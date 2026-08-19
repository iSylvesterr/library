-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillSyncLog = require(game.ReplicatedFirst.AllSideCode.SkillSyncLog);
local NetWork = UtilsSystem.NetWork;
local NetMsg = UtilsSystem.NetMsg;
local LocalPlayer = UtilsSystem.LocalPlayer;
local SyncEventType = UtilsSystem.SkillEventConst.SyncEventType;
local PlayerSkillContext = require(script.Parent.PlayerSkillContext);
require(script.Parent.SkillSlotConfig);
local PlayerSkillOthersRuntime = require(script.Parent.PlayerSkillOthersRuntime);
local SkillSyncRouter = require(game.ReplicatedStorage.ClientSideCode.SystemSkill.BaseSkill.SkillSyncRouter);
local v1 = {};

local function _isOthersPlayerSkill(p2) -- Line: 35
    -- upvalues: LocalPlayer (copy)
    local v3;

    if p2.characterType == "Player" then
        v3 = p2.characterId ~= LocalPlayer.UserId;
    else
        v3 = false;
    end;

    return v3;
end;

local u4 = nil;

function v1.setMagicBlockDebugFn(p5) -- Line: 48
    -- upvalues: u4 (ref)
    u4 = p5;
end;

local function _findBaseSkill(p6) -- Line: 57
    -- upvalues: LocalPlayer (copy), PlayerSkillContext (copy), PlayerSkillOthersRuntime (copy)
    local skillCastId = p6.skillCastId;
    local baseSkillInstanceId = p6.baseSkillInstanceId;

    if not (skillCastId and baseSkillInstanceId) then
        return nil;
    end;

    local v7;

    if p6.characterType == "Player" then
        v7 = p6.characterId == LocalPlayer.UserId;
    else
        v7 = false;
    end;

    if not v7 then
        return PlayerSkillOthersRuntime.findBaseSkill(p6.characterId, skillCastId, baseSkillInstanceId);
    end;

    for _, v in PlayerSkillContext.localPlayerSkill do
        local v8 = v.instanceMap and v.instanceMap[skillCastId];

        if v8 then
            return v8.baseSkillMap and v8.baseSkillMap[baseSkillInstanceId];
        end;
    end;

    return nil;
end;

local function _handleBaseSkillStarted(p9) -- Line: 80
    -- upvalues: SkillSyncLog (copy), LocalPlayer (copy), PlayerSkillContext (copy), PlayerSkillOthersRuntime (copy)
    SkillSyncLog.log(p9.groupSkillName or p9.skillName, p9.skillCastId, p9.baseSkillInstanceId, "Client", "BaseSkillStarted", "");
    local v10;

    if p9.characterType == "Player" then
        v10 = p9.characterId == LocalPlayer.UserId;
    else
        v10 = false;
    end;

    if v10 and p9.slotIndex then
        local v11 = PlayerSkillContext.localPlayerSkill[p9.slotIndex];

        if v11 and v11.skillName == p9.groupSkillName then
            v11:createInstanceFromServerStart(p9);
        end;
    else
        PlayerSkillOthersRuntime.processBaseSkillStartedWithRetry(p9);
    end;
end;

