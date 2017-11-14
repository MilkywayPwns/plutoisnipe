util.print("Starting up plutoisnipe by RektInator...")

function isSniperRifle(weapon)

    if string.match(weapon, "l96a1") or 
        string.match(weapon, "rsass") or 
        string.match(weapon, "msr") or 
        string.match(weapon, "barrett") or 
        string.match(weapon, "dragunov") or 
        string.match(weapon, "as50") or 
        string.match(weapon, "cheytac") then
        return true
    end

    return false

end

function onPlayerDamage(args)

    -- only allow sniperrifle kills
    if isSniperRifle(args.weapon) == false then
        args.damage = 0
    end

    -- restrict melee
    if args.mod == MeansOfDeath.Melee then
        args.damage = 0
    end

end

function antiHardscope()

    for player in util.iterPlayers() do
        local ads = player:playerads()
        local adscycles = player.data.adscycles or 0

        if ads == 1 then
            adscycles = adscycles + 1
        else
            adscycles = 0
        end

        if adscycles > 5 then
            if isSniperRifle(player:GetCurrentWeapon()) then
                player:allowads(false)
                player:iPrintLnBold("Hardscoping is not allowed.")
            end
        end

        if ads == 0 and player:adsButtonPressed() ~= 1 then
            player:allowads(true)
        end

        player.data.adscycles = adscycles
    end

end

function removeAmmo()

    for player in util.iterPlayers() do
        local offhand = player:getcurrentoffhand()
        player:setweaponammoclip(offhand, 0)
        player:setweaponammostock(offhand, 0)
    end

end

-- install callbacks
callbacks.playerDamage.add(onPlayerDamage)
callbacks.onInterval.add(50, antiHardscope)
callbacks.frame.add(removeAmmo)

util.print("Successfully loaded plutoisnipe.")
util.chatPrint("Plutonium iSnipe mod by RektInator started successfully.")
