-- Decompiled with Potassium's decompiler.

function HMAC(p1, p2, p3, p4)
    if p2 < #p3 then
        p3 = p1(p3);
    end;

    local v5 = p3 .. string.rep("\0", p2 - #p3);
    local v6 = string.rep("\\", p2);
    local v7 = string.rep("6", p2);
    local v8 = "";
    local v9 = "";

    for i = 1, p2 do
        local v10 = string.byte(v6, i);
        local v11 = string.byte(v5, i);
        local v12 = bit32.bxor(v10, v11);
        v8 = v8 .. string.char(v12);
        local v13 = string.byte(v7, i);
        local v14 = bit32.bxor(v13, v11);
        v9 = v9 .. string.char(v14);
    end;

    return p1(v8 .. p1(v9 .. p4));
end;

return HMAC;