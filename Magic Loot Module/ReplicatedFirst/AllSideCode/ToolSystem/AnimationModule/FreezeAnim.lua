-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local Animation = require(script.Parent.Animation);
local AnimationState = require(script.Parent.AnimationState);
local TrackCache = require(script.Parent.TrackCache);
local v1 = {};

local function _disconnectTimeUpdate(p2, p3) -- Line: 22
    -- upvalues: AnimationState (copy)
    if AnimationState.animationTimeUpdateConnections[p2] and AnimationState.animationTimeUpdateConnections[p2][p3] then
        AnimationState.animationTimeUpdateConnections[p2][p3]:Disconnect();
        AnimationState.animationTimeUpdateConnections[p2][p3] = nil;
    end;
end;

local function _connectFreezeTimeUpdate(p4, p5, u6, u7) -- Line: 36
    -- upvalues: AnimationState (copy), RunService (copy)
    if AnimationState.animationTimeUpdateConnections[p4] and AnimationState.animationTimeUpdateConnections[p4][p5] then
        AnimationState.animationTimeUpdateConnections[p4][p5]:Disconnect();
        AnimationState.animationTimeUpdateConnections[p4][p5] = nil;
    end;

    if not AnimationState.animationTimeUpdateConnections[p4] then
        AnimationState.animationTimeUpdateConnections[p4] = {};
    end;

    if not u6.IsPlaying then
        u6:Play();
    end;

    u6:AdjustSpeed(0);
    local TimePosition = u6.TimePosition;
    local u8 = 0;
    AnimationState.animationTimeUpdateConnections[p4][p5] = RunService.Heartbeat:Connect(function(p9) -- Line: 57
        -- upvalues: u8 (ref), u7 (copy), TimePosition (ref), u6 (copy)
        u8 = u8 + p9;

        if u7 <= u8 then
            TimePosition = TimePosition + u8;

            if TimePosition > u6.Length then
                TimePosition = TimePosition % u6.Length;
            end;

            u6.TimePosition = TimePosition;
            u8 = 0;
        end;
    end);
end;

function v1.FreezeAnimationAtTime(p10, p11, p12) -- Line: 79
    -- upvalues: TrackCache (copy), Animation (copy), _connectFreezeTimeUpdate (copy)
    if not p10 then
        warn("Animator不存在");

        return;
    end;

    if not p10.Parent then
        return;
    end;

    if not TrackCache.IsValidAnimationName(p11) then
        return;
    end;

    if not Animation[p11] then
        warn("未找到动画配置:", p11);

        return;
    end;

    if not p12 or p12 <= 0 then
        warn("更新时间间隔必须大于0");

        return;
    end;

    local v13 = TrackCache.GetCachedTrack(p10, p11);

    if v13 then
        _connectFreezeTimeUpdate(p10, p11, v13, p12);

        return;
    end;

    warn("动画轨道不存在，请先播放动画:", p11);
end;

function v1.ResumeAnimation(p14, p15, p16) -- Line: 117
    -- upvalues: TrackCache (copy), Animation (copy), AnimationState (copy)
    if not p14 then
        warn("Animator不存在");

        return;
    end;

    if not p14.Parent then
        return;
    end;

    if not TrackCache.IsValidAnimationName(p15) then
        return;
    end;

    if not Animation[p15] then
        warn("未找到动画配置:", p15);

        return;
    end;

    if AnimationState.animationTimeUpdateConnections[p14] and AnimationState.animationTimeUpdateConnections[p14][p15] then
        AnimationState.animationTimeUpdateConnections[p14][p15]:Disconnect();
        AnimationState.animationTimeUpdateConnections[p14][p15] = nil;
    end;

    local v17 = TrackCache.GetCachedTrack(p14, p15);

    if not v17 then
        warn("动画轨道不存在:", p15);

        return;
    end;

    v17:AdjustSpeed(p16 or 1);

    if not v17.IsPlaying then
        v17:Play();
    end;
end;

function v1.FreezeAllAnimations(p18, p19) -- Line: 155
    -- upvalues: AnimationState (copy), TrackCache (copy), _connectFreezeTimeUpdate (copy)
    if not p18 then
        warn("Animator不存在");

        return;
    end;

    if not p18.Parent then
        return;
    end;

    if not p19 or p19 <= 0 then
        warn("更新时间间隔必须大于0");

        return;
    end;

    if not AnimationState.animationOriginalSpeedCache[p18] then
        AnimationState.animationOriginalSpeedCache[p18] = {};
    end;

    local v20 = TrackCache.GetAnimatorTrackCache(p18);

    if v20 then
        for i, v in pairs(v20) do
            if v.IsPlaying then
                AnimationState.animationOriginalSpeedCache[p18][i] = v.Speed;
                _connectFreezeTimeUpdate(p18, i, v, p19);
            end;
        end;
    end;
end;

function v1.ResumeAllAnimations(p21) -- Line: 189
    -- upvalues: TrackCache (copy), AnimationState (copy)
    if not p21 then
        warn("Animator不存在");

        return;
    end;

    if not p21.Parent then
        return;
    end;

    local v22 = TrackCache.GetAnimatorTrackCache(p21);

    if v22 then
        for i, v in pairs(v22) do
            if AnimationState.animationTimeUpdateConnections[p21] and AnimationState.animationTimeUpdateConnections[p21][i] then
                AnimationState.animationTimeUpdateConnections[p21][i]:Disconnect();
                AnimationState.animationTimeUpdateConnections[p21][i] = nil;
            end;

            if AnimationState.animationOriginalSpeedCache[p21] and AnimationState.animationOriginalSpeedCache[p21][i] then
                v:AdjustSpeed(AnimationState.animationOriginalSpeedCache[p21][i]);
                AnimationState.animationOriginalSpeedCache[p21][i] = nil;
            else
                v:AdjustSpeed(1);
            end;

            if not v.IsPlaying then
                v:Play();
            end;
        end;
    end;
end;

return v1;