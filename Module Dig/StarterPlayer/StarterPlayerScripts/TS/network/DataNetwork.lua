-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "network", "DataNetwork");
local GlobalDataFunctions = v1.GlobalDataFunctions;

return {
    DataEvents = v1.GlobalDataEvents:createClient({}, {
        incomingIds = { "DataPartialUpdate" },
        incoming = {
            DataPartialUpdate = {
                { t.number, t.array(t.string), t.map(t.string, t.union(t.any, t.none)) },
                nil
            }
        },
        incomingUnreliable = {},
        outgoingIds = {},
        outgoingUnreliable = {},
        namespaceIds = {},
        namespaces = {}
    }),
    DataFunctions = GlobalDataFunctions:createClient({}, {
        incomingIds = {},
        incoming = {},
        outgoingIds = { "requestDataUpdate" },
        outgoing = {
            requestDataUpdate = t.optional(t.map(t.string, t.union(t.any, t.none)))
        },
        namespaceIds = {},
        namespaces = {}
    })
};