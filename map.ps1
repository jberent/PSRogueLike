# .#. .#. .#. ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... 
# .## .## .## .#. .#. .#. .#. .#. .#. .#. .#. .#. .#. .#. .#. .#. .#. .#. .#. .#. .#. .#. .#. .#. .#. 
# ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... 
#
# .#. ##. ##. ##. .## .## .## ...   ... *.* *.* ### *.* ... ... ... ... ... ... ... ... ... ... ... ... 
# .#. .#. .#. .#. .#. .#. .#. .#.   ### ### ##. ##. .## .#. .#. .#. .#. .#. .#. .#. .#. .#. .#. .#. .#. 
# .#. .#. .## ##. .## ##  .#. ...   ... *.* *#* *#* *#* ... ... ... ... ... ... ... ... ... ... ... ... 

$wallhash = @{
    "    ## # " = "l"
    "    ## ##" = "l"
    "    #####" = "l"
    "    #### " = "l"
    "#   ## # " = "l"
    "#   ## ##" = "l"
    "#   #####" = "l"
    "#   #### " = "l"
    "# # ## # " = "l"
    "# # ## ##" = "l"
    "# # #####" = "l"
    "# # #### " = "l"
    "  # ## # " = "l"
    "  # ## ##" = "l"
    "  # #####" = "l"
    "  # #### " = "l"

    "   ##  # " = "k"
    "   ##  ##" = "k"
    "   ## ###" = "k"
    "   ## ## " = "k"
    "#  ##  # " = "k"
    "#  ##  ##" = "k"
    "#  ## ###" = "k"
    "#  ## ## " = "k"
    "# ###  # " = "k"
    "# ###  ##" = "k"
    "# ### ###" = "k"
    "# ### ## " = "k"
    "  ###  # " = "k"
    "  ###  ##" = "k"
    "  ### ###" = "k"
    "  ### ## " = "k"

    "   ###   " = "q"
    "   ###  #" = "q"
    "   #### #" = "q"
    "   ####  " = "q"

    "#  ###   " = "q"
    "#  ###  #" = "q"
    "#  #### #" = "q"
    "#  ####  " = "q"
    
    "# ####   " = "q"
    "# #####  " = "q"
    "# ##### #" = "q"
    "# ####  #" = "q"

    "  ####   " = "q"
    "  #####  " = "q"
    "  ##### #" = "q"
    "  ####  #" = "q"

    " #  ##   " = "m"
    " #  ###  " = "m"
    " #  ### #" = "m"
    " #  ##  #" = "m"
    " ## ##   " = "m"
    " ## ###  " = "m"
    " ## ### #" = "m"
    " ## ##  #" = "m"
    "##  ##   " = "m"
    "##  ###  " = "m"
    "##  ### #" = "m"
    "##  ##  #" = "m"

    " # ##    " = "j"
    " # ## #  " = "j"
    " # ## # #" = "j"
    " # ##   #" = "j"
    " ####    " = "j"
    " #### #  " = "j"
    " #### # #" = "j"
    " ####   #" = "j"
    "## ##    " = "j"
    "## ## #  " = "j"
    "## ## # #" = "j"
    "## ##   #" = "j"

    " #  #  # " = "x"
    " #  #  ##" = "x"
    " #  # ## " = "x"
    " #  # ###" = "x"
    "##  #  # " = "x"
    "##  #  ##" = "x"
    "##  # ## " = "x"
    "##  # ###" = "x"
    " ## #  # " = "x"
    " ## #  ##" = "x"
    " ## # ## " = "x"
    " ## # ###" = "x"
    "### #  # " = "x"
    "### #  ##" = "x"
    "### # ## " = "x"
    "### # ###" = "x"

    " # ### # " = "n"

    " #  ## # " = "t"
    " #  #### " = "t"

    " # ##  # " = "u"

    "   ### # " = "w"

    " # ###   " = "v"
}

