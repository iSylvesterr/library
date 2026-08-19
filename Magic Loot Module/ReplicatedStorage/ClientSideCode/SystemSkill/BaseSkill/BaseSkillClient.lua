-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillAction = require(script.Parent.SkillAction);
local GetSkillData = require(script.Parent.GetSkillData);
local SkillStateRuntime = require(script.Parent.SkillStateRuntime);
local SkillControlRuntime = require(script.Parent.SkillControlRuntime);
local SkillEventConst = require(script.Parent.SkillEventConst);
local SkillStateMachine = require(script.Parent.SkillStateMachine);
local BaseSkillDefinitionLoader = require(script.Parent.BaseSkillDefinitionLoader);
local BaseSkillExecutionContext = require(script.Parent.BaseSkillExecutionContext);
local BaseSkillRuntimeHost = require(script.Parent.BaseSkillRuntimeHost);
local BaseSkillTargetFind = require(script.Parent.BaseSkillTargetFind);
local PlayerAimSync = require(script.Parent.PlayerAimSync);
local SkillStateActions = require(script.Parent.SkillStateActions);
local ProjectileObjectTracking = require(game.ReplicatedStorage.ClientSideCode.SystemSkill.SkillModule._Templates.Projectile.ProjectileObjectTracking);
local RunService = UtilsSystem.RunService;
local FXUtil = UtilsSystem.FXUtil;
local AssetPaths = UtilsSystem.AssetPaths;
local SkillTelegraph = UtilsSystem.SkillTelegraph;
local LocalPlayer = UtilsSystem.LocalPlayer;
local SkillFxGate = UtilsSystem.SkillFxGate;
local u1 = AssetPaths.Resolve("ModelRes/Skill", AssetPaths.Scope.Shared);
local u2 = {};

function u2.__index(p3, p4) -- Line: 36
    -- upvalues: u2 (copy)
    if p4 == "isRunning" then
        return p3:isRunningFlow();
    end;

    return u2[p4];
end;

local u5 = {
    MIN_FIX_RATE = 0.1,
    MAX_FIX_RATE = 0.9,
    SMALL_DIFF_THRESHOLD = 0.1,
    LARGE_DIFF_THRESHOLD = 0.5,
    MAX_APPLIED_FIX_PER_FRAME = 0.06
};

local function _assembleFromDefinition(p6, p7, p8, p9) -- Line: 59
    p6._definition = p7;
    p6._context = p8;
    p6._runtimeHost = p9;
    p6.skillName = p7.skillName;
    p6.skillModule = p7.skillModule;
    p6.characterId = p8.characterId;
    p6.characterType = p8.characterType;
    p6.character = p8.character;
    p6.skillID = p8.skillID;
    p6.skillInputData = p8.skillInputData;
    p6.skillTargetData = p8.skillTargetData;
    p6.combatSeed = p8.combatSeed;
    p6.skillCastId = p8.skillCastId;
    p6.baseSkillInstanceId = p8.baseSkillInstanceId;
    p6.activeBaseSkillIndex = p8.activeBaseSkillIndex;
    p6.skillPlaySpeed = 1;
    p6.nowTime = 0;
    p6.skillRunData = {};
    p6.skillTimeUpdateEvent = nil;
    p6.skillTimeFix = 0;
    p6.hitbox = {};
    p6.hitboxRuntime = nil;
    p6.hitboxControlIndex = 0;
    p6.flowState = "Idle";
    p6.authoritativeState = "Idle";
    p6._destroyed = false;
    p6._isDestroying = false;
    p6._skillMaterialCleared = false;
    p6.runGeneration = 0;
    p6.destroyReason = nil;
    p6.finishReason = nil;
    p6.enteredTerminalAt = nil;
    p6.cleanupCompleted = false;
    p6.controlRuntime = p9.controlRuntime;
    p6.isPhase1Complete = false;
    p6.isControlReleased = false;
    p6._presentationPredictActive = false;
end;

