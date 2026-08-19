-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local HitResolver = require(script.Parent.Parent.BaseSkill.HitResolver);
local ProjectileImpact = require(script.Parent._Templates.Projectile.ProjectileImpact);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local PlayerAimSync = require(script.Parent.Parent.BaseSkill.PlayerAimSync);
local FXUtil = UtilsSystem.FXUtil;
local BezierCurve = UtilsSystem.BezierCurve;
local RunService = UtilsSystem.RunService;
local u1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.Thunder,
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

local function getStormCircleFormationCF(p2) -- Line: 97
    -- upvalues: SkillCommon (copy)
    return SkillCommon.getProjectileStartWindStyleCF(p2, 4, 0.5);
end;

local function getThunderOrbBallLaunchCF(p3) -- Line: 101
    -- upvalues: SkillCommon (copy)
    return SkillCommon.getProjectileStartWindStyleCF(p3, 5, 0.5);
end;

local function getProjectileEndCF(p4) -- Line: 105
    -- upvalues: SkillCommon (copy)
    return SkillCommon.clampProjectileEndFromSkillData(p4, SkillCommon.getProjectileStartWindStyleCF(p4, 5, 0.5), 210, 0.55);
end;

local function setLightningBall01VfxEnabled(p5, p6) -- Line: 110
    -- upvalues: FXUtil (copy)
    if not p5 then
        return;
    end;

    local LightningBall_01 = p5:FindFirstChild("LightningBall_01", true);

    if LightningBall_01 then
        FXUtil.SetEmittersTrailsBeamsEnabled(LightningBall_01, p6);

        return;
    end;

    FXUtil.SetEmittersTrailsBeamsEnabled(p5, p6);
end;

local function stopThunderOrbWandTrail(p7) -- Line: 120
    -- upvalues: SkillCommon (copy)
    local skillRunData = p7.skillRunData;
    SkillCommon.disconnectRunEventKeys(skillRunData, { "雷球术Cast尾迹" });
    local v8 = skillRunData.material and skillRunData.material["雷系尾迹"];

    if v8 then
        for _, descendant in pairs(v8:GetDescendants()) do
            if descendant:IsA("Trail") or descendant:IsA("ParticleEmitter") then
                descendant.Enabled = false;
            end;
        end;
    end;
end;

local function beginThunderOrbBallAppear(p9, p10, p11) -- Line: 134
    -- upvalues: SkillCommon (copy), FXUtil (copy)
    local u12 = p10.material["雷球"];
    local _, u13 = SkillCommon.scaleDualFromData(p9, SkillCommon.bandScaleOptsFromSkillData(p9));
    u12:PivotTo(p11);
    u12.Parent = workspace.Debris;
    FXUtil.Model_Scale_Tween(u12, 0.0001 * u13, u13, 0.167, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, function() -- Line: 146
        -- upvalues: u12 (copy), u13 (copy)
        if u12.Parent then
            u12:ScaleTo(u13);
        end;
    end, true);
    FXUtil.Emit_Particles_GetDescendants(u12, false);
    FXUtil.SetEnableNameVfx(u12, true);

    if u12 then
        local LightningBall_01 = u12:FindFirstChild("LightningBall_01", true);

        if LightningBall_01 then
            FXUtil.SetEmittersTrailsBeamsEnabled(LightningBall_01, true);
        else
            FXUtil.SetEmittersTrailsBeamsEnabled(u12, true);
        end;
    end;

    p10.Visual.projectileModel = u12;
end;

