-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local ProjectileCore = require(script.Parent._Templates.Projectile.ProjectileCore);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local FXUtil = UtilsSystem.FXUtil;
local BezierCurve = UtilsSystem.BezierCurve;
local u1 = {
    skillTotalTime = 3,
    visualFadeoutTime = 1.5,
    skillElementType = ElementTp.Thunder,
    skillDistanceLimit = 64,
    InitialState = "Startup",
    ControlOpenState = "ProjectileFlying",
    States = {
        Startup = {
            Duration = 0.65,
            OnEnterClient = "Client_EnterStartup",
            OnEnterServer = "Server_EnterStartup",
            OnExitClient = nil,
            OnExitServer = nil
        },
        ProjectileFlying = {
            Duration = 3.4,
            OnEnterClient = "Client_EnterProjectileFlying",
            OnEnterServer = "Server_EnterProjectileFlying",
            OnExitClient = "Client_ExitProjectileFlying",
            OnExitServer = "Server_ExitProjectileFlying"
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
            From = "Recovery",
            To = "Finished",
            Event = SkillEventConst.ForceFinish
        }
    }
};

local function resolveLaunchPartFromCharacter(p2) -- Line: 118
    return p2:FindFirstChild("角", true);
end;

local function getPartPivotCF(p3) -- Line: 122
    if p3:IsA("BasePart") then
        return p3:GetPivot();
    end;

    if p3:IsA("Attachment") then
        return p3.WorldCFrame;
    end;

    if p3:IsA("Model") then
        return p3:GetPivot();
    end;

    return CFrame.new();
end;

local function getLaunchCF(p4) -- Line: 135
    -- upvalues: getPartPivotCF (copy)
    local v5 = p4.skillInputData and p4.skillInputData.character;

    if v5 then
        local v6 = v5:FindFirstChild("角", true);

        if v6 then
            return getPartPivotCF(v6);
        end;

        local HumanoidRootPart = v5:FindFirstChild("HumanoidRootPart");

        if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
            return HumanoidRootPart:GetPivot();
        end;
    end;

    return p4.skillInputData and p4.skillInputData.releaseCF or CFrame.new();
end;

local function getTargetPosition(p7) -- Line: 154
    -- upvalues: getLaunchCF (copy), ProjectileCore (copy)
    local Position = getLaunchCF(p7).Position;
    local v8 = p7:getTargetCF().Position + Vector3.new(0, 0.5, 0);

    return ProjectileCore.clampProjectileEndToMaxRange(Position, v8, 180, 3);
end;

local function getSkillScale(p9) -- Line: 161
    -- upvalues: SkillCommon (copy)
    return SkillCommon.npcSummonBodySkillScale(p9);
end;

local function getExplosionHitboxDiameter(p10) -- Line: 165
    return p10 * 32;
end;

local function raycastGroundAlignedCF(p11, p12) -- Line: 173
    -- upvalues: FXUtil (copy)
    return FXUtil.GetGroundAlignedCF(p11, p12, "Ground", 3, 0.12);
end;

local function getGroundFxFlatHint(p13, p14) -- Line: 177
    local v15 = p13.skillInputData and p13.skillInputData.releaseCF;

    if v15 then
        local v16 = p14 - v15.Position;
        local v17 = Vector3.new(v16.X, 0, v16.Z);

        if v17.Magnitude > 0.05 then
            return v17;
        end;
    end;

    return Vector3.new(0, 0, -1);
end;

local function shouldPlayGroundExplosionFx(p18, p19, p20) -- Line: 193
    -- upvalues: FXUtil (copy)
    local v21 = FXUtil.GetGroundAlignedCF(p18, p20, "Ground", 3, 0.12);

    if not v21 then
        return false, nil;
    end;

    if (p18 - v21.Position).Magnitude < p19 then
        return true, v21;
    end;

    return false, nil;
end;

local function hideModelBaseParts(p22) -- Line: 210
    -- upvalues: FXUtil (copy)
    if p22 then
        FXUtil.SetAllBasePartsTransparency(p22, 1);
    end;
end;

local function setElectricBallParticleTrailEnabled(p23, p24) -- Line: 216
    if not p23 then
        return;
    end;

    local v25 = p23:GetDescendants();
    table.insert(v25, p23);

    for _, v in v25 do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Enabled = p24;
        end;
    end;
end;

