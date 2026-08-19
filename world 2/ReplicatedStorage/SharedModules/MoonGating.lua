-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local u1 = {
    ["Mega Moon"] = true,
    ["Harvest Moon"] = true
};
local u2 = FastFlags.Replicated("Game.Moons.NaturalSpawnEnabled", Asserts.Map(Asserts.String, Asserts.Boolean), {});

return table.freeze({
    IsNaturallySpawnable = function(p3) -- Line: 40, Name: IsNaturallySpawnable
        -- upvalues: u1 (copy), u2 (copy)
        return not u1[p3] and true or u2:Get()[p3] == true;
    end
});