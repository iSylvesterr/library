-- Decompiled with Potassium's decompiler.

local u1 = { "Buy 1", "Buy 2", "Buy 3", "Buy 4", "Buy 5", "Buy 6", "Buy 7", "Buy 8", "Buy 9", "Buy 10" };
local u2 = { 1000, 5000, 25000, 75000, 200000, 450000, 1000000, 2000000, 4000000 };

return {
    gearRobuxProduct = function(p3) -- Line: 4, Name: gearRobuxProduct
        -- upvalues: u2 (copy), u1 (copy)
        local v4 = 0;

        while v4 < #u2 and u2[v4 + 1] < p3 do
            v4 = v4 + 1;
        end;

        return u1[v4 + 1];
    end
};