-- Decompiled with Potassium's decompiler.

local Animation = require(script.Animation);
local TrackCache = require(script.TrackCache);
local FreezeAnim = require(script.FreezeAnim);
local u1 = {};
debug.setmemorycategory(script.Name .. "-内存检测");

function u1.PlayAnim(p2, p3, p4, p5, p6, p7, p8) -- Line: 164
    -- upvalues: TrackCache (copy)
    if not p2 then
        warn("Animator不存在");

        return nil;
    end;

    if not p2.Parent then
        return nil;
    end;

    local v9 = TrackCache.LoadAndConfigureTrack(p2, p3, p4 or 1, p5, p6, p7, true, p8 or 0);

    if v9 then
        return v9.Length;
    end;

    return nil;
end;

function u1.SetAnimationTimePosition(p10, p11, p12) -- Line: 207
    -- upvalues: TrackCache (copy)
    if not p10 or (not p11 or type(p12) ~= "number") then
        return false;
    end;

    local v13 = TrackCache.GetCachedTrack(p10, p11);

    if not v13 then
        return false;
    end;

    local Length = v13.Length;

    if type(Length) == "number" and Length > 0 then
        local v14 = math.max(0, Length - TrackCache.TIME_POSITION_EPSILON);
        p12 = math.clamp(p12, 0, v14);
    end;

    if not v13.IsPlaying then
        v13:Play(0);
    end;

    v13.TimePosition = p12;

    return true;
end;

function u1.LoadAnimationTrack(p15, p16, p17, p18, p19, p20, p21) -- Line: 241
    -- upvalues: TrackCache (copy)
    if p15 then
        if p15.Parent then
            return TrackCache.LoadAndConfigureTrack(p15, p16, p17 or 1, p18, p19, p20, false, p21 or 0);
        end;

        return nil;
    end;

    warn("Animator不存在");

    return nil;
end;

function u1.PlayAnimByModel(p22, p23, p24, p25, p26, p27, p28) -- Line: 282
    -- upvalues: TrackCache (copy), u1 (copy)
    local v29 = TrackCache.FindAnimatorFromModel(p22);

    if v29 then
        return u1.PlayAnim(v29, p23, p24, p25, p26, p27, p28);
    end;

    return nil;
end;

function u1.StopAnim(p30, p31, p32) -- Line: 312
    -- upvalues: TrackCache (copy)
    if not p30 then
        warn("Animator不存在");

        return;
    end;

    if not p30.Parent then
        return;
    end;

    if not TrackCache.HasAnimationConfig(p31) then
        return;
    end;

    local v33 = TrackCache.GetCachedTrack(p30, p31);

    if v33 then
        v33:Stop(p32 or 0);
    end;
end;

function u1.StopAnimByModel(p34, p35, p36) -- Line: 338
    -- upvalues: TrackCache (copy), u1 (copy)
    local v37 = TrackCache.FindAnimatorFromModel(p34);

    if v37 then
        u1.StopAnim(v37, p35, p36);
    end;
end;

function u1.ChangeAnimSpeed(p38, p39, p40) -- Line: 351
    -- upvalues: TrackCache (copy)
    if not p38 then
        warn("Animator不存在");

        return;
    end;

    if not p38.Parent then
        return;
    end;

    local v41 = p40 or 1;

    if not TrackCache.IsValidAnimationName(p39) then
        return;
    end;

    if not TrackCache.HasAnimationConfig(p39) then
        warn("未找到动画配置:", p39);

        return;
    end;

    local v42 = TrackCache.GetCachedTrack(p38, p39);

    if v42 then
        v42:AdjustSpeed(v41);
    end;
end;

function u1.StopAll(p43) -- Line: 381
    -- upvalues: TrackCache (copy)
    if not p43 then
        warn("Animator不存在");

        return;
    end;

    local v44 = TrackCache.GetAnimatorTrackCache(p43);

    if v44 then
        for _, v in pairs(v44) do
            v:Stop();
        end;
    end;
