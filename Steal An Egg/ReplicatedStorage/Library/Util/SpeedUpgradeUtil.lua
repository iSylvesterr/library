-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local EternityNum = require(ReplicatedStorage.Library.Modules.EternityNum);
local GetPrice = require(ReplicatedStorage.Library.Functions.GetPrice);
local BASE_WALK_SPEED = Constants.BASE_WALK_SPEED;
local u1 = {};

local function getCostForN(p2, p3) -- Line: 23
    -- upvalues: EternityNum (copy), u1 (copy)
    local v4 = EternityNum.fromNumber(1.1653);
    local v5 = EternityNum.fromNumber(1);

    return EternityNum.mul(u1.GetCost(p2), EternityNum.div(EternityNum.sub(EternityNum.pow(v4, EternityNum.fromNumber(p3)), v5), EternityNum.sub(v4, v5)));
end;

function u1.GetCost(p6) -- Line: 36
    -- upvalues: EternityNum (copy), BASE_WALK_SPEED (copy)
    return EternityNum.mul(EternityNum.fromNumber(200), EternityNum.pow(EternityNum.fromNumber(1.1653), EternityNum.fromNumber(p6 + 1 - BASE_WALK_SPEED)));
end;

function u1.GetCostFor5(p7) -- Line: 46
    -- upvalues: getCostForN (copy)
    return getCostForN(p7, 5);
end;

function u1.GetCostFor10(p8) -- Line: 50
    -- upvalues: getCostForN (copy)
    return getCostForN(p8, 10);
end;

function u1.GetRobuxProductId(p9, p10) -- Line: 54
    -- upvalues: Asserts (copy), ReplicatedStorage (copy), BASE_WALK_SPEED (copy), Constants (copy)
    Asserts.integerNonNegative(p9);
    Asserts.integerNonNegative(p10);
    local Products = require(ReplicatedStorage.Directory.Products);

    for _, v in ipairs({
        {
            Min = BASE_WALK_SPEED,
            Max = Constants.BASE_WALK_SPEED,
            Products = {
                [1] = Products.Directory.SpeedUpgrade_1_Tier1,
                [5] = Products.Directory.SpeedUpgrade_5_Tier1,
                [10] = Products.Directory.SpeedUpgrade_10_Tier1
            }
        },
        {
            Min = 19,
            Max = 38,
            Products = {
                [1] = Products.Directory.SpeedUpgrade_1_Tier2,
                [5] = Products.Directory.SpeedUpgrade_5_Tier2,
                [10] = Products.Directory.SpeedUpgrade_10_Tier2
            }
        },
        {
            Min = 39,
            Max = 58,
            Products = {
                [1] = Products.Directory.SpeedUpgrade_1_Tier3,
                [5] = Products.Directory.SpeedUpgrade_5_Tier3,
                [10] = Products.Directory.SpeedUpgrade_10_Tier3
            }
        },
        {
            Min = 59,
            Max = 78,
            Products = {
                [1] = Products.Directory.SpeedUpgrade_1_Tier4,
                [5] = Products.Directory.SpeedUpgrade_5_Tier4,
                [10] = Products.Directory.SpeedUpgrade_10_Tier4
            }
        },
        {
            Min = 79,
            Max = 98,
            Products = {
                [1] = Products.Directory.SpeedUpgrade_1_Tier5,
                [5] = Products.Directory.SpeedUpgrade_5_Tier5,
                [10] = Products.Directory.SpeedUpgrade_10_Tier5
            }
        },
        {
            Min = 99,
            Max = 118,
            Products = {
                [1] = Products.Directory.SpeedUpgrade_1_Tier6,
                [5] = Products.Directory.SpeedUpgrade_5_Tier6,
                [10] = Products.Directory.SpeedUpgrade_10_Tier6
            }
        },
        {
            Min = 119,
            Max = 138,
            Products = {
                [1] = Products.Directory.SpeedUpgrade_1_Tier7,
                [5] = Products.Directory.SpeedUpgrade_5_Tier7,
                [10] = Products.Directory.SpeedUpgrade_10_Tier7
            }
        },
        {
            Min = 139,
            Max = 158,
            Products = {
                [1] = Products.Directory.SpeedUpgrade_1_Tier8,
                [5] = Products.Directory.SpeedUpgrade_5_Tier8,
                [10] = Products.Directory.SpeedUpgrade_10_Tier8
            }
        },
        {
            Min = 159,
            Max = (1 / 0),
            Products = {
                [1] = Products.Directory.SpeedUpgrade_1_Tier9,
                [5] = Products.Directory.SpeedUpgrade_5_Tier9,
                [10] = Products.Directory.SpeedUpgrade_10_Tier9
            }
        }
    }) do
        if v.Min <= p9 and p9 <= v.Max then
            local v11 = v.Products[p10];

            return v11 and v11.ProductId or nil;
        end;
    end;

    return nil;
end;

function u1.GetRobuxCost(p12, p13) -- Line: 153
    -- upvalues: Asserts (copy), u1 (copy), GetPrice (copy)
    Asserts.integerNonNegative(p12);
    Asserts.integerNonNegative(p13);
    local v14 = u1.GetRobuxProductId(p12, p13);

    if not v14 then
        return nil;
    end;

    local v15, v16 = GetPrice(v14, true);

    if v16 then
        return v15;
    end;

    return nil;
end;

function u1.GetSpeedModifierFromPower(p17) -- Line: 170
    -- upvalues: Asserts (copy), Constants (copy)
    Asserts.number(p17);
    local BASE_WALK_SPEED2 = Constants.BASE_WALK_SPEED;
    Asserts.finiteNonNegative(BASE_WALK_SPEED2);

    return BASE_WALK_SPEED2 <= 0 and 0 or p17 / BASE_WALK_SPEED2 - 1;
end;

return u1;