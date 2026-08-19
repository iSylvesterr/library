-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local SoundModule = UtilsSystem.SoundModule;
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local FXUtil = UtilsSystem.FXUtil;
local BurstStone = UtilsSystem.BurstStone;
local RunService = UtilsSystem.RunService;
local SkillTelegraph = UtilsSystem.SkillTelegraph;
local u1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.Earth,
    InitialState = "Startup",
    ControlOpenState = "Recovery",
    States = {
        Startup = {
            Duration = 0.74,
            OnEnterClient = "Client_EnterStartup",
            OnEnterServer = "Server_EnterStartup",
            OnExitClient = "Client_ExitStartup",
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
            IsTerminal = true,
            OnEnterClient = "Client_EnterInterrupted"
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

local function get_skillScale(p2) -- Line: 81
    local character = p2.skillInputData.character;

    return character and character:GetScale() or 1;
end;

local function stopTelegraphAimLoop(p3) -- Line: 91
    if not (p3 and p3.runEvent) then
        return;
    end;

    local damageTelegraphAim = p3.runEvent.damageTelegraphAim;

    if damageTelegraphAim then
        damageTelegraphAim:Disconnect();
        p3.runEvent.damageTelegraphAim = nil;
    end;
end;

local function destroyDangerTelegraph(p4) -- Line: 107
    local v5 = p4 and p4.runEvent and p4.runEvent.damageTelegraphAim;

    if v5 then
        v5:Disconnect();
        p4.runEvent.damageTelegraphAim = nil;
    end;

    if not (p4 and p4.Logic) then
        return;
    end;

    local dangerTelegraph = p4.Logic.dangerTelegraph;

    if dangerTelegraph then
        dangerTelegraph:destroy();
        p4.Logic.dangerTelegraph = nil;
    end;
end;

local function resolveHrpOffsetLandCF(p6) -- Line: 125
    -- upvalues: UtilsSystem (copy)
    local v7 = p6.skillInputData and p6.skillInputData.character;

    if not v7 then
        return nil;
    end;

    local HumanoidRootPart = v7:FindFirstChild("HumanoidRootPart");

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        return nil;
    end;

    local character = p6.skillInputData.character;
    local v8 = character and character:GetScale() or 1;
    local v9 = HumanoidRootPart:GetPivot():ToWorldSpace(CFrame.new(Vector3.new(-1.8, 0, -3.5) * v8));
    local v10 = UtilsSystem.RayCast.RayCastDirection(v9.Position, Vector3.new(0, -1, 0), 30, "Ground");

    if v10 then
        v9 = v9.Rotation + v10.Position + Vector3.new(0, 0.3, 0);
    end;

    return v9;
end;

local function startTelegraphAimLoop(u11, u12, u13) -- Line: 150
    -- upvalues: RunService (copy), SkillCommon (copy), resolveHrpOffsetLandCF (copy)
    local v14 = u12 and u12.runEvent and u12.runEvent.damageTelegraphAim;

    if v14 then
        v14:Disconnect();
        u12.runEvent.damageTelegraphAim = nil;
    end;

    u12.runEvent.damageTelegraphAim = RunService.Heartbeat:Connect(function() -- Line: 152
        -- upvalues: SkillCommon (ref), u11 (copy), u13 (copy), u12 (copy), resolveHrpOffsetLandCF (ref)
        if not SkillCommon.isRunningSameGeneration(u11, u13) then
            local v15 = u12;

            if v15 then
                if not v15.runEvent then
                    return;
                end;

                local damageTelegraphAim = v15.runEvent.damageTelegraphAim;

                if damageTelegraphAim then
                    damageTelegraphAim:Disconnect();
                    v15.runEvent.damageTelegraphAim = nil;
                end;
            end;

            return;
        end;

        local v16 = u12.Logic and u12.Logic.dangerTelegraph;

        if not v16 then
            return;
        end;

        local v17 = resolveHrpOffsetLandCF(u11);

        if not v17 then
            return;
        end;

        u12.Logic.lastTelegraphLandCF = v17;
        v16:update({
            hitboxSize = Vector3.new(20, 20, 20),
            worldCFrame = v17
        });
    end);
end;

function u1.Client_EnterStartup(u18) -- Line: 173
    -- upvalues: FXUtil (copy), RunService (copy), resolveHrpOffsetLandCF (copy), SkillTelegraph (copy), u1 (copy), SkillCommon (copy)
    local character = u18.skillInputData.character;

    if not character then
        return;
    end;

    local u19 = character:FindFirstChild("Left Arm");

    if not u19 then
        return;
    end;

    local skillRunData = u18.skillRunData;
    local u20 = skillRunData.material["大地震击手上能量-小"];
    u20.Parent = workspace.Debris;
    u20:PivotTo(u19:GetPivot());
    FXUtil.Start_All_Emit(u20, 0.5);
    skillRunData.runEvent["手上能量跟随"] = RunService.RenderStepped:Connect(function() -- Line: 189
        -- upvalues: u20 (copy), u19 (copy)
        if u20.Parent and u19 then
            u20:PivotTo(u19:GetPivot():ToWorldSpace(CFrame.new(0, u19.Size.Y / 2, 0)));
        end;
    end);
    skillRunData.Logic = skillRunData.Logic or {};
    local v21 = skillRunData and skillRunData.runEvent and skillRunData.runEvent.damageTelegraphAim;

    if v21 then
        v21:Disconnect();
        skillRunData.runEvent.damageTelegraphAim = nil;
    end;

    local v22 = skillRunData and skillRunData.Logic and skillRunData.Logic.dangerTelegraph;

    if v22 then
        v22:destroy();
        skillRunData.Logic.dangerTelegraph = nil;
    end;

    local v23 = resolveHrpOffsetLandCF(u18);

    if v23 then
        local Logic = skillRunData.Logic;
        local new = SkillTelegraph.new;
        local v24 = {
            shape = "Circle",
            hitboxSize = Vector3.new(20, 20, 20),
            worldCFrame = v23,
            warnDuration = u1.States.Startup.Duration
        };
        v24.casterCharacter = u18.skillInputData and u18.skillInputData.character;
        v24.characterType = u18.characterType;
        Logic.dangerTelegraph = new(v24);
        skillRunData.Logic.lastTelegraphLandCF = v23;
        local runGeneration = u18.runGeneration;
        local v25 = skillRunData and skillRunData.runEvent and skillRunData.runEvent.damageTelegraphAim;

        if v25 then
            v25:Disconnect();
            skillRunData.runEvent.damageTelegraphAim = nil;
        end;

        skillRunData.runEvent.damageTelegraphAim = RunService.Heartbeat:Connect(function() -- Line: 152
            -- upvalues: SkillCommon (ref), u18 (copy), runGeneration (copy), skillRunData (copy), resolveHrpOffsetLandCF (ref)
            if not SkillCommon.isRunningSameGeneration(u18, runGeneration) then
                local v26 = skillRunData;

                if v26 then
                    if not v26.runEvent then
                        return;
                    end;

                    local damageTelegraphAim = v26.runEvent.damageTelegraphAim;

                    if damageTelegraphAim then
                        damageTelegraphAim:Disconnect();
                        v26.runEvent.damageTelegraphAim = nil;
                    end;
                end;

                return;
            end;

            local v27 = skillRunData.Logic and skillRunData.Logic.dangerTelegraph;

            if not v27 then
                return;
            end;

            local v28 = resolveHrpOffsetLandCF(u18);

            if not v28 then
                return;
            end;

            skillRunData.Logic.lastTelegraphLandCF = v28;
            v27:update({
                hitboxSize = Vector3.new(20, 20, 20),
                worldCFrame = v28
            });
        end);
    end;
end;

function u1.Client_ExitStartup(p29) -- Line: 213
    local skillRunData = p29.skillRunData;

    if skillRunData then
        if not skillRunData.runEvent then
            return;
        end;

        local damageTelegraphAim = skillRunData.runEvent.damageTelegraphAim;

        if damageTelegraphAim then
            damageTelegraphAim:Disconnect();
            skillRunData.runEvent.damageTelegraphAim = nil;
        end;
    end;
end;

function u1.Server_EnterStartup(p30) -- Line: 217
    local v31 = p30.hitbox[1];

    if v31 and v31.hitbox then
        local character = p30.skillInputData.character;
        local v32 = character and character:GetScale() or 1;
        v31.hitbox.Size = Vector3.new(9, 9, 9 * v32);
    end;
end;

function u1.Client_EnterHitLand(p33) -- Line: 225
    -- upvalues: resolveHrpOffsetLandCF (copy), FXUtil (copy), BurstStone (copy), SoundModule (copy)
    if not p33.skillInputData.character then
        return;
    end;

    local skillRunData = p33.skillRunData;
    local v34 = skillRunData and skillRunData.runEvent and skillRunData.runEvent.damageTelegraphAim;

    if v34 then
        v34:Disconnect();
        skillRunData.runEvent.damageTelegraphAim = nil;
    end;

    local u35 = resolveHrpOffsetLandCF(p33);

    if not u35 then
        return;
    end;

    local skillRunData2 = p33.skillRunData;
    local v36 = skillRunData2.Logic and skillRunData2.Logic.dangerTelegraph;

    if v36 then
        v36:update({
            hitboxSize = Vector3.new(20, 20, 20),
            lockPosition = true,
            worldCFrame = u35
        });
        v36:activate(0.15);
    end;

    local u37 = skillRunData2.material["大地震击冲击波-小"];
    u37.Parent = workspace.Debris;
    u37:PivotTo(u35);
    task.delay(0, function() -- Line: 253
        -- upvalues: FXUtil (ref), u37 (copy), BurstStone (ref), u35 (copy), SoundModule (ref)
        FXUtil.Emit_Particles_GetDescendants(u37, true);
        BurstStone.CreateLandBreak(u35, "SmallHitLand1");
        BurstStone.CreateStoneFly(u35, "Meteor", 0.7);
        SoundModule:PlaySoundLocal({
            SoundName = "技能-砸地",
            Is2D = false,
            PlayPosition = u35.Position
        });
    end);
end;

function u1.Client_ExitHitLand(p38) -- Line: 265
    if p38.skillRunData.runEvent["手上能量跟随"] then
        p38.skillRunData.runEvent["手上能量跟随"]:Disconnect();
        p38.skillRunData.runEvent["手上能量跟随"] = nil;
    end;

    local skillRunData = p38.skillRunData;
    local v39 = skillRunData and skillRunData.runEvent and skillRunData.runEvent.damageTelegraphAim;

    if v39 then
        v39:Disconnect();
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

function u1.Server_EnterHitLand(u40) -- Line: 273
    -- upvalues: UtilsSystem (copy)
    local character = u40.skillInputData.character;

    if not character then
        return;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local character2 = u40.skillInputData.character;
    local v41 = character2 and character2:GetScale() or 1;
    local u42 = HumanoidRootPart:GetPivot():ToWorldSpace(CFrame.new(-1.8 * v41, 0, -3.5 * v41));
    local v43 = UtilsSystem.RayCast.RayCastDirection(u42.Position, Vector3.new(0, -1, 0), 30, "Ground");

    if v43 then
        u42 = u42.Rotation + v43.Position + Vector3.new(0, 0.3, 0);
    end;

    task.delay(0, function() -- Line: 291
        -- upvalues: u40 (copy), u42 (ref)
        local u44 = u40.hitbox[1];

        if not u44 then
            return;
        end;

        u44.hitbox:PivotTo(u42);
        u44.hitbox.Size = Vector3.new(20, 20, 20);
        u44:start();
        task.delay(0.15, function() -- Line: 299
            -- upvalues: u44 (copy)
            if u44.isActive then
                u44:stop();
            end;
        end);
    end);
end;

function u1.Server_ExitHitLand(p45) -- Line: 307
    local v46 = p45.hitbox[1];

    if v46 and v46.isActive then
        v46:stop();
    end;
end;

function u1.Server_EnterRecovery(p47) -- Line: 314
    p47:releaseControl();
end;

function u1.Client_EnterRecovery(p48) -- Line: 318
end;

function u1.Client_EnterInterrupted(p49) -- Line: 321
    local skillRunData = p49.skillRunData;
    local v50 = skillRunData and skillRunData.runEvent and skillRunData.runEvent.damageTelegraphAim;

    if v50 then
        v50:Disconnect();
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

u1.SoundList = { "技能-砸地" };
u1.AnimateList = { "土元素小砸地" };
u1.ResNameList = { "大地震击冲击波-小", "大地震击手上能量-小" };
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
        animationName = "土元素小砸地",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action
    }
};

return u1;