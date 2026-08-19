-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local SoundModule = UtilsSystem.SoundModule;
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
require(script.Parent.Parent.BaseSkill.GetSkillData);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local FXUtil = UtilsSystem.FXUtil;
local RayCast = UtilsSystem.RayCast;
local _ = UtilsSystem.BurstStone;
local RunService = UtilsSystem.RunService;
local SkillTelegraph = UtilsSystem.SkillTelegraph;
local u1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.Fire
};
local AIM_RUN_EVENT_KEY = SkillTelegraph.AIM_RUN_EVENT_KEY;
u1.InitialState = "Startup";
u1.ControlOpenState = "Swing";
u1.States = {
    Startup = {
        Duration = 1.19,
        OnEnterClient = "Client_EnterStartup",
        OnEnterServer = "Server_EnterStartup",
        OnExitClient = "Client_ExitStartup",
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
        IsTerminal = true,
        OnEnterClient = "Client_EnterInterrupted"
    }
};
u1.Transitions = {
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
};

local function get_skillScale(p2) -- Line: 89
    local character = p2.skillInputData.character;

    return character and character:GetScale() or 1;
end;

local function applyHitboxVisibility(p3, p4) -- Line: 100
    if not (p3 and p3.hitbox) then
        return;
    end;

    p3.hitbox.Transparency = p4 and 0.3 or 1;
end;

local function applyBurstHitboxTransform(p5) -- Line: 113
    local v6 = p5.hitbox[1];

    if not (v6 and v6.hitbox) then
        return nil;
    end;

    local character = p5.skillInputData.character;

    if not character then
        return nil;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        return nil;
    end;

    local character2 = p5.skillInputData.character;
    local v7 = character2 and character2:GetScale() or 1;
    v6.hitbox.Size = Vector3.new(25, 25, 25) * v7;
    v6.hitbox:PivotTo(HumanoidRootPart:GetPivot():ToWorldSpace(CFrame.new(Vector3.new(0, 0, -8) * v7)));

    return v6;
end;

local function stopTelegraphAimLoop(p8) -- Line: 137
    -- upvalues: AIM_RUN_EVENT_KEY (copy)
    if not (p8 and p8.runEvent) then
        return;
    end;

    local v9 = p8.runEvent[AIM_RUN_EVENT_KEY];

    if v9 then
        v9:Disconnect();
        p8.runEvent[AIM_RUN_EVENT_KEY] = nil;
    end;
end;

local function destroyDangerTelegraph(p10) -- Line: 153
    -- upvalues: AIM_RUN_EVENT_KEY (copy)
    local v11 = p10 and p10.runEvent and p10.runEvent[AIM_RUN_EVENT_KEY];

    if v11 then
        v11:Disconnect();
        p10.runEvent[AIM_RUN_EVENT_KEY] = nil;
    end;

    if not (p10 and p10.Logic) then
        return;
    end;

    local dangerTelegraph = p10.Logic.dangerTelegraph;

    if dangerTelegraph then
        dangerTelegraph:destroy();
        p10.Logic.dangerTelegraph = nil;
    end;
end;

local function resolveHrpBurstLandCF(p12) -- Line: 171
    -- upvalues: RayCast (copy)
    local v13 = p12.skillInputData and p12.skillInputData.character;

    if not v13 then
        return nil;
    end;

    local HumanoidRootPart = v13:FindFirstChild("HumanoidRootPart");

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        return nil;
    end;

    local character = p12.skillInputData.character;
    local v14 = character and character:GetScale() or 1;
    local v15 = HumanoidRootPart:GetPivot():ToWorldSpace(CFrame.new(Vector3.new(0, 0, -8) * v14));
    local v16 = RayCast.RayCastDirection(v15.Position, Vector3.new(0, -1, 0), 50, "Ground");

    if v16 then
        v15 = v15.Rotation + v16.Position + Vector3.new(0, 0.3, 0);
    end;

    return v15;
end;

