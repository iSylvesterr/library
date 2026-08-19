-- Decompiled with Potassium's decompiler.

local ServerStorage = game:GetService("ServerStorage");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local u1 = {
    Gold = require(script.Gold),
    Rainbow = require(script.Rainbow),
    Electric = require(script.Electric),
    Frozen = require(script.Frozen),
    Bloodlit = require(script.Bloodlit),
    Chained = require(script.Chained),
    Starstruck = require(script.Starstruck),
    Aurora = require(script.Aurora),
    Ignited = require(script.Ignited),
    Glow = require(script.Glow),
    Eclipsed = require(script.Eclipsed),
    Veil = require(script.Veil),
    Amber = require(script.Amber)
};
local v2 = {};
local v3 = {};

for i, v in u1 do
    v2[i] = v.PriceMultiplier or 1;
end;

local u4 = FastFlags.Replicated("Game.Mutations.PriceMultipliers", Asserts.Map(Asserts.String, Asserts.FinitePositive), v2);

local function getChanceMultiplier(p5) -- Line: 45
    -- upvalues: ServerStorage (copy)
    local MutationChanceMultipliers = ServerStorage:FindFirstChild("MutationChanceMultipliers");

    if not MutationChanceMultipliers then
        return 1;
    end;

    local v6 = MutationChanceMultipliers:FindFirstChild(p5);

    if not (v6 and v6:IsA("NumberValue")) then
        return 1;
    end;

    local Value = v6.Value;

    return Value <= 0 and 1 or Value;
end;

local function ComputeChanceWindow(p7, p8) -- Line: 68
    local v9 = math.floor(p7);
    local v10 = 1 / math.max(v9, 1);

    return (p8 <= 1 or v10 >= 0.3) and {
        GlobalChance = v10,
        EffectiveChance = v10
    } or {
        GlobalChance = v10,
        EffectiveChance = math.min(v10 * p8, 0.3)
    };
end;

function v3.GetMutation(p11) -- Line: 80
    -- upvalues: u1 (copy)
    return u1[p11];
end;

function v3.ReturnPriceMultiplier(p12) -- Line: 84
    -- upvalues: u4 (copy), u1 (copy)
    local v13 = u4:Get()[p12];

    if v13 then
        return v13;
    end;

    local v14 = u1[p12];

    return v14 and (v14.PriceMultiplier or 1) or 1;
end;

function v3.ReturnFruitMutation(p15, p16) -- Line: 101
    -- upvalues: u1 (copy), ServerStorage (copy), ComputeChanceWindow (copy)
    local v17 = Random.new(p15);

    for i, v in u1 do
        if v.FruitChance and v.CanGetOnGrowth then
            local MutationChanceMultipliers = ServerStorage:FindFirstChild("MutationChanceMultipliers");
            local v18;

            if MutationChanceMultipliers then
                local v19 = MutationChanceMultipliers:FindFirstChild(i);

                if v19 and v19:IsA("NumberValue") then
                    local Value = v19.Value;
                    v18 = Value <= 0 and 1 or Value;
                else
                    v18 = 1;
                end;
            else
                v18 = 1;
            end;

            local v20 = p16 and (p16[i] or 1) or 1;
            local v21 = ComputeChanceWindow(v.FruitChance / v18, v20);
            local v22 = v17:NextNumber();

            if v22 < v21.EffectiveChance then
                local v23;

                if v20 > 1 then
                    v23 = v21.GlobalChance <= v22;
                else
                    v23 = false;
                end;

                return i, v23;
            end;
        end;
    end;

    return nil, false;
end;

function v3.ReturnPlantMutation(p24, p25) -- Line: 119
    -- upvalues: u1 (copy), ServerStorage (copy), ComputeChanceWindow (copy)
    local v26 = Random.new(p24);

    for i, v in u1 do
        if v.PlantChance and v.CanGetOnGrowth then
            local MutationChanceMultipliers = ServerStorage:FindFirstChild("MutationChanceMultipliers");
            local v27;

            if MutationChanceMultipliers then
                local v28 = MutationChanceMultipliers:FindFirstChild(i);

                if v28 and v28:IsA("NumberValue") then
                    local Value = v28.Value;
                    v27 = Value <= 0 and 1 or Value;
                else
                    v27 = 1;
                end;
            else
                v27 = 1;
            end;

            local v29 = p25 and (p25[i] or 1) or 1;
            local v30 = ComputeChanceWindow(v.PlantChance / v27, v29);
            local v31 = v26:NextNumber();

            if v31 < v30.EffectiveChance then
                local v32;

                if v29 > 1 then
                    v32 = v30.GlobalChance <= v31;
                else
                    v32 = false;
                end;

                return i, v32;
            end;
        end;
    end;

    return nil, false;
end;

return v3;