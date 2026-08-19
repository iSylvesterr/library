-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local CfgFind = UtilsSystem.CfgFind;
local EnumMgr = UtilsSystem.EnumMgr;
local CharacterMorphUtil = UtilsSystem.CharacterMorphUtil;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local v1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 0,
    skillElementType = nil,
    skillConfSkillId = 10111002,
    InitialState = "Startup",
    ControlOpenState = "Apply"
};
local u5 = (function() -- Line: 54, Name: _getClientScaleMul
    -- upvalues: CfgFind (copy), EnumMgr (copy)
    local v2 = CfgFind.FindCfgByID(10111002, EnumMgr.ItemType.Skill);

    if not v2 or type(v2.buffs) ~= "table" then
        return 3;
    end;

    for _, v in v2.buffs do
        local v3 = tonumber(v);

        if v3 and v3 > 0 then
            local v4 = CfgFind.FindSkillBuffInst(v3);

            if v4 and (tonumber(v4.BuffTp) == EnumMgr.SkillBuffTypeTp.BodyMorph and v4.RuntimeTag == EnumMgr.SkillBuffRuntimeTag.BodyMorph_Arm) then
                local PerValue = v4.PerValue;

                return (type(PerValue) == "table" and tonumber(PerValue[1]) or 300) / 100;
            end;
        end;
    end;

    return 3;
end)();
v1.States = {
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
        OnExitClient = nil,
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
};
v1.Transitions = {
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
};

function v1.Client_EnterApply(p6) -- Line: 112
    -- upvalues: SkillCommon (copy), CharacterMorphUtil (copy), u5 (copy)
    local v7 = p6.skillInputData and p6.skillInputData.character;

    if not v7 then
        return;
    end;

    if not SkillCommon.isInDungeonChallenge(nil, v7) then
        return;
    end;

    CharacterMorphUtil.StretchArms(v7, u5, 1);
end;

function v1.Server_EnterApply(p8) -- Line: 123
    -- upvalues: Players (copy), SkillCommon (copy), UtilsSystem (copy), EnumMgr (copy)
    local v9 = p8.skillInputData and p8.skillInputData.character;

    if not v9 then
        return;
    end;

    local u10 = Players:GetPlayerFromCharacter(v9);

    if not u10 then
        return;
    end;

    if not SkillCommon.isInDungeonChallenge(u10, v9) then
        return;
    end;

    local SystemDungeon = UtilsSystem.SystemDungeon;

    if not SystemDungeon then
        return;
    end;

    local SkillBuffUtil = UtilsSystem.SkillBuffUtil;
    SystemDungeon.applyDungeonBuffs(u10, v9, 10111002, "LongArm");
    SystemDungeon.registerEffect(u10, "LongArm_ExtraProj", function() -- Line: 144
        -- upvalues: SkillBuffUtil (copy), u10 (copy), EnumMgr (ref)
        SkillBuffUtil.RevokeSelfAttrBuffByRuntimeTag(u10, EnumMgr.SkillBuffRuntimeTag.ExtraProj_Count);
        SkillBuffUtil.RevokeSelfAttrBuffByRuntimeTag(u10, EnumMgr.SkillBuffRuntimeTag.ExtraProj_DmgMul);
    end);
    local v11 = p8.skillInputData and p8.skillInputData.slotIndex;

    if v11 then
        SystemDungeon.registerCdSlot(u10, v11);
    end;
end;

function v1.Server_EnterRecovery(p12) -- Line: 155
    p12:releaseControl();
end;

v1.SoundList = {};
v1.AnimateList = {};
v1.ResNameList = {};
v1.hitboxConfig = {};
v1.DamageProfiles = {};
v1.Action = {};

return v1;