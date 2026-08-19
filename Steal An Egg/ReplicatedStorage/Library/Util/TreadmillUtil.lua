-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
require(ReplicatedStorage.Library.Modules.DefaultStats.Types.Interface);
local Simple = require(ReplicatedStorage.Library.Modules.FormatNumber.Simple);
local Trails = require(ReplicatedStorage.Directory.Trails);
local BASE_WALK_SPEED = Constants.BASE_WALK_SPEED;
local u1 = { 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096 };
local u2 = {
    DEFAULT_BASE_SPEED_POWER = 10,
    DEFAULT_BASE_SPEED_POWER_PER_STEP = 1,
    DEFAULT_SPEED_STEP_MULTIPLIER = 1,
    TEMPORARY_SPEED_BOOST_MULTIPLIER = 2,
    TREADMILL_SPEED_GAIN_INTERVAL = 1,
    MAX_WALK_SPEED = 300,
    MAX_SPEED_BOOST_TIER_INDEX = #u1
};

local function resolveCurveLevelFromCurveProgress(p3) -- Line: 52
    if p3 <= 0 then
        return 0;
    end;

    local v4 = p3 * 0.1499999999999999 / 100 + 1;

    return v4 <= 1 and 0 or math.log(v4) / 0.13976194237515863;
end;

local function resolveReferenceWalkSpeed(p5) -- Line: 65
    return p5 <= 0 and 10 or math.min(p5 * 2 + 10, 300);
end;

local function resolveCurveProgress(p6) -- Line: 76
    return math.max(p6 - 10, 0);
end;

local function resolveWalkSpeed(p7) -- Line: 80
    if p7 <= 0 then
        return 10;
    end;

    local v8;

    if p7 <= 0 then
        v8 = 0;
    else
        local v9 = p7 * 0.1499999999999999 / 100 + 1;
        v8 = v9 <= 1 and 0 or math.log(v9) / 0.13976194237515863;
    end;

    return v8 <= 0 and 10 or math.min(v8 * 2 + 10, 300);
end;

local function remapProgressionWalkSpeedToAppliedWalkSpeed(p10) -- Line: 89
    -- upvalues: BASE_WALK_SPEED (copy)
    return BASE_WALK_SPEED + math.clamp((p10 - 10) / 290, 0, 1) * (300 - BASE_WALK_SPEED);
end;

local function remapAppliedWalkSpeedToProgressionWalkSpeed(p11) -- Line: 101
    -- upvalues: BASE_WALK_SPEED (copy)
    return math.clamp((p11 - BASE_WALK_SPEED) / (300 - BASE_WALK_SPEED), 0, 1) * 290 + 10;
end;

local function formatDurationProductLabel(p12, p13) -- Line: 113
    -- upvalues: Asserts (copy)
    Asserts.number(p12);
    Asserts.boolean(p13);
    local v14 = math.floor(p12);
    local v15 = math.max(v14, 0) // 60;
    local v16 = v15 == 1 and "Minute" or "Minutes";

    if v15 >= 60 and v15 % 60 == 0 then
        v15 = v15 // 60;

        if v15 == 1 then
            v16 = "Hour";
        else
            v16 = "Hours";
        end;
    end;

    if p13 then
        v16 = string.upper(v16);
    end;

    return `{v15} {v16}`;
end;

function u2.NormalizeSpeedPower(p17) -- Line: 133
    -- upvalues: u2 (copy), Asserts (copy)
    if p17 == nil then
        return u2.DEFAULT_BASE_SPEED_POWER;
    end;

    Asserts.number(p17);

    return p17;
end;

function u2.SpeedPowerToWalkSpeed(p18) -- Line: 144
    -- upvalues: u2 (copy), BASE_WALK_SPEED (copy)
    local v19 = (u2.SpeedPowerToProgressionWalkSpeed(p18) - 10) / 290;

    return BASE_WALK_SPEED + math.clamp(v19, 0, 1) * (300 - BASE_WALK_SPEED);
end;