local function startTelegraphAimLoop(u17, u18, u19) -- Line: 196
    -- upvalues: AIM_RUN_EVENT_KEY (copy), RunService (copy), resolveHrpBurstLandCF (copy)
    local v20 = u18 and u18.runEvent and u18.runEvent[AIM_RUN_EVENT_KEY];

    if v20 then
        v20:Disconnect();
        u18.runEvent[AIM_RUN_EVENT_KEY] = nil;
    end;

    u18.runEvent[AIM_RUN_EVENT_KEY] = RunService.Heartbeat:Connect(function() -- Line: 198
        -- upvalues: u17 (copy), u19 (copy), u18 (copy), AIM_RUN_EVENT_KEY (ref), resolveHrpBurstLandCF (ref)
        if not u17:isRunningFlow() or u17.runGeneration ~= u19 then
            local v21 = u18;

            if v21 then
                if not v21.runEvent then
                    return;
                end;

                local v22 = v21.runEvent[AIM_RUN_EVENT_KEY];

                if v22 then
                    v22:Disconnect();
                    v21.runEvent[AIM_RUN_EVENT_KEY] = nil;
                end;
            end;

            return;
        end;

        local v23 = u18.Logic and u18.Logic.dangerTelegraph;

        if not v23 then
            return;
        end;

        local v24 = resolveHrpBurstLandCF(u17);

        if not v24 then
            return;
        end;

        local character = u17.skillInputData.character;
        v23:update({
            worldCFrame = v24,
            hitboxSize = Vector3.new(25, 25, 25) * (character and character:GetScale() or 1)
        });
    end);
end;

function u1.Client_EnterStartup(u25) -- Line: 220
    -- upvalues: AIM_RUN_EVENT_KEY (copy), resolveHrpBurstLandCF (copy), SkillTelegraph (copy), u1 (copy), RunService (copy)
    local character = u25.skillInputData.character;

    if not character then
        return;
    end;

    local skillRunData = u25.skillRunData;
    skillRunData.Logic = skillRunData.Logic or {};
    local v26 = skillRunData and skillRunData.runEvent and skillRunData.runEvent[AIM_RUN_EVENT_KEY];

    if v26 then
        v26:Disconnect();
        skillRunData.runEvent[AIM_RUN_EVENT_KEY] = nil;
    end;

    local v27 = skillRunData and skillRunData.Logic and skillRunData.Logic.dangerTelegraph;

    if v27 then
        v27:destroy();
        skillRunData.Logic.dangerTelegraph = nil;
    end;

    local v28 = resolveHrpBurstLandCF(u25);

    if v28 then
        local character2 = u25.skillInputData.character;
        local v29 = character2 and character2:GetScale() or 1;
        skillRunData.Logic.dangerTelegraph = SkillTelegraph.new({
            shape = "Circle",
            worldCFrame = v28,
            hitboxSize = Vector3.new(25, 25, 25) * v29,
            warnDuration = u1.States.Startup.Duration,
            casterCharacter = character,
            characterType = u25.characterType
        });
        local runGeneration = u25.runGeneration;
        local v30 = skillRunData and skillRunData.runEvent and skillRunData.runEvent[AIM_RUN_EVENT_KEY];

        if v30 then
            v30:Disconnect();
            skillRunData.runEvent[AIM_RUN_EVENT_KEY] = nil;
        end;

        skillRunData.runEvent[AIM_RUN_EVENT_KEY] = RunService.Heartbeat:Connect(function() -- Line: 198
            -- upvalues: u25 (copy), runGeneration (copy), skillRunData (copy), AIM_RUN_EVENT_KEY (ref), resolveHrpBurstLandCF (ref)
            if not u25:isRunningFlow() or u25.runGeneration ~= runGeneration then
                local v31 = skillRunData;

                if v31 then
                    if not v31.runEvent then
                        return;
                    end;

                    local v32 = v31.runEvent[AIM_RUN_EVENT_KEY];

                    if v32 then
                        v32:Disconnect();
                        v31.runEvent[AIM_RUN_EVENT_KEY] = nil;
                    end;
                end;

                return;
            end;

            local v33 = skillRunData.Logic and skillRunData.Logic.dangerTelegraph;

            if not v33 then
                return;
            end;

            local v34 = resolveHrpBurstLandCF(u25);

            if not v34 then
                return;
            end;

            local character3 = u25.skillInputData.character;
            v33:update({
                worldCFrame = v34,
                hitboxSize = Vector3.new(25, 25, 25) * (character3 and character3:GetScale() or 1)
            });
        end);
    end;
end;

