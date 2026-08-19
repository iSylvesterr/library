-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Worlds = require(ReplicatedStorage.SharedModules.Worlds);
local WerewolfFlags = require(ReplicatedStorage.SharedModules.Flags.WerewolfFlags);

return table.freeze({
    DefenderAttribute = "WerewolfNightDefender",
    DefenderIcon = "rbxassetid://99509831626783",

    IsEnabled = function() -- Line: 35, Name: IsEnabled
        -- upvalues: Worlds (copy), WerewolfFlags (copy)
        local v1 = Worlds.Current.Features.WerewolfNight and WerewolfFlags.Enabled:Get();

        return v1;
    end
});