-- Decompiled with Potassium's decompiler.

return {
    GOLD_PASS_NAME = "2x Gold",
    DIG_POWER_PASS_NAME = "2x Dig Power",
    WALK_SPEED_PASS_NAME = "2x Walkspeed",
    LUCK_PASS_NAME = "2x Luck",
    INSTANT_CLEAN_PASS_NAME = "Instant Clean",
    PASS_GOLD_MULTIPLIER = 2,
    PASS_DIG_POWER_MULTIPLIER = 2,
    PASS_WALK_SPEED_MULTIPLIER = 1.5,
    PASS_LUCK = 2,

    ownsPass = function(p1, p2) -- Line: 11, Name: ownsPass
        local v3 = p1 ~= nil and table.find(p1.Gamepasses, p2) ~= nil;

        return v3;
    end,

    goldMultiplierFor = function(p4) -- Line: 20, Name: goldMultiplierFor
        local v5 = p4 ~= nil and table.find(p4.Gamepasses, "2x Gold") ~= nil;

        return v5 and 2 or 1;
    end,

    digPowerMultiplierFor = function(p6) -- Line: 23, Name: digPowerMultiplierFor
        local v7 = p6 ~= nil and table.find(p6.Gamepasses, "2x Dig Power") ~= nil;

        return v7 and 2 or 1;
    end,

    walkSpeedMultiplierFor = function(p8) -- Line: 26, Name: walkSpeedMultiplierFor
        local v9 = p8 ~= nil and table.find(p8.Gamepasses, "2x Walkspeed") ~= nil;

        return v9 and 1.5 or 1;
    end,

    passLuckFor = function(p10) -- Line: 29, Name: passLuckFor
        local v11 = p10 ~= nil and table.find(p10.Gamepasses, "2x Luck") ~= nil;

        return v11 and 2 or 0;
    end
};