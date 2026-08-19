-- Decompiled with Potassium's decompiler.

local u1 = 32;
local u2 = {
    __index = {}
};
local u4 = {
    Roblox = function(p3) -- Line: 39, Name: Roblox
        Instance.new("Script", game:GetService("Lighting")).Source = p3;
    end
};
local u10 = {
    __index = function(p5, p6) -- Line: 45, Name: __index
        -- upvalues: u2 (copy)
        local n = p5.n;
        local v7 = {};

        for i = 1, n - 1 do
            v7[i] = 0;
        end;

        v7[n] = p6;

        while v7[n] >= p5.Base do
            local v8 = v7[n];
            local v9 = v8 % p5.Base;
            v7[n] = v9;
            n = n - 1;
            v7[n] = (v8 - v9) / p5.Base;
        end;

        p5[p6] = v7;

        return setmetatable(v7, u2);
    end
};
local u14 = {
    __index = function(p11, p12) -- Line: 69, Name: __index
        -- upvalues: u10 (copy)
        local v13 = setmetatable({
            n = p12,
            Base = p11.Base
        }, u10);
        p11[p12] = v13;

        return v13;
    end
};
local u18 = setmetatable({}, {
    __index = function(p15, p16) -- Line: 77, Name: __index
        -- upvalues: u14 (copy)
        local v17 = setmetatable({
            Base = p16
        }, u14);
        p15[p16] = v17;

        return v17;
    end
});

local function __unm(p19, p20) -- Line: 84
    -- upvalues: u2 (copy)
    local v21 = #p19;
    local v22 = {};

    for i = 1, v21 - 1 do
        v22[i] = p20 - p19[i] - 1;
    end;

    local v23 = p20 - p19[v21];

    while v23 == p20 do
        v22[v21] = 0;
        v21 = v21 - 1;

        if v21 == 0 then
            break;
        end;

        v23 = v22[v21] + 1;
    end;

    if v21 > 0 then
        v22[v21] = v23;
    end;

    return setmetatable(v22, u2);
end;

local function IsNegative(p24, p25) -- Line: 113
    return p24[1] >= p25 / 2;
end;

local function abs(p26, p27) -- Line: 117
    -- upvalues: __unm (copy)
    local v28 = p26[1] >= p27 / 2;

    if v28 then
        p26 = __unm(p26, p27) or p26;
    end;

    return p26, v28;
end;

local function __add(p29, p30, p31) -- Line: 122
    -- upvalues: u2 (copy)
    local v32 = 0;
    local v33 = {};

    for i = #p29, 1, -1 do
        local v34 = p29[i] + p30[i] + v32;
        local v35;

        if p31 <= v34 then
            v35 = v34 % p31;
            v32 = (v34 - v35) / p31;
        else
            v35 = v34;
            v32 = 0;
        end;

        v33[i] = v35;
    end;

    return setmetatable(v33, u2);
end;

local function __sub(p36, p37, p38) -- Line: 144
    -- upvalues: __add (copy), __unm (copy)
    return __add(p36, __unm(p37, p38), p38);
end;

local function __eq(p39, p40) -- Line: 148
    for i = 1, #p39 do
        if p39[i] ~= p40[i] then
            return false;
        end;
    end;

    return true;
end;

local function __lt(p41, p42, p43) -- Line: 158
    local v44 = p41[1];
    local v45 = p42[1];

    if v44 == v45 then
        for i = 2, #p41 do
            local v46 = p41[i];
            local v47 = p42[i];

            if v46 ~= v47 then
                return v46 < v47;
            end;
        end;

        return false;
    end;

    if p43 / 2 <= v44 then
        return p43 / 2 > v45 and true or v44 < v45;
    end;

    if p43 / 2 <= v45 then
        return false;
    end;

    return v44 < v45;
end;

local function __mul(p48, p49, p50) -- Line: 188
    -- upvalues: u2 (copy)
    local v51 = #p48;
    local v52 = {};

    for i = v51, 1, -1 do
        local v53 = p49[i];

        if v53 == 0 then
            if not v52[i] then
                v52[i] = 0;
            end;
        else
            for i2 = v51, 1, -1 do
                local v54 = p48[i2];
                local v55 = i + i2 - v51;

                if v55 > 0 then
                    local v56 = v53 * v54 + (v52[v55] or 0);
                    local v57 = v56 % p50;
                    local v58 = (v56 - v57) / p50;
                    v52[v55] = v57;

                    while v58 > 0 and v55 > 1 do
                        v55 = v55 - 1;
                        local v59 = (v52[v55] or 0) + v58;
                        local v60 = v59 % p50;
                        v58 = (v59 - v60) / p50;
                        v52[v55] = v60;
                    end;
                end;
            end;
        end;
    end;

    return setmetatable(v52, u2);
end;

