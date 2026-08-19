-- Decompiled with Potassium's decompiler.

local BufferWriter = require(script.Parent.BufferWriter);
local DataTypeBuffer = require(script.Parent.DataTypeBuffer);
require(script.Parent.Types);
local u1 = {};
u1.__index = u1;

function u1.new(p2) -- Line: 16
    -- upvalues: u1 (copy), BufferWriter (copy)
    if typeof(p2) == "string" then
        return u1.fromString(p2);
    end;

    if typeof(p2) == "buffer" then
        return u1.fromBuffer(p2);
    end;

    if typeof(p2) == "table" and getmetatable(p2) == BufferWriter then
        return u1.fromBuffer(p2:GetBuffer());
    end;

    error((`expected string or buffer; got {typeof(p2)}`));
end;

function u1.fromBuffer(p3) -- Line: 28
    -- upvalues: u1 (copy)
    local v4 = {
        _cursor = 0,
        _buffer = p3,
        _size = buffer.len(p3)
    };

    return setmetatable(v4, u1);
end;

function u1.fromString(p5) -- Line: 38
    -- upvalues: u1 (copy)
    return u1.fromBuffer(buffer.fromstring(p5));
end;

function u1._assertSize(p6, p7) -- Line: 42
    if p6._size < p7 then
        error("cursor out of bounds", 3);
    end;
end;

function u1.ReadInt8(p8) -- Line: 51
    p8:_assertSize(p8._cursor + 1);
    local v9 = buffer.readi8(p8._buffer, p8._cursor);
    p8._cursor = p8._cursor + 1;

    return v9;
end;

function u1.ReadUInt8(p10) -- Line: 61
    p10:_assertSize(p10._cursor + 1);
    local v11 = buffer.readu8(p10._buffer, p10._cursor);
    p10._cursor = p10._cursor + 1;

    return v11;
end;

function u1.ReadInt16(p12) -- Line: 71
    p12:_assertSize(p12._cursor + 2);
    local v13 = buffer.readi16(p12._buffer, p12._cursor);
    p12._cursor = p12._cursor + 2;

    return v13;
end;

function u1.ReadUInt16(p14) -- Line: 81
    p14:_assertSize(p14._cursor + 2);
    local v15 = buffer.readu16(p14._buffer, p14._cursor);
    p14._cursor = p14._cursor + 2;

    return v15;
end;

function u1.ReadInt32(p16) -- Line: 91
    p16:_assertSize(p16._cursor + 4);
    local v17 = buffer.readi32(p16._buffer, p16._cursor);
    p16._cursor = p16._cursor + 4;

    return v17;
end;

function u1.ReadUInt32(p18) -- Line: 101
    p18:_assertSize(p18._cursor + 4);
    local v19 = buffer.readu32(p18._buffer, p18._cursor);
    p18._cursor = p18._cursor + 4;

    return v19;
end;

function u1.ReadFloat32(p20) -- Line: 111
    p20:_assertSize(p20._cursor + 4);
    local v21 = buffer.readf32(p20._buffer, p20._cursor);
    p20._cursor = p20._cursor + 4;

    return v21;
end;

function u1.ReadFloat64(p22) -- Line: 121
    p22:_assertSize(p22._cursor + 8);
    local v23 = buffer.readf64(p22._buffer, p22._cursor);
    p22._cursor = p22._cursor + 8;

    return v23;
end;

function u1.ReadBool(p24) -- Line: 131
    return p24:ReadUInt8() == 1;
end;

function u1.ReadString(p25) -- Line: 143
    local v26 = p25:ReadUInt32();
    p25:_assertSize(p25._cursor + v26);
    local v27 = buffer.readstring(p25._buffer, p25._cursor, v26);
    p25._cursor = p25._cursor + v26;

    return v27;
end;

function u1.ReadStringRaw(p28, p29) -- Line: 157
    local v30 = math.floor(p29);
    local v31 = math.max(0, v30);
    p28:_assertSize(p28._cursor + v31);
    local v32 = buffer.readstring(p28._buffer, p28._cursor, v31);
    p28._cursor = p28._cursor + v31;

    return v32;
end;

function u1.ReadDataType(p33, p34) -- Line: 172
    -- upvalues: DataTypeBuffer (copy)
    local v35 = DataTypeBuffer.DataTypesToString[p34];

    if not v35 then
        error("unsupported data type", 2);
    end;

    return DataTypeBuffer.ReadWrite[v35].read(p33);
end;

function u1.SetCursor(p36, p37) -- Line: 185
    local v38 = math.floor(p37);

    if v38 < 0 or p36._size < v38 then
        error(`cursor position {v38} out of range [0, {p36._size}]`, 3);
    end;

    p36._cursor = v38;
end;

function u1.GetCursor(p39) -- Line: 197
    return p39._cursor;
end;

function u1.ResetCursor(p40) -- Line: 204
    p40._cursor = 0;
end;

function u1.GetSize(p41) -- Line: 211
    return p41._size;
end;

function u1.GetBuffer(p42) -- Line: 218
    return p42._buffer;
end;

function u1.__tostring(p43) -- Line: 222
    return "BufferReader";
end;

return u1;