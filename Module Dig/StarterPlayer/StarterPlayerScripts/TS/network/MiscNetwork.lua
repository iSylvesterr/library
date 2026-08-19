-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "network", "MiscNetwork");
local GlobalMiscFunctions = v1.GlobalMiscFunctions;

return {
    MiscEvents = v1.GlobalMiscEvents:createClient({}, {
        incomingIds = { "NotifyPlayer", "SetFlyEnabled", "SetPowerfulSpray", "SetRagdollEnabled", "SendServerMessage", "PlayGlobalAnnouncement", "PlaySound", "StopAnimation", "SendPlayerConfig", "SendPlotNumber" },
        incoming = {
            NotifyPlayer = {
                {
                    t.string,
                    t.number,
                    t.literal(
                        "Money Collect",
                        "Music",
                        "Notification",
                        "Click",
                        "Hover",
                        "Tick",
                        "Robux Prompt",
                        "Robux Purchase",
                        "Error",
                        "Pop",
                        "Purchase Success",
                        "Global Message",
                        "RevealFinish",
                        "RevealLift",
                        "RevealPop",
                        "RevealDiscovered",
                        "RevealDing",
                        "RevealMint",
                        "RevealLandLow",
                        "RevealLandMid",
                        "RevealLandHigh",
                        "ShovelImpact1",
                        "ShovelImpact2",
                        "ShovelImpact3",
                        "DirtThrow1",
                        "DirtThrow2",
                        "DirtThrow3",
                        "BeamGreen",
                        "BeamBlue",
                        "BeamPurple",
                        "BeamGold",
                        "BeamMythic",
                        "BeamDivine",
                        "BeamEternal",
                        "BeamTranscendent",
                        "DetectorBeep",
                        "None"
                    ),
                    t.union(t.Color3, t.literal(
                        "White",
                        "Black",
                        "Gray",
                        "Light Gray",
                        "Red",
                        "Light Red",
                        "Orange",
                        "Light Orange",
                        "Golden",
                        "Green",
                        "Light Green",
                        "Blue",
                        "Light Blue",
                        "Yellow",
                        "Light Yellow",
                        "Purple",
                        "Light Purple",
                        "Pink",
                        "Mythical",
                        "Godly",
                        "Common",
                        "Uncommon",
                        "Rare",
                        "Epic",
                        "Legendary",
                        "Mythic",
                        "Exotic",
                        "Secret",
                        "Divine",
                        "Exclusive",
                        "Admin"
                    ))
                },
                nil
            },
            SetFlyEnabled = {
                { t.boolean },
                nil
            },
            SetPowerfulSpray = {
                { t.boolean },
                nil
            },
            SetRagdollEnabled = {
                { t.boolean },
                nil
            },
            SendServerMessage = {
                {
                    t.string,
                    t.Color3,
                    t.optional(t.boolean),
                    t.optional(t.boolean)
                },
                nil
            },
            PlayGlobalAnnouncement = {
                { t.number, t.string },
                nil
            },
            PlaySound = {
                { t.literal(
                        "Money Collect",
                        "Music",
                        "Notification",
                        "Click",
                        "Hover",
                        "Tick",
                        "Robux Prompt",
                        "Robux Purchase",
                        "Error",
                        "Pop",
                        "Purchase Success",
                        "Global Message",
                        "RevealFinish",
                        "RevealLift",
                        "RevealPop",
                        "RevealDiscovered",
                        "RevealDing",
                        "RevealMint",
                        "RevealLandLow",
                        "RevealLandMid",
                        "RevealLandHigh",
                        "ShovelImpact1",
                        "ShovelImpact2",
                        "ShovelImpact3",
                        "DirtThrow1",
                        "DirtThrow2",
                        "DirtThrow3",
                        "BeamGreen",
                        "BeamBlue",
                        "BeamPurple",
                        "BeamGold",
                        "BeamMythic",
                        "BeamDivine",
                        "BeamEternal",
                        "BeamTranscendent",
                        "DetectorBeep"
                    ), t.optional(t.number) },
                nil
            },
            StopAnimation = { {}, nil },
            SendPlayerConfig = {
                { t.map(t.string, t.union(t.boolean, t.string, t.number)) },
                nil
            },
            SendPlotNumber = {
                { t.number },
                nil
            }
        },
        incomingUnreliable = {},
        outgoingIds = { "AntiAFK", "LogFunnel", "ReportLongFrame", "RequestTeleportHome", "MarkStarterOfferShown", "MarkShopOpened" },
        outgoingUnreliable = {},
        namespaceIds = {},
        namespaces = {}
    }),
    MiscFunctions = GlobalMiscFunctions:createClient({}, {
        incomingIds = {},
        incoming = {},
        outgoingIds = { "GetPlayerConfig", "RequestPlotNumber", "RequestAfkReturn" },
        outgoing = {
            GetPlayerConfig = t.optional(t.map(t.string, t.union(t.boolean, t.string, t.number))),
            RequestPlotNumber = t.optional(t.number),
            RequestAfkReturn = t.boolean
        },
        namespaceIds = {},
        namespaces = {}
    })
};