-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillSyncLog = require(game.ReplicatedFirst.AllSideCode.SkillSyncLog);
local _ = UtilsSystem.Players;
local CfgFind = UtilsSystem.CfgFind;
local EnumMgr = UtilsSystem.EnumMgr;
local NetWork = UtilsSystem.NetWork;
local NetMsg = UtilsSystem.NetMsg;
local RunService = UtilsSystem.RunService;
local BaseSkillClient = require(script.Parent.Parent.BaseSkill.BaseSkillClient);
local BaseSkillDefinitionLoader = require(script.Parent.Parent.BaseSkill.BaseSkillDefinitionLoader);
local GetSkillData = require(script.Parent.Parent.BaseSkill.GetSkillData);
local SkillModuleValidator = require(script.Parent.Parent.BaseSkill.SkillModuleValidator);
local SkillDataSchema = require(script.Parent.Parent.BaseSkill.SkillDataSchema);
local GroupSkillClientInstanceRuntime = require(script.Parent.GroupSkillClientInstanceRuntime);
local ProjectileObjectTracking = require(script.Parent.Parent.SkillModule._Templates.Projectile.ProjectileObjectTracking);
local LocalPlayer = UtilsSystem.LocalPlayer;
local GroupSkillModule = script.Parent.Parent.GroupSkillModule;

local function resolveInterruptionPriorityFromModule(p1) -- Line: 46
    local InterruptionPriority = p1.InterruptionPriority;

    if InterruptionPriority == nil then
        InterruptionPriority = p1.PriorityInterruption;
    end;

    local Data = p1.Data;

    if InterruptionPriority == nil and type(Data) == "table" then
        InterruptionPriority = Data.InterruptionPriority or Data.interruptionPriority;
    end;

    return (type(InterruptionPriority) ~= "number" or InterruptionPriority ~= InterruptionPriority) and (1 / 0) or InterruptionPriority;
end;

local u2 = {};
u2.__index = u2;

local function resolveBaseCooldownSeconds(p3, p4) -- Line: 68
    -- upvalues: CfgFind (copy), EnumMgr (copy)
    local v5 = p3 and p3 > 0 and CfgFind.FindCfgByID(p3, EnumMgr.ItemType.Skill);

    if v5 then
        local CD = v5.CD;

        if type(CD) == "number" and CD >= 0 then
            return CD;
        end;

        local v6 = tonumber(CD);

        if v6 and v6 >= 0 then
            return v6;
        end;
    end;

    return p4;
end;