function makeLines([string[]]$lines, $wallChar) {
    $walls = "+-&$wallChar"
    $cols = $lines[0].length
    $length = $cols + 2
    $rows = $lines.Count
    $l1 = " "*$length
    for ($i = 0; $i -lt $rows; $i++) {
        $l0 = $l1
        $l1 = " $($lines[$i]) "
        $chars = $lines[$i].ToCharArray()
        if ($i + 1 -lt $rows) {
            $l2 = " $($lines[$i + 1]) "
        } else {
            $l2 = " "*$length
        }
        for ($j = 0; $j -lt $cols; $j++) {
            if ($chars[$j] -eq $wallChar) {
                $wall = [string]::new( ("$($l0.Substring($j,3))$($l1.Substring($j,3))$($l2.Substring($j,3))".tochararray() | % { if($walls.Contains($_)){"#"}else{" "}}) )
                $d = $wallhash[$wall]
                if ($d) {
                    $chars[$j] = $d
                }
                if ($l1[$j+1] -eq $wallChar) {
                    if (!$d) {
                        
                        write-host $l0
                        write-host $l1
                        write-host $l2
                        write-host "'$wall'"
                        Read-Host ">"
                    }
                }
            }
        }
        $lines[$i] = [System.String]::new($chars)
    }
}

function CreateMapFromLevel($levelgen) {
    $lines = $levelgen.level.split([Environment]::NewLine, [StringSplitOptions]::RemoveEmptyEntries)
    if ($levelgen.DrawLines) {
        makeLines $lines $levelgen.DrawLines
    }
    $cols = $lines[0].length
    $rows = $lines.Count
    $grid = New-Object "object[,]" $rows,$cols
    $mapgen = $levelgen.mapgen
    $colors = $mapgen.litColors
    $bg = $colors[" "]
    $void = CreateCell " " $bg $bg
    $buffer = CreateBuffer $cols $rows $void

    $map = @{
        rows = $rows
        cols = $cols
        grid = $grid
        mapGen = $mapgen
        buffer = $buffer
        floor = "."
    }
    $game.map = $map


    for ($i = 0; $i -lt $rows; $i++) {
        $line = $lines[$i]
        for ($j = 0; $j -lt $cols; $j++) {
            $entity = CreateEntity $levelgen $line[$j]
            PlaceEntityXY $entity $j $i
            if ($key -ne " ") {
                UpdateBufferCell $buffer $entity
            }
        }
    }

}

function CreateEntity($levelgen, [string]$key) {
    $mapgen = $levelgen.mapgen
    
    if ($key -ceq $key.ToLower()) {
        if ($levelgen.dec -or $levelgen.DrawLines) {
            $dec = $mapgen.DEC
            $code = $dec.$key
            if ($code) {
                $glyph = [char]$code
                $key = $levelgen.DrawLines # wall
            }
        }
    }
    $gen = $mapgen.$key
    $entity = CreateEntityChar $mapgen $key $glyph
    if ($gen.IsMonster) {
        $entity.IsAlive = $true
        $entity.HP = $gen.hp
        GameAddEntity $entity
    }
    return $entity
}

function PlaceEntityXY($entity, $x, $y) {
    if (!$entity.floor) {
        $entity.floor = $game.map.grid[$y,$x]
    }
    if (!$entity.floor) {
        $entity.floor = CreateEntityChar $game.map.mapgen $game.map.floor
        $entity.floor.x = $x
        $entity.floor.y = $y
    }

    $entity.x = $x
    $entity.y = $y
    
    $game.map.grid[$y,$x] = $entity
}

function CreateEntityChar($mapgen,$key, $char) {
    if (!$char) { $char = $key}
    $colors = $mapgen.litColors
    $fg =  $colors[$key]
    if (!$fg) {
        $fg = "Magenta"
    }
    $bg = $colors[" "]
    return @{
        gen = $mapgen[$key]
        Character = $char
        Foreground = $fg
        Background = $bg
    }

}

