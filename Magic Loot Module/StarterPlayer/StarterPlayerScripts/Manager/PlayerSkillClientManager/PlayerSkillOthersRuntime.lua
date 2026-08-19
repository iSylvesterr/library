-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local GetSkillData = UtilsSystem.GetSkillData;
local BaseSkillClient = UtilsSystem.BaseSkillClient;
local MultThunderTramplePath = UtilsSystem.MultThunderTramplePath;
local ResourceUtil = UtilsSystem.ResourceUtil;
local Log = UtilsSystem.Log;
local u1 = {};
local u2 = {};
local u3 = {};
local u4 = {};
local u5 = { 0.05, 0.1, 0.15, 0.2, 0.3, 0.5, 0.8 };

local function _othersCastTimeoutKey(p6, p7) -- Line: 45
    return tostring(p6) .. ":" .. tostring(p7);
end;

function u1.cancelCastTimeout(p8, p9) -- Line: 54
    -- upvalues: u4 (copy)
    local v10 = tostring(p8) .. ":" .. tostring(p9);
    u4[v10] = (u4[v10] or 0) + 1;
end;

function u1.extractSkillCastId(p11) -- Line: 64
    if p11 then
        return p11:match("^(.+)_B%d+$") or p11;
    end;

    return nil;
end;

local function _tryPruneOthersSkillPool(p12, p13) -- Line: 77
    -- upvalues: u3 (copy), GetSkillData (copy), u2 (copy), Log (copy)
    if u3[p12] and next(u3[p12]) ~= nil then
        return;
    end;

    if p13 then
        if GetSkillData.getCharacter(p13, p12) then
            return;
        end;
    elseif GetSkillData.getCharacter("Summon", p12) or GetSkillData.getCharacter("NPC", p12) then
        return;
    end;

    local v14 = u2[p12];

    if not v14 then
        return;
    end;

    for _, v in v14 do
        if type(v) == "table" then
            for _, v2 in v do
                if v2 and v2.destroy then
                    local success, result = pcall(function() -- Line: 96
                        -- upvalues: v2 (copy)
                        v2:destroy("Interrupted", true);
                    end);

                    if not success then
                        Log.warn("[PlayerSkillOthersRuntime] tryPruneOthersSkillPool destroy failed:", result);
                    end;
                end;
            end;
        end;
    end;

    u2[p12] = nil;
end;

local function _forceCleanupOthersCast(p15, p16, p17) -- Line: 115
    -- upvalues: u3 (copy), Log (copy), _tryPruneOthersSkillPool (copy)
    local v18 = u3[p15];

    if not v18 then
        return;
    end;

    local v19 = v18[p16];

    if not v19 then
        return;
    end;

    for _, v in v19.baseSkillMap do
        if v and v.isRunning then
            local success, result = pcall(function() -- Line: 126
                -- upvalues: v (copy)
                v:skillEnd(true, "Interrupted");
            end);

            if not success then
                Log.warn("[PlayerSkillOthersRuntime] forceCleanupOthersCast skillEnd failed:", result);
            end;
        end;
    end;

    v18[p16] = nil;

    if next(v18) == nil then
        u3[p15] = nil;
        _tryPruneOthersSkillPool(p15, p17);
    end;
end;

local function _resolveOthersCastTimeoutSec(p20, p21) -- Line: 147
    if p20 and p20.characterType == "Summon" then
        local v22 = (type(p21) ~= "number" or (p21 ~= p21 or p21 <= 0)) and 12 or p21;

        return math.clamp(v22, 4, 30);
    end;

    local v23 = (type(p21) ~= "number" or (p21 ~= p21 or p21 <= 0)) and 45 or p21;

    return math.clamp(v23, 2, 180);
end;

