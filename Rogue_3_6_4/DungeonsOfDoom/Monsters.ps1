$lvl_mons =  "KJBSHEAOZGLCRQNYTWFIXUMVDP"
$wand_mons = "KJBSH AOZG CRQ Y W IXU V  "


$monster = @{
    IsMonster = $true
    CreatedAction = {$target.IsMonster = $true; $target.IsAlive = $true;}
    # ActivateAction = {Log "You attacked a $(EntityName $target)"}
    # BumpAction = {Log "You attacked a $(EntityName $target)"}
    # KilledAction = {Log "You killed a $(EntityName $target)"}
    randmonster = {Param($level, $wander)
        $d = $level + (rnd 10) - 5
        if ($d -lt 1) {
            $ch = "K","J","B","S","H" | Get-Random
        } elseif ($d -gt 26) {    
            $ch = "U","M","V","D","P" | Get-Random
        } else {
            [string]$ch = $lvl_mons[$d-1]
        }
        $ch   
    }
}
$itemGen.Monster = $monster
$itemGen.Player = @{
        Name = "rogue"
        Char = '@'
        Color = "Green"
        Damage = "1d12"
        Armor = 7
        LOS2 = 256 # dist^2 ??
        FOV2 = 64  # lit
        KilledAction = {ShowTombStone $game.playerName (EntityName $args[1])}
        Base = $monster
    }
function ItemGen([string]$name, [string]$char, [int]$carry, [int]$xp, [int]$level, [int]$ac, [string]$damage, [System.ConsoleColor]$fg,
                 [switch]$mean, [switch]$regen, [switch]$invis, [switch]$greed, [switch]$block) {
    
    $m = @{Name=$name; Char=$char; Carry=$carry; XP= $xp; Level=$level; Armor= $ac; Damage=$damage; Color=$fg; Base=$monster }
    if ($mean) { $m.ISMEAN = $true}
    if ($regen) { $m.ISREGEN = $true}
    if ($invis) { $m.ISINVIS = $true}
    if ($greed) { $m.ISGREED = $true}
    if ($block) { $m.ISBLOCK = $true}
    if (!$m.Color) {
        if ($mean) {
            $m.Color = [System.ConsoleColor]::Red
        } elseif ($regen) {
            $m.Color = [System.ConsoleColor]::Green
        }
    }
    $itemGen.$char = $m
}

#                                                    RGB CMYK 
itemGen "giant ant"         "A"   0   10  2  3 "1d6" -MEAN
itemGen "bat"               "B"   0    1  1  3 "1d2" 
itemGen "centaur"           "C"  15   15  4  4 "1d6/1d6"
itemGen "dragon"            "D" 100 9000 10 -1 "1d8/1d8/3d10" -GREED
itemGen "floating eye"      "E"   0    5  1  9 "0d0"
itemGen "violet fungi"      "F"   0   85  8  3 "000d0" -MEAN
itemGen "gnome"             "F"  10    8  1  5 "1d6"
itemGen "hobgoblin"         "H"   0    3  1  5 "1d8" -MEAN
itemGen "invisible stalker" "I"   0  120  8  3 "4d4" -INVIS
itemGen "jackal"            "J"   0    2  1  7 "1d2" -MEAN
itemGen "kobold"            "K"   0    1  1  7 "1d4" -MEAN
itemGen "leprechaun"        "L"   0   10  3  8 "1d1"
itemGen "mimic"             "M"  30  140  7  7 "3d4"
itemGen "nymph"             "N" 100   40  3  9 "0d0"
itemGen "orc"               "O"  15    5  1  6 "1d8" -BLOCK
itemGen "purple worm"       "P"  70 7000  15 6 "2d12/2d4"
itemGen "quasit"            "Q"  30   35  3  2 "1d2/1d2/1d4" -MEAN
itemGen "rust monster"      "R"   0   25  5  2 "0d0/0d0"     -MEAN
itemGen "snake"             "S"   0    3  1  5 "1d3"         -MEAN
itemGen "troll"             "T"  50   55  6  4 "1d8/1d8/2d6" -MEAN -REGEN
itemGen "umber hulk"        "U"  40  130  8  2 "3d4/3d4/2d5" -MEAN
itemGen "vampire"           "V"  20  380  8  1 "1d10"        -MEAN -REGEN
itemGen "wraith"            "W"   0   55  5  4 "1d6"
itemGen "xorn"              "X"   0  120  7 -2 "1d3/1d3/1d3/4d6" -MEAN
itemGen "yeti"              "Y"  30   50  4  6 "1d6/1d6"
itemGen "zombie"            "Z"   0    7  2  8 "1d8" -MEAN
