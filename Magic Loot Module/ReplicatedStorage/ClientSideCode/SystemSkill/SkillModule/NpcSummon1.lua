-- Decompiled with Potassium's decompiler.

local v1 = {};
local ElementTp = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local NpcSummonCore = require(script.Parent._Templates.NpcSummonCore);
v1.skillTotalTime = -1;
v1.visualFadeoutTime = 2;
v1.skillElementType = ElementTp.None;
v1.skillDistanceLimit = 64;
v1.InitialState = "Startup";
v1.ControlOpenState = "Summon";
v1.States = {
    Startup = {
        Duration = 1.33,
        OnEnterClient = "Client_EnterStartup",
        OnEnterServer = "Server_EnterStartup"
    },
    Summon = {
        Duration = 1.1,
        OnEnterClient = "Client_EnterSummon",
        OnEnterServer = "Server_EnterSummon",
        OnExitClient = "Client_ExitSummon"
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
NpcSummonCore.attach(v1, {
    summonId = 5000001,
    summonSkillKey = "NpcSummon1",
    summonMaxCount = 3
});

function v1.Server_EnterStartup(p2) -- Line: 67
end;

function v1.Server_EnterRecovery(p3) -- Line: 70
    p3:releaseControl();
end;

function v1.Client_EnterRecovery(p4) -- Line: 74
end;

v1.SoundList = { "音效-召唤法术-通用融合", "音效-召唤法术-通用法阵圈消散", "音效-召唤法术-通用法阵", "音效-召唤法术-通用投掷", "音效-召唤法术-召唤物的法阵圈1" };
v1.AnimateList = { "小召唤术" };
v1.ResNameList = { "召唤法阵A01_起手空间法阵_Emit", "召唤法阵A02_起手空间爆点_Emit", "召唤法阵A03_空间球_Enable", "召唤法阵A04_空间爆发_Emit", "召唤法阵1级_Emit和Enable" };
v1.hitboxConfig = {};
v1.Action = {
    {
        action = "Animation",
        startTime = 0,
        overTime = 2.5,
        animationName = "小召唤术",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action4
    }
};

return v1;