-- Decompiled with Potassium's decompiler.

local v1 = {
    _TYPE = "module",
    _NAME = "digest.crc32",
    _VERSION = "0.3.20111128"
};

local function requireany(...) -- Line: 128
    local v2 = {};

    for _, v in ipairs({ ... }) do
        if type(v) ~= "string" then
            return v, "";
        end;

        local success, result = pcall(require, v);

        if success then
            return result, v;
        end;

        v2[#v2 + 1] = result;
    end;

    error(table.concat(v2, "\n"), 2);
end;

local bxor = bit32.bxor;
local bnot = bit32.bnot;
local band = bit32.band;
local rshift = bit32.rshift;
local u11 = (function(u3) -- Line: 152, Name: memoize
    local v4 = {};
    local u5 = setmetatable({}, v4);

    function v4.__index(p6, p7) -- Line: 155
        -- upvalues: u3 (copy), u5 (copy)
        local v8 = u3(p7);
        u5[p7] = v8;

        return v8;
    end;

    return u5;
end)(function(p9) -- Line: 164
    -- upvalues: band (copy), rshift (copy), bxor (copy)
    for _ = 1, 8 do
        local v10 = band(p9, 1);
        p9 = rshift(p9, 1);

        if v10 == 1 then
            p9 = bxor(p9, 3988292384);
        end;
    end;

    return p9;
end);

function v1.crc32_byte(p12, p13) -- Line: 176
    -- upvalues: bnot (copy), rshift (copy), u11 (copy), bxor (copy)
    local v14 = bnot(p13 or 0);

    return bnot((bxor(rshift(v14, 8), u11[bxor(v14 % 256, p12)])));
end;

local crc32_byte = v1.crc32_byte;

function v1.crc32_string(p15, p16) -- Line: 184
    -- upvalues: crc32_byte (copy)
    local v17 = p16 or 0;

    for i = 1, #p15 do
        v17 = crc32_byte(p15:byte(i), v17);
    end;

    return v17;
end;

local crc32_string = v1.crc32_string;

function v1.crc32(p18, p19) -- Line: 193
    -- upvalues: crc32_string (copy), crc32_byte (copy)
    if type(p18) == "string" then
        return crc32_string(p18, p19);
    end;

    return crc32_byte(p18, p19);
end;

return v1;