-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local FXUtil = UtilsSystem.FXUtil;
local VisibleMgr = UtilsSystem.VisibleMgr;
local MathMgr = UtilsSystem.MathMgr;
local RunService = UtilsSystem.RunService;
local SkillTelegraph = UtilsSystem.SkillTelegraph;
local TweenService = game:GetService("TweenService");
local v1 = {};
local u2 = {
    {
        flightSec = 2.6,
        spiralEndMinDist = 25,
        spiralNearExpandStuds = 40,
        finalStraightStuds = 10,
        spiralAmpScale = 1,
        aimOffsetRight = 0,
        spiralPhaseOffsetDeg = 0,
        easingStyle = Enum.EasingStyle.Quad,
        easingDirection = Enum.EasingDirection.In
    },
    {
        flightSec = 3.4,
        spiralEndMinDist = 25,
        spiralNearExpandStuds = 80,
        finalStraightStuds = 15,
        spiralAmpScale = 1,
        aimOffsetRight = 0,
        spiralPhaseOffsetDeg = -90,
        easingStyle = Enum.EasingStyle.Quad,
        easingDirection = Enum.EasingDirection.In
    },
    {
        flightSec = 4,
        spiralEndMinDist = 25,
        spiralNearExpandStuds = 120,
        finalStraightStuds = 20,
        spiralAmpScale = 1,
        aimOffsetRight = 0,
        spiralPhaseOffsetDeg = -180,
        easingStyle = Enum.EasingStyle.Quad,
        easingDirection = Enum.EasingDirection.In
    }
};

local function getShotProfile(p3) -- Line: 78
    -- upvalues: u2 (copy)
    return u2[p3] or u2[1];
end;

local function shotFireAbsTime(p4) -- Line: 82
    return (p4 - 1) * 0.3 + 1.1;
end;

local function shotImpactAbsTime(p5) -- Line: 86
    -- upvalues: u2 (copy)
    return (p5 - 1) * 0.3 + 1.1 + (u2[p5] or u2[1]).flightSec;
end;

local function maxImpactAbsTime() -- Line: 90
    -- upvalues: u2 (copy)
    local v6 = math.max(0, 1.1 + (u2[1] or u2[1]).flightSec);
    local v7 = math.max(v6, 1.4000000000000001 + (u2[2] or u2[1]).flightSec);

    return math.max(v7, 1.7000000000000002 + (u2[3] or u2[1]).flightSec);
end;

local function shot3StateDuration() -- Line: 102
    -- upvalues: u2 (copy)
    local v8 = math.max(0, 1.1 + (u2[1] or u2[1]).flightSec);
    local v9 = math.max(v8, 1.4000000000000001 + (u2[2] or u2[1]).flightSec);
    local v10 = math.max(v9, 1.7000000000000002 + (u2[3] or u2[1]).flightSec) - 1.7000000000000002;

    return math.max(0, v10) + 2;
end;

v1.skillTotalTime = -1;
local v11 = math.max(0, 1.1 + u2[1].flightSec);
local v12 = math.max(v11, 1.4000000000000001 + (u2[2] or u2[1]).flightSec);
v1.visualFadeoutTime = math.max(v12, 1.7000000000000002 + (u2[3] or u2[1]).flightSec) - 1.1 + 2;
v1.skillElementType = ElementTp.Dark;
v1.skillDistanceLimit = 64;
local u13 = CFrame.Angles(0, 0, 0);
local u14 = { "幽灵冲击骷髅Emit和Enabled", "幽灵召唤出现特效", "幽灵冲击爆炸", "幽灵冲击爆炸地面特效", "幽灵冲击枪口特效" };

local function resKey(p15, p16) -- Line: 150
    if p16 == 1 then
        return p15;
    end;

    return p15 .. p16;
end;

local function hasActiveClientProjectiles(p17) -- Line: 159
    local v18 = p17.GhostShootClient and p17.GhostShootClient.projectiles;

    if not v18 then
        return false;
    end;

    for _, v in v18 do
        if v and not v.impacted then
            return true;
        end;
    end;

    return false;
end;

local function hasActiveServerProjectiles(p19) -- Line: 172
    local v20 = p19.GhostShootServer and p19.GhostShootServer.projectiles;

    if not v20 then
        return false;
    end;

    for _, v in v20 do
        if v and not v.impacted then
            return true;
        end;
    end;

    return false;
end;

local function cleanupRunFx(p21, p22) -- Line: 185
    -- upvalues: SkillCommon (copy)
    local skillRunData = p21.skillRunData;

    if not (skillRunData and skillRunData.runEvent) then
        return;
    end;

    local runEvent = skillRunData.runEvent;
    local v23 = {};

    if runEvent["幽灵射击弹道"] then
        if p22 then
            table.insert(v23, "幽灵射击弹道");
        else
            local v24 = skillRunData.GhostShootClient and skillRunData.GhostShootClient.projectiles;
            local v25;

            if v24 then
                v25 = false;

                for _, v in v24 do
                    if v and not v.impacted then
                        v25 = true;
                        break;
                    end;
                end;
            else
                v25 = false;
            end;

            if not v25 then
                table.insert(v23, "幽灵射击弹道");
            end;
        end;
    end;

    if runEvent["幽灵射击命中盒"] then
        if p22 then
            table.insert(v23, "幽灵射击命中盒");
        else
            local v26 = skillRunData.GhostShootServer and skillRunData.GhostShootServer.projectiles;
            local v27;

            if v26 then
                v27 = false;

                for _, v in v26 do
                    if v and not v.impacted then
                        v27 = true;
                        break;
                    end;
                end;
            else
                v27 = false;
            end;

            if not v27 then
                table.insert(v23, "幽灵射击命中盒");
            end;
        end;
    end;

    if #v23 > 0 then
        SkillCommon.disconnectRunEventKeys(skillRunData, v23);
    end;
end;

local function stopContinuousFx(p28) -- Line: 203
    -- upvalues: FXUtil (copy), VisibleMgr (copy)
    if not (p28 and p28.Parent) then
        return;
    end;

    FXUtil.Stop_All_Emit(p28);
    FXUtil.SetEmittersTrailsBeamsEnabled(p28, false);
    FXUtil.OffEnableVfx(p28);
    VisibleMgr.fadeAllTween(p28, 1, nil, 0.2);
end;

local function resolveImpactHitboxSize(p29) -- Line: 220
    local v30 = p29 * 28;

    return Vector3.new(v30, v30, v30);
end;

local function destroyDangerTelegraphs(p31) -- Line: 230
    if not (p31 and p31.Logic) then
        return;
    end;

    local dangerTelegraphs = p31.Logic.dangerTelegraphs;

    if not dangerTelegraphs then
        return;
    end;

    for i, v in dangerTelegraphs do
        if v then
            v:destroy();
        end;

        dangerTelegraphs[i] = nil;
    end;

    p31.Logic.dangerTelegraphs = nil;
end;

local function isInterruptedCancel(p32) -- Line: 253
    if not p32 then
        return false;
    end;

    if p32.flowState == "Interrupted" or p32.finishReason == "Interrupted" then
        return true;
    end;

    local skillRunData = p32.skillRunData;
    local v33;

    if skillRunData == nil or skillRunData.Logic == nil then
        v33 = false;
    else
        v33 = skillRunData.Logic.combatCancelled == true;
    end;

    return v33;
end;

local function markCombatCancelled(p34) -- Line: 264
    if not p34 then
        return;
    end;

    p34.Logic = p34.Logic or {};
    p34.Logic.combatCancelled = true;
end;

local function sameRun(p35, p36) -- Line: 332
    return p35.runGeneration == p36;
end;

local function shouldKeepClientProjectileMotion(p37, p38, p39) -- Line: 339
    if p37.runGeneration ~= p38 then
        return false;
    end;

    local v40;

    if p37 then
        if p37.flowState == "Interrupted" or p37.finishReason == "Interrupted" then
            v40 = true;
        else
            local skillRunData = p37.skillRunData;

            if skillRunData == nil or skillRunData.Logic == nil then
                v40 = false;
            else
                v40 = skillRunData.Logic.combatCancelled == true;
            end;
        end;
    else
        v40 = false;
    end;

    if v40 then
        return false;
    end;

    if p37:isRunningFlow() then
        return true;
    end;

    local v41 = p39.GhostShootClient and p39.GhostShootClient.projectiles;

    if not v41 then
        return false;
    end;

    for _, v in v41 do
        if v and not v.impacted then
            return true;
        end;
    end;

    return false;
