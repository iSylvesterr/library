-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local t = require(ReplicatedStorage.Library.Modules.Packages.t);

return {
    CaughtRevealRewardPayload = t.interface({
        requestId = t.string,
        blockId = t.string,
        rewardCategory = t.string,
        rewardMutations = t.array(t.string),
        rewardBaseMutation = t.optional(t.string),
        rewardScale = t.number,
        highestRarityName = t.string,
        highestRarityNumber = t.number
    }),
    BeginRunPayload = t.interface({
        chargePower = t.number
    }),
    ActiveRunMutationHitPayload = t.interface({
        mutationName = t.string
    })
};