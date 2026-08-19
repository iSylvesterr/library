-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "network", "ItemsNetwork");
local GlobalItemsFunctions = v1.GlobalItemsFunctions;

return {
    ItemsEvents = v1.GlobalItemsEvents:createClient({}, {
        incomingIds = { "instantCleaned", "recoveryOffered", "recoveryGranted" },
        incoming = {
            instantCleaned = {
                { t.string },
                nil
            },
            recoveryOffered = {
                { t.number, t.literal("rare", "epic", "legendary", "mythic", "divine", "eternal", "transcendent") },
                nil
            },
            recoveryGranted = { {}, nil }
        },
        incomingUnreliable = {},
        outgoingIds = { "finishCleaning", "cancelCleaning", "saveCleanProgress", "requestSkipClean", "markSprayUpgradeHintSeen" },
        outgoingUnreliable = {},
        namespaceIds = {},
        namespaces = {}
    }),
    ItemsFunctions = GlobalItemsFunctions:createClient({}, {
        incomingIds = {},
        incoming = {},
        outgoingIds = { "beginCleaning" },
        outgoing = {
            beginCleaning = t.optional(t.interface({
                condition = t.literal("ok", "poor", "good", "great", "perfect", "mint"),
                kg = t.number,
                oneIn = t.number,
                value = t.number,
                isNew = t.boolean
            }))
        },
        namespaceIds = {},
        namespaces = {}
    })
};