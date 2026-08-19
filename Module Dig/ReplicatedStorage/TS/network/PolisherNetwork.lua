-- Decompiled with Potassium's decompiler.

local Networking = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "networking", "out").Networking;

return {
    GlobalPolisherFunctions = Networking.createFunction("shared/network/PolisherNetwork@GlobalPolisherFunctions"),
    GlobalPolisherEvents = Networking.createEvent("shared/network/PolisherNetwork@GlobalPolisherEvents")
};