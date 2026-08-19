-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Environment = require(ReplicatedStorage.SharedModules.Environment);
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local u1 = FastFlags.Replicated("Game.Worlds.FallHarvestEvents", Asserts.Boolean, false);
local u3 = {
    WorldId = "FallHarvest",

    EnabledInWorld = function(p2) -- Line: 44, Name: EnabledInWorld
        -- upvalues: u1 (copy)
        return p2 ~= "FallHarvest" and true or u1:Get();
    end
};

function u3.EnabledHere() -- Line: 52
    -- upvalues: u3 (copy), Environment (copy)
    return u3.EnabledInWorld(Environment.worldId);
end;

return u3;