-- Decompiled with Potassium's decompiler.

local Networking = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "networking", "out").Networking;

return {
    GlobalItemsEvents = Networking.createEvent("shared/network/ItemsNetwork@GlobalItemsEvents"),
    GlobalItemsFunctions = Networking.createFunction("shared/network/ItemsNetwork@GlobalItemsFunctions")
};