-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Library.Types.EggItem);
local UnpackCFrame = require(ReplicatedStorage.Library.Functions.UnpackCFrame);
local PackCFrame = require(ReplicatedStorage.Library.Functions.PackCFrame);

return {
    Serialize = function(p1) -- Line: 14, Name: Serialize
        -- upvalues: UnpackCFrame (copy)
        local v2 = {
            EggName = p1.EggName,
            IsFavorite = p1.IsFavorite
        };
        local v3;

        if p1.CFrame then
            v3 = UnpackCFrame(p1.CFrame) or nil;
        else
            v3 = nil;
        end;

        v2.CFrame = v3;
        v2.TimeToHatch = p1.TimeToHatch;
        v2.HatchEndTime = p1.HatchEndTime;
        v2.IsActive = p1.IsActive;
        v2.SlotIndex = p1.SlotIndex;
        v2.Scale = p1.Scale;

        return v2;
    end,

    Deserialize = function(p4) -- Line: 27, Name: Deserialize
        -- upvalues: PackCFrame (copy)
        local v5 = {
            EggName = p4.EggName,
            IsFavorite = p4.IsFavorite
        };
        local v6;

        if p4.CFrame then
            v6 = PackCFrame(p4.CFrame) or nil;
        else
            v6 = nil;
        end;

        v5.CFrame = v6;
        v5.TimeToHatch = p4.TimeToHatch;
        v5.HatchEndTime = p4.HatchEndTime;
        v5.IsActive = p4.IsActive;
        v5.SlotIndex = p4.SlotIndex;
        v5.Scale = p4.Scale;

        return v5;
    end
};