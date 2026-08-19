-- Decompiled with Potassium's decompiler.

require(game.ReplicatedStorage.UserGenerated.IO.Crypto.Hash);
local u1 = table.create(80, 0);
local u2 = table.create(80, 0);
local u3 = { 1116352408, 1899447441, 3049323471, 3921009573, 961987163, 1508970993, 2453635748, 2870763221, 3624381080, 310598401, 607225278, 1426881987, 1925078388, 2162078206, 2614888103, 3248222580, 3835390401, 4022224774, 264347078, 604807628, 770255983, 1249150122, 1555081692, 1996064986, 2554220882, 2821834349, 2952996808, 3210313671, 3336571891, 3584528711, 113926993, 338241895, 666307205, 773529912, 1294757372, 1396182291, 1695183700, 1986661051, 2177026350, 2456956037, 2730485921, 2820302411, 3259730800, 3345764771, 3516065817, 3600352804, 4094571909, 275423344, 430227734, 506948616, 659060556, 883997877, 958139571, 1322822218, 1537002063, 1747873779, 1955562222, 2024104815, 2227730452, 2361852424, 2428436474, 2756734187, 3204031479, 3329325298, 3391569614, 3515267271, 3940187606, 4118630271, 116418474, 174292421, 289380356, 460393269, 685471733, 852142971, 1017036298, 1126000580, 1288033470, 1501505948, 1607167915, 1816402316 };
local u4 = { 3609767458, 602891725, 3964484399, 2173295548, 4081628472, 3053834265, 2937671579, 3664609560, 2734883394, 1164996542, 1323610764, 3590304994, 4068182383, 991336113, 633803317, 3479774868, 2666613458, 944711139, 2341262773, 2007800933, 1495990901, 1856431235, 3175218132, 2198950837, 3999719339, 766784016, 2566594879, 3203337956, 1034457026, 2466948901, 3758326383, 168717936, 1188179964, 1546045734, 1522805485, 2643833823, 2343527390, 1014477480, 1206759142, 344077627, 1290863460, 3158454273, 3505952657, 106217008, 3606008344, 1432725776, 1467031594, 851169720, 3100823752, 1363258195, 3750685593, 3785050280, 3318307427, 3812723403, 2003034995, 3602036899, 1575990012, 1125592928, 2716904306, 442776044, 593698344, 3733110249, 2999351573, 3815920427, 3928383900, 566280711, 3454069534, 4000239992, 1914138554, 2731055270, 3203993006, 320620315, 587496836, 1086792851, 365543100, 2618297676, 3409855158, 4234509866, 987167468, 1246189591 };

function lil_sig0(p5, p6)
    local v7 = bit32.rshift(p5, 1);
    local v8 = bit32.lshift(p6, 31);
    local v9 = bit32.rshift(p5, 8);
    local v10 = bit32.lshift(p6, 24);
    local v11 = bit32.rshift(p5, 7);
    local v12 = bit32.bxor(v7, v8, v9, v10, v11);
    local v13 = bit32.rshift(p6, 1);
    local v14 = bit32.lshift(p5, 31);
    local v15 = bit32.rshift(p6, 8);
    local v16 = bit32.lshift(p5, 24);
    local v17 = bit32.rshift(p6, 7);
    local v18 = bit32.lshift(p5, 25);

    return v12, bit32.bxor(v13, v14, v15, v16, v17, v18);
end;

function lil_sig1(p19, p20)
    local v21 = bit32.rshift(p19, 19);
    local v22 = bit32.lshift(p20, 13);
    local v23 = bit32.lshift(p19, 3);
    local v24 = bit32.rshift(p20, 29);
    local v25 = bit32.rshift(p19, 6);
    local v26 = bit32.bxor(v21, v22, v23, v24, v25);
    local v27 = bit32.rshift(p20, 19);
    local v28 = bit32.lshift(p19, 13);
    local v29 = bit32.lshift(p20, 3);
    local v30 = bit32.rshift(p19, 29);
    local v31 = bit32.rshift(p20, 6);
    local v32 = bit32.lshift(p19, 26);

    return v26, bit32.bxor(v27, v28, v29, v30, v31, v32);
end;

