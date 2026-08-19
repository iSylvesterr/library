-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
require(script.Parent.Parent.BaseSkill.GetSkillData);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local ProjectileImpact = require(script.Parent._Templates.Projectile.ProjectileImpact);
local ProjectileObjectTracking = require(script.Parent._Templates.Projectile.ProjectileObjectTracking);
local ProjectileCore = require(script.Parent._Templates.Projectile.ProjectileCore);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local PlayerAimSync = require(script.Parent.Parent.BaseSkill.PlayerAimSync);
local HumanModule = UtilsSystem.HumanModule;
local FXUtil = UtilsSystem.FXUtil;
local BezierCurve = UtilsSystem.BezierCurve;
local RunService = UtilsSystem.RunService;
local TweenService = game:GetService("TweenService");
local _ = UtilsSystem.Players;
local u1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.Fire
};
local u2 = {
    enabled = true,
    curveRefreshInterval = 0,
    objectValueName = ProjectileObjectTracking.DEFAULT_OV_NAME,
    objectValuePathSegments = {}
};
u1.InitialState = "Startup";
u1.ControlOpenState = "ProjectileFlying";
u1.States = {
    Startup = {
        Duration = 0.27,
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

local function get_skillScale(p3) -- Line: 109
    -- upvalues: SkillCommon (copy)
    return SkillCommon.scaleDualFromData(p3, SkillCommon.bandScaleOptsFromSkillData(p3));
end;

local function getProjectileStartCF(p4) -- Line: 113
    -- upvalues: SkillCommon (copy)
    return SkillCommon.getHRPStartCF(p4, CFrame.new(0, 0, -3));
end;

local function getProjectileEndCF(p5) -- Line: 117
    -- upvalues: SkillCommon (copy)
    return SkillCommon.clampProjectileEndFromSkillData(p5, SkillCommon.getHRPStartCF(p5, CFrame.new(0, 0, -3)), 150, 0.7);
end;

local function buildFireArrowCurvePoints(p6, p7) -- Line: 127
    -- upvalues: BezierCurve (copy)
    return BezierCurve.GenerateBezierPoints(p6, p7, 2, {
        RandomSeed = 10000,
        HeightOffsetRandom = 0,
        SideOffsetRandom = 0,
        EasingStyle = Enum.EasingStyle.Quad,
        EasingDirection = Enum.EasingDirection.Out
    });
end;

local function getClampedEndPos(p8, p9, p10, p11, p12) -- Line: 146
    -- upvalues: ProjectileObjectTracking (copy), u2 (copy), SkillCommon (copy), ProjectileCore (copy)
    local skillInputData = p8.skillInputData;
    local v13;

    if p10 == nil or p10 == "" then
        v13 = nil;
    elseif p12 then
        v13 = ProjectileObjectTracking.getWorldPositionByTrackTargetId(p10);
    else
        v13 = ProjectileObjectTracking.getLiveTrackedWorldPosition(p10, p11, u2);
    end;

    if not v13 and (skillInputData and skillInputData.targetCF) then
        v13 = skillInputData.targetCF.Position;
    end;

    if v13 then
        return ProjectileCore.clampProjectileEndToMaxRange(p9, v13, 150, 0.7);
    end;

    return SkillCommon.clampProjectileEndFromSkillData(p8, SkillCommon.getHRPStartCF(p8, CFrame.new(0, 0, -3)), 150, 0.7).Position;
end;

local function resolveTrackingAtCast(p14, p15) -- Line: 177
    -- upvalues: u2 (copy), HumanModule (copy), ProjectileObjectTracking (copy)
    if not u2.enabled then
        return false, nil, nil;
    end;

    if not p15 and HumanModule.GetIsShiftLocked() then
        return false, nil, nil;
    end;

    local v16 = p14.skillInputData and p14.skillInputData.trackTargetId;
    local _, v17, v18 = ProjectileObjectTracking.resolveAtCast(v16, p14.character or p14.skillInputData and p14.skillInputData.character, u2);
    local v19 = v16 or v18;

    if v17 then
        return true, v19, v17;
    end;

    return false, nil, nil;
end;

local function runStaticFireArrowMotion(p20, p21, p22, p23) -- Line: 205
    -- upvalues: buildFireArrowCurvePoints (copy), BezierCurve (copy)
    local v24 = math.min((p21 - p22).Magnitude / 150, 0.7) * 60;
    local v25 = buildFireArrowCurvePoints(p21, p22);

    return BezierCurve.MultiOrderBezierCurves({
        FPS = 60,
        Frame = v24,
        Points = v25,
        Target = p20,
        EasingStyle = Enum.EasingStyle.Sine,
        EasingDirection = Enum.EasingDirection.In
    }, p23 or function() -- Line: 223
    end);
end;

local function runTrackedFireArrowMotion(u26, p27, u28, u29, p30, u31, u32, u33, u34) -- Line: 239
    -- upvalues: getClampedEndPos (copy), ProjectileCore (copy), RunService (copy), buildFireArrowCurvePoints (copy), TweenService (copy)
    if not u26 then
        return nil;
    end;

    local Position = p27.Position;
    local Rotation = p27.Rotation;
    local u35 = getClampedEndPos(u28, Position, u29, u31, u32);

    if (p30 - Position).Magnitude > 1e-6 then
        u35 = ProjectileCore.clampProjectileEndToMaxRange(Position, p30, 150, 0.7);
    end;

    local v36 = math.min((u35 - Position).Magnitude / 150, 0.7);
    local u37 = math.max(v36, 0.001);
    local u38 = 0;
    local u39 = false;
    local u40 = nil;
    u40 = RunService.Heartbeat:Connect(function(p41) -- Line: 265
        -- upvalues: u39 (ref), ProjectileCore (ref), u26 (copy), u40 (ref), u34 (copy), u35 (ref), getClampedEndPos (ref), u28 (copy), Position (copy), u29 (copy), u31 (copy), u32 (copy), buildFireArrowCurvePoints (ref), u38 (ref), u37 (ref), TweenService (ref), Rotation (copy), u33 (copy)
        if u39 or not ProjectileCore.isMotionTargetAlive(u26) then
            u39 = true;

            if u40 then
                u40:Disconnect();
            end;

            if u34 then
                u34(u35);
            end;

            return;
        end;

        u35 = getClampedEndPos(u28, Position, u29, u31, u32);
        local v42 = buildFireArrowCurvePoints(Position, u35);
        u38 = u38 + p41;
        local v43 = math.clamp(u38 / u37, 0, 1);
        local v44 = TweenService:GetValue(v43, Enum.EasingStyle.Sine, Enum.EasingDirection.In);
        local v45 = ProjectileCore.evaluateBezierPoint(v42, v44);
        local v46;

        if (u35 - v45).Magnitude > 0.03 then
            v46 = CFrame.lookAt(v45, u35);
        else
            v46 = CFrame.new(v45) * Rotation;
        end;

        ProjectileCore.setPivotCF(u26, v46);

        if u33 then
            u33(v45);
        end;

        if v43 >= 1 then
            u39 = true;
            u40:Disconnect();

            if u34 then
                u34(u35);
            end;
        end;
    end);

    return u40;
end;

function u1.Client_EnterStartup(u47) -- Line: 308
    -- upvalues: SkillCommon (copy), RunService (copy)
    local character = u47.skillInputData.character;

    if not character then
        return;
    end;

    local u48 = SkillCommon.resolveWandTipFromCharacter(character);

    if not u48 then
        return;
    end;

    if not character:FindFirstChild("HumanoidRootPart") then
        return;
    end;

    task.delay(0.27, function() -- Line: 317
        -- upvalues: u47 (copy), RunService (ref), u48 (copy)
        if not u47:isRunningFlow() then
            return;
        end;

        local u49 = u47.skillRunData.material["火系尾迹"];

        for _, descendant in pairs(u49:GetDescendants()) do
            if descendant:IsA("Trail") or descendant:IsA("ParticleEmitter") then
                descendant.Enabled = true;
            end;
        end;

        u49.Parent = workspace.Debris;
        u47.skillRunData.runEvent["火箭术Cast尾迹"] = RunService.RenderStepped:Connect(function() -- Line: 326
            -- upvalues: u48 (ref), u49 (copy)
            if u48.Parent then
                u49:PivotTo(u48:GetPivot());
            end;
        end);
    end);
end;

function u1.Server_EnterStartup(p50) -- Line: 334
    local v51 = p50.hitbox[1];
    local v52 = p50.hitbox[2];

    if v51 and v51.hitbox then
        v51.hitbox.Size = Vector3.new(5, 5, 5);
    end;

    if v52 and v52.hitbox then
        v52.hitbox.Size = Vector3.new(3, 3, 3);
    end;
end;

function u1.Client_EnterProjectileFlying(p53) -- Line: 348
    -- upvalues: PlayerAimSync (copy), SkillCommon (copy), FXUtil (copy), u2 (copy), HumanModule (copy), ProjectileObjectTracking (copy), getClampedEndPos (copy), runTrackedFireArrowMotion (copy), runStaticFireArrowMotion (copy), u1 (copy)
    PlayerAimSync.refreshAimSnapshot(p53);
    local character = p53.skillInputData.character;

    if not character then
        return;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local v54 = p53.skillRunData.material["火系尾迹"];

    if p53.skillRunData.runEvent["火箭术Cast尾迹"] then
        p53.skillRunData.runEvent["火箭术Cast尾迹"]:Disconnect();
        p53.skillRunData.runEvent["火箭术Cast尾迹"] = nil;
    end;

    if v54 then
        for _, descendant in pairs(v54:GetDescendants()) do
            if descendant:IsA("Trail") or descendant:IsA("ParticleEmitter") then
                descendant.Enabled = false;
            end;
        end;
    end;

    local targetCF = p53.skillInputData.targetCF;
    local v55 = HumanoidRootPart:GetPivot():ToWorldSpace(CFrame.new(0, 0, -2));
    local v56 = CFrame.lookAt(v55.Position, targetCF.Position);
    local _, v57 = SkillCommon.scaleDualFromData(p53, SkillCommon.bandScaleOptsFromSkillData(p53));
    local v58 = p53.skillRunData.material["火箭术法阵"];
    v58:ScaleTo(v57 * 0.5);
    v58:PivotTo(v56 * CFrame.Angles(1.5707963267948966, 0, 0));
    v58.Parent = workspace.Debris;
    FXUtil.Emit_Particles_GetDescendants(v58, true);
    SkillCommon.playSoundLocal3D("音效-技能-火法阵", v58:GetPivot().Position);
    local skillRunData = p53.skillRunData;
    local v59 = HumanoidRootPart:GetPivot():ToWorldSpace(CFrame.new(0, 0, -3));
    local Position = v59.Position;
    local v60 = skillRunData.material["火箭术火箭"];
    local v61 = skillRunData.material["火箭术爆炸"];
    local v62, v63 = SkillCommon.scaleDualFromData(p53, SkillCommon.bandScaleOptsFromSkillData(p53));
    local v64, v65, v66;

    if u2.enabled and not HumanModule.GetIsShiftLocked() then
        local v67 = p53.skillInputData and p53.skillInputData.trackTargetId;
        local v68, v69;
        v68, v64, v69 = ProjectileObjectTracking.resolveAtCast(v67, p53.character or p53.skillInputData and p53.skillInputData.character, u2);

        if v64 then
            v65 = true;
            v66 = v67 or v69;
        else
            v65 = false;
            v64 = nil;
            v66 = nil;
        end;
    else
        v65 = false;
        v64 = nil;
        v66 = nil;
    end;

    local v70 = SkillCommon.clampProjectileEndFromSkillData(p53, SkillCommon.getHRPStartCF(p53, CFrame.new(0, 0, -3)), 150, 0.7);
    local v71 = v65 and v64 and v64 or v70.Position;

    for _, descendant in pairs(v60:GetDescendants()) do
        if descendant:IsA("Beam") then
            descendant.Enabled = true;
            FXUtil.Beam_Fade_From_Transparent(descendant, 0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.In);
        end;

        if descendant:IsA("Trail") then
            descendant.Enabled = true;
        end;
    end;

    FXUtil.Model_Scale_Tween(v60, v62, v63, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In, nil, true);
    v60:PivotTo(CFrame.lookAt(Position, v71));
    v60.Parent = workspace.Debris;
    FXUtil.Start_All_Emit(v60, 10);
    SkillCommon.playSoundLocal3D("音效-技能-火箭术-攻击", v60:GetPivot().Position);
    v61.Parent = workspace.Debris;
    v61:ScaleTo(v63);
    skillRunData.Visual.projectileModel = v60;
    skillRunData.Logic.hasExploded = false;
    local v72;

    if v65 and v64 then
        skillRunData.Logic.trackTargetId = v66;
        skillRunData.Logic.impactPosition = getClampedEndPos(p53, Position, v66, character, false);
        v72 = runTrackedFireArrowMotion(v60, v59, p53, v66, v64, character, false, function(p73) -- Line: 426
            -- upvalues: skillRunData (copy)
            skillRunData.Logic.impactPosition = p73;
        end, function(p74) -- Line: 429
            -- upvalues: skillRunData (copy)
            skillRunData.Logic.impactPosition = p74;
        end);
    else
        skillRunData.Logic.impactPosition = v70.Position;
        v72 = runStaticFireArrowMotion(v60, Position, v70.Position, function() -- Line: 435
        end);
    end;

    skillRunData.Visual.projectileMotion = v72;
    table.insert(skillRunData.runEvent, v72);
    local pendingProjectileHitEvent = skillRunData.Visual.pendingProjectileHitEvent;

    if pendingProjectileHitEvent then
        skillRunData.Visual.pendingProjectileHitEvent = nil;
        v72:Disconnect();
        skillRunData.Visual.projectileMotion = nil;
        u1.onServerEvent(p53, pendingProjectileHitEvent);
    end;
end;

function u1.Client_ExitProjectileFlying(p75) -- Line: 449
    local projectileMotion = p75.skillRunData.Visual.projectileMotion;

    if projectileMotion then
        projectileMotion:Disconnect();
        p75.skillRunData.Visual.projectileMotion = nil;
    end;
end;

function u1.Server_EnterProjectileFlying(u76) -- Line: 457
    -- upvalues: PlayerAimSync (copy), SkillCommon (copy), u2 (copy), ProjectileObjectTracking (copy), ProjectileCore (copy), runTrackedFireArrowMotion (copy), SkillEventConst (copy), ProjectileImpact (copy), runStaticFireArrowMotion (copy)
    PlayerAimSync.refreshAimSnapshot(u76);
    local v77 = u76.hitbox[1];

    if not (v77 and u76.hitbox[2]) then
        return;
    end;

    local v78 = SkillCommon.getHRPStartCF(u76, CFrame.new(0, 0, -3));
    local u79 = SkillCommon.clampProjectileEndFromSkillData(u76, SkillCommon.getHRPStartCF(u76, CFrame.new(0, 0, -3)), 150, 0.7);
    local hitbox = v77.hitbox;
    local Position = v78.Position;
    u76.skillRunData.Logic.hasExploded = false;
    local v80, v81, v82;

    if u2.enabled then
        local v83 = u76.skillInputData and u76.skillInputData.trackTargetId;
        local v84, v85;
        v84, v80, v85 = ProjectileObjectTracking.resolveAtCast(v83, u76.character or u76.skillInputData and u76.skillInputData.character, u2);

        if v80 then
            v81 = true;
            v82 = v83 or v85;
        else
            v81 = false;
            v80 = nil;
            v82 = nil;
        end;
    else
        v81 = false;
        v80 = nil;
        v82 = nil;
    end;

    local v86;

    if v81 and v80 then
        u76.skillRunData.Logic.trackTargetId = v82;
        local Logic = u76.skillRunData.Logic;
        local _ = u76.character;
        local skillInputData = u76.skillInputData;
        local v87;

        if v82 == nil or v82 == "" then
            v87 = nil;
        else
            v87 = ProjectileObjectTracking.getWorldPositionByTrackTargetId(v82);
        end;

        if not v87 and (skillInputData and skillInputData.targetCF) then
            v87 = skillInputData.targetCF.Position;
        end;

        local v88;

        if v87 then
            v88 = ProjectileCore.clampProjectileEndToMaxRange(Position, v87, 150, 0.7);
        else
            v88 = SkillCommon.clampProjectileEndFromSkillData(u76, SkillCommon.getHRPStartCF(u76, CFrame.new(0, 0, -3)), 150, 0.7).Position;
        end;

        Logic.impactPosition = v88;
        v86 = runTrackedFireArrowMotion(hitbox, v78, u76, v82, v80, u76.character, true, function(p89) -- Line: 485
            -- upvalues: u76 (copy)
            u76.skillRunData.Logic.impactPosition = p89;
        end, function(p90) -- Line: 488
            -- upvalues: SkillEventConst (ref), ProjectileImpact (ref), u76 (copy)
            ProjectileImpact.resolveImpact(u76, {
                type = SkillEventConst.HitType.Timeout,
                position = p90,
                source = ProjectileImpact.ImpactSource.Lifetime
            });
        end);
    else
        u76.skillRunData.Logic.impactPosition = u79.Position;
        v86 = runStaticFireArrowMotion(hitbox, Position, u79.Position, function() -- Line: 499
            -- upvalues: SkillEventConst (ref), u79 (copy), ProjectileImpact (ref), u76 (copy)
            ProjectileImpact.resolveImpact(u76, {
                type = SkillEventConst.HitType.Timeout,
                position = u79.Position,
                source = ProjectileImpact.ImpactSource.Lifetime
            });
        end);
    end;

    hitbox:PivotTo(v78);
    u76.skillRunData.Logic.projectileHitboxMotion = v86;
    table.insert(u76.skillRunData.runEvent, v86);
end;

function u1.Server_ExitProjectileFlying(p91) -- Line: 514
    local projectileHitboxMotion = p91.skillRunData.Logic.projectileHitboxMotion;

    if projectileHitboxMotion then
        projectileHitboxMotion:Disconnect();
        p91.skillRunData.Logic.projectileHitboxMotion = nil;
    end;

    local v92 = p91.hitbox[1];

    if v92 and v92.isActive then
        v92:stop();
    end;

    if v92 and v92.hitbox then
        v92.hitbox.Transparency = 1;
    end;
end;

function u1.Server_UpdateProjectileObstacleCheck(p93) -- Line: 528
end;

function u1.Client_EnterExploding(p94, p95) -- Line: 532
    -- upvalues: FXUtil (copy)
    local v96 = p95 and p95.hitPosition or p94.skillRunData.Logic and p94.skillRunData.Logic.impactPosition;

    if not v96 then
        return;
    end;

    local projectileModel = p94.skillRunData.Visual.projectileModel;
    local v97 = p94.skillRunData.material["火箭术爆炸"];

    if projectileModel and projectileModel.Parent then
        projectileModel:PivotTo(CFrame.new(v96));
    end;

    if v97 then
        v97:PivotTo(CFrame.new(v96));
        FXUtil.Emit_Particles_GetDescendants(v97, true);
    end;

    if projectileModel then
        for _, descendant in pairs(projectileModel:GetDescendants()) do
            if descendant:IsA("Beam") then
                FXUtil.Beam_Fade_To_Transparent_Then_Disable(descendant, 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
            end;

            if descendant:IsA("ParticleEmitter") and descendant.Name == "Enabled_1" then
                descendant:Clear();
            end;
        end;

        FXUtil.Stop_All_Emit(projectileModel);
    end;
end;

function u1.Server_EnterExploding(p98, p99) -- Line: 558
    -- upvalues: SkillCommon (copy), FXUtil (copy), SkillEventConst (copy)
    local _, v100 = SkillCommon.scaleDualFromData(p98, SkillCommon.bandScaleOptsFromSkillData(p98));
    local v101 = p99 and p99.hitPosition or p98.skillRunData.Logic and p98.skillRunData.Logic.impactPosition;

    if not v101 then
        return;
    end;

    local u102 = p98.hitbox[2];

    if u102 then
        local hitbox = u102.hitbox;
        hitbox:PivotTo(CFrame.new(v101));
        u102:start();
        FXUtil.BasePart_Size_Tween(hitbox, 0.1, Vector3.new(10, 10, 10) * v100, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, function() -- Line: 570
            -- upvalues: u102 (copy), hitbox (copy)
            if u102.isActive then
                u102:stop();
                hitbox.Transparency = 1;
            end;
        end);
    end;

    p98:fireProjectileHitConfirmed(v101, p98.skillRunData.Logic.impactType or SkillEventConst.HitType.Timeout, p98.skillRunData.Logic.impactTargetId);
end;

function u1.Server_EnterRecovery(p103) -- Line: 586
    p103:releaseControl();
end;

function u1.Client_EnterRecovery(p104) -- Line: 590
    local v105 = p104.skillRunData.material["火系尾迹"];

    if v105 then
        for _, descendant in pairs(v105:GetDescendants()) do
            if descendant:IsA("Trail") or descendant:IsA("ParticleEmitter") then
                descendant.Enabled = false;
            end;
        end;
    end;

    if p104.skillRunData.runEvent["火箭术Cast尾迹"] then
        p104.skillRunData.runEvent["火箭术Cast尾迹"]:Disconnect();
        p104.skillRunData.runEvent["火箭术Cast尾迹"] = nil;
    end;
end;

function u1.onServerEvent(p106, p107) -- Line: 606
    -- upvalues: SkillEventConst (copy)
    if p107.eventType ~= SkillEventConst.SyncEventType.ProjectileHitConfirmed then
        return;
    end;

    local skillRunData = p106.skillRunData;

    if not skillRunData then
        return;
    end;

    local hitPosition = p107.hitPosition;

    if not hitPosition then
        return;
    end;

    local v108 = p107.hitType == SkillEventConst.HitType.Obstacle and SkillEventConst.ObstacleHit or (p107.hitType == SkillEventConst.HitType.Timeout and SkillEventConst.Timeout or SkillEventConst.EnemyHit);

    if p106.GetCurrentState and p106:GetCurrentState() == "ProjectileFlying" then
        p106:TryTransition(v108, {
            hitPosition = hitPosition,
            hitType = p107.hitType,
            targetId = p107.targetId
        });

        return;
    end;

    skillRunData.Visual.pendingProjectileHitEvent = p107;
end;

function u1.onProjectileHitServer(p109, p110, p111) -- Line: 628
    -- upvalues: SkillEventConst (copy), ProjectileImpact (copy)
    if not p110 then
        return;
    end;

    if not (p109.hitbox[1] and p109.hitbox[2]) then
        return;
    end;

    local skillRunData = p109.skillRunData;

    if not (skillRunData and skillRunData.State) then
        return;
    end;

    if p110.hitboxIndex == 2 then
        local HitResolver = require(script.Parent.Parent.BaseSkill.HitResolver);

        for i, v in p111 do
            HitResolver.applyHit(p109, p110, v, i);
        end;

        return;
    end;

    if p110.hitboxIndex ~= 1 then
        return;
    end;

    if not p110.isActive then
        return;
    end;

    local v112, v113 = next(p111);

    if not (v112 and v113) then
        return;
    end;

    ProjectileImpact.resolveImpact(p109, {
        type = SkillEventConst.HitType.Enemy,
        position = v113.Position,
        target = v112,
        hitResult = p111,
        source = ProjectileImpact.ImpactSource.Hitbox
    });
end;

u1.SoundList = { "音效-技能-火法阵", "音效-技能-火箭术-攻击" };
u1.AnimateList = { "技能释放动作3" };
u1.ResNameList = { "火系尾迹", "火箭术法阵", "火箭术爆炸", "火箭术火箭" };
u1.hitboxConfig = { {
        HitboxIndex = 1,
        PartName = "通用球",
        CollisionGroup = "Player",
        HitPresentationProfile = "火属性受击",
        CameraShakeProfile = "轻攻击震",
        PhysicsEffectName = "通用受击物理效果"
    }, {
        HitboxIndex = 2,
        PartName = "通用球",
        CollisionGroup = "Player",
        HitPresentationProfile = "火属性受击",
        CameraShakeProfile = "轻攻击震",
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