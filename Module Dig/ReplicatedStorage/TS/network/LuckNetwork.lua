-- Decompiled with Potassium's decompiler.

local Networking = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "networking", "out").Networking;

return {
    GlobalLuckEvents = Networking.createEvent("shared/network/LuckNetwork@GlobalLuckEvents"),
    GlobalLuckFunctions = Networking.createFunction("shared/network/LuckNetwork@GlobalLuckFunctions")
};