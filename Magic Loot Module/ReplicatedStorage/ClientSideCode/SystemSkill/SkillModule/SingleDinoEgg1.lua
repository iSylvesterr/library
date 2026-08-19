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
local TipsModule = UtilsSystem.TipsModule;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local ProjectileImpact = require(script.Parent._Templates.Projectile.ProjectileImpact);
local ProjectileObjectTracking = require(script.Parent._Templates.Projectile.ProjectileObjectTracking);
local ProjectileCore = require(script.Parent._Templates.Projectile.ProjectileCore);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local PlayerAimSync = require(script.Parent.Parent.BaseSkill.PlayerAimSync);
local HitResolver = require(script.Parent.Parent.BaseSkill.HitResolver);
local u1 = {
    enabled = true,
    curveRefreshInterval = 0,
    objectValueName = ProjectileObjectTracking.DEFAULT_OV_NAME,
    objectValuePathSegments = {}
};
local u2 = ProjectileCore.create({
    flySpeed = 200,
    maxFlyTime = 0.11666666666666667,
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
        EggShow = {
            Duration = 1.1333333333333333,
            OnEnterClient = "Client_EnterEggShow",
            OnEnterServer = "Server_EnterEggShow",
            OnExitClient = "Client_ExitEggShow",
            OnExitServer = "Server_ExitEggShow"
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
            To = "EggShow",
            Event = SkillEventConst.EnemyHit
        },
        {
            From = "ProjectileFlying",
            To = "EggShow",
            Event = SkillEventConst.ObstacleHit
        },
        {
            From = "ProjectileFlying",
            To = "EggShow",
            Event = SkillEventConst.Timeout
        },
        {
            From = "EggShow",
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
            From = "EggShow",
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
            From = "EggShow",
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

local function startFixedFlight(p4, p5, p6, u7) -- Line: 128
    -- upvalues: ProjectileObjectTracking (copy), u1 (copy), u2 (copy), BezierCurve (copy)
    local _, v8 = ProjectileObjectTracking.resolveAtCast(p4.skillInputData and p4.skillInputData.trackTargetId, p4.character or p4.skillInputData and p4.skillInputData.character, u1);
    local v9 = u2.getProjectileEndCF(p4);
    local u10 = v8 or (v9 and v9.Position or p6.Position);
    local v11 = BezierCurve.GenerateBezierPoints(p6.Position, u10, 2, {
        RandomSeed = 10000,
        HeightOffsetRandom = 0,
        SideOffsetRandom = 0,
        HeightOffset = math.clamp((u10 - p6.Position).Magnitude * 0.08, 0.5, 2),
        EasingStyle = Enum.EasingStyle.Quad,
        EasingDirection = Enum.EasingDirection.Out
    });

    return u2.runBezierMotion(p5, v11, 7, 60, function() -- Line: 147
        -- upvalues: u7 (copy), u10 (copy)
        if u7 then
            u7(u10);
        end;
    end);
end;

local function takeMaterialEmitOnce(u12, p13, p14, p15) -- Line: 163
    -- upvalues: Workspace (copy), SkillCommon (copy), FXUtil (copy)
    local u16 = u12.material and u12.material[p13];

    if not (u16 and u16:IsA("Model")) then
        return nil;
    end;

    u12.material[p13] = nil;

    if p15 then
        u16:ScaleTo((math.max(p15, 0.0001)));
    end;

    u16:PivotTo(p14);
    u16.Parent = Workspace:FindFirstChild("Debris") or Workspace;
    SkillCommon.appendRunSpawnList(u12, "SingleDinoEggSpawned", u16);
    FXUtil.Emit_Particles_GetDescendants(u16, true);
    task.delay(2, function() -- Line: 176
        -- upvalues: u16 (copy), SkillCommon (ref), u12 (copy)
        if u16.Parent then
            SkillCommon.returnPooledModelFromSpawnList(u12, "SingleDinoEggSpawned", u16);
        end;
    end);

    return u16;
end;

local function restoreEnemyVisual(p17) -- Line: 190
    -- upvalues: SkillCommon (copy)
    if not p17 then
        return;
    end;

    SkillCommon.disconnectRunEventKeys(p17, { "变恐龙蛋缩怪" });
    local Visual = p17.Visual;

    if not Visual then
        return;
    end;

    local eggEnemyModel = Visual.eggEnemyModel;
    local _ = Visual.eggEnemyOrigScale;

    if not eggEnemyModel then
        Visual.eggEnemyOrigScale = nil;

        return;
    end;

    if not eggEnemyModel.Parent then
        return;
    end;

    Visual.eggEnemyModel = nil;
    Visual.eggEnemyOrigScale = nil;
end;

local function sampleEggTiltDeg(p18) -- Line: 224
    local v19 = { { 0.21666666666666667, 0 }, { 0.3333333333333333, -25 }, { 0.4666666666666667, 25 }, { 0.5833333333333334, -25 }, { 0.7166666666666667, 25 }, { 0.8666666666666667, -25 }, { 1, 25 }, { 1.1, 0 } };
    local v20 = v19[1][1];
    local v21 = v19[1][2];

    for i = 2, #v19 do
        local v22 = v19[i][1];
        local v23 = v19[i][2];

        if p18 <= v22 then
            local v24 = v22 - v20;
            local v25 = v24 <= 0 and 1 or math.clamp((p18 - v20) / v24, 0, 1);

            return v21 + (v23 - v21) * v25;
        end;

        v21 = v23;
        v20 = v22;
    end;

    return v19[#v19][2];
end;

local function placeEggStandingOnGround(u26, p27, p28) -- Line: 257
    u26:PivotTo(CFrame.new(p27) * CFrame.Angles(0, 0, (math.rad(p28 or 0))));
    local v29 = u26:FindFirstChild("锚点", true);

    if v29 and v29:IsA("BasePart") then
        local Y = (v29.CFrame * CFrame.new(0, -v29.Size.Y * 0.5, 0)).Position.Y;
        u26:PivotTo(u26:GetPivot() + Vector3.new(0, p27.Y - Y, 0));

        return;
    end;

    local v30, v31, v32 = pcall(function() -- Line: 267
        -- upvalues: u26 (copy)
        return u26:GetBoundingBox();
    end);

    if v30 and (v31 and v32) then
        local v33 = v31.Position.Y - v32.Y * 0.5;
        u26:PivotTo(u26:GetPivot() + Vector3.new(0, p27.Y - v33, 0));
    end;
end;

local function ensureEggAnchorHidden(p34) -- Line: 280
    local v35 = p34:FindFirstChild("锚点", true);

    if v35 and v35:IsA("BasePart") then
        v35.Transparency = 1;
        v35.CanCollide = false;
        v35.CanQuery = false;
        v35.CanTouch = false;
    end;
end;

local function getEggMainNodeWorldPos(p36) -- Line: 295
    local PrimaryPart = p36.PrimaryPart;

    if PrimaryPart and PrimaryPart:IsA("BasePart") then
        return PrimaryPart.Position;
    end;

    local v37 = p36:FindFirstChild("锚点", true);

    if v37 and v37:IsA("BasePart") then
        return v37.Position;
    end;

    return p36:GetPivot().Position;
end;

function u3.Client_EnterStartup(p38) -- Line: 308
    -- upvalues: SkillCommon (copy)
    local v39 = p38.skillInputData and p38.skillInputData.character;

    if v39 then
        v39 = SkillCommon.resolveWandTipFromCharacter(v39);
    end;

    if v39 then
        SkillCommon.scheduleWandTipElementTrail(p38, v39, {
            trailMaterialKey = "空间系尾迹",
            runEventKey = "变恐龙蛋Cast尾迹",
            enableAt = 0.27,
            disableAt = 0.47
        });
    end;
end;

function u3.Server_EnterStartup(p40) -- Line: 322
    local v41 = p40.hitbox[1];
    local v42 = p40.hitbox[2];
    local v43 = p40.hitbox[3];

    if v41 and v41.hitbox then
        v41.hitbox.Shape = Enum.PartType.Block;
        v41.hitbox.Size = Vector3.new(2, 2, 2);
        v41.hitbox:PivotTo(CFrame.new(0, -5000, 0));
    end;

    if v42 and v42.hitbox then
        v42.hitbox.Shape = Enum.PartType.Ball;
        v42.hitbox.Size = Vector3.new(0.5, 0.5, 0.5);
        v42.hitbox:PivotTo(CFrame.new(0, -5000, 0));
    end;

    if v43 and v43.hitbox then
        v43.hitbox.Shape = Enum.PartType.Ball;
        v43.hitbox.Size = Vector3.new(45, 45, 45);
        v43.hitbox:PivotTo(CFrame.new(0, -5000, 0));
    end;
end;

function u3.Client_EnterProjectileFlying(p44) -- Line: 346
    -- upvalues: PlayerAimSync (copy), SkillCommon (copy), u2 (copy), takeMaterialEmitOnce (copy), Workspace (copy), FXUtil (copy), startFixedFlight (copy), u3 (copy)
    PlayerAimSync.refreshAimSnapshot(p44);
    local skillRunData = p44.skillRunData;

    if not (p44.skillInputData and p44.skillInputData.character and skillRunData) then
        return;
    end;

    skillRunData.Visual = skillRunData.Visual or {};
    skillRunData.Logic = skillRunData.Logic or {};
    SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "空间系尾迹", "变恐龙蛋Cast尾迹");
    local v45 = u2.getProjectileStartCF(p44);
    local _, v46 = SkillCommon.scaleDualFromData(p44, SkillCommon.bandScaleOptsFromSkillData(p44));
    takeMaterialEmitOnce(skillRunData, "变恐龙蛋_起手特效", v45, v46);
    local v47 = skillRunData.material and skillRunData.material["变恐龙蛋_发射物特效"];

    if not (v47 and v47:IsA("Model")) then
        return;
    end;

    skillRunData.material["变恐龙蛋_发射物特效"] = nil;
    v47:ScaleTo((math.max(v46, 0.0001)));
    v47:PivotTo(v45);
    v47.Parent = Workspace:FindFirstChild("Debris") or Workspace;
    skillRunData.Visual.projectileModel = v47;
    SkillCommon.appendRunSpawnList(skillRunData, "SingleDinoEggSpawned", v47);
    FXUtil.Emit_Particles_GetDescendants(v47, true);
    FXUtil.SetEmittersTrailsBeamsEnabled(v47, true);
    FXUtil.SetEnableNameVfx(v47, true);
    skillRunData.Logic.hasExploded = false;
    local v48 = startFixedFlight(p44, v47, v45, nil);
    skillRunData.Visual.projectileMotion = v48;

    if v48 then
        table.insert(skillRunData.runEvent, v48);
    end;

    local pendingProjectileHitEvent = skillRunData.Visual.pendingProjectileHitEvent;

    if pendingProjectileHitEvent then
        skillRunData.Visual.pendingProjectileHitEvent = nil;

        if v48 then
            v48:Disconnect();
        end;

        skillRunData.Visual.projectileMotion = nil;
        u3.onServerEvent(p44, pendingProjectileHitEvent);
    end;
end;

function u3.Client_ExitProjectileFlying(p49) -- Line: 398
    -- upvalues: SkillCommon (copy)
    local skillRunData = p49.skillRunData;

    if not skillRunData then
        return;
    end;

    if skillRunData.Visual and skillRunData.Visual.projectileMotion then
        skillRunData.Visual.projectileMotion:Disconnect();
        skillRunData.Visual.projectileMotion = nil;
    end;

    SkillCommon.clearSpawnIfTerminalAfterExit(p49, p49.runGeneration, skillRunData, "SingleDinoEggSpawned");
end;

function u3.Server_EnterProjectileFlying(u50) -- Line: 410
    -- upvalues: PlayerAimSync (copy), u2 (copy), startFixedFlight (copy), ProjectileObjectTracking (copy), u1 (copy), ProjectileImpact (copy), SkillEventConst (copy)
    PlayerAimSync.refreshAimSnapshot(u50);
    local v51 = u50.hitbox[1];

    if not (v51 and v51.hitbox) then
        return;
    end;

    local skillRunData = u50.skillRunData;
    skillRunData.Logic = skillRunData.Logic or {};
    skillRunData.Logic.hasExploded = false;
    local runGeneration = u50.runGeneration;
    local v52 = u2.getProjectileStartCF(u50);
    skillRunData.Logic.projectileLastPosition = v52.Position;
    v51.hitbox:PivotTo(v52);
    v51:start();
    local v57 = startFixedFlight(u50, v51.hitbox, v52, function(p53) -- Line: 426
        -- upvalues: u50 (copy), runGeneration (copy), ProjectileObjectTracking (ref), u1 (ref), ProjectileImpact (ref), SkillEventConst (ref)
        local skillRunData2 = u50.skillRunData;

        if not skillRunData2 or u50.runGeneration ~= runGeneration then
            return;
        end;

        if skillRunData2.State.current ~= "ProjectileFlying" or skillRunData2.Logic.hasExploded then
            return;
        end;

        local v54 = ProjectileObjectTracking.resolveAtCast(u50.skillInputData and u50.skillInputData.trackTargetId, u50.skillInputData and u50.skillInputData.character, u1);
        local resolveImpact = ProjectileImpact.resolveImpact;
        local v55 = {};
        local v56;

        if v54 then
            v56 = SkillEventConst.HitType.Enemy;
        else
            v56 = SkillEventConst.HitType.Timeout;
        end;

        v55.type = v56;
        v55.position = p53;
        v55.target = v54;
        v55.source = ProjectileImpact.ImpactSource.Motion;
        resolveImpact(u50, v55);
    end);
    skillRunData.Logic.projectileHitboxMotion = v57;

    if v57 then
        table.insert(skillRunData.runEvent, v57);
    end;
end;

function u3.Server_ExitProjectileFlying(p58) -- Line: 450
    local skillRunData = p58.skillRunData;

    if skillRunData and (skillRunData.Logic and skillRunData.Logic.projectileHitboxMotion) then
        skillRunData.Logic.projectileHitboxMotion:Disconnect();
        skillRunData.Logic.projectileHitboxMotion = nil;
    end;

    local v59 = p58.hitbox[1];

    if v59 and v59.isActive then
        v59:stop();
    end;

    if v59 and v59.hitbox then
        v59.hitbox.Transparency = 1;
    end;
end;

function u3.onProjectileImpact(p60, p61) -- Line: 465
    local skillRunData = p60.skillRunData;

    if skillRunData then
        skillRunData.Logic = skillRunData.Logic or {};

        if p61 then
            p61 = p61._target;
        end;

        skillRunData.Logic.impactEnemyModel = p61;
    end;
end;

function u3.Client_EnterEggShow(u62, p63) -- Line: 474
    -- upvalues: SkillCommon (copy), FXUtil (copy), ProjectileObjectTracking (copy), u1 (copy), SkillBuffUtil (copy), takeMaterialEmitOnce (copy), Workspace (copy), VisibleMgr (copy), placeEggStandingOnGround (copy), RunService (copy), sampleEggTiltDeg (copy), getEggMainNodeWorldPos (copy), restoreEnemyVisual (copy)
    local skillRunData = u62.skillRunData;

    if not skillRunData then
        return;
    end;

    skillRunData.Visual = skillRunData.Visual or {};
    skillRunData.Logic = skillRunData.Logic or {};
    local runGeneration = u62.runGeneration;
    local _, u64 = SkillCommon.scaleDualFromData(u62, SkillCommon.bandScaleOptsFromSkillData(u62));
    local u65 = p63 and p63.hitPosition or skillRunData.Logic and skillRunData.Logic.impactPosition;
    local projectileModel = skillRunData.Visual.projectileModel;

    if projectileModel and projectileModel.Parent then
        if u65 then
            projectileModel:PivotTo(CFrame.new(u65) * projectileModel:GetPivot().Rotation);
        end;

        FXUtil.SetEnableNameVfx(projectileModel, false);
        FXUtil.SetEmittersTrailsBeamsEnabled(projectileModel, false);
        FXUtil.FadeModel_KeepTrails(projectileModel, 0.1, 0);
        skillRunData.Visual.projectileModel = nil;
        task.delay(2, function() -- Line: 496
            -- upvalues: projectileModel (copy), SkillCommon (ref), skillRunData (copy)
            if projectileModel.Parent then
                SkillCommon.returnPooledModelFromSpawnList(skillRunData, "SingleDinoEggSpawned", projectileModel);
            end;
        end);
    end;

    local v66 = ProjectileObjectTracking.resolveAtCast(u62.skillInputData and u62.skillInputData.trackTargetId, u62.skillInputData and u62.skillInputData.character, u1);

    if not v66 and skillRunData.Logic.impactEnemyModel then
        v66 = skillRunData.Logic.impactEnemyModel;
    end;

    if not u65 then
        if v66 then
            u65 = ProjectileObjectTracking.getModelWorldPosition(v66, u1);
        else
            u65 = v66;
        end;
    end;

    if not u65 then
        return;
    end;

    if v66 and SkillBuffUtil.IsBeSheepExcludedTarget(v66) then
        return;
    end;

    task.delay(0.016666666666666666, function() -- Line: 522
        -- upvalues: u62 (copy), runGeneration (copy), takeMaterialEmitOnce (ref), skillRunData (copy), u65 (copy), u64 (copy)
        if not u62:isRunningFlow() or u62.runGeneration ~= runGeneration then
            return;
        end;

        takeMaterialEmitOnce(skillRunData, "变恐龙蛋_击打表现特效", CFrame.new(u65), u64);
    end);

    if v66 and v66.Parent then
        skillRunData.Visual.eggEnemyModel = v66;
        skillRunData.Visual.eggEnemyOrigScale = v66:GetScale();
    end;

    task.delay(0.11666666666666667, function() -- Line: 561
        -- upvalues: u62 (copy), runGeneration (copy), skillRunData (copy), SkillCommon (ref), u65 (copy), u64 (copy), Workspace (ref), VisibleMgr (ref), placeEggStandingOnGround (ref), RunService (ref), sampleEggTiltDeg (ref), FXUtil (ref), getEggMainNodeWorldPos (ref), takeMaterialEmitOnce (ref), restoreEnemyVisual (ref)
        if not u62:isRunningFlow() or u62.runGeneration ~= runGeneration then
            return;
        end;

        local u67 = skillRunData.material and skillRunData.material["变恐龙蛋_恐龙蛋"];

        if not (u67 and u67:IsA("Model")) then
            return;
        end;

        skillRunData.material["变恐龙蛋_恐龙蛋"] = nil;
        local Position = SkillCommon.getGroundCF(CFrame.new(u65), 4, 0.12, "Ground").Position;
        local v68 = math.max(u64 * 0.1, 0.0001);
        u67:ScaleTo(u64);
        u67.Parent = Workspace:FindFirstChild("Debris") or Workspace;
        VisibleMgr.UnTransparencyAll(u67);
        local v69 = u67:FindFirstChild("锚点", true);

        if v69 and v69:IsA("BasePart") then
            v69.Transparency = 1;
            v69.CanCollide = false;
            v69.CanQuery = false;
            v69.CanTouch = false;
        end;

        placeEggStandingOnGround(u67, Position, 0);
        local u70 = u67:GetPivot();
        skillRunData.Visual.eggModel = u67;
        skillRunData.Visual.eggGroundPos = Position;
        skillRunData.Visual.eggBaseCF = u70;
        SkillCommon.appendRunSpawnList(skillRunData, "SingleDinoEggSpawned", u67);
        SkillCommon.playSoundLocal3D("音效-变恐龙蛋-变蛋", Position);
        u67:ScaleTo(v68);
        u67:PivotTo(u70);
        VisibleMgr.TransparencyAll(u67);
        local v71 = u67:FindFirstChild("锚点", true);

        if v71 and v71:IsA("BasePart") then
            v71.Transparency = 1;
            v71.CanCollide = false;
            v71.CanQuery = false;
            v71.CanTouch = false;
        end;

        local u72 = os.clock();
        skillRunData.runEvent = skillRunData.runEvent or {};
        skillRunData.runEvent["变恐龙蛋倾角"] = RunService.RenderStepped:Connect(function() -- Line: 601
            -- upvalues: u62 (ref), runGeneration (ref), u67 (copy), u72 (copy), sampleEggTiltDeg (ref), u70 (copy)
            if not u62:isRunningFlow() or (u62.runGeneration ~= runGeneration or not u67.Parent) then
                return;
            end;

            local v73 = os.clock() - u72 + 0.11666666666666667;
            local v74 = v73 >= 1.1166666666666667 and 0 or sampleEggTiltDeg(v73);
            u67:PivotTo(u70 * CFrame.Angles(0, 0, (math.rad(v74))));
        end);
        FXUtil.Model_Scale_Tween(u67, v68, u64, 0.016666666666666666, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, function() -- Line: 612
            -- upvalues: u67 (copy), u62 (ref), runGeneration (ref), FXUtil (ref), u64 (ref)
            if not u67.Parent or u62.runGeneration ~= runGeneration then
                return;
            end;

            FXUtil.Model_Scale_Tween(u67, u64, u64 * 1.5, 0.016666666666666666, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, function() -- Line: 616
                -- upvalues: u67 (ref), u62 (ref), runGeneration (ref), FXUtil (ref), u64 (ref)
                if not u67.Parent or u62.runGeneration ~= runGeneration then
                    return;
                end;

                FXUtil.Model_Scale_Tween(u67, u64 * 1.5, u64 * 0.6, 0.03333333333333333, Enum.EasingStyle.Quad, Enum.EasingDirection.In, function() -- Line: 620
                    -- upvalues: u67 (ref), u62 (ref), runGeneration (ref), FXUtil (ref), u64 (ref)
                    if not u67.Parent or u62.runGeneration ~= runGeneration then
                        return;
                    end;

                    FXUtil.Model_Scale_Tween(u67, u64 * 0.6, u64, 0.03333333333333333, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, nil, true);
                end, true);
            end, true);
        end, true);
        local Model = u67:FindFirstChild("Model");

        if Model then
            Model = Model:FindFirstChild("Handle");
        end;

        local u75;

        if Model then
            u75 = Model:FindFirstChild("Emit_星");
        else
            u75 = Model;
        end;

        if Model then
            Model = Model:FindFirstChild("Enable_星");
        end;

        task.delay(0.21666666666666667, function() -- Line: 636
            -- upvalues: u62 (ref), runGeneration (ref), u67 (copy), u75 (copy), FXUtil (ref), Model (copy)
            if not u62:isRunningFlow() or (u62.runGeneration ~= runGeneration or not u67.Parent) then
                return;
            end;

            if u75 then
                FXUtil.Emit_Particles_GetDescendants(u75, true);
            end;

            if Model then
                FXUtil.SetEnableNameVfx(Model, true);
            end;
        end);
        task.delay(0.55, function() -- Line: 649
            -- upvalues: u62 (ref), runGeneration (ref), u67 (copy), u75 (copy), FXUtil (ref)
            if not u62:isRunningFlow() or (u62.runGeneration ~= runGeneration or not u67.Parent) then
                return;
            end;

            if u75 then
                FXUtil.Emit_Particles_GetDescendants(u75, true);
            end;
        end);
        task.delay(0.9333333333333333, function() -- Line: 659
            -- upvalues: u62 (ref), runGeneration (ref), u67 (copy), u75 (copy), FXUtil (ref), Model (copy)
            if not u62:isRunningFlow() or (u62.runGeneration ~= runGeneration or not u67.Parent) then
                return;
            end;

            if u75 then
                FXUtil.Emit_Particles_GetDescendants(u75, true);
            end;

            if Model then
                FXUtil.OffEnableVfx(Model);
            end;
        end);
        task.delay(1, function() -- Line: 672
            -- upvalues: u62 (ref), runGeneration (ref), SkillCommon (ref), skillRunData (ref), u67 (copy), getEggMainNodeWorldPos (ref), Position (copy), takeMaterialEmitOnce (ref), u64 (ref), FXUtil (ref)
            if not u62:isRunningFlow() or u62.runGeneration ~= runGeneration then
                return;
            end;

            SkillCommon.disconnectRunEventKeys(skillRunData, { "变恐龙蛋倾角" });
            local v76;

            if u67.Parent then
                v76 = CFrame.new((getEggMainNodeWorldPos(u67)));
            else
                v76 = CFrame.new(Position);
            end;

            takeMaterialEmitOnce(skillRunData, "变恐龙蛋_爆炸特效", v76, u64);
            SkillCommon.playSoundLocal3D("音效-变恐龙蛋-爆炸攻击", v76.Position);

            if u67.Parent then
                FXUtil.Model_Scale_Tween(u67, u67:GetScale(), math.max(u64 * 0.1, 0.0001), 0.016666666666666666, Enum.EasingStyle.Quad, Enum.EasingDirection.In, nil, true);
            end;
        end);
        task.delay(1.0166666666666666, function() -- Line: 697
            -- upvalues: u62 (ref), runGeneration (ref), SkillCommon (ref), skillRunData (ref), u67 (copy), FXUtil (ref), restoreEnemyVisual (ref)
            if u62.runGeneration ~= runGeneration then
                return;
            end;

            SkillCommon.disconnectRunEventKeys(skillRunData, { "变恐龙蛋倾角" });

            if u67.Parent then
                FXUtil.HideModelBasePartsStopEmit(u67);
                SkillCommon.returnPooledModelFromSpawnList(skillRunData, "SingleDinoEggSpawned", u67);
            end;

            skillRunData.Visual.eggModel = nil;
            skillRunData.Visual.eggGroundPos = nil;
            skillRunData.Visual.eggBaseCF = nil;
            restoreEnemyVisual(skillRunData);
        end);
    end);
end;

function u3.Client_ExitEggShow(p77) -- Line: 714
    -- upvalues: SkillCommon (copy), restoreEnemyVisual (copy)
    local skillRunData = p77.skillRunData;

    if not skillRunData then
        return;
    end;

    SkillCommon.disconnectRunEventKeys(skillRunData, { "变恐龙蛋倾角" });
    restoreEnemyVisual(skillRunData);
    SkillCommon.clearSpawnIfTerminalAfterExit(p77, p77.runGeneration, skillRunData, "SingleDinoEggSpawned");
end;

function u3.Server_EnterEggShow(u78, p79) -- Line: 724
    -- upvalues: SkillEventConst (copy), ProjectileObjectTracking (copy), u1 (copy), Players (copy), SkillBuffUtil (copy), TipsModule (copy), SkillCommon (copy)
    local u80 = p79 and p79.hitPosition or u78.skillRunData.Logic and u78.skillRunData.Logic.impactPosition;
    local skillRunData = u78.skillRunData;

    if not skillRunData then
        return;
    end;

    skillRunData.Logic = skillRunData.Logic or {};

    if u80 then
        u78:fireProjectileHitConfirmed(u80, skillRunData.Logic.impactType or SkillEventConst.HitType.Timeout, skillRunData.Logic.impactTargetId);
    end;

    local impactEnemyModel = skillRunData.Logic.impactEnemyModel;

    if not impactEnemyModel then
        impactEnemyModel = ProjectileObjectTracking.resolveAtCast(u78.skillInputData and u78.skillInputData.trackTargetId, u78.skillInputData and u78.skillInputData.character, u1);
        skillRunData.Logic.impactEnemyModel = impactEnemyModel;
    end;

    local v81 = u78.skillInputData and u78.skillInputData.character;

    if v81 then
        v81 = Players:GetPlayerFromCharacter(v81);
    end;

    local runGeneration = u78.runGeneration;

    if not (impactEnemyModel and v81) then
        return;
    end;

    if SkillBuffUtil.IsBeSheepExcludedTarget(impactEnemyModel) then
        TipsModule.NormalTips(v81, "好像对他们不起作用呢");
        skillRunData.Logic.eggSkipped = true;

        return;
    end;

    SkillBuffUtil.ApplySkillBuffsToDefender(impactEnemyModel, u78.skillID, {
        attacker = v81,
        casterUserId = v81.UserId,
        attackerPlayerId = v81.UserId
    });
    skillRunData.Logic.eggActive = true;

    for _, v in ipairs({ 0.3333333333333333, 0.4666666666666667, 0.5833333333333334, 0.7166666666666667, 0.8666666666666667, 1 }) do
        task.delay(v, function() -- Line: 776
            -- upvalues: u78 (copy), runGeneration (copy), ProjectileObjectTracking (ref), impactEnemyModel (ref), u1 (ref), u80 (copy), SkillCommon (ref)
            if u78.runGeneration ~= runGeneration then
                return;
            end;

            local skillRunData2 = u78.skillRunData;

            if not (skillRunData2 and (skillRunData2.Logic and skillRunData2.Logic.eggActive)) then
                return;
            end;

            if u78.GetCurrentState and u78:GetCurrentState() ~= "EggShow" then
                return;
            end;

            local v82 = ProjectileObjectTracking.getModelWorldPosition(impactEnemyModel, u1) or u80;

            if v82 then
                SkillCommon.pulseSphereHitboxAtPos(u78.hitbox[2], v82, Vector3.new(0.5, 0.5, 0.5), 0.12);
            end;
        end);
    end;

    task.delay(1.1166666666666667, function() -- Line: 795
        -- upvalues: u78 (copy), runGeneration (copy), ProjectileObjectTracking (ref), impactEnemyModel (ref), u1 (ref), u80 (copy), SkillCommon (ref)
        if u78.runGeneration ~= runGeneration then
            return;
        end;

        local skillRunData2 = u78.skillRunData;

        if not (skillRunData2 and (skillRunData2.Logic and skillRunData2.Logic.eggActive)) then
            return;
        end;

        if u78.GetCurrentState and u78:GetCurrentState() ~= "EggShow" then
            return;
        end;

        local v83 = ProjectileObjectTracking.getModelWorldPosition(impactEnemyModel, u1) or u80;

        if v83 then
            SkillCommon.pulseSphereHitboxAtPos(u78.hitbox[3], v83, Vector3.new(45, 45, 45), 0.12);
        end;
    end);
end;

function u3.Server_ExitEggShow(p84) -- Line: 813
    local skillRunData = p84.skillRunData;

    if skillRunData and skillRunData.Logic then
        skillRunData.Logic.eggActive = false;
    end;

    local v85 = p84.hitbox[2];

    if v85 and v85.isActive then
        v85:stop();
    end;

    local v86 = p84.hitbox[3];

    if v86 and v86.isActive then
        v86:stop();
    end;
end;

function u3.Server_EnterRecovery(p87) -- Line: 826
    p87:releaseControl();
end;

function u3.Client_EnterRecovery(p88) -- Line: 830
    -- upvalues: SkillCommon (copy)
    local skillRunData = p88.skillRunData;

    if skillRunData then
        SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "空间系尾迹", "变恐龙蛋Cast尾迹");
    end;
end;

function u3.onEnd(p89) -- Line: 837
    -- upvalues: SkillCommon (copy), restoreEnemyVisual (copy)
    local skillRunData = p89.skillRunData;

    if skillRunData then
        SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "空间系尾迹", "变恐龙蛋Cast尾迹");
        SkillCommon.disconnectRunEventKeys(skillRunData, { "变恐龙蛋倾角", "变恐龙蛋缩怪" });
        restoreEnemyVisual(skillRunData);
    end;
end;

function u3.onClearRunData(p90, p91) -- Line: 852
    -- upvalues: SkillCommon (copy), restoreEnemyVisual (copy)
    if not p91 then
        return;
    end;

    SkillCommon.cleanupWandTipTrailFromMaterial(p91, "空间系尾迹", "变恐龙蛋Cast尾迹");
    SkillCommon.disconnectRunEventKeys(p91, { "变恐龙蛋倾角", "变恐龙蛋缩怪" });
    restoreEnemyVisual(p91);
    local Visual = p91.Visual;

    if Visual then
        Visual.eggEnemyModel = nil;
        Visual.eggEnemyOrigScale = nil;
    end;
end;

function u3.onEndServer(p92) -- Line: 866
    local v93 = p92.hitbox[1];

    if v93 and v93.isActive then
        v93:stop();
    end;

    local v94 = p92.hitbox[2];

    if v94 and v94.isActive then
        v94:stop();
    end;

    local v95 = p92.hitbox[3];

    if v95 and v95.isActive then
        v95:stop();
    end;
end;

function u3.onServerEvent(p96, p97) -- Line: 875
    -- upvalues: SkillEventConst (copy)
    if p97.eventType ~= SkillEventConst.SyncEventType.ProjectileHitConfirmed then
        return;
    end;

    local skillRunData = p96.skillRunData;
    local hitPosition = p97.hitPosition;

    if not (skillRunData and hitPosition) then
        return;
    end;

    local v98 = p97.hitType == SkillEventConst.HitType.Obstacle and SkillEventConst.ObstacleHit or (p97.hitType == SkillEventConst.HitType.Timeout and SkillEventConst.Timeout or SkillEventConst.EnemyHit);

    if p96.GetCurrentState and p96:GetCurrentState() == "ProjectileFlying" then
        p96:TryTransition(v98, {
            hitPosition = hitPosition,
            hitType = p97.hitType,
            targetId = p97.targetId
        });

        return;
    end;

    skillRunData.Visual = skillRunData.Visual or {};
    skillRunData.Visual.pendingProjectileHitEvent = p97;
end;

function u3.onProjectileHitServer(p99, p100, p101) -- Line: 898
    -- upvalues: HitResolver (copy), ProjectileImpact (copy), SkillEventConst (copy)
    if not (p100 and p100.isActive) then
        return;
    end;

    local skillRunData = p99.skillRunData;

    if not (skillRunData and skillRunData.State) then
        return;
    end;

    if p100.hitboxIndex == 2 or p100.hitboxIndex == 3 then
        for i, v in p101 do
            HitResolver.applyHit(p99, p100, v, i);
        end;

        return;
    end;

    if p100.hitboxIndex ~= 1 or skillRunData.State.current ~= "ProjectileFlying" then
        return;
    end;

    local v102, v103 = next(p101);

    if not (v102 and v103) then
        return;
    end;

    ProjectileImpact.resolveImpact(p99, {
        type = SkillEventConst.HitType.Enemy,
        position = v103.Position,
        target = v102,
        hitResult = p101,
        source = ProjectileImpact.ImpactSource.Hitbox
    });
end;

u3.SoundList = { "音效-变恐龙蛋-变蛋", "音效-变恐龙蛋-爆炸攻击" };
u3.AnimateList = { "技能释放动作3" };
u3.ResNameList = { "空间系尾迹", "变恐龙蛋_起手特效", "变恐龙蛋_发射物特效", "变恐龙蛋_击打表现特效", "变恐龙蛋_恐龙蛋", "变恐龙蛋_爆炸特效" };
u3.hitboxConfig = { {
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
    }, {
        HitboxIndex = 3,
        PartName = "通用球",
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