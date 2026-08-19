-- Decompiled with Potassium's decompiler.

local EncodingService = game:GetService("EncodingService");
local u1 = newproxy(false);
local u2 = {};

function u2.new(p3, p4) -- Line: 22
    -- upvalues: u2 (copy)
    return {
        _msgpackType = u2,
        type = p3,
        data = p4
    };
end;

table.freeze(u2);
local u5 = {};

function u5.new(p6, p7) -- Line: 38
    -- upvalues: u5 (copy)
    return {
        _msgpackType = u5,
        mostSignificantPart = p6,
        leastSignificantPart = p7
    };
end;

table.freeze(u5);
local u8 = {};

function u8.new(p9, p10) -- Line: 54
    -- upvalues: u8 (copy)
    return {
        _msgpackType = u8,
        mostSignificantPart = p9,
        leastSignificantPart = p10
    };
end;

table.freeze(u8);

local function byteswap16(p11) -- Line: 64
    local v12 = bit32.band(p11, 65535);
    local v13 = bit32.rshift(v12, 8);
    local v14 = bit32.lshift(v12, 8);
    local v15 = bit32.band(v14, 65535);

    return bit32.bor(v13, v15);
end;

local function writeu16be(p16, p17, p18) -- Line: 69
    local v19 = bit32.band(p18, 65535);
    local v20 = bit32.rshift(v19, 8);
    local v21 = bit32.lshift(v19, 8);
    local v22 = bit32.band(v21, 65535);
    local v23 = bit32.bor(v20, v22);
    buffer.writeu16(p16, p17, v23);
end;

local function writei16be(p24, p25, p26) -- Line: 73
    local v27 = bit32.band(p26, 65535);
    local v28 = bit32.rshift(v27, 8);
    local v29 = bit32.lshift(v27, 8);
    local v30 = bit32.band(v29, 65535);
    local v31 = bit32.bor(v28, v30);
    buffer.writeu16(p24, p25, v31);
end;

local function writeu32be(p32, p33, p34) -- Line: 77
    local v35 = bit32.byteswap(p34);
    buffer.writeu32(p32, p33, v35);
end;

local function writei32be(p36, p37, p38) -- Line: 81
    local v39 = bit32.byteswap(p38);
    buffer.writeu32(p36, p37, v39);
end;

local function _writef32be(p40, p41, p42) -- Line: 86
    buffer.writef32(p40, p41, p42);
    local v43 = buffer.readu32(p40, p41);
    local v44 = bit32.byteswap(v43);
    buffer.writeu32(p40, p41, v44);
end;

local function writef64be(p45, p46, p47) -- Line: 91
    buffer.writef64(p45, p46, p47);
    local v48 = buffer.readu32(p45, p46);
    local v49 = bit32.byteswap(v48);
    local v50 = buffer.readu32(p45, p46 + 4);
    local v51 = bit32.byteswap(v50);
    buffer.writeu32(p45, p46, v51);
    buffer.writeu32(p45, p46 + 4, v49);
end;

local function readu16be(p52, p53) -- Line: 99
    local v54 = buffer.readu16(p52, p53);
    local v55 = bit32.band(v54, 65535);
    local v56 = bit32.rshift(v55, 8);
    local v57 = bit32.lshift(v55, 8);
    local v58 = bit32.band(v57, 65535);

    return bit32.bor(v56, v58);
end;

local function readi16be(p59, p60) -- Line: 103
    local v61 = buffer.readu16(p59, p60);
    local v62 = bit32.band(v61, 65535);
    local v63 = bit32.rshift(v62, 8);
    local v64 = bit32.lshift(v62, 8);
    local v65 = bit32.band(v64, 65535);
    local v66 = bit32.bor(v63, v65);

    if v66 >= 32768 then
        return v66 - 65536;
    end;

    return v66;
end;

local function readu32be(p67, p68) -- Line: 111
    local v69 = buffer.readu32(p67, p68);

    return bit32.byteswap(v69);
end;

local function readi32be(p70, p71) -- Line: 115
    local v72 = buffer.readu32(p70, p71);
    local v73 = bit32.byteswap(v72);

    if v73 >= 2147483648 then
        return v73 - 4294967296;
    end;

    return v73;
end;

local function readf32be(p74, p75) -- Line: 123
    local v76 = buffer.readu32(p74, p75);
    local v77 = bit32.byteswap(v76);
    buffer.writeu32(p74, p75, v77);

    return buffer.readf32(p74, p75);
end;