function u2.SpeedPowerToProgressionWalkSpeed(p20) -- Line: 149
    -- upvalues: u2 (copy)
    local v21 = u2.NormalizeSpeedPower(p20) - 10;
    local v22 = math.max(v21, 0);

    if v22 <= 0 then
        return 10;
    end;

    local v23;

    if v22 <= 0 then
        v23 = 0;
    else
        local v24 = v22 * 0.1499999999999999 / 100 + 1;
        v23 = v24 <= 1 and 0 or math.log(v24) / 0.13976194237515863;
    end;

    return v23 <= 0 and 10 or math.min(v23 * 2 + 10, 300);
end;

function u2.WalkSpeedToSpeedPower(p25) -- Line: 155
    -- upvalues: Asserts (copy), BASE_WALK_SPEED (copy)
    Asserts.number(p25);
    local v26 = math.clamp((p25 - BASE_WALK_SPEED) / (300 - BASE_WALK_SPEED), 0, 1) * 290 + 10 - 10;

    return (1.15 ^ (math.max(v26, 0) / 2) - 1) * 100 / 0.1499999999999999 + 10;
end;

function u2.RoundSpeedPowerRequirement(p27) -- Line: 165
    -- upvalues: Asserts (copy)
    Asserts.number(p27);

    if p27 <= 0 then
        return 0;
    end;

    local v28 = math.log10(p27);
    local v29 = 10 ^ math.floor(v28);
    local v30 = p27 / v29;
    local v31 = v30 < 2 and 0.1 or (v30 < 5 and 0.5 or 1);

    return math.ceil(v30 / v31) * v31 * v29;
end;

function u2.FormatSpeedPower(p32) -- Line: 178
    -- upvalues: Simple (copy), u2 (copy)
    return Simple.FormatCompact(u2.NormalizeSpeedPower(p32), ".#");
end;

function u2.FormatSpeedPowerPerStep(p33) -- Line: 182
    -- upvalues: Asserts (copy), Simple (copy)
    Asserts.number(p33);

    return `+{Simple.FormatCompact(p33, ".#")}/step`;
end;

function u2.ResolveEquippedTrailSpeedStepMultiplier(p34) -- Line: 187
    -- upvalues: Trails (copy)
    if p34 == nil then
        return 1;
    end;

    local EquippedTrail = p34.EquippedTrail;

    return (EquippedTrail == nil or p34.TrailInventory[EquippedTrail] ~= true) and 1 or (not Trails.Types.TrailNameExists(EquippedTrail) and 1 or math.max(Trails.Directory[EquippedTrail].SpeedMultiplier, 1));
end;

function u2.ResolveFinalWalkSpeed(p35, p36) -- Line: 205
    -- upvalues: Asserts (copy), u2 (copy)
    Asserts.optional.number(p35);
    Asserts.optional.number(p36);
    local v37 = p36 or 1;
    local v38;

    if v37 > 0 then
        v38 = v37 <= 1;
    else
        v38 = false;
    end;

    Asserts.cond(v38);

    return u2.SpeedPowerToWalkSpeed(p35) * v37;
end;

function u2.ResolveEffectiveSpeedPower(p39, p40) -- Line: 214
    -- upvalues: u2 (copy)
    return u2.WalkSpeedToSpeedPower(u2.ResolveFinalWalkSpeed(p39, p40));
end;

function u2.FormatSpeedMultiplierValue(p41) -- Line: 218
    -- upvalues: Asserts (copy), Simple (copy)
    Asserts.number(p41);

    return `x{Simple.FormatCompact(p41, ".#")}`;
end;

function u2.FormatSpeedMultiplier(p42) -- Line: 223
    -- upvalues: Asserts (copy), u2 (copy)
    Asserts.number(p42);

    return `{u2.FormatSpeedMultiplierValue(p42)} Speed`;
end;

function u2.FormatTemporarySpeedBoostProductDuration(p43) -- Line: 228
    -- upvalues: formatDurationProductLabel (copy)
    return formatDurationProductLabel(p43, true);
end;

function u2.FormatTreadmillSpeedEquivalentDuration(p44) -- Line: 232
    -- upvalues: formatDurationProductLabel (copy)
    return formatDurationProductLabel(p44, false);
end;

function u2.GetSpeedBoostMultiplierForTierIndex(p45) -- Line: 236
    -- upvalues: Asserts (copy), u1 (copy)
    Asserts.number(p45);

    return u1[p45] or 1;
