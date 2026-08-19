-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local ProjectileImpact = require(script.Parent._Templates.Projectile.ProjectileImpact);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local PlayerAimSync = require(script.Parent.Parent.BaseSkill.PlayerAimSync);
local FXUtil = UtilsSystem.FXUtil;
local BezierCurve = UtilsSystem.BezierCurve;
local RunService = UtilsSystem.RunService;
local u1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.Earth
};
local u2 = CFrame.new(0, 0, -4);
local u3 = CFrame.new(0, 0, -5);
u1.InitialState = "Startup";
u1.ControlOpenState = "ProjectileFlying";
u1.States = {
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
        Duration = 0.3,
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
};
u1.Transitions = {
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
};

local function get_skillScale(p4) -- Line: 92
    -- upvalues: SkillCommon (copy)
    return SkillCommon.scaleDualFromData(p4, SkillCommon.bandScaleOptsFromSkillData(p4));
end;

local function getProjectileStartCF(p5) -- Line: 96
    -- upvalues: SkillCommon (copy), u3 (copy)
    return SkillCommon.getHRPStartCF(p5, u3);
end;

local function getProjectileEndCF(p6) -- Line: 100
    -- upvalues: SkillCommon (copy), u3 (copy)
    return SkillCommon.clampProjectileEndFromSkillData(p6, SkillCommon.getHRPStartCF(p6, u3), 150, 0.7);
end;

local function getSpikeAimCF(p7, p8) -- Line: 105
    local Position = p7.Position;
    local v9 = p8 - Position;

    if v9.Magnitude < 0.05 then
        return p7;
    end;

    return CFrame.lookAt(Position, Position + v9.Unit);
end;

function u1.Client_EnterStartup(u10) -- Line: 114
    -- upvalues: SkillCommon (copy), RunService (copy)
    local character = u10.skillInputData.character;

    if not character then
        return;
    end;

    local u11 = SkillCommon.resolveWandTipFromCharacter(character);

    if not u11 then
        return;
    end;

    if not character:FindFirstChild("HumanoidRootPart") then
        return;
    end;

    task.delay(0.27, function() -- Line: 122
        -- upvalues: u10 (copy), RunService (ref), u11 (copy)
        if not u10:isRunningFlow() then
            return;
        end;

        local u12 = u10.skillRunData.material["地系尾迹2"];

        for _, descendant in pairs(u12:GetDescendants()) do
            if descendant:IsA("Trail") or descendant:IsA("ParticleEmitter") then
                descendant.Enabled = true;
            end;
        end;

        u12.Parent = workspace.Debris;
        u10.skillRunData.runEvent["木刺Cast尾迹"] = RunService.RenderStepped:Connect(function() -- Line: 131
            -- upvalues: u11 (ref), u12 (copy)
            if u11.Parent then
                u12:PivotTo(u11:GetPivot());
            end;
        end);
    end);
end;

function u1.Server_EnterStartup(p13) -- Line: 139
    local v14 = p13.hitbox[1];
    local v15 = p13.hitbox[2];

    if v14 and v14.hitbox then
        v14.hitbox.Shape = Enum.PartType.Block;
        v14.hitbox.Size = Vector3.new(2, 1, 4);
    end;

    if v15 and v15.hitbox then
        v15.hitbox.Shape = Enum.PartType.Ball;
        v15.hitbox.Size = Vector3.new(4, 4, 4);
    end;
end;

