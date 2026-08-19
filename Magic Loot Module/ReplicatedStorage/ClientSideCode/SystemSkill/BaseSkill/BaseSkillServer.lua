-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillSyncLog = require(game.ReplicatedFirst.AllSideCode.SkillSyncLog);
require(script.Parent.GetSkillData);
local SkillStateRuntime = require(script.Parent.SkillStateRuntime);
local SkillControlRuntime = require(script.Parent.SkillControlRuntime);
local SkillEventConst = require(script.Parent.SkillEventConst);
local SkillSyncEventFactory = require(script.Parent.SkillSyncEventFactory);
local SkillSyncDispatcher = require(script.Parent.SkillSyncDispatcher);
local BaseSkillDefinitionLoader = require(script.Parent.BaseSkillDefinitionLoader);
local BaseSkillExecutionContext = require(script.Parent.BaseSkillExecutionContext);
local BaseSkillRuntimeHost = require(script.Parent.BaseSkillRuntimeHost);
local SkillDataSchema = require(script.Parent.SkillDataSchema);
local BaseSkillTargetFind = require(script.Parent.BaseSkillTargetFind);
local PlayerAimSync = require(script.Parent.PlayerAimSync);
local ProjectileObjectTracking = require(game.ReplicatedStorage.ClientSideCode.SystemSkill.SkillModule._Templates.Projectile.ProjectileObjectTracking);
local AnimationPlaySide = require(script.Parent.AnimationPlaySide);
local SkillAction = require(script.Parent.SkillAction);
local RunService = UtilsSystem.RunService;
local Players = UtilsSystem.Players;
local SkillBuffUtil = UtilsSystem.SkillBuffUtil;
local SkillHitPresentation = UtilsSystem.SkillHitPresentation;
local u1 = {};

function u1.__index(p2, p3) -- Line: 37
    -- upvalues: u1 (copy)
    if p3 == "isRunning" then
        return p2:isRunningFlow();
    end;

    return u1[p3];
end;

function u1.getSyncRadius(p4, p5) -- Line: 49
    -- upvalues: SkillDataSchema (copy)
    local v6 = SkillDataSchema.normalizeSkillData(p4.skillModule and p4.skillModule.Data);

    if p5 == "DamageTip" then
        return v6.damageTipRadius;
    end;

    if p5 == "ProjectileHitConfirmed" then
        return v6.hitConfirmRadius;
    end;

    if p5 == "StopSkill" then
        return v6.stopSyncRadius;
    end;

    return v6.syncRadius;
end;

function u1.fireProjectileHitConfirmed(p7, p8, p9, p10, p11) -- Line: 70
    -- upvalues: SkillSyncEventFactory (copy), SkillSyncLog (copy), SkillSyncDispatcher (copy)
    if not (p7.skillCastId and p7.baseSkillInstanceId) then
        return;
    end;

    local v12 = SkillSyncEventFactory.projectileHitConfirmed(p7, p8, p9, p10);

    if p11 then
        for i, v in p11 do
            v12[i] = v;
        end;
    end;

    SkillSyncLog.log(p7.skillName, p7.skillCastId, p7.baseSkillInstanceId, "Server", "ProjectileHitConfirmed", string.format("hitType=%s target=%s", p9, (tostring(p10 or "?"))));
    local v13 = p8 or p7:getCharacterPosition();
    SkillSyncDispatcher.dispatch(p7, "ProjectileHitConfirmed", v12, v13);
end;