local function _scheduleOthersCastTimeout(u24, u25, p26, p27) -- Line: 168
    -- upvalues: u4 (copy), _forceCleanupOthersCast (copy)
    local u28 = tostring(u24) .. ":" .. tostring(u25);
    local u29 = (u4[u28] or 0) + 1;
    u4[u28] = u29;
    local v30;

    if p27 and p27.characterType == "Summon" then
        local v31 = (type(p26) ~= "number" or (p26 ~= p26 or p26 <= 0)) and 12 or p26;
        v30 = math.clamp(v31, 4, 30);
    else
        local v32 = (type(p26) ~= "number" or (p26 ~= p26 or p26 <= 0)) and 45 or p26;
        v30 = math.clamp(v32, 2, 180);
    end;

    task.delay(v30, function() -- Line: 173
        -- upvalues: u4 (ref), u28 (copy), u29 (copy), _forceCleanupOthersCast (ref), u24 (copy), u25 (copy)
        if u4[u28] ~= u29 then
            return;
        end;

        u4[u28] = nil;
        _forceCleanupOthersCast(u24, u25, nil);
    end);
end;

local function _applyOthersBaseSkillPotency(p33, p34, p35) -- Line: 188
    if not (p33 and p34) then
        return;
    end;

    local skillID = p34.skillID;

    if typeof(skillID) == "number" and skillID > 0 then
        p33.skillID = skillID;

        if p33._context then
            p33._context.skillID = skillID;
        end;
    end;
end;

local function _acquireOthersBaseSkill(p36, p37, p38) -- Line: 208
    -- upvalues: u2 (copy), BaseSkillClient (copy), ResourceUtil (copy)
    if not u2[p36] then
        u2[p36] = {};
    end;

    if not u2[p36][p37] then
        u2[p36][p37] = {};
    end;

    local v39 = nil;

    for _, v in u2[p36][p37] do
        if v.skillName == p37 and not v.isRunning then
            v39 = v;
            break;
        end;
    end;

    if not v39 then
        v39 = BaseSkillClient.new(p37, p38.characterId, p38.characterType, {
            skillID = p38.skillID
        });
        task.defer(ResourceUtil.PreloadBaseSkill, p37);
        table.insert(u2[p36][p37], v39);
    end;

    return v39;
end;

function u1.findBaseSkill(p40, p41, p42) -- Line: 244
    -- upvalues: u3 (copy)
    local v43 = u3[p40];

    if v43 then
        v43 = v43[p41];
    end;

    if not v43 then
        return nil;
    end;

    return v43.baseSkillMap and v43.baseSkillMap[p42];
end;

function u1.processBaseSkillStarted(p44) -- Line: 257
    -- upvalues: GetSkillData (copy), u3 (copy), _acquireOthersBaseSkill (copy), MultThunderTramplePath (copy), _scheduleOthersCastTimeout (copy)
    if not GetSkillData.getCharacter(p44.characterType, p44.characterId) then
        return;
    end;

    local skillCastId = p44.skillCastId;
    local baseSkillInstanceId = p44.baseSkillInstanceId;

    if not baseSkillInstanceId then
        if skillCastId then
            baseSkillInstanceId = skillCastId .. "_B1" or nil;
        else
            baseSkillInstanceId = nil;
        end;
    end;

    if not skillCastId then
        return;
    end;

    local characterId = p44.characterId;

    if not u3[characterId] then
        u3[characterId] = {};
    end;

    local v45 = u3[characterId];
    local v46 = v45[skillCastId];

    if not v46 then
        v45[skillCastId] = {
            activeBaseSkillIndex = 1,
            skillCastId = skillCastId,
            groupSkillName = p44.groupSkillName,
            baseSkills = {},
            baseSkillMap = {},
            completedBaseSkillIndex = {},
            skillInputData = {
                releaseCF = p44.releaseCF,
                targetCF = p44.targetCF,
                moveDirectionStr = p44.moveDirectionStr,
                trackTargetId = p44.trackTargetId,
                skillTargetData = p44.skillTargetData,
                moveFaceMode = p44.moveFaceMode,
                moveFaceWorldPos = p44.moveFaceWorldPos,
                approachLandWorldPos = p44.approachLandWorldPos,
                multThunderPathPoints = p44.multThunderPathPoints,
                multThunderPathPacked = p44.multThunderPathPacked,
                multThunderSpawnGround = p44.multThunderSpawnGround
            }
        };
        v46 = v45[skillCastId];
    end;

    if v46.baseSkillMap[baseSkillInstanceId] then
        return;
    end;

    local v47 = _acquireOthersBaseSkill(characterId, p44.skillName, p44);
    local v48 = p44.activeBaseSkillIndex or 1;
    v46.baseSkills[v48] = v47;
    v46.baseSkillMap[baseSkillInstanceId] = v47;
    v47:setSkillInputData(p44.characterId, p44.characterType, p44.releaseCF, p44.targetCF, p44.moveDirectionStr, p44.skillCastId, baseSkillInstanceId, v48, p44.trackTargetId, p44.skillTargetData);
    MultThunderTramplePath.applySyncFieldsToSkillInputData(v47.skillInputData, p44);

    if p44.combatSeed then
        v47.combatSeed = p44.combatSeed;
    end;

    if v47 and p44 then
        local skillID = p44.skillID;

        if typeof(skillID) == "number" and skillID > 0 then
            v47.skillID = skillID;

            if v47._context then
                v47._context.skillID = skillID;
            end;
        end;
    end;

    v47:skillStart();
    _scheduleOthersCastTimeout(characterId, skillCastId, p44.clientObserverMaxDuration, p44);
