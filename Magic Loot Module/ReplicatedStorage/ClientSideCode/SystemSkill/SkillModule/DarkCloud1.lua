-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
local FXUtil = UtilsSystem.FXUtil;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local SkillCommon = require(script.Parent._Templates.SkillCommon);

return {
    skillTotalTime = -1,
    visualFadeoutTime = 3,
    skillElementType = ElementTp.Thunder,
    skillConfSkillId = 10111005,
    InitialState = "Startup",
    ControlOpenState = "Main",
    States = {
        Startup = {
            Duration = 0.27,
            OnEnterClient = "Client_EnterStartup",
            OnEnterServer = nil
        },
        Main = {
            Duration = 0.2,
            OnEnterClient = "Client_EnterMain",
            OnEnterServer = "Server_EnterMain"
        },
        Recovery = {
            Duration = 0.2,
            OnEnterClient = "Client_EnterRecovery",
            OnEnterServer = "Server_EnterRecovery"
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
            To = "Main",
            Event = SkillEventConst.StateTimeout
        },
        {
            From = "Main",
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
            From = "Main",
            To = "Interrupted",
            Event = SkillEventConst.Interrupt
        },
        {
            From = "Recovery",
            To = "Interrupted",
            Event = SkillEventConst.Interrupt
        },
        {
            From = "Startup",
            To = "Finished",
            Event = SkillEventConst.ForceFinish
        },
        {
            From = "Main",
            To = "Finished",
            Event = SkillEventConst.ForceFinish
        },
        {
            From = "Recovery",
            To = "Finished",
            Event = SkillEventConst.ForceFinish
        }
    },

    Client_EnterStartup = function(p1) -- Line: 82, Name: Client_EnterStartup
        -- upvalues: SkillCommon (copy)
        local v2 = p1.skillInputData and p1.skillInputData.character;

        if not v2 then
            return;
        end;

        local v3 = SkillCommon.resolveWandTipFromCharacter(v2);

        if v3 then
            SkillCommon.scheduleWandTipElementTrail(p1, v3, {
                trailMaterialKey = "雷系尾迹",
                runEventKey = "DarkCloudCast尾迹",
                enableAt = 0.27,
                disableAt = 0.47
            });
        end;
    end,

    Client_EnterMain = function(p4) -- Line: 103, Name: Client_EnterMain
        -- upvalues: SkillCommon (copy), FXUtil (copy)
        SkillCommon.refreshSkillAimSnapshot(p4);
        local skillInputData = p4.skillInputData;
        local v5;

        if skillInputData then
            v5 = skillInputData.character;
        else
            v5 = skillInputData;
        end;

        if v5 then
            v5 = v5:FindFirstChild("HumanoidRootPart");
        end;

        local skillRunData = p4.skillRunData;

        if not skillInputData or (not v5 or (not skillRunData or type(skillRunData.material) ~= "table")) then
            return;
        end;

        if not SkillCommon.isRunningSameGeneration(p4, p4.runGeneration) then
            return;
        end;

        local v6 = skillRunData.material["落雷_法阵"];

        if not (v6 and v6:IsA("Model")) then
            return;
        end;

        skillRunData.material["落雷_法阵"] = nil;
        local _, v7 = SkillCommon.scaleDualFromData(p4, SkillCommon.bandScaleOptsFromSkillData(p4));
        v6:ScaleTo(v7);
        SkillCommon.pivotModelAtWorldPosKeepRotation(v6, SkillCommon.casterFeetGroundWorldPos(v5, 4, 1.5, "Ground"));
        v6.Parent = workspace.Debris;
        FXUtil.Emit_Particles_GetDescendants(v6, true);
        SkillCommon.playSoundLocal3D("音效-技能-雷系-法阵", v6:GetPivot().Position);
        FXUtil.Debris(v6, 3);
    end,

    Client_EnterRecovery = function(p8) -- Line: 139, Name: Client_EnterRecovery
        -- upvalues: SkillCommon (copy)
        local skillRunData = p8.skillRunData;

        if skillRunData and skillRunData.material then
            SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "雷系尾迹", "DarkCloudCast尾迹");
        end;
    end,

    Server_EnterMain = function(p9) -- Line: 151, Name: Server_EnterMain
        -- upvalues: Players (copy), UtilsSystem (copy)
        local v10 = p9.skillInputData and p9.skillInputData.character;

        if not v10 then
            return;
        end;

        local v11 = Players:GetPlayerFromCharacter(v10);

        if not v11 then
            return;
        end;

        local SystemDarkCloud = UtilsSystem.SystemDarkCloud;

        if SystemDarkCloud then
            SystemDarkCloud.SummonCloud(v11);
        end;

        local SystemDungeon = UtilsSystem.SystemDungeon;
        local v12 = p9.skillInputData and p9.skillInputData.slotIndex;

        if SystemDungeon and v12 then
            SystemDungeon.registerCdSlot(v11, v12);
        end;
    end,

    Server_EnterRecovery = function(p13) -- Line: 178, Name: Server_EnterRecovery
        p13:releaseControl();
    end,

    onEnd = function(p14) -- Line: 187, Name: onEnd
        -- upvalues: SkillCommon (copy)
        local skillRunData = p14.skillRunData;

        if skillRunData and skillRunData.material then
            SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "雷系尾迹", "DarkCloudCast尾迹");
        end;
    end,

    SoundList = { "音效-技能-雷系-法阵", "音效-技能-雷4-乌云", "音效-技能-雷4-打雷1", "音效-技能-雷4-打雷2", "音效-技能-雷4-打雷3", "音效-技能-雷4-打雷4", "音效-技能-雷4-打雷5", "音效-技能-雷4-打雷6", "音效-技能-雷4-打雷7", "音效-技能-雷4-打雷8", "音效-技能-雷4-打雷9" },
    AnimateList = { "技能释放动作3" },
    ResNameList = { "落雷_法阵", "雷系尾迹" },
    hitboxConfig = {},
    DamageProfiles = {},
    Action = {
        {
            action = "LookAt",
            startTime = 0,
            overTime = 0.47,
            speedType = "RELEASE_SKILL_STATE_HALF"
        },
        {
            action = "Animation",
            startTime = 0,
            overTime = 1.27,
            animationName = "技能释放动作3",
            animationSpeed = 1,
            animationFadeTime = 0.1,
            animationPriority = Enum.AnimationPriority.Action4
        }
    }
};