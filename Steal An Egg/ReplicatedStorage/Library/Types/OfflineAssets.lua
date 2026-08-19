-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local t = require(ReplicatedStorage.Library.Modules.Packages.t);

return {
    OfflineClaimSummary = t.interface({
        ClaimableAmount = t.number,
        ReservedAmount = t.number,
        TotalAmount = t.number,
        IsMultiplierPurchasePending = t.boolean
    }),
    OfflineRedeemResult = t.interface({
        BaseAmount = t.number,
        AwardedAmount = t.number,
        ClaimedByUid = t.map(t.string, t.number)
    })
};