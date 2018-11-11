$RLKey = @{
    27 = "Esc"
    32 = "Space"
    37 = "Left"
    39 = "Right"
    38 = "Up"
    40 = "Down"
    87 = "W"
    65 = "A"
    83 = "S"
    68 = "D"
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
    if ($game.rogue.IsAlive) {
        MovePlayer $state (Point ($game.rogue.x+$dx) ($game.rogue.y+$dy))
    } else {
        Log "You cannot move, you are dead"
    }
}
function CommandWASD($state, $dx, $dy) {
    if ($game.rogue.IsAlive) {
        PlayerActivate $state (Point ($game.rogue.x+$dx) ($game.rogue.y+$dy))
    } else {
        Log "You are dead"
    }
}
