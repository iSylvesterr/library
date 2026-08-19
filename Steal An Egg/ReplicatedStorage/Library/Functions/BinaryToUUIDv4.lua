-- Decompiled with Potassium's decompiler.

local BinaryToInt = require(script.Parent.BinaryToInt);

return function(p1) -- Line: 3
    -- upvalues: BinaryToInt (copy)
    local v2;

    if type(p1) == "string" then
        v2 = #p1 >= 16;
    else
        v2 = false;
    end;

    assert(v2);
    local v3 = BinaryToInt(p1:sub(1, 4));
    local v4 = BinaryToInt(p1:sub(5, 8));
    local v5 = bit32.band(v4, 4294905855);
    local v6 = bit32.bor(v5, 16384);
    local v7 = BinaryToInt(p1:sub(9, 12));
    local v8 = bit32.band(v7, 1073741823);
    local v9 = bit32.bor(v8, 2147483648);
    local v10 = BinaryToInt(p1:sub(13, 16));

    return string.format("%08x%08x%08x%08x", v3, v6, v9, v10);
end;