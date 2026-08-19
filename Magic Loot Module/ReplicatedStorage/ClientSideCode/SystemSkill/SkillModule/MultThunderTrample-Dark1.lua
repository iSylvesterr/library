-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local EntityUtil = require(script.Parent.Parent.BaseSkill.EntityUtil);
local HitQueryContext = require(script.Parent.Parent.BaseSkill.HitQueryContext);
local MultThunderTramplePath = require(script.MultThunderTramplePath);
local ThunderLeapTiming = require(script.Parent.Parent.Tool.ThunderLeapTiming);
local FXUtil = UtilsSystem.FXUtil;
local VisibleMgr = UtilsSystem.VisibleMgr;
local RunService = UtilsSystem.RunService;
local TweenService = UtilsSystem.TweenService;
local AnimationModule = UtilsSystem.AnimationModule;
local LEAP_STANDARD_TOTAL = ThunderLeapTiming.LEAP_STANDARD_TOTAL;
local u1 = math.max(0.3, 1.2 - LEAP_STANDARD_TOTAL + 0.15 + 0.1, ThunderLeapTiming.LEAP_PHASE_RECOVERY + (1.2 - 0.08 * ThunderLeapTiming.LEAP_PHASE_MOVE + 0.15 + 0.05));
local u2 = {
    skillTotalTime = -1,
    visualFadeoutTime = 0.5 + (LEAP_STANDARD_TOTAL * 3 + 0.4) + u1 + 0.5,
    skillElementType = ElementTp.Thunder,
    skillDistanceLimit = 120,
    animationPlaySide = "Server"
};
local Quad = Enum.EasingStyle.Quad;
local Out = Enum.EasingDirection.Out;

local function segmentPlanKey(p3) -- Line: 87
    return "multThunderSegPlan" .. p3;
end;

local function segmentLandFxKey(p4) -- Line: 91
    return "multThunderLandFxDone" .. p4;
end;

local function segmentLandPlayerStrikeKey(p5) -- Line: 95
    return "multThunderLandPlayerStrikeDone" .. p5;
end;

