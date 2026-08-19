-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local t = require(ReplicatedStorage.Library.Modules.Packages.t);
local FreeGifts = require(ReplicatedStorage.Library.Types.FreeGifts);

return {
    DefaultConfig = t.interface({
        Id = t.number,
        Type = FreeGifts.SchemaValidation.AllDifficulties,
        WaitTime = t.number,
        TypeData = FreeGifts.SchemaValidation.TypeData,
        Rewards = t.array(FreeGifts.SchemaValidation.RewardConfig)
    })
};