-- Decompiled with Potassium's decompiler.

local Networking = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "networking", "out").Networking;

return {
    GlobalDetectorEvents = Networking.createEvent("shared/network/DetectorNetwork@GlobalDetectorEvents"),
    GlobalDetectorFunctions = Networking.createFunction("shared/network/DetectorNetwork@GlobalDetectorFunctions")
};