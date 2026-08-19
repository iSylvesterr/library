-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "network", "ShopNetwork");
local GlobalShopFunctions = v1.GlobalShopFunctions;

return {
    ShopEvents = v1.GlobalShopEvents:createClient(
        {},
        {
            incomingIds = {},
            incoming = {},
            incomingUnreliable = {},
            outgoingIds = { "setGearPurchaseIntent" },
            outgoingUnreliable = {},
            namespaceIds = {},
            namespaces = {}
        }
    ),
    ShopFunctions = GlobalShopFunctions:createClient({}, {
        incomingIds = {},
        incoming = {},
        outgoingIds = { "buyGear", "equipGear" },
        outgoing = {
            buyGear = t.boolean,
            equipGear = t.boolean
        },
        namespaceIds = {},
        namespaces = {}
    })
};