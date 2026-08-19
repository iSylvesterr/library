-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local SkillSyncLog = require(game.ReplicatedFirst.AllSideCode.SkillSyncLog);
local SkillSyncEventFactory = require(script.Parent.Parent.BaseSkill.SkillSyncEventFactory);
local ClientObserverDurationEstimator = require(script.Parent.Parent.BaseSkill.ClientObserverDurationEstimator);
local SkillSyncDispatcher = require(script.Parent.Parent.BaseSkill.SkillSyncDispatcher);
local SkillSyncRouter = require(script.Parent.Parent.BaseSkill.SkillSyncRouter);
local GetSkillData = require(script.Parent.Parent.BaseSkill.GetSkillData);
local Players = UtilsSystem.Players;
local RunService = UtilsSystem.RunService;
local BaseSkillServer = require(script.Parent.Parent.BaseSkill.BaseSkillServer);
local DeclarativeCondition = require(script.Parent.DeclarativeCondition);
local ChainConditionContext = require(script.Parent.ChainConditionContext);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local ProjectileObjectTracking = require(script.Parent.Parent.SkillModule._Templates.Projectile.ProjectileObjectTracking);
local u1 = nil;

local function _tryDungeonSkillTrainOnPlayerCast(p2) -- Line: 30
    -- upvalues: RunService (copy), Players (copy), u1 (ref), UtilsSystem (copy)
    if not p2 or (p2.characterType ~= "Player" or not RunService:IsServer()) then
        return;
    end;

    local v3 = Players:GetPlayerByUserId(p2.characterId);

    if not v3 then
        return;
    end;

    if not u1 then
        u1 = UtilsSystem.SystemTrain;
    end;

    if u1 and u1.TryDungeonSkillTrain then
        u1.TryDungeonSkillTrain(v3);
    end;
end;

local function evaluateChainCondition(p4, p5, p6) -- Line: 53
    -- upvalues: DeclarativeCondition (copy)
    if not p4 then
        return false;
    end;

    local condition = p4.condition;

    if condition == nil then
        return false;
    end;

    if DeclarativeCondition.isDeclarative(condition) then
        local success, result = pcall(DeclarativeCondition.evaluate, condition, p5);

        if success then
            return result and true or false;
        end;

        local v7 = p6 or {};
        warn("[GroupSkillInstanceRuntime] 声明式 condition 解析异常:", v7.skillName or "?", v7.skillCastId or "?", v7.fromIndex, "->", v7.toIndex, result);

        return false;
    end;

    if type(condition) ~= "function" then
        return false;
    end;

    local success, result = pcall(condition, p5);

    if success then
        return result and true or false;
    end;

    local v8 = p6 or {};
    warn("[GroupSkillInstanceRuntime] condition 执行异常:", v8.skillName or "?", v8.skillCastId or "?", v8.fromIndex, "->", v8.toIndex, result);

    return false;
end;

local u9 = {};
u9.__index = u9;

function u9.new(p10, p11, p12, p13) -- Line: 97
    -- upvalues: u9 (copy), BaseSkillServer (copy), ChainConditionContext (copy)
    local v14 = setmetatable({}, u9);
    v14.owner = p10;
    v14.skillCastId = p11;
    v14.combatSeed = p13;
    v14._destroyed = false;
    v14._isDestroying = false;
    v14.lifeState = "Created";
    v14.groupSkillModule = p10.groupSkillModule;
    v14.baseSkills = {};
    v14.activeBaseSkillIndex = 1;
    v14.completedBaseSkillIndex = {};
    v14.deriveRequestByIndex = {};
    v14.inputBuffer = {};
    v14.castInputSnapshot = {};

    if p12 then
        if p12.releaseCF ~= nil then
            v14.castInputSnapshot.releaseCF = p12.releaseCF;
        end;

        if p12.targetCF ~= nil then
            v14.castInputSnapshot.targetCF = p12.targetCF;
        end;

        if p12.moveDirectionStr ~= nil then
            v14.castInputSnapshot.moveDirectionStr = p12.moveDirectionStr;
        end;

        if p12.trackTargetId ~= nil then
            v14.castInputSnapshot.trackTargetId = p12.trackTargetId;
        end;

        if p12.skillTargetData ~= nil then
            v14.castInputSnapshot.skillTargetData = p12.skillTargetData;
        end;

        if p12.approachLandWorldPos ~= nil then
            v14.castInputSnapshot.approachLandWorldPos = p12.approachLandWorldPos;
        end;

        if p12.moveFaceMode ~= nil then
            v14.castInputSnapshot.moveFaceMode = p12.moveFaceMode;
        end;

        if p12.moveFaceWorldPos ~= nil then
            v14.castInputSnapshot.moveFaceWorldPos = p12.moveFaceWorldPos;
        end;

        if p12.multThunderPathPoints ~= nil then
            v14.castInputSnapshot.multThunderPathPoints = p12.multThunderPathPoints;
        end;

        if typeof(p12.multThunderSpawnGround) == "Vector3" then
            v14.castInputSnapshot.multThunderSpawnGround = p12.multThunderSpawnGround;
        end;
    end;

    v14.skillRunData = {};
    v14.nowTime = 0;
    v14.startTimestamp = workspace:GetServerTimeNow();

    for i, v in p10.groupSkillModule.Skill do
        local v15 = BaseSkillServer.new(v.baseSkillName, p10.characterType, p10.characterId, p10.skillID);
        v15.combatSeed = p13;
        v15.skillCastId = p11;
        v15.baseSkillInstanceId = p11 .. "_B" .. tostring(i);
        v14.baseSkills[i] = v15;
    end;

    v14._chainConditionCtx = ChainConditionContext.createChainConditionContext(v14);

    return v14;
