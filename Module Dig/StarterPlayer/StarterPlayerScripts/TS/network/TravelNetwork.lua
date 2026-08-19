-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t;

return {
    TravelFunctions = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "network", "TravelNetwork").GlobalTravelFunctions:createClient({}, {
        incomingIds = {},
        incoming = {},
        outgoingIds = { "getIslands", "travel" },
        outgoing = {
            getIslands = t.array(t.interface({
                id = t.literal("starterIsland", "island2"),
                name = t.string,
                spawn = t.CFrame,
                hub = t.CFrame,
                hasTravelNpc = t.boolean,
                hasGearNpc = t.boolean
            })),
            travel = t.optional(t.literal("poor", "ok"))
        },
        namespaceIds = {},
        namespaces = {}
    })
};