-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.UserGenerated.Concurrency.Bindable);
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local v1 = FastFlags.Replicated("UserGenerated.ABTestDefaults", Asserts.Map(Asserts.String, Asserts.Any), {});

return table.freeze({
    UpdateRemote = script:WaitForChild("Update"),
    ABTestDefaults = v1
});