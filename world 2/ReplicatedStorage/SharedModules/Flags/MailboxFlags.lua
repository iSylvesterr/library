-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local v1 = FastFlags.Replicated("Game.Mailbox.OpenEnabled", Asserts.Boolean, true);
local v2 = FastFlags.Replicated("Game.Mailbox.StreaksEnabled", Asserts.Boolean, true);
local v3 = FastFlags.Replicated("Game.Mailbox.StreakAtRiskWindowSeconds", Asserts.IntegerPositive, 10800);
local v4 = FastFlags.Replicated("Game.Mailbox.ReplyWindowSeconds", Asserts.IntegerPositive, 3600);
local v5 = FastFlags.Replicated("Game.Mailbox.Capacity", Asserts.IntegerPositive, 100);

return table.freeze({
    OpenEnabled = v1,
    StreaksEnabled = v2,
    StreakAtRiskWindowSeconds = v3,
    ReplyWindowSeconds = v4,
    Capacity = v5
});