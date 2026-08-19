-- Decompiled with Potassium's decompiler.

local NetChannel = require(script.Parent.NetChannel);
local NetMsg = require(script.Parent.NetMsg);

return {
    [NetMsg.RELEASE_GROUP_SKILL] = NetChannel.SKILL,
    [NetMsg.FIX_SKILL_TIME] = NetChannel.SKILL,
    [NetMsg.STOP_SKILL] = NetChannel.SKILL,
    [NetMsg.SYN_SKILL_EFFECT] = NetChannel.SKILL,
    [NetMsg.PLAYER_AIM_SAMPLE] = NetChannel.SKILL,
    [NetMsg.DAMAGE_TIP] = NetChannel.SKILL,
    [NetMsg.ELEMENT_ATTACH_TIP] = NetChannel.SKILL,
    [NetMsg.BIND_GROUP_SKILL] = NetChannel.SKILL,
    [NetMsg.UNBIND_GROUP_SKILL] = NetChannel.SKILL
};