-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t;

return {
    NoticeEvents = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "network", "NoticeNetwork").GlobalNoticeEvents:createClient({}, {
        incomingIds = { "ShowNotice" },
        incoming = {
            ShowNotice = {
                { t.string },
                nil
            }
        },
        incomingUnreliable = {},
        outgoingIds = {},
        outgoingUnreliable = {},
        namespaceIds = {},
        namespaces = {}
    })
};