function u2.new(p7, p8, p9, p10, p11) -- Line: 90
    -- upvalues: u2 (copy), GroupSkillModule (copy), SkillModuleValidator (copy), SkillDataSchema (copy), CfgFind (copy), EnumMgr (copy), LocalPlayer (copy), RunService (copy)
    local u12 = setmetatable({}, u2);
    u12.authoritativeState = "Idle";
    u12.skillName = p7;
    u12.skillID = p11;
    local v13 = GroupSkillModule:FindFirstChild(u12.skillName);

    if not v13 then
        warn("组技能模块未找到", u12.skillName);

        return nil;
    end;

    local v14 = require(v13);
    local SkillModule = script.Parent.Parent.SkillModule;
    local validateForRelease = SkillModuleValidator.validateForRelease;
    local v17 = {
        env = "production",
        skillName = u12.skillName,
        moduleScriptName = v13.Name,

        resolveBaseSkill = function(p15) -- Line: 105, Name: resolveBaseSkill
            -- upvalues: SkillModule (copy)
            local v16 = SkillModule:FindFirstChild(p15);

            if not (v16 and v16:IsA("ModuleScript")) then
                return nil;
            end;

            local success, result = pcall(require, v16);

            return success and result and result or nil;
        end
    };
    local v18;

    if v14.Data then
        v18 = v14.Data.suppressions or nil;
    else
        v18 = nil;
    end;

    v17.suppressions = v18;
    local v19, v20 = validateForRelease("GroupSkill", v14, v17);

    if not v19 then
        SkillModuleValidator.failOnError(u12.skillName, v20, true);
    end;

    if v14.Data then
        v14.Data = SkillDataSchema.normalizeSkillData(v14.Data);
    end;

    u12.groupSkillModule = v14;
    local InterruptionPriority = v14.InterruptionPriority;

    if InterruptionPriority == nil then
        InterruptionPriority = v14.PriorityInterruption;
    end;

    local Data = v14.Data;

    if InterruptionPriority == nil and type(Data) == "table" then
        InterruptionPriority = Data.InterruptionPriority or Data.interruptionPriority;
    end;

    u12.interruptionPriority = (type(InterruptionPriority) ~= "number" or InterruptionPriority ~= InterruptionPriority) and (1 / 0) or InterruptionPriority;
    u12.slotIndex = p8;
    u12.characterId = p9;
    u12.characterType = p10;
    u12.nowTime = 0;
    u12.skillPlaySpeed = 1;
    u12.runningBaseSkillInstances = {};
    u12.instanceMap = {};
    u12.lastDerivableSkillCastId = nil;
    u12.visualSeed = math.random(1, 1000000);
    u12.combatSeed = nil;
    u12._presentationPredict = nil;
    u12._presentationPredictEpoch = 0;
    u12._lastPresentationPredictCastId = nil;
    u12._presentationPredictStartClock = nil;
    u12._pendingSoftMergeFirstBaseElapsed = nil;
    u12._pendingSoftMergeAnimHandoffForNextRuntime = nil;
    u12._sustainAwaitingFirstInstanceFromReleaseRequest = false;
    u12._pendingEarlyButtonUpForSustainHold = false;
    u12.completedBaseSkillIndex = {};
    u12.activeBaseSkillIndex = 1;
    u12.skillRunData = {};
    u12.skillInputData = {};
    u12.groupSkillRuntimeEvent = nil;
    u12.deriveRequestByIndex = {};
    u12.inputFlagsByName = {};
    u12.deriveSuppressedAfterCrossInterrupt = false;
    local skillCooldown = v14.Data.skillCooldown;

    if p11 and p11 > 0 then
        local v21 = CfgFind.FindCfgByID(p11, EnumMgr.ItemType.Skill);

        if v21 then
            local CD = v21.CD;

            if type(CD) == "number" and CD >= 0 then
                skillCooldown = CD;
            else
                local v22 = tonumber(CD);

                if v22 and v22 >= 0 then
                    skillCooldown = v22;
                end;
            end;
        end;
    end;

    u12.groupSkillCooldown = skillCooldown;
    u12.groupSkillCooldownRemaining = 0;
    u12.groupSkillCooldownEvent = nil;
    local v23;

    if p10 == "Player" then
        v23 = p9 == LocalPlayer.UserId;
    else
        v23 = false;
    end;

    if not v23 then
        u12.groupSkillCooldownEvent = RunService.Heartbeat:Connect(function(p24) -- Line: 182
            -- upvalues: u12 (copy)
            if u12.groupSkillCooldownRemaining > 0 then
                if p24 < u12.groupSkillCooldownRemaining then
                    local v25 = u12;
                    v25.groupSkillCooldownRemaining = v25.groupSkillCooldownRemaining - p24;

                    return;
                end;

                u12.groupSkillCooldownRemaining = 0;
            end;
        end);
    end;

    return u12;
end;

function u2.isCooldownActiveByTimestamp(p26) -- Line: 199
    -- upvalues: LocalPlayer (copy)
    if p26.characterType ~= "Player" or p26.characterId ~= LocalPlayer.UserId then
        return p26.groupSkillCooldownRemaining > 0;
    end;

    local v27 = LocalPlayer:FindFirstChild("技能CD时间戳");

    if not (v27 and (v27:IsA("Folder") and p26.slotIndex)) then
        return false;
    end;

    local v28 = v27:FindFirstChild("Slot" .. tostring(p26.slotIndex));

    if v28 and v28:IsA("NumberValue") then
        return workspace:GetServerTimeNow() < v28.Value;
    end;

    return false;
end;

