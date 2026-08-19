-- Decompiled with Potassium's decompiler.

local DataTypeBuffer = require(script.Parent.DataTypeBuffer);
require(script.Parent.Types);
local u1 = {};
u1.__index = u1;

function u1.new(p2) -- Line: 20
    -- upvalues: u1 (copy)
    local v3 = typeof(p2) ~= "number" and 0 or math.clamp(p2, 0, 1073741824);
    local v4 = {
        _cursor = 0,
        _size = 0,
        _buffer = buffer.create(v3)
    };

    return setmetatable(v4, u1);
end;

function u1._resizeUpTo(p5, p6) -- Line: 32
    if p6 > 1073741824 then
        error(`cannot resize buffer to {p6} bytes (max size: {1073741824} bytes)`, 3);
    end;

    p5._size = math.max(p5._size, p6);

    if p6 < buffer.len(p5._buffer) then
        return;
    end;

    local v7 = math.log(p6, 2);

    if math.floor(v7) ~= v7 then
        p6 = 2 ^ (math.floor(v7) + 1);
    end;

    local _buffer = p5._buffer;
    local v8 = buffer.create(p6);
    buffer.copy(v8, 0, _buffer, 0);
    p5._buffer = v8;
end;

function u1.WriteInt8(p9, p10) -- Line: 61
    p9:_resizeUpTo(p9._cursor + 1);
    buffer.writei8(p9._buffer, p9._cursor, p10);
    p9._cursor = p9._cursor + 1;
end;

function u1.WriteUInt8(p11, p12) -- Line: 70
    p11:_resizeUpTo(p11._cursor + 1);
    buffer.writeu8(p11._buffer, p11._cursor, p12);
    p11._cursor = p11._cursor + 1;
end;

function u1.WriteInt16(p13, p14) -- Line: 79
    p13:_resizeUpTo(p13._cursor + 2);
    buffer.writei16(p13._buffer, p13._cursor, p14);
    p13._cursor = p13._cursor + 2;
end;

function u1.WriteUInt16(p15, p16) -- Line: 88
    p15:_resizeUpTo(p15._cursor + 2);
    buffer.writeu16(p15._buffer, p15._cursor, p16);
    p15._cursor = p15._cursor + 2;
end;

function u1.WriteInt32(p17, p18) -- Line: 97
    p17:_resizeUpTo(p17._cursor + 4);
    buffer.writei32(p17._buffer, p17._cursor, p18);
    p17._cursor = p17._cursor + 4;
end;

function u1.WriteUInt32(p19, p20) -- Line: 106
    p19:_resizeUpTo(p19._cursor + 4);
    buffer.writeu32(p19._buffer, p19._cursor, p20);
    p19._cursor = p19._cursor + 4;
end;

function u1.WriteFloat32(p21, p22) -- Line: 115
    p21:_resizeUpTo(p21._cursor + 4);
    buffer.writef32(p21._buffer, p21._cursor, p22);
    p21._cursor = p21._cursor + 4;
end;

function u1.WriteFloat64(p23, p24) -- Line: 124
    p23:_resizeUpTo(p23._cursor + 8);
    buffer.writef64(p23._buffer, p23._cursor, p24);
    p23._cursor = p23._cursor + 8;
end;

function u1.WriteBool(p25, p26) -- Line: 133
    p25:WriteUInt8(p26 and 1 or 0);
end;

function u1.WriteString(p27, p28, p29) -- Line: 146
    local v30;

    if p29 then
        v30 = math.min(#p28, p29);
    else
        v30 = #p28;
    end;

    local v31 = v30 + 4;
    p27:_resizeUpTo(p27._cursor + v31);
    buffer.writeu32(p27._buffer, p27._cursor, v30);
    buffer.writestring(p27._buffer, p27._cursor + 4, p28, p29);
    p27._cursor = p27._cursor + v31;
end;

function u1.WriteStringRaw(p32, p33, p34) -- Line: 165
    local v35;

    if p34 then
        v35 = math.min(#p33, p34);
    else
        v35 = #p33;
    end;

    p32:_resizeUpTo(p32._cursor + v35);
    buffer.writestring(p32._buffer, p32._cursor, p33, p34);
    p32._cursor = p32._cursor + v35;
end;

function u1.WriteDataType(p36, p37) -- Line: 179
    -- upvalues: DataTypeBuffer (copy)
    local v38 = typeof(p37);
    local v39 = DataTypeBuffer.ReadWrite[v38];

    if not v39 then
        error(`unsupported data type "{v38}"`, 2);
    end;

    v39.write(p36, p37);
end;

function u1.Shrink(p40) -- Line: 191
    if p40._size == buffer.len(p40._buffer) then
        return;
    end;

    local _buffer = p40._buffer;
    local v41 = buffer.create(p40._size);
    buffer.copy(v41, 0, _buffer, 0, p40._size);
    p40._buffer = v41;
end;

function u1.GetSize(p42) -- Line: 208
    return p42._size;
end;

function u1.GetCapacity(p43) -- Line: 219
    return buffer.len(p43._buffer);
end;

function u1.SetCursor(p44, p45) -- Line: 226
    local v46 = math.floor(p45);

    if v46 < 0 or p44._size < v46 then
        error(`cursor position {v46} out of range [0, {p44._size}]`, 3);
    end;

    p44._cursor = v46;
end;

function u1.GetCursor(p47) -- Line: 238
    return p47._cursor;
end;

function u1.ResetCursor(p48) -- Line: 245
    p48._cursor = 0;
end;

function u1.GetBuffer(p49) -- Line: 252
    return p49._buffer;
end;

function u1.ToString(p50) -- Line: 259
    return buffer.tostring(p50._buffer);
end;

function u1.__tostring(p51) -- Line: 263
    return "BufferWriter";
end;

return u1;