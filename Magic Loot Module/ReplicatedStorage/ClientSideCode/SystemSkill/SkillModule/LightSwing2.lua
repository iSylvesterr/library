-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local SoundModule = UtilsSystem.SoundModule;
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local RunService = UtilsSystem.RunService;
local SkillTelegraph = UtilsSystem.SkillTelegraph;
local u1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.None,
    InitialState = "Startup",
    ControlOpenState = "Swing",
    States = {
        Startup = {
            Duration = 1.74,
            OnEnterClient = "Client_EnterStartup",
            OnEnterServer = "Server_EnterStartup",
            OnExitClient = "Client_ExitStartup",
            OnExitServer = nil
        },
        Swing = {
            Duration = 0.2,
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
            IsTerminal = true,
            OnEnterClient = "Client_EnterInterrupted"
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
    -- upvalues: SkillCommon (copy)
    local v3 = p2.skillInputData and p2.skillInputData.character;

    return (v3 and v3:GetScale() or 1) * SkillCommon.scaleBandFromData(p2, SkillCommon.bandScaleOptsFromSkillData(p2));
end;

local function stopTelegraphAimLoop(p4) -- Line: 93
    if not (p4 and p4.runEvent) then
        return;
    end;

    local damageTelegraphAim = p4.runEvent.damageTelegraphAim;

    if damageTelegraphAim then
        damageTelegraphAim:Disconnect();
        p4.runEvent.damageTelegraphAim = nil;
    end;
end;

local function destroyDangerTelegraph(p5) -- Line: 109
    local v6 = p5 and p5.runEvent and p5.runEvent.damageTelegraphAim;

    if v6 then
        v6:Disconnect();
        p5.runEvent.damageTelegraphAim = nil;
    end;

    if not (p5 and p5.Logic) then
        return;
    end;

    local dangerTelegraph = p5.Logic.dangerTelegraph;

    if dangerTelegraph then
        dangerTelegraph:destroy();
        p5.Logic.dangerTelegraph = nil;
    end;
end;

local function resolveSwingHitboxCF(p7) -- Line: 127
    -- upvalues: SkillCommon (copy)
    local v8 = p7.skillInputData and p7.skillInputData.character;

    if not v8 then
        return nil;
    end;

    local HumanoidRootPart = v8:FindFirstChild("HumanoidRootPart");

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        return nil;
    end;

    local v9 = HumanoidRootPart:GetPivot();
    local v10 = p7.skillInputData and p7.skillInputData.character;

    return v9:ToWorldSpace(CFrame.new(0, 0, (v10 and v10:GetScale() or 1) * SkillCommon.scaleBandFromData(p7, SkillCommon.bandScaleOptsFromSkillData(p7)) * -3));
end;

local function resolveSwingHitboxSize(p11) -- Line: 145
    -- upvalues: SkillCommon (copy)
    local v12 = p11.skillInputData and p11.skillInputData.character;

    return Vector3.new(12, 12, 12) * ((v12 and v12:GetScale() or 1) * SkillCommon.scaleBandFromData(p11, SkillCommon.bandScaleOptsFromSkillData(p11)));
end;

local function startTelegraphAimLoop(u13, u14, u15) -- Line: 157
    -- upvalues: RunService (copy), SkillCommon (copy), resolveSwingHitboxCF (copy)
    local v16 = u14 and u14.runEvent and u14.runEvent.damageTelegraphAim;

    if v16 then
        v16:Disconnect();
        u14.runEvent.damageTelegraphAim = nil;
    end;

    u14.runEvent.damageTelegraphAim = RunService.Heartbeat:Connect(function() -- Line: 159
        -- upvalues: SkillCommon (ref), u13 (copy), u15 (copy), u14 (copy), resolveSwingHitboxCF (ref)
        if not SkillCommon.isRunningSameGeneration(u13, u15) then
            local v17 = u14;

            if v17 then
                if not v17.runEvent then
                    return;
                end;

                local damageTelegraphAim = v17.runEvent.damageTelegraphAim;

                if damageTelegraphAim then
                    damageTelegraphAim:Disconnect();
                    v17.runEvent.damageTelegraphAim = nil;
                end;
            end;

            return;
        end;

        local v18 = u14.Logic and u14.Logic.dangerTelegraph;

        if not v18 then
            return;
        end;

        local v19 = resolveSwingHitboxCF(u13);

        if not v19 then
            return;
        end;

        local v20 = {
            worldCFrame = v19
        };
        local v21 = u13;
        local v22 = v21.skillInputData and v21.skillInputData.character;
        v20.hitboxSize = Vector3.new(12, 12, 12) * ((v22 and v22:GetScale() or 1) * SkillCommon.scaleBandFromData(v21, SkillCommon.bandScaleOptsFromSkillData(v21)));
        v18:update(v20);
    end);
end;

function u1.Client_EnterStartup(u23) -- Line: 180
    -- upvalues: resolveSwingHitboxCF (copy), SkillTelegraph (copy), SkillCommon (copy), u1 (copy), RunService (copy)
    local skillRunData = u23.skillRunData;
    skillRunData.Logic = skillRunData.Logic or {};
    local v24 = skillRunData and skillRunData.runEvent and skillRunData.runEvent.damageTelegraphAim;

    if v24 then
        v24:Disconnect();
        skillRunData.runEvent.damageTelegraphAim = nil;
    end;

    local v25 = skillRunData and skillRunData.Logic and skillRunData.Logic.dangerTelegraph;

    if v25 then
        v25:destroy();
        skillRunData.Logic.dangerTelegraph = nil;
    end;

    local v26 = resolveSwingHitboxCF(u23);

    if not v26 then
        return;
    end;

    local Logic = skillRunData.Logic;
    local new = SkillTelegraph.new;
    local v27 = {
        shape = "Circle",
        worldCFrame = v26
    };
    local v28 = u23.skillInputData and u23.skillInputData.character;
    v27.hitboxSize = Vector3.new(12, 12, 12) * ((v28 and v28:GetScale() or 1) * SkillCommon.scaleBandFromData(u23, SkillCommon.bandScaleOptsFromSkillData(u23)));
    v27.warnDuration = u1.States.Startup.Duration;
    v27.casterCharacter = u23.skillInputData and u23.skillInputData.character;
    v27.characterType = u23.characterType;
    Logic.dangerTelegraph = new(v27);
    local runGeneration = u23.runGeneration;
    local v29 = skillRunData and skillRunData.runEvent and skillRunData.runEvent.damageTelegraphAim;

    if v29 then
        v29:Disconnect();
        skillRunData.runEvent.damageTelegraphAim = nil;
    end;

    skillRunData.runEvent.damageTelegraphAim = RunService.Heartbeat:Connect(function() -- Line: 159
        -- upvalues: SkillCommon (ref), u23 (copy), runGeneration (copy), skillRunData (copy), resolveSwingHitboxCF (ref)
        if not SkillCommon.isRunningSameGeneration(u23, runGeneration) then
            local v30 = skillRunData;

            if v30 then
                if not v30.runEvent then
                    return;
                end;

                local damageTelegraphAim = v30.runEvent.damageTelegraphAim;

                if damageTelegraphAim then
                    damageTelegraphAim:Disconnect();
                    v30.runEvent.damageTelegraphAim = nil;
                end;
            end;

            return;
        end;

        local v31 = skillRunData.Logic and skillRunData.Logic.dangerTelegraph;

        if not v31 then
            return;
        end;

        local v32 = resolveSwingHitboxCF(u23);

        if not v32 then
            return;
        end;

        local v33 = {
            worldCFrame = v32
        };
        local v34 = u23;
        local v35 = v34.skillInputData and v34.skillInputData.character;
        v33.hitboxSize = Vector3.new(12, 12, 12) * ((v35 and v35:GetScale() or 1) * SkillCommon.scaleBandFromData(v34, SkillCommon.bandScaleOptsFromSkillData(v34)));
        v31:update(v33);
    end);
end;

function u1.Client_ExitStartup(p36) -- Line: 201
end;

function u1.Server_EnterStartup(p37) -- Line: 204
    -- upvalues: SkillCommon (copy)
    local v38 = p37.hitbox[1];

    if v38 and v38.hitbox then
        local v39 = p37.skillInputData and p37.skillInputData.character;
        v38.hitbox.Size = Vector3.new(12, 12, 12) * ((v39 and v39:GetScale() or 1) * SkillCommon.scaleBandFromData(p37, SkillCommon.bandScaleOptsFromSkillData(p37)));
    end;
end;

function u1.Client_EnterSwing(p40) -- Line: 212
    -- upvalues: SoundModule (copy), u1 (copy)
    local character = p40.skillInputData.character;

    if not character then
        return;
    end;

    SoundModule:PlaySoundLocal({
        SoundName = "技能_武器重击",
        Is2D = false,
        PlayPosition = character:GetPivot().Position
    });
    local skillRunData = p40.skillRunData;
    local v41 = skillRunData.Logic and skillRunData.Logic.dangerTelegraph;

    if v41 then
        v41:activate(u1.States.Swing.Duration);
    end;
end;

function u1.Client_ExitSwing(p42) -- Line: 231
end;

function u1.Server_EnterSwing(u43) -- Line: 234
    -- upvalues: RunService (copy), SkillCommon (copy)
    local u44 = u43.hitbox[1];

    if not u44 then
        return;
    end;

    u44:start();
    local character = u43.skillInputData.character;

    if not character then
        return;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    u43.skillRunData.runEvent["命中盒控制"] = RunService.Heartbeat:Connect(function() -- Line: 249
        -- upvalues: HumanoidRootPart (copy), u44 (copy), u43 (copy), SkillCommon (ref)
        if HumanoidRootPart and HumanoidRootPart.Parent then
            local hitbox = u44.hitbox;
            local v45 = HumanoidRootPart:GetPivot();
            local v46 = u43;
            local v47 = v46.skillInputData and v46.skillInputData.character;
            hitbox:PivotTo(v45:ToWorldSpace(CFrame.new(0, 0, (v47 and v47:GetScale() or 1) * SkillCommon.scaleBandFromData(v46, SkillCommon.bandScaleOptsFromSkillData(v46)) * -3)));
        end;
    end);
end;

function u1.Server_ExitSwing(p48) -- Line: 256
    local v49 = p48.hitbox[1];

    if v49 and v49.isActive then
        v49:stop();
    end;

    if p48.skillRunData.runEvent["命中盒控制"] then
        p48.skillRunData.runEvent["命中盒控制"]:Disconnect();
        p48.skillRunData.runEvent["命中盒控制"] = nil;
    end;
end;

function u1.Server_EnterRecovery(p50) -- Line: 268
    p50:releaseControl();
end;

function u1.Client_EnterRecovery(p51) -- Line: 272
    local skillRunData = p51.skillRunData;
    local v52 = skillRunData and skillRunData.runEvent and skillRunData.runEvent.damageTelegraphAim;

    if v52 then
        v52:Disconnect();
        skillRunData.runEvent.damageTelegraphAim = nil;
    end;

    if skillRunData then
        if not skillRunData.Logic then
            return;
        end;

        local dangerTelegraph = skillRunData.Logic.dangerTelegraph;

        if dangerTelegraph then
            dangerTelegraph:destroy();
            skillRunData.Logic.dangerTelegraph = nil;
        end;
    end;
end;

function u1.Client_EnterInterrupted(p53) -- Line: 276
    local skillRunData = p53.skillRunData;
    local v54 = skillRunData and skillRunData.runEvent and skillRunData.runEvent.damageTelegraphAim;

    if v54 then
        v54:Disconnect();
        skillRunData.runEvent.damageTelegraphAim = nil;
    end;

    if skillRunData then
        if not skillRunData.Logic then
            return;
        end;

        local dangerTelegraph = skillRunData.Logic.dangerTelegraph;

        if dangerTelegraph then
            dangerTelegraph:destroy();
            skillRunData.Logic.dangerTelegraph = nil;
        end;
    end;
end;

u1.SoundList = { "技能_武器重击" };
u1.AnimateList = { "人形生物挥砍2" };
u1.ResNameList = {};
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
        overTime = 2.6,
        speedType = "RELEASE_SKILL_STATE_HALF"
    },
    {
        action = "Animation",
        startTime = 0,
        overTime = 2.67,
        animationName = "人形生物挥砍2",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action
    }
};

return u1;