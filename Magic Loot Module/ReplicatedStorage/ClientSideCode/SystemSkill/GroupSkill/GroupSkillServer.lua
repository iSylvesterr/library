-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillSyncLog = require(game.ReplicatedFirst.AllSideCode.SkillSyncLog);
local RunService = UtilsSystem.RunService;
local Players = UtilsSystem.Players;
local NetWork = UtilsSystem.NetWork;
local NetMsg = UtilsSystem.NetMsg;
local CfgFind = UtilsSystem.CfgFind;
local EnumMgr = UtilsSystem.EnumMgr;
local GetData = UtilsSystem.GetData;
local SkillBuffUtil = UtilsSystem.SkillBuffUtil;
local ProjectileObjectTracking = require(game.ReplicatedStorage.ClientSideCode.SystemSkill.SkillModule._Templates.Projectile.ProjectileObjectTracking);

local function resolveBaseCooldownSeconds(p1, p2) -- Line: 31
    -- upvalues: CfgFind (copy), EnumMgr (copy)
    local v3 = p1 and p1 > 0 and CfgFind.FindCfgByID(p1, EnumMgr.ItemType.Skill);

    if v3 then
        local CD = v3.CD;

        if type(CD) == "number" and CD >= 0 then
            return CD;
        end;

        local v4 = tonumber(CD);

        if v4 and v4 >= 0 then
            return v4;
        end;
    end;

    return p2;
end;

local function combatSeedFromCharacterId(p5) -- Line: 48
    if typeof(p5) == "number" then
        return p5;
    end;

    local v6 = tostring(p5);
    local v7 = 0;

    for i = 1, #v6 do
        v7 = (v7 * 31 + string.byte(v6, i)) % 2147483647;
    end;

    return v7;
end;

local function getEffectiveCooldownSecondsForPlayer(p8, p9) -- Line: 60
    -- upvalues: CfgFind (copy), EnumMgr (copy), GetData (copy)
    local groupSkillCooldown = p8.groupSkillCooldown;

    if not p8.skillID or p8.skillID <= 0 then
        return groupSkillCooldown;
    end;

    local v10 = CfgFind.FindCfgByID(p8.skillID, EnumMgr.ItemType.Skill);

    if v10 and v10.isBase == EnumMgr.SkillTp.Skill then
        return groupSkillCooldown * (0.2 + 80 / ((GetData.GetPlrAttr(p9, EnumMgr.PlrAttr.Skill_Haste) or 0) + 100)) * 1;
    end;

    return groupSkillCooldown;
end;

local function writePlayerSkillCooldownEndTimestamp(p11, p12, p13) -- Line: 75
    if not p12 then
        return;
    end;

    local v14 = p11:FindFirstChild("技能CD时间戳");

    if not (v14 and v14:IsA("Folder")) then
        return;
    end;

    local v15 = v14:FindFirstChild("Slot" .. tostring(p12));

    if v15 and v15:IsA("NumberValue") then
        v15.Value = p13;
    end;
end;

local function getPlayerSlotCooldownEndTimestamp(p16, p17) -- Line: 89
    if not p17 then
        return nil;
    end;

    local v18 = p16:FindFirstChild("技能CD时间戳");

    if not (v18 and v18:IsA("Folder")) then
        return nil;
    end;

    local v19 = v18:FindFirstChild("Slot" .. tostring(p17));

    if v19 and v19:IsA("NumberValue") then
        return v19.Value;
    end;

    return nil;
end;

local function isPlayerSlotCooldownActiveByTimestamp(p20, p21) -- Line: 104
    -- upvalues: getPlayerSlotCooldownEndTimestamp (copy)
    local v22 = getPlayerSlotCooldownEndTimestamp(p20, p21);

    if v22 == nil then
        return false;
    end;

    return workspace:GetServerTimeNow() < v22;
end;

local function getPlayerSlotCooldownRemainingSeconds(p23, p24) -- Line: 112
    -- upvalues: getPlayerSlotCooldownEndTimestamp (copy)
    local v25 = getPlayerSlotCooldownEndTimestamp(p23, p24);

    if v25 == nil then
        return 0;
    end;

    local v26 = v25 - workspace:GetServerTimeNow();

    return math.max(0, v26);
end;

