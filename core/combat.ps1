
function AttackName($entity) {
    if ($entity.gen.Name -eq "rogue") {
        "You"
    } else {
        EntityName $entity
    }
}

function CombatResults($attacker, $defender) {
    [int]$tohit = GetCombatToHit $attacker $defender
    $hit = GetCombatHit $attacker
    $hit+= (GetCombatToHitBonus $attacker $defender)
    
    if ($hit -lt $tohit) {
        CombatLog "$(AttackName $attacker) attacked $(AttackName $defender), and missed [$tohit,$hit]" "MISS" $attacker $defender 
    } else {
        $damage = GetCombatDamage $attacker $defender
        $damage+= (GetCombatDamageBonus $attacker $defender)
        $hp = GetCombatHitPoints $defender
        $result = $hp - $damage
        if ($result -gt 0) {
            $defender.HP = $result
            CombatLog "$(AttackName $attacker) attacked $(AttackName $defender), and hit for $($damage) damage [$tohit,$hit,$hp,$damage]" "HIT" $attacker $defender
        } else {
            $defender.HP = 0
            $xp = GetEntityValueOrGen $defender XP
            if ($xp) {
                if (!$attacker.XP) {
                    $attacker.XP = [int]$xp
                } else {
                    $attacker.XP += [int]$xp
                }
            }
            CombatLog "$(AttackName $attacker) killed $(AttackName $defender) [$tohit,$hit,$hp,$damage]" "KILL" $attacker $defender
            KillEntity $defender $attacker
        }

    }

}
function GetCombatHitPoints($entity) {
    if ($entity.IsAlive) {
        if (!$entity.HP) {
            $entity.HP = RollDice $entity.gen.HP
        }
        if (!$entity.HP) {
            $entity.HP = RollDice "$(GetEntityLevel $entity)d8"
        }
    }
    if (!$entity.MAXHP) {
        $entity.MAXHP = $entity.HP
    }
    return $entity.HP
}
function GetCombatDamageDice($entity) {
    GetEntityValue $entity DamageDice
}

function GetCombatHit($attacker) {
    d20
}

function GetCombatToHitBonus($attacker, $defender) {
    0
}
function GetCombatDamage($attacker, $defender) {
    $dice = GetCombatDamageDice $attacker
    if ($dice) {
        RollDice $dice
    } else {
        (Get-Random 4) + 1
    }
}
function GetCombatDamageBonus($attacker, $defender) {
    0
}

function GetCombatToHit($attacker, $defender) {
    $matrix = GetCombatAttackMatrix $attacker
    $ac = GetCombatArmorClass $defender
    return $matrix[[string]$ac]
    
}

function GetCombatAttackMatrix($attacker) {
    $level = GetEntityLevel $attacker
    # TODO: choose matrix by level
    @{
        "-10" = 25
        "-9" = 24
        "-8" = 23
        "-7" = 22
        "-6" = 21
        "-5" = 20
        "-4" = 20
        "-3" = 20
        "-2" = 20
        "-1" = 20
        "0" = 20
        "1" = 19
        "2" = 18
        "3" = 17
        "4" = 16
        "5" = 15
        "6" = 14
        "7" = 13
        "8" = 12
        "9" = 11
        "10" = 10
    }
}

function GetCombatArmorClass($defender) {
    GetEntityValue $defender ArmorClass 10
}