end;

local function shouldKeepServerProjectileMotion(p42, p43, p44) -- Line: 352
    if p42.runGeneration ~= p43 then
        return false;
    end;

    local v45;

    if p42 then
        if p42.flowState == "Interrupted" or p42.finishReason == "Interrupted" then
            v45 = true;
        else
            local skillRunData = p42.skillRunData;

            if skillRunData == nil or skillRunData.Logic == nil then
                v45 = false;
            else
                v45 = skillRunData.Logic.combatCancelled == true;
            end;
        end;
    else
        v45 = false;
    end;

    if v45 then
        return false;
    end;

    if p42:isRunningFlow() then
        return true;
    end;

    local v46 = p44.GhostShootServer and p44.GhostShootServer.projectiles;

    if not v46 then
        return false;
    end;

    for _, v in v46 do
        if v and not v.impacted then
            return true;
        end;
    end;

    return false;
end;

local function strikePosAfterRefresh(p47) -- Line: 365
    -- upvalues: SkillCommon (copy)
    SkillCommon.refreshSkillAimSnapshot(p47);
    local skillInputData = p47.skillInputData;

    if skillInputData then
        return SkillCommon.resolveStrikeWorldPos(skillInputData);
    end;

    return p47:getTargetCF().Position;
end;

local function resolveLiveStrikePos(p48, p49) -- Line: 374
    -- upvalues: SkillCommon (copy)
    if p48 then
        p48 = SkillCommon.resolveTrackTargetHrp(p48);
    end;

    if p48 and p48.Parent then
        return p48.Position;
    end;

    return p49;
end;

local function resolveLiveEndForProjectile(p50, p51) -- Line: 382
    -- upvalues: SkillCommon (copy)
    if p51.frozenEnd then
        return p51.frozenEnd;
    end;

    if not p50 then
        return p51.snapEnd0;
    end;

    local snapEnd0 = p51.snapEnd0;

    if p50 then
        p50 = SkillCommon.resolveTrackTargetHrp(p50);
    end;

    if p50 and p50.Parent then
        return p50.Position;
    end;

    return snapEnd0;
end;

local function tryFreezeProjectileEnd(p52, p53) -- Line: 398
    -- upvalues: SkillCommon (copy)
    if p53.frozenEnd or p53.impacted then
        return;
    end;

    if math.max(0, p53.flightSec - 0.5) > p53.moveT then
        return;
    end;

    if not p52 then
        p53.frozenEnd = p53.snapEnd0;

        return;
    end;

    local snapEnd0 = p53.snapEnd0;

    if p52 then
        p52 = SkillCommon.resolveTrackTargetHrp(p52);
    end;

    if p52 and p52.Parent then
        snapEnd0 = p52.Position;
    end;

    p53.frozenEnd = snapEnd0;
end;

local function evaluateCubicBezier(p54, p55, p56, p57, p58) -- Line: 415
    local v59 = math.clamp(p58, 0, 1);
    local v60 = 1 - v59;

    return v60 * v60 * v60 * p54 + v60 * 3 * v60 * v59 * p55 + v60 * 3 * v59 * v59 * p56 + v59 * v59 * v59 * p57;
end;

local function cubicBezierTangent(p61, p62, p63, p64, p65) -- Line: 421
    local v66 = math.clamp(p65 - 0.002, 0, 1);
    local v67 = math.clamp(p65 + 0.002, 0, 1);

    if v67 - v66 < 1e-6 then
        local v68 = p64 - p61;

        return v68.Magnitude <= 0.0001 and Vector3.new(0, 0, -1) or v68.Unit;
    end;

    local v69 = math.clamp(v67, 0, 1);
    local v70 = 1 - v69;
    local v71 = math.clamp(v66, 0, 1);
    local v72 = 1 - v71;
    local v73 = v70 * v70 * v70 * p61 + v70 * 3 * v70 * v69 * p62 + v70 * 3 * v69 * v69 * p63 + v69 * v69 * v69 * p64 - (v72 * v72 * v72 * p61 + v72 * 3 * v72 * v71 * p62 + v72 * 3 * v71 * v71 * p63 + v71 * v71 * v71 * p64);

    return v73.Magnitude <= 0.0001 and Vector3.new(0, 0, -1) or v73.Unit;
end;

local function ensureBezierEndState(p74, p75) -- Line: 432
    -- upvalues: MathMgr (copy)
    if p74.bezierP0 then
        return;
    end;

    local v76, v77 = MathMgr.spiralFibLikeChordPosTangent(p74.skullStart, p74.snapEnd0, MathMgr.SPIRAL_FIB_SPIRAL_U_PORTION, p74.spiralAmp, p74.spiralEndMinDist, p74.finalStraightStuds, p74.spiralNearExpandStuds, p74.spiralPhaseOffsetRad or 0, p74.spiralUpLiftStuds);
    local v78 = p75 - v76;
    local v79 = v78.Magnitude * 0.6666666666666666;
    local v80;

    if v77.Magnitude < 0.0001 then
        v80 = v78.Magnitude <= 0.0001 and Vector3.new(0, 0, -1) or v78.Unit;
    else
        v80 = v77.Unit;
    end;

    p74.bezierP0 = v76;
    p74.bezierP1 = v76 + v80 * v79;
    p74.bezierArmLen = v79;
end;

local function kAtSpiralEnd(p81, p82) -- Line: 466
    if p81.easingStyle == Enum.EasingStyle.Quad and p81.easingDirection == Enum.EasingDirection.In then
        return math.sqrt(p82);
    end;

    return p82;
end;

local function flatHintFromTo(p83, p84) -- Line: 544
    local v85 = Vector3.new(p84.X - p83.X, 0, p84.Z - p83.Z);

    return v85.Magnitude <= 0.05 and Vector3.new(0, 0, -1) or v85;
end;

local function getSpiralPhaseOffsetRad(p86) -- Line: 607
    -- upvalues: u2 (copy)
    local v87 = (u2[p86] or u2[1]).spiralPhaseOffsetDeg or 0;

    return math.abs(v87) < 0.0001 and 0 or math.rad(v87);
end;

v1.InitialState = "Startup";
v1.ControlOpenState = "Shot1";
local v88 = {
    Startup = {
        Duration = 1.1,
        OnEnterClient = "Client_EnterStartup",
        OnEnterServer = "Server_EnterStartup"
    },
    Shot1 = {
        Duration = 0.3,
        OnEnterClient = "Client_EnterShot1",
        OnEnterServer = "Server_EnterShot1"
    },
    Shot2 = {
        Duration = 0.3,
        OnEnterClient = "Client_EnterShot2",
        OnEnterServer = "Server_EnterShot2"
    }
};
local v89 = {
    OnEnterClient = "Client_EnterShot3",
    OnEnterServer = "Server_EnterShot3",
    OnExitClient = "Client_ExitShot3",
    OnExitServer = "Server_ExitShot3"
};
local v90 = math.max(0, 1.1 + u2[1].flightSec);
local v91 = math.max(v90, 1.4000000000000001 + (u2[2] or u2[1]).flightSec);
local v92 = math.max(v91, 1.7000000000000002 + (u2[3] or u2[1]).flightSec) - 1.7000000000000002;
v89.Duration = math.max(0, v92) + 2;
v88.Shot3 = v89;
v88.Recovery = {
    Duration = 0.2,
    OnEnterClient = "Client_EnterRecovery",
    OnEnterServer = "Server_EnterRecovery"
};
v88.Finished = {
    Duration = 0,
    IsTerminal = true
};
v88.Interrupted = {
    Duration = 0,
    IsTerminal = true,
    OnEnterClient = "Client_EnterInterrupted",
    OnEnterServer = "Server_EnterInterrupted"
};
v1.States = v88;
v1.Transitions = {
    {
        From = "Startup",
        To = "Shot1",
        Event = SkillEventConst.StateTimeout
    },
    {
        From = "Shot1",
        To = "Shot2",
        Event = SkillEventConst.StateTimeout
    },
    {
        From = "Shot2",
        To = "Shot3",
        Event = SkillEventConst.StateTimeout
    },
    {
        From = "Shot3",
        To = "Recovery",
        Event = SkillEventConst.StateTimeout
    },
    {
        From = "Recovery",
        To = "Finished",
        Event = SkillEventConst.StateTimeout
    }
};

