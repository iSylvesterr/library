-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.UserGenerated.Randoms.Base);
local GenerateSeed = require(ReplicatedStorage.UserGenerated.IO.Crypto.GenerateSeed);
local Theory = require(script.Theory);
local bxor = bit32.bxor;
local bor = bit32.bor;
local band = bit32.band;
local lshift = bit32.lshift;
local rshift = bit32.rshift;
local floor = math.floor;
local ldexp = math.ldexp;
local sqrt = math.sqrt;
local log = math.log;
local max = math.max;
local sin = math.sin;
local cos = math.cos;
local clamp = math.clamp;
local format = string.format;
local new = Vector2.new;
local new2 = Vector3.new;
assert(true);
local u1 = Random.new();

local function Mul32(p2, p3) -- Line: 42
    -- upvalues: rshift (copy), band (copy), lshift (copy)
    local v4 = rshift(p2, 16);
    local v5 = band(p2, 65535);
    local v6 = rshift(p3, 16);
    local v7 = band(p3, 65535);

    return lshift(band(v4 * v7 + v5 * v6, 65535), 16) + v5 * v7;
end;

local function IsInteger(p8) -- Line: 53
    -- upvalues: floor (copy)
    local v9;

    if type(p8) == "number" and (floor(p8) == p8 and p8 ~= (1 / 0)) then
        v9 = p8 ~= (-1 / 0);
    else
        v9 = false;
    end;

    return v9;
end;

local function AssertInteger(p10) -- Line: 57
    -- upvalues: floor (copy)
    local v11;

    if type(p10) == "number" and (floor(p10) == p10 and p10 ~= (1 / 0)) then
        v11 = p10 ~= (-1 / 0);
    else
        v11 = false;
    end;

    if not v11 then
        error("Integer", 2);
    end;
end;

local function AssertIntegerNonNegative(p12) -- Line: 64
    -- upvalues: floor (copy)
    local v13;

    if type(p12) == "number" and (floor(p12) == p12 and p12 ~= (1 / 0)) then
        v13 = p12 ~= (-1 / 0);
    else
        v13 = false;
    end;

    if not v13 then
        error("Integer", 2);
    end;

    if p12 < 0 then
        error("NonNegative", 2);
    end;
end;

local function Seed(p14, p15) -- Line: 154
    -- upvalues: u1 (copy), bor (copy), rshift (copy), band (copy), lshift (copy)
    local v16 = p15 == nil and {} or (type(p15) == "number" and { p15 } or p15);
    local v17 = v16[2];
    local v18 = v16[3];
    local v19 = v16[4];
    local v20 = bor(v16[1] or u1:NextInteger(0, 4294967295), 0);

    if not v17 then
        local v21 = rshift(v20, 16);
        local v22 = band(v20, 65535);
        v17 = lshift(band(v22 * 27655 + v21 * 35173, 65535), 16) + v22 * 35173 + 1;
    end;

    local v23 = bor(v17, 0);

    if not v18 then
        local v24 = rshift(v23, 16);
        local v25 = band(v23, 65535);
        v18 = lshift(band(v25 * 27655 + v24 * 35173, 65535), 16) + v25 * 35173 + 1;
    end;

    local v26 = bor(v18, 0);

    if not v19 then
        local v27 = rshift(v26, 16);
        local v28 = band(v26, 65535);
        v19 = lshift(band(v28 * 27655 + v27 * 35173, 65535), 16) + v28 * 35173 + 1;
    end;

    local v29 = bor(v19, 0);
    p14.x = v20;
    p14.y = v23;
    p14.z = v26;
    p14.w = v29;
end;

