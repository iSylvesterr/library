-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "network", "VisitorNetwork");
local GlobalVisitorFunctions = v1.GlobalVisitorFunctions;

return {
    VisitorEvents = v1.GlobalVisitorEvents:createClient({}, {
        incomingIds = { "VisitStarted", "VisitCancelled", "VisitPaid" },
        incoming = {
            VisitStarted = {
                { t.interface({
                        visitId = t.number,
                        plotIndex = t.number,
                        slot = t.number,
                        startX = t.number,
                        startZ = t.number,
                        spread = t.number,
                        startTime = t.number,
                        dwell = t.number,
                        rich = t.boolean
                    }) },
                nil
            },
            VisitCancelled = {
                { t.number },
                nil
            },
            VisitPaid = {
                { t.number, t.number },
                nil
            }
        },
        incomingUnreliable = {},
        outgoingIds = {},
        outgoingUnreliable = {},
        namespaceIds = {},
        namespaces = {}
    }),
    VisitorFunctions = GlobalVisitorFunctions:createClient({}, {
        incomingIds = {},
        incoming = {},
        outgoingIds = { "requestCrowdState" },
        outgoing = {
            requestCrowdState = t.optional(t.interface({
                visits = t.array(t.interface({
                    visitId = t.number,
                    plotIndex = t.number,
                    slot = t.number,
                    startX = t.number,
                    startZ = t.number,
                    spread = t.number,
                    startTime = t.number,
                    dwell = t.number,
                    rich = t.boolean
                }))
            }))
        },
        namespaceIds = {},
        namespaces = {}
    })
};