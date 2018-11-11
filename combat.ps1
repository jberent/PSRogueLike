
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
            KillEntity $defender
        }

    }

}
function RollDice($dice) {
    if ($dice) {
        $parse = $dice.split("+")
        if ($parse.count -eq 2) {
            [int]$bonus = $parse[1] 
        }
        $parse2 = $parse[0].split("d")
        [int]$rolls = 1
        [int]$d = $parse2[0]
        
        $result = 0
        if ($parse2.count -eq 2) {
            [int]$rolls = $parse2[0]
            [int]$d = $parse2[1]
        } else { # no d, just an absolute value (?)
            $result = $d
            $rolls = 0
        }
        for($r=0; $r -lt $rolls; $r++) {
            $result += ((Get-Random $d) + 1)
        }
        return $result + $bonus
    }
}
function GetCombatHitPoints($entity) {
    if ($entity.IsAlive) {
        if (!$entity.HP) {
            $entity.HP = RollDice $entity.gen.HP
        }
        if (!$entity.HP) {
            $entity.HP = RollDice "$(GetCombatAttackLevel $entity)d8"
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

function d20 {(Get-Random 20) + 1 }
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
    $level = GetCombatAttackLevel $attacker
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

function GetCombatAttackLevel($attacker) {
    if ($attacker.Level) {
        $attacker.Level
    } else {
        1
    }

}

function GetCombatArmorClass($defender) {
    if ($defender.ArmorClass) {
        $defender.ArmorClass
    } else {
        10 # no armor
    }
}