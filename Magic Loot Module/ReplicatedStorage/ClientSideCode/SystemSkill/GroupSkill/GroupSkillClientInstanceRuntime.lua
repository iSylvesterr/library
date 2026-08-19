-- Decompiled with Potassium's decompiler.

local _ = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).RunService;
local BaseSkillClient = require(script.Parent.Parent.BaseSkill.BaseSkillClient);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local ChainConditionContext = require(script.Parent.ChainConditionContext);
local u1 = {};
u1.__index = u1;

function u1.new(p2, p3, p4) -- Line: 29
    -- upvalues: u1 (copy), BaseSkillClient (copy)
    local v5 = setmetatable({}, u1);
    v5.owner = p2;
    v5.skillCastId = p3;
    v5.groupSkillModule = p2.groupSkillModule;
    v5._destroyed = false;
    v5._isDestroying = false;
    v5._destroyGeneration = 0;
    v5.activeBaseSkillIndex = 1;
    v5.baseSkillIndex = 1;
    v5.currentState = "Casting";
    v5.startTime = 0;
    v5.lastSyncTime = 0;
    v5.nowTime = 0;
    v5.activeEffects = {};
    v5._softMergeHadAnimHandoff = false;
    v5.isFinished = false;
    v5.baseSkills = {};
    v5.baseSkillMap = {};
    v5.completedBaseSkillIndex = {};
    v5.deriveRequestByIndex = {};
    v5.inputBuffer = {};
    v5.skillInputData = {
        releaseCF = p4.releaseCF,
        targetCF = p4.targetCF,
        moveDirectionStr = p4.moveDirectionStr,
        trackTargetId = p4.trackTargetId,
        skillTargetData = p4.skillTargetData,
        slotIndex = p2.slotIndex,
        moveFaceMode = p4.moveFaceMode,
        moveFaceWorldPos = p4.moveFaceWorldPos,
        approachLandWorldPos = p4.approachLandWorldPos,
        multThunderPathPoints = p4.multThunderPathPoints,
        multThunderPathPacked = p4.multThunderPathPacked,
        multThunderSpawnGround = p4.multThunderSpawnGround
    };
    local v6 = p4.characterId or p2.characterId;
    local v7 = p4.characterType or p2.characterType;
    local v8 = p2._pendingSoftMergeAnimHandoffForNextRuntime == true;
    v5._softMergeHadAnimHandoff = v8;

    for i, v in p2.groupSkillModule.Skill do
        local v9 = {};

        if i == 1 and v8 then
            v9.skipAnimationCreatePreload = true;
        end;

        if p2.skillID then
            v9.skillID = p2.skillID;
        end;

        local v10 = BaseSkillClient.new(v.baseSkillName, v6, v7, v9);
        v10.combatSeed = p4.combatSeed or p2.combatSeed;
        v10.skillCastId = p3;
        v10.baseSkillInstanceId = p3 .. "_B" .. tostring(i);
        v5.baseSkills[i] = v10;
        v5.baseSkillMap[v10.baseSkillInstanceId] = v10;
    end;

    p2._pendingSoftMergeAnimHandoffForNextRuntime = nil;

    return v5;
end;

function u1.Tick(p11, p12) -- Line: 112
    -- upvalues: SkillEventConst (copy)
    if p11._destroyed or (p11._isDestroying or p11.isFinished) then
        return true;
    end;

    p11.nowTime = p11.nowTime + p12;
    local v13 = p11.baseSkills[p11.activeBaseSkillIndex];

    if not v13 then
        p11.isFinished = true;
        p11.currentState = "Finished";

        return true;
    end;

    if v13:isRunningFlow() and (p11.groupSkillModule and (p11.groupSkillModule.Data and (p11.groupSkillModule.Data.sustainActiveUntilSkillButtonRelease == true and (p11.inputBuffer and (p11.inputBuffer.buttonUp ~= nil and v13:TryTransition(SkillEventConst.SkillButtonRelease)))))) then
        p11.inputBuffer.buttonUp = nil;
    end;

    if not (p11.groupSkillModule.Skill[p11.activeBaseSkillIndex + 1] or v13:isRunningFlow()) then
        p11.isFinished = true;
        p11.currentState = "Finished";

        return true;
    end;

    local v14 = false;

    for _, v in p11.baseSkills do
        if v and (v:isRunningFlow() and not v.isControlReleased) then
            v14 = true;
            break;
        end;
    end;

    p11.currentState = v14 and "Casting" or "Recovering";

    return false;
end;

