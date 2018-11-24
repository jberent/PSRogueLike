$Wall = @{
    Name = "wall"
    Char = "_"
    IsWall = $true # move blocker, light blocker
    BumpAction = {Log "You bumped into a $(EntityName $target)"}
    Color = "Gray"
}
$Floor = @{
    Name = "floor"
    Char = "."
    IsEmpty = $true # don't interact
    Color = "DarkGray"
}


$Trap = @{
    Name = "trap"   # >    {     $     }    ~   ` 
    Char = '^'
    IsTrap = $true  # door arrow sleep bear tel dart
    Color = "Red"
    SubTypes = @("TrapDoor", "ArrowTrap", "SleepTrap", "BearTrap", "TeleTrap", "DartTrap")
}


$itemGen = @{

    # CONSTRUCTION
    Floor =$Floor
    Passage = @{
        Name = "passage"
        Char = "#"
        Base = $Floor
    }


    Room = @{ #not an entity, per se
        ROOM_ISDARK = {Param([int]$level) d10 -lt ($level-1)}
        WALLS = @{
            "ul" = 9484 # upper left corner
            "ur" = 9488
            "ll" = 9492
            "lr" = 9496
            "hw" = 9472 # horizontal wall
            "vw" = 9474 # vertical wall
        }
        ChanceGold = {Save100 50}
        AmountGold = {Param([int]$level)(Get-Random (50 + 10 * $level)) + 2}
        ChanceMonster = {Param($room) if ($room.HasGold){Save100 80} else {Save100 25} }

    }

    Wall = $Wall
    Rock = @{
        Name = "rock"
        Char = " "
        Base = $Wall
    }

    Door = @{
        Name = "door"
        State = "open"
        Color = "Cyan"
        States = @{
            open = @{
                Char = "+"
                ActivateAction =  {ChangeItemState $target "closed"; Log "You closed the door" }
            }
            closed = @{
                Char = '-'
                Name = "closed door"
                ActivateAction =  {ChangeItemState $target "open"; Log "You opened the door" }
                Base = $Wall

            }
        }
    }
    SecretDoor = @{
        Name = "secret door"
        Char = '&'
        IsSecretDoor = $true
        Color = "Cyan"
    }
    Stairs = @{
        Name = "stairs"
        Char = '>'
        Direction = "down"
        Color = "Cyan"
    }


    # ITEMS

    Gold = @{
        Name = "gold"
        Char = '$'
        Color = "Yellow"
        # IsGold = $true
        # Chance = {Save100 50}
        # Amount = {Param([int]$level)(Get-Random (50 + 10 * $level)) + 2}
        ActivateAction = {$gold = (GetEntityValue $target "gold"); $game.player.gold += $gold; $target.IsDeleted = $true; Log "You found $gold gold pieces!" }
        #BumpAction = {& $target.gen.ActivateAction $target}
    }

    Food = @{
        Name = "food"
        Char = ':'
        IsFood = $true
    }

    Weapon = @{
        Name = "weapon"
        Char = ')'
        IsWeapon = $true
    }
    Armor = @{
        Name = "armor"
        Char = ']'
        IsArmor = $true
    }

    # TRAPS

    Trap = $trap
    TrapDoor = @{
        Name = "trap door"
        Char = '>'
        Base = $trap
    }
    ArrowTrap = @{
        Name = "arrow trap"
        Char = '{'
        Base = $trap
    }
    SleepTrap = @{
        Name = "sleep trap"
        Char = '{'
        Base = $trap
    }
    BearTrap = @{
        Name = "bear trap"
        Char = '{'
        Base = $trap
    }
    TeleTrap = @{
        Name = "tele trap"
        Char = '{'
        Base = $trap
    }
    DartTrap = @{
        Name = "dart trap"
        Char = '`'
        Base = $trap
    }

    # MAGIC 
    Magic = @{
        Name = "magic"
        Char = '*'
        IsMagic = $true
    }
    Potion = @{
        Name = "flask"
        Char = '!'
        IsPotion = $true
    }
    Scroll = @{
        Name = "paper"
        Char = '?'
        IsScroll = $true
    }
    Ring = @{
        Name = "ring"
        Char = '='
        IsRing = $true
    }
    Wand = @{
        Name = "stick"
        Char = '/'
        IsWand = $true
    }
    Amulet = @{
        Name = "jewelry"
        Char = ','
        IsAmulet = $true
    }

}