function big_sig0(p33, p34)
    local v35 = bit32.rshift(p33, 28);
    local v36 = bit32.lshift(p34, 4);
    local v37 = bit32.lshift(p33, 30);
    local v38 = bit32.rshift(p34, 2);
    local v39 = bit32.lshift(p33, 25);
    local v40 = bit32.rshift(p34, 7);
    local v41 = bit32.bxor(v35, v36, v37, v38, v39, v40);
    local v42 = bit32.rshift(p34, 28);
    local v43 = bit32.lshift(p33, 4);
    local v44 = bit32.lshift(p34, 30);
    local v45 = bit32.rshift(p33, 2);
    local v46 = bit32.lshift(p34, 25);
    local v47 = bit32.rshift(p33, 7);

    return v41, bit32.bxor(v42, v43, v44, v45, v46, v47);
end;

function big_sig1(p48, p49)
    local v50 = bit32.rshift(p48, 14);
    local v51 = bit32.lshift(p49, 18);
    local v52 = bit32.rshift(p48, 18);
    local v53 = bit32.lshift(p49, 14);
    local v54 = bit32.lshift(p48, 23);
    local v55 = bit32.rshift(p49, 9);
    local v56 = bit32.bxor(v50, v51, v52, v53, v54, v55);
    local v57 = bit32.rshift(p49, 14);
    local v58 = bit32.lshift(p48, 18);
    local v59 = bit32.rshift(p49, 18);
    local v60 = bit32.lshift(p48, 14);
    local v61 = bit32.lshift(p49, 23);
    local v62 = bit32.rshift(p48, 9);

    return v56, bit32.bxor(v57, v58, v59, v60, v61, v62);
end;