function u1.start(p15) -- Line: 160
    if p15._destroyed then
        return false;
    end;

    local v16 = p15.baseSkills[1];

    if not v16 then
        return false;
    end;

    local skillInputData = p15.skillInputData;
    local owner = p15.owner;
    v16:setSkillInputData(owner.characterId, owner.characterType, skillInputData.releaseCF, skillInputData.targetCF, skillInputData.moveDirectionStr, p15.skillCastId, v16.baseSkillInstanceId, 1, skillInputData.trackTargetId, skillInputData.skillTargetData);
    local skillInputData2 = v16.skillInputData;

    if skillInputData2 then
        skillInputData2.slotIndex = skillInputData.slotIndex or owner.slotIndex;
        skillInputData2._castSnapshotRef = p15.skillInputData;
    end;

    local MultThunderTramplePath = require(game.ReplicatedStorage.ClientSideCode.SystemSkill.SkillModule.MultThunderTrample1.MultThunderTramplePath);

    if skillInputData2 then
        MultThunderTramplePath.applySyncFieldsToSkillInputData(skillInputData2, skillInputData);
    end;

    local _pendingSoftMergeFirstBaseElapsed = owner._pendingSoftMergeFirstBaseElapsed;
    owner._pendingSoftMergeFirstBaseElapsed = nil;

    if type(_pendingSoftMergeFirstBaseElapsed) == "number" and _pendingSoftMergeFirstBaseElapsed > 0.0001 then
        v16:skillStart({
            softMergeInitialNowTime = _pendingSoftMergeFirstBaseElapsed
        });
    else
        v16:skillStart();
    end;

    return true;
end;

function u1.applyDerived(p17, p18) -- Line: 202
    if p17._destroyed then
        return;
    end;

    local fromBaseSkillIndex = p18.fromBaseSkillIndex;
    local toBaseSkillIndex = p18.toBaseSkillIndex;

    if not (fromBaseSkillIndex and toBaseSkillIndex) then
        return;
    end;

    local v19 = p17.baseSkills[fromBaseSkillIndex];
    local v20 = p17.baseSkills[toBaseSkillIndex];

    if v19 and v19:isRunningFlow() then
        if p18.breakLastSkill then
            v19:skillEnd();
        else
            v19.skillAction:Over(v19.nowTime);
        end;
    end;

    table.insert(p17.completedBaseSkillIndex, fromBaseSkillIndex);
    p17.activeBaseSkillIndex = toBaseSkillIndex;
    p17.baseSkillIndex = toBaseSkillIndex;
    local ProjectileObjectTracking = require(game.ReplicatedStorage.ClientSideCode.SystemSkill.SkillModule._Templates.Projectile.ProjectileObjectTracking);
    local GetSkillData = require(game.ReplicatedStorage.ClientSideCode.SystemSkill.BaseSkill.GetSkillData);
    local v21 = ProjectileObjectTracking.refreshTrackTargetIdForSkillInput({
        objectValueName = "NowTargetCurrent",
        objectValuePathSegments = {}
    });
    p17.skillInputData.trackTargetId = v21;

    if p18.skillTargetData ~= nil then
        p17.skillInputData.skillTargetData = p18.skillTargetData;
    end;

    local _, v22 = GetSkillData.getLocalPlayerSkillInputData();

    if v22 then
        p17.skillInputData.targetCF = v22;
    end;

    if v20 and not v20:isRunningFlow() then
        local owner = p17.owner;
        v20:setSkillInputData(owner.characterId, owner.characterType, p18.releaseCF, p18.targetCF, p18.moveDirectionStr, p18.skillCastId or p17.skillCastId, p18.baseSkillInstanceId or v20.baseSkillInstanceId, p18.activeBaseSkillIndex or toBaseSkillIndex, p18.trackTargetId or p17.skillInputData.trackTargetId, p18.skillTargetData or p17.skillInputData.skillTargetData);
        local skillInputData = v20.skillInputData;

        if skillInputData then
            skillInputData.slotIndex = p17.skillInputData.slotIndex or owner.slotIndex;
            skillInputData._castSnapshotRef = p17.skillInputData;
        end;

        v20:skillStart();
        owner:pushTrackTargetRefresh(p18.skillCastId or p17.skillCastId, p17.skillInputData.trackTargetId, p17.skillInputData.targetCF);
    end;
end;

function u1.fixTime(p23, p24) -- Line: 271
    if p23._destroyed then
        return;
    end;

    local v25 = workspace:GetServerTimeNow() - p24 - p23.nowTime;
    local v26 = p23.baseSkills[p23.activeBaseSkillIndex];

    if v26 then
        v26:setSkillTimeFix(v25);
    end;

    p23.lastSyncTime = p23.nowTime;
end;

