-- Decompiled with Potassium's decompiler.

local byte = string.byte;
local char = string.char;
local find = string.find;
local gsub = string.gsub;
local sub = string.sub;
local concat = table.concat;
local sort = table.sort;
local u1 = {};
local u2 = {};
local u3 = {};
local u4 = {};
local u5 = {};
local u6 = {};
local u7 = {};
local u8 = {};
local u9 = {};
local u10 = { 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 15, 17, 19, 23, 27, 31, 35, 43, 51, 59, 67, 83, 99, 115, 131, 163, 195, 227, 258 };
local u11 = { 1, 2, 3, 4, 5, 7, 9, 13, 17, 25, 33, 49, 65, 97, 129, 193, 257, 385, 513, 769, 1025, 1537, 2049, 3073, 4097, 6145, 8193, 12289, 16385, 24577 };
local u12 = { 0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13 };
local u13 = {};
local u14 = {};
local u15 = {};
local u16 = { 16, 17, 18, 0, 8, 7, 9, 6, 10, 5, 11, 4, 12, 3, 13, 2, 14, 1, 15 };
local u17 = { 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 0 };
local u18 = {};
local u19 = {};
local u20 = {};
local u21 = {};
local u22 = {};

for i = 0, 255 do
    u1[i] = char(i);
end;

local v23 = 1;

for i = 0, 32 do
    u2[i] = v23;
    v23 = v23 * 2;
end;

for i = 1, 9 do
    u3[i] = {};

    for i2 = 0, u2[i + 1] - 1 do
        local v24 = i2;
        local v25 = 0;

        for _ = 1, i do
            local v26 = v25 - v25 % 2 + ((v25 % 2 == 1 or i2 % 2 == 1) and 1 or 0);
            local i2 = (i2 - i2 % 2) / 2;
            v25 = v26 * 2;
        end;

        u3[i][v24] = (v25 - v25 % 2) / 2;
    end;
end;

local v27 = 1;
local v28 = 18;
local v29 = 16;
local v30 = 265;

for i = 3, 258 do
    if i <= 10 then
        u5[i] = i + 254;
        u6[i] = 0;
    elseif i == 258 then
        u5[i] = 285;
        u6[i] = 0;
    else
        if v28 < i then
            v28 = v28 + v29;
            v29 = v29 * 2;
            v30 = v30 + 4;
            v27 = v27 + 1;
        end;

        local v31 = i - v28 - 1 + v29 / 2;
        u5[i] = (v31 - v31 % (v29 / 8)) / (v29 / 8) + v30;
        u6[i] = v27;
        u4[i] = v31 % (v29 / 8);
    end;
end;

u7[1] = 0;
u7[2] = 1;
u8[1] = 0;
u8[2] = 0;
local v32 = 4;
local v33 = 3;
local v34 = 2;
local v35 = 0;

for i = 3, 256 do
    if v32 < i then
        v33 = v33 * 2;
        v32 = v32 * 2;
        v34 = v34 + 2;
        v35 = v35 + 1;
    end;

    u7[i] = i <= v33 and v34 and v34 or v34 + 1;
    u8[i] = v35 < 0 and 0 or v35;

    if v32 >= 8 then
        u9[i] = (i - v32 / 2 - 1) % (v32 / 4);
    end;
end;

function u15.Adler32(p36, p37) -- Line: 444
    -- upvalues: byte (copy)
    if type(p37) ~= "string" then
        error(("Usage: LibDeflate:Adler32(str): \'str\' - string expected got \'%s\'."):format((type(p37))), 2);
    end;

    local v38 = #p37;
    local v39 = 1;
    local v40 = 1;
    local v41 = 0;

    while v39 <= v38 - 15 do
        local v42, v43, v44, v45, v46, v47, v48, v49, v50, v51, v52, v53, v54, v55, v56, v57 = byte(p37, v39, v39 + 15);
        v41 = (v41 + v40 * 16 + v42 * 16 + 15 * v43 + 14 * v44 + 13 * v45 + 12 * v46 + 11 * v47 + 10 * v48 + 9 * v49 + 8 * v50 + 7 * v51 + 6 * v52 + 5 * v53 + 4 * v54 + 3 * v55 + 2 * v56 + v57) % 65521;
        v40 = (v40 + v42 + v43 + v44 + v45 + v46 + v47 + v48 + v49 + v50 + v51 + v52 + v53 + v54 + v55 + v56 + v57) % 65521;
        v39 = v39 + 16;
    end;

    while v39 <= v38 do
        v40 = (v40 + byte(p37, v39, v39)) % 65521;
        v41 = (v41 + v40) % 65521;
        v39 = v39 + 1;
    end;

    return (v41 * 65536 + v40) % 4294967296;
end;

local function IsEqualAdler32(p58, p59) -- Line: 502
    return p58 % 4294967296 == p59 % 4294967296;
end;

