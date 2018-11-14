
function MoveMonster($state, $monster) {
    $rogue = $game.rogue
    $dx = $rogue.x - $monster.x
    $dy = $rogue.y - $monster.y
    $dxa = $dx; $dxs = 1; if ($dxa -lt 0) {$dxa = -$dxa; $dxs = -1}
    $dya = $dy; $dys = 1; if ($dya -lt 0) {$dya = -$dya; $dys = -1}
    if (($dxa -eq 0 -and $dya -eq 1) -or ($dxa -eq 1 -and $dya -eq 0)) {
        if ($rogue.IsAlive) {
            AttackEntity $monster $rogue
        }
    } else {

        $toX = Point ($monster.x + $dxs) $monster.y
        $toY = Point $monster.x ($monster.y + $dys)
        $choice =@()
        if ($dxa -ne 0 -and (IsLocationTraversable $toX)) {
            $choice += $toX
        }
        if ($dya -ne 0 -and (IsLocationTraversable $toy)) {
            $choice += $toY
        }
        if ($choice.count -gt 0) {
            $to = $choice[(Get-Random $choice.count)]
            MoveEntity $monster $to
        }
    }
}

function AttackEntity($attacker, $defender) {
    CombatResults $attacker $defender
}

function EntityName($entity) {
    GetEntityValueOrGen $entity "Name"
}
function GetGenValue($entity, $property) {
    #if ($entity.Character -eq "@") {Read-Host "Property: $property"}
    if ($entity.gen.$property) {
        $entity.gen.$property
    } elseif ($entity.gen.base.$property) {
        $entity.gen.base.$property
        #read-host $entity.gen.base.$property
    }
}
function GetEntityValueOrGen($entity, $property) {
    if ($entity.$property) {
        $entity.$property
    } else {
        GetGenValue $entity $property
    }
}
function GetEntityValue($entity, $property, $default) {
    if ($entity.$property) {
        return $entity.$property
    } else {        
        $value = GetGenValue $entity $property
        if (!$value) {
            $value = $default
        }
        $entity.$property = $value
        return $entity.$property
    }
}
function GetEntityLevel($entity) {
    GetEntityValue $entity Level 1
}

function ExecuteEntityAction($target, $action) 
{
    $method = GetEntityValueOrGen $entity "$($action)Action"
    if ($method) {
        & $method $target @args
        # Log action, update entity?
    }
}

function ActivateEntity($target) {
    ExecuteEntityAction $target Activate @args
    UpdateEntity $target
}

function BumpEntity($target) {
    ExecuteEntityAction $target Bump @args
    UpdateEntity $target
}


function KillEntity($target) {
    $target.IsAlive = $false
    $target.IsDead = $true
    $target.Foreground = "Red"
    DrawEntity $target
    ExecuteEntityAction $target Killed @args
    $target.Name = "$(EntityName $target) corpse"
}
