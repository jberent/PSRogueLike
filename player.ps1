function PlayerInit {
    $player = $game.rogue
    $player.Level = 1
    $player.XP = 0
    $player.HP = 12
    $player.MAXHP = 12
    $player.STR = 16 # hunger, rest
    $player.Gold = 0

}


function DrawPlayerStats {
    DrawPlayerHealthStats
    DrawPlayerEngagementStats
    DrawPlayerInventoryStats
}

function DrawPlayerHealthStats {
    $rogue = $game.rogue
    $status = "Level:1 x:{0,-4} y:{1,-4} `${2,-5} {3,3}({4,3}) {5,2}/{6,-5} " -f $rogue.x, $rogue.y, $rogue.Gold, $rogue.HP, $rogue.MAXHP, $rogue.Level, $rogue.XP
    Status $status # "x:$($rogue.x) y:$($rogue.y) `$$($rogue.Gold) $($rogue.HP)%"
}

function DrawPlayerEngagementStats {
    DrawOrbit
}

function DrawPlayerInventoryStats{}

function MovePlayer($state, [System.Management.Automation.Host.Coordinates]$to) {
    $entity = GetGridEntry $game.map $to
    if ($entity) {
        # write-host "Move torwards $($entity.gen.name) at $($to.x) $($to.y)"
        if (IsLocationTraversable $to) {
            # write-host "Move to $($to.x) $($to.y)"
            MoveEntity $game.rogue $to
        } elseif ($entity.gen.IsMonster -and $entity.IsAlive) {
            AttackEntity $game.rogue $entity
        } else {
            BumpEntity $entity $game.rogue
        }
    }
}
function PlayerActivate($state, [System.Management.Automation.Host.Coordinates]$to) {
    # Log "$($to.x),$($to.y)"
    $entity = GetGridEntry $game.map $to
    if ($entity) {
        # Log $entity.gen.name
        if ($entity.gen.IsMonster -and $entity.IsAlive) {
            AttackEntity $game.rogue $entity
        } else {
            ActivateEntity $entity $game.rogue
        }
    }
}

function GetRogueOrbit {
    $rogue = $game.rogue
    $map = $game.map
    @{
        W = GetMapEntry $map $rogue.x ($rogue.y-1)
        S = GetMapEntry $map $rogue.x ($rogue.y+1)
        A = GetMapEntry $map ($rogue.x-1) $rogue.y
        D = GetMapEntry $map ($rogue.x+1) $rogue.y
    }
}

function DrawOrbitEntry($buffer, $orbit, $key, $row) {
    $entity = $orbit.$key
    if ($entity) {
        UpdateCell $buffer 0 $row $key Black White
        $width = $buffer.GetLength(1) - 2
        [string]$desc = (EntityName $entity)
        if ($desc.Length -gt $width) {
            $desc = $desc.substring(0,$width)
        }
        if ($entity.IsAlive) {
            $desc = $desc.padright($width)
            $hp = GetCombatHitPoints $entity
            [int]$bar = ($width * $hp)/($entity.MAXHP)
            if ($bar -gt 0) {
                UpdateCells $buffer 2 $row ($desc.substring(0,$bar)) $entity.Foreground DarkGray
                UpdateCells $buffer (2+$bar) $row ($desc.substring($bar)) $entity.Foreground Black

            } else {
                UpdateCells $buffer 2 $row $desc black red
            }
        } else {
            UpdateCells $buffer 2 $row $desc $entity.Foreground $entity.Background
        }
    }
}
function DrawOrbit {
    $orbit = GetRogueOrbit
    $window = GetWindow "InventoryWindow"
    $width = $window.Size.Width
    $buffer = CreateBuffer $width 4 $window.Fill
    DrawOrbitEntry $buffer $orbit "W" 0
    DrawOrbitEntry $buffer $orbit "S" 1
    DrawOrbitEntry $buffer $orbit "A" 2
    DrawOrbitEntry $buffer $orbit "D" 3
    UpdateWindow "InventoryWindow" $buffer
}