function processBlocks(p63, p64, p65, p66, p67)
    -- upvalues: u1 (copy), u2 (copy), u4 (copy), u3 (copy)
    local v68 = u1;
    local v69 = u2;
    local v70 = p63[1];
    local v71 = p63[2];
    local v72 = p63[3];
    local v73 = p63[4];
    local v74 = p63[5];
    local v75 = p63[6];
    local v76 = p63[7];
    local v77 = p63[8];
    local v78 = p64[1];
    local v79 = p64[2];
    local v80 = p64[3];
    local v81 = p64[4];
    local v82 = p64[5];
    local v83 = p64[6];
    local v84 = p64[7];
    local v85 = p64[8];

    for i = p66, p67, 128 do
        local _ = i;

        for i2 = 1, 16 do
            local v86, v87, v88, v89, v90, v91, v92, v93 = string.byte(p65, i, i + 7);
            local v94 = bit32.lshift(v86, 24);
            local v95 = bit32.lshift(v87, 16);
            local v96 = bit32.lshift(v88, 8);
            v68[i2] = bit32.bor(v94, v95, v96, v89);
            local v97 = bit32.lshift(v90, 24);
            local v98 = bit32.lshift(v91, 16);
            local v99 = bit32.lshift(v92, 8);
            v69[i2] = bit32.bor(v97, v98, v99, v93);
            local i = i + 8;
        end;

        for i2 = 17, 80 do
            local v100, v101 = lil_sig0(v68[i2 - 15], v69[i2 - 15]);
            local v102, v103 = lil_sig1(v68[i2 - 2], v69[i2 - 2]);
            local v104 = v69[i2 - 16] + v101 + v69[i2 - 7] + v103;
            v69[i2] = bit32.bor(v104, 0);
            v68[i2] = v68[i2 - 16] + v100 + v68[i2 - 7] + v102 + v104 // 4294967296;
        end;

        local v105 = v77;
        local v106 = v81;
        local v107 = v80;
        local v108 = v75;
        local v109 = v85;
        local v110 = v73;
        local v111 = v71;
        local v112 = v79;
        local v113 = v72;
        local v114 = v74;
        local v115 = v83;
        local v116 = v76;
        local v117 = v84;
        local v118 = v82;
        local v119 = v70;
        local v120 = v78;

        for i2 = 1, 80 do
            local v121, v122 = big_sig0(v70, v78);
            local v123, v124 = big_sig1(v74, v82);
            local v125 = bit32.band(v82, v83);
            local v126 = bit32.band(-1 - v82, v84);
            local v127 = v85 + v124 + bit32.bor(v125, v126, 0) + u4[i2] + v69[i2];
            local v128 = bit32.band(v74, v75);
            local v129 = bit32.band(-1 - v74, v76);
            local v130 = v77 + v123 + bit32.bor(v128, v129, 0) + u3[i2] + v68[i2] + v127 // 4294967296;
            local v131 = bit32.bor(v127, 0);
            local v132 = v122 + bit32.band(v80, v79);
            local v133 = bit32.bxor(v80, v79);
            local v134 = v132 + bit32.band(v78, v133);
            local v135 = v121 + bit32.band(v72, v71);
            local v136 = bit32.bxor(v72, v71);
            local v137 = v135 + bit32.band(v70, v136);
            local v138 = v131 + v81;
            local v139 = bit32.bor(v138, 0);
            local v140 = v131 + v134;
            local v141 = bit32.bor(v140, 0);
            v85 = v84;
            v84 = v83;
            v83 = v82;
            v82 = v139;
            v77 = v76;
            v76 = v75;
            v75 = v74;
            v74 = v130 + v73 + v138 // 4294967296;
            v81 = v80;
            v80 = v79;
            v79 = v78;
            v78 = v141;
            v73 = v72;
            v72 = v71;
            v71 = v70;
            v70 = v130 + v137 + v140 // 4294967296;
        end;

        local v142 = v120 + v78;
        v70 = bit32.bor(v119 + v70 + v142 // 4294967296, 0);
        v78 = bit32.bor(v142, 0);
        local v143 = v112 + v79;
        v71 = bit32.bor(v111 + v71 + v143 // 4294967296, 0);
        v79 = bit32.bor(v143, 0);
        local v144 = v107 + v80;
        v72 = bit32.bor(v113 + v72 + v144 // 4294967296, 0);
        v80 = bit32.bor(v144, 0);
        local v145 = v106 + v81;
        v73 = bit32.bor(v110 + v73 + v145 // 4294967296, 0);
        v81 = bit32.bor(v145, 0);
        local v146 = v118 + v82;
        v74 = bit32.bor(v114 + v74 + v146 // 4294967296, 0);
        v82 = bit32.bor(v146, 0);
        local v147 = v115 + v83;
        v75 = bit32.bor(v108 + v75 + v147 // 4294967296, 0);
        v83 = bit32.bor(v147, 0);
        local v148 = v117 + v84;
        v76 = bit32.bor(v116 + v76 + v148 // 4294967296, 0);
        v84 = bit32.bor(v148, 0);
        local v149 = v109 + v85;
        v77 = bit32.bor(v105 + v77 + v149 // 4294967296, 0);
        v85 = bit32.bor(v149, 0);
    end;

    p63[1] = v70;
    p64[1] = v78;
    p63[2] = v71;
    p64[2] = v79;
    p63[3] = v72;
    p64[3] = v80;
    p63[4] = v73;
    p64[4] = v81;
    p63[5] = v74;
    p64[5] = v82;
    p63[6] = v75;
    p64[6] = v83;
    p63[7] = v76;
    p64[7] = v84;
    p63[8] = v77;
    p64[8] = v85;
end;

function sha384(p150)
    local v151 = { 3418070365, 1654270250, 2438529370, 355462360, 1731405415, 2394180231, 3675008525, 1203062813 };
    local v152 = { 3238371032, 914150663, 812702999, 4144912697, 4290775857, 1750603025, 1694076839, 3204075428 };
    local v153 = #p150;

    if v153 > 1125899906842624 then
        error("cannot calculate the SHA-384 hash of a string longer than 2^50 bytes", 2);
    end;

    local v154 = v153 % 128;

    if v153 >= 128 then
        processBlocks(v151, v152, p150, 1, v153 - v154);
    end;

    local v155 = bit32.band(v154 + 64, 4294963200);
    local v156 = {
        v154 == 0 and "" or string.sub(p150, -v154),
        "\128",
        string.rep("\0", (v155 - v154 - 17) % 128),
        string.pack(">L", v153 * 8 / 4294967296),
        string.pack(">L", (bit32.bor(v153 * 8)))
    };
    local v157 = table.concat(v156);
    processBlocks(v151, v152, v157, 1, #v157);
    local v158 = buffer.create(48);

    for i = 1, 6 do
        local v159 = bit32.byteswap(v151[i]);
        buffer.writeu32(v158, (i - 1) * 8, v159);
        local v160 = bit32.byteswap(v152[i]);
        buffer.writeu32(v158, (i - 1) * 8 + 4, v160);
    end;

    return v158;
end;

local v163 = {
    Name = "SHA-384",
    BlockSize = 128,
    OutputSize = 48,

    Digest = function(p161) -- Line: 348, Name: Digest
        return buffer.tostring(sha384(p161));
    end,

    DigestBuffer = function(p162) -- Line: 351, Name: DigestBuffer
        return sha384(buffer.tostring(p162));
    end,

    DigestToBuffer = sha384
};
table.freeze(v163);

return v163;