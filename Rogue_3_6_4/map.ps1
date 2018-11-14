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
function doRooms{
    $rows = $game.map.rows
    $cols = $game.map.cols
    # use a 9 grid
    [int]$boxw = $cols / 3 
    [int]$boxh = $rows / 3
    $x =0; $y= 0
    for($i=0;$i -lt 9;$i++) {
        doRoom @{x = $x; y = $y; w=$boxw; h=$boxh}
        $x += $boxw; if ($x + $boxw -gt $cols) {$x=0;$y+=$boxh}
    } 
}

function doRoom($box) {
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
    addRoom $room
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

}
