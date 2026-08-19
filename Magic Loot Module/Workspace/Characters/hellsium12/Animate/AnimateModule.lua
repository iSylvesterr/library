-- Decompiled with Potassium's decompiler.

require(game.ReplicatedFirst.AllSideCode.Class.Class);
local u1 = {};
u1.__index = u1;
local u2 = {
    StartRun = true,
    StopRun = true,
    StartWalk = true,
    StopWalk = true
};

local function _isTransitionPose(p3) -- Line: 45
    -- upvalues: u2 (copy)
    return u2[p3] == true;
end;

local function _disconnectMarkerConnections(p4) -- Line: 49
    local MarkerConnections = p4.MarkerConnections;

    if not MarkerConnections then
        return;
    end;

    for _, v in ipairs(MarkerConnections) do
        v:Disconnect();
    end;

    p4.MarkerConnections = nil;
end;

local function _syncMarkerConnections(u5, p6, p7) -- Line: 64
    local MarkerConnections = p7.MarkerConnections;

    if MarkerConnections then
        for _, v in ipairs(MarkerConnections) do
            v:Disconnect();
        end;

        p7.MarkerConnections = nil;
    end;

    if p6 == nil then
        return;
    end;

    local v8 = {};

    for i, v in pairs(p6) do
        if type(v) == "function" then
            local success, result = pcall(function() -- Line: 77
                -- upvalues: u5 (copy), i (copy)
                return u5:GetMarkerReachedSignal(i);
            end);

            if success and result then
                table.insert(v8, result:Connect(v));
            end;
        end;
    end;

    if #v8 > 0 then
        p7.MarkerConnections = v8;
    end;
end;

local function _stopBaseAction(p9, p10) -- Line: 94
    if p9.CurrentBaseTrack then
        p9.CurrentBaseTrack:Stop(p10 or 0.1);
    end;
end;

local function _playBaseAction(p11, p12) -- Line: 104
    if p11.BaseActionEnabled and p11.CurrentBaseTrack then
        p11.CurrentBaseTrack:Play(p12 or 0.1);
    end;
end;

function u1.new() -- Line: 116
    -- upvalues: u1 (copy)
    local Animator = script.Parent.Parent:WaitForChild("Humanoid"):WaitForChild("Animator");
    local v13 = setmetatable({}, u1);
    v13.Animator = Animator;
    v13.BaseActionEnabled = true;
    v13.CurrentBaseTrack = nil;
    v13.BasePos = "Idle";
    v13.BaseActions = {};
    v13.CrapStepActionEnabled = true;
    v13.CrapStepActions = {};
    v13.CrapStepPos = "";
    v13.CurrentCrapTrack = nil;
    v13.RollActions = {};
    v13.CurrentRollTrack = nil;
    v13.Animate = {};
    v13.BasePosChangedCallbacks = {};
    v13._transitionExitFadeOut = nil;
    v13._locomotionTransitionCancel = nil;

    return v13;
end;

function u1.BasePosChanged(u14, u15) -- Line: 163
    table.insert(u14.BasePosChangedCallbacks, u15);

    return function() -- Line: 165
        -- upvalues: u14 (copy), u15 (copy)
        for i, v in ipairs(u14.BasePosChangedCallbacks) do
            if v == u15 then
                table.remove(u14.BasePosChangedCallbacks, i);

                return;
            end;
        end;
    end;
end;

local function _fireBasePosChanged(p16, p17, p18) -- Line: 175
    for _, v in ipairs(p16.BasePosChangedCallbacks) do
        v(p17, p18);
    end;
end;

