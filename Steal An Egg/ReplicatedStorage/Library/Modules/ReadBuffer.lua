-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;

function u1.new(p2) -- Line: 4
    -- upvalues: u1 (copy)
    return setmetatable({
        offset = 0,
        buf = p2
    }, u1);
end;

function u1.ResetReadPos(p3) -- Line: 12
    p3.offset = 0;
end;

function u1.ReadU8(p4) -- Line: 16
    local v5 = buffer.readu8(p4.buf, p4.offset);
    p4.offset = p4.offset + 1;

    return v5;
end;

function u1.ReadI16(p6) -- Line: 22
    local v7 = buffer.readu16(p6.buf, p6.offset);
    p6.offset = p6.offset + 2;

    return v7;
end;

function u1.ReadVector3(p8) -- Line: 28
    local v9 = buffer.readf32(p8.buf, p8.offset);
    p8.offset = p8.offset + 4;
    local v10 = buffer.readf32(p8.buf, p8.offset);
    p8.offset = p8.offset + 4;
    local v11 = buffer.readf32(p8.buf, p8.offset);
    p8.offset = p8.offset + 4;

    return Vector3.new(v9, v10, v11);
end;

function u1.ReadFloat16(p12) -- Line: 39
    local v13 = buffer.readu8(p12.buf, p12.offset);
    p12.offset = p12.offset + 1;
    local v14 = buffer.readu8(p12.buf, p12.offset);
    p12.offset = p12.offset + 1;
    local v15 = bit32.btest(v13, 128);
    local v16 = bit32.band(v13, 127);
    local v17 = bit32.rshift(v16, 2);
    local v18 = bit32.band(v13, 3);
    local v19 = bit32.lshift(v18, 8) + v14;

    if v17 == 31 then
        return v19 == 0 and (v15 and (-1 / 0) or (1 / 0)) or (0 / 0);
    end;

    if v17 == 0 then
        return v19 == 0 and 0 or (v15 and -math.ldexp(v19 / 1024, -14) or math.ldexp(v19 / 1024, -14));
    end;

    local v20 = v19 / 1024 + 1;

    return v15 and -math.ldexp(v20, v17 - 15) or math.ldexp(v20, v17 - 15);
end;

return u1;