-- Decompiled with Potassium's decompiler.

local u1 = {};

for i = 0, 255 do
    local v2 = i;

    for _ = 1, 8 do
        local i;

        if bit32.band(i, 1) == 0 then
            i = bit32.rshift(i, 1);
        else
            local v3 = bit32.rshift(i, 1);
            i = bit32.bxor(v3, 3988292384);
        end;
    end;

    u1[v2] = i;
end;

local len = string.len;
local byte = string.byte;
local bxor = bit32.bxor;
local rshift = bit32.rshift;
local band = bit32.band;
local bnot = bit32.bnot;

function CRC32(p4)
    -- upvalues: len (copy), byte (copy), rshift (copy), u1 (copy), bxor (copy), band (copy), bnot (copy)
    local v5 = 4294967295;

    for i = 1, len(p4) do
        local v6 = byte(p4, i);
        v5 = bxor(rshift(v5, 8), u1[band(bxor(v5, v6), 255)]);
    end;

    return bnot(v5);
end;

return CRC32;