function u1.bindBaseAction(p19, p20, p21) -- Line: 193
    -- upvalues: _syncMarkerConnections (copy)
    if not p19.BaseActions[p20] then
        p19.BaseActions[p20] = {};
    end;

    if p19.BaseActions[p20].Animation then
        if p19.BaseActions[p20].Animation.AnimationID == p21.ID then
            local AnimationTrack = p19.BaseActions[p20].AnimationTrack;

            if AnimationTrack then
                _syncMarkerConnections(AnimationTrack, p21.MarkerEvents, p19.BaseActions[p20]);
            end;

            return;
        end;

        local v22 = p19.BaseActions[p20];
        local MarkerConnections = v22.MarkerConnections;

        if MarkerConnections then
            for _, v in ipairs(MarkerConnections) do
                v:Disconnect();
            end;

            v22.MarkerConnections = nil;
        end;

        p19.BaseActions[p20].Animation:Destroy();
        p19.BaseActions[p20].Animation = nil;

        if p19.BaseActions[p20].AnimationTrack then
            p19.BaseActions[p20].AnimationTrack:Stop();
            p19.BaseActions[p20].AnimationTrack:Destroy();
            p19.BaseActions[p20].AnimationTrack = nil;
        end;
    end;

    local Animation = Instance.new("Animation");
    Animation.AnimationId = p21.ID;
    Animation.Name = p20;
    Animation.Parent = script;
    local v23 = p19.Animator:LoadAnimation(Animation);
    v23.Priority = p21.Priority;
    v23:AdjustSpeed(p21.Speed or 1);

    if p21.Looped == false then
        v23.Looped = false;
    end;

    _syncMarkerConnections(v23, p21.MarkerEvents, p19.BaseActions[p20]);
    p19.BaseActions[p20].AnimationTrack = v23;
    p19.BaseActions[p20].Animation = Animation;

    if p20 == p19.BasePos and (p19.BaseActionEnabled and p19.CurrentBaseTrack) then
        p19.CurrentBaseTrack:Play(0.1);
    end;
end;

function u1.setBaseSpeed(p24, p25, p26) -- Line: 245
    if p24.BaseActions[p25] and p24.BaseActions[p25].AnimationTrack then
        p24.BaseActions[p25].AnimationTrack:AdjustSpeed(p26);
    end;
end;

function u1.setBasePos(p27, p28, p29) -- Line: 258
    if p27.BasePos ~= p28 then
        local BasePos = p27.BasePos;
        p27:switchBaseAction(p28, p29);
        p27.BasePos = p28;

        for _, v in ipairs(p27.BasePosChangedCallbacks) do
            v(BasePos, p28);
        end;
    end;
end;

function u1.switchBaseAction(p30, p31, p32) -- Line: 274
    -- upvalues: u2 (copy)
    if p31 == p30.BasePos then
        return;
    end;

    local v33 = p32 or 0.18;

    if p30.BaseActions[p31] and p30.BaseActions[p31].AnimationTrack then
        if p30.CurrentBaseTrack then
            local v34;

            if u2[p30.BasePos] == true and p30._transitionExitFadeOut ~= nil then
                v34 = p30._transitionExitFadeOut;
                p30._transitionExitFadeOut = nil;
            else
                v34 = v33;
            end;

            if p30.CurrentBaseTrack then
                p30.CurrentBaseTrack:Stop(v34 or 0.1);
            end;
        end;

        p30.CurrentBaseTrack = p30.BaseActions[p31].AnimationTrack;

        if p30.BaseActionEnabled and p30.CurrentBaseTrack then
            p30.CurrentBaseTrack:Play(v33 or 0.1);
        end;
    end;
end;