function u2.fixSkillTime(p29, p30, p31, p32) -- Line: 221
    if p32 then
        local v33 = p29.instanceMap[p32];

        if v33 and v33.fixTime then
            v33:fixTime(p30);
        end;
    else
        for _, v in pairs(p29.instanceMap) do
            if v and v.fixTime then
                v:fixTime(p30);
            end;
        end;
    end;
end;

function u2.updateSkillInput(p34, p35, p36) -- Line: 242
    -- upvalues: GetSkillData (copy), LocalPlayer (copy), ProjectileObjectTracking (copy)
    local v37 = GetSkillData.getCharacter(p34.characterType, p34.characterId);
    local v38 = GetSkillData.getCharacterDirectionStr(v37);
    local v39;

    if p34.characterType == "Player" and p34.characterId == LocalPlayer.UserId then
        v39 = ProjectileObjectTracking.getTrackTargetIdForSkillInput();
    else
        v39 = nil;
    end;

    p34.skillInputData = {
        skillName = nil,
        characterId = p34.characterId,
        characterType = p34.characterType,
        releaseCF = p35,
        targetCF = p36,
        moveDirectionStr = v38,
        trackTargetId = v39
    };
end;

function u2.hasActiveRuntime(p40) -- Line: 273
    return next(p40.instanceMap) ~= nil;
end;

function u2.hasActiveBaseSkill(p41) -- Line: 280
    for _, v in pairs(p41.instanceMap) do
        if v and v.baseSkills then
            for _, v2 in v.baseSkills do
                if v2 and v2:isRunningFlow() then
                    return true;
                end;
            end;
        end;
    end;

    return false;
end;

function u2.hasPhase1Incomplete(p42) -- Line: 293
    for _, v in pairs(p42.instanceMap) do
        local v43 = v.baseSkills and v.baseSkills[v.activeBaseSkillIndex];

        if v43 and (v43:isRunningFlow() and not v43.isPhase1Complete) then
            return true;
        end;
    end;

    return false;
end;

local function _getWindowNameFromCondition(p44) -- Line: 308
    -- upvalues: _getWindowNameFromCondition (copy)
    if type(p44) ~= "table" then
        return nil;
    end;

    if p44.type == "window" and type(p44.name) == "string" then
        return p44.name;
    end;

    local v45 = p44.all or p44.any;

    if type(v45) == "table" then
        for _, v in v45 do
            local v46 = _getWindowNameFromCondition(v);

            if v46 then
                return v46;
            end;
        end;
    end;

    return nil;
end;

function u2.getActiveAutoCastRuntime(p47) -- Line: 331
    if p47.lastDerivableSkillCastId then
        local v48 = p47.instanceMap[p47.lastDerivableSkillCastId];

        if v48 and (not v48.isFinished and (v48.hasRunningBaseSkill and v48:hasRunningBaseSkill())) then
            return v48;
        end;
    end;

    for _, v in pairs(p47.instanceMap) do
        if v and (not v.isFinished and (v.hasRunningBaseSkill and v:hasRunningBaseSkill())) then
            return v;
        end;
    end;

    return nil;
end;

function u2.canAutoCastDeriveInput(p49) -- Line: 350
    -- upvalues: _getWindowNameFromCondition (copy)
    local v50 = p49:getActiveAutoCastRuntime();

    if not v50 then
        return false;
    end;

    local v51 = v50.activeBaseSkillIndex + 1;
    local v52 = p49.groupSkillModule.Skill[v51];

    if not v52 then
        return false;
    end;

    if v50:CheckDeriveRequest(v51, 0.25) then
        return false;
    end;

    local v53 = _getWindowNameFromCondition(v52.condition);

    if v53 then
        if not v50:getChainConditionContext().InWindow(v53) then
            return false;
        end;
    elseif not p49:shouldBypassCooldownForLocalPress() then
        return false;
    end;

    return p49:shouldBypassCooldownForLocalPress() and true or v50:GetCurrentBaseSkillControlState() == "ChainOpen";
end;