local function fadeProjectileVfx(p26) -- Line: 229
    -- upvalues: FXUtil (copy), setElectricBallParticleTrailEnabled (copy)
    if not p26 then
        return;
    end;

    FXUtil.Stop_All_Emit(p26);
    setElectricBallParticleTrailEnabled(p26, false);

    if p26 then
        FXUtil.SetAllBasePartsTransparency(p26, 1);
    end;
end;

local function prepareProjectileVfx(p27) -- Line: 238
    -- upvalues: FXUtil (copy), setElectricBallParticleTrailEnabled (copy)
    if p27 then
        FXUtil.SetAllBasePartsTransparency(p27, 1);
    end;

    setElectricBallParticleTrailEnabled(p27, true);
    FXUtil.Start_All_Trail(p27);
    FXUtil.Start_All_Emit(p27, 10);
end;

local function emitParticleOnlyFxAt(p28, p29, p30) -- Line: 245
    -- upvalues: FXUtil (copy)
    if not p28 then
        return;
    end;

    p28:ScaleTo(p30);

    if p28 then
        FXUtil.SetAllBasePartsTransparency(p28, 1);
    end;

    p28:PivotTo(p29);
    p28.Parent = workspace.Debris;
    FXUtil.Emit_Particles_GetDescendants(p28, true);
end;

local function buildCubicBezierPoints(p31, p32) -- Line: 257
    -- upvalues: BezierCurve (copy)
    local Magnitude = (p32 - p31).Magnitude;

    if Magnitude < 0.05 then
        return { p31, p32 };
    end;

    local v33 = Magnitude * 0.5;
    local v34, v35 = BezierCurve.Get2MiddlePosition(p31, p32, 80, v33 * 0.55, 0.33, 65, v33 * 0.4, 0.66);

    return {
        p31,
        v34,
        v35,
        p32
    };
end;

local function prepareFlightPlan(p36, p37) -- Line: 282
    -- upvalues: buildCubicBezierPoints (copy), BezierCurve (copy)
    local v38 = buildCubicBezierPoints(p36, p37);
    local v39 = BezierCurve.EstimateFlightTime(v38, 180, 2.95);
    local v40 = v39 < 0.0001 and 0.0001 or v39;

    return v38, v40, v40 * 60, 60;
end;

local function applyHitboxVisibility(p41, p42) -- Line: 291
    if not p41 then
        return;
    end;

    p41.Transparency = 1;
end;

local function isInProjectileFlying(p43) -- Line: 302
    local v44 = p43.GetCurrentState and p43:GetCurrentState() == "ProjectileFlying";

    return v44;
end;

local function stopClientProjectileFlight(p45) -- Line: 306
    local skillRunData = p45.skillRunData;

    if not skillRunData then
        return;
    end;

    local v46 = skillRunData.Visual and skillRunData.Visual.projectileMotion;

    if v46 then
        v46:Disconnect();
        skillRunData.Visual.projectileMotion = nil;
    end;
end;

local function stopServerProjectileFlight(p47) -- Line: 318
    local skillRunData = p47.skillRunData;

    if not (skillRunData and skillRunData.Logic) then
        return;
    end;

    skillRunData.Logic.flightEndToken = nil;
end;

