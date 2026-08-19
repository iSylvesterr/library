-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.UserGenerated.Randoms.Base);
local GenerateSeed = require(ReplicatedStorage.UserGenerated.IO.Crypto.GenerateSeed);
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
local create = table.create;
local clone = table.clone;
local format = string.format;
local new = Vector2.new;
local new2 = Vector3.new;
assert(true);
local u1 = Random.new();

local function IsInteger(p2) -- Line: 45
    -- upvalues: floor (copy)
    local v3;

    if type(p2) == "number" and (floor(p2) == p2 and p2 ~= (1 / 0)) then
        v3 = p2 ~= (-1 / 0);
    else
        v3 = false;
    end;

    return v3;
end;

local function AssertIntegerNonNegative(p4) -- Line: 53
    -- upvalues: floor (copy)
    local v5;

    if type(p4) == "number" and (floor(p4) == p4 and p4 ~= (1 / 0)) then
        v5 = p4 ~= (-1 / 0);
    else
        v5 = false;
    end;

    if not v5 then
        error("Integer", 2);
    end;

    if p4 < 0 then
        error("NonNegative", 2);
    end;
end;

local function IsaacMix(p6) -- Line: 77
    -- upvalues: lshift (copy), bxor (copy), bor (copy), rshift (copy)
    local v7 = p6[2];
    local v8 = p6[3];
    local v9 = p6[4];
    local v10 = p6[5];
    local v11 = p6[6];
    local v12 = p6[7];
    local v13 = p6[8];
    local v14 = bxor(p6[1], (lshift(v7, 11)));
    local v15 = bor(v9 + v14, 0);
    local v16 = bxor(bor(v7 + v8, 0), (rshift(v8, 2)));
    local v17 = bor(v10 + v16, 0);
    local v18 = bxor(bor(v8 + v15, 0), (lshift(v15, 8)));
    local v19 = bor(v11 + v18, 0);
    local v20 = bxor(bor(v15 + v17, 0), (rshift(v17, 16)));
    local v21 = bor(v12 + v20, 0);
    local v22 = bxor(bor(v17 + v19, 0), (lshift(v19, 10)));
    local v23 = bor(v13 + v22, 0);
    local v24 = bxor(bor(v19 + v21, 0), (rshift(v21, 4)));
    local v25 = bor(v14 + v24, 0);
    local v26 = bxor(bor(v21 + v23, 0), (lshift(v23, 8)));
    local v27 = bor(v16 + v26, 0);
    local v28 = bxor(bor(v23 + v25, 0), (rshift(v25, 9)));
    local v29 = bor(v18 + v28, 0);
    p6[1] = bor(v25 + v27, 0);
    p6[2] = v27;
    p6[3] = v29;
    p6[4] = v20;
    p6[5] = v22;
    p6[6] = v24;
    p6[7] = v26;
    p6[8] = v28;
end;

local function Isaac(p30) -- Line: 92
    -- upvalues: bor (copy), band (copy), rshift (copy), bxor (copy), lshift (copy)
    local AA = p30.AA;
    local BB = p30.BB;
    local MM = p30.MM;
    local RSL = p30.RSL;
    local v31 = bor(p30.CC + 1, 0);
    local v32 = bor(BB + v31, 0);

    for i = 1, 256 do
        local v33 = MM[i];
        local v34 = band(i, 3);

        if v34 == 0 then
            AA = bxor(AA, (rshift(AA, 16)));
        elseif v34 == 1 then
            AA = bxor(AA, (lshift(AA, 13)));
        elseif v34 == 2 then
            AA = bxor(AA, (rshift(AA, 6)));
        elseif v34 == 3 then
            AA = bxor(AA, (lshift(AA, 2)));
        end;

        AA = bor(MM[band(i + 127, 255) + 1] + AA, 0);
        local v35 = bor(MM[band(rshift(v33, 2), 255) + 1] + AA + v32, 0);
        MM[i] = v35;
        v32 = bor(MM[band(rshift(v35, 10), 255) + 1] + v33, 0);
        RSL[i] = v32;
    end;

    p30.AA = AA;
    p30.BB = v32;
    p30.CC = v31;
end;

