-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local SpiderEggCore = require(script.Parent._Templates.SpiderEggCore);
local v1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2.95,
    skillElementType = UtilsSystem.EnumMgr.ElementTp.None,
    skillDistanceLimit = 64,
    InitialState = "Startup",
    ControlOpenState = "Throw",
    States = {
        Startup = {
            Duration = 1.06,
            OnEnterClient = "Client_EnterStartup",
            OnEnterServer = "Server_EnterStartup"
        },
        Throw = {
            Duration = 0.95,
            OnEnterClient = "Client_EnterThrow",
            OnEnterServer = "Server_EnterThrow",
            OnExitClient = "Client_ExitThrow"
        },
        Recovery = {
            Duration = 0.8,
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
            To = "Throw",
            Event = SkillEventConst.StateTimeout
        },
        {
            From = "Throw",
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
            From = "Throw",
            To = "Interrupted",
            Event = SkillEventConst.Interrupt
        },
        {
            From = "Startup",
            To = "Finished",
            Event = SkillEventConst.ForceFinish
        },
        {
            From = "Throw",
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
SpiderEggCore.attach(v1, {
    eggEnemyId = 5040008,
    eggSummonSkillKey = "SpiderEgg",
    eggMaxAlive = 8,
    eggCount = 4,
    scatterRadiusMin = 0,
    scatterRadiusMax = 30
});

function v1.Server_EnterStartup(p2) -- Line: 78
end;

function v1.Client_EnterStartup(p3) -- Line: 81
end;

function v1.Server_EnterRecovery(p4) -- Line: 84
    p4:releaseControl();
end;

function v1.Client_EnterRecovery(p5) -- Line: 88
    -- upvalues: SkillCommon (copy), SpiderEggCore (copy)
    local skillRunData = p5.skillRunData;

    if skillRunData then
        SkillCommon.scheduleRunSpawnClear(p5, p5.runGeneration, skillRunData, SpiderEggCore.SPAWN_LIST_KEY, 2);
        SkillCommon.scheduleRunSpawnClear(p5, p5.runGeneration, skillRunData, SpiderEggCore.PROJECTILE_LIST_KEY, SpiderEggCore.PROJECTILE_HOLD_MAX_SEC + 0.5);
    end;
end;

function v1.Client_ExitRecovery(p6) -- Line: 102
    -- upvalues: SkillCommon (copy), SpiderEggCore (copy)
    local skillRunData = p6.skillRunData;

    if skillRunData then
        SkillCommon.clearSpawnIfTerminalAfterExit(p6, p6.runGeneration, skillRunData, SpiderEggCore.SPAWN_LIST_KEY);
        SkillCommon.clearSpawnIfTerminalAfterExit(p6, p6.runGeneration, skillRunData, SpiderEggCore.PROJECTILE_LIST_KEY);
        SkillCommon.clearSpawnIfTerminalAfterExit(p6, p6.runGeneration, skillRunData, SpiderEggCore.WEB_FX_SPAWN_LIST_KEY);
    end;
end;

v1.SoundList = {
    SpiderEggCore.SOUND_THROW,
    SpiderEggCore.SOUND_HATCH,
    SpiderEggCore.SOUND_STAGE2,
    SpiderEggCore.SOUND_STAGE3
};
v1.AnimateList = { "蜘蛛产卵" };
v1.ResNameList = { "女王蜘蛛卵", "蜘蛛产卵蛛网特效", "蜘蛛产卵爆裂特效" };
v1.hitboxConfig = {};
v1.Action = {
    {
        action = "LookAt",
        startTime = 0,
        overTime = 2.01,
        speedType = "RELEASE_SKILL_STATE_HALF"
    },
    {
        action = "Animation",
        startTime = 0,
        overTime = 2.8099999999999996,
        animationName = "蜘蛛产卵",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action4
    }
};

return v1;