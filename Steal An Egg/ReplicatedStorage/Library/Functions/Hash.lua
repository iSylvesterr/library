-- Decompiled with Potassium's decompiler.

local Base64 = require(script.Base64);
local v1 = ipairs;
local band = bit32.band;
local bor = bit32.bor;
local bxor = bit32.bxor;
local lshift = bit32.lshift;
local rshift = bit32.rshift;
local lrotate = bit32.lrotate;
local rrotate = bit32.rrotate;
local u2 = {};
local u3 = {};
local v4 = {};
local v5 = {};
local u6 = {};
local u7 = {};
local u8 = {};
local u9 = { 0, 0, 0, 0, 0, 0, 0, 0, 28, 25, 26, 27, 0, 0, 10, 9, 11, 12, 0, 15, 16, 17, 18, 0, 20, 22, 23, 21 };
local u10 = {};
local v11 = v5;
local v12 = v4;
local v13 = 4;
local v14 = { 4, 1, 2, -2, 2 };

local function sha256_feed_64(p15, p16, p17, p18) -- Line: 179
    -- upvalues: u10 (copy), u3 (copy), rrotate (copy), lrotate (copy), rshift (copy), bxor (copy), band (copy)
    local v19 = u10;
    local v20 = u3;
    local v21 = p15[1];
    local v22 = p15[2];
    local v23 = p15[3];
    local v24 = p15[4];
    local v25 = p15[5];
    local v26 = p15[6];
    local v27 = p15[7];
    local v28 = p15[8];

    for i = p17, p17 + p18 - 1, 64 do
        local _ = i;

        for i2 = 1, 16 do
            local i = i + 4;
            local v29, v30, v31, v32 = string.byte(p16, i - 3, i);
            v19[i2] = ((v29 * 256 + v30) * 256 + v31) * 256 + v32;
        end;

        for i2 = 17, 64 do
            local v33 = v19[i2 - 15];
            local v34 = v19[i2 - 2];
            v19[i2] = bxor(rrotate(v33, 7), lrotate(v33, 14), (rshift(v33, 3))) + bxor(lrotate(v34, 15), lrotate(v34, 13), (rshift(v34, 10))) + v19[i2 - 7] + v19[i2 - 16];
        end;

        local v35 = v24;
        local v36 = v27;
        local v37 = v25;
        local v38 = v28;
        local v39 = v23;
        local v40 = v22;
        local v41 = v21;
        local v42 = v26;

        for i2 = 1, 64 do
            local v43 = bxor(rrotate(v25, 6), rrotate(v25, 11), (lrotate(v25, 7))) + band(v25, v26) + band(-1 - v25, v27) + v28 + v20[i2] + v19[i2];
            local v44 = v43 + v24;
            local v45 = v43 + band(v23, v22) + band(v21, (bxor(v23, v22))) + bxor(rrotate(v21, 2), rrotate(v21, 13), (lrotate(v21, 10)));
            v24 = v23;
            v23 = v22;
            v22 = v21;
            v21 = v45;
            v28 = v27;
            v27 = v26;
            v26 = v25;
            v25 = v44;
        end;

        v21 = (v21 + v41) % 4294967296;
        v22 = (v22 + v40) % 4294967296;
        v23 = (v23 + v39) % 4294967296;
        v24 = (v24 + v35) % 4294967296;
        v25 = (v25 + v37) % 4294967296;
        v26 = (v26 + v42) % 4294967296;
        v27 = (v27 + v36) % 4294967296;
        v28 = (v28 + v38) % 4294967296;
    end;

    p15[1] = v21;
    p15[2] = v22;
    p15[3] = v23;
    p15[4] = v24;
    p15[5] = v25;
    p15[6] = v26;
    p15[7] = v27;
    p15[8] = v28;
end;

local function md5_feed_64(p46, p47, p48, p49) -- Line: 350
    -- upvalues: u10 (copy), u8 (copy), u9 (copy), band (copy), rrotate (copy), bxor (copy), bor (copy)
    local v50 = u10;
    local v51 = u8;
    local v52 = u9;
    local v53 = p46[1];
    local v54 = p46[2];
    local v55 = p46[3];
    local v56 = p46[4];

    for i = p48, p48 + p49 - 1, 64 do
        local _ = i;

        for i2 = 1, 16 do
            local i = i + 4;
            local v57, v58, v59, v60 = string.byte(p47, i - 3, i);
            v50[i2] = ((v60 * 256 + v59) * 256 + v58) * 256 + v57;
        end;

        local v61 = v56;
        local v62 = v53;
        local v63 = v55;
        local v64 = v54;
        local v65 = 25;

        for i2 = 1, 16 do
            local v66 = rrotate(band(v54, v55) + band(-1 - v54, v56) + v53 + v51[i2] + v50[i2], v65) + v54;
            v65 = v52[v65];
            v53 = v56;
            v56 = v55;
            v55 = v54;
            v54 = v66;
        end;

        local v67 = 27;

        for i2 = 17, 32 do
            local v68 = rrotate(band(v56, v54) + band(-1 - v56, v55) + v53 + v51[i2] + v50[(i2 * 5 - 4) % 16 + 1], v67) + v54;
            v67 = v52[v67];
            v53 = v56;
            v56 = v55;
            v55 = v54;
            v54 = v68;
        end;

        local v69 = 28;

        for i2 = 33, 48 do
            local v70 = rrotate(bxor(bxor(v54, v55), v56) + v53 + v51[i2] + v50[(i2 * 3 + 2) % 16 + 1], v69) + v54;
            v69 = v52[v69];
            v53 = v56;
            v56 = v55;
            v55 = v54;
            v54 = v70;
        end;

        local v71 = 26;

        for i2 = 49, 64 do
            local v72 = rrotate(bxor(v55, (bor(v54, -1 - v56))) + v53 + v51[i2] + v50[(i2 * 7 - 7) % 16 + 1], v71) + v54;
            v71 = v52[v71];
            v53 = v56;
            v56 = v55;
            v55 = v54;
            v54 = v72;
        end;

        v53 = (v53 + v62) % 4294967296;
        v54 = (v54 + v64) % 4294967296;
        v55 = (v55 + v63) % 4294967296;
        v56 = (v56 + v61) % 4294967296;
    end;

    p46[1] = v53;
    p46[2] = v54;
    p46[3] = v55;
    p46[4] = v56;
end;

local u73 = {
    [384] = {},
    [512] = v5
};

