. $PSScriptRoot\items.ps1
. $PSScriptRoot\monsters.ps1

$mapGen = @{
    Settings = @{
        MaxRooms = 9
        MaxThings = 9
        MaxObj = 9
        MaxPack = 23
        MaxTraps = 10
        NumThings = 7

        ROOM_LEFT_OUT = {d4} # rooms[rnd_room()] |= ISGONE
        ROOM_ISDARK = {Param([int]$level) d10 -lt ($level-1)}
        # ISRING = {(h,r) (cur_ring[h] != NULL && cur_ring[h]->o_which == r)}
        # ISWEARING ={(r) (ISRING(LEFT, r) || ISRING(RIGHT, r))}
        # ISMULT = {(type) (type == POTION || type == SCROLL || type == FOOD)}
        
        BEARTIME = 3
        SLEEPTIME = 5
        HEALTIME = 30
        HOLDTIME = 2
        STPOS = 0
        WANDERTIME = 70
        BEFORE = 1
        AFTER = 2
        HUHDURATION = 20
        SEEDURATION = 850
        HUNGERTIME = 1300
        MORETIME = 150
        STOMACHSIZE = 2000
        BOLT_LENGTH = 6
        
    }
    GOLDCALC = {Param([int]$level)(Get-Random (50 + 10 * $level)) + 2}
    
    BackgroundColor = "Black"
    DEC = @{
        "ul" = 9484
        "um" = 9516
        "ur" = 9488
        "ml" = 9500
        "mm" = 9532
        "mr" = 9508
        "ll" = 9492
        "lm" = 9524
        "lr" = 9496
        "hw" = 9472
        "vw" = 9474
    }

    Items = $itemGen
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