function u1.releaseControl(p27) -- Line: 284
    for _, v in p27.baseSkills do
        if v and (v:isRunningFlow() and not v.isControlReleased) then
            v:releaseControl();
        end;
    end;
end;

function u1.stopBaseSkill(p28, p29, p30) -- Line: 298
    local v31 = p28.baseSkillMap and p28.baseSkillMap[p29];

    if v31 and v31:isRunningFlow() then
        v31:skillEnd(nil, p30);
    end;

    local v32 = false;

    for _, v in p28.baseSkills do
        if v and v:isRunningFlow() then
            v32 = true;
            break;
        end;
    end;

    return not v32;
end;

function u1._forceFinishIfNeeded(u33, p34) -- Line: 312
    local _destroyGeneration = u33._destroyGeneration;

    for _, v in u33.baseSkills do
        if v then
            if p34 then
                v:destroy("Interrupted", true);
            else
                if v:isRunningFlow() then
                    v:skillEnd(nil, v.flowState or "Finished");
                end;

                local u35 = v.flowState or "Finished";
                task.delay(v.skillModule and (v.skillModule.visualFadeoutTime or 0) or 0, function() -- Line: 325
                    -- upvalues: u33 (copy), _destroyGeneration (copy), v (copy), u35 (copy)
                    if u33._destroyGeneration ~= _destroyGeneration then
                        return;
                    end;

                    v:destroy(u35, true);
                end);
            end;
        end;
    end;
end;

function u1._clearBuffers(p36) -- Line: 334
    p36.deriveRequestByIndex = {};
    p36.inputBuffer = {};
end;

function u1.GetCurrentBaseSkill(p37) -- Line: 343
    return p37.baseSkills[p37.activeBaseSkillIndex];
end;

function u1.GetCurrentBaseSkillState(p38) -- Line: 351
    local v39 = p38:GetCurrentBaseSkill();

    if v39 and (v39.skillRunData and v39.skillRunData.State) then
        return v39.skillRunData.State.current;
    end;

    return nil;
end;

function u1.GetCurrentBaseSkillStateElapsed(p40) -- Line: 363
    local v41 = p40:GetCurrentBaseSkill();

    if v41 and (v41.skillRunData and v41.skillRunData.State) then
        return v41.nowTime - (v41.skillRunData.State.enteredAt or 0);
    end;

    return nil;
end;

function u1.GetCurrentBaseSkillTotalTime(p42) -- Line: 376
    local v43 = p42:GetCurrentBaseSkill();

    return v43 and v43.nowTime or nil;
end;

function u1.GetCurrentBaseSkillControlState(p44) -- Line: 385
    local v45 = p44:GetCurrentBaseSkill();

    if v45 and type(v45.getControlState) == "function" then
        return v45:getControlState();
    end;

    return nil;
end;

function u1.CheckDeriveRequest(p46, p47, p48) -- Line: 399
    local v49 = p46.deriveRequestByIndex and p46.deriveRequestByIndex[p47];

    if v49 == nil or type(v49) ~= "number" then
        if p46.deriveRequestByIndex and v49 ~= nil then
            p46.deriveRequestByIndex[p47] = nil;
        end;

        return false;
    end;

    if (p48 or 0.25) >= p46.nowTime - v49 then
        return true;
    end;

    p46.deriveRequestByIndex[p47] = nil;

    return false;
end;

function u1.CheckInputBuffered(p50, p51, p52) -- Line: 421
    if p50.inputBuffer and p50.inputBuffer[p51] then
        return p50.nowTime - p50.inputBuffer[p51] <= p52;
    end;

    return false;
end;

function u1.hasRunningBaseSkill(p53) -- Line: 433
    for _, v in p53.baseSkills do
        if v and v:isRunningFlow() then
            return true;
        end;
    end;

    return false;
end;

function u1.getChainConditionContext(p54) -- Line: 446
    -- upvalues: ChainConditionContext (copy)
    if not p54._chainConditionCtx then
        p54._chainConditionCtx = ChainConditionContext.createChainConditionContext(p54);
    end;

    return p54._chainConditionCtx;
end;

function u1.destroy(p55, p56) -- Line: 457
    if p55._destroyed or p55._isDestroying then
        return;
    end;

    p55._isDestroying = true;
    p55._destroyGeneration = (p55._destroyGeneration or 0) + 1;
    p55.isFinished = true;
    p55.currentState = "Finished";
    p55:_forceFinishIfNeeded(p56);
    p55:_clearBuffers();
    p55._destroyed = true;
    p55._isDestroying = false;
    p55.baseSkills = {};
    p55.baseSkillMap = {};
    p55.activeEffects = {};
    p55.owner = nil;
end;

return u1;