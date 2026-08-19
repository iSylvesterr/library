-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local v1 = FastFlags.Replicated("Game.MagicMail.Enabled", Asserts.Boolean, true);
local v2 = FastFlags.Replicated("Game.MagicMail.EscrowCap", Asserts.IntegerPositive, 50);
local v3 = FastFlags.Replicated("Game.MagicMail.MaxUnitsPerMail", Asserts.Map(Asserts.String, Asserts.IntegerPositive), {
    Seeds = 10
});

return table.freeze({
    Enabled = v1,
    EscrowCap = v2,
    MaxUnitsPerMail = v3
});