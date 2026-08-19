-- Decompiled with Potassium's decompiler.

local bxor = bit32.bxor;
local rrotate = bit32.rrotate;
local copy = buffer.copy;
local create = buffer.create;
local fromstring = buffer.fromstring;
local len = buffer.len;
local readu8 = buffer.readu8;
local readu16 = buffer.readu16;
local readu32 = buffer.readu32;
local tostring = buffer.tostring;
local writestring = buffer.writestring;
local writeu8 = buffer.writeu8;
local writeu16 = buffer.writeu16;
local writeu32 = buffer.writeu32;
local floor = math.floor;
local sub = string.sub;
local u1 = create(131072);
local u2 = create(65536);
local u3 = create(65536);
local u4 = create(65536);
local u5 = create(65536);
local u6 = create(65536);
local v7 = create(256);
local v8 = create(256);
local v9 = create(256);
local v10 = create(256);
local v11 = create(256);
writeu8(v7, 0, 99);
local v12 = 1;
local v13 = 1;

local function gfmul(p14, p15) -- Line: 748
    -- upvalues: bxor (copy), floor (copy)
    local v16 = 0;

    for _ = 0, 7 do
        if p15 % 2 == 1 then
            v16 = bxor(v16, p14);
        end;

        if p14 >= 128 then
            p14 = bxor(p14 * 2 % 256, 27);
        else
            p14 = p14 * 2 % 256;
        end;

        p15 = floor(p15 / 2);
    end;

    return v16;
end;

local function keySchedule(p17, p18, p19, p20) -- Line: 159
    -- upvalues: copy (copy), writestring (copy), readu32 (copy), rrotate (copy), u1 (copy), floor (copy), readu16 (copy), bxor (copy), writeu32 (copy)
    if p20 then
        copy(p19, 0, p17, 0, p18);
    else
        writestring(p19, 0, p17, p18);
    end;

    local v21 = rrotate(readu32(p19, p18 - 4), 8);
    local v22 = 0.5;

    if p18 == 32 then
        for i = 32, 192, 32 do
            v22 = v22 * 2 % 229;
            local v23 = bxor(readu32(p19, i - 32), readu16(u1, floor(v21 / 65536) * 2) * 65536 + readu16(u1, v21 % 65536 * 2), v22);
            writeu32(p19, i, v23);
            local v24 = bxor(readu32(p19, i - 28), v23);
            writeu32(p19, i + 4, v24);
            local v25 = bxor(readu32(p19, i - 24), v24);
            writeu32(p19, i + 8, v25);
            local v26 = bxor(readu32(p19, i - 20), v25);
            writeu32(p19, i + 12, v26);
            local v27 = bxor(readu32(p19, i - 16), readu16(u1, floor(v26 / 65536) * 2) * 65536 + readu16(u1, v26 % 65536 * 2));
            writeu32(p19, i + 16, v27);
            local v28 = bxor(readu32(p19, i - 12), v27);
            writeu32(p19, i + 20, v28);
            local v29 = bxor(readu32(p19, i - 8), v28);
            writeu32(p19, i + 24, v29);
            local v30 = bxor(readu32(p19, i - 4), v29);
            writeu32(p19, i + 28, v30);
            v21 = rrotate(v30, 8);
        end;

        local v31 = bxor(readu32(p19, 192), readu16(u1, floor(v21 / 65536) * 2) * 65536 + readu16(u1, v21 % 65536 * 2), 64);
        writeu32(p19, 224, v31);
        local v32 = bxor(readu32(p19, 196), v31);
        writeu32(p19, 228, v32);
        local v33 = bxor(readu32(p19, 200), v32);
        writeu32(p19, 232, v33);
        writeu32(p19, 236, (bxor(readu32(p19, 204), v33)));

        return p19;
    end;

    if p18 == 24 then
        for i = 24, 168, 24 do
            v22 = v22 * 2 % 229;
            local v34 = bxor(readu32(p19, i - 24), readu16(u1, floor(v21 / 65536) * 2) * 65536 + readu16(u1, v21 % 65536 * 2), v22);
            writeu32(p19, i, v34);
            local v35 = bxor(readu32(p19, i - 20), v34);
            writeu32(p19, i + 4, v35);
            local v36 = bxor(readu32(p19, i - 16), v35);
            writeu32(p19, i + 8, v36);
            local v37 = bxor(readu32(p19, i - 12), v36);
            writeu32(p19, i + 12, v37);
            local v38 = bxor(readu32(p19, i - 8), v37);
            writeu32(p19, i + 16, v38);
            local v39 = bxor(readu32(p19, i - 4), v38);
            writeu32(p19, i + 20, v39);
            v21 = rrotate(v39, 8);
        end;

        local v40 = bxor(readu32(p19, 168), readu16(u1, floor(v21 / 65536) * 2) * 65536 + readu16(u1, v21 % 65536 * 2), 128);
        writeu32(p19, 192, v40);
        local v41 = bxor(readu32(p19, 172), v40);
        writeu32(p19, 196, v41);
        local v42 = bxor(readu32(p19, 176), v41);
        writeu32(p19, 200, v42);
        writeu32(p19, 204, (bxor(readu32(p19, 180), v42)));

        return p19;
    end;

    for i = 16, 144, 16 do
        v22 = v22 * 2 % 229;
        local v43 = bxor(readu32(p19, i - 16), readu16(u1, floor(v21 / 65536) * 2) * 65536 + readu16(u1, v21 % 65536 * 2), v22);
        writeu32(p19, i, v43);
        local v44 = bxor(readu32(p19, i - 12), v43);
        writeu32(p19, i + 4, v44);
        local v45 = bxor(readu32(p19, i - 8), v44);
        writeu32(p19, i + 8, v45);
        local v46 = bxor(readu32(p19, i - 4), v45);
        writeu32(p19, i + 12, v46);
        v21 = rrotate(v46, 8);
    end;

    local v47 = bxor(readu32(p19, 144), readu16(u1, floor(v21 / 65536) * 2) * 65536 + readu16(u1, v21 % 65536 * 2), 54);
    writeu32(p19, 160, v47);
    local v48 = bxor(readu32(p19, 148), v47);
    writeu32(p19, 164, v48);
    local v49 = bxor(readu32(p19, 152), v48);
    writeu32(p19, 168, v49);
    writeu32(p19, 172, (bxor(readu32(p19, 156), v49)));

    return p19;
