-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local HttpService = game:GetService("HttpService");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Areas = require(ReplicatedStorage.Directory.Areas);
local AssetColorUtil = require(ReplicatedStorage.Library.Util.AssetColorUtil);
local Assets = require(ReplicatedStorage.Directory.Assets);
local Personalities = require(ReplicatedStorage.Directory.Assets.Personalities);
local AssetRollUtil = require(ReplicatedStorage.Library.Util.AssetRollUtil);
local Eggs = require(ReplicatedStorage.Library.Types.Eggs);
local Commas = require(ReplicatedStorage.Library.Functions.Commas);
local PackCFrame = require(ReplicatedStorage.Library.Functions.PackCFrame);
local UnpackCFrame = require(ReplicatedStorage.Library.Functions.UnpackCFrame);
local WeightedScaleRollUtil = require(ReplicatedStorage.Library.Util.WeightedScaleRollUtil);
local AssetItemUtil = require(ReplicatedStorage.Library.Util.AssetItemUtil);
local AssetItem = require(ReplicatedStorage.Library.Types.AssetItem);
local AssetGenderUtil = require(ReplicatedStorage.Library.Util.AssetGenderUtil);
local AreaEggResetTimeUtil = require(ReplicatedStorage.Library.Util.AreaEggResetTimeUtil);
local GetPriceValueForItem = require(ReplicatedStorage.Library.Util.GetPriceValueForItem);
local u1 = { {
        min = 0.85,
        max = 1.05,
        weight = 2000
    }, {
        min = 1.45,
        max = 1.55,
        weight = 250
    }, {
        min = 1.9,
        max = 2.1,
        weight = 125
    }, {
        min = 2.85,
        max = 3.15,
        weight = 62.5
    }, {
        min = 3.8,
        max = 4.2,
        weight = 31.25
    }, {
        min = 0.3,
        max = 0.45,
        weight = 18
    }, {
        min = 0.1,
        max = 0.2,
        weight = 5
    }, {
        min = 5.8,
        max = 6.2,
        weight = 15.625
    }, {
        min = 9.5,
        max = 12.5,
        weight = 3
    }, {
        min = 12,
        max = 17,
        weight = 0.05
    }, {
        min = 20,
        max = 35,
        weight = 0.0001
    } };
local u2 = Random.new();
local u3 = {};
local u4 = {};

local function getSizeGrowthMultiplier(p5) -- Line: 110
    if p5 <= 2 then
        return 1;
    end;

    if p5 <= 6 then
        return (p5 / 2) ^ 1.389;
    end;

    return math.min((p5 / 6) ^ 0.72 * 4.6, 20);
end;

local function updateTemporaryGrowthBoosts() -- Line: 120
    -- upvalues: u4 (ref), HttpService (copy)
    local u6 = workspace:GetAttribute("TemporaryGrowthBoosts");

    if type(u6) ~= "string" or u6 == "" then
        return;
    end;

    xpcall(function() -- Line: 124
        -- upvalues: u4 (ref), HttpService (ref), u6 (copy)
        u4 = HttpService:JSONDecode(u6);
    end, function() -- Line: 126
        -- upvalues: u4 (ref)
        u4 = {};
    end);
end;

workspace:GetAttributeChangedSignal("TemporaryGrowthBoosts"):Connect(updateTemporaryGrowthBoosts);
task.spawn(updateTemporaryGrowthBoosts);

local function getServerGrowthBonusSeconds(p7) -- Line: 133
    -- upvalues: u4 (ref)
    if not p7 then
        return 0;
    end;

    local v8 = p7:GetAttribute("JoinTick");

    if type(v8) ~= "number" then
        return 0;
    end;

    local v9 = 0;

    for _, v in u4 do
        local v10 = math.max(v.StartedAt, v8);
        local v11 = workspace:GetServerTimeNow();
        local v12 = (math.min(v11, v.EndsAt) - v10) * v.Multiplier;
        v9 = v9 + math.floor(v12);
    end;

    return v9;
end;

