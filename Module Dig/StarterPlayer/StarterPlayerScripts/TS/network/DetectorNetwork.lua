-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "network", "DetectorNetwork");
local GlobalDetectorFunctions = v1.GlobalDetectorFunctions;

return {
    DetectorEvents = v1.GlobalDetectorEvents:createClient({}, {
        incomingIds = { "DetectorStateChanged", "DetectorChanged", "BuriedNodes" },
        incoming = {
            DetectorStateChanged = {
                { t.number, t.boolean },
                nil
            },
            DetectorChanged = {
                { t.number, t.literal(
                        "rusty",
                        "copper",
                        "silver",
                        "gold",
                        "platinum",
                        "onyx",
                        "sapphire",
                        "jade",
                        "topaz",
                        "crystal",
                        "none"
                    ) },
                nil
            },
            BuriedNodes = {
                { t.array(t.interface({
                        id = t.string,
                        position = t.Vector3,
                        rarity = t.literal("uncommon", "common", "rare", "epic", "legendary", "mythic", "divine", "eternal", "transcendent"),
                        itemSize = t.Vector3
                    })), t.array(t.string) },
                nil
            }
        },
        incomingUnreliable = {},
        outgoingIds = { "SetDetectorHeld" },
        outgoingUnreliable = {},
        namespaceIds = {},
        namespaces = {}
    }),
    DetectorFunctions = GlobalDetectorFunctions:createClient({}, {
        incomingIds = {},
        incoming = {},
        outgoingIds = { "GetDetectorStates" },
        outgoing = {
            GetDetectorStates = t.array(t.interface({
                userId = t.number,
                held = t.boolean,
                detectorId = t.literal(
                    "rusty",
                    "copper",
                    "silver",
                    "gold",
                    "platinum",
                    "onyx",
                    "sapphire",
                    "jade",
                    "topaz",
                    "crystal",
                    "none"
                )
            }))
        },
        namespaceIds = {},
        namespaces = {}
    })
};