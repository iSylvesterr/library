-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local ProjectileImpact = require(script.Parent._Templates.Projectile.ProjectileImpact);
local ProjectileCore = require(script.Parent._Templates.Projectile.ProjectileCore);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local PlayerAimSync = require(script.Parent.Parent.BaseSkill.PlayerAimSync);
local FXUtil = UtilsSystem.FXUtil;
local VisibleMgr = UtilsSystem.VisibleMgr;
local BezierCurve = UtilsSystem.BezierCurve;
local u1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.Poison,
    skillDistanceLimit = 64
};
local u2 = CFrame.new(0, 1.4, -2);

local function buildParabolicCurve(p3, p4) -- Line: 51
    -- upvalues: BezierCurve (copy)
    local v5 = math.clamp((p4 - p3).Magnitude * 0.32, 12, 20);

    return BezierCurve.GenerateBezierPoints(p3, p4, 2, {
        RandomSeed = 10000,
        HeightOffsetRandom = 0,
        SideOffsetRandom = 0,
        HeightOffset = v5,
        EasingStyle = Enum.EasingStyle.Quad,
        EasingDirection = Enum.EasingDirection.Out
    });
end;

u1.InitialState = "Startup";
u1.ControlOpenState = "ProjectileFlying";
u1.States = {
    Startup = {
        Duration = 0.73,
        OnEnterClient = "Client_EnterStartup",
        OnEnterServer = "Server_EnterStartup"
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
        OnExitClient = "Client_ExitExploding",
        OnExitServer = nil
    },
    Recovery = {
        Duration = 0.2,
        OnEnterClient = "Client_EnterRecovery",
        OnEnterServer = "Server_EnterRecovery"
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
        From = "Exploding",
        To = "Interrupted",
        Event = SkillEventConst.Interrupt
    },
    {
        From = "Recovery",
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
u1.Server_UpdateProjectileObstacleCheck = ProjectileCore.create({
    stopOnObstacle = true
}).createObstacleCheck();

function u1.Client_EnterStartup(u6) -- Line: 117
    -- upvalues: SkillCommon (copy), u2 (copy), VisibleMgr (copy), FXUtil (copy)
    local u7 = u6.skillInputData and u6.skillInputData.character;

    if not u7 then
        return;
    end;

    local v8 = SkillCommon.resolveWandTipFromCharacter(u7);

    if v8 then
        SkillCommon.scheduleWandTipElementTrail(u6, v8, {
            trailMaterialKey = "毒系尾迹",
            runEventKey = "毒气弹Cast尾迹",
            enableAt = 0.3,
            disableAt = 0.9
        });
    end;

    local runGeneration = u6.runGeneration;
    local skillRunData = u6.skillRunData;

    if not skillRunData then
        return;
    end;

    task.delay(0.667, function() -- Line: 139
        -- upvalues: u6 (copy), runGeneration (copy), u7 (copy), skillRunData (copy), SkillCommon (ref), u2 (ref), VisibleMgr (ref), FXUtil (ref)
        if not u6:isRunningFlow() or (u6.runGeneration ~= runGeneration or u6:isTerminal()) then
            return;
        end;

        if u6.GetCurrentState and u6:GetCurrentState() ~= "Startup" then
            return;
        end;

        local HumanoidRootPart = u7:FindFirstChild("HumanoidRootPart");

        if not HumanoidRootPart then
            return;
        end;

        local v9 = skillRunData.material and skillRunData.material["毒气弹"];

        if not (v9 and v9:IsA("Model")) then
            return;
        end;

        local skillInputData = u6.skillInputData;
        local _, v10 = SkillCommon.scaleDualFromData(u6, SkillCommon.bandScaleOptsFromSkillData(u6));
        local v11 = SkillCommon.formationCFHorizontal(HumanoidRootPart, SkillCommon.resolveStrikeWorldPos(skillInputData), u2);
        v9:ScaleTo(v10);
        VisibleMgr.UnQueryAll(v9);
        VisibleMgr.UnTransparencyAll(v9);
        v9:PivotTo(v11);
        v9.Parent = workspace.Debris;
        skillRunData.Visual = skillRunData.Visual or {};
        skillRunData.Visual.projectileModel = v9;
        SkillCommon.appendRunSpawnList(skillRunData, "GasBombSpawned", v9);
        FXUtil.Model_Fade_In(v9, 0.017, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0);
    end);
    task.delay(0.683, function() -- Line: 170
        -- upvalues: u6 (copy), runGeneration (copy), skillRunData (copy), FXUtil (ref)
        if not u6:isRunningFlow() or (u6.runGeneration ~= runGeneration or u6:isTerminal()) then
            return;
        end;

        if u6.GetCurrentState and u6:GetCurrentState() ~= "Startup" then
            return;
        end;

        local v12 = skillRunData.Visual and skillRunData.Visual.projectileModel;

        if not (v12 and (v12:IsA("Model") and v12.Parent)) then
            return;
        end;

        FXUtil.Emit_Particles_GetDescendants(v12, true);
        FXUtil.SetEmittersTrailsBeamsEnabled(v12, true);
    end);
end;

function u1.Server_EnterStartup(p13) -- Line: 186
    local v14 = p13.hitbox[1];

    if v14 and v14.hitbox then
        local hitbox = v14.hitbox;

        if hitbox:IsA("BasePart") then
            hitbox.Shape = Enum.PartType.Ball;
        end;

        hitbox.Size = Vector3.new(4, 4, 4);
        hitbox:PivotTo(CFrame.new(0, -5000, 0));
    end;
end;

function u1.Client_EnterProjectileFlying(p15) -- Line: 199
    -- upvalues: PlayerAimSync (copy), SkillCommon (copy), u2 (copy), VisibleMgr (copy), FXUtil (copy), buildParabolicCurve (copy), BezierCurve (copy), u1 (copy)
    PlayerAimSync.refreshAimSnapshot(p15);
    local v16 = p15.skillInputData and p15.skillInputData.character;

    if not v16 then
        return;
    end;

    local HumanoidRootPart = v16:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local skillRunData = p15.skillRunData;

    if not skillRunData then
        return;
    end;

    SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "毒系尾迹", "毒气弹Cast尾迹");
    skillRunData.Visual = skillRunData.Visual or {};
    skillRunData.Logic = skillRunData.Logic or {};
    local v17 = SkillCommon.resolveStrikeWorldPos(p15.skillInputData);
    local v18 = SkillCommon.formationCFHorizontal(HumanoidRootPart, v17, u2);
    local Position = v18.Position;
    local v19 = v17 - Position;
    local v20;

    if v19.Magnitude < 0.05 then
        v20 = CFrame.new(Position);
    else
        v20 = CFrame.lookAt(Position, Position + v19.Unit);
    end;

    local _, v21 = SkillCommon.scaleDualFromData(p15, SkillCommon.bandScaleOptsFromSkillData(p15));
    local v22 = skillRunData.material and skillRunData.material["毒气弹_法阵"];

    if v22 and v22:IsA("Model") then
        v22:ScaleTo(v21);
        VisibleMgr.UnQueryAll(v22);
        v22:PivotTo(v18);
        v22.Parent = workspace.Debris;
        SkillCommon.appendRunSpawnList(skillRunData, "GasBombSpawned", v22);
        FXUtil.Emit_Particles_GetDescendants(v22, true);
        SkillCommon.playSoundLocal3D("音效-技能-毒气弹-法阵", v18.Position);
    end;

    local projectileModel = skillRunData.Visual.projectileModel;
    local v23;

    if projectileModel and (projectileModel:IsA("Model") and projectileModel.Parent) then
        projectileModel:PivotTo(v20);
        v23 = projectileModel;
    else
        v23 = skillRunData.material and skillRunData.material["毒气弹"];

        if v23 and v23:IsA("Model") then
            local _, v24 = SkillCommon.scaleDualFromData(p15, SkillCommon.bandScaleOptsFromSkillData(p15));
            v23:ScaleTo(v24);
            VisibleMgr.UnQueryAll(v23);
            v23:PivotTo(v20);
            v23.Parent = workspace.Debris;
            skillRunData.Visual.projectileModel = v23;
            SkillCommon.appendRunSpawnList(skillRunData, "GasBombSpawned", v23);
            FXUtil.Emit_Particles_GetDescendants(v23, true);
            FXUtil.SetEmittersTrailsBeamsEnabled(v23, true);
        else
            v23 = projectileModel;
        end;
    end;

    if not v23 then
        return;
    end;

    local v25 = skillRunData.material and skillRunData.material["毒气弹_爆炸"];

    if v25 then
        v25.Parent = workspace.Debris;
        local _, v26 = SkillCommon.scaleDualFromData(p15, SkillCommon.bandScaleOptsFromSkillData(p15));

        if v25:IsA("Model") then
            v25:ScaleTo(v26);
        end;
    end;

    local v27 = buildParabolicCurve(Position, v17);
    skillRunData.Logic.hasExploded = false;
    skillRunData.Logic.impactPosition = v17;
    local v28 = BezierCurve.MultiOrderBezierCurves({
        Frame = 10,
        FPS = 60,
        Points = v27,
        Target = v23,
        EasingStyle = Enum.EasingStyle.Sine,
        EasingDirection = Enum.EasingDirection.In
    }, function() -- Line: 287
    end);
    skillRunData.Visual.projectileMotion = v28;
    table.insert(skillRunData.runEvent, v28);
    local pendingProjectileHitEvent = skillRunData.Visual.pendingProjectileHitEvent;

    if pendingProjectileHitEvent then
        skillRunData.Visual.pendingProjectileHitEvent = nil;
        v28:Disconnect();
        skillRunData.Visual.projectileMotion = nil;
        u1.onServerEvent(p15, pendingProjectileHitEvent);
    end;
end;

function u1.Client_ExitProjectileFlying(p29) -- Line: 300
    -- upvalues: SkillCommon (copy)
    local skillRunData = p29.skillRunData;

    if skillRunData and (skillRunData.Visual and skillRunData.Visual.projectileMotion) then
        skillRunData.Visual.projectileMotion:Disconnect();
        skillRunData.Visual.projectileMotion = nil;
    end;

    if skillRunData then
        SkillCommon.clearSpawnIfTerminalAfterExit(p29, p29.runGeneration, skillRunData, "GasBombSpawned");
    end;
end;

function u1.Server_EnterProjectileFlying(u30) -- Line: 313
    -- upvalues: PlayerAimSync (copy), SkillCommon (copy), u2 (copy), buildParabolicCurve (copy), BezierCurve (copy), SkillEventConst (copy), ProjectileImpact (copy)
    PlayerAimSync.refreshAimSnapshot(u30);
    local v31 = u30.hitbox[1];

    if not (v31 and v31.hitbox) then
        return;
    end;

    local v32 = u30.skillInputData and u30.skillInputData.character;

    if v32 then
        v32 = v32:FindFirstChild("HumanoidRootPart");
    end;

    if not v32 then
        return;
    end;

    local skillRunData = u30.skillRunData;
    skillRunData.Logic = skillRunData.Logic or {};
    skillRunData.Logic.hasExploded = false;
    local u33 = SkillCommon.resolveStrikeWorldPos(u30.skillInputData);
    local Position = SkillCommon.formationCFHorizontal(v32, u33, u2).Position;
    local v34 = u33 - Position;
    local v35;

    if v34.Magnitude < 0.05 then
        v35 = CFrame.new(Position);
    else
        v35 = CFrame.lookAt(Position, Position + v34.Unit);
    end;

    local hitbox = v31.hitbox;
    skillRunData.Logic.projectileLastPosition = v35.Position;
    hitbox:PivotTo(v35);
    local v36 = buildParabolicCurve(Position, u33);
    skillRunData.Logic.impactPosition = u33;
    local v37 = BezierCurve.MultiOrderBezierCurves({
        Frame = 10,
        FPS = 60,
        Points = v36,
        Target = hitbox,
        EasingStyle = Enum.EasingStyle.Sine,
        EasingDirection = Enum.EasingDirection.In
    }, function() -- Line: 354
        -- upvalues: SkillEventConst (ref), u33 (copy), ProjectileImpact (ref), u30 (copy)
        ProjectileImpact.resolveImpact(u30, {
            type = SkillEventConst.HitType.Timeout,
            position = u33,
            source = ProjectileImpact.ImpactSource.Lifetime
        });
    end);
    skillRunData.Logic.projectileHitboxMotion = v37;
    table.insert(skillRunData.runEvent, v37);
end;

function u1.Server_ExitProjectileFlying(p38) -- Line: 366
    local skillRunData = p38.skillRunData;

    if skillRunData and (skillRunData.Logic and skillRunData.Logic.projectileHitboxMotion) then
        skillRunData.Logic.projectileHitboxMotion:Disconnect();
        skillRunData.Logic.projectileHitboxMotion = nil;
    end;

    local v39 = p38.hitbox[1];

    if v39 and v39.isActive then
        v39:stop();
    end;

    if v39 and v39.hitbox then
        v39.hitbox.Transparency = 1;
    end;
end;

function u1.Client_EnterExploding(p40, p41) -- Line: 382
    -- upvalues: FXUtil (copy), SkillCommon (copy)
    local v42 = p41 and p41.hitPosition or p40.skillRunData.Logic and p40.skillRunData.Logic.impactPosition;

    if not v42 then
        return;
    end;

    local skillRunData = p40.skillRunData;
    local runGeneration = p40.runGeneration;
    local u43 = skillRunData.Visual and skillRunData.Visual.projectileModel;
    local v44 = skillRunData.material and skillRunData.material["毒气弹_爆炸"];

    if u43 and u43.Parent then
        u43:PivotTo(CFrame.new(v42) * u43:GetPivot().Rotation);
    end;

    if v44 then
        if v44:IsA("Model") then
            v44:PivotTo(CFrame.new(v42));
        elseif v44:IsA("BasePart") then
            v44.CFrame = CFrame.new(v42);
        end;

        FXUtil.Emit_Particles_GetDescendants(v44, true);
        SkillCommon.playSoundLocal3D("音效-技能-毒气弹-攻击", v42);
    end;

    if u43 and (u43:IsA("Model") and u43.Parent) then
        FXUtil.SetEmittersTrailsBeamsEnabled(u43, false);
        FXUtil.Stop_All_Emit(u43);
        task.delay(0.017, function() -- Line: 411
            -- upvalues: u43 (copy), FXUtil (ref)
            if u43.Parent then
                FXUtil.FadeModel_KeepTrails(u43, 0.12, 1);
            end;
        end);
    end;

    if skillRunData.Visual then
        skillRunData.Visual.projectileModel = nil;
    end;

    SkillCommon.scheduleRunSpawnClear(p40, runGeneration, skillRunData, "GasBombSpawned", 1.2);
end;

function u1.Client_ExitExploding(p45) -- Line: 425
    -- upvalues: SkillCommon (copy)
    local skillRunData = p45.skillRunData;

    if skillRunData then
        SkillCommon.clearSpawnIfTerminalAfterExit(p45, p45.runGeneration, skillRunData, "GasBombSpawned");
    end;
end;

function u1.Server_EnterExploding(p46, p47) -- Line: 432
    -- upvalues: SkillCommon (copy), SkillEventConst (copy)
    local _, v48 = SkillCommon.scaleDualFromData(p46, SkillCommon.bandScaleOptsFromSkillData(p46));
    local v49 = p47 and p47.hitPosition or p46.skillRunData.Logic and p46.skillRunData.Logic.impactPosition;

    if not v49 then
        return;
    end;

    local u50 = p46.hitbox[1];

    if u50 and u50.hitbox then
        local hitbox = u50.hitbox;

        if hitbox:IsA("BasePart") then
            hitbox.Shape = Enum.PartType.Ball;
        end;

        hitbox.Size = Vector3.new(4, 4, 4) * v48;
        hitbox:PivotTo(CFrame.new(v49));
        u50:start(true);
        task.delay(0.14, function() -- Line: 449
            -- upvalues: u50 (copy), hitbox (copy)
            if u50.isActive then
                u50:stop();
                hitbox.Transparency = 1;
            end;
        end);
    end;

    p46:fireProjectileHitConfirmed(v49, p46.skillRunData.Logic.impactType or SkillEventConst.HitType.Timeout, p46.skillRunData.Logic.impactTargetId);
end;

function u1.Server_EnterRecovery(p51) -- Line: 465
    p51:releaseControl();
end;

function u1.Client_EnterRecovery(p52) -- Line: 469
    -- upvalues: SkillCommon (copy)
    local skillRunData = p52.skillRunData;

    if skillRunData then
        SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "毒系尾迹", "毒气弹Cast尾迹");
    end;