local function getServerGrowthMultiplier() -- Line: 155
    -- upvalues: u4 (ref)
    local v13 = 0;

    for _, v in u4 do
        v13 = v13 + v.Multiplier;
    end;

    return v13;
end;

function u3.RollAssetScale(p14, p15) -- Line: 169
    -- upvalues: WeightedScaleRollUtil (copy), u1 (copy)
    return WeightedScaleRollUtil.RollScale(u1, p14, 150, 0.01, p15);
end;

function u3.NormalizeSavedEgg(p16) -- Line: 179
    -- upvalues: AssetColorUtil (copy)
    local v17 = AssetColorUtil.ResolveFields(p16.AssetCategory, p16.AssetEyeColor, p16.AssetColorSeed, p16.AssetColorIndex);
    local v18 = table.clone(p16);
    v18.AssetEyeColor = v17.EyeColor;
    v18.AssetColorSeed = v17.ColorSeed;
    v18.AssetColorIndex = v17.ColorIndex;

    return v18;
end;

function u3.SerializePlacement(p19) -- Line: 193
    -- upvalues: UnpackCFrame (copy)
    return {
        LocalCFrame = UnpackCFrame(p19.LocalCFrame),
        PlacedAt = p19.PlacedAt,
        GrowthDuration = p19.GrowthDuration,
        GrowthCreditSeconds = p19.GrowthCreditSeconds,
        NightGrowthPeriodIndex = p19.NightGrowthPeriodIndex,
        NightGrowthCreditSeconds = p19.NightGrowthCreditSeconds,
        ReadyAt = p19.ReadyAt
    };
end;

function u3.DeserializePlacement(p20) -- Line: 205
    -- upvalues: PackCFrame (copy)
    return {
        LocalCFrame = PackCFrame(p20.LocalCFrame),
        PlacedAt = p20.PlacedAt,
        GrowthDuration = p20.GrowthDuration,
        GrowthCreditSeconds = p20.GrowthCreditSeconds,
        NightGrowthPeriodIndex = p20.NightGrowthPeriodIndex,
        NightGrowthCreditSeconds = p20.NightGrowthCreditSeconds,
        ReadyAt = p20.ReadyAt
    };
end;

function u3.GetGrowthDuration(p21) -- Line: 217
    -- upvalues: Eggs (copy), Asserts (copy), Assets (copy)
    local v22 = Eggs.SchemaValidation.SavedEgg(p21);
    assert(v22, "Invalid saved egg record");
    local v23 = assert(p21.Placement, "Egg growth duration requires a placed egg");

    if v23.GrowthDuration ~= nil then
        return v23.GrowthDuration;
    end;

    Asserts.finite(p21.AssetScale);
    assert(p21.AssetScale > 0, "Egg growth scale must be positive");
    local v24 = Assets.Directory[p21.AssetCategory];
    local v25 = `Missing asset config {p21.AssetCategory}`;
    assert(v24 ~= nil, v25);
    local GrowthTime = v24.Egg.GrowthTime;
    local AssetScale = p21.AssetScale;
    local v26;

    if AssetScale <= 2 then
        v26 = 1;
    elseif AssetScale <= 6 then
        v26 = (AssetScale / 2) ^ 1.389;
    else
        v26 = math.min((AssetScale / 6) ^ 0.72 * 4.6, 20);
    end;

    return GrowthTime * v26;
end;

function u3.GetGrowthSpeedMultiplier(p27) -- Line: 233
    -- upvalues: Asserts (copy)
    Asserts.boolean(p27);
    local v28 = 1;

    if p27 then
        v28 = v28 + 1;
    end;

    return v28;
end;

function u3.GetRemainingGrowthWallSeconds(p29, p30, p31, p32) -- Line: 244
    -- upvalues: u3 (copy)
    local v33 = u3.GetRemainingGrowthSeconds(p29, p30, p31, p32);

    return v33 <= 0 and 0 or (v33 <= 0 and 0 or 0 + v33 / p31);
end;