function u2.sendAutoCastDeriveInput(p54) -- Line: 388
    -- upvalues: NetWork (copy), NetMsg (copy)
    if not p54:canAutoCastDeriveInput() then
        return false;
    end;

    local v55 = p54:getActiveAutoCastRuntime();

    if not v55 then
        return false;
    end;

    local v56 = v55.activeBaseSkillIndex + 1;
    v55.inputBuffer = v55.inputBuffer or {};
    v55.deriveRequestByIndex = v55.deriveRequestByIndex or {};
    v55.inputBuffer.buttonDown = v55.nowTime;
    v55.deriveRequestByIndex[v56] = v55.nowTime;
    p54:onInputRequest("buttonDown", true);
    NetWork.FireServer(NetMsg.RELEASE_GROUP_SKILL, p54.slotIndex, {
        releaseCF = p54.skillInputData.releaseCF,
        targetCF = p54.skillInputData.targetCF,
        moveDirectionStr = p54.skillInputData.moveDirectionStr,
        trackTargetId = p54.skillInputData.trackTargetId,
        skillCastId = p54.lastDerivableSkillCastId or v55.skillCastId
    });

    return true;
end;

function u2.pushTrackTargetRefresh(p57, p58, p59, p60) -- Line: 423
    -- upvalues: NetWork (copy), NetMsg (copy)
    if not (p58 and p57.instanceMap[p58]) then
        return;
    end;

    NetWork.FireServer(NetMsg.RELEASE_GROUP_SKILL, p57.slotIndex, {
        trackTargetRefreshOnly = true,
        skillCastId = p58,
        trackTargetId = p59,
        targetCF = p60
    });
end;

function u2.getInterruptionPriority(p61) -- Line: 435
    return p61.interruptionPriority or (1 / 0);
end;

function u2.interruptAllCastingForCrossSlot(p62) -- Line: 442
    p62:clearPresentationPredict();
    p62.deriveRequestByIndex = {};
    p62.inputFlagsByName = {};

    for _, v in pairs(p62.instanceMap) do
        if v and v._clearBuffers then
            v:_clearBuffers();
        end;

        if v and v.baseSkills then
            for _, v2 in v.baseSkills do
                if v2 and (v2.isRunningFlow and (v2:isRunningFlow() and v2.interruptSkillActionsOnly)) then
                    v2:interruptSkillActionsOnly();
                end;
            end;
        end;
    end;
end;

function u2.shouldBypassCooldownForLocalPress(p63) -- Line: 467
    if not p63:hasPhase1Incomplete() then
        return false;
    end;

    for _, v in pairs(p63.instanceMap) do
        local v64 = false;

        for _, v2 in v.baseSkills do
            if v2 and v2:isRunningFlow() then
                v64 = true;
                break;
            end;
        end;

        if v64 and p63.groupSkillModule.Skill[v.activeBaseSkillIndex + 1] then
            return true;
        end;
    end;

    return false;
end;

function u2.onInputBegan(p65) -- Line: 500
    -- upvalues: NetWork (copy), NetMsg (copy), UtilsSystem (copy), LocalPlayer (copy)
    if p65:shouldBypassCooldownForLocalPress() then
        p65:onInputRequest("buttonDown", true);
        NetWork.FireServer(NetMsg.RELEASE_GROUP_SKILL, p65.slotIndex, {
            releaseCF = p65.skillInputData.releaseCF,
            targetCF = p65.skillInputData.targetCF,
            moveDirectionStr = p65.skillInputData.moveDirectionStr,
            trackTargetId = p65.skillInputData.trackTargetId,
            skillCastId = p65.lastDerivableSkillCastId
        });

        return;
    end;

    local v66 = p65._hubSkipCooldownOnce == true;
    p65._hubSkipCooldownOnce = nil;

    if p65:isCooldownActiveByTimestamp() and not v66 then
        return;
    end;

    p65.pendingReleaseData = {
        releaseCF = p65.skillInputData.releaseCF,
        targetCF = p65.skillInputData.targetCF,
        moveDirectionStr = p65.skillInputData.moveDirectionStr,
        trackTargetId = p65.skillInputData.trackTargetId
    };
    local v67 = UtilsSystem.HttpService:GenerateGUID(false);
    local v68 = {
        characterId = p65.skillInputData.characterId,
        characterType = p65.skillInputData.characterType,
        skillName = p65.skillInputData.skillName,
        releaseCF = p65.skillInputData.releaseCF,
        targetCF = p65.skillInputData.targetCF,
        moveDirectionStr = p65.skillInputData.moveDirectionStr,
        trackTargetId = p65.skillInputData.trackTargetId,
        clientPredictCastId = v67
    };
    p65._lastPresentationPredictCastId = v67;
    p65._presentationPredictStartClock = os.clock();
    NetWork.FireServer(NetMsg.RELEASE_GROUP_SKILL, p65.slotIndex, v68);
    p65:_tryStartPresentationPredict(v67, p65.pendingReleaseData);

    if p65.groupSkillModule.Data and p65.groupSkillModule.Data.sustainActiveUntilSkillButtonRelease == true and (p65.characterType == "Player" and p65.characterId == LocalPlayer.UserId) then
        p65._sustainAwaitingFirstInstanceFromReleaseRequest = true;
        p65._pendingEarlyButtonUpForSustainHold = false;
    end;
