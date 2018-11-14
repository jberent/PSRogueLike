$arena = @'
________________________________________________________________________________
_.............................................................................._
_......................................................................K......._
_.............................................................................._
_.............................................................................._
_.............................................................................._
_......................................K......................................._
_.............................................................................._
_.............................................................................._
_.........................K............@......................................._
_.............................................................................._
_.............................................................................._
_.............................................................................._
_.............................................................................._
_................................................K............................._
_.............................................................................._
_......K......................................................................._
_.............................................................................._
________________________________________________________________________________
'@

$arena2 = @'
________________________________________________________________________________
_..K..................$........................................................_
_......................................................................K......._
_.................____.____...................................................._
_................._.._-_.._...................................................._
_.................____.____.................._______________..................._
_......................................K....._............._..................._
_............................................_............._..................._
_............................................_______________..................._
_............___..........K............@......................................._
_............_._............................._______________..................._
_............___............................._............._..................._
_.............+.............................._............._..................._
_............___............................._______________..................._
_............_._.................................K............................._
_............___..............................................................._
_......K......................................................................._
_............................................................................>._
________________________________________________________________________________
'@

$dungeon1 = @'
                                                                 _______________
                 _______                                         _.!..........._
                 _.$..._                                         _............._
                 _=^.K.+################                         _......D......_
                 _....._               #                         _............._
                 _....._               #                         _.........]..._
                 ___-___           ____+_____                    _______+_______
                    #              _........_                           #       
                    #              _........_                           #       
                    #:#############+....@...+#########K####             #       
                                   _........_             #             #       
                                   _........_             #             #       
                                   __________             #       ______+______ 
                                                       ___+___    _..........._ 
                                                       _.....&####+....)......_ 
                                                       _.>..._    _.........?._ 
                                                       _______    _____________ 
                                                                                
'@



# .#. .#. .#. ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... 
# .## .## .## .#. .#. .#. .#. .#. .#. .#. .#. .#. .#. .#. .#. .#. .#. .#. .#. .#. .#. .#. .#. .#. .#. 
# ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... 
#
# .#. ##. ##. ##. .## .## .## ...   ... *.* *.* ### *.* ... ... ... ... ... ... ... ... ... ... ... ... 
# .#. .#. .#. .#. .#. .#. .#. .#.   ### ### ##. ##. .## .#. .#. .#. .#. .#. .#. .#. .#. .#. .#. .#. .#. 
# .#. .#. .## ##. .## ##  .#. ...   ... *.* *#* *#* *#* ... ... ... ... ... ... ... ... ... ... ... ... 

$wallhash = @{
    "    ## # " = "l"
    "    ## ##" = "l"
    "    #####" = "l"
    "    #### " = "l"
    "#   ## # " = "l"
    "#   ## ##" = "l"
    "#   #####" = "l"
    "#   #### " = "l"
    "# # ## # " = "l"
    "# # ## ##" = "l"
    "# # #####" = "l"
    "# # #### " = "l"
    "  # ## # " = "l"
    "  # ## ##" = "l"
    "  # #####" = "l"
    "  # #### " = "l"

    "   ##  # " = "k"
    "   ##  ##" = "k"
    "   ## ###" = "k"
    "   ## ## " = "k"
    "#  ##  # " = "k"
    "#  ##  ##" = "k"
    "#  ## ###" = "k"
    "#  ## ## " = "k"
    "# ###  # " = "k"
    "# ###  ##" = "k"
    "# ### ###" = "k"
    "# ### ## " = "k"
    "  ###  # " = "k"
    "  ###  ##" = "k"
    "  ### ###" = "k"
    "  ### ## " = "k"

    "   ###   " = "q"
    "   ###  #" = "q"
    "   #### #" = "q"
    "   ####  " = "q"

    "#  ###   " = "q"
    "#  ###  #" = "q"
    "#  #### #" = "q"
    "#  ####  " = "q"
    
    "# ####   " = "q"
    "# #####  " = "q"
    "# ##### #" = "q"
    "# ####  #" = "q"

    "  ####   " = "q"
    "  #####  " = "q"
    "  ##### #" = "q"
    "  ####  #" = "q"

    " #  ##   " = "m"
    " #  ###  " = "m"
    " #  ### #" = "m"
    " #  ##  #" = "m"
    " ## ##   " = "m"
    " ## ###  " = "m"
    " ## ### #" = "m"
    " ## ##  #" = "m"
    "##  ##   " = "m"
    "##  ###  " = "m"
    "##  ### #" = "m"
    "##  ##  #" = "m"

    " # ##    " = "j"
    " # ## #  " = "j"
    " # ## # #" = "j"
    " # ##   #" = "j"
    " ####    " = "j"
    " #### #  " = "j"
    " #### # #" = "j"
    " ####   #" = "j"
    "## ##    " = "j"
    "## ## #  " = "j"
    "## ## # #" = "j"
    "## ##   #" = "j"

    " #  #  # " = "x"
    " #  #  ##" = "x"
    " #  # ## " = "x"
    " #  # ###" = "x"
    "##  #  # " = "x"
    "##  #  ##" = "x"
    "##  # ## " = "x"
    "##  # ###" = "x"
    " ## #  # " = "x"
    " ## #  ##" = "x"
    " ## # ## " = "x"
    " ## # ###" = "x"
    "### #  # " = "x"
    "### #  ##" = "x"
    "### # ## " = "x"
    "### # ###" = "x"

    " # ### # " = "n"

    " #  ## # " = "t"
    " #  #### " = "t"

    " # ##  # " = "u"

    "   ### # " = "w"

    " # ###   " = "v"
}

