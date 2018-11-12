$mapGen = @{
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

$rip = @"
...............________...................
............../        \\.................
............./   REST   \\................
............/     IN     \\...............
.........../    PEACE     \\..............
........../                \\.............
.........|                  |.............
.........|                  |.............
.........|   killed by a    |.............
.........|                  |.............
.........|       2018       |.............
........*|     *  *  *      |.*...........
______)/\\\\_//(\\/(/\\)/\\//\\/|_)_______
..........................................
     Try Again? (Y) or Quit (Esc)?          
"@
