-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local LotteryCustom = require(ReplicatedStorage.Library.Functions.LotteryCustom);
local Assets = require(ReplicatedStorage.Directory.Assets);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local Directory = Assets.Directory;
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local u1 = require(ReplicatedStorage.Library.Modules.BetterRandom).new();
local AssetRollScaleWeights = require(script.Parent.AssetRollScaleWeights);
local Mutations = require(ReplicatedStorage.Library.Modules.Mutations);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local TableUtil = require(ReplicatedStorage.Library.Modules.Packages.TableUtil);
local VirtualRollLuckUtil = require(ReplicatedStorage.Library.Util.VirtualRollLuckUtil);
local u2 = Random.new();
local u3 = Random.new();
local u4 = Log.new():LimitUnderLevel("Warning");
local u5 = "";
local u6 = {};
local u7 = {
    LuckBoost = 0,
    ScaleBoost = 0,
    MutationsBoost = 0
};

for i, v in pairs(Directory) do
    if u5 == "" then
        u5 = i;
    end;

    local DropWeight = v.DropWeight;

    if DropWeight > 0 and (not v.DontRoll and v.Rarity ~= Rarity.Rarities.Eternal) then
        table.insert(u6, { i, DropWeight });
    end;
end;

assert(#u6 > 0, "No valid category drop entries found");
local u8 = Mutations.GetMutationsDropTable();
local u9 = Mutations.GetMutations();
local u10 = {};

local function computeVirtualRolls(p11) -- Line: 70
    -- upvalues: VirtualRollLuckUtil (copy)
    return VirtualRollLuckUtil.ComputeVirtualRolls(p11);
end;

local function cloneBoosts() -- Line: 74
    -- upvalues: u7 (copy)
    return table.clone(u7);
end;

local function applyLinearBoostToTokenWeights(p12, p13) -- Line: 78
    -- upvalues: TableUtil (copy), u4 (copy)
    if p13 <= 0 then
        return TableUtil.Copy(p12, true);
    end;

    local v14 = p13 / 100;
    local v15 = v14 / (v14 + 1) * 0.49;
    local v16 = (1 / 0);
    local v17 = 0;

    for _, v in ipairs(p12) do
        local v18 = v[2];

        if v18 < v16 then
            v16 = v18;
        end;

        v17 = v17 + v18;
    end;

    local v19 = {};
    local v20 = 0;

    for _, v in ipairs(p12) do
        local v21 = v[2];
        local v22 = v21 - (v21 - v16) * v15;
        table.insert(v19, { v[1], v22 });
        v20 = v20 + v22;
    end;

    local v23 = v20 == 0 and 1 or v17 / v20;

    for _, v in ipairs(v19) do
        v[2] = v[2] * v23;
    end;

    u4:AtTrace():Log((`applyLinearBoost boostPct={p13} factor={v15} k={v23}`));

    return v19;
end;

local function applyLinearBoostToScaleWeights(p24, p25) -- Line: 120
    -- upvalues: TableUtil (copy), u4 (copy)
    if p25 <= 0 then
        return TableUtil.Copy(p24, true);
    end;

    local v26 = p25 / 100;
    local v27 = v26 / (v26 + 1) * 0.49;
    local v28 = (1 / 0);
    local v29 = 0;

    for _, v in ipairs(p24) do
        local v30 = v[2];

        if v30 < v28 then
            v28 = v30;
        end;

        v29 = v29 + v30;
    end;

    local v31 = {};
    local v32 = 0;

    for _, v in ipairs(p24) do
        local v33 = v[2];
        local v34 = v33 - (v33 - v28) * v27;
        table.insert(v31, { v[1], v34 });
        v32 = v32 + v34;
    end;

    local v35 = v32 == 0 and 1 or v29 / v32;

    for _, v in ipairs(v31) do
        v[2] = v[2] * v35;
    end;

    u4:AtTrace():Log((`applyLinearBoost boostPct={p25} factor={v27} k={v35}`));

    return v31;
end;

local function buildWeightedTokenEntry(p36, p37) -- Line: 162
    return { p36, p37 };
end;

local function getPositiveAssetDropWeight(p38) -- Line: 169
    local DropWeight = p38.DropWeight;

    return (typeof(DropWeight) ~= "number" or DropWeight <= 0) and 0 or DropWeight;
end;

local function buildAssetDropTableForRarityToken(p39, p40) -- Line: 174
    -- upvalues: Assets (copy)
    local v41 = Assets.ByRarity[p40];
    local v42 = `Missing Assets.ByRarity entry for "{p39}" token "{p40}"`;
    assert(v41 ~= nil, v42);
    local v43 = {};

    for i, v in pairs(v41) do
        local DropWeight = v.DropWeight;
        local v44 = (typeof(DropWeight) ~= "number" or DropWeight <= 0) and 0 or DropWeight;

        if v44 > 0 then
            table.insert(v43, { i, v44 });
        end;
    end;

    local v45 = `"{p39}" rarity token "{p40}" has no weighted assets`;
    assert(#v43 > 0, v45);

    return v43;
end;

function u10.ChooseCategory(p46, p47, p48) -- Line: 194
    -- upvalues: u7 (copy), VirtualRollLuckUtil (copy), u6 (copy), u3 (copy), u5 (ref), u4 (copy)
    local v49 = table.clone(u7);
    local v50 = table.clone(u7);
    local v51 = VirtualRollLuckUtil.ComputeVirtualRolls((v49.LuckBoost or 0) + (v50.LuckBoost or 0) + (p47 or 0));
    local v52 = VirtualRollLuckUtil.RollToken(u6, v51, p48 or u3);

    if typeof(v52) == "string" and v52 ~= "" then
        return v52;
    end;

    local v53 = u5 == "" and "" or u5;
    u4:AtError():Log((`Failed to choose a category, using default '{v53}'`));

    return v53;
end;

function u10.ChooseCategoryFromRarityToken(p54, p55, p56) -- Line: 211
    -- upvalues: LotteryCustom (copy), buildAssetDropTableForRarityToken (copy)
    local v57 = LotteryCustom(p56, (buildAssetDropTableForRarityToken(p54, p55)));
    local v58;

    if typeof(v57) == "string" then
        v58 = v57 ~= "";
    else
        v58 = false;
    end;

    local v59 = `Invalid reward category for "{p54}" token "{p55}"`;
    assert(v58, v59);

    return v57;
end;

function u10.ChooseCategoryFromAssetDropTable(p60, p61, p62, p63) -- Line: 221
    -- upvalues: Asserts (copy), VirtualRollLuckUtil (copy), LotteryCustom (copy), Assets (copy)
    Asserts.finite(p62);
    assert(p62 >= 1, "Asset category virtual rolls must be at least one");
    local v64;

    if p62 > 1 then
        v64 = VirtualRollLuckUtil.RollToken(p61, p62, p63);
    else
        v64 = LotteryCustom(p63, p61);
    end;

    local v65;

    if typeof(v64) == "string" then
        v65 = v64 ~= "";
    else
        v65 = false;
    end;

    local v66 = `Invalid asset category for "{p60}"`;
    assert(v65, v66);
    local v67 = Assets.Types.AssetNameExists(v64);
    local v68 = `Asset drop table "{p60}" rolled unknown asset "{v64}"`;
    assert(v67, v68);

    return v64;
end;

function u10.ChooseCategoryFromRarityDropTable(p69, p70, p71) -- Line: 239
    -- upvalues: LotteryCustom (copy), u10 (copy)
    local v72 = LotteryCustom(p71, p70);
    local v73;

    if typeof(v72) == "string" then
        v73 = v72 ~= "";
    else
        v73 = false;
    end;

    local v74 = `Invalid rarity token for "{p69}"`;
    assert(v73, v74);

    return u10.ChooseCategoryFromRarityToken(p69, v72, p71);
end;

function u10.ChooseMutations(p75, p76, p77) -- Line: 250
    -- upvalues: u7 (copy), u2 (copy), applyLinearBoostToTokenWeights (copy), u8 (copy), u4 (copy), LotteryCustom (copy), u9 (copy)
    local v78 = table.clone(u7);
    local v79 = table.clone(u7);
    local v80 = p77 or u2;
    local v81 = applyLinearBoostToTokenWeights(u8, (v78.MutationsBoost or 0) + (v79.MutationsBoost or 0) + (p76 or 0));
    u4:AtInfo():Log((`Choosing mutations with extra chance: {0.5}`));
    local v82 = {};
    local v83 = LotteryCustom(v80, v81);

    if typeof(v83) == "string" and v83 ~= "None" then
        table.insert(v82, v83);
    end;

    if #v82 > 0 and v80:NextNumber() < 0.5 then
        local v84 = LotteryCustom(v80, v81);

        if typeof(v84) == "string" and (v84 ~= "None" and not table.find(v82, v84)) then
            table.insert(v82, v84);
        end;
    end;

    table.sort(v82, function(p85, p86) -- Line: 272
        -- upvalues: u9 (ref)
        return u9[p85].DropWeight < u9[p86].DropWeight;
    end);

    return v82;
end;

function u10.RollScale(p87, p88, p89, p90) -- Line: 279
    -- upvalues: u7 (copy), applyLinearBoostToScaleWeights (copy), AssetRollScaleWeights (copy), Constants (copy), u4 (copy), u2 (copy), LotteryCustom (copy), u1 (copy)
    local v91 = table.clone(u7);
    local v92 = table.clone(u7);
    local v93 = applyLinearBoostToScaleWeights(AssetRollScaleWeights, (v91.ScaleBoost or 0) + (v92.ScaleBoost or 0) + (p88 or 0));
    local v94;

    if p89 and p90 then
        local v95 = {};
        local v96 = {};

        for i, v in ipairs(v93) do
            local Range = v[1].Range;
            local v97;

            if typeof(Range) == "table" then
                v97 = Range[#Range];
            else
                v97 = Range;
            end;

            if typeof(v97) == "number" then
                if p89 <= v97 * p90 then
                    table.insert(v95, v);
                    table.insert(v96, i);
                end;
            else
                local v98 = `Invalid scale range {Range} for entry {i}, expected number`;

                if Constants.IS_STUDIO then
                    error(v98);
                else
                    u4:AtWarning():Log(v98);
                end;
            end;
        end;

        if #v95 == 0 then
            return p89 / p90, #AssetRollScaleWeights;
        end;

        if u2:NextInteger(1, 10) == 1 and #v95 > 1 then
            v93 = {};
            v94 = {};

            for i = 2, #v95 do
                table.insert(v93, v95[i]);
                table.insert(v94, v96[i]);
            end;
        else
            v93 = { v95[1] };
            v94 = { v96[1] };
        end;
    else
        v94 = nil;
    end;

    local v99, _, _, v100 = LotteryCustom(nil, v93);

    if not v99 then
        u4:AtError():Log("Failed to choose a scale, defaulting to 1x");

        return 1, 1;
    end;

    local Range = v99.Range;

    if typeof(Range) == "table" then
        if p89 and p90 then
            local v101 = Range[#Range];

            if v101 * p90 <= p89 then
                Range = p89 / p90;
            else
                Range = u1:numberArray({ p89 / p90, v101 });
            end;
        else
            Range = u1:numberArray(Range);
        end;
    end;

    if v94 then
        v100 = v94[v100] or v100;
    end;

    return typeof(Range) == "number" and Range and Range or 1, v100;
end;

return u10;