local function isGroupSkillOnCooldown(p27) -- Line: 120
    -- upvalues: Players (copy), getPlayerSlotCooldownEndTimestamp (copy)
    if p27.characterType ~= "Player" then
        return p27.groupSkillCooldownRemaining > 0;
    end;

    local v28 = Players:GetPlayerByUserId(p27.characterId);

    if not v28 then
        return false;
    end;

    local v29 = getPlayerSlotCooldownEndTimestamp(v28, p27.slotIndex);

    if v29 == nil then
        return false;
    end;

    return workspace:GetServerTimeNow() < v29;
end;

require(script.Parent.Parent.BaseSkill.BaseSkillServer);
local GroupSkillInstanceRuntime = require(script.Parent.GroupSkillInstanceRuntime);
local SkillModuleValidator = require(script.Parent.Parent.BaseSkill.SkillModuleValidator);
local SkillDataSchema = require(script.Parent.Parent.BaseSkill.SkillDataSchema);
local SkillReleaseCrossCheck = require(script.Parent.SkillReleaseCrossCheck);
local GroupSkillModule = script.Parent.Parent.GroupSkillModule;

local function resolveInterruptionPriorityFromModule(p30) -- Line: 150
    local InterruptionPriority = p30.InterruptionPriority;

    if InterruptionPriority == nil then
        InterruptionPriority = p30.PriorityInterruption;
    end;

    local Data = p30.Data;

    if InterruptionPriority == nil and type(Data) == "table" then
        InterruptionPriority = Data.InterruptionPriority or Data.interruptionPriority;
    end;

    return (type(InterruptionPriority) ~= "number" or InterruptionPriority ~= InterruptionPriority) and (1 / 0) or InterruptionPriority;
end;

local u31 = {};
u31.__index = u31;

function u31._registerRuntime(p32, p33) -- Line: 183
    table.insert(p32.runningRuntimeList, p33);
    p32.runtimeByCastId[p33.skillCastId] = p33;

    for _, v in p33.baseSkills do
        if v and v.baseSkillInstanceId then
            p32.runtimeByInstanceId[v.baseSkillInstanceId] = p33;
        end;
    end;
end;

function u31._unregisterRuntime(p34, p35) -- Line: 196
    p34.runtimeByCastId[p35.skillCastId] = nil;

    for _, v in p35.baseSkills do
        if v and v.baseSkillInstanceId then
            p34.runtimeByInstanceId[v.baseSkillInstanceId] = nil;
        end;
    end;

    for i, v in ipairs(p34.runningRuntimeList) do
        if v == p35 then
            table.remove(p34.runningRuntimeList, i);

            return;
        end;
    end;
end;

function u31._disposeRuntime(p36, p37, p38) -- Line: 220
    if not p37 then
        return;
    end;

    p36:_unregisterRuntime(p37);
    p37:destroy(p38);
end;

local function _updateGroupState(p39) -- Line: 233
    -- upvalues: Players (copy), getPlayerSlotCooldownEndTimestamp (copy)
    local v40 = #p39.runningRuntimeList > 0;
    local v41 = false;
    local v42 = false;
    local v43 = false;

    for _, v in ipairs(p39.runningRuntimeList) do
        for _, v2 in v.baseSkills do
            if v2 and v2:isRunningFlow() then
                v43 = true;
                local v44 = v2:getControlState();

                if v44 == "Locked" then
                    v41 = true;
                elseif v44 == "ChainOpen" then
                    v42 = true;
                end;
            end;
        end;
    end;

    if not v40 then
        local v45;

        if p39.characterType == "Player" then
            local v46 = Players:GetPlayerByUserId(p39.characterId);

            if v46 then
                local v47 = getPlayerSlotCooldownEndTimestamp(v46, p39.slotIndex);

                if v47 == nil then
                    v45 = false;
                else
                    v45 = workspace:GetServerTimeNow() < v47;
                end;
            else
                v45 = false;
            end;
        else
            v45 = p39.groupSkillCooldownRemaining > 0;
        end;

        p39.groupState = v45 and "Cooldown" or "Idle";

        return;
    end;

    if v41 then
        p39.groupState = "Casting";

        return;
    end;

    if v42 then
        p39.groupState = "ChainWindow";

        return;
    end;

    if v43 then
        p39.groupState = "Recovering";

        return;
    end;

    p39.groupState = "Idle";
end;