end;

function u9._testNewWithBaseSkills(p16, p17, p18) -- Line: 161
    -- upvalues: u9 (copy), ChainConditionContext (copy)
    local v19 = setmetatable({}, u9);
    v19.owner = nil;
    v19.skillCastId = p17 or "test_cast";
    v19.combatSeed = p18 or 0;
    v19._destroyed = false;
    v19._isDestroying = false;
    v19.lifeState = "Created";
    v19.groupSkillModule = nil;
    v19.baseSkills = {};

    for i, v in ipairs(p16) do
        v19.baseSkills[i] = v;

        if v then
            v.combatSeed = v19.combatSeed;
            v.skillCastId = v19.skillCastId;
            v.baseSkillInstanceId = (v19.skillCastId or "test") .. "_B" .. tostring(i);
        end;
    end;

    v19.activeBaseSkillIndex = 1;
    v19.completedBaseSkillIndex = {};
    v19.deriveRequestByIndex = {};
    v19.inputBuffer = {};
    v19.castInputSnapshot = {};
    v19.skillRunData = {};
    v19.nowTime = 0;
    v19.startTimestamp = workspace:GetServerTimeNow();
    v19._chainConditionCtx = ChainConditionContext.createChainConditionContext(v19);

    return v19;
end;

function u9.start(p20) -- Line: 198
    -- upvalues: GetSkillData (copy), ProjectileObjectTracking (copy), ClientObserverDurationEstimator (copy), SkillSyncEventFactory (copy), SkillSyncLog (copy), SkillSyncDispatcher (copy), _tryDungeonSkillTrainOnPlayerCast (copy)
    local v21 = p20.baseSkills[1];

    if not v21 then
        warn("[GroupSkillInstanceRuntime] 第一个基础技能不存在");

        return false;
    end;

    local v22 = p20.groupSkillModule.Skill[1];

    if not v22 then
        warn("[GroupSkillInstanceRuntime] 第一个基础技能配置不存在");

        return false;
    end;

    local v23 = GetSkillData.getCharacter(p20.owner.characterType, p20.owner.characterId);
    p20.castInputSnapshot.trackTargetId = ProjectileObjectTracking.resolveTrackTargetIdForProjectileFlying(p20.castInputSnapshot.trackTargetId, p20.castInputSnapshot, v23, p20.owner.characterId, p20.owner.characterType);
    local v24 = {
        activeBaseSkillIndex = 1,
        skipClientSync = true,
        characterType = p20.owner.characterType,
        characterId = p20.owner.characterId,
        skillName = v22.baseSkillName,
        releaseCF = p20.castInputSnapshot.releaseCF,
        targetCF = p20.castInputSnapshot.targetCF,
        combatSeed = p20.combatSeed,
        moveDirectionStr = p20.castInputSnapshot.moveDirectionStr,
        trackTargetId = p20.castInputSnapshot.trackTargetId,
        skillTargetData = p20.castInputSnapshot.skillTargetData
    };
    v24.slotIndex = p20.owner and p20.owner.slotIndex;
    v24.approachLandWorldPos = p20.castInputSnapshot.approachLandWorldPos;
    v24.moveFaceMode = p20.castInputSnapshot.moveFaceMode;
    v24.moveFaceWorldPos = p20.castInputSnapshot.moveFaceWorldPos;
    v24.multThunderPathPoints = p20.castInputSnapshot.multThunderPathPoints;
    v24.multThunderSpawnGround = p20.castInputSnapshot.multThunderSpawnGround;
    v24.skillCastId = p20.skillCastId;
    v24.baseSkillInstanceId = v21.baseSkillInstanceId;
    v24._castSnapshotRef = p20.castInputSnapshot;
    v21:start(v24);
    local skillInputData = v21.skillInputData;

    if skillInputData then
        if skillInputData.multThunderPathPoints ~= nil then
            p20.castInputSnapshot.multThunderPathPoints = skillInputData.multThunderPathPoints;
        end;

        if typeof(skillInputData.multThunderSpawnGround) == "Vector3" then
            p20.castInputSnapshot.multThunderSpawnGround = skillInputData.multThunderSpawnGround;
        end;
    end;

    local v25 = ClientObserverDurationEstimator.estimateForGroupSkill(p20.groupSkillModule);
    local v26 = SkillSyncEventFactory.baseSkillStarted(p20, v22, v25);
    SkillSyncLog.log(p20.owner.skillName, p20.skillCastId, v26.baseSkillInstanceId, "Server", "BaseSkillStarted", "");
    SkillSyncDispatcher.dispatch(p20, "BaseSkillStarted", v26, p20.castInputSnapshot.releaseCF and p20.castInputSnapshot.releaseCF.Position);
    _tryDungeonSkillTrainOnPlayerCast(p20.owner);
    p20.lifeState = "Running";

    return true;
