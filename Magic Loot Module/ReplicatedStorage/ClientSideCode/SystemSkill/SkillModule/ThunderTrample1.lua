-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local EntityUtil = require(script.Parent.Parent.BaseSkill.EntityUtil);
local HitQueryContext = require(script.Parent.Parent.BaseSkill.HitQueryContext);
local ThunderLeapTiming = require(script.Parent.Parent.Tool.ThunderLeapTiming);
local FXUtil = UtilsSystem.FXUtil;
local VisibleMgr = UtilsSystem.VisibleMgr;
local RunService = UtilsSystem.RunService;
local TweenService = UtilsSystem.TweenService;
local AnimationModule = UtilsSystem.AnimationModule;
local LEAP_PHASE_MOVE = ThunderLeapTiming.LEAP_PHASE_MOVE;
local MIN_FEASIBLE_MOVE_HORIZ = ThunderLeapTiming.MIN_FEASIBLE_MOVE_HORIZ;

local function makeBallHitboxEntry(p1) -- Line: 45
    return {
        PartName = "通用球",
        CollisionGroup = "Player",
        HitPresentationProfile = "通用受击",
        PhysicsEffectName = "通用受击物理效果",
        HitboxIndex = p1
    };
end;

local function recoveryDurationAfterMovement(p2) -- Line: 55
    local duration = p2.duration;
    local v3 = math.max(1.2, duration * 0.92 + 1.2) - duration + 0.15 + 0.05;

    return p2.phases.recovery + math.max(0, v3);
end;