function u2.new(p10, p11, p12, p13) -- Line: 108
    -- upvalues: u2 (copy), BaseSkillDefinitionLoader (copy), BaseSkillExecutionContext (copy), SkillAction (copy), BaseSkillRuntimeHost (copy), SkillStateActions (copy), _assembleFromDefinition (copy)
    local u14 = setmetatable({}, u2);
    local v15, v16 = BaseSkillDefinitionLoader.load(p10);
    assert(v15, ("[BaseSkillClient] %s"):format(v16 or "加载失败"));
    local v17 = p13 or {};
    local v18 = BaseSkillExecutionContext.create({
        characterId = p11,
        characterType = p12,
        skillID = v17.skillID
    });
    u14.skillModule = v15.skillModule;
    u14.skillName = v15.skillName;
    u14.characterId = v18.characterId;
    u14.characterType = v18.characterType;
    u14.character = v18.character;
    u14._skipAnimationCreatePreload = v17.skipAnimationCreatePreload == true;
    u14.skillAction = SkillAction.new(u14);
    _assembleFromDefinition(u14, v15, v18, (BaseSkillRuntimeHost.create(v15, {
        isClient = true,

        getActionsOverCheck = function() -- Line: 138, Name: getActionsOverCheck
            -- upvalues: u14 (copy), SkillStateActions (ref)
            local v19 = u14.skillAction:AreAllActionsOver();

            if not u14.skillModule.phase1UsesStateActions then
                return v19;
            end;

            if v19 then
                v19 = SkillStateActions.areAllOver(u14);
            end;

            return v19;
        end
    })));

    return u14;
end;

function u2.newWithDefinition(p20, p21) -- Line: 157
    -- upvalues: u2 (copy), SkillAction (copy), BaseSkillRuntimeHost (copy), SkillStateActions (copy), _assembleFromDefinition (copy)
    local u22 = setmetatable({}, u2);
    u22.skillModule = p20.skillModule;
    u22.skillName = p20.skillName;
    u22.characterId = p21.characterId;
    u22.characterType = p21.characterType;
    u22.character = p21.character;
    u22._skipAnimationCreatePreload = false;
    u22.skillAction = SkillAction.new(u22);
    _assembleFromDefinition(u22, p20, p21, (BaseSkillRuntimeHost.create(p20, {
        isClient = true,

        getActionsOverCheck = function() -- Line: 168, Name: getActionsOverCheck
            -- upvalues: u22 (copy), SkillStateActions (ref)
            local v23 = u22.skillAction:AreAllActionsOver();

            if not u22.skillModule.phase1UsesStateActions then
                return v23;
            end;

            if v23 then
                v23 = SkillStateActions.areAllOver(u22);
            end;

            return v23;
        end
    })));

    return u22;
end;

function u2.setSkillInputData(p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34) -- Line: 183
    -- upvalues: BaseSkillExecutionContext (copy)
    BaseSkillExecutionContext.update(p24._context, {
        skillModule = p24.skillModule,
        characterId = p25,
        characterType = p26,
        releaseCF = p27,
        targetCF = p28,
        moveDirectionStr = p29,
        skillCastId = p30,
        baseSkillInstanceId = p31,
        activeBaseSkillIndex = p32,
        trackTargetId = p33,
        skillTargetData = p34
    });
    BaseSkillExecutionContext.refreshCharacter(p24._context);
    local _context = p24._context;
    p24.characterId = _context.characterId;
    p24.characterType = _context.characterType;
    p24.character = _context.character;
    p24.skillInputData = _context.skillInputData;
    p24.skillTargetData = _context.skillTargetData;
    p24.skillCastId = _context.skillCastId;
    p24.baseSkillInstanceId = _context.baseSkillInstanceId;
    p24.activeBaseSkillIndex = _context.activeBaseSkillIndex;
end;

local function getInitialStateDurationCap(p35) -- Line: 219
    if not (p35 and (p35.States and p35.InitialState)) then
        return nil;
    end;

    local InitialState = p35.InitialState;
    local v36 = p35.States[InitialState] and p35.States[InitialState].Duration;

    if type(v36) == "number" and v36 >= 0 then
        return v36;
    end;

    return nil;
