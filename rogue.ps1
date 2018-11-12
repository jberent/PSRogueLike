$ErrorActionPreference =  'Stop'

$game = @{
    ui = $host.ui.RawUI
}


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

if ($host.Name -eq "Visual Studio Code Host") {
    . .\map.test.ps1
} else {

    (Get-Host).ui.rawui.WindowTitle = "PS RogueLike"
    
    if ($args.Count -gt 1) {
        if (Test-Path "$($args[1]).ps1") {
            . ".\$($args[1]).ps1"
        }
    }
    if ($args.Count -gt 0) {
        $game.playerName = $args[0]
    } else {
        $game.playerName = Read-Host "What is your name?"
    }
}

Initialize-Console

GameSetup

