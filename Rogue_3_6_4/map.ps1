. $PSScriptRoot\DungeonsOfDoom\mapgen.ps1

function CreateMap { CreateLevel 1}

function CreateLevel($level) {
    $size = GetWindowValue MapWindow Size
    $rows = $size.Height
    $cols = $size.Width
    
    $bg = $mapgen.BackgroundColor
    $void = CreateCell " " $bg $bg

    $map = @{
        level = $level
        rows = $rows
        cols = $cols
        grid = New-Object "object[,]" $rows,$cols
        mapGen = $mapgen
        BackgroundColor = $mapgen.BackgroundColor
        buffer = CreateBuffer $cols $rows $void
        floor = "."
        rooms = @()
    }
    $map | Add-Member ScriptMethod CreateItem { Param ([string]$name, $char, $x, $y)
        $gen = $this.mapgen.items.$name
        if (!$char) {
            [char]$char = GetGenBaseValue $gen Char
        }
        $entity = @{
            gen = $gen
            Character = [char]$char
            Foreground = GetGenBaseValue $gen Color
            Background = $this.BackgroundColor
            X = $x
            Y = $y
        }
        ExecuteEntityAction $entity "Created"
        return $entity
    }
    $map | Add-Member ScriptMethod PlaceEntity { Param ($point, $entity) 
        # $entity | Format-List | Out-Host
        # read-host "Gold? $($point.x) $($point.y) $($this.grid[$point.y,$point.x].Character)"
        PlaceEntityXY $entity $point.x $point.y
        if ($game.showDev -gt 2) {
            DrawEntity $entity
        }
    }
    $map | Add-Member ScriptMethod AddGold { Param ($point, $gold) 
        $entity = $this.CreateItem("Gold")
        $entity.gold = $gold
        $this.PlaceEntity($point, $entity)
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
    doRooms $map
    doPassages $map
    $room1 = $map.rooms[0]
    $x = $room1.x
    $y = $room1.y
    if (!$game.player) {
        $entity = $map.CreateItem("Player")
        GameAddEntity $entity
    }
    #$game.map.grid[($y+1),($x+1)] | Format-List
    PlaceEntityXY $entity ($x + 1) ($y+1)
    DrawEntity $entity
    
    #TODO: LightPlayer
    
    # $entity | Format-List
    # $game.map.buffer[$y,$x] | Format-List
    # read-host 



}
function doRooms($map){ RoomsGridStrategy $map }

# layout rooms in a grid to remove concern of overlap
# Nine Rooms
# Rogue has 'Gone' and 'Dark' rooms
function RoomsGridStrategy($map){
    $rows = $map.rows
    $cols = $map.cols
    # use a 9 grid
    [int]$boxw = $cols / 3 
    [int]$boxh = $rows / 3
    $x =0; $y= 0
    $dirCount = 0
    $dirx = 1
    for($i=0;$i -lt 9;$i++) {
        RoomGridStrategy $map @{x = $x; y = $y; w=$boxw; h=$boxh; i =$i}
        $dirCount++;
        if ($dirCount -eq 3) { # ox turn
            $dirx=-$dirx
            $y+=$boxh
            $dirCount = 0
        } else {
            $x += ($dirx * $boxw); 
        }
    } 
}

function RoomGridStrategy($map, $box) {
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
    $room.map = $map
    $room.gen = $map.mapgen.Items.Room

    $room | Add-Member ScriptMethod addRoomWall {Param($key, [char]$char, $x, $y) 
        $map = $this.map
        $entity = $map.CreateItem($key, $char, $x, $y)
        $entity.room = $this
        $map.grid[$y,$x] = $entity
    
        if ($game.showDev -gt 2){
            $map.buffer[$entity.y,$entity.x] = CreateCell $entity.Character $entity.Foreground $entity.Background
        }
    
    }
    $room | Add-Member ScriptMethod Light { 
        if (!$this.lit){
            $this.OuterContent | %{ DrawEntity $_ }
            $this.lit = $true
        } 
    }
    $room | Add-Member ScriptProperty OuterContent {
        for ($y = $this.y; $y -lt $this.y + $this.h; $y++)  {
         for ($x = $this.x; $x -lt $this.x + $this.w; $x++)  {
            $this.map.grid[$y,$x]
         }
        }     
    }
    $room | Add-Member ScriptProperty Content {
        for ($y = $this.y + 1 ; $y -lt $this.y + $this.h - 1; $y++)  {
         for ($x = $this.x + 1 ; $x -lt $this.x + $this.w - 1; $x++)  {
            $this.map.grid[$y,$x]
         }
        }     
    }
    $room | Add-Member ScriptProperty EmptyPosition { $this.Content | ? {$_.gen.IsEmpty} | Get-Random | % { Point $_.x $_.y } }
    $room | Add-Member ScriptProperty RandomPosition { Point ($this.x + 1 + (Get-Random ($this.w-2))) ($this.y + 1 + (Get-Random ($this.h-2)))}
    $room | Add-Member ScriptMethod AddGold {Param($gold) $this.HasGold = $gold; $point = $this.EmptyPosition; $this.map.AddGold($point, $gold) }
    $room | Add-Member ScriptMethod IfGold {
        $hasGold =  & $this.gen.ChanceGold
        if ($hasGold){
            $gold = & $this.gen.AmountGold ($this.map.level)
            $this.AddGold($gold )
        }
    }
    $room | Add-Member ScriptMethod IfMonster {
        $hasMonster =  & $this.gen.ChanceMonster $this
        if ($hasMonster){
            $ch = & $monster.randmonster ($this.map.level) 
            $monster = $this.map.CreateItem($ch)
            $point = $this.EmptyPosition
            $this.map.PlaceEntity($point, $monster)
            #addRoomWall "Monster" $ch $point.x $point.y
        }
    }
    addRoom $room
    $room.IfGold()
    $room.IfMonster()
    if ($game.showDev) { # show room number
        addRoomWall "Passage" "$($box.i)" $room.x $room.y
    }
}
function addRoom($room) {
    #read-host $room.x $room.y $room.w $room.h
    $map = $room.map
    $map.rooms += $room
    $mapgen = $map.mapGen
    $WALLS = $room.gen.WALLS
    $wall = "wall"
    $floor = "floor"
    $room.addRoomWall( $wall, $WALLS.ul, $room.x, $room.y)
    $room.addRoomWall( $wall, $WALLS.ur, ($room.x + $room.w - 1), $room.y)
    $room.addRoomWall( $wall, $WALLS.ll, $room.x, ($room.y + $room.h - 1))
    $room.addRoomWall( $wall, $WALLS.lr, ($room.x + $room.w - 1), ($room.y + $room.h - 1))
    for ($x=1;$x -lt ($room.w - 1); $x++) {
        $room.addRoomWall( $wall, $WALLS.hw, ($room.x + $x), $room.y)
        $room.addRoomWall( $wall, $WALLS.hw, ($room.x + $x), ($room.y + $room.h - 1))
    }
    for ($y=1;$y -lt ($room.h - 1); $y++) {
        $room.addRoomWall( $wall, $WALLS.vw, ($room.x), ($room.y + $y))
        for ($x=1;$x -lt ($room.w - 1); $x++) {
            $room.addRoomWall( $floor, ".", ($room.x + $x), ($room.y + $y))
        }
        $room.addRoomWall( $wall, $WALLS.vw, ($room.x + $room.w - 1), ($room.y + $y))
    }
}
function addRoomWall($key, [char]$char, $x, $y) {
    $map = $game.map
    $entity = $map.CreateItem($key, $char, $x, $y)
    $map.grid[$y,$x] = $entity

    if ($game.showDev -gt 2){
        $map.buffer[$entity.y,$entity.x] = CreateCell $entity.Character $entity.Foreground $entity.Background
    }

}
function addPassageTile($key, [char]$char, $x, $y, $dir) {
    $map = $game.map
    $entity = $map.CreateItem($key, $char, $x, $y)
    $entity.dir = $dir
    $map.grid[$y,$x] = $entity

    if ($game.showDev -gt 2){
        $map.buffer[$entity.y,$entity.x] = CreateCell $entity.Character $entity.Foreground $entity.Background
    }

}

function doPassages {
    PassageSimpleStrategy
}
# 0 1 2
# 5 4 3
# 6 7 8
$passageConnections = @(
    @(1,5),
    @(2,4,0),
    @(3,1),
    @(4,2,8),
    @(5,3,7,1),
    @(6,4,0),
    @(7,5),
    @(8,6,4),
    @(3,7)
)
function PassageSimpleStrategy {
    $map = $game.map
    for($i=0;$i -lt 8;$i++) {
        #$room = 
        #$to = $passageConnections[$i][0]
        connectRooms $map.rooms[$i] $map.rooms[$i+1] 
    }
}
function PassageRandomStrategy {
    $map = $game.map
    $edges = @{}
    $nodes = (0..8) | % {
        $id = $_
        $conns = $passageConnections[$_]
        @{
            id = $id
            conns = $conns
            isConnected = $true
        }  
        $conns | % {$to = $_; $key = "$id$to"; $edges.$key = @{a = $id; b=$to}}
    }
    $root = $nodes[0]
    (0..8) |  % { }
    $leafs = ,$nodes[8]

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
        addPassageTile "Passage" "#" $x $y1 "X"
    }
    if ($y1 -lt $y2 ) {$yL = $y1; $yT = $y2} else {$yL = $y2; $yT = $y1} 
    for($y=$yL; $y -lt $yT; $y++) {
        addPassageTile "Passage" "#" $mx $y "Y"
    }
    addRoomWall "Door" "+" ($x2) $y2
    for($x=$mx; $x -lt $x2; $x++) {
        addPassageTile "Passage" "#" $x $y2 "X"
    }

}
function drawPassageY($x1, $y1, $x2, $y2, $my){
    addRoomWall "Door" "+" $x1 ($y1 - 1)
    for($y=$y1; $y -le $my; $y++) {
        addPassageTile "Passage" "#" $x1 $y "Y"
    }
    
    if ($x1 -lt $x2 ) {$xL = $x1; $xT = $x2} else {$xL = $x2; $xT = $x1} 
    for($x=$xL; $x -lt $xT; $x++) {
        addPassageTile "Passage" "#" $x $my "X"
    }
    addRoomWall "Door" "+" $x2 $y2
    for($y=$my; $y -lt $y2; $y++) {
        addPassageTile "Passage" "#" $x2 $y "Y"
    }

}

function UpdateLights {
    $floor = $game.player.floor
    if ($floor) {
        if ($floor.room) {
            if (!$floor.room.lit) {
                $floor.room.light()
            }
        } else {
            $orbit = GetRogueOrbit
            UpdatePassageLights $orbit.w
            UpdatePassageLights $orbit.s
            UpdatePassageLights $orbit.a
            UpdatePassageLights $orbit.d
        }
    }
}
function UpdatePassageLights($floor) {
    if ($floor.floor) {
        $floor = $floor.floor
    }
    if ($floor) {
        if (!$floor.lit) {
            DrawTile $floor.x $floor.y
            $floor.lit = $true
        }
    }

}