end;

local function calculateAdaptiveFixRate(p37) -- Line: 231
    -- upvalues: u5 (copy)
    local v38 = math.abs(p37);
    local v39 = u5;

    if v39.LARGE_DIFF_THRESHOLD < v38 then
        return v39.MAX_FIX_RATE;
    end;

    if v39.SMALL_DIFF_THRESHOLD < v38 then
        return v39.MIN_FIX_RATE + (v39.MAX_FIX_RATE - v39.MIN_FIX_RATE) * ((v38 - v39.SMALL_DIFF_THRESHOLD) / (v39.LARGE_DIFF_THRESHOLD - v39.SMALL_DIFF_THRESHOLD));
    end;

    return v39.MIN_FIX_RATE;
end;

function u2.setSkillTimeFix(p40, p41) -- Line: 254
    p40.skillTimeFix = p41;
end;

local function _isPlayerCasterType(p42) -- Line: 264
    return p42 == "Player" and true or p42 == "Mirror";
end;

local function _refreshSuppressSkillFx(p43) -- Line: 272
    -- upvalues: SkillFxGate (copy)
    local characterType = p43.characterType;
    local v44 = (characterType == "Player" and true or characterType == "Mirror") and not SkillFxGate.IsLocalEnabled();
    p43.suppressSkillFx = v44;
end;

function u2.initSkillMaterial(p45) -- Line: 279
    -- upvalues: BaseSkillRuntimeHost (copy), u1 (copy)
    p45.skillRunData = BaseSkillRuntimeHost.initMaterial(p45._runtimeHost, p45._definition, {
        isClient = true,
        skillResFolder = u1,
        skipClientMaterials = p45.suppressSkillFx == true
    });

    if p45.skillModule.onStart and not p45.suppressSkillFx then
        p45.skillModule.onStart(p45);
    end;
end;

function u2.BindRunConn(p46, p47) -- Line: 296
    local skillRunData = p46.skillRunData;

    if not skillRunData then
        return p47;
    end;

    skillRunData.runEvent = skillRunData.runEvent or {};
    table.insert(skillRunData.runEvent, p47);

    return p47;
end;

function u2.BindStateConn(p48, p49, p50) -- Line: 310
    local skillRunData = p48.skillRunData;

    if not skillRunData then
        return p50;
    end;

    skillRunData.stateEventMap = skillRunData.stateEventMap or {};
    skillRunData.stateEventMap[p49] = skillRunData.stateEventMap[p49] or {};
    table.insert(skillRunData.stateEventMap[p49], p50);

    return p50;
end;

function u2.CleanupStateConns(p51, p52) -- Line: 323
    local skillRunData = p51.skillRunData;

    if not (skillRunData and skillRunData.stateEventMap) then
        return;
    end;

    local v53 = skillRunData.stateEventMap[p52];

    if not v53 then
        return;
    end;

    for _, v in v53 do
        pcall(function() -- Line: 329
            -- upvalues: v (copy)
            if v and typeof(v) == "RBXScriptConnection" then
                v:Disconnect();
            end;
        end);
    end;

    skillRunData.stateEventMap[p52] = nil;
end;

function u2.CleanupAllConns(p54, p55) -- Line: 342
    local v56 = p55 or p54.skillRunData;

    if not v56 then
        return;
    end;

    if v56.runEvent then
        for i, v in v56.runEvent do
            pcall(function() -- Line: 347
                -- upvalues: v (copy)
                if v and typeof(v) == "RBXScriptConnection" then
                    v:Disconnect();
                end;
            end);
            v56.runEvent[i] = nil;
        end;
    end;

    if v56.stateEventMap then
        for i, v in v56.stateEventMap do
            for _, v2 in v do
                pcall(function() -- Line: 358
                    -- upvalues: v2 (copy)
                    if v2 and typeof(v2) == "RBXScriptConnection" then
                        v2:Disconnect();
                    end;
                end);
            end;

            v56.stateEventMap[i] = nil;
        end;
    end;