end;

local function encryptBlock(p50, p51, p52, p53, p54, p55) -- Line: 284
    -- upvalues: readu8 (copy), bxor (copy), u2 (copy), u3 (copy), u1 (copy), readu16 (copy), readu32 (copy), writeu32 (copy)
    local v56 = bxor(readu8(p52, p53), (readu8(p50, 0)));
    local v57 = bxor(readu8(p52, p53 + 1), (readu8(p50, 1)));
    local v58 = bxor(readu8(p52, p53 + 2), (readu8(p50, 2)));
    local v59 = bxor(readu8(p52, p53 + 3), (readu8(p50, 3)));
    local v60 = bxor(readu8(p52, p53 + 4), (readu8(p50, 4)));
    local v61 = bxor(readu8(p52, p53 + 5), (readu8(p50, 5)));
    local v62 = bxor(readu8(p52, p53 + 6), (readu8(p50, 6)));
    local v63 = bxor(readu8(p52, p53 + 7), (readu8(p50, 7)));
    local v64 = bxor(readu8(p52, p53 + 8), (readu8(p50, 8)));
    local v65 = bxor(readu8(p52, p53 + 9), (readu8(p50, 9)));
    local v66 = bxor(readu8(p52, p53 + 10), (readu8(p50, 10)));
    local v67 = bxor(readu8(p52, p53 + 11), (readu8(p50, 11)));
    local v68 = bxor(readu8(p52, p53 + 12), (readu8(p50, 12)));
    local v69 = bxor(readu8(p52, p53 + 13), (readu8(p50, 13)));
    local v70 = bxor(readu8(p52, p53 + 14), (readu8(p50, 14)));
    local v71 = bxor(readu8(p52, p53 + 15), (readu8(p50, 15)));
    local v72 = v56 * 256 + v61;
    local v73 = v61 * 256 + v66;
    local v74 = v66 * 256 + v71;
    local v75 = v71 * 256 + v56;
    local v76 = v60 * 256 + v65;
    local v77 = v65 * 256 + v70;
    local v78 = v70 * 256 + v59;
    local v79 = v59 * 256 + v60;
    local v80 = v64 * 256 + v69;
    local v81 = v69 * 256 + v58;
    local v82 = v58 * 256 + v63;
    local v83 = v63 * 256 + v64;
    local v84 = v68 * 256 + v57;
    local v85 = v57 * 256 + v62;
    local v86 = v62 * 256 + v67;
    local v87 = v67 * 256 + v68;

    for i = 16, p51, 16 do
        local v88 = bxor(readu8(u2, v72), readu8(u3, v74), (readu8(p50, i)));
        local v89 = bxor(readu8(u2, v73), readu8(u3, v75), (readu8(p50, i + 1)));
        local v90 = bxor(readu8(u2, v74), readu8(u3, v72), (readu8(p50, i + 2)));
        local v91 = bxor(readu8(u2, v75), readu8(u3, v73), (readu8(p50, i + 3)));
        local v92 = bxor(readu8(u2, v76), readu8(u3, v78), (readu8(p50, i + 4)));
        local v93 = bxor(readu8(u2, v77), readu8(u3, v79), (readu8(p50, i + 5)));
        local v94 = bxor(readu8(u2, v78), readu8(u3, v76), (readu8(p50, i + 6)));
        local v95 = bxor(readu8(u2, v79), readu8(u3, v77), (readu8(p50, i + 7)));
        local v96 = bxor(readu8(u2, v80), readu8(u3, v82), (readu8(p50, i + 8)));
        local v97 = bxor(readu8(u2, v81), readu8(u3, v83), (readu8(p50, i + 9)));
        local v98 = bxor(readu8(u2, v82), readu8(u3, v80), (readu8(p50, i + 10)));
        local v99 = bxor(readu8(u2, v83), readu8(u3, v81), (readu8(p50, i + 11)));
        local v100 = bxor(readu8(u2, v84), readu8(u3, v86), (readu8(p50, i + 12)));
        local v101 = bxor(readu8(u2, v85), readu8(u3, v87), (readu8(p50, i + 13)));
        local v102 = bxor(readu8(u2, v86), readu8(u3, v84), (readu8(p50, i + 14)));
        local v103 = bxor(readu8(u2, v87), readu8(u3, v85), (readu8(p50, i + 15)));
        v72 = v88 * 256 + v93;
        v73 = v93 * 256 + v98;
        v74 = v98 * 256 + v103;
        v75 = v103 * 256 + v88;
        v76 = v92 * 256 + v97;
        v77 = v97 * 256 + v102;
        v78 = v102 * 256 + v91;
        v79 = v91 * 256 + v92;
        v80 = v96 * 256 + v101;
        v81 = v101 * 256 + v90;
        v82 = v90 * 256 + v95;
        v83 = v95 * 256 + v96;
        v84 = v100 * 256 + v89;
        v85 = v89 * 256 + v94;
        v86 = v94 * 256 + v99;
        v87 = v99 * 256 + v100;
    end;

    writeu32(p54, p55, (bxor(readu16(u1, bxor(readu8(u2, v87), readu8(u3, v85), (readu8(p50, p51 + 31))) * 512 + bxor(readu8(u2, v82), readu8(u3, v80), (readu8(p50, p51 + 26))) * 2) * 65536 + readu16(u1, bxor(readu8(u2, v77), readu8(u3, v79), (readu8(p50, p51 + 21))) * 512 + bxor(readu8(u2, v72), readu8(u3, v74), (readu8(p50, p51 + 16))) * 2), (readu32(p50, p51 + 32)))));
    writeu32(p54, p55 + 4, (bxor(readu16(u1, bxor(readu8(u2, v75), readu8(u3, v73), (readu8(p50, p51 + 19))) * 512 + bxor(readu8(u2, v86), readu8(u3, v84), (readu8(p50, p51 + 30))) * 2) * 65536 + readu16(u1, bxor(readu8(u2, v81), readu8(u3, v83), (readu8(p50, p51 + 25))) * 512 + bxor(readu8(u2, v76), readu8(u3, v78), (readu8(p50, p51 + 20))) * 2), (readu32(p50, p51 + 36)))));
    writeu32(p54, p55 + 8, (bxor(readu16(u1, bxor(readu8(u2, v79), readu8(u3, v77), (readu8(p50, p51 + 23))) * 512 + bxor(readu8(u2, v74), readu8(u3, v72), (readu8(p50, p51 + 18))) * 2) * 65536 + readu16(u1, bxor(readu8(u2, v85), readu8(u3, v87), (readu8(p50, p51 + 29))) * 512 + bxor(readu8(u2, v80), readu8(u3, v82), (readu8(p50, p51 + 24))) * 2), (readu32(p50, p51 + 40)))));
    writeu32(p54, p55 + 12, (bxor(readu16(u1, bxor(readu8(u2, v83), readu8(u3, v81), (readu8(p50, p51 + 27))) * 512 + bxor(readu8(u2, v78), readu8(u3, v76), (readu8(p50, p51 + 22))) * 2) * 65536 + readu16(u1, bxor(readu8(u2, v73), readu8(u3, v75), (readu8(p50, p51 + 17))) * 512 + bxor(readu8(u2, v84), readu8(u3, v86), (readu8(p50, p51 + 28))) * 2), (readu32(p50, p51 + 44)))));