local v144 = table.freeze({
    NextU32 = function(p30) -- Line: 89, Name: NextU32
        -- upvalues: lshift (copy), bxor (copy), rshift (copy)
        local x = p30.x;
        local w = p30.w;
        local v31 = bxor(x, (lshift(x, 11)));
        local v32 = bxor(bxor(bxor(v31, (rshift(v31, 8))), w), (rshift(w, 19)));
        local z = p30.z;
        p30.x = p30.y;
        p30.y = z;
        p30.z = w;
        p30.w = v32;

        return v32;
    end,

    NextU64 = function(p33) -- Line: 99, Name: NextU64
        -- upvalues: lshift (copy), bxor (copy), rshift (copy), ldexp (copy)
        local x = p33.x;
        local w = p33.w;
        local v34 = bxor(x, (lshift(x, 11)));
        local v35 = bxor(bxor(bxor(v34, (rshift(v34, 8))), w), (rshift(w, 19)));
        local z = p33.z;
        p33.x = p33.y;
        p33.y = z;
        p33.z = w;
        p33.w = v35;
        local v36 = ldexp(v35, 32);
        local x2 = p33.x;
        local w2 = p33.w;
        local v37 = bxor(x2, (lshift(x2, 11)));
        local v38 = bxor(bxor(bxor(v37, (rshift(v37, 8))), w2), (rshift(w2, 19)));
        local z2 = p33.z;
        p33.x = p33.y;
        p33.y = z2;
        p33.z = w2;
        p33.w = v38;

        return v36 + v38;
    end,

    NextFloat = function(p39) -- Line: 103, Name: NextFloat
        -- upvalues: lshift (copy), bxor (copy), rshift (copy), ldexp (copy)
        local x = p39.x;
        local w = p39.w;
        local v40 = bxor(x, (lshift(x, 11)));
        local v41 = bxor(bxor(bxor(v40, (rshift(v40, 8))), w), (rshift(w, 19)));
        local z = p39.z;
        p39.x = p39.y;
        p39.y = z;
        p39.z = w;
        p39.w = v41;

        return ldexp(v41, -32);
    end,

    NextDouble = function(p42) -- Line: 107, Name: NextDouble
        -- upvalues: lshift (copy), bxor (copy), rshift (copy), ldexp (copy)
        local x = p42.x;
        local w = p42.w;
        local v43 = bxor(x, (lshift(x, 11)));
        local v44 = bxor(bxor(bxor(v43, (rshift(v43, 8))), w), (rshift(w, 19)));
        local z = p42.z;
        p42.x = p42.y;
        p42.y = z;
        p42.z = w;
        p42.w = v44;
        local v45 = ldexp(v44, 32);
        local x2 = p42.x;
        local w2 = p42.w;
        local v46 = bxor(x2, (lshift(x2, 11)));
        local v47 = bxor(bxor(bxor(v46, (rshift(v46, 8))), w2), (rshift(w2, 19)));
        local z2 = p42.z;
        p42.x = p42.y;
        p42.y = z2;
        p42.z = w2;
        p42.w = v47;

        return ldexp(v45 + v47, -64);
    end,

    NextNumber = function(p48, p49, p50) -- Line: 111, Name: NextNumber
        -- upvalues: lshift (copy), bxor (copy), rshift (copy), ldexp (copy)
        local x = p48.x;
        local w = p48.w;
        local v51 = bxor(x, (lshift(x, 11)));
        local v52 = bxor(bxor(bxor(v51, (rshift(v51, 8))), w), (rshift(w, 19)));
        local z = p48.z;
        p48.x = p48.y;
        p48.y = z;
        p48.z = w;
        p48.w = v52;
        local v53 = ldexp(v52, 32);
        local x2 = p48.x;
        local w2 = p48.w;
        local v54 = bxor(x2, (lshift(x2, 11)));
        local v55 = bxor(bxor(bxor(v54, (rshift(v54, 8))), w2), (rshift(w2, 19)));
        local z2 = p48.z;
        p48.x = p48.y;
        p48.y = z2;
        p48.z = w2;
        p48.w = v55;

        return p49 + (p50 - p49) * ldexp(v53 + v55, -64);
    end,

    NextInteger = function(p56, p57, p58) -- Line: 115, Name: NextInteger
        -- upvalues: lshift (copy), bxor (copy), rshift (copy), ldexp (copy), floor (copy)
        local x = p56.x;
        local w = p56.w;
        local v59 = bxor(x, (lshift(x, 11)));
        local v60 = bxor(bxor(bxor(v59, (rshift(v59, 8))), w), (rshift(w, 19)));
        local z = p56.z;
        p56.x = p56.y;
        p56.y = z;
        p56.z = w;
        p56.w = v60;
        local v61 = ldexp(v60, 32);
        local x2 = p56.x;
        local w2 = p56.w;
        local v62 = bxor(x2, (lshift(x2, 11)));
        local v63 = bxor(bxor(bxor(v62, (rshift(v62, 8))), w2), (rshift(w2, 19)));
        local z2 = p56.z;
        p56.x = p56.y;
        p56.y = z2;
        p56.z = w2;
        p56.w = v63;

        return floor(p57 + (p58 - p57 + 1) * ldexp(v61 + v63, -64));
    end,

    NextNormal = function(p64, p65, p66) -- Line: 119, Name: NextNormal
        -- upvalues: lshift (copy), bxor (copy), rshift (copy), ldexp (copy), max (copy), log (copy), sqrt (copy), cos (copy), sin (copy)
        local x = p64.x;
        local w = p64.w;
        local v67 = bxor(x, (lshift(x, 11)));
        local v68 = bxor(bxor(bxor(v67, (rshift(v67, 8))), w), (rshift(w, 19)));
        local z = p64.z;
        p64.x = p64.y;
        p64.y = z;
        p64.z = w;
        p64.w = v68;
        local v69 = ldexp(v68, 32);
        local x2 = p64.x;
        local w2 = p64.w;
        local v70 = bxor(x2, (lshift(x2, 11)));
        local v71 = bxor(bxor(bxor(v70, (rshift(v70, 8))), w2), (rshift(w2, 19)));
        local z2 = p64.z;
        p64.x = p64.y;
        p64.y = z2;
        p64.z = w2;
        p64.w = v71;
        local v72 = sqrt(log((max(2.2250738585072014e-308, (ldexp(v69 + v71, -64))))) * -2) * (p66 or 0);
        local x3 = p64.x;
        local w3 = p64.w;
        local v73 = bxor(x3, (lshift(x3, 11)));
        local v74 = bxor(bxor(bxor(v73, (rshift(v73, 8))), w3), (rshift(w3, 19)));
        local z3 = p64.z;
        p64.x = p64.y;
        p64.y = z3;
        p64.z = w3;
        p64.w = v74;
        local v75 = ldexp(v74, 32);
        local x4 = p64.x;
        local w4 = p64.w;
        local v76 = bxor(x4, (lshift(x4, 11)));
        local v77 = bxor(bxor(bxor(v76, (rshift(v76, 8))), w4), (rshift(w4, 19)));
        local z4 = p64.z;
        p64.x = p64.y;
        p64.y = z4;
        p64.z = w4;
        p64.w = v77;
        local v78 = 6.283185307179586 * ldexp(v75 + v77, -64);
        local v79 = p65 or 0;

        return cos(v78) * v72 + v79, sin(v78) * v72 + v79;
    end,

    NextBoolean = function(p80, p81) -- Line: 126, Name: NextBoolean
        -- upvalues: lshift (copy), bxor (copy), rshift (copy), ldexp (copy)
        local x = p80.x;
        local w = p80.w;
        local v82 = bxor(x, (lshift(x, 11)));
        local v83 = bxor(bxor(bxor(v82, (rshift(v82, 8))), w), (rshift(w, 19)));
        local z = p80.z;
        p80.x = p80.y;
        p80.y = z;
        p80.z = w;
        p80.w = v83;
        local v84 = ldexp(v83, 32);
        local x2 = p80.x;
        local w2 = p80.w;
        local v85 = bxor(x2, (lshift(x2, 11)));
        local v86 = bxor(bxor(bxor(v85, (rshift(v85, 8))), w2), (rshift(w2, 19)));
        local z2 = p80.z;
        p80.x = p80.y;
        p80.y = z2;
        p80.z = w2;
        p80.w = v86;

        return ldexp(v84 + v86, -64) < (p81 or 0.5);
    end,

    NextVector2 = function(p87, p88) -- Line: 130, Name: NextVector2
        -- upvalues: lshift (copy), bxor (copy), rshift (copy), ldexp (copy), new (copy), cos (copy), sin (copy)
        local v89 = p88 or 1;
        local x = p87.x;
        local w = p87.w;
        local v90 = bxor(x, (lshift(x, 11)));
        local v91 = bxor(bxor(bxor(v90, (rshift(v90, 8))), w), (rshift(w, 19)));
        local z = p87.z;
        p87.x = p87.y;
        p87.y = z;
        p87.z = w;
        p87.w = v91;
        local v92 = ldexp(v91, 32);
        local x2 = p87.x;
        local w2 = p87.w;
        local v93 = bxor(x2, (lshift(x2, 11)));
        local v94 = bxor(bxor(bxor(v93, (rshift(v93, 8))), w2), (rshift(w2, 19)));
        local z2 = p87.z;
        p87.x = p87.y;
        p87.y = z2;
        p87.z = w2;
        p87.w = v94;
        local v95 = 6.283185307179586 * ldexp(v92 + v94, -64);

        return new(cos(v95) * v89, sin(v95) * v89);
    end,

    NextVector3 = function(p96, p97) -- Line: 136, Name: NextVector3
        -- upvalues: lshift (copy), bxor (copy), rshift (copy), ldexp (copy), sqrt (copy), cos (copy), sin (copy), new2 (copy)
        local v98 = p97 or 1;
        local x = p96.x;
        local w = p96.w;
        local v99 = bxor(x, (lshift(x, 11)));
        local v100 = bxor(bxor(bxor(v99, (rshift(v99, 8))), w), (rshift(w, 19)));
        local z = p96.z;
        p96.x = p96.y;
        p96.y = z;
        p96.z = w;
        p96.w = v100;
        local v101 = ldexp(v100, 32);
        local x2 = p96.x;
        local w2 = p96.w;
        local v102 = bxor(x2, (lshift(x2, 11)));
        local v103 = bxor(bxor(bxor(v102, (rshift(v102, 8))), w2), (rshift(w2, 19)));
        local z2 = p96.z;
        p96.x = p96.y;
        p96.y = z2;
        p96.z = w2;
        p96.w = v103;
        local v104 = 6.283185307179586 * ldexp(v101 + v103, -64);
        local x3 = p96.x;
        local w3 = p96.w;
        local v105 = bxor(x3, (lshift(x3, 11)));
        local v106 = bxor(bxor(bxor(v105, (rshift(v105, 8))), w3), (rshift(w3, 19)));
        local z3 = p96.z;
        p96.x = p96.y;
        p96.y = z3;
        p96.z = w3;
        p96.w = v106;
        local v107 = ldexp(v106, 32);
        local x4 = p96.x;
        local w4 = p96.w;
        local v108 = bxor(x4, (lshift(x4, 11)));
        local v109 = bxor(bxor(bxor(v108, (rshift(v108, 8))), w4), (rshift(w4, 19)));
        local z4 = p96.z;
        p96.x = p96.y;
        p96.y = z4;
        p96.z = w4;
        p96.w = v109;
        local v110 = ldexp(v107 + v109, -64) * 2 - 1;
        local v111 = sqrt(1 - v110 * v110);

        return new2(cos(v104) * v111 * v98, sin(v104) * v111 * v98, v110 * v98);
    end,

    NextUUIDv4 = function(p112) -- Line: 144, Name: NextUUIDv4
        -- upvalues: format (copy), lshift (copy), bxor (copy), rshift (copy), band (copy), bor (copy)
        local x = p112.x;
        local w = p112.w;
        local v113 = bxor(x, (lshift(x, 11)));
        local v114 = bxor(bxor(bxor(v113, (rshift(v113, 8))), w), (rshift(w, 19)));
        local z = p112.z;
        p112.x = p112.y;
        p112.y = z;
        p112.z = w;
        p112.w = v114;
        local x2 = p112.x;
        local w2 = p112.w;
        local v115 = bxor(x2, (lshift(x2, 11)));
        local v116 = bxor(bxor(bxor(v115, (rshift(v115, 8))), w2), (rshift(w2, 19)));
        local z2 = p112.z;
        p112.x = p112.y;
        p112.y = z2;
        p112.z = w2;
        p112.w = v116;
        local v117 = bor(band(v116, 4294905855), 16384);
        local x3 = p112.x;
        local w3 = p112.w;
        local v118 = bxor(x3, (lshift(x3, 11)));
        local v119 = bxor(bxor(bxor(v118, (rshift(v118, 8))), w3), (rshift(w3, 19)));
        local z3 = p112.z;
        p112.x = p112.y;
        p112.y = z3;
        p112.z = w3;
        p112.w = v119;
        local v120 = bor(band(v119, 1073741823), 2147483648);
        local x4 = p112.x;
        local w4 = p112.w;
        local v121 = bxor(x4, (lshift(x4, 11)));
        local v122 = bxor(bxor(bxor(v121, (rshift(v121, 8))), w4), (rshift(w4, 19)));
        local z4 = p112.z;
        p112.x = p112.y;
        p112.y = z4;
        p112.z = w4;
        p112.w = v122;

        return format("%08x%08x%08x%08x", v114, v117, v120, v122);
    end,

    Seed = Seed,

    Shuffle = function(p123, p124) -- Line: 185, Name: Shuffle
        -- upvalues: lshift (copy), bxor (copy), rshift (copy), ldexp (copy), floor (copy)
        local v125 = type(p124) == "table";
        assert(v125);

        for i = #p124, 2, -1 do
            local x = p123.x;
            local w = p123.w;
            local v126 = bxor(x, (lshift(x, 11)));
            local v127 = bxor(bxor(bxor(v126, (rshift(v126, 8))), w), (rshift(w, 19)));
            local z = p123.z;
            p123.x = p123.y;
            p123.y = z;
            p123.z = w;
            p123.w = v127;
            local v128 = ldexp(v127, 32);
            local x2 = p123.x;
            local w2 = p123.w;
            local v129 = bxor(x2, (lshift(x2, 11)));
            local v130 = bxor(bxor(bxor(v129, (rshift(v129, 8))), w2), (rshift(w2, 19)));
            local z2 = p123.z;
            p123.x = p123.y;
            p123.y = z2;
            p123.z = w2;
            p123.w = v130;
            local v131 = floor((i - 1 + 1) * ldexp(v128 + v130, -64) + 1);
            local v132 = p124[i];
            p124[i] = p124[v131];
            p124[v131] = v132;
        end;
    end,

    Clone = function(p133) -- Line: 193, Name: Clone
        local v134 = {
            x = p133.x,
            y = p133.y,
            z = p133.z,
            w = p133.w
        };
        local v135 = getmetatable(p133);

        return setmetatable(v134, v135);
    end,

    GetState = function(p136) -- Line: 203, Name: GetState
        return {
            p136.x,
            p136.y,
            p136.z,
            p136.w
        };
    end,

    Skip = function(p137, p138) -- Line: 207, Name: Skip
        -- upvalues: floor (copy), Theory (copy)
        local v139;

        if type(p138) == "number" and (floor(p138) == p138 and p138 ~= (1 / 0)) then
            v139 = p138 ~= (-1 / 0);
        else
            v139 = false;
        end;

        if not v139 then
            error("Integer", 2);
        end;

        local v140, v141, v142, v143 = Theory.Transform(p137.x, p137.y, p137.z, p137.w, p138);
        p137.x = v140;
        p137.y = v141;
        p137.z = v142;
        p137.w = v143;
    end
});
local u145 = table.freeze({
    __index = v144
});
local u148 = {
    new = function(p146) -- Line: 234, Name: new
        -- upvalues: Seed (copy), u145 (copy)
        local v147 = {
            x = 0,
            y = 0,
            z = 0,
            w = 0
        };
        Seed(v147, p146);

        return setmetatable(v147, u145);
    end
};

function u148.Unique(p149) -- Line: 245
    -- upvalues: floor (copy), clamp (copy), u148 (copy), GenerateSeed (copy)
    if p149 ~= nil then
        local v150;

        if type(p149) == "number" and (floor(p149) == p149 and p149 ~= (1 / 0)) then
            v150 = p149 ~= (-1 / 0);
        else
            v150 = false;
        end;

        if not v150 then
            error("Integer", 2);
        end;

        if p149 < 0 then
            error("NonNegative", 2);
        end;
    end;

    local v151 = clamp(p149 or 4, 0, 4);

    return u148.new(GenerateSeed(v151));
end;

u148.R = u148.Unique();

return table.freeze(u148);