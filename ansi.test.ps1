function foreground_check {
    "$(SGR 0)$(SGR 4)SGR BASIC TEST$(SGR 24)"
    (0..7) | % {
        $bg = "$(SGR (40 + $_))"
        $bh = "$(SGR (100 + $_))"
        (0..7) | % { Write-Host "$bg$(SGR (30 + $_))$_" -NoNewline }
        (0..7) | % { Write-Host "$bg$(SGR (90 + $_))$_" -NoNewline }
        (0..7) | % { Write-Host "$bh$(SGR (30 + $_))$_" -NoNewline }
        (0..7) | % { Write-Host "$bh$(SGR (90 + $_))$_" -NoNewline }
        if ($_ -eq 3) {
            Write-Host ""
        }
    }
    @"

$(SGR 0)$(SGR 7)SGR BASIC TEST -- COMPLETE$(SGR 27)
"@
}

function extendedColors_check {
    "$(SGR 0)$(SGR 4)SGR EXTENDED TEST$(SGR 24)"
    (0..127) | % {
        $c = "X"
        $bg = "$(SGR_BG (2 * $_))"
        $fg = "$(SGR_FG (255 - 2 * $_))"
        Write-Host "$bg$fg$c" -NoNewline
    }
    @"

$(SGR 0)$(SGR 7)SGR EXTENDED TEST -- COMPLETE$(SGR 27)
"@

}
function lineDrawing_check {
    "$(SGR 0)$(SGR 4)LINE DRAWING TEST$(SGR 24)"
    DEC "0"  ("l"+ "q"*64 +"k")
    "x" + " "*64 + "x"
    "x" + "a"*64 + "x"
    "m" + "q"*64 + "j"
    'afgjklmnqtuvwxyz'
    DEC "B"
    @"

$(SGR 0)$(SGR 7)LINE DRAWING TEST -- COMPLETE$(SGR 27)
"@
}

function Game {
    foreground_check
    extendedColors_check
    lineDrawing_check
    $u = Read-Host "<ENTER> to exit test"

}

