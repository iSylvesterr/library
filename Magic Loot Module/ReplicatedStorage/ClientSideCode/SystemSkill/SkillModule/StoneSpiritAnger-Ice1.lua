-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local SoundModule = UtilsSystem.SoundModule;
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
require(script.Parent.Parent.BaseSkill.GetSkillData);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local FXUtil = UtilsSystem.FXUtil;
local _ = UtilsSystem.RayCast;
local BurstStone = UtilsSystem.BurstStone;
local _ = UtilsSystem.RunService;
local _ = UtilsSystem.CameraModule;
local u1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.Earth,
    skillSizeScale = 0.5,
    InitialState = "Startup",
    ControlOpenState = "Recovery",
    States = {
        Startup = {
            Duration = 0.8,
            OnEnterClient = "Client_EnterStartup",
            OnEnterServer = "Server_EnterStartup",
            OnExitClient = nil,
            OnExitServer = nil
        },
        HitLand = {
            Duration = 1,
            OnEnterClient = "Client_EnterHitLand",
            OnEnterServer = "Server_EnterHitLand",
            OnExitClient = "Client_ExitHitLand",
            OnExitServer = "Server_ExitHitLand"
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
            To = "HitLand",
            Event = SkillEventConst.StateTimeout
        },
        {
            From = "HitLand",
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
            From = "HitLand",
            To = "Interrupted",
            Event = SkillEventConst.Interrupt
        },
        {
            From = "Startup",
            To = "Finished",
            Event = SkillEventConst.ForceFinish
        },
        {
            From = "HitLand",
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

local function getSkillScale(p2) -- Line: 86
    -- upvalues: u1 (copy)
    local character = p2.skillInputData.character;
    local v3 = character and character:GetScale() or 1;
    local skillSizeScale = u1.skillSizeScale;

    if type(skillSizeScale) == "number" and skillSizeScale > 0 then
        return v3 * skillSizeScale;
    end;

    return v3;
end;

function u1.Client_EnterStartup(p4) -- Line: 97
end;

function u1.Server_EnterStartup(p5) -- Line: 115
    -- upvalues: u1 (copy)
    local v6 = p5.hitbox[1];

    if v6 and v6.hitbox then
        local character = p5.skillInputData.character;
        local v7 = character and character:GetScale() or 1;
        local skillSizeScale = u1.skillSizeScale;

        if type(skillSizeScale) == "number" and skillSizeScale > 0 then
            v7 = v7 * skillSizeScale;
        end;

        local v8 = v7 * 9;
        local v9 = Vector3.new(v8, v8, v8);
        v6.hitbox.Size = v9;
    end;
end;

function u1.Client_EnterHitLand(p10) -- Line: 127
    -- upvalues: u1 (copy), UtilsSystem (copy), FXUtil (copy), BurstStone (copy), SoundModule (copy)
    local character = p10.skillInputData.character;

    if not character then
        return;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local character2 = p10.skillInputData.character;
    local u11 = character2 and character2:GetScale() or 1;
    local skillSizeScale = u1.skillSizeScale;

    if type(skillSizeScale) == "number" and skillSizeScale > 0 then
        u11 = u11 * skillSizeScale;
    end;

    local u12 = HumanoidRootPart:GetPivot():ToWorldSpace(CFrame.new(-0, 0, u11 * -5));
    local v13 = UtilsSystem.RayCast.RayCastDirection(u12.Position, Vector3.new(0, -1, 0), 30, "Ground");

    if v13 then
        u12 = u12.Rotation + v13.Position + Vector3.new(0, 0.3, 0);
    end;

    local u14 = p10.skillRunData.material["石灵砸地爆炸-冰"];
    u14.Parent = workspace.Debris;
    u14:ScaleTo(u11);
    u14:PivotTo(CFrame.new(u12.Position));
    task.delay(0, function() -- Line: 147
        -- upvalues: FXUtil (ref), u14 (copy), UtilsSystem (ref), u12 (ref), u11 (copy), BurstStone (ref), SoundModule (ref)
        FXUtil.Emit_Particles_GetDescendants(u14, true);
        UtilsSystem.BurstStone.CreateLandBreak(CFrame.new(u12.Position), "SmallHitLand1", u11);
        BurstStone.CreateStoneFly(u12, "Meteor", u11);
        SoundModule:PlaySoundLocal({
            SoundName = "音效-石头人攻击",
            Is2D = false,
            PlayPosition = u12.Position
        });
    end);
end;

function u1.Client_ExitHitLand(p15) -- Line: 162
end;

function u1.Server_EnterHitLand(u16) -- Line: 169
    -- upvalues: u1 (copy), UtilsSystem (copy)
    local character = u16.skillInputData.character;

    if not character then
        return;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local character2 = u16.skillInputData.character;
    local u17 = character2 and character2:GetScale() or 1;
    local skillSizeScale = u1.skillSizeScale;

    if type(skillSizeScale) == "number" and skillSizeScale > 0 then
        u17 = u17 * skillSizeScale;
    end;

    local u18 = HumanoidRootPart:GetPivot():ToWorldSpace(CFrame.new(-0, 0, u17 * -3.5));
    local v19 = UtilsSystem.RayCast.RayCastDirection(u18.Position, Vector3.new(0, -1, 0), 30, "Ground");

    if v19 then
        u18 = u18.Rotation + v19.Position + Vector3.new(0, 0.3, 0);
    end;

    task.delay(0, function() -- Line: 185
        -- upvalues: u16 (copy), u18 (ref), u17 (copy)
        local u20 = u16.hitbox[1];

        if not u20 then
            return;
        end;

        u20.hitbox:PivotTo(u18);
        u20.hitbox.Size = Vector3.new(20, 20, 20) * u17;
        u20:start();
        task.delay(0.15, function() -- Line: 192
            -- upvalues: u20 (copy)
            u20:stop();
        end);
    end);
end;

function u1.Server_ExitHitLand(p21) -- Line: 199
    local v22 = p21.hitbox[1];
    local _ = p21.hitbox[2];
    local _ = p21.hitbox[3];

    if v22 and v22.isActive then
        v22:stop();
    end;
end;

function u1.Server_EnterRecovery(p23) -- Line: 207
    p23:releaseControl();
end;

function u1.Client_EnterRecovery(p24) -- Line: 211
end;

u1.SoundList = { "音效-石头人攻击" };
u1.AnimateList = { "石灵砸地" };
u1.ResNameList = { "石灵砸地爆炸-冰" };
u1.hitboxConfig = { {
        HitboxIndex = 1,
        PartName = "通用球",
        CollisionGroup = "Player",
        HitPresentationProfile = "通用受击",
        PhysicsEffectName = "通用受击物理效果"
    } };
u1.Action = {
    {
        action = "LookAt",
        startTime = 0,
        overTime = 0.8,
        speedType = "RELEASE_SKILL_STATE_HALF"
    },
    {
        action = "Animation",
        startTime = 0,
        overTime = 1.2,
        animationName = "石灵砸地",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action
    }
};

return u1;