end;

function u2.EnterState(p57, p58, p59) -- Line: 372
    local skillModule = p57.skillModule;

    if not (skillModule.States and skillModule.States[p58]) then
        return;
    end;

    local v60 = skillModule.States[p58];
    local skillRunData = p57.skillRunData;

    if skillRunData.State then
        skillRunData.State.current = p58;
        skillRunData.State.enteredAt = p57.nowTime;
    end;

    if p57.suppressSkillFx then
        return;
    end;

    local OnEnterClient = v60.OnEnterClient;

    if OnEnterClient and skillModule[OnEnterClient] then
        skillModule[OnEnterClient](p57, p59);
    end;
end;

function u2.ExitState(p61, p62, p63) -- Line: 394
    local skillModule = p61.skillModule;

    if not (skillModule.States and skillModule.States[p62]) then
        return;
    end;

    if p61.suppressSkillFx then
        p61:CleanupStateConns(p62);

        return;
    end;

    local OnExitClient = skillModule.States[p62].OnExitClient;

    if OnExitClient and skillModule[OnExitClient] then
        skillModule[OnExitClient](p61, p63);
    end;

    p61:CleanupStateConns(p62);
end;

function u2.getFlowState(p64) -- Line: 417
    -- upvalues: SkillStateRuntime (copy)
    return SkillStateRuntime.getCurrentState(p64.skillRunData);
end;

function u2.isTerminal(p65) -- Line: 424
    local v66 = p65:getFlowState();

    if not v66 then
        return true;
    end;

    local v67 = p65.skillModule.States and p65.skillModule.States[v66];

    if v67 then
        v67 = v67.IsTerminal == true;
    end;

    return v67;
end;

function u2.isRunningFlow(p68) -- Line: 434
    return not p68:isTerminal();
end;

function u2.TryTransition(p69, p70, p71) -- Line: 438
    -- upvalues: SkillStateActions (copy), SkillStateRuntime (copy)
    return SkillStateRuntime.tryTransition(p69, p70, p71, {
        callEnterHandler = function(p72, p73, p74) -- Line: 440, Name: callEnterHandler
            -- upvalues: SkillStateActions (ref)
            p72:EnterState(p73, p74);
            SkillStateActions.enterForState(p72, p73);
        end,

        callExitHandler = function(p75, p76, p77) -- Line: 444, Name: callExitHandler
            -- upvalues: SkillStateActions (ref)
            SkillStateActions.exitForState(p75, p76);
            p75:ExitState(p76, p77);
        end,

        onTerminalReached = function(p78, p79) -- Line: 448, Name: onTerminalReached
            p78:markFinished(p79);
        end,

        onFatalError = function(p80) -- Line: 451, Name: onFatalError
            p80:skillInterrupt();
        end
    });
end;

function u2.markFinished(p81, p82, p83) -- Line: 460
    if p81._presentationPredictActive then
        p81._presentationPredictActive = false;
        p83 = true;
    end;

    p81:_doSkillEndCleanup(p83, p82);
end;

function u2.GetCurrentState(p84) -- Line: 471
    return p84:getFlowState();
end;

function u2.clearSkillMaterial(p85, p86) -- Line: 480
    -- upvalues: FXUtil (copy)
    local v87 = p86 or p85.skillRunData;

    if not v87 then
        return;
    end;

    if p86 == nil and p85._skillMaterialCleared then
        return;
    end;

    if p86 == nil then
        p85._skillMaterialCleared = true;
    end;

    if p86 == nil or not p85.skillModule.onClearRunData then
        if p86 == nil and p85.skillModule.onEnd then
            p85.skillModule.onEnd(p85);
        end;
    else
        p85.skillModule.onClearRunData(p85, p86);
    end;

    p85:CleanupAllConns(v87);

    if v87.material then
        for i, v in v87.material do
            if v and v.Parent then
                FXUtil.BackPool_Instance(v);
                v87.material[i] = nil;
            end;
        end;
    end;