local function _handleProjectileFamily(p12) -- Line: 119
    -- upvalues: SyncEventType (copy), SkillSyncLog (copy), _findBaseSkill (copy)
    if p12.eventType == SyncEventType.ProjectileHitConfirmed then
        SkillSyncLog.log(p12.skillName, p12.skillCastId, p12.baseSkillInstanceId, "Client", "ProjectileHitConfirmed", string.format("hitType=%s target=%s", tostring(p12.hitType or "?"), (tostring(p12.targetId or "?"))));
    elseif p12.eventType == SyncEventType.ProximityStrikeWave then
        local log = SkillSyncLog.log;
        local skillName = p12.skillName;
        local skillCastId = p12.skillCastId;
        local baseSkillInstanceId = p12.baseSkillInstanceId;
        local format = string.format;
        local v13 = tostring(p12.waveIndex or "?");
        local v14 = type(p12.positions) == "table" and (#p12.positions or 0) or 0;
        log(skillName, skillCastId, baseSkillInstanceId, "Client", "ProximityStrikeWave", format("wave=%s count=%s", v13, (tostring(v14))));
    elseif p12.eventType == SyncEventType.ProjectilePathConfirmed then
        local startPos = p12.startPos;
        local endPos = p12.endPos;
        SkillSyncLog.log(p12.skillName, p12.skillCastId, p12.baseSkillInstanceId, "Client", "ProjectilePathConfirmed", string.format("idx=%s start=%s end=%s", tostring(p12.projectileIndex or "?"), typeof(startPos) == "Vector3" and (string.format("(%.1f,%.1f,%.1f)", startPos.X, startPos.Y, startPos.Z) or "?") or "?", typeof(endPos) == "Vector3" and (string.format("(%.1f,%.1f,%.1f)", endPos.X, endPos.Y, endPos.Z) or "?") or "?"));
    else
        local endPos = p12.endPos;
        SkillSyncLog.log(p12.skillName, p12.skillCastId, p12.baseSkillInstanceId, "Client", "SolarFlareMeteorShot", string.format("idx=%s end=%s", tostring(p12.meteorIndex or "?"), typeof(endPos) == "Vector3" and (string.format("(%.1f,%.1f,%.1f)", endPos.X, endPos.Y, endPos.Z) or "?") or "?"));
    end;

    local v15 = _findBaseSkill(p12);

    if v15 then
        v15:handleServerEvent(p12);
    end;
end;

local function _handleStateTransition(p16) -- Line: 183
    -- upvalues: SkillSyncLog (copy), LocalPlayer (copy), PlayerSkillContext (copy), PlayerSkillOthersRuntime (copy)
    local skillCastId = p16.skillCastId;
    local baseSkillInstanceId = p16.baseSkillInstanceId;
    local transitionEvent = p16.transitionEvent;

    if not skillCastId or (not baseSkillInstanceId or type(transitionEvent) ~= "string") then
        return;
    end;

    SkillSyncLog.log(p16.groupSkillName or p16.skillName, skillCastId, baseSkillInstanceId, "Client", "BaseSkillStateTransition", (tostring(transitionEvent)));
    local v17;

    if p16.characterType == "Player" then
        v17 = p16.characterId == LocalPlayer.UserId;
    else
        v17 = false;
    end;

    if v17 then
        for _, v in PlayerSkillContext.localPlayerSkill do
            local v18 = v.instanceMap and v.instanceMap[skillCastId];

            if v18 then
                local v19 = v18.baseSkillMap and v18.baseSkillMap[baseSkillInstanceId];

                if v19 and v19.TryTransition then
                    v19:TryTransition(transitionEvent);
                end;

                return;
            end;
        end;

        return;
    end;

    local v20 = PlayerSkillOthersRuntime.findBaseSkill(p16.characterId, skillCastId, baseSkillInstanceId);

    if v20 and v20.TryTransition then
        v20:TryTransition(transitionEvent);
    end;
end;

local function _handleDerived(p21) -- Line: 222
    -- upvalues: SkillSyncLog (copy), PlayerSkillContext (copy), PlayerSkillOthersRuntime (copy)
    local skillCastId = p21.skillCastId;

    if not skillCastId then
        return;
    end;

    SkillSyncLog.log(p21.groupSkillName or p21.skillName, skillCastId, p21.baseSkillInstanceId, "Client", "BaseSkillDerived", string.format("from=%s to=%s", tostring(p21.fromBaseSkillIndex), (tostring(p21.toBaseSkillIndex))));

    for _, v in PlayerSkillContext.localPlayerSkill do
        if v.instanceMap and v.instanceMap[skillCastId] then
            v:applyDerivedToInstance(skillCastId, p21);

            return;
        end;
    end;

    PlayerSkillOthersRuntime.processDerived(p21);
end;

local function _onSynSkillEffect(p22) -- Line: 248
    -- upvalues: SkillSyncRouter (copy), LocalPlayer (copy), SyncEventType (copy), _handleBaseSkillStarted (copy), SkillSyncLog (copy), _handleProjectileFamily (copy), _handleStateTransition (copy), _handleDerived (copy), PlayerSkillOthersRuntime (copy)
    if not SkillSyncRouter.isPlayerSkillObserverSyncEnabled() then
        local v23;

        if p22.characterType == "Player" then
            v23 = p22.characterId ~= LocalPlayer.UserId;
        else
            v23 = false;
        end;

        if v23 then
            return;
        end;
    end;

    local eventType = p22.eventType;

    if eventType == SyncEventType.BaseSkillStarted then
        _handleBaseSkillStarted(p22);

        return;
    end;

    if eventType == SyncEventType.HitConfirmed then
        SkillSyncLog.log(p22.skillName, p22.skillCastId, p22.baseSkillInstanceId, "Client", "HitConfirmed", string.format("timeline=%.2f target=%s", p22.timelineTime or 0, (tostring(p22.targetId or "?"))));

        return;
    end;

    if eventType == SyncEventType.ProjectileHitConfirmed or (eventType == SyncEventType.ProximityStrikeWave or (eventType == SyncEventType.SolarFlareMeteorShot or eventType == SyncEventType.ProjectilePathConfirmed)) then
        _handleProjectileFamily(p22);

        return;
    end;

    if eventType == SyncEventType.BaseSkillStateTransition then
        _handleStateTransition(p22);

        return;
    end;

    if eventType == SyncEventType.BaseSkillDerived then
        _handleDerived(p22);

        return;
    end;

    SkillSyncLog.log(p22.skillName, p22.skillCastId, p22.baseSkillInstanceId, "Client", "SynSkillEffect", "eventType=" .. tostring(eventType or "legacy"));
    PlayerSkillOthersRuntime.processLegacySync(p22);
end;

function v1.connect() -- Line: 301
    -- upvalues: NetWork (copy), NetMsg (copy), _onSynSkillEffect (copy)
    NetWork.RegisterClientRemoteEvent(NetMsg.SYN_SKILL_EFFECT, _onSynSkillEffect);
end;

return v1;