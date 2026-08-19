-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Simple = require(ReplicatedStorage.Library.Modules.FormatNumber.Simple);
local AssetItem = require(ReplicatedStorage.Library.Types.AssetItem);
local Mutations = require(ReplicatedStorage.Library.Modules.Mutations);
local u1 = {};

local function truncateToSignificantDigits(p2) -- Line: 31
    local v3 = math.log10(p2);
    local v4 = 10 ^ (math.floor(v3) - 3 + 1);

    return math.floor(p2 / v4) * v4;
end;

local function getCompactSkeleton(p5) -- Line: 38
    if p5 < 1000 then
        return ".";
    end;

    local v6 = math.log10(p5) / 3;
    local v7 = p5 / 1000 ^ math.floor(v6);

    return v7 < 10 and ".##" or (v7 < 100 and ".#" or ".");
end;

local function formatOddsDenominator(p8) -- Line: 57
    -- upvalues: Simple (copy)
    local v9 = math.max(1, p8);
    local v10 = math.log10(v9);
    local v11 = 10 ^ (math.floor(v10) - 3 + 1);
    local v12 = math.floor(v9 / v11) * v11;
    local lower = string.lower;
    local FormatCompact = Simple.FormatCompact;
    local v13;

    if v12 < 1000 then
        v13 = ".";
    else
        local v14 = math.log10(v12) / 3;
        local v15 = v12 / 1000 ^ math.floor(v14);
        v13 = v15 < 10 and ".##" or (v15 < 100 and ".#" or ".");
    end;

    return lower(FormatCompact(v12, v13));
end;

local function resolveVisualOdds(p16) -- Line: 62
    local VisualOdds = p16.VisualOdds;

    if typeof(VisualOdds) == "number" and VisualOdds > 0 then
        return VisualOdds;
    end;

    local DropWeight = p16.DropWeight;

    if typeof(DropWeight) == "number" and DropWeight > 0 then
        return 1 / DropWeight;
    end;

    return nil;
end;

function u1.FormatDenominator(p17) -- Line: 80
    -- upvalues: Asserts (copy), formatOddsDenominator (copy)
    Asserts.finite(p17);

    return formatOddsDenominator(p17);
end;

function u1.GetDenominator(p18, p19) -- Line: 86
    -- upvalues: Asserts (copy), Mutations (copy)
    Asserts.table(p18);
    local VisualOdds = p18.VisualOdds;

    if typeof(VisualOdds) ~= "number" or VisualOdds <= 0 then
        local DropWeight = p18.DropWeight;

        if typeof(DropWeight) == "number" and DropWeight > 0 then
            VisualOdds = 1 / DropWeight;
        else
            VisualOdds = nil;
        end;
    end;

    if VisualOdds == nil then
        return nil;
    end;

    return VisualOdds * (p19 == nil and 1 or Mutations.GetVisualOddsMultiplier(p19.Mutations, p19.BaseMutation));
end;

function u1.GetDisplay(p20, p21, p22) -- Line: 100
    -- upvalues: Asserts (copy), u1 (copy), Simple (copy)
    Asserts.table(p20);
    local v23 = u1.GetDenominator(p20, p22);

    if v23 == nil then
        return "1/?";
    end;

    local v24 = math.max(1, v23);
    local v25 = math.log10(v24);
    local v26 = 10 ^ (math.floor(v25) - 3 + 1);
    local v27 = math.floor(v24 / v26) * v26;
    local lower = string.lower;
    local FormatCompact = Simple.FormatCompact;
    local v28;

    if v27 < 1000 then
        v28 = ".";
    else
        local v29 = math.log10(v27) / 3;
        local v30 = v27 / 1000 ^ math.floor(v29);
        v28 = v30 < 10 and ".##" or (v30 < 100 and ".#" or ".");
    end;

    return `{p21 and "1 in " or "1/"}{lower(FormatCompact(v27, v28))}`;
end;

function u1.GetDisplayForItemData(p31, p32, p33) -- Line: 115
    -- upvalues: AssetItem (copy), u1 (copy)
    assert(AssetItem.AssetItemData(p32));

    return u1.GetDisplay(p31, p33, {
        Mutations = p32.Mutations,
        BaseMutation = p32.BaseMutation
    });
end;

return u1;