local function IsaacInit(p36, p37) -- Line: 115
    -- upvalues: create (copy), IsaacMix (copy), bor (copy)
    p36.AA = 0;
    p36.BB = 0;
    p36.CC = 0;
    p36.Count = 256;
    local MM = p36.MM;
    local RSL = p36.RSL;
    local v38 = create(8, 2654435769);
    IsaacMix(v38);
    IsaacMix(v38);
    IsaacMix(v38);
    IsaacMix(v38);

    for i = 0, 255, 8 do
        if p37 then
            for i2 = 1, 8 do
                v38[i2] = bor(v38[i2] + RSL[i + i2], 0);
            end;
        end;

        IsaacMix(v38);
        MM[i + 1] = v38[1];
        MM[i + 2] = v38[2];
        MM[i + 3] = v38[3];
        MM[i + 4] = v38[4];
        MM[i + 5] = v38[5];
        MM[i + 6] = v38[6];
        MM[i + 7] = v38[7];
        MM[i + 8] = v38[8];
    end;

    if p37 then
        for i = 0, 255, 8 do
            for i2 = 1, 8 do
                v38[i2] = bor(v38[i2] + MM[i + i2], 0);
            end;

            IsaacMix(v38);
            MM[i + 1] = v38[1];
            MM[i + 2] = v38[2];
            MM[i + 3] = v38[3];
            MM[i + 4] = v38[4];
            MM[i + 5] = v38[5];
            MM[i + 6] = v38[6];
            MM[i + 7] = v38[7];
            MM[i + 8] = v38[8];
        end;
    end;
end;

