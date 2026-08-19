-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local MonetizationGamepassUtil = require(ReplicatedStorage.Library.Util.MonetizationGamepassUtil);
require(ReplicatedStorage.Library.Types.Monetization);
local RebirthUtil = require(script.Parent.RebirthUtil);
local Assets = require(ReplicatedStorage.Directory.Assets);
local AssetItem = require(ReplicatedStorage.Library.Types.AssetItem);
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Mutations = require(ReplicatedStorage.Library.Modules.Mutations);
local Signal = require(ReplicatedStorage.Library.Signal);
local u1 = {};

local function getSizeEarningMultiplier(p2) -- Line: 28
    -- upvalues: Asserts (copy)
    Asserts.finite(p2);
    assert(p2 > 0, "Asset scale must be greater than 0");

    if p2 <= 5 then
        return p2 ^ 1.85;
    end;

    return (p2 / 5) ^ 1.2 * 19.637875755794113;
end;

function u1.GetRate(p3, p4, p5, p6) -- Line: 44
    -- upvalues: AssetItem (copy), Asserts (copy), Assets (copy), Mutations (copy), RebirthUtil (copy), MonetizationGamepassUtil (copy)
    assert(AssetItem.AssetItemData(p3));
    Asserts.number(p4);
    local v7 = Assets.Directory[p3.Category];
    local v8 = v7 and tonumber(v7.EarningRate) or 0;
    local Scale = p3.Scale;
    Asserts.finite(Scale);
    assert(Scale > 0, "Asset scale must be greater than 0");
    local v9;

    if Scale <= 5 then
        v9 = Scale ^ 1.85;
    else
        v9 = (Scale / 5) ^ 1.2 * 19.637875755794113;
    end;

    local v10 = Mutations.GetTotalMutationsEarningMulti(p3.Mutations);
    local v11 = math.max(1, RebirthUtil.RebirthToMultiplier(p4)) + MonetizationGamepassUtil.GetAssetMoneyAdditiveRebirthBonus(p5, p6);
    local v12 = math.round(v8 * v9 * v10 * v11);

    return math.max(v12, 1);
end;

function u1.GetRateWithoutBoosts(p13) -- Line: 66
    -- upvalues: AssetItem (copy), Assets (copy), Asserts (copy)
    assert(AssetItem.AssetItemData(p13));
    local v14 = Assets.Directory[p13.Category];
    local v15 = v14 and tonumber(v14.EarningRate) or 0;
    local Scale = p13.Scale;
    Asserts.finite(Scale);
    assert(Scale > 0, "Asset scale must be greater than 0");
    local v16;

    if Scale <= 5 then
        v16 = Scale ^ 1.85;
    else
        v16 = (Scale / 5) ^ 1.2 * 19.637875755794113;
    end;

    return v15 * v16;
end;

function u1.GetBaseRateMutationOnly(p17) -- Line: 74
    -- upvalues: AssetItem (copy), u1 (copy)
    assert(AssetItem.AssetItemData(p17));

    return u1.GetRate(p17, 0);
end;

function u1.GetRateWithoutRebirth(p18, p19, p20) -- Line: 80
    -- upvalues: AssetItem (copy), u1 (copy)
    assert(AssetItem.AssetItemData(p18));

    return u1.GetRate(p18, 0, p19, p20);
end;

Signal.Invoked(Signal.MAP.Shared.AssetGenerationUtil.GET_BASE_RATE_MUTATION_ONLY).OnInvoke = u1.GetBaseRateMutationOnly;

return u1;