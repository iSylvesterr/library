-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local u1 = FastFlags.Replicated("Game.Sell.GlobalMultiplier", Asserts.FinitePositive, 1);
local u2 = FastFlags.Replicated("Game.Sell.PriceMultipliers", Asserts.Map(Asserts.String, Asserts.FinitePositive), {
    Mushroom = 0.5
});
local u3 = FastFlags.Replicated("Game.Sell.DailyDealMultiplier", Asserts.FinitePositive, 2.2);
local u4 = FastFlags.Replicated("Game.Sell.Bargain.MaxOfferMultiple", Asserts.FinitePositive, 1000);
local v5 = FastFlags.Replicated("Game.Sell.DoubleOrNothing.Enabled", Asserts.Boolean, true);

return table.freeze({
    GlobalMultiplier = u1,
    PriceMultipliers = u2,
    DailyDealMultiplier = u3,
    MaxOfferMultiple = u4,
    DoubleOrNothingEnabled = v5,

    Apply = function(p6, p7) -- Line: 60, Name: Apply
        -- upvalues: u1 (copy), u2 (copy)
        return p7 * u1:Get() * (u2:Get()[p6] or 1);
    end,

    DailyDealPrice = function(p8) -- Line: 70, Name: DailyDealPrice
        -- upvalues: u3 (copy)
        if p8 <= 0 then
            return 0;
        end;

        local v9 = p8 * u3:Get();
        local v10 = math.floor(v9);

        return math.max(1, v10);
    end,

    CapOffer = function(p11, p12) -- Line: 80, Name: CapOffer
        -- upvalues: u4 (copy)
        if p11 <= 0 then
            return 0;
        end;

        local v13 = p11 * u4:Get();

        return math.min(p12, v13);
    end
});