function u1.Client_ExitStartup(p35) -- Line: 245
    -- upvalues: AIM_RUN_EVENT_KEY (copy)
    local skillRunData = p35.skillRunData;

    if skillRunData then
        if not skillRunData.runEvent then
            return;
        end;

        local v36 = skillRunData.runEvent[AIM_RUN_EVENT_KEY];

        if v36 then
            v36:Disconnect();
            skillRunData.runEvent[AIM_RUN_EVENT_KEY] = nil;
        end;
    end;
end;

function u1.Server_EnterStartup(p37) -- Line: 249
    -- upvalues: applyBurstHitboxTransform (copy)
    local v38 = applyBurstHitboxTransform(p37);

    if v38 then
        if not v38.hitbox then
            return;
        end;

        v38.hitbox.Transparency = 0.3;
    end;
end;

function u1.Client_EnterSwing(p39) -- Line: 255
    -- upvalues: AIM_RUN_EVENT_KEY (copy), resolveHrpBurstLandCF (copy), u1 (copy), FXUtil (copy), SoundModule (copy)
    local character = p39.skillInputData.character;

    if not character then
        return;
    end;

    local skillRunData = p39.skillRunData;
    local v40 = skillRunData and skillRunData.runEvent and skillRunData.runEvent[AIM_RUN_EVENT_KEY];

    if v40 then
        v40:Disconnect();
        skillRunData.runEvent[AIM_RUN_EVENT_KEY] = nil;
    end;

    local skillRunData2 = p39.skillRunData;
    local character2 = p39.skillInputData.character;
    local v41 = character2 and character2:GetScale() or 1;
    local v42 = resolveHrpBurstLandCF(p39);

    if not v42 then
        return;
    end;

    local v43 = skillRunData2.Logic and skillRunData2.Logic.dangerTelegraph;

    if v43 then
        v43:update({
            lockPosition = true,
            worldCFrame = v42,
            hitboxSize = Vector3.new(25, 25, 25) * v41
        });
        v43:activate(u1.States.Swing.Duration);
    end;

    local v44 = skillRunData2.material["火焰强袭爆炸"];
    v44.Parent = workspace.Debris;
    v44:PivotTo(v42);
    FXUtil.Emit_Particles_GetDescendants(v44, true);
    SoundModule:PlaySoundLocal({
        SoundName = "音效-技能-火焰强袭爆炸",
        Is2D = false,
        PlayPosition = character:GetPivot().Position
    });
end;

function u1.Client_ExitSwing(p45) -- Line: 293
    -- upvalues: AIM_RUN_EVENT_KEY (copy)
    local skillRunData = p45.skillRunData;
    local v46 = skillRunData and skillRunData.runEvent and skillRunData.runEvent[AIM_RUN_EVENT_KEY];

    if v46 then
        v46:Disconnect();
        skillRunData.runEvent[AIM_RUN_EVENT_KEY] = nil;
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

function u1.Server_EnterSwing(p47) -- Line: 297
    -- upvalues: applyBurstHitboxTransform (copy)
    local v48 = applyBurstHitboxTransform(p47);

    if not v48 then
        return;
    end;

    v48:start();

    if v48 then
        if not v48.hitbox then
            return;
        end;

        v48.hitbox.Transparency = 0.3;
    end;
end;

function u1.Server_ExitSwing(p49) -- Line: 306
    local v50 = p49.hitbox[1];

    if v50 and v50.isActive then
        v50:stop();
    end;

    if v50 and v50.hitbox then
        v50.hitbox.Transparency = 1;
    end;

    if p49.skillRunData.runEvent["命中盒控制"] then
        p49.skillRunData.runEvent["命中盒控制"]:Disconnect();
        p49.skillRunData.runEvent["命中盒控制"] = nil;
    end;
end;

function u1.Server_EnterRecovery(p51) -- Line: 319
    p51:releaseControl();
end;

function u1.Client_EnterRecovery(p52) -- Line: 323
end;

function u1.Client_EnterInterrupted(p53) -- Line: 326
    -- upvalues: AIM_RUN_EVENT_KEY (copy)
    local skillRunData = p53.skillRunData;
    local v54 = skillRunData and skillRunData.runEvent and skillRunData.runEvent[AIM_RUN_EVENT_KEY];

    if v54 then
        v54:Disconnect();
        skillRunData.runEvent[AIM_RUN_EVENT_KEY] = nil;
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
u1.AnimateList = { "火焰强袭" };
u1.ResNameList = { "火焰强袭爆炸" };
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
        animationName = "火焰强袭",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action
    }
};

return u1;