local function readf64be(p78, p79) -- Line: 128
    local v80 = buffer.readu32(p78, p79);
    local v81 = bit32.byteswap(v80);
    local v82 = buffer.readu32(p78, p79 + 4);
    local v83 = bit32.byteswap(v82);
    buffer.writeu32(p78, p79, v83);
    buffer.writeu32(p78, p79 + 4, v81);

    return buffer.readf64(p78, p79);
end;

local function parse(p84, p85) -- Line: 138
    -- upvalues: u1 (copy), u2 (copy), parse (copy)
    local v86 = buffer.readu8(p84, p85);

    if v86 == 192 then
        return u1, p85 + 1;
    end;

    if v86 == 194 then
        return false, p85 + 1;
    end;

    if v86 == 195 then
        return true, p85 + 1;
    end;

    if v86 == 196 then
        local v87 = buffer.readu8(p84, p85 + 1);
        local v88 = buffer.create(v87);
        buffer.copy(v88, 0, p84, p85 + 2, v87);

        return v88, p85 + 2 + v87;
    end;

    if v86 == 197 then
        local v89 = buffer.readu16(p84, p85 + 1);
        local v90 = bit32.band(v89, 65535);
        local v91 = bit32.rshift(v90, 8);
        local v92 = bit32.lshift(v90, 8);
        local v93 = bit32.band(v92, 65535);
        local v94 = bit32.bor(v91, v93);
        local v95 = buffer.create(v94);
        buffer.copy(v95, 0, p84, p85 + 3, v94);

        return v95, p85 + 3 + v94;
    end;

    if v86 == 198 then
        local v96 = buffer.readu32(p84, p85 + 1);
        local v97 = bit32.byteswap(v96);
        local v98 = buffer.create(v97);
        buffer.copy(v98, 0, p84, p85 + 5, v97);

        return v98, p85 + 5 + v97;
    end;

    if v86 == 199 then
        local v99 = buffer.readu8(p84, p85 + 1);
        local v100 = buffer.create(v99);
        buffer.copy(v100, 0, p84, p85 + 3, v99);

        return {
            _msgpackType = u2,
            type = buffer.readu8(p84, p85 + 2),
            data = v100
        }, p85 + 3 + v99;
    end;

    if v86 == 200 then
        local v101 = buffer.readu16(p84, p85 + 1);
        local v102 = bit32.band(v101, 65535);
        local v103 = bit32.rshift(v102, 8);
        local v104 = bit32.lshift(v102, 8);
        local v105 = bit32.band(v104, 65535);
        local v106 = bit32.bor(v103, v105);
        local v107 = buffer.create(v106);
        buffer.copy(v107, 0, p84, p85 + 4, v106);

        return {
            _msgpackType = u2,
            type = buffer.readu8(p84, p85 + 3),
            data = v107
        }, p85 + 4 + v106;
    end;

    if v86 == 201 then
        local v108 = buffer.readu32(p84, p85 + 1);
        local v109 = bit32.byteswap(v108);
        local v110 = buffer.create(v109);
        buffer.copy(v110, 0, p84, p85 + 6, v109);

        return {
            _msgpackType = u2,
            type = buffer.readu8(p84, p85 + 5),
            data = v110
        }, p85 + 6 + v109;
    end;

    if v86 == 202 then
        local v111 = p85 + 1;
        local v112 = buffer.readu32(p84, v111);
        local v113 = bit32.byteswap(v112);
        buffer.writeu32(p84, v111, v113);

        return buffer.readf32(p84, v111), p85 + 5;
    end;

    if v86 == 203 then
        local v114 = p85 + 1;
        local v115 = buffer.readu32(p84, v114);
        local v116 = bit32.byteswap(v115);
        local v117 = buffer.readu32(p84, v114 + 4);
        local v118 = bit32.byteswap(v117);
        buffer.writeu32(p84, v114, v118);
        buffer.writeu32(p84, v114 + 4, v116);

        return buffer.readf64(p84, v114), p85 + 9;
    end;

    if v86 == 204 then
        return buffer.readu8(p84, p85 + 1), p85 + 2;
    end;

    if v86 == 205 then
        local v119 = buffer.readu16(p84, p85 + 1);
        local v120 = bit32.band(v119, 65535);
        local v121 = bit32.rshift(v120, 8);
        local v122 = bit32.lshift(v120, 8);
        local v123 = bit32.band(v122, 65535);

        return bit32.bor(v121, v123), p85 + 3;
    end;

    if v86 == 206 then
        local v124 = buffer.readu32(p84, p85 + 1);

        return bit32.byteswap(v124), p85 + 5;
    end;

    if v86 == 207 then
        local v125 = buffer.readu32(p84, p85 + 1);
        local v126 = bit32.byteswap(v125);
        local v127 = buffer.readu32(p84, p85 + 5);
        local v128 = bit32.byteswap(v127);

        return v126 * 4294967296 + v128, p85 + 9;
    end;

    if v86 == 208 then
        return buffer.readi8(p84, p85 + 1), p85 + 2;
    end;

    if v86 == 209 then
        local v129 = buffer.readu16(p84, p85 + 1);
        local v130 = bit32.band(v129, 65535);
        local v131 = bit32.rshift(v130, 8);
        local v132 = bit32.lshift(v130, 8);
        local v133 = bit32.band(v132, 65535);
        local v134 = bit32.bor(v131, v133);

        if v134 >= 32768 then
            v134 = v134 - 65536;
        end;

        return v134, p85 + 3;
    end;

    if v86 == 210 then
        local v135 = buffer.readu32(p84, p85 + 1);
        local v136 = bit32.byteswap(v135);

        if v136 >= 2147483648 then
            v136 = v136 - 4294967296;
        end;

        return v136, p85 + 5;
    end;

    if v86 == 211 then
        local v137 = buffer.readu32(p84, p85 + 1);
        local v138 = bit32.byteswap(v137);
        local v139 = buffer.readu32(p84, p85 + 5);
        local v140 = bit32.byteswap(v139);

        if v138 >= 2147483648 then
            return (v138 - 4294967296) * 4294967296 + v140, p85 + 9;
        end;

        return v138 * 4294967296 + v140, p85 + 9;
    end;

    if v86 == 212 then
        local v141 = buffer.create(1);
        buffer.copy(v141, 0, p84, p85 + 2, 1);

        return {
            _msgpackType = u2,
            type = buffer.readu8(p84, p85 + 1),
            data = v141
        }, p85 + 3;
    end;

    if v86 == 213 then
        local v142 = buffer.create(2);
        buffer.copy(v142, 0, p84, p85 + 2, 2);

        return {
            _msgpackType = u2,
            type = buffer.readu8(p84, p85 + 1),
            data = v142
        }, p85 + 4;
    end;

    if v86 == 214 then
        local v143 = buffer.create(4);
        buffer.copy(v143, 0, p84, p85 + 2, 4);

        return {
            _msgpackType = u2,
            type = buffer.readu8(p84, p85 + 1),
            data = v143
        }, p85 + 6;
    end;

    if v86 == 215 then
        local v144 = buffer.create(8);
        buffer.copy(v144, 0, p84, p85 + 2, 8);

        return {
            _msgpackType = u2,
            type = buffer.readu8(p84, p85 + 1),
            data = v144
        }, p85 + 10;
    end;

    if v86 == 216 then
        local v145 = buffer.create(16);
        buffer.copy(v145, 0, p84, p85 + 2, 16);

        return {
            _msgpackType = u2,
            type = buffer.readu8(p84, p85 + 1),
            data = v145
        }, p85 + 18;
    end;

    if v86 == 217 then
        local v146 = buffer.readu8(p84, p85 + 1);

        return buffer.readstring(p84, p85 + 2, v146), p85 + 2 + v146;
    end;

    if v86 == 218 then
        local v147 = buffer.readu16(p84, p85 + 1);
        local v148 = bit32.band(v147, 65535);
        local v149 = bit32.rshift(v148, 8);
        local v150 = bit32.lshift(v148, 8);
        local v151 = bit32.band(v150, 65535);
        local v152 = bit32.bor(v149, v151);

        return buffer.readstring(p84, p85 + 3, v152), p85 + 3 + v152;
    end;

    if v86 == 219 then
        local v153 = buffer.readu32(p84, p85 + 1);
        local v154 = bit32.byteswap(v153);

        return buffer.readstring(p84, p85 + 5, v154), p85 + 5 + v154;
    end;

    if v86 == 220 then
        local v155 = buffer.readu16(p84, p85 + 1);
        local v156 = bit32.band(v155, 65535);
        local v157 = bit32.rshift(v156, 8);
        local v158 = bit32.lshift(v156, 8);
        local v159 = bit32.band(v158, 65535);
        local v160 = bit32.bor(v157, v159);
        local v161 = table.create(v160);
        local v162 = p85 + 3;

        for i = 1, v160 do
            local v163;
            v163, v162 = parse(p84, v162);
            v161[i] = v163;
        end;

        return v161, v162;
    end;

    if v86 == 221 then
        local v164 = buffer.readu32(p84, p85 + 1);
        local v165 = bit32.byteswap(v164);
        local v166 = table.create(v165);
        local v167 = p85 + 5;

        for i = 1, v165 do
            local v168;
            v168, v167 = parse(p84, v167);
            v166[i] = v168;
        end;

        return v166, v167;
    end;

    if v86 == 222 then
        local v169 = buffer.readu16(p84, p85 + 1);
        local v170 = bit32.band(v169, 65535);
        local v171 = bit32.rshift(v170, 8);
        local v172 = bit32.lshift(v170, 8);
        local v173 = bit32.band(v172, 65535);
        local v174 = bit32.bor(v171, v173);
        local v175 = p85 + 3;
        local v176 = {};

        for _ = 1, v174 do
            local v177, v178 = parse(p84, v175);
            local v179;
            v179, v175 = parse(p84, v178);
            v176[v177] = v179;
        end;

        return v176, v175;
    end;

    if v86 == 223 then
        local v180 = buffer.readu32(p84, p85 + 1);
        local v181 = bit32.byteswap(v180);
        local v182 = p85 + 5;
        local v183 = {};

        for _ = 1, v181 do
            local v184, v185 = parse(p84, v182);
            local v186;
            v186, v182 = parse(p84, v185);
            v183[v184] = v186;
        end;

        return v183, v182;
    end;

    if v86 >= 224 then
        return v86 - 256, p85 + 1;
    end;

    if v86 <= 127 then
        return v86, p85 + 1;
    end;

    if v86 - 128 <= 15 then
        local v187 = bit32.band(v86, 15);
        local v188 = p85 + 1;
        local v189 = {};

        for _ = 1, v187 do
            local v190, v191 = parse(p84, v188);
            local v192;
            v192, v188 = parse(p84, v191);
            v189[v190] = v192;
        end;

        return v189, v188;
    end;

    if v86 - 144 <= 15 then
        local v193 = bit32.band(v86, 15);
        local v194 = table.create(v193);
        local v195 = p85 + 1;

        for i = 1, v193 do
            local v196;
            v196, v195 = parse(p84, v195);
            v194[i] = v196;
        end;

        return v194, v195;
    end;

    if v86 - 160 <= 31 then
        local v197 = v86 - 160;

        return buffer.readstring(p84, p85 + 1, v197), p85 + 1 + v197;
    end;

    error("Unknown type");