local function playClientExplosion(p48, p49) -- Line: 326
    -- upvalues: SkillCommon (copy), FXUtil (copy), setElectricBallParticleTrailEnabled (copy)
    local skillRunData = p48.skillRunData;

    if not skillRunData then
        return;
    end;

    local v50 = SkillCommon.npcSummonBodySkillScale(p48);
    local v51 = v50 * 32;
    local v52 = skillRunData.Visual and skillRunData.Visual.projectileModel;
    local v53 = skillRunData.material and skillRunData.material["电球爆炸-暗"];
    local skillRunData2 = p48.skillRunData;

    if skillRunData2 then
        local v54 = skillRunData2.Visual and skillRunData2.Visual.projectileMotion;

        if v54 then
            v54:Disconnect();
            skillRunData2.Visual.projectileMotion = nil;
        end;
    end;

    if v52 then
        FXUtil.Stop_All_Emit(v52);
        setElectricBallParticleTrailEnabled(v52, false);

        if v52 then
            FXUtil.SetAllBasePartsTransparency(v52, 1);
        end;
    end;

    SkillCommon.playSoundLocal3D("音效-技能-独角兽-雷光球-攻击爆炸", p49);

    if v53 then
        if v53 then
            FXUtil.SetAllBasePartsTransparency(v53, 1);
        end;

        v53:ScaleTo(v50);
        v53:PivotTo(CFrame.new(p49));
        v53.Parent = workspace.Debris;
        FXUtil.Emit_Particles_GetDescendants(v53, true);
    end;

    local v55 = p48.skillInputData and p48.skillInputData.releaseCF;
    local v56;

    if v55 then
        local v57 = p49 - v55.Position;
        local v58 = Vector3.new(v57.X, 0, v57.Z);
        v56 = v58.Magnitude <= 0.05 and Vector3.new(0, 0, -1) or v58;
    else
        v56 = Vector3.new(0, 0, -1);
    end;

    local v59 = FXUtil.GetGroundAlignedCF(p49, v56, "Ground", 3, 0.12);
    local v60;

    if v59 then
        if (p49 - v59.Position).Magnitude < v51 then
            v60 = true;
        else
            v60 = false;
            v59 = nil;
        end;
    else
        v60 = false;
        v59 = nil;
    end;

    if v60 and v59 then
        local v61 = skillRunData.material and skillRunData.material["电球爆炸地面特效-暗"];

        if not v61 then
            return;
        end;

        v61:ScaleTo(v50);

        if v61 then
            FXUtil.SetAllBasePartsTransparency(v61, 1);
        end;

        v61:PivotTo(v59);
        v61.Parent = workspace.Debris;
        FXUtil.Emit_Particles_GetDescendants(v61, true);
    end;
end;

local function playServerExplosion(u62, p63) -- Line: 354
    -- upvalues: SkillCommon (copy), SkillEventConst (copy)
    local v64 = SkillCommon.npcSummonBodySkillScale(u62);
    local u65 = u62.hitbox[2];

    if u65 and u65.hitbox then
        local hitbox = u65.hitbox;
        hitbox.Size = Vector3.new(32, 32, 32) * v64;
        hitbox:PivotTo(CFrame.new(p63));
        task.delay(0.2, function() -- Line: 362
            -- upvalues: u62 (copy), u65 (copy), hitbox (copy)
            if u62.skillRunData and u65.hitbox then
                local v66 = u62;
                local v67 = v66.GetCurrentState and v66:GetCurrentState() == "ProjectileFlying";

                if v67 then
                    local v68 = hitbox;

                    if v68 then
                        v68.Transparency = 1;
                    end;

                    u65:start();
                    task.delay(0.15, function() -- Line: 369
                        -- upvalues: u65 (ref), hitbox (ref)
                        if u65.isActive then
                            u65:stop();
                        end;

                        local v69 = hitbox;

                        if not v69 then
                            return;
                        end;

                        v69.Transparency = 1;
                    end);
                end;
            end;
        end);
    end;

    u62:fireProjectileHitConfirmed(p63, u62.skillRunData.Logic.impactType or SkillEventConst.HitType.Timeout, u62.skillRunData.Logic.impactTargetId);
end;

local function shouldTriggerExplosion(p70) -- Line: 385
    if not p70 then
        return false;
    end;

    p70.Logic = p70.Logic or {};

    return not p70.Logic.hasExploded;
end;

local function markExplosionTriggered(p71, p72, p73) -- Line: 393
    -- upvalues: SkillEventConst (copy)
    p71.Logic.hasExploded = true;
    p71.Logic.impactPosition = p72;
    p71.Logic.impactType = p73 or SkillEventConst.HitType.Timeout;
end;

local function tryTriggerExplosionClient(p74, p75, p76) -- Line: 399
    -- upvalues: SkillEventConst (copy), playClientExplosion (copy)
    local v77 = p74.GetCurrentState and p74:GetCurrentState() == "ProjectileFlying";

    if not v77 then
        return false;
    end;

    local skillRunData = p74.skillRunData;
    local v78;

    if skillRunData then
        skillRunData.Logic = skillRunData.Logic or {};
        v78 = not skillRunData.Logic.hasExploded;
    else
        v78 = false;
    end;

    if not v78 then
        return false;
    end;

    skillRunData.Logic.hasExploded = true;
    skillRunData.Logic.impactPosition = p75;
    skillRunData.Logic.impactType = p76 or SkillEventConst.HitType.Timeout;
    playClientExplosion(p74, p75);

    return true;
end;

