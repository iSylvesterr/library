-- Decompiled with Potassium's decompiler.

local copy = buffer.copy;
local create = buffer.create;
local fill = buffer.fill;
local len = buffer.len;
local readu8 = buffer.readu8;
local writeu8 = buffer.writeu8;
local random = math.random;
local v1 = {};

local function nonPad(p2) -- Line: 25
    return p2;
end;

v1.None = table.freeze({
    Overwrite = false,
    Pad = nonPad,
    Unpad = nonPad
});

local function anxPad(p3, p4, p5) -- Line: 38
    -- upvalues: len (copy), copy (copy), fill (copy), writeu8 (copy), create (copy)
    local v6 = len(p3);
    local v7 = v6 - v6 % p5;

    if not p4 then
        local v8 = v7 + p5;
        local v9 = create(v8);
        copy(v9, 0, p3, 0, v6);
        writeu8(v9, v8 - 1, p5 - v6 % p5);

        return v9;
    end;

    local v10 = len(p4) >= v6 + p5;
    assert(v10, "Output buffer out of bounds");
    local v11 = p5 - v6 % p5;
    copy(p4, 0, p3, 0, v6);
    fill(p4, v6, 0, v11 - 1);
    writeu8(p4, v7 + p5 - 1, v11);

    return p4;
end;

local function anxUnpad(p12, p13, p14) -- Line: 56
    -- upvalues: len (copy), readu8 (copy), create (copy), copy (copy)
    local v15 = len(p12);
    local v16 = readu8(p12, v15 - 1);
    local v17 = v15 - v16;
    local v18;

    if v16 > 0 then
        v18 = v16 <= p14;
    else
        v18 = false;
    end;

    assert(v18, "Got unexpected padding");

    for i = v17, v15 - 2 do
        if readu8(p12, i) ~= 0 then
            error("Got unexpected padding");
        end;
    end;

    if p13 then
        local v19 = v17 <= len(p13);
        assert(v19, "Output buffer out of bounds");
    else
        p13 = create(v17);
    end;

    copy(p13, 0, p12, 0, v17);

    return p13;
end;

local function i10Pad(p20, p21, p22) -- Line: 78
    -- upvalues: len (copy), create (copy), copy (copy), random (copy), writeu8 (copy)
    local v23 = len(p20);
    local v24 = v23 - v23 % p22;

    if p21 then
        local v25 = len(p21) >= v23 + p22;
        assert(v25, "Output buffer out of bounds");
    else
        p21 = create(v24 + p22);
    end;

    copy(p21, 0, p20, 0, v23);

    for i = v23, v24 + p22 - 2 do
        writeu8(p21, i, (random(0, 255)));
    end;

    writeu8(p21, v24 + p22 - 1, p22 - v23 % p22);

    return p21;
end;

local function i10Unpad(p26, p27, p28) -- Line: 93
    -- upvalues: len (copy), readu8 (copy), create (copy), copy (copy)
    local v29 = len(p26);
    local v30 = readu8(p26, v29 - 1);
    local v31 = v29 - v30;
    local v32;

    if v30 > 0 then
        v32 = v30 <= p28;
    else
        v32 = false;
    end;

    assert(v32, "Got unexpected padding");

    if p27 then
        local v33 = v31 <= len(p27);
        assert(v33, "Output buffer out of bounds");
    else
        p27 = create(v31);
    end;

    copy(p27, 0, p26, 0, v31);

    return p27;
end;

local function pksPad(p34, p35, p36) -- Line: 110
    -- upvalues: len (copy), create (copy), copy (copy), fill (copy)
    local v37 = len(p34);
    local v38 = v37 - v37 % p36;

    if p35 then
        local v39 = len(p35) >= v37 + p36;
        assert(v39, "Output buffer out of bounds");
    else
        p35 = create(v38 + p36);
    end;

    local v40 = p36 - v37 % p36;
    copy(p35, 0, p34, 0, v37);
    fill(p35, v37, v40, v40);

    return p35;
end;

