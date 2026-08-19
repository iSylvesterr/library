-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local GetData = UtilsSystem.GetData;
local CfgFind = UtilsSystem.CfgFind;
local EnumMgr = UtilsSystem.EnumMgr;
local RayCast = UtilsSystem.RayCast;
local SoundModule = UtilsSystem.SoundModule;
local FXUtil = UtilsSystem.FXUtil;
local Players = UtilsSystem.Players;
local ProjectileObjectTracking = require(script.Parent.Projectile.ProjectileObjectTracking);
local SkillReleaseCrossCheck = require(script.Parent.Parent.Parent.GroupSkill.SkillReleaseCrossCheck);
local TweenService = game:GetService("TweenService");
local u1 = {};
local PlayerAimSync = require(script.Parent.Parent.Parent.BaseSkill.PlayerAimSync);

function u1.isLocalPlayerCaster(p2) -- Line: 31
    -- upvalues: UtilsSystem (copy)
    local LocalPlayer = UtilsSystem.LocalPlayer;

    if p2 and (LocalPlayer and p2.characterType == "Player") then
        return p2.characterId == LocalPlayer.UserId;
    end;

    return false;
end;

function u1.isInDungeonChallenge(p3, p4) -- Line: 51
    -- upvalues: Players (copy), GetData (copy)
    if not p3 and p4 then
        p3 = Players:GetPlayerFromCharacter(p4);
    end;

    return GetData.IsInDungeonChallenge(p3) == true;
end;

function u1.isDungeonPassiveSkill(p5) -- Line: 66
    if type(p5) ~= "table" then
        return false;
    end;

    if type(p5.Data) == "table" then
        p5 = p5.Data;
    end;

    return (tonumber(p5.dungeonPassiveTp) or 0) > 0;
end;

function u1.scaleBandFromData(p6, p7) -- Line: 96
    -- upvalues: GetData (copy)
    return GetData.ScaleBandFromOpts(p7);
end;

function u1.scaleDualFromData(p8, p9) -- Line: 103
    -- upvalues: GetData (copy)
    return GetData.ScaleDualFromOpts(p9);
end;

function u1.skillScaleFromSkillData(p10) -- Line: 110
    -- upvalues: u1 (copy)
    return u1.scaleBandFromData(p10, u1.bandScaleOptsFromSkillData(p10));
end;

function u1.bandScaleOptsFromSkillData(p11) -- Line: 117
    -- upvalues: CfgFind (copy), EnumMgr (copy), GetData (copy)
    if p11 then
        p11 = p11.skillID;
    end;

    local v12 = tonumber(p11);

    if not v12 or v12 <= 0 then
        return {
            min = 1,
            max = 1
        };
    end;

    local v13 = CfgFind.FindCfgByID(v12, EnumMgr.ItemType.Skill);

    if not v13 then
        return {
            min = 1,
            max = 1
        };
    end;

    local v14, v15 = GetData.SkillConfSizeExtents(v13.Size);

    return v14 and {
        min = v14,
        max = v15 or v14
    } or {
        min = 1,
        max = 1
    };
end;

function u1.npcSummonBodySkillScale(p16) -- Line: 139
    -- upvalues: u1 (copy)
    return u1.scaleBandFromData(p16, u1.bandScaleOptsFromSkillData(p16));
end;

function u1.horizontalDistanceXZ(p17, p18) -- Line: 150
    local v19 = p17.X - p18.X;
    local v20 = p17.Z - p18.Z;

    return math.sqrt(v19 * v19 + v20 * v20);
end;

function u1.isWithinHorizReleaseRange(p21, p22, p23, p24) -- Line: 156
    -- upvalues: u1 (copy)
    return u1.horizontalDistanceXZ(p21, p22) <= p23 * p24;
end;

function u1.horizontalRingThreeWaypoints(p25, p26, p27, p28) -- Line: 164
    return Vector3.new(p25 + p28, p26, p27), Vector3.new(p25 + p28 * -0.4999999999999998, p26, p27 + p28 * 0.8660254037844387), Vector3.new(p25 + p28 * -0.5000000000000004, p26, p27 + p28 * -0.8660254037844384);
end;

function u1.horizontalOrbitCWSweepFromAngle(p29, p30, p31, p32, p33) -- Line: 182
    local v34 = p31 - p33 * p32;
    local v35 = p29.X + p30 * math.cos(v34);
    local Y = p29.Y;
    local v36 = p29.Z + p30 * math.sin(v34);

    return Vector3.new(v35, Y, v36);
end;

function u1.resolveCasterWorldPosForRange(p37) -- Line: 200
    if not p37 then
        return nil;
    end;

    local character = p37.character;

    if character then
        local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

        if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
            return HumanoidRootPart:GetPivot().Position;
        end;
    end;

    if p37.releaseCF then
        return p37.releaseCF.Position;
    end;

    return nil;
end;

local u38 = CFrame.new(0, 0, -3);

function u1.getHRPStartCF(p39, p40) -- Line: 230
    -- upvalues: u38 (copy)
    local v41 = p39.character or p39.skillInputData and p39.skillInputData.character;

    if not v41 then
        return p39.skillInputData.releaseCF;
    end;

    local HumanoidRootPart = v41:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart then
        return HumanoidRootPart:GetPivot():ToWorldSpace(p40 or u38);
    end;

    return p39.skillInputData.releaseCF;
end;

function u1.clampEndCF(p42, p43, p44, p45) -- Line: 250
    local Magnitude = (p42.Position - p43.Position).Magnitude;
    local v46 = math.min(Magnitude / p44, p45);

    if v46 * p44 < Magnitude then
        return CFrame.new(p42.Position + (p43.Position - p42.Position).Unit * v46 * p44) * p43.Rotation;
    end;

    return p43;
end;

function u1.clampProjectileEndFromSkillData(p47, p48, p49, p50) -- Line: 264
    -- upvalues: u1 (copy)
    if not p48 then
        local skillInputData = p47.skillInputData;

        if skillInputData then
            skillInputData = skillInputData.targetCF;
        end;

        return skillInputData;
    end;

    local skillInputData = p47.skillInputData;

    if skillInputData then
        skillInputData = skillInputData.targetCF;
    end;

    if skillInputData then
        return u1.clampEndCF(p48, skillInputData, p49, p50);
    end;

    return nil;
end;

function u1.getProjectileStartWindStyleCF(p51, p52, p53) -- Line: 281
    local skillInputData = p51.skillInputData;
    local character = p51.character;

    if not character then
        if skillInputData then
            character = skillInputData.character;
        else
            character = skillInputData;
        end;
    end;

    if not character then
        if skillInputData then
            skillInputData = skillInputData.releaseCF;
        end;

        return skillInputData;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        if skillInputData then
            skillInputData = skillInputData.releaseCF;
        end;

        return skillInputData;
    end;

    local v54 = HumanoidRootPart:GetPivot():ToWorldSpace(CFrame.new(0, 0, -p52)).Position + Vector3.new(0, p53 or 0, 0);

    if skillInputData then
        skillInputData = skillInputData.targetCF;
    end;

    if skillInputData then
        return CFrame.lookAt(v54, skillInputData.Position);
    end;

    return CFrame.new(v54) * HumanoidRootPart:GetPivot().Rotation;
end;

function u1.getGroundCF(p55, p56, p57, p58) -- Line: 313
    -- upvalues: RayCast (copy)
    local v59 = p57 or 0.15;
    local v60 = RayCast.RayCastDirection(p55.Position + Vector3.new(0, p56 or 4, 0), Vector3.new(0, -1, 0), 200, p58 or "Ground");

    if v60 then
        return CFrame.new(v60.Position + Vector3.new(0, v59, 0)) * p55.Rotation;
    end;

    return p55;
end;

function u1.casterFeetGroundWorldPos(p61, p62, p63, p64) -- Line: 328
    -- upvalues: u1 (copy)
    return u1.getGroundCF(CFrame.new(p61.Position), p62, p63, p64).Position;
end;

local u65 = CFrame.new(0, 1.4, -2);

