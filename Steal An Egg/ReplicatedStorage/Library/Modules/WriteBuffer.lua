-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;

function u1.new(p2) -- Line: 4
    -- upvalues: u1 (copy)
    local v3 = p2 == nil and 0 or math.max(p2, 0);

    return setmetatable({
        offset = 0,
        currentSize = 0,
        stepSize = 128,
        buf = nil,
        startSize = v3
    }, u1);
end;

function u1.GetBuffer(p4) -- Line: 21
    if buffer.len(p4.buf) == p4.offset then
        return p4.buf;
    end;

    local v5 = buffer.create(p4.offset);
    p4.currentSize = p4.offset;
    buffer.copy(v5, 0, p4.buf, 0, p4.offset);
    p4.buf = v5;

    return v5;
end;

function u1.CheckSize(p6, p7) -- Line: 34
    if p6.buf == nil or p6.offset + p7 > p6.currentSize then
        if p6.buf == nil then
            p6.currentSize = math.max(p6.startSize, p7);
        else
            p6.currentSize = p6.currentSize + math.max(p6.stepSize, p7);
        end;

        local v8 = buffer.create(p6.currentSize);

        if p6.buf then
            buffer.copy(v8, 0, p6.buf, 0, p6.offset);
        end;

        p6.buf = v8;
    end;
end;

function u1.WriteU8(p9, p10) -- Line: 50
    p9:CheckSize(1);
    buffer.writeu8(p9.buf, p9.offset, p10);
    p9.offset = p9.offset + 1;
end;

function u1.WriteI16(p11, p12) -- Line: 56
    p11:CheckSize(2);
    buffer.writeu16(p11.buf, p11.offset, p12);
    p11.offset = p11.offset + 2;
end;

function u1.WriteVector3(p13, p14) -- Line: 62
    p13:CheckSize(12);
    buffer.writef32(p13.buf, p13.offset, p14.X);
    p13.offset = p13.offset + 4;
    buffer.writef32(p13.buf, p13.offset, p14.Y);
    p13.offset = p13.offset + 4;
    buffer.writef32(p13.buf, p13.offset, p14.Z);
    p13.offset = p13.offset + 4;
end;

function u1.WriteFloat16(p15, p16) -- Line: 72
    p15:CheckSize(2);
    local v17 = p16 < 0;
    local v18 = math.abs(p16);
    local v19, v20 = math.frexp(v18);

    if v18 == (1 / 0) then
        if v17 then
            buffer.writeu8(p15.buf, p15.offset, 252);
            p15.offset = p15.offset + 1;
        else
            buffer.writeu8(p15.buf, p15.offset, 124);
            p15.offset = p15.offset + 1;
        end;

        buffer.writeu8(p15.buf, p15.offset, 0);
        p15.offset = p15.offset + 1;

        return;
    end;

    if v18 ~= v18 or v18 == 0 then
        buffer.writeu8(p15.buf, p15.offset, 0);
        p15.offset = p15.offset + 1;
        buffer.writeu8(p15.buf, p15.offset, 0);
        p15.offset = p15.offset + 1;

        return;
    end;

    if v20 + 15 <= 1 then
        local v21 = math.floor(v19 * 1024 + 0.5);

        if v17 then
            local buf = p15.buf;
            local offset = p15.offset;
            local v22 = bit32.rshift(v21, 8) + 128;
            buffer.writeu8(buf, offset, v22);
            p15.offset = p15.offset + 1;
        else
            local buf = p15.buf;
            local offset = p15.offset;
            local v23 = bit32.rshift(v21, 8);
            buffer.writeu8(buf, offset, v23);
            p15.offset = p15.offset + 1;
        end;

        local buf = p15.buf;
        local offset = p15.offset;
        local v24 = bit32.band(v21, 255);
        buffer.writeu8(buf, offset, v24);
        p15.offset = p15.offset + 1;

        return;
    end;

    local v25 = math.floor((v19 - 0.5) * 2048 + 0.5);

    if v17 then
        local buf = p15.buf;
        local offset = p15.offset;
        local v26 = bit32.lshift(v20 + 14, 2) + 128 + bit32.rshift(v25, 8);
        buffer.writeu8(buf, offset, v26);
        p15.offset = p15.offset + 1;
    else
        local buf = p15.buf;
        local offset = p15.offset;
        local v27 = bit32.lshift(v20 + 14, 2) + bit32.rshift(v25, 8);
        buffer.writeu8(buf, offset, v27);
        p15.offset = p15.offset + 1;
    end;

    local buf = p15.buf;
    local offset = p15.offset;
    local v28 = bit32.band(v25, 255);
    buffer.writeu8(buf, offset, v28);
    p15.offset = p15.offset + 1;
end;

return u1;