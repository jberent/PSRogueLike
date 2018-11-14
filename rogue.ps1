$ErrorActionPreference =  'Stop' # no effect ?

# .\rogue.ps1 -name -map -seed
# -name is player name
# -map  could be world, test file -- directory or ps file
#   map.test(.ps1)
#   max(\game.ps1) 
#

$game = @{
    ui = $host.ui.RawUI
}

function Play-Game($name, $map, $seed){

    . .\ansi.ps1
    . .\host.ps1
    . .\core.ps1
    . .\command.ps1
    . .\mapgen.ps1
    . .\map.ps1
    . .\game.ps1
    . .\entity.ps1
    . .\player.ps1
    . .\combat.ps1


    (Get-Host).ui.rawui.WindowTitle = "PS RogueLike"
    
    if ($map) {
        if (Test-Path "$map.ps1") {
            . ".\$map.ps1"
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

