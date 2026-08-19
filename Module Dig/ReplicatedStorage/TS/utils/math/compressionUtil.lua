-- Decompiled with Potassium's decompiler.

local u1 = bit32.lshift(1, 40) - 1;

local function packNumber(p2) -- Line: 15
    local v3 = math.sign(p2) < 0 and 1 or 0;
    local v4 = math.abs(p2);

    if v4 == 0 then
        return {
            exp = 0,
            mant = 0,
            sign = v3
        };
    end;

    if v4 == (1 / 0) then
        return {
            exp = 2047,
            mant = 0,
            sign = v3
        };
    end;

    if v4 ~= v4 then
        return {
            exp = 2047,
            sign = v3,
            mant = bit32.lshift(1, 51)
        };
    end;

    local v5 = math.log(v4) / 0.6931471805599453;
    local v6 = math.floor(v5);
    local v7 = v4 / math.pow(2, v6);

    if v7 < 1 then
        v6 = v6 - 1;
        v7 = v4 / math.pow(2, v6);
    elseif v7 >= 2 then
        v6 = v6 + 1;
        v7 = v4 / math.pow(2, v6);
    end;

    local v8 = v6 + 1023;
    local v9;

    if v8 > 0 then
        v9 = math.floor((v7 - 1) * 4503599627370496 + 0.5);
    else
        v9 = math.floor(v4 / 0 + 0.5);
    end;

    return {
        sign = v3,
        exp = v8,
        mant = v9
    };
end;

local function unpackNumber(p10) -- Line: 73
    local sign = p10.sign;
    local exp = p10.exp;
    local mant = p10.mant;

    if exp == 0 and mant == 0 then
        return sign == 1 and -0 or 0;
    end;

    if exp == 2047 and mant ~= 0 then
        return (0 / 0);
    end;

    if exp == 2047 and mant == 0 then
        return sign == 1 and (-1 / 0) or (1 / 0);
    end;

    local v11;

    if exp == 0 then
        v11 = mant / 4503599627370496 * 2.2250738585072014e-308;
    else
        v11 = (1 + mant / 4503599627370496) * math.pow(2, exp - 1023);
    end;

    if sign == 1 then
        return -v11;
    end;

    return v11;
end;

return {
    packNumber = packNumber,
    unpackNumber = unpackNumber,

    compressOrdered = function(p12) -- Line: 110, Name: compressOrdered
        -- upvalues: packNumber (copy)
        local v13 = packNumber(p12);
        local sign = v13.sign;
        local exp = v13.exp;
        local v14 = bit32.arshift(v13.mant, 12);
        local v15 = bit32.lshift(sign, 51);
        local v16 = bit32.lshift(exp, 40);
        local v17 = bit32.bor(v15, v16);

        return bit32.bor(v17, v14);
    end,

    decompressOrdered = function(p18) -- Line: 125, Name: decompressOrdered
        -- upvalues: u1 (copy), unpackNumber (copy)
        local v19 = bit32.arshift(p18, 51);
        local v20 = bit32.band(v19, 1) == 1 and 1 or 0;
        local v21 = bit32.arshift(p18, 40);
        local v22 = bit32.band(v21, 2047);
        local v23 = bit32.band(p18, u1);

        return unpackNumber({
            sign = v20,
            exp = v22,
            mant = bit32.lshift(v23, 12)
        });
    end
};