end;

function u2._applyLocalSustainHoldButtonRelease(p69) -- Line: 562
    -- upvalues: LocalPlayer (copy), NetWork (copy), NetMsg (copy)
    if p69:hasPhase1Incomplete() then
        p69:onInputRequest("buttonUp", false);
    end;

    if p69.groupSkillModule.Data and p69.groupSkillModule.Data.sustainActiveUntilSkillButtonRelease == true and (p69.characterType == "Player" and p69.characterId == LocalPlayer.UserId) then
        local lastDerivableSkillCastId = p69.lastDerivableSkillCastId;

        if p69:hasPhase1Incomplete() and lastDerivableSkillCastId then
            NetWork.FireServer(NetMsg.RELEASE_GROUP_SKILL, p69.slotIndex, {
                skillButtonPhase = "up",
                characterId = p69.skillInputData.characterId,
                characterType = p69.skillInputData.characterType,
                skillCastId = lastDerivableSkillCastId,
                releaseCF = p69.skillInputData.releaseCF,
                targetCF = p69.skillInputData.targetCF,
                moveDirectionStr = p69.skillInputData.moveDirectionStr,
                trackTargetId = p69.skillInputData.trackTargetId
            });
        end;
    end;
end;

function u2.onInputEnded(p70) -- Line: 590
    -- upvalues: LocalPlayer (copy)
    local v71;

    if p70.characterType == "Player" then
        v71 = p70.characterId == LocalPlayer.UserId;
    else
        v71 = false;
    end;

    if p70.groupSkillModule.Data and p70.groupSkillModule.Data.sustainActiveUntilSkillButtonRelease == true and (v71 and (not p70:hasPhase1Incomplete() and p70._sustainAwaitingFirstInstanceFromReleaseRequest)) then
        p70._pendingEarlyButtonUpForSustainHold = true;
    end;

    p70:_applyLocalSustainHoldButtonRelease();
end;

function u2.onInputRequest(p72, p73, p74) -- Line: 605
    if p72:hasPhase1Incomplete() then
        local v75 = {};
        local v76 = p72.lastDerivableSkillCastId and p72.instanceMap[p72.lastDerivableSkillCastId];

        if v76 then
            table.insert(v75, v76);
        end;

        if #v75 == 0 then
            for _, v in pairs(p72.instanceMap) do
                table.insert(v75, v);
            end;
        end;

        for _, v in ipairs(v75) do
            local v77 = false;

            for _, v2 in v.baseSkills do
                if v2 and v2:isRunningFlow() then
                    v77 = true;
                    break;
                end;
            end;

            if v77 then
                local v78 = v.activeBaseSkillIndex + 1;
                local v79 = p72.groupSkillModule.Skill[v78];
                v.inputBuffer = v.inputBuffer or {};
                v.inputBuffer[p73] = v.nowTime;

                if p74 and v79 then
                    v.deriveRequestByIndex[v78] = v.nowTime;
                end;
            end;
        end;
    end;
end;