end;

local function _skillClientClockTick(p88, p89, p90) -- Line: 508
    -- upvalues: u5 (copy), SkillStateMachine (copy), SkillEventConst (copy), SkillStateActions (copy), SkillControlRuntime (copy)
    if p88._destroyed then
        return;
    end;

    if p88.skillTimeFix ~= 0 then
        local v91 = math.abs(p88.skillTimeFix);
        local v92 = u5;
        local v93;

        if v92.LARGE_DIFF_THRESHOLD < v91 then
            v93 = v92.MAX_FIX_RATE;
        elseif v92.SMALL_DIFF_THRESHOLD < v91 then
            v93 = v92.MIN_FIX_RATE + (v92.MAX_FIX_RATE - v92.MIN_FIX_RATE) * ((v91 - v92.SMALL_DIFF_THRESHOLD) / (v92.LARGE_DIFF_THRESHOLD - v92.SMALL_DIFF_THRESHOLD));
        else
            v93 = v92.MIN_FIX_RATE;
        end;

        local v94 = math.min(p89 * v93, u5.MAX_APPLIED_FIX_PER_FRAME);
        local v95 = p88.skillTimeFix > 0 and 1 or -1;

        if math.abs(p88.skillTimeFix) > math.abs(v94) then
            p88.skillTimeFix = p88.skillTimeFix - v94 * v95;
            p89 = p89 + v94 * v95;
        else
            local v96 = math.abs(p88.skillTimeFix);
            local v97 = math.min(v96, u5.MAX_APPLIED_FIX_PER_FRAME) * v95;
            p89 = p89 + v97;
            p88.skillTimeFix = p88.skillTimeFix - v97;
        end;

        if math.abs(p88.skillTimeFix) < 0.001 then
            p88.skillTimeFix = 0;
        end;
    end;

    p88.nowTime = p88.nowTime + p89 * p88.skillPlaySpeed;
    local skillRunData = p88.skillRunData;
    local v98 = p88.skillModule.States and p88.skillModule.States[skillRunData.State.current];

    if v98 and SkillStateMachine.shouldStateTimeout(v98, skillRunData.State.enteredAt, p88.nowTime) then
        if p90 then
            if not p88:TryTransition(SkillEventConst.Interrupt, nil) then
                p88:TryTransition(SkillEventConst.ForceFinish, nil);
            end;
        else
            p88:TryTransition(SkillEventConst.StateTimeout, nil);
        end;

        if not p88:isRunningFlow() then
            return;
        end;
    end;

    p88.skillAction:Run(p88.nowTime);
    SkillStateActions.run(p88, p88.nowTime);
    SkillControlRuntime.update(p88.controlRuntime, p88.nowTime, p88);
    p88.isPhase1Complete = p88.controlRuntime.isPhase1Complete;
    p88.isControlReleased = p88.controlRuntime.isControlReleased;
end;

