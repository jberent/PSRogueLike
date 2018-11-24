function PlayerInit {
    $player = $game.player
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
    $rogue = $game.player
    $status = "Level:1 x:{0,-4} y:{1,-4} `${2,-5} {3,3}({4,3}) AC:{7,-2} {5,2}/{6,-5} " -f $rogue.x, $rogue.y, $rogue.Gold, $rogue.HP, $rogue.MAXHP, $rogue.Level, $rogue.XP, $rogue.ArmorClass
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
            MoveEntity $game.player $to
        } elseif ((GetEntityValue $entity IsMonster) -and $entity.IsAlive) {
            AttackEntity $game.player $entity
        } else {
            BumpEntity $entity $game.player
        }
    }
}
function PlayerActivate($state, [System.Management.Automation.Host.Coordinates]$to) {
    # Log "$($to.x),$($to.y)"
    $entity = GetGridEntry $game.map $to
    if ($entity) {
        # Log $entity.gen.name
        if ((GetEntityValue $entity IsMonster) -and $entity.IsAlive) {
            AttackEntity $game.player $entity
        } else {
            ActivateEntity $entity $game.player
        }
    }
}

function GetRogueOrbit {
    $rogue = $game.player
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
            # Read-host "$width $hp $($entity.MAXHP)"
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

function ShowTombstone([string]$playerName, [string]$attackerName) {
    DrawGame
    if (!$playerName) {$playerName = "Rogue"}
    if (!$attackerName) {$attackerName = "Misadventure"}
    # 6,6 center 19
    $lines = $rip.split([Environment]::NewLine, [StringSplitOptions]::RemoveEmptyEntries)
    $cols = $lines[0].length
    $rows = $lines.Count
    [int]$left = 19 - ($playerName.Length / 2)
    $line = $lines[6]
    $lines[6] = $line.substring(0,$left) + $playerName + $line.substring($left+$playerName.Length, $cols - ($left+$playerName.Length))
    [int]$left = 19 - ($attackerName.Length / 2)
    $line = $lines[9]
    $lines[9] = $line.substring(0,$left) + $attackerName + $line.substring($left+$attackerName.Length, $cols - ($left+$attackerName.Length))
    $buffer = $Host.ui.rawui.NewBufferCellArray($lines, "White", "Black")
    $win = GetWindow "MapWindow"
    $rect = RectFromWindow $win
    $y = (($rect.bottom - $rect.Top)-$rows)
    $dest = PointFromWindow $window $x $y
    [char]$mask = "."
    # [char]$sp = " "
    $backRect = RectLTRB $dest.x $dest.y ($dest.x+$cols-1) ($dest.y+$rows-1)
    $background = GetBufferContents $backRect
    for ($i = 0; $i -lt $rows; $i++) {
        for ($j = 0; $j -lt $cols; $j++) {
            if ($buffer[$i,$j].Character -eq $mask) {
                $buffer[$i,$j] = $background[$i,$j]
            # } elseif ($buffer[$i,$j].Character -eq $sp) {
            #     $buffer[$i,$j].ForegroundColor = "Black"
            #     $buffer[$i,$j].BackgroundColor = "White"
            }
        }
    }

    UpdateWindow "MapWindow" $buffer $dest.x $dest.y
    $host.ui.RawUI.FlushInputBuffer()
    for([System.Management.Automation.Host.PSHostRawUserInterface]$ui = $Host.UI.RawUI;;) {
        $Key = $ui.ReadKey(6)
        switch($RLKey[$Key.VirtualKeyCode]) {
            Y   {$game.Quit = $true; $game.Restart = $true; return}
            Esc {$game.Quit = $true; return}
        }
    }
    
}
function unsetMask($buffer, $rect, [char]$mask) {
    $background = GetBufferContents $rect
    for ($i = 0; $i -lt $rows; $i++) {
        for ($j = 0; $j -lt $cols; $j++) {
            if ($buffer[$i,$j].Character -eq $mask) {
                $buffer[$i,$j] = $background[$i,$j]
            }
        }
    }

}

