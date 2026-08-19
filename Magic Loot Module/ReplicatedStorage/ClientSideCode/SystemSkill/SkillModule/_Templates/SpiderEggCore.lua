-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local FXUtil = UtilsSystem.FXUtil;
local VisibleMgr = UtilsSystem.VisibleMgr;
local RunService = UtilsSystem.RunService;
local RayCast = UtilsSystem.RayCast;
local SystemGameConfig = UtilsSystem.SystemGameConfig;
local MonsterEggGround = require(game.ReplicatedFirst.AllSideCode.ToolSystem.MonsterEggGround);
local SkillCommon = require(script.Parent.SkillCommon);
local u1 = {};
local u2 = {
    eggEnemyId = 5040008,
    eggSummonSkillKey = "SpiderEgg",
    eggMaxAlive = 8,
    eggCount = 4,
    scatterRadiusMin = 0,
    scatterRadiusMax = 30,
    flightSec = 0.85,
    arcUPortion = 0.35,
    resEggProjectile = "女王蜘蛛卵",
    resWebFx = "蜘蛛产卵蛛网特效",
    resHatchBurstFx = "蜘蛛产卵爆裂特效"
};

local function mergeConfig(p3) -- Line: 65
    -- upvalues: u2 (copy)
    local v4 = table.clone(u2);

    for i, v in pairs(p3) do
        v4[i] = v;
    end;

    return v4;
end;

