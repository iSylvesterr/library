-- Decompiled with Potassium's decompiler.

local NetChannel = require(script.Parent.NetChannel);

return {
    channels = {
        [NetChannel.DEFAULT] = {
            RemoteEvent = "NetWorkRemoteEvent",
            RemoteFunction = "NetWorkRemoteFunction",
            BindableEvent = "NetWorkEvent",
            BindableFunction = "NetWorkBindableFunction"
        },
        [NetChannel.SKILL] = {
            RemoteEvent = "NetWorkRemoteEvent_Skill",
            BindableEvent = "NetWorkEvent_Skill"
        }
    }
};