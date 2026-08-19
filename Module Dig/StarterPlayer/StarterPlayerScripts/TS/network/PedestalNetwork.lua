-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t;

return {
    PedestalFunctions = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "network", "PedestalNetwork").GlobalPedestalFunctions:createClient({}, {
        incomingIds = {},
        incoming = {},
        outgoingIds = { "placeItem", "pickupItem" },
        outgoing = {
            placeItem = t.boolean,
            pickupItem = t.boolean
        },
        namespaceIds = {},
        namespaces = {}
    })
};