local function getEggStageScales() -- Line: 73
    -- upvalues: SystemGameConfig (copy)
    local v5 = SystemGameConfig.Get();

    if v5 then
        v5 = v5["怪物配置"];
    end;

    if v5 then
        v5 = v5.MonsterEgg;
    end;

    local v6 = v5 and v5.default and v5.default.eggStageScales;

    return (type(v6) ~= "table" or #v6 < 1) and { 0.5, 0.75, 1 } or v6;
end;

local function getStage1ScaleMul() -- Line: 84
    -- upvalues: getEggStageScales (copy)
    return getEggStageScales()[1] or 0.5;
end;

local function flatDirFromCF(p7) -- Line: 88
    local v8 = Vector3.new(p7.LookVector.X, 0, p7.LookVector.Z);

    return v8.Magnitude <= 0.05 and Vector3.new(0, 0, -1) or v8.Unit;
end;

local function resolveBackSpawnCF(p9, p10) -- Line: 96
    return p9 * CFrame.new(0, p10 * 1.4, p10 * -2.2);
end;

local u11 = nil;

local function getEggHrpHalfHeightAtScale1() -- Line: 103
    -- upvalues: u11 (ref), UtilsSystem (copy)
    if u11 then
        return u11;
    end;

    local v12 = UtilsSystem.ModelFind.GetModelCloneByModelName("4", UtilsSystem.EnumMgr.ItemType.Enemy, false);

    if v12 then
        local v13 = v12.PrimaryPart or v12:FindFirstChild("HumanoidRootPart");

        if v13 and v13:IsA("BasePart") then
            u11 = v13.Size.Y * 0.5;
        end;
    end;

    return u11 or 2;
end;

local function resolveThrowStartCF(p14, p15, p16) -- Line: 119
    local v17 = p14:FindFirstChild("屁股");

    if v17 and v17:IsA("BasePart") then
        return v17:GetPivot();
    end;

    return p15 * CFrame.new(0, p16 * 1.4, p16 * -2.2);
end;

local function removeFromRunSpawnList(p18, p19, p20) -- Line: 127
    if not (p18 and p20) then
        return;
    end;

    local v21 = p18[p19];

    if not v21 then
        return;
    end;

    local v22 = table.find(v21, p20);

    if v22 then
        table.remove(v21, v22);
    end;
end;

local function isMonsterEggNearLanding(p23, p24, p25) -- Line: 141
    local Monster = workspace:FindFirstChild("Monster");

    if not Monster then
        return false;
    end;

    local v26 = math.max(p25, 0.5) * 4;

    for _, child in Monster:GetChildren() do
        if child:IsA("Model") and (child:GetAttribute("EntitySubType") == "MonsterEgg" and (tostring(child:GetAttribute("OwnerId")) == tostring(p23) and (child:GetPivot().Position - p24).Magnitude <= v26)) then
            return true;
        end;
    end;

    return false;
end;

local function releaseProjectileWhenEntityAppears(u27, u28, u29, u30) -- Line: 161
    -- upvalues: isMonsterEggNearLanding (copy)
    task.spawn(function() -- Line: 162
        -- upvalues: isMonsterEggNearLanding (ref), u28 (copy), u29 (copy), u30 (copy), u27 (copy)
        local v31 = os.clock() + 4;

        while os.clock() < v31 and not isMonsterEggNearLanding(u28, u29, u30) do
            task.wait(0.05);
        end;

        local model = u27.model;

        if model and model.Parent then
            model:Destroy();
        end;

        u27.model = nil;
    end);
end;

local function resolveReleaseCF(p32, p33) -- Line: 178
    local skillInputData = p32.skillInputData;

    if skillInputData and typeof(skillInputData.releaseCF) == "CFrame" then
        return skillInputData.releaseCF;
    end;

    local HumanoidRootPart = p33:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart then
        return HumanoidRootPart:GetPivot();
    end;

    return p33:GetPivot();
end;

local function buildArcGeometry(p34, p35, p36) -- Line: 190
    local v37 = Vector3.new(p35.X - p34.X, 0, p35.Z - p34.Z);
    local v38 = v37.Magnitude < 0.05 and Vector3.new(0, 0, -1) or v37.Unit;
    local Magnitude = Vector3.new(p35.X - p34.X, 0, p35.Z - p34.Z).Magnitude;
    local v39 = math.clamp(Magnitude * 0.4, p36 * 6, p36 * 24);
    local v40 = math.clamp(Magnitude * 0.35, p36 * 6, p36 * 18);
    local v41 = p34 + v38 * v39 + Vector3.new(0, v40, 0);

    return {
        startPos = p34,
        control = p34 + v38 * (v39 * 0.5) + Vector3.new(0, v40 * 1.1, 0),
        peakPos = v41
    };
end;

local function sampleQuadraticArc(p42, p43) -- Line: 210
    local v44 = math.clamp(p43, 0, 1);
    local startPos = p42.startPos;
    local control = p42.control;
    local peakPos = p42.peakPos;
    local v45 = 1 - v44;
    local v46 = v45 * 2 * (control - startPos) + v44 * 2 * (peakPos - control);
    local v47;

    if v46.Magnitude > 0.0001 then
        v47 = v46.Unit;
    else
        local v48 = CFrame.new(startPos, peakPos);
        local v49 = Vector3.new(v48.LookVector.X, 0, v48.LookVector.Z);
        v47 = v49.Magnitude <= 0.05 and Vector3.new(0, 0, -1) or v49.Unit;
    end;

    return v45 * v45 * startPos + v45 * 2 * v44 * control + v44 * v44 * peakPos, v47;
end;

local function evaluateCubicBezier(p50, p51, p52, p53, p54) -- Line: 222
    local v55 = 1 - p54;

    return v55 * v55 * v55 * p50 + v55 * 3 * v55 * p54 * p51 + v55 * 3 * p54 * p54 * p52 + p54 * p54 * p54 * p53;
end;

local function cubicBezierTangent(p56, p57, p58, p59, p60) -- Line: 227
    local v61 = 1 - p60;

    return v61 * 3 * v61 * (p57 - p56) + v61 * 6 * p60 * (p58 - p57) + p60 * 3 * p60 * (p59 - p58);
end;

local function ensureBezierEndState(p62, p63) -- Line: 232
    -- upvalues: sampleQuadraticArc (copy)
    if p62.bezierP0 then
        return;
    end;

    local _, v64 = sampleQuadraticArc(p62.arcGeom, 1);
    local peakPos = p62.arcGeom.peakPos;
    local v65 = math.max((p63 - peakPos).Magnitude * 0.66, 1);
    local v66;

    if v64.Magnitude > 0.0001 then
        v66 = v64.Unit;
    else
        local v67 = CFrame.new(peakPos, p63);
        local v68 = Vector3.new(v67.LookVector.X, 0, v67.LookVector.Z);
        v66 = v68.Magnitude <= 0.05 and Vector3.new(0, 0, -1) or v68.Unit;
    end;

    p62.bezierP0 = peakPos;
    p62.bezierP1 = peakPos + v66 * v65;
    p62.bezierArmLen = v65;
end;

local function sampleProjectileMotion(p69, p70, p71) -- Line: 246
    -- upvalues: TweenService (copy), sampleQuadraticArc (copy), ensureBezierEndState (copy)
    local arcUPortion = p69.arcUPortion;
    local v72 = TweenService:GetValue(p70, p69.easingStyle, p69.easingDirection);

    if v72 < arcUPortion - 0.0001 then
        local v73 = math.clamp(v72 / arcUPortion, 0, 1);

        return sampleQuadraticArc(p69.arcGeom, v73);
    end;

    ensureBezierEndState(p69, p71);
    local bezierP0 = p69.bezierP0;
    local bezierP1 = p69.bezierP1;
    local v74 = p71 - bezierP0;
    local v75;

    if v74.Magnitude > 0.0001 then
        v75 = v74.Unit;
    else
        v75 = (bezierP1 - bezierP0).Unit;
    end;

    local v76 = p71 - v75 * p69.bezierArmLen;

    if p69.easingStyle == Enum.EasingStyle.Quad and p69.easingDirection == Enum.EasingDirection.In then
        arcUPortion = math.sqrt(arcUPortion);
    end;

    local v77 = (p70 - arcUPortion) / math.max(1 - arcUPortion, 1e-6);
    local v78 = TweenService:GetValue(math.clamp(v77, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.In);
    local v79 = 1 - v78;
    local v80 = 1 - v78;

    return v79 * v79 * v79 * bezierP0 + v79 * 3 * v79 * v78 * bezierP1 + v79 * 3 * v78 * v78 * v76 + v78 * v78 * v78 * p71, v80 * 3 * v80 * (bezierP1 - bezierP0) + v80 * 6 * v78 * (v76 - bezierP1) + v78 * 3 * v78 * (p71 - v76);
end;

local function raycastGround(p81) -- Line: 271
    -- upvalues: RayCast (copy)
    local v82 = RayCast.RayCastDirection(p81 + Vector3.new(0, 40, 0), Vector3.new(0, -1, 0), 80, "Ground");

    if not v82 then
        return nil, nil;
    end;

    if v82.Normal.Y < 0.65 then
        return nil, nil;
    end;

    return v82.Position, v82.Normal;
end;

local function isLandingValid(p83) -- Line: 283
    -- upvalues: RayCast (copy)
    local v84 = RayCast.RayCastDirection(p83 + Vector3.new(0, 40, 0), Vector3.new(0, -1, 0), 80, "Ground");
    local v85, v86;

    if v84 and v84.Normal.Y >= 0.65 then
        v85 = v84.Position;
        v86 = v84.Normal;
    else
        v85 = nil;
        v86 = nil;
    end;

    if not v85 then
        return false;
    end;

    if RayCast.RayCastDirection(v85 + Vector3.new(0, 2, 0), Vector3.new(0, 1, 0), 4, "Ground") then
        return false;
    end;

    return v86 ~= nil;
end;

local function sampleScatterLandingSeeded(p87, p88, p89, p90, p91) -- Line: 296
    -- upvalues: RayCast (copy), raycastGround (copy)
    for _ = 1, 2 do
        local v92 = p87:NextNumber() * 3.141592653589793 * 2;
        local v93 = p89 + p87:NextNumber() * math.max(p90 - p89, 0);
        local v94 = math.cos(v92) * v93 * p91;
        local v95 = math.sin(v92) * v93 * p91;
        local v96 = p88 + Vector3.new(v94, 0, v95);
        local v97 = RayCast.RayCastDirection(v96 + Vector3.new(0, 40, 0), Vector3.new(0, -1, 0), 80, "Ground");
        local v98, v99;

        if v97 and v97.Normal.Y >= 0.65 then
            v98 = v97.Position;
            v99 = v97.Normal;
        else
            v98 = nil;
            v99 = nil;
        end;

        local v100;

        if v98 and not RayCast.RayCastDirection(v98 + Vector3.new(0, 2, 0), Vector3.new(0, 1, 0), 4, "Ground") then
            v100 = v99 ~= nil;
        else
            v100 = false;
        end;

        if v100 then
            local v101 = select(1, raycastGround(v96));

            if v101 then
                return v101;
            end;
        end;
    end;

    return nil;
end;

local function buildLandingCF(p102, p103) -- Line: 318
    local v104 = Vector3.new(p103.X, 0, p103.Z);

    return CFrame.lookAt(p102, p102 + (v104.Magnitude < 0.05 and Vector3.new(0, 0, -1) or v104.Unit), Vector3.new(0, 1, 0));
end;

local function buildEggLandingPivotCF(p105, p106, p107) -- Line: 328
    -- upvalues: MonsterEggGround (copy), getEggHrpHalfHeightAtScale1 (copy), getEggStageScales (copy)
    local v108 = Vector3.new(p106.X, 0, p106.Z);
    local v109 = CFrame.lookAt(p105, p105 + (v108.Magnitude < 0.05 and Vector3.new(0, 0, -1) or v108.Unit), Vector3.new(0, 1, 0));

    return MonsterEggGround.resolveLandingPivotCF(p105, v109.Rotation, getEggHrpHalfHeightAtScale1(), p107, getEggStageScales()[1] or 0.5);
end;

local function buildProjectile(p110, p111, p112, p113, p114) -- Line: 339
    -- upvalues: buildArcGeometry (copy)
    local v115 = {
        moveT = 0,
        impacted = false,
        startPos = p111,
        endPos = p112,
        arcGeom = buildArcGeometry(p111, p112, p113),
        flightSec = p114.flightSec,
        arcUPortion = p114.arcUPortion,
        easingStyle = Enum.EasingStyle.Quad,
        easingDirection = Enum.EasingDirection.In
    };
    local v116 = p110:NextNumber() - 0.5;
    local v117 = p110:NextNumber() - 0.5;
    local v118 = p110:NextNumber() - 0.5;
    v115.spinAxis = Vector3.new(v116, v117, v118).Unit;
    v115.spinSpeed = p110:NextNumber() * 240 + 180;
    v115.randomRot = CFrame.Angles(p110:NextNumber() * 3.141592653589793, p110:NextNumber() * 3.141592653589793, p110:NextNumber() * 3.141592653589793);

    return v115;
end;

local function computeThrowPlan(p119, p120) -- Line: 360
    -- upvalues: SkillCommon (copy), sampleScatterLandingSeeded (copy), buildProjectile (copy), getEggStageScales (copy)
    local character = p119.skillInputData.character;

    if not character then
        return nil;
    end;

    local v121 = SkillCommon.npcSummonBodySkillScale(p119);
    local skillInputData = p119.skillInputData;
    local v122;

    if skillInputData and typeof(skillInputData.releaseCF) == "CFrame" then
        v122 = skillInputData.releaseCF;
    else
        local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

        if HumanoidRootPart then
            v122 = HumanoidRootPart:GetPivot();
        else
            v122 = character:GetPivot();
        end;
    end;

    local v123 = character:FindFirstChild("屁股");
    local v124;

    if v123 and v123:IsA("BasePart") then
        v124 = v123:GetPivot();
    else
        v124 = v122 * CFrame.new(0, v121 * 1.4, v121 * -2.2);
    end;

    local Position = v124.Position;
    local v125 = p119.skillInputData.skillRandomSeed or 1;
    local v126 = {};

    for i = 1, p120.eggCount do
        local v127 = Random.new(v125 + i * 9973);
        local v128 = sampleScatterLandingSeeded(v127, Position, p120.scatterRadiusMin, p120.scatterRadiusMax, v121);

        if v128 then
            local v129 = {
                index = i,
                endPos = v128,
                proj = buildProjectile(v127, Position, v128, v121, p120)
            };
            table.insert(v126, v129);
        end;
    end;

    return {
        startCF = v124,
        startPos = Position,
        sc = v121,
        projectileScale = v121 * (getEggStageScales()[1] or 0.5),
        eggs = v126
    };
end;

local function enableEggProjectileVfx(p130) -- Line: 396
    -- upvalues: FXUtil (copy)
    FXUtil.SetEmittersTrailsBeamsEnabled(p130, true);
    FXUtil.SetEnableNameVfx(p130, true);
end;

local function disableEggProjectileVfx(p131) -- Line: 401
    -- upvalues: FXUtil (copy)
    FXUtil.SetEmittersTrailsBeamsEnabled(p131, false);
    FXUtil.OffEnableVfx(p131);
end;

local function playWebFx(p132, p133, p134, p135, p136) -- Line: 406
    -- upvalues: FXUtil (copy), SkillCommon (copy)
    if p132 then
        p132 = p132[p136];
    end;

    if not p132 then
        return;
    end;

    local u137 = p132:Clone();

    if u137:IsA("Model") then
        u137:ScaleTo(p134);
        u137:PivotTo(p133);
    elseif u137:IsA("BasePart") then
        u137.CFrame = p133;
    end;

    u137.Parent = workspace.Debris;
    FXUtil.Emit_Particles_GetDescendants(u137, true);
    SkillCommon.appendRunSpawnList(p135, "SpiderEggWebFxSpawns", u137);
    task.delay(5, function() -- Line: 421
        -- upvalues: u137 (copy)
        if u137 and u137.Parent then
            u137:Destroy();
        end;
    end);
end;

local function spawnMonsterEgg(p138, p139, p140, p141, p142) -- Line: 428
    -- upvalues: UtilsSystem (copy)
    local SystemSummon = UtilsSystem.SystemSummon;

    if not (SystemSummon and SystemSummon.CreateNpcSummon) then
        return false;
    end;

    local v143 = CFrame.new(p139 + Vector3.new(0, 10, 0)) * p140.Rotation;

    return SystemSummon.CreateNpcSummon(p138, p142.eggEnemyId, p140, {
        rejectIfAtMaxCount = true,
        despawnOnOwnerLoseAggro = true,
        entitySubType = "MonsterEgg",
        spawnGroundOffsetY = 0,
        summonSkillKey = p142.eggSummonSkillKey,
        maxCount = p142.eggMaxAlive,
        scale = p141,
        spawnGroundRayCFrame = v143
    }) ~= nil;
end;

local function pivotProjectile(p144, p145, p146, p147, p148, p149) -- Line: 453
    local v150 = Vector3.new(p146.X, 0, p146.Z);
    local v151 = CFrame.lookAt(p145, p145 + (v150.Magnitude < 0.05 and Vector3.new(0, 0, -1) or v150.Unit), Vector3.new(0, 1, 0));
    local v152 = CFrame.fromAxisAngle(p147.spinAxis, (math.rad(p147.spinSpeed * p147.moveT))) * p147.randomRot;
    local v153 = CFrame.new(p145);

    if p148 < 0.82 then
        p144:PivotTo(v153 * v152 * (p149 or CFrame.new()));

        return;
    end;

    local v154 = math.clamp((p148 - 0.82) / 0.18000000000000005, 0, 1);
    local v155 = (v153 * v152 * (p149 or CFrame.new())).Rotation:Lerp(v151.Rotation, v154);
    p144:PivotTo(CFrame.new(p145) * v155);
end;

function u1.serverEnterThrow(u156, p157) -- Line: 468
    -- upvalues: u2 (copy), computeThrowPlan (copy), sampleProjectileMotion (copy), MonsterEggGround (copy), getEggHrpHalfHeightAtScale1 (copy), getEggStageScales (copy), spawnMonsterEgg (copy)
    local u158 = table.clone(u2);

    for i, v in pairs(p157) do
        u158[i] = v;
    end;

    local character = u156.skillInputData.character;

    if not character or u156.skillInputData.characterType ~= "NPC" then
        return;
    end;

    local u159 = computeThrowPlan(u156, u158);

    if not u159 then
        return;
    end;

    local skillRunData = u156.skillRunData;
    skillRunData.SpiderEggServer = skillRunData.SpiderEggServer or {
        projectiles = {}
    };

    for _, v in u159.eggs do
        local proj = v.proj;
        table.insert(skillRunData.SpiderEggServer.projectiles, proj);
        task.delay(proj.flightSec, function() -- Line: 486
            -- upvalues: u156 (copy), proj (copy), sampleProjectileMotion (ref), v (copy), u159 (copy), MonsterEggGround (ref), getEggHrpHalfHeightAtScale1 (ref), getEggStageScales (ref), spawnMonsterEgg (ref), character (copy), u158 (copy)
            if not u156:isRunningFlow() then
                return;
            end;

            if proj.impacted then
                return;
            end;

            proj.impacted = true;
            local _, v160 = sampleProjectileMotion(proj, 1, v.endPos);
            local endPos = v.endPos;
            local sc = u159.sc;
            local v161 = Vector3.new(v160.X, 0, v160.Z);
            local v162 = CFrame.lookAt(endPos, endPos + (v161.Magnitude < 0.05 and Vector3.new(0, 0, -1) or v161.Unit), Vector3.new(0, 1, 0));
            local v163 = MonsterEggGround.resolveLandingPivotCF(endPos, v162.Rotation, getEggHrpHalfHeightAtScale1(), sc, getEggStageScales()[1] or 0.5);
            spawnMonsterEgg(character, v.endPos, v163, u159.sc, u158);
        end);
    end;
end;

function u1.clientEnterThrow(u164, p165) -- Line: 501
    -- upvalues: u2 (copy), computeThrowPlan (copy), SkillCommon (copy), VisibleMgr (copy), FXUtil (copy), RunService (copy), sampleProjectileMotion (copy), MonsterEggGround (copy), getEggHrpHalfHeightAtScale1 (copy), getEggStageScales (copy), pivotProjectile (copy), isMonsterEggNearLanding (copy), playWebFx (copy)
    local u166 = table.clone(u2);

    for i, v in pairs(p165) do
        u166[i] = v;
    end;

    local character = u164.skillInputData.character;

    if not character then
        return;
    end;

    local u167 = computeThrowPlan(u164, u166);

    if not u167 then
        return;
    end;

    SkillCommon.playSoundLocal3D("音效-技能-boss产卵-产卵", u167.startPos);
    local skillRunData = u164.skillRunData;
    local material = skillRunData.material;
    local runGeneration = u164.runGeneration;
    skillRunData.SpiderEggClient = skillRunData.SpiderEggClient or {
        projectiles = {}
    };

    local function stillThrow() -- Line: 520
        -- upvalues: u164 (copy), runGeneration (copy)
        local v168 = u164:isRunningFlow() and u164.runGeneration == runGeneration;

        return v168;
    end;

    local v169;

    if character.Name == "" then
        v169 = nil;
    else
        v169 = tonumber(character.Name) or character.Name;
    end;

    for _, v in u167.eggs do
        local proj = v.proj;
        local v170 = nil;
        local v171 = nil;
        local v172;

        if material then
            v172 = material[u166.resEggProjectile];
        else
            v172 = material;
        end;

        if v172 and v172:IsA("Model") then
            v170 = v172:Clone();
            VisibleMgr.UnQueryAll(v170);
            v170:ScaleTo(u167.projectileScale);
            v171 = v170:GetPivot() - v170:GetPivot().Position;
            v170:PivotTo(u167.startCF);
            v170.Parent = workspace.Debris;
            FXUtil.SetEmittersTrailsBeamsEnabled(v170, true);
            FXUtil.SetEnableNameVfx(v170, true);
            SkillCommon.appendRunSpawnList(skillRunData, "SpiderEggProjectiles", v170);
        end;

        table.insert(skillRunData.SpiderEggClient.projectiles, {
            proj = proj,
            model = v170,
            oriLocal = v171,
            endPos = v.endPos,
            ownerRuntimeId = v169
        });
    end;

    skillRunData.runEvent = skillRunData.runEvent or {};

    if skillRunData.runEvent["蜘蛛产卵客户端弹道"] then
        return;
    end;

    skillRunData.runEvent["蜘蛛产卵客户端弹道"] = RunService.Heartbeat:Connect(function(p173) -- Line: 554
        -- upvalues: u164 (copy), runGeneration (copy), skillRunData (copy), sampleProjectileMotion (ref), u167 (copy), MonsterEggGround (ref), getEggHrpHalfHeightAtScale1 (ref), getEggStageScales (ref), pivotProjectile (ref), FXUtil (ref), isMonsterEggNearLanding (ref), playWebFx (ref), material (copy), u166 (copy)
        local v174 = u164:isRunningFlow() and u164.runGeneration == runGeneration;

        if not v174 then
            return;
        end;

        local v175 = skillRunData.SpiderEggClient and skillRunData.SpiderEggClient.projectiles;

        if not v175 then
            return;
        end;

        for _, v in v175 do
            local proj = v.proj;

            if not proj.impacted then
                proj.moveT = proj.moveT + p173;
                local v176 = math.clamp(proj.moveT / proj.flightSec, 0, 1);
                local _, v177 = sampleProjectileMotion(proj, 1, v.endPos);
                local endPos = v.endPos;
                local sc = u167.sc;
                local v178 = Vector3.new(v177.X, 0, v177.Z);
                local v179 = CFrame.lookAt(endPos, endPos + (v178.Magnitude < 0.05 and Vector3.new(0, 0, -1) or v178.Unit), Vector3.new(0, 1, 0));
                local v180 = MonsterEggGround.resolveLandingPivotCF(endPos, v179.Rotation, getEggHrpHalfHeightAtScale1(), sc, getEggStageScales()[1] or 0.5);
                local v181, v182 = sampleProjectileMotion(proj, v176, v180.Position);

                if v.model and v.model.Parent then
                    pivotProjectile(v.model, v181, v182, proj, v176, v.oriLocal);
                end;

                if v176 >= 1 then
                    proj.impacted = true;

                    if v.model and v.model.Parent then
                        v.model:PivotTo(v180 * (v.oriLocal or CFrame.new()));
                        local model = v.model;
                        FXUtil.SetEmittersTrailsBeamsEnabled(model, false);
                        FXUtil.OffEnableVfx(model);
                        local v183 = skillRunData;
                        local model2 = v.model;

                        if v183 and model2 then
                            local SpiderEggProjectiles = v183.SpiderEggProjectiles;
                            local v184 = SpiderEggProjectiles and table.find(SpiderEggProjectiles, model2);

                            if v184 then
                                table.remove(SpiderEggProjectiles, v184);
                            end;
                        end;

                        local ownerRuntimeId = v.ownerRuntimeId;
                        local Position = v180.Position;
                        local sc2 = u167.sc;
                        task.spawn(function() -- Line: 162
                            -- upvalues: isMonsterEggNearLanding (ref), ownerRuntimeId (copy), Position (copy), sc2 (copy), v (copy)
                            local v185 = os.clock() + 4;

                            while os.clock() < v185 and not isMonsterEggNearLanding(ownerRuntimeId, Position, sc2) do
                                task.wait(0.05);
                            end;

                            local model3 = v.model;

                            if model3 and model3.Parent then
                                model3:Destroy();
                            end;

                            v.model = nil;
                        end);
                    end;

                    local endPos2 = v.endPos;
                    local v186 = Vector3.new(v182.X, 0, v182.Z);
                    playWebFx(material, CFrame.lookAt(endPos2, endPos2 + (v186.Magnitude < 0.05 and Vector3.new(0, 0, -1) or v186.Unit), Vector3.new(0, 1, 0)), u167.sc, skillRunData, u166.resWebFx);
                end;
            end;
        end;
    end);
end;

function u1.clientExitThrow(p187) -- Line: 595
    -- upvalues: SkillCommon (copy), FXUtil (copy)
    local skillRunData = p187.skillRunData;

    if not skillRunData then
        return;
    end;

    SkillCommon.disconnectRunEventKeys(skillRunData, { "蜘蛛产卵客户端弹道" });
    local v188 = skillRunData.SpiderEggClient and skillRunData.SpiderEggClient.projectiles;

    if v188 then
        for _, v in v188 do
            if not (v.proj and v.proj.impacted) and (v.model and v.model.Parent) then
                local model = v.model;
                FXUtil.SetEmittersTrailsBeamsEnabled(model, false);
                FXUtil.OffEnableVfx(model);
                local model2 = v.model;

                if skillRunData and model2 then
                    local SpiderEggProjectiles = skillRunData.SpiderEggProjectiles;
                    local v189 = SpiderEggProjectiles and table.find(SpiderEggProjectiles, model2);

                    if v189 then
                        table.remove(SpiderEggProjectiles, v189);
                    end;
                end;

                v.model:Destroy();
                v.model = nil;
            end;
        end;
    end;
end;

function u1.attach(p190, p191) -- Line: 617
    -- upvalues: u2 (copy), u1 (copy)
    local u192 = table.clone(u2);

    for i, v in pairs(p191) do
        u192[i] = v;
    end;

    p190.summonSkillKey = u192.eggSummonSkillKey;
    p190.summonMaxCount = u192.eggMaxAlive;

    function p190.Server_EnterThrow(p193) -- Line: 622
        -- upvalues: u1 (ref), u192 (copy)
        u1.serverEnterThrow(p193, u192);
    end;

    function p190.Client_EnterThrow(p194) -- Line: 625
        -- upvalues: u1 (ref), u192 (copy)
        u1.clientEnterThrow(p194, u192);
    end;

    function p190.Client_ExitThrow(p195) -- Line: 628
        -- upvalues: u1 (ref)
        u1.clientExitThrow(p195);
    end;
end;

u1.SOUND_THROW = "音效-技能-boss产卵-产卵";
u1.SOUND_HATCH = "音效-技能-boss产卵-爆炸";
u1.SOUND_STAGE2 = "音效-技能-boss产卵-第一次变大";
u1.SOUND_STAGE3 = "音效-技能-boss产卵-第二次变大";
u1.SPAWN_LIST_KEY = "SpiderEggSpawns";
u1.PROJECTILE_LIST_KEY = "SpiderEggProjectiles";
u1.PROJECTILE_HOLD_MAX_SEC = 4;
u1.WEB_FX_SPAWN_LIST_KEY = "SpiderEggWebFxSpawns";
u1.WEB_FX_RECYCLE_DELAY_SEC = 5;

return u1;