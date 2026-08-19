-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");

if not game:IsLoaded() then
    game.Loaded:Wait();
end;

task.spawn(function() -- Line: 13
    require(script.Parent:WaitForChild("PlayerModule"));
end);
local TagPackageLoader = require(ReplicatedStorage.Library.Loaders.TagPackageLoader);
task.spawn(function() -- Line: 21
    -- upvalues: TagPackageLoader (copy)
    TagPackageLoader.new("[Client]:[Ecosystem]:", { "SpawnInThread" }):Load();
end);