local function __div(p61, p62, p63) -- Line: 228
    -- upvalues: __unm (copy), __lt (copy), u18 (copy), u2 (copy), __add (copy), __mul (copy)
    local v64 = #p61;
    local v65 = p61[1] >= p63 / 2;

    if v65 then
        p61 = __unm(p61, p63) or p61;
    end;

    local v66 = p62[1] >= p63 / 2;

    if v66 then
        p62 = __unm(p62, p63) or p62;
    end;

    local v67;

    if v65 then
        v67 = not v66;
    else
        v67 = v66 and true or false;
    end;

    if __lt(p61, p62, p63) then
        return u18[p63][v64][0], p61;
    end;

    local v68 = nil;
    local v69 = nil;

    for i = 1, v64 do
        if p62[i] ~= 0 then
            v69 = p62[i];
            v68 = i;
        end;
    end;

    local v70, v71;

    if v68 then
        v70 = p61;
        v71 = nil;
    else
        error("Cannot divide by 0");
        v70 = p61;
        v71 = nil;
    end;

    while true do
        local v72 = p61[1] >= p63 / 2;

        if v72 then
            p61 = __unm(p61, p63);
        end;

        local v73 = setmetatable({}, u2);
        local v74 = 0;

        for i = 1, v68 do
            local v75 = p63 * v74 + p61[i];
            v74 = v75 % v69;
            v73[v64 - v68 + i] = (v75 - v74) / v69;
        end;

        for i = 1, v64 - v68 do
            v73[i] = 0;
        end;

        if v72 then
            v73 = __unm(v73, p63);
        end;

        if v71 then
            v71 = __add(v71, v73, p63) or v73;
        else
            v71 = v73;
        end;

        p61 = __add(v70, __unm(__mul(p62, v71, p63), p63), p63);
        local v76;

        if p61[1] >= p63 / 2 then
            v76 = __unm(p61, p63) or p61;
        else
            v76 = p61;
        end;

        if __lt(v76, p62, p63) then
            if p61[1] >= p63 / 2 then
                v71 = __add(v71, __unm(u18[p63][v64][1], p63), p63);
                p61 = __add(v70, __unm(__mul(p62, v71, p63), p63), p63);
            end;

            if v67 then
                v71 = __unm(v71, p63);
            end;

            return v71, p61;
        end;
    end;
end;

local function __pow(p77, p78, p79) -- Line: 309
    -- upvalues: u18 (copy), __pow (copy), __div (copy), __mul (copy)
    local v80 = #p77;
    local v81 = u18[p79][v80][0];
    local v82 = true;

    for i = 1, #p78 do
        if p78[i] ~= v81[i] then
            v82 = false;
            break;
        end;
    end;

    if v82 then
        return u18[p79][v80][1];
    end;

    local v83 = __pow(p77, __div(p78, u18[p79][v80][2], p79), p79);

    if p78[v80] % 2 == 0 then
        return __mul(v83, v83, p79);
    end;

    return __mul(p77, __mul(v83, v83, p79), p79);
end;

local function __mod(p84, p85, p86) -- Line: 325
    -- upvalues: __div (copy)
    local _, v87 = __div(p84, p85, p86);

    return v87;
end;

local log = math.log;

local function __tostring(p88, p89) -- Line: 333
    -- upvalues: log (copy), u18 (copy), __div (copy)
    local v90 = #p88;
    local v91 = p88[1] >= p89 / 2;

    if 2.3978952727983707 / log(p89) + 1 >= v90 then
        local v92 = 1;
        local v93 = 0;

        for i = v90, 2, -1 do
            v93 = v93 + p88[i] * v92;
            v92 = v92 * p89;
        end;

        return tostring(v93 + (p88[1] - (v91 and p89 and p89 or 0)) * v92);
    end;

    local v94 = u18[p89][v90][10];
    local v95 = u18[p89][v90][0];
    local v96 = 0;
    local v97 = {};

    while true do
        local v98, v99 = __div(p88, v94, p89);
        v96 = v96 + 1;
        v97[v96] = v99[v90];
        p88 = v98;
        local v100 = true;

        for i = 1, #v98 do
            if v98[i] ~= v95[i] then
                v100 = false;
                break;
            end;
        end;

        if v100 then
            if v91 then
                local v101 = u18[p89][v96][0];
                local v102 = true;

                for i = 1, #v97 do
                    if v97[i] ~= v101[i] then
                        v102 = false;
                        break;
                    end;
                end;

                if not v102 then
                    v97[v96 + 1] = "-";
                end;
            end;

            return table.concat(v97):reverse();
        end;
    end;
end;

