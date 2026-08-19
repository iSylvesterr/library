-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "network", "PolisherNetwork");
local GlobalPolisherEvents = v1.GlobalPolisherEvents;

return {
    PolisherFunctions = v1.GlobalPolisherFunctions:createClient({}, {
        incomingIds = {},
        incoming = {},
        outgoingIds = { "startPolish", "collectPolish", "upgradePolisher", "unlockPolisher" },
        outgoing = {
            startPolish = t.optional(t.literal("ok", "dirty", "maxed", "busy")),
            collectPolish = t.boolean,
            upgradePolisher = t.optional(t.literal("poor", "ok", "maxed")),
            unlockPolisher = t.optional(t.literal("poor", "ok", "owned"))
        },
        namespaceIds = {},
        namespaces = {}
    }),
    PolisherEvents = GlobalPolisherEvents:createClient(
        {},
        {
            incomingIds = {},
            incoming = {},
            incomingUnreliable = {},
            outgoingIds = { "setSkipPolishIntent" },
            outgoingUnreliable = {},
            namespaceIds = {},
            namespaces = {}
        }
    )
};