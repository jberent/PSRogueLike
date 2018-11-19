function Test {
    CreateMap $game
}


if ($game) {
    . Rogue_3_6_4\map.ps1
    $game.showDev = 3

} else {
    . core\host.ps1
    . core\map.ps1
    . Rogue_3_6_4\map.ps1
    
    function GameAddEntity($entity) {}
}
function CreateMap {
    # $game.mapWindow | Format-List | Out-Host
    # read-host $game.viewport
    CreateLevel 1
}

if (!$game) {

    $game = @{
        ui = $host.ui.RawUI
        MapWindow = RectLTRB 0 0 81 45
        showDev = 3
    }
    
    Test
    Read-Host
}