function u1.formationCF(p66, p67, p68) -- Line: 350
    -- upvalues: u65 (copy)
    local Position = p66:GetPivot():ToWorldSpace(p68 or u65).Position;

    if p67 then
        return CFrame.lookAt(Position, p67) * CFrame.Angles(1.5707963267948966, 0, 0);
    end;

    local v69 = p66:GetPivot();
    local v70 = Vector3.new(v69.LookVector.X, 0, v69.LookVector.Z);

    return CFrame.lookAt(Position, Position + (v70.Magnitude < 0.08 and Vector3.new(0, 0, -1) or v70.Unit), Vector3.new(0, 1, 0)) * CFrame.Angles(1.5707963267948966, 0, 0);
end;

local function formationHorizontalPosAndFlat(p71, p72, p73) -- Line: 366
    -- upvalues: u65 (copy)
    local Position = p71:GetPivot():ToWorldSpace(p73 or u65).Position;
    local v74 = Vector3.new(p72.X, Position.Y, p72.Z) - Position;

    if v74.Magnitude >= 0.05 then
        return Position, v74.Unit;
    end;

    local v75 = p71:GetPivot();
    local v76 = Vector3.new(v75.LookVector.X, 0, v75.LookVector.Z);

    if v76.Magnitude < 0.08 then
        return Position, Vector3.new(0, 0, -1);
    end;

    return Position, v76.Unit;
end;

function u1.formationCFHorizontal(p77, p78, p79) -- Line: 385
    -- upvalues: formationHorizontalPosAndFlat (copy)
    local v80, v81 = formationHorizontalPosAndFlat(p77, p78, p79);

    return CFrame.lookAt(v80, v80 + v81, Vector3.new(0, 1, 0)) * CFrame.Angles(1.5707963267948966, 0, 0);
end;

function u1.horizontalAimCF(p82, p83, p84) -- Line: 394
    -- upvalues: formationHorizontalPosAndFlat (copy)
    local v85, v86 = formationHorizontalPosAndFlat(p82, p83, p84);

    return CFrame.lookAt(v85, v85 + v86, Vector3.new(0, 1, 0));
end;

function u1.formationHorizontalAnchorPos(p87, p88, p89) -- Line: 402
    -- upvalues: formationHorizontalPosAndFlat (copy)
    local v90, _ = formationHorizontalPosAndFlat(p87, p88, p89);

    return v90;
end;

function u1.horizontalFlatFormationToStrike(p91, p92, p93) -- Line: 410
    -- upvalues: formationHorizontalPosAndFlat (copy)
    local _, v94 = formationHorizontalPosAndFlat(p91, p92, p93);

    return v94;
end;

function u1.horizontalHrpStrikeFlatBasis(p95, p96) -- Line: 419
    local v97 = Vector3.new(p96.X - p95.Position.X, 0, p96.Z - p95.Position.Z);

    if v97.Magnitude < 0.08 then
        local LookVector = p95.CFrame.LookVector;
        v97 = Vector3.new(LookVector.X, 0, LookVector.Z);
    end;

    local Unit = (v97.Magnitude < 0.08 and Vector3.new(0, 0, -1) or v97.Unit):Cross(Vector3.new(0, 1, 0)).Unit;

    return Unit, (Vector3.new(0, 1, 0)):Cross(Unit).Unit;
end;

function u1.dnaTwinHelixWorldPositions(p98, p99, p100, p101, p102, p103, p104, p105) -- Line: 449
    local v106 = math.clamp(p105 == nil and 0.083 or p105, 0.001, 1);
    local v107 = math.clamp(p100, 0, 1);
    local v108 = p98:Lerp(p99, v107);
    local v109 = p104 * 2 * 3.141592653589793 * v107;

    if 1 - v106 < v107 then
        p103 = p103 * (1 - math.clamp((v107 - (1 - v106)) / v106, 0, 1));
    end;

    local v110 = p103 * (math.cos(v109) * p101 + math.sin(v109) * p102);
    local v111 = p103 * (math.cos(v109 + 3.141592653589793) * p101 + math.sin(v109 + 3.141592653589793) * p102);

    return v108 + v110, v108 + v111;
end;

function u1.resolveTrackPos(p112, p113) -- Line: 488
    -- upvalues: ProjectileObjectTracking (copy)
    local trackTargetId = p112.trackTargetId;

    return trackTargetId ~= nil and trackTargetId ~= "" and ProjectileObjectTracking.getWorldPositionByTrackTargetId(trackTargetId) or p113;
end;

function u1.resolveStrikeWorldPos(p114) -- Line: 502
    -- upvalues: u1 (copy)
    return not p114 and Vector3.new(0, 0, 0) or u1.resolveTrackPos(p114, not p114.targetCF and Vector3.new(0, 0, 0) or p114.targetCF.Position);
end;

function u1.refreshSkillAimSnapshot(p115) -- Line: 519
    -- upvalues: u1 (copy), PlayerAimSync (copy)
    if not p115 then
        return;
    end;

    if p115.characterType == "Mirror" then
        local skillInputData = p115.skillInputData;

        if skillInputData then
            skillInputData.targetCF = CFrame.new(u1.resolveStrikeWorldPos(skillInputData));
        end;

        return;
    end;

    if type(p115.getTargetCF) == "function" then
        PlayerAimSync.refreshAimSnapshot(p115);
    end;

    if p115.characterType == "Player" then
        return;
    end;

    local skillInputData = p115.skillInputData;

    if not skillInputData then
        return;
    end;

    skillInputData.targetCF = p115:getTargetCF();
end;

function u1.resolveSkillRayOriginWorldPos(p116) -- Line: 552
    -- upvalues: u1 (copy)
    if not p116 then
        return nil;
    end;

    local character = p116.character;
    local v117 = u1.resolveWandTipFromCharacter(character);
    local v118 = u1.resolveWandTipWorldCFrame(v117);

    if v118 then
        return v118.Position;
    end;

    if character then
        local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

        if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
            return HumanoidRootPart.Position;
        end;
    end;

    if p116.releaseCF then
        return p116.releaseCF.Position;
    end;

    return nil;
end;

function u1.resolveStrikeWorldPosWithObstruction(p119, p120, p121) -- Line: 580
    -- upvalues: u1 (copy)
    local v122 = u1.resolveStrikeWorldPos(p119);
    local v123 = p120 or u1.resolveSkillRayOriginWorldPos(p119);

    if not v123 then
        return v122;
    end;

    local v124 = v122 - v123;

    if v124.Magnitude < 0.0001 then
        return v122;
    end;

    local v125 = RaycastParams.new();
    v125.FilterType = Enum.RaycastFilterType.Blacklist;
    local v126 = {};
    local character = p119.character;

    if character then
        table.insert(v126, character);
    end;

    if p121 then
        p121 = p121.extraIgnore;
    end;

    if p121 then
        for _, v in p121 do
            if typeof(v) == "Instance" then
                table.insert(v126, v);
            end;
        end;
    end;

    v125.FilterDescendantsInstances = v126;
    v125.IgnoreWater = true;
    local v127 = workspace:Raycast(v123, v124, v125);

    if v127 then
        return v127.Position;
    end;

    return v122;
end;

function u1.resolveStrikeAnchorPosThroughFriendly(p128, p129, p130) -- Line: 627
    -- upvalues: u1 (copy)
    local FriendlyRayUtil = require(script.Parent.Parent.Parent.BaseSkill.FriendlyRayUtil);
    local v131 = u1.resolveSkillRayOriginWorldPos(p128);

    if not v131 then
        return p129;
    end;

    local v132 = {};
    local character = p128.character;

    if character then
        table.insert(v132, character);
    end;

    local v133;

    if p130 then
        v133 = p130.extraIgnore;
    else
        v133 = p130;
    end;

    if v133 then
        for _, v in v133 do
            if typeof(v) == "Instance" then
                table.insert(v132, v);
            end;
        end;
    end;

    local v134;

    if p130 then
        v134 = p130.casterId;
    else
        v134 = p130;
    end;

    if p130 then
        p130 = p130.casterType;
    end;

    if v134 == nil or (p130 == nil or p130 == "") then
        return u1.resolveStrikeWorldPosWithObstruction(p128, v131, {
            extraIgnore = v132
        });
    end;

    return FriendlyRayUtil.resolvePositionThroughFriendly(v131, p129, {
        id = v134,
        type = p130
    }, {
        ignoreWater = true,
        extraIgnore = v132
    });
