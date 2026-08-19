-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "network", "LuckNetwork");
local GlobalLuckFunctions = v1.GlobalLuckFunctions;

return {
    LuckEvents = v1.GlobalLuckEvents:createClient({}, {
        incomingIds = { "ServerLuckChanged" },
        incoming = {
            ServerLuckChanged = {
                { t.optional(t.interface({
                        multiplier = t.number,
                        expiresAt = t.number
                    })) },
                nil
            }
        },
        incomingUnreliable = {},
        outgoingIds = {},
        outgoingUnreliable = {},
        namespaceIds = {},
        namespaces = {}
    }),
    LuckFunctions = GlobalLuckFunctions:createClient({}, {
        incomingIds = {},
        incoming = {},
        outgoingIds = { "getServerLuck" },
        outgoing = {
            getServerLuck = t.optional(t.interface({
                multiplier = t.number,
                expiresAt = t.number
            }))
        },
        namespaceIds = {},
        namespaces = {}
    })
};