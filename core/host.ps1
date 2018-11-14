function Initialize-Console {
    (Get-Host).ui.rawui.BackgroundColor = "Black"
    
    #TODO: verify Width >= 128
}


function Size($w, $h) {
    New-Object System.Management.Automation.Host.Size($w, $h)
}
function Point($x, $y) {
    New-Object System.Management.Automation.Host.Coordinates($x, $y)
}
function Rect([System.Management.Automation.Host.Coordinates]$upperLeft, [System.Management.Automation.Host.Coordinates]$lowerRight) {
    New-Object System.Management.Automation.Host.Rectangle($upperLeft, $lowerRight)
}

function RectLTRB([int]$l, [int]$t, [int]$r, [int]$b) {
    New-Object System.Management.Automation.Host.Rectangle($l, $t, $r, $b)
}

function CreateCell([char]$char, $fg, $bg) {
    if ($null -eq $fg) { $fg = $host.ui.rawui.ForegroundColor}
    if ($null -eq $bg) { $bg = $host.ui.rawui.BackgroundColor}
    new-object System.Management.Automation.Host.BufferCell($char, $fg, $bg, [System.Management.Automation.Host.BufferCellType]::Complete)
}

function CreateTextBuffer([string]$text, [int]$width, [System.Management.Automation.Host.BufferCell]$fill) {
    if (!$width) {
        $width = $text.Length
    }
    #read-host "$width $text"
    $buffer = CreateBuffer $width 1 $fill
    UpdateCells $buffer 0 0 $text
    return ,$buffer
}

function CreateBuffer([int]$width, [int]$height, [System.Management.Automation.Host.BufferCell]$fill) {
    if (!$fill) {
        $fill = CreateCell " "
    }
    $buffer = $Host.ui.rawui.NewBufferCellArray($width, $height, $fill)
    ,$buffer
}

function UpdateTextToScreenXY([int]$x, [int]$y, [string]$text, $fg, $bg){
    $buffer = GetBufferContents (RectLTRB $x $y ($x + $text.Length-1) $y)
    UpdateCells $buffer 0 0 $text $fg $bg
    SetBufferContents (Point $x $y) $buffer
}

function UpdateCells($buffer, [int]$x, [int]$y, [string]$text, $fg, $bg){
    $text.ToCharArray() | % { UpdateCell $buffer $x $y $_ $fg $bg; $x++ }
}

function UpdateCell($buffer, [int]$x, [int]$y, [char]$char, $fg, $bg){
    if ($x -ge 0 -and $x -lt $buffer.GetLength(1)) {
        if ($y -ge 0 -and $y -lt $buffer.GetLength(0)) {

            [System.Management.Automation.Host.BufferCell]$cell = $buffer[$y,$x]
            
            if ($char) { $cell.Character = $char }
            if ($null -ne $fg) { $cell.ForegroundColor = $fg}
            if ($null -ne $bg) { $cell.BackgroundColor = $bg}
            $buffer[$y,$x] = $cell
        }
    }
}

<#    x == 0                         y == 0
    +----+ (0,-1)               $source  -->            (1,0)
    +----+ $source              +----+-------------+----+
    |    |                      |    :             |    |
    |    |                      |fill:             |    |
    |    | ---- Bottom + Dir    |    :             |    |
    |    | fill                 |    :             |    |
    +----+ ----                 +----+-------------+----+
 Y
+1  Top
-1  Bottom
#>
function ScrollBufferContents([System.Management.Automation.Host.Rectangle]$source, 
                              [System.Management.Automation.Host.Coordinates]$direction, 
                              [System.Management.Automation.Host.BufferCell]$fill,
                              [string]$text) {

    if(!$fill) {
        $fill = CreateCell " "
    }
    #$host.UI.RawUI.ScrollBufferContents($source, $destination, $clip, $fill)
    $buffer = $host.UI.RawUI.GetBufferContents($source)
    $destination = Point ($source.Left + $direction.X) ($source.Top + $direction.Y) # ($source.Right + $direction.X) ($source.Bottom + $direction.Y)
    $host.UI.RawUI.SetBufferContents($destination, $buffer)
    if ($direction.X -eq 0) { # vertical scroll
        $width = $source.Right - $source.Left + 1
        if ($text) {
            $clear = $host.UI.RawUI.NewBufferCellArray(@($text.PadRight($width)), $fill.ForegroundColor, $fill.BackgroundColor)   
        } else {
            $clear = CreateBuffer $width 1 $fill
            # $source | Format-Table
            # $destination | Format-Table
            # $direction | Format-Table
            # read-host
        }
        if ($direction.Y -eq -1) { # up
            $destination =  Point $source.Left $source.Bottom
        } else {
            $destination =  Point $source.Left $source.Top
        }
    }
    $host.UI.RawUI.SetBufferContents($destination, $clear)
}

function GetBufferContents([System.Management.Automation.Host.Rectangle]$source){ 
    ,$host.UI.RawUI.GetBufferContents($source)
}
function SetBufferContents([System.Management.Automation.Host.Coordinates]$origin, $buffer){ 
    $host.UI.RawUI.SetBufferContents($origin, $buffer)
}

function PrintTextToScreenXY([int]$x, [int]$y, [string]$text, [int]$width, [System.Management.Automation.Host.BufferCell]$fill) {
    PrintTextToScreen (Point $x $y) $text $width $fill
}
function PrintTextToScreen([System.Management.Automation.Host.Coordinates]$to, [string]$text, [int]$width, [System.Management.Automation.Host.BufferCell]$fill) {
    [System.Management.Automation.Host.BufferCell[,]]$buffer = CreateTextBuffer $text $width $fill
    SetBufferContents $to $buffer
}