end;

local function buildMoveRayIgnoreList(p135, p136) -- Line: 694
    local v137 = {};

    if p135 then
        table.insert(v137, p135);
    end;

    if p136 then
        for _, v in p136 do
            if typeof(v) == "Instance" then
                table.insert(v137, v);
            end;
        end;
    end;

    return v137;
end;

local function castMoveProbeRay(p138, p139, p140, p141, p142) -- Line: 714
    -- upvalues: RayCast (copy), buildMoveRayIgnoreList (copy)
    local v143;

    if p142 then
        v143 = p142.rayTag;
    else
        v143 = p142;
    end;

    if v143 and v143 ~= "" then
        return RayCast.RayCastDirection(p138, p139, p140, v143);
    end;

    local v144 = RaycastParams.new();
    v144.FilterType = Enum.RaycastFilterType.Blacklist;

    if p142 then
        p142 = p142.extraIgnore;
    end;

    v144.FilterDescendantsInstances = buildMoveRayIgnoreList(p141, p142);
    v144.IgnoreWater = true;

    return workspace:Raycast(p138, p139.Unit * p140, v144);
end;

function u1.probeMoveEndpointGroundFromAbove(p145, p146, p147, p148) -- Line: 736
    -- upvalues: castMoveProbeRay (copy)
    local v149 = p148 and (p148.probeDownStuds or 100) or 100;
    local v150 = p148 and (p148.minGroundNormalY or 0.35) or 0.35;
    local v151 = p148 and (p148.groundLift or 0) or 0;
    local v152 = castMoveProbeRay(Vector3.new(p145.X, p146 + (p148 and (p148.probeUpStuds or 50) or 50), p145.Z), Vector3.new(0, -1, 0), v149, p147, p148);

    if not v152 then
        return nil;
    end;

    if v152.Normal.Y < v150 then
        return nil;
    end;

    return Vector3.new(v152.Position.X, v152.Position.Y + v151, v152.Position.Z);
end;

function u1.probeGroundYAtWorldPos(p153, p154, p155) -- Line: 761
    -- upvalues: u1 (copy)
    local v156 = u1.probeMoveEndpointGroundFromAbove(p153, p153.Y, p154, p155);

    return v156 and v156.Y or nil;
end;

local function isLowVisualSprayObstruction(p157, p158, p159) -- Line: 773
    return p158.Position.Y < p157 - p159;
end;

local function castHorizontalWallRayWithLowVisualPass(p160, p161, p162, p163, p164) -- Line: 777
    -- upvalues: castMoveProbeRay (copy)
    local v165 = {};
    local v166;

    if p164 then
        v166 = p164.rayTag;
    else
        v166 = p164;
    end;

    v165.rayTag = v166;
    local v167;

    if p164 then
        v167 = p164.extraIgnore;
    else
        v167 = p164;
    end;

    v165.extraIgnore = v167;

    if p164 then
        p164 = p164.lowVisualClearStuds;
    end;

    if not p164 or p164 <= 0 then
        return castMoveProbeRay(p160, p161 * p162, p162, p163, v165);
    end;

    local v168 = p160;

    for _ = 1, 12 do
        if p162 < 0.001 then
            return nil;
        end;

        local v169 = castMoveProbeRay(v168, p161 * p162, p162, p163, v165);

        if not v169 then
            return nil;
        end;

        if v169.Position.Y >= p160.Y - p164 then
            return v169;
        end;

        local v170 = (v169.Position - v168):Dot(p161) + 0.12;

        if v170 <= 0.01 or p162 - 0.01 <= v170 then
            return nil;
        end;

        v168 = v168 + p161 * v170;
        p162 = p162 - v170;
    end;

    return nil;
end;

function u1.clampHorizontalMoveEndByWallRay(p171, p172, p173, p174) -- Line: 821
    -- upvalues: castHorizontalWallRayWithLowVisualPass (copy)
    local v175 = p174 and (p174.wallBackoffStuds or 3) or 3;
    local v176 = p174 and (p174.minHorizontalMoveStuds or 2) or 2;
    local v177 = Vector3.new(p172.X - p171.X, 0, p172.Z - p171.Z);
    local Magnitude = v177.Magnitude;

    if Magnitude < 0.001 then
        return nil, false;
    end;

    local v178 = v177 / Magnitude;
    local v179 = Vector3.new(p172.X, p171.Y, p172.Z);
    local v180 = castHorizontalWallRayWithLowVisualPass(p171, v178, Magnitude, p173, p174);
    local v181;

    if v180 then
        v179 = v180.Position - v178 * v175;
        v181 = true;
    else
        v181 = false;
    end;

    if Vector3.new(v179.X - p171.X, 0, v179.Z - p171.Z):Dot(v178) < v176 then
        return nil, v181;
    end;

    return Vector3.new(v179.X, p172.Y, v179.Z), v181;
end;

function u1.resolveBodyWallBackoffStuds(p182, p183) -- Line: 859
    local v184 = p183 or 3;

    if not p182 then
        return v184;
    end;

    local v185 = math.max(p182.Size.X, p182.Size.Z) * 0.55 + 0.5;

    return math.max(v184, v185);
end;

function u1.isHorizontalMoveEndpointFeasible(p186, p187, p188, p189) -- Line: 870
    -- upvalues: u1 (copy)
    return u1.clampHorizontalMoveEndByWallRay(p186, p187, p188, p189);
end;

function u1.resolveMoveEndpointWorldPos(p190, p191, p192, p193) -- Line: 883
    -- upvalues: u1 (copy)
    local v194, _ = u1.clampHorizontalMoveEndByWallRay(p190, p191, p192, p193);

    if not v194 then
        return nil;
    end;

    local v195 = math.max(p190.Y, p191.Y, v194.Y);
    local v196 = {};
    local v197;

    if p193 then
        v197 = p193.probeUpStuds;
    else
        v197 = p193;
    end;

    v196.probeUpStuds = v197;
    local v198;

    if p193 then
        v198 = p193.probeDownStuds;
    else
        v198 = p193;
    end;

    v196.probeDownStuds = v198;
    local v199;

    if p193 then
        v199 = p193.minGroundNormalY;
    else
        v199 = p193;
    end;

    v196.minGroundNormalY = v199;
    local v200;

    if p193 then
        v200 = p193.maxDropBelowStartStuds;
    else
        v200 = p193;
    end;

    v196.maxDropBelowStartStuds = v200;
    local v201;

    if p193 then
        v201 = p193.groundLift;
    else
        v201 = p193;
    end;

    v196.groundLift = v201;
    local v202;

    if p193 then
        v202 = p193.rayTag;
    else
        v202 = p193;
    end;

    v196.rayTag = v202;
    local v203;

    if p193 then
        v203 = p193.extraIgnore;
    else
        v203 = p193;
    end;

    v196.extraIgnore = v203;
    local v204 = u1.probeMoveEndpointGroundFromAbove(v194, v195, p192, v196);

    if not v204 then
        return nil;
    end;

    local v205 = p193 and p193.maxDropBelowStartStuds or 30;
    local v206 = u1.probeGroundYAtWorldPos(p190, p192, v196) or p190.Y;

    if v204.Y < v206 - v205 then
        return nil;
    end;

    return v204;
end;

function u1.hrpTopWorldY(p207) -- Line: 921
    return p207.Position.Y + p207.Size.Y * 0.5;
end;

function u1.resolveStrikeGroundWorldPos(p208, p209, p210, p211) -- Line: 928
    -- upvalues: u1 (copy)
    local v212 = u1.resolveStrikeWorldPos(p208);

    return u1.getGroundCF(CFrame.new(v212), p209, p210, p211).Position;
