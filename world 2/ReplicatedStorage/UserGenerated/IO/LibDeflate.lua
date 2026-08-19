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
local u10 = {};
local u11 = { 1, 2, 3, 4, 5, 7, 9, 13, 17, 25, 33, 49, 65, 97, 129, 193, 257, 385, 513, 769, 1025, 1537, 2049, 3073, 4097, 6145, 8193, 12289, 16385, 24577 };
local u12 = { 0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13 };
local u13 = {};
local u14 = {};
local u15 = {};
local u16 = { 16, 17, 18, 0, 8, 7, 9, 6, 10, 5, 11, 4, 12, 3, 13, 2, 14, 1, 15 };
local u17 = { 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 0 };
local u18 = {};
local u19 = {};
local u20 = { 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 15, 17, 19, 23, 27, 31, 35, 43, 51, 59, 67, 83, 99, 115, 131, 163, 195, 227, 258 };
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

function u22.Adler32(p36, p37) -- Line: 371
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

local function IsEqualAdler32(p58, p59) -- Line: 416
    return p58 % 4294967296 == p59 % 4294967296;
end;

function u22.CreateDictionary(p60, p61, p62, p63) -- Line: 462
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

local function IsValidDictionary(p84) -- Line: 560
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

local function IsValidArguments(p86, p87, p88, p89, p90) -- Line: 640
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

local function CreateWriter() -- Line: 702
    -- upvalues: u2 (copy), u1 (copy), char (copy), concat (copy)
    local u94 = 0;
    local u95 = 0;
    local u96 = 0;
    local u97 = 0;
    local u98 = {};
    local u99 = {};

    return function(p100, p101) -- Line: 715, Name: WriteBits
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
    end, function(p103) -- Line: 737, Name: WriteString
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
    end, function(p104) -- Line: 756, Name: FlushWriter
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

local function MinHeapPush(p107, p108, p109) -- Line: 808
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

local function MinHeapPop(p113, p114) -- Line: 829
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

local function GetHuffmanCodeFromBitlen(p125, p126, p127, p128) -- Line: 879
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

local function SortByFirstThenSecond(p136, p137) -- Line: 923
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

local function GetHuffmanBitlenAndCode(p139, p140, p141) -- Line: 938
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

local function RunLengthEncodeHuffmanBitlen(p166, p167, p168, p169) -- Line: 1073
    local v170 = p167 + (p169 < 0 and 0 or p169) + 1;
    local v171 = nil;
    local v172 = 0;
    local v173 = {};
    local v174 = {};
    local v175 = {};
    local v176 = 0;
    local v177 = 0;

    for i = 0, v170 + 1 do
        local v178;

        if i <= p167 then
            v178 = p166[i] or 0;
        else
            v178 = i <= v170 and (p168[i - p167 - 1] or 0) or nil;
        end;

        if v178 == v171 then
            v176 = v176 + 1;

            if v178 == 0 or v176 ~= 6 then
                if v178 == 0 and v176 == 138 then
                    v172 = v172 + 1;
                    v173[v172] = 18;
                    v177 = v177 + 1;
                    v174[v177] = 127;
                    v175[18] = (v175[18] or 0) + 1;
                    v176 = 0;
                end;
            else
                v172 = v172 + 1;
                v173[v172] = 16;
                v177 = v177 + 1;
                v174[v177] = 3;
                v175[16] = (v175[16] or 0) + 1;
                v176 = 0;
            end;
        else
            if v176 == 1 then
                assert(v171);
                v172 = v172 + 1;
                v173[v172] = v171;
                v175[v171] = (v175[v171] or 0) + 1;
            elseif v176 == 2 then
                assert(v171);
                local v179 = v172 + 1;
                v173[v179] = v171;
                v172 = v179 + 1;
                v173[v172] = v171;
                v175[v171] = (v175[v171] or 0) + 2;
            elseif v176 >= 3 then
                v172 = v172 + 1;
                local v180 = v171 == 0 and (v176 <= 10 and 17 or 18) or 16;
                v173[v172] = v180;
                v175[v180] = (v175[v180] or 0) + 1;
                v177 = v177 + 1;
                v174[v177] = v176 <= 10 and v176 - 3 or v176 - 11;
            end;

            if v178 and v178 ~= 0 then
                v172 = v172 + 1;
                v173[v172] = v178;
                v175[v178] = (v175[v178] or 0) + 1;
                v171 = v178;
                v176 = 0;
            else
                v171 = v178;
                v176 = 1;
            end;
        end;
    end;

    return v173, v174, v175;
end;

local function LoadStringToTable(p181, p182, p183, p184, p185) -- Line: 1162
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