end;

function u9.Tick(p27, p28) -- Line: 271
    -- upvalues: SkillEventConst (copy), SkillSyncEventFactory (copy), SkillSyncLog (copy), GetSkillData (copy), SkillSyncDispatcher (copy), evaluateChainCondition (copy), ProjectileObjectTracking (copy), _tryDungeonSkillTrainOnPlayerCast (copy)
    if p27._destroyed then
        return true;
    end;

    p27.nowTime = p27.nowTime + p28;
    local v29 = p27.baseSkills[p27.activeBaseSkillIndex];

    if not v29 then
        return true;
    end;

    if v29:isRunningFlow() and (p27.groupSkillModule and (p27.groupSkillModule.Data and (p27.groupSkillModule.Data.sustainActiveUntilSkillButtonRelease == true and (p27.inputBuffer and (p27.inputBuffer.buttonUp ~= nil and v29:TryTransition(SkillEventConst.SkillButtonRelease)))))) then
        p27.inputBuffer.buttonUp = nil;
        local v30 = SkillSyncEventFactory.baseSkillStateTransition(p27, v29, SkillEventConst.SkillButtonRelease);
        SkillSyncLog.log(p27.owner.skillName, p27.skillCastId, v29.baseSkillInstanceId, "Server", "BaseSkillStateTransition", SkillEventConst.SkillButtonRelease);
        local v31 = GetSkillData.getCharacter(p27.owner.characterType, p27.owner.characterId);

        if v31 then
            v31 = v31:FindFirstChild("HumanoidRootPart") or v31.PrimaryPart;
        end;

        SkillSyncDispatcher.dispatch(p27, "BaseSkillStateTransition", v30, v31 and v31.Position or p27.castInputSnapshot.releaseCF and p27.castInputSnapshot.releaseCF.Position);
    end;

    local v32 = p27.activeBaseSkillIndex + 1;
    local v33 = p27.groupSkillModule.Skill[v32];

    if not v33 then
        return not v29:isRunningFlow();
    end;

    local _chainConditionCtx = p27._chainConditionCtx;
    local v34 = {};
    v34.skillName = p27.owner and p27.owner.skillName;
    v34.skillCastId = p27.skillCastId;
    v34.fromIndex = p27.activeBaseSkillIndex;
    v34.toIndex = v32;

    if evaluateChainCondition(v33, _chainConditionCtx, v34) then
        local v35 = p27.baseSkills[v32];

        if v35 and not v35:isRunningFlow() then
            if v29:isRunningFlow() then
                if v33.breakLastSkill then
                    SkillSyncLog.log(p27.owner.skillName, p27.skillCastId, v29.baseSkillInstanceId, "Server", "BreakLastSkill", string.format("from=%d to=%d", p27.activeBaseSkillIndex, v32));
                    v29:stop();
                    table.insert(p27.completedBaseSkillIndex, p27.activeBaseSkillIndex);
                end;
            else
                local v36 = false;

                for _, v in p27.completedBaseSkillIndex do
                    if v == p27.activeBaseSkillIndex then
                        v36 = true;
                        break;
                    end;
                end;

                if not v36 then
                    table.insert(p27.completedBaseSkillIndex, p27.activeBaseSkillIndex);
                end;
            end;

            local activeBaseSkillIndex = p27.activeBaseSkillIndex;
            p27.activeBaseSkillIndex = v32;
            local v37 = GetSkillData.getCharacter(p27.owner.characterType, p27.owner.characterId);
            p27.castInputSnapshot.trackTargetId = ProjectileObjectTracking.resolveTrackTargetIdForProjectileFlying(p27.castInputSnapshot.trackTargetId, p27.castInputSnapshot, v37, p27.owner.characterId, p27.owner.characterType);
            local v38 = {
                skipClientSync = true,
                characterType = p27.owner.characterType,
                characterId = p27.owner.characterId,
                skillName = v33.baseSkillName,
                releaseCF = p27.castInputSnapshot.releaseCF,
                targetCF = p27.castInputSnapshot.targetCF,
                combatSeed = p27.combatSeed,
                moveDirectionStr = p27.castInputSnapshot.moveDirectionStr,
                trackTargetId = p27.castInputSnapshot.trackTargetId,
                skillTargetData = p27.castInputSnapshot.skillTargetData
            };
            v38.slotIndex = p27.owner and p27.owner.slotIndex;
            v38.approachLandWorldPos = p27.castInputSnapshot.approachLandWorldPos;
            v38.moveFaceMode = p27.castInputSnapshot.moveFaceMode;
            v38.moveFaceWorldPos = p27.castInputSnapshot.moveFaceWorldPos;
            v38.skillCastId = p27.skillCastId;
            v38.baseSkillInstanceId = v35.baseSkillInstanceId;
            v38.activeBaseSkillIndex = v32;
            v38._castSnapshotRef = p27.castInputSnapshot;
            v35:start(v38);
            local v39 = SkillSyncEventFactory.baseSkillDerived(p27, activeBaseSkillIndex, v32, v35, v33);
            SkillSyncLog.log(p27.owner.skillName, p27.skillCastId, v35.baseSkillInstanceId, "Server", "BaseSkillDerived", string.format("from=%d to=%d breakLast=%s", activeBaseSkillIndex, v32, (tostring(v33.breakLastSkill))));
            local v40 = GetSkillData.getCharacter(p27.owner.characterType, p27.owner.characterId);

            if v40 then
                v40 = v40:FindFirstChild("HumanoidRootPart") or v40.PrimaryPart;
            end;

            SkillSyncDispatcher.dispatch(p27, "Derived", v39, v40 and v40.Position or p27.castInputSnapshot.releaseCF and p27.castInputSnapshot.releaseCF.Position);
            _tryDungeonSkillTrainOnPlayerCast(p27.owner);
            p27.deriveRequestByIndex[v32] = nil;
        end;
    end;

    return false;
