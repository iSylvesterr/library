-- Decompiled with Potassium's decompiler.

local Networking = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "networking", "out").Networking;

return {
    GlobalPlotSectionFunctions = Networking.createFunction("shared/network/PlotSectionNetwork@GlobalPlotSectionFunctions"),
    GlobalPlotSectionEvents = Networking.createEvent("shared/network/PlotSectionNetwork@GlobalPlotSectionEvents")
};