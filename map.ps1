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

    $game.map = @{
        rows = $rows
        cols = $cols
        grid = $grid
        mapGen = $mapgen
        buffer = $buffer
        floor = "."
    }


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
function CreateMap($game) {
    $map = New-Object "object[,]" 40,80
    $game.map = $map
    $wall = @{
        Character = "#"
    }
    $floor = @{
        Character = "."
    }

    $rows = $map.GetLength(0)
    $cols = $map.GetLength(1)
    $rogue = @{
        Character = "@"
        X = $cols / 2
        Y = $rows / 2
    }
    for ($i = 0; $i -lt $rows; $i++) {
        for ($j = 0; $j -lt $cols; $j++) {
            if ($i -eq 0 -or $j -eq 0 -or $i -eq $rows - 1 -or $j -eq $cols - 1) {
                $map[$i,$j] = $wall
            } else {
                $map[$i,$j] = $floor
            }
        }
    }
    $map[$rogue.Y,$rogue.X] = $rogue
    $game.rogue = $rogue
    for ($i = 1; $i -lt $rows - 1; $i++) {
        $monster = @{
            Character = "K"
            X = (Get-Random ($cols-2)) + 1
            Y = $i
        }
        $map[$monster.Y,$monster.X] = $monster
        $game.monsters.add($monster) > $null
        
    }

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