end;

function u1.resolveStruckTargetGroundWorldPos(p213, p214, p215, p216) -- Line: 937
    -- upvalues: u1 (copy)
    local v217 = u1.resolveTrackTargetHrp(p213);

    if v217 then
        return u1.getGroundCF(CFrame.new(v217.Position), p214, p215, p216).Position;
    end;

    return u1.resolveStrikeGroundWorldPos(p213, p214, p215, p216);
end;

function u1.resolveTrackTargetHrp(p218) -- Line: 948
    -- upvalues: ProjectileObjectTracking (copy)
    if not p218 or (p218.trackTargetId == nil or p218.trackTargetId == "") then
        return nil;
    end;

    local v219 = ProjectileObjectTracking.findModelByTrackTargetId(p218.trackTargetId);

    if not (v219 and v219.Parent) then
        return nil;
    end;

    local HumanoidRootPart = v219:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
        return HumanoidRootPart;
    end;

    return nil;
end;

function u1.resolveTargetHeadPart(p220) -- Line: 985
    for _, v in { "Head", "head", "头" } do
        local v221 = p220:FindFirstChild(v, true);

        if v221 and v221:IsA("BasePart") then
            return v221;
        end;
    end;

    local HumanoidRootPart = p220:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
        return HumanoidRootPart;
    end;

    if p220.PrimaryPart then
        return p220.PrimaryPart;
    end;

    return nil;
end;

function u1.horizontalFlatBackFromPart(p222) -- Line: 1005
    local LookVector = p222.CFrame.LookVector;
    local v223 = Vector3.new(-LookVector.X, 0, -LookVector.Z);

    return v223.Magnitude < 0.05 and Vector3.new(0, 0, 1) or v223.Unit;
end;

function u1.resolveStrikeHeadAnchor(p224, p225) -- Line: 1017
    -- upvalues: ProjectileObjectTracking (copy), u1 (copy)
    local v226 = Vector3.new(0, 0, 1);

    if p224 and (p224.trackTargetId ~= nil and p224.trackTargetId ~= "") then
        local v227 = ProjectileObjectTracking.findModelByTrackTargetId(p224.trackTargetId);
        local v228 = v227 and v227.Parent and u1.resolveTargetHeadPart(v227);

        if v228 then
            return {
                manualStrike = nil,
                head = v228,
                flatBack = u1.horizontalFlatBackFromPart(v228)
            };
        end;
    end;

    if p225 then
        u1.refreshSkillAimSnapshot(p225);
    end;

    local v229 = not p224 and Vector3.new(0, 0, 0) or u1.resolveStrikeWorldPos(p224);

    if p224 then
        p224 = p224.character;
    end;

    if p224 then
        p224 = p224:FindFirstChild("HumanoidRootPart");
    end;

    if p224 then
        local _, v230 = u1.horizontalHrpStrikeFlatBasis(p224, v229);
        v226 = -v230;
    end;

    return {
        head = nil,
        manualStrike = v229,
        flatBack = v226
    };
end;

function u1.resolveStrikeHeadAnchorLive(p231, p232) -- Line: 1054
    -- upvalues: ProjectileObjectTracking (copy), u1 (copy)
    local v233 = Vector3.new(0, 0, 1);

    if p231 and (p231.trackTargetId ~= nil and p231.trackTargetId ~= "") then
        local v234 = ProjectileObjectTracking.findModelByTrackTargetId(p231.trackTargetId);

        if v234 and v234.Parent then
            local v235 = u1.resolveTargetHeadPart(v234);

            if v235 and v235.Parent then
                return {
                    manualStrike = nil,
                    head = v235,
                    flatBack = u1.horizontalFlatBackFromPart(v235)
                };
            end;
        end;

        local v236 = u1.resolveTrackTargetHrp(p231);

        if v236 and v236.Parent then
            return {
                manualStrike = nil,
                head = v236,
                flatBack = u1.horizontalFlatBackFromPart(v236)
            };
        end;
    end;

    local v237 = Vector3.new(0, 0, 0);

    if p231 and p231.targetCF then
        v237 = p231.targetCF.Position;
    elseif p231 then
        v237 = u1.resolveStrikeWorldPos(p231);
    end;

    if p232 then
        local _, v238 = u1.horizontalHrpStrikeFlatBasis(p232, v237);
        v233 = -v238;
    end;

    return {
        head = nil,
        manualStrike = v237,
        flatBack = v233
    };
end;

function u1.strikeHeadAnchorTargetPos(p239) -- Line: 1097
    return not p239.head and (p239.manualStrike or Vector3.new(0, 0, 0)) or p239.head.Position;
end;

function u1.strikeHeadAnchorPosBehind(p240, p241, p242) -- Line: 1107
    -- upvalues: u1 (copy)
    if p240.head then
        local v243 = u1.horizontalFlatBackFromPart(p240.head);
        local v244 = p240.head.Position + v243 * (p241 * p242);

        return Vector3.new(v244.X, p240.head.Position.Y, v244.Z);
    end;

    local v245 = p240.manualStrike or Vector3.new(0, 0, 0);
    local v246 = v245 + p240.flatBack * (p241 * p242);

    return Vector3.new(v246.X, v245.Y, v246.Z);
end;

function u1.strikeHeadAnchorBasisRot(p247) -- Line: 1121
    if p247.head then
        return p247.head.CFrame.Rotation;
    end;

    local v248 = p247.manualStrike or Vector3.new(0, 0, 0);
    local v249 = -p247.flatBack;

    if v249.Magnitude < 0.05 then
        return CFrame.identity;
    end;

    return CFrame.lookAt(v248, v248 + v249.Unit, Vector3.new(0, 1, 0)).Rotation;
end;

function u1.composeHammerWorldRotFromRefEnemy(p250, p251, p252) -- Line: 1137
    local v253 = CFrame.Angles(math.rad(p252.X), math.rad(p252.Y), (math.rad(p252.Z)));
    local v254 = CFrame.Angles(math.rad(p251.X), math.rad(p251.Y), (math.rad(p251.Z)));

    return p250 * v253:Inverse() * v254;
end;

function u1.pivotModelAtStrikeAnchorHammerOri(p255, p256, p257, p258, p259) -- Line: 1158
    -- upvalues: u1 (copy)
    local v260 = u1.strikeHeadAnchorBasisRot(p257);
    local v261 = u1.composeHammerWorldRotFromRefEnemy(v260, p258, p259);
    p255:PivotTo(CFrame.new(p256) * v261);
end;

function u1.resolveCasterFeetFormationCF(p262, p263, p264) -- Line: 1173
    -- upvalues: u1 (copy)
    local v265 = not (p264 and p264.extraLift) and 0.5 or p264.extraLift;
    local v266 = u1.casterFeetGroundWorldPos(p262, not (p264 and p264.rayUp) and 4 or p264.rayUp, not (p264 and p264.lift) and 0.5 or p264.lift, not (p264 and p264.rayTag) and "Ground" or p264.rayTag) + Vector3.new(0, v265, 0);
    local LookVector = p262.CFrame.LookVector;
    local v267 = Vector3.new(LookVector.X, 0, LookVector.Z);

    if v267.Magnitude > 0.05 then
        return CFrame.lookAt(v266, v266 + v267.Unit) * p263;
    end;

    return CFrame.new(v266) * p263;
end;

function u1.pivotModelAtPosEulerDeg(p268, p269, p270) -- Line: 1194
    p268:PivotTo(CFrame.new(p269) * CFrame.Angles(math.rad(p270.X), math.rad(p270.Y), (math.rad(p270.Z))));
end;

function u1.pulseSphereHitboxAtPos(u271, p272, p273, p274) -- Line: 1204
    if not (u271 and u271.hitbox) then
        return;
    end;

    local hitbox = u271.hitbox;
    hitbox.Size = p273;
    hitbox:PivotTo(CFrame.new(p272));
    u271:start();
    task.delay(p274 or 0.15, function() -- Line: 1218
        -- upvalues: u271 (copy)
        if u271.isActive then
            u271:stop();
        end;
    end);
