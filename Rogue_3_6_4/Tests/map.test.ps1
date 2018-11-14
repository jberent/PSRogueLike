function Test {
    CreateMap $game
}


if ($game) {
    . Rogue_3_6_4\map.ps1

} else {
    . core\host.ps1
    . core\map.ps1
    . Rogue_3_6_4\map.ps1
    
    function GameAddEntity($entity) {}
}
function CreateMap {
    CreateLevel 1
}

if (!$game) {

    $game = @{
        ui = $host.ui.RawUI
        MapWindow = RectLTRB 0 0 81 45
    }
    
    Test
    Read-Host
}