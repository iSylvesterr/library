-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local u1 = FastFlags.Replicated("Game.Steal.Bamboo.Stealable", Asserts.Boolean, true);
local u2 = FastFlags.Replicated("Game.Steal.Bamboo.StealDurationSeconds", Asserts.FinitePositive, 3);
local u3 = FastFlags.Replicated("Game.Steal.Mushroom.Stealable", Asserts.Boolean, true);
local u4 = FastFlags.Replicated("Game.Steal.Mushroom.StealDurationSeconds", Asserts.FinitePositive, 3);
local u5 = FastFlags.Replicated("Game.Steal.HypnoBloom.Stealable", Asserts.Boolean, true);
local u6 = FastFlags.Replicated("Game.Steal.HypnoBloom.StealDurationSeconds", Asserts.FinitePositive, 3);
local u7 = FastFlags.Replicated("Game.Steal.RocketPop.Stealable", Asserts.Boolean, true);
local u8 = FastFlags.Replicated("Game.Steal.RocketPop.StealDurationSeconds", Asserts.FinitePositive, 3);

return table.freeze({
    BambooStealable = u1,
    BambooStealDuration = u2,
    MushroomStealable = u3,
    MushroomStealDuration = u4,
    HypnoBloomStealable = u5,
    HypnoBloomStealDuration = u6,
    RocketPopStealable = u7,
    RocketPopStealDuration = u8,

    GetStealHoldDuration = function(p9) -- Line: 34, Name: GetStealHoldDuration
        -- upvalues: u2 (copy), u4 (copy), u6 (copy), u8 (copy)
        if p9 == "Bamboo" then
            return u2:Get();
        end;

        if p9 == "Mushroom" then
            return u4:Get();
        end;

        if p9 == "Hypno Bloom" then
            return u6:Get();
        end;

        return p9 ~= "Rocket Pop" and 0 or u8:Get();
    end,

    IsPlantStealable = function(p10) -- Line: 42, Name: IsPlantStealable
        -- upvalues: u1 (copy), u3 (copy), u5 (copy), u7 (copy)
        if p10 == "Bamboo" then
            return u1:Get();
        end;

        if p10 == "Mushroom" then
            return u3:Get();
        end;

        if p10 == "Hypno Bloom" then
            return u5:Get();
        end;

        return p10 ~= "Rocket Pop" and true or u7:Get();
    end
});