function UpdateBufferCell($buffer, $info) {
    $fg = $info.Foreground
    $buffer[$info.y,$info.x] = CreateCell $info.Character $fg $info.Background
}
function CreateMap { CreateLevel 1}
function CreateLevel($level) {
    $size = GetWindowValue MapWindow Size
    $rows = $size.Height
    $cols = $size.Width
    
    $colors = $mapgen.litColors
    $bg = $colors[" "]
    $void = CreateCell " " $bg $bg

    $game.map = @{
        rows = $rows
        cols = $cols
        grid = New-Object "object[,]" $rows,$cols
        mapGen = $mapgen
        buffer = CreateBuffer $cols $rows $void
        floor = "."
        rooms = @()
    }
    doRooms
    doPassages
    $room1 = $game.map.rooms[0]
    $x = $room1.x
    $y = $room1.y
    $entity = CreateEntityChar $mapgen "@" "@"
    $entity.IsAlive = $true
    $entity.HP = $gen.hp
    GameAddEntity $entity
    PlaceEntityXY $entity ($x + 1) ($y+1)
    DrawEntity $entity
    # $entity | Format-List
    # $game.map.grid[$y,$x] | Format-List
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
    $wall = $mapgen.wall
    $floor = $mapgen.floor
    addRoomWall $wall $dec.l $room.x $room.y
    addRoomWall $wall $dec.k ($room.x + $room.w - 1) $room.y
    addRoomWall $wall $dec.m $room.x ($room.y + $room.h - 1)
    addRoomWall $wall $dec.j ($room.x + $room.w - 1) ($room.y + $room.h - 1)
    for ($x=1;$x -lt ($room.w - 1); $x++) {
        addRoomWall $wall $dec.q ($room.x + $x) $room.y
        addRoomWall $wall $dec.q ($room.x + $x) ($room.y + $room.h - 1)
    }
    for ($y=1;$y -lt ($room.h - 1); $y++) {
        addRoomWall $wall $dec.x ($room.x) ($room.y + $y)
        for ($x=1;$x -lt ($room.w - 1); $x++) {
            addRoomWall $floor $floor ($room.x + $x) ($room.y + $y)
        }
        addRoomWall $wall $dec.x ($room.x + $room.w - 1) ($room.y + $y)
    }
}
function addRoomWall($key, [char]$char, $x, $y) {
    $map = $game.map
    $mapgen = $map.mapGen
    #$entity = CreateEntityChar $mapgen $key $char
    $colors = $mapgen.litColors

    $entity = @{
        gen = $mapgen[$key]
        Character = $char
        Foreground = $colors[$key]
        Background = $colors[" "]
        x = $x
        y = $y
    }
    
    $map.grid[$y,$x] = $entity

    $map.buffer[$entity.y,$entity.x] = CreateCell $entity.Character $entity.Foreground $entity.Background

}

function doPassages {

}

function IsLocationTraversable([System.Management.Automation.Host.Coordinates]$to) {
    $entity = GetGridEntry $game.map $to
    if ($entity) {
        !(($entity.gen.IsMonster -and $entity.IsAlive) -or $entity.gen.IsWall)
    }
}

function MoveEntity($entity, [System.Management.Automation.Host.Coordinates]$to) {
    # remove
    if (!$entity.floor) {
        $entity.floor = CreateEntityChar $game.floor
        $entity.floor.x = $entity.x
        $entity.floor.y = $entity.y
    }
    UpdateEntity $entity.floor # could be door or other entity that can be walked over
    
    # replace
    $entity.floor = $game.map.grid[$to.y,$to.x]
    $entity.X = $to.X
    $entity.Y = $to.Y
    UpdateEntity $entity
}
function RemoveEntity($entity) {
    UpdateEntity $entity.floor # could be door or other entity that can be walked over
}
function UpdateEntity($entity) {
    if ($entity.IsDeleted) {
        RemoveEntity $entity
    } else {
        $game.map.grid[$entity.Y,$entity.X] = $entity
        DrawEntity $entity
    }
}


function DrawEntity($entity) { # TODO: dirty rectangle
    UpdateBufferCell $game.map.buffer $entity
}

function DrawMap {
    UpdateWindow "MapWindow" $game.map.buffer
}

function GetGridEntry($map, [System.Management.Automation.Host.Coordinates]$to) {
    $rows = $map.rows
    $cols = $map.cols
    if ($to.X -ge 0 -and $to.X -lt $cols) {
    if ($to.Y -ge 0 -and $to.Y -lt $rows) {
        $map.grid[$to.Y,$to.X]
    }}   
}

function GetMapEntry($map, $x, $y) {
    GetGridEntry $map (Point $x $y)
}


