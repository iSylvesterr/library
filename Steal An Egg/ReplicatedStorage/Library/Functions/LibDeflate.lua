-- Decompiled with Potassium's decompiler.

local u1 = assert;
local u2 = error;
local u3 = pairs;
local byte = string.byte;
local char = string.char;
local find = string.find;
local gsub = string.gsub;
local sub = string.sub;
local concat = table.concat;
local sort = table.sort;
local u4 = tostring;
local u5 = type;
local u6 = {};
local u7 = {};
local u8 = {};
local u9 = {};
local u10 = {};
local u11 = {};
local u12 = {};
local u13 = {};
local u14 = {};
local u15 = { 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 0 };
local u16 = nil;
local u17 = { 16, 17, 18, 0, 8, 7, 9, 6, 10, 5, 11, 4, 12, 3, 13, 2, 14, 1, 15 };
local u18 = nil;
local u19 = {
    _VERSION = "1.0.2-release",
    _MAJOR = "LibDeflate",
    _MINOR = 3,
    _COPYRIGHT = "LibDeflate 1.0.2-release Copyright (C) 2018-2021 Haoqian He. Licensed under the zlib License"
};
local u20 = nil;
local u21 = nil;
local u22 = nil;
local u23 = { 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 15, 17, 19, 23, 27, 31, 35, 43, 51, 59, 67, 83, 99, 115, 131, 163, 195, 227, 258 };
local u24 = { 1, 2, 3, 4, 5, 7, 9, 13, 17, 25, 33, 49, 65, 97, 129, 193, 257, 385, 513, 769, 1025, 1537, 2049, 3073, 4097, 6145, 8193, 12289, 16385, 24577 };
local u25 = nil;
local u26 = nil;
local u27 = { 0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13 };

for i = 0, 255 do
    u6[i] = char(i);
end;

local v28 = 1;

for i = 0, 32 do
    u7[i] = v28;
    v28 = v28 * 2;
end;

for i = 1, 9 do
    u8[i] = {};

    for i2 = 0, u7[i + 1] - 1 do
        local v29 = i2;
        local v30 = 0;

        for _ = 1, i do
            local v31 = v30 - v30 % 2 + ((v30 % 2 == 1 or i2 % 2 == 1) and 1 or 0);
            local i2 = (i2 - i2 % 2) / 2;
            v30 = v31 * 2;
        end;

        u8[i][v29] = (v30 - v30 % 2) / 2;
    end;
end;

local v32 = 1;
local v33 = 18;
local v34 = 16;
local v35 = 265;

for i = 3, 258 do
    if i <= 10 then
        u10[i] = i + 254;
        u11[i] = 0;
    elseif i == 258 then
        u10[i] = 285;
        u11[i] = 0;
    else
        if v33 < i then
            v33 = v33 + v34;
            v34 = v34 * 2;
            v35 = v35 + 4;
            v32 = v32 + 1;
        end;

        local v36 = i - v33 - 1 + v34 / 2;
        u10[i] = (v36 - v36 % (v34 / 8)) / (v34 / 8) + v35;
        u11[i] = v32;
        u9[i] = v36 % (v34 / 8);
    end;
end;

u12[1] = 0;
u12[2] = 1;
u13[1] = 0;
u13[2] = 0;
local v37 = 4;
local v38 = 3;
local v39 = 2;
local v40 = 0;

for i = 3, 256 do
    if v37 < i then
        v38 = v38 * 2;
        v37 = v37 * 2;
        v39 = v39 + 2;
        v40 = v40 + 1;
    end;

    u12[i] = i <= v38 and v39 and v39 or v39 + 1;
    u13[i] = v40 < 0 and 0 or v40;

    if v37 >= 8 then
        u14[i] = (i - v37 / 2 - 1) % (v37 / 4);
    end;
end;

function u19.Adler32(p41, p42) -- Line: 459
    -- upvalues: u5 (copy), u2 (copy), byte (copy)
    if u5(p42) ~= "string" then
        u2(("Usage: LibDeflate:Adler32(str): \'str\' - string expected got \'%s\'."):format((u5(p42))), 2);
    end;

    local v43 = #p42;
    local v44 = 1;
    local v45 = 1;
    local v46 = 0;

    while v44 <= v43 - 15 do
        local v47, v48, v49, v50, v51, v52, v53, v54, v55, v56, v57, v58, v59, v60, v61, v62 = byte(p42, v44, v44 + 15);
        v46 = (v46 + v45 * 16 + v47 * 16 + 15 * v48 + 14 * v49 + 13 * v50 + 12 * v51 + 11 * v52 + 10 * v53 + 9 * v54 + 8 * v55 + 7 * v56 + 6 * v57 + 5 * v58 + 4 * v59 + 3 * v60 + 2 * v61 + v62) % 65521;
        v45 = (v45 + v47 + v48 + v49 + v50 + v51 + v52 + v53 + v54 + v55 + v56 + v57 + v58 + v59 + v60 + v61 + v62) % 65521;
        v44 = v44 + 16;
    end;

    while v44 <= v43 do
        v45 = (v45 + byte(p42, v44, v44)) % 65521;
        v46 = (v46 + v45) % 65521;
        v44 = v44 + 1;
    end;

    return (v46 * 65536 + v45) % 4294967296;
end;

local function IsEqualAdler32(p63, p64) -- Line: 517
    return p63 % 4294967296 == p64 % 4294967296;
end;