local function cleanupClientVisualsImmediate(p93) -- Line: 272
    -- upvalues: SkillCommon (copy), stopContinuousFx (copy), cleanupRunFx (copy), destroyDangerTelegraphs (copy), u14 (copy)
    local skillRunData = p93.skillRunData;

    if not skillRunData then
        return;
    end;

    if skillRunData then
        skillRunData.Logic = skillRunData.Logic or {};
        skillRunData.Logic.combatCancelled = true;
    end;

    SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "暗系尾迹2", "幽灵射击Cast尾迹");
    local GhostShootClient = skillRunData.GhostShootClient;

    if GhostShootClient and GhostShootClient.projectiles then
        for _, v in GhostShootClient.projectiles do
            if v then
                v.impacted = true;
                v.frozenEnd = nil;
                stopContinuousFx(v.skull);
            end;
        end;
    end;

    cleanupRunFx(p93, true);
    destroyDangerTelegraphs(skillRunData);
    local ghostShootSpawns = skillRunData.ghostShootSpawns;

    if ghostShootSpawns then
        for _, v in ghostShootSpawns do
            stopContinuousFx(v);
        end;
    end;

    for _, v in u14 do
        for i = 1, 3 do
            local material = skillRunData.material;

            if material then
                local v94;

                if i == 1 then
                    v94 = v;
                else
                    v94 = v .. i;
                end;

                material = skillRunData.material[v94];
            end;

            if material and material.Parent then
                stopContinuousFx(material);
            end;
        end;
    end;
end;

local function cleanupServerOnInterrupt(p95) -- Line: 312
    -- upvalues: cleanupRunFx (copy)
    local skillRunData = p95.skillRunData;

    if skillRunData then
        skillRunData.Logic = skillRunData.Logic or {};
        skillRunData.Logic.combatCancelled = true;
    end;

    if skillRunData and (skillRunData.GhostShootServer and skillRunData.GhostShootServer.projectiles) then
        for _, v in skillRunData.GhostShootServer.projectiles do
            if v then
                v.impacted = true;
                v.frozenEnd = nil;
            end;
        end;
    end;

    cleanupRunFx(p95, true);
    local v96 = p95.hitbox[1];

    if v96 and v96.isActive then
        v96:stop();
    end;

    local v97 = p95.hitbox[2];

    if v97 and v97.isActive then
        v97:stop();
    end;

    local v98 = p95.hitbox[3];

    if v98 and v98.isActive then
        v98:stop();
    end;
end;

local function resolveShotPointWorldPos(p99) -- Line: 514
    if not p99 then
        return nil;
    end;

    local v100 = p99:FindFirstChild("当前手持");

    if not v100 then
        return nil;
    end;

    local ShotPoint = v100:FindFirstChild("ShotPoint");

    if not ShotPoint then
        return nil;
    end;

    local v101 = nil;

    if ShotPoint:IsA("BasePart") then
        v101 = ShotPoint.Position;
    elseif ShotPoint:IsA("Model") then
        v101 = ShotPoint:GetPivot().Position;
    elseif ShotPoint:IsA("Attachment") then
        v101 = ShotPoint.WorldPosition;
    end;

    if v101 then
        return v101 + Vector3.new(0, 4, 0);
    end;

    return nil;
end;

local function resolveShotSnapEnd(p102, p103, p104, p105) -- Line: 584
    -- upvalues: u2 (copy)
    local v106 = ((u2[p104] or u2[1]).aimOffsetRight or 0) * p105;

    if math.abs(v106) < 0.0001 then
        return p103;
    end;

    local HumanoidRootPart = p102:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return p103;
    end;

    local Position = HumanoidRootPart.Position;
    local v107 = Vector3.new(p103.X - Position.X, 0, p103.Z - Position.Z);

    if v107.Magnitude < 0.0001 then
        local LookVector = HumanoidRootPart.CFrame.LookVector;
        v107 = Vector3.new(LookVector.X, 0, LookVector.Z);
    end;

    if v107.Magnitude < 0.0001 then
        return p103;
    end;

    return p103 + Vector3.new(-v107.Z, 0, v107.X).Unit * v106;
end;

local function cloneShotMaterials(p108) -- Line: 569
    -- upvalues: u14 (copy)
    for _, v in u14 do
        local v109 = p108.material[v];

        if v109 then
            for i = 2, 3 do
                local v110;

                if i == 1 then
                    v110 = v;
                else
                    v110 = v .. i;
                end;

                if not p108.material[v110] then
                    p108.material[v110] = v109:Clone();
                end;
            end;
        end;
    end;
end;

local function playGroundExplosionFx(p111, p112, p113, p114, p115) -- Line: 552
    -- upvalues: FXUtil (copy), VisibleMgr (copy), SkillCommon (copy)
    local v116 = p111.material[p112];

    if not v116 then
        return;
    end;

    local v117 = FXUtil.GetGroundAlignedCF(p113, p114, "Ground", 3, 0.1) or CFrame.new(p113 + Vector3.new(0, 0.1, 0));
    VisibleMgr.UnQueryAll(v116);
    v116:ScaleTo(p115);
    v116:PivotTo(v117);
    v116.Parent = workspace.Debris;
    FXUtil.Emit_Particles_GetDescendants(v116, true);
    SkillCommon.appendRunSpawnList(p111, "ghostShootSpawns", v116);
end;

