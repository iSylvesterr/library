-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SellValueData = require(script.Parent.SellValueData);
local MutationData = require(script.Parent.MutationData);
local SeedData = require(script.Parent.SeedData);
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local u1 = FastFlags.Replicated("Game.Selling.SizeMultiplier", Asserts.FinitePositive, 1);
local u2 = FastFlags.Replicated("Game.Selling.MutationMultiplier", Asserts.FinitePositive, 1);
local u3 = FastFlags.Replicated("Game.Selling.SizeExponent", Asserts.FinitePositive, 2.5);
local u4 = FastFlags.Replicated("Game.Selling.SizeExponentOverrides", Asserts.Map(Asserts.String, Asserts.FinitePositive), {
    Mushroom = 1.9,
    Bamboo = 1.75
});
local u5 = FastFlags.Replicated("Game.Selling.SingleHarvestMutationBonusScale", Asserts.FiniteNonNegative, 0.15);
local u6 = FastFlags.Replicated("Game.Selling.SizeDiminishingReturns.Enabled", Asserts.Boolean, true);
local u7 = FastFlags.Replicated("Game.Selling.SizeDiminishingReturns.Knee", Asserts.FinitePositive, 5);
local u8 = FastFlags.Replicated("Game.Selling.SizeDiminishingReturns.TailExponent", Asserts.FinitePositive, 1.5);
local u9 = {};
local v10 = {};
local v11 = {};
local u12 = {
    Carrot = 4
};

for _, v in SeedData do
    u9[v.SeedName] = v.IsSingleHarvest == true;
    v10[v.SeedName] = 1;
    v11[v.SeedName] = 1;
end;

local u13 = FastFlags.Replicated("Game.Selling.SizeDiminishingReturns.KneeMultipliers", Asserts.Map(Asserts.String, Asserts.FinitePositive), v10);
local u14 = FastFlags.Replicated("Game.Selling.SizeDiminishingReturns.TailExponentMultipliers", Asserts.Map(Asserts.String, Asserts.FinitePositive), v11);

return function(p15, p16, p17, p18, p19) -- Line: 122, Name: Calculate
    -- upvalues: SellValueData (copy), u4 (copy), u3 (copy), u6 (copy), u7 (copy), u13 (copy), u8 (copy), u14 (copy), u1 (copy), MutationData (copy), u9 (copy), u5 (copy), u2 (copy), u12 (copy)
    local v20 = SellValueData[p15] or 0;
    local v21 = u4:Get()[p15] or u3:Get();
    local v22 = p16 ^ v21;

    if u6:Get() then
        local v23 = u7:Get() * (u13:Get()[p15] or 1);

        if v23 < p16 then
            local v24 = u8:Get() * (u14:Get()[p15] or 1);
            local v25 = math.min(v24, v21);
            v22 = v23 ^ v21 * (p16 / v23) ^ v25;
        end;
    end;

    local v26 = u1:Get();
    local v27;

    if p17 then
        local v28 = MutationData.ReturnPriceMultiplier(p17);

        if u9[p15] and v28 > 1 then
            v28 = 1 + (v28 - 1) * u5:Get();
        end;

        v27 = v28 * u2:Get();
    else
        v27 = 1;
    end;

    local v29 = (typeof(p19) ~= "number" or p19 <= 0) and 1 or 1 - math.clamp(p19, 0, 1) * 0.8;
    local v30 = 1 + (p18:GetAttribute("Friends") or 0) * 0.1;
    local v31 = u12[p15];
    local v32 = math.floor(v20 * v22 * v26 * v27 * v29 * v30);

    if v31 then
        if v32 >= v31 then
            v31 = v32;
        end;
    else
        v31 = v32;
    end;

    return v31;
end;