function u31.new(p48) -- Line: 270
    -- upvalues: u31 (copy), GroupSkillModule (copy), SkillModuleValidator (copy), SkillDataSchema (copy), CfgFind (copy), EnumMgr (copy), RunService (copy), _updateGroupState (copy)
    local u49 = setmetatable({}, u31);
    u49.authoritativeState = "Idle";
    u49.skillName = p48.skillName;
    u49.characterType = p48.characterType;
    u49.characterId = p48.characterId;
    u49.slotIndex = p48.slotIndex;
    u49.skillID = p48.skillID;
    local v50 = GroupSkillModule:FindFirstChild(u49.skillName);

    if not v50 then
        warn("组技能模块未找到", u49.skillName);

        return nil;
    end;

    local v51 = require(v50);
    local SkillModule = script.Parent.Parent.SkillModule;
    local validateForRelease = SkillModuleValidator.validateForRelease;
    local v54 = {
        env = "production",
        skillName = u49.skillName,
        moduleScriptName = v50.Name,

        resolveBaseSkill = function(p52) -- Line: 286, Name: resolveBaseSkill
            -- upvalues: SkillModule (copy)
            local v53 = SkillModule:FindFirstChild(p52);

            if not (v53 and v53:IsA("ModuleScript")) then
                return nil;
            end;

            local success, result = pcall(require, v53);

            return success and result and result or nil;
        end
    };
    local v55;

    if v51.Data then
        v55 = v51.Data.suppressions or nil;
    else
        v55 = nil;
    end;

    v54.suppressions = v55;
    local v56, v57 = validateForRelease("GroupSkill", v51, v54);

    if not v56 then
        SkillModuleValidator.failOnError(u49.skillName, v57, true);
    end;

    if v51.Data then
        v51.Data = SkillDataSchema.normalizeSkillData(v51.Data);
    end;

    u49.groupSkillModule = v51;
    local InterruptionPriority = v51.InterruptionPriority;

    if InterruptionPriority == nil then
        InterruptionPriority = v51.PriorityInterruption;
    end;

    local Data = v51.Data;

    if InterruptionPriority == nil and type(Data) == "table" then
        InterruptionPriority = Data.InterruptionPriority or Data.interruptionPriority;
    end;

    u49.interruptionPriority = (type(InterruptionPriority) ~= "number" or InterruptionPriority ~= InterruptionPriority) and (1 / 0) or InterruptionPriority;
    u49.skillStartTimestamp = 0;
    u49.nowTime = 0;
    u49.skillPlaySpeed = 1;
    u49.runningRuntimeList = {};
    u49.runtimeByCastId = {};
    u49.runtimeByInstanceId = {};
    u49.runningBaseSkillInstances = u49.runningRuntimeList;
    u49.completedBaseSkillIndex = {};
    u49.activeBaseSkillIndex = 1;
    local skillID = u49.skillID;
    local skillCooldown = v51.Data.skillCooldown;

    if skillID and skillID > 0 then
        local v58 = CfgFind.FindCfgByID(skillID, EnumMgr.ItemType.Skill);

        if v58 then
            local CD = v58.CD;

            if type(CD) == "number" and CD >= 0 then
                skillCooldown = CD;
            else
                local v59 = tonumber(CD);

                if v59 and v59 >= 0 then
                    skillCooldown = v59;
                end;
            end;
        end;
    end;

    u49.groupSkillCooldown = skillCooldown;
    u49.groupSkillCooldownRemaining = 0;
    u49.groupState = "Idle";
    u49.skillRunData = {};
    u49.deriveRequestByIndex = {};
    u49.inputFlagsByName = {};
    u49.deriveSuppressedAfterCrossInterrupt = false;
    u49.groupSkillCooldownEvent = nil;
    u49.groupSkillCooldownEvent = RunService.Heartbeat:Connect(function(p60) -- Line: 341
        -- upvalues: _updateGroupState (ref), u49 (copy)
        _updateGroupState(u49);

        if u49.characterType ~= "Player" and u49.groupSkillCooldownRemaining > 0 then
            if p60 < u49.groupSkillCooldownRemaining then
                local v61 = u49;
                v61.groupSkillCooldownRemaining = v61.groupSkillCooldownRemaining - p60;

                return;
            end;

            u49.groupSkillCooldownRemaining = 0;
        end;
    end);

    return u49;
end;

function u31._removeSkillInstance(p62, p63) -- Line: 364
    local v64 = p62.runningRuntimeList[p63];

    if v64 then
        p62:_disposeRuntime(v64, "Finished");
    end;
end;

function u31.hasActiveRuntime(p65) -- Line: 376
    return #p65.runningRuntimeList > 0;
end;

function u31.hasActiveBaseSkill(p66) -- Line: 383
    for _, v in ipairs(p66.runningRuntimeList) do
        if v:hasRunningBaseSkill() then
            return true;
        end;
    end;

    return false;