end;

function u9.GetCurrentBaseSkill(p41) -- Line: 399
    return p41.baseSkills[p41.activeBaseSkillIndex];
end;

function u9.GetCurrentBaseSkillState(p42) -- Line: 407
    local v43 = p42:GetCurrentBaseSkill();

    if v43 and (v43.skillRunData and v43.skillRunData.State) then
        return v43.skillRunData.State.current;
    end;

    return nil;
end;

function u9.GetCurrentBaseSkillStateElapsed(p44) -- Line: 419
    local v45 = p44:GetCurrentBaseSkill();

    if v45 and (v45.skillRunData and v45.skillRunData.State) then
        return v45.nowTime - (v45.skillRunData.State.enteredAt or 0);
    end;

    return nil;
end;

function u9.GetCurrentBaseSkillTotalTime(p46) -- Line: 432
    local v47 = p46:GetCurrentBaseSkill();

    return v47 and v47.nowTime or nil;
end;

function u9.GetCurrentBaseSkillControlState(p48) -- Line: 441
    local v49 = p48:GetCurrentBaseSkill();

    if v49 and type(v49.getControlState) == "function" then
        return v49:getControlState();
    end;

    return nil;
end;

function u9.CheckDeriveRequest(p50, p51, p52) -- Line: 453
    local v53 = p50.deriveRequestByIndex and p50.deriveRequestByIndex[p51];

    if v53 == nil or type(v53) ~= "number" then
        if p50.deriveRequestByIndex and v53 ~= nil then
            p50.deriveRequestByIndex[p51] = nil;
        end;

        return false;
    end;

    if (p52 or 0.25) >= p50.nowTime - v53 then
        return true;
    end;

    p50.deriveRequestByIndex[p51] = nil;

    return false;