end;

function u1.tweenRunDataVector3(u275, u276, u277, u278, u279, u280, u281, u282, p283) -- Line: 1228
    -- upvalues: u1 (copy), UtilsSystem (copy), TweenService (copy)
    if not (u276 and u276.runEvent) then
        return;
    end;

    u1.disconnectRunEventKeys(u276, { u278 });

    if u282 <= 0 then
        u276[u279] = u281;

        return;
    end;

    local u284;

    if p283 and p283.easingStyle then
        u284 = p283.easingStyle;
    else
        u284 = Enum.EasingStyle.Quad;
    end;

    local u285;

    if p283 and p283.easingDirection then
        u285 = p283.easingDirection;
    else
        u285 = Enum.EasingDirection.Out;
    end;

    local u286 = os.clock();
    u276.runEvent[u278] = UtilsSystem.RunService.Heartbeat:Connect(function() -- Line: 1250
        -- upvalues: u1 (ref), u275 (copy), u277 (copy), u276 (copy), u278 (copy), u286 (copy), u282 (copy), TweenService (ref), u284 (copy), u285 (copy), u279 (copy), u280 (copy), u281 (copy)
        if not u1.isRunningSameGeneration(u275, u277) then
            u1.disconnectRunEventKeys(u276, { u278 });

            return;
        end;

        local v287 = (os.clock() - u286) / u282;
        local v288 = math.clamp(v287, 0, 1);
        u276[u279] = u280:Lerp(u281, (TweenService:GetValue(v288, u284, u285)));

        if v288 >= 1 then
            u1.disconnectRunEventKeys(u276, { u278 });
        end;
    end);
end;

function u1.tweenModelScaleOnHeartbeat(u289, u290, u291, u292, u293, u294, u295, u296, u297) -- Line: 1267
    -- upvalues: u1 (copy), UtilsSystem (copy), TweenService (copy)
    if not (u290 and u290.runEvent) then
        return;
    end;

    u1.disconnectRunEventKeys(u290, { u292 });

    if u296 <= 0 then
        if u297 and u297.resultKey then
            u290[u297.resultKey] = u295;
        end;

        if u293.Parent then
            u293:ScaleTo(u295);
        end;

        return;
    end;

    local u298;

    if u297 and u297.easingStyle then
        u298 = u297.easingStyle;
    else
        u298 = Enum.EasingStyle.Quad;
    end;

    local u299;

    if u297 and u297.easingDirection then
        u299 = u297.easingDirection;
    else
        u299 = Enum.EasingDirection.Out;
    end;

    if u297 then
        u297 = u297.resultKey;
    end;

    local u300 = os.clock();
    u290.runEvent[u292] = UtilsSystem.RunService.Heartbeat:Connect(function() -- Line: 1295
        -- upvalues: u1 (ref), u289 (copy), u291 (copy), u293 (copy), u290 (copy), u292 (copy), u300 (copy), u296 (copy), TweenService (ref), u298 (copy), u299 (copy), u294 (copy), u295 (copy), u297 (copy)
        if not (u1.isRunningSameGeneration(u289, u291) and u293.Parent) then
            u1.disconnectRunEventKeys(u290, { u292 });

            return;
        end;

        local v301 = (os.clock() - u300) / u296;
        local v302 = math.clamp(v301, 0, 1);
        local v303 = TweenService:GetValue(v302, u298, u299);
        local v304 = u294 + (u295 - u294) * v303;

        if u297 then
            u290[u297] = v304;
        end;

        u293:ScaleTo(v304);

        if v302 >= 1 then
            u1.disconnectRunEventKeys(u290, { u292 });
        end;
    end);
end;

function u1.commitLockedStrike(p305, p306, p307) -- Line: 1330
    -- upvalues: u1 (copy)
    local skillRunData = p305.skillRunData;

    if not skillRunData.Logic then
        skillRunData.Logic = {};
    end;

    local v308 = skillRunData.Logic[p306];

    if v308 then
        return v308;
    end;

    local skillInputData = p305.skillInputData;
    local v309;

    if p307 then
        v309 = p307.rayUp;
    else
        v309 = p307;
    end;

    local v310;

    if p307 then
        v310 = p307.lift;
    else
        v310 = p307;
    end;

    if p307 then
        p307 = p307.rayTag;
    end;

    local v311 = u1.resolveStruckTargetGroundWorldPos(skillInputData, v309, v310, p307);
    local v312 = u1.resolveTrackTargetHrp(skillInputData);
    local v313;

    if v312 then
        v313 = v312.Position;
    else
        v313 = u1.resolveStrikeWorldPos(skillInputData);
    end;

    if skillInputData then
        skillInputData = skillInputData.character;
    end;

    if skillInputData then
        skillInputData = skillInputData:FindFirstChild("HumanoidRootPart");
    end;

    local v314, v315;

    if skillInputData then
        v314, v315 = u1.horizontalHrpStrikeFlatBasis(skillInputData, v311);
    else
        v314 = Vector3.new(1, 0, 0);
        v315 = Vector3.new(0, 0, -1);
    end;

    local v316 = {
        groundCenter = v311,
        hrpCenter = v313,
        right = v314,
        forward = v315
    };
    skillRunData.Logic[p306] = v316;

    return v316;
end;

function u1.worldPosPlusVerticalStuds(p317, p318, p319) -- Line: 1369
    return p317 + Vector3.new(0, p318 * p319, 0);
end;

function u1.setupBlockHitboxesAtCf(p320, p321, p322, p323) -- Line: 1376
    for i = 1, p321 do
        local v324 = p320[i];

        if v324 and v324.hitbox then
            local hitbox = v324.hitbox;

            if hitbox:IsA("BasePart") then
                hitbox.Shape = Enum.PartType.Block;
            end;

            hitbox.Size = p323;
            hitbox:PivotTo(p322);
        end;
    end;
end;

function u1.pulseBlockHitboxAtGroundPos(u325, p326, p327, p328) -- Line: 1393
    if not (u325 and u325.hitbox) then
        return;
    end;

    local hitbox = u325.hitbox;

    if hitbox:IsA("BasePart") then
        hitbox.Shape = Enum.PartType.Block;
    end;

    hitbox.Size = p327;
    local v329 = p326 + Vector3.new(0, p327.Y * 0.5, 0);
    hitbox:PivotTo(CFrame.new(v329));
    u325:start();
    task.delay(p328 or 0.15, function() -- Line: 1411
        -- upvalues: u325 (copy)
        if u325.isActive then
            u325:stop();
        end;
    end);
end;

function u1.resolveWandTipFromCharacter(p330) -- Line: 1421
    if not p330 then
        return nil;
    end;

    local v331 = p330:FindFirstChild("当前手持");

    if v331 then
        v331 = v331:FindFirstChildOfClass("Model");
    end;

    if v331 then
        return v331:FindFirstChild("魔杖尖端");
    end;

    return nil;
end;

function u1.resolveWandTipWorldCFrame(p332) -- Line: 1436
    if not p332 then
        return nil;
    end;

    if p332:IsA("BasePart") then
        return p332:GetPivot();
    end;

    if p332:IsA("Model") then
        return p332:GetPivot();
    end;

    if p332:IsA("Attachment") then
        return p332.WorldCFrame;
    end;

    return nil;
end;

function u1.disconnectRunEventKeys(p333, p334) -- Line: 1455
    if not (p333 and p333.runEvent) then
        return;
    end;

    local runEvent = p333.runEvent;

    for _, v in p334 do
        local v335 = runEvent[v];

        if v335 then
            v335:Disconnect();
            runEvent[v] = nil;
        end;
    end;
end;

function u1.connectRunEventWhile(u336, u337, p338, u339, u340) -- Line: 1472
    -- upvalues: u1 (copy)
    if not u336 then
        return;
    end;

    u1.disconnectRunEventKeys(u336, { u337 });
    u336.runEvent = u336.runEvent or {};
    u336.runEvent[u337] = p338:Connect(function(p341) -- Line: 1484
        -- upvalues: u339 (copy), u1 (ref), u336 (copy), u337 (copy), u340 (copy)
        if u339() then
            u340(p341);

            return;
        end;

        u1.disconnectRunEventKeys(u336, { u337 });
    end);
