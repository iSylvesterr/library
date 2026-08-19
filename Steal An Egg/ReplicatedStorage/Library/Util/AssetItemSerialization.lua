-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local AssetColorUtil = require(ReplicatedStorage.Library.Util.AssetColorUtil);
local AssetGenderUtil = require(ReplicatedStorage.Library.Util.AssetGenderUtil);
require(ReplicatedStorage.Library.Types.AssetItem);
local v1 = {};

local function sanitizeMutations(p2) -- Line: 23
    local v3 = {};

    for _, v in ipairs(p2) do
        if typeof(v) == "string" and (v ~= "" and v ~= "None") then
            table.insert(v3, v);
        end;
    end;

    return v3;
end;

local function resolveGender(p4, p5) -- Line: 35
    -- upvalues: AssetGenderUtil (copy)
    return AssetGenderUtil.ResolveForCategory(p4, p5) == "Male" and "Male" or "Female";
end;

function v1.Serialize(p6) -- Line: 48
    -- upvalues: sanitizeMutations (copy), AssetColorUtil (copy), AssetGenderUtil (copy)
    local v7 = sanitizeMutations(p6.Mutations);
    local BaseMutation = p6.BaseMutation;

    if typeof(BaseMutation) ~= "string" or (BaseMutation == "" or BaseMutation == "None") then
        BaseMutation = v7[1];
    end;

    local v8 = AssetColorUtil.ResolveFields(p6.Category, p6.EyeColor, p6.ColorSeed, p6.ColorIndex);
    local v9 = AssetGenderUtil.ResolveForCategory(p6.Category, p6.Gender) == "Male" and "Male" or "Female";

    return {
        Category = p6.Category,
        Mutations = v7,
        BaseMutation = BaseMutation,
        Scale = p6.Scale,
        Gender = v9,
        EyeColor = v8.EyeColor,
        ColorSeed = v8.ColorSeed,
        ColorIndex = v8.ColorIndex,
        IsFavorite = p6.IsFavorite,
        GeneratedMoney = p6.GeneratedMoney,
        LastTick = p6.LastTick,
        PendingEggName = p6.PendingEggName,
        Claimed = p6.Claimed,
        LuckyBlockUnlockTimestamp = p6.LuckyBlockUnlockTimestamp,
        LuckyBlockUnlockDuration = p6.LuckyBlockUnlockDuration,
        LuckyBlockInstantUnlock = p6.LuckyBlockInstantUnlock,
        InFuse = p6.InFuse or false,
        SpecialLuckyBlockColumn = p6.SpecialLuckyBlockColumn,
        SpecialLuckyBlockCapturedAt = p6.SpecialLuckyBlockCapturedAt,
        Personality = p6.Personality,
        HasBeenFirstPlaced = p6.HasBeenFirstPlaced,
        IsStolenDNA = p6.IsStolenDNA
    };
end;

function v1.Deserialize(p10) -- Line: 84
    -- upvalues: sanitizeMutations (copy), AssetColorUtil (copy), AssetGenderUtil (copy)
    local v11 = sanitizeMutations(p10.Mutations);
    local BaseMutation = p10.BaseMutation;

    if typeof(BaseMutation) ~= "string" or (BaseMutation == "" or BaseMutation == "None") then
        BaseMutation = v11[1];
    end;

    local v12 = AssetColorUtil.ResolveFields(p10.Category, p10.EyeColor, p10.ColorSeed, p10.ColorIndex);
    local v13 = AssetGenderUtil.ResolveForCategory(p10.Category, p10.Gender) == "Male" and "Male" or "Female";

    return {
        Category = p10.Category,
        Mutations = v11,
        BaseMutation = BaseMutation,
        Scale = p10.Scale,
        Gender = v13,
        EyeColor = v12.EyeColor,
        ColorSeed = v12.ColorSeed,
        ColorIndex = v12.ColorIndex,
        IsFavorite = p10.IsFavorite,
        GeneratedMoney = p10.GeneratedMoney,
        LastTick = p10.LastTick,
        PendingEggName = p10.PendingEggName,
        Claimed = p10.Claimed,
        LuckyBlockUnlockTimestamp = p10.LuckyBlockUnlockTimestamp,
        LuckyBlockUnlockDuration = p10.LuckyBlockUnlockDuration,
        LuckyBlockInstantUnlock = p10.LuckyBlockInstantUnlock,
        InFuse = p10.InFuse or false,
        SpecialLuckyBlockColumn = p10.SpecialLuckyBlockColumn,
        SpecialLuckyBlockCapturedAt = p10.SpecialLuckyBlockCapturedAt,
        Personality = p10.Personality,
        HasBeenFirstPlaced = p10.HasBeenFirstPlaced,
        IsStolenDNA = p10.IsStolenDNA
    };
end;

return v1;