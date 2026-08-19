-- Decompiled with Potassium's decompiler.

local Comb = require(script.Parent:WaitForChild("Comb"));

return function(...) -- Line: 3
    -- upvalues: Comb (copy)
    local u1 = table.pack(...);
    local u2 = u1.n - 1;
    local v3 = 0;

    for i = 1, u2 do
        v3 = v3 + (u1[i] - u1[i + 1]).Magnitude;
    end;

    local u4 = {};

    for i = 0, u2 do
        table.insert(u4, Comb(u2, i));
    end;

    return function(p5) -- Line: 14
        -- upvalues: u2 (copy), u4 (copy), u1 (copy)
        local v6 = Vector3.new(0, 0, 0);

        for i = 0, u2 do
            local v7 = u4[i + 1] * math.pow(1 - p5, u2 - i) * math.pow(p5, i);
            v6 = v6 + u1[i + 1] * v7;
        end;

        return v6;
    end, v3;
end;