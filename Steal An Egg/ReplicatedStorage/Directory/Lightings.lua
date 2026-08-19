-- Decompiled with Potassium's decompiler.

local Lighting = game:GetService("Lighting");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local MakeTableStrict = require(ReplicatedStorage.Library.Functions.MakeTableStrict);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local LightingsCore = require(ReplicatedStorage.Library.Client.LightingsCore);
require(ReplicatedStorage.Library.Functions.DeepCopyUnsafe);
local Interface = require(script.Types.Interface);
local v1 = {};
local v2 = {};
v1.Directory = v2;
v1.Types = Interface;
v2.Default = LightingsCore.Serialize(Lighting);
v2.Default.Clouds = LightingsCore.SerializeClouds(Workspace.Terrain.Clouds);

if Constants.IS_STUDIO then
    for i, v in pairs(v2) do
        local v3, v4 = Interface.LightingConfig(v);
        local v5 = `Invalid lighting config "{i}": {v4}`;
        assert(v3, v5);
    end;
end;

MakeTableStrict(v2, "Lightings.Directory");

return v1;