local function tryTriggerExplosionServer(p79, p80, p81) -- Line: 412
    -- upvalues: SkillEventConst (copy), playServerExplosion (copy)
    local v82 = p79.GetCurrentState and p79:GetCurrentState() == "ProjectileFlying";

    if not v82 then
        return false;
    end;

    local skillRunData = p79.skillRunData;
    local v83;

    if skillRunData then
        skillRunData.Logic = skillRunData.Logic or {};
        v83 = not skillRunData.Logic.hasExploded;
    else
        v83 = false;
    end;

    if not v83 then
        return false;
    end;

    skillRunData.Logic.hasExploded = true;
    skillRunData.Logic.impactPosition = p80;
    skillRunData.Logic.impactType = p81 or SkillEventConst.HitType.Timeout;
    local skillRunData2 = p79.skillRunData;

    if skillRunData2 and skillRunData2.Logic then
        skillRunData2.Logic.flightEndToken = nil;
    end;

    playServerExplosion(p79, p80);

    return true;
end;

function u1.Client_EnterStartup(p84) -- Line: 427
end;

function u1.Server_EnterStartup(p85) -- Line: 429
    local v86 = p85.hitbox[2];

    if v86 and v86.hitbox then
        v86.hitbox.Size = Vector3.new(32, 32, 32);
    end;
end;

function u1.Client_EnterProjectileFlying(u87) -- Line: 437
    -- upvalues: SkillCommon (copy), getLaunchCF (copy), ProjectileCore (copy), FXUtil (copy), setElectricBallParticleTrailEnabled (copy), buildCubicBezierPoints (copy), BezierCurve (copy), SkillEventConst (copy), playClientExplosion (copy), u1 (copy)
    SkillCommon.refreshSkillAimSnapshot(u87);

    if not u87.skillInputData.character then
        return;
    end;

    local skillRunData = u87.skillRunData;
    local material = skillRunData.material;
    local v88 = SkillCommon.npcSummonBodySkillScale(u87);
    local v89 = getLaunchCF(u87);
    local Position = getLaunchCF(u87).Position;
    local v90 = u87:getTargetCF().Position + Vector3.new(0, 0.5, 0);
    local u91 = ProjectileCore.clampProjectileEndToMaxRange(Position, v90, 180, 3);
    local v92 = material["电球-暗"];
    local v93 = material["电球爆炸-暗"];

    if not v92 then
        return;
    end;

    v92:ScaleTo(v88);
    v92:PivotTo(CFrame.lookAt(v89.Position, u91));
    v92.Parent = workspace.Debris;

    if v92 then
        FXUtil.SetAllBasePartsTransparency(v92, 1);
    end;

    setElectricBallParticleTrailEnabled(v92, true);
    FXUtil.Start_All_Trail(v92);
    FXUtil.Start_All_Emit(v92, 10);
    SkillCommon.playSoundLocal3D("音效-技能-独角兽-雷光球-飞行", v89.Position);

    if v93 then
        v93:ScaleTo(v88);
        v93:PivotTo(CFrame.new(u91));
        v93.Parent = workspace.Debris;

        if v93 then
            FXUtil.SetAllBasePartsTransparency(v93, 1);
        end;
    end;

    skillRunData.Visual = skillRunData.Visual or {};
    skillRunData.Visual.projectileModel = v92;
    skillRunData.Visual.ownerPredictsExplosion = true;
    skillRunData.Logic = skillRunData.Logic or {};
    skillRunData.Logic.hasExploded = false;
    skillRunData.Logic.impactPosition = u91;
    local v94 = buildCubicBezierPoints(v89.Position, u91);
    local v95 = BezierCurve.EstimateFlightTime(v94, 180, 2.95);
    local v100 = BezierCurve.MultiOrderBezierCurves({
        Frame = (v95 < 0.0001 and 0.0001 or v95) * 60,
        FPS = 60,
        Points = v94,
        Target = v92,
        EasingStyle = Enum.EasingStyle.Sine,
        EasingDirection = Enum.EasingDirection.In
    }, function() -- Line: 485
        -- upvalues: u87 (copy), u91 (copy), SkillEventConst (ref), playClientExplosion (ref)
        local v96 = u87;
        local v97 = u91;
        local Timeout = SkillEventConst.HitType.Timeout;
        local v98 = v96.GetCurrentState and v96:GetCurrentState() == "ProjectileFlying";

        if not v98 then
            return;
        end;

        local skillRunData2 = v96.skillRunData;
        local v99;

        if skillRunData2 then
            skillRunData2.Logic = skillRunData2.Logic or {};
            v99 = not skillRunData2.Logic.hasExploded;
        else
            v99 = false;
        end;

        if not v99 then
            return;
        end;

        skillRunData2.Logic.hasExploded = true;
        skillRunData2.Logic.impactPosition = v97;
        skillRunData2.Logic.impactType = Timeout or SkillEventConst.HitType.Timeout;
        playClientExplosion(v96, v97);
    end);
    skillRunData.Visual.projectileMotion = v100;
    table.insert(skillRunData.runEvent, v100);
    local pendingProjectileHitEvent = skillRunData.Visual.pendingProjectileHitEvent;

    if pendingProjectileHitEvent then
        skillRunData.Visual.pendingProjectileHitEvent = nil;
        v100:Disconnect();
        skillRunData.Visual.projectileMotion = nil;
        u1.onServerEvent(u87, pendingProjectileHitEvent);
    end;