local function Seed(p39, p40, p41) -- Line: 229
    -- upvalues: u1 (copy), bor (copy), IsaacInit (copy)
    if p40 == nil then
        p40 = { u1:NextInteger(0, 4294967295) };
    elseif type(p40) == "number" then
        p40 = { p40 };
    else
        local v42 = type(p40) == "table";
        assert(v42);
    end;

    if p41 == nil then
        p41 = true;
    else
        local v43 = type(p41) == "boolean";
        assert(v43);
    end;

    local v44 = math.min(256, #p40);
    local MM = p39.MM;
    local RSL = p39.RSL;

    for i = 1, 256 do
        MM[i] = 0;
        RSL[i] = 0;
    end;

    for i = 1, v44 do
        RSL[i] = bor(p40[i], 0);
    end;

    IsaacInit(p39, p41);
end;

local v124 = table.freeze({
    NextU32 = function(p45) -- Line: 152, Name: NextU32
        -- upvalues: Isaac (copy)
        local v46 = p45.Count + 1;

        if v46 > 256 then
            Isaac(p45);
            v46 = 1;
        end;

        p45.Count = v46;

        return p45.RSL[v46];
    end,

    NextU64 = function(p47) -- Line: 162, Name: NextU64
        -- upvalues: Isaac (copy), ldexp (copy)
        local v48 = p47.Count + 1;

        if v48 > 256 then
            Isaac(p47);
            v48 = 1;
        end;

        p47.Count = v48;
        local v49 = ldexp(p47.RSL[v48], 32);
        local v50 = p47.Count + 1;

        if v50 > 256 then
            Isaac(p47);
            v50 = 1;
        end;

        p47.Count = v50;

        return v49 + p47.RSL[v50];
    end,

    NextFloat = function(p51) -- Line: 166, Name: NextFloat
        -- upvalues: Isaac (copy), ldexp (copy)
        local v52 = p51.Count + 1;

        if v52 > 256 then
            Isaac(p51);
            v52 = 1;
        end;

        p51.Count = v52;

        return ldexp(p51.RSL[v52], -32);
    end,

    NextDouble = function(p53) -- Line: 170, Name: NextDouble
        -- upvalues: Isaac (copy), ldexp (copy)
        local v54 = p53.Count + 1;

        if v54 > 256 then
            Isaac(p53);
            v54 = 1;
        end;

        p53.Count = v54;
        local v55 = ldexp(p53.RSL[v54], 32);
        local v56 = p53.Count + 1;

        if v56 > 256 then
            Isaac(p53);
            v56 = 1;
        end;

        p53.Count = v56;

        return ldexp(v55 + p53.RSL[v56], -64);
    end,

    NextNumber = function(p57, p58, p59) -- Line: 174, Name: NextNumber
        -- upvalues: Isaac (copy), ldexp (copy)
        local v60 = p57.Count + 1;

        if v60 > 256 then
            Isaac(p57);
            v60 = 1;
        end;

        p57.Count = v60;
        local v61 = ldexp(p57.RSL[v60], 32);
        local v62 = p57.Count + 1;

        if v62 > 256 then
            Isaac(p57);
            v62 = 1;
        end;

        p57.Count = v62;

        return p58 + (p59 - p58) * ldexp(v61 + p57.RSL[v62], -64);
    end,

    NextInteger = function(p63, p64, p65) -- Line: 178, Name: NextInteger
        -- upvalues: Isaac (copy), ldexp (copy), floor (copy)
        local v66 = p63.Count + 1;

        if v66 > 256 then
            Isaac(p63);
            v66 = 1;
        end;

        p63.Count = v66;
        local v67 = ldexp(p63.RSL[v66], 32);
        local v68 = p63.Count + 1;

        if v68 > 256 then
            Isaac(p63);
            v68 = 1;
        end;

        p63.Count = v68;

        return floor(p64 + (p65 - p64 + 1) * ldexp(v67 + p63.RSL[v68], -64));
    end,

    NextNormal = function(p69, p70, p71) -- Line: 182, Name: NextNormal
        -- upvalues: Isaac (copy), ldexp (copy), max (copy), log (copy), sqrt (copy), cos (copy), sin (copy)
        local v72 = p69.Count + 1;

        if v72 > 256 then
            Isaac(p69);
            v72 = 1;
        end;

        p69.Count = v72;
        local v73 = ldexp(p69.RSL[v72], 32);
        local v74 = p69.Count + 1;

        if v74 > 256 then
            Isaac(p69);
            v74 = 1;
        end;

        p69.Count = v74;
        local v75 = sqrt(log((max(2.2250738585072014e-308, (ldexp(v73 + p69.RSL[v74], -64))))) * -2) * (p71 or 0);
        local v76 = p69.Count + 1;

        if v76 > 256 then
            Isaac(p69);
            v76 = 1;
        end;

        p69.Count = v76;
        local v77 = ldexp(p69.RSL[v76], 32);
        local v78 = p69.Count + 1;

        if v78 > 256 then
            Isaac(p69);
            v78 = 1;
        end;

        p69.Count = v78;
        local v79 = 6.283185307179586 * ldexp(v77 + p69.RSL[v78], -64);
        local v80 = p70 or 0;

        return cos(v79) * v75 + v80, sin(v79) * v75 + v80;
    end,

    NextBoolean = function(p81, p82) -- Line: 194, Name: NextBoolean
        -- upvalues: Isaac (copy), ldexp (copy)
        local v83 = p81.Count + 1;

        if v83 > 256 then
            Isaac(p81);
            v83 = 1;
        end;

        p81.Count = v83;
        local v84 = ldexp(p81.RSL[v83], 32);
        local v85 = p81.Count + 1;

        if v85 > 256 then
            Isaac(p81);
            v85 = 1;
        end;

        p81.Count = v85;

        return ldexp(v84 + p81.RSL[v85], -64) < (p82 or 0.5);
    end,

    NextVector2 = function(p86, p87) -- Line: 198, Name: NextVector2
        -- upvalues: Isaac (copy), ldexp (copy), new (copy), cos (copy), sin (copy)
        local v88 = p87 or 1;
        local v89 = p86.Count + 1;

        if v89 > 256 then
            Isaac(p86);
            v89 = 1;
        end;

        p86.Count = v89;
        local v90 = ldexp(p86.RSL[v89], 32);
        local v91 = p86.Count + 1;

        if v91 > 256 then
            Isaac(p86);
            v91 = 1;
        end;

        p86.Count = v91;
        local v92 = 6.283185307179586 * ldexp(v90 + p86.RSL[v91], -64);

        return new(cos(v92) * v88, sin(v92) * v88);
    end,

    NextVector3 = function(p93, p94) -- Line: 207, Name: NextVector3
        -- upvalues: Isaac (copy), ldexp (copy), sqrt (copy), cos (copy), sin (copy), new2 (copy)
        local v95 = p94 or 1;
        local v96 = p93.Count + 1;

        if v96 > 256 then
            Isaac(p93);
            v96 = 1;
        end;

        p93.Count = v96;
        local v97 = ldexp(p93.RSL[v96], 32);
        local v98 = p93.Count + 1;

        if v98 > 256 then
            Isaac(p93);
            v98 = 1;
        end;

        p93.Count = v98;
        local v99 = 6.283185307179586 * ldexp(v97 + p93.RSL[v98], -64);
        local v100 = p93.Count + 1;

        if v100 > 256 then
            Isaac(p93);
            v100 = 1;
        end;

        p93.Count = v100;
        local v101 = ldexp(p93.RSL[v100], 32);
        local v102 = p93.Count + 1;

        if v102 > 256 then
            Isaac(p93);
            v102 = 1;
        end;

        p93.Count = v102;
        local v103 = ldexp(v101 + p93.RSL[v102], -64) * 2 - 1;
        local v104 = sqrt(1 - v103 * v103);

        return new2(cos(v99) * v104 * v95, sin(v99) * v104 * v95, v103 * v95);
    end,

    NextUUIDv4 = function(p105) -- Line: 219, Name: NextUUIDv4
        -- upvalues: format (copy), Isaac (copy), band (copy), bor (copy)
        local v106 = p105.Count + 1;

        if v106 > 256 then
            Isaac(p105);
            v106 = 1;
        end;

        p105.Count = v106;
        local v107 = p105.RSL[v106];
        local v108 = p105.Count + 1;

        if v108 > 256 then
            Isaac(p105);
            v108 = 1;
        end;

        p105.Count = v108;
        local v109 = bor(band(p105.RSL[v108], 4294905855), 16384);
        local v110 = p105.Count + 1;

        if v110 > 256 then
            Isaac(p105);
            v110 = 1;
        end;

        p105.Count = v110;
        local v111 = bor(band(p105.RSL[v110], 1073741823), 2147483648);
        local v112 = p105.Count + 1;

        if v112 > 256 then
            Isaac(p105);
            v112 = 1;
        end;

        p105.Count = v112;

        return format("%08x%08x%08x%08x", v107, v109, v111, p105.RSL[v112]);
    end,

    Seed = Seed,

    Shuffle = function(p113, p114) -- Line: 260, Name: Shuffle
        -- upvalues: Isaac (copy), ldexp (copy), floor (copy)
        local v115 = type(p114) == "table";
        assert(v115);

        for i = #p114, 2, -1 do
            local v116 = p113.Count + 1;

            if v116 > 256 then
                Isaac(p113);
                v116 = 1;
            end;

            p113.Count = v116;
            local v117 = ldexp(p113.RSL[v116], 32);
            local v118 = p113.Count + 1;

            if v118 > 256 then
                Isaac(p113);
                v118 = 1;
            end;

            p113.Count = v118;
            local v119 = floor((i - 1 + 1) * ldexp(v117 + p113.RSL[v118], -64) + 1);
            local v120 = p114[i];
            p114[i] = p114[v119];
            p114[v119] = v120;
        end;
    end,

    Clone = function(p121) -- Line: 268, Name: Clone
        -- upvalues: clone (copy)
        local v122 = {
            RSL = clone(p121.RSL),
            Count = p121.Count,
            MM = clone(p121.MM),
            AA = p121.AA,
            BB = p121.BB,
            CC = p121.CC
        };
        local v123 = getmetatable(p121);

        return setmetatable(v122, v123);
    end
});
local u125 = table.freeze({
    __index = v124
});
local u129 = {
    new = function(p126, p127) -- Line: 300, Name: new
        -- upvalues: create (copy), Seed (copy), u125 (copy)
        local v128 = {
            Count = 0,
            AA = 0,
            BB = 0,
            CC = 0,
            RSL = create(256, 0),
            MM = create(256, 0)
        };
        Seed(v128, p126, p127);

        return setmetatable(v128, u125);
    end
};

function u129.Unique(p130) -- Line: 316
    -- upvalues: floor (copy), clamp (copy), u129 (copy), GenerateSeed (copy)
    if p130 ~= nil then
        local v131;

        if type(p130) == "number" and (floor(p130) == p130 and p130 ~= (1 / 0)) then
            v131 = p130 ~= (-1 / 0);
        else
            v131 = false;
        end;

        if not v131 then
            error("Integer", 2);
        end;

        if p130 < 0 then
            error("NonNegative", 2);
        end;
    end;

    local v132 = clamp(p130 or 32, 0, 256);

    return u129.new(GenerateSeed(v132), true);
end;

u129.R = u129.Unique();

return table.freeze(u129);