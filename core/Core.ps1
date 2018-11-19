        
function RectFromSize($pos, $size) {
    RectLTRB $pos.X $pos.Y ($pos.X+$size.Width-1) ($pos.Y+$size.Height-1)
}
function RectFromWindow($window) {
    RectFromSize $window.Position $window.Size
}
function OriginFromWindow($window) {
    Point $window.Position.X $window.Position.Y
}
function PointFromWindow($window, $x, $y) {
    Point ($window.Position.X+$x) ($window.Position.Y+$y)
}

function PrintToWindow($windowName, $x, $y, $text) {
    $window = GetWindow $windowName
    #Read-Host "$windowName $x $y $text"
    PrintTextToScreen (PointFromWindow $window $x $y) $text 0 $window.Fill
}

function GetWindow($windowName) {
    $game.$windowName
}
function GetWindowValue($windowName, $property) {$game.$windowName.$property}

function UpdateWindow($windowName, $buffer, $x, $y) {
    $window = GetWindow $windowName
    if (!$x -and !$y) {
        $dest = (OriginFromWindow $window)
    } else {
        $dest = (PointFromWindow $window $x $y)
    }
    SetBufferContents $dest $buffer
    #read-host $windowName $dest.x $dest.y $buffer.getlength(0) $buffer.getlength(1)
}


function ScrollWindow($window, [System.Management.Automation.Host.Coordinates]$direction, $text, $fill) {
    if (!$fill) {
        $fill = $window.Fill
    }
    $dTop = if ($direction.Y -eq -1 ) {1} else {0}
    $dBottom = if ($direction.Y -eq 1 ) {-1} else {0}
    
    [System.Management.Automation.Host.Rectangle]$clip = RectFromWindow $window
    [System.Management.Automation.Host.Rectangle]$source = RectLTRB $clip.Left ($clip.Top+$dTop) $clip.Right ($clip.Bottom+$dBottom)
    ScrollBufferContents $source $direction $fill $text
}

function PrintToScrollWindow($windowName, $text, $fill) {
    $window = GetWindow $windowName
    #Read-Host "$($window.Scroll) $($window.Position.Y + $window.Size.Height) $($game.viewport.Height) $text"
    ScrollWindow $window (Point 0 1) $text $fill
    #Read-host "UpdateTextToScreenXY $($window.Position.X) $($window.Position.Y + $Window.Size.Height - 1) $text"
    #UpdateTextToScreenXY $window.Position.X ($window.Position.Y + $Window.Size.Height - 1) $text
}

function DrawEntity($state, $entity) {
    CUP ($entity.y+1) ($entity.x+1) $entity.Character
}



function CreateWindows {
    ##########################
    # Map                # I #
    #                    #   #
    #                    #---#
    #                    #   #
    #                    #   #
    #                    #---#
    #                    #   #
    #                    #   #
    ##########################
    # Status                 #
    ##########################
    # Log          # Debug   #
    #              #         #
    #              #         #
    ##########################
    $right = $game.viewport.width-1
    $bottom = $game.viewport.height-1
    $mapWidth = 81
    $mapHeight = 45
    if ($right -lt 100) {
        $mapWidth = $right - 20
    }
    $game.MapWindow = @{
        Fill = (CreateCell " " Gray Black)
        Position = @{ X = 0; Y = 0 }
        Size = @{ Width = $mapWidth;  Height = $mapHeight }
    }
    $game.InventoryWindow = @{
        Fill = (CreateCell " " White Black)
        Position = @{ X = $mapWidth; Y = 0 }
        Size = @{ Width = $right - $mapWidth;  Height = $mapHeight }
    }
    $game.StatusWindow = @{
        Fill = (CreateCell " " Black White)
        Position = @{ X = 0; Y = $mapHeight }
        Size = @{ Width = $right;  Height = 1 }
    }
    $game.LogWindow = @{
        Scroll = $true
        ScrollDirection = "Up"
        Fill = (CreateCell " " Cyan Black)
        Position = @{ X = 0; Y = $mapHeight + 1 }
        Size = @{ Width = $right;  Height = $bottom - $mapHeight }
    }
    #                                L         T                R                  B    
    # $game.MapWindow =       RectLTRB 0         0                ($mapWidth - 1)    ($bottom - 6)
    # $game.InventoryWindow = RectLTRB $mapWidth 0                $right             ($bottom - 6)
    # $game.StatusWindow =    RectLTRB 0         $mapHeight       $right             ($mapHeight + 1)
    # $game.LogWindow =       RectLTRB 0         ($mapHeight + 2) $right             ($bottom - 1)
    # CreateLogScrollingRegion
}

# function CreateLogScrollingRegion {
#     CSI "$($game.LogWindow.Top);$($game.LogWindow.Bottom)r"
# }

function Log($msg, $fill) {
    if ($game.LogWindow) {
        PrintToScrollWindow "LogWindow" $msg (WithFill $fill) #CUP ($game.LogWindow.Bottom) 0 $msg
    } else {
        Write-Host $msg
    }
    #$state.ui.CursorPosition = $state.CursorPosition
}
function CombatLog($msg, $cat, $attacker, $defender) {
    if ( $defender.gen.Name -eq "rogue") {
        switch ($cat) {
            HIT { Log $msg BAD }
            KILL { Log $msg FATAL }
            Default {Log $msg}
        }
    } elseif ( $attacker.gen.Name -eq "rogue") {
        switch ($cat) {
            HIT { Log $msg GOOD }
            KILL { Log $msg GOOD }
            Default {Log $msg}
        }
    } else {
        Log $msg
    }
}
function WithFill($fill) {
    switch ($fill) {
        GOOD { CreateCell " " "Green" "Black"}
        BAD { CreateCell " " "Red" "Black"}
        FATAL { CreateCell " " "Black" "Red"}
    }
}

function Status($msg) {
    #Read-Host "$msg"
    if ($game.StatusWindow) {
        PrintToWindow "StatusWindow" 0 0 $msg #(CUP ($game.StatusWindow.Top) 0 (CSI "K" $msg)) | Write-Host -NoNewline
    } else {
        Write-Host $msg  -NoNewline
    }
    #$state.ui.CursorPosition = $state.CursorPosition
}

function RollDice($dice) {
    if ($dice) {
        $parse = $dice.split("+")
        if ($parse.count -eq 2) {
            [int]$bonus = $parse[1] 
        }
        $parse2 = $parse[0].split("d")
        [int]$rolls = 1
        [int]$d = $parse2[0]
        
        $result = 0
        if ($parse2.count -eq 2) {
            [int]$rolls = $parse2[0]
            [int]$d = $parse2[1]
        } else { # no d, just an absolute value (?)
            $result = $d
            $rolls = 0
        }
        for($r=0; $r -lt $rolls; $r++) {
            $result += ((Get-Random $d) + 1)
        }
        #read-host "$dice $rolls x $d = $($result + $bonus)"
        return $result + $bonus
    }
}
function d4 {(Get-Random 4) + 1 }

function d10 {(Get-Random 10) + 1 }

function d20 {(Get-Random 20) + 1 }
function d100 {(Get-Random 100) + 1 }