end;

function u1.onEnd(p53) -- Line: 476
    -- upvalues: SkillCommon (copy)
    local skillRunData = p53.skillRunData;

    if skillRunData then
        SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "毒系尾迹", "毒气弹Cast尾迹");
    end;
end;

function u1.onEndServer(p54) -- Line: 483
    local v55 = p54.hitbox[1];

    if v55 and v55.isActive then
        v55:stop();
    end;
end;

function u1.onServerEvent(p56, p57) -- Line: 490
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

    local v58 = p57.hitType == SkillEventConst.HitType.Obstacle and SkillEventConst.ObstacleHit or SkillEventConst.Timeout;

    if p56.GetCurrentState and p56:GetCurrentState() == "ProjectileFlying" then
        p56:TryTransition(v58, {
            hitPosition = hitPosition,
            hitType = p57.hitType,
            targetId = p57.targetId
        });

        return;
    end;

    skillRunData.Visual = skillRunData.Visual or {};
    skillRunData.Visual.pendingProjectileHitEvent = p57;
end;

function u1.onProjectileHitServer(p59, p60, p61) -- Line: 518
    if not p60 or p60.hitboxIndex ~= 1 then
        return;
    end;

    local skillRunData = p59.skillRunData;

    if not skillRunData or (not skillRunData.State or skillRunData.State.current ~= "Exploding") then
        return;
    end;

    local HitResolver = require(script.Parent.Parent.BaseSkill.HitResolver);

    for i, v in p61 do
        HitResolver.applyHit(p59, p60, v, i);
    end;
end;

u1.SoundList = { "音效-技能-毒气弹-法阵", "音效-技能-毒气弹-攻击" };
u1.AnimateList = { "技能释放动作4" };
u1.ResNameList = { "毒系尾迹", "毒气弹_法阵", "毒气弹", "毒气弹_爆炸" };
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
        overTime = 0.73,
        speedType = "RELEASE_SKILL_STATE_HALF"
    },
    {
        action = "Animation",
        startTime = 0,
        overTime = 1.4,
        animationName = "技能释放动作4",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action4
    }
};

return u1;