function u2.clearPresentationPredict(p80, p81) -- Line: 646
    local v82 = p81 ~= false;
    local _presentationPredict = p80._presentationPredict;

    if not _presentationPredict then
        if v82 then
            p80._lastPresentationPredictCastId = nil;
            p80._presentationPredictStartClock = nil;
        end;

        return;
    end;

    p80._presentationPredict = nil;

    if _presentationPredict.client then
        _presentationPredict.client:destroy("Interrupted", true);
    end;

    if type(_presentationPredict.cleanup) == "function" then
        _presentationPredict.cleanup();
    end;

    if v82 then
        p80._lastPresentationPredictCastId = nil;
        p80._presentationPredictStartClock = nil;
    end;
end;

function u2._getFirstBaseSkillInitialStateDurationCap(p83) -- Line: 672
    -- upvalues: BaseSkillDefinitionLoader (copy)
    local groupSkillModule = p83.groupSkillModule;
    local v84 = groupSkillModule.Skill and groupSkillModule.Skill[1];

    if not v84 or type(v84.baseSkillName) ~= "string" then
        return nil;
    end;

    local v85, _ = BaseSkillDefinitionLoader.load(v84.baseSkillName);

    if not (v85 and (v85.skillModule and (v85.skillModule.States and v85.skillModule.InitialState))) then
        return nil;
    end;

    local InitialState = v85.skillModule.InitialState;
    local v86 = v85.skillModule.States[InitialState] and v85.skillModule.States[InitialState].Duration;

    if type(v86) == "number" and v86 >= 0 then
        return v86;
    end;

    return nil;
end;

function u2._takePresentationPredictSoftMergeElapsed(p87, p88) -- Line: 693
    if not p88 or p88 ~= p87._lastPresentationPredictCastId then
        return nil;
    end;

    if not p87.groupSkillModule.Data.predictPresentation then
        return nil;
    end;

    local v89 = p87:_getFirstBaseSkillInitialStateDurationCap();
    local _presentationPredict = p87._presentationPredict;
    local v90 = not (_presentationPredict and _presentationPredict.client) and 0 or _presentationPredict.client.nowTime;

    if v90 < 0.001 and p87._presentationPredictStartClock then
        v90 = os.clock() - p87._presentationPredictStartClock;
    end;

    if v89 then
        v90 = math.min(v90, v89);
    end;

    if v90 < 0.0001 then
        return nil;
    end;

    return v90;
end;

function u2._tryStartPresentationPredict(u91, u92, u93) -- Line: 728
    -- upvalues: BaseSkillClient (copy)
    u91:clearPresentationPredict(false);
    local groupSkillModule = u91.groupSkillModule;
    local v94;

    if groupSkillModule then
        v94 = groupSkillModule.Data;
    else
        v94 = groupSkillModule;
    end;

    if not (v94 and v94.predictPresentation) then
        return;
    end;

    local u95 = groupSkillModule.Skill and groupSkillModule.Skill[1];

    if not u95 or type(u95.baseSkillName) ~= "string" then
        return;
    end;

    local success, result = pcall(function() -- Line: 741
        -- upvalues: BaseSkillClient (ref), u95 (copy), u91 (copy), u93 (copy), u92 (copy)
        local u96 = BaseSkillClient.new(u95.baseSkillName, u91.characterId, u91.characterType, {
            skillID = u91.skillID
        });
        u96:setSkillInputData(u91.characterId, u91.characterType, u93.releaseCF, u93.targetCF, u93.moveDirectionStr, u92, u92 .. "_B1", 1, u93.trackTargetId, u93.skillTargetData);
        u96.combatSeed = u91.combatSeed or 0;
        u96:skillStartPresentationPredict();
        local v97 = u91;
        v97._presentationPredictEpoch = v97._presentationPredictEpoch + 1;
        local _presentationPredictEpoch = u91._presentationPredictEpoch;
        u91._presentationPredict = {
            client = u96,
            epoch = _presentationPredictEpoch
        };
        task.delay(5, function() -- Line: 766
            -- upvalues: u91 (ref), _presentationPredictEpoch (copy), u96 (copy)
            local _presentationPredict = u91._presentationPredict;

            if _presentationPredict and (_presentationPredict.epoch == _presentationPredictEpoch and _presentationPredict.client == u96) then
                u91:clearPresentationPredict();
            end;
        end);
    end);

    if not success then
        warn("[GroupSkillClient] 表现预测启动失败:", u91.skillName, result);
    end;
