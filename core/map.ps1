
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