end;

local function inflate(p198, p199) -- Line: 303
    local v200 = buffer.len(p198);

    if p199 <= v200 then
        return p198;
    end;

    while v200 < p199 do
        v200 = v200 * 2;
    end;

    local v201 = buffer.create(v200);
    buffer.copy(v201, 0, p198);

    return v201;
end;

local u202 = {
    [1] = 212,
    [2] = 213,
    [4] = 214,
    [8] = 215,
    [16] = 216
};

local function encode(p203, p204, p205, p206) -- Line: 324
    -- upvalues: u1 (copy), inflate (copy), u5 (copy), u8 (copy), u2 (copy), u202 (copy), encode (copy)
    if p205 == u1 then
        p205 = nil;
    end;

    local v207 = type(p205);

    if p205 == nil then
        local v208 = inflate(p203, p204 + 1);
        buffer.writestring(v208, p204, "\192");

        return v208, p204 + 1;
    end;

    if p205 == false then
        local v209 = inflate(p203, p204 + 1);
        buffer.writestring(v209, p204, "\194");

        return v209, p204 + 1;
    end;

    if p205 == true then
        local v210 = inflate(p203, p204 + 1);
        buffer.writestring(v210, p204, "\195");

        return v210, p204 + 1;
    end;

    if v207 == "string" then
        local v211 = #p205;

        if v211 <= 31 then
            local v212 = inflate(p203, p204 + 1 + v211);
            local v213 = bit32.bor(160, v211);
            buffer.writeu8(v212, p204, v213);
            buffer.writestring(v212, p204 + 1, p205);

            return v212, p204 + 1 + v211;
        end;

        if v211 <= 255 then
            local v214 = inflate(p203, p204 + 2 + v211);
            buffer.writeu8(v214, p204, 217);
            buffer.writeu8(v214, p204 + 1, v211);
            buffer.writestring(v214, p204 + 2, p205);

            return v214, p204 + 2 + v211;
        end;

        if v211 <= 65535 then
            local v215 = inflate(p203, p204 + 3 + v211);
            buffer.writeu8(v215, p204, 218);
            local v216 = bit32.band(v211, 65535);
            local v217 = bit32.rshift(v216, 8);
            local v218 = bit32.lshift(v216, 8);
            local v219 = bit32.band(v218, 65535);
            local v220 = bit32.bor(v217, v219);
            buffer.writeu16(v215, p204 + 1, v220);
            buffer.writestring(v215, p204 + 3, p205);

            return v215, p204 + 3 + v211;
        end;

        if v211 <= 4294967295 then
            local v221 = inflate(p203, p204 + 5 + v211);
            buffer.writeu8(v221, p204, 219);
            local v222 = bit32.byteswap(v211);
            buffer.writeu32(v221, p204 + 1, v222);
            buffer.writestring(v221, p204 + 5, p205);

            return v221, p204 + 5 + v211;
        end;

        error("Could not encode - too long string");
    elseif v207 == "buffer" then
        local v223 = buffer.len(p205);

        if v223 <= 255 then
            local v224 = inflate(p203, p204 + 2 + v223);
            buffer.writeu8(v224, p204, 196);
            buffer.writeu8(v224, p204 + 1, v223);
            buffer.copy(v224, p204 + 2, p205);

            return v224, p204 + 2 + v223;
        end;

        if v223 <= 65535 then
            local v225 = inflate(p203, p204 + 3 + v223);
            buffer.writeu8(v225, p204, 197);
            local v226 = bit32.band(v223, 65535);
            local v227 = bit32.rshift(v226, 8);
            local v228 = bit32.lshift(v226, 8);
            local v229 = bit32.band(v228, 65535);
            local v230 = bit32.bor(v227, v229);
            buffer.writeu16(v225, p204 + 1, v230);
            buffer.copy(v225, p204 + 3, p205);

            return v225, p204 + 3 + v223;
        end;

        if v223 <= 4294967295 then
            local v231 = inflate(p203, p204 + 5 + v223);
            buffer.writeu8(v231, p204, 198);
            local v232 = bit32.byteswap(v223);
            buffer.writeu32(v231, p204 + 1, v232);
            buffer.copy(v231, p204 + 5, p205);

            return v231, p204 + 5 + v223;
        end;

        error("Could not encode - too long binary buffer");
    elseif v207 == "number" then
        if p205 == 0 then
            local v233 = inflate(p203, p204 + 1);
            buffer.writeu8(v233, p204, 0);

            return v233, p204 + 1;
        end;

        if p205 ~= p205 then
            local v234 = inflate(p203, p204 + 5);
            buffer.writestring(v234, p204, "\202\127\128\0\1");

            return v234, p204 + 5;
        end;

        if p205 == (1 / 0) then
            local v235 = inflate(p203, p204 + 5);
            buffer.writestring(v235, p204, "\202\127\128\0\0");

            return v235, p204 + 5;
        end;

        if p205 == (-1 / 0) then
            local v236 = inflate(p203, p204 + 5);
            buffer.writestring(v236, p204, "\202\255\128\0\0");

            return v236, p204 + 5;
        end;

        local v237, v238 = math.modf(p205);
        local v239 = math.sign(p205);

        if v238 ~= 0 or (v237 > 4294967295 or v237 < -2147483648) then
            local v240 = inflate(p203, p204 + 9);
            buffer.writeu8(v240, p204, 203);
            local v241 = p204 + 1;
            buffer.writef64(v240, v241, p205);
            local v242 = buffer.readu32(v240, v241);
            local v243 = bit32.byteswap(v242);
            local v244 = buffer.readu32(v240, v241 + 4);
            local v245 = bit32.byteswap(v244);
            buffer.writeu32(v240, v241, v245);
            buffer.writeu32(v240, v241 + 4, v243);

            return v240, p204 + 9;
        end;

        if v239 > 0 then
            if v237 <= 127 then
                local v246 = inflate(p203, p204 + 1);
                buffer.writeu8(v246, p204, v237);

                return v246, p204 + 1;
            end;

            if v237 <= 255 then
                local v247 = inflate(p203, p204 + 2);
                buffer.writeu8(v247, p204, 204);
                buffer.writeu8(v247, p204 + 1, v237);

                return v247, p204 + 2;
            end;

            if v237 <= 65535 then
                local v248 = inflate(p203, p204 + 3);
                buffer.writeu8(v248, p204, 205);
                local v249 = bit32.band(v237, 65535);
                local v250 = bit32.rshift(v249, 8);
                local v251 = bit32.lshift(v249, 8);
                local v252 = bit32.band(v251, 65535);
                local v253 = bit32.bor(v250, v252);
                buffer.writeu16(v248, p204 + 1, v253);

                return v248, p204 + 3;
            end;

            if v237 <= 4294967295 then
                local v254 = inflate(p203, p204 + 5);
                buffer.writeu8(v254, p204, 206);
                local v255 = bit32.byteswap(v237);
                buffer.writeu32(v254, p204 + 1, v255);

                return v254, p204 + 5;
            end;
        else
            if v237 >= -32 then
                local v256 = inflate(p203, p204 + 1);
                local v257 = bit32.extract(v237, 0, 5);
                local v258 = bit32.bor(224, v257);
                buffer.writeu8(v256, p204, v258);

                return v256, p204 + 1;
            end;

            if v237 >= -128 then
                local v259 = inflate(p203, p204 + 2);
                buffer.writeu8(v259, p204, 208);
                buffer.writei8(v259, p204 + 1, v237);

                return v259, p204 + 2;
            end;

            if v237 >= -32768 then
                local v260 = inflate(p203, p204 + 3);
                buffer.writeu8(v260, p204, 209);
                local v261 = bit32.band(v237, 65535);
                local v262 = bit32.rshift(v261, 8);
                local v263 = bit32.lshift(v261, 8);
                local v264 = bit32.band(v263, 65535);
                local v265 = bit32.bor(v262, v264);
                buffer.writeu16(v260, p204 + 1, v265);

                return v260, p204 + 3;
            end;

            if v237 >= -2147483648 then
                local v266 = inflate(p203, p204 + 5);
                buffer.writeu8(v266, p204, 210);
                local v267 = bit32.byteswap(v237);
                buffer.writeu32(v266, p204 + 1, v267);

                return v266, p204 + 5;
            end;
        end;

        error(string.format("Could not encode - unhandled number \"%s\"", (typeof(p205))));
    elseif v207 == "table" then
        local _msgpackType = p205._msgpackType;

        if _msgpackType then
            if _msgpackType == u5 or _msgpackType == u8 then
                local v268 = inflate(p203, p204 + 9);
                buffer.writeu8(v268, p204, _msgpackType == u8 and 207 or 211);
                local v269 = bit32.byteswap(p205.mostSignificantPart);
                buffer.writeu32(v268, p204 + 1, v269);
                local v270 = bit32.byteswap(p205.leastSignificantPart);
                buffer.writeu32(v268, p204 + 5, v270);

                return v268, p204 + 9;
            end;

            if _msgpackType == u2 then
                local v271 = buffer.len(p205.data);
                local v272 = u202[v271];

                if v272 then
                    local v273 = inflate(p203, p204 + 2 + v271);
                    buffer.writeu8(v273, p204, v272);
                    buffer.writeu8(v273, p204 + 1, p205.type);
                    buffer.copy(v273, p204 + 2, p205.data);

                    return v273, p204 + 2 + v271;
                end;

                if v271 <= 255 then
                    local v274 = inflate(p203, p204 + 3 + v271);
                    buffer.writeu8(v274, p204, 199);
                    buffer.writeu8(v274, p204 + 1, v271);
                    buffer.writeu8(v274, p204 + 2, p205.type);
                    buffer.copy(v274, p204 + 3, p205.data);

                    return v274, p204 + 3 + v271;
                end;

                if v271 <= 65535 then
                    local v275 = inflate(p203, p204 + 4 + v271);
                    buffer.writeu8(v275, p204, 200);
                    local v276 = bit32.band(v271, 65535);
                    local v277 = bit32.rshift(v276, 8);
                    local v278 = bit32.lshift(v276, 8);
                    local v279 = bit32.band(v278, 65535);
                    local v280 = bit32.bor(v277, v279);
                    buffer.writeu16(v275, p204 + 1, v280);
                    buffer.writeu8(v275, p204 + 3, p205.type);
                    buffer.copy(v275, p204 + 4, p205.data);

                    return v275, p204 + 4 + v271;
                end;

                if v271 <= 4294967295 then
                    local v281 = inflate(p203, p204 + 6 + v271);
                    buffer.writeu8(v281, p204, 201);
                    local v282 = bit32.byteswap(v271);
                    buffer.writeu32(v281, p204 + 1, v282);
                    buffer.writeu8(v281, p204 + 5, p205.type);
                    buffer.copy(v281, p204 + 6, p205.data);

                    return v281, p204 + 6 + v271;
                end;

                error("Could not encode - too long extension data");
            end;
        end;

        if p206[p205] then
            error("Can not serialize cyclic table");
        else
            p206[p205] = true;
        end;

        local v283 = #p205;
        local v284 = 0;

        for _, _ in pairs(p205) do
            v284 = v284 + 1;
        end;

        if v283 == v284 then
            if v283 <= 15 then
                p203 = inflate(p203, p204 + 1);
                local v285 = bit32.bor(144, v284);
                buffer.writeu8(p203, p204, v285);
                p204 = p204 + 1;
            elseif v283 <= 65535 then
                p203 = inflate(p203, p204 + 3);
                buffer.writeu8(p203, p204, 220);
                local v286 = bit32.band(v283, 65535);
                local v287 = bit32.rshift(v286, 8);
                local v288 = bit32.lshift(v286, 8);
                local v289 = bit32.band(v288, 65535);
                local v290 = bit32.bor(v287, v289);
                buffer.writeu16(p203, p204 + 1, v290);
                p204 = p204 + 3;
            elseif v283 <= 4294967295 then
                p203 = inflate(p203, p204 + 5);
                buffer.writeu8(p203, p204, 221);
                local v291 = bit32.byteswap(v283);
                buffer.writeu32(p203, p204 + 1, v291);
                p204 = p204 + 5;
            else
                error("Could not encode - too long array");
            end;

            for _, v in ipairs(p205) do
                p203, p204 = encode(p203, p204, v, p206);
            end;

            return p203, p204;
        end;

        if v284 <= 15 then
            p203 = inflate(p203, p204 + 1);
            local v292 = bit32.bor(128, v284);
            buffer.writeu8(p203, p204, v292);
            p204 = p204 + 1;
        elseif v284 <= 65535 then
            p203 = inflate(p203, p204 + 3);
            buffer.writeu8(p203, p204, 222);
            local v293 = bit32.band(v284, 65535);
            local v294 = bit32.rshift(v293, 8);
            local v295 = bit32.lshift(v293, 8);
            local v296 = bit32.band(v295, 65535);
            local v297 = bit32.bor(v294, v296);
            buffer.writeu16(p203, p204 + 1, v297);
            p204 = p204 + 3;
        elseif v284 <= 4294967295 then
            p203 = inflate(p203, p204 + 5);
            buffer.writeu8(p203, p204, 223);
            local v298 = bit32.byteswap(v284);
            buffer.writeu32(p203, p204 + 1, v298);
            p204 = p204 + 5;
        else
            error("Could not encode - too long map");
        end;

        for i, v in pairs(p205) do
            local v299, v300 = encode(p203, p204, i, p206);
            p203, p204 = encode(v299, v300, v, p206);
        end;

        return p203, p204;
    end;

    error(string.format("Could not encode - unsupported datatype \"%s\"", (typeof(p205))));
