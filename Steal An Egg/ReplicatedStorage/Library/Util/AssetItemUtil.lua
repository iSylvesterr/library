-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local AssetItem = require(ReplicatedStorage.Library.Types.AssetItem);
local Personalities = require(ReplicatedStorage.Directory.Assets.Personalities);
local Assets = require(ReplicatedStorage.Directory.Assets);
local AssetGenerationUtil = require(ReplicatedStorage.Library.Util.AssetGenerationUtil);
local Commas = require(ReplicatedStorage.Library.Functions.Commas);
local u1 = {};

local function createItemData(p2) -- Line: 23
    -- upvalues: Personalities (copy)
    return {
        Scale = 1,
        HasBeenFirstPlaced = true,
        Category = p2,
        Mutations = {},
        Personality = Personalities.Personalities.Normal
    };
end;

function u1.GetIndexMoneyRewardAmount(p3) -- Line: 37
    -- upvalues: Personalities (copy), AssetGenerationUtil (copy)
    local v4 = AssetGenerationUtil.GetBaseRateMutationOnly({
        Scale = 1,
        HasBeenFirstPlaced = true,
        Category = p3,
        Mutations = {},
        Personality = Personalities.Personalities.Normal
    }) * 100;

    return math.round(v4);
end;

function u1.GetIndexSpeedRewardAmount(p5) -- Line: 44
    -- upvalues: Assets (copy)
    return Assets.Directory[p5].IndexSpeedReward;
end;

function u1.GetVisualWeightKg(p6) -- Line: 49
    -- upvalues: AssetItem (copy), Assets (copy)
    assert(AssetItem.AssetItemData(p6));

    return Assets.Directory[p6.Category].ModelWeight * math.max(p6.Scale, 0) ^ 3;
end;

function u1.GetVisualWeightKgDisplay(p7) -- Line: 59
    -- upvalues: Commas (copy), u1 (copy)
    local v8 = u1.GetVisualWeightKg(p7) * 100;
    local v9 = math.round(v8) / 100;

    return `{Commas((math.max(v9, 0)))}Kg`;
end;

return u1;