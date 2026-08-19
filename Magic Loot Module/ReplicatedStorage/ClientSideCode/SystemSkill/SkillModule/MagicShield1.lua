-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
require(script.Parent.Parent.BaseSkill.GetSkillData);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local SystemPlrAttr = UtilsSystem.SystemPlrAttr;
local GetData = UtilsSystem.GetData;
local _ = UtilsSystem.CameraModule;
local FXUtil = UtilsSystem.FXUtil;
local _ = UtilsSystem.RayCast;
local _ = UtilsSystem.BurstStone;
local RunService = UtilsSystem.RunService;
local u1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.None,
    skillDistanceLimit = 64,
    MagicDefenseConfig = {
        perfectDefenseDuration = 0.1,
        normalDefenseDuration = 0.4,
        perfectBlockChargeCount = 1,
        normalBlockChargeCount = 5
    }
};
local v2 = u1.MagicDefenseConfig.perfectDefenseDuration + u1.MagicDefenseConfig.normalDefenseDuration;

local function clearDodgeInvulnIfShieldEndedEarly(p3) -- Line: 53
    -- upvalues: GetData (copy), SystemPlrAttr (copy)
    local skillRunData = p3.skillRunData;

    if not skillRunData then
        return;
    end;

    local magicShieldDefenseEndAt = skillRunData.magicShieldDefenseEndAt;

    if type(magicShieldDefenseEndAt) ~= "number" then
        return;
    end;

    skillRunData.magicShieldDefenseEndAt = nil;

    if magicShieldDefenseEndAt <= workspace:GetServerTimeNow() + 0.02 then
        return;
    end;

    local v4 = GetData.GetPlayerByID(p3.characterId);

    if not v4 then
        return;
    end;

    SystemPlrAttr.ClearMagicShieldBlockBudget(v4);
    local v5 = v4:FindFirstChild("闪避无敌");

    if v5 and v5:IsA("NumberValue") then
        v5.Value = 0;
    end;
end;

u1.InitialState = "Startup";
u1.ControlOpenState = "ActiveShield";
u1.States = {
    Startup = {
        Duration = 0.1,
        OnEnterClient = "Client_EnterStartup",
        OnEnterServer = "Server_EnterStartup",
        OnExitClient = nil,
        OnExitServer = nil
    },
    ActiveShield = {
        OnEnterClient = "Client_EnterActiveShield",
        OnEnterServer = "Server_EnterActiveShield",
        OnExitClient = "Client_ExitActiveShield",
        OnExitServer = "Server_ExitActiveShield",
        Duration = v2
    },
    Recovery = {
        Duration = 0.2,
        OnEnterClient = "Client_EnterRecovery",
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
u1.Transitions = {
    {
        From = "Startup",
        To = "ActiveShield",
        Event = SkillEventConst.StateTimeout
    },
    {
        From = "ActiveShield",
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
        From = "ActiveShield",
        To = "Interrupted",
        Event = SkillEventConst.Interrupt
    },
    {
        From = "Startup",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    },
    {
        From = "ActiveShield",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    },
    {
        From = "Recovery",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    }
};

function u1.Client_EnterStartup(p6) -- Line: 121
    -- upvalues: SkillCommon (copy)
    local character = p6.skillInputData.character;

    if not character then
        return;
    end;

    if not SkillCommon.resolveWandTipFromCharacter(character) then
        return;
    end;

    if character:FindFirstChild("HumanoidRootPart") then
    end;
end;

function u1.Server_EnterStartup(p7) -- Line: 132
end;

function u1.Client_EnterActiveShield(p8) -- Line: 137
    -- upvalues: FXUtil (copy), RunService (copy)
    local character = p8.skillInputData.character;

    if not character then
        return;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local u9 = p8.skillRunData.material["弹反魔法护盾"];
    u9:PivotTo(HumanoidRootPart:GetPivot());
    u9.Parent = workspace.Debris;
    FXUtil.Emit_Particles_GetDescendants(u9, true);
    p8.skillRunData.runEvent["护盾跟随"] = RunService.Heartbeat:Connect(function() -- Line: 147
        -- upvalues: HumanoidRootPart (copy), u9 (copy)
        if HumanoidRootPart and HumanoidRootPart.Parent then
            u9:PivotTo(HumanoidRootPart:GetPivot());
        end;
    end);
end;

function u1.Client_ExitActiveShield(p10) -- Line: 157
end;

function u1.Server_EnterActiveShield(p11) -- Line: 161
    -- upvalues: u1 (copy), SystemPlrAttr (copy)
    local MagicDefenseConfig = u1.MagicDefenseConfig;
    local v12 = MagicDefenseConfig.perfectDefenseDuration + MagicDefenseConfig.normalDefenseDuration;
    local skillRunData = p11.skillRunData;

    if skillRunData then
        skillRunData.magicShieldDefenseEndAt = workspace:GetServerTimeNow() + v12;
    end;

    SystemPlrAttr.DefensePlr(p11.characterId, v12);
    SystemPlrAttr.PerfectDefensePlr(p11.characterId, MagicDefenseConfig.perfectDefenseDuration);
    SystemPlrAttr.SetMagicShieldBlockBudget(p11.characterId, MagicDefenseConfig.perfectBlockChargeCount, MagicDefenseConfig.normalBlockChargeCount);
end;

function u1.Server_ExitActiveShield(p13) -- Line: 177
    -- upvalues: GetData (copy), SystemPlrAttr (copy), clearDodgeInvulnIfShieldEndedEarly (copy)
    local v14 = GetData.GetPlayerByID(p13.characterId);

    if v14 then
        SystemPlrAttr.ClearMagicShieldBlockBudget(v14);
    end;

    clearDodgeInvulnIfShieldEndedEarly(p13);
    local v15 = p13.hitbox[1];

    if v15 and v15.isActive then
        v15:stop();
    end;
end;

function u1.Server_EnterRecovery(p16) -- Line: 190
    p16:releaseControl();
end;

function u1.Client_EnterRecovery(p17) -- Line: 194
end;

u1.SoundList = {};
u1.AnimateList = { "魔法防御" };
u1.ResNameList = { "弹反魔法护盾" };
u1.hitboxConfig = {};
u1.Action = {
    {
        action = "Animation",
        startTime = 0,
        overTime = 1.2,
        animationName = "魔法防御",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action
    }
};

return u1;