local function startThunderOrbClientBezier(p14, p15, p16) -- Line: 159
    -- upvalues: BezierCurve (copy), u1 (copy)
    local skillRunData = p14.skillRunData;
    local v17 = p15:GetPivot();
    local v18 = math.min((v17.Position - p16.Position).Magnitude / 210, 0.55) * 60;
    local v19 = BezierCurve.GenerateBezierPoints(v17.Position, p16.Position, 2, {
        RandomSeed = 10000,
        HeightOffsetRandom = 0,
        SideOffsetRandom = 0,
        EasingStyle = Enum.EasingStyle.Quad,
        EasingDirection = Enum.EasingDirection.Out
    });
    skillRunData.Logic.hasExploded = false;
    local v20 = BezierCurve.MultiOrderBezierCurves({
        FPS = 60,
        Frame = v18,
        Points = v19,
        Target = p15,
        EasingStyle = Enum.EasingStyle.Sine,
        EasingDirection = Enum.EasingDirection.In
    }, function() -- Line: 180
    end);
    skillRunData.Visual.projectileMotion = v20;
    skillRunData.Logic.impactPosition = p16.Position;
    table.insert(skillRunData.runEvent, v20);
    local pendingProjectileHitEvent = skillRunData.Visual.pendingProjectileHitEvent;

    if pendingProjectileHitEvent then
        skillRunData.Visual.pendingProjectileHitEvent = nil;
        v20:Disconnect();
        skillRunData.Visual.projectileMotion = nil;
        u1.onServerEvent(p14, pendingProjectileHitEvent);
    end;
end;

function u1.Client_EnterStartup(u21) -- Line: 194
    -- upvalues: SkillCommon (copy), RunService (copy)
    local character = u21.skillInputData.character;

    if not character then
        return;
    end;

    local u22 = SkillCommon.resolveWandTipFromCharacter(character);

    if not u22 then
        return;
    end;

    if not character:FindFirstChild("HumanoidRootPart") then
        return;
    end;

    task.delay(0.27, function() -- Line: 203
        -- upvalues: u21 (copy), RunService (ref), u22 (copy)
        if not u21:isRunningFlow() then
            return;
        end;

        local u23 = u21.skillRunData.material["雷系尾迹"];

        for _, descendant in pairs(u23:GetDescendants()) do
            if descendant:IsA("Trail") or descendant:IsA("ParticleEmitter") then
                descendant.Enabled = true;
            end;
        end;

        u23.Parent = workspace.Debris;
        u21.skillRunData.runEvent["雷球术Cast尾迹"] = RunService.RenderStepped:Connect(function() -- Line: 212
            -- upvalues: u22 (ref), u23 (copy)
            if u22.Parent then
                u23:PivotTo(u22:GetPivot());
            end;
        end);
    end);
end;

function u1.Server_EnterStartup(p24) -- Line: 220
    local v25 = p24.hitbox[1];
    local v26 = p24.hitbox[2];

    if v25 and v25.hitbox then
        v25.hitbox.Size = Vector3.new(5, 5, 5);
    end;

    if v26 and v26.hitbox then
        v26.hitbox.Size = Vector3.new(45, 45, 45);
    end;
end;