end;

function u1.flushPhase1AndRelease(p342) -- Line: 1501
    require(script.Parent.Parent.Parent.BaseSkill.SkillControlRuntime).update(p342.controlRuntime, p342.nowTime, p342);
    p342.isPhase1Complete = p342.controlRuntime.isPhase1Complete;

    if p342.releaseControl and not p342.controlRuntime.isControlReleased then
        p342:releaseControl();
    end;

    p342.isControlReleased = p342.controlRuntime.isControlReleased;
end;

function u1.dispatchBaseSkillStateTransition(p343, p344, p345) -- Line: 1512
    if not (p343.skillCastId and p343.baseSkillInstanceId) then
        return;
    end;

    local SkillSyncEventFactory = require(script.Parent.Parent.Parent.BaseSkill.SkillSyncEventFactory);
    local SkillSyncDispatcher = require(script.Parent.Parent.Parent.BaseSkill.SkillSyncDispatcher);
    local v346 = SkillSyncEventFactory.baseSkillStateTransitionFromSkill(p343, p344, p345);
    local v347 = p343.getCharacterPosition and p343:getCharacterPosition();
    SkillSyncDispatcher.dispatch(p343, "BaseSkillStateTransition", v346, v347);
end;

function u1.bindHumanoidJumpWhile(p348, p349, p350, u351) -- Line: 1527
    local skillRunData = p348.skillRunData;

    if not (skillRunData and p349) then
        return;
    end;

    if not skillRunData.runEvent then
        skillRunData.runEvent = {};
    end;

    skillRunData.runEvent[p350] = p349.StateChanged:Connect(function(p352, p353) -- Line: 1540
        -- upvalues: u351 (copy)
        if p353 == Enum.HumanoidStateType.Jumping then
            u351();
        end;
    end);
end;

local RunService = UtilsSystem.RunService;

function u1.scheduleWandTipElementTrail(u354, u355, u356) -- Line: 1564
    -- upvalues: RunService (copy), u1 (copy)
    local runGeneration = u354.runGeneration;
    local u357 = nil;
    local u358 = nil;

    local function stillTrail() -- Line: 1569
        -- upvalues: u354 (copy), runGeneration (copy)
        local v359 = u354:isRunningFlow() and u354.runGeneration == runGeneration;

        return v359;
    end;

    local function cleanupThisTrail() -- Line: 1573
        -- upvalues: u357 (ref), u358 (ref), u354 (copy), u356 (copy)
        if u357 then
            for _, descendant in pairs(u357:GetDescendants()) do
                if descendant:IsA("Trail") or descendant:IsA("ParticleEmitter") then
                    descendant.Enabled = false;
                end;
            end;
        end;

        if u358 then
            u358:Disconnect();
            u358 = nil;
        end;

        u357 = nil;
        local skillRunData = u354.skillRunData;

        if skillRunData and (skillRunData.runEvent and skillRunData.runEvent[u356.runEventKey]) then
            skillRunData.runEvent[u356.runEventKey] = nil;
        end;
    end;

    task.delay(u356.enableAt, function() -- Line: 1592
        -- upvalues: u354 (copy), runGeneration (copy), u356 (copy), u357 (ref), u358 (ref), RunService (ref), u355 (copy), u1 (ref)
        local v360 = u354:isRunningFlow() and u354.runGeneration == runGeneration;

        if not v360 then
            return;
        end;

        local skillRunData = u354.skillRunData;

        if not (skillRunData and skillRunData.material) then
            return;
        end;

        local v361 = skillRunData.material[u356.trailMaterialKey];

        if not v361 then
            return;
        end;

        u357 = v361;

        for _, descendant in pairs(v361:GetDescendants()) do
            if descendant:IsA("Trail") or descendant:IsA("ParticleEmitter") then
                descendant.Enabled = true;
            end;
        end;

        v361.Parent = workspace.Debris;

        if not skillRunData.runEvent then
            skillRunData.runEvent = {};
        end;

        u358 = RunService.RenderStepped:Connect(function() -- Line: 1614
            -- upvalues: u355 (ref), u357 (ref), u1 (ref)
            local v362 = u355.Parent and (u357 and u1.resolveWandTipWorldCFrame(u355));

            if v362 then
                u357:PivotTo(v362);
            end;
        end);
        skillRunData.runEvent[u356.runEventKey] = u358;
    end);

    if u356.disableAt then
        task.delay(u356.disableAt, function() -- Line: 1626
            -- upvalues: u354 (copy), runGeneration (copy), cleanupThisTrail (copy)
            if u354.runGeneration ~= runGeneration then
                return;
            end;

            cleanupThisTrail();
        end);
    end;
end;

function u1.cleanupWandTipTrailFromMaterial(p363, p364, p365) -- Line: 1638
    if not (p363 and p363.material) then
        return;
    end;

    local v366 = p363.material[p364];

    if v366 then
        for _, descendant in pairs(v366:GetDescendants()) do
            if descendant:IsA("Trail") or descendant:IsA("ParticleEmitter") then
                descendant.Enabled = false;
            end;
        end;
    end;

    local runEvent = p363.runEvent;

    if runEvent and runEvent[p365] then
        runEvent[p365]:Disconnect();
        runEvent[p365] = nil;
    end;
end;

function u1.pivotModelAtWorldPosKeepRotation(p367, p368) -- Line: 1660
    local Rotation = p367:GetPivot().Rotation;
    p367:PivotTo(CFrame.new(p368) * Rotation);
end;

function u1.pivotInstanceToWorldCF(p369, p370) -- Line: 1668
    if not p369 then
        return;
    end;

    if p369:IsA("Model") then
        p369:PivotTo(p370);

        return;
    end;

    if p369:IsA("BasePart") then
        p369.CFrame = p370;
    end;
end;

function u1.appendRunSpawnList(p371, p372, p373) -- Line: 1691
    if not p371 then
        return;
    end;

    p371[p372] = p371[p372] or {};
    table.insert(p371[p372], p373);
end;

function u1.removeFromRunSpawnList(p374, p375, p376) -- Line: 1699
    if not (p374 and p376) then
        return;
    end;

    local v377 = p374[p375];

    if not v377 then
        return;
    end;

    for i = #v377, 1, -1 do
        if v377[i] == p376 then
            table.remove(v377, i);
        end;
    end;

    if #v377 == 0 then
        p374[p375] = nil;
    end;
end;

function u1.returnPooledModelFromSpawnList(p378, p379, p380) -- Line: 1717
    -- upvalues: FXUtil (copy), u1 (copy)
    if not (p380 and p380:IsA("Model")) then
        return;
    end;

    FXUtil.ReturnPooledModelToPool(p380);
    u1.removeFromRunSpawnList(p378, p379, p380);
end;

function u1.returnAllRunSpawnListToPool(p381, p382) -- Line: 1725
    -- upvalues: u1 (copy)
    if not p381 then
        return;
    end;

    local v383 = p381[p382];

    if not v383 then
        return;
    end;

    local v384 = {};

    for _, v in v383 do
        if v and v:IsA("Model") then
            table.insert(v384, v);
        end;
    end;

    for _, v in v384 do
        u1.returnPooledModelFromSpawnList(p381, p382, v);
    end;

    p381[p382] = nil;
end;

function u1.clearRunSpawnList(p385, p386) -- Line: 1745
    if not p385 then
        return;
    end;

    local v387 = p385[p386];

    if not v387 then
        return;
    end;

    for _, v in v387 do
        if v and v.Parent then
            v:Destroy();
        end;
    end;

    p385[p386] = nil;
end;

