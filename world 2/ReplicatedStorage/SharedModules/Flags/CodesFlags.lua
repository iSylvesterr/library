-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local v1 = FastFlags.Private("Game.Codes.Disabled", Asserts.Boolean, false);
local v2 = Asserts.TablePermissive({
    Category = Asserts.String,
    ItemName = Asserts.Optional(Asserts.String),
    Count = Asserts.Optional(Asserts.FiniteNonNegative),
    Size = Asserts.Optional(Asserts.String),
    Type = Asserts.Optional(Asserts.String),
    Mutation = Asserts.Optional(Asserts.String)
});
local v3 = Asserts.TablePermissive({
    Enabled = Asserts.Optional(Asserts.Boolean),
    EndTimeUnixTimeStamp = Asserts.Optional(Asserts.Finite),
    Rewards = Asserts.Optional(Asserts.Array(v2))
});
local v4 = FastFlags.Private("Game.Codes.Config", Asserts.Map(Asserts.String, v3), {});

return table.freeze({
    Disabled = v1,
    Config = v4
});