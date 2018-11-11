$mapGen = @{
    litColors = @{
        " " = "Black"
        "." = "DarkGray"
        "#" = "Gray"
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
        "#" = "GrayWhite"
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
    " " = @{
        Name = "void"
        IsWall = $true # move blocker, light blocker
    }
    "#" = @{
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
    }
} 

$rip = @"
.............. ________  ...................
............. /        \\ ..................
............ /   REST   \\ .................
........... /     IN     \\ ................
.......... /    PEACE     \\ ...............
......... /                \\ ..............
........ |                  | ..............
........ |                  | ..............
........ |   killed by a    | ..............
........ |                  | ..............
........ |       2018       | ..............
....... *|     *  *  *      | *.............
________)/\\\\_//(\\/(/\\)/\\//\\/|_)_______
"@