end;

function u2.ResolveSpeedBoostTierIndex(p46) -- Line: 242
    -- upvalues: u2 (copy)
    if p46 == nil then
        return 0;
    end;

    local v47 = math.floor(p46.SpeedBoostTierIndex);

    return math.clamp(v47, 0, u2.MAX_SPEED_BOOST_TIER_INDEX);
end;

function u2.ResolveSpeedBoostSpeedStepMultiplier(p48) -- Line: 250
    -- upvalues: u2 (copy)
    return u2.GetSpeedBoostMultiplierForTierIndex(u2.ResolveSpeedBoostTierIndex(p48));
end;

function u2.ResolveTemporarySpeedBoostRemainingSeconds(p49, p50) -- Line: 254
    -- upvalues: Asserts (copy)
    Asserts.optional.number(p50);

    if p49 == nil then
        return 0;
    end;

    local v51 = math.max(p49.TemporarySpeedBoostRemainingSeconds, 0);
    local TemporarySpeedBoostActiveStartedAt = p49.TemporarySpeedBoostActiveStartedAt;

    if TemporarySpeedBoostActiveStartedAt > 0 then
        if p50 == nil then
            p50 = workspace:GetServerTimeNow();
        end;

        v51 = v51 - math.max(p50 - TemporarySpeedBoostActiveStartedAt, 0);
    end;

    return math.max(v51, 0);
end;

function u2.ResolveTemporarySpeedBoostSpeedStepMultiplier(p52, p53) -- Line: 271
    -- upvalues: u2 (copy)
    return u2.ResolveTemporarySpeedBoostRemainingSeconds(p52, p53) <= 0 and 1 or 2;
end;

function u2.ResolveAdditiveSpeedStepMultiplier(p54, p55) -- Line: 279
    -- upvalues: Asserts (copy)
    Asserts.optional.number(p54);
    Asserts.optional.number(p55);
    local v56 = math.max((p54 == nil and 1 or p54) - 1, 0);
    local v57 = math.max((p55 == nil and 1 or p55) - 1, 0);

    return v56 + 1 + v57;
end;

function u2.ResolveTreadmillSpeedPowerDelta(p58, p59, p60, p61) -- Line: 298
    -- upvalues: Asserts (copy), u2 (copy)
    Asserts.number(p58);
    Asserts.number(p59);
    Asserts.optional.number(p60);
    Asserts.optional.number(p61);
    local v62 = p61 == nil and 1 or math.max(p61, 0);
    local v63 = u2.ResolveAdditiveSpeedStepMultiplier(p59, p60);

    return math.max(p58, 0) * v63 * v62;
end;

function u2.ResolveSpeedPowerPerStep(p64, p65, p66) -- Line: 315
    -- upvalues: Asserts (copy), u2 (copy)
    Asserts.optional.number(p65);
    Asserts.optional.number(p66);
    local v67 = u2.ResolveSpeedBoostSpeedStepMultiplier(p64);
    local v68 = u2.ResolveTemporarySpeedBoostSpeedStepMultiplier(p64, p66);
    local v69 = u2.ResolveEquippedTrailSpeedStepMultiplier(p64);
    local v70 = u2.ResolveTreadmillSpeedPowerDelta(1, p65 or 1, nil);
    local v71 = u2.ResolveAdditiveSpeedStepMultiplier(v67, v68);

    return v70 * u2.ResolveAdditiveSpeedStepMultiplier(v71, v69);
end;

function u2.ResolveSpeedPowerPerSecond(p72, p73, p74) -- Line: 337
    -- upvalues: Asserts (copy), u2 (copy)
    Asserts.table(p72);
    Asserts.number(p73);
    Asserts.optional.number(p74);
    local v75 = u2.ResolveSpeedPowerPerStep(p72, p73, p74);
    local v76 = u2.SpeedPowerToProgressionWalkSpeed(p72.SpeedPower);

    return v75 / u2.ResolveWalkSpeedPowerAwardInterval(v76);
end;