function u2.skillStart(u99, p100) -- Line: 559
    -- upvalues: SkillFxGate (copy), SkillStateActions (copy), BaseSkillRuntimeHost (copy), RunService (copy), _skillClientClockTick (copy)
    if u99._destroyed or u99:isRunningFlow() then
        return;
    end;

    assert(u99.skillModule.States and u99.skillModule.InitialState, ("[BaseSkillClient] %s 必须定义 States + InitialState（仅支持状态机范式）"):format(u99.skillName));
    u99.runGeneration = (u99.runGeneration or 0) + 1;

    if not (u99.character and u99.character.Parent) then
        warn("技能无法启动：角色不存在或已销毁", u99.skillName);

        return;
    end;

    if not (u99.skillInputData and u99.skillInputData.character) then
        warn("技能无法启动：技能输入数据无效", u99.skillName);

        return;
    end;

    u99.flowState = "Running";
    u99.authoritativeState = "Running";
    local characterType = u99.characterType;
    local v101 = (characterType == "Player" and true or characterType == "Mirror") and not SkillFxGate.IsLocalEnabled();
    u99.suppressSkillFx = v101;
    u99:initSkillMaterial();
    u99.hitbox = {};
    u99.hitboxRuntime = nil;
    u99._runtimeHost.hitboxRuntime = nil;
    u99.skillAction:Init();
    local softMergeInitialNowTime = (p100 or {}).softMergeInitialNowTime;
    local skillModule = u99.skillModule;
    local v102;

    if skillModule and (skillModule.States and skillModule.InitialState) then
        local InitialState = skillModule.InitialState;
        v102 = skillModule.States[InitialState] and skillModule.States[InitialState].Duration;

        if type(v102) ~= "number" or v102 < 0 then
            v102 = nil;
        end;
    else
        v102 = nil;
    end;

    local v103;

    if type(softMergeInitialNowTime) == "number" then
        v103 = softMergeInitialNowTime > 0.0001;
    else
        v103 = false;
    end;

    if v103 then
        if v102 then
            softMergeInitialNowTime = math.min(softMergeInitialNowTime, v102);
        end;

        u99.nowTime = softMergeInitialNowTime;
        u99.skillAction:startOrCatchUpAtTime(softMergeInitialNowTime);
        u99:EnterState(u99.skillModule.InitialState, nil);
        local skillRunData = u99.skillRunData;

        if skillRunData and skillRunData.State then
            skillRunData.State.enteredAt = u99.nowTime - softMergeInitialNowTime;
        end;
    else
        u99.nowTime = 0;
        u99.skillAction:Start(u99.nowTime);
        u99:EnterState(u99.skillModule.InitialState, nil);
    end;

    SkillStateActions.enterForState(u99, u99.skillModule.InitialState);
    u99.skillTimeUpdateEvent = BaseSkillRuntimeHost.startClock(u99._runtimeHost, RunService, function(p104) -- Line: 625
        -- upvalues: _skillClientClockTick (ref), u99 (copy)
        _skillClientClockTick(u99, p104, false);
    end);
end;

function u2.skillStartPresentationPredict(u105) -- Line: 634
    -- upvalues: SkillFxGate (copy), SkillStateActions (copy), BaseSkillRuntimeHost (copy), RunService (copy), _skillClientClockTick (copy)
    if u105._destroyed or u105:isRunningFlow() then
        return;
    end;

    assert(u105.skillModule.States and u105.skillModule.InitialState, ("[BaseSkillClient] %s 必须定义 States + InitialState（仅支持状态机范式）"):format(u105.skillName));
    u105.runGeneration = (u105.runGeneration or 0) + 1;

    if not (u105.character and u105.character.Parent) then
        return;
    end;

    if not (u105.skillInputData and u105.skillInputData.character) then
        return;
    end;

    u105.flowState = "Running";
    u105.authoritativeState = "Running";
    u105._presentationPredictActive = true;
    local characterType = u105.characterType;
    local v106 = (characterType == "Player" and true or characterType == "Mirror") and not SkillFxGate.IsLocalEnabled();
    u105.suppressSkillFx = v106;
    u105:initSkillMaterial();
    u105.skillAction:Init();
    u105.skillAction:Start(u105.nowTime);
    u105:EnterState(u105.skillModule.InitialState, nil);
    SkillStateActions.enterForState(u105, u105.skillModule.InitialState);
    u105.skillTimeUpdateEvent = BaseSkillRuntimeHost.startClock(u105._runtimeHost, RunService, function(p107) -- Line: 661
        -- upvalues: _skillClientClockTick (ref), u105 (copy)
        _skillClientClockTick(u105, p107, true);
    end);
end;

function u2.getControlState(p108) -- Line: 670
    -- upvalues: SkillControlRuntime (copy)
    return SkillControlRuntime.getState(p108.controlRuntime);
end;

function u2.releaseControl(p109) -- Line: 677
    -- upvalues: SkillControlRuntime (copy)
    SkillControlRuntime.release(p109.controlRuntime, p109.nowTime);
    p109.isControlReleased = true;
