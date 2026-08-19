-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local EternityNum = require(ReplicatedStorage.Library.Modules.EternityNum);
local BASE_JUMP_HEIGHT = Constants.BASE_JUMP_HEIGHT;
local u1 = {};

local function getCostForN(p2, p3) -- Line: 22
    -- upvalues: EternityNum (copy), u1 (copy)
    local v4 = EternityNum.fromNumber(1.1653);
    local v5 = EternityNum.fromNumber(1);

    return EternityNum.mul(u1.GetCost(p2), EternityNum.div(EternityNum.sub(EternityNum.pow(v4, EternityNum.fromNumber(p3)), v5), EternityNum.sub(v4, v5)));
end;

function u1.GetCost(p6) -- Line: 35
    -- upvalues: EternityNum (copy), BASE_JUMP_HEIGHT (copy)
    return EternityNum.mul(EternityNum.fromNumber(200), EternityNum.pow(EternityNum.fromNumber(1.1653), EternityNum.fromNumber(p6 + 1 - BASE_JUMP_HEIGHT)));
end;

function u1.GetCostFor5(p7) -- Line: 45
    -- upvalues: getCostForN (copy)
    return getCostForN(p7, 5);
end;

function u1.GetCostFor10(p8) -- Line: 49
    -- upvalues: getCostForN (copy)
    return getCostForN(p8, 10);
end;

function u1.GetRobuxCost(p9) -- Line: 53
    -- upvalues: BASE_JUMP_HEIGHT (copy)
    return BASE_JUMP_HEIGHT <= p9 and p9 < 19 and 9 or (p9 >= 19 and p9 < 39 and 19 or (p9 >= 39 and p9 < 59 and 29 or (p9 >= 59 and p9 < 79 and 49 or (p9 >= 79 and p9 < 99 and 69 or (p9 >= 99 and p9 < 119 and 99 or (p9 >= 119 and p9 < 139 and 139 or (p9 >= 139 and p9 < 159 and 179 or (p9 >= 159 and 229 or 0))))))));
end;

function u1.GetJumpModifierFromPower(p10) -- Line: 85
    -- upvalues: Asserts (copy), Constants (copy)
    Asserts.number(p10);
    local BASE_JUMP_HEIGHT2 = Constants.BASE_JUMP_HEIGHT;
    Asserts.finiteNonNegative(BASE_JUMP_HEIGHT2);

    return BASE_JUMP_HEIGHT2 <= 0 and 0 or p10 / BASE_JUMP_HEIGHT2 - 1;
end;

return u1;