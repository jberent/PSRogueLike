
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
function GetEntityValueOrGen($entity, $property) {
    if ($entity.$property) {$entity.$property} else {$entity.gen.$property}
}
function GetEntityValue($entity, $property, $default) {
    if ($entity.$property) {
        return $entity.$property
    } elseif ($entity.gen.$property) {
        $entity.$property = $entity.gen.$property
        return $entity.$property
    } elseif ($default) {
        $entity.$property = $default
        return $entity.$property
    }
}


function ExecuteEntityAction($target, $action) 
{
    if ($action) {
        & $action $target @args
        # Log action, update entity?
    }
    UpdateEntity $target
}

function ActivateEntity($target) {
    ExecuteEntityAction $target $target.gen.ActivateAction @args
}

function BumpEntity($target) {
    ExecuteEntityAction $target $target.gen.BumpAction @args
}


function KillEntity($target) {
    $target.IsAlive = $false
    $target.IsDead = $true
    $target.Foreground = "Red"
    ExecuteEntityAction $target $target.gen.KilledAction @args
    $target.Name = "$(EntityName $target) corpse"
}