end;

function u2.interruptSkillActionsOnly(p110) -- Line: 685
    -- upvalues: SkillStateActions (copy), SkillControlRuntime (copy)
    if p110._destroyed or not p110:isRunningFlow() then
        return;
    end;

    if p110.skillAction then
        p110.skillAction:Over(p110.nowTime);
    end;

    SkillStateActions.destroyAll(p110);
    SkillControlRuntime.update(p110.controlRuntime, p110.nowTime, p110);
    p110.isPhase1Complete = p110.controlRuntime.isPhase1Complete;
    p110.isControlReleased = p110.controlRuntime.isControlReleased;

    if not p110.controlRuntime.isControlReleased then
        p110:releaseControl();
    end;
end;

function u2.skillInterrupt(p111) -- Line: 705
    p111.flowState = "Interrupted";
    p111.authoritativeState = "Interrupted";
    p111:skillEnd(nil, "Interrupted");
end;

function u2._doSkillEndCleanup(u112, p113, p114) -- Line: 714
    -- upvalues: SkillTelegraph (copy), SkillStateActions (copy), BaseSkillRuntimeHost (copy)
    local v115 = p114 or (u112.flowState or "Finished");
    SkillTelegraph.destroyAllInRunData(u112.skillRunData);

    if v115 == "Interrupted" then
        u112.flowState = "Interrupted";
        u112.authoritativeState = "Interrupted";
    else
        u112.flowState = "Finished";
        u112.authoritativeState = "Finished";
    end;

    u112.finishReason = v115;
    u112.enteredTerminalAt = os.clock();
    SkillStateActions.destroyAll(u112);
    u112.skillAction:Over(u112.nowTime);
    local v116 = not p113 and u112.skillModule and u112.skillModule.visualFadeoutTime;

    if v116 and v116 > 0 then
        local skillRunData = u112.skillRunData;
        local runGeneration = u112.runGeneration;
        task.delay(v116, function() -- Line: 734
            -- upvalues: u112 (copy), skillRunData (copy), runGeneration (copy)
            if u112._destroyed then
                return;
            end;

            if u112.clearSkillMaterial and (skillRunData and (u112.runGeneration == runGeneration or skillRunData ~= u112.skillRunData)) then
                u112:clearSkillMaterial(skillRunData);
            end;
        end);
    else
        u112:clearSkillMaterial();
    end;

    BaseSkillRuntimeHost.stopClock(u112._runtimeHost);
    u112.skillTimeUpdateEvent = nil;
    BaseSkillRuntimeHost.destroyHitbox(u112._runtimeHost);
    u112.hitbox = {};
    u112.hitboxRuntime = nil;
    u112.skillInputData = {};
    u112.skillTargetData = nil;
    u112.hitboxControlIndex = 0;
    u112.nowTime = 0;
    BaseSkillRuntimeHost.resetControl(u112._runtimeHost);
    u112.isPhase1Complete = u112.controlRuntime.isPhase1Complete;
    u112.isControlReleased = u112.controlRuntime.isControlReleased;
end;

function u2.skillEnd(p117, p118, p119) -- Line: 767
    -- upvalues: SkillEventConst (copy), SkillStateActions (copy)
    if p117._destroyed and not p117._isDestroying then
        return;
    end;

    local v120 = p119 or (p117.flowState or "Finished");

    if v120 == "Interrupted" then
        if p117:TryTransition(SkillEventConst.Interrupt) then
            return;
        end;

        local skillRunData = p117.skillRunData;

        if skillRunData and skillRunData.State then
            local current = skillRunData.State.current;
            SkillStateActions.exitForState(p117, current);
            p117:ExitState(current, nil);
        end;
    else
        if p117:TryTransition(SkillEventConst.ForceFinish) then
            return;
        end;

        local skillRunData = p117.skillRunData;

        if skillRunData and skillRunData.State then
            local current = skillRunData.State.current;
            SkillStateActions.exitForState(p117, current);
            p117:ExitState(current, nil);
        end;
    end;

    p117:_doSkillEndCleanup(p118, v120);