function u1.Client_EnterProjectileFlying(u27) -- Line: 230
    -- upvalues: PlayerAimSync (copy), stopThunderOrbWandTrail (copy), SkillCommon (copy), FXUtil (copy), beginThunderOrbBallAppear (copy), getThunderOrbBallLaunchCF (copy), startThunderOrbClientBezier (copy)
    PlayerAimSync.refreshAimSnapshot(u27);

    if not u27.skillInputData.character then
        return;
    end;

    stopThunderOrbWandTrail(u27);
    local skillRunData = u27.skillRunData;
    local v28 = SkillCommon.getProjectileStartWindStyleCF(u27, 4, 0.5);
    local _, v29 = SkillCommon.scaleDualFromData(u27, SkillCommon.bandScaleOptsFromSkillData(u27));
    local v30 = skillRunData.material["雷球术法阵"];
    v30:ScaleTo(v29);
    v30:PivotTo(v28);
    v30.Parent = workspace.Debris;
    FXUtil.Emit_Particles_GetDescendants(v30, true);
    SkillCommon.playSoundLocal3D("音效-技能-雷系-法阵", v30:GetPivot().Position);
    task.delay(0.083, function() -- Line: 251
        -- upvalues: u27 (copy), skillRunData (copy), beginThunderOrbBallAppear (ref), getThunderOrbBallLaunchCF (ref), SkillCommon (ref), startThunderOrbClientBezier (ref)
        if not u27:isRunningFlow() then
            return;
        end;

        if u27.GetCurrentState and u27:GetCurrentState() ~= "ProjectileFlying" then
            return;
        end;

        local projectileModel = skillRunData.Visual.projectileModel;

        if projectileModel and projectileModel.Parent then
            local _, v31 = SkillCommon.scaleDualFromData(u27, SkillCommon.bandScaleOptsFromSkillData(u27));
            projectileModel:ScaleTo(v31);
        else
            beginThunderOrbBallAppear(u27, skillRunData, getThunderOrbBallLaunchCF(u27));
            projectileModel = skillRunData.Visual.projectileModel;
        end;

        local _, v32 = SkillCommon.scaleDualFromData(u27, SkillCommon.bandScaleOptsFromSkillData(u27));
        local v33 = u27;
        local v34 = SkillCommon.clampProjectileEndFromSkillData(v33, SkillCommon.getProjectileStartWindStyleCF(v33, 5, 0.5), 210, 0.55);
        local v35 = skillRunData.material["雷球术爆炸"];

        if v35 then
            v35.Parent = workspace.Debris;
            v35:ScaleTo(v32);
        end;

        if not skillRunData.Visual.projectileMotion then
            startThunderOrbClientBezier(u27, projectileModel, v34);
        end;
    end);
end;

function u1.Client_ExitProjectileFlying(p36) -- Line: 279
    local projectileMotion = p36.skillRunData.Visual.projectileMotion;

    if projectileMotion then
        projectileMotion:Disconnect();
        p36.skillRunData.Visual.projectileMotion = nil;
    end;
end;

function u1.Server_EnterProjectileFlying(u37) -- Line: 287
    -- upvalues: PlayerAimSync (copy), SkillCommon (copy), BezierCurve (copy), SkillEventConst (copy), ProjectileImpact (copy)
    PlayerAimSync.refreshAimSnapshot(u37);
    local u38 = u37.hitbox[1];

    if not (u38 and u37.hitbox[2]) then
        return;
    end;

    u37.skillRunData.Logic.hasExploded = false;
    task.delay(0.083, function() -- Line: 298
        -- upvalues: u37 (copy), SkillCommon (ref), u38 (copy), BezierCurve (ref), SkillEventConst (ref), ProjectileImpact (ref)
        local skillRunData = u37.skillRunData;

        if not skillRunData or (skillRunData.State.current ~= "ProjectileFlying" or skillRunData.Logic.hasExploded) then
            return;
        end;

        local v39 = SkillCommon.getProjectileStartWindStyleCF(u37, 5, 0.5);
        local v40 = u37;
        local u41 = SkillCommon.clampProjectileEndFromSkillData(v40, SkillCommon.getProjectileStartWindStyleCF(v40, 5, 0.5), 210, 0.55);
        local hitbox = u38.hitbox;
        skillRunData.Logic.projectileLastPosition = v39.Position;
        hitbox:PivotTo(v39);
        u38:start();
        local v42 = math.min((v39.Position - u41.Position).Magnitude / 210, 0.55) * 60;
        local v43 = BezierCurve.GenerateBezierPoints(v39.Position, u41.Position, 2, {
            RandomSeed = 10000,
            HeightOffsetRandom = 0,
            SideOffsetRandom = 0,
            EasingStyle = Enum.EasingStyle.Quad,
            EasingDirection = Enum.EasingDirection.Out
        });
        local v44 = BezierCurve.MultiOrderBezierCurves({
            FPS = 60,
            Frame = v42,
            Points = v43,
            Target = hitbox,
            EasingStyle = Enum.EasingStyle.Sine,
            EasingDirection = Enum.EasingDirection.In
        }, function() -- Line: 333
            -- upvalues: SkillEventConst (ref), u41 (copy), ProjectileImpact (ref), u37 (ref)
            ProjectileImpact.resolveImpact(u37, {
                type = SkillEventConst.HitType.Timeout,
                position = u41.Position,
                source = ProjectileImpact.ImpactSource.Lifetime
            });
        end);
        skillRunData.Logic.projectileHitboxMotion = v44;
        table.insert(skillRunData.runEvent, v44);
    end);