end;

local function decryptBlock(p104, p105, p106, p107, p108, p109) -- Line: 477
    -- upvalues: u4 (copy), readu8 (copy), bxor (copy), u5 (copy), u6 (copy), writeu32 (copy)
    local v110 = bxor(readu8(u4, readu8(p106, p107) * 256 + readu8(p104, p105 + 32)), (readu8(p104, p105 + 16)));
    local v111 = bxor(readu8(u4, readu8(p106, p107 + 13) * 256 + readu8(p104, p105 + 45)), (readu8(p104, p105 + 17)));
    local v112 = bxor(readu8(u4, readu8(p106, p107 + 10) * 256 + readu8(p104, p105 + 42)), (readu8(p104, p105 + 18)));
    local v113 = bxor(readu8(u4, readu8(p106, p107 + 7) * 256 + readu8(p104, p105 + 39)), (readu8(p104, p105 + 19)));
    local v114 = bxor(readu8(u4, readu8(p106, p107 + 4) * 256 + readu8(p104, p105 + 36)), (readu8(p104, p105 + 20)));
    local v115 = bxor(readu8(u4, readu8(p106, p107 + 1) * 256 + readu8(p104, p105 + 33)), (readu8(p104, p105 + 21)));
    local v116 = bxor(readu8(u4, readu8(p106, p107 + 14) * 256 + readu8(p104, p105 + 46)), (readu8(p104, p105 + 22)));
    local v117 = bxor(readu8(u4, readu8(p106, p107 + 11) * 256 + readu8(p104, p105 + 43)), (readu8(p104, p105 + 23)));
    local v118 = bxor(readu8(u4, readu8(p106, p107 + 8) * 256 + readu8(p104, p105 + 40)), (readu8(p104, p105 + 24)));
    local v119 = bxor(readu8(u4, readu8(p106, p107 + 5) * 256 + readu8(p104, p105 + 37)), (readu8(p104, p105 + 25)));
    local v120 = bxor(readu8(u4, readu8(p106, p107 + 2) * 256 + readu8(p104, p105 + 34)), (readu8(p104, p105 + 26)));
    local v121 = bxor(readu8(u4, readu8(p106, p107 + 15) * 256 + readu8(p104, p105 + 47)), (readu8(p104, p105 + 27)));
    local v122 = bxor(readu8(u4, readu8(p106, p107 + 12) * 256 + readu8(p104, p105 + 44)), (readu8(p104, p105 + 28)));
    local v123 = bxor(readu8(u4, readu8(p106, p107 + 9) * 256 + readu8(p104, p105 + 41)), (readu8(p104, p105 + 29)));
    local v124 = bxor(readu8(u4, readu8(p106, p107 + 6) * 256 + readu8(p104, p105 + 38)), (readu8(p104, p105 + 30)));
    local v125 = bxor(readu8(u4, readu8(p106, p107 + 3) * 256 + readu8(p104, p105 + 35)), (readu8(p104, p105 + 31)));
    local v126 = v110 * 256 + v111;
    local v127 = v111 * 256 + v112;
    local v128 = v112 * 256 + v113;
    local v129 = v113 * 256 + v110;
    local v130 = v114 * 256 + v115;
    local v131 = v115 * 256 + v116;
    local v132 = v116 * 256 + v117;
    local v133 = v117 * 256 + v114;
    local v134 = v118 * 256 + v119;
    local v135 = v119 * 256 + v120;
    local v136 = v120 * 256 + v121;
    local v137 = v121 * 256 + v118;
    local v138 = v122 * 256 + v123;
    local v139 = v123 * 256 + v124;
    local v140 = v124 * 256 + v125;
    local v141 = v125 * 256 + v122;

    for i = p105, 16, -16 do
        local v142 = bxor(readu8(u4, readu8(u5, v126) * 256 + readu8(u6, v128)), (readu8(p104, i)));
        local v143 = bxor(readu8(u4, readu8(u5, v139) * 256 + readu8(u6, v141)), (readu8(p104, i + 1)));
        local v144 = bxor(readu8(u4, readu8(u5, v136) * 256 + readu8(u6, v134)), (readu8(p104, i + 2)));
        local v145 = bxor(readu8(u4, readu8(u5, v133) * 256 + readu8(u6, v131)), (readu8(p104, i + 3)));
        local v146 = bxor(readu8(u4, readu8(u5, v130) * 256 + readu8(u6, v132)), (readu8(p104, i + 4)));
        local v147 = bxor(readu8(u4, readu8(u5, v127) * 256 + readu8(u6, v129)), (readu8(p104, i + 5)));
        local v148 = bxor(readu8(u4, readu8(u5, v140) * 256 + readu8(u6, v138)), (readu8(p104, i + 6)));
        local v149 = bxor(readu8(u4, readu8(u5, v137) * 256 + readu8(u6, v135)), (readu8(p104, i + 7)));
        local v150 = bxor(readu8(u4, readu8(u5, v134) * 256 + readu8(u6, v136)), (readu8(p104, i + 8)));
        local v151 = bxor(readu8(u4, readu8(u5, v131) * 256 + readu8(u6, v133)), (readu8(p104, i + 9)));
        local v152 = bxor(readu8(u4, readu8(u5, v128) * 256 + readu8(u6, v126)), (readu8(p104, i + 10)));
        local v153 = bxor(readu8(u4, readu8(u5, v141) * 256 + readu8(u6, v139)), (readu8(p104, i + 11)));
        local v154 = bxor(readu8(u4, readu8(u5, v138) * 256 + readu8(u6, v140)), (readu8(p104, i + 12)));
        local v155 = bxor(readu8(u4, readu8(u5, v135) * 256 + readu8(u6, v137)), (readu8(p104, i + 13)));
        local v156 = bxor(readu8(u4, readu8(u5, v132) * 256 + readu8(u6, v130)), (readu8(p104, i + 14)));
        local v157 = bxor(readu8(u4, readu8(u5, v129) * 256 + readu8(u6, v127)), (readu8(p104, i + 15)));
        v126 = v142 * 256 + v143;
        v127 = v143 * 256 + v144;
        v128 = v144 * 256 + v145;
        v129 = v145 * 256 + v142;
        v130 = v146 * 256 + v147;
        v131 = v147 * 256 + v148;
        v132 = v148 * 256 + v149;
        v133 = v149 * 256 + v146;
        v134 = v150 * 256 + v151;
        v135 = v151 * 256 + v152;
        v136 = v152 * 256 + v153;
        v137 = v153 * 256 + v150;
        v138 = v154 * 256 + v155;
        v139 = v155 * 256 + v156;
        v140 = v156 * 256 + v157;
        v141 = v157 * 256 + v154;
    end;

    writeu32(p108, p109, bxor(readu8(u4, readu8(u5, v133) * 256 + readu8(u6, v131)), (readu8(p104, 3))) * 16777216 + bxor(readu8(u4, readu8(u5, v136) * 256 + readu8(u6, v134)), (readu8(p104, 2))) * 65536 + bxor(readu8(u4, readu8(u5, v139) * 256 + readu8(u6, v141)), (readu8(p104, 1))) * 256 + bxor(readu8(u4, readu8(u5, v126) * 256 + readu8(u6, v128)), (readu8(p104, 0))));
    writeu32(p108, p109 + 4, bxor(readu8(u4, readu8(u5, v137) * 256 + readu8(u6, v135)), (readu8(p104, 7))) * 16777216 + bxor(readu8(u4, readu8(u5, v140) * 256 + readu8(u6, v138)), (readu8(p104, 6))) * 65536 + bxor(readu8(u4, readu8(u5, v127) * 256 + readu8(u6, v129)), (readu8(p104, 5))) * 256 + bxor(readu8(u4, readu8(u5, v130) * 256 + readu8(u6, v132)), (readu8(p104, 4))));
    writeu32(p108, p109 + 8, bxor(readu8(u4, readu8(u5, v141) * 256 + readu8(u6, v139)), (readu8(p104, 11))) * 16777216 + bxor(readu8(u4, readu8(u5, v128) * 256 + readu8(u6, v126)), (readu8(p104, 10))) * 65536 + bxor(readu8(u4, readu8(u5, v131) * 256 + readu8(u6, v133)), (readu8(p104, 9))) * 256 + bxor(readu8(u4, readu8(u5, v134) * 256 + readu8(u6, v136)), (readu8(p104, 8))));
    writeu32(p108, p109 + 12, bxor(readu8(u4, readu8(u5, v129) * 256 + readu8(u6, v127)), (readu8(p104, 15))) * 16777216 + bxor(readu8(u4, readu8(u5, v132) * 256 + readu8(u6, v130)), (readu8(p104, 14))) * 65536 + bxor(readu8(u4, readu8(u5, v135) * 256 + readu8(u6, v137)), (readu8(p104, 13))) * 256 + bxor(readu8(u4, readu8(u5, v138) * 256 + readu8(u6, v140)), (readu8(p104, 12))));