end;

function u1.Client_ExitProjectileFlying(p101) -- Line: 500
    -- upvalues: SkillEventConst (copy), playClientExplosion (copy)
    local skillRunData = p101.skillRunData;

    if skillRunData then
        local v102 = skillRunData.Visual and skillRunData.Visual.projectileMotion;

        if v102 then
            v102:Disconnect();
            skillRunData.Visual.projectileMotion = nil;
        end;
    end;

    local skillRunData2 = p101.skillRunData;
    local v103 = skillRunData2 and skillRunData2.Logic and skillRunData2.Logic.impactPosition;

    if v103 and (skillRunData2.Logic and not skillRunData2.Logic.hasExploded) then
        local Timeout = SkillEventConst.HitType.Timeout;
        local v104 = p101.GetCurrentState and p101:GetCurrentState() == "ProjectileFlying";

        if not v104 then
            return;
        end;

        local skillRunData3 = p101.skillRunData;
        local v105;

        if skillRunData3 then
            skillRunData3.Logic = skillRunData3.Logic or {};
            v105 = not skillRunData3.Logic.hasExploded;
        else
            v105 = false;
        end;

        if not v105 then
            return;
        end;

        skillRunData3.Logic.hasExploded = true;
        skillRunData3.Logic.impactPosition = v103;
        skillRunData3.Logic.impactType = Timeout or SkillEventConst.HitType.Timeout;
        playClientExplosion(p101, v103);
    end;
end;

function u1.Server_EnterProjectileFlying(u106) -- Line: 509
    -- upvalues: SkillCommon (copy), getLaunchCF (copy), ProjectileCore (copy), buildCubicBezierPoints (copy), BezierCurve (copy), tryTriggerExplosionServer (copy), SkillEventConst (copy)
    SkillCommon.refreshSkillAimSnapshot(u106);
    local v107 = u106.hitbox[2];

    if not (v107 and v107.hitbox) then
        return;
    end;

    local skillRunData = u106.skillRunData;
    skillRunData.Logic = skillRunData.Logic or {};
    skillRunData.Logic.hasExploded = false;
    local v108 = getLaunchCF(u106);
    local Position = getLaunchCF(u106).Position;
    local v109 = u106:getTargetCF().Position + Vector3.new(0, 0.5, 0);
    local u110 = ProjectileCore.clampProjectileEndToMaxRange(Position, v109, 180, 3);
    skillRunData.Logic.projectileLastPosition = v108.Position;
    skillRunData.Logic.impactPosition = u110;
    local v111 = buildCubicBezierPoints(v108.Position, u110);
    local v112 = BezierCurve.EstimateFlightTime(v111, 180, 2.95);
    local v113 = v112 < 0.0001 and 0.0001 or v112;
    local _ = v113 * 60;
    local u114 = {};
    skillRunData.Logic.flightEndToken = u114;
    task.delay(v113, function() -- Line: 530
        -- upvalues: skillRunData (copy), u114 (copy), tryTriggerExplosionServer (ref), u106 (copy), u110 (copy), SkillEventConst (ref)
        if not skillRunData.Logic or skillRunData.Logic.flightEndToken ~= u114 then
            return;
        end;

        tryTriggerExplosionServer(u106, u110, SkillEventConst.HitType.Timeout);
    end);
end;