function u3.GetGrowthCreditSeconds(p34) -- Line: 264
    -- upvalues: Asserts (copy)
    local Placement = p34.Placement;

    if Placement == nil then
        return 0;
    end;

    local v35 = Placement.GrowthCreditSeconds or 0;
    Asserts.finiteNonNegative(v35);

    return v35;
end;

function u3.GetCommittedNightGrowthCreditSeconds(p36, p37) -- Line: 275
    -- upvalues: Asserts (copy)
    Asserts.integerNonNegative(p37);
    local Placement = p36.Placement;

    if Placement == nil then
        return 0;
    end;

    Asserts.optional.integerNonNegative(Placement.NightGrowthPeriodIndex);

    if Placement.NightGrowthPeriodIndex ~= p37 then
        return 0;
    end;

    local v38 = Placement.NightGrowthCreditSeconds or 0;
    Asserts.finiteNonNegative(v38);

    return v38;
end;

function u3.GetNightGrowthCreditSecondsAt(p39, p40, p41, p42, p43) -- Line: 291
    -- upvalues: Asserts (copy), u3 (copy), AreaEggResetTimeUtil (copy)
    Asserts.finite(p40);
    Asserts.finite(p41);
    Asserts.finite(p42);
    Asserts.integerNonNegative(p43);
    assert(p41 > 0, "Egg growth speed multiplier must be positive");
    local Placement = p39.Placement;

    if Placement == nil or (Placement.ReadyAt ~= nil or p42 < Placement.PlacedAt) then
        return 0;
    end;

    local v44 = u3.GetCommittedNightGrowthCreditSeconds(p39, p43);
    local v45 = u3.GetRemainingGrowthSeconds(p39, p42, p41) + v44;
    local v46 = AreaEggResetTimeUtil.GetNightGrowthSecondsAt(p40, p42);
    local v47 = math.min(v46, v45) - v44;

    return math.max(0, v47);
end;

function u3.GetCurrentNightGrowthCreditSeconds(p48, p49, p50) -- Line: 317
    -- upvalues: AreaEggResetTimeUtil (copy), u3 (copy)
    if not AreaEggResetTimeUtil.IsNight(p49) then
        return 0;
    end;

    local v51 = AreaEggResetTimeUtil.GetNightStartsAt(p49);
    local v52 = v51 + AreaEggResetTimeUtil.GetNightDurationSeconds();

    return u3.GetNightGrowthCreditSecondsAt(p48, p49, p50, v51, AreaEggResetTimeUtil.GetPeriodIndex(v52));
end;

function u3.GetGrowthAlpha(p53, p54, p55, p56, p57) -- Line: 337
    -- upvalues: Asserts (copy), u3 (copy), getServerGrowthBonusSeconds (copy)
    Asserts.finite(p54);
    Asserts.finite(p55);
    Asserts.optional.finiteNonNegative(p56);
    assert(p55 > 0, "Egg growth speed multiplier must be positive");
    local Placement = p53.Placement;

    if Placement == nil then
        return 0;
    end;

    if Placement.ReadyAt ~= nil then
        return 1;
    end;

    local v58 = u3.GetGrowthDuration(p53);

    if v58 <= 0 then
        return 1;
    end;

    local v59 = u3.GetGrowthCreditSeconds(p53) + (p56 or 0) + getServerGrowthBonusSeconds(p57);

    return math.clamp(((p54 - Placement.PlacedAt) * p55 + v59) / v58, 0, 1);
end;

function u3.GetRemainingGrowthSeconds(p60, p61, p62, p63, p64) -- Line: 372
    -- upvalues: Asserts (copy), u3 (copy), getServerGrowthBonusSeconds (copy)
    Asserts.finite(p61);
    Asserts.finite(p62);
    Asserts.optional.finiteNonNegative(p63);
    assert(p62 > 0, "Egg growth speed multiplier must be positive");
    local v65 = assert(p60.Placement, "Egg remaining growth time requires a placed egg");

    if v65.ReadyAt ~= nil then
        return 0;
    end;

    local v66 = u3.GetGrowthCreditSeconds(p60) + (p63 or 0) + getServerGrowthBonusSeconds(p64);
    local v67 = u3.GetGrowthDuration(p60) - (p61 - v65.PlacedAt) * p62 - v66;

    return math.max(0, v67);