function u1.scheduleRunSpawnClear(u388, u389, u390, u391, p392) -- Line: 1762
    -- upvalues: u1 (copy)
    task.delay(p392, function() -- Line: 1763
        -- upvalues: u388 (copy), u389 (copy), u390 (copy), u1 (ref), u391 (copy)
        if not u388 or (u388.runGeneration ~= u389 or not u390) then
            return;
        end;

        u1.clearRunSpawnList(u390, u391);
    end);
end;

function u1.clearSpawnIfTerminalAfterExit(u393, u394, u395, u396) -- Line: 1772
    -- upvalues: u1 (copy)
    task.defer(function() -- Line: 1773
        -- upvalues: u393 (copy), u394 (copy), u395 (copy), u1 (ref), u396 (copy)
        if not u393 or (u393.runGeneration ~= u394 or not u395) then
            return;
        end;

        if u393.isTerminal and u393:isTerminal() then
            u1.clearRunSpawnList(u395, u396);
        end;
    end);
end;

function u1.playSoundLocal3D(p397, p398) -- Line: 1793
    -- upvalues: SoundModule (copy)
    if not (p397 and p398) then
        return;
    end;

    if SoundModule then
        SoundModule:PlaySoundLocal({
            Is2D = false,
            SoundName = p397,
            PlayPosition = p398
        });
    end;
end;

function u1.playSoundLocal3DOnPart(p399, p400) -- Line: 1810
    -- upvalues: SoundModule (copy)
    if not (p399 and p400) then
        return;
    end;

    if SoundModule then
        SoundModule:PlaySoundLocal({
            Is2D = false,
            SoundName = p399,
            AttachPart = p400
        });
    end;
end;

function u1.resolveSkillCastSoundTag(p401) -- Line: 1826
    if not p401 then
        return nil;
    end;

    local skillInputData = p401.skillInputData;

    return p401.skillCastId or skillInputData and skillInputData.skillCastId or nil;
end;

function u1.resolveModelAttachPart(p402) -- Line: 1837
    if not p402 then
        return nil;
    end;

    if p402:IsA("BasePart") then
        return p402;
    end;

    if p402:IsA("Model") then
        return p402.PrimaryPart or p402:FindFirstChildWhichIsA("BasePart", true);
    end;

    return nil;
end;

function u1.playSoundLocal3DForSkill(p403, p404, p405, p406) -- Line: 1855
    -- upvalues: SoundModule (copy), u1 (copy)
    if p403 and p403.suppressSkillFx then
        return false;
    end;

    if not (p404 and (p405 and SoundModule)) then
        return false;
    end;

    local v407 = u1.resolveSkillCastSoundTag(p403);

    if not v407 then
        return false;
    end;

    local v408 = {
        Is2D = false,
        SoundName = p404,
        PlayPosition = p405,
        SoundTag = v407
    };

    if p406 == true then
        v408.Looped = true;
    end;

    SoundModule:PlaySoundLocal(v408);

    return true;
end;

function u1.playSoundLocal3DOnPartForSkill(p409, p410, p411, p412) -- Line: 1889
    -- upvalues: SoundModule (copy), u1 (copy)
    if p409 and p409.suppressSkillFx then
        return false;
    end;

    if not (p410 and (p411 and SoundModule)) then
        return false;
    end;

    local v413 = u1.resolveSkillCastSoundTag(p409);

    if not v413 then
        return false;
    end;

    local v414 = {
        Is2D = false,
        SoundName = p410,
        AttachPart = p411,
        SoundTag = v413
    };

    if p412 == true then
        v414.Looped = true;
    end;

    SoundModule:PlaySoundLocal(v414);

    return true;
end;

function u1.stopSoundLocalForSkill(p415, p416, p417) -- Line: 1922
    -- upvalues: SoundModule (copy), u1 (copy)
    if not (p416 and SoundModule) then
        return;
    end;

    local v418 = u1.resolveSkillCastSoundTag(p415);

    if not v418 then
        return;
    end;

    local v419 = {
        SoundName = p416,
        SoundTag = v418
    };

    if p417 and p417 > 0 then
        v419.FadeTime = p417;
    end;

    SoundModule:StopSoundLocal(v419);
end;