local Action4 = Enum.AnimationPriority.Action4;
local Movement = Enum.AnimationPriority.Movement;
u2.MoveFaceMode = {
    MoveTarget = "MoveTarget",
    AttackTarget = "AttackTarget"
};
u2.InitialState = "Startup";
u2.ControlOpenState = "Recovery";
u2.States = {
    Startup = {
        Duration = 0.5,
        OnEnterClient = "Client_EnterStartup",
        OnEnterServer = "Server_EnterStartup",
        OnExitClient = "Client_ExitStartup",
        OnExitServer = nil
    },
    Movement1 = {
        Duration = -1,
        OnEnterClient = "Client_EnterMovement1",
        OnEnterServer = "Server_EnterMovement1",
        OnExitClient = "Client_ExitMovement1",
        OnExitServer = "Server_ExitMovement1"
    },
    Pause1 = {
        Duration = 0.2,
        OnEnterClient = "Client_EnterPause1",
        OnEnterServer = "Server_EnterPause1",
        OnExitClient = "Client_ExitPause1",
        OnExitServer = "Server_ExitPause1"
    },
    Movement2 = {
        Duration = -1,
        OnEnterClient = "Client_EnterMovement2",
        OnEnterServer = "Server_EnterMovement2",
        OnExitClient = "Client_ExitMovement2",
        OnExitServer = "Server_ExitMovement2"
    },
    Pause2 = {
        Duration = 0.2,
        OnEnterClient = "Client_EnterPause2",
        OnEnterServer = "Server_EnterPause2",
        OnExitClient = "Client_ExitPause2",
        OnExitServer = "Server_ExitPause2"
    },
    Movement3 = {
        Duration = -1,
        OnEnterClient = "Client_EnterMovement3",
        OnEnterServer = "Server_EnterMovement3",
        OnExitClient = "Client_ExitMovement3",
        OnExitServer = "Server_ExitMovement3"
    },
    Recovery = {
        OnEnterClient = "Client_EnterRecovery",
        OnEnterServer = "Server_EnterRecovery",
        OnExitClient = nil,
        OnExitServer = "Server_ExitRecovery",
        Duration = u1
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
u2.Transitions = {
    {
        From = "Startup",
        To = "Movement1",
        Event = SkillEventConst.StateTimeout
    },
    {
        From = "Movement1",
        To = "Pause1",
        Event = SkillEventConst.StateTimeout
    },
    {
        From = "Pause1",
        To = "Movement2",
        Event = SkillEventConst.StateTimeout
    },
    {
        From = "Movement2",
        To = "Pause2",
        Event = SkillEventConst.StateTimeout
    },
    {
        From = "Pause2",
        To = "Movement3",
        Event = SkillEventConst.StateTimeout
    },
    {
        From = "Movement3",
        To = "Recovery",
        Event = SkillEventConst.StateTimeout
    },
    {
        From = "Recovery",
        To = "Finished",
        Event = SkillEventConst.StateTimeout
    }
};
local u6 = { "音效-技能-独角兽-打雷1", "音效-技能-独角兽-打雷2", "音效-技能-独角兽-打雷3", "音效-技能-独角兽-打雷4", "音效-技能-独角兽-打雷5", "音效-技能-独角兽-打雷6", "音效-技能-独角兽-打雷7", "音效-技能-独角兽-打雷8", "音效-技能-独角兽-打雷9" };

for _, v in { "Startup", "Movement1", "Pause1", "Movement2", "Pause2", "Movement3", "Recovery" } do
    table.insert(u2.Transitions, {
        To = "Interrupted",
        From = v,
        Event = SkillEventConst.Interrupt
    });
    table.insert(u2.Transitions, {
        To = "Finished",
        From = v,
        Event = SkillEventConst.ForceFinish
    });
end;

local function applyHitboxVisibility(p7, p8) -- Line: 256
    if not p7 then
        return;
    end;

    p7.Transparency = 1;
end;

local function snapGroundPos(p9) -- Line: 267
    -- upvalues: SkillCommon (copy)
    return SkillCommon.getGroundCF(CFrame.new(p9), 4, 0.15, "Ground").Position;
end;

local function withLandingYOffset(p10) -- Line: 271
    return Vector3.new(p10.X, p10.Y + 0.1, p10.Z);
end;

local function snapLandingGroundPos(p11) -- Line: 276
    -- upvalues: SkillCommon (copy)
    local Position = SkillCommon.getGroundCF(CFrame.new(p11), 4, 0.15, "Ground").Position;

    return Vector3.new(Position.X, Position.Y + 0.1, Position.Z);
end;

local function flatDistance(p12, p13) -- Line: 280
    return (Vector3.new(p12.X, 0, p12.Z) - Vector3.new(p13.X, 0, p13.Z)).Magnitude;
end;

local function buildPathLeapSegmentTimings(p14) -- Line: 286
    -- upvalues: ThunderLeapTiming (copy)
    local points = p14.points;
    local v15 = {};
    local v16 = {};
    local v17 = {};

    for i = 1, 3 do
        local v18 = points[i];
        local v19 = points[i + 1];
        local v20 = ThunderLeapTiming.computeFromHorizDist((Vector3.new(v18.X, 0, v18.Z) - Vector3.new(v19.X, 0, v19.Z)).Magnitude);
        v15[i] = v20.total;
        v16[i] = v20.move;
        v17[i] = v20.windup;
    end;

    return v15, v16, v17;
end;

local function getFlatLookHint(p21) -- Line: 300
    local HumanoidRootPart = p21:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart then
        local v22 = Vector3.new(HumanoidRootPart.CFrame.LookVector.X, 0, HumanoidRootPart.CFrame.LookVector.Z);

        if v22.Magnitude > 0.05 then
            return v22.Unit;
        end;
    end;

    return Vector3.new(0, 0, -1);
end;

local function strikeFlatHint(p23, p24) -- Line: 311
    local v25 = p24 - p23.Position;
    local v26 = Vector3.new(v25.X, 0, v25.Z);

    if v26.Magnitude > 0.05 then
        return v26.Unit;
    end;

    local HumanoidRootPart = p23.Parent:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart then
        local v27 = Vector3.new(HumanoidRootPart.CFrame.LookVector.X, 0, HumanoidRootPart.CFrame.LookVector.Z);

        if v27.Magnitude > 0.05 then
            return v27.Unit;
        end;
    end;

    return Vector3.new(0, 0, -1);
end;

local function resolveStrikeGroundAlignedCF(p28, p29) -- Line: 320
    -- upvalues: FXUtil (copy)
    return FXUtil.GetGroundAlignedCF(p28, p29, "Ground", 4, 0.15) or CFrame.new(p28 + Vector3.new(0, 0.15, 0));
end;

local function cloneEmitFx(p30, p31, p32, p33) -- Line: 328
    -- upvalues: VisibleMgr (copy), SkillCommon (copy), FXUtil (copy)
    local v34 = p30:Clone();

    if v34:IsA("Model") then
        v34:ScaleTo(p32);
    end;

    VisibleMgr.UnQueryAll(v34);
    v34:PivotTo(p31);
    v34.Parent = workspace.Debris;
    SkillCommon.appendRunSpawnList(p33, "MultThunderTrampleSpawned", v34);
    FXUtil.Emit_Particles_GetDescendants(v34, true);
end;

local function emitJumpStrikeWarningAt(p35, p36, p37, p38) -- Line: 340
    -- upvalues: cloneEmitFx (copy), SkillCommon (copy)
    cloneEmitFx(p35, CFrame.new(p36), p37, p38);
    SkillCommon.playSoundLocal3D("音效-技能-独角兽-预警", p36);
end;

local function emitJumpStrikeAt(p39, p40, p41, p42, p43, p44) -- Line: 345
    -- upvalues: cloneEmitFx (copy), FXUtil (copy), SkillCommon (copy), u6 (copy)
    cloneEmitFx(p39, CFrame.new(p41), p43, p44);
    cloneEmitFx(p40, FXUtil.GetGroundAlignedCF(p41, p42, "Ground", 4, 0.15) or CFrame.new(p41 + Vector3.new(0, 0.15, 0)), p43, p44);
    local v45 = SkillCommon.pickRandomSoundName(u6);

    if v45 then
        SkillCommon.playSoundLocal3D(v45, p41);
    end;
end;

local function pulseJumpStrikeHitboxAtGround(u46, p47, p48, p49, p50) -- Line: 361
    if not (u46 and u46.hitbox) then
        return;
    end;

    local hitbox = u46.hitbox;
    hitbox.Size = p48;
    hitbox:PivotTo(CFrame.new(p47));
    local _ = p50 == true;

    if hitbox then
        hitbox.Transparency = 1;
    end;

    u46:start();
    task.delay(p49 or 0.15, function() -- Line: 377
        -- upvalues: u46 (copy), hitbox (copy)
        if u46.isActive then
            u46:stop();
        end;

        local v51 = hitbox;

        if not v51 then
            return;
        end;

        v51.Transparency = 1;
    end);
end;

local function stillActiveForScheduledStrike(p52, p53) -- Line: 386
    return p52.runGeneration == p53;
end;

local function scheduleJumpStrikeClient(u54, u55, u56, u57, p58) -- Line: 390
    -- upvalues: SkillCommon (copy), cloneEmitFx (copy), emitJumpStrikeAt (copy)
    local skillRunData = u54.skillRunData;
    local v59;

    if skillRunData then
        v59 = skillRunData.material;
    else
        v59 = skillRunData;
    end;

    if not (skillRunData and v59) then
        return;
    end;

    local u60 = v59["独角兽落雷预警-暗"];
    local u61 = v59["独角兽落雷-暗"];
    local u62 = v59["独角兽落雷地面特效-暗"];

    if not (u60 and (u61 and u62)) then
        return;
    end;

    local u63 = SkillCommon.npcSummonBodySkillScale(u54);
    task.delay(p58, function() -- Line: 409
        -- upvalues: u54 (copy), u57 (copy), u60 (copy), u55 (copy), u63 (copy), skillRunData (copy), cloneEmitFx (ref), SkillCommon (ref)
        if u57 ~= u54.runGeneration then
            return;
        end;

        local v64 = u55;
        cloneEmitFx(u60, CFrame.new(v64), u63, skillRunData);
        SkillCommon.playSoundLocal3D("音效-技能-独角兽-预警", v64);
    end);
    task.delay(p58 + 1.2, function() -- Line: 415
        -- upvalues: u54 (copy), u57 (copy), emitJumpStrikeAt (ref), u61 (copy), u62 (copy), u55 (copy), u56 (copy), u63 (copy), skillRunData (copy)
        if u57 ~= u54.runGeneration then
            return;
        end;

        emitJumpStrikeAt(u61, u62, u55, u56, u63, skillRunData);
    end);
end;

local function scheduleJumpStrikeServer(u65, u66, u67, u68, p69, p70) -- Line: 423
    -- upvalues: pulseJumpStrikeHitboxAtGround (copy)
    local u71 = p70 or 2;
    task.delay(p69 + 1.2, function() -- Line: 432
        -- upvalues: u65 (copy), u67 (copy), u71 (copy), pulseJumpStrikeHitboxAtGround (ref), u66 (copy), u68 (copy)
        if u67 ~= u65.runGeneration then
            return;
        end;

        local v72 = u65.hitbox[u71];

        if not v72 then
            return;
        end;

        pulseJumpStrikeHitboxAtGround(v72, u66, u68, 0.15, false);
    end);
end;

local function isLandingPlayerStrikeTarget(p73, p74, p75) -- Line: 444
    -- upvalues: EntityUtil (copy), HitQueryContext (copy)
    if p75 == p74 then
        return false;
    end;

    local v76 = p75:FindFirstChildOfClass("Humanoid");
    local HumanoidRootPart = p75:FindFirstChild("HumanoidRootPart");

    if not v76 or (not HumanoidRootPart or (not HumanoidRootPart:IsA("BasePart") or v76.Health <= 0)) then
        return false;
    end;

    local _, v77 = EntityUtil.getEntityIdentity(p75);

    if v77 ~= "Player" then
        return false;
    end;

    local v78 = p73.hitbox[1];

    if not v78 then
        return not EntityUtil.isFriendly({
            id = p73.characterId,
            type = p73.characterType
        }, p75);
    end;

    local v79 = HitQueryContext.create(v78, p75, 0);

    return HitQueryContext.isDetectableTarget(v79);
end;

local function gatherNearbyPlayerLandingStrikePositions(p80, p81, p82) -- Line: 469
    -- upvalues: Players (copy), isLandingPlayerStrikeTarget (copy), SkillCommon (copy)
    local v83 = {};

    for _, v in Players:GetPlayers() do
        local Character = v.Character;

        if Character and isLandingPlayerStrikeTarget(p80, p82, Character) then
            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

            if HumanoidRootPart then
                local Position = HumanoidRootPart.Position;
                local Magnitude = (Vector3.new(p81.X, 0, p81.Z) - Vector3.new(Position.X, 0, Position.Z)).Magnitude;

                if Magnitude <= 200 then
                    local v84 = {
                        dist = Magnitude
                    };
                    local Position2 = SkillCommon.getGroundCF(CFrame.new(HumanoidRootPart.Position), 4, 0.15, "Ground").Position;
                    v84.pos = Vector3.new(Position2.X, Position2.Y + 0.1, Position2.Z);
                    table.insert(v83, v84);
                end;
            end;
        end;
    end;

    table.sort(v83, function(p85, p86) -- Line: 490
        if p85.dist == p86.dist then
            return p85.pos.X < p86.pos.X;
        end;

        return p85.dist < p86.dist;
    end);
    local v87 = {};

    for i = 1, math.min(8, #v83) do
        v87[i] = v83[i].pos;
    end;

    return v87;
end;

local function strikeFlatHintFromCenter(p88, p89) -- Line: 503
    local v90 = p89 - p88;
    local v91 = Vector3.new(v90.X, 0, v90.Z);

    return v91.Magnitude <= 0.05 and Vector3.new(0, 0, -1) or v91.Unit;
end;

local function scheduleLandingPlayerStrikesAtPositions(u92, p93, p94, u95, p96, p97) -- Line: 512
    -- upvalues: SkillCommon (copy), pulseJumpStrikeHitboxAtGround (copy), scheduleJumpStrikeClient (copy)
    if #p93 == 0 then
        return;
    end;

    local u98 = Vector3.new(25, 25, 25) * SkillCommon.npcSummonBodySkillScale(u92);

    for i, v in p93 do
        local v99 = v - p94;
        local v100 = Vector3.new(v99.X, 0, v99.Z);
        local v101 = v100.Magnitude <= 0.05 and Vector3.new(0, 0, -1) or v100.Unit;

        if p96 then
            local u102 = i + 3 - 1 or 2;
            task.delay(p97 + 1.2, function() -- Line: 432
                -- upvalues: u92 (copy), u95 (copy), u102 (copy), pulseJumpStrikeHitboxAtGround (ref), v (copy), u98 (copy)
                if u95 ~= u92.runGeneration then
                    return;
                end;

                local v103 = u92.hitbox[u102];

                if not v103 then
                    return;
                end;

                pulseJumpStrikeHitboxAtGround(v103, v, u98, 0.15, false);
            end);
        else
            scheduleJumpStrikeClient(u92, v, v101, u95, p97);
        end;
    end;
end;

local function scheduleLandingPlayerStrikesIfNeeded(p104, p105, p106, p107) -- Line: 536
    -- upvalues: gatherNearbyPlayerLandingStrikePositions (copy), scheduleLandingPlayerStrikesAtPositions (copy)
    local skillRunData = p104.skillRunData;
    skillRunData.Logic = skillRunData.Logic or {};

    if skillRunData.Logic["multThunderLandPlayerStrikeDone" .. p105] then
        return;
    end;

    skillRunData.Logic["multThunderLandPlayerStrikeDone" .. p105] = true;
    local v108 = p104.skillInputData and p104.skillInputData.character;

    if not v108 then
        return;
    end;

    local endGroundPos = p106.endGroundPos;
    scheduleLandingPlayerStrikesAtPositions(p104, gatherNearbyPlayerLandingStrikePositions(p104, endGroundPos, v108), endGroundPos, p104.runGeneration, p107, 0);
end;

local function scheduleExtraPathStrikes(u109, p110, u111, p112) -- Line: 559
    -- upvalues: SkillCommon (copy), buildPathLeapSegmentTimings (copy), MultThunderTramplePath (copy), pulseJumpStrikeHitboxAtGround (copy), scheduleJumpStrikeClient (copy)
    local u113 = Vector3.new(25, 25, 25) * SkillCommon.npcSummonBodySkillScale(u109);
    local v114, v115, v116 = buildPathLeapSegmentTimings(p110);

    for i = 1, 3 do
        local v117 = (i <= 0 and 1 or 0) + 2;

        for i2 = 1, v117 do
            local v118 = i2 / (v117 + 1);
            local v119 = MultThunderTramplePath.pathArcTForLeapSegment(p110, i, v118);
            local v120 = MultThunderTramplePath.samplePolylineGround(p110, v119);
            local Position = SkillCommon.getGroundCF(CFrame.new(v120), 4, 0.15, "Ground").Position;
            local u121 = Vector3.new(Position.X, Position.Y + 0.1, Position.Z);
            local v122 = MultThunderTramplePath.leapTimeAtLeapSegment(i, v118, v114, v115, v116, 0.2);

            if p112 then
                local u123 = 2;
                task.delay(v122 + 1.2, function() -- Line: 432
                    -- upvalues: u109 (copy), u111 (copy), u123 (copy), pulseJumpStrikeHitboxAtGround (ref), u121 (copy), u113 (copy)
                    if u111 ~= u109.runGeneration then
                        return;
                    end;

                    local v124 = u109.hitbox[u123];

                    if not v124 then
                        return;
                    end;

                    pulseJumpStrikeHitboxAtGround(v124, u121, u113, 0.15, false);
                end);
            else
                scheduleJumpStrikeClient(u109, u121, MultThunderTramplePath.flatTangentAtPathT(p110, v119), u111, v122);
            end;
        end;
    end;
end;

local function emitFootFxModel(p125, p126, p127) -- Line: 595
    -- upvalues: VisibleMgr (copy), FXUtil (copy)
    if not p125 then
        return;
    end;

    p125:ScaleTo(p127);
    VisibleMgr.UnQueryAll(p125);
    p125:PivotTo(p126);
    p125.Parent = workspace.Debris;
    FXUtil.Emit_Particles_GetDescendants(p125, true);
end;

local function resolveGroundAlignedFootCF(p128, p129, p130) -- Line: 606
    -- upvalues: FXUtil (copy)
    if not p129 then
        local HumanoidRootPart = p128:FindFirstChild("HumanoidRootPart");

        if HumanoidRootPart then
            p129 = HumanoidRootPart.Position;
        else
            p129 = p128:GetPivot().Position;
        end;
    end;

    return FXUtil.GetGroundAlignedCF(p129, p130, "Ground", 4, 0.15);
end;

local function playJumpFootFx(p131, p132, p133) -- Line: 615
    -- upvalues: SkillCommon (copy), FXUtil (copy), VisibleMgr (copy)
    local v134 = p131.skillInputData and p131.skillInputData.character;

    if not v134 then
        return;
    end;

    local skillRunData = p131.skillRunData;
    local v135 = skillRunData.material and skillRunData.material["雷跃起跳-暗"];

    if not v135 then
        return;
    end;

    local v136 = SkillCommon.npcSummonBodySkillScale(p131);

    if not p133 then
        local HumanoidRootPart = v134:FindFirstChild("HumanoidRootPart");

        if HumanoidRootPart then
            local v137 = Vector3.new(HumanoidRootPart.CFrame.LookVector.X, 0, HumanoidRootPart.CFrame.LookVector.Z);
            p133 = v137.Magnitude <= 0.05 and Vector3.new(0, 0, -1) or v137.Unit;
        else
            p133 = Vector3.new(0, 0, -1);
        end;
    end;

    local v138;

    if p132 then
        v138 = p132;
    else
        local HumanoidRootPart = v134:FindFirstChild("HumanoidRootPart");

        if HumanoidRootPart then
            v138 = HumanoidRootPart.Position;
        else
            v138 = v134:GetPivot().Position;
        end;
    end;

    local v139 = FXUtil.GetGroundAlignedCF(v138, p133, "Ground", 4, 0.15);

    if v139 then
        if not v135 then
            return;
        end;

        v135:ScaleTo(v136);
        VisibleMgr.UnQueryAll(v135);
        v135:PivotTo(v139);
        v135.Parent = workspace.Debris;
        FXUtil.Emit_Particles_GetDescendants(v135, true);

        return;
    end;

    local v140 = p132 or v134:GetPivot().Position;
    local v141 = CFrame.new(v140) * v135:GetPivot().Rotation;

    if not v135 then
        return;
    end;

    v135:ScaleTo(v136);
    VisibleMgr.UnQueryAll(v135);
    v135:PivotTo(v141);
    v135.Parent = workspace.Debris;
    FXUtil.Emit_Particles_GetDescendants(v135, true);
end;

local function landFxWorldPosFromPlan(p142) -- Line: 637
    return Vector3.new(p142.endPos.X, p142.endGroundPos.Y, p142.endPos.Z);
end;

local function segmentMovementFlatHint(p143) -- Line: 641
    local v144 = Vector3.new(p143.endGroundPos.X - p143.startGroundPos.X, 0, p143.endGroundPos.Z - p143.startGroundPos.Z);

    return v144.Magnitude < 0.01 and Vector3.new(0, 0, -1) or v144.Unit;
end;

local function playLandFootFx(p145, p146, p147) -- Line: 654
    -- upvalues: SkillCommon (copy), FXUtil (copy), cloneEmitFx (copy)
    local v148 = p145.skillInputData and p145.skillInputData.character;

    if not (v148 and p146) then
        return;
    end;

    local skillRunData = p145.skillRunData;
    local v149 = skillRunData.material and skillRunData.material["雷跃落地-暗"];

    if v149 then
        local v150 = SkillCommon.npcSummonBodySkillScale(p145);

        if not p147 then
            local HumanoidRootPart = v148:FindFirstChild("HumanoidRootPart");

            if HumanoidRootPart then
                local v151 = Vector3.new(HumanoidRootPart.CFrame.LookVector.X, 0, HumanoidRootPart.CFrame.LookVector.Z);
                p147 = v151.Magnitude <= 0.05 and Vector3.new(0, 0, -1) or v151.Unit;
            else
                p147 = Vector3.new(0, 0, -1);
            end;
        end;

        local v152 = Vector3.new(p146.X, p146.Y, p146.Z);
        local v153 = FXUtil.GetGroundAlignedCF(v152, p147, "Ground", 4, 0.15);

        if v153 then
            cloneEmitFx(v149, v153, v150, skillRunData);

            return v153.Position;
        end;

        local Position = SkillCommon.getGroundCF(CFrame.new(v152), 4, 0.15, "Ground").Position;
        cloneEmitFx(v149, CFrame.new(Position) * v149:GetPivot().Rotation, v150, skillRunData);

        return Position;
    end;
end;

local function playSegmentLandFootFxIfNeeded(p154, p155, p156, p157, p158) -- Line: 680
    -- upvalues: playLandFootFx (copy), SkillCommon (copy)
    local skillRunData = p154.skillRunData;

    if not (skillRunData and skillRunData.Logic) then
        return;
    end;

    if skillRunData.Logic["multThunderLandFxDone" .. p155] then
        return;
    end;

    skillRunData.Logic["multThunderLandFxDone" .. p155] = true;
    local v159 = Vector3.new(p156.endPos.X, p156.endGroundPos.Y, p156.endPos.Z);
    local v160;

    if p157 then
        local v161 = Vector3.new(p156.endGroundPos.X - p156.startGroundPos.X, 0, p156.endGroundPos.Z - p156.startGroundPos.Z);
        v160 = v161.Magnitude < 0.01 and Vector3.new(0, 0, -1) or v161.Unit;
    else
        v160 = nil;
    end;

    local v162 = playLandFootFx(p154, v159, v160);

    if not p158 and v162 then
        SkillCommon.playSoundLocal3D("音效-技能-独角兽-跳跃落地", v162);
    end;
end;

local function onSegmentLandingIfNeeded(p163, p164, p165, p166, p167) -- Line: 705
    -- upvalues: playSegmentLandFootFxIfNeeded (copy), scheduleLandingPlayerStrikesIfNeeded (copy)
    playSegmentLandFootFxIfNeeded(p163, p164, p165, p166, p167);
    scheduleLandingPlayerStrikesIfNeeded(p163, p164, p165, p167);
end;

local function storeSegmentPlan(p168, p169) -- Line: 716
    p168.Logic["multThunderSegPlan" .. p169.segmentIndex] = p169;
end;

local function getStoredSegmentPlan(p170, p171) -- Line: 720
    return p170.Logic["multThunderSegPlan" .. p171];
end;

local function disconnectRunEvent(p172, p173) -- Line: 724
    -- upvalues: SkillCommon (copy)
    SkillCommon.disconnectRunEventKeys(p172.skillRunData, { p173 });
end;

local function buildFlatLookRotation(p174, p175, p176) -- Line: 728
    local v177 = Vector3.new(p175.X - p174.X, 0, p175.Z - p174.Z);

    if v177.Magnitude < 0.01 then
        return p176;
    end;

    return CFrame.lookAt(Vector3.new(0, 0, 0), v177.Unit, Vector3.new(0, 1, 0));
end;

local function resolveMoveFaceMode(p178) -- Line: 736
    -- upvalues: u2 (copy)
    return p178 and p178.moveFaceMode == u2.MoveFaceMode.AttackTarget and "AttackTarget" or "MoveTarget";
end;

local function resolveSegmentTravelRotation(p179, p180) -- Line: 743
    -- upvalues: buildFlatLookRotation (copy)
    if p180.faceMode == "AttackTarget" and p180.attackFaceWorldPos then
        return buildFlatLookRotation(p179.startGroundPos, p180.attackFaceWorldPos, p180.startRot);
    end;

    return buildFlatLookRotation(p179.startGroundPos, p179.endGroundPos, p180.startRot);
end;

local function resolveSegmentFaceRotation(p181, p182, p183) -- Line: 750
    -- upvalues: buildFlatLookRotation (copy)
    local v184;

    if p182.faceMode == "AttackTarget" and p182.attackFaceWorldPos then
        local startGroundPos = p181.startGroundPos;
        local attackFaceWorldPos = p182.attackFaceWorldPos;
        v184 = p182.startRot;
        local v185 = Vector3.new(attackFaceWorldPos.X - startGroundPos.X, 0, attackFaceWorldPos.Z - startGroundPos.Z);

        if v185.Magnitude >= 0.01 then
            v184 = CFrame.lookAt(Vector3.new(0, 0, 0), v185.Unit, Vector3.new(0, 1, 0));
        end;
    else
        local startGroundPos = p181.startGroundPos;
        local endGroundPos = p181.endGroundPos;
        v184 = p182.startRot;
        local v186 = Vector3.new(endGroundPos.X - startGroundPos.X, 0, endGroundPos.Z - startGroundPos.Z);

        if v186.Magnitude >= 0.01 then
            v184 = CFrame.lookAt(Vector3.new(0, 0, 0), v186.Unit, Vector3.new(0, 1, 0));
        end;
    end;

    if p182.faceMode == "AttackTarget" and p182.attackFaceWorldPos then
        return buildFlatLookRotation(p183, p182.attackFaceWorldPos, v184);
    end;

    return buildFlatLookRotation(p183, p181.endPos, v184);
end;

local function resolveRawGroundY(p187) -- Line: 759
    -- upvalues: SkillCommon (copy)
    return SkillCommon.getGroundCF(CFrame.new(p187), 4, 0, "Ground").Position.Y;
end;

local function resolveFrozenStrikeWorld(p188) -- Line: 764
    -- upvalues: SkillCommon (copy)
    if p188 and typeof(p188.moveFaceWorldPos) == "Vector3" then
        return p188.moveFaceWorldPos;
    end;

    if p188 and p188.targetCF then
        return p188.targetCF.Position;
    end;

    return SkillCommon.resolveStrikeWorldPos(p188);
end;

local function hasAuthorityPathPoints(p189) -- Line: 774
    -- upvalues: MultThunderTramplePath (copy)
    if p189 then
        p189 = p189.multThunderPathPoints;
    end;

    return MultThunderTramplePath.normalizePathPointsFromSync(p189) ~= nil;
end;

local function resolveCastSpawnGround(p190, p191, p192) -- Line: 778
    -- upvalues: MultThunderTramplePath (copy), SkillCommon (copy)
    return MultThunderTramplePath.resolveSpawnGroundFromCharacter(p190) or MultThunderTramplePath.inferSpawnGroundFromPathStart(SkillCommon.getGroundCF(CFrame.new(p191.Position), 4, 0.15, "Ground").Position, p192);
end;

local function pathPlanFromAuthorityPoints(p193) -- Line: 786
    -- upvalues: MultThunderTramplePath (copy)
    return MultThunderTramplePath.planFromPoints(p193);
end;

local function commitPathRootFromAuthority(p194, p195, p196, p197) -- Line: 790
    -- upvalues: MultThunderTramplePath (copy), SkillCommon (copy), u2 (copy)
    local v198 = MultThunderTramplePath.normalizePathPointsFromSync(p195.multThunderPathPoints);

    if not v198 then
        return nil;
    end;

    p195.multThunderPathPoints = MultThunderTramplePath.copyPathPoints(v198);
    local Position = p197.Position;
    local v199 = SkillCommon.getGroundCF(CFrame.new(Position), 4, 0, "Ground").Position.Y or Position.Y;
    local v200 = math.max(0, Position.Y - v199);
    local v201 = MultThunderTramplePath.planFromPoints(v198);

    if not v201 then
        return nil;
    end;

    local v202;

    if typeof(p195.multThunderSpawnGround) == "Vector3" then
        v202 = p195.multThunderSpawnGround;
    else
        v202 = v201.startPos;
    end;

    local v203;

    if p195 and typeof(p195.moveFaceWorldPos) == "Vector3" then
        v203 = p195.moveFaceWorldPos;
    elseif p195 and p195.targetCF then
        v203 = p195.targetCF.Position;
    else
        v203 = SkillCommon.resolveStrikeWorldPos(p195);
    end;

    local v204 = p196:GetPivot();
    local v205 = p195 and p195.moveFaceMode == u2.MoveFaceMode.AttackTarget and "AttackTarget" or "MoveTarget";

    if v205 == "AttackTarget" then
        if typeof(p195.moveFaceWorldPos) == "Vector3" then
            v203 = p195.moveFaceWorldPos;
        end;
    else
        v203 = nil;
    end;

    local v206 = Vector3.new(v201.endPos.X, v201.endPos.Y + v200, v201.endPos.Z);

    return {
        lastSegmentEndGround = nil,
        pathPlan = v201,
        spawnGround = v202,
        groundClearance = v200,
        faceMode = v205,
        attackFaceWorldPos = v203,
        startRot = v204.Rotation,
        finalEndPos = v206
    };
end;

local function publishMultThunderPathAuthority(p207, p208) -- Line: 843
    -- upvalues: MultThunderTramplePath (copy)
    local skillInputData = p207.skillInputData;

    if not skillInputData then
        return;
    end;

    skillInputData.multThunderPathPoints = MultThunderTramplePath.copyPathPoints(p208.pathPlan.points);
    skillInputData.multThunderSpawnGround = p208.spawnGround;
    skillInputData._multThunderPathFrozen = true;
end;

local function buildPathPlanOnceAtSkillStart(p209, p210, p211, p212) -- Line: 854
    -- upvalues: SkillCommon (copy), MultThunderTramplePath (copy)
    SkillCommon.refreshSkillAimSnapshot(p209);
    local v213;

    if p212 and typeof(p212.moveFaceWorldPos) == "Vector3" then
        v213 = p212.moveFaceWorldPos;
    elseif p212 and p212.targetCF then
        v213 = p212.targetCF.Position;
    else
        v213 = SkillCommon.resolveStrikeWorldPos(p212);
    end;

    local v214 = MultThunderTramplePath.resolveSpawnGroundFromCharacter(p210) or MultThunderTramplePath.inferSpawnGroundFromPathStart(SkillCommon.getGroundCF(CFrame.new(p211.Position), 4, 0.15, "Ground").Position, v213);

    if v214 then
        return MultThunderTramplePath.buildHorizontalPlan(v214, v213);
    end;

    return nil;
end;

local function commitPathRoot(p215) -- Line: 869
    -- upvalues: MultThunderTramplePath (copy), commitPathRootFromAuthority (copy), RunService (copy), SkillCommon (copy), u2 (copy)
    local skillInputData = p215.skillInputData;
    local v216;

    if skillInputData then
        v216 = skillInputData.character;
    else
        v216 = skillInputData;
    end;

    if not v216 then
        return nil;
    end;

    local HumanoidRootPart = v216:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return nil;
    end;

    local v217;

    if skillInputData then
        v217 = skillInputData.multThunderPathPoints;
    else
        v217 = skillInputData;
    end;

    local v218 = MultThunderTramplePath.normalizePathPointsFromSync(v217) ~= nil and commitPathRootFromAuthority(p215, skillInputData, v216, HumanoidRootPart);

    if v218 then
        if RunService:IsServer() then
            local skillInputData2 = p215.skillInputData;

            if not skillInputData2 then
                return v218;
            end;

            skillInputData2.multThunderPathPoints = MultThunderTramplePath.copyPathPoints(v218.pathPlan.points);
            skillInputData2.multThunderSpawnGround = v218.spawnGround;
            skillInputData2._multThunderPathFrozen = true;
        end;

        return v218;
    end;

    if not RunService:IsServer() then
        return nil;
    end;

    if skillInputData._multThunderPathFrozen then
        local v219;

        if skillInputData then
            v219 = skillInputData.multThunderPathPoints;
        else
            v219 = skillInputData;
        end;

        if MultThunderTramplePath.normalizePathPointsFromSync(v219) == nil then
            return nil;
        end;
    end;

    if skillInputData._multThunderPathFrozen then
        return commitPathRootFromAuthority(p215, skillInputData, v216, HumanoidRootPart);
    end;

    SkillCommon.refreshSkillAimSnapshot(p215);
    local v220;

    if skillInputData and typeof(skillInputData.moveFaceWorldPos) == "Vector3" then
        v220 = skillInputData.moveFaceWorldPos;
    elseif skillInputData and skillInputData.targetCF then
        v220 = skillInputData.targetCF.Position;
    else
        v220 = SkillCommon.resolveStrikeWorldPos(skillInputData);
    end;

    local v221 = MultThunderTramplePath.resolveSpawnGroundFromCharacter(v216) or MultThunderTramplePath.inferSpawnGroundFromPathStart(SkillCommon.getGroundCF(CFrame.new(HumanoidRootPart.Position), 4, 0.15, "Ground").Position, v220);
    local v222;

    if v221 then
        v222 = MultThunderTramplePath.buildHorizontalPlan(v221, v220);
    else
        v222 = nil;
    end;

    if not v222 then
        return nil;
    end;

    local Position = HumanoidRootPart.Position;
    local v223 = SkillCommon.getGroundCF(CFrame.new(Position), 4, 0, "Ground").Position.Y or Position.Y;
    local v224 = math.max(0, Position.Y - v223);
    local v225 = v216:GetPivot();
    local v226 = skillInputData and skillInputData.moveFaceMode == u2.MoveFaceMode.AttackTarget and "AttackTarget" or "MoveTarget";
    local v227;

    if skillInputData and typeof(skillInputData.moveFaceWorldPos) == "Vector3" then
        v227 = skillInputData.moveFaceWorldPos;
    elseif skillInputData and skillInputData.targetCF then
        v227 = skillInputData.targetCF.Position;
    else
        v227 = SkillCommon.resolveStrikeWorldPos(skillInputData);
    end;

    local v228;

    if v226 == "AttackTarget" then
        if typeof(skillInputData.moveFaceWorldPos) == "Vector3" then
            v228 = skillInputData.moveFaceWorldPos;
        else
            v228 = v227;
        end;
    else
        v228 = nil;
    end;

    local v229;

    if typeof(skillInputData.multThunderSpawnGround) == "Vector3" then
        v229 = skillInputData.multThunderSpawnGround;
    else
        v229 = MultThunderTramplePath.resolveSpawnGroundFromCharacter(v216) or MultThunderTramplePath.inferSpawnGroundFromPathStart(SkillCommon.getGroundCF(CFrame.new(HumanoidRootPart.Position), 4, 0.15, "Ground").Position, v227) or v222.startPos;
    end;

    local v230 = Vector3.new(v222.endPos.X, v222.endPos.Y + v224, v222.endPos.Z);
    local v231 = {
        lastSegmentEndGround = nil,
        pathPlan = v222,
        spawnGround = v229,
        groundClearance = v224,
        faceMode = v226,
        attackFaceWorldPos = v228,
        startRot = v225.Rotation,
        finalEndPos = v230
    };
    local skillInputData2 = p215.skillInputData;

    if not skillInputData2 then
        return v231;
    end;

    skillInputData2.multThunderPathPoints = MultThunderTramplePath.copyPathPoints(v231.pathPlan.points);
    skillInputData2.multThunderSpawnGround = v231.spawnGround;
    skillInputData2._multThunderPathFrozen = true;

    return v231;
end;

local function resolveSegmentStartGround(p232, p233, p234, p235, p236) -- Line: 952
    -- upvalues: SkillCommon (copy)
    if p234 > 1 and p233.lastSegmentEndGround then
        return p233.lastSegmentEndGround;
    end;

    if p234 > 1 then
        return SkillCommon.getGroundCF(CFrame.new(p236[p234]), 4, 0.15, "Ground").Position;
    end;

    local Position = SkillCommon.getGroundCF(CFrame.new(p236[p234]), 4, 0.15, "Ground").Position;

    if p234 == 1 then
        local skillInputData = p232.skillInputData;

        if skillInputData and typeof(skillInputData.approachLandWorldPos) == "Vector3" then
            return SkillCommon.getGroundCF(CFrame.new(skillInputData.approachLandWorldPos), 4, 0.15, "Ground").Position;
        end;

        local Position2 = SkillCommon.getGroundCF(CFrame.new(p235.Position), 4, 0.15, "Ground").Position;

        if (Vector3.new(Position2.X, 0, Position2.Z) - Vector3.new(Position.X, 0, Position.Z)).Magnitude <= 12 then
            return Position2;
        end;
    end;

    return Position;
end;

local function recordSegmentEndGround(p237, p238) -- Line: 980
    p237.lastSegmentEndGround = p238;
end;

local function commitSegmentMovePlan(p239, p240, p241) -- Line: 984
    -- upvalues: resolveSegmentStartGround (copy), SkillCommon (copy), ThunderLeapTiming (copy)
    local skillInputData = p239.skillInputData;

    if skillInputData then
        skillInputData = skillInputData.character;
    end;

    if not skillInputData then
        return nil;
    end;

    local HumanoidRootPart = skillInputData:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return nil;
    end;

    local points = p240.pathPlan.points;
    local v242 = resolveSegmentStartGround(p239, p240, p241, HumanoidRootPart, points);
    local v243 = Vector3.new(v242.X, v242.Y + p240.groundClearance, v242.Z);
    local Position = SkillCommon.getGroundCF(CFrame.new(points[p241 + 1]), 4, 0.15, "Ground").Position;
    local v244 = Vector3.new(Position.X, Position.Y + 0.1, Position.Z);
    local v245 = Vector3.new(v244.X, v244.Y + p240.groundClearance, v244.Z);
    local v246 = SkillCommon.npcSummonBodySkillScale(p239);
    local Magnitude = (Vector3.new(v243.X, 0, v243.Z) - Vector3.new(v245.X, 0, v245.Z)).Magnitude;
    local v247 = math.min(16, Magnitude * 0.35) * v246;
    local v248 = ThunderLeapTiming.computeFromHorizDist(Magnitude);

    return {
        startedAt = 0,
        segmentIndex = p241,
        startPos = v243,
        endPos = v245,
        startGroundPos = v242,
        endGroundPos = v244,
        startRot = p240.startRot,
        faceMode = p240.faceMode,
        attackFaceWorldPos = p240.attackFaceWorldPos,
        arcHeight = v247,
        duration = v248.total,
        groundClearance = p240.groundClearance,
        landGroundPos = v244,
        phases = v248
    };
end;

local function sampleSegmentMoveCF(p249, p250, p251) -- Line: 1033
    -- upvalues: TweenService (copy), Quad (copy), Out (copy), ThunderLeapTiming (copy)
    local v252 = math.clamp(p251, 0, 1);
    local v253 = TweenService:GetValue(v252, Quad, Out);
    local v254 = p249.startGroundPos:Lerp(p249.endGroundPos, v253);
    local v255 = ThunderLeapTiming.sampleArcHeight(v252, p249.arcHeight);
    local v256 = Vector3.new(v254.X, v254.Y + p249.groundClearance + v255, v254.Z);
    local v257 = CFrame.new(v256);
    local v258;

    if p250.faceMode == "AttackTarget" and p250.attackFaceWorldPos then
        local startGroundPos = p249.startGroundPos;
        local attackFaceWorldPos = p250.attackFaceWorldPos;
        v258 = p250.startRot;
        local v259 = Vector3.new(attackFaceWorldPos.X - startGroundPos.X, 0, attackFaceWorldPos.Z - startGroundPos.Z);

        if v259.Magnitude >= 0.01 then
            v258 = CFrame.lookAt(Vector3.new(0, 0, 0), v259.Unit, Vector3.new(0, 1, 0));
        end;
    else
        local startGroundPos = p249.startGroundPos;
        local endGroundPos = p249.endGroundPos;
        v258 = p250.startRot;
        local v260 = Vector3.new(endGroundPos.X - startGroundPos.X, 0, endGroundPos.Z - startGroundPos.Z);

        if v260.Magnitude >= 0.01 then
            v258 = CFrame.lookAt(Vector3.new(0, 0, 0), v260.Unit, Vector3.new(0, 1, 0));
        end;
    end;

    if p250.faceMode == "AttackTarget" and p250.attackFaceWorldPos then
        local attackFaceWorldPos = p250.attackFaceWorldPos;
        local v261 = Vector3.new(attackFaceWorldPos.X - v256.X, 0, attackFaceWorldPos.Z - v256.Z);

        if v261.Magnitude >= 0.01 then
            v258 = CFrame.lookAt(Vector3.new(0, 0, 0), v261.Unit, Vector3.new(0, 1, 0));
        end;
    else
        local endPos = p249.endPos;
        local v262 = Vector3.new(endPos.X - v256.X, 0, endPos.Z - v256.Z);

        if v262.Magnitude >= 0.01 then
            v258 = CFrame.lookAt(Vector3.new(0, 0, 0), v262.Unit, Vector3.new(0, 1, 0));
        end;
    end;

    return v257 * v258;
end;

local function resolveRecoveryTargetRotation(p263, p264, p265) -- Line: 1047
    -- upvalues: buildFlatLookRotation (copy)
    local v266 = Vector3.new(p264.endGroundPos.X, p264.endGroundPos.Y + p264.groundClearance, p264.endGroundPos.Z);
    local v267;

    if p263.faceMode == "AttackTarget" and p263.attackFaceWorldPos then
        local startGroundPos = p264.startGroundPos;
        local attackFaceWorldPos = p263.attackFaceWorldPos;
        v267 = p263.startRot;
        local v268 = Vector3.new(attackFaceWorldPos.X - startGroundPos.X, 0, attackFaceWorldPos.Z - startGroundPos.Z);

        if v268.Magnitude >= 0.01 then
            v267 = CFrame.lookAt(Vector3.new(0, 0, 0), v268.Unit, Vector3.new(0, 1, 0));
        end;
    else
        local startGroundPos = p264.startGroundPos;
        local endGroundPos = p264.endGroundPos;
        v267 = p263.startRot;
        local v269 = Vector3.new(endGroundPos.X - startGroundPos.X, 0, endGroundPos.Z - startGroundPos.Z);

        if v269.Magnitude >= 0.01 then
            v267 = CFrame.lookAt(Vector3.new(0, 0, 0), v269.Unit, Vector3.new(0, 1, 0));
        end;
    end;

    if p263.faceMode == "AttackTarget" and p263.attackFaceWorldPos then
        local attackFaceWorldPos = p263.attackFaceWorldPos;
        local v270 = Vector3.new(attackFaceWorldPos.X - v266.X, 0, attackFaceWorldPos.Z - v266.Z);

        if v270.Magnitude >= 0.01 then
            v267 = CFrame.lookAt(Vector3.new(0, 0, 0), v270.Unit, Vector3.new(0, 1, 0));
        end;
    else
        local endPos = p264.endPos;
        local v271 = Vector3.new(endPos.X - v266.X, 0, endPos.Z - v266.Z);

        if v271.Magnitude >= 0.01 then
            v267 = CFrame.lookAt(Vector3.new(0, 0, 0), v271.Unit, Vector3.new(0, 1, 0));
        end;
    end;

    return buildFlatLookRotation(v266, p265, v267);
end;

local function lockCharacterForSkillMove(p272) -- Line: 1057
    local HumanoidRootPart = p272:FindFirstChild("HumanoidRootPart");
    local v273 = p272:FindFirstChildOfClass("Humanoid");

    if not (HumanoidRootPart and v273) then
        return nil;
    end;

    local v274 = {
        hrp = HumanoidRootPart,
        humanoid = v273,
        wasAnchored = HumanoidRootPart.Anchored,
        wasAutoRotate = v273.AutoRotate,
        prevWalkSpeed = v273.WalkSpeed
    };
    HumanoidRootPart.Anchored = true;
    v273.AutoRotate = false;
    v273.WalkSpeed = 0;
    p272:SetAttribute("MultThunderTrampleMoveLock", true);
    p272:SetAttribute("NPCUprightSnapDisabled", true);

    return v274;
end;

local function getSkillCharacter(p275) -- Line: 1078
    return p275.character or p275.skillInputData and p275.skillInputData.character;
end;

local function resolveHrpAndHumanoid(p276, p277) -- Line: 1082
    if p276 and p276.Parent then
        local HumanoidRootPart = p276:FindFirstChild("HumanoidRootPart");
        local v278 = p276:FindFirstChildOfClass("Humanoid");

        if HumanoidRootPart and (HumanoidRootPart.Parent and (v278 and v278.Parent)) then
            return HumanoidRootPart, v278;
        end;
    end;

    if p277 and (p277.hrp and (p277.hrp.Parent and (p277.humanoid and p277.humanoid.Parent))) then
        return p277.hrp, p277.humanoid;
    end;

    return nil, nil;
end;

local function clearSkillMoveLockAttribute(p279) -- Line: 1096
    if p279 and p279.Parent then
        p279:SetAttribute("MultThunderTrampleMoveLock", nil);
        p279:SetAttribute("NPCUprightSnapDisabled", nil);
    end;
end;

local function markSkillMoveLockApplied(p280, p281) -- Line: 1103
    if p281 and p280 then
        p280.Logic = p280.Logic or {};
        p280.Logic.multThunderTrampleMoveLockApplied = true;
    end;
end;

local function syncNpcEntityPos(p282, p283) -- Line: 1110
    -- upvalues: UtilsSystem (copy)
    local SystemEnemy = UtilsSystem.SystemEnemy;
    local v284;

    if SystemEnemy and SystemEnemy.getPackByModel then
        v284 = SystemEnemy.getPackByModel(p282);
    else
        v284 = nil;
    end;

    if not v284 then
        local SystemSummon = UtilsSystem.SystemSummon;

        if SystemSummon and SystemSummon.getPackByModel then
            v284 = SystemSummon.getPackByModel(p282);
        end;
    end;

    if v284 then
        v284 = v284.entity;
    end;

    if not v284 then
        return;
    end;

    v284.pos = p283;
    v284.lastPos = p283;
end;

local function serverStartSmoothFaceRotation(u285, u286, u287, u288, u289, u290, u291) -- Line: 1128
    -- upvalues: SkillCommon (copy), RunService (copy), UtilsSystem (copy)
    local u292 = u285.character or u285.skillInputData and u285.skillInputData.character;

    if not u292 then
        return;
    end;

    SkillCommon.disconnectRunEventKeys(u285.skillRunData, { u286 });
    local skillRunData = u285.skillRunData;

    if not skillRunData then
        return;
    end;

    skillRunData.runEvent = skillRunData.runEvent or {};
    skillRunData.runEvent[u286] = RunService.Heartbeat:Connect(function() -- Line: 1149
        -- upvalues: u285 (copy), u286 (copy), SkillCommon (ref), skillRunData (copy), u287 (copy), u288 (copy), u290 (copy), u291 (copy), u292 (copy), u289 (copy), UtilsSystem (ref)
        if not u285:isRunningFlow() then
            SkillCommon.disconnectRunEventKeys(u285.skillRunData, { u286 });

            return;
        end;

        if (skillRunData.State and skillRunData.State.current) ~= u287 then
            SkillCommon.disconnectRunEventKeys(u285.skillRunData, { u286 });

            return;
        end;

        local v293;

        if skillRunData.State then
            v293 = skillRunData.State.enteredAt;
        else
            v293 = u285.nowTime;
        end;

        local v294 = math.clamp((u285.nowTime - v293) / u288, 0, 1);
        local v295 = u290:Lerp(u291, v294);
        u292:PivotTo(CFrame.new(u289) * v295);
        local v296 = u292;
        local v297 = u289;
        local SystemEnemy = UtilsSystem.SystemEnemy;
        local v298;

        if SystemEnemy and SystemEnemy.getPackByModel then
            v298 = SystemEnemy.getPackByModel(v296);
        else
            v298 = nil;
        end;

        if not v298 then
            local SystemSummon = UtilsSystem.SystemSummon;

            if SystemSummon and SystemSummon.getPackByModel then
                v298 = SystemSummon.getPackByModel(v296);
            end;
        end;

        if v298 then
            v298 = v298.entity;
        end;

        if v298 then
            v298.pos = v297;
            v298.lastPos = v297;
        end;

        if v294 >= 1 then
            SkillCommon.disconnectRunEventKeys(u285.skillRunData, { u286 });
        end;
    end);
end;

local u299 = nil;

local function serverStartRecoveryFaceRotation(u300, u301, u302, u303, u304) -- Line: 1174
    -- upvalues: SkillCommon (copy), RunService (copy), ThunderLeapTiming (copy), UtilsSystem (copy), u299 (ref)
    local u305 = u300.character or u300.skillInputData and u300.skillInputData.character;

    if not u305 then
        return;
    end;

    SkillCommon.disconnectRunEventKeys(u300.skillRunData, { "MultThunderTrampleRecoveryFace" });
    local skillRunData = u300.skillRunData;

    if not skillRunData then
        return;
    end;

    local nowTime = u300.nowTime;
    skillRunData.runEvent = skillRunData.runEvent or {};
    skillRunData.runEvent.MultThunderTrampleRecoveryFace = RunService.Heartbeat:Connect(function() -- Line: 1194
        -- upvalues: u300 (copy), SkillCommon (ref), skillRunData (copy), u301 (copy), u302 (copy), nowTime (ref), ThunderLeapTiming (ref), u305 (copy), u303 (copy), UtilsSystem (ref), u299 (ref), u304 (copy)
        if not u300:isRunningFlow() then
            SkillCommon.disconnectRunEventKeys(u300.skillRunData, { "MultThunderTrampleRecoveryFace" });

            return;
        end;

        if (skillRunData.State and skillRunData.State.current) ~= "Recovery" then
            SkillCommon.disconnectRunEventKeys(u300.skillRunData, { "MultThunderTrampleRecoveryFace" });

            return;
        end;

        SkillCommon.refreshSkillAimSnapshot(u300);
        local v306 = SkillCommon.resolveStrikeWorldPos(u300.skillInputData);
        local v307 = u301;
        local v308 = u302;
        local v309 = Vector3.new(v308.endGroundPos.X, v308.endGroundPos.Y + v308.groundClearance, v308.endGroundPos.Z);
        local v310;

        if v307.faceMode == "AttackTarget" and v307.attackFaceWorldPos then
            local startGroundPos = v308.startGroundPos;
            local attackFaceWorldPos = v307.attackFaceWorldPos;
            v310 = v307.startRot;
            local v311 = Vector3.new(attackFaceWorldPos.X - startGroundPos.X, 0, attackFaceWorldPos.Z - startGroundPos.Z);

            if v311.Magnitude >= 0.01 then
                v310 = CFrame.lookAt(Vector3.new(0, 0, 0), v311.Unit, Vector3.new(0, 1, 0));
            end;
        else
            local startGroundPos = v308.startGroundPos;
            local endGroundPos = v308.endGroundPos;
            v310 = v307.startRot;
            local v312 = Vector3.new(endGroundPos.X - startGroundPos.X, 0, endGroundPos.Z - startGroundPos.Z);

            if v312.Magnitude >= 0.01 then
                v310 = CFrame.lookAt(Vector3.new(0, 0, 0), v312.Unit, Vector3.new(0, 1, 0));
            end;
        end;

        if v307.faceMode == "AttackTarget" and v307.attackFaceWorldPos then
            local attackFaceWorldPos = v307.attackFaceWorldPos;
            local v313 = Vector3.new(attackFaceWorldPos.X - v309.X, 0, attackFaceWorldPos.Z - v309.Z);

            if v313.Magnitude >= 0.01 then
                v310 = CFrame.lookAt(Vector3.new(0, 0, 0), v313.Unit, Vector3.new(0, 1, 0));
            end;
        else
            local endPos = v308.endPos;
            local v314 = Vector3.new(endPos.X - v309.X, 0, endPos.Z - v309.Z);

            if v314.Magnitude >= 0.01 then
                v310 = CFrame.lookAt(Vector3.new(0, 0, 0), v314.Unit, Vector3.new(0, 1, 0));
            end;
        end;

        local v315 = Vector3.new(v306.X - v309.X, 0, v306.Z - v309.Z);

        if v315.Magnitude >= 0.01 then
            v310 = CFrame.lookAt(Vector3.new(0, 0, 0), v315.Unit, Vector3.new(0, 1, 0));
        end;

        local nowTime2 = u300.nowTime;
        local v316 = math.max(nowTime2 - nowTime, 0);
        nowTime = nowTime2;
        local v317 = math.clamp(v316 * ThunderLeapTiming.RECOVERY_FACE_TRACK_RATE, 0, 1);
        local v318 = u305:GetPivot().Rotation:Lerp(v310, v317);
        u305:PivotTo(CFrame.new(u303) * v318);
        local v319 = u305;
        local v320 = u303;
        local SystemEnemy = UtilsSystem.SystemEnemy;
        local v321;

        if SystemEnemy and SystemEnemy.getPackByModel then
            v321 = SystemEnemy.getPackByModel(v319);
        else
            v321 = nil;
        end;

        if not v321 then
            local SystemSummon = UtilsSystem.SystemSummon;

            if SystemSummon and SystemSummon.getPackByModel then
                v321 = SystemSummon.getPackByModel(v319);
            end;
        end;

        if v321 then
            v321 = v321.entity;
        end;

        if v321 then
            v321.pos = v320;
            v321.lastPos = v320;
        end;

        if ThunderLeapTiming.isFlatLookAligned(v318, v310) then
            SkillCommon.disconnectRunEventKeys(u300.skillRunData, { "MultThunderTrampleRecoveryFace" });
            u299(u300);

            return;
        end;

        local v322;

        if skillRunData.State then
            v322 = skillRunData.State.enteredAt;
        else
            v322 = nowTime2;
        end;

        if u304 <= nowTime2 - v322 then
            SkillCommon.disconnectRunEventKeys(u300.skillRunData, { "MultThunderTrampleRecoveryFace" });
        end;
    end);
end;

local function pinCharacterAtSegmentEnd(p323, p324, p325) -- Line: 1231
    -- upvalues: sampleSegmentMoveCF (copy), UtilsSystem (copy)
    local v326 = p323.skillInputData and p323.skillInputData.character;

    if not v326 then
        return;
    end;

    v326:PivotTo((sampleSegmentMoveCF(p324, p325, 1)));
    p325.lastSegmentEndGround = p324.endGroundPos;
    local endPos = p324.endPos;
    local SystemEnemy = UtilsSystem.SystemEnemy;
    local v327;

    if SystemEnemy and SystemEnemy.getPackByModel then
        v327 = SystemEnemy.getPackByModel(v326);
    else
        v327 = nil;
    end;

    if not v327 then
        local SystemSummon = UtilsSystem.SystemSummon;

        if SystemSummon and SystemSummon.getPackByModel then
            v327 = SystemSummon.getPackByModel(v326);
        end;
    end;

    if v327 then
        v327 = v327.entity;
    end;

    if not v327 then
        return;
    end;

    v327.pos = endPos;
    v327.lastPos = endPos;
end;

local function pinCharacterAtSegmentPlanEnd(p328, p329, p330) -- Line: 1241
    -- upvalues: sampleSegmentMoveCF (copy), UtilsSystem (copy)
    local v331 = p328.skillInputData and p328.skillInputData.character;

    if not v331 then
        return;
    end;

    v331:PivotTo((sampleSegmentMoveCF(p329, p330, 1)));
    p330.lastSegmentEndGround = p329.endGroundPos;
    local endPos = p329.endPos;
    local SystemEnemy = UtilsSystem.SystemEnemy;
    local v332;

    if SystemEnemy and SystemEnemy.getPackByModel then
        v332 = SystemEnemy.getPackByModel(v331);
    else
        v332 = nil;
    end;

    if not v332 then
        local SystemSummon = UtilsSystem.SystemSummon;

        if SystemSummon and SystemSummon.getPackByModel then
            v332 = SystemSummon.getPackByModel(v331);
        end;
    end;

    if v332 then
        v332 = v332.entity;
    end;

    if not v332 then
        return;
    end;

    v332.pos = endPos;
    v332.lastPos = endPos;
end;

local function getSkillAnimator(p333) -- Line: 1252
    if not p333 then
        return nil;
    end;

    local v334 = p333:FindFirstChildOfClass("Humanoid");

    if v334 then
        return v334:FindFirstChildOfClass("Animator");
    end;

    return nil;
end;

local function setTrackLooped(p335, p336, p337) -- Line: 1263
    for _, v in p335:GetPlayingAnimationTracks() do
        if v.Name == p336 then
            v.Looped = p337;

            return;
        end;
    end;
end;

local function stopSegmentSkillAnims(p338) -- Line: 1272
    -- upvalues: AnimationModule (copy)
    if not p338 then
        return;
    end;

    AnimationModule.StopAnim(p338, "雷跃", 0.1);
    AnimationModule.StopAnim(p338, "独角兽行走异形骨骼", 0.1);
end;

local function serverPlayLeapAnim(p339, p340) -- Line: 1280
    -- upvalues: AnimationModule (copy), Action4 (copy)
    local v341 = p339.skillInputData and p339.skillInputData.character;
    local v342;

    if v341 then
        local v343 = v341:FindFirstChildOfClass("Humanoid");

        if v343 then
            v342 = v343:FindFirstChildOfClass("Animator");
        else
            v342 = nil;
        end;
    else
        v342 = nil;
    end;

    if not v342 then
        return;
    end;

    AnimationModule.StopAnim(v342, "独角兽行走异形骨骼", 0.1);
    AnimationModule.StopAnim(v342, "雷跃", 0);
    AnimationModule.PlayAnim(v342, "雷跃", p340, nil, nil, Action4, 0.1);

    for _, v in v342:GetPlayingAnimationTracks() do
        if v.Name == "雷跃" then
            v.Looped = false;

            return;
        end;
    end;
end;

local function serverStopLeapAnim(p344) -- Line: 1292
    -- upvalues: AnimationModule (copy)
    local v345 = p344.skillInputData and p344.skillInputData.character;
    local v346;

    if v345 then
        local v347 = v345:FindFirstChildOfClass("Humanoid");

        if v347 then
            v346 = v347:FindFirstChildOfClass("Animator");
        else
            v346 = nil;
        end;
    else
        v346 = nil;
    end;

    if v346 then
        AnimationModule.StopAnim(v346, "雷跃", 0.1);
    end;
end;

local function serverPlayPauseWalkAnim(p348) -- Line: 1300
    -- upvalues: AnimationModule (copy), Movement (copy)
    local v349 = p348.skillInputData and p348.skillInputData.character;
    local v350;

    if v349 then
        local v351 = v349:FindFirstChildOfClass("Humanoid");

        if v351 then
            v350 = v351:FindFirstChildOfClass("Animator");
        else
            v350 = nil;
        end;
    else
        v350 = nil;
    end;

    if not v350 then
        return;
    end;

    AnimationModule.StopAnim(v350, "雷跃", 0.1);
    AnimationModule.StopAnim(v350, "独角兽行走异形骨骼", 0);
    AnimationModule.PlayAnim(v350, "独角兽行走异形骨骼", 1, nil, nil, Movement, 0.1);

    for _, v in v350:GetPlayingAnimationTracks() do
        if v.Name == "独角兽行走异形骨骼" then
            v.Looped = true;

            return;
        end;
    end;
end;

u299 = function(p352) -- Line: 1312, Name: serverStopPauseWalkAnim
    -- upvalues: AnimationModule (copy)
    local v353 = p352.skillInputData and p352.skillInputData.character;
    local v354;

    if v353 then
        local v355 = v353:FindFirstChildOfClass("Humanoid");

        if v355 then
            v354 = v355:FindFirstChildOfClass("Animator");
        else
            v354 = nil;
        end;
    else
        v354 = nil;
    end;

    if v354 then
        AnimationModule.StopAnim(v354, "独角兽行走异形骨骼", 0.1);
    end;
end;

local function serverEnterPauseSegment(u356, p357) -- Line: 1321
    -- upvalues: SkillCommon (copy), commitSegmentMovePlan (copy), sampleSegmentMoveCF (copy), UtilsSystem (copy), serverPlayPauseWalkAnim (copy), RunService (copy)
    local u358 = u356.skillInputData and u356.skillInputData.character;

    if not u358 then
        return;
    end;

    local skillRunData = u356.skillRunData;
    local v359 = skillRunData and skillRunData.Logic and skillRunData.Logic.multThunderRoot;
    local v360 = skillRunData and skillRunData.Logic and skillRunData.Logic.multThunderSegmentMove;

    if not v359 or (not v360 or v360.segmentIndex ~= p357) then
        return;
    end;

    SkillCommon.disconnectRunEventKeys(u356.skillRunData, { "MultThunderTramplePauseFace" });
    local v361 = commitSegmentMovePlan(u356, v359, p357 + 1);

    if not v361 then
        local v362 = u356.skillInputData and u356.skillInputData.character;

        if not v362 then
            return;
        end;

        v362:PivotTo((sampleSegmentMoveCF(v360, v359, 1)));
        v359.lastSegmentEndGround = v360.endGroundPos;
        local endPos = v360.endPos;
        local SystemEnemy = UtilsSystem.SystemEnemy;
        local v363;

        if SystemEnemy and SystemEnemy.getPackByModel then
            v363 = SystemEnemy.getPackByModel(v362);
        else
            v363 = nil;
        end;

        if not v363 then
            local SystemSummon = UtilsSystem.SystemSummon;

            if SystemSummon and SystemSummon.getPackByModel then
                v363 = SystemSummon.getPackByModel(v362);
            end;
        end;

        if v363 then
            v363 = v363.entity;
        end;

        if not v363 then
            return;
        end;

        v363.pos = endPos;
        v363.lastPos = endPos;

        return;
    end;

    skillRunData.Logic["multThunderSegPlan" .. v361.segmentIndex] = v361;
    local v364 = sampleSegmentMoveCF(v360, v359, 1);
    local Position = v364.Position;
    local Rotation = v364.Rotation;
    local Rotation2 = sampleSegmentMoveCF(v361, v359, 0).Rotation;
    u358:PivotTo(v364);
    v359.lastSegmentEndGround = v360.endGroundPos;
    local SystemEnemy = UtilsSystem.SystemEnemy;
    local v365;

    if SystemEnemy and SystemEnemy.getPackByModel then
        v365 = SystemEnemy.getPackByModel(u358);
    else
        v365 = nil;
    end;

    if not v365 then
        local SystemSummon = UtilsSystem.SystemSummon;

        if SystemSummon and SystemSummon.getPackByModel then
            v365 = SystemSummon.getPackByModel(u358);
        end;
    end;

    if v365 then
        v365 = v365.entity;
    end;

    if v365 then
        v365.pos = Position;
        v365.lastPos = Position;
    end;

    serverPlayPauseWalkAnim(u356);

    if v359.faceMode == "AttackTarget" then
        return;
    end;

    local u366 = "Pause" .. p357;
    skillRunData.runEvent = skillRunData.runEvent or {};
    skillRunData.runEvent.MultThunderTramplePauseFace = RunService.Heartbeat:Connect(function() -- Line: 1363
        -- upvalues: u356 (copy), SkillCommon (ref), skillRunData (copy), u366 (copy), Rotation (copy), Rotation2 (copy), u358 (copy), Position (copy), UtilsSystem (ref)
        if not u356:isRunningFlow() then
            SkillCommon.disconnectRunEventKeys(u356.skillRunData, { "MultThunderTramplePauseFace" });

            return;
        end;

        if (skillRunData.State and skillRunData.State.current) ~= u366 then
            SkillCommon.disconnectRunEventKeys(u356.skillRunData, { "MultThunderTramplePauseFace" });

            return;
        end;

        local v367;

        if skillRunData.State then
            v367 = skillRunData.State.enteredAt;
        else
            v367 = u356.nowTime;
        end;

        local v368 = Rotation:Lerp(Rotation2, (math.clamp((u356.nowTime - v367) / 0.2, 0, 1)));
        u358:PivotTo(CFrame.new(Position) * v368);
        local v369 = u358;
        local v370 = Position;
        local SystemEnemy2 = UtilsSystem.SystemEnemy;
        local v371;

        if SystemEnemy2 and SystemEnemy2.getPackByModel then
            v371 = SystemEnemy2.getPackByModel(v369);
        else
            v371 = nil;
        end;

        if not v371 then
            local SystemSummon = UtilsSystem.SystemSummon;

            if SystemSummon and SystemSummon.getPackByModel then
                v371 = SystemSummon.getPackByModel(v369);
            end;
        end;

        if v371 then
            v371 = v371.entity;
        end;

        if not v371 then
            return;
        end;

        v371.pos = v370;
        v371.lastPos = v370;
    end);
end;

local function serverExitPauseSegment(p372, p373) -- Line: 1382
    -- upvalues: SkillCommon (copy), u299 (ref), sampleSegmentMoveCF (copy), UtilsSystem (copy)
    SkillCommon.disconnectRunEventKeys(p372.skillRunData, { "MultThunderTramplePauseFace" });
    u299(p372);
    local skillRunData = p372.skillRunData;
    local v374 = skillRunData and skillRunData.Logic and skillRunData.Logic.multThunderRoot;
    local v375 = skillRunData.Logic["multThunderSegPlan" .. p373 + 1];
    local v376 = p372.character or p372.skillInputData and p372.skillInputData.character;

    if v376 and (v374 and v375) then
        v376:PivotTo((sampleSegmentMoveCF(v375, v374, 0)));
        local startPos = v375.startPos;
        local SystemEnemy = UtilsSystem.SystemEnemy;
        local v377;

        if SystemEnemy and SystemEnemy.getPackByModel then
            v377 = SystemEnemy.getPackByModel(v376);
        else
            v377 = nil;
        end;

        if not v377 then
            local SystemSummon = UtilsSystem.SystemSummon;

            if SystemSummon and SystemSummon.getPackByModel then
                v377 = SystemSummon.getPackByModel(v376);
            end;
        end;

        if v377 then
            v377 = v377.entity;
        end;

        if not v377 then
            return;
        end;

        v377.pos = startPos;
        v377.lastPos = startPos;
    end;
end;

local function applyHumanoidPhysicsAfterUnanchor(p378, p379) -- Line: 1398
    if not p378.Parent then
        return;
    end;

    p378:ChangeState(Enum.HumanoidStateType.GettingUp);

    if p379 then
        p378.AutoRotate = p379.wasAutoRotate;
        p378.WalkSpeed = p379.prevWalkSpeed;

        return;
    end;

    p378.AutoRotate = true;

    if p378.WalkSpeed <= 0 then
        p378.WalkSpeed = 16;
    end;
end;

local function releaseSkillMoveAnchoring(p380, p381, p382, p383, p384) -- Line: 1414
    -- upvalues: resolveHrpAndHumanoid (copy), UtilsSystem (copy)
    if not (p381 or p382) then
        return;
    end;

    local v385 = p381 or p380.character or p380.skillInputData and p380.skillInputData.character;
    local v386, v387 = resolveHrpAndHumanoid(v385, p382);

    if not v386 then
        if v385 and v385.Parent then
            v385:SetAttribute("MultThunderTrampleMoveLock", nil);
            v385:SetAttribute("NPCUprightSnapDisabled", nil);
        end;

        return;
    end;

    if v385 and v385.Parent then
        local v388;

        if p383 then
            v388 = p383.endPos;
        elseif p384 then
            v388 = p384.finalEndPos;
        else
            v388 = v386.Position;
        end;

        v385:PivotTo(CFrame.new(v388) * v385:GetPivot().Rotation);
        local SystemEnemy = UtilsSystem.SystemEnemy;
        local v389;

        if SystemEnemy and SystemEnemy.getPackByModel then
            v389 = SystemEnemy.getPackByModel(v385);
        else
            v389 = nil;
        end;

        if not v389 then
            local SystemSummon = UtilsSystem.SystemSummon;

            if SystemSummon and SystemSummon.getPackByModel then
                v389 = SystemSummon.getPackByModel(v385);
            end;
        end;

        if v389 then
            v389 = v389.entity;
        end;

        if v389 then
            v389.pos = v388;
            v389.lastPos = v388;
        end;

        if v387 and v387.Parent then
            v387:MoveTo(v388);
        end;
    end;

    v386.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
    v386.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
    v386.Anchored = false;

    if v387 and v387.Parent then
        v387:ChangeState(Enum.HumanoidStateType.GettingUp);

        if p382 then
            v387.AutoRotate = p382.wasAutoRotate;
            v387.WalkSpeed = p382.prevWalkSpeed;
        else
            v387.AutoRotate = true;

            if v387.WalkSpeed <= 0 then
                v387.WalkSpeed = 16;
            end;
        end;
    end;

    if v385 and v385.Parent then
        v385:SetAttribute("MultThunderTrampleMoveLock", nil);
        v385:SetAttribute("NPCUprightSnapDisabled", nil);
    end;
end;

local function restoreCharacterMoveState(p390) -- Line: 1452
    -- upvalues: releaseSkillMoveAnchoring (copy)
    local v391 = p390.character or p390.skillInputData and p390.skillInputData.character;
    local skillRunData = p390.skillRunData;
    local v392 = nil;
    local v393 = nil;
    local v394 = nil;
    local v395;

    if v391 then
        v395 = v391:GetAttribute("MultThunderTrampleMoveLock") == true;
    else
        v395 = v391;
    end;

    if skillRunData and skillRunData.Logic then
        v392 = skillRunData.Logic.multThunderTrampleMoveLock;
        v393 = skillRunData.Logic.multThunderSegmentMove;
        v394 = skillRunData.Logic.multThunderRoot;
        v395 = v395 or (skillRunData.Logic.multThunderTrampleMoveLockApplied == true and true or v392 ~= nil);
        skillRunData.Logic.multThunderTrampleMoveLock = nil;
        skillRunData.Logic.multThunderTrampleMoveLockApplied = nil;
    end;

    if not v395 then
        return;
    end;

    releaseSkillMoveAnchoring(p390, v391, v392, v393, v394);
end;

function u2.onEndServer(p396) -- Line: 1475
    -- upvalues: SkillCommon (copy), AnimationModule (copy), restoreCharacterMoveState (copy)
    SkillCommon.disconnectRunEventKeys(p396.skillRunData, { "MultThunderTramplePauseFace" });
    SkillCommon.disconnectRunEventKeys(p396.skillRunData, { "MultThunderTrampleStartupFace" });
    SkillCommon.disconnectRunEventKeys(p396.skillRunData, { "MultThunderTrampleRecoveryFace" });
    local v397 = p396.character or p396.skillInputData and p396.skillInputData.character;
    local v398;

    if v397 then
        local v399 = v397:FindFirstChildOfClass("Humanoid");

        if v399 then
            v398 = v399:FindFirstChildOfClass("Animator");
        else
            v398 = nil;
        end;
    else
        v398 = nil;
    end;

    if v398 then
        AnimationModule.StopAnim(v398, "雷跃", 0.1);
        AnimationModule.StopAnim(v398, "独角兽行走异形骨骼", 0.1);
    end;

    for _, v in { 1, 2 } do
        local v400 = p396.hitbox[v];

        if v400 and v400.isActive then
            v400:stop();
        end;

        if v400 and v400.hitbox then
            local hitbox = v400.hitbox;

            if hitbox then
                hitbox.Transparency = 1;
            end;
        end;
    end;

    for i = 3, 10 do
        local v401 = p396.hitbox[i];

        if v401 and v401.isActive then
            v401:stop();
        end;

        if v401 and v401.hitbox then
            local hitbox = v401.hitbox;

            if hitbox then
                hitbox.Transparency = 1;
            end;
        end;
    end;

    restoreCharacterMoveState(p396);
end;

local function segmentMovementProgress(p402, p403) -- Line: 1502
    -- upvalues: ThunderLeapTiming (copy)
    return ThunderLeapTiming.sampleDisplacementU(p402.nowTime - p403.startedAt, p403.phases);
end;

local function applySegmentMovementSample(p404, p405, p406, p407) -- Line: 1507
    -- upvalues: sampleSegmentMoveCF (copy)
    local character = p404.skillInputData.character;

    if not character then
        return;
    end;

    character:PivotTo((sampleSegmentMoveCF(p405, p406, p407)));
end;

local function tryFinishMovementSegment(p408, p409, p410, p411, p412) -- Line: 1515
    -- upvalues: SkillCommon (copy), SkillEventConst (copy)
    if not SkillCommon.isRunningSameGeneration(p408, p411) then
        return;
    end;

    if p408.nowTime - p410.startedAt < p410.duration then
        return;
    end;

    local skillRunData = p408.skillRunData;

    if skillRunData.Logic and skillRunData.Logic[p412] then
        return;
    end;

    skillRunData.Logic = skillRunData.Logic or {};
    skillRunData.Logic[p412] = true;

    if p408.GetCurrentState and p408:GetCurrentState() == "Movement" .. p409 then
        p408:TryTransition(SkillEventConst.StateTimeout, nil);
    end;
end;

local function beginLeapAtPoint(u413, p414, p415, u416, p417) -- Line: 1539
    -- upvalues: SkillCommon (copy), pulseJumpStrikeHitboxAtGround (copy), scheduleJumpStrikeClient (copy), playJumpFootFx (copy)
    local points = p414.pathPlan.points;
    local Position = SkillCommon.getGroundCF(CFrame.new(points[p415]), 4, 0.15, "Ground").Position;
    local u418 = Vector3.new(Position.X, Position.Y + 0.1, Position.Z);
    local u419 = Vector3.new(25, 25, 25) * SkillCommon.npcSummonBodySkillScale(u413);
    local v420 = math.min(p415 + 1, #points);
    local v421 = Vector3.new(points[v420].X - points[p415].X, 0, points[v420].Z - points[p415].Z);
    local v422 = v421.Magnitude < 0.01 and Vector3.new(0, 0, -1) or v421.Unit;

    if p417 then
        local u423 = 2;
        task.delay(1.2, function() -- Line: 432
            -- upvalues: u413 (copy), u416 (copy), u423 (copy), pulseJumpStrikeHitboxAtGround (ref), u418 (copy), u419 (copy)
            if u416 ~= u413.runGeneration then
                return;
            end;

            local v424 = u413.hitbox[u423];

            if not v424 then
                return;
            end;

            pulseJumpStrikeHitboxAtGround(v424, u418, u419, 0.15, false);
        end);

        return;
    end;

    scheduleJumpStrikeClient(u413, u418, v422, u416, 0);
    playJumpFootFx(u413, u418, v422);
end;

local function ensurePathRoot(p425) -- Line: 1565
    -- upvalues: commitPathRoot (copy)
    local skillRunData = p425.skillRunData;
    skillRunData.Logic = skillRunData.Logic or {};
    local multThunderRoot = skillRunData.Logic.multThunderRoot;

    if multThunderRoot then
        return multThunderRoot;
    end;

    local v426 = commitPathRoot(p425);

    if v426 then
        skillRunData.Logic.multThunderRoot = v426;
    end;

    return v426;
end;

local function serverEnterMovementSegment(u427, u428) -- Line: 1579
    -- upvalues: commitPathRoot (copy), lockCharacterForSkillMove (copy), SkillCommon (copy), scheduleExtraPathStrikes (copy), commitSegmentMovePlan (copy), beginLeapAtPoint (copy), sampleSegmentMoveCF (copy), serverPlayLeapAnim (copy), RunService (copy), ThunderLeapTiming (copy), playLandFootFx (copy), scheduleLandingPlayerStrikesIfNeeded (copy), UtilsSystem (copy), tryFinishMovementSegment (copy)
    local v429 = u427.skillInputData and u427.skillInputData.character;

    if not v429 then
        return;
    end;

    local skillRunData = u427.skillRunData;
    skillRunData.Logic = skillRunData.Logic or {};
    local skillRunData2 = u427.skillRunData;
    skillRunData2.Logic = skillRunData2.Logic or {};
    local multThunderRoot = skillRunData2.Logic.multThunderRoot;

    if not multThunderRoot then
        multThunderRoot = commitPathRoot(u427);

        if multThunderRoot then
            skillRunData2.Logic.multThunderRoot = multThunderRoot;
        end;
    end;

    if not multThunderRoot then
        return;
    end;

    if u428 == 1 then
        if not skillRunData.Logic.multThunderTrampleMoveLock then
            local v430 = lockCharacterForSkillMove(v429);
            skillRunData.Logic.multThunderTrampleMoveLock = v430;

            if v430 and skillRunData then
                skillRunData.Logic = skillRunData.Logic or {};
                skillRunData.Logic.multThunderTrampleMoveLockApplied = true;
            end;
        end;

        local v431 = SkillCommon.npcSummonBodySkillScale(u427);
        local v432 = u427.hitbox[2];

        if v432 and v432.hitbox then
            v432.hitbox.Size = Vector3.new(25, 25, 25) * v431;
        end;

        scheduleExtraPathStrikes(u427, multThunderRoot.pathPlan, u427.runGeneration, true);
    end;

    SkillCommon.disconnectRunEventKeys(u427.skillRunData, { "MultThunderTramplePauseFace" });
    SkillCommon.disconnectRunEventKeys(u427.skillRunData, { "MultThunderTrampleStartupFace" });
    local v433 = skillRunData.Logic["multThunderSegPlan" .. u428] or skillRunData.Logic.multThunderSegmentMove;

    if not v433 or v433.segmentIndex ~= u428 then
        v433 = commitSegmentMovePlan(u427, multThunderRoot, u428);
    end;

    if not v433 then
        return;
    end;

    v433.startedAt = u427.nowTime;
    skillRunData.Logic.multThunderSegmentMove = v433;
    skillRunData.Logic["multThunderSegPlan" .. v433.segmentIndex] = v433;
    beginLeapAtPoint(u427, multThunderRoot, u428, u427.runGeneration, true);
    local HumanoidRootPart = v429:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart then
        local v434 = sampleSegmentMoveCF(v433, multThunderRoot, 0);
        local Position = v434.Position;
        local Position2 = HumanoidRootPart.Position;

        if (Vector3.new(Position2.X, 0, Position2.Z) - Vector3.new(Position.X, 0, Position.Z)).Magnitude <= 2 then
            if HumanoidRootPart.CFrame.LookVector:Dot(v434.LookVector) <= 0.95 then
                v429:PivotTo(CFrame.new(HumanoidRootPart.Position) * v434.Rotation);
            end;
        else
            local character = u427.skillInputData.character;

            if character then
                character:PivotTo((sampleSegmentMoveCF(v433, multThunderRoot, 0)));
            end;
        end;
    end;

    serverPlayLeapAnim(u427, v433.phases.animSpeed);
    local u435 = false;
    local u436 = false;
    local u437 = SkillCommon.npcSummonBodySkillScale(u427);
    local u438 = "multThunderSegDone" .. u428;
    skillRunData.Logic[u438] = nil;
    SkillCommon.disconnectRunEventKeys(u427.skillRunData, { "MultThunderTrampleMove" });
    skillRunData.runEvent = skillRunData.runEvent or {};
    skillRunData.runEvent.MultThunderTrampleMove = RunService.Heartbeat:Connect(function() -- Line: 1648
        -- upvalues: u427 (copy), skillRunData (copy), ThunderLeapTiming (ref), u428 (copy), playLandFootFx (ref), scheduleLandingPlayerStrikesIfNeeded (ref), sampleSegmentMoveCF (ref), UtilsSystem (ref), u436 (ref), u435 (ref), u437 (copy), tryFinishMovementSegment (ref), u438 (copy)
        if not u427:isRunningFlow() then
            return;
        end;

        local multThunderRoot2 = skillRunData.Logic.multThunderRoot;
        local multThunderSegmentMove = skillRunData.Logic.multThunderSegmentMove;

        if not multThunderRoot2 or (not multThunderSegmentMove or multThunderSegmentMove.startedAt <= 0) then
            return;
        end;

        local v439 = ThunderLeapTiming.sampleDisplacementU(u427.nowTime - multThunderSegmentMove.startedAt, multThunderSegmentMove.phases);

        if (skillRunData.State and skillRunData.State.current) ~= "Movement" .. u428 then
            if multThunderSegmentMove.segmentIndex == u428 and v439 >= 0.92 then
                local v440 = u427;
                local v441 = u428;
                local skillRunData3 = v440.skillRunData;

                if skillRunData3 and (skillRunData3.Logic and not skillRunData3.Logic["multThunderLandFxDone" .. v441]) then
                    skillRunData3.Logic["multThunderLandFxDone" .. v441] = true;
                    local v442 = Vector3.new(multThunderSegmentMove.endPos.X, multThunderSegmentMove.endGroundPos.Y, multThunderSegmentMove.endPos.Z);
                    local v443;

                    if multThunderRoot2 then
                        local v444 = Vector3.new(multThunderSegmentMove.endGroundPos.X - multThunderSegmentMove.startGroundPos.X, 0, multThunderSegmentMove.endGroundPos.Z - multThunderSegmentMove.startGroundPos.Z);
                        v443 = v444.Magnitude < 0.01 and Vector3.new(0, 0, -1) or v444.Unit;
                    else
                        v443 = nil;
                    end;

                    playLandFootFx(v440, v442, v443);
                end;

                scheduleLandingPlayerStrikesIfNeeded(v440, v441, multThunderSegmentMove, true);
            end;

            return;
        end;

        local character = u427.skillInputData.character;

        if character then
            character:PivotTo((sampleSegmentMoveCF(multThunderSegmentMove, multThunderRoot2, v439)));
        end;

        if v439 >= 1 then
            local v445 = u427;
            local v446 = v445.skillInputData and v445.skillInputData.character;

            if v446 then
                v446:PivotTo((sampleSegmentMoveCF(multThunderSegmentMove, multThunderRoot2, 1)));
                multThunderRoot2.lastSegmentEndGround = multThunderSegmentMove.endGroundPos;
                local endPos = multThunderSegmentMove.endPos;
                local SystemEnemy = UtilsSystem.SystemEnemy;
                local v447;

                if SystemEnemy and SystemEnemy.getPackByModel then
                    v447 = SystemEnemy.getPackByModel(v446);
                else
                    v447 = nil;
                end;

                if not v447 then
                    local SystemSummon = UtilsSystem.SystemSummon;

                    if SystemSummon and SystemSummon.getPackByModel then
                        v447 = SystemSummon.getPackByModel(v446);
                    end;
                end;

                if v447 then
                    v447 = v447.entity;
                end;

                if v447 then
                    v447.pos = endPos;
                    v447.lastPos = endPos;
                end;
            end;
        end;

        if not u436 and v439 >= 0.92 then
            u436 = true;
            local v448 = u427;
            local v449 = u428;
            local skillRunData3 = v448.skillRunData;

            if skillRunData3 and (skillRunData3.Logic and not skillRunData3.Logic["multThunderLandFxDone" .. v449]) then
                skillRunData3.Logic["multThunderLandFxDone" .. v449] = true;
                local v450 = Vector3.new(multThunderSegmentMove.endPos.X, multThunderSegmentMove.endGroundPos.Y, multThunderSegmentMove.endPos.Z);
                local v451;

                if multThunderRoot2 then
                    local v452 = Vector3.new(multThunderSegmentMove.endGroundPos.X - multThunderSegmentMove.startGroundPos.X, 0, multThunderSegmentMove.endGroundPos.Z - multThunderSegmentMove.startGroundPos.Z);
                    v451 = v452.Magnitude < 0.01 and Vector3.new(0, 0, -1) or v452.Unit;
                else
                    v451 = nil;
                end;

                playLandFootFx(v448, v450, v451);
            end;

            scheduleLandingPlayerStrikesIfNeeded(v448, v449, multThunderSegmentMove, true);
        end;

        if not u435 and v439 >= 0.92 then
            u435 = true;
            local v453 = u427.hitbox[1];

            if v453 and v453.hitbox then
                v453.hitbox.Size = Vector3.new(25, 25, 25) * u437;
                v453.hitbox:PivotTo(CFrame.new(multThunderSegmentMove.endPos));
                local hitbox = v453.hitbox;

                if hitbox then
                    hitbox.Transparency = 1;
                end;

                v453:start();
            end;
        end;

        tryFinishMovementSegment(u427, u428, multThunderSegmentMove, u427.runGeneration, u438);
    end);
end;

local function serverExitMovementSegment(p454, p455) -- Line: 1696
    -- upvalues: SkillCommon (copy), sampleSegmentMoveCF (copy), UtilsSystem (copy), playLandFootFx (copy), scheduleLandingPlayerStrikesIfNeeded (copy), AnimationModule (copy)
    SkillCommon.disconnectRunEventKeys(p454.skillRunData, { "MultThunderTrampleMove" });
    local v456 = p454.hitbox[1];

    if v456 and v456.isActive then
        v456:stop();
    end;

    local v457 = v456 and v456.hitbox and v456.hitbox;

    if v457 then
        v457.Transparency = 1;
    end;

    local skillRunData = p454.skillRunData;
    local v458 = skillRunData and skillRunData.Logic and skillRunData.Logic.multThunderRoot;
    local v459 = skillRunData.Logic["multThunderSegPlan" .. p455] or skillRunData and skillRunData.Logic and skillRunData.Logic.multThunderSegmentMove;

    if v458 and v459 then
        local v460 = p454.skillInputData and p454.skillInputData.character;

        if v460 then
            v460:PivotTo((sampleSegmentMoveCF(v459, v458, 1)));
            v458.lastSegmentEndGround = v459.endGroundPos;
            local endPos = v459.endPos;
            local SystemEnemy = UtilsSystem.SystemEnemy;
            local v461;

            if SystemEnemy and SystemEnemy.getPackByModel then
                v461 = SystemEnemy.getPackByModel(v460);
            else
                v461 = nil;
            end;

            if not v461 then
                local SystemSummon = UtilsSystem.SystemSummon;

                if SystemSummon and SystemSummon.getPackByModel then
                    v461 = SystemSummon.getPackByModel(v460);
                end;
            end;

            if v461 then
                v461 = v461.entity;
            end;

            if v461 then
                v461.pos = endPos;
                v461.lastPos = endPos;
            end;
        end;

        local skillRunData2 = p454.skillRunData;

        if skillRunData2 and (skillRunData2.Logic and not skillRunData2.Logic["multThunderLandFxDone" .. p455]) then
            skillRunData2.Logic["multThunderLandFxDone" .. p455] = true;
            local v462 = Vector3.new(v459.endPos.X, v459.endGroundPos.Y, v459.endPos.Z);
            local v463;

            if v458 then
                local v464 = Vector3.new(v459.endGroundPos.X - v459.startGroundPos.X, 0, v459.endGroundPos.Z - v459.startGroundPos.Z);
                v463 = v464.Magnitude < 0.01 and Vector3.new(0, 0, -1) or v464.Unit;
            else
                v463 = nil;
            end;

            playLandFootFx(p454, v462, v463);
        end;

        scheduleLandingPlayerStrikesIfNeeded(p454, p455, v459, true);
    end;

    local v465 = p454.skillInputData and p454.skillInputData.character;
    local v466;

    if v465 then
        local v467 = v465:FindFirstChildOfClass("Humanoid");

        if v467 then
            v466 = v467:FindFirstChildOfClass("Animator");
        else
            v466 = nil;
        end;
    else
        v466 = nil;
    end;

    if v466 then
        AnimationModule.StopAnim(v466, "雷跃", 0.1);
    end;
end;

local function clientEnterMovementSegment(u468, u469) -- Line: 1716
    -- upvalues: SkillCommon (copy), commitPathRoot (copy), scheduleExtraPathStrikes (copy), commitSegmentMovePlan (copy), beginLeapAtPoint (copy), RunService (copy), ThunderLeapTiming (copy), playSegmentLandFootFxIfNeeded (copy), scheduleLandingPlayerStrikesIfNeeded (copy), tryFinishMovementSegment (copy)
    local v470 = u468.skillInputData and u468.skillInputData.character;

    if not v470 then
        return;
    end;

    SkillCommon.playSoundLocal3D("音效-技能-雷系普攻", v470:GetPivot().Position);
    local skillRunData = u468.skillRunData;
    skillRunData.Logic = skillRunData.Logic or {};
    local skillRunData2 = u468.skillRunData;
    skillRunData2.Logic = skillRunData2.Logic or {};
    local multThunderRoot = skillRunData2.Logic.multThunderRoot;

    if not multThunderRoot then
        multThunderRoot = commitPathRoot(u468);

        if multThunderRoot then
            skillRunData2.Logic.multThunderRoot = multThunderRoot;
        end;
    end;

    if not multThunderRoot then
        return;
    end;

    if u469 == 1 then
        scheduleExtraPathStrikes(u468, multThunderRoot.pathPlan, u468.runGeneration, false);
    end;

    local v471 = skillRunData.Logic["multThunderSegPlan" .. u469];

    if u469 ~= 1 or (not v471 or v471.segmentIndex ~= 1) then
        v471 = commitSegmentMovePlan(u468, multThunderRoot, u469);
    end;

    if not v471 then
        return;
    end;

    v471.startedAt = u468.nowTime;
    skillRunData.Logic.multThunderSegmentMove = v471;
    skillRunData.Logic["multThunderSegPlan" .. v471.segmentIndex] = v471;
    beginLeapAtPoint(u468, multThunderRoot, u469, u468.runGeneration, false);
    local u472 = false;
    local u473 = "multThunderSegDone" .. u469;
    skillRunData.Logic[u473] = nil;
    SkillCommon.disconnectRunEventKeys(u468.skillRunData, { "MultThunderTrampleMove" });
    skillRunData.runEvent = skillRunData.runEvent or {};
    skillRunData.runEvent.MultThunderTrampleMove = RunService.Heartbeat:Connect(function() -- Line: 1756
        -- upvalues: u468 (copy), skillRunData (copy), ThunderLeapTiming (ref), u469 (copy), playSegmentLandFootFxIfNeeded (ref), scheduleLandingPlayerStrikesIfNeeded (ref), u472 (ref), tryFinishMovementSegment (ref), u473 (copy)
        if not u468:isRunningFlow() then
            return;
        end;

        local multThunderRoot2 = skillRunData.Logic.multThunderRoot;
        local multThunderSegmentMove = skillRunData.Logic.multThunderSegmentMove;

        if not multThunderSegmentMove or multThunderSegmentMove.startedAt <= 0 then
            return;
        end;

        local v474 = ThunderLeapTiming.sampleDisplacementU(u468.nowTime - multThunderSegmentMove.startedAt, multThunderSegmentMove.phases);

        if (skillRunData.State and skillRunData.State.current) ~= "Movement" .. u469 then
            if multThunderSegmentMove.segmentIndex == u469 and v474 >= 0.92 then
                local v475 = u468;
                local v476 = u469;
                playSegmentLandFootFxIfNeeded(v475, v476, multThunderSegmentMove, multThunderRoot2, false);
                scheduleLandingPlayerStrikesIfNeeded(v475, v476, multThunderSegmentMove, false);
            end;

            return;
        end;

        if not u472 and v474 >= 0.92 then
            u472 = true;
            local v477 = u468;
            local v478 = u469;
            playSegmentLandFootFxIfNeeded(v477, v478, multThunderSegmentMove, multThunderRoot2, false);
            scheduleLandingPlayerStrikesIfNeeded(v477, v478, multThunderSegmentMove, false);
        end;

        tryFinishMovementSegment(u468, u469, multThunderSegmentMove, u468.runGeneration, u473);
    end);
end;

local function clientExitMovementSegment(p479, p480) -- Line: 1781
    -- upvalues: playSegmentLandFootFxIfNeeded (copy), scheduleLandingPlayerStrikesIfNeeded (copy), SkillCommon (copy)
    local skillRunData = p479.skillRunData;
    local v481 = skillRunData and skillRunData.Logic and skillRunData.Logic.multThunderRoot;
    local v482 = skillRunData.Logic["multThunderSegPlan" .. p480] or skillRunData and skillRunData.Logic and skillRunData.Logic.multThunderSegmentMove;

    if v482 and v481 then
        playSegmentLandFootFxIfNeeded(p479, p480, v482, v481, false);
        scheduleLandingPlayerStrikesIfNeeded(p479, p480, v482, false);
    end;

    SkillCommon.disconnectRunEventKeys(p479.skillRunData, { "MultThunderTrampleMove" });
end;

function u2.Client_EnterStartup(p483) -- Line: 1791
    -- upvalues: commitPathRoot (copy)
    local skillRunData = p483.skillRunData;
    skillRunData.Logic = skillRunData.Logic or {};
    local v484 = commitPathRoot(p483);

    if v484 then
        skillRunData.Logic.multThunderRoot = v484;
    end;
end;

function u2.Client_ExitStartup(p485) -- Line: 1800
end;

function u2.Server_EnterStartup(p486) -- Line: 1803
    -- upvalues: commitPathRoot (copy), MultThunderTramplePath (copy), lockCharacterForSkillMove (copy), commitSegmentMovePlan (copy), sampleSegmentMoveCF (copy), UtilsSystem (copy), serverStartSmoothFaceRotation (copy)
    local v487 = p486.skillInputData and p486.skillInputData.character;

    if not v487 then
        return;
    end;

    local skillRunData = p486.skillRunData;
    skillRunData.Logic = skillRunData.Logic or {};
    local v488 = commitPathRoot(p486);

    if not v488 then
        return;
    end;

    skillRunData.Logic.multThunderRoot = v488;
    local skillInputData = p486.skillInputData;

    if skillInputData then
        skillInputData.multThunderPathPoints = MultThunderTramplePath.copyPathPoints(v488.pathPlan.points);
        skillInputData.multThunderSpawnGround = v488.spawnGround;
        skillInputData._multThunderPathFrozen = true;
    end;

    if not skillRunData.Logic.multThunderTrampleMoveLock then
        local v489 = lockCharacterForSkillMove(v487);
        skillRunData.Logic.multThunderTrampleMoveLock = v489;

        if v489 and skillRunData then
            skillRunData.Logic = skillRunData.Logic or {};
            skillRunData.Logic.multThunderTrampleMoveLockApplied = true;
        end;
    end;

    local v490 = commitSegmentMovePlan(p486, v488, 1);

    if v490 then
        skillRunData.Logic.multThunderSegmentMove = v490;
        skillRunData.Logic["multThunderSegPlan" .. v490.segmentIndex] = v490;
        local v491 = sampleSegmentMoveCF(v490, v488, 0);
        local Position = v491.Position;
        local Rotation = v487:GetPivot().Rotation;
        local Rotation2 = v491.Rotation;
        v487:PivotTo(CFrame.new(Position) * Rotation);
        local SystemEnemy = UtilsSystem.SystemEnemy;
        local v492;

        if SystemEnemy and SystemEnemy.getPackByModel then
            v492 = SystemEnemy.getPackByModel(v487);
        else
            v492 = nil;
        end;

        if not v492 then
            local SystemSummon = UtilsSystem.SystemSummon;

            if SystemSummon and SystemSummon.getPackByModel then
                v492 = SystemSummon.getPackByModel(v487);
            end;
        end;

        if v492 then
            v492 = v492.entity;
        end;

        if v492 then
            v492.pos = Position;
            v492.lastPos = Position;
        end;

        serverStartSmoothFaceRotation(p486, "MultThunderTrampleStartupFace", "Startup", 0.5, Position, Rotation, Rotation2);
    end;

    local v493 = p486.hitbox[2];

    if v493 and v493.hitbox then
        local hitbox = v493.hitbox;

        if not hitbox then
            return;
        end;

        hitbox.Transparency = 1;
    end;
end;

function u2.Client_EnterMovement1(p494) -- Line: 1852
    -- upvalues: clientEnterMovementSegment (copy)
    clientEnterMovementSegment(p494, 1);
end;

function u2.Client_ExitMovement1(p495) -- Line: 1856
    -- upvalues: clientExitMovementSegment (copy)
    clientExitMovementSegment(p495, 1);
end;

function u2.Server_EnterMovement1(p496) -- Line: 1860
    -- upvalues: serverEnterMovementSegment (copy)
    serverEnterMovementSegment(p496, 1);
end;

function u2.Server_ExitMovement1(p497) -- Line: 1864
    -- upvalues: serverExitMovementSegment (copy)
    serverExitMovementSegment(p497, 1);
end;

function u2.Client_EnterPause1(p498) -- Line: 1868
end;

function u2.Client_ExitPause1(p499) -- Line: 1871
end;

function u2.Server_EnterPause1(p500) -- Line: 1874
    -- upvalues: serverEnterPauseSegment (copy)
    serverEnterPauseSegment(p500, 1);
end;

function u2.Server_ExitPause1(p501) -- Line: 1878
    -- upvalues: serverExitPauseSegment (copy)
    serverExitPauseSegment(p501, 1);
end;

function u2.Client_EnterMovement2(p502) -- Line: 1882
    -- upvalues: clientEnterMovementSegment (copy)
    clientEnterMovementSegment(p502, 2);
end;

function u2.Client_ExitMovement2(p503) -- Line: 1886
    -- upvalues: clientExitMovementSegment (copy)
    clientExitMovementSegment(p503, 2);
end;

function u2.Server_EnterMovement2(p504) -- Line: 1890
    -- upvalues: serverEnterMovementSegment (copy)
    serverEnterMovementSegment(p504, 2);
end;

function u2.Server_ExitMovement2(p505) -- Line: 1894
    -- upvalues: serverExitMovementSegment (copy)
    serverExitMovementSegment(p505, 2);
end;

function u2.Client_EnterPause2(p506) -- Line: 1898
end;

function u2.Client_ExitPause2(p507) -- Line: 1901
end;

function u2.Server_EnterPause2(p508) -- Line: 1904
    -- upvalues: serverEnterPauseSegment (copy)
    serverEnterPauseSegment(p508, 2);
end;

function u2.Server_ExitPause2(p509) -- Line: 1908
    -- upvalues: serverExitPauseSegment (copy)
    serverExitPauseSegment(p509, 2);
end;

function u2.Client_EnterMovement3(p510) -- Line: 1912
    -- upvalues: clientEnterMovementSegment (copy)
    clientEnterMovementSegment(p510, 3);
end;

function u2.Client_ExitMovement3(p511) -- Line: 1916
    -- upvalues: clientExitMovementSegment (copy)
    clientExitMovementSegment(p511, 3);
end;

function u2.Server_EnterMovement3(p512) -- Line: 1920
    -- upvalues: serverEnterMovementSegment (copy)
    serverEnterMovementSegment(p512, 3);
end;

function u2.Server_ExitMovement3(p513) -- Line: 1924
    -- upvalues: serverExitMovementSegment (copy)
    serverExitMovementSegment(p513, 3);
end;

function u2.Server_EnterRecovery(p514) -- Line: 1928
    -- upvalues: AnimationModule (copy), SkillCommon (copy), sampleSegmentMoveCF (copy), UtilsSystem (copy), serverPlayPauseWalkAnim (copy), serverStartRecoveryFaceRotation (copy), u1 (copy)
    local v515 = p514.skillInputData and p514.skillInputData.character;
    local v516;

    if v515 then
        local v517 = v515:FindFirstChildOfClass("Humanoid");

        if v517 then
            v516 = v517:FindFirstChildOfClass("Animator");
        else
            v516 = nil;
        end;
    else
        v516 = nil;
    end;

    if v516 then
        AnimationModule.StopAnim(v516, "雷跃", 0.1);
    end;

    SkillCommon.disconnectRunEventKeys(p514.skillRunData, { "MultThunderTrampleMove" });
    SkillCommon.disconnectRunEventKeys(p514.skillRunData, { "MultThunderTramplePauseFace" });
    local v518 = p514.character or p514.skillInputData and p514.skillInputData.character;
    local skillRunData = p514.skillRunData;
    local v519 = skillRunData and skillRunData.Logic and skillRunData.Logic.multThunderRoot;
    local v520 = skillRunData and skillRunData.Logic and skillRunData.Logic.multThunderSegmentMove;

    if not (v518 and (v519 and v520)) then
        return;
    end;

    local v521 = sampleSegmentMoveCF(v520, v519, 1);
    local Position = v521.Position;
    v518:PivotTo(CFrame.new(Position) * v521.Rotation);
    v519.lastSegmentEndGround = v520.endGroundPos;
    local SystemEnemy = UtilsSystem.SystemEnemy;
    local v522;

    if SystemEnemy and SystemEnemy.getPackByModel then
        v522 = SystemEnemy.getPackByModel(v518);
    else
        v522 = nil;
    end;

    if not v522 then
        local SystemSummon = UtilsSystem.SystemSummon;

        if SystemSummon and SystemSummon.getPackByModel then
            v522 = SystemSummon.getPackByModel(v518);
        end;
    end;

    if v522 then
        v522 = v522.entity;
    end;

    if v522 then
        v522.pos = Position;
        v522.lastPos = Position;
    end;

    serverPlayPauseWalkAnim(p514);
    serverStartRecoveryFaceRotation(p514, v519, v520, Position, u1);
end;

function u2.Server_ExitRecovery(p523) -- Line: 1950
    -- upvalues: SkillCommon (copy), u299 (ref), restoreCharacterMoveState (copy)
    SkillCommon.disconnectRunEventKeys(p523.skillRunData, { "MultThunderTrampleRecoveryFace" });
    u299(p523);
    restoreCharacterMoveState(p523);
end;

function u2.Client_EnterRecovery(p524) -- Line: 1956
    -- upvalues: SkillCommon (copy)
    SkillCommon.disconnectRunEventKeys(p524.skillRunData, { "MultThunderTrampleMove" });
end;

function u2.onEnd(p525) -- Line: 1960
    -- upvalues: SkillCommon (copy)
    local skillRunData = p525.skillRunData;

    if skillRunData then
        SkillCommon.clearRunSpawnList(skillRunData, "MultThunderTrampleSpawned");
    end;
end;

u2.SoundList = { "音效-技能-雷系普攻", "音效-技能-独角兽-跳跃落地", "音效-技能-独角兽-预警", "音效-技能-独角兽-打雷1", "音效-技能-独角兽-打雷2", "音效-技能-独角兽-打雷3", "音效-技能-独角兽-打雷4", "音效-技能-独角兽-打雷5", "音效-技能-独角兽-打雷6", "音效-技能-独角兽-打雷7", "音效-技能-独角兽-打雷8", "音效-技能-独角兽-打雷9" };
u2.AnimateList = { "雷跃", "独角兽行走异形骨骼" };
u2.ResNameList = { "雷跃起跳-暗", "雷跃落地-暗", "独角兽落雷地面特效-暗", "独角兽落雷-暗", "独角兽落雷预警-暗" };
u2.hitboxConfig = {};

for i = 1, 10 do
    u2.hitboxConfig[i] = {
        PartName = "通用球",
        CollisionGroup = "Player",
        HitPresentationProfile = "通用受击",
        PhysicsEffectName = "通用受击物理效果",
        HitboxIndex = i
    };
end;

u2.Action = {};

function u2.estimateSkillTotalDuration(p526) -- Line: 2008
    -- upvalues: ThunderLeapTiming (copy), LEAP_STANDARD_TOTAL (copy), u1 (copy)
    local v527 = 0;

    if p526 and (p526.points and #p526.points >= 4) then
        local points = p526.points;

        for i = 1, 3 do
            local v528 = points[i];
            local v529 = points[i + 1];
            v527 = v527 + ThunderLeapTiming.computeFromHorizDist((Vector3.new(v528.X, 0, v528.Z) - Vector3.new(v529.X, 0, v529.Z)).Magnitude).total;
        end;
    else
        v527 = LEAP_STANDARD_TOTAL * 3;
    end;

    return v527 + 0.5 + 0.4 + u1;
end;

return u2;