end;

function u2.requestRelease(p98, p99, p100, p101) -- Line: 780
    if p99 == true then
        return;
    end;

    warn("[GroupSkillClient] 客户端禁止无服务器确认直接创建技能实例");
end;

function u2._createInstanceFromServerData(u102, p103) -- Line: 792
    -- upvalues: SkillSyncLog (copy), LocalPlayer (copy), GroupSkillClientInstanceRuntime (copy), RunService (copy)
    local skillCastId = p103.skillCastId;

    if not skillCastId then
        return;
    end;

    if u102.instanceMap[skillCastId] then
        return;
    end;

    local v104 = u102:_takePresentationPredictSoftMergeElapsed(skillCastId);
    local _presentationPredict = u102._presentationPredict;
    local v105 = _presentationPredict and _presentationPredict.client;

    if v105 then
        if type(v104) == "number" and v104 > 0.0001 then
            v105 = _presentationPredict.client:isRunningFlow();
        else
            v105 = false;
        end;
    end;

    if v105 then
        _presentationPredict.client._presentationPredictAnimHandoff = true;
    end;

    u102:clearPresentationPredict();
    u102._pendingSoftMergeFirstBaseElapsed = v104;
    u102._pendingSoftMergeAnimHandoffForNextRuntime = v105 == true;
    SkillSyncLog.log(u102.skillName, skillCastId, p103.baseSkillInstanceId or skillCastId .. "_B1", "Client", "InstanceCreated", "");

    if u102.characterType ~= "Player" or u102.characterId ~= LocalPlayer.UserId then
        u102.groupSkillCooldownRemaining = u102.groupSkillCooldown;
    end;

    if p103.combatSeed then
        u102.combatSeed = p103.combatSeed;
    end;

    local v106 = GroupSkillClientInstanceRuntime.new(u102, skillCastId, p103);
    table.insert(u102.runningBaseSkillInstances, v106);
    u102.instanceMap[skillCastId] = v106;
    u102.lastDerivableSkillCastId = skillCastId;

    if not u102.groupSkillRuntimeEvent then
        u102.groupSkillRuntimeEvent = RunService.Heartbeat:Connect(function(p107) -- Line: 826
            -- upvalues: u102 (copy)
            local v108 = {};

            for i, v in pairs(u102.instanceMap) do
                if v:Tick(p107) then
                    table.insert(v108, i);
                end;
            end;

            for _, v in ipairs(v108) do
                u102:_removeSkillInstance(v);
            end;

            local v109 = false;

            for _, v in pairs(u102.instanceMap) do
                for _, v2 in v.baseSkills do
                    if v2 and v2:isRunningFlow() then
                        v109 = true;
                        break;
                    end;
                end;

                if v109 then
                    break;
                end;
            end;

            local v110 = false;

            for _, v in pairs(u102.instanceMap) do
                for _, v2 in v.baseSkills do
                    if v2 and (v2:isRunningFlow() and not v2.isControlReleased) then
                        v110 = true;
                        break;
                    end;
                end;

                if v110 then
                    break;
                end;
            end;

            if not v109 and u102.groupSkillRuntimeEvent then
                u102.groupSkillRuntimeEvent:Disconnect();
                u102.groupSkillRuntimeEvent = nil;
            end;
        end);
    end;

    if v106:start() then
        u102._sustainAwaitingFirstInstanceFromReleaseRequest = false;

        if u102._pendingEarlyButtonUpForSustainHold then
            u102._pendingEarlyButtonUpForSustainHold = false;
            u102:_applyLocalSustainHoldButtonRelease();
        end;

        return;
    end;

    u102._pendingSoftMergeFirstBaseElapsed = nil;
    u102._sustainAwaitingFirstInstanceFromReleaseRequest = false;
    u102._pendingEarlyButtonUpForSustainHold = false;
    u102:_removeSkillInstance(skillCastId);
end;

function u2.createInstanceFromServerStart(p111, p112) -- Line: 879
    p111:_createInstanceFromServerData(p112);
end;