end;

function u3.IsGrowthReady(p68, p69, p70, p71, p72) -- Line: 400
    -- upvalues: u3 (copy)
    return u3.GetGrowthAlpha(p68, p69, p70, p71, p72) >= 1;
end;

function u3.SerializeSavedEgg(p73) -- Line: 410
    -- upvalues: u3 (copy)
    local v74 = u3.NormalizeSavedEgg(p73);
    local Placement = v74.Placement;
    local v75 = {
        AssetCategory = v74.AssetCategory,
        AssetScale = v74.AssetScale,
        AssetEyeColor = v74.AssetEyeColor,
        AssetColorSeed = v74.AssetColorSeed,
        AssetColorIndex = v74.AssetColorIndex
    };
    local v76;

    if v74.Mutations then
        v76 = table.clone(v74.Mutations);
    else
        v76 = nil;
    end;

    v75.Mutations = v76;
    v75.BaseMutation = v74.BaseMutation;
    v75.AssetGender = v74.AssetGender;
    v75.AssetPersonality = v74.AssetPersonality;
    v75.IsStolenDNA = v74.IsStolenDNA;
    local v77;

    if Placement then
        v77 = u3.SerializePlacement(Placement);
    else
        v77 = nil;
    end;

    v75.Placement = v77;

    return v75;
end;

function u3.DeserializeSavedEgg(p78) -- Line: 428
    -- upvalues: u3 (copy)
    local Placement = p78.Placement;
    local NormalizeSavedEgg = u3.NormalizeSavedEgg;
    local v79 = {
        AssetCategory = p78.AssetCategory,
        AssetScale = p78.AssetScale,
        AssetEyeColor = p78.AssetEyeColor,
        AssetColorSeed = p78.AssetColorSeed,
        AssetColorIndex = p78.AssetColorIndex
    };
    local v80;

    if p78.Mutations then
        v80 = table.clone(p78.Mutations);
    else
        v80 = nil;
    end;

    v79.Mutations = v80;
    v79.BaseMutation = p78.BaseMutation;
    v79.AssetGender = p78.AssetGender;
    v79.AssetPersonality = p78.AssetPersonality;
    v79.IsStolenDNA = p78.IsStolenDNA;
    local v81;

    if Placement then
        v81 = u3.DeserializePlacement(Placement);
    else
        v81 = nil;
    end;

    v79.Placement = v81;

    return NormalizeSavedEgg(v79);
end;

function u3.BuildSavedEgg(p82, p83) -- Line: 445
    -- upvalues: Asserts (copy), u2 (copy), AssetRollUtil (copy), AssetColorUtil (copy), u3 (copy), Eggs (copy)
    Asserts.string(p82);
    local v84 = p83 or u2;
    local v85 = AssetRollUtil.ChooseMutations(nil, nil, v84);
    local v86 = AssetColorUtil.RollFields(p82, v84);
    local v87 = {
        AssetCategory = p82,
        AssetScale = u3.RollAssetScale(v84),
        AssetEyeColor = v86.EyeColor,
        AssetColorSeed = v86.ColorSeed,
        AssetColorIndex = v86.ColorIndex,
        Mutations = v85,
        BaseMutation = v85[1]
    };
    local v88, v89 = Eggs.SchemaValidation.SavedEgg(v87);
    assert(v88, v89);

    return v87;
end;