end;

function u31.hasPhase1Incomplete(p67) -- Line: 396
    for _, v in ipairs(p67.runningRuntimeList) do
        local v68 = v.baseSkills[v.activeBaseSkillIndex];

        if v68 and (v68:isRunningFlow() and not v68.isPhase1Complete) then
            return true;
        end;
    end;

    return false;
end;

function u31.getInterruptionPriority(p69) -- Line: 406
    return p69.interruptionPriority or (1 / 0);
end;

function u31.interruptCrossSlotCast(p70) -- Line: 413
    p70.deriveRequestByIndex = {};
    p70.inputFlagsByName = {};

    for _, v in ipairs(p70.runningRuntimeList) do
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

function u31.requestRelease(u71, p72) -- Line: 438
    -- upvalues: Players (copy), getPlayerSlotCooldownEndTimestamp (copy), SkillSyncLog (copy), NetWork (copy), NetMsg (copy), SkillReleaseCrossCheck (copy), getEffectiveCooldownSecondsForPlayer (copy), GroupSkillInstanceRuntime (copy), SkillBuffUtil (copy), RunService (copy), writePlayerSkillCooldownEndTimestamp (copy), UtilsSystem (copy)
    if not u71:hasPhase1Incomplete() then
        local v73;

        if u71.characterType == "Player" then
            local v74 = Players:GetPlayerByUserId(u71.characterId);

            if v74 then
                local v75 = getPlayerSlotCooldownEndTimestamp(v74, u71.slotIndex);

                if v75 == nil then
                    v73 = false;
                else
                    v73 = workspace:GetServerTimeNow() < v75;
                end;
            else
                v73 = false;
            end;
        else
            v73 = u71.groupSkillCooldownRemaining > 0;
        end;

        if v73 then
            local groupSkillCooldownRemaining = u71.groupSkillCooldownRemaining;

            if u71.characterType == "Player" then
                local v76 = Players:GetPlayerByUserId(u71.characterId);

                if v76 then
                    local v77 = getPlayerSlotCooldownEndTimestamp(v76, u71.slotIndex);

                    if v77 == nil then
                        groupSkillCooldownRemaining = 0;
                    else
                        local v78 = v77 - workspace:GetServerTimeNow();
                        groupSkillCooldownRemaining = math.max(0, v78);
                    end;
                end;
            end;

            SkillSyncLog.log(u71.skillName, "?", "?", "Server", "ReleaseGroupSkill", string.format("rejected reason=cooldown remaining=%.2f", groupSkillCooldownRemaining));
            local v79 = u71.characterType == "Player" and Players:GetPlayerByUserId(u71.characterId);

            if v79 then
                NetWork.FireClient(v79, NetMsg.RELEASE_GROUP_SKILL, u71.slotIndex, false);
            end;

            return;
        end;
    end;

    if u71.characterType == "Player" then
        SkillReleaseCrossCheck.runAll({
            characterId = u71.characterId,
            characterType = u71.characterType,
            incomingGroupSkillName = u71.skillName,
            incomingSlotIndex = u71.slotIndex
        });
    end;

    local groupSkillCooldown = u71.groupSkillCooldown;

    if u71.characterType == "Player" then
        local v80 = Players:GetPlayerByUserId(u71.characterId);

        if v80 then
            groupSkillCooldown = getEffectiveCooldownSecondsForPlayer(u71, v80);
        end;
    else
        u71.groupSkillCooldownRemaining = groupSkillCooldown;
    end;

    u71._castSeq = (u71._castSeq or 0) + 1;
    local v81 = workspace:GetServerTimeNow() * 1000;
    local u82 = math.floor(v81);
    local characterId = u71.characterId;

    if typeof(characterId) ~= "number" then
        local v83 = tostring(characterId);
        characterId = 0;

        for i = 1, #v83 do
            characterId = (characterId * 31 + string.byte(v83, i)) % 2147483647;
        end;
    end;

    local v84 = math.abs((characterId * 73856093 + u71._castSeq * 19349663 + u82) % 2147483647);

    local function fallbackSkillCastId() -- Line: 489
        -- upvalues: u71 (copy), u82 (copy)
        return string.format("%s_%d_%d", tostring(u71.characterId), u82, u71._castSeq);
    end;

    local v85 = string.format("%s_%d_%d", tostring(u71.characterId), u82, u71._castSeq);
    local v86;

    if p72 then
        v86 = p72.clientPredictCastId;
    else
        v86 = p72;
    end;

    if type(v86) == "string" and (#v86 > 0 and (#v86 <= 80 and v86:match("^[%w%-_]+$"))) then
        if u71.runtimeByCastId[v86] then
            v86 = v85;
        end;
    else
        v86 = v85;
    end;

    local v87 = GroupSkillInstanceRuntime.new(u71, v86, p72, v84);
    u71:_registerRuntime(v87);

    if v87:start() then
        if u71.characterType == "Player" and (not p72 or p72.skipCastTrait ~= true) then
            local v88 = Players:GetPlayerByUserId(u71.characterId);
            local v89 = p72 or v87.castInputSnapshot;

            if v88 and v89 then
                SkillBuffUtil.TryProcCastTraitsOnSkillCast(v88, u71.skillID, {
                    combatSeed = v84,
                    skillName = u71.skillName,
                    slotIndex = u71.slotIndex,
                    skillInputData = v89
                });
            end;
        end;

        if not u71.groupSkillRuntimeEvent then
            u71.groupSkillRuntimeEvent = RunService.Heartbeat:Connect(function(p90) -- Line: 537
                -- upvalues: u71 (copy)
                local v91 = {};

                for _, v in ipairs(u71.runningRuntimeList) do
                    v:Tick(p90);

                    if v:isFinished() then
                        table.insert(v91, v);
                    end;
                end;

                for _, v in ipairs(v91) do
                    u71:_disposeRuntime(v, "Finished");
                end;

                local v92 = false;

                for _, v in ipairs(u71.runningRuntimeList) do
                    if v:hasRunningBaseSkill() then
                        v92 = true;
                        break;
                    end;
                end;

                if not v92 and u71.groupSkillRuntimeEvent then
                    u71.groupSkillRuntimeEvent:Disconnect();
                    u71.groupSkillRuntimeEvent = nil;
                end;
            end);
        end;

        local v93 = u71.characterType == "Player" and Players:GetPlayerByUserId(u71.characterId);

        if v93 then
            local v94 = workspace:GetServerTimeNow();
            NetWork.FireClient(v93, NetMsg.FIX_SKILL_TIME, u71.slotIndex, v94, nil, v86);

            if groupSkillCooldown > 0 then
                v94 = v94 + groupSkillCooldown;
            end;

            writePlayerSkillCooldownEndTimestamp(v93, u71.slotIndex, v94);
            local SystemSkill = UtilsSystem.SystemSkill;

            if SystemSkill and SystemSkill.ApplyPlayerGlobalCooldownAfterCast then
                SystemSkill.ApplyPlayerGlobalCooldownAfterCast(v93, u71.slotIndex);
            end;
        end;

        return;
    end;

    u71:_disposeRuntime(v87, "StartFailed");

    if u71.characterType ~= "Player" then
        u71.groupSkillCooldownRemaining = 0;
    end;

    local v95 = u71.characterType == "Player" and Players:GetPlayerByUserId(u71.characterId);

    if v95 then
        NetWork.FireClient(v95, NetMsg.RELEASE_GROUP_SKILL, u71.slotIndex, false);
    end;
end;

function u31.onInputRequest(p96, p97, p98) -- Line: 599
    -- upvalues: ProjectileObjectTracking (copy)
    if type(p97) ~= "string" then
        p98 = p97;
    end;

    local v99;

    if p98 then
        v99 = p98.skillCastId;
    else
        v99 = p98;
    end;

    local v100;

    if v99 and #v99 > 0 then
        v100 = p96.runtimeByCastId[v99];

        if v100 and not v100:hasRunningBaseSkill() then
            v100 = nil;
        end;
    else
        v100 = nil;
    end;

    if not v100 then
        for i = #p96.runningRuntimeList, 1, -1 do
            local v101 = p96.runningRuntimeList[i];

            if v101:hasRunningBaseSkill() then
                v100 = v101;
                break;
            end;
        end;
    end;

    if v100 and (p98 and p98.trackTargetRefreshOnly == true) then
        v100:applyInputRequest(p98, nil, nil);
        local v102 = v100:GetCurrentBaseSkill();

        if v102 and v102.skillInputData then
            local castInputSnapshot = v100.castInputSnapshot;

            if castInputSnapshot then
                v102.skillInputData.trackTargetId = castInputSnapshot.trackTargetId;

                if castInputSnapshot.targetCF ~= nil then
                    v102.skillInputData.targetCF = castInputSnapshot.targetCF;
                end;
            end;

            local v103 = v102.skillRunData and v102.skillRunData.Logic;

            if v103 then
                v103.trackTargetId = v102.skillInputData.trackTargetId;
                local v104 = v102.GetCurrentState and v102:GetCurrentState();
                local v105 = v104 == "ProjectileFlying" and (v103.trackTargetId and ProjectileObjectTracking.getWorldPositionByTrackTargetId(v103.trackTargetId));

                if v105 then
                    v103.impactPosition = v105;
                end;
            end;
        end;

        return;
    end;

    if not v100 then
        warn("技能组未运行，无法处理按键输入请求");

        return;
    end;

    local v106 = type(p97) == "string" and p97 and p97 or nil;
    local v107 = v100.activeBaseSkillIndex + 1;
    v100:applyInputRequest(p98, v106, p96.groupSkillModule.Skill[v107] and v107 and v107 or nil);
end;

function u31.releaseControl(p108) -- Line: 670
    -- upvalues: _updateGroupState (copy)
    print("提前释放技能组控制权，技能名称:", p108.skillName);

    for _, v in ipairs(p108.runningRuntimeList) do
        v:releaseControl();
    end;

    _updateGroupState(p108);
    p108.deriveRequestByIndex = {};
    p108.inputFlagsByName = {};
    print("技能组控制权已释放，BaseSkill 将继续运行，冷却时间开始倒计时，hasActiveBaseSkill:", p108:hasActiveBaseSkill());
end;

function u31.interruptAllRunningCasts(p109) -- Line: 696
    -- upvalues: _updateGroupState (copy)
    if #p109.runningRuntimeList == 0 then
        return;
    end;

    p109.deriveSuppressedAfterCrossInterrupt = false;
    p109.deriveRequestByIndex = {};
    p109.inputFlagsByName = {};

    if p109.groupSkillRuntimeEvent then
        p109.groupSkillRuntimeEvent:Disconnect();
        p109.groupSkillRuntimeEvent = nil;
    end;

    local v110 = {};

    for _, v in ipairs(p109.runningRuntimeList) do
        table.insert(v110, v);
    end;

    for _, v in ipairs(v110) do
        p109:_disposeRuntime(v, "Interrupted");
    end;

    p109.activeBaseSkillIndex = 1;
    p109.completedBaseSkillIndex = {};
    _updateGroupState(p109);
end;

function u31.requestStop(p111) -- Line: 723
    -- upvalues: Players (copy), writePlayerSkillCooldownEndTimestamp (copy)
    p111.deriveRequestByIndex = {};
    p111.inputFlagsByName = {};

    if p111.groupSkillRuntimeEvent then
        p111.groupSkillRuntimeEvent:Disconnect();
        p111.groupSkillRuntimeEvent = nil;
    end;

    local v112 = {};

    for _, v in ipairs(p111.runningRuntimeList) do
        v:stop();
        table.insert(v112, v);
    end;

    for _, v in ipairs(v112) do
        p111:_disposeRuntime(v, "Stop");
    end;

    p111.groupState = "Cooldown";
    p111.nowTime = 0;
    p111.activeBaseSkillIndex = 1;
    p111.completedBaseSkillIndex = {};

    if p111.characterType == "Player" then
        local v113 = Players:GetPlayerByUserId(p111.characterId);

        if v113 then
            writePlayerSkillCooldownEndTimestamp(v113, p111.slotIndex, workspace:GetServerTimeNow() + p111.groupSkillCooldown);
        end;
    else
        p111.groupSkillCooldownRemaining = p111.groupSkillCooldown;
    end;
end;

function u31.destroy(p114) -- Line: 770
    p114.deriveSuppressedAfterCrossInterrupt = false;

    if p114.groupSkillCooldownEvent then
        p114.groupSkillCooldownEvent:Disconnect();
        p114.groupSkillCooldownEvent = nil;
    end;

    if p114.groupSkillRuntimeEvent then
        p114.groupSkillRuntimeEvent:Disconnect();
        p114.groupSkillRuntimeEvent = nil;
    end;

    local v115 = {};

    for _, v in ipairs(p114.runningRuntimeList) do
        table.insert(v115, v);
    end;

    for _, v in ipairs(v115) do
        p114:_disposeRuntime(v, "Destroy");
    end;

    p114.completedBaseSkillIndex = {};
    p114.skillRunData = {};
    p114.skillInputData = {};
    p114.nowTime = 0;
end;

return u31;