function u19.CreateDictionary(p65, p66, p67, p68) -- Line: 563
    -- upvalues: u5 (copy), u2 (copy), byte (copy)
    if u5(p66) ~= "string" then
        u2(("Usage: LibDeflate:CreateDictionary(str, strlen, adler32): \'str\' - string expected got \'%s\'."):format((u5(p66))), 2);
    end;

    if u5(p67) ~= "number" then
        u2(("Usage: LibDeflate:CreateDictionary(str, strlen, adler32): \'strlen\' - number expected got \'%s\'."):format((u5(p67))), 2);
    end;

    if u5(p68) ~= "number" then
        u2(("Usage: LibDeflate:CreateDictionary(str, strlen, adler32): \'adler32\' - number expected got \'%s\'."):format((u5(p68))), 2);
    end;

    if p67 ~= #p66 then
        u2(("Usage: LibDeflate:CreateDictionary(str, strlen, adler32): \'strlen\' does not match the actual length of \'str\'. \'strlen\': %u, \'#str\': %u . Please check if \'str\' is modified unintentionally."):format(p67, #p66));
    end;

    if p67 == 0 then
        u2(
            "Usage: LibDeflate:CreateDictionary(str, strlen, adler32): \'str\' - Empty string is not allowed.",
            2
        );
    end;

    if p67 > 32768 then
        u2(("Usage: LibDeflate:CreateDictionary(str, strlen, adler32): \'str\' - string longer than 32768 bytes is not allowed. Got %d bytes."):format(p67), 2);
    end;

    local v69 = p65:Adler32(p66);

    if p68 % 4294967296 ~= v69 % 4294967296 then
        u2(("Usage: LibDeflate:CreateDictionary(str, strlen, adler32): \'adler32\' does not match the actual adler32 of \'str\'. \'adler32\': %u, \'Adler32(str)\': %u . Please check if \'str\' is modified unintentionally."):format(p68, v69));
    end;

    local v70 = {
        adler32 = p68,
        hash_tables = {},
        string_table = {},
        strlen = p67
    };
    local string_table = v70.string_table;
    local hash_tables = v70.hash_tables;
    string_table[1] = byte(p66, 1, 1);
    string_table[2] = byte(p66, 2, 2);

    if p67 >= 3 then
        local v71 = string_table[1] * 256 + string_table[2];
        local v72 = 1;

        while v72 <= p67 - 2 - 3 do
            local v73, v74, v75, v76 = byte(p66, v72 + 2, v72 + 5);
            string_table[v72 + 2] = v73;
            string_table[v72 + 3] = v74;
            string_table[v72 + 4] = v75;
            string_table[v72 + 5] = v76;
            local v77 = (v71 * 256 + v73) % 16777216;
            local v78 = hash_tables[v77];

            if not v78 then
                v78 = {};
                hash_tables[v77] = v78;
            end;

            v78[#v78 + 1] = v72 - p67;
            local v79 = v72 + 1;
            local v80 = (v77 * 256 + v74) % 16777216;
            local v81 = hash_tables[v80];

            if not v81 then
                v81 = {};
                hash_tables[v80] = v81;
            end;

            v81[#v81 + 1] = v79 - p67;
            local v82 = v79 + 1;
            local v83 = (v80 * 256 + v75) % 16777216;
            local v84 = hash_tables[v83];

            if not v84 then
                v84 = {};
                hash_tables[v83] = v84;
            end;

            v84[#v84 + 1] = v82 - p67;
            local v85 = v82 + 1;
            v71 = (v83 * 256 + v76) % 16777216;
            local v86 = hash_tables[v71];

            if not v86 then
                v86 = {};
                hash_tables[v71] = v86;
            end;

            v86[#v86 + 1] = v85 - p67;
            v72 = v85 + 1;
        end;

        while v72 <= p67 - 2 do
            local v87 = byte(p66, v72 + 2);
            string_table[v72 + 2] = v87;
            v71 = (v71 * 256 + v87) % 16777216;
            local v88 = hash_tables[v71];

            if not v88 then
                v88 = {};
                hash_tables[v71] = v88;
            end;

            v88[#v88 + 1] = v72 - p67;
            v72 = v72 + 1;
        end;
    end;

    return v70;
end;

local function IsValidDictionary(p89) -- Line: 697
    -- upvalues: u5 (copy)
    if u5(p89) ~= "table" then
        return false, ("\'dictionary\' - table expected got \'%s\'."):format((u5(p89)));
    end;

    if u5(p89.adler32) == "number" and (u5(p89.string_table) == "table" and (u5(p89.strlen) == "number" and (p89.strlen > 0 and (p89.strlen <= 32768 and (p89.strlen == #p89.string_table and u5(p89.hash_tables) == "table"))))) then
        return true, "";
    end;

    return false, ("\'dictionary\' - corrupted dictionary."):format((u5(p89)));
end;

local u90 = {
    [0] = { false, nil, 0, 0, 0 },
    [1] = { false, nil, 4, 8, 4 },
    [2] = { false, nil, 5, 18, 8 },
    [3] = { false, nil, 6, 32, 32 },
    [4] = { true, 4, 4, 16, 16 },
    [5] = { true, 8, 16, 32, 32 },
    [6] = { true, 8, 16, 128, 128 },
    [7] = { true, 8, 32, 128, 256 },
    [8] = { true, 32, 128, 258, 1024 },
    [9] = { true, 32, 258, 258, 4096 }
};

local function IsValidArguments(p91, p92, p93, p94, p95) -- Line: 777
    -- upvalues: u5 (copy), IsValidDictionary (copy), u3 (copy), u90 (copy), u4 (copy)
    if u5(p91) ~= "string" then
        return false, ("\'str\' - string expected got \'%s\'."):format((u5(p91)));
    end;

    if p92 then
        local v96, v97 = IsValidDictionary(p93);

        if not v96 then
            return false, v97;
        end;
    end;

    if p94 then
        local v98 = u5(p95);

        if v98 ~= "nil" and v98 ~= "table" then
            return false, ("\'configs\' - nil or table expected got \'%s\'."):format((u5(p95)));
        end;

        if v98 == "table" then
            for i, v in u3(p95) do
                if i ~= "level" and i ~= "strategy" then
                    return false, ("\'configs\' - unsupported table key in the configs: \'%s\'."):format(i);
                end;

                if i == "level" and not u90[v] then
                    return false, ("\'configs\' - unsupported \'level\': %s."):format((u4(v)));
                end;

                if i == "strategy" and (v ~= "fixed" and (v ~= "huffman_only" and v ~= "dynamic")) then
                    return false, ("\'configs\' - unsupported \'strategy\': \'%s\'."):format((u4(v)));
                end;
            end;
        end;
    end;

    return true, "";
end;

local function CreateWriter() -- Line: 829
    -- upvalues: u7 (copy), u6 (copy), char (copy), concat (copy)
    local u99 = 0;
    local u100 = 0;
    local u101 = 0;
    local u102 = 0;
    local u103 = {};
    local u104 = {};

    return function(p105, p106) -- Line: 842, Name: WriteBits
        -- upvalues: u100 (ref), u7 (ref), u101 (ref), u102 (ref), u99 (ref), u103 (ref), u6 (ref)
        u100 = u100 + p105 * u7[u101];
        u101 = u101 + p106;
        u102 = u102 + p106;

        if u101 >= 32 then
            u99 = u99 + 1;
            u103[u99] = u6[u100 % 256] .. u6[(u100 - u100 % 256) / 256 % 256] .. u6[(u100 - u100 % 65536) / 65536 % 256] .. u6[(u100 - u100 % 16777216) / 16777216 % 256];
            local v107 = u7[32 - u101 + p106];
            u100 = (p105 - p105 % v107) / v107;
            u101 = u101 - 32;
        end;
    end, function(p108) -- Line: 862, Name: WriteString
        -- upvalues: u101 (ref), u99 (ref), u103 (ref), u100 (ref), char (ref), u102 (ref)
        for _ = 1, u101, 8 do
            u99 = u99 + 1;
            u103[u99] = char(u100 % 256);
            u100 = (u100 - u100 % 256) / 256;
        end;

        u101 = 0;
        u99 = u99 + 1;
        u103[u99] = p108;
        u102 = u102 + #p108 * 8;
    end, function(p109) -- Line: 881, Name: FlushWriter
        -- upvalues: u102 (ref), u101 (ref), u100 (ref), u7 (ref), u99 (ref), u103 (ref), u6 (ref), concat (ref), u104 (copy)
        if p109 == 3 then
            return u102;
        end;

        if p109 == 1 or p109 == 2 then
            local v110 = (8 - u101 % 8) % 8;

            if u101 > 0 then
                u100 = u100 - u7[u101] + u7[u101 + v110];

                for _ = 1, u101, 8 do
                    u99 = u99 + 1;
                    u103[u99] = u6[u100 % 256];
                    u100 = (u100 - u100 % 256) / 256;
                end;

                u100 = 0;
                u101 = 0;
            end;

            if p109 == 2 then
                u102 = u102 + v110;

                return u102;
            end;
        end;

        local v111 = concat(u103);
        u103 = {};
        u99 = 0;
        u104[#u104 + 1] = v111;

        if p109 == 0 then
            return u102;
        end;

        return u102, concat(u104);
    end;
end;

local function MinHeapPush(p112, p113, p114) -- Line: 934
    local v115 = p114 + 1;
    p112[v115] = p113;
    local v116 = (v115 - v115 % 2) / 2;

    while v116 >= 1 and p113[1] < p112[v116][1] do
        local v117 = p112[v116];
        p112[v116] = p113;
        p112[v115] = v117;
        v115 = v116;
        v116 = (v116 - v116 % 2) / 2;
    end;
end;

local function MinHeapPop(p118, p119) -- Line: 955
    local v120 = p118[1];
    local v121 = p118[p119];
    local v122 = v121[1];
    p118[1] = v121;
    p118[p119] = v120;
    local v123 = p119 - 1;
    local v124 = 1;
    local v125 = v124 * 2;
    local v126 = v125 + 1;

    while v125 <= v123 do
        local v127 = p118[v125];
        local v128;

        if v126 <= v123 and p118[v126][1] < v127[1] then
            local v129 = p118[v126];

            if v129[1] >= v122 then
                break;
            end;

            p118[v126] = v121;
            p118[v124] = v129;
            v128 = v126 * 2;
            v125 = v126;
            v126 = v128 + 1;
        else
            if v127[1] >= v122 then
                break;
            end;

            p118[v125] = v121;
            p118[v124] = v127;
            v128 = v125 * 2;
            v126 = v128 + 1;
        end;

        v124 = v125;
        v125 = v128;
    end;

    return v120;
end;

local function GetHuffmanCodeFromBitlen(p130, p131, p132, p133) -- Line: 1004
    -- upvalues: u8 (copy)
    local v134 = 0;
    local v135 = {};
    local v136 = {};

    for i = 1, p133 do
        v134 = (v134 + (p130[i - 1] or 0)) * 2;
        v135[i] = v134;
    end;

    for i = 0, p132 do
        local v137 = p131[i];

        if v137 then
            local v138 = v135[v137];
            v135[v137] = v138 + 1;

            if v137 <= 9 then
                v136[i] = u8[v137][v138];
            else
                local v139 = 0;

                for _ = 1, v137 do
                    local v140 = v139 - v139 % 2 + ((v139 % 2 == 1 or v138 % 2 == 1) and 1 or 0);
                    v138 = (v138 - v138 % 2) / 2;
                    v139 = v140 * 2;
                end;

                v136[i] = (v139 - v139 % 2) / 2;
            end;
        end;
    end;

    return v136;
end;

local function SortByFirstThenSecond(p141, p142) -- Line: 1041
    local v143;

    if p141[1] < p142[1] then
        v143 = true;
    elseif p141[1] == p142[1] then
        v143 = p141[2] < p142[2];
    else
        v143 = false;
    end;

    return v143;
end;

local function GetHuffmanBitlenAndCode(p144, p145, p146) -- Line: 1056
    -- upvalues: u3 (copy), sort (copy), SortByFirstThenSecond (copy), MinHeapPop (copy), MinHeapPush (copy), GetHuffmanCodeFromBitlen (copy)
    local v147 = 0;
    local v148 = {};
    local v149 = {};
    local v150 = {};
    local v151 = -1;
    local v152 = {};
    local v153 = {};

    for i, v in u3(p144) do
        v147 = v147 + 1;
        v148[v147] = { v, i };
    end;

    if v147 == 0 then
        return {}, {}, -1;
    end;

    if v147 == 1 then
        local v154 = v148[1][2];
        v150[v154] = 1;
        v153[v154] = 0;

        return v150, v153, v154;
    end;

    sort(v148, SortByFirstThenSecond);

    for i = 1, v147 do
        v149[i] = v148[i];
    end;

    while v147 > 1 do
        local v155 = MinHeapPop(v149, v147);
        local v156 = v147 - 1;
        local v157 = MinHeapPop(v149, v156);
        local v158 = v156 - 1;
        MinHeapPush(v149, {
            v155[1] + v157[1],
            -1,
            v155,
            v157
        }, v158);
        v147 = v158 + 1;
    end;

    local v159 = {
        v149[1],
        0,
        0,
        0
    };
    v149[1][1] = 0;
    local v160 = 1;
    local v161 = 1;
    local v162 = 0;

    while v160 <= v161 do
        local v163 = v159[v160];
        local v164 = v163[1];
        local v165 = v163[2];
        local v166 = v163[3];
        local v167 = v163[4];

        if v166 then
            v161 = v161 + 1;
            v159[v161] = v166;
            v166[1] = v164 + 1;
        end;

        if v167 then
            v161 = v161 + 1;
            v159[v161] = v167;
            v167[1] = v164 + 1;
        end;

        v160 = v160 + 1;

        if p145 < v164 then
            v162 = v162 + 1;
            v164 = p145;
        end;

        if v165 >= 0 then
            v150[v165] = v164;

            if v151 < v165 then
                v151 = v165 or v151;
            end;

            v152[v164] = (v152[v164] or 0) + 1;
        end;
    end;

    if v162 > 0 then
        repeat
            local v168 = p145 - 1;

            while (v152[v168] or 0) == 0 do
                v168 = v168 - 1;
            end;

            v152[v168] = v152[v168] - 1;
            v152[v168 + 1] = (v152[v168 + 1] or 0) + 2;
            v152[p145] = v152[p145] - 1;
            v162 = v162 - 2;
        until v162 <= 0;

        local v169 = 1;

        for i = p145, 1, -1 do
            local v170 = v152[i] or 0;

            while v170 > 0 do
                v150[v148[v169][2]] = i;
                v170 = v170 - 1;
                v169 = v169 + 1;
            end;
        end;
    end;

    return v150, GetHuffmanCodeFromBitlen(v152, v150, p146, p145), v151;
end;

local function RunLengthEncodeHuffmanBitlen(p171, p172, p173, p174) -- Line: 1190
    local v175 = p172 + (p174 < 0 and 0 or p174) + 1;
    local v176 = nil;
    local v177 = 0;
    local v178 = 0;
    local v179 = {};
    local v180 = 0;
    local v181 = {};
    local v182 = {};

    for i = 0, v175 + 1 do
        local v183;

        if i <= p172 then
            v183 = p171[i] or 0;
        else
            v183 = i <= v175 and (p173[i - p172 - 1] or 0) or nil;
        end;

        if v183 == v176 then
            v180 = v180 + 1;

            if v183 == 0 or v180 ~= 6 then
                if v183 == 0 and v180 == 138 then
                    v177 = v177 + 1;
                    v181[v177] = 18;
                    v178 = v178 + 1;
                    v182[v178] = 127;
                    v179[18] = (v179[18] or 0) + 1;
                    v180 = 0;
                end;
            else
                v177 = v177 + 1;
                v181[v177] = 16;
                v178 = v178 + 1;
                v182[v178] = 3;
                v179[16] = (v179[16] or 0) + 1;
                v180 = 0;
            end;
        else
            if v180 == 1 then
                v177 = v177 + 1;
                v181[v177] = v176;
                v179[v176] = (v179[v176] or 0) + 1;
            elseif v180 == 2 then
                local v184 = v177 + 1;
                v181[v184] = v176;
                v177 = v184 + 1;
                v181[v177] = v176;
                v179[v176] = (v179[v176] or 0) + 2;
            elseif v180 >= 3 then
                v177 = v177 + 1;
                local v185 = v176 == 0 and (v180 <= 10 and 17 or 18) or 16;
                v181[v177] = v185;
                v179[v185] = (v179[v185] or 0) + 1;
                v178 = v178 + 1;
                v182[v178] = v180 <= 10 and v180 - 3 or v180 - 11;
            end;

            if v183 and v183 ~= 0 then
                v177 = v177 + 1;
                v181[v177] = v183;
                v179[v183] = (v179[v183] or 0) + 1;
                v176 = v183;
                v180 = 0;
            else
                v176 = v183;
                v180 = 1;
            end;
        end;
    end;

    return v181, v182, v179;
end;

local function LoadStringToTable(p186, p187, p188, p189, p190) -- Line: 1273
    -- upvalues: byte (copy)
    local v191 = p188 - p190;

    while v191 <= p189 - 15 - p190 do
        local v192, v193, v194, v195, v196, v197, v198, v199, v200, v201, v202, v203, v204, v205, v206, v207 = byte(p186, v191 + p190, v191 + 15 + p190);
        p187[v191] = v192;
        p187[v191 + 1] = v193;
        p187[v191 + 2] = v194;
        p187[v191 + 3] = v195;
        p187[v191 + 4] = v196;
        p187[v191 + 5] = v197;
        p187[v191 + 6] = v198;
        p187[v191 + 7] = v199;
        p187[v191 + 8] = v200;
        p187[v191 + 9] = v201;
        p187[v191 + 10] = v202;
        p187[v191 + 11] = v203;
        p187[v191 + 12] = v204;
        p187[v191 + 13] = v205;
        p187[v191 + 14] = v206;
        p187[v191 + 15] = v207;
        v191 = v191 + 16;
    end;

    while v191 <= p189 - p190 do
        p187[v191] = byte(p186, v191 + p190, v191 + p190);
        v191 = v191 + 1;
    end;

    return p187;
end;

local function GetBlockLZ77Result(p208, p209, p210, p211, p212, p213, p214) -- Line: 1329
    -- upvalues: u90 (copy), u1 (copy), u10 (copy), u11 (copy), u12 (copy), u14 (copy), u13 (copy), u9 (copy)
    local v215 = u90[p208];
    local v216 = v215[1];
    local v217 = v215[2];
    local v218 = v215[3];
    local v219 = v215[4];
    local v220 = v215[5];
    local v221 = (v216 or not v218) and 2147483646 or v218;
    local v222 = v220 - v220 % 4 / 4;
    local v223, v224, v225;

    if p214 then
        v223 = p214.hash_tables;
        v224 = p214.string_table;
        v225 = p214.strlen;
        u1(p211 == 1);

        if p211 <= p212 and v225 >= 2 then
            local v226 = v224[v225 - 1] * 65536 + v224[v225] * 256 + p209[1];
            local v227 = p210[v226];

            if not v227 then
                v227 = {};
                p210[v226] = v227;
            end;

            v227[#v227 + 1] = -1;
        end;

        if p211 + 1 <= p212 and v225 >= 1 then
            local v228 = v224[v225] * 65536 + p209[1] * 256 + p209[2];
            local v229 = p210[v228];

            if not v229 then
                v229 = {};
                p210[v228] = v229;
            end;

            v229[#v229 + 1] = 0;
        end;
    else
        v225 = 0;
        v224 = nil;
        v223 = nil;
    end;

    local v230 = v225 + 3;
    local v231 = (p209[p211 - p213] or 0) * 256 + (p209[p211 + 1 - p213] or 0);
    local v232 = p212 + (v216 and 1 or 0);
    local v233 = 0;
    local v234 = 0;
    local v235 = false;
    local v236 = {};
    local v237 = {};
    local v238 = 0;
    local v239 = 0;
    local v240 = {};
    local v241 = {};
    local v242 = 0;
    local v243 = 0;
    local v244 = {};
    local v245 = {};

    while true do
        if p211 > v232 then
            v240[v243 + 1] = 256;
            v244[256] = (v244[256] or 0) + 1;

            return v240, v237, v244, v236, v245, v241;
        end;

        local v246 = p211 - p213;
        local v247 = p213 - 3;
        local v248 = 0;
        v231 = (v231 * 256 + (p209[v246 + 2] or 0)) % 16777216;
        local v249 = nil;
        local v250 = p210[v231];
        local v251, v252;

        if v250 then
            v251 = #v250;
            v249 = v250;
            v252 = v251;
        else
            v252 = 0;
            v250 = {};
            p210[v231] = v250;

            if v223 then
                v249 = v223[v231];
                v251 = v249 and (#v249 or 0) or 0;
            else
                v251 = 0;
            end;
        end;

        if p211 <= p212 then
            v250[v252 + 1] = p211;
        end;

        local v253, v254;

        if v251 > 0 and (p211 + 2 <= p212 and (not v216 or v233 < v218)) then
            local v255;

            if v216 and (v217 <= v233 and v222) then
                v255 = v222;
            else
                v255 = v220;
            end;

            local v256 = p212 - p211;
            local v257 = (v256 >= 257 and 257 or v256) + v246;
            local v258 = v246 + 3;
            v253 = v234;

            while true do
                if v251 < 1 or v255 <= 0 then
                    v254 = v248;
                    break;
                end;

                local v259 = v249[v251];

                if p211 - v259 > 32768 then
                    v254 = v248;
                    break;
                end;

                local v260;

                if v259 < p211 then
                    if v259 >= -257 then
                        local v261 = v259 - v247;
                        v260 = v258;

                        while v258 <= v257 and p209[v261] == p209[v258] do
                            v258 = v258 + 1;
                            v261 = v261 + 1;
                        end;
                    else
                        local v262 = v230 + v259;
                        local v263 = v258;

                        while v263 <= v257 and v224[v262] == p209[v263] do
                            v263 = v263 + 1;
                            v262 = v262 + 1;
                        end;

                        v260 = v258;
                        v258 = v263;
                    end;

                    v254 = v258 - v246;

                    if v248 < v254 then
                        v234 = p211 - v259;
                    else
                        v254 = v248;
                    end;

                    if v219 <= v254 then
                        break;
                    end;
                else
                    v260 = v258;
                    v254 = v248;
                end;

                v251 = v251 - 1;
                v255 = v255 - 1;

                if v251 == 0 and (v259 > 0 and v223) then
                    v249 = v223[v231];
                    v251 = v249 and (#v249 or 0) or 0;
                end;

                v258 = v260;
                v248 = v254;
            end;
        else
            v253 = v234;
            v254 = v248;
        end;

        if not v216 then
            v253 = v234;
            v233 = v254;
        end;

        if v216 and not v235 or (v233 <= 3 and (v233 ~= 3 or v253 >= 4096) or v254 > v233) then
            if v216 and not v235 then
                p211 = p211 + 1;
                v235 = true;
            else
                if v216 then
                    v246 = v246 - 1 or v246;
                end;

                local v264 = p209[v246];
                v243 = v243 + 1;
                v240[v243] = v264;
                v244[v264] = (v244[v264] or 0) + 1;
                p211 = p211 + 1;
            end;
        else
            local v265 = u10[v233];
            local v266 = u11[v233];
            local v267, v268, v269;

            if v253 <= 256 then
                v267 = u12[v253];
                v268 = u14[v253];
                v269 = u13[v253];
            else
                v267 = 16;
                v269 = 7;
                local v270 = 384;
                local v271 = 512;

                while true do
                    if v253 <= v270 then
                        v268 = (v253 - v271 / 2 - 1) % (v271 / 4);
                    end;

                    if v253 <= v271 then
                        v268 = (v253 - v271 / 2 - 1) % (v271 / 4);
                        v267 = v267 + 1;
                    end;

                    v267 = v267 + 2;
                    v269 = v269 + 1;
                    v270 = v270 * 2;
                    v271 = v271 * 2;
                end;
            end;

            v243 = v243 + 1;
            v240[v243] = v265;
            v244[v265] = (v244[v265] or 0) + 1;
            v238 = v238 + 1;
            v236[v238] = v267;
            v241[v267] = (v241[v267] or 0) + 1;

            if v266 > 0 then
                v239 = v239 + 1;
                v237[v239] = u9[v233];
            end;

            if v269 > 0 then
                v242 = v242 + 1;
                v245[v242] = v268;
            end;

            for i = p211 + 1, p211 + v233 - (v216 and 2 or 1) do
                v231 = (v231 * 256 + (p209[i - p213 + 2] or 0)) % 16777216;

                if v233 <= v221 then
                    local v272 = p210[v231];

                    if not v272 then
                        v272 = {};
                        p210[v231] = v272;
                    end;

                    v272[#v272 + 1] = i;
                end;
            end;

            p211 = p211 + v233 - (v216 and 1 or 0);
            v235 = false;
        end;

        v233 = v254;
    end;
end;

local function GetBlockDynamicHuffmanHeader(p273, p274) -- Line: 1575
    -- upvalues: GetHuffmanBitlenAndCode (copy), RunLengthEncodeHuffmanBitlen (copy), u17 (copy)
    local v275, v276, v277 = GetHuffmanBitlenAndCode(p273, 15, 285);
    local v278, v279, v280 = GetHuffmanBitlenAndCode(p274, 15, 29);
    local v281, v282, v283 = RunLengthEncodeHuffmanBitlen(v275, v277, v278, v280);
    local v284, v285 = GetHuffmanBitlenAndCode(v283, 7, 18);
    local v286 = 0;

    for i = 1, 19 do
        if (v284[u17[i]] or 0) ~= 0 then
            v286 = i;
        end;
    end;

    local v287 = v280 + 1 - 1;

    return v277 + 1 - 257, v287 < 0 and 0 or v287, v286 - 4, v284, v285, v281, v282, v275, v276, v278, v279;
end;

local function GetDynamicHuffmanBlockSize(p288, p289, p290, p291, p292, p293, p294) -- Line: 1622
    -- upvalues: u15 (copy)
    local v295 = 17 + (p290 + 4) * 3;

    for i = 1, #p292 do
        local v296 = p292[i];
        v295 = v295 + p291[v296];

        if v296 >= 16 then
            v295 = v295 + (v296 == 16 and 2 or (v296 == 17 and 3 or 7));
        end;
    end;

    local v297 = 0;

    for i = 1, #p288 do
        local v298 = p288[i];
        v295 = v295 + p293[v298];

        if v298 > 256 then
            v297 = v297 + 1;

            if v298 > 264 and v298 < 285 then
                v295 = v295 + u15[v298 - 256];
            end;

            local v299 = p289[v297];
            v295 = v295 + p294[v299];

            if v299 > 3 then
                v295 = v295 + ((v299 - v299 % 2) / 2 - 1);
            end;
        end;
    end;

    return v295;
end;

local function CompressDynamicHuffmanBlock(p300, p301, p302, p303, p304, p305, p306, p307, p308, p309, p310, p311, p312, p313, p314, p315, p316) -- Line: 1668
    -- upvalues: u17 (copy), u15 (copy)
    p300(p301 and 1 or 0, 1);
    p300(2, 2);
    p300(p306, 5);
    p300(p307, 5);
    p300(p308, 4);

    for i = 1, p308 + 4 do
        p300(p309[u17[i]] or 0, 3);
    end;

    local v317 = 1;

    for i = 1, #p311 do
        local v318 = p311[i];
        p300(p310[v318], p309[v318]);

        if v318 >= 16 then
            p300(p312[v317], v318 == 16 and 2 or (v318 == 17 and 3 or 7));
            v317 = v317 + 1;
        end;
    end;

    local v319 = 0;
    local v320 = 0;
    local v321 = 0;

    for i = 1, #p302 do
        local v322 = p302[i];
        p300(p314[v322], p313[v322]);

        if v322 > 256 then
            v320 = v320 + 1;

            if v322 > 264 and v322 < 285 then
                v319 = v319 + 1;
                p300(p303[v319], u15[v322 - 256]);
            end;

            local v323 = p304[v320];
            p300(p316[v323], p315[v323]);

            if v323 > 3 then
                v321 = v321 + 1;
                p300(p305[v321], (v323 - v323 % 2) / 2 - 1);
            end;
        end;
    end;
end;

local function GetFixedHuffmanBlockSize(p324, p325) -- Line: 1749
    -- upvalues: u22 (ref), u15 (copy)
    local v326 = 3;
    local v327 = 0;

    for i = 1, #p324 do
        local v328 = p324[i];
        v326 = v326 + u22[v328];

        if v328 > 256 then
            v327 = v327 + 1;

            if v328 > 264 and v328 < 285 then
                v326 = v326 + u15[v328 - 256];
            end;

            local v329 = p325[v327];
            v326 = v326 + 5;

            if v329 > 3 then
                v326 = v326 + ((v329 - v329 % 2) / 2 - 1);
            end;
        end;
    end;

    return v326;
end;

local function CompressFixedHuffmanBlock(p330, p331, p332, p333, p334, p335) -- Line: 1777
    -- upvalues: u26 (ref), u22 (ref), u15 (copy), u18 (ref)
    p330(p331 and 1 or 0, 1);
    p330(1, 2);
    local v336 = 0;
    local v337 = 0;
    local v338 = 0;

    for i = 1, #p332 do
        local v339 = p332[i];
        p330(u26[v339], u22[v339]);

        if v339 > 256 then
            v336 = v336 + 1;

            if v339 > 264 and v339 < 285 then
                v337 = v337 + 1;
                p330(p333[v337], u15[v339 - 256]);
            end;

            local v340 = p334[v336];
            p330(u18[v340], 5);

            if v340 > 3 then
                v338 = v338 + 1;
                p330(p335[v338], (v340 - v340 % 2) / 2 - 1);
            end;
        end;
    end;
end;

local function GetStoreBlockSize(p341, p342, p343) -- Line: 1818
    -- upvalues: u1 (copy)
    u1(p342 - p341 + 1 <= 65535);

    return 3 + (8 - (p343 + 3) % 8) % 8 + 32 + (p342 - p341 + 1) * 8;
end;

local function CompressStoreBlock(p344, p345, p346, p347, p348, p349, p350) -- Line: 1832
    -- upvalues: u1 (copy), u7 (copy)
    u1(p349 - p348 + 1 <= 65535);
    p344(p346 and 1 or 0, 1);
    p344(0, 2);
    local v351 = (8 - (p350 + 3) % 8) % 8;

    if v351 > 0 then
        p344(u7[v351] - 1, v351);
    end;

    local v352 = p349 - p348 + 1;
    p344(v352, 16);
    p344(255 - v352 % 256 + (255 - (v352 - v352 % 256) / 256) * 256, 16);
    p345(p347:sub(p348, p349));
end;

local function Deflate(p353, p354, p355, p356, p357, p358) -- Line: 1862
    -- upvalues: LoadStringToTable (copy), GetBlockLZ77Result (copy), GetBlockDynamicHuffmanHeader (copy), GetDynamicHuffmanBlockSize (copy), GetFixedHuffmanBlockSize (copy), u1 (copy), CompressStoreBlock (copy), CompressFixedHuffmanBlock (copy), CompressDynamicHuffmanBlock (copy), u3 (copy)
    local v359 = {};
    local v360 = {};
    local v361 = nil;
    local v362 = nil;
    local v363 = nil;
    local v364 = p356(3);
    local v365 = #p357;
    local v366 = nil;
    local v367 = nil;

    if p353 then
        if p353.level then
            v366 = p353.level;
        end;

        if p353.strategy then
            v367 = p353.strategy;
        end;
    end;

    if not v366 then
        if v365 < 2048 then
            v366 = 7;
        elseif v365 > 65536 then
            v366 = 3;
        else
            v366 = 5;
        end;
    end;

    while not v361 do
        local v368;

        if v362 then
            v362 = v363 + 1;
            v363 = v363 + 32768;
            v368 = v362 - 32768 - 1;
        else
            v362 = 1;
            v368 = 0;
            v363 = 65535;
        end;

        if v365 <= v363 then
            v363 = v365;
            v361 = true;
        else
            v361 = false;
        end;

        local v369, v370, v371, v372, v373, v374, v375, v376, v377, v378, v379, v380, v381, v382, v383, v384, v385;

        if v366 == 0 then
            v369 = nil;
            v370 = nil;
            v371 = nil;
            v372 = nil;
            v373 = nil;
            v374 = nil;
            v375 = nil;
            v376 = nil;
            v377 = nil;
            v378 = nil;
            v379 = nil;
            v380 = nil;
            v381 = nil;
            v382 = nil;
            v383 = nil;
            v384 = nil;
            v385 = nil;
        else
            LoadStringToTable(p357, v359, v362, v363 + 3, v368);

            if v362 == 1 and p358 then
                local string_table = p358.string_table;
                local strlen = p358.strlen;

                for i = 0, -strlen + 1 < -257 and -257 or -strlen + 1, -1 do
                    v359[i] = string_table[strlen + i];
                end;
            end;

            local v386, v387;

            if v367 == "huffman_only" then
                v372 = {};
                LoadStringToTable(p357, v372, v362, v363, v362 - 1);
                v372[v363 - v362 + 2] = 256;
                v386 = {};
                v373 = {};

                for i = 1, v363 - v362 + 2 do
                    local v388 = v372[i];
                    v386[v388] = (v386[v388] or 0) + 1;
                end;

                v371 = {};
                v387 = {};
                v384 = {};
            else
                v372, v373, v386, v384, v371, v387 = GetBlockLZ77Result(v366, v359, v360, v362, v363, v368, p358);
            end;

            v378, v370, v379, v380, v381, v383, v377, v369, v385, v374, v375 = GetBlockDynamicHuffmanHeader(v386, v387);
            v382 = GetDynamicHuffmanBlockSize(v372, v384, v379, v380, v383, v369, v374);
            v376 = GetFixedHuffmanBlockSize(v372, v384);
        end;

        u1(v363 - v362 + 1 <= 65535);
        local v389 = 3 + (8 - (v364 + 3) % 8) % 8 + 32 + (v363 - v362 + 1) * 8;
        local v390;

        if v376 and (v376 < v389 and v376) then
            v390 = v376;
        else
            v390 = v389;
        end;

        if v382 and (v382 < v390 and v382) then
            v390 = v382;
        end;

        if v366 == 0 or v367 ~= "fixed" and (v367 ~= "dynamic" and v389 == v390) then
            CompressStoreBlock(p354, p355, v361, p357, v362, v363, v364);
            v364 = v364 + v389;
        elseif v367 == "dynamic" or v367 ~= "fixed" and v376 ~= v390 then
            if v367 == "dynamic" or v382 == v390 then
                CompressDynamicHuffmanBlock(p354, v361, v372, v373, v384, v371, v378, v370, v379, v380, v381, v383, v377, v369, v385, v374, v375);
                v364 = v364 + v382;
            end;
        else
            CompressFixedHuffmanBlock(p354, v361, v372, v373, v384, v371);
            v364 = v364 + v376;
        end;

        local v391;

        if v361 then
            v391 = p356(3);
        else
            v391 = p356(0);
        end;

        u1(v391 == v364);

        if not v361 then
            if p358 and v362 == 1 then
                local v392 = 0;

                while v359[v392] do
                    v359[v392] = nil;
                    v392 = v392 - 1;
                end;
            end;

            local v393 = 1;
            p358 = nil;

            for i = v363 - 32767, v363 do
                v359[v393] = v359[i - v368];
                v393 = v393 + 1;
            end;

            for i, v in u3(v360) do
                local v394 = #v;

                if v394 > 0 and v363 + 1 - v[1] > 32768 then
                    if v394 == 1 then
                        v360[i] = nil;
                    else
                        local v395 = 0;
                        local v396 = {};

                        for i2 = 2, v394 do
                            local v397 = v[i2];

                            if v363 + 1 - v397 <= 32768 then
                                v395 = v395 + 1;
                                v396[v395] = v397;
                            end;
                        end;

                        v360[i] = v396;
                    end;
                end;
            end;
        end;
    end;
end;

local function CompressDeflateInternal(p398, p399, p400) -- Line: 2064
    -- upvalues: CreateWriter (copy), Deflate (copy)
    local v401, v402, v403 = CreateWriter();
    Deflate(p400, v401, v402, v403, p398, p399);
    local v404, v405 = v403(1);

    return v405, (8 - v404 % 8) % 8;
end;

local function CompressZlibInternal(p406, p407, p408) -- Line: 2074
    -- upvalues: CreateWriter (copy), Deflate (copy), u19 (copy)
    local v409, v410, v411 = CreateWriter();
    v409(120, 8);
    local v412 = p407 and 1 or 0;
    local v413 = 128 + v412 * 32;
    v409(v413 + (31 - (30720 + v413) % 31), 8);

    if v412 == 1 then
        local adler32 = p407.adler32;
        local v414 = adler32 % 256;
        local v415 = (adler32 - v414) / 256;
        local v416 = v415 % 256;
        local v417 = (v415 - v416) / 256;
        local v418 = v417 % 256;
        v409((v417 - v418) / 256 % 256, 8);
        v409(v418, 8);
        v409(v416, 8);
        v409(v414, 8);
    end;

    Deflate(p408, v409, v410, v411, p406, p407);
    v411(2);
    local v419 = u19:Adler32(p406);
    local v420 = v419 % 256;
    local v421 = (v419 - v420) / 256;
    local v422 = v421 % 256;
    local v423 = (v421 - v422) / 256;
    local v424 = v423 % 256;
    v409((v423 - v424) / 256 % 256, 8);
    v409(v424, 8);
    v409(v422, 8);
    v409(v420, 8);
    local v425, v426 = v411(1);

    return v426, (8 - v425 % 8) % 8;
end;

function u19.CompressDeflate(p427, p428, p429) -- Line: 2143
    -- upvalues: IsValidArguments (copy), u2 (copy), CompressDeflateInternal (copy)
    local v430, v431 = IsValidArguments(p428, false, nil, true, p429);

    if not v430 then
        u2("Usage: LibDeflate:CompressDeflate(str, configs): " .. v431, 2);
    end;

    return CompressDeflateInternal(p428, nil, p429);
end;

function u19.CompressDeflateWithDict(p432, p433, p434, p435) -- Line: 2167
    -- upvalues: IsValidArguments (copy), u2 (copy), CompressDeflateInternal (copy)
    local v436, v437 = IsValidArguments(p433, true, p434, true, p435);

    if not v436 then
        u2("Usage: LibDeflate:CompressDeflateWithDict" .. "(str, dictionary, configs): " .. v437, 2);
    end;

    return CompressDeflateInternal(p433, p434, p435);
end;

function u19.CompressZlib(p438, p439, p440) -- Line: 2185
    -- upvalues: IsValidArguments (copy), u2 (copy), CompressZlibInternal (copy)
    local v441, v442 = IsValidArguments(p439, false, nil, true, p440);

    if not v441 then
        u2("Usage: LibDeflate:CompressZlib(str, configs): " .. v442, 2);
    end;

    return CompressZlibInternal(p439, nil, p440);
end;

function u19.CompressZlibWithDict(p443, p444, p445, p446) -- Line: 2206
    -- upvalues: IsValidArguments (copy), u2 (copy), CompressZlibInternal (copy)
    local v447, v448 = IsValidArguments(p444, true, p445, true, p446);

    if not v447 then
        u2("Usage: LibDeflate:CompressZlibWithDict" .. "(str, dictionary, configs): " .. v448, 2);
    end;

    return CompressZlibInternal(p444, p445, p446);
end;

local function CreateReader(u449) -- Line: 2228
    -- upvalues: u7 (copy), byte (copy), u1 (copy), char (copy), sub (copy), u8 (copy)
    local u450 = #u449;
    local u451 = 1;
    local u452 = 0;
    local u453 = 0;

    return function(p454) -- Line: 2241, Name: ReadBits
        -- upvalues: u7 (ref), u452 (ref), u453 (ref), u449 (copy), u451 (ref), byte (ref)
        local v455 = u7[p454];

        if p454 <= u452 then
            local v456 = u453 % v455;
            u453 = (u453 - v456) / v455;
            u452 = u452 - p454;

            return v456;
        end;

        local v457 = u7[u452];
        local v458, v459, v460, v461 = byte(u449, u451, u451 + 3);
        u453 = u453 + ((v458 or 0) + (v459 or 0) * 256 + (v460 or 0) * 65536 + (v461 or 0) * 16777216) * v457;
        u451 = u451 + 4;
        u452 = u452 + 32 - p454;
        local v462 = u453 % v455;
        u453 = (u453 - v462) / v455;

        return v462;
    end, function(p463, p464, p465) -- Line: 2270, Name: ReadBytes
        -- upvalues: u452 (ref), u1 (ref), u453 (ref), char (ref), u450 (copy), u451 (ref), u449 (copy), sub (ref)
        u1(u452 % 8 == 0);
        local v466;

        if u452 / 8 < p463 then
            v466 = u452 / 8 or p463;
        else
            v466 = p463;
        end;

        for _ = 1, v466 do
            local v467 = u453 % 256;
            p465 = p465 + 1;
            p464[p465] = char(v467);
            u453 = (u453 - v467) / 256;
        end;

        u452 = u452 - v466 * 8;
        local v468 = p463 - v466;

        if (u450 - u451 - v468 + 1) * 8 + u452 < 0 then
            return -1;
        end;

        for i = u451, u451 + v468 - 1 do
            p465 = p465 + 1;
            p464[p465] = sub(u449, i, i);
        end;

        u451 = u451 + v468;

        return p465;
    end, function(p469, p470, p471) -- Line: 2305, Name: Decode
        -- upvalues: u452 (ref), u449 (copy), u7 (ref), u451 (ref), byte (ref), u453 (ref), u8 (ref)
        local v472, v473, v474;

        if p471 > 0 then
            if u452 < 15 and u449 then
                local v475 = u7[u452];
                local v476, v477, v478, v479 = byte(u449, u451, u451 + 3);
                u453 = u453 + ((v476 or 0) + (v477 or 0) * 256 + (v478 or 0) * 65536 + (v479 or 0) * 16777216) * v475;
                u451 = u451 + 4;
                u452 = u452 + 32;
            end;

            local v480 = u7[p471];
            u452 = u452 - p471;
            local v481 = u453 % v480;
            u453 = (u453 - v481) / v480;
            local v482 = u8[p471][v481];
            v472 = p469[p471];

            if v482 < v472 then
                return p470[v482];
            end;

            v473 = v472 * 2;
            v474 = v482 * 2;
        else
            v474 = 0;
            v473 = 0;
            v472 = 0;
        end;

        for i = p471 + 1, 15 do
            local v483 = u453 % 2;
            u453 = (u453 - v483) / 2;
            u452 = u452 - 1;

            if v483 == 1 then
                v474 = v474 + 1 - v474 % 2 or v474;
            end;

            local v484 = p469[i] or 0;
            local v485 = v474 - v473;

            if v485 < v484 then
                return p470[v472 + v485];
            end;

            v472 = v472 + v484;
            v473 = (v473 + v484) * 2;
            v474 = v474 * 2;
        end;

        return -10;
    end, function() -- Line: 2360, Name: ReaderBitlenLeft
        -- upvalues: u450 (copy), u451 (ref), u452 (ref)
        return (u450 - u451 + 1) * 8 + u452;
    end, function() -- Line: 2364, Name: SkipToByteBoundary
        -- upvalues: u452 (ref), u7 (ref), u453 (ref)
        local v486 = u452 % 8;
        local v487 = u7[v486];
        u452 = u452 - v486;
        u453 = (u453 - u453 % v487) / v487;
    end;
end;

local function CreateDecompressState(p488, p489) -- Line: 2379
    -- upvalues: CreateReader (copy)
    local v490, v491, v492, v493, v494 = CreateReader(p488);

    return {
        buffer_size = 0,
        ReadBits = v490,
        ReadBytes = v491,
        Decode = v492,
        ReaderBitlenLeft = v493,
        SkipToByteBoundary = v494,
        buffer = {},
        result_buffer = {},
        dictionary = p489
    };
end;

local function GetHuffmanForDecode(p495, p496, p497) -- Line: 2404
    local v498 = p497;
    local v499 = {};

    for i = 0, p496 do
        local v500 = p495[i] or 0;

        if v500 > 0 and (v500 < p497 and v500) then
            p497 = v500;
        end;

        v499[v500] = (v499[v500] or 0) + 1;
    end;

    if v499[0] == p496 + 1 then
        return 0, v499, {}, 0;
    end;

    local v501 = 1;

    for i = 1, v498 do
        v501 = v501 * 2 - (v499[i] or 0);

        if v501 < 0 then
            return v501;
        end;
    end;

    local v502 = { 0 };

    for i = 1, v498 - 1 do
        v502[i + 1] = v502[i] + (v499[i] or 0);
    end;

    local v503 = {};

    for i = 0, p496 do
        local v504 = p495[i] or 0;

        if v504 ~= 0 then
            v503[v502[v504]] = i;
            v502[v504] = v502[v504] + 1;
        end;
    end;

    return v501, v499, v503, p497;
end;

local function DecodeUntilEndOfBlock(p505, p506, p507, p508, p509, p510, p511) -- Line: 2454
    -- upvalues: u6 (copy), u23 (copy), u15 (copy), u24 (copy), u27 (copy), concat (copy)
    local buffer = p505.buffer;
    local buffer_size = p505.buffer_size;
    local ReadBits = p505.ReadBits;
    local Decode = p505.Decode;
    local ReaderBitlenLeft = p505.ReaderBitlenLeft;
    local result_buffer = p505.result_buffer;
    local dictionary = p505.dictionary;
    local v512, v513, v514;

    if dictionary and not buffer[0] then
        v512 = dictionary.string_table;
        v513 = dictionary.strlen;
        v514 = -v513 + 1;

        for i = 0, -v513 + 1 < -257 and -257 or -v513 + 1, -1 do
            buffer[i] = u6[v512[v513 + i]];
        end;
    else
        v513 = nil;
        v512 = nil;
        v514 = 1;
    end;

    while true do
        local v515 = Decode(p506, p507, p508);

        if v515 < 0 or v515 > 285 then
            break;
        end;

        if v515 < 256 then
            buffer_size = buffer_size + 1;
            buffer[buffer_size] = u6[v515];
        elseif v515 > 256 then
            local v516 = v515 - 256;
            local v517 = u23[v516];

            if v516 >= 8 then
                v517 = v517 + ReadBits(u15[v516]) or v517;
            end;

            v515 = Decode(p509, p510, p511);

            if v515 < 0 or v515 > 29 then
                return -10;
            end;

            local v518 = u24[v515];

            if v518 > 4 then
                v518 = v518 + ReadBits(u27[v515]) or v518;
            end;

            local v519 = buffer_size - v518 + 1;

            if v519 < v514 then
                return -11;
            end;

            if v519 >= -257 then
                for _ = 1, v517 do
                    buffer_size = buffer_size + 1;
                    buffer[buffer_size] = buffer[v519];
                    v519 = v519 + 1;
                end;
            else
                local v520 = v513 + v519;

                for _ = 1, v517 do
                    buffer_size = buffer_size + 1;
                    buffer[buffer_size] = u6[v512[v520]];
                    v520 = v520 + 1;
                end;
            end;
        end;

        if ReaderBitlenLeft() < 0 then
            return 2;
        end;

        if buffer_size >= 65536 then
            result_buffer[#result_buffer + 1] = concat(buffer, "", 1, 32768);

            for i = 32769, buffer_size do
                buffer[i - 32768] = buffer[i];
            end;

            buffer_size = buffer_size - 32768;
            buffer[buffer_size + 1] = nil;
        end;

        if v515 == 256 then
            p505.buffer_size = buffer_size;

            return 0;
        end;
    end;

    return -10;
end;

local function DecompressStoreBlock(p521) -- Line: 2547
    -- upvalues: concat (copy)
    local buffer = p521.buffer;
    local buffer_size = p521.buffer_size;
    local ReadBits = p521.ReadBits;
    local ReadBytes = p521.ReadBytes;
    local ReaderBitlenLeft = p521.ReaderBitlenLeft;
    local result_buffer = p521.result_buffer;
    p521.SkipToByteBoundary();
    local v522 = ReadBits(16);

    if ReaderBitlenLeft() < 0 then
        return 2;
    end;

    local v523 = ReadBits(16);

    if ReaderBitlenLeft() < 0 then
        return 2;
    end;

    if v522 % 256 + v523 % 256 ~= 255 then
        return -2;
    end;

    if (v522 - v522 % 256) / 256 + (v523 - v523 % 256) / 256 ~= 255 then
        return -2;
    end;

    local v524 = ReadBytes(v522, buffer, buffer_size);

    if v524 < 0 then
        return 2;
    end;

    if v524 >= 65536 then
        result_buffer[#result_buffer + 1] = concat(buffer, "", 1, 32768);

        for i = 32769, v524 do
            buffer[i - 32768] = buffer[i];
        end;

        v524 = v524 - 32768;
        buffer[v524 + 1] = nil;
    end;

    p521.buffer_size = v524;

    return 0;
end;

local function DecompressFixBlock(p525) -- Line: 2596
    -- upvalues: DecodeUntilEndOfBlock (copy), u20 (ref), u25 (ref), u16 (ref), u21 (ref)
    return DecodeUntilEndOfBlock(p525, u20, u25, 7, u16, u21, 5);
end;

local function DecompressDynamicBlock(p526) -- Line: 2611
    -- upvalues: u17 (copy), GetHuffmanForDecode (copy), DecodeUntilEndOfBlock (copy)
    local ReadBits = p526.ReadBits;
    local Decode = p526.Decode;
    local v527 = ReadBits(5) + 257;
    local v528 = ReadBits(5) + 1;
    local v529 = ReadBits(4) + 4;

    if v527 > 286 or v528 > 30 then
        return -3;
    end;

    local v530 = {};

    for i = 1, v529 do
        v530[u17[i]] = ReadBits(3);
    end;

    local v531, v532, v533, v534 = GetHuffmanForDecode(v530, 18, 7);

    if v531 ~= 0 then
        return -4;
    end;

    local v535 = 0;
    local v536 = {};
    local v537 = {};

    while v535 < v527 + v528 do
        local v538 = Decode(v532, v533, v534);

        if v538 < 0 then
            return v538;
        end;

        if v538 < 16 then
            if v535 < v527 then
                v536[v535] = v538;
            else
                v537[v535 - v527] = v538;
            end;

            v535 = v535 + 1;
        else
            local v539 = 0;
            local v540;

            if v538 == 16 then
                if v535 == 0 then
                    return -5;
                end;

                if v535 - 1 < v527 then
                    v539 = v536[v535 - 1];
                else
                    v539 = v537[v535 - v527 - 1];
                end;

                v540 = 3 + ReadBits(2);
            elseif v538 == 17 then
                v540 = 3 + ReadBits(3);
            else
                v540 = 11 + ReadBits(7);
            end;

            if v535 + v540 > v527 + v528 then
                return -6;
            end;

            while v540 > 0 do
                v540 = v540 - 1;

                if v535 < v527 then
                    v536[v535] = v539;
                else
                    v537[v535 - v527] = v539;
                end;

                v535 = v535 + 1;
            end;
        end;
    end;

    if (v536[256] or 0) == 0 then
        return -9;
    end;

    local v541, v542, v543, v544 = GetHuffmanForDecode(v536, v527 - 1, 15);

    if v541 ~= 0 and (v541 < 0 or v527 ~= (v542[0] or 0) + (v542[1] or 0)) then
        return -7;
    end;

    local v545, v546, v547, v548 = GetHuffmanForDecode(v537, v528 - 1, 15);

    return v545 ~= 0 and (v545 < 0 or v528 ~= (v546[0] or 0) + (v546[1] or 0)) and -8 or DecodeUntilEndOfBlock(p526, v542, v543, v544, v546, v547, v548);
end;

local function Inflate(p549) -- Line: 2731
    -- upvalues: DecompressStoreBlock (copy), DecodeUntilEndOfBlock (copy), u20 (ref), u25 (ref), u16 (ref), u21 (ref), DecompressDynamicBlock (copy), concat (copy)
    local ReadBits = p549.ReadBits;
    local v550 = nil;

    while not v550 do
        v550 = ReadBits(1) == 1;
        local v551 = ReadBits(2);
        local v552;

        if v551 == 0 then
            v552 = DecompressStoreBlock(p549);
        elseif v551 == 1 then
            v552 = DecodeUntilEndOfBlock(p549, u20, u25, 7, u16, u21, 5);
        else
            if v551 ~= 2 then
                return nil, -1;
            end;

            v552 = DecompressDynamicBlock(p549);
        end;

        if v552 ~= 0 then
            return nil, v552;
        end;
    end;

    p549.result_buffer[#p549.result_buffer + 1] = concat(p549.buffer, "", 1, p549.buffer_size);

    return concat(p549.result_buffer);
end;

local function DecompressDeflateInternal(p553, p554) -- Line: 2760
    -- upvalues: CreateDecompressState (copy), Inflate (copy)
    local v555 = CreateDecompressState(p553, p554);
    local v556, v557 = Inflate(v555);

    if not v556 then
        return nil, v557;
    end;

    local v558 = v555.ReaderBitlenLeft();

    return v556, (v558 - v558 % 8) / 8;
end;

local function DecompressZlibInternal(p559, p560) -- Line: 2774
    -- upvalues: CreateDecompressState (copy), Inflate (copy), u19 (copy)
    local v561 = CreateDecompressState(p559, p560);
    local ReadBits = v561.ReadBits;
    local v562 = ReadBits(8);

    if v561.ReaderBitlenLeft() < 0 then
        return nil, 2;
    end;

    local v563 = v562 % 16;

    if v563 ~= 8 then
        return nil, -12;
    end;

    if (v562 - v563) / 16 > 7 then
        return nil, -13;
    end;

    local v564 = ReadBits(8);

    if v561.ReaderBitlenLeft() < 0 then
        return nil, 2;
    end;

    if (v562 * 256 + v564) % 31 ~= 0 then
        return nil, -14;
    end;

    local _ = (v564 - v564 % 64) / 64 % 4;

    if (v564 - v564 % 32) / 32 % 2 == 1 then
        if not p560 then
            return nil, -16;
        end;

        local v565 = ReadBits(8);
        local v566 = ReadBits(8);
        local v567 = ReadBits(8);
        local v568 = ReadBits(8);

        if v561.ReaderBitlenLeft() < 0 then
            return nil, 2;
        end;

        if (v565 * 16777216 + v566 * 65536 + v567 * 256 + v568) % 4294967296 ~= p560.adler32 % 4294967296 then
            return nil, -17;
        end;
    end;

    local v569, v570 = Inflate(v561);

    if not v569 then
        return nil, v570;
    end;

    v561.SkipToByteBoundary();
    local v571 = ReadBits(8);
    local v572 = ReadBits(8);
    local v573 = ReadBits(8);
    local v574 = ReadBits(8);

    if v561.ReaderBitlenLeft() < 0 then
        return nil, 2;
    end;

    local v575 = u19:Adler32(v569);

    if (v571 * 16777216 + v572 * 65536 + v573 * 256 + v574) % 4294967296 ~= v575 % 4294967296 then
        return nil, -15;
    end;

    local v576 = v561.ReaderBitlenLeft();

    return v569, (v576 - v576 % 8) / 8;
end;

function u19.DecompressDeflate(p577, p578) -- Line: 2856
    -- upvalues: u5 (copy), u2 (copy), DecompressDeflateInternal (copy)
    local v579, v580;

    if u5(p578) == "string" then
        v579 = true;
        v580 = "";
    else
        v580 = ("\'str\' - string expected got \'%s\'."):format((u5(p578)));
        v579 = false;
    end;

    if not v579 then
        u2("Usage: LibDeflate:DecompressDeflate(str): " .. v580, 2);
    end;

    return DecompressDeflateInternal(p578);
end;

function u19.DecompressDeflateWithDict(p581, p582, p583) -- Line: 2882
    -- upvalues: u5 (copy), IsValidDictionary (copy), u2 (copy), DecompressDeflateInternal (copy)
    local v584, v585;

    if u5(p582) == "string" then
        local v586;
        v586, v584 = IsValidDictionary(p583);

        if v586 then
            v585 = true;
            v584 = "";
        else
            v585 = false;
        end;
    else
        v584 = ("\'str\' - string expected got \'%s\'."):format((u5(p582)));
        v585 = false;
    end;

    if not v585 then
        u2("Usage: LibDeflate:DecompressDeflateWithDict(str, dictionary): " .. v584, 2);
    end;

    return DecompressDeflateInternal(p582, p583);
end;

function u19.DecompressZlib(p587, p588) -- Line: 2903
    -- upvalues: u5 (copy), u2 (copy), DecompressZlibInternal (copy)
    local v589, v590;

    if u5(p588) == "string" then
        v589 = true;
        v590 = "";
    else
        v590 = ("\'str\' - string expected got \'%s\'."):format((u5(p588)));
        v589 = false;
    end;

    if not v589 then
        u2("Usage: LibDeflate:DecompressZlib(str): " .. v590, 2);
    end;

    return DecompressZlibInternal(p588);
end;

function u19.DecompressZlibWithDict(p591, p592, p593) -- Line: 2929
    -- upvalues: u5 (copy), IsValidDictionary (copy), u2 (copy), DecompressZlibInternal (copy)
    local v594, v595;

    if u5(p592) == "string" then
        local v596;
        v596, v594 = IsValidDictionary(p593);

        if v596 then
            v595 = true;
            v594 = "";
        else
            v595 = false;
        end;
    else
        v594 = ("\'str\' - string expected got \'%s\'."):format((u5(p592)));
        v595 = false;
    end;

    if not v595 then
        u2("Usage: LibDeflate:DecompressZlibWithDict(str, dictionary): " .. v594, 2);
    end;

    return DecompressZlibInternal(p592, p593);
end;

u22 = {};

for i = 0, 143 do
    u22[i] = 8;
end;

for i = 144, 255 do
    u22[i] = 9;
end;

u22[256] = 7;
u22[257] = 7;
u22[258] = 7;
u22[259] = 7;
u22[260] = 7;
u22[261] = 7;
u22[262] = 7;
u22[263] = 7;
u22[264] = 7;
u22[265] = 7;
u22[266] = 7;
u22[267] = 7;
u22[268] = 7;
u22[269] = 7;
u22[270] = 7;
u22[271] = 7;
u22[272] = 7;
u22[273] = 7;
u22[274] = 7;
u22[275] = 7;
u22[276] = 7;
u22[277] = 7;
u22[278] = 7;
u22[279] = 7;
u22[280] = 8;
u22[281] = 8;
u22[282] = 8;
u22[283] = 8;
u22[284] = 8;
u22[285] = 8;
u22[286] = 8;
u22[287] = 8;
local v597 = {};

for i = 0, 31 do
    v597[i] = 5;
end;

local v598, v599, v600 = GetHuffmanForDecode(u22, 287, 9);
u20 = v599;
u25 = v600;
u1(v598 == 0);
local v601, v602, v603 = GetHuffmanForDecode(v597, 31, 5);
u16 = v602;
u21 = v603;
u1(v601 == 0);
u26 = GetHuffmanCodeFromBitlen(u20, u22, 287, 9);
u18 = GetHuffmanCodeFromBitlen(u16, v597, 31, 5);
local u604 = {
    ["\0"] = "%z",
    ["("] = "%(",
    [")"] = "%)",
    ["."] = "%.",
    ["%"] = "%%",
    ["+"] = "%+",
    ["-"] = "%-",
    ["*"] = "%*",
    ["?"] = "%?",
    ["["] = "%[",
    ["]"] = "%]",
    ["^"] = "%^",
    ["$"] = "%$"
};

local function escape_for_gsub(p605) -- Line: 2997
    -- upvalues: u604 (copy)
    return p605:gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", u604);
end;

function u19.CreateCodec(p606, p607, p608, p609) -- Line: 3041
    -- upvalues: u5 (copy), u2 (copy), byte (copy), sub (copy), concat (copy), u604 (copy), u6 (copy), gsub (copy), find (copy)
    if u5(p607) ~= "string" or (u5(p608) ~= "string" or u5(p609) ~= "string") then
        u2(
            "Usage: LibDeflate:CreateCodec(reserved_chars, escape_chars, map_chars): All arguments must be string.",
            2
        );
    end;

    if p608 == "" then
        return nil, "No escape characters supplied.";
    end;

    if #p607 < #p609 then
        return nil, "The number of reserved characters must be at least as many as the number of mapped chars.";
    end;

    if p607 == "" then
        return nil, "No characters to encode.";
    end;

    local v610 = p607 .. p608 .. p609;
    local v611 = {};

    for i = 1, #v610 do
        local v612 = byte(v610, i, i);

        if v611[v612] then
            return nil, "There must be no duplicate characters in the concatenation of reserved_chars, escape_chars and map_chars.";
        end;

        v611[v612] = true;
    end;

    local u613 = {};
    local u614 = {};
    local v615 = {};
    local u616 = {};

    if #p609 > 0 then
        local v617 = {};
        local v618 = {};

        for i = 1, #p609 do
            local v619 = sub(p607, i, i);
            local v620 = sub(p609, i, i);
            u616[v619] = v620;
            v615[#v615 + 1] = v619;
            v617[v620] = v619;
            v618[#v618 + 1] = v620;
        end;

        u613[#u613 + 1] = "([" .. concat(v618):gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", u604) .. "])";
        u614[#u614 + 1] = v617;
    end;

    local v621 = 1;
    local v622 = sub(p608, v621, v621);
    local v623 = 0;
    local v624 = {};
    local v625 = {};

    for i = 1, #v610 do
        local v626 = sub(v610, i, i);

        if not u616[v626] then
            while v623 >= 256 or v611[v623] do
                v623 = v623 + 1;

                if v623 > 255 then
                    u613[#u613 + 1] = v622:gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", u604) .. "([" .. concat(v624):gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", u604) .. "])";
                    u614[#u614 + 1] = v625;
                    v621 = v621 + 1;
                    v622 = sub(p608, v621, v621);

                    if not v622 or v622 == "" then
                        return nil, "Out of escape characters.";
                    end;

                    v623 = 0;
                    v624 = {};
                    v625 = {};
                end;
            end;

            local v627 = u6[v623];
            u616[v626] = v622 .. v627;
            v615[#v615 + 1] = v626;
            v625[v627] = v626;
            v624[#v624 + 1] = v627;
            v623 = v623 + 1;
        end;

        if i == #v610 then
            u613[#u613 + 1] = v622:gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", u604) .. "([" .. concat(v624):gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", u604) .. "])";
            u614[#u614 + 1] = v625;
        end;
    end;

    local v628 = {};
    local u629 = "([" .. concat(v615):gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", u604) .. "])";

    function v628.Encode(p630, p631) -- Line: 3155
        -- upvalues: u5 (ref), u2 (ref), gsub (ref), u629 (copy), u616 (copy)
        if u5(p631) ~= "string" then
            u2(("Usage: codec:Encode(str): \'str\' - string expected got \'%s\'."):format((u5(p631))), 2);
        end;

        return gsub(p631, u629, u616);
    end;

    local u632 = #u613;
    local u633 = "([" .. p607:gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", u604) .. "])";

    function v628.Decode(p634, p635) -- Line: 3165
        -- upvalues: u5 (ref), u2 (ref), find (ref), u633 (copy), u632 (copy), gsub (ref), u613 (copy), u614 (copy)
        if u5(p635) ~= "string" then
            u2(("Usage: codec:Decode(str): \'str\' - string expected got \'%s\'."):format((u5(p635))), 2);
        end;

        if find(p635, u633) then
            return nil;
        end;

        for i = 1, u632 do
            p635 = gsub(p635, u613[i], u614[i]);
        end;

        return p635;
    end;

    return v628;
end;

local u636 = nil;

local function GenerateWoWAddonChannelCodec() -- Line: 3183
    -- upvalues: u19 (copy)
    return u19:CreateCodec("\0", "\1", "");
end;

function u19.EncodeForWoWAddonChannel(p637, p638) -- Line: 3193
    -- upvalues: u5 (copy), u2 (copy), u636 (ref), u19 (copy)
    if u5(p638) ~= "string" then
        u2(("Usage: LibDeflate:EncodeForWoWAddonChannel(str): \'str\' - string expected got \'%s\'."):format((u5(p638))), 2);
    end;

    if not u636 then
        u636 = u19:CreateCodec("\0", "\1", "");
    end;

    return u636:Encode(p638);
end;

function u19.DecodeForWoWAddonChannel(p639, p640) -- Line: 3212
    -- upvalues: u5 (copy), u2 (copy), u636 (ref), u19 (copy)
    if u5(p640) ~= "string" then
        u2(("Usage: LibDeflate:DecodeForWoWAddonChannel(str): \'str\' - string expected got \'%s\'."):format((u5(p640))), 2);
    end;

    if not u636 then
        u636 = u19:CreateCodec("\0", "\1", "");
    end;

    return u636:Decode(p640);
end;

local function GenerateWoWChatChannelCodec() -- Line: 3249
    -- upvalues: u6 (copy), concat (copy), u19 (copy)
    local v641 = {};

    for i = 128, 255 do
        v641[#v641 + 1] = u6[i];
    end;

    return u19:CreateCodec("sS\0\n\r|%" .. concat(v641), "\29\31", "\15\20");
end;

local u642 = nil;

function u19.EncodeForWoWChatChannel(p643, p644) -- Line: 3267
    -- upvalues: u5 (copy), u2 (copy), u642 (ref), GenerateWoWChatChannelCodec (copy)
    if u5(p644) ~= "string" then
        u2(("Usage: LibDeflate:EncodeForWoWChatChannel(str): \'str\' - string expected got \'%s\'."):format((u5(p644))), 2);
    end;

    if not u642 then
        u642 = GenerateWoWChatChannelCodec();
    end;

    return u642:Encode(p644);
end;

function u19.DecodeForWoWChatChannel(p645, p646) -- Line: 3286
    -- upvalues: u5 (copy), u2 (copy), u642 (ref), GenerateWoWChatChannelCodec (copy)
    if u5(p646) ~= "string" then
        u2(("Usage: LibDeflate:DecodeForWoWChatChannel(str): \'str\' - string expected got \'%s\'."):format((u5(p646))), 2);
    end;

    if not u642 then
        u642 = GenerateWoWChatChannelCodec();
    end;

    return u642:Decode(p646);
end;

local u647 = { "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "(", ")" };
local u648 = {
    [97] = 0,
    [98] = 1,
    [99] = 2,
    [100] = 3,
    [101] = 4,
    [102] = 5,
    [103] = 6,
    [104] = 7,
    [105] = 8,
    [106] = 9,
    [107] = 10,
    [108] = 11,
    [109] = 12,
    [110] = 13,
    [111] = 14,
    [112] = 15,
    [113] = 16,
    [114] = 17,
    [115] = 18,
    [116] = 19,
    [117] = 20,
    [118] = 21,
    [119] = 22,
    [120] = 23,
    [121] = 24,
    [122] = 25,
    [65] = 26,
    [66] = 27,
    [67] = 28,
    [68] = 29,
    [69] = 30,
    [70] = 31,
    [71] = 32,
    [72] = 33,
    [73] = 34,
    [74] = 35,
    [75] = 36,
    [76] = 37,
    [77] = 38,
    [78] = 39,
    [79] = 40,
    [80] = 41,
    [81] = 42,
    [82] = 43,
    [83] = 44,
    [84] = 45,
    [85] = 46,
    [86] = 47,
    [87] = 48,
    [88] = 49,
    [89] = 50,
    [90] = 51,
    [48] = 52,
    [49] = 53,
    [50] = 54,
    [51] = 55,
    [52] = 56,
    [53] = 57,
    [54] = 58,
    [55] = 59,
    [56] = 60,
    [57] = 61,
    [40] = 62,
    [41] = 63
};

function u19.EncodeForPrint(p649, p650) -- Line: 3452
    -- upvalues: u5 (copy), u2 (copy), byte (copy), u647 (copy), u7 (copy), concat (copy)
    if u5(p650) ~= "string" then
        u2(("Usage: LibDeflate:EncodeForPrint(str): \'str\' - string expected got \'%s\'."):format((u5(p650))), 2);
    end;

    local v651 = #p650;
    local v652 = 1;
    local v653 = 0;
    local v654 = {};

    while v652 <= v651 - 2 do
        local v655, v656, v657 = byte(p650, v652, v652 + 2);
        v652 = v652 + 3;
        local v658 = v655 + v656 * 256 + v657 * 65536;
        local v659 = v658 % 64;
        local v660 = (v658 - v659) / 64;
        local v661 = v660 % 64;
        local v662 = (v660 - v661) / 64;
        local v663 = v662 % 64;
        v653 = v653 + 1;
        v654[v653] = u647[v659] .. u647[v661] .. u647[v663] .. u647[(v662 - v663) / 64];
    end;

    local v664 = 0;
    local v665 = 0;

    while v652 <= v651 do
        v665 = v665 + byte(p650, v652, v652) * u7[v664];
        v664 = v664 + 8;
        v652 = v652 + 1;
    end;

    while v664 > 0 do
        local v666 = v665 % 64;
        v653 = v653 + 1;
        v654[v653] = u647[v666];
        v665 = (v665 - v666) / 64;
        v664 = v664 - 6;
    end;

    return concat(v654);
end;

function u19.DecodeForPrint(p667, p668) -- Line: 3507
    -- upvalues: u5 (copy), u2 (copy), byte (copy), u648 (copy), u6 (copy), u7 (copy), concat (copy)
    if u5(p668) ~= "string" then
        u2(("Usage: LibDeflate:DecodeForPrint(str): \'str\' - string expected got \'%s\'."):format((u5(p668))), 2);
    end;

    local v669 = p668:gsub("^[%c ]+", ""):gsub("[%c ]+$", "");
    local v670 = #v669;

    if v670 == 1 then
        return nil;
    end;

    local v671 = 1;
    local v672 = 0;
    local v673 = {};

    while v671 <= v670 - 3 do
        local v674, v675, v676, v677 = byte(v669, v671, v671 + 3);
        local v678 = u648[v674];
        local v679 = u648[v675];
        local v680 = u648[v676];
        local v681 = u648[v677];

        if not (v678 and (v679 and (v680 and v681))) then
            return nil;
        end;

        v671 = v671 + 4;
        local v682 = v678 + v679 * 64 + v680 * 4096 + v681 * 262144;
        local v683 = v682 % 256;
        local v684 = (v682 - v683) / 256;
        local v685 = v684 % 256;
        v672 = v672 + 1;
        v673[v672] = u6[v683] .. u6[v685] .. u6[(v684 - v685) / 256];
    end;

    local v686 = 0;
    local v687 = 0;

    while v671 <= v670 do
        local v688 = u648[byte(v669, v671, v671)];

        if not v688 then
            return nil;
        end;

        v687 = v687 + v688 * u7[v686];
        v686 = v686 + 6;
        v671 = v671 + 1;
    end;

    while v686 >= 8 do
        local v689 = v687 % 256;
        v672 = v672 + 1;
        v673[v672] = u6[v689];
        v687 = (v687 - v689) / 256;
        v686 = v686 - 8;
    end;

    return concat(v673);
end;

u19.internals = {
    LoadStringToTable = LoadStringToTable,
    IsValidDictionary = IsValidDictionary,
    IsEqualAdler32 = IsEqualAdler32,
    _byte_to_6bit_char = u647,
    _6bit_to_byte = u648,

    InternalClearCache = function() -- Line: 3565, Name: InternalClearCache
        -- upvalues: u642 (ref), u636 (ref)
        u642 = nil;
        u636 = nil;
    end
};

return u19;