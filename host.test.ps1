
<#
Black
DarkBlue
DarkGreen
DarkCyan
DarkRed
DarkMagenta - VeryDarkBlue
DarkYellow - DarkWhite
Gray
DarkGray
Blue
Green
Cyan
Red
Magenta
Yellow
White
#>
function HostBuffer_Test {
    $ui = (Get-Host).ui.rawui
    $fg = $ui.ForegroundColor
    $bg = $ui.BackgroundColor #.ToString() # Black == 0 which is not $true!
    $colors = [System.ConsoleColor]::GetValues([System.ConsoleColor])
    # 16 FG + 16 BG
    # make screen buffer 2*128 plus Title, Status line
    $buffer = (CreateBuffer 128 4)
    UpdateCells $buffer 0 0 "Buffer Basic Test" $fg $bg
    $x = 0
    $y = 1
    for ($b = 0; $b -lt 8; $b++) {
        $colors | % { UpdateCell $buffer $x $y "X" $_ ($colors[$b]); $x++ }
    }
    $x = 0
    $y = 2
    for ($b = 8; $b -lt 16; $b++) {
        $colors | % { UpdateCell $buffer $x $y "X" $_ ($colors[$b]); $x++ }
    }
    UpdateCells $buffer 0 3 "Buffer Basic Test -- Complete" $bg $fg
    $to = Point 0 0
    $ui.SetBufferContents($to, $buffer)
}
#$buffer = $state.ui.GetBufferContents((Rect $state.CursorPosition $state.CursorPosition))
function HostMap_Test {
    $ui = (Get-Host).ui.rawui
    $buffer = (CreateBuffer 128 1)
    UpdateCells $buffer 0 0 "Host Map Test"
    $to = Point 0 5
    $ui.SetBufferContents($to, $buffer)
    UpdateCells $buffer 0 0 "Host Map Test -- Complete" "Black" "White"
    $to = Point 0 38
    $ui.SetBufferContents($to, $buffer)

    $floor = CreateCell "." DarkMagenta Black
    $buffer = CreateBuffer 128 32 $floor
    $x0 = 64; $y0 = 16
    $x = 0
    $y = 1
    for ($x = 0; $x -lt 128; $x++) {
        UpdateCell $buffer $x 0 "#" "White" "DarkGray"
        UpdateCell $buffer $x 31 "#" "White" "DarkGray"
        if ($x -lt 32) {
            UpdateCell $buffer 0 $x "#" "White" "DarkGray"
            UpdateCell $buffer 127 $x "#" "White" "DarkGray"
        }
    }

    FOV_Test $buffer $x0 $y0
    FOV_Test $buffer 120 24
    UpdateCell $buffer $x0 $y0 "@" "Green"
    UpdateCell $buffer 120 24 "$" "Yellow"
    $to = Point 0 6
    $ui.SetBufferContents($to, $buffer)
}

function FOV_Test($buffer, $x0, $y0) {
    $light = "DarkGray"
    for ($x = 0; $x -lt 8; $x++) {
        for ($y = 0; $y -lt 8; $y++) {
            if ($x * $x + $y * $y -lt 64) {
                UpdateCell $buffer ($x0-$x) ($y0-$y) 0 $light
                UpdateCell $buffer ($x0+$x) ($y0-$y) 0 $light
                UpdateCell $buffer ($x0-$x) ($y0+$y) 0 $light
                UpdateCell $buffer ($x0+$x) ($y0+$y) 0 $light
            }
        }
    }

}
function Game {
    #(Get-Host).ui.rawui.CursorSize = 100
    $viewport = (Get-Host).ui.RawUI.WindowSize
    #CSI "$($viewport.Height - 5);$($viewport.Height - 2)r"
    CUP ($viewport.Height - 5) 0 $host.ui.RawUI.BackgroundColor
    HostBuffer_Test
    HostMap_Test
    BufferLineDrawTest
    # CUP ($viewport.Height - 4) 0 ">>>"
    Read-Host "<ENTER> to exit test"
    #(Get-Host).ui.rawui.CursorSize = 25

}

function BufferLineDrawTest {
    CUP 40 0 "$(SGR 0)$(SGR 4)LINE DRAWING TEST$(SGR 24)"
    SGR_FG 14 26 12 (DEC "0" ("l"+ "q"*64 +"k"))
    SGR_FG 14 26 127 ("x" + " "*64 + "x")
    SGR_FG 14 26 77 ("x" + "a"*64 + "x")
    SGR_FG 14 26 227 ("m" + "q"*64 + "j")
    SGR_FG 14 26 200 ("lqkxmjafgjklmnqtuvwxyz$(DEC "B")")
    #         
    $codes = @(9484,9516,9488,9492,9524)
    $ui = (Get-Host).ui.rawui
    $buffer = $ui.GetBufferContents((RectLTRB 0 40 65 43))
    write-host ":"
    write-host ":"
    write-host ":"
    write-host ":"
    write-host ([int]($buffer[0,0].Character))
    $buffer[0,0] | Format-List
    $ui.SetBufferContents((Point 0 45),$buffer)


}