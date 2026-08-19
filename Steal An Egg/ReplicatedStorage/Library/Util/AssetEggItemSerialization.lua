-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Library.Types.AssetEggItem);
local UnpackCFrame = require(ReplicatedStorage.Library.Functions.UnpackCFrame);
local PackCFrame = require(ReplicatedStorage.Library.Functions.PackCFrame);

return {
    Serialize = function(p1) -- Line: 14, Name: Serialize
        -- upvalues: UnpackCFrame (copy)
        local v2 = {
            EggName = p1.EggName,
            Mutations = p1.Mutations,
            IsFavorite = p1.IsFavorite
        };
        local v3;

        if p1.CFrame then
            v3 = UnpackCFrame(p1.CFrame) or nil;
        else
            v3 = nil;
        end;

        v2.CFrame = v3;
        v2.IsActive = p1.IsActive;
        v2.Scale = p1.Scale;
        v2.CreationTime = p1.CreationTime;
        v2.NestSlotIndex = p1.NestSlotIndex;
        v2.GrowthStartedAt = p1.GrowthStartedAt;
        v2.GrowthDuration = p1.GrowthDuration;

        return v2;
    end,

    Deserialize = function(p4) -- Line: 31, Name: Deserialize
        -- upvalues: PackCFrame (copy)
        local v5 = {
            EggName = p4.EggName,
            Mutations = p4.Mutations,
            IsFavorite = p4.IsFavorite
        };
        local v6;

        if p4.CFrame then
            v6 = PackCFrame(p4.CFrame) or nil;
        else
            v6 = nil;
        end;

        v5.CFrame = v6;
        v5.IsActive = p4.IsActive;
        v5.Scale = p4.Scale;
        v5.CreationTime = p4.CreationTime;
        v5.NestSlotIndex = p4.NestSlotIndex;
        v5.GrowthStartedAt = p4.GrowthStartedAt;
        v5.GrowthDuration = p4.GrowthDuration;

        return v5;
    end
};