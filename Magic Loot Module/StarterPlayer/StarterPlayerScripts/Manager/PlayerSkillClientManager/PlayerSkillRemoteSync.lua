-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local SkillSyncLog = require(game.ReplicatedFirst.AllSideCode.SkillSyncLog);
local NetWork = UtilsSystem.NetWork;
local NetMsg = UtilsSystem.NetMsg;
local LocalPlayer = UtilsSystem.LocalPlayer;
local PlayerSkillContext = require(script.Parent.PlayerSkillContext);
local PlayerSkillOthersRuntime = require(script.Parent.PlayerSkillOthersRuntime);
local SkillSyncRouter = require(game.ReplicatedStorage.ClientSideCode.SystemSkill.BaseSkill.SkillSyncRouter);
local v1 = {};

local function _onFixSkillTime(p2, p3, p4, p5) -- Line: 29
    -- upvalues: PlayerSkillContext (copy)
    if PlayerSkillContext.localPlayerSkill[p2] then
        PlayerSkillContext.localPlayerSkill[p2]:fixSkillTime(p3, nil, p5);
    end;
end;

local function _onStopSkill(p6) -- Line: 39
    -- upvalues: SkillSyncLog (copy), LocalPlayer (copy), PlayerSkillContext (copy), SkillSyncRouter (copy), PlayerSkillOthersRuntime (copy)
    local v7 = typeof(p6) == "table" and p6 and p6 or {
        skillName = p6
    };

    if not (v7.skillCastId and v7.baseSkillInstanceId) then
        return;
    end;

    SkillSyncLog.log(v7.skillName, v7.skillCastId, v7.baseSkillInstanceId, "Client", "StopSkill", v7.reason and ("reason=" .. v7.reason or "") or "");

    if v7.characterId == LocalPlayer.UserId and v7.characterType == "Player" then
        for _, v in PlayerSkillContext.localPlayerSkill do
            if v.instanceMap and v.instanceMap[v7.skillCastId] then
                v:requestStop(v7);

                return;
            end;
        end;

        return;
    end;

    if not SkillSyncRouter.isPlayerSkillObserverSyncEnabled() and v7.characterType == "Player" then
        return;
    end;

    PlayerSkillOthersRuntime.handleStopSkill(v7);
end;

local function _onReleaseGroupSkill(p8, p9, p10) -- Line: 78
    -- upvalues: PlayerSkillContext (copy), SkillSyncLog (copy)
    local v11 = PlayerSkillContext.localPlayerSkill[p8];

    if not v11 then
        warn("无法找到对应的组技能，slotIndex:", p8);

        return;
    end;

    if p9 then
        v11.pendingReleaseData = nil;
    else
        v11.pendingReleaseData = nil;
        v11._sustainAwaitingFirstInstanceFromReleaseRequest = false;
        v11._pendingEarlyButtonUpForSustainHold = false;
        SkillSyncLog.log(v11.skillName, p10 or "?", "?", "Client", "ReleaseGroupSkill", "rejected");
        local v12 = nil;
        local v13 = 0;

        for i = #v11.runningBaseSkillInstances, 1, -1 do
            local v14 = v11.runningBaseSkillInstances[i];

            if v14 and v14.pendingServerConfirmation then
                v13 = i;
                v12 = v14;
                break;
            end;
        end;

        if v12 then
            for _, v in v12.baseSkills do
                if v and v.isRunning then
                    v:skillEnd();
                end;
            end;

            table.remove(v11.runningBaseSkillInstances, v13);
        end;

        if #v11.runningBaseSkillInstances == 0 then
            v11.isRunning = false;
        end;
    end;
end;

function v1.connect() -- Line: 122
    -- upvalues: NetWork (copy), NetMsg (copy), _onFixSkillTime (copy), _onStopSkill (copy), _onReleaseGroupSkill (copy)
    NetWork.RegisterClientRemoteEvent(NetMsg.FIX_SKILL_TIME, _onFixSkillTime);
    NetWork.RegisterClientRemoteEvent(NetMsg.STOP_SKILL, _onStopSkill);
    NetWork.RegisterClientRemoteEvent(NetMsg.RELEASE_GROUP_SKILL, _onReleaseGroupSkill);
end;

return v1;