-- Decompiled with Potassium's decompiler.

local v1 = {};

local function version_tostring(p2) -- Line: 35
    return string.format("%d.%d", p2.Major, p2.Minor);
end;

local function version_lt(p3, p4) -- Line: 39
    if p3.Major == p4.Major then
        return p3.Minor < p4.Minor;
    end;

    return p3.Major < p4.Major;
end;

local function version_eq(p5, p6) -- Line: 43
    local v7;

    if p5.Major == p6.Major then
        v7 = p5.Minor == p6.Minor;
    else
        v7 = false;
    end;

    return v7;
end;

local function double_to_int32(p8) -- Line: 47
    local v9 = tonumber(p8) or 0;

    if math.clamp(v9, -2147483648, 2147483647) ~= p8 then
        return UDim.new(nil, p8).Offset;
    end;

    if p8 <= -1 then
        return math.ceil(p8);
    end;

    return p8 < 1 and 0 or math.floor(p8);
end;

function v1.new(p10, p11) -- Line: 61
    -- upvalues: version_tostring (copy), version_lt (copy), version_eq (copy)
    local v12 = newproxy(true);
    local v13 = getmetatable(v12);
    local v14 = {};
    local v15 = tonumber(p10) or 0;
    local v16;

    if math.clamp(v15, -2147483648, 2147483647) == p10 then
        if p10 <= -1 then
            v16 = math.ceil(p10);
        else
            v16 = p10 < 1 and 0 or math.floor(p10);
        end;
    else
        v16 = UDim.new(nil, p10).Offset;
    end;

    v14.Major = v16;
    local v17 = tonumber(p11) or 0;
    local v18;

    if math.clamp(v17, -2147483648, 2147483647) == p11 then
        if p11 <= -1 then
            v18 = math.ceil(p11);
        else
            v18 = p11 < 1 and 0 or math.floor(p11);
        end;
    else
        v18 = UDim.new(nil, p11).Offset;
    end;

    v14.Minor = v18;
    v13.__index = v14;
    v13.__metatable = "The metatable is locked";
    v13.__tostring = version_tostring;
    v13.__lt = version_lt;
    v13.__eq = version_eq;
    table.freeze(v13);

    return v12;
end;

v1.current = v1.new(31, 1);

return table.freeze(v1);