function u1.Client_EnterProjectileFlying(p16) -- Line: 157
    -- upvalues: PlayerAimSync (copy), SkillCommon (copy), u2 (copy), FXUtil (copy), u3 (copy), getSpikeAimCF (copy), BezierCurve (copy), u1 (copy)
    PlayerAimSync.refreshAimSnapshot(p16);
    local character = p16.skillInputData.character;

    if not character then
        return;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local v17 = p16.skillRunData.material["地系尾迹2"];

    if p16.skillRunData.runEvent["木刺Cast尾迹"] then
        p16.skillRunData.runEvent["木刺Cast尾迹"]:Disconnect();
        p16.skillRunData.runEvent["木刺Cast尾迹"] = nil;
    end;

    if v17 then
        for _, descendant in pairs(v17:GetDescendants()) do
            if descendant:IsA("Trail") or descendant:IsA("ParticleEmitter") then
                descendant.Enabled = false;
            end;
        end;
    end;

    local _, v18 = SkillCommon.scaleDualFromData(p16, SkillCommon.bandScaleOptsFromSkillData(p16));
    local v19 = p16.skillRunData.material["木刺_法阵"];
    v19:ScaleTo(v18);
    v19:PivotTo(HumanoidRootPart:GetPivot() * u2);
    v19.Parent = workspace.Debris;
    FXUtil.Emit_Particles_GetDescendants(v19, true);
    SkillCommon.playSoundLocal3D("音效-技能-木刺-施法", v19:GetPivot().Position);
    local skillRunData = p16.skillRunData;
    local v20 = SkillCommon.getHRPStartCF(p16, u3);
    local v21 = SkillCommon.clampProjectileEndFromSkillData(p16, SkillCommon.getHRPStartCF(p16, u3), 150, 0.7);
    local v22 = skillRunData.material["木刺"];
    local v23 = skillRunData.material["木刺_爆炸"];
    local v24, v25 = SkillCommon.scaleDualFromData(p16, SkillCommon.bandScaleOptsFromSkillData(p16));
    FXUtil.Model_Scale_Tween(v22, v24, v25, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In, nil, true);
    v22:PivotTo(getSpikeAimCF(v20, v21.Position));
    v22.Parent = workspace.Debris;

    if v23 then
        v23.Parent = workspace.Debris;
        v23:ScaleTo(v25);
    end;

    local v26 = math.min((v20.Position - v21.Position).Magnitude / 150, 0.7) * 60;
    local v27 = BezierCurve.GenerateBezierPoints(v20.Position, v21.Position, 2, {
        RandomSeed = 10000,
        HeightOffsetRandom = 0,
        SideOffsetRandom = 0,
        EasingStyle = Enum.EasingStyle.Quad,
        EasingDirection = Enum.EasingDirection.Out
    });
    skillRunData.Visual.projectileModel = v22;
    skillRunData.Logic.hasExploded = false;
    local v28 = BezierCurve.MultiOrderBezierCurves({
        FPS = 60,
        Frame = v26,
        Points = v27,
        Target = v22,
        EasingStyle = Enum.EasingStyle.Sine,
        EasingDirection = Enum.EasingDirection.In
    }, function() -- Line: 227
    end);
    skillRunData.Visual.projectileMotion = v28;
    skillRunData.Logic.impactPosition = v21.Position;
    table.insert(skillRunData.runEvent, v28);
    local pendingProjectileHitEvent = skillRunData.Visual.pendingProjectileHitEvent;

    if pendingProjectileHitEvent then
        skillRunData.Visual.pendingProjectileHitEvent = nil;
        v28:Disconnect();
        skillRunData.Visual.projectileMotion = nil;
        u1.onServerEvent(p16, pendingProjectileHitEvent);
    end;
end;

function u1.Client_ExitProjectileFlying(p29) -- Line: 242
    local projectileMotion = p29.skillRunData.Visual.projectileMotion;

    if projectileMotion then
        projectileMotion:Disconnect();
        p29.skillRunData.Visual.projectileMotion = nil;
    end;
end;

function u1.Server_EnterProjectileFlying(u30) -- Line: 250
    -- upvalues: PlayerAimSync (copy), SkillCommon (copy), u3 (copy), BezierCurve (copy), SkillEventConst (copy), ProjectileImpact (copy)
    PlayerAimSync.refreshAimSnapshot(u30);
    local v31 = u30.hitbox[1];

    if not (v31 and u30.hitbox[2]) then
        return;
    end;

    local v32 = SkillCommon.getHRPStartCF(u30, u3);
    local u33 = SkillCommon.clampProjectileEndFromSkillData(u30, SkillCommon.getHRPStartCF(u30, u3), 150, 0.7);
    local hitbox = v31.hitbox;
    local Position = v32.Position;
    local v34 = u33.Position - Position;
    local v35;

    if v34.Magnitude < 0.05 then
        v35 = v32;
    else
        v35 = CFrame.lookAt(Position, Position + v34.Unit);
    end;

    u30.skillRunData.Logic.hasExploded = false;
    u30.skillRunData.Logic.projectileLastPosition = v35.Position;
    hitbox:PivotTo(v35);
    v31:start();
    local v36 = math.min((v32.Position - u33.Position).Magnitude / 150, 0.7) * 60;
    local v37 = BezierCurve.GenerateBezierPoints(v32.Position, u33.Position, 2, {
        RandomSeed = 10000,
        HeightOffsetRandom = 0,
        SideOffsetRandom = 0,
        EasingStyle = Enum.EasingStyle.Quad,
        EasingDirection = Enum.EasingDirection.Out
    });
    local v38 = BezierCurve.MultiOrderBezierCurves({
        FPS = 60,
        Frame = v36,
        Points = v37,
        Target = hitbox,
        EasingStyle = Enum.EasingStyle.Sine,
        EasingDirection = Enum.EasingDirection.In
    }, function() -- Line: 288
        -- upvalues: SkillEventConst (ref), u33 (copy), ProjectileImpact (ref), u30 (copy)
        ProjectileImpact.resolveImpact(u30, {
            type = SkillEventConst.HitType.Timeout,
            position = u33.Position,
            source = ProjectileImpact.ImpactSource.Lifetime
        });
    end);
    u30.skillRunData.Logic.projectileHitboxMotion = v38;
    table.insert(u30.skillRunData.runEvent, v38);