local function mul(p74, p75, p76, p77) -- Line: 801
    local v78 = table.create(p77);
    local v79 = 0;
    local v80 = 1;
    local v81 = 0;

    for i = 1, p77 do
        for i2 = math.max(1, i + 1 - #p75), math.min(i, #p74) do
            v79 = v79 + p76 * p74[i2] * p75[i + 1 - i2];
        end;

        local v82 = v79 % 16777216;
        v78[i] = math.floor(v82);
        v79 = (v79 - v82) / 16777216;
        v81 = v81 + v82 * v80;
        v80 = v80 * 16777216;
    end;

    return v78, v81;
end;

local v83 = { 1 };

local function keccak_feed(p84, p85, p86, p87, p88, p89) -- Line: 474
    -- upvalues: u6 (copy), u7 (copy), bxor (copy), band (copy)
    local v90 = u6;
    local v91 = u7;
    local v92 = p89 / 8;

    for i = p87, p87 + p88 - 1, p89 do
        local _ = i;

        for i2 = 1, v92 do
            local v93, v94, v95, v96 = string.byte(p86, i + 1, i + 4);
            p84[i2] = bxor(p84[i2], ((v96 * 256 + v95) * 256 + v94) * 256 + v93);
            local i = i + 8;
            local v97, v98, v99, v100 = string.byte(p86, i - 3, i);
            p85[i2] = bxor(p85[i2], ((v100 * 256 + v99) * 256 + v98) * 256 + v97);
        end;

        local v101 = p84[1];
        local v102 = p85[1];
        local v103 = p84[2];
        local v104 = p85[2];
        local v105 = p84[3];
        local v106 = p85[3];
        local v107 = p84[4];
        local v108 = p85[4];
        local v109 = p84[5];
        local v110 = p85[5];
        local v111 = p84[6];
        local v112 = p85[6];
        local v113 = p84[7];
        local v114 = p85[7];
        local v115 = p84[8];
        local v116 = p85[8];
        local v117 = p84[9];
        local v118 = p85[9];
        local v119 = p84[10];
        local v120 = p85[10];
        local v121 = p84[11];
        local v122 = p85[11];
        local v123 = p84[12];
        local v124 = p85[12];
        local v125 = p84[13];
        local v126 = p85[13];
        local v127 = p84[14];
        local v128 = p85[14];
        local v129 = p84[15];
        local v130 = p85[15];
        local v131 = p84[16];
        local v132 = p85[16];
        local v133 = p84[17];
        local v134 = p85[17];
        local v135 = p84[18];
        local v136 = p85[18];
        local v137 = p84[19];
        local v138 = p85[19];
        local v139 = p84[20];
        local v140 = p85[20];
        local v141 = p84[21];
        local v142 = p85[21];
        local v143 = p84[22];
        local v144 = p85[22];
        local v145 = p84[23];
        local v146 = p85[23];
        local v147 = p84[24];
        local v148 = p85[24];
        local v149 = p84[25];
        local v150 = p85[25];

        for i2 = 1, 24 do
            local v151 = bxor(v101, v111, v121, v131, v141);
            local v152 = bxor(v102, v112, v122, v132, v142);
            local v153 = bxor(v103, v113, v123, v133, v143);
            local v154 = bxor(v104, v114, v124, v134, v144);
            local v155 = bxor(v105, v115, v125, v135, v145);
            local v156 = bxor(v106, v116, v126, v136, v146);
            local v157 = bxor(v107, v117, v127, v137, v147);
            local v158 = bxor(v108, v118, v128, v138, v148);
            local v159 = bxor(v109, v119, v129, v139, v149);
            local v160 = bxor(v110, v120, v130, v140, v150);
            local v161 = bxor(v151, v155 * 2 + (v156 % 4294967296 - v156 % 2147483648) / 2147483648);
            local v162 = bxor(v152, v156 * 2 + (v155 % 4294967296 - v155 % 2147483648) / 2147483648);
            local v163 = bxor(v161, v103);
            local v164 = bxor(v162, v104);
            local v165 = bxor(v161, v113);
            local v166 = bxor(v162, v114);
            local v167 = bxor(v161, v123);
            local v168 = bxor(v162, v124);
            local v169 = bxor(v161, v133);
            local v170 = bxor(v162, v134);
            local v171 = bxor(v161, v143);
            local v172 = bxor(v162, v144);
            local v173 = (v165 % 4294967296 - v165 % 1048576) / 1048576 + v166 * 4096;
            local v174 = (v166 % 4294967296 - v166 % 1048576) / 1048576 + v165 * 4096;
            local v175 = (v169 % 4294967296 - v169 % 524288) / 524288 + v170 * 8192;
            local v176 = (v170 % 4294967296 - v170 % 524288) / 524288 + v169 * 8192;
            local v177 = v163 * 2 + (v164 % 4294967296 - v164 % 2147483648) / 2147483648;
            local v178 = v164 * 2 + (v163 % 4294967296 - v163 % 2147483648) / 2147483648;
            local v179 = v167 * 1024 + (v168 % 4294967296 - v168 % 4194304) / 4194304;
            local v180 = v168 * 1024 + (v167 % 4294967296 - v167 % 4194304) / 4194304;
            local v181 = v171 * 4 + (v172 % 4294967296 - v172 % 1073741824) / 1073741824;
            local v182 = v172 * 4 + (v171 % 4294967296 - v171 % 1073741824) / 1073741824;
            local v183 = bxor(v153, v157 * 2 + (v158 % 4294967296 - v158 % 2147483648) / 2147483648);
            local v184 = bxor(v154, v158 * 2 + (v157 % 4294967296 - v157 % 2147483648) / 2147483648);
            local v185 = bxor(v183, v105);
            local v186 = bxor(v184, v106);
            local v187 = bxor(v183, v115);
            local v188 = bxor(v184, v116);
            local v189 = bxor(v183, v125);
            local v190 = bxor(v184, v126);
            local v191 = bxor(v183, v135);
            local v192 = bxor(v184, v136);
            local v193 = bxor(v183, v145);
            local v194 = bxor(v184, v146);
            local v195 = (v189 % 4294967296 - v189 % 2097152) / 2097152 + v190 * 2048;
            local v196 = (v190 % 4294967296 - v190 % 2097152) / 2097152 + v189 * 2048;
            local v197 = (v193 % 4294967296 - v193 % 8) / 8 + v194 * 536870912 % 4294967296;
            local v198 = (v194 % 4294967296 - v194 % 8) / 8 + v193 * 536870912 % 4294967296;
            local v199 = v187 * 64 + (v188 % 4294967296 - v188 % 67108864) / 67108864;
            local v200 = v188 * 64 + (v187 % 4294967296 - v187 % 67108864) / 67108864;
            local v201 = v191 * 32768 + (v192 % 4294967296 - v192 % 131072) / 131072;
            local v202 = v192 * 32768 + (v191 % 4294967296 - v191 % 131072) / 131072;
            local v203 = (v185 % 4294967296 - v185 % 4) / 4 + v186 * 1073741824 % 4294967296;
            local v204 = (v186 % 4294967296 - v186 % 4) / 4 + v185 * 1073741824 % 4294967296;
            local v205 = bxor(v155, v159 * 2 + (v160 % 4294967296 - v160 % 2147483648) / 2147483648);
            local v206 = bxor(v156, v160 * 2 + (v159 % 4294967296 - v159 % 2147483648) / 2147483648);
            local v207 = bxor(v205, v107);
            local v208 = bxor(v206, v108);
            local v209 = bxor(v205, v117);
            local v210 = bxor(v206, v118);
            local v211 = bxor(v205, v127);
            local v212 = bxor(v206, v128);
            local v213 = bxor(v205, v137);
            local v214 = bxor(v206, v138);
            local v215 = bxor(v205, v147);
            local v216 = bxor(v206, v148);
            local v217 = v213 * 2097152 % 4294967296 + (v214 % 4294967296 - v214 % 2048) / 2048;
            local v218 = v214 * 2097152 % 4294967296 + (v213 % 4294967296 - v213 % 2048) / 2048;
            local v219 = v207 * 268435456 % 4294967296 + (v208 % 4294967296 - v208 % 16) / 16;
            local v220 = v208 * 268435456 % 4294967296 + (v207 % 4294967296 - v207 % 16) / 16;
            local v221 = v211 * 33554432 % 4294967296 + (v212 % 4294967296 - v212 % 128) / 128;
            local v222 = v212 * 33554432 % 4294967296 + (v211 % 4294967296 - v211 % 128) / 128;
            local v223 = (v215 % 4294967296 - v215 % 256) / 256 + v216 * 16777216 % 4294967296;
            local v224 = (v216 % 4294967296 - v216 % 256) / 256 + v215 * 16777216 % 4294967296;
            local v225 = (v209 % 4294967296 - v209 % 512) / 512 + v210 * 8388608 % 4294967296;
            local v226 = (v210 % 4294967296 - v210 % 512) / 512 + v209 * 8388608 % 4294967296;
            local v227 = bxor(v157, v151 * 2 + (v152 % 4294967296 - v152 % 2147483648) / 2147483648);
            local v228 = bxor(v158, v152 * 2 + (v151 % 4294967296 - v151 % 2147483648) / 2147483648);
            local v229 = bxor(v227, v109);
            local v230 = bxor(v228, v110);
            local v231 = bxor(v227, v119);
            local v232 = bxor(v228, v120);
            local v233 = bxor(v227, v129);
            local v234 = bxor(v228, v130);
            local v235 = bxor(v227, v139);
            local v236 = bxor(v228, v140);
            local v237 = bxor(v227, v149);
            local v238 = bxor(v228, v150);
            local v239 = v237 * 16384 + (v238 % 4294967296 - v238 % 262144) / 262144;
            local v240 = v238 * 16384 + (v237 % 4294967296 - v237 % 262144) / 262144;
            local v241 = v231 * 1048576 % 4294967296 + (v232 % 4294967296 - v232 % 4096) / 4096;
            local v242 = v232 * 1048576 % 4294967296 + (v231 % 4294967296 - v231 % 4096) / 4096;
            local v243 = v235 * 256 + (v236 % 4294967296 - v236 % 16777216) / 16777216;
            local v244 = v236 * 256 + (v235 % 4294967296 - v235 % 16777216) / 16777216;
            local v245 = v229 * 134217728 % 4294967296 + (v230 % 4294967296 - v230 % 32) / 32;
            local v246 = v230 * 134217728 % 4294967296 + (v229 % 4294967296 - v229 % 32) / 32;
            local v247 = (v233 % 4294967296 - v233 % 33554432) / 33554432 + v234 * 128;
            local v248 = (v234 % 4294967296 - v234 % 33554432) / 33554432 + v233 * 128;
            local v249 = bxor(v159, v153 * 2 + (v154 % 4294967296 - v154 % 2147483648) / 2147483648);
            local v250 = bxor(v160, v154 * 2 + (v153 % 4294967296 - v153 % 2147483648) / 2147483648);
            local v251 = bxor(v249, v111);
            local v252 = bxor(v250, v112);
            local v253 = bxor(v249, v121);
            local v254 = bxor(v250, v122);
            local v255 = bxor(v249, v131);
            local v256 = bxor(v250, v132);
            local v257 = bxor(v249, v141);
            local v258 = bxor(v250, v142);
            local v259 = v253 * 8 + (v254 % 4294967296 - v254 % 536870912) / 536870912;
            local v260 = v254 * 8 + (v253 % 4294967296 - v253 % 536870912) / 536870912;
            local v261 = v257 * 262144 + (v258 % 4294967296 - v258 % 16384) / 16384;
            local v262 = v258 * 262144 + (v257 % 4294967296 - v257 % 16384) / 16384;
            local v263 = (v251 % 4294967296 - v251 % 268435456) / 268435456 + v252 * 16;
            local v264 = (v252 % 4294967296 - v252 % 268435456) / 268435456 + v251 * 16;
            local v265 = (v255 % 4294967296 - v255 % 8388608) / 8388608 + v256 * 512;
            local v266 = (v256 % 4294967296 - v256 % 8388608) / 8388608 + v255 * 512;
            local v267 = bxor(v249, v101);
            local v268 = bxor(v250, v102);
            local v269 = bxor(v267, (band(-1 - v173, v195)));
            v103 = bxor(v173, (band(-1 - v195, v217)));
            v105 = bxor(v195, (band(-1 - v217, v239)));
            v107 = bxor(v217, (band(-1 - v239, v267)));
            v109 = bxor(v239, (band(-1 - v267, v173)));
            local v270 = bxor(v268, (band(-1 - v174, v196)));
            v104 = bxor(v174, (band(-1 - v196, v218)));
            v106 = bxor(v196, (band(-1 - v218, v240)));
            v108 = bxor(v218, (band(-1 - v240, v268)));
            v110 = bxor(v240, (band(-1 - v268, v174)));
            v111 = bxor(v219, (band(-1 - v241, v259)));
            v113 = bxor(v241, (band(-1 - v259, v175)));
            v115 = bxor(v259, (band(-1 - v175, v197)));
            v117 = bxor(v175, (band(-1 - v197, v219)));
            v119 = bxor(v197, (band(-1 - v219, v241)));
            v112 = bxor(v220, (band(-1 - v242, v260)));
            v114 = bxor(v242, (band(-1 - v260, v176)));
            v116 = bxor(v260, (band(-1 - v176, v198)));
            v118 = bxor(v176, (band(-1 - v198, v220)));
            v120 = bxor(v198, (band(-1 - v220, v242)));
            v121 = bxor(v177, (band(-1 - v199, v221)));
            v123 = bxor(v199, (band(-1 - v221, v243)));
            v125 = bxor(v221, (band(-1 - v243, v261)));
            v127 = bxor(v243, (band(-1 - v261, v177)));
            v129 = bxor(v261, (band(-1 - v177, v199)));
            v122 = bxor(v178, (band(-1 - v200, v222)));
            v124 = bxor(v200, (band(-1 - v222, v244)));
            v126 = bxor(v222, (band(-1 - v244, v262)));
            v128 = bxor(v244, (band(-1 - v262, v178)));
            v130 = bxor(v262, (band(-1 - v178, v200)));
            v131 = bxor(v245, (band(-1 - v263, v179)));
            v133 = bxor(v263, (band(-1 - v179, v201)));
            v135 = bxor(v179, (band(-1 - v201, v223)));
            v137 = bxor(v201, (band(-1 - v223, v245)));
            v139 = bxor(v223, (band(-1 - v245, v263)));
            v132 = bxor(v246, (band(-1 - v264, v180)));
            v134 = bxor(v264, (band(-1 - v180, v202)));
            v136 = bxor(v180, (band(-1 - v202, v224)));
            v138 = bxor(v202, (band(-1 - v224, v246)));
            v140 = bxor(v224, (band(-1 - v246, v264)));
            v141 = bxor(v203, (band(-1 - v225, v247)));
            v143 = bxor(v225, (band(-1 - v247, v265)));
            v145 = bxor(v247, (band(-1 - v265, v181)));
            v147 = bxor(v265, (band(-1 - v181, v203)));
            v149 = bxor(v181, (band(-1 - v203, v225)));
            v142 = bxor(v204, (band(-1 - v226, v248)));
            v144 = bxor(v226, (band(-1 - v248, v266)));
            v146 = bxor(v248, (band(-1 - v266, v182)));
            v148 = bxor(v266, (band(-1 - v182, v204)));
            v150 = bxor(v182, (band(-1 - v204, v226)));
            v101 = bxor(v269, v90[i2]);
            v102 = v270 + v91[i2];
        end;

        p84[1] = v101;
        p85[1] = v102;
        p84[2] = v103;
        p85[2] = v104;
        p84[3] = v105;
        p85[3] = v106;
        p84[4] = v107;
        p85[4] = v108;
        p84[5] = v109;
        p85[5] = v110;
        p84[6] = v111;
        p85[6] = v112;
        p84[7] = v113;
        p85[7] = v114;
        p84[8] = v115;
        p85[8] = v116;
        p84[9] = v117;
        p85[9] = v118;
        p84[10] = v119;
        p85[10] = v120;
        p84[11] = v121;
        p85[11] = v122;
        p84[12] = v123;
        p85[12] = v124;
        p84[13] = v125;
        p85[13] = v126;
        p84[14] = v127;
        p85[14] = v128;
        p84[15] = v129;
        p85[15] = v130;
        p84[16] = v131;
        p85[16] = v132;
        p84[17] = v133;
        p85[17] = v134;
        p84[18] = v135;
        p85[18] = v136;
        p84[19] = v137;
        p85[19] = v138;
        p84[20] = v139;
        p85[20] = v140;
        p84[21] = v141;
        p85[21] = v142;
        p84[22] = v143;
        p85[22] = v144;
        p84[23] = v145;
        p85[23] = v146;
        p84[24] = v147;
        p85[24] = v148;
        p84[25] = v149;
        p85[25] = v150;
    end;
end;

local function sha512_feed_128(p271, p272, p273, p274, p275) -- Line: 226
    -- upvalues: u10 (copy), u2 (copy), u3 (copy), rshift (copy), lshift (copy), bxor (copy), band (copy)
    local v276 = u10;
    local v277 = u2;
    local v278 = u3;
    local v279 = p271[1];
    local v280 = p271[2];
    local v281 = p271[3];
    local v282 = p271[4];
    local v283 = p271[5];
    local v284 = p271[6];
    local v285 = p271[7];
    local v286 = p271[8];
    local v287 = p272[1];
    local v288 = p272[2];
    local v289 = p272[3];
    local v290 = p272[4];
    local v291 = p272[5];
    local v292 = p272[6];
    local v293 = p272[7];
    local v294 = p272[8];

    for i = p274, p274 + p275 - 1, 128 do
        local _ = i;

        for i2 = 1, 32 do
            local i = i + 4;
            local v295, v296, v297, v298 = string.byte(p273, i - 3, i);
            v276[i2] = ((v295 * 256 + v296) * 256 + v297) * 256 + v298;
        end;

        for i2 = 34, 160, 2 do
            local v299 = v276[i2 - 30];
            local v300 = v276[i2 - 31];
            local v301 = v276[i2 - 4];
            local v302 = v276[i2 - 5];
            local v303 = bxor(rshift(v299, 1) + lshift(v300, 31), rshift(v299, 8) + lshift(v300, 24), rshift(v299, 7) + lshift(v300, 25)) % 4294967296 + bxor(rshift(v301, 19) + lshift(v302, 13), lshift(v301, 3) + rshift(v302, 29), rshift(v301, 6) + lshift(v302, 26)) % 4294967296 + v276[i2 - 14] + v276[i2 - 32];
            local v304 = v303 % 4294967296;
            v276[i2 - 1] = bxor(rshift(v300, 1) + lshift(v299, 31), rshift(v300, 8) + lshift(v299, 24), (rshift(v300, 7))) + bxor(rshift(v302, 19) + lshift(v301, 13), lshift(v302, 3) + rshift(v301, 29), (rshift(v302, 6))) + v276[i2 - 15] + v276[i2 - 33] + (v303 - v304) / 4294967296;
            v276[i2] = v304;
        end;

        local v305 = v288;
        local v306 = v280;
        local v307 = v282;
        local v308 = v289;
        local v309 = v293;
        local v310 = v286;
        local v311 = v284;
        local v312 = v291;
        local v313 = v279;
        local v314 = v281;
        local v315 = v294;
        local v316 = v285;
        local v317 = v292;
        local v318 = v283;
        local v319 = v290;
        local v320 = v287;

        for i2 = 1, 80 do
            local v321 = i2 * 2;
            local v322 = bxor(rshift(v283, 14) + lshift(v291, 18), rshift(v283, 18) + lshift(v291, 14), lshift(v283, 23) + rshift(v291, 9)) % 4294967296 + (band(v283, v284) + band(-1 - v283, v285)) % 4294967296 + v286 + v277[i2] + v276[v321];
            local v323 = v322 % 4294967296;
            local v324 = bxor(rshift(v291, 14) + lshift(v283, 18), rshift(v291, 18) + lshift(v283, 14), lshift(v291, 23) + rshift(v283, 9)) + band(v291, v292) + band(-1 - v291, v293) + v294 + v278[i2] + v276[v321 - 1] + (v322 - v323) / 4294967296;
            local v325 = v323 + v282;
            local v326 = v325 % 4294967296;
            local v327 = v323 + (band(v281, v280) + band(v279, (bxor(v281, v280)))) % 4294967296 + bxor(rshift(v279, 28) + lshift(v287, 4), lshift(v279, 30) + rshift(v287, 2), lshift(v279, 25) + rshift(v287, 7)) % 4294967296;
            local v328 = v327 % 4294967296;
            local v329 = v324 + (band(v289, v288) + band(v287, (bxor(v289, v288)))) + bxor(rshift(v287, 28) + lshift(v279, 4), lshift(v287, 30) + rshift(v279, 2), lshift(v287, 25) + rshift(v279, 7)) + (v327 - v328) / 4294967296;
            v282 = v281;
            v281 = v280;
            v280 = v279;
            v279 = v328;
            v294 = v293;
            v293 = v292;
            v292 = v291;
            v291 = v324 + v290 + (v325 - v326) / 4294967296;
            v286 = v285;
            v285 = v284;
            v284 = v283;
            v283 = v326;
            v290 = v289;
            v289 = v288;
            v288 = v287;
            v287 = v329;
        end;

        local v330 = v313 + v279;
        v279 = v330 % 4294967296;
        v287 = (v320 + v287 + (v330 - v279) / 4294967296) % 4294967296;
        local v331 = v306 + v280;
        v280 = v331 % 4294967296;
        v288 = (v305 + v288 + (v331 - v280) / 4294967296) % 4294967296;
        local v332 = v314 + v281;
        v281 = v332 % 4294967296;
        v289 = (v308 + v289 + (v332 - v281) / 4294967296) % 4294967296;
        local v333 = v307 + v282;
        v282 = v333 % 4294967296;
        v290 = (v319 + v290 + (v333 - v282) / 4294967296) % 4294967296;
        local v334 = v318 + v283;
        v283 = v334 % 4294967296;
        v291 = (v312 + v291 + (v334 - v283) / 4294967296) % 4294967296;
        local v335 = v311 + v284;
        v284 = v335 % 4294967296;
        v292 = (v317 + v292 + (v335 - v284) / 4294967296) % 4294967296;
        local v336 = v316 + v285;
        v285 = v336 % 4294967296;
        v293 = (v309 + v293 + (v336 - v285) / 4294967296) % 4294967296;
        local v337 = v310 + v286;
        v286 = v337 % 4294967296;
        v294 = (v315 + v294 + (v337 - v286) / 4294967296) % 4294967296;
    end;

    p271[1] = v279;
    p271[2] = v280;
    p271[3] = v281;
    p271[4] = v282;
    p271[5] = v283;
    p271[6] = v284;
    p271[7] = v285;
    p271[8] = v286;
    p272[1] = v287;
    p272[2] = v288;
    p272[3] = v289;
    p272[4] = v290;
    p272[5] = v291;
    p272[6] = v292;
    p272[7] = v293;
    p272[8] = v294;
end;

local u338 = { 1732584193, 4023233417, 2562383102, 271733878, 3285377520 };
local u339 = {
    [384] = {},
    [512] = v4
};

local function sha1_feed_64(p340, p341, p342, p343) -- Line: 412
    -- upvalues: u10 (copy), bxor (copy), lrotate (copy), band (copy), rrotate (copy)
    local v344 = u10;
    local v345 = p340[1];
    local v346 = p340[2];
    local v347 = p340[3];
    local v348 = p340[4];
    local v349 = p340[5];

    for i = p342, p342 + p343 - 1, 64 do
        local _ = i;

        for i2 = 1, 16 do
            local i = i + 4;
            local v350, v351, v352, v353 = string.byte(p341, i - 3, i);
            v344[i2] = ((v350 * 256 + v351) * 256 + v352) * 256 + v353;
        end;

        for i2 = 17, 80 do
            v344[i2] = lrotate(bxor(v344[i2 - 3], v344[i2 - 8], v344[i2 - 14], v344[i2 - 16]), 1);
        end;

        local v354 = v348;
        local v355 = v347;
        local v356 = v345;
        local v357 = v349;
        local v358 = v346;

        for i2 = 1, 20 do
            local v359 = lrotate(v345, 5) + band(v346, v347) + band(-1 - v346, v348) + 1518500249 + v344[i2] + v349;
            local v360 = rrotate(v346, 2);
            v346 = v345;
            v345 = v359;
            v349 = v348;
            v348 = v347;
            v347 = v360;
        end;

        for i2 = 21, 40 do
            local v361 = lrotate(v345, 5) + bxor(v346, v347, v348) + 1859775393 + v344[i2] + v349;
            local v362 = rrotate(v346, 2);
            v346 = v345;
            v345 = v361;
            v349 = v348;
            v348 = v347;
            v347 = v362;
        end;

        for i2 = 41, 60 do
            local v363 = lrotate(v345, 5) + band(v348, v347) + band(v346, (bxor(v348, v347))) + 2400959708 + v344[i2] + v349;
            local v364 = rrotate(v346, 2);
            v346 = v345;
            v345 = v363;
            v349 = v348;
            v348 = v347;
            v347 = v364;
        end;

        for i2 = 61, 80 do
            local v365 = lrotate(v345, 5) + bxor(v346, v347, v348) + 3395469782 + v344[i2] + v349;
            local v366 = rrotate(v346, 2);
            v346 = v345;
            v345 = v365;
            v349 = v348;
            v348 = v347;
            v347 = v366;
        end;

        v345 = (v345 + v356) % 4294967296;
        v346 = (v346 + v358) % 4294967296;
        v347 = (v347 + v355) % 4294967296;
        v348 = (v348 + v354) % 4294967296;
        v349 = (v349 + v357) % 4294967296;
    end;

    p340[1] = v345;
    p340[2] = v346;
    p340[3] = v347;
    p340[4] = v348;
    p340[5] = v349;
end;

local v367 = 0;
local u368 = {
    [224] = {},
    [256] = v5
};

while true do
    v13 = v13 + v14[v13 % 6];
    local v369 = 1;
    v369 = v369 + v14[v369 % 6];

    if v13 < v369 * v369 then
        local v370 = v13 ^ 0.3333333333333333;
        local v371 = mul(table.create(1, (math.floor(v370 * 1099511627776))), v83, 1, 2);
        local _, v372 = mul(v371, mul(v371, v371, 1, 4), -1, 4);
        local v373 = v371[2] % 65536 * 65536 + math.floor(v371[1] / 256);
        local v374 = v371[1] % 256 * 16777216 + math.floor(v372 * 4.625929269271485e-18 * v370 / v13);

        if v367 < 16 then
            local v375 = math.sqrt(v13);
            local v376 = mul(table.create(1, (math.floor(v375 * 1099511627776))), v83, 1, 2);
            local _, v377 = mul(v376, v376, -1, 2);
            local v378 = v376[2] % 65536 * 65536 + math.floor(v376[1] / 256);
            local v379 = v376[1] % 256 * 16777216 + math.floor(v377 * 7.62939453125e-6 / v375);
            local v380 = v367 % 8 + 1;
            u368[224][v380] = v379;
            v5[v380] = v378;
            v4[v380] = v379 + v378 * 0;

            if v380 > 7 then
                v5 = u73[384];
                v4 = u339[384];
            end;
        end;

        v367 = v367 + 1;
        u3[v367] = v373;
        u2[v367] = v374 % 4294967296 + v373 * 0;
    elseif v13 % v369 == 0 then
    else
        continue;
    end;

    if v367 > 79 then
        for i = 224, 256, 32 do
            local v381 = {};
            local v382 = {};

            for i2 = 1, 8 do
                v381[i2] = bxor(v12[i2], 2779096485) % 4294967296;
                v382[i2] = bxor(v11[i2], 2779096485) % 4294967296;
            end;

            sha512_feed_128(v381, v382, "SHA-512/" .. tostring(i) .. "\128" .. string.rep("\0", 115) .. "X", 0, 128);
            u339[i] = v381;
            u73[i] = v382;
        end;

        for i = 1, 64 do
            local v383 = math.sin(i);
            local v384 = math.abs(v383) * 65536;
            local v385, v386 = math.modf(v384);
            u8[i] = v385 * 65536 + math.floor(v386 * 65536);
        end;

        local u387 = 29;

        local function next_bit() -- Line: 891
            -- upvalues: u387 (ref), bxor (copy)
            local v388 = u387 % 2;
            u387 = bxor((u387 - v388) / 2, v388 * 142);

            return v388;
        end;

        for i = 1, 24 do
            local v389 = nil;
            local v390 = 0;

            for _ = 1, 6 do
                v389 = v389 and v389 * v389 * 2 or 1;
                local v391 = u387 % 2;
                u387 = bxor((u387 - v391) / 2, v391 * 142);
                v390 = v390 + v391 * v389;
            end;

            local v392 = u387 % 2;
            u387 = bxor((u387 - v392) / 2, v392 * 142);
            local v393 = v392 * v389;
            u7[i] = v393;
            u6[i] = v390 + v393 * 0;
        end;

        local function HexToBinFunction(p394) -- Line: 1344
            local v395 = tonumber(p394, 16);

            return string.char(v395);
        end;

        local u396 = {
            ["+"] = 62,
            ["-"] = 62,
            [62] = "+",
            ["/"] = 63,
            _ = 63,
            [63] = "/",
            ["="] = -1,
            ["."] = -1,
            [-1] = "="
        };
        local v397 = 0;

        local function keccak(u398, u399, u400, p401) -- Line: 1185
            -- upvalues: keccak_feed (copy)
            if type(u399) ~= "number" then
                error("Argument \'digest_size_in_bytes\' must be a number", 2);
            end;

            local u402 = "";
            local u403 = table.create(25, 0);
            local u404 = table.create(25, 0);
            local u405 = nil;

            local function partial(p406) -- Line: 1211
                -- upvalues: u402 (ref), u398 (copy), keccak_feed (ref), u403 (copy), u404 (copy), partial (copy), u400 (copy), u399 (copy), u405 (ref)
                if not p406 then
                    if u402 then
                        local v407 = u400 and 31 or 6;
                        u402 = u402 .. (#u402 + 1 == u398 and string.char(v407 + 128) or string.char(v407) .. string.rep("\0", (-2 - #u402) % u398) .. "\128");
                        keccak_feed(u403, u404, u402, 0, #u402, u398);
                        u402 = nil;
                        local u408 = 0;
                        local u409 = math.floor(u398 / 8);
                        local u410 = {};

                        local function get_next_qwords_of_digest(p411) -- Line: 1253
                            -- upvalues: u408 (ref), u409 (copy), keccak_feed (ref), u403 (ref), u404 (ref), u410 (copy)
                            if u409 <= u408 then
                                keccak_feed(u403, u404, "\0\0\0\0\0\0\0\0", 0, 8, 8);
                                u408 = 0;
                            end;

                            local v412 = math.min(p411, u409 - u408);
                            local v413 = math.floor(v412);

                            for i = 1, v413 do
                                u410[i] = string.format("%08x", u404[u408 + i] % 4294967296) .. string.format("%08x", u403[u408 + i] % 4294967296);
                            end;

                            u408 = u408 + v413;

                            return string.gsub(table.concat(u410, "", 1, v413), "(..)(..)(..)(..)(..)(..)(..)(..)", "%8%7%6%5%4%3%2%1"), v413 * 8;
                        end;

                        local u414 = {};
                        local u415 = "";
                        local u416 = 0;

                        local function get_next_part_of_digest(p417) -- Line: 1286
                            -- upvalues: u416 (ref), u415 (ref), u414 (copy), get_next_qwords_of_digest (copy), get_next_part_of_digest (copy)
                            local v418 = p417 or 1;

                            if v418 > u416 then
                                local v419;

                                if u416 > 0 then
                                    v419 = 1;
                                    u414[v419] = u415;
                                    v418 = v418 - u416;
                                else
                                    v419 = 0;
                                end;

                                while v418 >= 8 do
                                    local v420, v421 = get_next_qwords_of_digest(v418 / 8);
                                    v419 = v419 + 1;
                                    u414[v419] = v420;
                                    v418 = v418 - v421;
                                end;

                                if v418 > 0 then
                                    local v422, v423 = get_next_qwords_of_digest(1);
                                    u415 = v422;
                                    u416 = v423;
                                    v419 = v419 + 1;
                                    u414[v419] = get_next_part_of_digest(v418);
                                else
                                    u415 = "";
                                    u416 = 0;
                                end;

                                return table.concat(u414, "", 1, v419);
                            end;

                            u416 = u416 - v418;
                            local v424 = v418 * 2;
                            local v425 = string.sub(u415, 1, v424);
                            u415 = string.sub(u415, v424 + 1);

                            return v425;
                        end;

                        if u399 < 0 then
                            u405 = get_next_part_of_digest;
                        else
                            u405 = get_next_part_of_digest(u399);
                        end;
                    end;

                    return u405;
                end;

                local v426 = #p406;

                if u402 then
                    local v427;

                    if u402 == "" or u398 > #u402 + v426 then
                        v427 = 0;
                    else
                        v427 = u398 - #u402;
                        keccak_feed(u403, u404, u402 .. string.sub(p406, 1, v427), 0, u398, u398);
                        u402 = "";
                    end;

                    local v428 = v426 - v427;
                    local v429 = v428 % u398;
                    keccak_feed(u403, u404, p406, v427, v428 - v429, u398);
                    u402 = u402 .. string.sub(p406, v426 + 1 - v429);

                    return partial;
                end;

                error("Adding more chunks is not allowed after receiving the result", 2);
            end;

            if p401 then
                return partial(p401)();
            end;

            return partial;
        end;

        local function hex2bin(p430) -- Line: 1348
            -- upvalues: HexToBinFunction (copy)
            return string.gsub(p430, "%x%x", HexToBinFunction);
        end;

        local function md5(p431) -- Line: 1060
            -- upvalues: u338 (copy), md5_feed_64 (copy)
            local u432 = table.create(4);
            local u433 = 0;
            local u434 = "";
            local v435 = u338[2];
            local v436 = u338[3];
            local v437 = u338[4];
            u432[1] = u338[1];
            u432[2] = v435;
            u432[3] = v436;
            u432[4] = v437;

            local function u446(p438) -- Line: 1065
                -- upvalues: u434 (ref), u433 (ref), md5_feed_64 (ref), u432 (ref), u446 (copy)
                if not p438 then
                    if u434 then
                        local v439 = table.create(3);
                        v439[1] = u434;
                        v439[2] = "\128";
                        v439[3] = string.rep("\0", (-9 - u433) % 64);
                        u434 = nil;
                        u433 = u433 * 8;

                        for i = 4, 11 do
                            local v440 = u433 % 256;
                            v439[i] = string.char(v440);
                            u433 = (u433 - v440) / 256;
                        end;

                        local v441 = table.concat(v439);
                        md5_feed_64(u432, v441, 0, #v441);

                        for i = 1, 4 do
                            u432[i] = string.format("%08x", u432[i] % 4294967296);
                        end;

                        u432 = string.gsub(table.concat(u432), "(..)(..)(..)(..)", "%4%3%2%1");
                    end;

                    return u432;
                end;

                local v442 = #p438;

                if u434 then
                    u433 = u433 + v442;
                    local v443;

                    if u434 == "" or #u434 + v442 < 64 then
                        v443 = 0;
                    else
                        v443 = 64 - #u434;
                        md5_feed_64(u432, u434 .. string.sub(p438, 1, v443), 0, 64);
                        u434 = "";
                    end;

                    local v444 = v442 - v443;
                    local v445 = v444 % 64;
                    md5_feed_64(u432, p438, v443, v444 - v445);
                    u434 = u434 .. string.sub(p438, v442 + 1 - v445);

                    return u446;
                end;

                error("Adding more chunks is not allowed after receiving the result", 2);
            end;

            if p431 then
                return u446(p431)();
            end;

            return u446;
        end;

        local function sha1(p447) -- Line: 1122
            -- upvalues: u338 (copy), sha1_feed_64 (copy)
            local u448 = table.pack(table.unpack(u338));
            local u449 = 0;
            local u450 = "";

            local function u459(p451) -- Line: 1126
                -- upvalues: u450 (ref), u449 (ref), sha1_feed_64 (ref), u448 (ref), u459 (copy)
                if not p451 then
                    if u450 then
                        local v452 = table.create(10);
                        v452[1] = u450;
                        v452[2] = "\128";
                        v452[3] = string.rep("\0", (-9 - u449) % 64 + 1);
                        u450 = nil;
                        u449 = u449 * 1.1102230246251565e-16;

                        for i = 4, 10 do
                            u449 = u449 % 1 * 256;
                            local v453 = math.floor(u449);
                            v452[i] = string.char(v453);
                        end;

                        local v454 = table.concat(v452);
                        sha1_feed_64(u448, v454, 0, #v454);

                        for i = 1, 5 do
                            u448[i] = string.format("%08x", u448[i] % 4294967296);
                        end;

                        u448 = table.concat(u448);
                    end;

                    return u448;
                end;

                local v455 = #p451;

                if u450 then
                    u449 = u449 + v455;
                    local v456;

                    if u450 == "" or #u450 + v455 < 64 then
                        v456 = 0;
                    else
                        v456 = 64 - #u450;
                        sha1_feed_64(u448, u450 .. string.sub(p451, 1, v456), 0, 64);
                        u450 = "";
                    end;

                    local v457 = v455 - v456;
                    local v458 = v457 % 64;
                    sha1_feed_64(u448, p451, v456, v457 - v458);
                    u450 = u450 .. string.sub(p451, v455 + 1 - v458);

                    return u459;
                end;

                error("Adding more chunks is not allowed after receiving the result", 2);
            end;

            if p447 then
                return u459(p447)();
            end;

            return u459;
        end;

        local function sha256ext(u460, p461) -- Line: 912
            -- upvalues: u368 (copy), sha256_feed_64 (copy)
            local v462 = u368[u460];
            local u463 = 0;
            local u464 = "";
            local u465 = table.create(8);
            local v466 = v462[2];
            local v467 = v462[3];
            local v468 = v462[4];
            local v469 = v462[5];
            local v470 = v462[6];
            local v471 = v462[7];
            local v472 = v462[8];
            u465[1] = v462[1];
            u465[2] = v466;
            u465[3] = v467;
            u465[4] = v468;
            u465[5] = v469;
            u465[6] = v470;
            u465[7] = v471;
            u465[8] = v472;

            local function u483(p473) -- Line: 920
                -- upvalues: u464 (ref), u463 (ref), sha256_feed_64 (ref), u465 (ref), u483 (copy), u460 (copy)
                if not p473 then
                    if u464 then
                        local v474 = table.create(10);
                        v474[1] = u464;
                        v474[2] = "\128";
                        v474[3] = string.rep("\0", (-9 - u463) % 64 + 1);
                        u464 = nil;
                        u463 = u463 * 1.1102230246251565e-16;

                        for i = 4, 10 do
                            u463 = u463 % 1 * 256;
                            local v475 = math.floor(u463);
                            v474[i] = string.char(v475);
                        end;

                        local v476 = table.concat(v474);
                        sha256_feed_64(u465, v476, 0, #v476);
                        local v477 = u460 / 32;

                        for i = 1, v477 do
                            u465[i] = string.format("%08x", u465[i] % 4294967296);
                        end;

                        u465 = table.concat(u465, "", 1, v477);
                    end;

                    return u465;
                end;

                local v478 = #p473;

                if u464 then
                    u463 = u463 + v478;
                    local v479 = #u464;
                    local v480;

                    if u464 == "" or v479 + v478 < 64 then
                        v480 = 0;
                    else
                        v480 = 64 - v479;
                        sha256_feed_64(u465, u464 .. string.sub(p473, 1, v480), 0, 64);
                        u464 = "";
                    end;

                    local v481 = v478 - v480;
                    local v482 = v481 % 64;
                    sha256_feed_64(u465, p473, v480, v481 - v482);
                    u464 = u464 .. string.sub(p473, v478 + 1 - v482);

                    return u483;
                end;

                error("Adding more chunks is not allowed after receiving the result", 2);
            end;

            if p461 then
                return u483(p461)();
            end;

            return u483;
        end;

        local function sha512ext(u484, p485) -- Line: 982
            -- upvalues: u339 (copy), u73 (copy), sha512_feed_128 (copy)
            local u486 = 0;
            local u487 = "";
            local u488 = table.pack(table.unpack(u339[u484]));
            local u489 = table.pack(table.unpack(u73[u484]));

            local function u500(p490) -- Line: 990
                -- upvalues: u487 (ref), u486 (ref), sha512_feed_128 (ref), u488 (ref), u489 (ref), u500 (copy), u484 (copy)
                if not p490 then
                    if u487 then
                        local v491 = table.create(3);
                        v491[1] = u487;
                        v491[2] = "\128";
                        v491[3] = string.rep("\0", (-17 - u486) % 128 + 9);
                        u487 = nil;
                        u486 = u486 * 1.1102230246251565e-16;

                        for i = 4, 10 do
                            u486 = u486 % 1 * 256;
                            local v492 = math.floor(u486);
                            v491[i] = string.char(v492);
                        end;

                        local v493 = table.concat(v491);
                        sha512_feed_128(u488, u489, v493, 0, #v493);
                        local v494 = math.ceil(u484 / 64);

                        for i = 1, v494 do
                            u488[i] = string.format("%08x", u489[i] % 4294967296) .. string.format("%08x", u488[i] % 4294967296);
                        end;

                        u489 = nil;
                        local v495 = table.concat(u488, "", 1, v494);
                        u488 = string.sub(v495, 1, u484 / 4);
                    end;

                    return u488;
                end;

                local v496 = #p490;

                if u487 then
                    u486 = u486 + v496;
                    local v497;

                    if u487 == "" or #u487 + v496 < 128 then
                        v497 = 0;
                    else
                        v497 = 128 - #u487;
                        sha512_feed_128(u488, u489, u487 .. string.sub(p490, 1, v497), 0, 128);
                        u487 = "";
                    end;

                    local v498 = v496 - v497;
                    local v499 = v498 % 128;
                    sha512_feed_128(u488, u489, p490, v497, v498 - v499);
                    u487 = u487 .. string.sub(p490, v496 + 1 - v499);

                    return u500;
                end;

                error("Adding more chunks is not allowed after receiving the result", 2);
            end;

            if p485 then
                return u500(p485)();
            end;

            return u500;
        end;

        for _, v in v1({ "AZ", "az", "09" }) do
            for i = string.byte(v), string.byte(v, 2) do
                local v501 = string.char(i);
                u396[v501] = v397;
                u396[v397] = v501;
                v397 = v397 + 1;
            end;
        end;

        local u502 = {};

        local function base642bin(p503) -- Line: 1391
            -- upvalues: u396 (copy)
            local v504 = 3;
            local v505 = {};

            for i, v in string.gmatch(string.gsub(p503, "%s+", ""), "()(.)") do
                local v506 = u396[v];

                if v506 < 0 then
                    v504 = v504 - 1;
                    v506 = 0;
                end;

                local v507 = i % 4;

                if v507 > 0 then
                    v505[-v507] = v506;
                else
                    local v508 = v505[-1] * 4 + math.floor(v505[-2] / 16);
                    local v509 = v505[-2] % 16 * 16 + math.floor(v505[-3] / 4);
                    local v510 = string.char(v508, v509, v505[-3] % 4 * 64 + v506);
                    v505[#v505 + 1] = string.sub(v510, 1, v504);
                end;
            end;

            return table.concat(v505);
        end;

        local function bin2base64(p511) -- Line: 1374
            -- upvalues: u396 (copy)
            local v512 = table.create((math.ceil(#p511 / 3)));
            local v513 = 0;

            for i = 1, #p511, 3 do
                local v514 = string.sub(p511, i, i + 2) .. "\0";
                local v515, v516, v517, v518 = string.byte(v514, 1, -1);
                v513 = v513 + 1;
                v512[v513] = u396[math.floor(v515 / 4)] .. u396[v515 % 4 * 16 + math.floor(v516 / 16)] .. u396[v517 and (v516 % 16 * 4 + math.floor(v517 / 64) or -1) or -1] .. u396[v518 and v517 % 64 or -1];
            end;

            return table.concat(v512);
        end;

        local u519 = nil;

        for i = 0, 255 do
            u502[string.format("%02x", i)] = string.char(i);
        end;

        local v549 = {
            md5 = md5,
            sha1 = sha1,

            sha224 = function(p520) -- Line: 1482, Name: sha224
                -- upvalues: sha256ext (copy)
                return sha256ext(224, p520);
            end,

            sha256 = function(p521) -- Line: 1486, Name: sha256
                -- upvalues: sha256ext (copy)
                return sha256ext(256, p521);
            end,

            sha512_224 = function(p522) -- Line: 1490, Name: sha512_224
                -- upvalues: sha512ext (copy)
                return sha512ext(224, p522);
            end,

            sha512_256 = function(p523) -- Line: 1494, Name: sha512_256
                -- upvalues: sha512ext (copy)
                return sha512ext(256, p523);
            end,

            sha384 = function(p524) -- Line: 1498, Name: sha384
                -- upvalues: sha512ext (copy)
                return sha512ext(384, p524);
            end,

            sha512 = function(p525) -- Line: 1502, Name: sha512
                -- upvalues: sha512ext (copy)
                return sha512ext(512, p525);
            end,

            sha3_224 = function(p526) -- Line: 1507, Name: sha3_224
                -- upvalues: keccak (copy)
                return keccak(144, 28, false, p526);
            end,

            sha3_256 = function(p527) -- Line: 1511, Name: sha3_256
                -- upvalues: keccak (copy)
                return keccak(136, 32, false, p527);
            end,

            sha3_384 = function(p528) -- Line: 1515, Name: sha3_384
                -- upvalues: keccak (copy)
                return keccak(104, 48, false, p528);
            end,

            sha3_512 = function(p529) -- Line: 1519, Name: sha3_512
                -- upvalues: keccak (copy)
                return keccak(72, 64, false, p529);
            end,

            shake128 = function(p530, p531) -- Line: 1523, Name: shake128
                -- upvalues: keccak (copy)
                return keccak(168, p531, true, p530);
            end,

            shake256 = function(p532, p533) -- Line: 1527, Name: shake256
                -- upvalues: keccak (copy)
                return keccak(136, p533, true, p532);
            end,

            hmac = function(u534, u535, p536, p537) -- Line: 1428, Name: hmac
                -- upvalues: u519 (ref), HexToBinFunction (copy), bxor (copy), u502 (copy)
                local u538 = u519[u534];

                if not u538 then
                    error("Unknown hash function", 2);
                end;

                local u539 = #u535;

                if u538 < u539 then
                    u535 = string.gsub(u534(u535), "%x%x", HexToBinFunction);
                    u539 = #u535;
                end;

                local u542 = u534()(string.gsub(u535, ".", function(p540) -- Line: 1441
                    -- upvalues: bxor (ref)
                    local v541 = bxor(string.byte(p540), 54);

                    return string.char(v541);
                end) .. string.rep("6", u538 - u539));
                local u543 = nil;

                local function u547(p544) -- Line: 1447
                    -- upvalues: u543 (ref), u534 (copy), u535 (ref), bxor (ref), u538 (copy), u539 (ref), u542 (copy), HexToBinFunction (ref), u547 (copy)
                    if not p544 then
                        u543 = u543 or u534(string.gsub(u535, ".", function(p545) -- Line: 1451
                            -- upvalues: bxor (ref)
                            local v546 = bxor(string.byte(p545), 92);

                            return string.char(v546);
                        end) .. string.rep("\\", u538 - u539) .. string.gsub(u542(), "%x%x", HexToBinFunction));

                        return u543;
                    end;

                    if not u543 then
                        u542(p544);

                        return u547;
                    end;

                    error("Adding more chunks is not allowed after receiving the result", 2);
                end;

                if not p536 then
                    return u547;
                end;

                local v548 = u547(p536)();

                if p537 then
                    v548 = string.gsub(v548, "%x%x", u502) or v548;
                end;

                return v548;
            end,

            hex_to_bin = hex2bin,
            base64_to_bin = base642bin,
            bin_to_base64 = bin2base64,
            base64_encode = Base64.Encode,
            base64_decode = Base64.Decode
        };
        u519 = {
            [v549.md5] = 64,
            [v549.sha1] = 64,
            [v549.sha224] = 64,
            [v549.sha256] = 64,
            [v549.sha512_224] = 128,
            [v549.sha512_256] = 128,
            [v549.sha384] = 128,
            [v549.sha512] = 128,
            [v549.sha3_224] = 144,
            [v549.sha3_256] = 136,
            [v549.sha3_384] = 104,
            [v549.sha3_512] = 72
        };

        return v549;
    end;
end;