end;

for _ = 1, 255 do
    v12 = bxor(v12, v12 * 2, v12 < 128 and 0 or 27) % 256;
    local v158 = bxor(v13, v13 * 2);
    local v159 = bxor(v158, v158 * 4);
    v13 = bxor(v159, v159 * 16) % 256;

    if v13 >= 128 then
        v13 = bxor(v13, 9);
    end;

    local v160 = bxor(v13, v13 % 128 * 2 + v13 / 128, v13 % 64 * 4 + v13 / 64, v13 % 32 * 8 + v13 / 32, v13 % 16 * 16 + v13 / 16, 99);
    writeu8(v7, v12, v160);
    writeu8(v8, v160, v12);
    writeu8(v9, v12, (gfmul(3, v12)));
    writeu8(v10, v12, (gfmul(9, v12)));
    writeu8(v11, v12, (gfmul(11, v12)));
end;

local v161 = 0;

for i = 0, 255 do
    local v162 = readu8(v7, i);
    local v163 = v162 * 256;
    local v164 = gfmul(2, v162);
    local v165 = gfmul(13, i);
    local v166 = gfmul(14, i);

    for i2 = 0, 255 do
        local v167 = readu8(v7, i2);
        writeu16(u1, v161 * 2, v163 + v167);
        writeu8(u4, v161, (readu8(v8, (bxor(i, i2)))));
        writeu8(u2, v161, (bxor(v164, (readu8(v9, v167)))));
        writeu8(u3, v161, (bxor(v162, v167)));
        writeu8(u5, v161, (bxor(v166, (readu8(v11, i2)))));
        writeu8(u6, v161, (bxor(v165, (readu8(v10, i2)))));
        v161 = v161 + 1;
    end;
