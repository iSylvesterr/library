-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local NetMsg = UtilsSystem.NetMsg;
local NetWork = UtilsSystem.NetWork;
local SoundInstance = UtilsSystem.SoundInstance;

local function _normalizeStopData(p1, p2) -- Line: 24
    return type(p1) ~= "table" and {
        SoundName = p1,
        FadeTime = p2
    } or p1;
end;

local function _playSound(p3) -- Line: 38
    -- upvalues: SoundInstance (copy)
    local v4 = SoundInstance:new(p3);

    if v4 then
        v4:playSound();

        return;
    end;

    warn("SoundInstance 未找到，无法播放音效");
end;

local function _stopSound(p5) -- Line: 51
    -- upvalues: SoundInstance (copy)
    local v6 = type(p5) ~= "table" and {
        FadeTime = nil,
        SoundName = p5
    } or p5;
    local SoundName = v6.SoundName;
    local FadeTime = v6.FadeTime;
    local DestroyAfter = v6.DestroyAfter;
    local v7 = SoundInstance:GetSoundByTag(v6.SoundTag);

    if v7 then
        v7:stopSound(FadeTime, DestroyAfter);

        return;
    end;

    if not SoundName then
        return;
    end;

    for _, v in SoundInstance:GetSoundByName(SoundName) do
        v:stopSound(FadeTime, DestroyAfter);
    end;
end;

local function onStopSound(p8, p9, p10) -- Line: 80
    -- upvalues: _stopSound (copy)
    _stopSound(type(p8) ~= "table" and {
        SoundName = p8,
        FadeTime = p10
    } or p8);
end;

NetWork.RegisterClientRemoteEvent(NetMsg.PLAY_SOUND, _playSound);
NetWork.RegisterBindableEvent(NetMsg.PLAY_SOUND, _playSound);
NetWork.RegisterClientRemoteEvent(NetMsg.STOP_SOUND, onStopSound);
NetWork.RegisterBindableEvent(NetMsg.STOP_SOUND, onStopSound);