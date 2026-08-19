-- Decompiled with Potassium's decompiler.

local u1 = Random.new();

return function(p2, p3, p4) -- Line: 6
    -- upvalues: u1 (copy)
    local v5 = {};
    local v6 = {};

    for i = 1, #p2 do
        table.insert(v5, i);
    end;

    local v7 = p4 or u1;

    for _ = 1, p3 do
        local v8 = v7:NextInteger(1, #v5);
        local v9 = p2[table.remove(v5, v8)];
        table.insert(v6, v9);
    end;

    return v6;
end;