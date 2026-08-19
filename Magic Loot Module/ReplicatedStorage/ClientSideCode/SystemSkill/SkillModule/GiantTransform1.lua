-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local EnumMgr = UtilsSystem.EnumMgr;
local CameraModule = UtilsSystem.CameraModule;
local _ = UtilsSystem.CharacterMorphUtil;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local v1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 0,
    skillElementType = nil,
    skillConfSkillId = 10111003,
    InitialState = "Startup",
    ControlOpenState = "Apply",
    States = {
        Startup = {
            Duration = 0.05,
            OnEnterClient = nil,
            OnEnterServer = nil,
            OnExitClient = nil,
            OnExitServer = nil
        },
        Apply = {
            Duration = 1.1,
            OnEnterClient = "Client_EnterApply",
            OnEnterServer = "Server_EnterApply",
            OnExitClient = "Client_ExitApply",
            OnExitServer = nil
        },
        Recovery = {
            Duration = 0.1,
            OnEnterClient = nil,
            OnEnterServer = "Server_EnterRecovery",
            OnExitClient = nil,
            OnExitServer = nil
        },
        Finished = {
            Duration = 0,
            IsTerminal = true
        },
        Interrupted = {
            Duration = 0,
            IsTerminal = true
        }
    },
    Transitions = {
        {
            From = "Startup",
            To = "Apply",
            Event = SkillEventConst.StateTimeout
        },
        {
            From = "Apply",
            To = "Recovery",
            Event = SkillEventConst.StateTimeout
        },
        {
            From = "Recovery",
            To = "Finished",
            Event = SkillEventConst.StateTimeout
        },
        {
            From = "Startup",
            To = "Interrupted",
            Event = SkillEventConst.Interrupt
        },
        {
            From = "Apply",
            To = "Interrupted",
            Event = SkillEventConst.Interrupt
        },
        {
            From = "Startup",
            To = "Finished",
            Event = SkillEventConst.ForceFinish
        },
        {
            From = "Apply",
            To = "Finished",
            Event = SkillEventConst.ForceFinish
        },
        {
            From = "Recovery",
            To = "Finished",
            Event = SkillEventConst.ForceFinish
        }
    }
};

local function _disableGiantCamHelper() -- Line: 88
    -- upvalues: CameraModule (copy)
    CameraModule.DisableCameraEvent_Helper("GiantBodyScaleCam");
end;

function v1.Client_EnterApply(p2) -- Line: 96
    -- upvalues: SkillCommon (copy), CameraModule (copy)
    local u3 = p2.skillInputData and p2.skillInputData.character;

    if not u3 then
        return;
    end;

    if not SkillCommon.isInDungeonChallenge(nil, u3) then
        return;
    end;

    local v4 = u3:GetScale();
    local u5 = v4 <= 0 and 1 or v4;
    local u6 = 0;
    CameraModule.DisableCameraEvent_Helper("GiantBodyScaleCam");
    CameraModule.EnableCameraEvent_Helper("GiantBodyScaleCam", function(p7, p8) -- Line: 112
        -- upvalues: u3 (copy), u5 (ref), u6 (ref)
        if not u3.Parent then
            return CFrame.new(), 0;
        end;

        local v9 = u3:GetAttribute("CharMorph_VisualScale");

        if type(v9) ~= "number" then
            v9 = u3:GetScale();
        end;

        local v10 = math.max(v9 / u5 - 1, 0);
        local v11 = math.clamp((p8 or 0.016) * 10, 0, 1);
        u6 = u6 + (v10 - u6) * v11;

        return CFrame.new(0, 0, u6 * 2), 0;
    end);
end;

function v1.Client_ExitApply(p12) -- Line: 129
    -- upvalues: CameraModule (copy)
    CameraModule.DisableCameraEvent_Helper("GiantBodyScaleCam");
end;

function v1.Server_EnterApply(p13) -- Line: 133
    -- upvalues: Players (copy), SkillCommon (copy), UtilsSystem (copy), EnumMgr (copy)
    local v14 = p13.skillInputData and p13.skillInputData.character;

    if not v14 then
        return;
    end;

    local u15 = Players:GetPlayerFromCharacter(v14);

    if not u15 then
        return;
    end;

    if not SkillCommon.isInDungeonChallenge(u15, v14) then
        return;
    end;

    local SystemDungeon = UtilsSystem.SystemDungeon;

    if not SystemDungeon then
        return;
    end;

    local SkillBuffUtil = UtilsSystem.SkillBuffUtil;
    SystemDungeon.applyDungeonBuffs(u15, v14, 10111003, "Giant");
    SystemDungeon.registerEffect(u15, "Giant_StatBuffs", function() -- Line: 154
        -- upvalues: SkillBuffUtil (copy), u15 (copy), EnumMgr (ref), UtilsSystem (ref)
        SkillBuffUtil.RevokeSelfAttrBuffByRuntimeTag(u15, EnumMgr.SkillBuffRuntimeTag.GiantDmg);
        SkillBuffUtil.RevokeSelfAttrBuffByRuntimeTag(u15, EnumMgr.SkillBuffRuntimeTag.GiantHp);
        local SystemPlrAttr = UtilsSystem.SystemPlrAttr;

        if SystemPlrAttr then
            SystemPlrAttr.UpdateHumanState(u15);
        end;
    end);
    local v16 = p13.skillInputData and p13.skillInputData.slotIndex;

    if v16 then
        SystemDungeon.registerCdSlot(u15, v16);
    end;

    task.delay(0.1, function() -- Line: 168
        -- upvalues: u15 (copy), SkillCommon (ref), UtilsSystem (ref)
        if not (u15 and u15.Parent) then
            return;
        end;

        if not SkillCommon.isInDungeonChallenge(u15, nil) then
            return;
        end;

        local SystemPlrAttr = UtilsSystem.SystemPlrAttr;

        if SystemPlrAttr then
            SystemPlrAttr.UpdateHumanState(u15);
        end;
    end);
end;

function v1.Server_EnterRecovery(p17) -- Line: 182
    p17:releaseControl();
end;

v1.SoundList = {};
v1.AnimateList = {};
v1.ResNameList = {};
v1.hitboxConfig = {};
v1.DamageProfiles = {};
v1.Action = {};

return v1;