function u1.playTransition(u35, p36, u37, p38) -- Line: 301
    if not (u35.BaseActions[p36] and u35.BaseActions[p36].AnimationTrack) then
        return false, nil;
    end;

    local AnimationTrack = u35.BaseActions[p36].AnimationTrack;
    local u39 = p38 and (p38.fadeTime or 0.18) or 0.18;
    local v40;

    if p38 then
        v40 = p38.fadeIn or u39;
    else
        v40 = u39;
    end;

    if p38 then
        u39 = p38.fadeOut or u39;
    end;

    local v41 = p38 and (p38.middleDuration or 0) or 0;
    local v42 = (not p38 or p38.animationSpeed == nil) and 1 or p38.animationSpeed;
    u35._transitionExitFadeOut = u39;

    if u35.CurrentBaseTrack and u35.CurrentBaseTrack then
        u35.CurrentBaseTrack:Stop(u39 or 0.1);
    end;

    local BasePos = u35.BasePos;
    u35.CurrentBaseTrack = AnimationTrack;
    u35.BasePos = p36;

    for _, v in ipairs(u35.BasePosChangedCallbacks) do
        v(BasePos, p36);
    end;

    local u43 = os.clock() + v40 + (v41 < 0 and 0 or v41);
    local u44 = false;
    local u45 = nil;
    local u46 = nil;

    local function clearCancelRef() -- Line: 342
        -- upvalues: u35 (copy)
        if u35._locomotionTransitionCancel ~= nil then
            u35._locomotionTransitionCancel = nil;
        end;
    end;

    local function invokeComplete() -- Line: 348
        -- upvalues: u44 (ref), u37 (copy), u43 (copy), u45 (ref)
        if u44 or not u37 then
            return;
        end;

        local function run() -- Line: 352
            -- upvalues: u44 (ref), u37 (ref)
            if u44 then
                return;
            end;

            u37();
        end;

        local v47 = u43 - os.clock();

        if v47 > 0 then
            u45 = task.delay(v47, function() -- Line: 360
                -- upvalues: u45 (ref), u44 (ref), u37 (ref)
                u45 = nil;

                if u44 then
                    return;
                end;

                u37();
            end);

            return;
        end;

        if u44 then
            return;
        end;

        u37();
    end;

    local function cancelTransition(p48) -- Line: 369
        -- upvalues: u44 (ref), u45 (ref), u46 (ref), u35 (copy), u39 (copy), AnimationTrack (copy)
        if u44 then
            return;
        end;

        u44 = true;

        if u45 ~= nil then
            task.cancel(u45);
            u45 = nil;
        end;

        if u46 ~= nil then
            u46:Disconnect();
            u46 = nil;
        end;

        if u35._locomotionTransitionCancel ~= nil then
            u35._locomotionTransitionCancel = nil;
        end;

        local u49 = p48 or u39 or 0.08;
        pcall(function() -- Line: 384
            -- upvalues: AnimationTrack (ref), u49 (copy)
            AnimationTrack:Stop(u49);
        end);
    end;

    u35._locomotionTransitionCancel = cancelTransition;

    if u35.BaseActionEnabled and u35.CurrentBaseTrack then
        u35.CurrentBaseTrack:Play(v40 or 0.1);
    end;

    AnimationTrack:AdjustSpeed(v42);
    u46 = AnimationTrack.Stopped:Connect(function() -- Line: 393
        -- upvalues: u46 (ref), u44 (ref), u35 (copy), invokeComplete (copy)
        if u46 ~= nil then
            u46:Disconnect();
            u46 = nil;
        end;

        if u44 then
            return;
        end;

        if u35._locomotionTransitionCancel ~= nil then
            u35._locomotionTransitionCancel = nil;
        end;

        invokeComplete();
    end);

    return true, cancelTransition;
end;

function u1.stopBaseAction(p50) -- Line: 411
    if not p50.BaseActionEnabled then
        return;
    end;

    p50.BaseActionEnabled = false;

    if p50.CurrentBaseTrack and p50.CurrentBaseTrack then
        p50.CurrentBaseTrack:Stop(0.1);
    end;
end;

function u1.resumeBaseAction(p51) -- Line: 426
    if p51.BaseActionEnabled then
        return;
    end;

    p51.BaseActionEnabled = true;

    if p51.BaseActionEnabled and (p51.CurrentBaseTrack and (p51.BaseActionEnabled and p51.CurrentBaseTrack)) then
        p51.CurrentBaseTrack:Play(0.1);
    end;
end;

local function _stopCrapStepAction(p52, p53) -- Line: 447
    if p52.CurrentCrapTrack then
        p52.CurrentCrapTrack:Stop(p53 or 0.1);
    end;
end;

local function _playCrapStepAction(p54, p55) -- Line: 456
    if not p54.CrapStepActionEnabled then
        return;
    end;

    if not p54.CrapStepPos or p54.CrapStepPos == "" then
        return;
    end;

    if not (p54.CrapStepActions[p54.CrapStepPos] and p54.CrapStepActions[p54.CrapStepPos].AnimationTrack) then
        return;
    end;

    p54.CurrentCrapTrack = p54.CrapStepActions[p54.CrapStepPos].AnimationTrack;
    p54.CurrentCrapTrack:Play(p55 or 0.1);
end;