end;

function u1.Server_ExitProjectileFlying(p39) -- Line: 300
    local projectileHitboxMotion = p39.skillRunData.Logic.projectileHitboxMotion;

    if projectileHitboxMotion then
        projectileHitboxMotion:Disconnect();
        p39.skillRunData.Logic.projectileHitboxMotion = nil;
    end;

    local v40 = p39.hitbox[1];

    if v40 and v40.isActive then
        v40:stop();
    end;

    if v40 and v40.hitbox then
        v40.hitbox.Transparency = 1;
    end;
end;

function u1.Server_UpdateProjectileObstacleCheck(p41) -- Line: 311
    -- upvalues: SkillEventConst (copy), ProjectileImpact (copy)
    local skillRunData = p41.skillRunData;

    if skillRunData.State.current ~= "ProjectileFlying" or skillRunData.Logic.hasExploded then
        return;
    end;

    local v42 = p41.hitbox[1];

    if not v42 then
        return;
    end;

    local hitbox = v42.hitbox;
    local Position = hitbox.Position;
    local v43 = skillRunData.Logic.projectileLastPosition or Position;
    local v44 = Position - v43;

    if v44.Magnitude > 0.01 then
        local v45 = RaycastParams.new();
        v45.FilterType = Enum.RaycastFilterType.Exclude;
        local v46;

        if typeof(hitbox) == "Instance" then
            v46 = { p41.character, hitbox };
        else
            v46 = { p41.character };
        end;

        v45.FilterDescendantsInstances = v46;
        local v47 = workspace:Raycast(v43, v44, v45);

        if v47 then
            local Instance = v47.Instance;

            if Instance then
                Instance = Instance.Parent;
            end;

            local v48 = Instance and Instance:IsA("Model") and Instance:FindFirstChildOfClass("Humanoid");

            if not v48 then
                ProjectileImpact.resolveImpact(p41, {
                    type = SkillEventConst.HitType.Obstacle,
                    position = v47.Position,
                    normal = v47.Normal,
                    source = ProjectileImpact.ImpactSource.Raycast
                });

                return;
            end;
        end;
    end;

    skillRunData.Logic.projectileLastPosition = Position;
end;

function u1.Client_EnterExploding(p49, p50) -- Line: 348
    -- upvalues: FXUtil (copy), SkillCommon (copy)
    local v51 = p50 and p50.hitPosition or p49.skillRunData.Logic and p49.skillRunData.Logic.impactPosition;

    if not v51 then
        return;
    end;

    local projectileModel = p49.skillRunData.Visual.projectileModel;
    local v52 = p49.skillRunData.material["木刺_爆炸"];

    if projectileModel and projectileModel.Parent then
        projectileModel:PivotTo(CFrame.new(v51) * projectileModel:GetPivot().Rotation);
    end;

    if v52 then
        v52:PivotTo(CFrame.new(v51));
        FXUtil.Emit_Particles_GetDescendants(v52, true);
    end;

    SkillCommon.playSoundLocal3D("音效-技能-木刺-爆炸", v51);

    if projectileModel then
        FXUtil.FadeModel_KeepTrails(projectileModel, 0.12, 1);
        p49.skillRunData.Visual.projectileModel = nil;
    end;
end;