function u2.ResolveTreadmillEquivalentSpeedPower(p77, p78, p79, p80) -- Line: 348
    -- upvalues: Asserts (copy), u2 (copy)
    Asserts.table(p77);
    Asserts.number(p78);
    Asserts.number(p79);
    Asserts.optional.number(p80);
    assert(p79 > 0, "Treadmill equivalent duration must be positive");

    return u2.ResolveSpeedPowerPerSecond(p77, p78, p80) * p79;
end;

function u2.ResolveNextTreadmillSpeedGainAt(p81) -- Line: 363
    -- upvalues: Asserts (copy)
    Asserts.number(p81);

    return p81 + 1;
end;

function u2.ResolveElapsedTreadmillSpeedGainTicks(p82, p83) -- Line: 368
    -- upvalues: Asserts (copy)
    Asserts.number(p82);
    Asserts.number(p83);

    return p83 < p82 and 0 or math.floor((p83 - p82) / 1) + 1;
end;

function u2.ResolveWalkSpeedPowerAwardInterval(p84) -- Line: 379
    -- upvalues: Asserts (copy)
    Asserts.number(p84);

    return 0.25 - math.clamp((p84 - 10) / 90, 0, 1) * 0.15;
end;

local function findOptionalPresentationPart(p85, p86) -- Line: 390
    local v87 = p85:FindFirstChild(p86, true);

    if v87 == nil then
        return nil;
    end;

    local v88 = v87:IsA("BasePart");
    local v89 = `Treadmill "{p85.Name}" {p86} must be a BasePart`;
    assert(v88, v89);

    return v87;
end;

function u2.FindVideoFeedScreenPart(p90) -- Line: 399
    -- upvalues: Asserts (copy)
    Asserts.Tool(p90);
    local VideoFeedScreen = p90:FindFirstChild("VideoFeedScreen", true);

    if VideoFeedScreen == nil then
        return nil;
    end;

    local v91 = VideoFeedScreen:IsA("BasePart");
    local v92 = `Treadmill "{p90.Name}" VideoFeedScreen must be a BasePart`;
    assert(v91, v92);

    return VideoFeedScreen;
end;

function u2.FindVideoPresentationParts(p93) -- Line: 404
    -- upvalues: Asserts (copy), u2 (copy)
    Asserts.Tool(p93);
    local v94 = u2.FindVideoFeedScreenPart(p93);
    local SwapLeft = p93:FindFirstChild("SwapLeft", true);

    if SwapLeft == nil then
        SwapLeft = nil;
    else
        local v95 = SwapLeft:IsA("BasePart");
        local v96 = `Treadmill "{p93.Name}" SwapLeft must be a BasePart`;
        assert(v95, v96);
    end;

    local SwapRight = p93:FindFirstChild("SwapRight", true);

    if SwapRight == nil then
        SwapRight = nil;
    else
        local v97 = SwapRight:IsA("BasePart");
        local v98 = `Treadmill "{p93.Name}" SwapRight must be a BasePart`;
        assert(v97, v98);
    end;

    if v94 == nil or (SwapLeft == nil or SwapRight == nil) then
        return nil, nil, nil;
    end;

    return v94, SwapLeft, SwapRight;
end;

function u2.ResolveGroundedToolRootCFrameAtLocation(p99, p100) -- Line: 415
    -- upvalues: Asserts (copy)
    Asserts.BasePart(p99);
    Asserts.Tool(p100);
    local Root = p100.Root;
    local v101 = Root:IsA("BasePart");
    local v102 = `Treadmill "{p100.Name}" Root must be a BasePart`;
    assert(v101, v102);
    local BoundingBoxPart = p100.BoundingBoxPart;
    local v103 = BoundingBoxPart:IsA("BasePart");
    local v104 = `Treadmill "{p100.Name}" BoundingBoxPart must be a BasePart`;
    assert(v103, v104);
    local v105 = Root.CFrame:PointToObjectSpace(BoundingBoxPart.CFrame.Position);
    local v106 = p100:GetAttribute("Offset") or 0;
    local v107 = p99.Position + Vector3.new(0, BoundingBoxPart.Size.Y * 0.5 + v106, 0);

    return CFrame.new(v107) * p99.CFrame.Rotation * CFrame.new(-v105);
end;

return u2;