function u1.fireProximityStrikeWave(p14, p15, p16, p17) -- Line: 86
    -- upvalues: SkillSyncEventFactory (copy), SkillSyncLog (copy), SkillSyncDispatcher (copy)
    if not (p14.skillCastId and p14.baseSkillInstanceId) then
        return;
    end;

    if type(p17) ~= "table" or #p17 == 0 then
        return;
    end;

    local v18 = SkillSyncEventFactory.proximityStrikeWave(p14, p15, p16, p17);
    SkillSyncLog.log(p14.skillName, p14.skillCastId, p14.baseSkillInstanceId, "Server", "ProximityStrikeWave", string.format("wave=%d count=%d", p15, #p17));
    SkillSyncDispatcher.dispatch(p14, "ProximityStrikeWave", v18, p16);
end;

function u1.fireSolarFlareMeteorShot(p19, p20, p21, p22) -- Line: 113
    -- upvalues: SkillSyncEventFactory (copy), SkillSyncLog (copy), SkillSyncDispatcher (copy)
    if not (p19.skillCastId and p19.baseSkillInstanceId) then
        return;
    end;

    if type(p20) ~= "number" or (typeof(p21) ~= "Vector3" or typeof(p22) ~= "Vector3") then
        return;
    end;

    local v23 = SkillSyncEventFactory.solarFlareMeteorShot(p19, p20, p21, p22);
    SkillSyncLog.log(p19.skillName, p19.skillCastId, p19.baseSkillInstanceId, "Server", "SolarFlareMeteorShot", string.format("idx=%d end=(%.1f,%.1f,%.1f)", p20, p22.X, p22.Y, p22.Z));
    SkillSyncDispatcher.dispatch(p19, "SolarFlareMeteorShot", v23, p22);
end;

function u1.fireProjectilePathConfirmed(p24, p25, p26, p27, p28) -- Line: 140
    -- upvalues: SkillSyncEventFactory (copy), SkillSyncLog (copy), SkillSyncDispatcher (copy)
    if not (p24.skillCastId and p24.baseSkillInstanceId) then
        return;
    end;

    if type(p25) ~= "number" or (typeof(p26) ~= "Vector3" or (typeof(p27) ~= "Vector3" or typeof(p28) ~= "Vector3")) then
        return;
    end;

    local v29 = SkillSyncEventFactory.projectilePathConfirmed(p24, p25, p26, p27, p28);
    SkillSyncLog.log(p24.skillName, p24.skillCastId, p24.baseSkillInstanceId, "Server", "ProjectilePathConfirmed", string.format("idx=%d start=(%.1f,%.1f,%.1f) end=(%.1f,%.1f,%.1f)", p25, p26.X, p26.Y, p26.Z, p27.X, p27.Y, p27.Z));
    SkillSyncDispatcher.dispatch(p24, "ProjectilePathConfirmed", v29, p26);
end;

function u1.getCharacterPosition(p30) -- Line: 181
    local character = p30.character;

    if not character then
        return nil;
    end;

    local v31 = character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart;

    if v31 then
        return v31.Position;
    end;

    return nil;
end;

local function _assembleFromDefinition(p32, p33, p34, p35, p36) -- Line: 192
    p32._definition = p33;
    p32._context = p34;
    p32._runtimeHost = p35;
    p32.skillName = p33.skillName;
    p32.skillModule = p33.skillModule;
    p32.characterId = p34.characterId;
    p32.characterType = p34.characterType;
    p32.isPlayer = p36 == "Player";
    p32.character = p34.character;
    p32.skillID = p34.skillID;
    p32.skillInputData = p34.skillInputData;
    p32.skillTargetData = nil;
    p32.combatSeed = p34.combatSeed;
    p32.skillCastId = p34.skillCastId;
    p32.baseSkillInstanceId = p34.baseSkillInstanceId;
    p32.activeBaseSkillIndex = p34.activeBaseSkillIndex;
    p32.nowTime = 0;
    p32.skillTimeFix = 0;
    p32.skillPlaySpeed = 1;
    p32.timeLineRunServer = nil;
    p32.hitboxControlIndex = 0;
    p32.hitbox = {};
    p32.hitboxRuntime = nil;
    p32.skillRunData = {};
    p32.flowState = "Idle";
    p32.authoritativeState = "Idle";
    p32.controlRuntime = p35.controlRuntime;
    p32.isPhase1Complete = false;
    p32.isControlReleased = false;
    p32._destroyed = false;
    p32._isDestroying = false;
    p32.destroyReason = nil;
    p32.finishReason = nil;
    p32.enteredTerminalAt = nil;
    p32.cleanupCompleted = false;
    p32.skillAction = nil;
end;

function u1.new(p37, p38, p39, p40) -- Line: 239
    -- upvalues: u1 (copy), BaseSkillDefinitionLoader (copy), BaseSkillExecutionContext (copy), AnimationPlaySide (copy), BaseSkillRuntimeHost (copy), _assembleFromDefinition (copy), SkillAction (copy)
    local u41 = setmetatable({}, u1);
    local v42, v43 = BaseSkillDefinitionLoader.load(p37);
    assert(v42, ("[BaseSkillServer] %s"):format(v43 or "加载失败"));
    local v44 = BaseSkillExecutionContext.create({
        characterId = p39,
        characterType = p38,
        skillID = p40
    });
    u41.skillModule = v42.skillModule;
    u41.characterType = p38;
    u41.character = v44.character;
    u41.skillInputData = v44.skillInputData;
    local v45 = AnimationPlaySide.shouldRunServerSkillAction(u41);
    _assembleFromDefinition(u41, v42, v44, BaseSkillRuntimeHost.create(v42, {
        isClient = false,
        getActionsOverCheck = v45 and (function() -- Line: 262
            -- upvalues: u41 (copy)
            return not u41.skillAction and true or u41.skillAction:AreAllActionsOver();
        end or nil) or nil
    }), p38);

    if v45 then
        u41.skillAction = SkillAction.new(u41, {
            serverMode = true
        });

        return u41;
    end;

    u41.skillAction = nil;

    return u41;
end;

function u1.newWithDefinition(p46, p47) -- Line: 285
    -- upvalues: u1 (copy), AnimationPlaySide (copy), BaseSkillRuntimeHost (copy), _assembleFromDefinition (copy), SkillAction (copy)
    local u48 = setmetatable({}, u1);
    u48.skillModule = p46.skillModule;
    u48.characterType = p47.characterType or "NPC";
    u48.character = p47.character;
    u48.skillInputData = p47.skillInputData;
    local v49 = AnimationPlaySide.shouldRunServerSkillAction(u48);
    _assembleFromDefinition(u48, p46, p47, BaseSkillRuntimeHost.create(p46, {
        isClient = false,
        getActionsOverCheck = v49 and (function() -- Line: 294
            -- upvalues: u48 (copy)
            return not u48.skillAction and true or u48.skillAction:AreAllActionsOver();
        end or nil) or nil
    }), p47.characterType or "NPC");

    if v49 then
        u48.skillAction = SkillAction.new(u48, {
            serverMode = true
        });

        return u48;
    end;

    u48.skillAction = nil;

    return u48;
end;

function u1.initSkillMaterial(p50) -- Line: 313
    -- upvalues: BaseSkillRuntimeHost (copy)
    p50._skillMaterialCleared = false;
    p50.skillRunData = BaseSkillRuntimeHost.initMaterial(p50._runtimeHost, p50._definition, {
        isClient = false
    });

    if p50.skillModule.onStartServer then
        p50.skillModule.onStartServer(p50);
    end;
end;

function u1.BindRunConn(p51, p52) -- Line: 327
    local skillRunData = p51.skillRunData;

    if not skillRunData then
        return p52;
    end;

    skillRunData.runEvent = skillRunData.runEvent or {};
    table.insert(skillRunData.runEvent, p52);

    return p52;
end;

function u1.BindStateConn(p53, p54, p55) -- Line: 341
    local skillRunData = p53.skillRunData;

    if not skillRunData then
        return p55;
    end;

    skillRunData.stateEventMap = skillRunData.stateEventMap or {};
    skillRunData.stateEventMap[p54] = skillRunData.stateEventMap[p54] or {};
    table.insert(skillRunData.stateEventMap[p54], p55);

    return p55;
end;

function u1.CleanupStateConns(p56, p57) -- Line: 354
    local skillRunData = p56.skillRunData;

    if not (skillRunData and skillRunData.stateEventMap) then
        return;
    end;

    local v58 = skillRunData.stateEventMap[p57];

    if not v58 then
        return;
    end;

    for _, v in v58 do
        pcall(function() -- Line: 360
            -- upvalues: v (copy)
            if v and typeof(v) == "RBXScriptConnection" then
                v:Disconnect();
            end;
        end);
    end;

    skillRunData.stateEventMap[p57] = nil;
end;

function u1.CleanupAllConns(p59) -- Line: 372
    local skillRunData = p59.skillRunData;

    if not skillRunData then
        return;
    end;

    if skillRunData.runEvent then
        for i, v in pairs(skillRunData.runEvent) do
            pcall(function() -- Line: 377
                -- upvalues: v (copy)
                if v and typeof(v) == "RBXScriptConnection" then
                    v:Disconnect();
                end;
            end);
            skillRunData.runEvent[i] = nil;
        end;

        skillRunData.runEvent = nil;
    end;

    if skillRunData.stateEventMap then
        for i, v in pairs(skillRunData.stateEventMap) do
            for _, v2 in ipairs(v) do
                pcall(function() -- Line: 389
                    -- upvalues: v2 (copy)
                    if v2 and typeof(v2) == "RBXScriptConnection" then
                        v2:Disconnect();
                    end;
                end);
            end;

            skillRunData.stateEventMap[i] = nil;
        end;

        skillRunData.stateEventMap = nil;
    end;
end;

function u1.EnterState(p60, p61, p62) -- Line: 404
    -- upvalues: Players (copy), SkillBuffUtil (copy)
    local skillModule = p60.skillModule;

    if not (skillModule.States and skillModule.States[p61]) then
        return;
    end;

    local v63 = skillModule.States[p61];
    local skillRunData = p60.skillRunData;

    if skillRunData.State then
        skillRunData.State.current = p61;
        skillRunData.State.enteredAt = p60.nowTime;
    end;

    local ControlOpenState = skillModule.ControlOpenState;

    if p60.characterType == "Player" and (ControlOpenState and ControlOpenState == p61) then
        local v64 = tonumber(p60.skillID);
        local v65 = v64 and v64 > 0 and Players:GetPlayerByUserId(p60.characterId);

        if v65 then
            SkillBuffUtil.ApplyBuffsFromSkillForCaster(v65, v64, {});
        end;
    end;

    local OnEnterServer = v63.OnEnterServer;

    if OnEnterServer and skillModule[OnEnterServer] then
        skillModule[OnEnterServer](p60, p62);
    end;
end;

function u1.ExitState(p66, p67, p68) -- Line: 432
    local skillModule = p66.skillModule;

    if not (skillModule.States and skillModule.States[p67]) then
        return;
    end;

    local OnExitServer = skillModule.States[p67].OnExitServer;

    if OnExitServer and skillModule[OnExitServer] then
        skillModule[OnExitServer](p66, p68);
    end;

    p66:CleanupStateConns(p67);
end;

function u1.TryTransition(p69, p70, p71) -- Line: 447
    -- upvalues: SkillStateRuntime (copy)
    return SkillStateRuntime.tryTransition(p69, p70, p71, {
        callEnterHandler = function(p72, p73, p74) -- Line: 449, Name: callEnterHandler
            p72:EnterState(p73, p74);
        end,

        callExitHandler = function(p75, p76, p77) -- Line: 450, Name: callExitHandler
            p75:ExitState(p76, p77);
        end,

        onTerminalReached = function(p78, p79) -- Line: 451, Name: onTerminalReached
            p78:markFinished(p79);
        end,

        onFatalError = function(p80) -- Line: 454, Name: onFatalError
            p80:interrupt();
        end
    });
end;

function u1.markFinished(p81, p82) -- Line: 463
    p81:_finish(p82 == "Finished" and "Finished" or "Interrupted");
end;

function u1.getFlowState(p83) -- Line: 471
    -- upvalues: SkillStateRuntime (copy)
    return SkillStateRuntime.getCurrentState(p83.skillRunData);
end;

function u1.isTerminal(p84) -- Line: 478
    local v85 = p84:getFlowState();

    if not v85 then
        return true;
    end;

    local v86 = p84.skillModule.States and p84.skillModule.States[v85];

    if v86 then
        v86 = v86.IsTerminal == true;
    end;

    return v86;
end;

function u1.isRunningFlow(p87) -- Line: 488
    return not p87:isTerminal();
end;

function u1.GetCurrentState(p88) -- Line: 495
    return p88:getFlowState();
end;

function u1.clearSkillMaterial(p89) -- Line: 503
    if p89._skillMaterialCleared then
        return;
    end;

    p89._skillMaterialCleared = true;
    p89:CleanupAllConns();

    if p89.skillModule and p89.skillModule.onEndServer then
        p89.skillModule.onEndServer(p89);
    end;
end;

function u1.start(u90, p91) -- Line: 519
    -- upvalues: BaseSkillExecutionContext (copy), BaseSkillRuntimeHost (copy), RunService (copy), SkillControlRuntime (copy), SkillEventConst (copy), SkillHitPresentation (copy)
    if u90._destroyed or (u90._isDestroying or u90:isRunningFlow()) then
        return;
    end;

    assert(u90.skillModule.States and u90.skillModule.InitialState, ("[BaseSkillServer] %s 必须定义 States + InitialState（仅支持状态机范式）"):format(u90.skillName));
    BaseSkillExecutionContext.update(u90._context, {
        skillModule = u90.skillModule,
        skillCastId = p91.skillCastId,
        baseSkillInstanceId = p91.baseSkillInstanceId,
        activeBaseSkillIndex = p91.activeBaseSkillIndex,
        combatSeed = p91.combatSeed,
        releaseCF = p91.releaseCF,
        targetCF = p91.targetCF,
        moveDirectionStr = p91.moveDirectionStr,
        trackTargetId = p91.trackTargetId,
        skillTargetData = p91.skillTargetData,
        approachLandWorldPos = p91.approachLandWorldPos,
        moveFaceMode = p91.moveFaceMode,
        moveFaceWorldPos = p91.moveFaceWorldPos,
        multThunderPathPoints = p91.multThunderPathPoints,
        multThunderSpawnGround = p91.multThunderSpawnGround
    });
    u90.skillCastId = u90._context.skillCastId;
    u90.baseSkillInstanceId = u90._context.baseSkillInstanceId;
    u90.activeBaseSkillIndex = u90._context.activeBaseSkillIndex;
    u90.combatSeed = u90._context.combatSeed;
    BaseSkillExecutionContext.refreshCharacter(u90._context);
    u90.character = u90._context.character;
    u90:initSkillMaterial();
    u90.hitbox = BaseSkillRuntimeHost.initHitbox(u90._runtimeHost, u90, {
        characterId = p91.characterId,
        characterType = p91.characterType,
        combatSeed = u90.combatSeed
    });
    u90.hitboxRuntime = u90._runtimeHost.hitboxRuntime;
    u90.flowState = "Running";
    u90.authoritativeState = "Running";
    u90.skillInputData = u90._context.skillInputData;
    u90.skillTargetData = u90.skillInputData.skillTargetData;

    if p91.slotIndex ~= nil and u90.skillInputData then
        u90.skillInputData.slotIndex = p91.slotIndex;
    end;

    if p91._castSnapshotRef ~= nil and u90.skillInputData then
        u90.skillInputData._castSnapshotRef = p91._castSnapshotRef;
    end;

    u90:EnterState(u90.skillModule.InitialState, nil);

    if u90.skillAction then
        u90.skillAction:Init();
        u90.skillAction:Start(u90.nowTime);
    end;

    u90.timeLineRunServer = BaseSkillRuntimeHost.startClock(u90._runtimeHost, RunService, function(p92) -- Line: 579
        -- upvalues: u90 (copy), SkillControlRuntime (ref), SkillEventConst (ref), SkillHitPresentation (ref)
        if u90._destroyed then
            return;
        end;

        local v93 = u90;
        v93.nowTime = v93.nowTime + p92;
        local skillRunData = u90.skillRunData;

        if u90.skillAction then
            u90.skillAction:Run(u90.nowTime);
        end;

        SkillControlRuntime.update(u90.controlRuntime, u90.nowTime, u90);
        u90.isPhase1Complete = u90.controlRuntime.isPhase1Complete;
        u90.isControlReleased = u90.controlRuntime.isControlReleased;
        local SkillStateMachine = require(script.Parent.SkillStateMachine);
        local v94 = u90.skillModule.States and u90.skillModule.States[skillRunData.State.current];

        if v94 and SkillStateMachine.shouldStateTimeout(v94, skillRunData.State.enteredAt, u90.nowTime) then
            u90:TryTransition(SkillEventConst.StateTimeout, nil);

            if not u90:isRunningFlow() then
                return;
            end;
        end;

        for _, v in u90.hitbox do
            if v.isActive then
                local v95 = v:check();

                if v95 and next(v95) then
                    if u90.skillModule.onProjectileHitServer then
                        u90.skillModule.onProjectileHitServer(u90, v, v95);
                    else
                        local HitResolver = require(script.Parent.HitResolver);
                        SkillHitPresentation.beginBatch(v.hitboxOwnerId);

                        for i, v2 in v95 do
                            HitResolver.applyHit(u90, v, v2, i);
                        end;

                        SkillHitPresentation.flushBatch();
                    end;
                end;
            end;
        end;

        local current = skillRunData.State.current;

        if u90.skillModule.Server_UpdateProjectileObstacleCheck and (current == "ProjectileFlying" or current == "ThrownMoving") then
            u90.skillModule.Server_UpdateProjectileObstacleCheck(u90);
        end;
    end);
end;

function u1.getControlState(p96) -- Line: 633
    -- upvalues: SkillControlRuntime (copy)
    return SkillControlRuntime.getState(p96.controlRuntime);
end;

function u1.releaseControl(p97) -- Line: 640
    -- upvalues: SkillControlRuntime (copy)
    SkillControlRuntime.release(p97.controlRuntime, p97.nowTime);
end;

function u1.interruptSkillActionsOnly(p98) -- Line: 647
    -- upvalues: SkillControlRuntime (copy)
    if p98._destroyed or not p98:isRunningFlow() then
        return;
    end;

    if p98.skillAction then
        p98.skillAction:Over(p98.nowTime);
    end;

    SkillControlRuntime.forceMarkPhase1CompleteAndRelease(p98.controlRuntime, p98.nowTime);
    p98.isPhase1Complete = p98.controlRuntime.isPhase1Complete;
    p98.isControlReleased = p98.controlRuntime.isControlReleased;
end;

function u1._finish(p99, p100) -- Line: 665
    -- upvalues: BaseSkillRuntimeHost (copy), SkillSyncLog (copy), SkillSyncDispatcher (copy)
    if p99.flowState == "Finished" or p99.flowState == "Interrupted" then
        return;
    end;

    BaseSkillRuntimeHost.stopClock(p99._runtimeHost);
    p99.timeLineRunServer = nil;

    if p99.skillAction then
        p99.skillAction:Over(p99.nowTime);
    end;

    BaseSkillRuntimeHost.destroyHitbox(p99._runtimeHost);
    p99.hitbox = {};
    p99:clearSkillMaterial();
    p99.skillRunData = {};
    p99.skillInputData = {};
    local v101 = {
        characterId = p99.characterId,
        characterType = p99.characterType,
        skillName = p99.skillName,
        skillCastId = p99.skillCastId,
        baseSkillInstanceId = p99.baseSkillInstanceId,
        reason = p100
    };
    SkillSyncLog.log(p99.skillName, p99.skillCastId, p99.baseSkillInstanceId, "Server", "StopSkill", ("reason=%s"):format(p100));
    local v102 = p99:getCharacterPosition();
    SkillSyncDispatcher.dispatch(p99, "StopSkill", v101, v102);
    p99.nowTime = 0;
    p99.skillTimeFix = 0;
    p99.hitboxControlIndex = 0;
    p99.flowState = p100;
    p99.authoritativeState = p100;
    p99.finishReason = p100;
    p99.enteredTerminalAt = os.clock();
    BaseSkillRuntimeHost.resetControl(p99._runtimeHost);
    p99.isPhase1Complete = p99.controlRuntime.isPhase1Complete;
    p99.isControlReleased = p99.controlRuntime.isControlReleased;
end;

function u1.interrupt(p103) -- Line: 713
    -- upvalues: SkillEventConst (copy)
    if p103:isTerminal() then
        return;
    end;

    if p103:TryTransition(SkillEventConst.Interrupt) then
        return;
    end;

    local skillRunData = p103.skillRunData;

    if skillRunData and skillRunData.State then
        p103:ExitState(skillRunData.State.current, nil);
    end;

    p103:_finish("Interrupted");
end;

function u1.stop(p104) -- Line: 729
    -- upvalues: SkillEventConst (copy)
    if p104:isTerminal() then
        return;
    end;

    if p104:TryTransition(SkillEventConst.ForceFinish) then
        return;
    end;

    local skillRunData = p104.skillRunData;

    if skillRunData and skillRunData.State then
        p104:ExitState(skillRunData.State.current, nil);
    end;

    p104:_finish("Finished");
end;

function u1._forceFinishIfNeeded(p105, p106) -- Line: 742
    if p105:isRunningFlow() then
        if p106 == "Finished" then
            p105:stop();

            return;
        end;

        p105:interrupt();
    end;
end;

function u1._disconnectAll(p107) -- Line: 752
    p107:clearSkillMaterial();
end;

function u1._clearTimers(p108) -- Line: 756
    -- upvalues: BaseSkillRuntimeHost (copy)
    BaseSkillRuntimeHost.stopClock(p108._runtimeHost);
    p108.timeLineRunServer = nil;
end;

function u1._clearHitboxes(p109) -- Line: 761
    -- upvalues: BaseSkillRuntimeHost (copy)
    BaseSkillRuntimeHost.destroyHitbox(p109._runtimeHost);
    p109.hitbox = {};
end;

function u1.destroy(p110, p111) -- Line: 771
    if p110._destroyed or p110._isDestroying then
        return;
    end;

    p110._isDestroying = true;
    local v112 = p111 or "Destroyed";
    p110.destroyReason = v112;
    p110:_forceFinishIfNeeded(v112);
    p110._destroyed = true;
    p110._isDestroying = false;
    p110:_disconnectAll();
    p110:_clearTimers();
    p110:_clearHitboxes();

    if p110.skillAction then
        p110.skillAction:Destroy();
        p110.skillAction = nil;
    end;

    p110.skillRunData = {};
    p110.skillInputData = {};
    p110.skillTargetData = nil;
    p110._runtimeHost = nil;
    p110._definition = nil;
    p110._context = nil;
    p110.cleanupCompleted = true;
end;

function u1.getTargetCF(p113) -- Line: 804
    -- upvalues: PlayerAimSync (copy), ProjectileObjectTracking (copy), BaseSkillTargetFind (copy)
    if not PlayerAimSync.isAutoAimActiveForSkill(p113) then
        return PlayerAimSync.getOrFreezeManualAimCF(p113, PlayerAimSync.getServerBufferedAimCFrame(p113.characterId));
    end;

    local skillInputData = p113.skillInputData;

    if skillInputData and (skillInputData.trackTargetId ~= nil and skillInputData.trackTargetId ~= "") then
        local v114 = ProjectileObjectTracking.getWorldPositionByTrackTargetId(skillInputData.trackTargetId);

        if v114 and p113.skillInputData then
            p113.skillInputData.targetCF = CFrame.new(v114);

            return p113.skillInputData.targetCF;
        end;
    end;

    local v115 = BaseSkillTargetFind.findTarget(p113.skillTargetData);

    if v115 and p113.skillInputData then
        p113.skillInputData.targetCF = v115;
    end;

    return p113.skillInputData and p113.skillInputData.targetCF or CFrame.new();
end;

return u1;