function u1.pickRandomSoundName(p420) -- Line: 1943
    if type(p420) == "table" and #p420 ~= 0 then
        return p420[math.random(1, #p420)];
    end;

    return nil;
end;

function u1.isRunningSameGeneration(p421, p422) -- Line: 1954
    local v423 = p421:isRunningFlow() and p421.runGeneration == p422;

    return v423;
end;

function u1.resolveSummonFormationCF(p424, p425, p426) -- Line: 1971
    -- upvalues: RayCast (copy)
    local v427 = p425 <= 0 and 1 or p425;
    local v428 = p426 and (p426.upOffsetStuds or 0) or 0;
    local v429 = p424:PointToWorldSpace((Vector3.new(0, 0, -(p426 and (p426.forwardOffsetStuds or 30) or 30) * v427))) + Vector3.new(0, v428 * v427, 0);

    if p426 and p426.groundRaycast == false then
        return p424.Rotation + v429;
    end;

    local v430 = p426 and p426.groundSurfaceLift or 0.2;
    local v431 = RayCast.RayCastDirection(v429, Vector3.new(0, -1, 0), p426 and (p426.groundRayLength or 100) or 100, "Ground");

    if v431 then
        return p424.Rotation + v431.Position + Vector3.new(0, v430, 0);
    end;

    return p424.Rotation + v429;
end;

local u432 = {};

local function ensureCrossCheckProvider(p433) -- Line: 2015
    -- upvalues: SkillReleaseCrossCheck (copy)
    if type(p433.checkOnOtherGroupSkillRelease) == "function" then
        SkillReleaseCrossCheck.registerProvider(p433);

        return true;
    end;

    warn("[SkillCommon] beginCrossCheck 需要 export checkOnOtherGroupSkillRelease");

    return false;
end;

function u1.beginCrossCheck(p434, p435) -- Line: 2028
    -- upvalues: SkillReleaseCrossCheck (copy), u432 (copy)
    if not p434 or type(p434.characterId) ~= "number" then
        return;
    end;

    local v436;

    if type(p435.checkOnOtherGroupSkillRelease) == "function" then
        SkillReleaseCrossCheck.registerProvider(p435);
        v436 = true;
    else
        warn("[SkillCommon] beginCrossCheck 需要 export checkOnOtherGroupSkillRelease");
        v436 = false;
    end;

    if not v436 then
        return;
    end;

    local v437 = u432[p435];

    if not v437 then
        v437 = {};
        u432[p435] = v437;
    end;

    v437[p434.characterId] = p434;
    SkillReleaseCrossCheck.registerActive(p434.characterId, p434, p435);
end;

function u1.endCrossCheck(p438, p439) -- Line: 2047
    -- upvalues: u432 (copy), SkillReleaseCrossCheck (copy)
    if not p438 or type(p438.characterId) ~= "number" then
        return;
    end;

    local v440 = u432[p439];

    if v440 and v440[p438.characterId] == p438 then
        v440[p438.characterId] = nil;
    end;

    SkillReleaseCrossCheck.unregisterActive(p438.characterId, p438);
end;

function u1.getCrossCheckSession(p441, p442) -- Line: 2059
    -- upvalues: u432 (copy)
    local v443 = u432[p441];

    if v443 then
        return v443[p442];
    end;

    return nil;
end;

function u1.cancelCrossCheckExcept(p444, p445, p446) -- Line: 2068
    -- upvalues: u1 (copy)
    local v447 = u1.getCrossCheckSession(p444, p445);

    if not v447 or v447 == p446 then
        return;
    end;

    if not (v447.isRunningFlow and v447:isRunningFlow()) then
        return;
    end;

    if v447.stop then
        v447:stop();

        return;
    end;

    if v447.TryTransition then
        v447:TryTransition("ForceFinish", nil);
    end;
end;

function u1.clearCrossCheckCharacter(p448) -- Line: 2084
    -- upvalues: u432 (copy), SkillReleaseCrossCheck (copy)
    if type(p448) ~= "number" then
        return;
    end;

    for _, v in pairs(u432) do
        v[p448] = nil;
    end;

    SkillReleaseCrossCheck.clearCharacter(p448);
end;

function u1.findDescendantByName(p449, p450) -- Line: 2098
    if p449 then
        return p449:FindFirstChild(p450, true);
    end;

    return nil;
end;

function u1.pivotModelAtFormationAnchor(p451, p452, p453) -- Line: 2108
    -- upvalues: u1 (copy)
    u1.pivotInstanceToWorldCF(p452, p451 * p453);
end;

function u1.pivotModelOffsetFromFormationAnchor(p454, p455, p456, p457) -- Line: 2115
    -- upvalues: u1 (copy)
    u1.pivotInstanceToWorldCF(p455, p454 * CFrame.new(p456) * p457);
end;

function u1.capturePartLocalCF(p458, p459) -- Line: 2127
    local Parent = p458.Parent;

    if Parent and Parent:IsA("BasePart") then
        return Parent.CFrame:ToObjectSpace(p458.CFrame);
    end;

    if p459 then
        return p459:GetPivot():ToObjectSpace(p458.CFrame);
    end;

    return nil;
end;

function u1.applyPartLocalCFWithYaw(p460, p461, p462, p463) -- Line: 2141
    local v464 = CFrame.Angles(0, math.rad(p462), 0);
    local Parent = p460.Parent;

    if Parent and Parent:IsA("BasePart") then
        p460.CFrame = Parent.CFrame * p461 * v464;

        return;
    end;

    if p463 then
        p460.CFrame = p463:GetPivot() * p461 * v464;
    end;
end;

function u1.buildFormationCFFromSnappedFlat(p465, p466, p467) -- Line: 2160
    local v468 = p467 or CFrame.new(0, 1.4, -6.5);
    local Position = p465:GetPivot():ToWorldSpace(v468).Position;

    return CFrame.lookAt(Position, Position + p466, Vector3.new(0, 1, 0));
end;

function u1.resolveHorizSprayHitEnd(p469, p470, p471, p472, p473, p474, p475, p476) -- Line: 2186
    -- upvalues: u1 (copy)
    local v477 = p471 * p472;
    local v478 = u1.isWithinHorizReleaseRange(p469.Position, p470, p471, p472);
    local v479;

    if p476 then
        v479 = p476.fullHorizSprayRange == true;
    else
        v479 = p476;
    end;

    local Magnitude = Vector3.new(p470.X - p473.X, 0, p470.Z - p473.Z).Magnitude;
    local v480;

    if v479 or Magnitude <= 0.001 then
        v480 = v477;
    elseif Magnitude < v477 then
        v480 = Magnitude;
    else
        v480 = v477;
    end;

    local v481 = p476 and p476.wallBackoffStuds or u1.resolveBodyWallBackoffStuds(p469, 2);
    local clampHorizontalMoveEndByWallRay = u1.clampHorizontalMoveEndByWallRay;
    local v482 = {
        wallBackoffStuds = v481,
        minHorizontalMoveStuds = p476 and (p476.minHorizontalMoveStuds or 0) or 0
    };
    local v483;

    if p476 then
        v483 = p476.extraIgnore;
    else
        v483 = p476;
    end;

    v482.extraIgnore = v483;
    local v484;

    if p476 then
        v484 = p476.wallRayTag;
    else
        v484 = p476;
    end;

    v482.rayTag = v484;

    if p476 then
        p476 = p476.lowVisualClearStuds;
    end;

    v482.lowVisualClearStuds = p476;
    local v485, v486 = clampHorizontalMoveEndByWallRay(p473, p473 + p474 * v480, p475, v482);

    if v486 and v485 then
        return v485, true, true;
    end;

    if v479 then
        return p473 + p474 * v477, true, false;
    end;

    if not v478 then
        return p473 + p474 * v477, false, false;
    end;

    if Magnitude > 0.001 then
        v477 = math.min(Magnitude, v477);
    end;

    return p473 + p474 * v477, true, false;
end;

function u1.placeBoxHitboxBetween(p487, p488, p489, p490, p491) -- Line: 2233
    local Magnitude = (p489 - p488).Magnitude;
    local v492 = Magnitude < 0.001 and 0.5 or math.max(Magnitude, 0.5);
    local v493 = p490 * p491;
    local X = v493.X;
    local Y = v493.Y;
    local v494 = math.max(v493.Z, v492);
    p487.Size = Vector3.new(X, Y, v494);
    p487:PivotTo(CFrame.lookAt((p488 + p489) * 0.5, p489, Vector3.new(0, 1, 0)));
end;

function u1.enterSkillCameraRotLimit(p495, p496) -- Line: 2256
    -- upvalues: UtilsSystem (copy)
    if not (UtilsSystem.RunService:IsClient() and p495) then
        return;
    end;

    if type(p496) ~= "number" or p496 <= 0 then
        return;
    end;

    local LocalPlayer = UtilsSystem.LocalPlayer;

    if not LocalPlayer then
        return;
    end;

    if p495.skillCameraRotLimitActive then
        return;
    end;

    p495.skillCameraRotLimitWas = LocalPlayer:GetAttribute("SkillCameraMaxRotSpeedDeg");
    p495.skillCameraRotLimitActive = true;
    LocalPlayer:SetAttribute("SkillCameraMaxRotSpeedDeg", p496);
end;

function u1.restoreSkillCameraRotLimit(p497) -- Line: 2275
    -- upvalues: UtilsSystem (copy)
    if not (UtilsSystem.RunService:IsClient() and (p497 and p497.skillCameraRotLimitActive)) then
        return;
    end;

    local LocalPlayer = UtilsSystem.LocalPlayer;

    if not LocalPlayer then
        return;
    end;

    local skillCameraRotLimitWas = p497.skillCameraRotLimitWas;

    if skillCameraRotLimitWas == nil then
        LocalPlayer:SetAttribute("SkillCameraMaxRotSpeedDeg", nil);
    else
        LocalPlayer:SetAttribute("SkillCameraMaxRotSpeedDeg", skillCameraRotLimitWas);
    end;

    p497.skillCameraRotLimitActive = nil;
    p497.skillCameraRotLimitWas = nil;
end;

function u1.enterSkillShiftLock(p498, p499) -- Line: 2298
    -- upvalues: UtilsSystem (copy), u1 (copy)
    if not (UtilsSystem.RunService:IsClient() and (p498 and p498.skillRunData)) then
        return;
    end;

    if not u1.isLocalPlayerCaster(p498) then
        return;
    end;

    local skillRunData = p498.skillRunData;

    if not UtilsSystem.LocalPlayer then
        return;
    end;

    skillRunData.shiftLockWasOn = UtilsSystem.HumanModule.GetIsShiftLocked();

    if not skillRunData.shiftLockWasOn then
        game.ReplicatedStorage.Msg.Event.ShiftLock:Fire();
    end;

    if p499 then
        u1.enterSkillCameraRotLimit(skillRunData, p499);
    end;
end;

function u1.restoreSkillShiftLock(p500) -- Line: 2320
    -- upvalues: UtilsSystem (copy), u1 (copy)
    local v501;

    if p500 then
        v501 = p500.skillRunData;
    else
        v501 = p500;
    end;

    if not (UtilsSystem.RunService:IsClient() and v501) then
        u1.restoreSkillCameraRotLimit(v501);

        return;
    end;

    if not u1.isLocalPlayerCaster(p500) then
        u1.restoreSkillCameraRotLimit(v501);

        return;
    end;

    if v501.shiftLockWasOn == nil then
        u1.restoreSkillCameraRotLimit(v501);

        return;
    end;

    if not UtilsSystem.LocalPlayer then
        return;
    end;

    local v502 = UtilsSystem.HumanModule.GetIsShiftLocked();

    if v501.shiftLockWasOn then
        if not v502 then
            game.ReplicatedStorage.Msg.Event.ShiftLock:Fire();
        end;
    elseif v502 then
        game.ReplicatedStorage.Msg.Event.ShiftLock:Fire();
    end;

    v501.shiftLockWasOn = nil;
    u1.restoreSkillCameraRotLimit(v501);
end;

return u1;