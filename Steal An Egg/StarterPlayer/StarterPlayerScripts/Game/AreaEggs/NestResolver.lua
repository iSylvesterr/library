-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
require(ReplicatedStorage.Library.Types.AreaEggs);
local AreaEggSlotIdentity = require(ReplicatedStorage.Library.Util.AreaEggSlotIdentity);
local Asserts = require(ReplicatedStorage.Library.Asserts);
local __OBJECTS = Workspace.__OBJECTS;
local v1 = __OBJECTS:IsA("Folder");
assert(v1, "Workspace.__OBJECTS must be a Folder");
local Areas = __OBJECTS.Areas;
local v2 = Areas:IsA("Folder");
assert(v2, "Workspace.__OBJECTS.Areas must be a Folder");
local GuardAreas = Areas.GuardAreas;
local v3 = GuardAreas:IsA("Folder");
assert(v3, "Workspace.__OBJECTS.Areas.GuardAreas must be a Folder");

return {
    Resolve = function(p4) -- Line: 41, Name: Resolve
        -- upvalues: Asserts (copy), GuardAreas (copy), AreaEggSlotIdentity (copy)
        Asserts.string(p4.AreaId);
        Asserts.string(p4.NestId);
        local v5 = GuardAreas[p4.AreaId];
        local v6 = v5:IsA("Model");
        local v7 = `Guard area {p4.AreaId} must be a Model`;
        assert(v6, v7);

        return AreaEggSlotIdentity.ResolveNest(v5, p4.NestId);
    end
};