end;

function u9.CheckInputBuffered(p54, p55, p56) -- Line: 475
    if p54.inputBuffer and p54.inputBuffer[p55] then
        return p54.nowTime - p54.inputBuffer[p55] <= p56;
    end;

    return false;
end;

function u9.CheckInputFlag(p57, p58) -- Line: 485
    return p57:CheckInputBuffered(p58, 0.3);
end;

function u9.isFinished(p59) -- Line: 492
    return not p59:hasRunningBaseSkill();
end;

function u9.hasRunningBaseSkill(p60) -- Line: 499
    for _, v in p60.baseSkills do
        if v and v:isRunningFlow() then
            return true;
        end;
    end;

    return false;
end;

function u9.applyInputRequest(p61, p62, p63, p64) -- Line: 512
    -- upvalues: ProjectileObjectTracking (copy)
    if p61._destroyed then
        return;
    end;

    if p62 then
        p61.castInputSnapshot = p61.castInputSnapshot or {};

        if p62.releaseCF ~= nil then
            p61.castInputSnapshot.releaseCF = p62.releaseCF;
        end;

        if p62.targetCF ~= nil then
            p61.castInputSnapshot.targetCF = p62.targetCF;
        end;

        if p62.moveDirectionStr ~= nil then
            p61.castInputSnapshot.moveDirectionStr = p62.moveDirectionStr;
        end;

        if p62.trackTargetRefreshOnly == true then
            p61.castInputSnapshot.trackTargetId = ProjectileObjectTracking.sanitizeTrackTargetId(p62.trackTargetId);
        elseif p62.trackTargetId ~= nil then
            p61.castInputSnapshot.trackTargetId = ProjectileObjectTracking.sanitizeTrackTargetId(p62.trackTargetId);
        end;

        if p62.skillTargetData ~= nil then
            p61.castInputSnapshot.skillTargetData = p62.skillTargetData;
        end;

        if p62.approachLandWorldPos ~= nil then
            p61.castInputSnapshot.approachLandWorldPos = p62.approachLandWorldPos;
        end;

        if p62.moveFaceMode ~= nil then
            p61.castInputSnapshot.moveFaceMode = p62.moveFaceMode;
        end;

        if p62.moveFaceWorldPos ~= nil then
            p61.castInputSnapshot.moveFaceWorldPos = p62.moveFaceWorldPos;
        end;
    end;

    if p63 then
        p61.inputBuffer[p63] = p61.nowTime;
    end;

    if p64 then
        p61.deriveRequestByIndex[p64] = p61.nowTime;
    end;
end;

function u9.releaseControl(p65) -- Line: 554
    for _, v in p65.baseSkills do
        if v and (v:isRunningFlow() and not v.isControlReleased) then
            v:releaseControl();
        end;
    end;
end;

function u9.stop(p66) -- Line: 565
    for _, v in p66.baseSkills do
        if v and v:isRunningFlow() then
            v:stop();
        end;
    end;
end;

function u9._forceFinishIfNeeded(p67, p68) -- Line: 574
    for _, v in p67.baseSkills do
        if v and v:isRunningFlow() then
            if p68 == "Finished" then
                v:stop();
            else
                v:interrupt();
            end;
        end;
    end;
end;

function u9._clearAudienceTracking(p69) -- Line: 586
    -- upvalues: SkillSyncRouter (copy)
    SkillSyncRouter.clearAudience(p69.skillCastId);
end;

function u9._clearBuffers(p70) -- Line: 590
    p70.deriveRequestByIndex = {};
    p70.inputBuffer = {};
end;

function u9.destroy(p71, p72) -- Line: 599
    if p71._destroyed or p71._isDestroying then
        return;
    end;

    p71._isDestroying = true;
    local v73 = p72 or "Destroyed";
    p71:_forceFinishIfNeeded(v73);

    for _, v in p71.baseSkills do
        if v then
            v:destroy(v73 == "Finished" and "Finished" or "Interrupted");
        end;
    end;

    p71:_clearAudienceTracking();
    p71:_clearBuffers();
    p71._destroyed = true;
    p71._isDestroying = false;
    p71.baseSkills = {};
    p71._chainConditionCtx = nil;
    p71.lifeState = "Disposed";
    p71.owner = nil;
end;

return u9;