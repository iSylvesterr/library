-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local AssetItem = require(ReplicatedStorage.Library.Types.AssetItem);
local Personalities = require(ReplicatedStorage.Directory.Assets.Personalities);
local AssetSizeClassification = require(ReplicatedStorage.Library.Util.AssetSizeClassification);
local Mutations = require(ReplicatedStorage.Library.Modules.Mutations);
local u1 = table.freeze({
    {
        MinimumScore = 6,
        Suffix = "Impossibly Rare",
        Color = Color3.fromRGB(255, 59, 127)
    },
    {
        MinimumScore = 5,
        Suffix = "Mega Rare",
        Color = Color3.fromRGB(255, 138, 0)
    },
    {
        MinimumScore = 4,
        Suffix = "Giga Rare",
        Color = Color3.fromRGB(255, 215, 0)
    },
    {
        MinimumScore = 3,
        Suffix = "Ultra Rare",
        Color = Color3.fromRGB(155, 81, 224)
    },
    {
        MinimumScore = 2,
        Suffix = "Super Rare",
        Color = Color3.fromRGB(47, 128, 237)
    },
    {
        MinimumScore = 0,
        Suffix = "Rare",
        Color = Color3.fromRGB(52, 199, 89)
    }
});
local v2 = {};

local function getBaseScore(p3) -- Line: 49
    return p3 >= 10 and 6 or (p3 >= 9 and 3 or (p3 >= 8 and 2 or (p3 >= 7 and 1 or (p3 >= 6 and 0.5 or 0))));
end;

local function getPersonalityScore(p4) -- Line: 65
    -- upvalues: Personalities (copy)
    local RollWeight = Personalities.GetConfig(p4.Personality).RollWeight;

    return RollWeight <= 1.5 and 1 or (RollWeight <= 2.5 and 0.75 or (RollWeight <= 3.5 and 0.5 or (RollWeight <= 7 and 0.25 or 0)));
end;

local function getMutationQualityScore(p5) -- Line: 80
    -- upvalues: Mutations (copy)
    local v6 = Mutations.GetMutation(p5);
    local v7 = `Unknown mutation "{p5}"`;
    local v8 = assert(v6, v7);
    local Odds = v8.Odds;

    if Odds and Odds > 0 then
        return Odds <= 0.01 and 0.5 or (Odds <= 0.04 and 0.35 or (Odds <= 0.07 and 0.25 or 0.1));
    end;

    local DropWeight = v8.DropWeight;

    return DropWeight > 0 and (DropWeight <= 1 and 0.5 or (DropWeight <= 4 and 0.35 or (DropWeight <= 7 and 0.25 or 0.1))) or 0.25;
end;

local function getMutationScore(p9, p10) -- Line: 111
    -- upvalues: getMutationQualityScore (copy)
    local u11 = {};
    local u12 = 0;
    local u13 = 0;

    local function includeMutation(p14) -- Line: 116
        -- upvalues: u11 (copy), u12 (ref), u13 (ref), getMutationQualityScore (ref)
        if p14 == nil or (p14 == "" or (p14 == "None" or u11[p14])) then
            return;
        end;

        u11[p14] = true;
        u12 = u12 + 1;
        local v15 = getMutationQualityScore(p14);
        u13 = math.max(u13, v15);
    end;

    local BaseMutation = p9.BaseMutation;

    if BaseMutation ~= nil and (BaseMutation ~= "" and (BaseMutation ~= "None" and not u11[BaseMutation])) then
        u11[BaseMutation] = true;
        u12 = u12 + 1;
        local v16 = getMutationQualityScore(BaseMutation);
        u13 = math.max(u13, v16);
    end;

    for _, v in ipairs(p9.Mutations) do
        if v ~= nil and (v ~= "" and v ~= "None") then
            if not u11[v] then
                u11[v] = true;
                u12 = u12 + 1;
                local v17 = getMutationQualityScore(v);
                u13 = math.max(u13, v17);
            end;
        end;
    end;

    return math.min(u12 * 0.5, 2) + u13 + (p10 >= 9 and u12 >= 4 and 0.5 or 0);
end;

local function resolveSuffixTier(p18) -- Line: 139
    -- upvalues: u1 (copy)
    for _, v in ipairs(u1) do
        if v.MinimumScore <= p18 then
            return v;
        end;
    end;

    error("DNA rarity suffix tiers must include a zero-score tier");
end;

function v2.Resolve(p19, p20) -- Line: 153
    -- upvalues: AssetItem (copy), Asserts (copy), Personalities (copy), getMutationScore (copy), u1 (copy), AssetSizeClassification (copy)
    assert(AssetItem.AssetItemData(p19));
    Asserts.number(p20);
    local RollWeight = Personalities.GetConfig(p19.Personality).RollWeight;
    local v21 = (p20 >= 10 and 6 or (p20 >= 9 and 3 or (p20 >= 8 and 2 or (p20 >= 7 and 1 or (p20 >= 6 and 0.5 or 0))))) + (RollWeight <= 1.5 and 1 or (RollWeight <= 2.5 and 0.75 or (RollWeight <= 3.5 and 0.5 or (RollWeight <= 7 and 0.25 or 0)))) + getMutationScore(p19, p20);

    for _, v in ipairs(u1) do
        if v.MinimumScore <= v21 then
            break;
        end;
    end;

    local v22 = AssetSizeClassification.Resolve(p19.Scale);
    local v23;

    if v22 then
        v23 = `{v22.Prefix} {v.Suffix}`;
    else
        v23 = v.Suffix;
    end;

    local v24;

    if v22 then
        v24 = v22.Color;
    else
        v24 = v.Color;
    end;

    local v25 = {
        Article = v22 == nil and (v.Suffix == "Ultra Rare" or v.Suffix == "Impossibly Rare") and "an" or "a",
        Descriptor = v23,
        RichText = `<font color="#{v24:ToHex()}">{v23}</font>`,
        Score = v21
    };
    local v26;

    if v22 then
        v26 = v22.Prefix;
    else
        v26 = nil;
    end;

    v25.SizePrefix = v26;
    local v27;

    if v22 then
        v27 = v22.RichText;
    else
        v27 = nil;
    end;

    v25.SizeRichText = v27;

    return v25;
end;

return v2;