end;

function u2.handleServerEvent(p121, p122) -- Line: 801
    if p121._destroyed then
        return;
    end;

    if p121.suppressSkillFx then
        return;
    end;

    if p121.skillModule and p121.skillModule.onServerEvent then
        p121.skillModule.onServerEvent(p121, p122);
    end;
end;

function u2._forceFinishIfNeeded(p123, p124, p125) -- Line: 813
    if not p123:isTerminal() then
        p123:skillEnd(p125, p124);
    end;
end;

function u2._disconnectAll(p126) -- Line: 819
    p126:clearSkillMaterial();
end;

function u2._clearTimers(p127) -- Line: 823
    -- upvalues: BaseSkillRuntimeHost (copy)
    BaseSkillRuntimeHost.stopClock(p127._runtimeHost);

    if p127.skillTimeUpdateEvent then
        p127.skillTimeUpdateEvent:Disconnect();
        p127.skillTimeUpdateEvent = nil;
    end;
end;

function u2._clearHitboxes(p128) -- Line: 831
    -- upvalues: BaseSkillRuntimeHost (copy)
    BaseSkillRuntimeHost.destroyHitbox(p128._runtimeHost);
    p128.hitbox = {};
    p128.hitboxRuntime = nil;
end;

function u2.destroy(p129, p130, p131) -- Line: 844
    -- upvalues: BaseSkillRuntimeHost (copy)
    if p129._destroyed or p129._isDestroying then
        return;
    end;

    p129._isDestroying = true;
    p129._presentationPredictActive = false;
    local v132 = p130 or "Interrupted";
    p129.destroyReason = v132;
    p129:_forceFinishIfNeeded(v132, p131 == nil and true or p131);
    p129._destroyed = true;
    p129._isDestroying = false;

    if p129.skillAction then
        p129.skillAction:Destroy();
    end;

    p129:_disconnectAll();
    p129:_clearTimers();
    p129:_clearHitboxes();
    p129.skillRunData = {};
    p129.skillInputData = {};
    p129.skillTargetData = nil;
    p129.hitboxControlIndex = 0;
    p129.nowTime = 0;
    BaseSkillRuntimeHost.resetControl(p129._runtimeHost);
    p129.isPhase1Complete = p129.controlRuntime.isPhase1Complete;
    p129.isControlReleased = p129.controlRuntime.isControlReleased;
    p129.cleanupCompleted = true;
end;

function u2.getTargetCF(p133) -- Line: 882
    -- upvalues: PlayerAimSync (copy), ProjectileObjectTracking (copy), BaseSkillTargetFind (copy), RunService (copy), LocalPlayer (copy), GetSkillData (copy)
    local skillInputData = p133.skillInputData;

    if not skillInputData then
        return CFrame.new();
    end;

    if not PlayerAimSync.isAutoAimActiveForSkill(p133) then
        return PlayerAimSync.getOrFreezeManualAimCF(p133, PlayerAimSync.getClientBufferedAimCFrame());
    end;

    local v134 = skillInputData.trackTargetId ~= nil and skillInputData.trackTargetId ~= "" and ProjectileObjectTracking.getWorldPositionByTrackTargetId(skillInputData.trackTargetId);

    if v134 then
        skillInputData.targetCF = CFrame.new(v134);

        return skillInputData.targetCF;
    end;

    local v135 = BaseSkillTargetFind.findTarget(p133.skillTargetData);

    if v135 then
        skillInputData.targetCF = v135;

        return skillInputData.targetCF;
    end;

    if RunService:IsClient() and (LocalPlayer and (p133.characterType == "Player" and p133.characterId == LocalPlayer.UserId)) then
        local _, v136 = GetSkillData.getLocalPlayerSkillInputData();

        if v136 then
            skillInputData.targetCF = v136;

            return skillInputData.targetCF;
        end;
    end;

    return skillInputData.targetCF or CFrame.new();
end;

return u2;