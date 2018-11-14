$ErrorActionPreference =  'Stop' # no effect ?

# .\rogue.ps1 -name -map -seed
# -name is player name
# -map  could be world, test file -- directory or ps file
#   map.test(.ps1)
#   max(\game.ps1) Max\test().ps1)
#

$game = @{
    ui = $host.ui.RawUI
}

function Play-Game($name, $map, $seed){

    . core\ansi.ps1
    . core\host.ps1
    . core\core.ps1
    . core\command.ps1
#    . .\mapgen.ps1
    . core\map.ps1
    . core\game.ps1
    . core\entity.ps1
    . core\player.ps1
    . core\combat.ps1


    (Get-Host).ui.rawui.WindowTitle = "PS RogueLike"
    
    if (!$map) {
        $map = "Rogue_3_6_4"
    }
    if ($map) {
        if (Test-Path "$map.ps1") {
            . ".\$map.ps1"
        } elseif (Test-Path $map) { # folder?
            if (Test-Path "$map\game.ps1") {
                . "$map\game.ps1"           
            } else {
                Read-Host "No map found"
            }
        } else {
            Read-Host "No map found"
        }
    }
    if ($name) {
        $game.playerName = $name
    } else {
        $game.playerName = Read-Host "What is your name?"
    }


    if($seed) {$dump = Get-Random -SetSeed ($seed.GetHashCode())}

    Initialize-Console
    
    GameSetup
}

if ($args.Count -gt 0) {
    Play-Game @args
} else {
    if ($host.Name -eq "Visual Studio Code Host") {
        Play-Game "Tester" "map.test" "MapTestSeed"
    }
}

