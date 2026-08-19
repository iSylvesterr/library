-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "network", "PlotSectionNetwork");
local GlobalPlotSectionFunctions = v1.GlobalPlotSectionFunctions;

return {
    PlotSectionEvents = v1.GlobalPlotSectionEvents:createClient({}, {
        incomingIds = { "sectionUnlocked" },
        incoming = {
            sectionUnlocked = {
                { t.literal("Polishing") },
                nil
            }
        },
        incomingUnreliable = {},
        outgoingIds = {},
        outgoingUnreliable = {},
        namespaceIds = {},
        namespaces = {}
    }),
    PlotSectionFunctions = GlobalPlotSectionFunctions:createClient({}, {
        incomingIds = {},
        incoming = {},
        outgoingIds = { "unlockSection" },
        outgoing = {
            unlockSection = t.optional(t.literal("poor", "ok"))
        },
        namespaceIds = {},
        namespaces = {}
    })
};