function u1.Server_ExitProjectileFlying(p115) -- Line: 538
    -- upvalues: tryTriggerExplosionServer (copy), SkillEventConst (copy)
    local skillRunData = p115.skillRunData;

    if skillRunData and skillRunData.Logic then
        skillRunData.Logic.flightEndToken = nil;
    end;

    local skillRunData2 = p115.skillRunData;
    local v116 = skillRunData2 and skillRunData2.Logic and skillRunData2.Logic.impactPosition;

    if v116 and (skillRunData2.Logic and not skillRunData2.Logic.hasExploded) then
        tryTriggerExplosionServer(p115, v116, SkillEventConst.HitType.Timeout);
    end;
end;

function u1.Server_EnterRecovery(p117) -- Line: 548
    p117:releaseControl();
end;

function u1.Client_EnterRecovery(p118) -- Line: 552
end;

function u1.onServerEvent(p119, p120) -- Line: 555
    -- upvalues: SkillEventConst (copy), playClientExplosion (copy)
    if p120.eventType ~= SkillEventConst.SyncEventType.ProjectileHitConfirmed then
        return;
    end;

    local skillRunData = p119.skillRunData;

    if not skillRunData then
        return;
    end;

    local hitPosition = p120.hitPosition;

    if not hitPosition then
        return;
    end;

    local v121 = p119.GetCurrentState and p119:GetCurrentState();

    if v121 == "Recovery" or v121 == "Finished" then
        return;
    end;

    if skillRunData.Visual and (skillRunData.Visual.ownerPredictsExplosion and v121 ~= "ProjectileFlying") then
        return;
    end;

    if v121 ~= "ProjectileFlying" then
        skillRunData.Visual = skillRunData.Visual or {};
        skillRunData.Visual.pendingProjectileHitEvent = p120;

        return;
    end;

    local v122 = p120.hitType or SkillEventConst.HitType.Timeout;
    local v123 = p119.GetCurrentState and p119:GetCurrentState() == "ProjectileFlying";

    if not v123 then
        return;
    end;

    local skillRunData2 = p119.skillRunData;
    local v124;

    if skillRunData2 then
        skillRunData2.Logic = skillRunData2.Logic or {};
        v124 = not skillRunData2.Logic.hasExploded;
    else
        v124 = false;
    end;

    if not v124 then
        return;
    end;

    skillRunData2.Logic.hasExploded = true;
    skillRunData2.Logic.impactPosition = hitPosition;
    skillRunData2.Logic.impactType = v122 or SkillEventConst.HitType.Timeout;
    playClientExplosion(p119, hitPosition);
end;

function u1.onProjectileHitServer(p125, p126, p127) -- Line: 586
    if not p126 or p126.hitboxIndex ~= 2 then
        return;
    end;

    if not p125.hitbox[2] then
        return;
    end;

    local skillRunData = p125.skillRunData;

    if not (skillRunData and skillRunData.State) then
        return;
    end;

    if not (skillRunData.Logic and skillRunData.Logic.hasExploded) then
        return;
    end;

    local HitResolver = require(script.Parent.Parent.BaseSkill.HitResolver);

    for i, v in p127 do
        HitResolver.applyHit(p125, p126, v, i, {
            damageProfileId = "ExplosionMain",
            hitboxIndex = 2,
            sourceState = "ProjectileFlying",
            skillName = p125.skillName,
            skillCastId = p125.skillCastId,
            baseSkillInstanceId = p125.baseSkillInstanceId,
            activeBaseSkillIndex = p125.activeBaseSkillIndex,
            skillPower = p125.skillPower,
            skillPurity = p125.skillPurity,
            combatSeed = p125.combatSeed
        });
    end;
end;

u1.SoundList = { "音效-技能-独角兽-雷光球-攻击爆炸", "音效-技能-独角兽-雷光球-飞行" };
u1.AnimateList = { "电球" };
u1.ResNameList = { "电球-暗", "电球爆炸-暗", "电球爆炸地面特效-暗" };
u1.hitboxConfig = { {
        HitboxIndex = 2,
        PartName = "通用球",
        CollisionGroup = "Player",
        HitPresentationProfile = "通用受击",
        PhysicsEffectName = "通用受击物理效果",
        HitPolicy = {
            hitOncePerTarget = true
        }
    } };
u1.DamageProfiles = {
    ExplosionMain = {
        damageRate = 1,
        canCritical = true,
        showDamageText = true,
        randomOffset = 0.05,
        elementType = ElementTp.Thunder,
        damageTags = { "Magic", "Projectile", "Explosion" }
    }
};
u1.Action = {
    {
        action = "Animation",
        startTime = 0,
        overTime = 1.44,
        animationName = "电球",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action4
    }
};

return u1;