local function pksUnpad(p41, p42, p43) -- Line: 123
    -- upvalues: len (copy), readu8 (copy), create (copy), copy (copy)
    local v44 = len(p41);
    local v45 = readu8(p41, v44 - 1);
    local v46 = v44 - v45;
    local v47;

    if v45 > 0 then
        v47 = v45 <= p43;
    else
        v47 = false;
    end;

    assert(v47, "Got unexpected padding");

    for i = v46, v44 - 2 do
        if readu8(p41, i) ~= v45 then
            error("Got unexpected padding");
        end;
    end;

    if p42 then
        local v48 = v46 <= len(p42);
        assert(v48, "Output buffer out of bounds");
    else
        p42 = create(v46);
    end;

    copy(p42, 0, p41, 0, v46);

    return p42;
end;

local function ii7Pad(p49, p50, p51) -- Line: 145
    -- upvalues: len (copy), fill (copy), create (copy), copy (copy), writeu8 (copy)
    local v52 = len(p49);

    if p50 then
        local v53 = len(p50) >= v52 + p51;
        assert(v53, "Output buffer out of bounds");
        fill(p50, v52 + 1, 0, p51 - v52 % p51 - 1);
    else
        p50 = create(v52 + p51 - v52 % p51);
    end;

    copy(p50, 0, p49, 0, v52);
    writeu8(p50, v52, 128);

    return p50;
end;

local function ii7Unpad(p54, p55, p56) -- Line: 157
    -- upvalues: len (copy), readu8 (copy), create (copy), copy (copy)
    local v57 = len(p54) - 1;

    for i = v57, v57 - p56, -1 do
        local v58 = readu8(p54, i);

        if v58 == 128 then
            if p55 then
                local v59 = i <= len(p55);
                assert(v59, "Output buffer out of bounds");
            else
                p55 = create(i);
            end;

            copy(p55, 0, p54, 0, i);

            return p55;
        end;

        assert(v58 == 0, "Got unexpected padding");
    end;

    error("Got unexpected padding");

    return create(0);
end;

local function zroPad(p60, p61, p62) -- Line: 181
    -- upvalues: len (copy), fill (copy), create (copy), copy (copy)
    local v63 = len(p60);

    if p61 then
        local v64 = len(p61) >= v63 + p62;
        assert(v64, "Output buffer out of bounds");
        fill(p61, v63, 0, p62 - v63 % p62);
    else
        p61 = create(v63 + p62 - v63 % p62);
    end;

    copy(p61, 0, p60, 0, v63);

    return p61;
end;

local function zroUnpad(p65, p66, p67) -- Line: 192
    -- upvalues: len (copy), readu8 (copy), create (copy), copy (copy)
    local v68 = len(p65) - 1;

    for i = v68, v68 - p67, -1 do
        if readu8(p65, i) == 0 then
            local v69 = i + 1;

            if p66 then
                local v70 = v69 <= len(p66);
                assert(v70, "Output buffer out of bounds");
            else
                p66 = create(v69);
            end;

            copy(p66, 0, p65, 0, v69);

            return p66;
        end;
    end;

    copy(p66, 0, p65, 0, v68 - p67 - 1);

    return p66;
end;

local v73 = {
    __index = function(p71, p72) -- Line: 213, Name: __index
        -- upvalues: anxPad (copy), i10Pad (copy), i10Unpad (copy), pksPad (copy), pksUnpad (copy), ii7Pad (copy), ii7Unpad (copy), zroPad (copy), zroUnpad (copy)
        return p72 == "AnsiX923" and {
            Overwrite = nil,
            Pad = anxPad,
            Unpad = anxPad
        } or (p72 == "Iso10126" and {
            Overwrite = nil,
            Pad = i10Pad,
            Unpad = i10Unpad
        } or (p72 == "Pkcs7" and {
            Overwrite = nil,
            Pad = pksPad,
            Unpad = pksUnpad
        } or (p72 == "Iso7816_4" and {
            Overwrite = nil,
            Pad = ii7Pad,
            Unpad = ii7Unpad
        } or (p72 == "Zero" and {
            Overwrite = nil,
            Pad = zroPad,
            Unpad = zroUnpad
        } or nil))));
    end,

    __newindex = function() -- Line: 231, Name: __newindex
    end
};
setmetatable(v1, v73);
v1.AnsiX923 = {};
v1.Iso10126 = {};
v1.Pkcs7 = {};
v1.Iso7816_4 = {};
v1.Zero = {};
table.freeze(v1);
v73.__metatable = "This metatable is locked";

return v1;