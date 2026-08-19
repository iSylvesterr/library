-- Decompiled with Potassium's decompiler.

local u1 = Random.new();

return function(p2, p3) -- Line: 3
    -- upvalues: u1 (copy)
    local v4 = p3 or u1;

    for i = #p2, 2, -1 do
        local v5 = v4:NextInteger(1, i);
        local v6 = p2[i];
        p2[i] = p2[v5];
        p2[v5] = v6;
    end;

    return p2;
end;