end;

local function newidx(p168, p169) -- Line: 845
    return error((`{p169} cannot be assigned to`));
end;

local function tostr() -- Line: 848
    return "AesCipher";
end;

local Modes = require(script.Modes);
local Pads = require(script.Pads);

local function expandKey(p170, p171) -- Line: 854
    -- upvalues: len (copy), keySchedule (copy), create (copy)
    local v172 = typeof(p170) == "buffer";
    local v173;

    if v172 then
        v173 = len(p170);
    else
        v173 = #p170;
    end;

    return keySchedule(p170, v173, p171 or create(v173 == 32 and 240 or (v173 == 24 and 208 or (v173 == 16 and 176 or error("Key must be either 16, 24 or 32 bytes long")))), v172);
end;

local function fromKey(p174, p175, p176) -- Line: 864
    -- upvalues: len (copy), tostring (copy), sub (copy), Modes (copy), Pads (copy), encryptBlock (copy), decryptBlock (copy), fromstring (copy), create (copy), newidx (copy), tostr (copy)
    local u177 = len(p174);
    local u178 = nil;
    local u179 = nil;
    local u180 = tostring(p174);

    if u177 == 240 then
        u179 = sub(u180, 1, 32);
        u178 = 192;
    elseif u177 == 208 then
        u179 = sub(u180, 1, 24);
        u178 = 160;
    elseif u177 == 176 then
        u179 = sub(u180, 1, 16);
        u178 = 128;
    else
        error("Round keys must be either 240, 208 or 128 bytes long");
    end;

    local u181 = p174;
    local u182 = p175 or Modes.ECB;
    local FwdMode = u182.FwdMode;
    local InvMode = u182.InvMode;
    local u183 = u182.SegmentSize or 16;
    local u184 = p176 or Pads.Pkcs7;
    local Pad = u184.Pad;
    local Unpad = u184.Unpad;
    local u185 = newproxy(true);
    local v186 = getmetatable(u185);

    local function encp(p187, p188, p189, p190) -- Line: 894
        -- upvalues: encryptBlock (ref), u181 (ref), u178 (ref)
        encryptBlock(u181, u178, p187, p188, p189, p190);
    end;

    local function decp(p191, p192, p193, p194) -- Line: 897
        -- upvalues: decryptBlock (ref), u181 (ref), u178 (ref)
        decryptBlock(u181, u178, p191, p192, p193, p194);
    end;

    local function enc(p195, p196, p197, ...) -- Line: 900
        -- upvalues: fromstring (ref), u185 (copy), u178 (ref), Pad (copy), u183 (copy), FwdMode (ref), encp (copy), decp (copy), u184 (ref), u182 (ref), create (ref)
        if typeof(p196) ~= "buffer" then
            if typeof(p196) == "string" then
                p196 = fromstring(p196);
            else
                p196 = error((`Unable to cast {typeof(p196)} to buffer`));
            end;
        end;

        if typeof(p197) ~= "buffer" then
            p197 = false;
        end;

        if p195 ~= u185 then
            return p195:Encrypt(p196, p197, ...);
        end;

        if not u178 then
            error("AesCipher object\'s already destroyed");

            return create(0);
        end;

        local v198 = Pad(p196, p197, u183);

        if u184.Overwrite ~= false then
            p196 = v198;
        end;

        FwdMode(encp, decp, p196, v198, u182, ...);

        return v198;
    end;

    local function encb(p199, p200, p201, p202, p203) -- Line: 917
        -- upvalues: u185 (copy), u178 (ref), encryptBlock (ref), u181 (ref)
        if p199 ~= u185 then
            p199:EncryptBlock(p200, p201, p202, p203);

            return;
        end;

        if u178 then
            encryptBlock(u181, u178, p200, p201, p202 or p200, p203 or p201);

            return;
        end;

        error("AesCipher object\'s already destroyed");
    end;

    local function dec(p204, p205, p206, ...) -- Line: 926
        -- upvalues: fromstring (ref), u185 (copy), u178 (ref), u184 (ref), create (ref), len (ref), InvMode (ref), encp (copy), decp (copy), u182 (ref), Unpad (copy), u183 (copy)
        if typeof(p205) ~= "buffer" then
            if typeof(p205) == "string" then
                p205 = fromstring(p205);
            else
                p205 = error((`Unable to cast {typeof(p205)} to buffer`));
            end;
        end;

        if typeof(p206) ~= "buffer" then
            p206 = false;
        end;

        if p204 ~= u185 then
            return p204:Decrypt(p205, p206, ...);
        end;

        if not u178 then
            error("AesCipher object\'s already destroyed");

            return create(0);
        end;

        local Overwrite = u184.Overwrite;
        local v207;

        if Overwrite == nil then
            v207 = create(len(p205));
        elseif Overwrite then
            v207 = p205;
        else
            v207 = p206 or create(len(p205));
        end;

        InvMode(encp, decp, p205, v207, u182, ...);

        return Unpad(v207, p206, u183);
    end;

    local function decb(p208, p209, p210, p211, p212) -- Line: 947
        -- upvalues: u185 (copy), u178 (ref), decryptBlock (ref), u181 (ref)
        if p208 ~= u185 then
            p208:DecryptBlock(p209, p210, p211, p212);

            return;
        end;

        if u178 then
            decryptBlock(u181, u178, p209, p210, p211 or p209, p212 or p210);

            return;
        end;

        error("AesCipher object\'s already destroyed");
    end;

    local function destroy(p213) -- Line: 956
        -- upvalues: u185 (copy), u178 (ref), u180 (ref), u181 (ref), FwdMode (ref), InvMode (ref), u182 (ref), u184 (ref), u179 (ref), u177 (ref)
        if p213 ~= u185 then
            p213:Destroy();

            return;
        end;

        if not u178 then
            error("AesCipher object\'s already destroyed");

            return;
        end;

        u180 = nil;
        u181 = nil;
        u178 = nil;
        FwdMode = nil;
        InvMode = nil;
        u182 = nil;
        u184 = nil;
        u179 = nil;
        u177 = nil;
    end;

    function v186.__index(p214, p215) -- Line: 967
        -- upvalues: enc (copy), dec (copy), encb (copy), decb (copy), destroy (copy), u178 (ref), u179 (ref), u180 (ref), u182 (ref), u184 (ref), u177 (ref)
        if p215 == "Encrypt" then
            return enc;
        end;

        if p215 == "Decrypt" then
            return dec;
        end;

        if p215 == "EncryptBlock" then
            return encb;
        end;

        if p215 == "DecryptBlock" then
            return decb;
        end;

        if p215 == "Destroy" then
            return destroy;
        end;

        if not u178 then
            return error("AesCipher object\'s already destroyed");
        end;

        if p215 == "Key" then
            return u179;
        end;

        if p215 == "RoundKeys" then
            return u180;
        end;

        if p215 == "Mode" then
            return u182;
        end;

        if p215 == "Padding" then
            return u184;
        end;

        if p215 == "Length" then
            return u177;
        end;

        return error((`{p215} is not a valid member of AesCipher`));
    end;

    v186.__newindex = newidx;
    v186.__tostring = tostr;

    function v186.__len() -- Line: 985
        -- upvalues: u177 (ref)
        return u177 or error("AesCipher object\'s destroyed");
    end;

    v186.__metatable = "AesCipher object: Metatable\'s locked";

    return u185;
end;

return table.freeze({
    new = function(p216, p217, p218) -- Line: 993, Name: new
        -- upvalues: fromKey (copy), expandKey (copy)
        return fromKey(expandKey(p216), p217, p218);
    end,

    expandKey = expandKey,
    fromKey = fromKey,
    modes = Modes,
    pads = Pads
});