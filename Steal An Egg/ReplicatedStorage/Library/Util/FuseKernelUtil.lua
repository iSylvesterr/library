-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local AssetGenerationUtil = require(ReplicatedStorage.Library.Util.AssetGenerationUtil);
local AssetItem = require(ReplicatedStorage.Library.Types.AssetItem);
local Directory = require(ReplicatedStorage.Directory.Assets).Directory;
local EggItemUtil = require(ReplicatedStorage.Library.Util.EggItemUtil);
require(ReplicatedStorage.Library.Modules.Packages.Log).new();
local u1 = {};

local function getAverageScale(p2) -- Line: 31
    -- upvalues: Asserts (copy)
    Asserts.table(p2);
    assert(#p2 == 3, "Fused scale roll requires exactly three input scales");
    local v3 = 0;

    for _, v in ipairs(p2) do
        Asserts.finite(v);
        assert(v > 0, "Fuse input scale must be positive");
        v3 = v3 + v;
    end;

    return v3 / #p2;
end;

function u1.CanSelectPet(p4, p5, p6, p7) -- Line: 49
    -- upvalues: Asserts (copy), AssetItem (copy), Directory (copy)
    Asserts.string(p4);
    assert(AssetItem.SerializedAssetItemData(p5));
    Asserts.optional.string(p6);
    Asserts.boolean(p7);
    local v8 = Directory[p5.Category];

    if v8 == nil or v8.CannotFuse == true then
        return false, "That pet cannot be fused";
    end;

    if p5.IsFavorite == true then
        return false, "Favorite pets cannot be fused";
    end;

    if p7 then
        if p5.InFuse ~= true then
            return false, "That pet is not in this fuse machine";
        end;
    elseif p5.InFuse == true then
        return false, "That pet is already in a fuse machine";
    end;

    if p6 == nil or p5.Category == p6 then
        return true, nil;
    end;

    return false, "All three pets must be the same category";
end;

function u1.GetScaleTierWeightMultiplier(p9, p10, p11) -- Line: 81
    -- upvalues: Asserts (copy), getAverageScale (copy)
    Asserts.finite(p10);
    Asserts.finite(p11);
    assert(p10 > 0, "Scale tier minimum must be positive");
    assert(p10 <= p11, "Scale tier maximum must be greater than or equal to its minimum");
    local v12 = getAverageScale(p9);
    local v13 = math.log(v12) / 0.6931471805599453 * (math.log((p10 + p11) / 2) / 0.6931471805599453) * 0.6;

    return math.exp(v13);
end;

function u1.RollFusedAssetScale(u14, p15) -- Line: 96
    -- upvalues: getAverageScale (copy), EggItemUtil (copy), u1 (copy)
    getAverageScale(u14);

    return EggItemUtil.RollAssetScale(p15, function(p16, p17) -- Line: 99
        -- upvalues: u1 (ref), u14 (copy)
        return u1.GetScaleTierWeightMultiplier(u14, p16, p17);
    end);
end;

function u1.CalculateFusePrice(p18) -- Line: 104
    -- upvalues: AssetItem (copy), AssetGenerationUtil (copy)
    assert(AssetItem.AssetItemDataArray(p18));
    assert(#p18 == 3, "Fuse price requires exactly three pets");
    local v19 = 0;
    local v20 = 0;

    for _, v in ipairs(p18) do
        v19 = v19 + AssetGenerationUtil.GetRateWithoutRebirth(v) * 3 * 60;
        v20 = math.max(v20, #v.Mutations);
    end;

    local v21 = math.floor(v19) * (v20 == 1 and 2 or (v20 >= 2 and 3 or 1));

    return math.floor(v21);
end;

return u1;