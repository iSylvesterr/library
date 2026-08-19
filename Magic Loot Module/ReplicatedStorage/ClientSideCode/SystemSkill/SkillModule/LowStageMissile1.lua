-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local SoundModule = UtilsSystem.SoundModule;
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
require(script.Parent.Parent.BaseSkill.GetSkillData);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local ProjectileImpact = require(script.Parent._Templates.Projectile.ProjectileImpact);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local FXUtil = UtilsSystem.FXUtil;
local BezierCurve = UtilsSystem.BezierCurve;
local RunService = UtilsSystem.RunService;
local _ = UtilsSystem.Players;
local u1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.None,
    InitialState = "Startup",
    ControlOpenState = "ProjectileFlying",
    States = {
        Startup = {
            Duration = 0.47,
            OnEnterClient = "Client_EnterStartup",
            OnEnterServer = "Server_EnterStartup",
            OnExitClient = nil,
            OnExitServer = nil
        },
        ProjectileFlying = {
            Duration = -1,
            OnEnterClient = "Client_EnterProjectileFlying",
            OnEnterServer = "Server_EnterProjectileFlying",
            OnExitClient = "Client_ExitProjectileFlying",
            OnExitServer = "Server_ExitProjectileFlying"
        },
        Exploding = {
            Duration = 1,
            OnEnterClient = "Client_EnterExploding",
            OnEnterServer = "Server_EnterExploding",
            OnExitClient = nil,
            OnExitServer = nil
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
            To = "ProjectileFlying",
            Event = SkillEventConst.StateTimeout
        },
        {
            From = "ProjectileFlying",
            To = "Exploding",
            Event = SkillEventConst.EnemyHit
        },
        {
            From = "ProjectileFlying",
            To = "Exploding",
            Event = SkillEventConst.ObstacleHit
        },
        {
            From = "ProjectileFlying",
            To = "Exploding",
            Event = SkillEventConst.Timeout
        },
        {
            From = "Exploding",
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
            From = "ProjectileFlying",
            To = "Interrupted",
            Event = SkillEventConst.Interrupt
        },
        {
            From = "Startup",
            To = "Finished",
            Event = SkillEventConst.ForceFinish
        },
        {
            From = "ProjectileFlying",
            To = "Finished",
            Event = SkillEventConst.ForceFinish
        },
        {
            From = "Exploding",
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

local function get_skillScale(p2) -- Line: 92
    -- upvalues: SkillCommon (copy)
    return SkillCommon.scaleDualFromData(p2, SkillCommon.bandScaleOptsFromSkillData(p2));
end;

local function getProjectileStartCF(p3) -- Line: 96
    -- upvalues: SkillCommon (copy)
    return SkillCommon.getHRPStartCF(p3, CFrame.new(0, 0, -3));
end;

local function getProjectileEndCF(p4) -- Line: 100
    -- upvalues: SkillCommon (copy)
    return SkillCommon.clampProjectileEndFromSkillData(p4, SkillCommon.getHRPStartCF(p4, CFrame.new(0, 0, -3)), 150, 0.7);
end;

function u1.Client_EnterStartup(u5) -- Line: 105
    -- upvalues: SkillCommon (copy), RunService (copy)
    local character = u5.skillInputData.character;

    if not character then
        return;
    end;

    local u6 = SkillCommon.resolveWandTipFromCharacter(character);

    if not u6 then
        return;
    end;

    if not character:FindFirstChild("HumanoidRootPart") then
        return;
    end;

    task.delay(0.27, function() -- Line: 114
        -- upvalues: u5 (copy), RunService (ref), u6 (copy)
        if not u5:isRunningFlow() then
            return;
        end;

        local u7 = u5.skillRunData.material["火系尾迹"];

        for _, descendant in pairs(u7:GetDescendants()) do
            if descendant:IsA("Trail") or descendant:IsA("ParticleEmitter") then
                descendant.Enabled = true;
            end;
        end;

        u7.Parent = workspace.Debris;
        u5.skillRunData.runEvent["火箭术Cast尾迹"] = RunService.RenderStepped:Connect(function() -- Line: 123
            -- upvalues: u6 (ref), u7 (copy)
            if u6.Parent then
                u7:PivotTo(u6:GetPivot());
            end;
        end);
    end);
end;

function u1.Server_EnterStartup(p8) -- Line: 131
    local v9 = p8.hitbox[1];
    local v10 = p8.hitbox[2];

    if v9 and v9.hitbox then
        v9.hitbox.Size = Vector3.new(5, 5, 5);
    end;

    if v10 and v10.hitbox then
        v10.hitbox.Size = Vector3.new(3, 3, 3);
    end;
end;

function u1.Client_EnterProjectileFlying(p11) -- Line: 146
    -- upvalues: SoundModule (copy), SkillCommon (copy), FXUtil (copy), BezierCurve (copy), u1 (copy)
    local character = p11.skillInputData.character;

    if not character then
        return;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    if SoundModule then
        SoundModule:PlaySoundLocal({
            SoundName = "技能_低阶魔法弹释放",
            Is2D = false,
            PlayPosition = HumanoidRootPart.Position
        });
    end;

    local v12 = p11.skillRunData.material["火系尾迹"];

    if p11.skillRunData.runEvent["火箭术Cast尾迹"] then
        p11.skillRunData.runEvent["火箭术Cast尾迹"]:Disconnect();
        p11.skillRunData.runEvent["火箭术Cast尾迹"] = nil;
    end;

    if v12 then
        for _, descendant in pairs(v12:GetDescendants()) do
            if descendant:IsA("Trail") or descendant:IsA("ParticleEmitter") then
                descendant.Enabled = false;
            end;
        end;
    end;

    local targetCF = p11.skillInputData.targetCF;
    local v13 = HumanoidRootPart:GetPivot():ToWorldSpace(CFrame.new(0, 0, -2));
    local v14 = CFrame.lookAt(v13.Position, targetCF.Position);
    local _, v15 = SkillCommon.scaleDualFromData(p11, SkillCommon.bandScaleOptsFromSkillData(p11));
    local v16 = p11.skillRunData.material["初级魔法弹法阵"];
    v16:ScaleTo(v15);
    v16:PivotTo(v14 * CFrame.Angles(1.5707963267948966, 0, 0));
    v16.Parent = workspace.Debris;
    FXUtil.Emit_Particles_GetDescendants(v16, true);
    local skillRunData = p11.skillRunData;
    local v17 = HumanoidRootPart:GetPivot():ToWorldSpace(CFrame.new(0, 0, -3));
    local v18 = SkillCommon.clampProjectileEndFromSkillData(p11, SkillCommon.getHRPStartCF(p11, CFrame.new(0, 0, -3)), 150, 0.7);
    local v19 = skillRunData.material["初级魔法弹主体"];
    local v20 = skillRunData.material["初级魔法弹爆破"];
    local v21, v22 = SkillCommon.scaleDualFromData(p11, SkillCommon.bandScaleOptsFromSkillData(p11));

    for _, descendant in pairs(v19:GetDescendants()) do
        if descendant:IsA("Beam") then
            descendant.Enabled = true;
            FXUtil.Beam_Fade_From_Transparent(descendant, 0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.In);
        end;

        if descendant:IsA("Trail") then
            descendant.Enabled = true;
        end;
    end;

    FXUtil.Model_Scale_Tween(v19, v21, v22, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In, nil, true);
    v19:PivotTo(CFrame.lookAt(v17.Position, v18.Position));
    v19.Parent = workspace.Debris;
    FXUtil.Start_All_Emit(v19, 10);
    v20.Parent = workspace.Debris;
    v20:ScaleTo(v22);
    local v23 = math.min((v17.Position - v18.Position).Magnitude / 150, 0.7) * 60;
    local v24 = BezierCurve.GenerateBezierPoints(v17.Position, v18.Position, 3, {
        RandomSeed = 100001,
        HeightOffsetRandom = 0,
        SideOffsetRandom = 5,
        EasingStyle = Enum.EasingStyle.Quad,
        EasingDirection = Enum.EasingDirection.Out
    });
    skillRunData.Visual.projectileModel = v19;
    skillRunData.Logic.hasExploded = false;
    local v25 = BezierCurve.MultiOrderBezierCurves({
        FPS = 60,
        Frame = v23,
        Points = v24,
        Target = v19,
        EasingStyle = Enum.EasingStyle.Sine,
        EasingDirection = Enum.EasingDirection.In
    }, function() -- Line: 232
    end);
    skillRunData.Visual.projectileMotion = v25;
    skillRunData.Logic.impactPosition = v18.Position;
    table.insert(skillRunData.runEvent, v25);
    local pendingProjectileHitEvent = skillRunData.Visual.pendingProjectileHitEvent;

    if pendingProjectileHitEvent then
        skillRunData.Visual.pendingProjectileHitEvent = nil;
        v25:Disconnect();
        skillRunData.Visual.projectileMotion = nil;
        u1.onServerEvent(p11, pendingProjectileHitEvent);
    end;
end;

function u1.Client_ExitProjectileFlying(p26) -- Line: 248
    local projectileMotion = p26.skillRunData.Visual.projectileMotion;

    if projectileMotion then
        projectileMotion:Disconnect();
        p26.skillRunData.Visual.projectileMotion = nil;
    end;
end;

function u1.Server_EnterProjectileFlying(u27) -- Line: 256
    -- upvalues: SkillCommon (copy), BezierCurve (copy), SkillEventConst (copy), ProjectileImpact (copy)
    local v28 = u27.hitbox[1];

    if not (v28 and u27.hitbox[2]) then
        return;
    end;

    local v29 = SkillCommon.getHRPStartCF(u27, CFrame.new(0, 0, -3));
    local u30 = SkillCommon.clampProjectileEndFromSkillData(u27, SkillCommon.getHRPStartCF(u27, CFrame.new(0, 0, -3)), 150, 0.7);
    local hitbox = v28.hitbox;
    u27.skillRunData.Logic.hasExploded = false;
    u27.skillRunData.Logic.projectileLastPosition = v29.Position;
    hitbox:PivotTo(v29);
    v28:start();
    local v31 = math.min((v29.Position - u30.Position).Magnitude / 150, 0.7) * 60;
    local v32 = BezierCurve.GenerateBezierPoints(v29.Position, u30.Position, 3, {
        RandomSeed = 100001,
        HeightOffsetRandom = 0,
        SideOffsetRandom = 5,
        EasingStyle = Enum.EasingStyle.Quad,
        EasingDirection = Enum.EasingDirection.Out
    });
    local v33 = BezierCurve.MultiOrderBezierCurves({
        FPS = 60,
        Frame = v31,
        Points = v32,
        Target = hitbox,
        EasingStyle = Enum.EasingStyle.Sine,
        EasingDirection = Enum.EasingDirection.In
    }, function() -- Line: 291
        -- upvalues: SkillEventConst (ref), u30 (copy), ProjectileImpact (ref), u27 (copy)
        ProjectileImpact.resolveImpact(u27, {
            type = SkillEventConst.HitType.Timeout,
            position = u30.Position,
            source = ProjectileImpact.ImpactSource.Lifetime
        });
    end);
    u27.skillRunData.Logic.projectileHitboxMotion = v33;
    table.insert(u27.skillRunData.runEvent, v33);
end;

function u1.Server_ExitProjectileFlying(p34) -- Line: 303
    local projectileHitboxMotion = p34.skillRunData.Logic.projectileHitboxMotion;

    if projectileHitboxMotion then
        projectileHitboxMotion:Disconnect();
        p34.skillRunData.Logic.projectileHitboxMotion = nil;
    end;

    local v35 = p34.hitbox[1];

    if v35 and v35.isActive then
        v35:stop();
    end;

    if v35 and v35.hitbox then
        v35.hitbox.Transparency = 1;
    end;
end;

function u1.Server_UpdateProjectileObstacleCheck(p36) -- Line: 318
    -- upvalues: SkillEventConst (copy), ProjectileImpact (copy)
    local skillRunData = p36.skillRunData;

    if skillRunData.State.current ~= "ProjectileFlying" or skillRunData.Logic.hasExploded then
        return;
    end;

    local v37 = p36.hitbox[1];

    if not v37 then
        return;
    end;

    local hitbox = v37.hitbox;
    local Position = hitbox.Position;
    local v38 = skillRunData.Logic.projectileLastPosition or Position;
    local v39 = Position - v38;

    if v39.Magnitude > 0.01 then
        local v40 = RaycastParams.new();
        v40.FilterType = Enum.RaycastFilterType.Exclude;
        local v41;

        if typeof(hitbox) == "Instance" then
            v41 = { p36.character, hitbox };
        else
            v41 = { p36.character };
        end;

        v40.FilterDescendantsInstances = v41;
        local v42 = workspace:Raycast(v38, v39, v40);

        if v42 then
            local Instance = v42.Instance;

            if Instance then
                Instance = Instance.Parent;
            end;

            local v43 = Instance and Instance:IsA("Model") and Instance:FindFirstChildOfClass("Humanoid");

            if not v43 then
                ProjectileImpact.resolveImpact(p36, {
                    type = SkillEventConst.HitType.Obstacle,
                    position = v42.Position,
                    normal = v42.Normal,
                    source = ProjectileImpact.ImpactSource.Raycast
                });

                return;
            end;
        end;
    end;

    skillRunData.Logic.projectileLastPosition = Position;
end;

function u1.Client_EnterExploding(p44, p45) -- Line: 356
    -- upvalues: SoundModule (copy), FXUtil (copy)
    local v46 = p45 and p45.hitPosition or p44.skillRunData.Logic and p44.skillRunData.Logic.impactPosition;

    if not v46 then
        return;
    end;

    if SoundModule then
        SoundModule:PlaySoundLocal({
            SoundName = "技能_低阶魔法弹爆炸",
            Is2D = false,
            PlayPosition = v46
        });
    end;

    local projectileModel = p44.skillRunData.Visual.projectileModel;
    local v47 = p44.skillRunData.material["初级魔法弹爆破"];

    if projectileModel and projectileModel.Parent then
        projectileModel:PivotTo(CFrame.new(v46));
    end;

    if v47 then
        v47:PivotTo(CFrame.new(v46));
        FXUtil.Emit_Particles_GetDescendants(v47, true);
    end;

    if projectileModel then
        for _, descendant in pairs(projectileModel:GetDescendants()) do
            if descendant:IsA("Beam") then
                FXUtil.Beam_Fade_To_Transparent_Then_Disable(descendant, 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
            end;

            if descendant:IsA("ParticleEmitter") and descendant.Name == "弹道1_星" then
                descendant:Clear();
            end;
        end;

        FXUtil.Stop_All_Emit(projectileModel);
    end;
end;

function u1.Server_EnterExploding(p48, p49) -- Line: 390
    -- upvalues: SkillCommon (copy), FXUtil (copy), SkillEventConst (copy)
    local _, v50 = SkillCommon.scaleDualFromData(p48, SkillCommon.bandScaleOptsFromSkillData(p48));
    local v51 = p49 and p49.hitPosition or p48.skillRunData.Logic and p48.skillRunData.Logic.impactPosition;

    if not v51 then
        return;
    end;

    local u52 = p48.hitbox[2];

    if u52 then
        local hitbox = u52.hitbox;
        hitbox:PivotTo(CFrame.new(v51));
        u52:start();
        FXUtil.BasePart_Size_Tween(hitbox, 0.1, Vector3.new(10, 10, 10) * v50, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, function() -- Line: 402
            -- upvalues: u52 (copy), hitbox (copy)
            if u52.isActive then
                u52:stop();
                hitbox.Transparency = 1;
            end;
        end);
    end;

    p48:fireProjectileHitConfirmed(v51, p48.skillRunData.Logic.impactType or SkillEventConst.HitType.Timeout, p48.skillRunData.Logic.impactTargetId);
end;

function u1.Server_EnterRecovery(p53) -- Line: 418
    p53:releaseControl();
end;

function u1.Client_EnterRecovery(p54) -- Line: 422
    local v55 = p54.skillRunData.material["火系尾迹"];

    if v55 then
        for _, descendant in pairs(v55:GetDescendants()) do
            if descendant:IsA("Trail") or descendant:IsA("ParticleEmitter") then
                descendant.Enabled = false;
            end;
        end;
    end;

    if p54.skillRunData.runEvent["火箭术Cast尾迹"] then
        p54.skillRunData.runEvent["火箭术Cast尾迹"]:Disconnect();
        p54.skillRunData.runEvent["火箭术Cast尾迹"] = nil;
    end;
end;

function u1.onServerEvent(p56, p57) -- Line: 438
    -- upvalues: SkillEventConst (copy)
    if p57.eventType ~= SkillEventConst.SyncEventType.ProjectileHitConfirmed then
        return;
    end;

    local skillRunData = p56.skillRunData;

    if not skillRunData then
        return;
    end;

    local hitPosition = p57.hitPosition;

    if not hitPosition then
        return;
    end;

    local v58 = p57.hitType == SkillEventConst.HitType.Obstacle and SkillEventConst.ObstacleHit or (p57.hitType == SkillEventConst.HitType.Timeout and SkillEventConst.Timeout or SkillEventConst.EnemyHit);

    if p56.GetCurrentState and p56:GetCurrentState() == "ProjectileFlying" then
        p56:TryTransition(v58, {
            hitPosition = hitPosition,
            hitType = p57.hitType,
            targetId = p57.targetId
        });

        return;
    end;

    skillRunData.Visual.pendingProjectileHitEvent = p57;
end;

function u1.onProjectileHitServer(p59, p60, p61) -- Line: 460
    -- upvalues: SkillEventConst (copy), ProjectileImpact (copy)
    if not p60 then
        return;
    end;

    if not (p59.hitbox[1] and p59.hitbox[2]) then
        return;
    end;

    local skillRunData = p59.skillRunData;

    if not (skillRunData and skillRunData.State) then
        return;
    end;

    if p60.hitboxIndex == 2 then
        local HitResolver = require(script.Parent.Parent.BaseSkill.HitResolver);

        for i, v in p61 do
            HitResolver.applyHit(p59, p60, v, i);
        end;

        return;
    end;

    if p60.hitboxIndex ~= 1 then
        return;
    end;

    local v62, v63 = next(p61);

    if not (v62 and v63) then
        return;
    end;

    ProjectileImpact.resolveImpact(p59, {
        type = SkillEventConst.HitType.Enemy,
        position = v63.Position,
        target = v62,
        hitResult = p61,
        source = ProjectileImpact.ImpactSource.Hitbox
    });
end;

u1.SoundList = { "技能_低阶魔法弹释放", "技能_低阶魔法弹爆炸" };
u1.AnimateList = { "技能释放动作3" };
u1.ResNameList = { "火系尾迹", "初级魔法弹法阵", "初级魔法弹爆破", "初级魔法弹主体" };
u1.hitboxConfig = { {
        HitboxIndex = 1,
        PartName = "通用球",
        CollisionGroup = "Player",
        HitPresentationProfile = "通用受击",
        PhysicsEffectName = "通用受击物理效果"
    }, {
        HitboxIndex = 2,
        PartName = "通用球",
        CollisionGroup = "Player",
        HitPresentationProfile = "通用受击",
        PhysicsEffectName = "通用受击物理效果"
    } };
u1.Action = {
    {
        action = "LookAt",
        startTime = 0,
        overTime = 0.47,
        speedType = "RELEASE_SKILL_STATE_HALF"
    },
    {
        action = "Animation",
        startTime = 0,
        overTime = 1.27,
        animationName = "技能释放动作3",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action4
    }
};

return u1;