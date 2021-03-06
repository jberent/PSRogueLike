$RLKey = @{
    27 = "Esc"
    32 = "Space"
    37 = "Left"
    39 = "Right"
    38 = "Up"
    40 = "Down"
    65 = "A"
    68 = "D"
    83 = "S"
    87 = "W"
    89 = "Y"
}

function CommandLeft($state) { CommandMovePlayer $state  -1 0 }
function CommandRight($state) { CommandMovePlayer $state 1 0}
function CommandUp($state) { CommandMovePlayer $state 0 -1 }
function CommandDown($state) { CommandMovePlayer $state 0 1 }
function CommandW($state) { CommandWASD $state 0 -1 }
function CommandA($state) { CommandWASD $state -1 0 }
function CommandS($state) { CommandWASD $state 0 1 }
function CommandD($state) { CommandWASD $state 1 0 }
function CommandMovePlayer($state, $dx, $dy) {
    if ($game.player.IsAlive) {
        MovePlayer $state (Point ($game.player.x+$dx) ($game.player.y+$dy))
    } else {
        Log "You cannot move, you are dead"
    }
}
function CommandWASD($state, $dx, $dy) {
    if ($game.player.IsAlive) {
        PlayerActivate $state (Point ($game.player.x+$dx) ($game.player.y+$dy))
    } else {
        Log "You are dead"
    }
}