end;

function u1.processBaseSkillStartedWithRetry(u49) -- Line: 335
    -- upvalues: GetSkillData (copy), u1 (copy), u5 (copy)
    if GetSkillData.getCharacter(u49.characterType, u49.characterId) then
        u1.processBaseSkillStarted(u49);

        return;
    end;

    task.spawn(function() -- Line: 341
        -- upvalues: u5 (ref), GetSkillData (ref), u49 (copy), u1 (ref)
        for _, v in u5 do
            task.wait(v);

            if GetSkillData.getCharacter(u49.characterType, u49.characterId) then
                u1.processBaseSkillStarted(u49);

                return;
            end;
        end;
    end);
end;

function u1.processDerived(p50) -- Line: 356
    -- upvalues: GetSkillData (copy), u3 (copy), _acquireOthersBaseSkill (copy)
    local skillCastId = p50.skillCastId;

    if not skillCastId then
        return;
    end;

    local fromBaseSkillIndex = p50.fromBaseSkillIndex;
    local toBaseSkillIndex = p50.toBaseSkillIndex;
    local v51 = skillCastId .. "_B" .. tostring(fromBaseSkillIndex);
    local v52 = p50.baseSkillInstanceId or skillCastId .. "_B" .. tostring(toBaseSkillIndex);
    local v53 = p50.skillName or p50.nextBaseSkillName;

    if not (p50.characterId and v53) then
        return;
    end;

    if not GetSkillData.getCharacter(p50.characterType, p50.characterId) then
        return;
    end;

    local v54 = u3[p50.characterId];

    if v54 then
        v54 = v54[skillCastId];
    end;

    if not v54 then
        return;
    end;

    if v54.skillInputData then
        if p50.trackTargetId ~= nil then
            v54.skillInputData.trackTargetId = p50.trackTargetId;
        end;

        if p50.skillTargetData ~= nil then
            v54.skillInputData.skillTargetData = p50.skillTargetData;
        end;
    end;

    local v55 = v54.baseSkillMap[v51];

    if v55 and v55.isRunning then
        if p50.breakLastSkill then
            v55:skillEnd();
        else
            v55.skillAction:Over(v55.nowTime);
        end;
    end;

    table.insert(v54.completedBaseSkillIndex, fromBaseSkillIndex);
    v54.activeBaseSkillIndex = toBaseSkillIndex;
    local v56 = _acquireOthersBaseSkill(p50.characterId, v53, p50);
    v54.baseSkills[toBaseSkillIndex] = v56;
    v54.baseSkillMap[v52] = v56;
    v56:setSkillInputData(p50.characterId, p50.characterType, p50.releaseCF, p50.targetCF, p50.moveDirectionStr, skillCastId, v52, p50.activeBaseSkillIndex or toBaseSkillIndex, p50.trackTargetId or v54.skillInputData and v54.skillInputData.trackTargetId, p50.skillTargetData or v54.skillInputData and v54.skillInputData.skillTargetData);

    if p50.combatSeed then
        v56.combatSeed = p50.combatSeed;
    end;

    if v56 and p50 then
        local skillID = p50.skillID;

        if typeof(skillID) == "number" and skillID > 0 then
            v56.skillID = skillID;

            if v56._context then
                v56._context.skillID = skillID;
            end;
        end;
    end;

    v56:skillStart();
