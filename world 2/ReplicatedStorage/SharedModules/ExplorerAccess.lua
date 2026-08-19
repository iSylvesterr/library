-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Environment = require(ReplicatedStorage.SharedModules.Environment);
local ExplorerFlags = require(ReplicatedStorage.SharedModules.Flags.ExplorerFlags);
local Worlds = require(ReplicatedStorage.SharedModules.Worlds);

return {
    OverrideAttribute = "ExplorerStandOverride",

    IsAvailable = function() -- Line: 29, Name: IsAvailable
        -- upvalues: Worlds (copy), Environment (copy), ExplorerFlags (copy)
        if not Worlds.Current.Features.Explorer then
            return false;
        end;

        if Environment.isBotContainmentPlace then
            return false;
        end;

        local v1 = workspace:GetAttribute("ExplorerStandOverride");

        if v1 == "on" then
            return true;
        end;

        if v1 == "off" then
            return false;
        end;

        return ExplorerFlags.Enabled:Get();
    end
};