-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
require(ReplicatedStorage.Library.Types.Eggs);

return {
    RollScale = function(p1, p2, p3, p4, p5) -- Line: 24, Name: RollScale
        -- upvalues: Asserts (copy)
        Asserts.table(p1);
        Asserts.optional.number(p3);
        Asserts.optional.number(p4);
        Asserts.optional.func(p5);
        local v6 = p2 or Random.new();
        local v7 = 0;

        for _, v in ipairs(p1) do
            Asserts.number(v.min);
            Asserts.number(v.max);
            Asserts.number(v.weight);
            assert(v.max >= v.min, "Scale tier max must be greater than or equal to min");
            assert(v.weight > 0, "Scale tier weight must be positive");
            local v8 = not p5 and 1 or p5(v.min, v.max);
            Asserts.finite(v8);
            assert(v8 > 0, "Scale tier weight multiplier must be positive");
            v7 = v7 + v.weight * v8;
        end;

        assert(v7 > 0, "Scale tier table must include positive weight");
        local v9 = p1[1];
        local v10 = v6:NextNumber() * v7;
        local v11 = 0;

        for _, v in ipairs(p1) do
            local v12 = not p5 and 1 or p5(v.min, v.max);
            v11 = v11 + v.weight * v12;

            if v10 <= v11 then
                v9 = v;
                break;
            end;
        end;

        local v13 = v9.min + v6:NextNumber() * (v9.max - v9.min);
        local v14 = p4 or 0;

        if p3 and v14 > 0 then
            while v13 * 2 <= p3 and v6:NextNumber() <= v14 do
                v13 = v13 * 2;
            end;
        end;

        return v13;
    end
};