function u2.applyDerivedToInstance(p113, p114, p115) -- Line: 887
    local v116 = p113.instanceMap[p114];

    if v116 and v116.applyDerived then
        v116:applyDerived(p115);
    end;
end;

function u2._removeSkillInstance(p117, p118, p119) -- Line: 899
    local v120 = p117.instanceMap[p118];

    if not v120 then
        return;
    end;

    if v120.destroy then
        v120:destroy(p119);
    end;

    p117.instanceMap[p118] = nil;

    if p117.lastDerivableSkillCastId == p118 then
        p117.lastDerivableSkillCastId = nil;
    end;

    for i = #p117.runningBaseSkillInstances, 1, -1 do
        if p117.runningBaseSkillInstances[i] == v120 then
            table.remove(p117.runningBaseSkillInstances, i);

            return;
        end;
    end;
end;

function u2.releaseControl(p121) -- Line: 919
    for _, v in pairs(p121.instanceMap) do
        if v and v.releaseControl then
            v:releaseControl();
        end;
    end;

    local v122 = false;

    for _, v in pairs(p121.instanceMap) do
        for _, v2 in v.baseSkills do
            if v2 and (v2:isRunningFlow() and not v2.isControlReleased) then
                v122 = true;
                break;
            end;
        end;

        if v122 then
            break;
        end;
    end;

    p121.deriveRequestByIndex = {};
    p121.inputFlagsByName = {};
end;

function u2.interruptAllRunningCasts(p123) -- Line: 944
    p123.deriveSuppressedAfterCrossInterrupt = false;
    p123.deriveRequestByIndex = {};
    p123.inputFlagsByName = {};

    if p123.clearPresentationPredict then
        p123:clearPresentationPredict();
    end;

    local v124 = {};

    for i, _ in pairs(p123.instanceMap) do
        table.insert(v124, i);
    end;

    for _, v in ipairs(v124) do
        p123:_removeSkillInstance(v, true);
    end;

    p123.nowTime = 0;
    p123.activeBaseSkillIndex = 1;
    p123.completedBaseSkillIndex = {};
end;

function u2.requestStop(p125, p126) -- Line: 964
    -- upvalues: SkillSyncLog (copy)
    if not (p126 and (p126.skillCastId and p126.baseSkillInstanceId)) then
        return;
    end;

    SkillSyncLog.log(p125.skillName, p126.skillCastId, p126.baseSkillInstanceId, "Client", "StopSkillApplied", p126.reason and ("reason=" .. p126.reason or "") or "");
    local v127 = p125.instanceMap[p126.skillCastId];

    if not v127 then
        return;
    end;

    if v127:stopBaseSkill(p126.baseSkillInstanceId, p126.reason) then
        p125:_removeSkillInstance(p126.skillCastId);
    end;

    if not p125:hasActiveBaseSkill() then
        p125.nowTime = 0;
        p125.activeBaseSkillIndex = 1;
        p125.completedBaseSkillIndex = {};
    end;
end;

function u2._stopAllForDestroy(p128) -- Line: 986
    p128.deriveRequestByIndex = {};
    p128.inputFlagsByName = {};

    if p128.groupSkillRuntimeEvent then
        p128.groupSkillRuntimeEvent:Disconnect();
        p128.groupSkillRuntimeEvent = nil;
    end;

    local v129 = {};

    for i, _ in pairs(p128.instanceMap) do
        table.insert(v129, i);
    end;

    for _, v in ipairs(v129) do
        p128:_removeSkillInstance(v, true);
    end;

    p128.nowTime = 0;
    p128.activeBaseSkillIndex = 1;
    p128.completedBaseSkillIndex = {};
end;

function u2.destroy(p130) -- Line: 1006
    p130.deriveSuppressedAfterCrossInterrupt = false;
    p130:clearPresentationPredict();
    p130:_stopAllForDestroy();

    if p130.groupSkillCooldownEvent then
        p130.groupSkillCooldownEvent:Disconnect();
        p130.groupSkillCooldownEvent = nil;
    end;

    p130.instanceMap = {};
    p130.skillRunData = {};
    p130.skillInputData = {};
end;

return u2;