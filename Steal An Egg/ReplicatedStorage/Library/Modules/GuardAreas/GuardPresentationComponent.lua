-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
require(ReplicatedStorage.Directory.Animations.Pipeline);
local Audio = require(ReplicatedStorage.Library.Audio);
local CreateConfiguredSound = require(ReplicatedStorage.Library.Audio.CreateConfiguredSound);
local Interface = require(ReplicatedStorage.Directory.Guards.Types.Interface);
local u1 = {};
u1.__index = u1;
u1.__class = "GuardPresentationComponent";

function u1.new(p2, p3, p4) -- Line: 46
    -- upvalues: Asserts (copy), u1 (copy), CreateConfiguredSound (copy)
    Asserts.BasePart(p2);
    Asserts.Instance(p3);
    Asserts.table(p4);
    local v5 = setmetatable({}, u1);
    v5._afterWakeSoundConfigs = u1.NormalizeAfterWakeSoundConfigs(p4.AfterWakeSound);
    local v6;

    if #v5._afterWakeSoundConfigs > 0 then
        v6 = CreateConfiguredSound(p2, u1.CreateSoundFile(v5._afterWakeSoundConfigs[1]), "AfterWakeSound");
    else
        v6 = nil;
    end;

    v5._afterWakeSound = v6;
    v5._afterWakeSoundAt = nil;
    v5._animationBaseWalkSpeed = p4.AnimationBaseWalkSpeed or 7;
    local v7 = v5._animationBaseWalkSpeed > 0;
    local v8 = `Guard {p4._id} animation base WalkSpeed must be greater than zero`;
    assert(v7, v8);
    local v9;

    if p4.FootstepSound == nil then
        v9 = nil;
    else
        v9 = CreateConfiguredSound(p2, u1.CreateSoundFile(p4.FootstepSound), "FootstepSound");
    end;

    v5._footstepSound = v9;
    v5._footstepPlaybackSpeed = p4.FootstepSound ~= nil and (p4.FootstepSound.PlaybackSpeed or 1) or nil;
    v5._hitSound = CreateConfiguredSound(p2, u1.CreateSoundFile(p4.AttackSound), "Hit");
    v5._hitTrack = u1.LoadTrack(p3, p4.AttackAnimation);
    v5._hitTrack.Priority = Enum.AnimationPriority.Action4;
    v5._idleTrack = u1.LoadTrack(p3, p4.IdleAnimation);
    v5._sleepSound = CreateConfiguredSound(p2, u1.CreateSoundFile(p4.SleepSound), "SleepSound");
    v5._sleepTrack = u1.LoadTrack(p3, p4.SleepAnimation);
    v5._random = Random.new();
    v5._wakeSound = CreateConfiguredSound(p2, u1.CreateSoundFile(p4.WakeSound), "Detected");
    v5._walkTrack = u1.LoadTrack(p3, p4.WalkAnimation);

    return v5;
end;

function u1.CreateSoundFile(p10) -- Line: 93
    return {
        SoundId = p10.SoundIds or p10.SoundId,
        Data = {
            Speed = p10.PlaybackSpeed,
            Volume = p10.Volume,
            MaxDistance = p10.MaxDistance,
            Looped = p10.Looped
        }
    };
end;