end;

local u301 = buffer.create(4096);

local function unpack64(p302) -- Line: 673
    if p302 >= 0 then
        return bit32.bor(p302 // 4294967296, 0), bit32.bor(p302, 0);
    end;

    local v303 = -1 - p302;

    return bit32.bnot(v303 // 4294967296), bit32.bnot(v303);
end;

return table.freeze({
    Null = u1,

    Coalesce = function(p304, p305) -- Line: 9, Name: Coalesce
        -- upvalues: u1 (copy)
        if p304 == u1 then
            return p305;
        end;

        return p304;
    end,

    Optional = function(p306) -- Line: 13, Name: Optional
        -- upvalues: u1 (copy)
        if p306 == nil then
            return u1;
        end;

        return p306;
    end,

    Int64 = u5,
    UInt64 = u8,
    Extension = u2,

    uint64 = function(p307) -- Line: 681, Name: uint64
        -- upvalues: u8 (copy)
        local v308, v309;

        if p307 < 0 then
            local v310 = -1 - p307;
            v308 = bit32.bnot(v310 // 4294967296);
            v309 = bit32.bnot(v310);
        else
            v308 = bit32.bor(p307 // 4294967296, 0);
            v309 = bit32.bor(p307, 0);
        end;

        return {
            _msgpackType = u8,
            mostSignificantPart = v308,
            leastSignificantPart = v309
        };
    end,

    int64 = function(p311) -- Line: 686, Name: int64
        -- upvalues: u5 (copy)
        local v312, v313;

        if p311 < 0 then
            local v314 = -1 - p311;
            v312 = bit32.bnot(v314 // 4294967296);
            v313 = bit32.bnot(v314);
        else
            v312 = bit32.bor(p311 // 4294967296, 0);
            v313 = bit32.bor(p311, 0);
        end;

        return {
            _msgpackType = u5,
            mostSignificantPart = v312,
            leastSignificantPart = v313
        };
    end,

    uint64optional = function(p315) -- Line: 691, Name: uint64optional
        -- upvalues: u8 (copy)
        if p315 == nil then
            return nil;
        end;

        local v316, v317;

        if p315 < 0 then
            local v318 = -1 - p315;
            v316 = bit32.bnot(v318 // 4294967296);
            v317 = bit32.bnot(v318);
        else
            v316 = bit32.bor(p315 // 4294967296, 0);
            v317 = bit32.bor(p315, 0);
        end;

        return {
            _msgpackType = u8,
            mostSignificantPart = v316,
            leastSignificantPart = v317
        };
    end,

    int64optional = function(p319) -- Line: 698, Name: int64optional
        -- upvalues: u5 (copy)
        if p319 == nil then
            return nil;
        end;

        local v320, v321;

        if p319 < 0 then
            local v322 = -1 - p319;
            v320 = bit32.bnot(v322 // 4294967296);
            v321 = bit32.bnot(v322);
        else
            v320 = bit32.bor(p319 // 4294967296, 0);
            v321 = bit32.bor(p319, 0);
        end;

        return {
            _msgpackType = u5,
            mostSignificantPart = v320,
            leastSignificantPart = v321
        };
    end,

    utf8Encode = function(p323) -- Line: 594, Name: utf8Encode
        local v324 = math.ceil(#p323 * 1.1428571428571428);
        local v325 = buffer.create(v324);
        local v326 = 0;

        for i = 1, v324 do
            local v327 = math.floor(v326 / 8) + 1;
            local v328 = v326 % 8;
            local v329 = string.byte(p323, v327);

            if v328 == 0 then
                local v330 = bit32.extract(v329, 1, 7);
                buffer.writeu8(v325, i - 1, v330);
            elseif v328 == 1 then
                local v331 = bit32.extract(v329, 0, 7);
                buffer.writeu8(v325, i - 1, v331);
            else
                local v332 = string.byte(p323, v327 + 1) or 0;
                local v333 = bit32.extract(v329, 0, 8 - v328);
                local v334 = bit32.lshift(v333, v328 - 1);
                local v335 = bit32.extract(v332, 9 - v328, v328 - 1);
                local v336 = bit32.bor(v334, v335);
                buffer.writeu8(v325, i - 1, v336);
            end;

            v326 = v326 + 7;
        end;

        return buffer.tostring(v325);
    end,

    utf8Decode = function(p337) -- Line: 623, Name: utf8Decode
        local v338 = math.floor(#p337 * 7 / 8);
        local v339 = buffer.create(v338);
        local v340 = 0;

        for i = 1, v338 do
            local v341 = v340 % 7;
            local v342 = math.floor(v340 / 7) + 1;
            local v343 = string.byte(p337, v342);
            local v344 = math.floor(v340 / 7) + 2;
            local v345 = string.byte(p337, v344);
            local v346 = bit32.extract(v343, 0, 7 - v341);
            local v347 = bit32.lshift(v346, v341 + 1);
            local v348 = bit32.extract(v345, 6 - v341, v341 + 1);
            local v349 = bit32.bor(v347, v348);
            buffer.writeu8(v339, i - 1, v349);
            v340 = v340 + 8;
        end;

        return buffer.tostring(v339);
    end,

    decode = function(p350) -- Line: 644, Name: decodeData
        -- upvalues: parse (copy)
        local v351 = type(p350) == "string";
        assert(v351, "must be string");
        assert(#p350 > 0, "input too short");

        return parse(buffer.fromstring(p350), 0);
    end,

    decodeBuffer = parse,

    encode = function(p352) -- Line: 654, Name: encodeData
        -- upvalues: encode (copy), u301 (ref)
        local v353, v354 = encode(u301, 0, p352, {});
        u301 = v353;

        return buffer.readstring(v353, 0, v354);
    end,

    encodeb64 = function(p355) -- Line: 660, Name: encodeb64
        -- upvalues: encode (copy), u301 (ref), EncodingService (copy)
        local v356, v357 = encode(u301, 0, p355, {});
        u301 = v356;
        local v358 = buffer.create(v357);
        buffer.copy(v358, 0, v356, 0, v357);

        return buffer.tostring(EncodingService:Base64Encode(v358));
    end,

    decodeb64 = function(p359) -- Line: 668, Name: decodeb64
        -- upvalues: EncodingService (copy), parse (copy)
        return parse(EncodingService:Base64Decode(buffer.fromstring(p359)), 0);
    end
});