local function sampleProjectileMotion(p118, p119, p120) -- Line: 473
    -- upvalues: MathMgr (copy), TweenService (copy), ensureBezierEndState (copy), cubicBezierTangent (copy)
    local snapEnd0 = p118.snapEnd0;
    local v121 = p118.spiralPhaseOffsetRad or 0;
    local SPIRAL_FIB_SPIRAL_U_PORTION = MathMgr.SPIRAL_FIB_SPIRAL_U_PORTION;
    local v122 = TweenService:GetValue(p119, p118.easingStyle, p118.easingDirection);

    if v122 < SPIRAL_FIB_SPIRAL_U_PORTION - 0.0001 then
        return MathMgr.spiralFibLikeChordPosTangent(p118.skullStart, snapEnd0, v122, p118.spiralAmp, p118.spiralEndMinDist, p118.finalStraightStuds, p118.spiralNearExpandStuds, v121, p118.spiralUpLiftStuds);
    end;

    ensureBezierEndState(p118, p120);
    local bezierP0 = p118.bezierP0;
    local bezierP1 = p118.bezierP1;
    local v123 = p120 - bezierP0;
    local v124;

    if v123.Magnitude > 0.0001 then
        v124 = v123.Unit;
    else
        v124 = (bezierP1 - bezierP0).Unit;
    end;

    local v125 = p120 - (v124.Magnitude < 0.0001 and Vector3.new(0, 0, -1) or v124) * p118.bezierArmLen;

    if p118.easingStyle == Enum.EasingStyle.Quad and p118.easingDirection == Enum.EasingDirection.In then
        SPIRAL_FIB_SPIRAL_U_PORTION = math.sqrt(SPIRAL_FIB_SPIRAL_U_PORTION);
    end;

    local v126 = (p119 - SPIRAL_FIB_SPIRAL_U_PORTION) / math.max(1 - SPIRAL_FIB_SPIRAL_U_PORTION, 1e-6);
    local v127 = TweenService:GetValue(math.clamp(v126, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.In);
    local v128 = math.clamp(v127, 0, 1);
    local v129 = 1 - v128;

    return v129 * v129 * v129 * bezierP0 + v129 * 3 * v129 * v128 * bezierP1 + v129 * 3 * v128 * v128 * v125 + v128 * v128 * v128 * p120, cubicBezierTangent(bezierP0, bezierP1, v125, p120, v127);
end;

local function buildMuzzleCF(p130) -- Line: 540
    return CFrame.lookAt(p130, p130 + Vector3.new(0, 1, 0));
end;

local u131 = {
    clientMotion = "幽灵射击弹道",
    serverMotion = "幽灵射击命中盒"
};

local function buildShotTrajectory(p132, p133, p134, p135) -- Line: 615
    -- upvalues: u2 (copy)
    local v136 = u2[p132] or u2[1];
    local v137 = {
        spiralUpLiftStuds = 16,
        spiralEndMinDist = (v136.spiralEndMinDist or 25) * p135,
        spiralNearExpandStuds = v136.spiralNearExpandStuds * p135,
        finalStraightStuds = v136.finalStraightStuds * p135,
        spiralAmp = math.clamp((p134 - p133).Magnitude * 0.12 * (v136.spiralAmpScale or 1), 3, 40),
        flightSec = v136.flightSec,
        easingStyle = v136.easingStyle,
        easingDirection = v136.easingDirection
    };
    local v138 = (u2[p132] or u2[1]).spiralPhaseOffsetDeg or 0;
    v137.spiralPhaseOffsetRad = math.abs(v138) < 0.0001 and 0 or math.rad(v138);

    return v137;
end;

for _, v in { "Startup", "Shot1", "Shot2", "Shot3", "Recovery" } do
    table.insert(v1.Transitions, {
        To = "Interrupted",
        From = v,
        Event = SkillEventConst.Interrupt
    });
    table.insert(v1.Transitions, {
        To = "Finished",
        From = v,
        Event = SkillEventConst.ForceFinish
    });
end;

function v1.Client_EnterStartup(p139) -- Line: 690
    -- upvalues: cloneShotMaterials (copy), SkillCommon (copy)
    local v140 = p139.skillInputData and p139.skillInputData.character;

    if not v140 then
        return;
    end;

    cloneShotMaterials(p139.skillRunData);
    SkillCommon.playSoundLocal3D("音效-幽灵船长-暗夜亡魂-动作", v140:GetPivot().Position);
    local v141 = SkillCommon.resolveWandTipFromCharacter(v140);

    if v141 then
        SkillCommon.scheduleWandTipElementTrail(p139, v141, {
            trailMaterialKey = "暗系尾迹2",
            runEventKey = "幽灵射击Cast尾迹",
            enableAt = 0.27,
            disableAt = 1.2
        });
    end;
end;

function v1.Server_EnterStartup(p142) -- Line: 708
    -- upvalues: SkillCommon (copy)
    local v143 = 28 * SkillCommon.scaleBandFromData(p142, SkillCommon.bandScaleOptsFromSkillData(p142));
    local v144 = Vector3.new(v143, v143, v143);
    local v145 = p142.hitbox[1];

    if v145 and v145.hitbox then
        v145.hitbox.Size = v144;
    end;

    local v146 = p142.hitbox[2];

    if v146 and v146.hitbox then
        v146.hitbox.Size = v144;
    end;

    local v147 = p142.hitbox[3];

    if v147 and v147.hitbox then
        v147.hitbox.Size = v144;
    end;
end;

local function ensureClientProjectileList(p148) -- Line: 722
    p148.GhostShootClient = p148.GhostShootClient or {};
    p148.GhostShootClient.projectiles = p148.GhostShootClient.projectiles or {};

    return p148.GhostShootClient.projectiles;
end;

local function doClientImpact(u149, u150, p151, u152) -- Line: 728
    -- upvalues: SkillCommon (copy), FXUtil (copy), VisibleMgr (copy), playGroundExplosionFx (copy)
    if u150.impacted then
        return;
    end;

    local v153;

    if u149 then
        if u149.flowState == "Interrupted" or u149.finishReason == "Interrupted" then
            v153 = true;
        else
            local skillRunData = u149.skillRunData;

            if skillRunData == nil or skillRunData.Logic == nil then
                v153 = false;
            else
                v153 = skillRunData.Logic.combatCancelled == true;
            end;
        end;
    else
        v153 = false;
    end;

    if v153 then
        u150.impacted = true;

        return;
    end;

    u150.impacted = true;
    local skillRunData = u149.skillRunData;
    local v154 = SkillCommon.scaleBandFromData(u149, SkillCommon.bandScaleOptsFromSkillData(u149));
    local skullStart = u150.skullStart;
    local v155 = Vector3.new(p151.X - skullStart.X, 0, p151.Z - skullStart.Z);
    local v156 = v155.Magnitude <= 0.05 and Vector3.new(0, 0, -1) or v155;

    if u150.telegraph then
        u150.telegraph:activate(0.12);

        if skillRunData.Logic and skillRunData.Logic.dangerTelegraphs then
            skillRunData.Logic.dangerTelegraphs[u150.shotIndex] = nil;
        end;

        u150.telegraph = nil;
    end;

    if u150.skull and u150.skull.Parent then
        FXUtil.Stop_All_Emit(u150.skull);
        FXUtil.SetEmittersTrailsBeamsEnabled(u150.skull, false);
        FXUtil.OffEnableVfx(u150.skull);
        VisibleMgr.fadeAll(u150.skull, 1);
    end;

    local shotIndex = u150.shotIndex;
    local v157 = skillRunData.material[shotIndex == 1 and "幽灵冲击爆炸" or "幽灵冲击爆炸" .. shotIndex];

    if v157 then
        VisibleMgr.UnQueryAll(v157);
        v157:ScaleTo(v154);
        local v158 = CFrame.new(p151) * v157:GetPivot().Rotation;
        v157:PivotTo(v158);
        v157.Parent = workspace.Debris;
        FXUtil.Emit_Particles_GetDescendants(v157, true);
        SkillCommon.appendRunSpawnList(skillRunData, "ghostShootSpawns", v157);
        SkillCommon.playSoundLocal3D("音效-幽灵船长-暗夜亡魂攻击", v158.Position);
    end;

    local shotIndex2 = u150.shotIndex;
    playGroundExplosionFx(skillRunData, shotIndex2 == 1 and "幽灵冲击爆炸地面特效" or "幽灵冲击爆炸地面特效" .. shotIndex2, p151, v156, v154);
    task.delay(2, function() -- Line: 777
        -- upvalues: u149 (copy), u152 (copy), u150 (copy), SkillCommon (ref), skillRunData (copy)
        if u149.runGeneration ~= u152 then
            return;
        end;

        if u150.shotIndex == 3 then
            SkillCommon.clearRunSpawnList(skillRunData, "ghostShootSpawns");
        end;
    end);
end;

local function ensureClientMotionLoop(u159, u160, u161) -- Line: 787
    -- upvalues: RunService (copy), ensureClientProjectileList (copy), doClientImpact (copy), SkillCommon (copy), sampleProjectileMotion (copy), MathMgr (copy), u13 (copy), cleanupRunFx (copy)
    local skillRunData = u159.skillRunData;

    if skillRunData.runEvent["幽灵射击弹道"] then
        return;
    end;

    skillRunData.runEvent["幽灵射击弹道"] = RunService.Heartbeat:Connect(function(p162) -- Line: 793
        -- upvalues: u159 (copy), u161 (copy), skillRunData (copy), ensureClientProjectileList (ref), doClientImpact (ref), SkillCommon (ref), sampleProjectileMotion (ref), MathMgr (ref), u160 (copy), u13 (ref), cleanupRunFx (ref)
        local v163 = u159;
        local v164 = skillRunData;
        local v165;

        if u161 == v163.runGeneration then
            local v166;

            if v163 then
                if v163.flowState == "Interrupted" or v163.finishReason == "Interrupted" then
                    v166 = true;
                else
                    local skillRunData2 = v163.skillRunData;

                    if skillRunData2 == nil or skillRunData2.Logic == nil then
                        v166 = false;
                    else
                        v166 = skillRunData2.Logic.combatCancelled == true;
                    end;
                end;
            else
                v166 = false;
            end;

            if v166 then
                v165 = false;
            elseif v163:isRunningFlow() then
                v165 = true;
            else
                local v167 = v164.GhostShootClient and v164.GhostShootClient.projectiles;

                if v167 then
                    v165 = false;

                    for _, v in v167 do
                        if v and not v.impacted then
                            v165 = true;
                            break;
                        end;
                    end;
                else
                    v165 = false;
                end;
            end;
        else
            v165 = false;
        end;

        if not v165 then
            local v168 = skillRunData.runEvent["幽灵射击弹道"];

            if v168 then
                v168:Disconnect();
                skillRunData.runEvent["幽灵射击弹道"] = nil;
            end;

            return;
        end;

        local skillInputData = u159.skillInputData;
        local v169 = false;

        for _, v in ensureClientProjectileList(skillRunData) do
            if v and not v.impacted then
                if v.skull and v.skull.Parent then
                    v169 = true;
                    v.moveT = v.moveT + p162;

                    if not v.frozenEnd and (not v.impacted and math.max(0, v.flightSec - 0.5) <= v.moveT) then
                        if skillInputData then
                            local snapEnd0 = v.snapEnd0;
                            local v170;

                            if skillInputData then
                                v170 = SkillCommon.resolveTrackTargetHrp(skillInputData);
                            else
                                v170 = skillInputData;
                            end;

                            if v170 and v170.Parent then
                                snapEnd0 = v170.Position;
                            end;

                            v.frozenEnd = snapEnd0;
                        else
                            v.frozenEnd = v.snapEnd0;
                        end;
                    end;

                    local v171 = math.clamp(v.moveT / v.flightSec, 0, 1);
                    local v172;

                    if v.frozenEnd then
                        v172 = v.frozenEnd;
                    elseif skillInputData then
                        v172 = v.snapEnd0;
                        local v173;

                        if skillInputData then
                            v173 = SkillCommon.resolveTrackTargetHrp(skillInputData);
                        else
                            v173 = skillInputData;
                        end;

                        if v173 and v173.Parent then
                            v172 = v173.Position;
                        end;
                    else
                        v172 = v.snapEnd0;
                    end;

                    local v174, v175 = sampleProjectileMotion(v, v171, v172);

                    if v.telegraph and v.impactHitboxSize then
                        v.telegraph:update({
                            worldCFrame = CFrame.new(v172),
                            hitboxSize = v.impactHitboxSize,
                            lockPosition = v.frozenEnd ~= nil
                        });
                    end;

                    if v.oriLocal then
                        local v176 = MathMgr.rotLookAtForwardSafe(v175, Vector3.new(0, 1, 0), u160.CFrame.RightVector);
                        v.skull:PivotTo(CFrame.new(v174) * v176 * v.oriLocal * u13);
                    else
                        v.skull:PivotTo(CFrame.new(v174));
                    end;

                    if v171 >= 1 then
                        doClientImpact(u159, v, v172, u161);
                    end;
                else
                    local v177;

                    if v.frozenEnd then
                        v177 = v.frozenEnd;
                    elseif skillInputData then
                        v177 = v.snapEnd0;
                        local v178;

                        if skillInputData then
                            v178 = SkillCommon.resolveTrackTargetHrp(skillInputData);
                        else
                            v178 = skillInputData;
                        end;

                        if v178 and v178.Parent then
                            v177 = v178.Position;
                        end;
                    else
                        v177 = v.snapEnd0;
                    end;

                    doClientImpact(u159, v, v177, u161);
                end;
            end;
        end;

        if not v169 then
            cleanupRunFx(u159);
        end;
    end);
end;

local function fireClientShot(u179, p180) -- Line: 849
    -- upvalues: SkillCommon (copy), resolveShotPointWorldPos (copy), resolveShotSnapEnd (copy), buildShotTrajectory (copy), SkillTelegraph (copy), VisibleMgr (copy), buildMuzzleCF (copy), FXUtil (copy), MathMgr (copy), u13 (copy), ensureClientProjectileList (copy), u131 (copy), RunService (copy), doClientImpact (copy), sampleProjectileMotion (copy), cleanupRunFx (copy)
    local skillInputData = u179.skillInputData;

    if not skillInputData then
        return;
    end;

    local character = skillInputData.character;

    if not character then
        return;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    if p180 == 1 then
        SkillCommon.playSoundLocal3D("音效-幽灵船长-暗夜亡魂-射击", HumanoidRootPart:GetPivot().Position);
    end;

    local runGeneration = u179.runGeneration;

    if u179.runGeneration ~= runGeneration then
        return;
    end;

    local skillRunData = u179.skillRunData;
    local v181 = SkillCommon.scaleBandFromData(u179, SkillCommon.bandScaleOptsFromSkillData(u179));
    local v182 = resolveShotPointWorldPos(character);

    if not v182 then
        return;
    end;

    SkillCommon.refreshSkillAimSnapshot(u179);
    local skillInputData2 = u179.skillInputData;
    local v183;

    if skillInputData2 then
        v183 = SkillCommon.resolveStrikeWorldPos(skillInputData2);
    else
        v183 = u179:getTargetCF().Position;
    end;

    local v184 = resolveShotSnapEnd(character, v183, p180, v181);
    local v185 = buildShotTrajectory(p180, v182, v184, v181);
    local v186 = v181 * 28;
    local v187 = Vector3.new(v186, v186, v186);

    if skillInputData then
        skillInputData = SkillCommon.resolveTrackTargetHrp(skillInputData);
    end;

    local v188;

    if skillInputData and skillInputData.Parent then
        v188 = skillInputData.Position;
    else
        v188 = v184;
    end;

    skillRunData.Logic = skillRunData.Logic or {};
    skillRunData.Logic.dangerTelegraphs = skillRunData.Logic.dangerTelegraphs or {};
    local v189 = SkillTelegraph.new({
        shape = "Circle",
        worldCFrame = CFrame.new(v188),
        hitboxSize = v187,
        warnDuration = v185.flightSec,
        casterCharacter = character,
        characterType = u179.characterType
    });
    skillRunData.Logic.dangerTelegraphs[p180] = v189;
    local v190 = skillRunData.material[p180 == 1 and "幽灵冲击枪口特效" or "幽灵冲击枪口特效" .. p180];

    if v190 then
        VisibleMgr.UnQueryAll(v190);
        v190:ScaleTo(v181);
        v190:PivotTo(buildMuzzleCF(v182));
        v190.Parent = workspace.Debris;
        FXUtil.Emit_Particles_GetDescendants(v190, true);
        SkillCommon.appendRunSpawnList(skillRunData, "ghostShootSpawns", v190);
    end;

    local v191 = skillRunData.material[p180 == 1 and "幽灵召唤出现特效" or "幽灵召唤出现特效" .. p180];

    if v191 then
        VisibleMgr.UnQueryAll(v191);
        v191:ScaleTo(v181);
        v191:PivotTo(CFrame.new(v182) * v191:GetPivot().Rotation);
        v191.Parent = workspace.Debris;
        FXUtil.Emit_Particles_GetDescendants(v191, true);
        SkillCommon.appendRunSpawnList(skillRunData, "ghostShootSpawns", v191);
    end;

    local v192 = skillRunData.material[p180 == 1 and "幽灵冲击骷髅Emit和Enabled" or "幽灵冲击骷髅Emit和Enabled" .. p180];
    local v193;

    if v192 then
        VisibleMgr.UnQueryAll(v192);
        v192:ScaleTo(v181);
        v193 = v192:GetPivot() - v192:GetPivot().Position;
        local _, v194 = MathMgr.spiralFibLikeChordPosTangent(v182, v184, 0, v185.spiralAmp, v185.spiralEndMinDist, v185.finalStraightStuds, v185.spiralNearExpandStuds, v185.spiralPhaseOffsetRad, v185.spiralUpLiftStuds);
        local v195 = MathMgr.rotLookAtForwardSafe(v194, Vector3.new(0, 1, 0), HumanoidRootPart.CFrame.RightVector);

        if v193 then
            v192:PivotTo(CFrame.new(v182) * v195 * v193 * u13);
        end;

        v192.Parent = workspace.Debris;
        FXUtil.SetEmittersTrailsBeamsEnabled(v192, true);
        FXUtil.Emit_Particles_GetDescendants(v192, false);
        SkillCommon.appendRunSpawnList(skillRunData, "ghostShootSpawns", v192);
    else
        v193 = nil;
    end;

    local v196 = ensureClientProjectileList(skillRunData);
    table.insert(v196, {
        moveT = 0,
        impacted = false,
        shotIndex = p180,
        skull = v192,
        skullStart = v182,
        snapEnd0 = v184,
        spiralEndMinDist = v185.spiralEndMinDist,
        spiralNearExpandStuds = v185.spiralNearExpandStuds,
        finalStraightStuds = v185.finalStraightStuds,
        spiralAmp = v185.spiralAmp,
        flightSec = v185.flightSec,
        easingStyle = v185.easingStyle,
        easingDirection = v185.easingDirection,
        spiralPhaseOffsetRad = v185.spiralPhaseOffsetRad,
        spiralUpLiftStuds = v185.spiralUpLiftStuds,
        oriLocal = v193,
        telegraph = v189,
        impactHitboxSize = v187
    });
    local skillRunData2 = u179.skillRunData;

    if skillRunData2.runEvent[u131.clientMotion] then
        return;
    end;

    skillRunData2.runEvent[u131.clientMotion] = RunService.Heartbeat:Connect(function(p197) -- Line: 793
        -- upvalues: u179 (copy), runGeneration (copy), skillRunData2 (copy), ensureClientProjectileList (ref), doClientImpact (ref), SkillCommon (ref), sampleProjectileMotion (ref), MathMgr (ref), HumanoidRootPart (copy), u13 (ref), cleanupRunFx (ref)
        local v198 = u179;
        local v199 = skillRunData2;
        local v200;

        if runGeneration == v198.runGeneration then
            local v201;

            if v198 then
                if v198.flowState == "Interrupted" or v198.finishReason == "Interrupted" then
                    v201 = true;
                else
                    local skillRunData3 = v198.skillRunData;

                    if skillRunData3 == nil or skillRunData3.Logic == nil then
                        v201 = false;
                    else
                        v201 = skillRunData3.Logic.combatCancelled == true;
                    end;
                end;
            else
                v201 = false;
            end;

            if v201 then
                v200 = false;
            elseif v198:isRunningFlow() then
                v200 = true;
            else
                local v202 = v199.GhostShootClient and v199.GhostShootClient.projectiles;

                if v202 then
                    v200 = false;

                    for _, v in v202 do
                        if v and not v.impacted then
                            v200 = true;
                            break;
                        end;
                    end;
                else
                    v200 = false;
                end;
            end;
        else
            v200 = false;
        end;

        if not v200 then
            local v203 = skillRunData2.runEvent["幽灵射击弹道"];

            if v203 then
                v203:Disconnect();
                skillRunData2.runEvent["幽灵射击弹道"] = nil;
            end;

            return;
        end;

        local skillInputData3 = u179.skillInputData;
        local v204 = false;

        for _, v in ensureClientProjectileList(skillRunData2) do
            if v and not v.impacted then
                if v.skull and v.skull.Parent then
                    v204 = true;
                    v.moveT = v.moveT + p197;

                    if not v.frozenEnd and (not v.impacted and math.max(0, v.flightSec - 0.5) <= v.moveT) then
                        if skillInputData3 then
                            local snapEnd0 = v.snapEnd0;
                            local v205;

                            if skillInputData3 then
                                v205 = SkillCommon.resolveTrackTargetHrp(skillInputData3);
                            else
                                v205 = skillInputData3;
                            end;

                            if v205 and v205.Parent then
                                snapEnd0 = v205.Position;
                            end;

                            v.frozenEnd = snapEnd0;
                        else
                            v.frozenEnd = v.snapEnd0;
                        end;
                    end;

                    local v206 = math.clamp(v.moveT / v.flightSec, 0, 1);
                    local v207;

                    if v.frozenEnd then
                        v207 = v.frozenEnd;
                    elseif skillInputData3 then
                        v207 = v.snapEnd0;
                        local v208;

                        if skillInputData3 then
                            v208 = SkillCommon.resolveTrackTargetHrp(skillInputData3);
                        else
                            v208 = skillInputData3;
                        end;

                        if v208 and v208.Parent then
                            v207 = v208.Position;
                        end;
                    else
                        v207 = v.snapEnd0;
                    end;

                    local v209, v210 = sampleProjectileMotion(v, v206, v207);

                    if v.telegraph and v.impactHitboxSize then
                        v.telegraph:update({
                            worldCFrame = CFrame.new(v207),
                            hitboxSize = v.impactHitboxSize,
                            lockPosition = v.frozenEnd ~= nil
                        });
                    end;

                    if v.oriLocal then
                        local v211 = MathMgr.rotLookAtForwardSafe(v210, Vector3.new(0, 1, 0), HumanoidRootPart.CFrame.RightVector);
                        v.skull:PivotTo(CFrame.new(v209) * v211 * v.oriLocal * u13);
                    else
                        v.skull:PivotTo(CFrame.new(v209));
                    end;

                    if v206 >= 1 then
                        doClientImpact(u179, v, v207, runGeneration);
                    end;
                else
                    local v212;

                    if v.frozenEnd then
                        v212 = v.frozenEnd;
                    elseif skillInputData3 then
                        v212 = v.snapEnd0;
                        local v213;

                        if skillInputData3 then
                            v213 = SkillCommon.resolveTrackTargetHrp(skillInputData3);
                        else
                            v213 = skillInputData3;
                        end;

                        if v213 and v213.Parent then
                            v212 = v213.Position;
                        end;
                    else
                        v212 = v.snapEnd0;
                    end;

                    doClientImpact(u179, v, v212, runGeneration);
                end;
            end;
        end;

        if not v204 then
            cleanupRunFx(u179);
        end;
    end);
end;

function v1.Client_EnterShot1(p214) -- Line: 969
    -- upvalues: fireClientShot (copy)
    fireClientShot(p214, 1);
end;

function v1.Client_EnterShot2(p215) -- Line: 973
    -- upvalues: fireClientShot (copy)
    fireClientShot(p215, 2);
end;

function v1.Client_EnterShot3(p216) -- Line: 977
    -- upvalues: fireClientShot (copy)
    fireClientShot(p216, 3);
end;

function v1.Client_ExitShot3(p217) -- Line: 981
    -- upvalues: cleanupRunFx (copy)
    cleanupRunFx(p217);
end;

function v1.Client_EnterRecovery(p218) -- Line: 985
    -- upvalues: cleanupRunFx (copy)
    cleanupRunFx(p218);
end;

function v1.Client_EnterInterrupted(p219) -- Line: 989
    -- upvalues: cleanupClientVisualsImmediate (copy)
    cleanupClientVisualsImmediate(p219);
end;

local function flushClientProjectiles(p220, p221) -- Line: 993
    -- upvalues: doClientImpact (copy), SkillCommon (copy)
    local skillRunData = p220.skillRunData;

    if not (skillRunData and (skillRunData.GhostShootClient and skillRunData.GhostShootClient.projectiles)) then
        return;
    end;

    local skillInputData = p220.skillInputData;

    for _, v in skillRunData.GhostShootClient.projectiles do
        if v and not v.impacted then
            local v222;

            if v.frozenEnd then
                v222 = v.frozenEnd;
            elseif skillInputData then
                v222 = v.snapEnd0;
                local v223;

                if skillInputData then
                    v223 = SkillCommon.resolveTrackTargetHrp(skillInputData);
                else
                    v223 = skillInputData;
                end;

                if v223 and v223.Parent then
                    v222 = v223.Position;
                end;
            else
                v222 = v.snapEnd0;
            end;

            doClientImpact(p220, v, v222, p221);
        end;
    end;
end;

function v1.onEnd(p224) -- Line: 1006
    -- upvalues: cleanupClientVisualsImmediate (copy), SkillCommon (copy), flushClientProjectiles (copy), cleanupRunFx (copy), destroyDangerTelegraphs (copy)
    local v225;

    if p224 then
        if p224.flowState == "Interrupted" or p224.finishReason == "Interrupted" then
            v225 = true;
        else
            local skillRunData = p224.skillRunData;

            if skillRunData == nil or skillRunData.Logic == nil then
                v225 = false;
            else
                v225 = skillRunData.Logic.combatCancelled == true;
            end;
        end;
    else
        v225 = false;
    end;

    if v225 then
        cleanupClientVisualsImmediate(p224);

        if p224.skillRunData then
            SkillCommon.clearRunSpawnList(p224.skillRunData, "ghostShootSpawns");
            p224.skillRunData.GhostShootClient = nil;
        end;

        return;
    end;

    flushClientProjectiles(p224, p224.runGeneration);
    cleanupRunFx(p224, true);

    if p224.skillRunData then
        destroyDangerTelegraphs(p224.skillRunData);
    end;

    cleanupClientVisualsImmediate(p224);

    if p224.skillRunData then
        SkillCommon.clearRunSpawnList(p224.skillRunData, "ghostShootSpawns");
        p224.skillRunData.GhostShootClient = nil;
    end;
end;

local function ensureServerProjectileList(p226) -- Line: 1030
    p226.GhostShootServer = p226.GhostShootServer or {};
    p226.GhostShootServer.projectiles = p226.GhostShootServer.projectiles or {};

    return p226.GhostShootServer.projectiles;
end;

local function doServerImpact(p227, p228, p229) -- Line: 1036
    -- upvalues: SkillCommon (copy)
    if p228.impacted then
        return;
    end;

    local v230;

    if p227 then
        if p227.flowState == "Interrupted" or p227.finishReason == "Interrupted" then
            v230 = true;
        else
            local skillRunData = p227.skillRunData;

            if skillRunData == nil or skillRunData.Logic == nil then
                v230 = false;
            else
                v230 = skillRunData.Logic.combatCancelled == true;
            end;
        end;
    else
        v230 = false;
    end;

    if v230 then
        p228.impacted = true;

        return;
    end;

    p228.impacted = true;
    local u231 = p227.hitbox[p228.shotIndex];

    if not (u231 and u231.hitbox) then
        return;
    end;

    local v232 = 28 * SkillCommon.scaleBandFromData(p227, SkillCommon.bandScaleOptsFromSkillData(p227));
    local v233 = Vector3.new(v232, v232, v232);
    u231.hitbox.Size = v233;
    u231.hitbox:PivotTo(CFrame.new(p229));

    if not u231.isActive then
        u231:start();
    end;

    task.delay(0.12, function() -- Line: 1059
        -- upvalues: u231 (copy)
        if u231.isActive then
            u231:stop();
        end;
    end);
end;

local function flushServerProjectiles(p234) -- Line: 1066
    -- upvalues: doServerImpact (copy), SkillCommon (copy)
    local skillRunData = p234.skillRunData;

    if not (skillRunData and (skillRunData.GhostShootServer and skillRunData.GhostShootServer.projectiles)) then
        return;
    end;

    local skillInputData = p234.skillInputData;

    for _, v in skillRunData.GhostShootServer.projectiles do
        if v and not v.impacted then
            local v235;

            if v.frozenEnd then
                v235 = v.frozenEnd;
            elseif skillInputData then
                v235 = v.snapEnd0;
                local v236;

                if skillInputData then
                    v236 = SkillCommon.resolveTrackTargetHrp(skillInputData);
                else
                    v236 = skillInputData;
                end;

                if v236 and v236.Parent then
                    v235 = v236.Position;
                end;
            else
                v235 = v.snapEnd0;
            end;

            doServerImpact(p234, v, v235);
        end;
    end;
end;

local function ensureServerMotionLoop(u237, u238) -- Line: 1079
    -- upvalues: RunService (copy), ensureServerProjectileList (copy), SkillCommon (copy), sampleProjectileMotion (copy), doServerImpact (copy), cleanupRunFx (copy)
    local skillRunData = u237.skillRunData;

    if skillRunData.runEvent["幽灵射击命中盒"] then
        return;
    end;

    skillRunData.runEvent["幽灵射击命中盒"] = RunService.Heartbeat:Connect(function(p239) -- Line: 1085
        -- upvalues: u237 (copy), u238 (copy), skillRunData (copy), ensureServerProjectileList (ref), SkillCommon (ref), sampleProjectileMotion (ref), doServerImpact (ref), cleanupRunFx (ref)
        local v240 = u237;
        local v241 = skillRunData;
        local v242;

        if u238 == v240.runGeneration then
            local v243;

            if v240 then
                if v240.flowState == "Interrupted" or v240.finishReason == "Interrupted" then
                    v243 = true;
                else
                    local skillRunData2 = v240.skillRunData;

                    if skillRunData2 == nil or skillRunData2.Logic == nil then
                        v243 = false;
                    else
                        v243 = skillRunData2.Logic.combatCancelled == true;
                    end;
                end;
            else
                v243 = false;
            end;

            if v243 then
                v242 = false;
            elseif v240:isRunningFlow() then
                v242 = true;
            else
                local v244 = v241.GhostShootServer and v241.GhostShootServer.projectiles;

                if v244 then
                    v242 = false;

                    for _, v in v244 do
                        if v and not v.impacted then
                            v242 = true;
                            break;
                        end;
                    end;
                else
                    v242 = false;
                end;
            end;
        else
            v242 = false;
        end;

        if not v242 then
            local v245 = skillRunData.runEvent["幽灵射击命中盒"];

            if v245 then
                v245:Disconnect();
                skillRunData.runEvent["幽灵射击命中盒"] = nil;
            end;

            return;
        end;

        local skillInputData = u237.skillInputData;
        local v246 = false;

        for _, v in ensureServerProjectileList(skillRunData) do
            if v and not v.impacted then
                v246 = true;
                v.moveT = v.moveT + p239;

                if not v.frozenEnd and (not v.impacted and math.max(0, v.flightSec - 0.5) <= v.moveT) then
                    if skillInputData then
                        local snapEnd0 = v.snapEnd0;
                        local v247;

                        if skillInputData then
                            v247 = SkillCommon.resolveTrackTargetHrp(skillInputData);
                        else
                            v247 = skillInputData;
                        end;

                        if v247 and v247.Parent then
                            snapEnd0 = v247.Position;
                        end;

                        v.frozenEnd = snapEnd0;
                    else
                        v.frozenEnd = v.snapEnd0;
                    end;
                end;

                local v248 = math.clamp(v.moveT / v.flightSec, 0, 1);
                local v249;

                if v.frozenEnd then
                    v249 = v.frozenEnd;
                elseif skillInputData then
                    v249 = v.snapEnd0;
                    local v250;

                    if skillInputData then
                        v250 = SkillCommon.resolveTrackTargetHrp(skillInputData);
                    else
                        v250 = skillInputData;
                    end;

                    if v250 and v250.Parent then
                        v249 = v250.Position;
                    end;
                else
                    v249 = v.snapEnd0;
                end;

                select(1, sampleProjectileMotion(v, v248, v249));

                if v248 >= 1 then
                    doServerImpact(u237, v, v249);
                end;
            end;
        end;

        if not v246 then
            cleanupRunFx(u237);
        end;
    end);
end;

local function fireServerShot(u251, p252) -- Line: 1122
    -- upvalues: resolveShotPointWorldPos (copy), SkillCommon (copy), resolveShotSnapEnd (copy), buildShotTrajectory (copy), ensureServerProjectileList (copy), u131 (copy), RunService (copy), sampleProjectileMotion (copy), doServerImpact (copy), cleanupRunFx (copy)
    local skillInputData = u251.skillInputData;

    if not skillInputData then
        return;
    end;

    local character = skillInputData.character;

    if not character then
        return;
    end;

    if not character:FindFirstChild("HumanoidRootPart") then
        return;
    end;

    local runGeneration = u251.runGeneration;

    if u251.runGeneration ~= runGeneration then
        return;
    end;

    local v253 = resolveShotPointWorldPos(character);

    if not v253 then
        return;
    end;

    local v254 = SkillCommon.scaleBandFromData(u251, SkillCommon.bandScaleOptsFromSkillData(u251));
    SkillCommon.refreshSkillAimSnapshot(u251);
    local skillInputData2 = u251.skillInputData;
    local v255;

    if skillInputData2 then
        v255 = SkillCommon.resolveStrikeWorldPos(skillInputData2);
    else
        v255 = u251:getTargetCF().Position;
    end;

    local v256 = resolveShotSnapEnd(character, v255, p252, v254);
    local v257 = buildShotTrajectory(p252, v253, v256, v254);
    local v258 = ensureServerProjectileList(u251.skillRunData);
    table.insert(v258, {
        moveT = 0,
        impacted = false,
        shotIndex = p252,
        skullStart = v253,
        snapEnd0 = v256,
        spiralEndMinDist = v257.spiralEndMinDist,
        spiralNearExpandStuds = v257.spiralNearExpandStuds,
        finalStraightStuds = v257.finalStraightStuds,
        spiralAmp = v257.spiralAmp,
        flightSec = v257.flightSec,
        easingStyle = v257.easingStyle,
        easingDirection = v257.easingDirection,
        spiralPhaseOffsetRad = v257.spiralPhaseOffsetRad,
        spiralUpLiftStuds = v257.spiralUpLiftStuds
    });
    local skillRunData = u251.skillRunData;

    if skillRunData.runEvent[u131.serverMotion] then
        return;
    end;

    skillRunData.runEvent[u131.serverMotion] = RunService.Heartbeat:Connect(function(p259) -- Line: 1085
        -- upvalues: u251 (copy), runGeneration (copy), skillRunData (copy), ensureServerProjectileList (ref), SkillCommon (ref), sampleProjectileMotion (ref), doServerImpact (ref), cleanupRunFx (ref)
        local v260 = u251;
        local v261 = skillRunData;
        local v262;

        if runGeneration == v260.runGeneration then
            local v263;

            if v260 then
                if v260.flowState == "Interrupted" or v260.finishReason == "Interrupted" then
                    v263 = true;
                else
                    local skillRunData2 = v260.skillRunData;

                    if skillRunData2 == nil or skillRunData2.Logic == nil then
                        v263 = false;
                    else
                        v263 = skillRunData2.Logic.combatCancelled == true;
                    end;
                end;
            else
                v263 = false;
            end;

            if v263 then
                v262 = false;
            elseif v260:isRunningFlow() then
                v262 = true;
            else
                local v264 = v261.GhostShootServer and v261.GhostShootServer.projectiles;

                if v264 then
                    v262 = false;

                    for _, v in v264 do
                        if v and not v.impacted then
                            v262 = true;
                            break;
                        end;
                    end;
                else
                    v262 = false;
                end;
            end;
        else
            v262 = false;
        end;

        if not v262 then
            local v265 = skillRunData.runEvent["幽灵射击命中盒"];

            if v265 then
                v265:Disconnect();
                skillRunData.runEvent["幽灵射击命中盒"] = nil;
            end;

            return;
        end;

        local skillInputData3 = u251.skillInputData;
        local v266 = false;

        for _, v in ensureServerProjectileList(skillRunData) do
            if v and not v.impacted then
                v266 = true;
                v.moveT = v.moveT + p259;

                if not v.frozenEnd and (not v.impacted and math.max(0, v.flightSec - 0.5) <= v.moveT) then
                    if skillInputData3 then
                        local snapEnd0 = v.snapEnd0;
                        local v267;

                        if skillInputData3 then
                            v267 = SkillCommon.resolveTrackTargetHrp(skillInputData3);
                        else
                            v267 = skillInputData3;
                        end;

                        if v267 and v267.Parent then
                            snapEnd0 = v267.Position;
                        end;

                        v.frozenEnd = snapEnd0;
                    else
                        v.frozenEnd = v.snapEnd0;
                    end;
                end;

                local v268 = math.clamp(v.moveT / v.flightSec, 0, 1);
                local v269;

                if v.frozenEnd then
                    v269 = v.frozenEnd;
                elseif skillInputData3 then
                    v269 = v.snapEnd0;
                    local v270;

                    if skillInputData3 then
                        v270 = SkillCommon.resolveTrackTargetHrp(skillInputData3);
                    else
                        v270 = skillInputData3;
                    end;

                    if v270 and v270.Parent then
                        v269 = v270.Position;
                    end;
                else
                    v269 = v.snapEnd0;
                end;

                select(1, sampleProjectileMotion(v, v268, v269));

                if v268 >= 1 then
                    doServerImpact(u251, v, v269);
                end;
            end;
        end;

        if not v266 then
            cleanupRunFx(u251);
        end;
    end);
end;

function v1.Server_EnterShot1(p271) -- Line: 1171
    -- upvalues: fireServerShot (copy)
    fireServerShot(p271, 1);
end;

function v1.Server_EnterShot2(p272) -- Line: 1175
    -- upvalues: fireServerShot (copy)
    fireServerShot(p272, 2);
end;

function v1.Server_EnterShot3(p273) -- Line: 1179
    -- upvalues: fireServerShot (copy)
    fireServerShot(p273, 3);
end;

function v1.Server_ExitShot3(p274) -- Line: 1183
    -- upvalues: cleanupRunFx (copy)
    cleanupRunFx(p274);
end;

function v1.Server_EnterRecovery(p275) -- Line: 1187
    -- upvalues: cleanupRunFx (copy)
    cleanupRunFx(p275);
    p275:releaseControl();
end;

function v1.Server_EnterInterrupted(p276) -- Line: 1192
    -- upvalues: cleanupServerOnInterrupt (copy)
    cleanupServerOnInterrupt(p276);
end;

function v1.onEndServer(p277) -- Line: 1196
    -- upvalues: cleanupServerOnInterrupt (copy), flushServerProjectiles (copy), cleanupRunFx (copy)
    local v278;

    if p277 then
        if p277.flowState == "Interrupted" or p277.finishReason == "Interrupted" then
            v278 = true;
        else
            local skillRunData = p277.skillRunData;

            if skillRunData == nil or skillRunData.Logic == nil then
                v278 = false;
            else
                v278 = skillRunData.Logic.combatCancelled == true;
            end;
        end;
    else
        v278 = false;
    end;

    if v278 then
        cleanupServerOnInterrupt(p277);

        if p277.skillRunData then
            p277.skillRunData.GhostShootServer = nil;
        end;

        return;
    end;

    flushServerProjectiles(p277);
    cleanupRunFx(p277, true);
    cleanupServerOnInterrupt(p277);
    local v279 = p277.hitbox[1];

    if v279 and v279.isActive then
        v279:stop();
    end;

    local v280 = p277.hitbox[2];

    if v280 and v280.isActive then
        v280:stop();
    end;

    local v281 = p277.hitbox[3];

    if v281 and v281.isActive then
        v281:stop();
    end;

    if p277.skillRunData then
        p277.skillRunData.GhostShootServer = nil;
    end;
end;

v1.SoundList = { "音效-幽灵船长-暗夜亡魂攻击", "音效-幽灵船长-暗夜亡魂-射击", "音效-幽灵船长-暗夜亡魂-动作" };
v1.AnimateList = { "幽魂射击" };
v1.ResNameList = { "暗系尾迹2", "幽灵冲击骷髅Emit和Enabled", "幽灵召唤出现特效", "幽灵冲击爆炸", "幽灵冲击爆炸地面特效", "幽灵冲击枪口特效" };
v1.hitboxConfig = { {
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
    }, {
        HitboxIndex = 3,
        PartName = "通用球",
        CollisionGroup = "Player",
        HitPresentationProfile = "通用受击",
        PhysicsEffectName = "通用受击物理效果"
    } };
v1.Action = {
    {
        action = "LookAt",
        startTime = 0,
        overTime = 1,
        speedType = "RELEASE_SKILL_STATE_HALF"
    },
    {
        action = "Animation",
        startTime = 0,
        overTime = 2.38,
        animationName = "幽魂射击",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action4
    }
};

return v1;