function u1.bindCrapStepAction(p56, p57, p58) -- Line: 486
    -- upvalues: _syncMarkerConnections (copy), _playCrapStepAction (copy)
    if not p56.CrapStepActions[p57] then
        p56.CrapStepActions[p57] = {};
    end;

    if p56.CrapStepActions[p57].Animation then
        if p56.CrapStepActions[p57].Animation.AnimationID == p58.ID then
            local AnimationTrack = p56.CrapStepActions[p57].AnimationTrack;

            if AnimationTrack then
                _syncMarkerConnections(AnimationTrack, p58.MarkerEvents, p56.CrapStepActions[p57]);
            end;

            return;
        end;

        local v59 = p56.CrapStepActions[p57];
        local MarkerConnections = v59.MarkerConnections;

        if MarkerConnections then
            for _, v in ipairs(MarkerConnections) do
                v:Disconnect();
            end;

            v59.MarkerConnections = nil;
        end;

        p56.CrapStepActions[p57].Animation:Destroy();
        p56.CrapStepActions[p57].Animation = nil;

        if p56.CrapStepActions[p57].AnimationTrack then
            p56.CrapStepActions[p57].AnimationTrack:Stop();
            p56.CrapStepActions[p57].AnimationTrack:Destroy();
            p56.CrapStepActions[p57].AnimationTrack = nil;
        end;
    end;

    local Animation = Instance.new("Animation");
    Animation.AnimationId = p58.ID;
    Animation.Name = p57;
    Animation.Parent = script;
    local v60 = p56.Animator:LoadAnimation(Animation);
    v60.Priority = p58.Priority;
    v60:AdjustSpeed(p58.Speed or 1);
    v60.Looped = true;
    _syncMarkerConnections(v60, p58.MarkerEvents, p56.CrapStepActions[p57]);
    p56.CrapStepActions[p57].AnimationTrack = v60;
    p56.CrapStepActions[p57].Animation = Animation;

    if p57 == p56.CrapStepPos then
        _playCrapStepAction(p56, 0.1);
    end;
end;

function u1.switchCrapStepAction(p61, p62) -- Line: 537
    -- upvalues: _playCrapStepAction (copy)
    if p62 == p61.CrapStepPos then
        return;
    end;

    p61.CrapStepPos = p62;

    if p61.CrapStepActions[p62] and p61.CrapStepActions[p62].AnimationTrack then
        if p61.CurrentCrapTrack and p61.CurrentCrapTrack then
            p61.CurrentCrapTrack:Stop(0.1);
        end;

        p61.CurrentCrapTrack = p61.CrapStepActions[p62].AnimationTrack;
        _playCrapStepAction(p61, 0.1);
    end;
end;

function u1.setCrapStepPos(p63, p64) -- Line: 559
    if p63.CrapStepPos == p64 then
        return false;
    end;

    p63:switchCrapStepAction(p64);

    return true;
end;

function u1.stopCrapStepActionOnly(p65) -- Line: 571
    if p65.CurrentCrapTrack then
        if p65.CurrentCrapTrack then
            p65.CurrentCrapTrack:Stop(0.1);
        end;

        p65.CrapStepPos = "";
    end;
end;

function u1.stopCrapStepAction(p66) -- Line: 581
    if not p66.CrapStepActionEnabled then
        return;
    end;

    p66.CrapStepActionEnabled = false;

    if p66.CurrentCrapTrack and p66.CurrentCrapTrack then
        p66.CurrentCrapTrack:Stop(0.1);
    end;
end;

function u1.resumeCrapStepAction(p67) -- Line: 596
    -- upvalues: _playCrapStepAction (copy)
    if p67.CrapStepActionEnabled then
        return;
    end;

    p67.CrapStepActionEnabled = true;

    if p67.CrapStepActionEnabled and p67.CurrentCrapTrack then
        _playCrapStepAction(p67, 0.1);
    end;
end;

function u1.setCrapStepSpeed(p68, p69) -- Line: 611
    if not p68.CrapStepPos or p68.CrapStepPos == "" then
        return;
    end;

    if p68.CrapStepActions[p68.CrapStepPos] and p68.CrapStepActions[p68.CrapStepPos].AnimationTrack then
        p68.CrapStepActions[p68.CrapStepPos].AnimationTrack:AdjustSpeed(p69);
    end;
end;

