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
            Duration = 0.9,
            OnEnterClient = "Client_EnterStartup",
            OnEnterServer = "Server_EnterStartup",
            OnExitClient = nil,
            OnExitServer = nil
        },
        Swing = {
            Duration = 0.4,
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

local function get_skillScale(p2) -- Line: 78
    local character = p2.skillInputData.character;

    return character and character:GetScale() or 1;
end;

function v1.Client_EnterStartup(p3) -- Line: 84
end;

function v1.Server_EnterStartup(p4) -- Line: 88
    local v5 = p4.hitbox[1];

    if v5 and v5.hitbox then
        local character = p4.skillInputData.character;
        v5.hitbox.Size = Vector3.new(11, 11, 11) * (character and character:GetScale() or 1);
    end;
end;

function v1.Client_EnterSwing(p6) -- Line: 97
    -- upvalues: FXUtil (copy), RunService (copy), SoundModule (copy)
    local character = p6.skillInputData.character;

    if not character then
        return;
    end;

    local u7 = p6.skillRunData.material["横劈刀光"];
    u7.Parent = workspace.Debris;
    u7:PivotTo(character:GetPivot());
    FXUtil.Emit_Particles_GetDescendants(u7, true);
    p6.skillRunData.runEvent["刀光跟随"] = RunService.Heartbeat:Connect(function() -- Line: 107
        -- upvalues: u7 (copy), character (copy)
        if u7 and character then
            u7:PivotTo(character:GetPivot());
        end;
    end);
    SoundModule:PlaySoundLocal({
        SoundName = "技能_武器重击",
        Is2D = false,
        PlayPosition = character:GetPivot().Position
    });
end;

function v1.Client_ExitSwing(p8) -- Line: 123
    if p8.skillRunData.runEvent and p8.skillRunData.runEvent["刀光跟随"] then
        p8.skillRunData.runEvent["刀光跟随"]:Disconnect();
        p8.skillRunData.runEvent["刀光跟随"] = nil;
    end;
end;

function v1.Server_EnterSwing(u9) -- Line: 132
    -- upvalues: RunService (copy)
    local u10 = u9.hitbox[1];

    if not u10 then
        return;
    end;

    u10:start();
    local character = u9.skillInputData.character;

    if not character then
        return;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    u9.skillRunData.runEvent["命中盒控制"] = RunService.Heartbeat:Connect(function(p11) -- Line: 141
        -- upvalues: HumanoidRootPart (copy), u10 (copy), u9 (copy)
        if HumanoidRootPart and HumanoidRootPart.Parent then
            local hitbox = u10.hitbox;
            local v12 = HumanoidRootPart:GetPivot();
            local character2 = u9.skillInputData.character;
            hitbox:PivotTo(v12:ToWorldSpace(CFrame.new(0, 0, -5 * (character2 and character2:GetScale() or 1))));
        end;
    end);
end;

function v1.Server_ExitSwing(p13) -- Line: 152
    local v14 = p13.hitbox[1];

    if v14 and v14.isActive then
        v14:stop();
    end;

    if p13.skillRunData.runEvent["命中盒控制"] then
        p13.skillRunData.runEvent["命中盒控制"]:Disconnect();
        p13.skillRunData.runEvent["命中盒控制"] = nil;
    end;
end;

function v1.Server_EnterRecovery(p15) -- Line: 164
    p15:releaseControl();
end;

function v1.Client_EnterRecovery(p16) -- Line: 168
end;

v1.SoundList = { "技能_武器重击" };
v1.AnimateList = { "人形生物挥砍4" };
v1.ResNameList = { "横劈刀光" };
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
        overTime = 2.6,
        speedType = "RELEASE_SKILL_STATE_HALF"
    },
    {
        action = "Animation",
        startTime = 0,
        overTime = 2.67,
        animationName = "人形生物挥砍4",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action
    }
};

return v1;