function u15.CreateDictionary(p60, p61, p62, p63) -- Line: 548
    -- upvalues: byte (copy)
    if type(p61) ~= "string" then
        error(("Usage: LibDeflate:CreateDictionary(str, strlen, adler32): \'str\' - string expected got \'%s\'."):format((type(p61))), 2);
    end;

    if type(p62) ~= "number" then
        error(("Usage: LibDeflate:CreateDictionary(str, strlen, adler32): \'strlen\' - number expected got \'%s\'."):format((type(p62))), 2);
    end;

    if type(p63) ~= "number" then
        error(("Usage: LibDeflate:CreateDictionary(str, strlen, adler32): \'adler32\' - number expected got \'%s\'."):format((type(p63))), 2);
    end;

    if p62 ~= #p61 then
        error(("Usage: LibDeflate:CreateDictionary(str, strlen, adler32): \'strlen\' does not match the actual length of \'str\'. \'strlen\': %u, \'#str\': %u . Please check if \'str\' is modified unintentionally."):format(p62, #p61));
    end;

    if p62 == 0 then
        error(
            "Usage: LibDeflate:CreateDictionary(str, strlen, adler32): \'str\' - Empty string is not allowed.",
            2
        );
    end;

    if p62 > 32768 then
        error(("Usage: LibDeflate:CreateDictionary(str, strlen, adler32): \'str\' - string longer than 32768 bytes is not allowed. Got %d bytes."):format(p62), 2);
    end;

    local v64 = p60:Adler32(p61);

    if p63 % 4294967296 ~= v64 % 4294967296 then
        error(("Usage: LibDeflate:CreateDictionary(str, strlen, adler32): \'adler32\' does not match the actual adler32 of \'str\'. \'adler32\': %u, \'Adler32(str)\': %u . Please check if \'str\' is modified unintentionally."):format(p63, v64));
    end;

    local v65 = {
        adler32 = p63,
        hash_tables = {},
        string_table = {},
        strlen = p62
    };
    local string_table = v65.string_table;
    local hash_tables = v65.hash_tables;
    string_table[1] = byte(p61, 1, 1);
    string_table[2] = byte(p61, 2, 2);

    if p62 >= 3 then
        local v66 = string_table[1] * 256 + string_table[2];
        local v67 = 1;

        while v67 <= p62 - 2 - 3 do
            local v68, v69, v70, v71 = byte(p61, v67 + 2, v67 + 5);
            string_table[v67 + 2] = v68;
            string_table[v67 + 3] = v69;
            string_table[v67 + 4] = v70;
            string_table[v67 + 5] = v71;
            local v72 = (v66 * 256 + v68) % 16777216;
            local v73 = hash_tables[v72];

            if not v73 then
                v73 = {};
                hash_tables[v72] = v73;
            end;

            v73[#v73 + 1] = v67 - p62;
            local v74 = v67 + 1;
            local v75 = (v72 * 256 + v69) % 16777216;
            local v76 = hash_tables[v75];

            if not v76 then
                v76 = {};
                hash_tables[v75] = v76;
            end;

            v76[#v76 + 1] = v74 - p62;
            local v77 = v74 + 1;
            local v78 = (v75 * 256 + v70) % 16777216;
            local v79 = hash_tables[v78];

            if not v79 then
                v79 = {};
                hash_tables[v78] = v79;
            end;

            v79[#v79 + 1] = v77 - p62;
            local v80 = v77 + 1;
            v66 = (v78 * 256 + v71) % 16777216;
            local v81 = hash_tables[v66];

            if not v81 then
                v81 = {};
                hash_tables[v66] = v81;
            end;

            v81[#v81 + 1] = v80 - p62;
            v67 = v80 + 1;
        end;

        while v67 <= p62 - 2 do
            local v82 = byte(p61, v67 + 2);
            string_table[v67 + 2] = v82;
            v66 = (v66 * 256 + v82) % 16777216;
            local v83 = hash_tables[v66];

            if not v83 then
                v83 = {};
                hash_tables[v66] = v83;
            end;

            v83[#v83 + 1] = v67 - p62;
            v67 = v67 + 1;
        end;
    end;

    return v65;
end;

local function IsValidDictionary(p84) -- Line: 674
    if p84 == nil or type(p84) ~= "table" then
        return false, ("\'dictionary\' - table expected got \'%s\'."):format((type(p84)));
    end;

    if type(p84.adler32) == "number" and (type(p84.string_table) == "table" and (type(p84.strlen) == "number" and (p84.strlen > 0 and (p84.strlen <= 32768 and (p84.strlen == #p84.string_table and type(p84.hash_tables) == "table"))))) then
        return true, "";
    end;

    return false, ("\'%s\' - corrupted dictionary."):format((type(p84)));
end;

local u85 = {
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

local function IsValidArguments(p86, p87, p88, p89, p90) -- Line: 754
    -- upvalues: IsValidDictionary (copy), u85 (copy)
    if type(p86) ~= "string" then
        return false, ("\'str\' - string expected got \'%s\'."):format((type(p86)));
    end;

    if p87 then
        local v91, v92 = IsValidDictionary(p88);

        if not v91 then
            return false, v92;
        end;
    end;

    if p89 then
        local v93 = type(p90);

        if v93 ~= "nil" and v93 ~= "table" then
            return false, ("\'configs\' - nil or table expected got \'%s\'."):format((type(p90)));
        end;

        if v93 == "table" then
            assert(p90);

            for i, v in pairs(p90) do
                if i ~= "level" and i ~= "strategy" then
                    return false, ("\'configs\' - unsupported table key in the configs: \'%s\'."):format(i);
                end;

                if i == "level" and not u85[v] then
                    return false, ("\'configs\' - unsupported \'level\': %s."):format((tostring(v)));
                end;

                if i == "strategy" and (v ~= "fixed" and (v ~= "huffman_only" and v ~= "dynamic")) then
                    return false, ("\'configs\' - unsupported \'strategy\': \'%s\'."):format((tostring(v)));
                end;
            end;
        end;
    end;

    return true, "";
end;

local function CreateWriter() -- Line: 817
    -- upvalues: u2 (copy), u1 (copy), char (copy), concat (copy)
    local u94 = 0;
    local u95 = 0;
    local u96 = 0;
    local u97 = 0;
    local u98 = {};
    local u99 = {};

    return function(p100, p101) -- Line: 830, Name: WriteBits
        -- upvalues: u95 (ref), u2 (ref), u96 (ref), u97 (ref), u94 (ref), u98 (ref), u1 (ref)
        u95 = u95 + p100 * u2[u96];
        u96 = u96 + p101;
        u97 = u97 + p101;

        if u96 >= 32 then
            u94 = u94 + 1;
            u98[u94] = u1[u95 % 256] .. u1[(u95 - u95 % 256) / 256 % 256] .. u1[(u95 - u95 % 65536) / 65536 % 256] .. u1[(u95 - u95 % 16777216) / 16777216 % 256];
            local v102 = u2[32 - u96 + p101];
            u95 = (p100 - p100 % v102) / v102;
            u96 = u96 - 32;
        end;
    end, function(p103) -- Line: 850, Name: WriteString
        -- upvalues: u96 (ref), u94 (ref), u98 (ref), u95 (ref), char (ref), u97 (ref)
        for _ = 1, u96, 8 do
            u94 = u94 + 1;
            u98[u94] = char(u95 % 256);
            u95 = (u95 - u95 % 256) / 256;
        end;

        u96 = 0;
        u94 = u94 + 1;
        u98[u94] = p103;
        u97 = u97 + #p103 * 8;
    end, function(p104) -- Line: 869, Name: FlushWriter
        -- upvalues: u97 (ref), u96 (ref), u95 (ref), u2 (ref), u94 (ref), u98 (ref), u1 (ref), concat (ref), u99 (copy)
        if p104 == 3 then
            return u97, nil;
        end;

        if p104 == 1 or p104 == 2 then
            local v105 = (8 - u96 % 8) % 8;

            if u96 > 0 then
                u95 = u95 - u2[u96] + u2[u96 + v105];

                for _ = 1, u96, 8 do
                    u94 = u94 + 1;
                    u98[u94] = u1[u95 % 256];
                    u95 = (u95 - u95 % 256) / 256;
                end;

                u95 = 0;
                u96 = 0;
            end;

            if p104 == 2 then
                u97 = u97 + v105;

                return u97, nil;
            end;
        end;

        local v106 = concat(u98);
        u98 = {};
        u94 = 0;
        u99[#u99 + 1] = v106;

        if p104 == 0 then
            return u97, nil;
        end;

        return u97, concat(u99);
    end;
end;

local function MinHeapPush(p107, p108, p109) -- Line: 922
    local v110 = p109 + 1;
    p107[v110] = p108;
    local v111 = (v110 - v110 % 2) / 2;

    while v111 >= 1 and p108[1] < p107[v111][1] do
        local v112 = p107[v111];
        p107[v111] = p108;
        p107[v110] = v112;
        v110 = v111;
        v111 = (v111 - v111 % 2) / 2;
    end;
end;

local function MinHeapPop(p113, p114) -- Line: 943
    local v115 = p113[1];
    local v116 = p113[p114];
    local v117 = v116[1];
    p113[1] = v116;
    p113[p114] = v115;
    local v118 = p114 - 1;
    local v119 = 1;
    local v120 = v119 * 2;
    local v121 = v120 + 1;

    while v120 <= v118 do
        local v122 = p113[v120];
        local v123;

        if v121 <= v118 and p113[v121][1] < v122[1] then
            local v124 = p113[v121];

            if v124[1] >= v117 then
                break;
            end;

            p113[v121] = v116;
            p113[v119] = v124;
            v123 = v121 * 2;
            v120 = v121;
            v121 = v123 + 1;
        else
            if v122[1] >= v117 then
                break;
            end;

            p113[v120] = v116;
            p113[v119] = v122;
            v123 = v120 * 2;
            v121 = v123 + 1;
        end;

        v119 = v120;
        v120 = v123;
    end;

    return v115;
end;

local function GetHuffmanCodeFromBitlen(p125, p126, p127, p128) -- Line: 992
    -- upvalues: u3 (copy)
    local v129 = 0;
    local v130 = {};
    local v131 = {};

    for i = 1, p128 do
        v129 = (v129 + (p125[i - 1] or 0)) * 2;
        v130[i] = v129;
    end;

    for i = 0, p127 do
        local v132 = p126[i];

        if v132 then
            local v133 = v130[v132];
            v130[v132] = v133 + 1;

            if v132 <= 9 then
                v131[i] = u3[v132][v133];
            else
                local v134 = 0;

                for _ = 1, v132 do
                    local v135 = v134 - v134 % 2 + ((v134 % 2 == 1 or v133 % 2 == 1) and 1 or 0);
                    v133 = (v133 - v133 % 2) / 2;
                    v134 = v135 * 2;
                end;

                v131[i] = (v134 - v134 % 2) / 2;
            end;
        end;
    end;

    return v131;
end;

local function SortByFirstThenSecond(p136, p137) -- Line: 1034
    local v138;

    if p136[1] < p137[1] then
        v138 = true;
    elseif p136[1] == p137[1] then
        v138 = p136[2] < p137[2];
    else
        v138 = false;
    end;

    return v138;
end;

local function GetHuffmanBitlenAndCode(p139, p140, p141) -- Line: 1049
    -- upvalues: sort (copy), SortByFirstThenSecond (copy), MinHeapPop (copy), MinHeapPush (copy), GetHuffmanCodeFromBitlen (copy)
    local v142 = 0;
    local v143 = {};
    local v144 = {};
    local v145 = {};
    local v146 = -1;
    local v147 = {};
    local v148 = {};

    for i, v in pairs(p139) do
        v142 = v142 + 1;
        v143[v142] = { v, i };
    end;

    if v142 == 0 then
        return {}, {}, -1;
    end;

    if v142 == 1 then
        local v149 = v143[1][2];
        v145[v149] = 1;
        v148[v149] = 0;

        return v145, v148, v149;
    end;

    sort(v143, SortByFirstThenSecond);

    for i = 1, v142 do
        v144[i] = v143[i];
    end;

    while v142 > 1 do
        local v150 = MinHeapPop(v144, v142);
        local v151 = v142 - 1;
        local v152 = MinHeapPop(v144, v151);
        local v153 = v151 - 1;
        MinHeapPush(v144, {
            v150[1] + v152[1],
            -1,
            v150,
            v152
        }, v153);
        v142 = v153 + 1;
    end;

    local v154 = {
        v144[1],
        {},
        {},
        {}
    };
    v144[1][1] = 0;
    local v155 = 1;
    local v156 = 1;
    local v157 = 0;

    while v155 <= v156 do
        local v158 = v154[v155];
        local v159 = v158[1];
        local v160 = v158[2];
        local v161 = v158[3];
        local v162 = v158[4];

        if v161 then
            v156 = v156 + 1;
            v154[v156] = v161;
            v161[1] = v159 + 1;
        end;

        if v162 then
            v156 = v156 + 1;
            v154[v156] = v162;
            v162[1] = v159 + 1;
        end;

        v155 = v155 + 1;

        if p140 < v159 then
            v157 = v157 + 1;
            v159 = p140;
        end;

        if v160 >= 0 then
            v145[v160] = v159;

            if v146 < v160 then
                v146 = v160 or v146;
            end;

            v147[v159] = (v147[v159] or 0) + 1;
        end;
    end;

    if v157 > 0 then
        repeat
            local v163 = p140 - 1;

            while (v147[v163] or 0) == 0 do
                v163 = v163 - 1;
            end;

            v147[v163] = v147[v163] - 1;
            v147[v163 + 1] = (v147[v163 + 1] or 0) + 2;
            v147[p140] = v147[p140] - 1;
            v157 = v157 - 2;
        until v157 <= 0;

        local v164 = 1;

        for i = p140, 1, -1 do
            local v165 = v147[i] or 0;

            while v165 > 0 do
                v145[v143[v164][2]] = i;
                v165 = v165 - 1;
                v164 = v164 + 1;
            end;
        end;
    end;

    return v145, GetHuffmanCodeFromBitlen(v147, v145, p141, p140), v146;
end;

local function RunLengthEncodeHuffmanBitlen(p166, p167, p168, p169) -- Line: 1187
    local v170 = p167 + (p169 < 0 and 0 or p169) + 1;
    local v171 = 0;
    local v172 = 0;
    local v173 = {};
    local v174 = {};
    local v175 = nil;
    local v176 = 0;
    local v177 = {};

    for i = 0, v170 + 1 do
        local v178;

        if i <= p167 then
            v178 = p166[i] or 0;
        else
            v178 = i <= v170 and (p168[i - p167 - 1] or 0) or nil;
        end;

        if v178 == v175 then
            v176 = v176 + 1;

            if v178 == 0 or v176 ~= 6 then
                if v178 == 0 and v176 == 138 then
                    v171 = v171 + 1;
                    v177[v171] = 18;
                    v172 = v172 + 1;
                    v173[v172] = 127;
                    v174[18] = (v174[18] or 0) + 1;
                    v176 = 0;
                end;
            else
                v171 = v171 + 1;
                v177[v171] = 16;
                v172 = v172 + 1;
                v173[v172] = 3;
                v174[16] = (v174[16] or 0) + 1;
                v176 = 0;
            end;
        else
            if v176 == 1 then
                assert(v175);
                v171 = v171 + 1;
                v177[v171] = v175;
                v174[v175] = (v174[v175] or 0) + 1;
            elseif v176 == 2 then
                assert(v175);
                local v179 = v171 + 1;
                v177[v179] = v175;
                v171 = v179 + 1;
                v177[v171] = v175;
                v174[v175] = (v174[v175] or 0) + 2;
            elseif v176 >= 3 then
                v171 = v171 + 1;
                local v180 = v175 == 0 and (v176 <= 10 and 17 or 18) or 16;
                v177[v171] = v180;
                v174[v180] = (v174[v180] or 0) + 1;
                v172 = v172 + 1;
                v173[v172] = v176 <= 10 and v176 - 3 or v176 - 11;
            end;

            if v178 and v178 ~= 0 then
                v171 = v171 + 1;
                v177[v171] = v178;
                v174[v178] = (v174[v178] or 0) + 1;
                v175 = v178;
                v176 = 0;
            else
                v175 = v178;
                v176 = 1;
            end;
        end;
    end;

    return v177, v173, v174;
end;

local function LoadStringToTable(p181, p182, p183, p184, p185) -- Line: 1272
    -- upvalues: byte (copy)
    local v186 = p183 - p185;

    while v186 <= p184 - 15 - p185 do
        local v187, v188, v189, v190, v191, v192, v193, v194, v195, v196, v197, v198, v199, v200, v201, v202 = byte(p181, v186 + p185, v186 + 15 + p185);
        p182[v186] = v187;
        p182[v186 + 1] = v188;
        p182[v186 + 2] = v189;
        p182[v186 + 3] = v190;
        p182[v186 + 4] = v191;
        p182[v186 + 5] = v192;
        p182[v186 + 6] = v193;
        p182[v186 + 7] = v194;
        p182[v186 + 8] = v195;
        p182[v186 + 9] = v196;
        p182[v186 + 10] = v197;
        p182[v186 + 11] = v198;
        p182[v186 + 12] = v199;
        p182[v186 + 13] = v200;
        p182[v186 + 14] = v201;
        p182[v186 + 15] = v202;
        v186 = v186 + 16;
    end;

    while v186 <= p184 - p185 do
        p182[v186] = byte(p181, v186 + p185, v186 + p185);
        v186 = v186 + 1;
    end;

    return p182;
end;

local function GetBlockLZ77Result(p203, p204, p205, p206, p207, p208, p209) -- Line: 1328
    -- upvalues: u85 (copy), u5 (copy), u6 (copy), u7 (copy), u9 (copy), u8 (copy), u4 (copy)
    local v210 = u85[p203];
    local v211 = v210[1];
    local v212 = v210[2];
    local v213 = v210[3];
    local v214 = v210[4];
    local v215 = v210[5];
    local v216 = (v211 or not v213) and 2147483646 or v213;
    local v217 = v215 - v215 % 4 / 4;
    local v218, v219, v220;

    if p209 then
        v218 = p209.hash_tables;
        v219 = p209.string_table;
        v220 = p209.strlen;
        assert(p206 == 1);

        if p206 <= p207 and v220 >= 2 then
            local v221 = v219[v220 - 1] * 65536 + v219[v220] * 256 + p204[1];
            local v222 = p205[v221];

            if not v222 then
                v222 = {};
                p205[v221] = v222;
            end;

            v222[#v222 + 1] = -1;
        end;

        if p206 + 1 <= p207 and v220 >= 1 then
            local v223 = v219[v220] * 65536 + p204[1] * 256 + p204[2];
            local v224 = p205[v223];

            if not v224 then
                v224 = {};
                p205[v223] = v224;
            end;

            v224[#v224 + 1] = 0;
        end;
    else
        v220 = 0;
        v219 = {};
        v218 = {};
    end;

    local v225 = v220 + 3;
    local v226 = (p204[p206 - p208] or 0) * 256 + (p204[p206 + 1 - p208] or 0);
    local v227 = p207 + (v211 and 1 or 0);
    local v228 = 0;
    local v229 = 0;
    local v230 = 0;
    local v231 = {};
    local v232 = {};
    local v233 = 0;
    local v234 = {};
    local v235 = 0;
    local v236 = 0;
    local v237 = {};
    local v238 = false;
    local v239 = {};
    local v240 = {};

    while true do
        if p206 > v227 then
            v239[v236 + 1] = 256;
            v240[256] = (v240[256] or 0) + 1;

            return v239, v234, v240, v231, v237, v232;
        end;

        local v241 = p206 - p208;
        local v242 = p208 - 3;
        local v243 = 0;
        v226 = (v226 * 256 + (p204[v241 + 2] or 0)) % 16777216;
        local v244 = nil;
        local v245 = p205[v226];
        local v246, v247;

        if v245 then
            v246 = #v245;
            v244 = v245;
            v247 = v246;
        else
            v246 = 0;
            v245 = {};
            p205[v226] = v245;

            if v218 then
                v244 = v218[v226];
                v247 = v244 and (#v244 or 0) or 0;
            else
                v247 = 0;
            end;
        end;

        if p206 <= p207 then
            v245[v246 + 1] = p206;
        end;

        local v248, v249;

        if v247 > 0 and (p206 + 2 <= p207 and (not v211 or v228 < v213)) then
            local v250;

            if v211 and (v212 <= v228 and v217) then
                v250 = v217;
            else
                v250 = v215;
            end;

            local v251 = p207 - p206;
            local v252 = (v251 >= 257 and 257 or v251) + v241;
            local v253 = v241 + 3;
            v248 = v229;

            while true do
                if v247 < 1 or v250 <= 0 then
                    v249 = v243;
                    break;
                end;

                local v254 = v244[v247];

                if p206 - v254 > 32768 then
                    v249 = v243;
                    break;
                end;

                local v255;

                if v254 < p206 then
                    if v254 >= -257 then
                        local v256 = v254 - v242;
                        v255 = v253;

                        while v253 <= v252 and p204[v256] == p204[v253] do
                            v253 = v253 + 1;
                            v256 = v256 + 1;
                        end;
                    else
                        local v257 = v225 + v254;
                        v255 = v253;

                        while v253 <= v252 and v219[v257] == p204[v253] do
                            v253 = v253 + 1;
                            v257 = v257 + 1;
                        end;
                    end;

                    v249 = v253 - v241;

                    if v243 < v249 then
                        v248 = p206 - v254;
                    else
                        v249 = v243;
                    end;

                    if v214 <= v249 then
                        break;
                    end;
                else
                    v255 = v253;
                    v249 = v243;
                end;

                v247 = v247 - 1;
                v250 = v250 - 1;

                if v247 == 0 and (v254 > 0 and v218) then
                    v244 = v218[v226];
                    v247 = v244 and (#v244 or 0) or 0;
                end;

                v253 = v255;
                v243 = v249;
            end;
        else
            v248 = v229;
            v249 = v243;
        end;

        if not v211 then
            v228 = v249;
            v229 = v248;
        end;

        if v211 and not v238 or (v228 <= 3 and (v228 ~= 3 or v229 >= 4096) or v249 > v228) then
            if v211 and not v238 then
                p206 = p206 + 1;
                v238 = true;
            else
                if v211 then
                    v241 = v241 - 1 or v241;
                end;

                local v258 = p204[v241];
                v236 = v236 + 1;
                v239[v236] = v258;
                v240[v258] = (v240[v258] or 0) + 1;
                p206 = p206 + 1;
            end;
        else
            local v259 = u5[v228];
            local v260 = u6[v228];
            local v261, v262, v263;

            if v229 <= 256 then
                v261 = u7[v229];
                v262 = u9[v229];
                v263 = u8[v229];
            else
                v261 = 16;
                v263 = 7;
                local v264 = 384;
                local v265 = 512;

                while true do
                    if v229 <= v264 then
                        v262 = (v229 - v265 / 2 - 1) % (v265 / 4);
                    end;

                    if v229 <= v265 then
                        v262 = (v229 - v265 / 2 - 1) % (v265 / 4);
                        v261 = v261 + 1;
                    end;

                    v261 = v261 + 2;
                    v263 = v263 + 1;
                    v264 = v264 * 2;
                    v265 = v265 * 2;
                end;
            end;

            v236 = v236 + 1;
            v239[v236] = v259;
            v240[v259] = (v240[v259] or 0) + 1;
            v230 = v230 + 1;
            v231[v230] = v261;
            v232[v261] = (v232[v261] or 0) + 1;

            if v260 > 0 then
                v233 = v233 + 1;
                v234[v233] = u4[v228];
            end;

            if v263 > 0 then
                v235 = v235 + 1;
                v237[v235] = v262;
            end;

            for i = p206 + 1, p206 + v228 - (v211 and 2 or 1) do
                v226 = (v226 * 256 + (p204[i - p208 + 2] or 0)) % 16777216;

                if v228 <= v216 then
                    local v266 = p205[v226];

                    if not v266 then
                        v266 = {};
                        p205[v226] = v266;
                    end;

                    v266[#v266 + 1] = i;
                end;
            end;

            p206 = p206 + v228 - (v211 and 1 or 0);
            v238 = false;
        end;

        v229 = v248;
        v228 = v249;
    end;
end;

local function GetBlockDynamicHuffmanHeader(p267, p268) -- Line: 1582
    -- upvalues: GetHuffmanBitlenAndCode (copy), RunLengthEncodeHuffmanBitlen (copy), u16 (copy)
    local v269, v270, v271 = GetHuffmanBitlenAndCode(p267, 15, 285);
    local v272, v273, v274 = GetHuffmanBitlenAndCode(p268, 15, 29);
    local v275, v276, v277 = RunLengthEncodeHuffmanBitlen(v269, v271, v272, v274);
    local v278, v279 = GetHuffmanBitlenAndCode(v277, 7, 18);
    local v280 = 0;

    for i = 1, 19 do
        if (v278[u16[i]] or 0) ~= 0 then
            v280 = i;
        end;
    end;

    local v281 = v274 + 1 - 1;

    return v271 + 1 - 257, v281 < 0 and 0 or v281, v280 - 4, v278, v279, v275, v276, v269, v270, v272, v273;
end;

local function GetDynamicHuffmanBlockSize(p282, p283, p284, p285, p286, p287, p288) -- Line: 1644
    -- upvalues: u17 (copy)
    local v289 = 17 + (p284 + 4) * 3;

    for i = 1, #p286 do
        local v290 = p286[i];
        v289 = v289 + p285[v290];

        if v290 >= 16 then
            v289 = v289 + (v290 == 16 and 2 or (v290 == 17 and 3 or 7));
        end;
    end;

    local v291 = 0;

    for i = 1, #p282 do
        local v292 = p282[i];
        v289 = v289 + p287[v292];

        if v292 > 256 then
            v291 = v291 + 1;

            if v292 > 264 and v292 < 285 then
                v289 = v289 + u17[v292 - 256];
            end;

            local v293 = p283[v291];
            v289 = v289 + p288[v293];

            if v293 > 3 then
                v289 = v289 + ((v293 - v293 % 2) / 2 - 1);
            end;
        end;
    end;

    return v289;
end;

local function CompressDynamicHuffmanBlock(p294, p295, p296, p297, p298, p299, p300, p301, p302, p303, p304, p305, p306, p307, p308, p309, p310) -- Line: 1690
    -- upvalues: u16 (copy), u17 (copy)
    p294(p295 and 1 or 0, 1);
    p294(2, 2);
    p294(p300, 5);
    p294(p301, 5);
    p294(p302, 4);

    for i = 1, p302 + 4 do
        p294(p303[u16[i]] or 0, 3);
    end;

    local v311 = 1;

    for i = 1, #p305 do
        local v312 = p305[i];
        p294(p304[v312], p303[v312]);

        if v312 >= 16 then
            p294(p306[v311], v312 == 16 and 2 or (v312 == 17 and 3 or 7));
            v311 = v311 + 1;
        end;
    end;

    local v313 = 0;
    local v314 = 0;
    local v315 = 0;

    for i = 1, #p296 do
        local v316 = p296[i];
        p294(p308[v316], p307[v316]);

        if v316 > 256 then
            v314 = v314 + 1;

            if v316 > 264 and v316 < 285 then
                v313 = v313 + 1;
                p294(p297[v313], u17[v316 - 256]);
            end;

            local v317 = p298[v314];
            p294(p310[v317], p309[v317]);

            if v317 > 3 then
                v315 = v315 + 1;
                p294(p299[v315], (v317 - v317 % 2) / 2 - 1);
            end;
        end;
    end;
end;

local function GetFixedHuffmanBlockSize(p318, p319) -- Line: 1771
    -- upvalues: u18 (ref), u17 (copy)
    local v320 = 3;
    local v321 = 0;

    for i = 1, #p318 do
        local v322 = p318[i];
        v320 = v320 + u18[v322];

        if v322 > 256 then
            v321 = v321 + 1;

            if v322 > 264 and v322 < 285 then
                v320 = v320 + u17[v322 - 256];
            end;

            local v323 = p319[v321];
            v320 = v320 + 5;

            if v323 > 3 then
                v320 = v320 + ((v323 - v323 % 2) / 2 - 1);
            end;
        end;
    end;

    return v320;
end;

local function CompressFixedHuffmanBlock(p324, p325, p326, p327, p328, p329) -- Line: 1799
    -- upvalues: u22 (ref), u18 (ref), u17 (copy), u19 (ref)
    p324(p325 and 1 or 0, 1);
    p324(1, 2);
    local v330 = 0;
    local v331 = 0;
    local v332 = 0;

    for i = 1, #p326 do
        local v333 = p326[i];
        p324(u22[v333], u18[v333]);

        if v333 > 256 then
            v330 = v330 + 1;

            if v333 > 264 and v333 < 285 then
                v331 = v331 + 1;
                p324(p327[v331], u17[v333 - 256]);
            end;

            local v334 = p328[v330];
            p324(u19[v334], 5);

            if v334 > 3 then
                v332 = v332 + 1;
                p324(p329[v332], (v334 - v334 % 2) / 2 - 1);
            end;
        end;
    end;
end;

local function GetStoreBlockSize(p335, p336, p337) -- Line: 1847
    assert(p336 - p335 + 1 <= 65535);

    return 3 + (8 - (p337 + 3) % 8) % 8 + 32 + (p336 - p335 + 1) * 8;
end;

local function CompressStoreBlock(p338, p339, p340, p341, p342, p343, p344) -- Line: 1861
    -- upvalues: u2 (copy)
    assert(p343 - p342 + 1 <= 65535);
    p338(p340 and 1 or 0, 1);
    p338(0, 2);
    local v345 = (8 - (p344 + 3) % 8) % 8;

    if v345 > 0 then
        p338(u2[v345] - 1, v345);
    end;

    local v346 = p343 - p342 + 1;
    p338(v346, 16);
    p338(255 - v346 % 256 + (255 - (v346 - v346 % 256) / 256) * 256, 16);
    p339(p341:sub(p342, p343));
end;

local function Deflate(p347, p348, p349, p350, p351, p352) -- Line: 1899
    -- upvalues: LoadStringToTable (copy), GetBlockLZ77Result (copy), GetBlockDynamicHuffmanHeader (copy), GetDynamicHuffmanBlockSize (copy), GetFixedHuffmanBlockSize (copy), CompressStoreBlock (copy), CompressFixedHuffmanBlock (copy), CompressDynamicHuffmanBlock (copy)
    local v353 = {};
    local v354 = {};
    local v355 = nil;
    local v356 = 0;
    local v357 = 0;
    local v358, _ = p350(3);
    local v359 = #p351;
    local v360 = nil;
    local v361 = nil;

    if p347 then
        if p347.level then
            v360 = p347.level;
        end;

        if p347.strategy then
            v361 = p347.strategy;
        end;
    end;

    if not v360 then
        if v359 < 2048 then
            v360 = 7;
        elseif v359 > 65536 then
            v360 = 3;
        else
            v360 = 5;
        end;
    end;

    while not v355 do
        local v362;

        if v356 == 0 then
            v356 = 1;
            v362 = 0;
            v357 = 65535;
        else
            v356 = v357 + 1;
            v357 = v357 + 32768;
            v362 = v356 - 32768 - 1;
        end;

        if v359 <= v357 then
            v357 = v359;
            v355 = true;
        else
            v355 = false;
        end;

        local v363, v364, v365, v366, v367, v368, v369, v370, v371, v372, v373, v374, v375, v376, v377, v378, v379;

        if v360 == 0 then
            v363 = {};
            v364 = {};
            v365 = {};
            v366 = {};
            v367 = {};
            v368 = {};
            v369 = {};
            v370 = nil;
            v371 = {};
            v372 = nil;
            v373 = {};
            v374 = nil;
            v375 = nil;
            v376 = {};
            v377 = nil;
            v378 = {};
            v379 = {};
        else
            LoadStringToTable(p351, v353, v356, v357 + 3, v362);

            if v356 == 1 and p352 then
                local string_table = p352.string_table;
                local strlen = p352.strlen;

                for i = 0, -strlen + 1 < -257 and -257 or -strlen + 1, -1 do
                    v353[i] = string_table[strlen + i];
                end;
            end;

            local v380, v381;

            if v361 == "huffman_only" then
                v365 = {};
                LoadStringToTable(p351, v365, v356, v357, v356 - 1);
                v365[v357 - v356 + 2] = 256;
                v380 = {};
                v366 = {};

                for i = 1, v357 - v356 + 2 do
                    local v382 = v365[i];
                    v380[v382] = (v380[v382] or 0) + 1;
                end;

                v381 = {};
                v371 = {};
                v378 = {};
            else
                v365, v366, v380, v371, v378, v381 = GetBlockLZ77Result(v360, v353, v354, v356, v357, v362, p352);
            end;

            v374, v370, v377, v367, v368, v373, v379, v369, v376, v363, v364 = GetBlockDynamicHuffmanHeader(v380, v381);
            v375 = GetDynamicHuffmanBlockSize(v365, v371, v377, v367, v373, v369, v363);
            v372 = GetFixedHuffmanBlockSize(v365, v371);
        end;

        assert(v357 - v356 + 1 <= 65535);
        local v383 = 3 + (8 - (v358 + 3) % 8) % 8 + 32 + (v357 - v356 + 1) * 8;
        local v384;

        if v372 and (v372 < v383 and v372) then
            v384 = v372;
        else
            v384 = v383;
        end;

        if v375 and (v375 < v384 and v375) then
            v384 = v375;
        end;

        if v360 == 0 or v361 ~= "fixed" and (v361 ~= "dynamic" and v383 == v384) then
            CompressStoreBlock(p348, p349, v355, p351, v356, v357, v358);
            v358 = v358 + v383;
        elseif v361 == "dynamic" or v361 ~= "fixed" and v372 ~= v384 then
            if v361 == "dynamic" or v375 == v384 then
                CompressDynamicHuffmanBlock(p348, v355, v365, v366, v371, v378, v374, v370, v377, v367, v368, v373, v379, v369, v376, v363, v364);
                v358 = v358 + assert(v375);
            end;
        else
            CompressFixedHuffmanBlock(p348, v355, v365, v366, v371, v378);
            v358 = v358 + assert(v372);
        end;

        local v385;

        if v355 then
            v385 = p350(3);
        else
            v385 = p350(0);
        end;

        assert(v385 == v358);

        if not v355 then
            if p352 and v356 == 1 then
                local v386 = 0;

                while v353[v386] do
                    v353[v386] = nil;
                    v386 = v386 - 1;
                end;
            end;

            local v387 = 1;
            p352 = nil;

            for i = v357 - 32767, v357 do
                v353[v387] = v353[i - v362];
                v387 = v387 + 1;
            end;

            for i, v in pairs(v354) do
                local v388 = #v;

                if v388 > 0 and v357 + 1 - v[1] > 32768 then
                    if v388 == 1 then
                        v354[i] = nil;
                    else
                        local v389 = 0;
                        local v390 = {};

                        for i2 = 2, v388 do
                            local v391 = v[i2];

                            if v357 + 1 - v391 <= 32768 then
                                v389 = v389 + 1;
                                v390[v389] = v391;
                            end;
                        end;

                        v354[i] = v390;
                    end;
                end;
            end;
        end;
    end;
end;

local function CompressDeflateInternal(p392, p393, p394) -- Line: 2123
    -- upvalues: CreateWriter (copy), Deflate (copy)
    local v395, v396, v397 = CreateWriter();
    Deflate(p394, v395, v396, v397, p392, p393);
    local v398, v399 = v397(1);
    assert(v399);

    return v399, (8 - v398 % 8) % 8;
end;

local function CompressZlibInternal(p400, p401, p402) -- Line: 2134
    -- upvalues: CreateWriter (copy), Deflate (copy), u15 (copy)
    local v403, v404, v405 = CreateWriter();
    v403(120, 8);
    local v406 = p401 and 1 or 0;
    local v407 = 128 + v406 * 32;
    v403(v407 + (31 - (30720 + v407) % 31), 8);

    if v406 == 1 then
        assert(p401);
        local adler32 = p401.adler32;
        local v408 = adler32 % 256;
        local v409 = (adler32 - v408) / 256;
        local v410 = v409 % 256;
        local v411 = (v409 - v410) / 256;
        local v412 = v411 % 256;
        v403((v411 - v412) / 256 % 256, 8);
        v403(v412, 8);
        v403(v410, 8);
        v403(v408, 8);
    end;

    Deflate(p402, v403, v404, v405, p400, p401);
    v405(2);
    local v413 = u15:Adler32(p400);
    local v414 = v413 % 256;
    local v415 = (v413 - v414) / 256;
    local v416 = v415 % 256;
    local v417 = (v415 - v416) / 256;
    local v418 = v417 % 256;
    v403((v417 - v418) / 256 % 256, 8);
    v403(v418, 8);
    v403(v416, 8);
    v403(v414, 8);
    local v419, v420 = v405(1);
    assert(v420);

    return v420, (8 - v419 % 8) % 8;
end;

function u15.CompressDeflate(p421, p422, p423) -- Line: 2205
    -- upvalues: IsValidArguments (copy), CompressDeflateInternal (copy)
    local v424, v425 = IsValidArguments(p422, false, nil, true, p423);

    if not v424 then
        error("Usage: LibDeflate:CompressDeflate(str, configs): " .. v425, 2);
    end;

    return CompressDeflateInternal(p422, nil, p423);
end;

function u15.CompressDeflateWithDict(p426, p427, p428, p429) -- Line: 2229
    -- upvalues: IsValidArguments (copy), CompressDeflateInternal (copy)
    local v430, v431 = IsValidArguments(p427, true, p428, true, p429);

    if not v430 then
        error("Usage: LibDeflate:CompressDeflateWithDict" .. "(str, dictionary, configs): " .. v431, 2);
    end;

    return CompressDeflateInternal(p427, p428, p429);
end;

function u15.CompressZlib(p432, p433, p434) -- Line: 2247
    -- upvalues: IsValidArguments (copy), CompressZlibInternal (copy)
    local v435, v436 = IsValidArguments(p433, false, nil, true, p434);

    if not v435 then
        error("Usage: LibDeflate:CompressZlib(str, configs): " .. v436, 2);
    end;

    return CompressZlibInternal(p433, nil, p434);
end;

function u15.CompressZlibWithDict(p437, p438, p439, p440) -- Line: 2268
    -- upvalues: IsValidArguments (copy), CompressZlibInternal (copy)
    local v441, v442 = IsValidArguments(p438, true, p439, true, p440);

    if not v441 then
        error("Usage: LibDeflate:CompressZlibWithDict" .. "(str, dictionary, configs): " .. v442, 2);
    end;

    return CompressZlibInternal(p438, p439, p440);
end;

local function CreateReader(u443) -- Line: 2296
    -- upvalues: u2 (copy), byte (copy), char (copy), sub (copy), u3 (copy)
    local u444 = #u443;
    local u445 = 1;
    local u446 = 0;
    local u447 = 0;

    return function(p448) -- Line: 2309, Name: ReadBits
        -- upvalues: u2 (ref), u446 (ref), u447 (ref), u443 (copy), u445 (ref), byte (ref)
        local v449 = u2[p448];

        if p448 <= u446 then
            local v450 = u447 % v449;
            u447 = (u447 - v450) / v449;
            u446 = u446 - p448;

            return v450;
        end;

        local v451 = u2[u446];
        local v452, v453, v454, v455 = byte(u443, u445, u445 + 3);
        u447 = u447 + ((v452 or 0) + (v453 or 0) * 256 + (v454 or 0) * 65536 + (v455 or 0) * 16777216) * v451;
        u445 = u445 + 4;
        u446 = u446 + 32 - p448;
        local v456 = u447 % v449;
        u447 = (u447 - v456) / v449;

        return v456;
    end, function(p457, p458, p459) -- Line: 2337, Name: ReadBytes
        -- upvalues: u446 (ref), u447 (ref), char (ref), u444 (copy), u445 (ref), u443 (copy), sub (ref)
        assert(u446 % 8 == 0);
        local v460;

        if u446 / 8 < p457 then
            v460 = u446 / 8 or p457;
        else
            v460 = p457;
        end;

        for _ = 1, v460 do
            local v461 = u447 % 256;
            p459 = p459 + 1;
            p458[p459] = char(v461);
            u447 = (u447 - v461) / 256;
        end;

        u446 = u446 - v460 * 8;
        local v462 = p457 - v460;

        if (u444 - u445 - v462 + 1) * 8 + u446 < 0 then
            return -1;
        end;

        for i = u445, u445 + v462 - 1 do
            p459 = p459 + 1;
            p458[p459] = sub(u443, i, i);
        end;

        u445 = u445 + v462;

        return p459;
    end, function(p463, p464, p465) -- Line: 2372, Name: Decode
        -- upvalues: u446 (ref), u443 (copy), u2 (ref), u445 (ref), byte (ref), u447 (ref), u3 (ref)
        local v466, v467, v468;

        if p465 > 0 then
            if u446 < 15 and u443 then
                local v469 = u2[u446];
                local v470, v471, v472, v473 = byte(u443, u445, u445 + 3);
                u447 = u447 + ((v470 or 0) + (v471 or 0) * 256 + (v472 or 0) * 65536 + (v473 or 0) * 16777216) * v469;
                u445 = u445 + 4;
                u446 = u446 + 32;
            end;

            local v474 = u2[p465];
            u446 = u446 - p465;
            local v475 = u447 % v474;
            u447 = (u447 - v475) / v474;
            local v476 = u3[p465][v475];
            v466 = p463[p465];

            if v476 < v466 then
                return p464[v476];
            end;

            v467 = v466 * 2;
            v468 = v476 * 2;
        else
            v468 = 0;
            v467 = 0;
            v466 = 0;
        end;

        for i = p465 + 1, 15 do
            local v477 = u447 % 2;
            u447 = (u447 - v477) / 2;
            u446 = u446 - 1;

            if v477 == 1 then
                v468 = v468 + 1 - v468 % 2 or v468;
            end;

            local v478 = p463[i] or 0;
            local v479 = v468 - v467;

            if v479 < v478 then
                return p464[v466 + v479];
            end;

            v466 = v466 + v478;
            v467 = (v467 + v478) * 2;
            v468 = v468 * 2;
        end;

        return -10;
    end, function() -- Line: 2431, Name: ReaderBitlenLeft
        -- upvalues: u444 (copy), u445 (ref), u446 (ref)
        return (u444 - u445 + 1) * 8 + u446;
    end, function() -- Line: 2435, Name: SkipToByteBoundary
        -- upvalues: u446 (ref), u2 (ref), u447 (ref)
        local v480 = u446 % 8;
        local v481 = u2[v480];
        u446 = u446 - v480;
        u447 = (u447 - u447 % v481) / v481;
    end;
end;

local function CreateDecompressState(p482, p483) -- Line: 2450
    -- upvalues: CreateReader (copy)
    local v484, v485, v486, v487, v488 = CreateReader(p482);

    return {
        buffer_size = 0,
        ReadBits = v484,
        ReadBytes = v485,
        Decode = v486,
        ReaderBitlenLeft = v487,
        SkipToByteBoundary = v488,
        buffer = {},
        result_buffer = {},
        dictionary = p483
    };
end;

local function GetHuffmanForDecode(p489, p490, p491) -- Line: 2475
    local v492 = p491;
    local v493 = {};

    for i = 0, p490 do
        local v494 = p489[i] or 0;

        if v494 > 0 and (v494 < p491 and v494) then
            p491 = v494;
        end;

        v493[v494] = (v493[v494] or 0) + 1;
    end;

    if v493[0] == p490 + 1 then
        return 0, v493, {}, 0;
    end;

    local v495 = 1;

    for i = 1, v492 do
        v495 = v495 * 2 - (v493[i] or 0);

        if v495 < 0 then
            return v495, {}, {}, 0;
        end;
    end;

    local v496 = { 0 };

    for i = 1, v492 - 1 do
        v496[i + 1] = v496[i] + (v493[i] or 0);
    end;

    local v497 = {};

    for i = 0, p490 do
        local v498 = p489[i] or 0;

        if v498 ~= 0 then
            v497[v496[v498]] = i;
            v496[v498] = v496[v498] + 1;
        end;
    end;

    return v495, v493, v497, p491;
end;

local function DecodeUntilEndOfBlock(p499, p500, p501, p502, p503, p504, p505) -- Line: 2541
    -- upvalues: u1 (copy), u10 (copy), u17 (copy), u11 (copy), u12 (copy), concat (copy)
    local buffer = p499.buffer;
    local buffer_size = p499.buffer_size;
    local ReadBits = p499.ReadBits;
    local Decode = p499.Decode;
    local ReaderBitlenLeft = p499.ReaderBitlenLeft;
    local result_buffer = p499.result_buffer;
    local dictionary = p499.dictionary;
    local v506, v507, v508;

    if dictionary and not buffer[0] then
        v506 = dictionary.string_table;
        v507 = dictionary.strlen;
        v508 = -v507 + 1;

        for i = 0, -v507 + 1 < -257 and -257 or -v507 + 1, -1 do
            buffer[i] = u1[v506[v507 + i]];
        end;
    else
        v508 = 1;
        v507 = nil;
        v506 = {};
    end;

    while true do
        local v509 = Decode(p500, p501, p502);

        if v509 < 0 or v509 > 285 then
            break;
        end;

        if v509 < 256 then
            buffer_size = buffer_size + 1;
            buffer[buffer_size] = u1[v509];
        elseif v509 > 256 then
            local v510 = v509 - 256;
            local v511 = u10[v510];

            if v510 >= 8 then
                v511 = v511 + ReadBits(u17[v510]) or v511;
            end;

            v509 = Decode(p503, p504, p505);

            if v509 < 0 or v509 > 29 then
                return -10;
            end;

            local v512 = u11[v509];

            if v512 > 4 then
                v512 = v512 + ReadBits(u12[v509]) or v512;
            end;

            local v513 = buffer_size - v512 + 1;

            if v513 < v508 then
                return -11;
            end;

            if v513 >= -257 then
                for _ = 1, v511 do
                    buffer_size = buffer_size + 1;
                    buffer[buffer_size] = buffer[v513];
                    v513 = v513 + 1;
                end;
            else
                local v514 = v507 + v513;

                for _ = 1, v511 do
                    buffer_size = buffer_size + 1;
                    buffer[buffer_size] = u1[v506[v514]];
                    v514 = v514 + 1;
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

        if v509 == 256 then
            p499.buffer_size = buffer_size;

            return 0;
        end;
    end;

    return -10;
end;

local function DecompressStoreBlock(p515) -- Line: 2634
    -- upvalues: concat (copy)
    local buffer = p515.buffer;
    local buffer_size = p515.buffer_size;
    local ReadBits = p515.ReadBits;
    local ReadBytes = p515.ReadBytes;
    local ReaderBitlenLeft = p515.ReaderBitlenLeft;
    local result_buffer = p515.result_buffer;
    p515.SkipToByteBoundary();
    local v516 = ReadBits(16);

    if ReaderBitlenLeft() < 0 then
        return 2;
    end;

    local v517 = ReadBits(16);

    if ReaderBitlenLeft() < 0 then
        return 2;
    end;

    if v516 % 256 + v517 % 256 ~= 255 then
        return -2;
    end;

    if (v516 - v516 % 256) / 256 + (v517 - v517 % 256) / 256 ~= 255 then
        return -2;
    end;

    local v518 = ReadBytes(v516, buffer, buffer_size);

    if v518 < 0 then
        return 2;
    end;

    if v518 >= 65536 then
        result_buffer[#result_buffer + 1] = concat(buffer, "", 1, 32768);

        for i = 32769, v518 do
            buffer[i - 32768] = buffer[i];
        end;

        v518 = v518 - 32768;
        buffer[v518 + 1] = nil;
    end;

    p515.buffer_size = v518;

    return 0;
end;

local function DecompressFixBlock(p519) -- Line: 2683
    -- upvalues: DecodeUntilEndOfBlock (copy), u13 (ref), u20 (ref), u21 (ref), u14 (ref)
    return DecodeUntilEndOfBlock(p519, u13, u20, 7, u21, u14, 5);
end;

local function DecompressDynamicBlock(p520) -- Line: 2698
    -- upvalues: u16 (copy), GetHuffmanForDecode (copy), DecodeUntilEndOfBlock (copy)
    local ReadBits = p520.ReadBits;
    local Decode = p520.Decode;
    local v521 = ReadBits(5) + 257;
    local v522 = ReadBits(5) + 1;
    local v523 = ReadBits(4) + 4;

    if v521 > 286 or v522 > 30 then
        return -3;
    end;

    local v524 = {};

    for i = 1, v523 do
        v524[u16[i]] = ReadBits(3);
    end;

    local v525, v526, v527, v528 = GetHuffmanForDecode(v524, 18, 7);

    if v525 ~= 0 then
        return -4;
    end;

    local v529 = 0;
    local v530 = {};
    local v531 = {};

    while v529 < v521 + v522 do
        local v532 = Decode(v526, v527, v528);

        if v532 < 0 then
            return v532;
        end;

        if v532 < 16 then
            if v529 < v521 then
                v530[v529] = v532;
            else
                v531[v529 - v521] = v532;
            end;

            v529 = v529 + 1;
        else
            local v533 = 0;
            local v534;

            if v532 == 16 then
                if v529 == 0 then
                    return -5;
                end;

                if v529 - 1 < v521 then
                    v533 = v530[v529 - 1];
                else
                    v533 = v531[v529 - v521 - 1];
                end;

                v534 = 3 + ReadBits(2);
            elseif v532 == 17 then
                v534 = 3 + ReadBits(3);
            else
                v534 = 11 + ReadBits(7);
            end;

            if v529 + v534 > v521 + v522 then
                return -6;
            end;

            while v534 > 0 do
                v534 = v534 - 1;

                if v529 < v521 then
                    v530[v529] = v533;
                else
                    v531[v529 - v521] = v533;
                end;

                v529 = v529 + 1;
            end;
        end;
    end;

    if (v530[256] or 0) == 0 then
        return -9;
    end;

    local v535, v536, v537, v538 = GetHuffmanForDecode(v530, v521 - 1, 15);

    if v535 ~= 0 and (v535 < 0 or v521 ~= (v536[0] or 0) + (v536[1] or 0)) then
        return -7;
    end;

    local v539, v540, v541, v542 = GetHuffmanForDecode(v531, v522 - 1, 15);

    return v539 ~= 0 and (v539 < 0 or v522 ~= (v540[0] or 0) + (v540[1] or 0)) and -8 or DecodeUntilEndOfBlock(p520, v536, v537, v538, v540, v541, v542);
end;

local function Inflate(p543) -- Line: 2818
    -- upvalues: DecompressStoreBlock (copy), DecodeUntilEndOfBlock (copy), u13 (ref), u20 (ref), u21 (ref), u14 (ref), DecompressDynamicBlock (copy), concat (copy)
    local ReadBits = p543.ReadBits;
    local v544 = nil;

    while not v544 do
        v544 = ReadBits(1) == 1;
        local v545 = ReadBits(2);
        local v546;

        if v545 == 0 then
            v546 = DecompressStoreBlock(p543);
        elseif v545 == 1 then
            v546 = DecodeUntilEndOfBlock(p543, u13, u20, 7, u21, u14, 5);
        else
            if v545 ~= 2 then
                return nil, -1;
            end;

            v546 = DecompressDynamicBlock(p543);
        end;

        if v546 ~= 0 then
            return nil, v546;
        end;
    end;

    p543.result_buffer[#p543.result_buffer + 1] = concat(p543.buffer, "", 1, p543.buffer_size);

    return concat(p543.result_buffer), 0;
end;

local function DecompressDeflateInternal(p547, p548) -- Line: 2847
    -- upvalues: CreateDecompressState (copy), Inflate (copy)
    local v549 = CreateDecompressState(p547, p548);
    local v550, v551 = Inflate(v549);

    if not v550 then
        return nil, v551;
    end;

    local v552 = v549.ReaderBitlenLeft();

    return v550, (v552 - v552 % 8) / 8;
end;

local function DecompressZlibInternal(p553, p554) -- Line: 2861
    -- upvalues: CreateDecompressState (copy), Inflate (copy), u15 (copy)
    local v555 = CreateDecompressState(p553, p554);
    local ReadBits = v555.ReadBits;
    local v556 = ReadBits(8);

    if v555.ReaderBitlenLeft() < 0 then
        return nil, 2;
    end;

    local v557 = v556 % 16;

    if v557 ~= 8 then
        return nil, -12;
    end;

    if (v556 - v557) / 16 > 7 then
        return nil, -13;
    end;

    local v558 = ReadBits(8);

    if v555.ReaderBitlenLeft() < 0 then
        return nil, 2;
    end;

    if (v556 * 256 + v558) % 31 ~= 0 then
        return nil, -14;
    end;

    local _ = (v558 - v558 % 64) / 64 % 4;

    if (v558 - v558 % 32) / 32 % 2 == 1 then
        if not p554 then
            return nil, -16;
        end;

        local v559 = ReadBits(8);
        local v560 = ReadBits(8);
        local v561 = ReadBits(8);
        local v562 = ReadBits(8);

        if v555.ReaderBitlenLeft() < 0 then
            return nil, 2;
        end;

        if (v559 * 16777216 + v560 * 65536 + v561 * 256 + v562) % 4294967296 ~= p554.adler32 % 4294967296 then
            return nil, -17;
        end;
    end;

    local v563, v564 = Inflate(v555);

    if not v563 then
        return nil, v564;
    end;

    v555.SkipToByteBoundary();
    local v565 = ReadBits(8);
    local v566 = ReadBits(8);
    local v567 = ReadBits(8);
    local v568 = ReadBits(8);

    if v555.ReaderBitlenLeft() < 0 then
        return nil, 2;
    end;

    local v569 = u15:Adler32(v563);

    if (v565 * 16777216 + v566 * 65536 + v567 * 256 + v568) % 4294967296 ~= v569 % 4294967296 then
        return nil, -15;
    end;

    local v570 = v555.ReaderBitlenLeft();

    return v563, (v570 - v570 % 8) / 8;
end;

function u15.DecompressDeflate(p571, p572) -- Line: 2943
    -- upvalues: DecompressDeflateInternal (copy)
    local v573, v574;

    if type(p572) == "string" then
        v573 = true;
        v574 = "";
    else
        v574 = ("\'str\' - string expected got \'%s\'."):format((type(p572)));
        v573 = false;
    end;

    if not v573 then
        error("Usage: LibDeflate:DecompressDeflate(str): " .. v574, 2);
    end;

    return DecompressDeflateInternal(p572);
end;

function u15.DecompressDeflateWithDict(p575, p576, p577) -- Line: 2969
    -- upvalues: IsValidDictionary (copy), DecompressDeflateInternal (copy)
    local v578, v579;

    if type(p576) == "string" then
        local v580;
        v580, v578 = IsValidDictionary(p577);

        if v580 then
            v579 = true;
            v578 = "";
        else
            v579 = false;
        end;
    else
        v578 = ("\'str\' - string expected got \'%s\'."):format((type(p576)));
        v579 = false;
    end;

    if not v579 then
        error("Usage: LibDeflate:DecompressDeflateWithDict(str, dictionary): " .. v578, 2);
    end;

    return DecompressDeflateInternal(p576, p577);
end;

function u15.DecompressZlib(p581, p582) -- Line: 2990
    -- upvalues: DecompressZlibInternal (copy)
    local v583, v584;

    if type(p582) == "string" then
        v583 = true;
        v584 = "";
    else
        v584 = ("\'str\' - string expected got \'%s\'."):format((type(p582)));
        v583 = false;
    end;

    if not v583 then
        error("Usage: LibDeflate:DecompressZlib(str): " .. v584, 2);
    end;

    return DecompressZlibInternal(p582);
end;

function u15.DecompressZlibWithDict(p585, p586, p587) -- Line: 3016
    -- upvalues: IsValidDictionary (copy), DecompressZlibInternal (copy)
    local v588, v589;

    if type(p586) == "string" then
        local v590;
        v590, v588 = IsValidDictionary(p587);

        if v590 then
            v589 = true;
            v588 = "";
        else
            v589 = false;
        end;
    else
        v588 = ("\'str\' - string expected got \'%s\'."):format((type(p586)));
        v589 = false;
    end;

    if not v589 then
        error("Usage: LibDeflate:DecompressZlibWithDict(str, dictionary): " .. v588, 2);
    end;

    return DecompressZlibInternal(p586, p587);
end;

u18 = {};

for i = 0, 143 do
    u18[i] = 8;
end;

for i = 144, 255 do
    u18[i] = 9;
end;

u18[256] = 7;
u18[257] = 7;
u18[258] = 7;
u18[259] = 7;
u18[260] = 7;
u18[261] = 7;
u18[262] = 7;
u18[263] = 7;
u18[264] = 7;
u18[265] = 7;
u18[266] = 7;
u18[267] = 7;
u18[268] = 7;
u18[269] = 7;
u18[270] = 7;
u18[271] = 7;
u18[272] = 7;
u18[273] = 7;
u18[274] = 7;
u18[275] = 7;
u18[276] = 7;
u18[277] = 7;
u18[278] = 7;
u18[279] = 7;
u18[280] = 8;
u18[281] = 8;
u18[282] = 8;
u18[283] = 8;
u18[284] = 8;
u18[285] = 8;
u18[286] = 8;
u18[287] = 8;
local v591 = {};

for i = 0, 31 do
    v591[i] = 5;
end;

local v592, v593, v594 = GetHuffmanForDecode(u18, 287, 9);
u13 = v593;
u20 = v594;
assert(v592 == 0);
local v595, v596, v597 = GetHuffmanForDecode(v591, 31, 5);
u21 = v596;
u14 = v597;
assert(v595 == 0);
u22 = GetHuffmanCodeFromBitlen(u13, u18, 287, 9);
u19 = GetHuffmanCodeFromBitlen(u21, v591, 31, 5);
local u598 = {
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

local function escape_for_gsub(p599) -- Line: 3084
    -- upvalues: u598 (copy)
    local v600, _ = p599:gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", u598);

    return v600;
end;

function u15.CreateCodec(p601, p602, p603, p604) -- Line: 3129
    -- upvalues: byte (copy), sub (copy), concat (copy), u598 (copy), u1 (copy), gsub (copy), find (copy)
    if type(p602) ~= "string" or (type(p603) ~= "string" or type(p604) ~= "string") then
        error(
            "Usage: LibDeflate:CreateCodec(reserved_chars, escape_chars, map_chars): All arguments must be string.",
            2
        );
    end;

    if p603 == "" then
        return nil, "No escape characters supplied.";
    end;

    if #p602 < #p604 then
        return nil, "The number of reserved characters must be at least as many as the number of mapped chars.";
    end;

    if p602 == "" then
        return nil, "No characters to encode.";
    end;

    local v605 = p602 .. p603 .. p604;
    local v606 = {};

    for i = 1, #v605 do
        local v607 = byte(v605, i, i);

        if v606[v607] then
            return nil, "There must be no duplicate characters in the concatenation of reserved_chars, escape_chars and map_chars.";
        end;

        v606[v607] = true;
    end;

    local u608 = {};
    local u609 = {};
    local v610 = {};
    local u611 = {};

    if #p604 > 0 then
        local v612 = {};
        local v613 = {};

        for i = 1, #p604 do
            local v614 = sub(p602, i, i);
            local v615 = sub(p604, i, i);
            u611[v614] = v615;
            v610[#v610 + 1] = v614;
            v612[v615] = v614;
            v613[#v613 + 1] = v615;
        end;

        local v616, _ = concat(v613):gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", u598);
        u608[#u608 + 1] = "([" .. v616 .. "])";
        u609[#u609 + 1] = v612;
    end;

    local v617 = 1;
    local v618 = sub(p603, v617, v617);
    local v619 = 0;
    local v620 = {};
    local v621 = {};

    for i = 1, #v605 do
        local v622 = sub(v605, i, i);

        if not u611[v622] then
            while v619 >= 256 or v606[v619] do
                v619 = v619 + 1;

                if v619 > 255 then
                    local v623, _ = v618:gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", u598);
                    local v624, _ = concat(v620):gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", u598);
                    u608[#u608 + 1] = v623 .. "([" .. v624 .. "])";
                    u609[#u609 + 1] = v621;
                    v617 = v617 + 1;
                    v618 = sub(p603, v617, v617);

                    if not v618 or v618 == "" then
                        return nil, "Out of escape characters.";
                    end;

                    v619 = 0;
                    v620 = {};
                    v621 = {};
                end;
            end;

            local v625 = u1[v619];
            u611[v622] = v618 .. v625;
            v610[#v610 + 1] = v622;
            v621[v625] = v622;
            v620[#v620 + 1] = v625;
            v619 = v619 + 1;
        end;

        if i == #v605 then
            local v626, _ = v618:gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", u598);
            local v627, _ = concat(v620):gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", u598);
            u608[#u608 + 1] = v626 .. "([" .. v627 .. "])";
            u609[#u609 + 1] = v621;
        end;
    end;

    local v628 = {};
    local v629, _ = concat(v610):gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", u598);
    local u630 = "([" .. v629 .. "])";

    function v628.Encode(p631, p632) -- Line: 3243
        -- upvalues: gsub (ref), u630 (copy), u611 (copy)
        if type(p632) ~= "string" then
            error(("Usage: codec:Encode(str): \'str\' - string expected got \'%s\'."):format((type(p632))), 2);
        end;

        local v633, _ = gsub(p632, u630, u611);

        return v633;
    end;

    local u634 = #u608;
    local v635, _ = p602:gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", u598);
    local u636 = "([" .. v635 .. "])";

    function v628.Decode(p637, p638) -- Line: 3254
        -- upvalues: find (ref), u636 (copy), u634 (copy), gsub (ref), u608 (copy), u609 (copy)
        if type(p638) ~= "string" then
            error(("Usage: codec:Decode(str): \'str\' - string expected got \'%s\'."):format((type(p638))), 2);
        end;

        if find(p638, u636) then
            return nil;
        end;

        for i = 1, u634 do
            p638 = gsub(p638, u608[i], u609[i]);
        end;

        return p638;
    end;

    return v628, "";
end;

u15.internals = {
    LoadStringToTable = LoadStringToTable,
    IsValidDictionary = IsValidDictionary,
    IsEqualAdler32 = IsEqualAdler32
};

return table.freeze(u15);