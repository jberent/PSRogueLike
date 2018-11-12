

function GameSetup {
    ConsoleStart
    do {
        GameRun
        
    } while ($game.Restart)
}

function GameRun {
    GameStart
    GameLoop
    GameOver
}

function GameStart {
    if ($game.Restart) {
        Write-Host "Restarting....."
        $script:game = @{
            ui = $host.ui.RawUI
            playerName = $game.playerName
        }
        
    }
    $game.entities = [System.Collections.ArrayList]@()
    $game.viewport = $game.ui.WindowSize
    
    CreateWindows
    CreateMap
    PlayerInit
}

$hostuiRawUICursorSize=$host.ui.RawUI.CursorSize
function ConsoleStart {
    $hostuiRawUICursorSize=$host.ui.RawUI.CursorSize
    CSI "?1049h"
    $host.ui.RawUI.CursorSize = 0
}

function GameOver {
    if (!$game.Restart) {
        ConsoleOver
    } else {
        # clear windows
    }
}
function ConsoleOver {
    $host.ui.RawUI.CursorSize=$hostuiRawUICursorSize
    CSI "?1049l"
}

function DrawGame {
    DrawMap
    DrawStats
}

function DrawStats {
    DrawPlayerStats
}

function UpdateGame($state) {
    UpdateEntities
    DrawGame
}

function GameAddEntity($entity) {
    if ($entity.gen.Name -eq "rogue"){
        $game.rogue = $entity
    } else {
        $game.entities.Add($entity) > $null
    }
}

function UpdateEntities($state) {
    $game.entities | ? {$_.IsAlive} | % { if(!$game.Quit) { MoveMonster $state $_}}
}

function GameLoop{
    DrawGame
    for([System.Management.Automation.Host.PSHostRawUserInterface]$ui = $Host.UI.RawUI;;) {
        #$b = $ui.BufferSize
        $state = @{
            game = $game
            ui = $ui
            Key = $ui.ReadKey(6)
        }
        switch($RLKey[$state.Key.VirtualKeyCode]) {
            Space {
                 break
            }
            Left { CommandLeft $state
                break
            }
            Right { CommandRight $state
                break
            }
            Up { CommandUp $state
                break
            }
            Down { CommandDown $state
                break
            }

            W {CommandW $state; break }
            A {CommandA $state; break }
            S {CommandS $state; break }
            D {CommandD $state; break }
            
            Esc {
                return
            }
        }

        UpdateGame $state
        if ($game.Quit) {return}
    }
}
