$monster = @{
    IsMonster = $true
    CreatedAction = {$target.IsMonster = $true; $target.IsAlive = $true;}
    # ActivateAction = {Log "You attacked a $(EntityName $target)"}
    # BumpAction = {Log "You attacked a $(EntityName $target)"}
    # KilledAction = {Log "You killed a $(EntityName $target)"}
}

$itemGen.Player = @{
        Name = "rogue"
        Char = '@'
        Color = "Green"
        DamageDice = "1d12"
        ArmorClass = 7
        LOS2 = 256 # dist^2 ??
        FOV2 = 64  # lit
        KilledAction = {ShowTombStone $game.playerName (EntityName $args[1])}
        Base = $monster
    }
$itemGen.Dragon = @{
        Name = "dragon"
        Char = "D"
        Base = $monster
        DamageDice = "3d6+2" # ?
        Level = 10 # hpDice = Level * d8
        #HP = 50
        XP = 2500
    }
$itemGen.Kobold = @{
        Name = "kobold"
        Char = "K"
        AttackDice = "2d6" # ?
        DamageDice = "1d4+2" # dagger
        Level = 1 # hpDice = Level * d8
        #HP = 50
        XP = 25
        FOV2 = 64
        Base = $monster
    }

