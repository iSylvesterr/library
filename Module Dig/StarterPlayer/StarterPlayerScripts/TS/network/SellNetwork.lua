-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t;

return {
    SellFunctions = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "network", "SellNetwork").GlobalSellFunctions:createClient({}, {
        incomingIds = {},
        incoming = {},
        outgoingIds = { "sellHeldItem", "sellInventory" },
        outgoing = {
            sellHeldItem = t.optional(t.number),
            sellInventory = t.optional(t.number)
        },
        namespaceIds = {},
        namespaces = {}
    })
};