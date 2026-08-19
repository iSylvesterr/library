-- Decompiled with Potassium's decompiler.

local Players = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Players;

return {
    PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui"),
    Player = Players.LocalPlayer
};