. $PSScriptRoot\DungeonsOfDoom\mapgen.ps1

function CreateMap { CreateLevel 1}

function CreateLevel($level) {
    $size = GetWindowValue MapWindow Size
    $rows = $size.Height
    $cols = $size.Width
    
    $bg = $mapgen.BackgroundColor
    $void = CreateCell " " $bg $bg

    $map = @{
        rows = $rows
        cols = $cols
        grid = New-Object "object[,]" $rows,$cols
        mapGen = $mapgen
        BackgroundColor = $mapgen.BackgroundColor
        buffer = CreateBuffer $cols $rows $void
        floor = "."
        rooms = @()
    }
    $map | Add-Member ScriptMethod CreateItem { Param ([string]$name, [char]$char, $x, $y)
        $gen = $this.mapgen.items.$name
        if (!$char) {
            [char]$char = $gen.Char
        }
        $entity = @{
            gen = $gen
            Character = $char
            Foreground = $gen.Color
            Background = $this.BackgroundColor
            X = $x
            Y = $y
        }
        ExecuteEntityAction $entity "Created"
        return $entity
    }
    # $map | Add-Member ScriptMethod CreateCreature {Param([string]$name)
    #     $gen = $this.mapgen.Creatures.$name
    #     return @{
    #         gen = $gen
    #         Character = $gen.Char
    #         Foreground = $gen.Color
    #         Background = $this.BackgroundColor
    #     }   
    # }
    $game.map = $map
    doRooms
    doPassages
    $room1 = $game.map.rooms[0]
    $x = $room1.x
    $y = $room1.y
    if (!$game.rogue) {
        $entity = $map.CreateItem("Player")
        GameAddEntity $entity
    }
    $game.map.grid[($y+1),($x+1)] | Format-List
    PlaceEntityXY $entity ($x + 1) ($y+1)
    DrawEntity $entity
    # $entity | Format-List
    # $game.map.buffer[$y,$x] | Format-List
    # read-host 



}
function doRooms{ RoomsGridStrategy }

# layout rooms in a grid to remove concern of overlap
# Nine Rooms
# Rogue has 'Gone' and 'Dark' rooms
function RoomsGridStrategy{
    $rows = $game.map.rows
    $cols = $game.map.cols
    # use a 9 grid
    [int]$boxw = $cols / 3 
    [int]$boxh = $rows / 3
    $x =0; $y= 0
    for($i=0;$i -lt 9;$i++) {
        RoomGridStrategy @{x = $x; y = $y; w=$boxw; h=$boxh; i =$i}
        $x += $boxw; if ($x + $boxw -gt $cols) {$x=0;$y+=$boxh}
    } 
}

function RoomGridStrategy($box) {
    #read-host $box.x $box.y $box.w $box.h
    do {
        $w = (Get-Random ($box.w - 4)) + 4
        $h = (Get-Random ($box.h - 4)) + 4
        $room = @{
            w = $w
            h = $h
            x = $box.x + (Get-Random ($box.w - $w))
            y = $box.y + (Get-Random ($box.h - $h))

        }    
    } until ($room.y -ne 0)
    $room.box = $box
    addRoom $room
    addRoomWall "Passage" "$($box.i)" $room.x $room.y
}
function addRoom($room) {
    #read-host $room.x $room.y $room.w $room.h
    $map = $game.map
    $map.rooms += $room
    $mapgen = $map.mapGen
    $dec = $mapgen.dec
    $wall = "wall"
    $floor = "floor"
    addRoomWall $wall $dec.ul $room.x $room.y
    addRoomWall $wall $dec.ur ($room.x + $room.w - 1) $room.y
    addRoomWall $wall $dec.ll $room.x ($room.y + $room.h - 1)
    addRoomWall $wall $dec.lr ($room.x + $room.w - 1) ($room.y + $room.h - 1)
    for ($x=1;$x -lt ($room.w - 1); $x++) {
        addRoomWall $wall $dec.hw ($room.x + $x) $room.y
        addRoomWall $wall $dec.hw ($room.x + $x) ($room.y + $room.h - 1)
    }
    for ($y=1;$y -lt ($room.h - 1); $y++) {
        addRoomWall $wall $dec.vw ($room.x) ($room.y + $y)
        for ($x=1;$x -lt ($room.w - 1); $x++) {
            addRoomWall $floor "." ($room.x + $x) ($room.y + $y)
        }
        addRoomWall $wall $dec.vw ($room.x + $room.w - 1) ($room.y + $y)
    }
}
function addRoomWall($key, [char]$char, $x, $y) {
    $map = $game.map
    $entity = $map.CreateItem($key, $char, $x, $y)
    $map.grid[$y,$x] = $entity

    $map.buffer[$entity.y,$entity.x] = CreateCell $entity.Character $entity.Foreground $entity.Background

}