function u1.NormalizeAfterWakeSoundConfigs(p11) -- Line: 105
    -- upvalues: Interface (copy)
    if p11 == nil then
        return {};
    end;

    if Interface.SoundConfig(p11) then
        return { p11 };
    end;

    assert(#p11 > 0, "AfterWakeSound config array must not be empty");

    return p11;
end;

function u1.LoadTrack(p12, p13) -- Line: 120
    local v14 = p12:LoadAnimation(p13.anim);
    v14.Looped = p13.looped == true;
    local v15 = p13.protocol and p13.protocol.Play;

    if v15 and v15[2] then
        v14:AdjustWeight(v15[2]);
    end;

    return v14;
end;

function u1.Destroy(p16) -- Line: 137
    p16._afterWakeSoundAt = nil;
    p16:StopWalkAnimation();
    p16:StopIdleAnimation();
    p16:StopFootstepSound();
    p16._sleepTrack:Stop(0.1);
    p16._hitTrack:Stop(0.1);

    if p16._footstepSound ~= nil then
        p16._footstepSound:Destroy();
    end;

    if p16._afterWakeSound ~= nil then
        p16._afterWakeSound:Destroy();
    end;

    p16._hitSound:Destroy();
    p16._sleepSound:Destroy();
    p16._wakeSound:Destroy();
end;

function u1.PlaySleep(p17, p18) -- Line: 155
    -- upvalues: Asserts (copy)
    Asserts.number(p18);

    if not p17._sleepTrack.IsPlaying then
        p17._sleepTrack:Play(p18);
    end;

    if not p17._sleepSound.IsPlaying then
        p17._sleepSound.Looped = true;
        p17._sleepSound.TimePosition = 0;
        p17._sleepSound:Play();
    end;
end;

function u1.StopSleep(p19, p20) -- Line: 167
    -- upvalues: Asserts (copy)
    Asserts.number(p20);
    p19._sleepTrack:Stop(p20);
    p19._sleepSound:Stop();
end;

function u1.PlayWake(p21) -- Line: 173
    p21._wakeSound.TimePosition = 0;
    p21._wakeSound:Play();
end;

function u1.PlayAfterWake(p22) -- Line: 178
    -- upvalues: Audio (copy), u1 (copy)
    local _afterWakeSound = p22._afterWakeSound;

    if _afterWakeSound == nil then
        return;
    end;

    local v23 = p22._afterWakeSoundConfigs[p22._random:NextInteger(1, #p22._afterWakeSoundConfigs)];
    assert(v23 ~= nil, "AfterWakeSound playback requires a configured sound");
    _afterWakeSound:Stop();
    Audio.PrepareSoundFromSoundFile(_afterWakeSound, u1.CreateSoundFile(v23));
    _afterWakeSound.TimePosition = 0;
    _afterWakeSound:Play();
end;

function u1.ScheduleAfterWake(p24, p25) -- Line: 191
    -- upvalues: Asserts (copy)
    Asserts.number(p25);

    if p24._afterWakeSound ~= nil then
        p24._afterWakeSoundAt = p25 + 1;
    end;
end;

function u1.CancelAfterWake(p26) -- Line: 198
    p26._afterWakeSoundAt = nil;
end;

function u1.UpdateAfterWake(p27, p28, p29) -- Line: 202
    -- upvalues: Asserts (copy)
    Asserts.number(p28);
    Asserts.boolean(p29);
    local _afterWakeSoundAt = p27._afterWakeSoundAt;

    if _afterWakeSoundAt == nil or p28 < _afterWakeSoundAt then
        return;
    end;

    p27._afterWakeSoundAt = nil;

    if p29 then
        p27:PlayAfterWake();
    end;
end;

function u1.PlayHit(p30) -- Line: 221
    p30:StopWalkAnimation();
    p30:StopFootstepSound();
    p30:EnsureIdleAnimation();
    p30._hitTrack.TimePosition = 0;
    p30._hitTrack:Play(0.05);
    p30._hitSound.TimePosition = 0;
    p30._hitSound:Play();

    return p30._hitTrack.Length;
end;

function u1.EnsureFootstepSound(p31, p32) -- Line: 232
    -- upvalues: Asserts (copy)
    Asserts.number(p32);
    local _footstepSound = p31._footstepSound;
    local _footstepPlaybackSpeed = p31._footstepPlaybackSpeed;

    if _footstepSound == nil or _footstepPlaybackSpeed == nil then
        return;
    end;

    _footstepSound.PlaybackSpeed = _footstepPlaybackSpeed * math.max(p32 / p31._animationBaseWalkSpeed, 0.01);

    if not _footstepSound.IsPlaying then
        _footstepSound.Looped = true;
        _footstepSound.TimePosition = 0;
        _footstepSound:Play();
    end;
end;

function u1.StopFootstepSound(p33) -- Line: 247
    local _footstepSound = p33._footstepSound;

    if _footstepSound ~= nil and _footstepSound.IsPlaying then
        _footstepSound:Stop();
    end;
end;

function u1.EnsureIdleAnimation(p34) -- Line: 254
    if not p34._idleTrack.IsPlaying then
        p34._idleTrack:Play(0.2);
    end;
end;

function u1.StopIdleAnimation(p35) -- Line: 260
    if p35._idleTrack.IsPlaying then
        p35._idleTrack:Stop(0.2);
    end;
end;

function u1.EnsureWalkAnimation(p36, p37) -- Line: 266
    -- upvalues: Asserts (copy)
    Asserts.number(p37);
    p36:StopIdleAnimation();
    p36:EnsureFootstepSound(p37);
    p36._walkTrack:AdjustSpeed((math.max(p37 / p36._animationBaseWalkSpeed, 0.01)));

    if not p36._walkTrack.IsPlaying then
        p36._walkTrack:Play(0.4);
    end;
end;

function u1.StopWalkAnimation(p38) -- Line: 276
    if p38._walkTrack.IsPlaying then
        p38._walkTrack:Stop(0.2);
    end;
end;

return u1;