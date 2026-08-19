-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local v1 = FastFlags.Replicated("Game.Explorer.Enabled", Asserts.Boolean, true);
local v2 = FastFlags.Replicated("Game.Explorer.TravelMenuEnabled", Asserts.Boolean, false);
local v3 = FastFlags.Replicated("Game.Explorer.MailboxPromptEnabled", Asserts.Boolean, true);
local v4 = FastFlags.Replicated("Game.Explorer.ReleaseAtUnix", Asserts.FinitePositive, 1785621600);
local v5 = FastFlags.Replicated("Game.Explorer.CloseAfterSeconds", Asserts.FinitePositive, 5184000);

return table.freeze({
    Enabled = v1,
    TravelMenuEnabled = v2,
    MailboxPromptEnabled = v3,
    ReleaseAtUnix = v4,
    CloseAfterSeconds = v5
});