function u1.bindRollAction(p70, p71, p72) -- Line: 636
    -- upvalues: _syncMarkerConnections (copy)
    if not p70.RollActions[p71] then
        p70.RollActions[p71] = {};
    end;

    if p70.RollActions[p71].Animation then
        if p70.RollActions[p71].Animation.AnimationID == p72.ID then
            local AnimationTrack = p70.RollActions[p71].AnimationTrack;

            if AnimationTrack then
                _syncMarkerConnections(AnimationTrack, p72.MarkerEvents, p70.RollActions[p71]);
            end;

            return;
        end;

        local v73 = p70.RollActions[p71];
        local MarkerConnections = v73.MarkerConnections;

        if MarkerConnections then
            for _, v in ipairs(MarkerConnections) do
                v:Disconnect();
            end;

            v73.MarkerConnections = nil;
        end;

        p70.RollActions[p71].Animation:Destroy();
        p70.RollActions[p71].Animation = nil;

        if p70.RollActions[p71].AnimationTrack then
            p70.RollActions[p71].AnimationTrack:Stop();
            p70.RollActions[p71].AnimationTrack:Destroy();
            p70.RollActions[p71].AnimationTrack = nil;
        end;
    end;

    local Animation = Instance.new("Animation");
    Animation.AnimationId = p72.ID;
    Animation.Name = p71;
    Animation.Parent = script;
    local v74 = p70.Animator:LoadAnimation(Animation);
    v74.Priority = p72.Priority;
    v74:AdjustSpeed(p72.Speed or 1);
    _syncMarkerConnections(v74, p72.MarkerEvents, p70.RollActions[p71]);
    p70.RollActions[p71].AnimationTrack = v74;
    p70.RollActions[p71].Animation = Animation;
end;

function u1.playRollAction(p75, p76) -- Line: 682
    if p75.RollActions[p76] and p75.RollActions[p76].AnimationTrack then
        p75.RollActions[p76].AnimationTrack:Play(0.1);
    end;
end;

function u1.stopRollAction(p77, p78) -- Line: 692
    if p77.RollActions[p78] and p77.RollActions[p78].AnimationTrack then
        p77.RollActions[p78].AnimationTrack:Stop(0.1);
    end;
end;

local function _destroyActionSlot(u79) -- Line: 702
    local MarkerConnections = u79.MarkerConnections;

    if MarkerConnections then
        for _, v in ipairs(MarkerConnections) do
            v:Disconnect();
        end;

        u79.MarkerConnections = nil;
    end;

    if u79.AnimationTrack then
        pcall(function() -- Line: 705
            -- upvalues: u79 (copy)
            u79.AnimationTrack:Stop(0);
            u79.AnimationTrack:Destroy();
        end);
        u79.AnimationTrack = nil;
    end;

    if u79.Animation then
        u79.Animation:Destroy();
        u79.Animation = nil;
    end;
end;

function u1.destroy(u80) -- Line: 720
    -- upvalues: _destroyActionSlot (copy)
    if u80._locomotionTransitionCancel then
        pcall(u80._locomotionTransitionCancel);
        u80._locomotionTransitionCancel = nil;
    end;

    if u80.CurrentBaseTrack then
        pcall(function() -- Line: 727
            -- upvalues: u80 (copy)
            u80.CurrentBaseTrack:Stop(0);
        end);
        u80.CurrentBaseTrack = nil;
    end;

    if u80.CurrentCrapTrack then
        pcall(function() -- Line: 733
            -- upvalues: u80 (copy)
            u80.CurrentCrapTrack:Stop(0);
        end);
        u80.CurrentCrapTrack = nil;
    end;

    if u80.CurrentRollTrack then
        pcall(function() -- Line: 739
            -- upvalues: u80 (copy)
            u80.CurrentRollTrack:Stop(0);
        end);
        u80.CurrentRollTrack = nil;
    end;

    for _, v in pairs(u80.BaseActions) do
        _destroyActionSlot(v);
    end;

    for _, v in pairs(u80.CrapStepActions) do
        _destroyActionSlot(v);
    end;

    for _, v in pairs(u80.RollActions) do
        _destroyActionSlot(v);
    end;

    table.clear(u80.BaseActions);
    table.clear(u80.CrapStepActions);
    table.clear(u80.RollActions);
    table.clear(u80.BasePosChangedCallbacks);
    u80.BaseActionEnabled = false;
    u80.CrapStepActionEnabled = false;
end;

return u1.new();