local u4 = ThunderLeapTiming.maxLeapTotalDuration();
local u5 = {
    skillTotalTime = -1,
    visualFadeoutTime = u4 + 0.5,
    skillElementType = ElementTp.Thunder,
    skillDistanceLimit = 64,
    animationPlaySide = "Server"
};
local Quad = Enum.EasingStyle.Quad;
local Out = Enum.EasingDirection.Out;
local u6 = { "音效-技能-独角兽-打雷1", "音效-技能-独角兽-打雷2", "音效-技能-独角兽-打雷3", "音效-技能-独角兽-打雷4", "音效-技能-独角兽-打雷5", "音效-技能-独角兽-打雷6", "音效-技能-独角兽-打雷7", "音效-技能-独角兽-打雷8", "音效-技能-独角兽-打雷9" };
local _ = Enum.AnimationPriority.Action4;
local Movement = Enum.AnimationPriority.Movement;
u5.MoveFaceMode = {
    MoveTarget = "MoveTarget",
    AttackTarget = "AttackTarget"
};
u5.InitialState = "Startup";
u5.ControlOpenState = "Recovery";
u5.States = {
    Startup = {
        Duration = -1,
        OnEnterClient = "Client_EnterStartup",
        OnEnterServer = "Server_EnterStartup",
        OnExitClient = "Client_ExitStartup",
        OnExitServer = "Server_ExitStartup"
    },
    Movement = {
        Duration = -1,
        OnEnterClient = "Client_EnterMovement",
        OnEnterServer = "Server_EnterMovement",
        OnExitClient = "Client_ExitMovement",
        OnExitServer = "Server_ExitMovement"
    },
    Recovery = {
        Duration = -1,
        OnEnterClient = "Client_EnterRecovery",
        OnEnterServer = "Server_EnterRecovery",
        OnExitClient = nil,
        OnExitServer = "Server_ExitRecovery"
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
u5.Transitions = {
    {
        From = "Startup",
        To = "Movement",
        Event = SkillEventConst.StateTimeout
    },
    {
        From = "Movement",
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
        From = "Movement",
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
        From = "Movement",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    },
    {
        From = "Recovery",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    }
};

local function applyHitboxVisibility(p7, p8) -- Line: 206
    if not p7 then
        return;
    end;

    p7.Transparency = 1;
end;

local function snapGroundPos(p9) -- Line: 217
    -- upvalues: SkillCommon (copy)
    return SkillCommon.getGroundCF(CFrame.new(p9), 4, 0.15, "Ground").Position;
end;

local function withLandingYOffset(p10) -- Line: 221
    return Vector3.new(p10.X, p10.Y + 0.1, p10.Z);
end;

local function snapLandingGroundPos(p11) -- Line: 225
    -- upvalues: SkillCommon (copy)
    local Position = SkillCommon.getGroundCF(CFrame.new(p11), 4, 0.15, "Ground").Position;

    return Vector3.new(Position.X, Position.Y + 0.1, Position.Z);
end;

local function flatDistance(p12, p13) -- Line: 229
    return (Vector3.new(p12.X, 0, p12.Z) - Vector3.new(p13.X, 0, p13.Z)).Magnitude;
end;

local function getFlatLookHint(p14) -- Line: 235
    local HumanoidRootPart = p14:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart then
        local v15 = Vector3.new(HumanoidRootPart.CFrame.LookVector.X, 0, HumanoidRootPart.CFrame.LookVector.Z);

        if v15.Magnitude > 0.05 then
            return v15.Unit;
        end;
    end;

    return Vector3.new(0, 0, -1);
end;

local function strikeFlatHint(p16, p17) -- Line: 246
    local v18 = p17 - p16.Position;
    local v19 = Vector3.new(v18.X, 0, v18.Z);

    if v19.Magnitude > 0.05 then
        return v19.Unit;
    end;

    local HumanoidRootPart = p16.Parent:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart then
        local v20 = Vector3.new(HumanoidRootPart.CFrame.LookVector.X, 0, HumanoidRootPart.CFrame.LookVector.Z);

        if v20.Magnitude > 0.05 then
            return v20.Unit;
        end;
    end;

    return Vector3.new(0, 0, -1);
end;

local function resolveStrikeGroundAlignedCF(p21, p22) -- Line: 255
    -- upvalues: FXUtil (copy)
    return FXUtil.GetGroundAlignedCF(p21, p22, "Ground", 4, 0.15) or CFrame.new(p21 + Vector3.new(0, 0.15, 0));
end;

local function cloneEmitFx(p23, p24, p25, p26) -- Line: 263
    -- upvalues: VisibleMgr (copy), SkillCommon (copy), FXUtil (copy)
    local v27 = p23:Clone();

    if v27:IsA("Model") then
        v27:ScaleTo(p25);
    end;

    VisibleMgr.UnQueryAll(v27);
    v27:PivotTo(p24);
    v27.Parent = workspace.Debris;
    SkillCommon.appendRunSpawnList(p26, "ThunderTrampleSpawned", v27);
    FXUtil.Emit_Particles_GetDescendants(v27, true);
end;

local function emitJumpStrikeWarningAt(p28, p29, p30, p31) -- Line: 275
    -- upvalues: cloneEmitFx (copy), SkillCommon (copy)
    cloneEmitFx(p28, CFrame.new(p29), p30, p31);
    SkillCommon.playSoundLocal3D("音效-技能-独角兽-预警", p29);
end;

local function emitJumpStrikeAt(p32, p33, p34, p35, p36, p37) -- Line: 280
    -- upvalues: cloneEmitFx (copy), FXUtil (copy), SkillCommon (copy), u6 (copy)
    cloneEmitFx(p32, CFrame.new(p34), p36, p37);
    cloneEmitFx(p33, FXUtil.GetGroundAlignedCF(p34, p35, "Ground", 4, 0.15) or CFrame.new(p34 + Vector3.new(0, 0.15, 0)), p36, p37);
    local v38 = SkillCommon.pickRandomSoundName(u6);

    if v38 then
        SkillCommon.playSoundLocal3D(v38, p34);
    end;
end;

local function pulseJumpStrikeHitboxAtGround(u39, p40, p41, p42, p43) -- Line: 296
    if not (u39 and u39.hitbox) then
        return;
    end;

    local hitbox = u39.hitbox;
    hitbox.Size = p41;
    hitbox:PivotTo(CFrame.new(p40));
    local _ = p43 == true;

    if hitbox then
        hitbox.Transparency = 1;
    end;

    u39:start();
    task.delay(p42 or 0.15, function() -- Line: 312
        -- upvalues: u39 (copy), hitbox (copy)
        if u39.isActive then
            u39:stop();
        end;

        local v44 = hitbox;

        if not v44 then
            return;
        end;

        v44.Transparency = 1;
    end);
end;

local function stillActiveForJumpStrike(p45, p46) -- Line: 320
    -- upvalues: SkillCommon (copy)
    if not SkillCommon.isRunningSameGeneration(p45, p46) then
        return false;
    end;

    local v47 = p45.GetCurrentState and p45:GetCurrentState();

    return v47 == "Movement" and true or v47 == "Recovery";
end;

local function stillActiveForScheduledStrike(p48, p49) -- Line: 329
    return p48.runGeneration == p49;
end;

local function scheduleLandingPlayerStrikeClient(u50, u51, u52, u53) -- Line: 333
    -- upvalues: SkillCommon (copy), cloneEmitFx (copy), emitJumpStrikeAt (copy)
    local skillRunData = u50.skillRunData;
    local v54;

    if skillRunData then
        v54 = skillRunData.material;
    else
        v54 = skillRunData;
    end;

    if not (skillRunData and v54) then
        return;
    end;

    local u55 = v54["独角兽落雷预警"];
    local u56 = v54["独角兽落雷"];
    local u57 = v54["独角兽落雷地面特效"];

    if not (u55 and (u56 and u57)) then
        return;
    end;

    local u58 = SkillCommon.npcSummonBodySkillScale(u50);
    task.delay(0, function() -- Line: 351
        -- upvalues: u50 (copy), u53 (copy), u55 (copy), u51 (copy), u58 (copy), skillRunData (copy), cloneEmitFx (ref), SkillCommon (ref)
        if u53 ~= u50.runGeneration then
            return;
        end;

        local v59 = u51;
        cloneEmitFx(u55, CFrame.new(v59), u58, skillRunData);
        SkillCommon.playSoundLocal3D("音效-技能-独角兽-预警", v59);
    end);
    task.delay(1.2, function() -- Line: 357
        -- upvalues: u50 (copy), u53 (copy), emitJumpStrikeAt (ref), u56 (copy), u57 (copy), u51 (copy), u52 (copy), u58 (copy), skillRunData (copy)
        if u53 ~= u50.runGeneration then
            return;
        end;

        emitJumpStrikeAt(u56, u57, u51, u52, u58, skillRunData);
    end);
end;

local function scheduleLandingPlayerStrikeServer(u60, u61, u62, u63, u64) -- Line: 365
    -- upvalues: pulseJumpStrikeHitboxAtGround (copy)
    task.delay(1.2, function() -- Line: 372
        -- upvalues: u60 (copy), u62 (copy), u64 (copy), pulseJumpStrikeHitboxAtGround (ref), u61 (copy), u63 (copy)
        if u62 ~= u60.runGeneration then
            return;
        end;

        local v65 = u60.hitbox[u64];

        if not v65 then
            return;
        end;

        pulseJumpStrikeHitboxAtGround(v65, u61, u63, 0.15, false);
    end);
end;

local function isLandingPlayerStrikeTarget(p66, p67, p68) -- Line: 384
    -- upvalues: EntityUtil (copy), HitQueryContext (copy)
    if p68 == p67 then
        return false;
    end;

    local v69 = p68:FindFirstChildOfClass("Humanoid");
    local HumanoidRootPart = p68:FindFirstChild("HumanoidRootPart");

    if not v69 or (not HumanoidRootPart or (not HumanoidRootPart:IsA("BasePart") or v69.Health <= 0)) then
        return false;
    end;

    local _, v70 = EntityUtil.getEntityIdentity(p68);

    if v70 ~= "Player" then
        return false;
    end;

    local v71 = p66.hitbox[1];

    if not v71 then
        return not EntityUtil.isFriendly({
            id = p66.characterId,
            type = p66.characterType
        }, p68);
    end;

    local v72 = HitQueryContext.create(v71, p68, 0);

    return HitQueryContext.isDetectableTarget(v72);
end;

local function gatherNearbyPlayerLandingStrikePositions(p73, p74, p75) -- Line: 409
    -- upvalues: Players (copy), isLandingPlayerStrikeTarget (copy), SkillCommon (copy)
    local v76 = {};

    for _, v in Players:GetPlayers() do
        local Character = v.Character;

        if Character and isLandingPlayerStrikeTarget(p73, p75, Character) then
            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

            if HumanoidRootPart then
                local Position = HumanoidRootPart.Position;
                local Magnitude = (Vector3.new(p74.X, 0, p74.Z) - Vector3.new(Position.X, 0, Position.Z)).Magnitude;

                if Magnitude <= 200 then
                    local v77 = {
                        dist = Magnitude
                    };
                    local Position2 = SkillCommon.getGroundCF(CFrame.new(HumanoidRootPart.Position), 4, 0.15, "Ground").Position;
                    v77.pos = Vector3.new(Position2.X, Position2.Y + 0.1, Position2.Z);
                    table.insert(v76, v77);
                end;
            end;
        end;
    end;

    table.sort(v76, function(p78, p79) -- Line: 430
        if p78.dist == p79.dist then
            return p78.pos.X < p79.pos.X;
        end;

        return p78.dist < p79.dist;
    end);
    local v80 = {};

    for i = 1, math.min(8, #v76) do
        v80[i] = v76[i].pos;
    end;

    return v80;
end;

local function strikeFlatHintFromCenter(p81, p82) -- Line: 443
    local v83 = p82 - p81;
    local v84 = Vector3.new(v83.X, 0, v83.Z);

    return v84.Magnitude <= 0.05 and Vector3.new(0, 0, -1) or v84.Unit;
end;

local function scheduleLandingPlayerStrikesAtPositions(u85, p86, p87, u88, p89) -- Line: 452
    -- upvalues: SkillCommon (copy), pulseJumpStrikeHitboxAtGround (copy), scheduleLandingPlayerStrikeClient (copy)
    if #p86 == 0 then
        return;
    end;

    local u90 = Vector3.new(25, 25, 25) * SkillCommon.npcSummonBodySkillScale(u85);

    for i, v in p86 do
        local v91 = v - p87;
        local v92 = Vector3.new(v91.X, 0, v91.Z);
        local v93 = v92.Magnitude <= 0.05 and Vector3.new(0, 0, -1) or v92.Unit;

        if p89 then
            local u94 = i + 3 - 1;
            task.delay(1.2, function() -- Line: 372
                -- upvalues: u85 (copy), u88 (copy), u94 (copy), pulseJumpStrikeHitboxAtGround (ref), v (copy), u90 (copy)
                if u88 ~= u85.runGeneration then
                    return;
                end;

                local v95 = u85.hitbox[u94];

                if not v95 then
                    return;
                end;

                pulseJumpStrikeHitboxAtGround(v95, v, u90, 0.15, false);
            end);
        else
            scheduleLandingPlayerStrikeClient(u85, v, v93, u88);
        end;
    end;
end;

local function landingGroundCenterFromPlan(p96) -- Line: 475
    -- upvalues: SkillCommon (copy)
    local v97 = Vector3.new(p96.endPos.X, p96.endPos.Y - p96.groundClearance - 1, p96.endPos.Z);
    local Position = SkillCommon.getGroundCF(CFrame.new(v97), 4, 0.15, "Ground").Position;

    return Vector3.new(Position.X, Position.Y + 0.1, Position.Z);
end;

local function scheduleLandingPlayerStrikesIfNeeded(p98, p99, p100) -- Line: 483
    -- upvalues: SkillCommon (copy), gatherNearbyPlayerLandingStrikePositions (copy), scheduleLandingPlayerStrikesAtPositions (copy)
    local skillRunData = p98.skillRunData;
    skillRunData.Logic = skillRunData.Logic or {};

    if skillRunData.Logic.thunderTrampleLandPlayerStrikeDone then
        return;
    end;

    skillRunData.Logic.thunderTrampleLandPlayerStrikeDone = true;
    local v101 = p98.skillInputData and p98.skillInputData.character;

    if not v101 then
        return;
    end;

    local v102 = Vector3.new(p99.endPos.X, p99.endPos.Y - p99.groundClearance - 1, p99.endPos.Z);
    local Position = SkillCommon.getGroundCF(CFrame.new(v102), 4, 0.15, "Ground").Position;
    local v103 = Vector3.new(Position.X, Position.Y + 0.1, Position.Z);
    scheduleLandingPlayerStrikesAtPositions(p98, gatherNearbyPlayerLandingStrikePositions(p98, v103, v101), v103, p98.runGeneration, p100);
end;

local function scheduleJumpStrikeClient(u104, u105, u106, u107) -- Line: 505
    -- upvalues: SkillCommon (copy), cloneEmitFx (copy), emitJumpStrikeAt (copy)
    local skillRunData = u104.skillRunData;
    local v108;

    if skillRunData then
        v108 = skillRunData.material;
    else
        v108 = skillRunData;
    end;

    if not (skillRunData and v108) then
        return;
    end;

    local u109 = v108["独角兽落雷预警"];
    local u110 = v108["独角兽落雷"];
    local u111 = v108["独角兽落雷地面特效"];

    if not (u109 and (u110 and u111)) then
        return;
    end;

    local u112 = SkillCommon.npcSummonBodySkillScale(u104);
    task.delay(0, function() -- Line: 523
        -- upvalues: u104 (copy), u107 (copy), SkillCommon (ref), u109 (copy), u105 (copy), u112 (copy), skillRunData (copy), cloneEmitFx (ref)
        local v113 = u104;
        local v114;

        if SkillCommon.isRunningSameGeneration(v113, u107) then
            local v115 = v113.GetCurrentState and v113:GetCurrentState();
            v114 = v115 == "Movement" and true or v115 == "Recovery";
        else
            v114 = false;
        end;

        if not v114 then
            return;
        end;

        local v116 = u105;
        cloneEmitFx(u109, CFrame.new(v116), u112, skillRunData);
        SkillCommon.playSoundLocal3D("音效-技能-独角兽-预警", v116);
    end);
    task.delay(1.2, function() -- Line: 529
        -- upvalues: u104 (copy), u107 (copy), SkillCommon (ref), emitJumpStrikeAt (ref), u110 (copy), u111 (copy), u105 (copy), u106 (copy), u112 (copy), skillRunData (copy)
        local v117 = u104;
        local v118;

        if SkillCommon.isRunningSameGeneration(v117, u107) then
            local v119 = v117.GetCurrentState and v117:GetCurrentState();
            v118 = v119 == "Movement" and true or v119 == "Recovery";
        else
            v118 = false;
        end;

        if not v118 then
            return;
        end;

        emitJumpStrikeAt(u110, u111, u105, u106, u112, skillRunData);
    end);
end;

local function scheduleJumpStrikeServer(u120, u121, u122, u123) -- Line: 537
    -- upvalues: SkillCommon (copy), pulseJumpStrikeHitboxAtGround (copy)
    task.delay(1.2, function() -- Line: 543
        -- upvalues: SkillCommon (ref), u120 (copy), u122 (copy), pulseJumpStrikeHitboxAtGround (ref), u121 (copy), u123 (copy)
        if not SkillCommon.isRunningSameGeneration(u120, u122) then
            return;
        end;

        local v124 = u120.hitbox[2];

        if not v124 then
            return;
        end;

        pulseJumpStrikeHitboxAtGround(v124, u121, u123, 0.15, false);
    end);
end;

local function resolveJumpStrikeGroundPos(p125, p126) -- Line: 555
    -- upvalues: SkillCommon (copy)
    local HumanoidRootPart = p125:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return nil, nil;
    end;

    local Position = SkillCommon.getGroundCF(CFrame.new(p126 or HumanoidRootPart.Position), 4, 0.15, "Ground").Position;
    local v127 = Position - HumanoidRootPart.Position;
    local v128 = Vector3.new(v127.X, 0, v127.Z);

    if v128.Magnitude > 0.05 then
        return Position, v128.Unit;
    end;

    local HumanoidRootPart2 = HumanoidRootPart.Parent:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart2 then
        local v129 = Vector3.new(HumanoidRootPart2.CFrame.LookVector.X, 0, HumanoidRootPart2.CFrame.LookVector.Z);

        if v129.Magnitude > 0.05 then
            return Position, v129.Unit;
        end;
    end;

    return Position, Vector3.new(0, 0, -1);
end;

local function emitFootFxModel(p130, p131, p132) -- Line: 565
    -- upvalues: VisibleMgr (copy), FXUtil (copy)
    if not p130 then
        return;
    end;

    p130:ScaleTo(p132);
    VisibleMgr.UnQueryAll(p130);
    p130:PivotTo(p131);
    p130.Parent = workspace.Debris;
    FXUtil.Emit_Particles_GetDescendants(p130, true);
end;

local function resolveGroundAlignedFootCF(p133, p134, p135) -- Line: 576
    -- upvalues: FXUtil (copy)
    local HumanoidRootPart = p133:FindFirstChild("HumanoidRootPart");

    if not p134 then
        if HumanoidRootPart then
            p134 = HumanoidRootPart.Position;
        else
            p134 = p133:GetPivot().Position;
        end;
    end;

    return FXUtil.GetGroundAlignedCF(p134, p135, "Ground", 4, 0.15);
end;

local function resolveCasterFeetPos(p136, p137) -- Line: 589
    -- upvalues: SkillCommon (copy)
    local HumanoidRootPart = p136:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return p137 or p136:GetPivot().Position;
    end;

    if p137 then
        return SkillCommon.getGroundCF(CFrame.new(p137), 4, 0.15, "Ground").Position;
    end;

    return SkillCommon.casterFeetGroundWorldPos(HumanoidRootPart, 4, 0.15, "Ground");
end;

local function playJumpFootFx(p138) -- Line: 600
    -- upvalues: SkillCommon (copy), VisibleMgr (copy), FXUtil (copy)
    local v139 = p138.skillInputData and p138.skillInputData.character;

    if not v139 then
        return;
    end;

    local skillRunData = p138.skillRunData;
    local v140 = skillRunData.material and skillRunData.material["雷跃起跳"];

    if not v140 then
        return;
    end;

    local v141 = SkillCommon.npcSummonBodySkillScale(p138);
    local HumanoidRootPart = v139:FindFirstChild("HumanoidRootPart");
    local v142;

    if HumanoidRootPart then
        v142 = SkillCommon.casterFeetGroundWorldPos(HumanoidRootPart, 4, 0.15, "Ground");
    else
        v142 = v139:GetPivot().Position;
    end;

    local v143 = CFrame.new(v142) * v140:GetPivot().Rotation;

    if not v140 then
        return;
    end;

    v140:ScaleTo(v141);
    VisibleMgr.UnQueryAll(v140);
    v140:PivotTo(v143);
    v140.Parent = workspace.Debris;
    FXUtil.Emit_Particles_GetDescendants(v140, true);
end;

local function landFxWorldPosFromPlan(p144) -- Line: 615
    return Vector3.new(p144.endPos.X, p144.endPos.Y - p144.groundClearance - 1, p144.endPos.Z);
end;

local function playLandFootFx(p145, p146) -- Line: 619
    -- upvalues: SkillCommon (copy), FXUtil (copy), VisibleMgr (copy), resolveCasterFeetPos (copy)
    local v147 = p145.skillInputData and p145.skillInputData.character;

    if not v147 then
        return;
    end;

    local skillRunData = p145.skillRunData;
    local v148 = skillRunData.material and skillRunData.material["雷跃落地"];

    if not v148 then
        return;
    end;

    local v149 = SkillCommon.npcSummonBodySkillScale(p145);
    local HumanoidRootPart = v147:FindFirstChild("HumanoidRootPart");
    local v150;

    if HumanoidRootPart then
        local v151 = Vector3.new(HumanoidRootPart.CFrame.LookVector.X, 0, HumanoidRootPart.CFrame.LookVector.Z);
        v150 = v151.Magnitude <= 0.05 and Vector3.new(0, 0, -1) or v151.Unit;
    else
        v150 = Vector3.new(0, 0, -1);
    end;

    local HumanoidRootPart2 = v147:FindFirstChild("HumanoidRootPart");
    local v152;

    if p146 then
        v152 = p146;
    elseif HumanoidRootPart2 then
        v152 = HumanoidRootPart2.Position;
    else
        v152 = v147:GetPivot().Position;
    end;

    local v153 = FXUtil.GetGroundAlignedCF(v152, v150, "Ground", 4, 0.15);
    local v154;

    if v153 then
        if v148 then
            v148:ScaleTo(v149);
            VisibleMgr.UnQueryAll(v148);
            v148:PivotTo(v153);
            v148.Parent = workspace.Debris;
            FXUtil.Emit_Particles_GetDescendants(v148, true);
        end;

        v154 = v153.Position;
    else
        v154 = resolveCasterFeetPos(v147, p146);
        local v155 = CFrame.new(v154) * v148:GetPivot().Rotation;

        if v148 then
            v148:ScaleTo(v149);
            VisibleMgr.UnQueryAll(v148);
            v148:PivotTo(v155);
            v148.Parent = workspace.Debris;
            FXUtil.Emit_Particles_GetDescendants(v148, true);
        end;
    end;

    SkillCommon.playSoundLocal3D("音效-技能-独角兽-跳跃落地", v154);
end;

local function disconnectRunEvent(p156, p157) -- Line: 644
    -- upvalues: SkillCommon (copy)
    SkillCommon.disconnectRunEventKeys(p156.skillRunData, { p157 });
end;

local function onLandingIfNeeded(p158, p159, p160) -- Line: 648
    -- upvalues: scheduleLandingPlayerStrikesIfNeeded (copy)
    scheduleLandingPlayerStrikesIfNeeded(p158, p159, p160);
end;

local function buildFlatLookRotation(p161, p162, p163) -- Line: 652
    local v164 = Vector3.new(p162.X - p161.X, 0, p162.Z - p161.Z);

    if v164.Magnitude < 0.01 then
        return p163;
    end;

    return CFrame.lookAt(Vector3.new(0, 0, 0), v164.Unit, Vector3.new(0, 1, 0));
end;

local function resolveMoveFaceMode(p165) -- Line: 660
    -- upvalues: u5 (copy)
    return p165 and p165.moveFaceMode == u5.MoveFaceMode.AttackTarget and "AttackTarget" or "MoveTarget";
end;

local function resolveAttackFaceWorldPos(p166, p167, p168) -- Line: 667
    -- upvalues: SkillCommon (copy)
    if typeof(p166.moveFaceWorldPos) == "Vector3" then
        return p166.moveFaceWorldPos;
    end;

    local v169 = Vector3.new(p168.LookVector.X, 0, p168.LookVector.Z);

    return SkillCommon.resolveTrackPos(p166, p167 + (v169.Magnitude < 0.01 and Vector3.new(0, 0, -1) or v169.Unit) * 5);
end;

local function resolveFaceRotation(p170, p171) -- Line: 681
    -- upvalues: buildFlatLookRotation (copy)
    if p170.faceMode == "AttackTarget" and p170.attackFaceWorldPos then
        return buildFlatLookRotation(p171, p170.attackFaceWorldPos, p170.startRot);
    end;

    return buildFlatLookRotation(p171, p170.endPos, p170.startRot);
end;

local function resolveRecoveryTargetRotation(p172, p173) -- Line: 688
    -- upvalues: buildFlatLookRotation (copy)
    return buildFlatLookRotation(p172.endPos, p173, p172.startRot);
end;

local function sampleMoveCF(p174, p175) -- Line: 692
    -- upvalues: TweenService (copy), Quad (copy), Out (copy), ThunderLeapTiming (copy)
    local v176 = math.clamp(p175, 0, 1);
    local v177 = TweenService:GetValue(v176, Quad, Out);
    local v178 = p174.startPos:Lerp(p174.endPos, v177);
    local v179 = ThunderLeapTiming.sampleArcHeight(v176, p174.arcHeight);
    local v180 = v178 + Vector3.new(0, v179, 0);
    local v181 = CFrame.new(v180);
    local v182;

    if p174.faceMode == "AttackTarget" and p174.attackFaceWorldPos then
        local attackFaceWorldPos = p174.attackFaceWorldPos;
        v182 = p174.startRot;
        local v183 = Vector3.new(attackFaceWorldPos.X - v180.X, 0, attackFaceWorldPos.Z - v180.Z);

        if v183.Magnitude >= 0.01 then
            v182 = CFrame.lookAt(Vector3.new(0, 0, 0), v183.Unit, Vector3.new(0, 1, 0));
        end;
    else
        local endPos = p174.endPos;
        v182 = p174.startRot;
        local v184 = Vector3.new(endPos.X - v180.X, 0, endPos.Z - v180.Z);

        if v184.Magnitude >= 0.01 then
            v182 = CFrame.lookAt(Vector3.new(0, 0, 0), v184.Unit, Vector3.new(0, 1, 0));
        end;
    end;

    return v181 * v182;
end;

local function resolveRawGroundY(p185) -- Line: 701
    -- upvalues: SkillCommon (copy)
    return SkillCommon.getGroundCF(CFrame.new(p185), 4, 0, "Ground").Position.Y;
end;

local function commitMovePlan(p186) -- Line: 706
    -- upvalues: SkillCommon (copy), MIN_FEASIBLE_MOVE_HORIZ (copy), u5 (copy), ThunderLeapTiming (copy)
    local skillInputData = p186.skillInputData;
    local v187;

    if skillInputData then
        v187 = skillInputData.character;
    else
        v187 = skillInputData;
    end;

    if not v187 then
        return nil;
    end;

    local HumanoidRootPart = v187:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return nil;
    end;

    if typeof(skillInputData.approachLandWorldPos) ~= "Vector3" then
        SkillCommon.refreshSkillAimSnapshot(p186);
    end;

    local Position = HumanoidRootPart.Position;
    local v188 = SkillCommon.getGroundCF(CFrame.new(Position), 4, 0, "Ground").Position.Y or Position.Y;
    local v189 = math.max(0, Position.Y - v188);
    local v190;

    if typeof(skillInputData.approachLandWorldPos) == "Vector3" then
        v190 = skillInputData.approachLandWorldPos;
    else
        v190 = SkillCommon.resolveStrikeWorldPos(skillInputData);
    end;

    local v191 = Vector3.new(v190.X, Position.Y, v190.Z);
    local v192 = SkillCommon.resolveBodyWallBackoffStuds(HumanoidRootPart, 3);
    local v193 = SkillCommon.resolveMoveEndpointWorldPos(Position, v191, v187, {
        probeUpStuds = 50,
        probeDownStuds = 100,
        maxDropBelowStartStuds = 30,
        groundLift = 0,
        rayTag = "Ground",
        wallBackoffStuds = v192,
        minHorizontalMoveStuds = MIN_FEASIBLE_MOVE_HORIZ
    });

    if not v193 then
        return nil;
    end;

    local v194 = Vector3.new(v193.X, v193.Y + v189 + 1, v193.Z);
    local v195 = v187:GetPivot();
    local v196 = SkillCommon.npcSummonBodySkillScale(p186);
    local Magnitude = (Vector3.new(Position.X, 0, Position.Z) - Vector3.new(v194.X, 0, v194.Z)).Magnitude;
    local v197 = math.min(16, Magnitude * 0.35) * v196;
    local v198 = skillInputData and skillInputData.moveFaceMode == u5.MoveFaceMode.AttackTarget and "AttackTarget" or "MoveTarget";
    local v199;

    if v198 == "AttackTarget" then
        local Rotation = v195.Rotation;

        if typeof(skillInputData.moveFaceWorldPos) == "Vector3" then
            v199 = skillInputData.moveFaceWorldPos;
        else
            local v200 = Vector3.new(Rotation.LookVector.X, 0, Rotation.LookVector.Z);
            v199 = SkillCommon.resolveTrackPos(skillInputData, Position + (v200.Magnitude < 0.01 and Vector3.new(0, 0, -1) or v200.Unit) * 5);
        end;
    else
        v199 = nil;
    end;

    local v201 = ThunderLeapTiming.computeFromHorizDist(Magnitude);

    return {
        startedAt = 0,
        startPos = Position,
        endPos = v194,
        startRot = v195.Rotation,
        faceMode = v198,
        attackFaceWorldPos = v199,
        arcHeight = v197,
        duration = v201.move,
        groundClearance = v189,
        phases = v201
    };
end;

local function scheduleStartupTimeout(u202, p203, u204) -- Line: 774
    -- upvalues: SkillCommon (copy), SkillEventConst (copy)
    task.delay(p203, function() -- Line: 775
        -- upvalues: SkillCommon (ref), u202 (copy), u204 (copy), SkillEventConst (ref)
        if not SkillCommon.isRunningSameGeneration(u202, u204) then
            return;
        end;

        if u202.GetCurrentState and u202:GetCurrentState() == "Startup" then
            u202:TryTransition(SkillEventConst.StateTimeout, nil);
        end;
    end);
end;

local function lockCharacterForSkillMove(p205) -- Line: 785
    local HumanoidRootPart = p205:FindFirstChild("HumanoidRootPart");
    local v206 = p205:FindFirstChildOfClass("Humanoid");

    if not (HumanoidRootPart and v206) then
        return nil;
    end;

    local v207 = {
        hrp = HumanoidRootPart,
        humanoid = v206,
        wasAnchored = HumanoidRootPart.Anchored,
        wasAutoRotate = v206.AutoRotate,
        prevWalkSpeed = v206.WalkSpeed
    };
    HumanoidRootPart.Anchored = true;
    v206.AutoRotate = false;
    v206.WalkSpeed = 0;
    p205:SetAttribute("ThunderTrampleMoveLock", true);
    p205:SetAttribute("NPCUprightSnapDisabled", true);

    return v207;
end;

local function getSkillCharacter(p208) -- Line: 806
    return p208.character or p208.skillInputData and p208.skillInputData.character;
end;

local function getSkillAnimator(p209) -- Line: 810
    if not p209 then
        return nil;
    end;

    local v210 = p209:FindFirstChildOfClass("Humanoid");

    if v210 then
        return v210:FindFirstChildOfClass("Animator");
    end;

    return nil;
end;

local function setTrackLooped(p211, p212, p213) -- Line: 821
    for _, v in p211:GetPlayingAnimationTracks() do
        if v.Name == p212 then
            v.Looped = p213;

            return;
        end;
    end;
end;

local function serverStopLeapAnim(p214) -- Line: 830
    -- upvalues: AnimationModule (copy)
    local v215 = p214.character or p214.skillInputData and p214.skillInputData.character;
    local v216;

    if v215 then
        local v217 = v215:FindFirstChildOfClass("Humanoid");

        if v217 then
            v216 = v217:FindFirstChildOfClass("Animator");
        else
            v216 = nil;
        end;
    else
        v216 = nil;
    end;

    if v216 then
        AnimationModule.StopAnim(v216, "雷跃", 0.1);
    end;
end;

local function serverPlayPauseWalkAnim(p218) -- Line: 837
    -- upvalues: AnimationModule (copy), Movement (copy)
    local v219 = p218.character or p218.skillInputData and p218.skillInputData.character;
    local v220;

    if v219 then
        local v221 = v219:FindFirstChildOfClass("Humanoid");

        if v221 then
            v220 = v221:FindFirstChildOfClass("Animator");
        else
            v220 = nil;
        end;
    else
        v220 = nil;
    end;

    if not v220 then
        return;
    end;

    AnimationModule.StopAnim(v220, "雷跃", 0.1);
    AnimationModule.StopAnim(v220, "独角兽行走异形骨骼", 0);
    AnimationModule.PlayAnim(v220, "独角兽行走异形骨骼", 1, nil, nil, Movement, 0.1);

    for _, v in v220:GetPlayingAnimationTracks() do
        if v.Name == "独角兽行走异形骨骼" then
            v.Looped = true;

            return;
        end;
    end;
end;

local function serverStopPauseWalkAnim(p222) -- Line: 848
    -- upvalues: AnimationModule (copy)
    local v223 = p222.character or p222.skillInputData and p222.skillInputData.character;
    local v224;

    if v223 then
        local v225 = v223:FindFirstChildOfClass("Humanoid");

        if v225 then
            v224 = v225:FindFirstChildOfClass("Animator");
        else
            v224 = nil;
        end;
    else
        v224 = nil;
    end;

    if v224 then
        AnimationModule.StopAnim(v224, "独角兽行走异形骨骼", 0.1);
    end;
end;

local function applyLeapAnimSpeed(p226, p227) -- Line: 855
    -- upvalues: AnimationModule (copy)
    local v228 = p226.character or p226.skillInputData and p226.skillInputData.character;
    local v229;

    if v228 then
        local v230 = v228:FindFirstChildOfClass("Humanoid");

        if v230 then
            v229 = v230:FindFirstChildOfClass("Animator");
        else
            v229 = nil;
        end;
    else
        v229 = nil;
    end;

    if v229 then
        AnimationModule.ChangeAnimSpeed(v229, "雷跃", p227);
    end;
end;

local function resolveHrpAndHumanoid(p231, p232) -- Line: 862
    if p231 and p231.Parent then
        local HumanoidRootPart = p231:FindFirstChild("HumanoidRootPart");
        local v233 = p231:FindFirstChildOfClass("Humanoid");

        if HumanoidRootPart and (HumanoidRootPart.Parent and (v233 and v233.Parent)) then
            return HumanoidRootPart, v233;
        end;
    end;

    if p232 and (p232.hrp and (p232.hrp.Parent and (p232.humanoid and p232.humanoid.Parent))) then
        return p232.hrp, p232.humanoid;
    end;

    return nil, nil;
end;

local function clearSkillMoveLockAttribute(p234) -- Line: 876
    if p234 and p234.Parent then
        p234:SetAttribute("ThunderTrampleMoveLock", nil);
        p234:SetAttribute("NPCUprightSnapDisabled", nil);
    end;
end;

local function getMoveEndCF(p235) -- Line: 883
    local v236 = CFrame.new(p235.endPos);
    local endPos = p235.endPos;
    local v237;

    if p235.faceMode == "AttackTarget" and p235.attackFaceWorldPos then
        local attackFaceWorldPos = p235.attackFaceWorldPos;
        v237 = p235.startRot;
        local v238 = Vector3.new(attackFaceWorldPos.X - endPos.X, 0, attackFaceWorldPos.Z - endPos.Z);

        if v238.Magnitude >= 0.01 then
            v237 = CFrame.lookAt(Vector3.new(0, 0, 0), v238.Unit, Vector3.new(0, 1, 0));
        end;
    else
        local endPos2 = p235.endPos;
        v237 = p235.startRot;
        local v239 = Vector3.new(endPos2.X - endPos.X, 0, endPos2.Z - endPos.Z);

        if v239.Magnitude >= 0.01 then
            v237 = CFrame.lookAt(Vector3.new(0, 0, 0), v239.Unit, Vector3.new(0, 1, 0));
        end;
    end;

    return v236 * v237;
end;

local function syncNpcEntityPos(p240, p241) -- Line: 887
    -- upvalues: UtilsSystem (copy)
    local v242 = UtilsSystem.SystemEnemy.getPackByModel(p240);

    if not v242 and UtilsSystem.SystemSummon.getPackByModel then
        v242 = UtilsSystem.SystemSummon.getPackByModel(p240);
    end;

    if v242 then
        v242 = v242.entity;
    end;

    if not v242 then
        return;
    end;

    v242.pos = p241;
    v242.lastPos = p241;
end;

local function serverStartSmoothFaceRotation(u243, u244, u245, u246, u247, u248, u249) -- Line: 901
    -- upvalues: SkillCommon (copy), RunService (copy), UtilsSystem (copy)
    local u250 = u243.character or u243.skillInputData and u243.skillInputData.character;

    if not u250 then
        return;
    end;

    SkillCommon.disconnectRunEventKeys(u243.skillRunData, { u244 });
    local skillRunData = u243.skillRunData;

    if not skillRunData then
        return;
    end;

    skillRunData.runEvent = skillRunData.runEvent or {};
    skillRunData.runEvent[u244] = RunService.Heartbeat:Connect(function() -- Line: 922
        -- upvalues: u243 (copy), u244 (copy), SkillCommon (ref), skillRunData (copy), u245 (copy), u246 (copy), u248 (copy), u249 (copy), u250 (copy), u247 (copy), UtilsSystem (ref)
        if not u243:isRunningFlow() then
            SkillCommon.disconnectRunEventKeys(u243.skillRunData, { u244 });

            return;
        end;

        if (skillRunData.State and skillRunData.State.current) ~= u245 then
            SkillCommon.disconnectRunEventKeys(u243.skillRunData, { u244 });

            return;
        end;

        local v251;

        if skillRunData.State then
            v251 = skillRunData.State.enteredAt;
        else
            v251 = u243.nowTime;
        end;

        local v252 = math.clamp((u243.nowTime - v251) / u246, 0, 1);
        local v253 = u248:Lerp(u249, v252);
        u250:PivotTo(CFrame.new(u247) * v253);
        local v254 = u250;
        local v255 = u247;
        local v256 = UtilsSystem.SystemEnemy.getPackByModel(v254);

        if not v256 and UtilsSystem.SystemSummon.getPackByModel then
            v256 = UtilsSystem.SystemSummon.getPackByModel(v254);
        end;

        if v256 then
            v256 = v256.entity;
        end;

        if v256 then
            v256.pos = v255;
            v256.lastPos = v255;
        end;

        if v252 >= 1 then
            SkillCommon.disconnectRunEventKeys(u243.skillRunData, { u244 });
        end;
    end);
end;

local function serverStartRecoveryFaceRotation(u257, u258, u259, u260) -- Line: 944
    -- upvalues: SkillCommon (copy), RunService (copy), ThunderLeapTiming (copy), UtilsSystem (copy), AnimationModule (copy)
    local u261 = u257.character or u257.skillInputData and u257.skillInputData.character;

    if not u261 then
        return;
    end;

    SkillCommon.disconnectRunEventKeys(u257.skillRunData, { "ThunderTrampleRecoveryFace" });
    local skillRunData = u257.skillRunData;

    if not skillRunData then
        return;
    end;

    local nowTime = u257.nowTime;
    skillRunData.runEvent = skillRunData.runEvent or {};
    skillRunData.runEvent.ThunderTrampleRecoveryFace = RunService.Heartbeat:Connect(function() -- Line: 963
        -- upvalues: u257 (copy), SkillCommon (ref), skillRunData (copy), u258 (copy), nowTime (ref), ThunderLeapTiming (ref), u261 (copy), u259 (copy), UtilsSystem (ref), AnimationModule (ref), u260 (copy)
        if not u257:isRunningFlow() then
            SkillCommon.disconnectRunEventKeys(u257.skillRunData, { "ThunderTrampleRecoveryFace" });

            return;
        end;

        if (skillRunData.State and skillRunData.State.current) ~= "Recovery" then
            SkillCommon.disconnectRunEventKeys(u257.skillRunData, { "ThunderTrampleRecoveryFace" });

            return;
        end;

        SkillCommon.refreshSkillAimSnapshot(u257);
        local v262 = SkillCommon.resolveStrikeWorldPos(u257.skillInputData);
        local v263 = u258;
        local endPos = v263.endPos;
        local startRot = v263.startRot;
        local v264 = Vector3.new(v262.X - endPos.X, 0, v262.Z - endPos.Z);

        if v264.Magnitude >= 0.01 then
            startRot = CFrame.lookAt(Vector3.new(0, 0, 0), v264.Unit, Vector3.new(0, 1, 0));
        end;

        local nowTime2 = u257.nowTime;
        local v265 = math.max(nowTime2 - nowTime, 0);
        nowTime = nowTime2;
        local v266 = math.clamp(v265 * ThunderLeapTiming.RECOVERY_FACE_TRACK_RATE, 0, 1);
        local v267 = u261:GetPivot().Rotation:Lerp(startRot, v266);
        u261:PivotTo(CFrame.new(u259) * v267);
        local v268 = u261;
        local v269 = u259;
        local v270 = UtilsSystem.SystemEnemy.getPackByModel(v268);

        if not v270 and UtilsSystem.SystemSummon.getPackByModel then
            v270 = UtilsSystem.SystemSummon.getPackByModel(v268);
        end;

        if v270 then
            v270 = v270.entity;
        end;

        if v270 then
            v270.pos = v269;
            v270.lastPos = v269;
        end;

        if not ThunderLeapTiming.isFlatLookAligned(v267, startRot) then
            local v271;

            if skillRunData.State then
                v271 = skillRunData.State.enteredAt;
            else
                v271 = nowTime2;
            end;

            if u260 <= nowTime2 - v271 then
                SkillCommon.disconnectRunEventKeys(u257.skillRunData, { "ThunderTrampleRecoveryFace" });
            end;

            return;
        end;

        SkillCommon.disconnectRunEventKeys(u257.skillRunData, { "ThunderTrampleRecoveryFace" });
        local v272 = u257;
        local v273 = v272.character or v272.skillInputData and v272.skillInputData.character;
        local v274;

        if v273 then
            local v275 = v273:FindFirstChildOfClass("Humanoid");

            if v275 then
                v274 = v275:FindFirstChildOfClass("Animator");
            else
                v274 = nil;
            end;
        else
            v274 = nil;
        end;

        if v274 then
            AnimationModule.StopAnim(v274, "独角兽行走异形骨骼", 0.1);
        end;
    end);
end;

local function snapCharacterToMoveEnd(p276, p277) -- Line: 1000
    -- upvalues: UtilsSystem (copy)
    local skillRunData = p276.skillRunData;
    local v278 = skillRunData and skillRunData.Logic and skillRunData.Logic.thunderTrampleMove;
    local v279 = p276.skillInputData and p276.skillInputData.character;

    if not (v278 and v279) then
        return;
    end;

    local v280;

    if p277 then
        v280 = CFrame.new(v278.endPos) * v279:GetPivot().Rotation;
    else
        local v281 = CFrame.new(v278.endPos);
        local endPos = v278.endPos;
        local v282;

        if v278.faceMode == "AttackTarget" and v278.attackFaceWorldPos then
            local attackFaceWorldPos = v278.attackFaceWorldPos;
            v282 = v278.startRot;
            local v283 = Vector3.new(attackFaceWorldPos.X - endPos.X, 0, attackFaceWorldPos.Z - endPos.Z);

            if v283.Magnitude >= 0.01 then
                v282 = CFrame.lookAt(Vector3.new(0, 0, 0), v283.Unit, Vector3.new(0, 1, 0));
            end;
        else
            local endPos2 = v278.endPos;
            v282 = v278.startRot;
            local v284 = Vector3.new(endPos2.X - endPos.X, 0, endPos2.Z - endPos.Z);

            if v284.Magnitude >= 0.01 then
                v282 = CFrame.lookAt(Vector3.new(0, 0, 0), v284.Unit, Vector3.new(0, 1, 0));
            end;
        end;

        v280 = v281 * v282;
    end;

    v279:PivotTo(v280);
    local endPos = v278.endPos;
    local v285 = UtilsSystem.SystemEnemy.getPackByModel(v279);

    if not v285 and UtilsSystem.SystemSummon.getPackByModel then
        v285 = UtilsSystem.SystemSummon.getPackByModel(v279);
    end;

    if v285 then
        v285 = v285.entity;
    end;

    if not v285 then
        return;
    end;

    v285.pos = endPos;
    v285.lastPos = endPos;
end;

local function applyHumanoidPhysicsAfterUnanchor(p286, p287) -- Line: 1015
    if not p286.Parent then
        return;
    end;

    p286:ChangeState(Enum.HumanoidStateType.GettingUp);

    if p287 then
        p286.AutoRotate = p287.wasAutoRotate;
        p286.WalkSpeed = p287.prevWalkSpeed;

        return;
    end;

    p286.AutoRotate = true;

    if p286.WalkSpeed <= 0 then
        p286.WalkSpeed = 16;
    end;
end;

local function releaseSkillMoveAnchoring(p288, p289, p290, p291) -- Line: 1031
    -- upvalues: resolveHrpAndHumanoid (copy), UtilsSystem (copy)
    local v292 = p289 or p288.character or p288.skillInputData and p288.skillInputData.character;
    local v293, v294 = resolveHrpAndHumanoid(v292, p290);

    if not v293 then
        if v292 and v292.Parent then
            v292:SetAttribute("ThunderTrampleMoveLock", nil);
            v292:SetAttribute("NPCUprightSnapDisabled", nil);
        end;

        return;
    end;

    if v292 and (v292.Parent and p291) then
        v292:PivotTo(CFrame.new(p291.endPos) * v292:GetPivot().Rotation);
        local endPos = p291.endPos;
        local v295 = UtilsSystem.SystemEnemy.getPackByModel(v292);

        if not v295 and UtilsSystem.SystemSummon.getPackByModel then
            v295 = UtilsSystem.SystemSummon.getPackByModel(v292);
        end;

        if v295 then
            v295 = v295.entity;
        end;

        if v295 then
            v295.pos = endPos;
            v295.lastPos = endPos;
        end;

        if v294 and v294.Parent then
            v294:MoveTo(p291.endPos);
        end;
    end;

    v293.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
    v293.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
    v293.Anchored = false;

    if v294 and v294.Parent then
        v294:ChangeState(Enum.HumanoidStateType.GettingUp);

        if p290 then
            v294.AutoRotate = p290.wasAutoRotate;
            v294.WalkSpeed = p290.prevWalkSpeed;
        else
            v294.AutoRotate = true;

            if v294.WalkSpeed <= 0 then
                v294.WalkSpeed = 16;
            end;
        end;
    end;

    if v292 and v292.Parent then
        v292:SetAttribute("ThunderTrampleMoveLock", nil);
        v292:SetAttribute("NPCUprightSnapDisabled", nil);
    end;
end;

local function restoreCharacterMoveState(p296) -- Line: 1067
    -- upvalues: releaseSkillMoveAnchoring (copy)
    local v297 = p296.character or p296.skillInputData and p296.skillInputData.character;
    local skillRunData = p296.skillRunData;
    local v298 = nil;
    local v299 = nil;
    local v300;

    if v297 then
        v300 = v297:GetAttribute("ThunderTrampleMoveLock") == true;
    else
        v300 = v297;
    end;

    if skillRunData and skillRunData.Logic then
        v298 = skillRunData.Logic.thunderTrampleMoveLock;
        v299 = skillRunData.Logic.thunderTrampleMove;
        v300 = v300 or v298 ~= nil;
        skillRunData.Logic.thunderTrampleMoveLock = nil;
    end;

    if not v300 then
        return;
    end;

    releaseSkillMoveAnchoring(p296, v297, v298, v299);
end;

function u5.onEndServer(p301) -- Line: 1087
    -- upvalues: SkillCommon (copy), AnimationModule (copy), restoreCharacterMoveState (copy)
    SkillCommon.disconnectRunEventKeys(p301.skillRunData, { "ThunderTrampleStartupFace" });
    SkillCommon.disconnectRunEventKeys(p301.skillRunData, { "ThunderTrampleRecoveryFace" });
    local v302 = p301.character or p301.skillInputData and p301.skillInputData.character;
    local v303;

    if v302 then
        local v304 = v302:FindFirstChildOfClass("Humanoid");

        if v304 then
            v303 = v304:FindFirstChildOfClass("Animator");
        else
            v303 = nil;
        end;
    else
        v303 = nil;
    end;

    if v303 then
        AnimationModule.StopAnim(v303, "独角兽行走异形骨骼", 0.1);
    end;

    local v305 = p301.character or p301.skillInputData and p301.skillInputData.character;
    local v306;

    if v305 then
        local v307 = v305:FindFirstChildOfClass("Humanoid");

        if v307 then
            v306 = v307:FindFirstChildOfClass("Animator");
        else
            v306 = nil;
        end;
    else
        v306 = nil;
    end;

    if v306 then
        AnimationModule.StopAnim(v306, "雷跃", 0.1);
    end;

    for i = 1, 10 do
        local v308 = p301.hitbox[i];

        if v308 and v308.isActive then
            v308:stop();
        end;

        if v308 and v308.hitbox then
            local hitbox = v308.hitbox;

            if hitbox then
                hitbox.Transparency = 1;
            end;
        end;
    end;

    restoreCharacterMoveState(p301);
end;

local function movementProgress(p309, p310) -- Line: 1105
    -- upvalues: LEAP_PHASE_MOVE (copy)
    local duration = p310.duration;

    if duration <= 0 then
        duration = LEAP_PHASE_MOVE;
    end;

    return math.clamp((p309.nowTime - p310.startedAt) / duration, 0, 1);
end;

local function pinCharacterAtMoveEnd(p311) -- Line: 1113
    -- upvalues: snapCharacterToMoveEnd (copy)
    local skillRunData = p311.skillRunData;

    if not (skillRunData and skillRunData.Logic and skillRunData.Logic.thunderTrampleMove) then
        return;
    end;

    snapCharacterToMoveEnd(p311);
    local thunderTrampleMoveLock = skillRunData.Logic.thunderTrampleMoveLock;

    if thunderTrampleMoveLock and thunderTrampleMoveLock.hrp.Parent then
        thunderTrampleMoveLock.hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
        thunderTrampleMoveLock.hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
    end;
end;

local function applyMovementSample(p312, p313, p314) -- Line: 1127
    -- upvalues: sampleMoveCF (copy)
    local character = p312.skillInputData.character;

    if not character then
        return;
    end;

    character:PivotTo((sampleMoveCF(p313, p314)));
end;

function u5.Client_EnterStartup(u315) -- Line: 1136
    -- upvalues: commitMovePlan (copy), SkillCommon (copy), SkillEventConst (copy)
    local skillRunData = u315.skillRunData;
    skillRunData.Logic = skillRunData.Logic or {};
    local v316 = commitMovePlan(u315);

    if not v316 then
        return;
    end;

    skillRunData.Logic.thunderTrampleMove = v316;
    local runGeneration = u315.runGeneration;
    task.delay(v316.phases.windup, function() -- Line: 775
        -- upvalues: SkillCommon (ref), u315 (copy), runGeneration (copy), SkillEventConst (ref)
        if not SkillCommon.isRunningSameGeneration(u315, runGeneration) then
            return;
        end;

        if u315.GetCurrentState and u315:GetCurrentState() == "Startup" then
            u315:TryTransition(SkillEventConst.StateTimeout, nil);
        end;
    end);
end;

function u5.Client_ExitStartup(p317) -- Line: 1147
end;

function u5.Server_EnterStartup(u318) -- Line: 1150
    -- upvalues: commitMovePlan (copy), lockCharacterForSkillMove (copy), AnimationModule (copy), SkillCommon (copy), SkillEventConst (copy), UtilsSystem (copy), serverStartSmoothFaceRotation (copy)
    local v319 = u318.skillInputData and u318.skillInputData.character;
    local v320 = u318.hitbox[2];
    local v321 = v320 and v320.hitbox and v320.hitbox;

    if v321 then
        v321.Transparency = 1;
    end;

    if not v319 then
        return;
    end;

    local skillRunData = u318.skillRunData;
    skillRunData.Logic = skillRunData.Logic or {};
    local v322 = commitMovePlan(u318);

    if not v322 then
        return;
    end;

    skillRunData.Logic.thunderTrampleMove = v322;
    skillRunData.Logic.thunderTrampleMoveLock = lockCharacterForSkillMove(v319);
    local animSpeed = v322.phases.animSpeed;
    local v323 = u318.character or u318.skillInputData and u318.skillInputData.character;
    local v324;

    if v323 then
        local v325 = v323:FindFirstChildOfClass("Humanoid");

        if v325 then
            v324 = v325:FindFirstChildOfClass("Animator");
        else
            v324 = nil;
        end;
    else
        v324 = nil;
    end;

    if v324 then
        AnimationModule.ChangeAnimSpeed(v324, "雷跃", animSpeed);
    end;

    local runGeneration = u318.runGeneration;
    task.delay(v322.phases.windup, function() -- Line: 775
        -- upvalues: SkillCommon (ref), u318 (copy), runGeneration (copy), SkillEventConst (ref)
        if not SkillCommon.isRunningSameGeneration(u318, runGeneration) then
            return;
        end;

        if u318.GetCurrentState and u318:GetCurrentState() == "Startup" then
            u318:TryTransition(SkillEventConst.StateTimeout, nil);
        end;
    end);
    local startPos = v322.startPos;
    local Rotation = v319:GetPivot().Rotation;
    local startPos2 = v322.startPos;
    local v326;

    if v322.faceMode == "AttackTarget" and v322.attackFaceWorldPos then
        local attackFaceWorldPos = v322.attackFaceWorldPos;
        v326 = v322.startRot;
        local v327 = Vector3.new(attackFaceWorldPos.X - startPos2.X, 0, attackFaceWorldPos.Z - startPos2.Z);

        if v327.Magnitude >= 0.01 then
            v326 = CFrame.lookAt(Vector3.new(0, 0, 0), v327.Unit, Vector3.new(0, 1, 0));
        end;
    else
        local endPos = v322.endPos;
        v326 = v322.startRot;
        local v328 = Vector3.new(endPos.X - startPos2.X, 0, endPos.Z - startPos2.Z);

        if v328.Magnitude >= 0.01 then
            v326 = CFrame.lookAt(Vector3.new(0, 0, 0), v328.Unit, Vector3.new(0, 1, 0));
        end;
    end;

    v319:PivotTo(CFrame.new(startPos) * Rotation);
    local v329 = UtilsSystem.SystemEnemy.getPackByModel(v319);

    if not v329 and UtilsSystem.SystemSummon.getPackByModel then
        v329 = UtilsSystem.SystemSummon.getPackByModel(v319);
    end;

    if v329 then
        v329 = v329.entity;
    end;

    if v329 then
        v329.pos = startPos;
        v329.lastPos = startPos;
    end;

    serverStartSmoothFaceRotation(u318, "ThunderTrampleStartupFace", "Startup", v322.phases.windup, startPos, Rotation, v326);
end;

function u5.Server_ExitStartup(p330) -- Line: 1188
    -- upvalues: SkillCommon (copy)
    SkillCommon.disconnectRunEventKeys(p330.skillRunData, { "ThunderTrampleStartupFace" });
end;

function u5.Client_EnterMovement(u331) -- Line: 1193
    -- upvalues: SkillCommon (copy), playJumpFootFx (copy), scheduleJumpStrikeClient (copy), commitMovePlan (copy), RunService (copy), LEAP_PHASE_MOVE (copy), playLandFootFx (copy), scheduleLandingPlayerStrikesIfNeeded (copy)
    local v332 = u331.skillInputData and u331.skillInputData.character;

    if not v332 then
        return;
    end;

    SkillCommon.playSoundLocal3D("音效-技能-雷系普攻", v332:GetPivot().Position);
    playJumpFootFx(u331);
    local HumanoidRootPart = v332:FindFirstChild("HumanoidRootPart");
    local v333, v334;

    if HumanoidRootPart then
        v333 = SkillCommon.getGroundCF(CFrame.new(HumanoidRootPart.Position), 4, 0.15, "Ground").Position;
        local v335 = v333 - HumanoidRootPart.Position;
        local v336 = Vector3.new(v335.X, 0, v335.Z);

        if v336.Magnitude > 0.05 then
            v334 = v336.Unit;
        else
            local HumanoidRootPart2 = HumanoidRootPart.Parent:FindFirstChild("HumanoidRootPart");

            if HumanoidRootPart2 then
                local v337 = Vector3.new(HumanoidRootPart2.CFrame.LookVector.X, 0, HumanoidRootPart2.CFrame.LookVector.Z);

                if v337.Magnitude > 0.05 then
                    v334 = v337.Unit;
                else
                    v334 = Vector3.new(0, 0, -1);
                end;
            else
                v334 = Vector3.new(0, 0, -1);
            end;
        end;
    else
        v333 = nil;
        v334 = nil;
    end;

    if v333 and v334 then
        scheduleJumpStrikeClient(u331, v333, v334, u331.runGeneration);
    end;

    local skillRunData = u331.skillRunData;
    skillRunData.Logic = skillRunData.Logic or {};
    local v338 = skillRunData.Logic.thunderTrampleMove or commitMovePlan(u331);

    if not v338 then
        return;
    end;

    v338.startedAt = u331.nowTime;
    skillRunData.Logic.thunderTrampleMove = v338;
    skillRunData.clientLandFxDone = false;
    SkillCommon.disconnectRunEventKeys(u331.skillRunData, { "ThunderTrampleMove" });
    skillRunData.runEvent = skillRunData.runEvent or {};
    skillRunData.runEvent.ThunderTrampleMove = RunService.Heartbeat:Connect(function() -- Line: 1217
        -- upvalues: u331 (copy), skillRunData (copy), LEAP_PHASE_MOVE (ref), playLandFootFx (ref), scheduleLandingPlayerStrikesIfNeeded (ref)
        if not u331:isRunningFlow() then
            return;
        end;

        local thunderTrampleMove = skillRunData.Logic.thunderTrampleMove;

        if not thunderTrampleMove or thunderTrampleMove.startedAt <= 0 then
            return;
        end;

        if (skillRunData.State and skillRunData.State.current) ~= "Movement" then
            return;
        end;

        if skillRunData.clientLandFxDone then
            return;
        end;

        local duration = thunderTrampleMove.duration;

        if duration <= 0 then
            duration = LEAP_PHASE_MOVE;
        end;

        if math.clamp((u331.nowTime - thunderTrampleMove.startedAt) / duration, 0, 1) >= 0.92 then
            skillRunData.clientLandFxDone = true;
            playLandFootFx(u331, (Vector3.new(thunderTrampleMove.endPos.X, thunderTrampleMove.endPos.Y - thunderTrampleMove.groundClearance - 1, thunderTrampleMove.endPos.Z)));
            scheduleLandingPlayerStrikesIfNeeded(u331, thunderTrampleMove, false);
        end;
    end);
end;

function u5.Client_ExitMovement(p339) -- Line: 1241
    -- upvalues: playLandFootFx (copy), scheduleLandingPlayerStrikesIfNeeded (copy), SkillCommon (copy)
    local skillRunData = p339.skillRunData;
    local v340 = skillRunData and skillRunData.Logic and skillRunData.Logic.thunderTrampleMove;

    if v340 and (skillRunData and not skillRunData.clientLandFxDone) then
        playLandFootFx(p339, (Vector3.new(v340.endPos.X, v340.endPos.Y - v340.groundClearance - 1, v340.endPos.Z)));
        scheduleLandingPlayerStrikesIfNeeded(p339, v340, false);
    end;

    SkillCommon.disconnectRunEventKeys(p339.skillRunData, { "ThunderTrampleMove" });
end;

function u5.Server_EnterMovement(u341) -- Line: 1251
    -- upvalues: SkillCommon (copy), commitMovePlan (copy), lockCharacterForSkillMove (copy), pulseJumpStrikeHitboxAtGround (copy), sampleMoveCF (copy), RunService (copy), LEAP_PHASE_MOVE (copy), snapCharacterToMoveEnd (copy), SkillEventConst (copy), scheduleLandingPlayerStrikesIfNeeded (copy)
    local v342 = u341.skillInputData and u341.skillInputData.character;

    if not v342 then
        return;
    end;

    SkillCommon.disconnectRunEventKeys(u341.skillRunData, { "ThunderTrampleStartupFace" });
    local skillRunData = u341.skillRunData;
    skillRunData.Logic = skillRunData.Logic or {};
    local v343 = skillRunData.Logic.thunderTrampleMove or commitMovePlan(u341);

    if not v343 then
        return;
    end;

    v343.startedAt = u341.nowTime;
    skillRunData.Logic.thunderTrampleMove = v343;

    if not skillRunData.Logic.thunderTrampleMoveLock then
        skillRunData.Logic.thunderTrampleMoveLock = lockCharacterForSkillMove(v342);
    end;

    local HumanoidRootPart = v342:FindFirstChild("HumanoidRootPart");
    local Position = SkillCommon.getGroundCF(CFrame.new(v343.startPos), 4, 0.15, "Ground").Position;
    skillRunData.Logic.thunderTrampleJumpStrikePos = Position;
    local u344 = Vector3.new(25, 25, 25) * SkillCommon.npcSummonBodySkillScale(u341);

    for i = 2, 10 do
        local v345 = u341.hitbox[i];

        if v345 and v345.hitbox then
            v345.hitbox.Size = u344;
        end;
    end;

    if HumanoidRootPart then
        local runGeneration = u341.runGeneration;
        task.delay(1.2, function() -- Line: 543
            -- upvalues: SkillCommon (ref), u341 (copy), runGeneration (copy), pulseJumpStrikeHitboxAtGround (ref), Position (copy), u344 (copy)
            if not SkillCommon.isRunningSameGeneration(u341, runGeneration) then
                return;
            end;

            local v346 = u341.hitbox[2];

            if not v346 then
                return;
            end;

            pulseJumpStrikeHitboxAtGround(v346, Position, u344, 0.15, false);
        end);
        local Position2 = HumanoidRootPart.Position;
        local startPos = v343.startPos;
        local v347 = (Vector3.new(Position2.X, 0, Position2.Z) - Vector3.new(startPos.X, 0, startPos.Z)).Magnitude > 1.5 and u341.skillInputData.character;

        if v347 then
            v347:PivotTo((sampleMoveCF(v343, 0)));
        end;
    end;

    local u348 = false;
    local u349 = false;
    u341:BindStateConn("Movement", RunService.Heartbeat:Connect(function() -- Line: 1292
        -- upvalues: u341 (copy), skillRunData (copy), LEAP_PHASE_MOVE (ref), sampleMoveCF (ref), snapCharacterToMoveEnd (ref), SkillEventConst (ref), u348 (ref), SkillCommon (ref), u349 (ref), scheduleLandingPlayerStrikesIfNeeded (ref)
        if not u341:isRunningFlow() then
            return;
        end;

        local thunderTrampleMove = skillRunData.Logic.thunderTrampleMove;

        if not thunderTrampleMove or thunderTrampleMove.startedAt <= 0 then
            return;
        end;

        if (skillRunData.State and skillRunData.State.current) ~= "Movement" then
            return;
        end;

        local duration = thunderTrampleMove.duration;

        if duration <= 0 then
            duration = LEAP_PHASE_MOVE;
        end;

        local v350 = math.clamp((u341.nowTime - thunderTrampleMove.startedAt) / duration, 0, 1);
        local character = u341.skillInputData.character;

        if character then
            character:PivotTo((sampleMoveCF(thunderTrampleMove, v350)));
        end;

        if v350 >= 1 then
            snapCharacterToMoveEnd(u341, false);
            local thunderTrampleMoveLock = skillRunData.Logic.thunderTrampleMoveLock;

            if thunderTrampleMoveLock and thunderTrampleMoveLock.hrp.Parent then
                thunderTrampleMoveLock.hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
                thunderTrampleMoveLock.hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
            end;

            if not skillRunData.Logic.thunderTrampleMoveEndTriggered then
                skillRunData.Logic.thunderTrampleMoveEndTriggered = true;
                u341:TryTransition(SkillEventConst.StateTimeout, nil);
            end;
        end;

        if not u348 and v350 >= 0.92 then
            u348 = true;
            local v351 = u341.hitbox[1];

            if v351 and v351.hitbox then
                local v352 = SkillCommon.npcSummonBodySkillScale(u341);
                local hitbox = v351.hitbox;
                hitbox.Size = Vector3.new(25, 25, 25) * v352;
                hitbox:PivotTo(CFrame.new(thunderTrampleMove.endPos));

                if hitbox then
                    hitbox.Transparency = 1;
                end;

                v351:start();
            end;
        end;

        if not u349 and v350 >= 0.92 then
            u349 = true;
            scheduleLandingPlayerStrikesIfNeeded(u341, thunderTrampleMove, true);
        end;
    end));
end;

function u5.Server_ExitMovement(p353) -- Line: 1343
    -- upvalues: scheduleLandingPlayerStrikesIfNeeded (copy), snapCharacterToMoveEnd (copy)
    local v354 = p353.hitbox[1];

    if v354 and v354.isActive then
        v354:stop();
    end;

    local v355 = v354 and v354.hitbox and v354.hitbox;

    if v355 then
        v355.Transparency = 1;
    end;

    local v356 = p353.hitbox[2];

    if v356 and v356.isActive then
        v356:stop();
    end;

    local v357 = v356 and v356.hitbox and v356.hitbox;

    if v357 then
        v357.Transparency = 1;
    end;

    local skillRunData = p353.skillRunData;
    local v358 = skillRunData and skillRunData.Logic and skillRunData.Logic.thunderTrampleMove;

    if v358 then
        scheduleLandingPlayerStrikesIfNeeded(p353, v358, true);
    end;

    snapCharacterToMoveEnd(p353, true);
    local v359 = skillRunData and skillRunData.Logic and skillRunData.Logic.thunderTrampleMoveLock;

    if v359 and v359.hrp.Parent then
        v359.hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
        v359.hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
    end;
end;

function u5.Server_EnterRecovery(u360) -- Line: 1373
    -- upvalues: SkillCommon (copy), ThunderLeapTiming (copy), UtilsSystem (copy), AnimationModule (copy), serverPlayPauseWalkAnim (copy), serverStartRecoveryFaceRotation (copy), snapCharacterToMoveEnd (copy), restoreCharacterMoveState (copy), SkillEventConst (copy)
    SkillCommon.disconnectRunEventKeys(u360.skillRunData, { "ThunderTrampleMove" });
    local skillRunData = u360.skillRunData;
    local v361 = skillRunData and skillRunData.Logic and skillRunData.Logic.thunderTrampleMove;
    local v362;

    if v361 then
        local duration = v361.duration;
        local v363 = math.max(1.2, duration * 0.92 + 1.2) - duration + 0.15 + 0.05;
        v362 = v361.phases.recovery + math.max(0, v363);
    else
        v362 = ThunderLeapTiming.LEAP_PHASE_RECOVERY;
    end;

    local v364 = u360.character or u360.skillInputData and u360.skillInputData.character;

    if v364 and v361 then
        local endPos = v361.endPos;
        v364:PivotTo(CFrame.new(endPos) * v364:GetPivot().Rotation);
        local v365 = UtilsSystem.SystemEnemy.getPackByModel(v364);

        if not v365 and UtilsSystem.SystemSummon.getPackByModel then
            v365 = UtilsSystem.SystemSummon.getPackByModel(v364);
        end;

        if v365 then
            v365 = v365.entity;
        end;

        if v365 then
            v365.pos = endPos;
            v365.lastPos = endPos;
        end;

        local v366 = u360.character or u360.skillInputData and u360.skillInputData.character;
        local v367;

        if v366 then
            local v368 = v366:FindFirstChildOfClass("Humanoid");

            if v368 then
                v367 = v368:FindFirstChildOfClass("Animator");
            else
                v367 = nil;
            end;
        else
            v367 = nil;
        end;

        if v367 then
            AnimationModule.StopAnim(v367, "雷跃", 0.1);
        end;

        serverPlayPauseWalkAnim(u360);
        serverStartRecoveryFaceRotation(u360, v361, endPos, v362);
    else
        local skillRunData2 = u360.skillRunData;

        if skillRunData2 and skillRunData2.Logic and skillRunData2.Logic.thunderTrampleMove then
            snapCharacterToMoveEnd(u360);
            local thunderTrampleMoveLock = skillRunData2.Logic.thunderTrampleMoveLock;

            if thunderTrampleMoveLock and thunderTrampleMoveLock.hrp.Parent then
                thunderTrampleMoveLock.hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
                thunderTrampleMoveLock.hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
            end;
        end;
    end;

    local runGeneration = u360.runGeneration;
    task.delay(v362, function() -- Line: 1393
        -- upvalues: SkillCommon (ref), u360 (copy), runGeneration (copy), restoreCharacterMoveState (ref), SkillEventConst (ref)
        if not SkillCommon.isRunningSameGeneration(u360, runGeneration) then
            return;
        end;

        if u360.GetCurrentState and u360:GetCurrentState() == "Recovery" then
            restoreCharacterMoveState(u360);
            u360:TryTransition(SkillEventConst.StateTimeout, nil);
        end;
    end);
end;

function u5.Server_ExitRecovery(p369) -- Line: 1404
    -- upvalues: SkillCommon (copy), AnimationModule (copy), restoreCharacterMoveState (copy)
    SkillCommon.disconnectRunEventKeys(p369.skillRunData, { "ThunderTrampleRecoveryFace" });
    local v370 = p369.character or p369.skillInputData and p369.skillInputData.character;
    local v371;

    if v370 then
        local v372 = v370:FindFirstChildOfClass("Humanoid");

        if v372 then
            v371 = v372:FindFirstChildOfClass("Animator");
        else
            v371 = nil;
        end;
    else
        v371 = nil;
    end;

    if v371 then
        AnimationModule.StopAnim(v371, "独角兽行走异形骨骼", 0.1);
    end;

    restoreCharacterMoveState(p369);
end;

function u5.Client_EnterRecovery(p373) -- Line: 1410
    -- upvalues: SkillCommon (copy)
    SkillCommon.disconnectRunEventKeys(p373.skillRunData, { "ThunderTrampleMove" });
end;

function u5.onEnd(p374) -- Line: 1414
    -- upvalues: SkillCommon (copy)
    local skillRunData = p374.skillRunData;

    if skillRunData then
        SkillCommon.clearRunSpawnList(skillRunData, "ThunderTrampleSpawned");
    end;
end;

u5.SoundList = { "音效-技能-雷系普攻", "音效-技能-独角兽-跳跃落地", "音效-技能-独角兽-预警", "音效-技能-独角兽-打雷1", "音效-技能-独角兽-打雷2", "音效-技能-独角兽-打雷3", "音效-技能-独角兽-打雷4", "音效-技能-独角兽-打雷5", "音效-技能-独角兽-打雷6", "音效-技能-独角兽-打雷7", "音效-技能-独角兽-打雷8", "音效-技能-独角兽-打雷9" };
u5.AnimateList = { "雷跃", "独角兽行走异形骨骼" };
u5.ResNameList = { "雷跃起跳", "雷跃落地", "独角兽落雷地面特效", "独角兽落雷", "独角兽落雷预警" };
u5.hitboxConfig = {};

for i = 1, 10 do
    u5.hitboxConfig[i] = {
        PartName = "通用球",
        CollisionGroup = "Player",
        HitPresentationProfile = "通用受击",
        PhysicsEffectName = "通用受击物理效果",
        HitboxIndex = i
    };
end;

u5.Action = {
    {
        action = "Animation",
        startTime = 0,
        animationName = "雷跃",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        overTime = u4,
        animationPriority = Enum.AnimationPriority.Action4
    }
};

function u5.computeMoveDuration(p375) -- Line: 1462
    -- upvalues: ThunderLeapTiming (copy)
    return ThunderLeapTiming.computeMovePhaseDuration(p375);
end;

function u5.computeLeapPhases(p376) -- Line: 1466
    -- upvalues: ThunderLeapTiming (copy)
    return ThunderLeapTiming.computeFromHorizDist(p376);
end;

function u5.estimateSkillTotalDuration(p377) -- Line: 1470
    -- upvalues: ThunderLeapTiming (copy), u4 (copy)
    if not p377 then
        return u4;
    end;

    local v378 = ThunderLeapTiming.computeFromHorizDist(p377);
    local move = v378.move;
    local v379 = math.max(1.2, 0.92 * move + 1.2) - move + 0.15 + 0.05;

    return v378.total + math.max(0, v379);
end;

return u5;