local function GetBlockLZ77Result(p203, p204, p205, p206, p207, p208, p209) -- Line: 1219
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
    local v230 = {};
    local v231 = false;
    local v232 = 0;
    local v233 = 0;
    local v234 = 0;
    local v235 = {};
    local v236 = {};
    local v237 = {};
    local v238 = {};
    local v239 = {};
    local v240 = 0;

    while true do
        if p206 > v227 then
            v238[v234 + 1] = 256;
            v237[256] = (v237[256] or 0) + 1;

            return v238, v230, v237, v239, v235, v236;
        end;

        local v241 = p206 - p208;
        local v242 = p208 - 3;
        local v243 = 0;
        v226 = (v226 * 256 + (p204[v241 + 2] or 0)) % 16777216;
        local v244 = nil;
        local v245 = p205[v226];
        local v246, v247, v248;

        if v245 then
            v246 = #v245;
            v247 = v246;
            v248 = v245;
        else
            v247 = 0;
            v248 = {};
            p205[v226] = v248;

            if v218 then
                v245 = v218[v226];
                v246 = v245 and (#v245 or 0) or 0;
            else
                v245 = v244;
                v246 = 0;
            end;
        end;

        if p206 <= p207 then
            v248[v247 + 1] = p206;
        end;

        local v249, v250;

        if v246 > 0 and (p206 + 2 <= p207 and (not v211 or v228 < v213)) then
            local v251;

            if v211 and (v212 <= v228 and v217) then
                v251 = v217;
            else
                v251 = v215;
            end;

            local v252 = p207 - p206;
            local v253 = (v252 >= 257 and 257 or v252) + v241;
            local v254 = v241 + 3;
            v249 = v229;

            while true do
                if v246 < 1 or v251 <= 0 then
                    v250 = v243;
                    break;
                end;

                local v255 = v245[v246];

                if p206 - v255 > 32768 then
                    v250 = v243;
                    break;
                end;

                local v256;

                if v255 < p206 then
                    if v255 >= -257 then
                        local v257 = v255 - v242;
                        v256 = v254;

                        while v254 <= v253 and p204[v257] == p204[v254] do
                            v254 = v254 + 1;
                            v257 = v257 + 1;
                        end;
                    else
                        local v258 = v225 + v255;
                        local v259 = v254;

                        while v259 <= v253 and v219[v258] == p204[v259] do
                            v259 = v259 + 1;
                            v258 = v258 + 1;
                        end;

                        v256 = v254;
                        v254 = v259;
                    end;

                    v250 = v254 - v241;

                    if v243 < v250 then
                        v229 = p206 - v255;
                    else
                        v250 = v243;
                    end;

                    if v214 <= v250 then
                        break;
                    end;
                else
                    v250 = v243;
                    v256 = v254;
                end;

                v246 = v246 - 1;
                v251 = v251 - 1;

                if v246 == 0 and (v255 > 0 and v218) then
                    v245 = v218[v226];
                    v246 = v245 and (#v245 or 0) or 0;
                end;

                v243 = v250;
                v254 = v256;
            end;
        else
            v249 = v229;
            v250 = v243;
        end;

        if not v211 then
            v249 = v229;
            v228 = v250;
        end;

        if v211 and not v231 or (v228 <= 3 and (v228 ~= 3 or v249 >= 4096) or v250 > v228) then
            if v211 and not v231 then
                p206 = p206 + 1;
                v231 = true;
            else
                if v211 then
                    v241 = v241 - 1 or v241;
                end;

                local v260 = p204[v241];
                v234 = v234 + 1;
                v238[v234] = v260;
                v237[v260] = (v237[v260] or 0) + 1;
                p206 = p206 + 1;
            end;
        else
            local v261 = u5[v228];
            local v262 = u6[v228];
            local v263, v264, v265;

            if v249 <= 256 then
                v263 = u7[v249];
                v264 = u9[v249];
                v265 = u8[v249];
            else
                v265 = 7;
                v263 = 16;
                local v266 = 384;
                local v267 = 512;

                while true do
                    if v249 <= v266 then
                        v264 = (v249 - v267 / 2 - 1) % (v267 / 4);
                    end;

                    if v249 <= v267 then
                        v264 = (v249 - v267 / 2 - 1) % (v267 / 4);
                        v263 = v263 + 1;
                    end;

                    v263 = v263 + 2;
                    v265 = v265 + 1;
                    v266 = v266 * 2;
                    v267 = v267 * 2;
                end;
            end;

            v234 = v234 + 1;
            v238[v234] = v261;
            v237[v261] = (v237[v261] or 0) + 1;
            v232 = v232 + 1;
            v239[v232] = v263;
            v236[v263] = (v236[v263] or 0) + 1;

            if v262 > 0 then
                v240 = v240 + 1;
                v230[v240] = u4[v228];
            end;

            if v265 > 0 then
                v233 = v233 + 1;
                v235[v233] = v264;
            end;

            for i = p206 + 1, p206 + v228 - (v211 and 2 or 1) do
                v226 = (v226 * 256 + (p204[i - p208 + 2] or 0)) % 16777216;

                if v228 <= v216 then
                    local v268 = p205[v226];

                    if not v268 then
                        v268 = {};
                        p205[v226] = v268;
                    end;

                    v268[#v268 + 1] = i;
                end;
            end;

            p206 = p206 + v228 - (v211 and 1 or 0);
            v231 = false;
        end;

        v228 = v250;
    end;
end;

local function GetBlockDynamicHuffmanHeader(p269, p270) -- Line: 1478
    -- upvalues: GetHuffmanBitlenAndCode (copy), RunLengthEncodeHuffmanBitlen (copy), u16 (copy)
    local v271, v272, v273 = GetHuffmanBitlenAndCode(p269, 15, 285);
    local v274, v275, v276 = GetHuffmanBitlenAndCode(p270, 15, 29);
    local v277, v278, v279 = RunLengthEncodeHuffmanBitlen(v271, v273, v274, v276);
    local v280, v281 = GetHuffmanBitlenAndCode(v279, 7, 18);
    local v282 = 0;

    for i = 1, 19 do
        if (v280[u16[i]] or 0) ~= 0 then
            v282 = i;
        end;
    end;

    local v283 = v276 + 1 - 1;

    return v273 + 1 - 257, v283 < 0 and 0 or v283, v282 - 4, v280, v281, v277, v278, v271, v272, v274, v275;
end;

local function GetDynamicHuffmanBlockSize(p284, p285, p286, p287, p288, p289, p290) -- Line: 1516
    -- upvalues: u17 (copy)
    local v291 = 17 + (p286 + 4) * 3;

    for i = 1, #p288 do
        local v292 = p288[i];
        v291 = v291 + p287[v292];

        if v292 >= 16 then
            v291 = v291 + (v292 == 16 and 2 or (v292 == 17 and 3 or 7));
        end;
    end;

    local v293 = 0;

    for i = 1, #p284 do
        local v294 = p284[i];
        v291 = v291 + p289[v294];

        if v294 > 256 then
            v293 = v293 + 1;

            if v294 > 264 and v294 < 285 then
                v291 = v291 + u17[v294 - 256];
            end;

            local v295 = p285[v293];
            v291 = v291 + p290[v295];

            if v295 > 3 then
                v291 = v291 + ((v295 - v295 % 2) / 2 - 1);
            end;
        end;
    end;

    return v291;
end;

local function CompressDynamicHuffmanBlock(p296, p297, p298, p299, p300, p301, p302, p303, p304, p305, p306, p307, p308, p309, p310, p311, p312) -- Line: 1564
    -- upvalues: u16 (copy), u17 (copy)
    p296(p297 and 1 or 0, 1);
    p296(2, 2);
    p296(p302, 5);
    p296(p303, 5);
    p296(p304, 4);

    for i = 1, p304 + 4 do
        p296(p305[u16[i]] or 0, 3);
    end;

    local v313 = 1;

    for i = 1, #p307 do
        local v314 = p307[i];
        p296(p306[v314], p305[v314]);

        if v314 >= 16 then
            p296(p308[v313], v314 == 16 and 2 or (v314 == 17 and 3 or 7));
            v313 = v313 + 1;
        end;
    end;

    local v315 = 0;
    local v316 = 0;
    local v317 = 0;

    for i = 1, #p298 do
        local v318 = p298[i];
        p296(p310[v318], p309[v318]);

        if v318 > 256 then
            v316 = v316 + 1;

            if v318 > 264 and v318 < 285 then
                v315 = v315 + 1;
                p296(p299[v315], u17[v318 - 256]);
            end;

            local v319 = p300[v316];
            p296(p312[v319], p311[v319]);

            if v319 > 3 then
                v317 = v317 + 1;
                p296(p301[v317], (v319 - v319 % 2) / 2 - 1);
            end;
        end;
    end;
end;

local function GetFixedHuffmanBlockSize(p320, p321) -- Line: 1635
    -- upvalues: u18 (ref), u17 (copy)
    local v322 = 3;
    local v323 = 0;

    for i = 1, #p320 do
        local v324 = p320[i];
        v322 = v322 + u18[v324];

        if v324 > 256 then
            v323 = v323 + 1;

            if v324 > 264 and v324 < 285 then
                v322 = v322 + u17[v324 - 256];
            end;

            local v325 = p321[v323];
            v322 = v322 + 5;

            if v325 > 3 then
                v322 = v322 + ((v325 - v325 % 2) / 2 - 1);
            end;
        end;
    end;

    return v322;
end;

local function CompressFixedHuffmanBlock(p326, p327, p328, p329, p330, p331) -- Line: 1664
    -- upvalues: u10 (ref), u18 (ref), u17 (copy), u19 (ref)
    p326(p327 and 1 or 0, 1);
    p326(1, 2);
    local v332 = 0;
    local v333 = 0;
    local v334 = 0;

    for i = 1, #p328 do
        local v335 = p328[i];
        p326(u10[v335], u18[v335]);

        if v335 > 256 then
            v332 = v332 + 1;

            if v335 > 264 and v335 < 285 then
                v333 = v333 + 1;
                p326(p329[v333], u17[v335 - 256]);
            end;

            local v336 = p330[v332];
            p326(u19[v336], 5);

            if v336 > 3 then
                v334 = v334 + 1;
                p326(p331[v334], (v336 - v336 % 2) / 2 - 1);
            end;
        end;
    end;
end;

local function GetStoreBlockSize(p337, p338, p339) -- Line: 1707
    assert(p338 - p337 + 1 <= 65535);

    return 3 + (8 - (p339 + 3) % 8) % 8 + 32 + (p338 - p337 + 1) * 8;
end;

local function CompressStoreBlock(p340, p341, p342, p343, p344, p345, p346) -- Line: 1721
    -- upvalues: u2 (copy)
    assert(p345 - p344 + 1 <= 65535);
    p340(p342 and 1 or 0, 1);
    p340(0, 2);
    local v347 = (8 - (p346 + 3) % 8) % 8;

    if v347 > 0 then
        p340(u2[v347] - 1, v347);
    end;

    local v348 = p345 - p344 + 1;
    p340(v348, 16);
    p340(255 - v348 % 256 + (255 - (v348 - v348 % 256) / 256) * 256, 16);
    p341(p343:sub(p344, p345));
end;

local function Deflate(p349, p350, p351, p352, p353, p354) -- Line: 1752
    -- upvalues: LoadStringToTable (copy), GetBlockLZ77Result (copy), GetBlockDynamicHuffmanHeader (copy), GetDynamicHuffmanBlockSize (copy), GetFixedHuffmanBlockSize (copy), CompressStoreBlock (copy), CompressFixedHuffmanBlock (copy), CompressDynamicHuffmanBlock (copy)
    local v355 = {};
    local v356 = {};
    local v357 = nil;
    local v358 = 0;
    local v359 = 0;
    local v360, _ = p352(3);
    local v361 = #p353;
    local v362 = nil;
    local v363 = nil;

    if p349 then
        if p349.level then
            v362 = p349.level;
        end;

        if p349.strategy then
            v363 = p349.strategy;
        end;
    end;

    if not v362 then
        if v361 < 2048 then
            v362 = 7;
        elseif v361 > 65536 then
            v362 = 3;
        else
            v362 = 5;
        end;
    end;

    while not v357 do
        local v364;

        if v358 == 0 then
            v358 = 1;
            v364 = 0;
            v359 = 65535;
        else
            v358 = v359 + 1;
            v359 = v359 + 32768;
            v364 = v358 - 32768 - 1;
        end;

        if v361 <= v359 then
            v359 = v361;
            v357 = true;
        else
            v357 = false;
        end;

        local v365, v366, v367, v368, v369, v370, v371, v372, v373, v374, v375, v376, v377, v378, v379, v380, v381;

        if v362 == 0 then
            v365 = {};
            v366 = {};
            v367 = {};
            v368 = {};
            v369 = nil;
            v370 = {};
            v371 = nil;
            v372 = {};
            v373 = {};
            v374 = nil;
            v375 = nil;
            v376 = {};
            v377 = nil;
            v378 = {};
            v379 = {};
            v380 = {};
            v381 = {};
        else
            LoadStringToTable(p353, v355, v358, v359 + 3, v364);

            if v358 == 1 and p354 then
                local string_table = p354.string_table;
                local strlen = p354.strlen;

                for i = 0, -strlen + 1 < -257 and -257 or -strlen + 1, -1 do
                    v355[i] = string_table[strlen + i];
                end;
            end;

            local v382, v383;

            if v363 == "huffman_only" then
                v380 = {};
                LoadStringToTable(p353, v380, v358, v359, v358 - 1);
                v380[v359 - v358 + 2] = 256;
                v382 = {};
                v378 = {};

                for i = 1, v359 - v358 + 2 do
                    local v384 = v380[i];
                    v382[v384] = (v382[v384] or 0) + 1;
                end;

                v379 = {};
                v383 = {};
                v376 = {};
            else
                v380, v378, v382, v376, v379, v383 = GetBlockLZ77Result(v362, v355, v356, v358, v359, v364, p354);
            end;

            v374, v369, v377, v372, v373, v370, v366, v381, v367, v368, v365 = GetBlockDynamicHuffmanHeader(v382, v383);
            v371 = GetDynamicHuffmanBlockSize(v380, v376, v377, v372, v370, v381, v368);
            v375 = GetFixedHuffmanBlockSize(v380, v376);
        end;

        assert(v359 - v358 + 1 <= 65535);
        local v385 = 3 + (8 - (v360 + 3) % 8) % 8 + 32 + (v359 - v358 + 1) * 8;
        local v386;

        if v375 and (v375 < v385 and v375) then
            v386 = v375;
        else
            v386 = v385;
        end;

        if v371 and (v371 < v386 and v371) then
            v386 = v371;
        end;

        if v362 == 0 or v363 ~= "fixed" and (v363 ~= "dynamic" and v385 == v386) then
            CompressStoreBlock(p350, p351, v357, p353, v358, v359, v360);
            v360 = v360 + v385;
        elseif v363 == "dynamic" or v363 ~= "fixed" and v375 ~= v386 then
            if v363 == "dynamic" or v371 == v386 then
                CompressDynamicHuffmanBlock(p350, v357, v380, v378, v376, v379, v374, v369, v377, v372, v373, v370, v366, v381, v367, v368, v365);
                v360 = v360 + assert(v371);
            end;
        else
            CompressFixedHuffmanBlock(p350, v357, v380, v378, v376, v379);
            v360 = v360 + assert(v375);
        end;

        local v387;

        if v357 then
            v387 = p352(3);
        else
            v387 = p352(0);
        end;

        assert(v387 == v360);

        if not v357 then
            if p354 and v358 == 1 then
                local v388 = 0;

                while v355[v388] do
                    v355[v388] = nil;
                    v388 = v388 - 1;
                end;
            end;

            local v389 = 1;
            p354 = nil;

            for i = v359 - 32767, v359 do
                v355[v389] = v355[i - v364];
                v389 = v389 + 1;
            end;

            for i, v in pairs(v356) do
                local v390 = #v;

                if v390 > 0 and v359 + 1 - v[1] > 32768 then
                    if v390 == 1 then
                        v356[i] = nil;
                    else
                        local v391 = 0;
                        local v392 = {};

                        for i2 = 2, v390 do
                            local v393 = v[i2];

                            if v359 + 1 - v393 <= 32768 then
                                v391 = v391 + 1;
                                v392[v391] = v393;
                            end;
                        end;

                        v356[i] = v392;
                    end;
                end;
            end;
        end;
    end;
end;

local function CompressDeflateInternal(p394, p395, p396) -- Line: 1966
    -- upvalues: CreateWriter (copy), Deflate (copy)
    local v397, v398, v399 = CreateWriter();
    Deflate(p396, v397, v398, v399, p394, p395);
    local v400, v401 = v399(1);
    assert(v401);

    return v401, (8 - v400 % 8) % 8;
end;

local function CompressZlibInternal(p402, p403, p404) -- Line: 1977
    -- upvalues: CreateWriter (copy), Deflate (copy), u22 (copy)
    local v405, v406, v407 = CreateWriter();
    v405(120, 8);
    local v408 = p403 and 1 or 0;
    local v409 = 128 + v408 * 32;
    v405(v409 + (31 - (30720 + v409) % 31), 8);

    if v408 == 1 then
        assert(p403);
        local adler32 = p403.adler32;
        local v410 = adler32 % 256;
        local v411 = (adler32 - v410) / 256;
        local v412 = v411 % 256;
        local v413 = (v411 - v412) / 256;
        local v414 = v413 % 256;
        v405((v413 - v414) / 256 % 256, 8);
        v405(v414, 8);
        v405(v412, 8);
        v405(v410, 8);
    end;

    Deflate(p404, v405, v406, v407, p402, p403);
    v407(2);
    local v415 = u22:Adler32(p402);
    local v416 = v415 % 256;
    local v417 = (v415 - v416) / 256;
    local v418 = v417 % 256;
    local v419 = (v417 - v418) / 256;
    local v420 = v419 % 256;
    v405((v419 - v420) / 256 % 256, 8);
    v405(v420, 8);
    v405(v418, 8);
    v405(v416, 8);
    local v421, v422 = v407(1);
    assert(v422);

    return v422, (8 - v421 % 8) % 8;
end;

function u22.CompressDeflate(p423, p424, p425) -- Line: 2048
    -- upvalues: IsValidArguments (copy), CompressDeflateInternal (copy)
    local v426, v427 = IsValidArguments(p424, false, nil, true, p425);

    if not v426 then
        error("Usage: LibDeflate:CompressDeflate(str, configs): " .. v427, 2);
    end;

    return CompressDeflateInternal(p424, nil, p425);
end;

function u22.CompressDeflateWithDict(p428, p429, p430, p431) -- Line: 2072
    -- upvalues: IsValidArguments (copy), CompressDeflateInternal (copy)
    local v432, v433 = IsValidArguments(p429, true, p430, true, p431);

    if not v432 then
        error("Usage: LibDeflate:CompressDeflateWithDict" .. "(str, dictionary, configs): " .. v433, 2);
    end;

    return CompressDeflateInternal(p429, p430, p431);
end;

function u22.CompressZlib(p434, p435, p436) -- Line: 2092
    -- upvalues: IsValidArguments (copy), CompressZlibInternal (copy)
    local v437, v438 = IsValidArguments(p435, false, nil, true, p436);

    if not v437 then
        error("Usage: LibDeflate:CompressZlib(str, configs): " .. v438, 2);
    end;

    return CompressZlibInternal(p435, nil, p436);
end;

function u22.CompressZlibWithDict(p439, p440, p441, p442) -- Line: 2113
    -- upvalues: IsValidArguments (copy), CompressZlibInternal (copy)
    local v443, v444 = IsValidArguments(p440, true, p441, true, p442);

    if not v443 then
        error("Usage: LibDeflate:CompressZlibWithDict" .. "(str, dictionary, configs): " .. v444, 2);
    end;

    return CompressZlibInternal(p440, p441, p442);
end;

local function CreateReader(u445) -- Line: 2142
    -- upvalues: u2 (copy), byte (copy), char (copy), sub (copy), u3 (copy)
    local u446 = #u445;
    local u447 = 1;
    local u448 = 0;
    local u449 = 0;

    return function(p450) -- Line: 2155, Name: ReadBits
        -- upvalues: u2 (ref), u448 (ref), u449 (ref), u445 (copy), u447 (ref), byte (ref)
        local v451 = u2[p450];

        if p450 <= u448 then
            local v452 = u449 % v451;
            u449 = (u449 - v452) / v451;
            u448 = u448 - p450;

            return v452;
        end;

        local v453 = u2[u448];
        local v454, v455, v456, v457 = byte(u445, u447, u447 + 3);
        u449 = u449 + ((v454 or 0) + (v455 or 0) * 256 + (v456 or 0) * 65536 + (v457 or 0) * 16777216) * v453;
        u447 = u447 + 4;
        u448 = u448 + 32 - p450;
        local v458 = u449 % v451;
        u449 = (u449 - v458) / v451;

        return v458;
    end, function(p459, p460, p461) -- Line: 2185, Name: ReadBytes
        -- upvalues: u448 (ref), u449 (ref), char (ref), u446 (copy), u447 (ref), u445 (copy), sub (ref)
        assert(u448 % 8 == 0);
        local v462;

        if u448 / 8 < p459 then
            v462 = u448 / 8 or p459;
        else
            v462 = p459;
        end;

        for _ = 1, v462 do
            local v463 = u449 % 256;
            p461 = p461 + 1;
            p460[p461] = char(v463);
            u449 = (u449 - v463) / 256;
        end;

        u448 = u448 - v462 * 8;
        local v464 = p459 - v462;

        if (u446 - u447 - v464 + 1) * 8 + u448 < 0 then
            return -1;
        end;

        for i = u447, u447 + v464 - 1 do
            p461 = p461 + 1;
            p460[p461] = sub(u445, i, i);
        end;

        u447 = u447 + v464;

        return p461;
    end, function(p465, p466, p467) -- Line: 2221, Name: Decode
        -- upvalues: u448 (ref), u445 (copy), u2 (ref), u447 (ref), byte (ref), u449 (ref), u3 (ref)
        local v468, v469, v470;

        if p467 > 0 then
            if u448 < 15 and u445 then
                local v471 = u2[u448];
                local v472, v473, v474, v475 = byte(u445, u447, u447 + 3);
                u449 = u449 + ((v472 or 0) + (v473 or 0) * 256 + (v474 or 0) * 65536 + (v475 or 0) * 16777216) * v471;
                u447 = u447 + 4;
                u448 = u448 + 32;
            end;

            local v476 = u2[p467];
            u448 = u448 - p467;
            local v477 = u449 % v476;
            u449 = (u449 - v477) / v476;
            local v478 = u3[p467][v477];
            v468 = p465[p467];

            if v478 < v468 then
                return p466[v478];
            end;

            v469 = v468 * 2;
            v470 = v478 * 2;
        else
            v470 = 0;
            v469 = 0;
            v468 = 0;
        end;

        for i = p467 + 1, 15 do
            local v479 = u449 % 2;
            u449 = (u449 - v479) / 2;
            u448 = u448 - 1;

            if v479 == 1 then
                v470 = v470 + 1 - v470 % 2 or v470;
            end;

            local v480 = p465[i] or 0;
            local v481 = v470 - v469;

            if v481 < v480 then
                return p466[v468 + v481];
            end;

            v468 = v468 + v480;
            v469 = (v469 + v480) * 2;
            v470 = v470 * 2;
        end;

        return -10;
    end, function() -- Line: 2273, Name: ReaderBitlenLeft
        -- upvalues: u446 (copy), u447 (ref), u448 (ref)
        return (u446 - u447 + 1) * 8 + u448;
    end, function() -- Line: 2277, Name: SkipToByteBoundary
        -- upvalues: u448 (ref), u2 (ref), u449 (ref)
        local v482 = u448 % 8;
        local v483 = u2[v482];
        u448 = u448 - v482;
        u449 = (u449 - u449 % v483) / v483;
    end;
end;

local function CreateDecompressState(p484, p485) -- Line: 2292
    -- upvalues: CreateReader (copy)
    local v486, v487, v488, v489, v490 = CreateReader(p484);

    return {
        buffer_size = 0,
        ReadBits = v486,
        ReadBytes = v487,
        Decode = v488,
        ReaderBitlenLeft = v489,
        SkipToByteBoundary = v490,
        buffer = {},
        result_buffer = {},
        dictionary = p485
    };
end;

local function GetHuffmanForDecode(p491, p492, p493) -- Line: 2318
    local v494 = p493;
    local v495 = {};

    for i = 0, p492 do
        local v496 = p491[i] or 0;

        if v496 > 0 and (v496 < p493 and v496) then
            p493 = v496;
        end;

        v495[v496] = (v495[v496] or 0) + 1;
    end;

    if v495[0] == p492 + 1 then
        return 0, v495, {}, 0;
    end;

    local v497 = 1;

    for i = 1, v494 do
        v497 = v497 * 2 - (v495[i] or 0);

        if v497 < 0 then
            return v497, {}, {}, 0;
        end;
    end;

    local v498 = { 0 };

    for i = 1, v494 - 1 do
        v498[i + 1] = v498[i] + (v495[i] or 0);
    end;

    local v499 = {};

    for i = 0, p492 do
        local v500 = p491[i] or 0;

        if v500 ~= 0 then
            v499[v498[v500]] = i;
            v498[v500] = v498[v500] + 1;
        end;
    end;

    return v497, v495, v499, p493;
end;

local function DecodeUntilEndOfBlock(p501, p502, p503, p504, p505, p506, p507) -- Line: 2380
    -- upvalues: u1 (copy), u20 (copy), u17 (copy), u11 (copy), u12 (copy), concat (copy)
    local buffer = p501.buffer;
    local buffer_size = p501.buffer_size;
    local ReadBits = p501.ReadBits;
    local Decode = p501.Decode;
    local ReaderBitlenLeft = p501.ReaderBitlenLeft;
    local result_buffer = p501.result_buffer;
    local dictionary = p501.dictionary;
    local v508, v509, v510;

    if dictionary and not buffer[0] then
        v508 = dictionary.string_table;
        v509 = dictionary.strlen;
        v510 = -v509 + 1;

        for i = 0, -v509 + 1 < -257 and -257 or -v509 + 1, -1 do
            buffer[i] = u1[v508[v509 + i]];
        end;
    else
        v509 = nil;
        v508 = {};
        v510 = 1;
    end;

    while true do
        local v511 = Decode(p502, p503, p504);

        if v511 < 0 or v511 > 285 then
            break;
        end;

        if v511 < 256 then
            buffer_size = buffer_size + 1;
            buffer[buffer_size] = u1[v511];
        elseif v511 > 256 then
            local v512 = v511 - 256;
            local v513 = u20[v512];

            if v512 >= 8 then
                v513 = v513 + ReadBits(u17[v512]) or v513;
            end;

            v511 = Decode(p505, p506, p507);

            if v511 < 0 or v511 > 29 then
                return -10;
            end;

            local v514 = u11[v511];

            if v514 > 4 then
                v514 = v514 + ReadBits(u12[v511]) or v514;
            end;

            local v515 = buffer_size - v514 + 1;

            if v515 < v510 then
                return -11;
            end;

            if v515 >= -257 then
                for _ = 1, v513 do
                    buffer_size = buffer_size + 1;
                    buffer[buffer_size] = buffer[v515];
                    v515 = v515 + 1;
                end;
            else
                local v516 = v509 + v515;

                for _ = 1, v513 do
                    buffer_size = buffer_size + 1;
                    buffer[buffer_size] = u1[v508[v516]];
                    v516 = v516 + 1;
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

        if v511 == 256 then
            p501.buffer_size = buffer_size;

            return 0;
        end;
    end;

    return -10;
end;

local function DecompressStoreBlock(p517) -- Line: 2480
    -- upvalues: concat (copy)
    local buffer = p517.buffer;
    local buffer_size = p517.buffer_size;
    local ReadBits = p517.ReadBits;
    local ReadBytes = p517.ReadBytes;
    local ReaderBitlenLeft = p517.ReaderBitlenLeft;
    local result_buffer = p517.result_buffer;
    p517.SkipToByteBoundary();
    local v518 = ReadBits(16);

    if ReaderBitlenLeft() < 0 then
        return 2;
    end;

    local v519 = ReadBits(16);

    if ReaderBitlenLeft() < 0 then
        return 2;
    end;

    if v518 % 256 + v519 % 256 ~= 255 then
        return -2;
    end;

    if (v518 - v518 % 256) / 256 + (v519 - v519 % 256) / 256 ~= 255 then
        return -2;
    end;

    local v520 = ReadBytes(v518, buffer, buffer_size);

    if v520 < 0 then
        return 2;
    end;

    if v520 >= 65536 then
        result_buffer[#result_buffer + 1] = concat(buffer, "", 1, 32768);

        for i = 32769, v520 do
            buffer[i - 32768] = buffer[i];
        end;

        v520 = v520 - 32768;
        buffer[v520 + 1] = nil;
    end;

    p517.buffer_size = v520;

    return 0;
end;

local function DecompressFixBlock(p521) -- Line: 2526
    -- upvalues: DecodeUntilEndOfBlock (copy), u13 (ref), u14 (ref), u15 (ref), u21 (ref)
    return DecodeUntilEndOfBlock(p521, u13, u14, 7, u15, u21, 5);
end;

local function DecompressDynamicBlock(p522) -- Line: 2536
    -- upvalues: u16 (copy), GetHuffmanForDecode (copy), DecodeUntilEndOfBlock (copy)
    local ReadBits = p522.ReadBits;
    local Decode = p522.Decode;
    local v523 = ReadBits(5) + 257;
    local v524 = ReadBits(5) + 1;
    local v525 = ReadBits(4) + 4;

    if v523 > 286 or v524 > 30 then
        return -3;
    end;

    local v526 = {};

    for i = 1, v525 do
        v526[u16[i]] = ReadBits(3);
    end;

    local v527, v528, v529, v530 = GetHuffmanForDecode(v526, 18, 7);

    if v527 ~= 0 then
        return -4;
    end;

    local v531 = 0;
    local v532 = {};
    local v533 = {};

    while v531 < v523 + v524 do
        local v534 = Decode(v528, v529, v530);

        if v534 < 0 then
            return v534;
        end;

        if v534 < 16 then
            if v531 < v523 then
                v532[v531] = v534;
            else
                v533[v531 - v523] = v534;
            end;

            v531 = v531 + 1;
        else
            local v535 = 0;
            local v536;

            if v534 == 16 then
                if v531 == 0 then
                    return -5;
                end;

                if v531 - 1 < v523 then
                    v535 = v532[v531 - 1];
                else
                    v535 = v533[v531 - v523 - 1];
                end;

                v536 = 3 + ReadBits(2);
            elseif v534 == 17 then
                v536 = 3 + ReadBits(3);
            else
                v536 = 11 + ReadBits(7);
            end;

            if v531 + v536 > v523 + v524 then
                return -6;
            end;

            while v536 > 0 do
                v536 = v536 - 1;

                if v531 < v523 then
                    v532[v531] = v535;
                else
                    v533[v531 - v523] = v535;
                end;

                v531 = v531 + 1;
            end;
        end;
    end;

    if (v532[256] or 0) == 0 then
        return -9;
    end;

    local v537, v538, v539, v540 = GetHuffmanForDecode(v532, v523 - 1, 15);

    if v537 ~= 0 and (v537 < 0 or v523 ~= (v538[0] or 0) + (v538[1] or 0)) then
        return -7;
    end;

    local v541, v542, v543, v544 = GetHuffmanForDecode(v533, v524 - 1, 15);

    return v541 ~= 0 and (v541 < 0 or v524 ~= (v542[0] or 0) + (v542[1] or 0)) and -8 or DecodeUntilEndOfBlock(p522, v538, v539, v540, v542, v543, v544);
end;

local function Inflate(p545) -- Line: 2650
    -- upvalues: DecompressStoreBlock (copy), DecodeUntilEndOfBlock (copy), u13 (ref), u14 (ref), u15 (ref), u21 (ref), DecompressDynamicBlock (copy), concat (copy)
    local ReadBits = p545.ReadBits;
    local v546 = nil;

    while not v546 do
        v546 = ReadBits(1) == 1;
        local v547 = ReadBits(2);
        local v548;

        if v547 == 0 then
            v548 = DecompressStoreBlock(p545);
        elseif v547 == 1 then
            v548 = DecodeUntilEndOfBlock(p545, u13, u14, 7, u15, u21, 5);
        else
            if v547 ~= 2 then
                return nil, -1;
            end;

            v548 = DecompressDynamicBlock(p545);
        end;

        if v548 ~= 0 then
            return nil, v548;
        end;
    end;

    p545.result_buffer[#p545.result_buffer + 1] = concat(p545.buffer, "", 1, p545.buffer_size);

    return concat(p545.result_buffer), 0;
end;

local function DecompressDeflateInternal(p549, p550) -- Line: 2678
    -- upvalues: CreateDecompressState (copy), Inflate (copy)
    local v551 = CreateDecompressState(p549, p550);
    local v552, v553 = Inflate(v551);

    if not v552 then
        return nil, v553;
    end;

    local v554 = v551.ReaderBitlenLeft();

    return v552, (v554 - v554 % 8) / 8;
end;

local function DecompressZlibInternal(p555, p556) -- Line: 2690
    -- upvalues: CreateDecompressState (copy), Inflate (copy), u22 (copy)
    local v557 = CreateDecompressState(p555, p556);
    local ReadBits = v557.ReadBits;
    local v558 = ReadBits(8);

    if v557.ReaderBitlenLeft() < 0 then
        return nil, 2;
    end;

    local v559 = v558 % 16;

    if v559 ~= 8 then
        return nil, -12;
    end;

    if (v558 - v559) / 16 > 7 then
        return nil, -13;
    end;

    local v560 = ReadBits(8);

    if v557.ReaderBitlenLeft() < 0 then
        return nil, 2;
    end;

    if (v558 * 256 + v560) % 31 ~= 0 then
        return nil, -14;
    end;

    local _ = (v560 - v560 % 64) / 64 % 4;

    if (v560 - v560 % 32) / 32 % 2 == 1 then
        if not p556 then
            return nil, -16;
        end;

        local v561 = ReadBits(8);
        local v562 = ReadBits(8);
        local v563 = ReadBits(8);
        local v564 = ReadBits(8);

        if v557.ReaderBitlenLeft() < 0 then
            return nil, 2;
        end;

        if (v561 * 16777216 + v562 * 65536 + v563 * 256 + v564) % 4294967296 ~= p556.adler32 % 4294967296 then
            return nil, -17;
        end;
    end;

    local v565, v566 = Inflate(v557);

    if not v565 then
        return nil, v566;
    end;

    v557.SkipToByteBoundary();
    local v567 = ReadBits(8);
    local v568 = ReadBits(8);
    local v569 = ReadBits(8);
    local v570 = ReadBits(8);

    if v557.ReaderBitlenLeft() < 0 then
        return nil, 2;
    end;

    local v571 = u22:Adler32(v565);

    if (v567 * 16777216 + v568 * 65536 + v569 * 256 + v570) % 4294967296 ~= v571 % 4294967296 then
        return nil, -15;
    end;

    local v572 = v557.ReaderBitlenLeft();

    return v565, (v572 - v572 % 8) / 8;
end;

function u22.DecompressDeflate(p573, p574) -- Line: 2772
    -- upvalues: DecompressDeflateInternal (copy)
    local v575, v576;

    if type(p574) == "string" then
        v575 = true;
        v576 = "";
    else
        v576 = ("\'str\' - string expected got \'%s\'."):format((type(p574)));
        v575 = false;
    end;

    if not v575 then
        error("Usage: LibDeflate:DecompressDeflate(str): " .. v576, 2);
    end;

    return DecompressDeflateInternal(p574);
end;

function u22.DecompressDeflateWithDict(p577, p578, p579) -- Line: 2798
    -- upvalues: IsValidDictionary (copy), DecompressDeflateInternal (copy)
    local v580, v581;

    if type(p578) == "string" then
        local v582;
        v582, v580 = IsValidDictionary(p579);

        if v582 then
            v581 = true;
            v580 = "";
        else
            v581 = false;
        end;
    else
        v580 = ("\'str\' - string expected got \'%s\'."):format((type(p578)));
        v581 = false;
    end;

    if not v581 then
        error("Usage: LibDeflate:DecompressDeflateWithDict(str, dictionary): " .. v580, 2);
    end;

    return DecompressDeflateInternal(p578, p579);
end;

function u22.DecompressZlib(p583, p584) -- Line: 2820
    -- upvalues: DecompressZlibInternal (copy)
    local v585, v586;

    if type(p584) == "string" then
        v585 = true;
        v586 = "";
    else
        v586 = ("\'str\' - string expected got \'%s\'."):format((type(p584)));
        v585 = false;
    end;

    if not v585 then
        error("Usage: LibDeflate:DecompressZlib(str): " .. v586, 2);
    end;

    return DecompressZlibInternal(p584);
end;

function u22.DecompressZlibWithDict(p587, p588, p589) -- Line: 2846
    -- upvalues: IsValidDictionary (copy), DecompressZlibInternal (copy)
    local v590, v591;

    if type(p588) == "string" then
        local v592;
        v592, v590 = IsValidDictionary(p589);

        if v592 then
            v591 = true;
            v590 = "";
        else
            v591 = false;
        end;
    else
        v590 = ("\'str\' - string expected got \'%s\'."):format((type(p588)));
        v591 = false;
    end;

    if not v591 then
        error("Usage: LibDeflate:DecompressZlibWithDict(str, dictionary): " .. v590, 2);
    end;

    return DecompressZlibInternal(p588, p589);
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
local v593 = {};

for i = 0, 31 do
    v593[i] = 5;
end;

local v594, v595, v596 = GetHuffmanForDecode(u18, 287, 9);
u13 = v595;
u14 = v596;
assert(v594 == 0);
local v597, v598, v599 = GetHuffmanForDecode(v593, 31, 5);
u15 = v598;
u21 = v599;
assert(v597 == 0);
u10 = GetHuffmanCodeFromBitlen(u13, u18, 287, 9);
u19 = GetHuffmanCodeFromBitlen(u15, v593, 31, 5);
local u600 = {
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

local function escape_for_gsub(p601) -- Line: 2907
    -- upvalues: u600 (copy)
    local v602, _ = p601:gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", u600);

    return v602;
end;

function u22.CreateCodec(p603, p604, p605, p606) -- Line: 2952
    -- upvalues: byte (copy), sub (copy), concat (copy), u600 (copy), u1 (copy), gsub (copy), find (copy)
    if type(p604) ~= "string" or (type(p605) ~= "string" or type(p606) ~= "string") then
        error(
            "Usage: LibDeflate:CreateCodec(reserved_chars, escape_chars, map_chars): All arguments must be string.",
            2
        );
    end;

    if p605 == "" then
        return nil, "No escape characters supplied.";
    end;

    if #p604 < #p606 then
        return nil, "The number of reserved characters must be at least as many as the number of mapped chars.";
    end;

    if p604 == "" then
        return nil, "No characters to encode.";
    end;

    local v607 = p604 .. p605 .. p606;
    local v608 = {};

    for i = 1, #v607 do
        local v609 = byte(v607, i, i);

        if v608[v609] then
            return nil, "There must be no duplicate characters in the concatenation of reserved_chars, escape_chars and map_chars.";
        end;

        v608[v609] = true;
    end;

    local u610 = {};
    local u611 = {};
    local v612 = {};
    local u613 = {};

    if #p606 > 0 then
        local v614 = {};
        local v615 = {};

        for i = 1, #p606 do
            local v616 = sub(p604, i, i);
            local v617 = sub(p606, i, i);
            u613[v616] = v617;
            v612[#v612 + 1] = v616;
            v614[v617] = v616;
            v615[#v615 + 1] = v617;
        end;

        local v618, _ = concat(v615):gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", u600);
        u610[#u610 + 1] = "([" .. v618 .. "])";
        u611[#u611 + 1] = v614;
    end;

    local v619 = 1;
    local v620 = sub(p605, v619, v619);
    local v621 = 0;
    local v622 = {};
    local v623 = {};

    for i = 1, #v607 do
        local v624 = sub(v607, i, i);

        if not u613[v624] then
            while v621 >= 256 or v608[v621] do
                v621 = v621 + 1;

                if v621 > 255 then
                    local v625, _ = v620:gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", u600);
                    local v626, _ = concat(v622):gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", u600);
                    u610[#u610 + 1] = v625 .. "([" .. v626 .. "])";
                    u611[#u611 + 1] = v623;
                    v619 = v619 + 1;
                    v620 = sub(p605, v619, v619);

                    if not v620 or v620 == "" then
                        return nil, "Out of escape characters.";
                    end;

                    v621 = 0;
                    v622 = {};
                    v623 = {};
                end;
            end;

            local v627 = u1[v621];
            u613[v624] = v620 .. v627;
            v612[#v612 + 1] = v624;
            v623[v627] = v624;
            v622[#v622 + 1] = v627;
            v621 = v621 + 1;
        end;

        if i == #v607 then
            local v628, _ = v620:gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", u600);
            local v629, _ = concat(v622):gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", u600);
            u610[#u610 + 1] = v628 .. "([" .. v629 .. "])";
            u611[#u611 + 1] = v623;
        end;
    end;

    local v630 = {};
    local v631, _ = concat(v612):gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", u600);
    local u632 = "([" .. v631 .. "])";

    function v630.Encode(p633, p634) -- Line: 3065
        -- upvalues: gsub (ref), u632 (copy), u613 (copy)
        if type(p634) ~= "string" then
            error(("Usage: codec:Encode(str): \'str\' - string expected got \'%s\'."):format((type(p634))), 2);
        end;

        local v635, _ = gsub(p634, u632, u613);

        return v635;
    end;

    local u636 = #u610;
    local v637, _ = p604:gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", u600);
    local u638 = "([" .. v637 .. "])";

    function v630.Decode(p639, p640) -- Line: 3078
        -- upvalues: find (ref), u638 (copy), u636 (copy), gsub (ref), u610 (copy), u611 (copy)
        if type(p640) ~= "string" then
            error(("Usage: codec:Decode(str): \'str\' - string expected got \'%s\'."):format((type(p640))), 2);
        end;

        if find(p640, u638) then
            return nil;
        end;

        for i = 1, u636 do
            p640 = gsub(p640, u610[i], u611[i]);
        end;

        return p640;
    end;

    return v630, "";
end;

u22.internals = {
    LoadStringToTable = LoadStringToTable,
    IsValidDictionary = IsValidDictionary,
    IsEqualAdler32 = IsEqualAdler32
};

return table.freeze(u22);