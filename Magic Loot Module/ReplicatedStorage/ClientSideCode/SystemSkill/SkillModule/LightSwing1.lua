-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local SoundModule = UtilsSystem.SoundModule;
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
require(script.Parent.Parent.BaseSkill.GetSkillData);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local FXUtil = UtilsSystem.FXUtil;
local _ = UtilsSystem.RayCast;
local _ = UtilsSystem.BurstStone;
local RunService = UtilsSystem.RunService;
local v1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.Fire,
    InitialState = "Startup",
    ControlOpenState = "Swing",
    States = {
        Startup = {
            Duration = 0.5,
            OnEnterClient = "Client_EnterStartup",
            OnEnterServer = "Server_EnterStartup",
            OnExitClient = nil,
            OnExitServer = nil
        },
        Swing = {
            Duration = 0.5,
            OnEnterClient = "Client_EnterSwing",
            OnEnterServer = "Server_EnterSwing",
            OnExitClient = "Client_ExitSwing",
            OnExitServer = "Server_ExitSwing"
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
    },
    Transitions = {
        {
            From = "Startup",
            To = "Swing",
            Event = SkillEventConst.StateTimeout
        },
        {
            From = "Swing",
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
            From = "Swing",
            To = "Interrupted",
            Event = SkillEventConst.Interrupt
        },
        {
            From = "Startup",
            To = "Finished",
            Event = SkillEventConst.ForceFinish
        },
        {
            From = "Swing",
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

local function get_skillScale(p2) -- Line: 81
    local character = p2.skillInputData.character;

    return character and character:GetScale() or 1;
end;

function v1.Client_EnterStartup(p3) -- Line: 87
end;

function v1.Server_EnterStartup(p4) -- Line: 91
    local v5 = p4.hitbox[1];

    if v5 and v5.hitbox then
        local character = p4.skillInputData.character;
        local v6 = character and character:GetScale() or 1;
        local v7 = Vector3.new(9, 9, 9 * v6);
        v5.hitbox.Size = v7;
    end;
end;

function v1.Client_EnterSwing(u8) -- Line: 102
    -- upvalues: SoundModule (copy), FXUtil (copy), RunService (copy)
    local u9 = u8.skillRunData.material["刀光"];
    u9.Parent = workspace.Debris;
    local character = u8.skillInputData.character;

    if not character then
        return;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    SoundModule:PlaySoundLocal({
        SoundName = "音效-技能-剑-whoosh",
        Is2D = false,
        PlayPosition = HumanoidRootPart.Position
    });
    FXUtil.Emit_Particles_GetDescendants(u9, true);
    u8.skillRunData.runEvent["刀光特效控制"] = RunService.Heartbeat:Connect(function(p10) -- Line: 120
        -- upvalues: HumanoidRootPart (copy), u9 (copy), u8 (copy)
        if HumanoidRootPart and HumanoidRootPart.Parent then
            local v11 = HumanoidRootPart:GetPivot();
            local character2 = u8.skillInputData.character;
            u9:PivotTo(v11:ToWorldSpace(CFrame.new(0, 0, -1 * (character2 and character2:GetScale() or 1))));
        end;
    end);
end;

function v1.Client_ExitSwing(p12) -- Line: 130
    if p12.skillRunData.runEvent["刀光特效控制"] then
        p12.skillRunData.runEvent["刀光特效控制"]:Disconnect();
        p12.skillRunData.runEvent["刀光特效控制"] = nil;
    end;
end;

function v1.Server_EnterSwing(u13) -- Line: 137
    -- upvalues: RunService (copy)
    local u14 = u13.hitbox[1];

    if not u14 then
        return;
    end;

    u14:start();
    local character = u13.skillInputData.character;

    if not character then
        return;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    u13.skillRunData.runEvent["命中盒控制"] = RunService.Heartbeat:Connect(function(p15) -- Line: 146
        -- upvalues: HumanoidRootPart (copy), u14 (copy), u13 (copy)
        if HumanoidRootPart and HumanoidRootPart.Parent then
            local hitbox = u14.hitbox;
            local v16 = HumanoidRootPart:GetPivot();
            local character2 = u13.skillInputData.character;
            hitbox:PivotTo(v16:ToWorldSpace(CFrame.new(0, 0, -1 * (character2 and character2:GetScale() or 1))));
        end;
    end);
end;

function v1.Server_ExitSwing(p17) -- Line: 157
    local v18 = p17.hitbox[1];

    if v18 and v18.isActive then
        v18:stop();
    end;

    if p17.skillRunData.runEvent["命中盒控制"] then
        p17.skillRunData.runEvent["命中盒控制"]:Disconnect();
        p17.skillRunData.runEvent["命中盒控制"] = nil;
    end;
end;

function v1.Server_EnterRecovery(p19) -- Line: 169
    p19:releaseControl();
end;

function v1.Client_EnterRecovery(p20) -- Line: 173
end;

v1.SoundList = { "音效-技能-剑-whoosh" };
v1.AnimateList = { "人形生物挥砍1" };
v1.ResNameList = { "刀光" };
v1.hitboxConfig = { {
        HitboxIndex = 1,
        PartName = "通用球",
        CollisionGroup = "Player",
        HitPresentationProfile = "通用受击",
        PhysicsEffectName = "通用受击物理效果"
    } };
v1.Action = {
    {
        action = "LookAt",
        startTime = 0,
        overTime = 0.8,
        speedType = "RELEASE_SKILL_STATE_HALF"
    },
    {
        action = "Animation",
        startTime = 0,
        overTime = 1.33,
        animationName = "人形生物挥砍1",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action
    }
};

return v1;