end;

function u1.Server_ExitProjectileFlying(p45) -- Line: 346
    local projectileHitboxMotion = p45.skillRunData.Logic.projectileHitboxMotion;

    if projectileHitboxMotion then
        projectileHitboxMotion:Disconnect();
        p45.skillRunData.Logic.projectileHitboxMotion = nil;
    end;

    local v46 = p45.hitbox[1];

    if v46 and v46.isActive then
        v46:stop();
    end;

    if v46 and v46.hitbox then
        v46.hitbox.Transparency = 1;
    end;
end;

function u1.Server_UpdateProjectileObstacleCheck(p47) -- Line: 357
    -- upvalues: SkillEventConst (copy), ProjectileImpact (copy)
    local skillRunData = p47.skillRunData;

    if skillRunData.State.current ~= "ProjectileFlying" or skillRunData.Logic.hasExploded then
        return;
    end;

    if not skillRunData.Logic.projectileHitboxMotion then
        return;
    end;

    local v48 = p47.hitbox[1];

    if not v48 then
        return;
    end;

    local hitbox = v48.hitbox;
    local Position = hitbox.Position;
    local v49 = skillRunData.Logic.projectileLastPosition or Position;
    local v50 = Position - v49;

    if v50.Magnitude > 0.01 then
        local v51 = RaycastParams.new();
        v51.FilterType = Enum.RaycastFilterType.Exclude;
        local v52;

        if typeof(hitbox) == "Instance" then
            v52 = { p47.character, hitbox };
        else
            v52 = { p47.character };
        end;

        v51.FilterDescendantsInstances = v52;
        local v53 = workspace:Raycast(v49, v50, v51);

        if v53 then
            local Instance = v53.Instance;

            if Instance then
                Instance = Instance.Parent;
            end;

            local v54 = Instance and Instance:IsA("Model") and Instance:FindFirstChildOfClass("Humanoid");

            if not v54 then
                ProjectileImpact.resolveImpact(p47, {
                    type = SkillEventConst.HitType.Obstacle,
                    position = v53.Position,
                    normal = v53.Normal,
                    source = ProjectileImpact.ImpactSource.Raycast
                });

                return;
            end;
        end;
    end;

    skillRunData.Logic.projectileLastPosition = Position;
end;

function u1.Client_EnterExploding(p55, p56) -- Line: 396
    -- upvalues: FXUtil (copy), SkillCommon (copy)
    local v57 = p56 and p56.hitPosition or p55.skillRunData.Logic and p55.skillRunData.Logic.impactPosition;

    if not v57 then
        return;
    end;

    local projectileModel = p55.skillRunData.Visual.projectileModel;
    local v58 = p55.skillRunData.material["雷球术爆炸"];

    if projectileModel and projectileModel.Parent then
        projectileModel:PivotTo(CFrame.new(v57));
        FXUtil.SetEnableNameVfx(projectileModel, false);

        if projectileModel then
            local LightningBall_01 = projectileModel:FindFirstChild("LightningBall_01", true);

            if LightningBall_01 then
                FXUtil.SetEmittersTrailsBeamsEnabled(LightningBall_01, false);
            else
                FXUtil.SetEmittersTrailsBeamsEnabled(projectileModel, false);
            end;
        end;

        FXUtil.Stop_All_Emit(projectileModel);
        task.delay(0.05, function() -- Line: 408
            -- upvalues: projectileModel (copy)
            if projectileModel and projectileModel.Parent then
                projectileModel:Destroy();
            end;
        end);
    end;

    if v58 and p55:isRunningFlow() then
        local _, v59 = SkillCommon.scaleDualFromData(p55, SkillCommon.bandScaleOptsFromSkillData(p55));
        v58:ScaleTo(v59);
        v58:PivotTo(CFrame.new(v57));
        v58.Parent = workspace.Debris;
        FXUtil.Emit_Particles_GetDescendants(v58, true);
    end;

    SkillCommon.playSoundLocal3D("音效-技能-雷3-攻击", v57);