function u1.Server_EnterExploding(p53, p54) -- Line: 372
    -- upvalues: SkillCommon (copy), FXUtil (copy), SkillEventConst (copy)
    local _, v55 = SkillCommon.scaleDualFromData(p53, SkillCommon.bandScaleOptsFromSkillData(p53));
    local v56 = p54 and p54.hitPosition or p53.skillRunData.Logic and p53.skillRunData.Logic.impactPosition;

    if not v56 then
        return;
    end;

    local u57 = p53.hitbox[2];

    if u57 then
        local hitbox = u57.hitbox;
        hitbox.Shape = Enum.PartType.Ball;
        hitbox:PivotTo(CFrame.new(v56));
        local v58 = Vector3.new(4, 4, 4) * v55;
        hitbox.Size = v58 * 0.15;
        u57:start();
        FXUtil.BasePart_Size_Tween(hitbox, 0.1, v58, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, function() -- Line: 387
            -- upvalues: u57 (copy), hitbox (copy)
            if u57.isActive then
                u57:stop();
                hitbox.Transparency = 1;
            end;
        end);
    end;

    p53:fireProjectileHitConfirmed(v56, p53.skillRunData.Logic.impactType or SkillEventConst.HitType.Timeout, p53.skillRunData.Logic.impactTargetId);
end;

function u1.Server_EnterRecovery(p59) -- Line: 402
    p59:releaseControl();
end;

function u1.Client_EnterRecovery(p60) -- Line: 406
    local v61 = p60.skillRunData.material["地系尾迹2"];

    if v61 then
        for _, descendant in pairs(v61:GetDescendants()) do
            if descendant:IsA("Trail") or descendant:IsA("ParticleEmitter") then
                descendant.Enabled = false;
            end;
        end;
    end;

    if p60.skillRunData.runEvent["木刺Cast尾迹"] then
        p60.skillRunData.runEvent["木刺Cast尾迹"]:Disconnect();
        p60.skillRunData.runEvent["木刺Cast尾迹"] = nil;
    end;
end;

function u1.onServerEvent(p62, p63) -- Line: 421
    -- upvalues: SkillEventConst (copy)
    if p63.eventType ~= SkillEventConst.SyncEventType.ProjectileHitConfirmed then
        return;
    end;

    local skillRunData = p62.skillRunData;

    if not skillRunData then
        return;
    end;

    local hitPosition = p63.hitPosition;

    if not hitPosition then
        return;
    end;

    local v64 = p63.hitType == SkillEventConst.HitType.Obstacle and SkillEventConst.ObstacleHit or (p63.hitType == SkillEventConst.HitType.Timeout and SkillEventConst.Timeout or SkillEventConst.EnemyHit);

    if p62.GetCurrentState and p62:GetCurrentState() == "ProjectileFlying" then
        p62:TryTransition(v64, {
            hitPosition = hitPosition,
            hitType = p63.hitType,
            targetId = p63.targetId
        });

        return;
    end;

    skillRunData.Visual.pendingProjectileHitEvent = p63;
end;

function u1.onProjectileHitServer(p65, p66, p67) -- Line: 442
    -- upvalues: SkillEventConst (copy), ProjectileImpact (copy)
    if not p66 then
        return;
    end;

    if not (p65.hitbox[1] and p65.hitbox[2]) then
        return;
    end;

    local skillRunData = p65.skillRunData;

    if not (skillRunData and skillRunData.State) then
        return;
    end;

    if p66.hitboxIndex == 2 then
        local HitResolver = require(script.Parent.Parent.BaseSkill.HitResolver);

        for i, v in p67 do
            HitResolver.applyHit(p65, p66, v, i);
        end;

        return;
    end;

    if p66.hitboxIndex ~= 1 then
        return;
    end;

    local v68, v69 = next(p67);

    if not (v68 and v69) then
        return;
    end;

    ProjectileImpact.resolveImpact(p65, {
        type = SkillEventConst.HitType.Enemy,
        position = v69.Position,
        target = v68,
        hitResult = p67,
        source = ProjectileImpact.ImpactSource.Hitbox
    });
end;

u1.SoundList = { "音效-技能-木刺-施法", "音效-技能-木刺-爆炸" };
u1.AnimateList = { "技能释放动作3" };
u1.ResNameList = { "地系尾迹2", "木刺_法阵", "木刺_爆炸", "木刺" };
u1.hitboxConfig = { {
        HitboxIndex = 1,
        PartName = "通用长方体",
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