function doPassages {
    PassageSimpleStrategy
}
# 0 1 2
# 3 4 5
# 6 7 8
$passageConnections = @(
    @(1,3),
    @(2,4,0),
    @(5,1),
    @(6,4,0),
    @(3,5,7,1),
    @(4,2,8),
    @(7,3),
    @(8,6,4),
    @(5,7)
)
function PassageSimpleStrategy {
    $map = $game.map
    for($i=0;$i -lt 8;$i++) {
        $room = $map.rooms[$i]
        $to = $passageConnections[$i][0]
        connectRooms $room $map.rooms[$to] 
    }
}

function connectRooms($room1, $room2) {
    $isHor = $room1.box.y -eq $room2.box.y
    if ($isHor) {
        $door1 = $room1.y + (Get-Random ($room1.h-1) -Minimum 1)
        $door2 = $room2.y + (Get-Random ($room2.h-1) -Minimum 1)
        $rd = $room1.box.x -lt $room2.box.x # right or down
        if ($rd) {
            $corrM =$room2.box.x - 1 # 1 - 2
            #read-host = "drawPassageX ($($room1.x + $room1.w) $door1) -> ($($room2.x) $door2) $corrM"
            drawPassageX ($room1.x + $room1.w) $door1 $room2.x $door2 $corrM
        } else {
            $corrM =$room1.box.x - 1 # 2 - 1
            drawPassageX ($room2.x + $room2.w) $door2 $room1.x $door1 $corrM
        }
    } else {
        $door1 = $room1.x + (Get-Random ($room1.w-1) -Minimum 1)
        $door2 = $room2.x + (Get-Random ($room2.w-1) -Minimum 1)
        $rd = $room1.box.y -lt $room2.box.y
        if ($rd) {
            $corrM =$room2.box.y - 1
            drawPassageY $door1 ($room1.y + $room1.h) $door2 $room2.y $corrM
        } else {
            $corrM =$room1.box.y - 1
            drawPassageY $door2 ($room2.y + $room2.h) $door1 $room1.y $corrM
        }
    }
}

function drawPassageX($x1, $y1, $x2, $y2, $mx){
    addRoomWall "Door" "+" ($x1-1) $y1
    for($x=$x1; $x -le $mx; $x++) {
        addRoomWall "Passage" "#" $x $y1
    }
    if ($y1 -lt $y2 ) {$yL = $y1; $yT = $y2} else {$yL = $y2; $yT = $y1} 
    for($y=$yL; $y -lt $yT; $y++) {
        addRoomWall "Passage" "#" $mx $y
    }
    addRoomWall "Door" "+" ($x2) $y2
    for($x=$mx; $x -lt $x2; $x++) {
        addRoomWall "Passage" "#" $x $y2
    }

}
function drawPassageY($x1, $y1, $x2, $y2, $my){
    addRoomWall "Door" "+" $x1 ($y1 - 1)
    for($y=$y1; $y -le $my; $y++) {
        addRoomWall "Passage" "#" $x1 $y
    }
    if ($x1 -lt $x2 ) {$xL = $x1; $xT = $y2} else {$xL = $x2; $xT = $x1} 
    for($x=$xL; $x -lt $xT; $x++) {
        addRoomWall "Passage" "#" $x $my
    }
    addRoomWall "Door" "+" $x2 $y2
    for($y=$my; $y -lt $y2; $y++) {
        addRoomWall "Passage" "#" $x2 $y
    }

}