end;

function u1.Server_EnterExploding(p60, p61) -- Line: 425
    -- upvalues: SkillEventConst (copy)
    local v62 = p61 and p61.hitPosition or p60.skillRunData.Logic and p60.skillRunData.Logic.impactPosition;

    if not v62 then
        return;
    end;

    p60:fireProjectileHitConfirmed(v62, p60.skillRunData.Logic.impactType or SkillEventConst.HitType.Timeout, p60.skillRunData.Logic.impactTargetId);

    if not p60:isRunningFlow() then
        return;
    end;

    if p60:GetCurrentState() ~= "Exploding" then
        return;
    end;

    local u63 = p60.hitbox[2];

    if u63 then
        local hitbox = u63.hitbox;
        hitbox:PivotTo(CFrame.new(v62));
        u63:start();
        task.delay(0.15, function() -- Line: 442
            -- upvalues: u63 (copy), hitbox (copy)
            if u63.isActive then
                u63:stop();
                hitbox.Transparency = 1;
            end;
        end);
    end;
end;

function u1.Server_EnterRecovery(p64) -- Line: 452
    p64:releaseControl();
end;

function u1.Client_EnterRecovery(p65) -- Line: 456
    -- upvalues: stopThunderOrbWandTrail (copy)
    stopThunderOrbWandTrail(p65);
end;

function u1.onServerEvent(p66, p67) -- Line: 461
    -- upvalues: SkillEventConst (copy)
    if p67.eventType ~= SkillEventConst.SyncEventType.ProjectileHitConfirmed then
        return;
    end;

    local skillRunData = p66.skillRunData;

    if not skillRunData then
        return;
    end;

    local hitPosition = p67.hitPosition;

    if not hitPosition then
        return;
    end;

    local v68 = p67.hitType == SkillEventConst.HitType.Obstacle and SkillEventConst.ObstacleHit or (p67.hitType == SkillEventConst.HitType.Timeout and SkillEventConst.Timeout or SkillEventConst.EnemyHit);

    if p66.GetCurrentState and p66:GetCurrentState() == "ProjectileFlying" then
        p66:TryTransition(v68, {
            hitPosition = hitPosition,
            hitType = p67.hitType,
            targetId = p67.targetId
        });

        return;
    end;

    skillRunData.Visual.pendingProjectileHitEvent = p67;
end;

function u1.onProjectileHitServer(p69, p70, p71) -- Line: 483
    -- upvalues: HitResolver (copy), SkillEventConst (copy), ProjectileImpact (copy)
    if not p70 then
        return;
    end;

    if not (p69.hitbox[1] and p69.hitbox[2]) then
        return;
    end;

    local skillRunData = p69.skillRunData;

    if not (skillRunData and skillRunData.State) then
        return;
    end;

    if p70.hitboxIndex == 2 then
        for i, v in p71 do
            HitResolver.applyHit(p69, p70, v, i);
        end;

        return;
    end;

    if p70.hitboxIndex ~= 1 then
        return;
    end;

    local v72, v73 = next(p71);

    if not (v72 and v73) then
        return;
    end;

    ProjectileImpact.resolveImpact(p69, {
        type = SkillEventConst.HitType.Enemy,
        position = v73.Position,
        target = v72,
        hitResult = p71,
        source = ProjectileImpact.ImpactSource.Hitbox
    });
end;

u1.SoundList = { "音效-技能-雷系-法阵", "音效-技能-雷3-攻击" };
u1.AnimateList = { "技能释放动作3" };
u1.ResNameList = { "雷球", "雷球术法阵", "雷球术爆炸", "雷系尾迹" };
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