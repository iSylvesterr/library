-- Decompiled with Potassium's decompiler.

local Networking = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "networking", "out").Networking;

return {
    GlobalVisitorEvents = Networking.createEvent("shared/network/VisitorNetwork@GlobalVisitorEvents"),
    GlobalVisitorFunctions = Networking.createFunction("shared/network/VisitorNetwork@GlobalVisitorFunctions")
};