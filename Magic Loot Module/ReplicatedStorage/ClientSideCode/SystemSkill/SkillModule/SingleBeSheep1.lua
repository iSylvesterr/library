-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local Workspace = game:GetService("Workspace");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
local SkillBuffUtil = UtilsSystem.SkillBuffUtil;
local FXUtil = UtilsSystem.FXUtil;
local VisibleMgr = UtilsSystem.VisibleMgr;
local BezierCurve = UtilsSystem.BezierCurve;
local RunService = UtilsSystem.RunService;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local ProjectileImpact = require(script.Parent._Templates.Projectile.ProjectileImpact);
local ProjectileObjectTracking = require(script.Parent._Templates.Projectile.ProjectileObjectTracking);
local ProjectileCore = require(script.Parent._Templates.Projectile.ProjectileCore);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local PlayerAimSync = require(script.Parent.Parent.BaseSkill.PlayerAimSync);
local u1 = {
    enabled = true,
    curveRefreshInterval = 0,
    objectValueName = ProjectileObjectTracking.DEFAULT_OV_NAME,
    objectValuePathSegments = {}
};
local u2 = ProjectileCore.create({
    flySpeed = 70,
    maxFlyTime = 1,
    bezierSeed = 10000,
    stopOnObstacle = true
});
local u3 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.Space,
    skillDistanceLimit = 55,
    InitialState = "Startup",
    ControlOpenState = "ProjectileFlying",
    Server_UpdateProjectileObstacleCheck = u2.createObstacleCheck(),
    States = {
        Startup = {
            Duration = 0.47,
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
        Impact = {
            Duration = 0.3,
            OnEnterClient = "Client_EnterImpact",
            OnEnterServer = "Server_EnterImpact"
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
    },
    Transitions = {
        {
            From = "Startup",
            To = "ProjectileFlying",
            Event = SkillEventConst.StateTimeout
        },
        {
            From = "ProjectileFlying",
            To = "Impact",
            Event = SkillEventConst.EnemyHit
        },
        {
            From = "ProjectileFlying",
            To = "Impact",
            Event = SkillEventConst.ObstacleHit
        },
        {
            From = "ProjectileFlying",
            To = "Impact",
            Event = SkillEventConst.Timeout
        },
        {
            From = "Impact",
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
            From = "Impact",
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
            From = "Impact",
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

local function lowArcHeight(p4, p5) -- Line: 104
    return math.clamp((p5 - p4).Magnitude * 0.1, 1.5, 5);
end;

local function startLowArcFlight(p6, p7, p8, u9, u10) -- Line: 111
    -- upvalues: ProjectileObjectTracking (copy), u1 (copy), u2 (copy), ProjectileCore (copy), lowArcHeight (copy), BezierCurve (copy)
    local u11 = p6.character or p6.skillInputData and p6.skillInputData.character;
    local v12 = p6.skillInputData and p6.skillInputData.trackTargetId;
    local _, v13, v14 = ProjectileObjectTracking.resolveAtCast(v12, u11, u1);
    local u15 = v12 or v14;
    local v16 = u2.getProjectileEndCF(p6);
    local u17;

    if v13 then
        u17 = ProjectileCore.clampProjectileEndToMaxRange(p8.Position, v13, 70, 1);
    else
        u17 = v16 and v16.Position or p8.Position;
    end;

    if u15 ~= nil and (u15 ~= "" and v13) then
        return ProjectileCore.runTrackedBezierMotion(p7, {
            flySpeed = 70,
            maxFlyTime = 1,
            bezierSeed = 10000,
            middlePointCount = 2,
            curveRefreshInterval = 0,
            sideOffsetRandom = 0,
            startCF = p8,
            initialEndPosition = u17,
            getHeightOffset = lowArcHeight,

            getTrackedEndPosition = function() -- Line: 138, Name: getTrackedEndPosition
                -- upvalues: u9 (copy), ProjectileObjectTracking (ref), u15 (copy), u11 (copy), u1 (ref)
                if u9 then
                    return ProjectileObjectTracking.getWorldPositionByTrackTargetId(u15);
                end;

                return ProjectileObjectTracking.getLiveTrackedWorldPosition(u15, u11, u1);
            end
        }, u10);
    end;

    local v18 = math.min((u17 - p8.Position).Magnitude / 70, 1);
    local v19 = BezierCurve.GenerateBezierPoints(p8.Position, u17, 2, {
        RandomSeed = 10000,
        HeightOffsetRandom = 0,
        SideOffsetRandom = 0,
        HeightOffset = math.clamp((u17 - p8.Position).Magnitude * 0.1, 1.5, 5),
        EasingStyle = Enum.EasingStyle.Quad,
        EasingDirection = Enum.EasingDirection.Out
    });

    return u2.runBezierMotion(p7, v19, math.max(v18 * 60, 1), 60, function() -- Line: 157
        -- upvalues: u10 (copy), u17 (copy)
        if u10 then
            u10(u17);
        end;
    end);
end;

function u3.Client_EnterStartup(p20) -- Line: 165
    -- upvalues: SkillCommon (copy)
    local v21 = p20.skillInputData and p20.skillInputData.character;

    if v21 then
        v21 = SkillCommon.resolveWandTipFromCharacter(v21);
    end;

    if v21 then
        SkillCommon.scheduleWandTipElementTrail(p20, v21, {
            trailMaterialKey = "空间系尾迹",
            runEventKey = "单体变羊术Cast尾迹",
            enableAt = 0.27,
            disableAt = 0.47
        });
    end;
end;

function u3.Server_EnterStartup(p22) -- Line: 178
    local v23 = p22.hitbox[1];

    if v23 then
        v23 = v23.hitbox;
    end;

    if v23 and v23:IsA("BasePart") then
        v23.Shape = Enum.PartType.Block;
        v23.Size = Vector3.new(2, 2, 2);
        v23:PivotTo(CFrame.new(0, -5000, 0));
    end;
end;

function u3.Client_EnterProjectileFlying(u24) -- Line: 189
    -- upvalues: PlayerAimSync (copy), SkillCommon (copy), SkillBuffUtil (copy), u2 (copy), VisibleMgr (copy), Workspace (copy), FXUtil (copy), RunService (copy), startLowArcFlight (copy), u3 (copy)
    PlayerAimSync.refreshAimSnapshot(u24);
    local v25 = u24.skillInputData and u24.skillInputData.character;
    local skillRunData = u24.skillRunData;

    if not (v25 and skillRunData) then
        return;
    end;

    skillRunData.Visual = skillRunData.Visual or {};
    skillRunData.Logic = skillRunData.Logic or {};
    SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "空间系尾迹", "单体变羊术Cast尾迹");
    SkillBuffUtil.PlayBeSheepCasterSuccessFxFromMaterial(skillRunData.material, v25);
    local u26 = skillRunData.material and skillRunData.material["变羊术_小羊"];

    if not (u26 and u26:IsA("Model")) then
        return;
    end;

    skillRunData.material["变羊术_小羊"] = nil;
    local runGeneration = u24.runGeneration;
    local v27 = u2.getProjectileStartCF(u24);
    local _, u28 = SkillCommon.scaleDualFromData(u24, SkillCommon.bandScaleOptsFromSkillData(u24));
    VisibleMgr.UnCollideAll(u26);
    VisibleMgr.UnTouchAll(u26);
    VisibleMgr.UnQueryAll(u26);
    VisibleMgr.UnTransparencyAll(u26);
    u26:ScaleTo((math.max(u28 * 0.0001, 0.0001)));
    u26:PivotTo(v27);
    u26.Parent = Workspace:FindFirstChild("Debris") or Workspace;
    skillRunData.Visual.projectileModel = u26;
    SkillCommon.appendRunSpawnList(skillRunData, "SingleBeSheepSpawned", u26);
    FXUtil.Model_Fade_In(u26, 0.083, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0);
    FXUtil.Model_Scale_Tween(u26, math.max(u28 * 0.0001, 0.0001), u28, 0.083, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, function() -- Line: 223
        -- upvalues: u26 (copy), u28 (copy)
        if u26.Parent then
            u26:ScaleTo(u28);
        end;
    end, true);
    local u29 = SkillCommon.resolveWandTipFromCharacter(v25);

    if u29 then
        skillRunData.runEvent = skillRunData.runEvent or {};
        skillRunData.runEvent["单体变羊术现身跟杖"] = RunService.RenderStepped:Connect(function() -- Line: 232
            -- upvalues: u24 (copy), runGeneration (copy), u26 (copy), SkillCommon (ref), u29 (copy)
            if not u24:isRunningFlow() or (u24.runGeneration ~= runGeneration or not u26.Parent) then
                return;
            end;

            local v30 = SkillCommon.resolveWandTipWorldCFrame(u29);

            if not v30 then
                return;
            end;

            local v31 = u24.skillInputData and u24.skillInputData.targetCF;

            if v31 then
                v30 = CFrame.lookAt(v30.Position, v31.Position);
            end;

            u26:PivotTo(v30);
        end);
    end;

    task.delay(0.083, function() -- Line: 245
        -- upvalues: u24 (copy), runGeneration (copy), SkillCommon (ref), skillRunData (copy), u26 (copy), FXUtil (ref), startLowArcFlight (ref), u3 (ref)
        if not u24:isRunningFlow() or u24.runGeneration ~= runGeneration then
            return;
        end;

        if u24.GetCurrentState and u24:GetCurrentState() ~= "ProjectileFlying" then
            return;
        end;

        SkillCommon.disconnectRunEventKeys(skillRunData, { "单体变羊术现身跟杖" });

        if not u26.Parent then
            return;
        end;

        FXUtil.SetEmittersTrailsBeamsEnabled(u26, true);
        skillRunData.Logic.hasExploded = false;
        local v32 = startLowArcFlight(u24, u26, u26:GetPivot(), false, nil);
        skillRunData.Visual.projectileMotion = v32;

        if v32 then
            table.insert(skillRunData.runEvent, v32);
        end;

        local pendingProjectileHitEvent = skillRunData.Visual.pendingProjectileHitEvent;

        if pendingProjectileHitEvent then
            skillRunData.Visual.pendingProjectileHitEvent = nil;

            if v32 then
                v32:Disconnect();
            end;

            skillRunData.Visual.projectileMotion = nil;
            u3.onServerEvent(u24, pendingProjectileHitEvent);
        end;
    end);
end;

function u3.Client_ExitProjectileFlying(p33) -- Line: 277
    -- upvalues: SkillCommon (copy)
    local skillRunData = p33.skillRunData;

    if not skillRunData then
        return;
    end;

    SkillCommon.disconnectRunEventKeys(skillRunData, { "单体变羊术现身跟杖" });

    if skillRunData.Visual and skillRunData.Visual.projectileMotion then
        skillRunData.Visual.projectileMotion:Disconnect();
        skillRunData.Visual.projectileMotion = nil;
    end;

    SkillCommon.clearSpawnIfTerminalAfterExit(p33, p33.runGeneration, skillRunData, "SingleBeSheepSpawned");
end;

function u3.Server_EnterProjectileFlying(u34) -- Line: 290
    -- upvalues: PlayerAimSync (copy), u2 (copy), startLowArcFlight (copy), ProjectileImpact (copy), SkillEventConst (copy)
    PlayerAimSync.refreshAimSnapshot(u34);
    local u35 = u34.hitbox[1];

    if not (u35 and u35.hitbox) then
        return;
    end;

    local skillRunData = u34.skillRunData;
    skillRunData.Logic = skillRunData.Logic or {};
    skillRunData.Logic.hasExploded = false;
    local runGeneration = u34.runGeneration;
    task.delay(0.083, function() -- Line: 301
        -- upvalues: u34 (copy), runGeneration (copy), u2 (ref), u35 (copy), startLowArcFlight (ref), ProjectileImpact (ref), SkillEventConst (ref)
        local skillRunData2 = u34.skillRunData;

        if not skillRunData2 or u34.runGeneration ~= runGeneration then
            return;
        end;

        if skillRunData2.State.current ~= "ProjectileFlying" or skillRunData2.Logic.hasExploded then
            return;
        end;

        local v36 = u2.getProjectileStartCF(u34);
        local hitbox = u35.hitbox;
        skillRunData2.Logic.projectileLastPosition = v36.Position;
        hitbox:PivotTo(v36);
        u35:start();
        local v38 = startLowArcFlight(u34, hitbox, v36, true, function(p37) -- Line: 316
            -- upvalues: ProjectileImpact (ref), u34 (ref), SkillEventConst (ref)
            ProjectileImpact.resolveImpact(u34, {
                type = SkillEventConst.HitType.Timeout,
                position = p37,
                source = ProjectileImpact.ImpactSource.Motion
            });
        end);
        skillRunData2.Logic.projectileHitboxMotion = v38;

        if v38 then
            table.insert(skillRunData2.runEvent, v38);
        end;
    end);
end;

function u3.Server_ExitProjectileFlying(p39) -- Line: 330
    local skillRunData = p39.skillRunData;

    if skillRunData and (skillRunData.Logic and skillRunData.Logic.projectileHitboxMotion) then
        skillRunData.Logic.projectileHitboxMotion:Disconnect();
        skillRunData.Logic.projectileHitboxMotion = nil;
    end;

    local v40 = p39.hitbox[1];

    if v40 and v40.isActive then
        v40:stop();
    end;

    if v40 and v40.hitbox then
        v40.hitbox.Transparency = 1;
    end;
end;

function u3.onProjectileImpact(p41, p42) -- Line: 345
    local skillRunData = p41.skillRunData;

    if skillRunData then
        skillRunData.Logic = skillRunData.Logic or {};

        if p42 then
            p42 = p42._target;
        end;

        skillRunData.Logic.impactEnemyModel = p42;
    end;
end;

function u3.Client_EnterImpact(p43, p44) -- Line: 354
    -- upvalues: FXUtil (copy), SkillCommon (copy)
    local v45 = p44 and p44.hitPosition or p43.skillRunData.Logic and p43.skillRunData.Logic.impactPosition;
    local skillRunData = p43.skillRunData;
    local u46 = skillRunData and skillRunData.Visual and skillRunData.Visual.projectileModel;

    if not (v45 and (u46 and (u46:IsA("Model") and u46.Parent))) then
        return;
    end;

    u46:PivotTo(CFrame.new(v45) * u46:GetPivot().Rotation);
    FXUtil.FadeModel_KeepTrails(u46, 0.1, 0);
    skillRunData.Visual.projectileModel = nil;
    task.delay(2, function() -- Line: 365
        -- upvalues: u46 (copy), SkillCommon (ref), skillRunData (copy)
        if u46.Parent then
            SkillCommon.returnPooledModelFromSpawnList(skillRunData, "SingleBeSheepSpawned", u46);
        end;
    end);
end;

function u3.Server_EnterImpact(p47, p48) -- Line: 372
    -- upvalues: SkillEventConst (copy), Players (copy), SkillBuffUtil (copy)
    local v49 = p48 and p48.hitPosition or p47.skillRunData.Logic and p47.skillRunData.Logic.impactPosition;

    if not v49 then
        return;
    end;

    local skillRunData = p47.skillRunData;
    p47:fireProjectileHitConfirmed(v49, skillRunData and skillRunData.Logic and skillRunData.Logic.impactType or SkillEventConst.HitType.Timeout, skillRunData and skillRunData.Logic and skillRunData.Logic.impactTargetId);
    local v50 = skillRunData and skillRunData.Logic and skillRunData.Logic.impactEnemyModel;
    local v51 = p47.skillInputData and p47.skillInputData.character;

    if v51 then
        v51 = Players:GetPlayerFromCharacter(v51);
    end;

    if not (v50 and v51) then
        return;
    end;

    SkillBuffUtil.TryApplyBeSheepToEnemy(v50, p47.skillID, {
        attacker = v51,
        casterUserId = v51.UserId,
        attackerPlayerId = v51.UserId
    }, "好像对他们不起作用呢");
end;

function u3.Server_EnterRecovery(p52) -- Line: 399
    p52:releaseControl();
end;

function u3.Client_EnterRecovery(p53) -- Line: 403
    -- upvalues: SkillCommon (copy)
    local skillRunData = p53.skillRunData;

    if skillRunData then
        SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "空间系尾迹", "单体变羊术Cast尾迹");
    end;
end;

function u3.onEnd(p54) -- Line: 410
    -- upvalues: SkillCommon (copy)
    local skillRunData = p54.skillRunData;

    if skillRunData then
        SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "空间系尾迹", "单体变羊术Cast尾迹");
        SkillCommon.disconnectRunEventKeys(skillRunData, { "单体变羊术现身跟杖" });
    end;
end;

function u3.onEndServer(p55) -- Line: 418
    local v56 = p55.hitbox[1];

    if v56 and v56.isActive then
        v56:stop();
    end;
end;

function u3.onServerEvent(p57, p58) -- Line: 425
    -- upvalues: SkillEventConst (copy)
    if p58.eventType ~= SkillEventConst.SyncEventType.ProjectileHitConfirmed then
        return;
    end;

    local skillRunData = p57.skillRunData;
    local hitPosition = p58.hitPosition;

    if not (skillRunData and hitPosition) then
        return;
    end;

    local v59 = p58.hitType == SkillEventConst.HitType.Obstacle and SkillEventConst.ObstacleHit or (p58.hitType == SkillEventConst.HitType.Timeout and SkillEventConst.Timeout or SkillEventConst.EnemyHit);

    if p57.GetCurrentState and p57:GetCurrentState() == "ProjectileFlying" then
        p57:TryTransition(v59, {
            hitPosition = hitPosition,
            hitType = p58.hitType,
            targetId = p58.targetId
        });

        return;
    end;

    skillRunData.Visual = skillRunData.Visual or {};
    skillRunData.Visual.pendingProjectileHitEvent = p58;
end;

function u3.onProjectileHitServer(p60, p61, p62) -- Line: 448
    -- upvalues: ProjectileImpact (copy), SkillEventConst (copy)
    if not p61 or (p61.hitboxIndex ~= 1 or not p61.isActive) then
        return;
    end;

    local skillRunData = p60.skillRunData;

    if not skillRunData or (not skillRunData.State or skillRunData.State.current ~= "ProjectileFlying") then
        return;
    end;

    local v63, v64 = next(p62);

    if not (v63 and v64) then
        return;
    end;

    ProjectileImpact.resolveImpact(p60, {
        type = SkillEventConst.HitType.Enemy,
        position = v64.Position,
        target = v63,
        hitResult = p62,
        source = ProjectileImpact.ImpactSource.Hitbox
    });
end;

u3.SoundList = {};
u3.AnimateList = { "技能释放动作3" };
u3.ResNameList = { "空间系尾迹", "变羊术_小羊", "变羊术_成功特效", "变羊_羊出现特效" };
u3.hitboxConfig = { {
        HitboxIndex = 1,
        PartName = "通用长方体",
        CollisionGroup = "Player",
        HitPresentationProfile = "通用受击",
        PhysicsEffectName = "通用受击物理效果"
    } };
u3.Action = {
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

return u3;