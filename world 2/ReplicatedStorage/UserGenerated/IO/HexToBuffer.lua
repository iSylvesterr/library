-- Decompiled with Potassium's decompiler.

local u1 = {
    [48] = 0,
    [49] = 1,
    [50] = 2,
    [51] = 3,
    [52] = 4,
    [53] = 5,
    [54] = 6,
    [55] = 7,
    [56] = 8,
    [57] = 9,
    [65] = 10,
    [66] = 11,
    [67] = 12,
    [68] = 13,
    [69] = 14,
    [70] = 15,
    [97] = 10,
    [98] = 11,
    [99] = 12,
    [100] = 13,
    [101] = 14,
    [102] = 15
};

return function(p2) -- Line: 45, Name: HexToBuffer
    -- upvalues: u1 (copy)
    local v3 = #p2;
    assert(v3 % 2 == 0, "hex length must be even");
    local v4 = buffer.create(v3 // 2);
    local v5 = 0;

    for i = 1, v3, 2 do
        local v6, v7 = string.byte(p2, i, i + 1);
        local v8 = u1[v6];

        if not v8 then
            error((`invalid hex at {i}`));
        end;

        local v9 = u1[v7];

        if not v9 then
            error((`invalid hex at {i + 1}`));
        end;

        buffer.writeu8(v4, v5, v8 * 16 + v9);
        v5 = v5 + 1;
    end;

    return v4;
end;