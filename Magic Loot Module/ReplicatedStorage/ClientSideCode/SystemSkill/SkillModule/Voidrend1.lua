-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
require(script.Parent.Parent.BaseSkill.GetSkillData);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local ProjectileImpact = require(script.Parent._Templates.Projectile.ProjectileImpact);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local PlayerAimSync = require(script.Parent.Parent.BaseSkill.PlayerAimSync);
local FXUtil = UtilsSystem.FXUtil;
local BezierCurve = UtilsSystem.BezierCurve;
local RunService = UtilsSystem.RunService;
local _ = UtilsSystem.Players;
local u1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.Wind,
    InitialState = "Startup",
    ControlOpenState = "ProjectileFlying",
    States = {
        Startup = {
            Duration = 0.4,
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

local function get_skillScale(p2) -- Line: 98
    -- upvalues: SkillCommon (copy)
    return SkillCommon.scaleDualFromData(p2, SkillCommon.bandScaleOptsFromSkillData(p2));
end;

local function getProjectileStartCF(p3) -- Line: 102
    -- upvalues: SkillCommon (copy)
    return SkillCommon.getProjectileStartWindStyleCF(p3, 2, 0.5);
end;

local function getProjectileEndCF(p4) -- Line: 106
    -- upvalues: SkillCommon (copy)
    return SkillCommon.clampProjectileEndFromSkillData(p4, SkillCommon.getProjectileStartWindStyleCF(p4, 2, 0.5), 210, 0.3);
end;

function u1.Client_EnterStartup(p5) -- Line: 111
    -- upvalues: SkillCommon (copy), RunService (copy)
    local character = p5.skillInputData.character;

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

    local u7 = p5.skillRunData.material["风系尾迹"];

    for _, descendant in pairs(u7:GetDescendants()) do
        if descendant:IsA("Trail") or descendant:IsA("ParticleEmitter") then
            descendant.Enabled = true;
        end;
    end;

    u7.Parent = workspace.Debris;
    p5.skillRunData.runEvent["风刃术Cast尾迹"] = RunService.RenderStepped:Connect(function() -- Line: 127
        -- upvalues: u6 (copy), u7 (copy)
        if u6.Parent then
            u7:PivotTo(u6:GetPivot());
        end;
    end);
end;

function u1.Server_EnterStartup(p8) -- Line: 135
    -- upvalues: SkillCommon (copy)
    local v9 = p8.hitbox[1];
    local v10 = p8.hitbox[2];
    local v11 = 5 * SkillCommon.skillScaleFromSkillData(p8);
    local v12 = Vector3.new(v11, v11, v11);

    if v9 and v9.hitbox then
        v9.hitbox.Size = v12;
    end;

    if v10 and v10.hitbox then
        v10.hitbox.Size = Vector3.new(3, 3, 3);
    end;
end;

function u1.Client_EnterProjectileFlying(u13) -- Line: 149
    -- upvalues: PlayerAimSync (copy), SkillCommon (copy), FXUtil (copy), BezierCurve (copy), u1 (copy)
    PlayerAimSync.refreshAimSnapshot(u13);
    task.delay(0.33, function() -- Line: 153
        -- upvalues: u13 (copy), SkillCommon (ref), FXUtil (ref), BezierCurve (ref), u1 (ref)
        if not u13:isRunningFlow() then
            return;
        end;

        if u13.GetCurrentState and u13:GetCurrentState() ~= "ProjectileFlying" then
            return;
        end;

        local character = u13.skillInputData.character;

        if not character then
            return;
        end;

        if not character:FindFirstChild("HumanoidRootPart") then
            return;
        end;

        local skillRunData = u13.skillRunData;
        local v14 = SkillCommon.getProjectileStartWindStyleCF(u13, 2, 0.5);
        local v15 = u13;
        local v16 = SkillCommon.clampProjectileEndFromSkillData(v15, SkillCommon.getProjectileStartWindStyleCF(v15, 2, 0.5), 210, 0.3);
        local v17 = u13;
        local _, v18 = SkillCommon.scaleDualFromData(v17, SkillCommon.bandScaleOptsFromSkillData(v17));
        local v19 = skillRunData.material["风刃法阵"];
        v19:ScaleTo(v18 * 0.5);
        v19:PivotTo(v14 * CFrame.Angles(1.5707963267948966, 0, 0));
        v19.Parent = workspace.Debris;
        FXUtil.Emit_Particles_GetDescendants(v19, true);
        local v20 = skillRunData.material["风刃"];
        local v21 = skillRunData.material["风刃爆炸"];
        local v22 = u13;
        local v23, v24 = SkillCommon.scaleDualFromData(v22, SkillCommon.bandScaleOptsFromSkillData(v22));

        for _, descendant in pairs(v20:GetDescendants()) do
            if descendant:IsA("Beam") then
                descendant.Enabled = true;
                FXUtil.Beam_Fade_From_Transparent(descendant, 0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.In);
            end;
        end;

        FXUtil.Model_Scale_Tween(v20, v23, v24, 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, nil, true);
        v20:PivotTo(v14);
        v20.Parent = workspace.Debris;
        FXUtil.Start_All_Emit(v20, 10);
        v21.Parent = workspace.Debris;
        v21:ScaleTo(v24);
        SkillCommon.playSoundLocal3D("技能_风刃术", v20:GetPivot().Position);
        local v25 = math.min((v14.Position - v16.Position).Magnitude / 210, 0.3) * 60;
        local v26 = BezierCurve.GenerateBezierPoints(v14.Position, v16.Position, 2, {
            RandomSeed = 10000,
            HeightOffsetRandom = 0,
            SideOffsetRandom = 0,
            EasingStyle = Enum.EasingStyle.Quad,
            EasingDirection = Enum.EasingDirection.Out
        });
        skillRunData.Visual.projectileModel = v20;
        skillRunData.Logic.hasExploded = false;
        local v27 = BezierCurve.MultiOrderBezierCurves({
            FPS = 60,
            Frame = v25,
            Points = v26,
            Target = v20,
            EasingStyle = Enum.EasingStyle.Sine,
            EasingDirection = Enum.EasingDirection.In
        }, function() -- Line: 216
        end);
        skillRunData.Visual.projectileMotion = v27;
        skillRunData.Logic.impactPosition = v16.Position;
        table.insert(skillRunData.runEvent, v27);
        local pendingProjectileHitEvent = skillRunData.Visual.pendingProjectileHitEvent;

        if pendingProjectileHitEvent then
            skillRunData.Visual.pendingProjectileHitEvent = nil;
            v27:Disconnect();
            skillRunData.Visual.projectileMotion = nil;
            u1.onServerEvent(u13, pendingProjectileHitEvent);
        end;
    end);
end;

function u1.Client_ExitProjectileFlying(p28) -- Line: 233
    local projectileMotion = p28.skillRunData.Visual.projectileMotion;

    if projectileMotion then
        projectileMotion:Disconnect();
        p28.skillRunData.Visual.projectileMotion = nil;
    end;
end;

function u1.Server_EnterProjectileFlying(u29) -- Line: 241
    -- upvalues: PlayerAimSync (copy), SkillCommon (copy), BezierCurve (copy), SkillEventConst (copy), ProjectileImpact (copy)
    PlayerAimSync.refreshAimSnapshot(u29);
    local u30 = u29.hitbox[1];

    if not (u30 and u29.hitbox[2]) then
        return;
    end;

    task.delay(0.33, function() -- Line: 248
        -- upvalues: u29 (copy), SkillCommon (ref), u30 (copy), BezierCurve (ref), SkillEventConst (ref), ProjectileImpact (ref)
        if not u29:isRunningFlow() then
            return;
        end;

        if u29:GetCurrentState() ~= "ProjectileFlying" then
            return;
        end;

        local v31 = SkillCommon.getProjectileStartWindStyleCF(u29, 2, 0.5);
        local v32 = u29;
        local u33 = SkillCommon.clampProjectileEndFromSkillData(v32, SkillCommon.getProjectileStartWindStyleCF(v32, 2, 0.5), 210, 0.3);
        local hitbox = u30.hitbox;
        u29.skillRunData.Logic.hasExploded = false;
        u29.skillRunData.Logic.projectileLastPosition = v31.Position;
        hitbox:PivotTo(v31);
        u30:start();
        local v34 = math.min((v31.Position - u33.Position).Magnitude / 210, 0.3) * 60;
        local v35 = BezierCurve.GenerateBezierPoints(v31.Position, u33.Position, 2, {
            RandomSeed = 10000,
            HeightOffsetRandom = 0,
            SideOffsetRandom = 0,
            EasingStyle = Enum.EasingStyle.Quad,
            EasingDirection = Enum.EasingDirection.Out
        });
        local v36 = BezierCurve.MultiOrderBezierCurves({
            FPS = 60,
            Frame = v34,
            Points = v35,
            Target = hitbox,
            EasingStyle = Enum.EasingStyle.Sine,
            EasingDirection = Enum.EasingDirection.In
        }, function() -- Line: 282
            -- upvalues: SkillEventConst (ref), u33 (copy), ProjectileImpact (ref), u29 (ref)
            ProjectileImpact.resolveImpact(u29, {
                type = SkillEventConst.HitType.Timeout,
                position = u33.Position,
                source = ProjectileImpact.ImpactSource.Lifetime
            });
        end);
        u29.skillRunData.Logic.projectileHitboxMotion = v36;
        table.insert(u29.skillRunData.runEvent, v36);
    end);
end;

function u1.Server_ExitProjectileFlying(p37) -- Line: 295
    local projectileHitboxMotion = p37.skillRunData.Logic.projectileHitboxMotion;

    if projectileHitboxMotion then
        projectileHitboxMotion:Disconnect();
        p37.skillRunData.Logic.projectileHitboxMotion = nil;
    end;

    local v38 = p37.hitbox[1];

    if v38 and v38.isActive then
        v38:stop();
    end;

    if v38 and v38.hitbox then
        v38.hitbox.Transparency = 1;
    end;
end;

function u1.Server_UpdateProjectileObstacleCheck(p39) -- Line: 310
    -- upvalues: SkillEventConst (copy), ProjectileImpact (copy)
    local skillRunData = p39.skillRunData;

    if skillRunData.State.current ~= "ProjectileFlying" or skillRunData.Logic.hasExploded then
        return;
    end;

    if not skillRunData.Logic.projectileHitboxMotion then
        return;
    end;

    local v40 = p39.hitbox[1];

    if not v40 then
        return;
    end;

    local hitbox = v40.hitbox;
    local Position = hitbox.Position;
    local v41 = skillRunData.Logic.projectileLastPosition or Position;
    local v42 = Position - v41;

    if v42.Magnitude > 0.01 then
        local v43 = RaycastParams.new();
        v43.FilterType = Enum.RaycastFilterType.Exclude;
        local v44;

        if typeof(hitbox) == "Instance" then
            v44 = { p39.character, hitbox };
        else
            v44 = { p39.character };
        end;

        v43.FilterDescendantsInstances = v44;
        local v45 = workspace:Raycast(v41, v42, v43);

        if v45 then
            local Instance = v45.Instance;

            if Instance then
                Instance = Instance.Parent;
            end;

            local v46 = Instance and Instance:IsA("Model") and Instance:FindFirstChildOfClass("Humanoid");

            if not v46 then
                ProjectileImpact.resolveImpact(p39, {
                    type = SkillEventConst.HitType.Obstacle,
                    position = v45.Position,
                    normal = v45.Normal,
                    source = ProjectileImpact.ImpactSource.Raycast
                });

                return;
            end;
        end;
    end;

    skillRunData.Logic.projectileLastPosition = Position;
end;

function u1.Client_EnterExploding(p47, p48) -- Line: 349
    -- upvalues: FXUtil (copy)
    local v49 = p48 and p48.hitPosition or p47.skillRunData.Logic and p47.skillRunData.Logic.impactPosition;

    if not v49 then
        return;
    end;

    local projectileModel = p47.skillRunData.Visual.projectileModel;
    local v50 = p47.skillRunData.material["风刃爆炸"];

    if projectileModel and projectileModel.Parent then
        projectileModel:PivotTo(CFrame.new(v49));
    end;

    if v50 then
        v50:PivotTo(CFrame.new(v49));
        FXUtil.Emit_Particles_GetDescendants(v50, true);
    end;

    if projectileModel then
        for _, descendant in pairs(projectileModel:GetDescendants()) do
            if descendant:IsA("Beam") then
                FXUtil.Beam_Fade_To_Transparent_Then_Disable(descendant, 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
            end;

            if descendant:IsA("ParticleEmitter") and descendant.Name == "Enabled3" then
                descendant:Clear();
            end;
        end;

        FXUtil.Stop_All_Emit(projectileModel);
    end;
end;

function u1.Server_EnterExploding(p51, p52) -- Line: 375
    -- upvalues: FXUtil (copy), SkillEventConst (copy)
    local v53 = p52 and p52.hitPosition or p51.skillRunData.Logic and p51.skillRunData.Logic.impactPosition;

    if not v53 then
        return;
    end;

    local u54 = p51.hitbox[2];

    if u54 then
        local hitbox = u54.hitbox;
        hitbox:PivotTo(CFrame.new(v53));
        u54:start();
        FXUtil.BasePart_Size_Tween(hitbox, 0.1, Vector3.new(10, 10, 10), Enum.EasingStyle.Quad, Enum.EasingDirection.Out, function() -- Line: 384
            -- upvalues: u54 (copy), hitbox (copy)
            if u54.isActive then
                u54:stop();
                hitbox.Transparency = 1;
            end;
        end);
    end;

    p51:fireProjectileHitConfirmed(v53, p51.skillRunData.Logic.impactType or SkillEventConst.HitType.Timeout, p51.skillRunData.Logic.impactTargetId);
end;

function u1.Server_EnterRecovery(p55) -- Line: 400
    p55:releaseControl();
end;

function u1.Client_EnterRecovery(p56) -- Line: 404
    local v57 = p56.skillRunData.material["风系尾迹"];

    if v57 then
        for _, descendant in pairs(v57:GetDescendants()) do
            if descendant:IsA("Trail") or descendant:IsA("ParticleEmitter") then
                descendant.Enabled = false;
            end;
        end;
    end;

    if p56.skillRunData.runEvent["风刃术Cast尾迹"] then
        p56.skillRunData.runEvent["风刃术Cast尾迹"]:Disconnect();
        p56.skillRunData.runEvent["风刃术Cast尾迹"] = nil;
    end;
end;

function u1.onServerEvent(p58, p59) -- Line: 420
    -- upvalues: SkillEventConst (copy)
    if p59.eventType ~= SkillEventConst.SyncEventType.ProjectileHitConfirmed then
        return;
    end;

    local skillRunData = p58.skillRunData;

    if not skillRunData then
        return;
    end;

    local hitPosition = p59.hitPosition;

    if not hitPosition then
        return;
    end;

    local v60 = p59.hitType == SkillEventConst.HitType.Obstacle and SkillEventConst.ObstacleHit or (p59.hitType == SkillEventConst.HitType.Timeout and SkillEventConst.Timeout or SkillEventConst.EnemyHit);

    if p58.GetCurrentState and p58:GetCurrentState() == "ProjectileFlying" then
        p58:TryTransition(v60, {
            hitPosition = hitPosition,
            hitType = p59.hitType,
            targetId = p59.targetId
        });

        return;
    end;

    skillRunData.Visual.pendingProjectileHitEvent = p59;
end;

function u1.onProjectileHitServer(p61, p62, p63) -- Line: 442
    -- upvalues: SkillEventConst (copy), ProjectileImpact (copy)
    if not p62 then
        return;
    end;

    if not (p61.hitbox[1] and p61.hitbox[2]) then
        return;
    end;

    local skillRunData = p61.skillRunData;

    if not (skillRunData and skillRunData.State) then
        return;
    end;

    if p62.hitboxIndex == 2 then
        local HitResolver = require(script.Parent.Parent.BaseSkill.HitResolver);

        for i, v in p63 do
            HitResolver.applyHit(p61, p62, v, i);
        end;

        return;
    end;

    if p62.hitboxIndex ~= 1 then
        return;
    end;

    local v64, v65 = next(p63);

    if not (v64 and v65) then
        return;
    end;

    ProjectileImpact.resolveImpact(p61, {
        type = SkillEventConst.HitType.Enemy,
        position = v65.Position,
        target = v64,
        hitResult = p63,
        source = ProjectileImpact.ImpactSource.Hitbox
    });
end;

u1.SoundList = { "技能_风刃术" };
u1.AnimateList = { "技能释放动作1" };
u1.ResNameList = { "风刃", "风刃法阵", "风刃爆炸", "风系尾迹" };
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
        overTime = 0.73,
        speedType = "RELEASE_SKILL_STATE_HALF"
    },
    {
        action = "Animation",
        startTime = 0,
        overTime = 1.53,
        animationName = "技能释放动作1",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action4
    }
};

return u1;