$mapGen = @{

    Wall = "_"
    Floor = "."

    litColors = @{
        " " = "Black"
        "." = "DarkGray"
        "#" = "DarkGray"
        "_" = "Gray"
        "@" = "Green"
        "K" = "Yellow"
        '$' = "Yellow"
        ">" = "Blue"
        "-" = "Cyan"
        "+" = "Cyan"
    }
    unlitColors = @{
        " " = "Black"
        "." = "DarkGray"
        "#" = "DarkGray"
        "_" = "DarkGray"
        "@" = "Green"
        "K" = "DarkYellow"
        '$' = "DarkYellow"
        ">" = "DarkBlue"
        "-" = "DarkBlue"
        "+" = "DarkBlue"
    }
    DEC = @{
        "l" = 9484
        "w" = 9516
        "k" = 9488
        "t" = 9500
        "n" = 9532
        "u" = 9508
        "m" = 9492
        "v" = 9524
        "j" = 9496
        "q" = 9472
        "x" = 9474
    }

    "." = @{
        Name = "floor"
        IsEmpty = $true # don't interact
    }
    "#" = @{
        Name = "passage"
        IsEmpty = $true # don't interact
    }
    " " = @{
        Name = "void" # rock?
        IsWall = $true # move blocker, light blocker
    }
    "_" = @{
        Name = "wall"
        IsWall = $true # move blocker, light blocker
        lit2 = 64 # use litcolors when d <= lit2
        BumpAction = {Log "You bumped into a $(EntityName $target)"}
    }
    "-" = @{
        Name = "door"
        IsWall = $true # move blocker, light blocker
        IsClosed = $true
        State = "closed"
        ActivateAction =  {$target.character="+"; $target.gen = $mapgen["+"]; Log "You opened the door" }
        BumpAction = {Log "You bumped into a $(EntityName $target)"}
    }
    "+" = @{
        Name = "door"
        IsWall = $false # move blocker, light blocker
        IsClosed = $false
        State = "open"
        ActivateAction = {$target.character = "-"; $target.gen = $mapgen["-"] }
    }
    "D" = @{
        Name = "dragon"
        IsMonster = $true # move blocker
        DamageDice = "3d6+2" # ?
        Level = 10 # hpDice = Level * d8
        #HP = 50
        XP = 2500
    }
    "K" = @{
        Name = "kobold"
        IsMonster = $true # move blocker
        AttackDice = "2d6" # ?
        DamageDice = "1d4+2" # dagger
        Level = 1 # hpDice = Level * d8
        #HP = 50
        XP = 25
        FOV2 = 64
        # ActivateAction = {Log "You attacked a $(EntityName $target)"}
        # BumpAction = {Log "You attacked a $(EntityName $target)"}
        # KilledAction = {Log "You killed a $(EntityName $target)"}
    }
    '$' = @{
        Name = "gold"
        IsGold = $true
        Gold = 10
        ActivateAction = {$game.rogue.gold += $target.gen.gold; $target.IsDeleted = $true; Log "You found $($target.gen.gold) gold pieces!" }
        #BumpAction = {& $target.gen.ActivateAction $target}
    }
    ')' = @{
        Name = "weapon"
        IsWeapon = $true
    }
    ']' = @{
        Name = "armor"
        IsArmor = $true
    }
    '!' = @{
        Name = "flask"
        IsPotion = $true
    }
    '?' = @{
        Name = "paper"
        IsScroll = $true
    }
    '^' = @{
        Name = "trap"   # >    {     $     }    ~   ` 
        IsTrap = $true  # door arrow sleep bear tel dart
    }
    '%' = @{
        Name = "armor"
        IsArmor = $true
    }
    ',' = @{
        Name = "jewelry"
        IsAmulet = $true
    }
    '*' = @{
        Name = "magic"
        IsMagic = $true
    }
    ':' = @{
        Name = "food"
        IsFood = $true
    }
    '=' = @{
        Name = "ring"
        IsRing = $true
    }
    '/' = @{
        Name = "stick"
        IsWand = $true
    }
    '&' = @{
        Name = "secret door"
        IsSecretDoor = $true
    }
    '>' = @{
        Name = "stairs"
        Direction = "down"
    }
    "@" = @{
        Name = "rogue"
        IsMonster = $true
        DamageDice = "1d12"
        ArmorClass = 7
        LOS2 = 256 # dist^2 ??
        FOV2 = 64  # lit
        KilledAction = {ShowTombStone $game.playerName (EntityName $args[1])}
    }
} 