end;

function u1.BindEndFunc(p45, p46, p47) -- Line: 401
    -- upvalues: TrackCache (copy)
    if not p45 then
        warn("Animator不存在");

        return;
    end;

    if not p45.Parent then
        return;
    end;

    TrackCache.BindEndFunc(p45, p46, p47);
end;

function u1.GetCachedTrack(p48, p49) -- Line: 424
    -- upvalues: TrackCache (copy)
    if p48 and p49 then
        return TrackCache.GetCachedTrack(p48, p49);
    end;

    return nil;
end;

function u1.IsAnimPlaying(p50, p51) -- Line: 437
    -- upvalues: TrackCache (copy)
    if not p50 then
        warn("Animator不存在");

        return false;
    end;

    if not TrackCache.IsValidAnimationName(p51) then
        return false;
    end;

    if not TrackCache.HasAnimationConfig(p51) then
        warn("未找到动画配置:", p51);

        return false;
    end;

    local v52 = TrackCache.GetCachedTrack(p50, p51);

    if v52 then
        return v52.IsPlaying;
    end;

    return false;
end;

function u1.IsAnimsPlaying(p53, p54) -- Line: 465
    -- upvalues: u1 (copy)
    for _, v in ipairs(p54) do
        if u1.IsAnimPlaying(p53, v) then
            return true;
        end;
    end;

    return false;
end;

function u1.StopAnimByID(p55, p56) -- Line: 480
    -- upvalues: TrackCache (copy)
    if not p55 then
        warn("Animator不存在");

        return;
    end;

    local v57 = TrackCache.FormatAnimationAssetId(p56);

    for _, v in pairs(p55:GetPlayingAnimationTracks()) do
        if v.Animation.AnimationId == v57 then
            v:Stop();
        end;
    end;
end;

function u1.GetAnimID(p58) -- Line: 499
    -- upvalues: TrackCache (copy)
    local v59 = TrackCache.GetConfiguredAnimID(p58);

    if v59 then
        return v59;
    end;

    warn("未找到动画:", p58);

    return nil;
end;

function u1.GetPreloadTable() -- Line: 513
    -- upvalues: Animation (copy), TrackCache (copy)
    local v60 = {};

    for _, v in pairs(Animation) do
        if type(v) == "number" then
            table.insert(v60, TrackCache.RBX_ASSET_PREFIX .. v);
        end;
    end;

    return v60;
end;

function u1.FreezeAnimationAtTime(p61, p62, p63) -- Line: 535
    -- upvalues: FreezeAnim (copy)
    FreezeAnim.FreezeAnimationAtTime(p61, p62, p63);
end;

function u1.ResumeAnimation(p64, p65, p66) -- Line: 545
    -- upvalues: FreezeAnim (copy)
    FreezeAnim.ResumeAnimation(p64, p65, p66);
end;

function u1.FreezeAllAnimations(p67, p68) -- Line: 554
    -- upvalues: FreezeAnim (copy)
    FreezeAnim.FreezeAllAnimations(p67, p68);
end;

function u1.ResumeAllAnimations(p69) -- Line: 562
    -- upvalues: FreezeAnim (copy)
    FreezeAnim.ResumeAllAnimations(p69);
end;

local MoonAnimator = require(script.MoonAnimator);
u1.PlayMoonAnimator = MoonAnimator.PlayMoonAnimator;
u1.PlayMoonAnimatorWithCameraOffset = MoonAnimator.PlayMoonAnimatorWithCameraOffset;
u1.StopActiveMoonAnimator = MoonAnimator.StopActiveMoonAnimator;
u1.GetMoonAnimatorStartEndPositions = MoonAnimator.GetMoonAnimatorStartEndPositions;
u1.ChangeRootFolder = MoonAnimator.ChangeRootFolder;

return u1;