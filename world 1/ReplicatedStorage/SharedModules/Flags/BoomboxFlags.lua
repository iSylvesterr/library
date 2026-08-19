-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local BoomboxSounds = require(ReplicatedStorage.SharedModules.BoomboxSounds);
local u1 = FastFlags.Replicated("Game.Boombox.PlaybackDistance", Asserts.FinitePositive, 50);
local u2 = FastFlags.Replicated("Game.Boombox.BigDistanceMult", Asserts.FinitePositive, 1.5);
local u3 = FastFlags.Replicated("Game.Boombox.MegaDistanceMult", Asserts.FinitePositive, 2);
local u4 = FastFlags.Replicated("Game.Boombox.BigVolumeMult", Asserts.Range(0, 1), 0.75);
local u5 = FastFlags.Replicated("Game.Boombox.NormalVolumeMult", Asserts.Range(0, 1), 0.5);
local v6 = FastFlags.Replicated("Game.Boombox.MaxPlaced", Asserts.IntegerPositive, 5);
local v7 = FastFlags.Replicated("Game.Boombox.SoundChangeCooldown", Asserts.FinitePositive, 1);
local u8 = FastFlags.Replicated("Game.Boombox.DefaultSounds", Asserts.Array(Asserts.String), BoomboxSounds.GetPool());
local v9 = table.freeze({ "Boombox", "Big Boombox", "Mega Boombox" });
local u10 = table.freeze({
    Boombox = true,
    ["Big Boombox"] = true,
    ["Mega Boombox"] = true
});

return table.freeze({
    PlaybackDistance = u1,
    BigDistanceMult = u2,
    MegaDistanceMult = u3,
    BigVolumeMult = u4,
    NormalVolumeMult = u5,
    MaxPlaced = v6,
    SoundChangeCooldown = v7,
    DefaultSounds = u8,
    VariantNames = v9,

    IsVariant = function(p11) -- Line: 55, Name: IsVariant
        -- upvalues: u10 (copy)
        local v12;

        if typeof(p11) == "string" then
            v12 = u10[p11] == true;
        else
            v12 = false;
        end;

        return v12;
    end,

    PlaybackRadius = function(p13) -- Line: 60, Name: PlaybackRadius
        -- upvalues: u1 (copy), u2 (copy), u3 (copy)
        local v14 = u1:Get();

        if p13 == "Big Boombox" then
            return v14 * u2:Get();
        end;

        if p13 == "Mega Boombox" then
            return v14 * u3:Get();
        end;

        return v14;
    end,

    VolumeMult = function(p15) -- Line: 72, Name: VolumeMult
        -- upvalues: u4 (copy), u5 (copy)
        if p15 == "Big Boombox" then
            return u4:Get();
        end;

        return p15 == "Mega Boombox" and 1 or u5:Get();
    end,

    RandomSound = function() -- Line: 82, Name: RandomSound
        -- upvalues: u8 (copy)
        local v16 = u8:Get();

        return #v16 == 0 and "" or v16[math.random(#v16)];
    end
});