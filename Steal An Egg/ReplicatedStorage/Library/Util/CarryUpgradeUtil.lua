-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local EternityNum = require(ReplicatedStorage.Library.Modules.EternityNum);
local GetPrice = require(ReplicatedStorage.Library.Functions.GetPrice);
local u1 = { 100, 1000000, 500000000, 100000000000, 100000000000000, 7000000000000000 };
local u4 = {
    GetCost = function(p2) -- Line: 28, Name: GetCost
        -- upvalues: Asserts (copy), u1 (copy), EternityNum (copy)
        Asserts.integerNonNegative(p2);

        if p2 < 1 then
            return nil;
        end;

        local v3 = u1[p2];

        if typeof(v3) == "number" then
            return EternityNum.fromNumber(v3);
        end;

        return nil;
    end
};

function u4.GetRobuxProductId(p5, p6) -- Line: 43
    -- upvalues: Asserts (copy), u4 (copy), ReplicatedStorage (copy)
    Asserts.integerNonNegative(p5);
    Asserts.integerNonNegative(p6);

    if p6 ~= 1 then
        return nil;
    end;

    if u4.GetCost(p5) then
        return require(ReplicatedStorage.Directory.Products).Directory.CarryUpgrade_1.ProductId;
    end;

    return nil;
end;

function u4.GetRobuxCost(p7, p8) -- Line: 60
    -- upvalues: Asserts (copy), u4 (copy), GetPrice (copy)
    Asserts.integerNonNegative(p7);
    Asserts.integerNonNegative(p8);
    local v9 = u4.GetRobuxProductId(p7, p8);

    if not v9 then
        return nil;
    end;

    local v10, v11 = GetPrice(v9, true);

    if v11 then
        return v10;
    end;

    return nil;
end;

return u4;