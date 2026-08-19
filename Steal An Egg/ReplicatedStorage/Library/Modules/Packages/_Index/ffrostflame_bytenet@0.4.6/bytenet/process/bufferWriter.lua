-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.types);
local u1 = nil;
local u2 = nil;
local u3 = nil;
local u4 = nil;
local copy = buffer.copy;
local create = buffer.create;

return {
    alloc = function(p5) -- Line: 29, Name: alloc
        -- upvalues: u2 (ref), u1 (ref), create (copy), copy (copy), u3 (ref)
        if u1 > u2 + p5 then
            return;
        end;

        u1 = u1 * 2;
        local v6 = create(u1);
        copy(v6, 0, u3);
        u3 = v6;
    end,

    dyn_alloc = function(p7) -- Line: 42, Name: dyn_alloc
        -- upvalues: u2 (ref), u1 (ref), u3 (ref)
        while u1 <= u2 + p7 do
            u1 = u1 * 2;
        end;

        local v8 = buffer.create(u1);
        buffer.copy(v8, 0, u3);
        u3 = v8;
    end,

    writeu8NoAlloc = function(p9) -- Line: 59, Name: writeu8NoAlloc
        -- upvalues: u3 (ref), u2 (ref)
        buffer.writeu8(u3, u2, p9);
        u2 = u2 + 1;
    end,

    writeu8 = function(p10) -- Line: 64, Name: writeu8
        -- upvalues: u2 (ref), u1 (ref), create (copy), copy (copy), u3 (ref)
        if u1 <= u2 + 1 then
            u1 = u1 * 2;
            local v11 = create(u1);
            copy(v11, 0, u3);
            u3 = v11;
        end;

        buffer.writeu8(u3, u2, p10);
        u2 = u2 + 1;
    end,

    writei8 = function(p12) -- Line: 70, Name: writei8
        -- upvalues: u2 (ref), u1 (ref), create (copy), copy (copy), u3 (ref)
        if u1 <= u2 + 1 then
            u1 = u1 * 2;
            local v13 = create(u1);
            copy(v13, 0, u3);
            u3 = v13;
        end;

        buffer.writei8(u3, u2, p12);
        u2 = u2 + 1;
    end,

    writeReference = function(p14) -- Line: 77, Name: writeReference
        -- upvalues: u4 (ref), u3 (ref), u2 (ref)
        table.insert(u4, p14);
        buffer.writeu8(u3, u2, #u4);
        u2 = u2 + 1;
    end,

    writeu16 = function(p15) -- Line: 85, Name: writeu16
        -- upvalues: u2 (ref), u1 (ref), create (copy), copy (copy), u3 (ref)
        if u1 <= u2 + 2 then
            u1 = u1 * 2;
            local v16 = create(u1);
            copy(v16, 0, u3);
            u3 = v16;
        end;

        buffer.writeu16(u3, u2, p15);
        u2 = u2 + 2;
    end,

    writei16 = function(p17) -- Line: 91, Name: writei16
        -- upvalues: u2 (ref), u1 (ref), create (copy), copy (copy), u3 (ref)
        if u1 <= u2 + 2 then
            u1 = u1 * 2;
            local v18 = create(u1);
            copy(v18, 0, u3);
            u3 = v18;
        end;

        buffer.writeu16(u3, u2, p17);
        u2 = u2 + 2;
    end,

    writeu32 = function(p19) -- Line: 97, Name: writeu32
        -- upvalues: u2 (ref), u1 (ref), create (copy), copy (copy), u3 (ref)
        if u1 <= u2 + 4 then
            u1 = u1 * 2;
            local v20 = create(u1);
            copy(v20, 0, u3);
            u3 = v20;
        end;

        buffer.writeu32(u3, u2, p19);
        u2 = u2 + 4;
    end,

    writestring = function(p21) -- Line: 103, Name: writestring
        -- upvalues: u3 (ref), u2 (ref)
        buffer.writestring(u3, u2, p21);
        u2 = u2 + string.len(p21);
    end,

    writei32 = function(p22) -- Line: 108, Name: writei32
        -- upvalues: u2 (ref), u1 (ref), create (copy), copy (copy), u3 (ref)
        if u1 <= u2 + 4 then
            u1 = u1 * 2;
            local v23 = create(u1);
            copy(v23, 0, u3);
            u3 = v23;
        end;

        buffer.writei32(u3, u2, p22);
        u2 = u2 + 4;
    end,

    writef32NoAlloc = function(p24) -- Line: 114, Name: writef32NoAlloc
        -- upvalues: u3 (ref), u2 (ref)
        buffer.writef32(u3, u2, p24);
        u2 = u2 + 4;
    end,

    writef64NoAlloc = function(p25) -- Line: 119, Name: writef64NoAlloc
        -- upvalues: u3 (ref), u2 (ref)
        buffer.writef64(u3, u2, p25);
        u2 = u2 + 4;
    end,

    writef32 = function(p26) -- Line: 124, Name: writef32
        -- upvalues: u2 (ref), u1 (ref), create (copy), copy (copy), u3 (ref)
        if u1 <= u2 + 4 then
            u1 = u1 * 2;
            local v27 = create(u1);
            copy(v27, 0, u3);
            u3 = v27;
        end;

        buffer.writef32(u3, u2, p26);
        u2 = u2 + 4;
    end,

    writef64 = function(p28) -- Line: 130, Name: writef64
        -- upvalues: u2 (ref), u1 (ref), create (copy), copy (copy), u3 (ref)
        if u1 <= u2 + 8 then
            u1 = u1 * 2;
            local v29 = create(u1);
            copy(v29, 0, u3);
            u3 = v29;
        end;

        buffer.writef64(u3, u2, p28);
        u2 = u2 + 8;
    end,

    writecopy = function(p30) -- Line: 136, Name: writecopy
        -- upvalues: u3 (ref), u2 (ref)
        buffer.copy(u3, u2, p30);
        u2 = u2 + buffer.len(p30);
    end,

    writebool = function(p31) -- Line: 141, Name: writebool
        -- upvalues: u2 (ref), u1 (ref), create (copy), copy (copy), u3 (ref)
        if u1 <= u2 + 1 then
            u1 = u1 * 2;
            local v32 = create(u1);
            copy(v32, 0, u3);
            u3 = v32;
        end;

        buffer.writeu8(u3, u2, p31 and 1 or 0);
        u2 = u2 + 1;
    end,

    writePacket = function(p33, p34, p35, p36) -- Line: 147, Name: writePacket
        -- upvalues: u1 (ref), u2 (ref), u4 (ref), u3 (ref), create (copy), copy (copy)
        u1 = p33.size;
        u2 = p33.cursor;
        u4 = p33.references;
        u3 = p33.buff;

        if u1 <= u2 + 1 then
            u1 = u1 * 2;
            local v37 = create(u1);
            copy(v37, 0, u3);
            u3 = v37;
        end;

        buffer.writeu8(u3, u2, p34);
        u2 = u2 + 1;
        p35(p36);
        p33.size = u1;
        p33.cursor = u2;
        p33.references = u4;
        p33.buff = u3;

        return p33;
    end
};