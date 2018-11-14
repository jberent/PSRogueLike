# ANSI terminal functions

$esc = "$([char]27)"
$csi = "$([char]27)["
$dec = "$([char]27)("
$osc = "$([char]27)]"

function CSI($code, $term, $text) { "$csi$code$term$text" }
function DEC($code, $term, $text) { "$dec$code$term$text" }
function OSC($code, $term, $text) { "$osc$code$term$text" }

<#
    0 - default
    4 - underline; 24 off
    7 - swap FG/BG; 27 off
    30-37 FG; 39 default; 90-97 bright
    40-47 BG; 49 default; 100-107 bright
    38;2;r;g;b ; 38;5;s indexed
    48;2;r;g;b
#>
function SGR($code, $text)  { CSI "$code" "m" $text}
function SGR_FG($r, $g, $b, $text) { SGR "38;2;$r;$g;$b" $text}
function SGR_BG($r, $g, $b, $text) { SGR "48;2;$r;$g;$b" $text}

function MSC($i, $r, $g, $b, $text) { OSC "4;$i;rgb:$r/$g/$b$" $esc $text } # Modify Screen Colors, rgb in hex

function CUP($row, $column, $text) { CSI "$row;$column" "H" $text}
