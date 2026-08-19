-- Decompiled with Potassium's decompiler.

local Networking = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "networking", "out").Networking;

return {
    GlobalMiscEvents = Networking.createEvent("shared/network/MiscNetwork@GlobalMiscEvents"),
    GlobalMiscFunctions = Networking.createFunction("shared/network/MiscNetwork@GlobalMiscFunctions")
};