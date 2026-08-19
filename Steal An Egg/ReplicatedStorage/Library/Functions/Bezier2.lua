-- Decompiled with Potassium's decompiler.

local Comb = require(script.Parent.Comb);

return function(...) -- Line: 3
    -- upvalues: Comb (copy)
    local u1 = table.pack(...);
    local u2 = u1.n - 1;
    local u3 = {};

    for i = 0, u2 do
        table.insert(u3, Comb(u2, i));
    end;

    return function(p4) -- Line: 12
        -- upvalues: u2 (copy), u3 (copy), u1 (copy)
        local v5 = Vector2.new();

        for i = 0, u2 do
            local v6 = u3[i + 1] * math.pow(1 - p4, u2 - i) * math.pow(p4, i);
            v5 = v5 + u1[i + 1] * v6;
        end;

        return v5;
    end;
end;