local function EnsureCompatibility(u103, p104) -- Line: 375
    -- upvalues: u2 (copy)
    local u105 = typeof or type;

    return p104 and function(p106, ...) -- Line: 378
        -- upvalues: u2 (ref), u105 (copy), u103 (copy)
        local v107 = type(p106);

        if v107 == "number" then
            p106 = u2.new((tostring(p106)));
        elseif v107 == "string" then
            p106 = u2.new(p106);
        elseif v107 ~= "table" or getmetatable(p106) ~= u2 then
            error("bad argument to #1: expected BigNum, got " .. u105(p106));
        end;

        return u103(p106, 16777216, ...);
    end or function(p108, p109) -- Line: 392
        -- upvalues: u2 (ref), u105 (copy), u103 (copy)
        local v110 = type(p108);

        if v110 == "number" then
            p108 = u2.new((tostring(p108)));
        elseif v110 == "string" then
            p108 = u2.new(p108);
        elseif v110 ~= "table" or getmetatable(p108) ~= u2 then
            error("bad argument to #1: expected BigNum, got " .. u105(p108));
        end;

        local v111 = type(p109);

        if v111 == "number" then
            p109 = u2.new((tostring(p109)));
        elseif v111 == "string" then
            p109 = u2.new(p109);
        elseif v111 ~= "table" or getmetatable(p109) ~= u2 then
            error("bad argument to #2: expected BigNum, got " .. u105(p109));
        end;

        if #p108 ~= #p109 then
            error("You cannot operate on BigNums with different radix: " .. #p108 .. " and " .. #p109);
        end;

        return u103(p108, p109, 16777216);
    end;
end;

local function GCD(p112, p113, p114) -- Line: 422
    -- upvalues: u18 (copy), __div (copy)
    local v115 = u18[p114][#p112][0];

    while true do
        local v116 = p113;
        local v117, v118;

        for i = 1, #p113 do
            if p113[i] ~= v115[i] then
                v117 = false;

                if v117 then
                    return p112;
                end;

                v118, p113 = __div(p112, v116, p114);
                p112 = v116;
            end;
        end;

        v117 = true;

        if v117 then
            return p112;
        end;

        v118, p113 = __div(p112, v116, p114);
        p112 = v116;
        v117 = false;

        if v117 then
            return p112;
        end;

        v118, p113 = __div(p112, v116, p114);
        p112 = v116;
    end;
end;

local function LCM(p119, p120, p121) -- Line: 432
    -- upvalues: u18 (copy), __mul (copy), GCD (copy)
    local v122 = u18[p121][#p119][0];

    if p119 ~= v122 and p120 ~= v122 then
        v122 = __mul(p119, p120, p121) / GCD(p119, p120, p121) or v122;
    end;

    return v122;
end;

local u123 = ("0"):byte();

local function toScientificNotation(p124, p125, p126) -- Line: 439
    -- upvalues: __tostring (copy), u123 (copy)
    local v127 = p126 or 2;
    local v128 = __tostring(p124, p125);

    if #v128 - 2 < v127 then
        return v128;
    end;

    local v129 = {};

    for i = 1, v127 do
        v129[i] = v128:byte(i) - u123;
    end;

    v129[v127 + 1] = v128:byte(v127 + 1) - u123 + (v128:byte(v127 + 2) - u123 > 4 and 1 or 0);
    v129[v127 + 2] = #v128 - 1;

    return ("%d." .. ("%d"):rep(v127) .. "e%d"):format(unpack(v129));
end;

local u130 = typeof or type;

function u2.__tostring(p131, ...) -- Line: 378
    -- upvalues: u2 (copy), u130 (copy), __tostring (copy)
    local v132 = type(p131);

    if v132 == "number" then
        p131 = u2.new((tostring(p131)));
    elseif v132 == "string" then
        p131 = u2.new(p131);
    elseif v132 ~= "table" or getmetatable(p131) ~= u2 then
        error("bad argument to #1: expected BigNum, got " .. u130(p131));
    end;

    return __tostring(p131, 16777216, ...);
end;

local u133 = typeof or type;

function u2.__unm(p134, ...) -- Line: 378
    -- upvalues: u2 (copy), u133 (copy), __unm (copy)
    local v135 = type(p134);

    if v135 == "number" then
        p134 = u2.new((tostring(p134)));
    elseif v135 == "string" then
        p134 = u2.new(p134);
    elseif v135 ~= "table" or getmetatable(p134) ~= u2 then
        error("bad argument to #1: expected BigNum, got " .. u133(p134));
    end;

    return __unm(p134, 16777216, ...);
end;

local u136 = typeof or type;

function u2.__index.toScientificNotation(p137, ...) -- Line: 378
    -- upvalues: u2 (copy), u136 (copy), toScientificNotation (copy)
    local v138 = type(p137);

    if v138 == "number" then
        p137 = u2.new((tostring(p137)));
    elseif v138 == "string" then
        p137 = u2.new(p137);
    elseif v138 ~= "table" or getmetatable(p137) ~= u2 then
        error("bad argument to #1: expected BigNum, got " .. u136(p137));
    end;

    return toScientificNotation(p137, 16777216, ...);
end;

local u139 = typeof or type;

function u2.__add(p140, p141) -- Line: 392
    -- upvalues: u2 (copy), u139 (copy), __add (copy)
    local v142 = type(p140);

    if v142 == "number" then
        p140 = u2.new((tostring(p140)));
    elseif v142 == "string" then
        p140 = u2.new(p140);
    elseif v142 ~= "table" or getmetatable(p140) ~= u2 then
        error("bad argument to #1: expected BigNum, got " .. u139(p140));
    end;

    local v143 = type(p141);

    if v143 == "number" then
        p141 = u2.new((tostring(p141)));
    elseif v143 == "string" then
        p141 = u2.new(p141);
    elseif v143 ~= "table" or getmetatable(p141) ~= u2 then
        error("bad argument to #2: expected BigNum, got " .. u139(p141));
    end;

    if #p140 ~= #p141 then
        error("You cannot operate on BigNums with different radix: " .. #p140 .. " and " .. #p141);
    end;

    return __add(p140, p141, 16777216);
end;

local u144 = typeof or type;

function u2.__sub(p145, p146) -- Line: 392
    -- upvalues: u2 (copy), u144 (copy), __sub (copy)
    local v147 = type(p145);

    if v147 == "number" then
        p145 = u2.new((tostring(p145)));
    elseif v147 == "string" then
        p145 = u2.new(p145);
    elseif v147 ~= "table" or getmetatable(p145) ~= u2 then
        error("bad argument to #1: expected BigNum, got " .. u144(p145));
    end;

    local v148 = type(p146);

    if v148 == "number" then
        p146 = u2.new((tostring(p146)));
    elseif v148 == "string" then
        p146 = u2.new(p146);
    elseif v148 ~= "table" or getmetatable(p146) ~= u2 then
        error("bad argument to #2: expected BigNum, got " .. u144(p146));
    end;

    if #p145 ~= #p146 then
        error("You cannot operate on BigNums with different radix: " .. #p145 .. " and " .. #p146);
    end;

    return __sub(p145, p146, 16777216);
end;

local u149 = typeof or type;

function u2.__mul(p150, p151) -- Line: 392
    -- upvalues: u2 (copy), u149 (copy), __mul (copy)
    local v152 = type(p150);

    if v152 == "number" then
        p150 = u2.new((tostring(p150)));
    elseif v152 == "string" then
        p150 = u2.new(p150);
    elseif v152 ~= "table" or getmetatable(p150) ~= u2 then
        error("bad argument to #1: expected BigNum, got " .. u149(p150));
    end;

    local v153 = type(p151);

    if v153 == "number" then
        p151 = u2.new((tostring(p151)));
    elseif v153 == "string" then
        p151 = u2.new(p151);
    elseif v153 ~= "table" or getmetatable(p151) ~= u2 then
        error("bad argument to #2: expected BigNum, got " .. u149(p151));
    end;

    if #p150 ~= #p151 then
        error("You cannot operate on BigNums with different radix: " .. #p150 .. " and " .. #p151);
    end;

    return __mul(p150, p151, 16777216);
end;

local u154 = typeof or type;

function u2.__div(p155, p156) -- Line: 392
    -- upvalues: u2 (copy), u154 (copy), __div (copy)
    local v157 = type(p155);

    if v157 == "number" then
        p155 = u2.new((tostring(p155)));
    elseif v157 == "string" then
        p155 = u2.new(p155);
    elseif v157 ~= "table" or getmetatable(p155) ~= u2 then
        error("bad argument to #1: expected BigNum, got " .. u154(p155));
    end;

    local v158 = type(p156);

    if v158 == "number" then
        p156 = u2.new((tostring(p156)));
    elseif v158 == "string" then
        p156 = u2.new(p156);
    elseif v158 ~= "table" or getmetatable(p156) ~= u2 then
        error("bad argument to #2: expected BigNum, got " .. u154(p156));
    end;

    if #p155 ~= #p156 then
        error("You cannot operate on BigNums with different radix: " .. #p155 .. " and " .. #p156);
    end;

    return __div(p155, p156, 16777216);
end;

local u159 = typeof or type;

function u2.__pow(p160, p161) -- Line: 392
    -- upvalues: u2 (copy), u159 (copy), __pow (copy)
    local v162 = type(p160);

    if v162 == "number" then
        p160 = u2.new((tostring(p160)));
    elseif v162 == "string" then
        p160 = u2.new(p160);
    elseif v162 ~= "table" or getmetatable(p160) ~= u2 then
        error("bad argument to #1: expected BigNum, got " .. u159(p160));
    end;

    local v163 = type(p161);

    if v163 == "number" then
        p161 = u2.new((tostring(p161)));
    elseif v163 == "string" then
        p161 = u2.new(p161);
    elseif v163 ~= "table" or getmetatable(p161) ~= u2 then
        error("bad argument to #2: expected BigNum, got " .. u159(p161));
    end;

    if #p160 ~= #p161 then
        error("You cannot operate on BigNums with different radix: " .. #p160 .. " and " .. #p161);
    end;

    return __pow(p160, p161, 16777216);
end;

local u164 = typeof or type;

function u2.__mod(p165, p166) -- Line: 392
    -- upvalues: u2 (copy), u164 (copy), __mod (copy)
    local v167 = type(p165);

    if v167 == "number" then
        p165 = u2.new((tostring(p165)));
    elseif v167 == "string" then
        p165 = u2.new(p165);
    elseif v167 ~= "table" or getmetatable(p165) ~= u2 then
        error("bad argument to #1: expected BigNum, got " .. u164(p165));
    end;

    local v168 = type(p166);

    if v168 == "number" then
        p166 = u2.new((tostring(p166)));
    elseif v168 == "string" then
        p166 = u2.new(p166);
    elseif v168 ~= "table" or getmetatable(p166) ~= u2 then
        error("bad argument to #2: expected BigNum, got " .. u164(p166));
    end;

    if #p165 ~= #p166 then
        error("You cannot operate on BigNums with different radix: " .. #p165 .. " and " .. #p166);
    end;

    return __mod(p165, p166, 16777216);
end;

local u169 = typeof or type;

function u2.__lt(p170, p171) -- Line: 392
    -- upvalues: u2 (copy), u169 (copy), __lt (copy)
    local v172 = type(p170);

    if v172 == "number" then
        p170 = u2.new((tostring(p170)));
    elseif v172 == "string" then
        p170 = u2.new(p170);
    elseif v172 ~= "table" or getmetatable(p170) ~= u2 then
        error("bad argument to #1: expected BigNum, got " .. u169(p170));
    end;

    local v173 = type(p171);

    if v173 == "number" then
        p171 = u2.new((tostring(p171)));
    elseif v173 == "string" then
        p171 = u2.new(p171);
    elseif v173 ~= "table" or getmetatable(p171) ~= u2 then
        error("bad argument to #2: expected BigNum, got " .. u169(p171));
    end;

    if #p170 ~= #p171 then
        error("You cannot operate on BigNums with different radix: " .. #p170 .. " and " .. #p171);
    end;

    return __lt(p170, p171, 16777216);
end;

local u174 = typeof or type;

function u2.__eq(p175, p176) -- Line: 392
    -- upvalues: u2 (copy), u174 (copy), __eq (copy)
    local v177 = type(p175);

    if v177 == "number" then
        p175 = u2.new((tostring(p175)));
    elseif v177 == "string" then
        p175 = u2.new(p175);
    elseif v177 ~= "table" or getmetatable(p175) ~= u2 then
        error("bad argument to #1: expected BigNum, got " .. u174(p175));
    end;

    local v178 = type(p176);

    if v178 == "number" then
        p176 = u2.new((tostring(p176)));
    elseif v178 == "string" then
        p176 = u2.new(p176);
    elseif v178 ~= "table" or getmetatable(p176) ~= u2 then
        error("bad argument to #2: expected BigNum, got " .. u174(p176));
    end;

    if #p175 ~= #p176 then
        error("You cannot operate on BigNums with different radix: " .. #p175 .. " and " .. #p176);
    end;

    return __eq(p175, p176, 16777216);
end;

local u179 = typeof or type;

function u2.__index.GDC(p180, p181) -- Line: 392
    -- upvalues: u2 (copy), u179 (copy), GCD (copy)
    local v182 = type(p180);

    if v182 == "number" then
        p180 = u2.new((tostring(p180)));
    elseif v182 == "string" then
        p180 = u2.new(p180);
    elseif v182 ~= "table" or getmetatable(p180) ~= u2 then
        error("bad argument to #1: expected BigNum, got " .. u179(p180));
    end;

    local v183 = type(p181);

    if v183 == "number" then
        p181 = u2.new((tostring(p181)));
    elseif v183 == "string" then
        p181 = u2.new(p181);
    elseif v183 ~= "table" or getmetatable(p181) ~= u2 then
        error("bad argument to #2: expected BigNum, got " .. u179(p181));
    end;

    if #p180 ~= #p181 then
        error("You cannot operate on BigNums with different radix: " .. #p180 .. " and " .. #p181);
    end;

    return GCD(p180, p181, 16777216);
end;

local u184 = typeof or type;

function u2.__index.LCM(p185, p186) -- Line: 392
    -- upvalues: u2 (copy), u184 (copy), LCM (copy)
    local v187 = type(p185);

    if v187 == "number" then
        p185 = u2.new((tostring(p185)));
    elseif v187 == "string" then
        p185 = u2.new(p185);
    elseif v187 ~= "table" or getmetatable(p185) ~= u2 then
        error("bad argument to #1: expected BigNum, got " .. u184(p185));
    end;

    local v188 = type(p186);

    if v188 == "number" then
        p186 = u2.new((tostring(p186)));
    elseif v188 == "string" then
        p186 = u2.new(p186);
    elseif v188 ~= "table" or getmetatable(p186) ~= u2 then
        error("bad argument to #2: expected BigNum, got " .. u184(p186));
    end;

    if #p185 ~= #p186 then
        error("You cannot operate on BigNums with different radix: " .. #p185 .. " and " .. #p186);
    end;

    return LCM(p185, p186, 16777216);
end;

local function ProcessAsDecimal(p189, p190, p191, p192, p193, p194) -- Line: 482
    -- upvalues: __mul (copy), ProcessAsDecimal (copy), __pow (copy), u18 (copy), u123 (copy), __div (copy), __unm (copy), u2 (copy)
    local v195, v196, v197, v198, v199, v200, v201, v202;
    local v195, p189, v196, v197, v198, v199, v200, v201, v202;
    local v203 = 0;

    while true do
        if v203 == 0 then
            v203 = -1;

            if p192 then
                local v204 = tonumber(p192);
                local v205 = p191:find(".", 1, true) - 1;
                local v206 = v205 + v204;
                local v207 = (p191:sub(1, v205) .. p191:sub(v205 + 2)):sub(1, v206 > 0 and v206 and v206 or 0);
                local v208 = v207 == "" and "0" or v207;

                return __mul(ProcessAsDecimal(p189, p190, v208, nil, p193, p194), __pow(u18[p194][p189][10], u18[p194][p189][v206 - #v208], p194), p194);
            end;

            v195 = { (("0"):rep(p189 - #p191) .. p191):byte(1, -1) };
            local v209 = #v195;
            v198 = u18[p193][v209][0];
            v196 = u18[p193][v209][p194];

            for i = 1, v209 do
                v195[i] = v195[i] - u123;
            end;

            v197 = {};
            v203 = 1;
            continue;
        elseif v203 == 1 then
            v203 = -1;
            local v210;
            v199, v210 = __div(v195, v196, p193);
            v197[p189] = tonumber(table.concat(v210));
            p189 = p189 - 1;
            -- NumForInit
local v200, v201, v202 = 1, #v199, 1
-- end NumForInit;
            v195 = v199;
            v203 = 2;
            continue;
        elseif v203 == 2 then
            v203 = -1;
            v200 = v200 + v202;

            if v202 > 0 and v200 <= v201 or v202 <= 0 and v200 >= v201 then
                if v199[v200] ~= v198[v200] then
                    if false then
                        for i = 1, p189 do
                            v197[i] = 0;
                        end;

                        if p190 then
                            v197 = __unm(v197, p194) or v197;
                        end;

                        return setmetatable(v197, u2);
                    end;

                    v203 = 1;
                    continue;
                end;

                v203 = 2;
                continue;
            else
                break;
            end;
        else
            break;
        end;
    end;
end;

function u2.new(p211, p212) -- Line: 532
    -- upvalues: ProcessAsDecimal (copy), u1 (ref), u2 (copy)
    local v213 = type(p211);

    if v213 == "number" then
        p211 = tostring(p211);
        v213 = "string";
    end;

    if v213 ~= "string" then
        if v213 == "table" then
            return setmetatable(p211, u2);
        end;

        error(tostring(p211) .. " is not a valid input to BigNum.new, please supply a string or table");

        return;
    end;

    local v214 = #p211;

    if v214 > 0 then
        local _, v215 = p211:match("^(%-?)0[Xx](%x*%.?%x*)$");

        if v215 and (v215 ~= "" and v215 ~= ".") then
            return error("Hexidecimal is currently unsupported");
        end;

        local _, v216, v217, v218, v219 = p211:find("^(%-?)(%d*(%.?)%d*)");

        if v218 ~= "" and v218 ~= "." then
            local v220 = p211:match("^[Ee]([%+%-]?%d+)$", v216 + 1);

            if v220 or v216 == v214 then
                if v220 and v219 == "" then
                    v218 = v218 .. "." or v218;
                end;

                return ProcessAsDecimal(p212 or u1, v217 == "-", v218, v220, 10, 16777216);
            end;
        end;
    end;

    error(p211 .. " is not a valid Decimal value");
end;

function u2.GetRange(p221, p222, p223) -- Line: 583
    -- upvalues: u1 (ref), toScientificNotation (copy)
    local v224 = p223 or 16777216;
    local v225 = {};

    for i = 2, p222 or u1 do
        v225[i] = v224 - 1;
    end;

    v225[1] = (v224 - v224 % 2) / 2 - 1;

    return "+/- " .. toScientificNotation(v225, v224);
end;

function u2.SetDefaultRadix(p226, p227) -- Line: 601
    -- upvalues: u1 (ref)
    u1 = p227;
end;

function u2.fromString64(p228) -- Line: 610
    -- upvalues: u2 (copy)
    local v229 = {};

    for i = 1, #p228 / 4 do
        local v230 = i * 4;
        local v231, v232, v233, v234 = p228:byte(v230 - 3, v230);
        v229[i] = (v231 - 58) * 262144 + (v232 - 58) * 4096 + (v233 - 58) * 64 + (v234 - 58);
    end;

    return setmetatable(v229, u2);
end;

function u2.__index.toString64(p235) -- Line: 623
    local v236 = {};

    for i = 1, #p235 do
        local v237 = p235[i];
        local v238 = v237 % 64;
        local v239 = (v237 - v238) / 64;
        local v240 = v239 % 64;
        local v241 = (v239 - v240) / 64;
        local v242 = v241 % 64;
        v236[i] = string.char((v241 - v242) / 64 % 64 + 58, v242 + 58, v240 + 58, v238 + 58);
    end;

    return table.concat(v236);
end;

function u2.__index.toConstantForm(p243, p244) -- Line: 644
    -- upvalues: u4 (copy)
    local v245 = { "local CONSTANT_NUMBER = BigNum.new{\n\t" };
    local v246 = p244 or 16;

    for i = 1, #p243 do
        local v247 = tostring(p243[i]);
        local v248 = (" "):rep(0) .. v247;
        table.insert(v245, v248);
        table.insert(v245, ",");

        if i % v246 == 0 then
            table.insert(v245, "\n\t");
        else
            table.insert(v245, " ");
        end;
    end;

    table.remove(v245);
    v245[#v245] = "\n}";
    u4.Roblox(table.concat(v245));
end;

function u2.__index.stringify(p249, p250) -- Line: 668
    return (p249[1] >= (p250 or 16777216) / 2 and "-" or " ") .. "{" .. table.concat(p249, ", ") .. "}";
end;

local u251 = {
    __index = {}
};

local function newFraction(p252, p253, p254) -- Line: 675
    -- upvalues: __unm (copy), u251 (copy)
    if p253[1] >= p254 / 2 then
        p252 = __unm(p252, p254);
        p253 = __unm(p253, p254);
    end;

    return setmetatable({
        Numerator = p252,
        Denominator = p253
    }, u251);
end;

local function Fraction__reduce(p255, p256) -- Line: 687
    -- upvalues: GCD (copy), __div (copy)
    local v257 = GCD(p255.Numerator, p255.Denominator, p256);
    p255.Numerator = __div(p255.Numerator, v257, p256);
    p255.Denominator = __div(p255.Denominator, v257, p256);

    return p255;
end;

local function Fraction__add(p258, p259, p260) -- Line: 696
    -- upvalues: newFraction (copy), __add (copy), __mul (copy)
    return newFraction(__add(__mul(p258.Numerator, p259.Denominator, p260), __mul(p259.Numerator, p258.Denominator, p260), p260), __mul(p258.Denominator, p259.Denominator, p260), p260);
end;

local function Fraction__sub(p261, p262, p263) -- Line: 704
    -- upvalues: newFraction (copy), __mul (copy), __add (copy), __unm (copy)
    return newFraction(__add(__mul(p261.Numerator, p262.Denominator, p263), __unm(__mul(p262.Numerator, p261.Denominator, p263), p263), p263), __mul(p261.Denominator, p262.Denominator, p263), p263);
end;

local function Fraction__mul(p264, p265, p266) -- Line: 712
    -- upvalues: newFraction (copy), __mul (copy)
    return newFraction(__mul(p264.Numerator, p265.Numerator, p266), __mul(p264.Denominator, p265.Denominator, p266), p266);
end;

local function Fraction__div(p267, p268, p269) -- Line: 716
    -- upvalues: newFraction (copy), __mul (copy)
    return newFraction(__mul(p267.Numerator, p268.Denominator, p269), __mul(p267.Denominator, p268.Numerator, p269), p269);
end;

local function Fraction__mod() -- Line: 720
    error("The modulo operation is undefined for Fractions");
end;

local function Fraction__pow(p270, p271, p272) -- Line: 724
    -- upvalues: __div (copy), newFraction (copy), __pow (copy), __tostring (copy)
    local v273 = __div(p271.Numerator, p271.Denominator, p272);

    if type(v273) == "number" then
        return newFraction(__pow(p270.Numerator, v273, p272), __pow(p270.Denominator, v273, p272), p272);
    end;

    error("Cannot raise " .. __tostring(p270, p272) .. " to the Power of " .. __tostring(v273, p272));
end;

local function Fraction__tostring(p274, p275) -- Line: 734
    -- upvalues: __tostring (copy)
    return __tostring(p274.Numerator, p275) .. " / " .. __tostring(p274.Denominator, p275);
end;

local function Fraction__toScientificNotation(p276, p277, p278) -- Line: 738
    -- upvalues: toScientificNotation (copy)
    return toScientificNotation(p276.Numerator, p277, p278) .. " / " .. toScientificNotation(p276.Denominator, p277, p278);
end;

local function Fraction__lt(p279, p280, p281) -- Line: 744
    -- upvalues: __lt (copy), __mul (copy)
    return __lt(__mul(p279.Numerator, p280.Denominator, p281), __mul(p280.Numerator, p279.Denominator, p281), p281);
end;

local function Fraction__unm(p282, p283) -- Line: 748
    -- upvalues: newFraction (copy), __unm (copy)
    return newFraction(__unm(p282.Numerator, p283), p282.Denominator, p283);
end;

local function Fraction__eq(p284, p285, p286) -- Line: 752
    -- upvalues: __mul (copy)
    local v287 = __mul(p284.Numerator, p285.Denominator, p286);
    local v288 = __mul(p285.Numerator, p284.Denominator, p286);

    for i = 1, #v287 do
        if v287[i] ~= v288[i] then
            return false;
        end;
    end;

    return true;
end;

local function EnsureFractionalCompatibility(u289, p290) -- Line: 756
    -- upvalues: u251 (copy)
    local u291 = typeof or type;

    return p290 and function(p292, ...) -- Line: 759
        -- upvalues: u251 (ref), u291 (copy), u289 (copy)
        if getmetatable(p292) ~= u251 then
            error("bad argument to #1: expected Fraction, got " .. u291(p292));
        end;

        return u289(p292, 16777216, ...);
    end or function(p293, p294) -- Line: 767
        -- upvalues: u251 (ref), u291 (copy), u289 (copy)
        if getmetatable(p293) ~= u251 then
            error("bad argument to #1: expected Fraction, got " .. u291(p293));
        end;

        if getmetatable(p294) ~= u251 then
            error("bad argument to #2: expected Fraction, got " .. u291(p294));
        end;

        if #p293 ~= #p294 then
            error("You cannot operate on Fractions with BigNums of different sizes: " .. #p293 .. " and " .. #p294);
        end;

        return u289(p293, p294, 16777216);
    end;
end;

local u295 = typeof or type;

function u251.__tostring(p296, ...) -- Line: 759
    -- upvalues: u251 (copy), u295 (copy), Fraction__tostring (copy)
    if getmetatable(p296) ~= u251 then
        error("bad argument to #1: expected Fraction, got " .. u295(p296));
    end;

    return Fraction__tostring(p296, 16777216, ...);
end;

local u297 = typeof or type;

function u251.__unm(p298, ...) -- Line: 759
    -- upvalues: u251 (copy), u297 (copy), Fraction__unm (copy)
    if getmetatable(p298) ~= u251 then
        error("bad argument to #1: expected Fraction, got " .. u297(p298));
    end;

    return Fraction__unm(p298, 16777216, ...);
end;

local u299 = typeof or type;

function u251.__index.Reduce(p300, ...) -- Line: 759
    -- upvalues: u251 (copy), u299 (copy), Fraction__reduce (copy)
    if getmetatable(p300) ~= u251 then
        error("bad argument to #1: expected Fraction, got " .. u299(p300));
    end;

    return Fraction__reduce(p300, 16777216, ...);
end;

local u301 = typeof or type;

function u251.__index.toScientificNotation(p302, ...) -- Line: 759
    -- upvalues: u251 (copy), u301 (copy), Fraction__toScientificNotation (copy)
    if getmetatable(p302) ~= u251 then
        error("bad argument to #1: expected Fraction, got " .. u301(p302));
    end;

    return Fraction__toScientificNotation(p302, 16777216, ...);
end;

local u303 = typeof or type;

function u251.__add(p304, p305) -- Line: 767
    -- upvalues: u251 (copy), u303 (copy), Fraction__add (copy)
    if getmetatable(p304) ~= u251 then
        error("bad argument to #1: expected Fraction, got " .. u303(p304));
    end;

    if getmetatable(p305) ~= u251 then
        error("bad argument to #2: expected Fraction, got " .. u303(p305));
    end;

    if #p304 ~= #p305 then
        error("You cannot operate on Fractions with BigNums of different sizes: " .. #p304 .. " and " .. #p305);
    end;

    return Fraction__add(p304, p305, 16777216);
end;

local u306 = typeof or type;

function u251.__sub(p307, p308) -- Line: 767
    -- upvalues: u251 (copy), u306 (copy), Fraction__sub (copy)
    if getmetatable(p307) ~= u251 then
        error("bad argument to #1: expected Fraction, got " .. u306(p307));
    end;

    if getmetatable(p308) ~= u251 then
        error("bad argument to #2: expected Fraction, got " .. u306(p308));
    end;

    if #p307 ~= #p308 then
        error("You cannot operate on Fractions with BigNums of different sizes: " .. #p307 .. " and " .. #p308);
    end;

    return Fraction__sub(p307, p308, 16777216);
end;

local u309 = typeof or type;

function u251.__mul(p310, p311) -- Line: 767
    -- upvalues: u251 (copy), u309 (copy), Fraction__mul (copy)
    if getmetatable(p310) ~= u251 then
        error("bad argument to #1: expected Fraction, got " .. u309(p310));
    end;

    if getmetatable(p311) ~= u251 then
        error("bad argument to #2: expected Fraction, got " .. u309(p311));
    end;

    if #p310 ~= #p311 then
        error("You cannot operate on Fractions with BigNums of different sizes: " .. #p310 .. " and " .. #p311);
    end;

    return Fraction__mul(p310, p311, 16777216);
end;

local u312 = typeof or type;

function u251.__div(p313, p314) -- Line: 767
    -- upvalues: u251 (copy), u312 (copy), Fraction__div (copy)
    if getmetatable(p313) ~= u251 then
        error("bad argument to #1: expected Fraction, got " .. u312(p313));
    end;

    if getmetatable(p314) ~= u251 then
        error("bad argument to #2: expected Fraction, got " .. u312(p314));
    end;

    if #p313 ~= #p314 then
        error("You cannot operate on Fractions with BigNums of different sizes: " .. #p313 .. " and " .. #p314);
    end;

    return Fraction__div(p313, p314, 16777216);
end;

local u315 = typeof or type;

function u251.__pow(p316, p317) -- Line: 767
    -- upvalues: u251 (copy), u315 (copy), Fraction__pow (copy)
    if getmetatable(p316) ~= u251 then
        error("bad argument to #1: expected Fraction, got " .. u315(p316));
    end;

    if getmetatable(p317) ~= u251 then
        error("bad argument to #2: expected Fraction, got " .. u315(p317));
    end;

    if #p316 ~= #p317 then
        error("You cannot operate on Fractions with BigNums of different sizes: " .. #p316 .. " and " .. #p317);
    end;

    return Fraction__pow(p316, p317, 16777216);
end;

local u318 = typeof or type;

function u251.__mod(p319, p320) -- Line: 767
    -- upvalues: u251 (copy), u318 (copy), Fraction__mod (copy)
    if getmetatable(p319) ~= u251 then
        error("bad argument to #1: expected Fraction, got " .. u318(p319));
    end;

    if getmetatable(p320) ~= u251 then
        error("bad argument to #2: expected Fraction, got " .. u318(p320));
    end;

    if #p319 ~= #p320 then
        error("You cannot operate on Fractions with BigNums of different sizes: " .. #p319 .. " and " .. #p320);
    end;

    return Fraction__mod(p319, p320, 16777216);
end;

local u321 = typeof or type;

function u251.__lt(p322, p323) -- Line: 767
    -- upvalues: u251 (copy), u321 (copy), Fraction__lt (copy)
    if getmetatable(p322) ~= u251 then
        error("bad argument to #1: expected Fraction, got " .. u321(p322));
    end;

    if getmetatable(p323) ~= u251 then
        error("bad argument to #2: expected Fraction, got " .. u321(p323));
    end;

    if #p322 ~= #p323 then
        error("You cannot operate on Fractions with BigNums of different sizes: " .. #p322 .. " and " .. #p323);
    end;

    return Fraction__lt(p322, p323, 16777216);
end;

local u324 = typeof or type;

function u251.__eq(p325, p326) -- Line: 767
    -- upvalues: u251 (copy), u324 (copy), Fraction__eq (copy)
    if getmetatable(p325) ~= u251 then
        error("bad argument to #1: expected Fraction, got " .. u324(p325));
    end;

    if getmetatable(p326) ~= u251 then
        error("bad argument to #2: expected Fraction, got " .. u324(p326));
    end;

    if #p325 ~= #p326 then
        error("You cannot operate on Fractions with BigNums of different sizes: " .. #p325 .. " and " .. #p326);
    end;

    return Fraction__eq(p325, p326, 16777216);
end;

local u327 = typeof or type;

function u2.newFraction(p328, p329) -- Line: 392
    -- upvalues: u2 (copy), u327 (copy), newFraction (copy)
    local v330 = type(p328);

    if v330 == "number" then
        p328 = u2.new((tostring(p328)));
    elseif v330 == "string" then
        p328 = u2.new(p328);
    elseif v330 ~= "table" or getmetatable(p328) ~= u2 then
        error("bad argument to #1: expected BigNum, got " .. u327(p328));
    end;

    local v331 = type(p329);

    if v331 == "number" then
        p329 = u2.new((tostring(p329)));
    elseif v331 == "string" then
        p329 = u2.new(p329);
    elseif v331 ~= "table" or getmetatable(p329) ~= u2 then
        error("bad argument to #2: expected BigNum, got " .. u327(p329));
    end;

    if #p328 ~= #p329 then
        error("You cannot operate on BigNums with different radix: " .. #p328 .. " and " .. #p329);
    end;

    return newFraction(p328, p329, 16777216);
end;

return u2;