function u3.BuildStolenDnaEgg(p90) -- Line: 467
    -- upvalues: AssetItem (copy), AssetGenderUtil (copy), Eggs (copy)
    assert(AssetItem.AssetItemData(p90));
    local v91 = {
        IsStolenDNA = true,
        AssetCategory = p90.Category,
        AssetScale = p90.Scale,
        AssetEyeColor = assert(p90.EyeColor, "Asset DNA requires a resolved eye color"),
        AssetColorSeed = assert(p90.ColorSeed, "Asset DNA requires a resolved color seed"),
        AssetColorIndex = assert(p90.ColorIndex, "Asset DNA requires a resolved color index"),
        Mutations = table.clone(p90.Mutations),
        BaseMutation = p90.BaseMutation,
        AssetGender = AssetGenderUtil.ResolveForCategory(p90.Category, p90.Gender),
        AssetPersonality = p90.Personality
    };
    local v92, v93 = Eggs.SchemaValidation.SavedEgg(v91);
    assert(v92, v93);

    return v91;
end;

function u3.BuildAssetItemData(p94) -- Line: 488
    -- upvalues: Eggs (copy), Personalities (copy)
    local v95 = Eggs.SchemaValidation.SavedEgg(p94);
    assert(v95, "Invalid saved egg record");

    return Personalities.CreateNewItemData({
        Category = p94.AssetCategory,
        Scale = p94.AssetScale,
        EyeColor = p94.AssetEyeColor,
        ColorSeed = p94.AssetColorSeed,
        ColorIndex = p94.AssetColorIndex,
        Mutations = p94.Mutations or {},
        BaseMutation = p94.BaseMutation,
        Gender = p94.AssetGender,
        IsStolenDNA = p94.IsStolenDNA
    }, nil, p94.AssetPersonality);
end;

function u3.GetSellPrice(p96) -- Line: 508
    -- upvalues: Eggs (copy), u3 (copy), GetPriceValueForItem (copy)
    local v97 = Eggs.SchemaValidation.SavedEgg(p96);
    assert(v97, "Invalid saved egg record");
    local v98 = table.clone(u3.BuildAssetItemData(p96));
    v98.Mutations = {};
    v98.BaseMutation = nil;

    return GetPriceValueForItem(v98) * 0.8;
end;

function u3.GetWeightKgForScale(p99, p100) -- Line: 518
    -- upvalues: Asserts (copy), AssetItemUtil (copy)
    Asserts.string(p99);
    Asserts.finite(p100);

    return AssetItemUtil.GetVisualWeightKg({
        Category = p99,
        Scale = p100,
        Mutations = {}
    });
end;

function u3.GetWeightKg(p101) -- Line: 529
    -- upvalues: Eggs (copy), u3 (copy)
    local v102 = Eggs.SchemaValidation.SavedEgg(p101);
    assert(v102, "Invalid saved egg record");

    return u3.GetWeightKgForScale(p101.AssetCategory, p101.AssetScale);
end;

function u3.GetWeightKgDisplay(p103) -- Line: 535
    -- upvalues: Commas (copy), u3 (copy)
    return `{Commas(u3.GetWeightKg(p103))}Kg`;
end;

function u3.GetDisplayName(p104) -- Line: 539
    -- upvalues: Eggs (copy), Assets (copy), Areas (copy)
    local v105 = Eggs.SchemaValidation.SavedEgg(p104);
    assert(v105, "Invalid saved egg record");
    local v106 = Assets.Directory[p104.AssetCategory];
    local v107 = `Missing asset config {p104.AssetCategory}`;
    assert(v106 ~= nil, v107);
    local _id = v106.Rarity._id;

    for _, v in pairs(Areas.Directory) do
        for _, v2 in ipairs(v.DropTable) do
            local v108 = v2[1];

            if v108 == p104.AssetCategory or v108 == _id then
                return `{v.DisplayName} Egg`;
            end;
        end;
    end;

    return "Egg";
end;

function u3.GetDisplayNameWithWeight(p109) -- Line: 557
    -- upvalues: u3 (copy)
    return `{u3.GetDisplayName(p109)} ({u3.GetWeightKgDisplay(p109)})`;
end;

function u3.GetServerGrowthBoostMultiplier() -- Line: 561
    -- upvalues: u4 (ref)
    local v110 = 0;

    for _, v in u4 do
        v110 = v110 + v.Multiplier;
    end;

    return v110;
end;

return u3;