function makeLines([string[]]$lines, $wallChar) {
    $walls = "+-&$wallChar"
    $cols = $lines[0].length
    $length = $cols + 2
    $rows = $lines.Count
    $l1 = " "*$length
    for ($i = 0; $i -lt $rows; $i++) {
        $l0 = $l1
        $l1 = " $($lines[$i]) "
        $chars = $lines[$i].ToCharArray()
        if ($i + 1 -lt $rows) {
            $l2 = " $($lines[$i + 1]) "
        } else {
            $l2 = " "*$length
        }
        for ($j = 0; $j -lt $cols; $j++) {
            if ($chars[$j] -eq $wallChar) {
                $wall = [string]::new( ("$($l0.Substring($j,3))$($l1.Substring($j,3))$($l2.Substring($j,3))".tochararray() | % { if($walls.Contains($_)){"#"}else{" "}}) )
                $d = $wallhash[$wall]
                if ($d) {
                    $chars[$j] = $d
                }
                if ($l1[$j+1] -eq $wallChar) {
                    if (!$d) {
                        
                        write-host $l0
                        write-host $l1
                        write-host $l2
                        write-host "'$wall'"
                        Read-Host ">"
                    }
                }
            }
        }
        $lines[$i] = [System.String]::new($chars)
    }
}

function CreateMapFromLevel($levelgen) {
    $lines = $levelgen.level.split([Environment]::NewLine, [StringSplitOptions]::RemoveEmptyEntries)
    if ($levelgen.DrawLines) {
        makeLines $lines $levelgen.DrawLines
    }
    $cols = $lines[0].length
    $rows = $lines.Count
    $grid = New-Object "object[,]" $rows,$cols
    $mapgen = $levelgen.mapgen
    $colors = $mapgen.litColors
    $bg = $colors[" "]
    $void = CreateCell " " $bg $bg
    $buffer = CreateBuffer $cols $rows $void

    $map = @{
        rows = $rows
        cols = $cols
        grid = $grid
        mapGen = $mapgen
        buffer = $buffer
        floor = "."
    }
    $game.map = $map


    for ($i = 0; $i -lt $rows; $i++) {
        $line = $lines[$i]
        for ($j = 0; $j -lt $cols; $j++) {
            $entity = CreateEntity $levelgen $line[$j]
            PlaceEntityXY $entity $j $i
            if ($key -ne " ") {
                UpdateBufferCell $buffer $entity
            }
        }
    }

}

function showLevelTest($level) {
    createMapFromLevel (@{level = $level; mapGen = $mapGen})
}


function Test {
    CreateMap $game
}


if (!$game) {
    . .\host.ps1
    . .\mapgen.ps1
    . .\map.ps1
    
    function GameAddEntity($entity) {}
}
function CreateMap {
    # $game.MapWindow | Format-List
    # $game.InventoryWindow | Format-List
    # $game.LogWindow | Format-List
    # $game.StatusWindow | Format-List
    # read-host
    # showLevelTest $game $dungeon1
    # createMapFromLevel (@{level = $dungeon1a; mapGen = $mapGen; DrawLines = $true})
    createMapFromLevel (@{level = $arena2; mapGen = $mapGen; DrawLines = $true})
    #createMapFromLevel (@{level = $dungeon1; mapGen = $mapGen; DrawLines = "_"})
    #createMapFromLevel (@{level = $dungeon2; mapGen = $mapGen; dec = $true})
    # $game
    # $game.rogue
    #$game.map | Format-List

    # $log = GetWindow "LogWindow"
    # PrintToWindow "LogWindow" 0 0 "1234567890"
    # PrintToWindow "LogWindow" 0 1 "234567890"
    # PrintToWindow "LogWindow" 0 2 "34567890"
    # PrintToWindow "LogWindow" 0 3 "4567890"
    # $src = RectLTRB ($log.Position.X) $log.Position.Y 3 ($log.Position.Y+3)
    # $Host.UI.RawUI | Format-List
    # Read-Host "$($src.Right) $($src.Bottom) $((PointFromWindow $log 1 0).Y)"
    # ScrollBufferContents $src (PointFromWindow $log 0 1) $src (CreateCell "X" "Red" "Yellow")
}

# function DrawStats {
#     DrawOrbit $game
# }

if (!$game) {

    $game = @{
        ui = $host.ui.RawUI
        MapWindow = RectLTRB 0 0 80 50
    }
    
    Test
    Read-Host
}