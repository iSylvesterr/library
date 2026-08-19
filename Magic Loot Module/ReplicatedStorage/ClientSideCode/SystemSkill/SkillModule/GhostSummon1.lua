-- Decompiled with Potassium's decompiler.

local v1 = {};
local ElementTp = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local GhostSummonCore = require(script.Parent._Templates.GhostSummonCore);
v1.skillTotalTime = -1;
v1.visualFadeoutTime = 2;
v1.skillElementType = ElementTp.Dark;
v1.skillDistanceLimit = 64;
v1.InitialState = "Startup";
v1.ControlOpenState = "Summon";
v1.States = {
    Startup = {
        Duration = 1,
        OnEnterClient = "Client_EnterStartup",
        OnEnterServer = "Server_EnterStartup"
    },
    Summon = {
        Duration = 2,
        OnEnterClient = "Client_EnterSummon",
        OnEnterServer = "Server_EnterSummon",
        OnExitClient = "Client_ExitSummon"
    },
    Recovery = {
        Duration = 0.5,
        OnEnterClient = "Client_EnterRecovery",
        OnEnterServer = "Server_EnterRecovery",
        OnExitClient = "Client_ExitRecovery"
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
        To = "Summon",
        Event = SkillEventConst.StateTimeout
    },
    {
        From = "Summon",
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
        From = "Summon",
        To = "Interrupted",
        Event = SkillEventConst.Interrupt
    },
    {
        From = "Startup",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    },
    {
        From = "Summon",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    },
    {
        From = "Recovery",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    }
};
GhostSummonCore.attach(v1, {
    summonSkillKey = "GhostSummon1",
    summonMaxCount = 2,
    spawnIntroDuration = 2,
    spawnGroundOffsetY = 4.5,
    spawnIntroBelowOffset = 25,
    sideOffsetStuds = 20,
    summonSlots = { {
            summonId = 5030008,
            formationVfxName = "幽灵船长召唤法阵_紫",
            lateralSign = -1
        }, {
            summonId = 5030009,
            formationVfxName = "幽灵船长召唤法阵_红",
            lateralSign = 1
        } }
});

function v1.Server_EnterStartup(p2) -- Line: 90
end;

function v1.Client_EnterStartup(p3) -- Line: 93
end;

function v1.Server_EnterRecovery(p4) -- Line: 96
    p4:releaseControl();
end;

function v1.Client_EnterRecovery(p5) -- Line: 100
end;

v1.SoundList = { "音效-幽灵船长-幽魂分身法阵" };
v1.AnimateList = { "幽魂分身" };
v1.ResNameList = { "幽灵船长召唤特效", "幽灵船长召唤法阵_紫", "幽灵船长召唤法阵_红" };
v1.hitboxConfig = {};
v1.Action = {
    {
        action = "Animation",
        startTime = 0,
        overTime = 3.43,
        animationName = "幽魂分身",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action4
    }
};

return v1;