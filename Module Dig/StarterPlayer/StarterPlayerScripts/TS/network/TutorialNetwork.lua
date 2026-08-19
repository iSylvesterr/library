-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "network", "TutorialNetwork");
local GlobalTutorialFunctions = v1.GlobalTutorialFunctions;

return {
    TutorialEvents = v1.GlobalTutorialEvents:createClient({}, {
        incomingIds = { "TutorialStepChanged", "TutorialTouristPaid" },
        incoming = {
            TutorialStepChanged = {
                { t.interface({
                        step = t.number,
                        itemUid = t.optional(t.string),
                        digSpot = t.optional(t.Vector3)
                    }) },
                nil
            },
            TutorialTouristPaid = {
                { t.number, t.number },
                nil
            }
        },
        incomingUnreliable = {},
        outgoingIds = { "ReportTutorialProgress" },
        outgoingUnreliable = {},
        namespaceIds = {},
        namespaces = {}
    }),
    TutorialFunctions = GlobalTutorialFunctions:createClient({}, {
        incomingIds = {},
        incoming = {},
        outgoingIds = { "GetTutorialState" },
        outgoing = {
            GetTutorialState = t.optional(t.interface({
                step = t.number,
                itemUid = t.optional(t.string),
                digSpot = t.optional(t.Vector3)
            }))
        },
        namespaceIds = {},
        namespaces = {}
    })
};