end;

function u1.processLegacySync(p57) -- Line: 427
    -- upvalues: GetSkillData (copy), _acquireOthersBaseSkill (copy)
    if not GetSkillData.getCharacter(p57.characterType, p57.characterId) then
        warn("无法找到对应的角色模型", p57.characterId);

        return;
    end;

    local v58 = _acquireOthersBaseSkill(p57.characterId, p57.skillName, p57);
    v58:setSkillInputData(p57.characterId, p57.characterType, p57.releaseCF, p57.targetCF, p57.moveDirectionStr, p57.skillCastId, p57.baseSkillInstanceId, p57.activeBaseSkillIndex, p57.trackTargetId, p57.skillTargetData);

    if p57.combatSeed then
        v58.combatSeed = p57.combatSeed;
    end;

    if v58 and p57 then
        local skillID = p57.skillID;

        if typeof(skillID) == "number" and skillID > 0 then
            v58.skillID = skillID;

            if v58._context then
                v58._context.skillID = skillID;
            end;
        end;
    end;

    v58:skillStart();
end;

local function _resolveStopSkillEndReason(p59) -- Line: 459
    return p59 == "Finished" and "Finished" or "Interrupted";
end;

function u1.handleStopSkill(p60) -- Line: 470
    -- upvalues: u1 (copy), u3 (copy), _tryPruneOthersSkillPool (copy), u2 (copy)
    if not (p60.characterId and p60.baseSkillInstanceId) then
        return;
    end;

    local v61 = u1.extractSkillCastId(p60.baseSkillInstanceId);
    local v62 = u3[p60.characterId];

    if v61 then
        if v62 then
            v62 = v62[v61];
        end;
    else
        v62 = v61;
    end;

    if v62 then
        local v63 = v62.baseSkillMap[p60.baseSkillInstanceId];

        if v63 and v63.isRunning then
            local v64 = p60.reason == "Finished" and "Finished" or "Interrupted";
            v63.flowState = v64;
            v63.authoritativeState = v64;
            v63:skillEnd(nil, v64);
        end;

        local v65 = false;

        for _, v in v62.baseSkillMap do
            if v and v.isRunning then
                v65 = true;
                break;
            end;
        end;

        if not v65 then
            u3[p60.characterId][v61] = nil;
            u1.cancelCastTimeout(p60.characterId, v61);
            local v66 = u3[p60.characterId];

            if v66 and next(v66) == nil then
                u3[p60.characterId] = nil;
                _tryPruneOthersSkillPool(p60.characterId, p60.characterType);
            end;
        end;
    elseif p60.skillName and (u2[p60.characterId] and u2[p60.characterId][p60.skillName]) then
        for _, v in u2[p60.characterId][p60.skillName] do
            if v and v.baseSkillInstanceId == p60.baseSkillInstanceId then
                if v.isRunning then
                    local v67 = p60.reason == "Finished" and "Finished" or "Interrupted";
                    v.flowState = v67;
                    v.authoritativeState = v67;
                    v:skillEnd(nil, v67);
                end;

                break;
            end;
        end;
    end;

    if v61 then
        local v68 = u3[p60.characterId];

        if not (v68 and v68[v61]) then
            u1.cancelCastTimeout(p60.characterId, v61);
        end;
    end;
end;

return u1;