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
local u10 = { 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 0 };
local u11 = {};
local u12 = {};
local u13 = {};
local u14 = {};
local u15 = { 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 15, 17, 19, 23, 27, 31, 35, 43, 51, 59, 67, 83, 99, 115, 131, 163, 195, 227, 258 };
local u16 = { 1, 2, 3, 4, 5, 7, 9, 13, 17, 25, 33, 49, 65, 97, 129, 193, 257, 385, 513, 769, 1025, 1537, 2049, 3073, 4097, 6145, 8193, 12289, 16385, 24577 };
local u17 = { 0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13 };
local u18 = {};
local u19 = {};
local u20 = {};
local u21 = {};
local u22 = { 16, 17, 18, 0, 8, 7, 9, 6, 10, 5, 11, 4, 12, 3, 13, 2, 14, 1, 15 };

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

function u21.Adler32(p36, p37) -- Line: 371
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

function u21.CreateDictionary(p60, p61, p62, p63) -- Line: 462
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
    local v171 = 0;
    local v172 = {};
    local v173 = 0;
    local v174 = {};
    local v175 = {};
    local v176 = nil;
    local v177 = 0;

    for i = 0, v170 + 1 do
        local v178;

        if i <= p167 then
            v178 = p166[i] or 0;
        else
            v178 = i <= v170 and (p168[i - p167 - 1] or 0) or nil;
        end;

        if v178 == v176 then
            v177 = v177 + 1;

            if v178 == 0 or v177 ~= 6 then
                if v178 == 0 and v177 == 138 then
                    v173 = v173 + 1;
                    v174[v173] = 18;
                    v171 = v171 + 1;
                    v175[v171] = 127;
                    v172[18] = (v172[18] or 0) + 1;
                    v177 = 0;
                end;
            else
                v173 = v173 + 1;
                v174[v173] = 16;
                v171 = v171 + 1;
                v175[v171] = 3;
                v172[16] = (v172[16] or 0) + 1;
                v177 = 0;
            end;
        else
            if v177 == 1 then
                assert(v176);
                v173 = v173 + 1;
                v174[v173] = v176;
                v172[v176] = (v172[v176] or 0) + 1;
            elseif v177 == 2 then
                assert(v176);
                local v179 = v173 + 1;
                v174[v179] = v176;
                v173 = v179 + 1;
                v174[v173] = v176;
                v172[v176] = (v172[v176] or 0) + 2;
            elseif v177 >= 3 then
                v173 = v173 + 1;
                local v180 = v176 == 0 and (v177 <= 10 and 17 or 18) or 16;
                v174[v173] = v180;
                v172[v180] = (v172[v180] or 0) + 1;
                v171 = v171 + 1;
                v175[v171] = v177 <= 10 and v177 - 3 or v177 - 11;
            end;

            if v178 and v178 ~= 0 then
                v173 = v173 + 1;
                v174[v173] = v178;
                v172[v178] = (v172[v178] or 0) + 1;
                v176 = v178;
                v177 = 0;
            else
                v176 = v178;
                v177 = 1;
            end;
        end;
    end;

    return v174, v175, v172;
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
        v218 = {};
        v219 = {};
    end;

    local v225 = v220 + 3;
    local v226 = (p204[p206 - p208] or 0) * 256 + (p204[p206 + 1 - p208] or 0);
    local v227 = p207 + (v211 and 1 or 0);
    local v228 = 0;
    local v229 = 0;
    local v230 = {};
    local v231 = {};
    local v232 = 0;
    local v233 = {};
    local v234 = 0;
    local v235 = {};
    local v236 = false;
    local v237 = 0;
    local v238 = 0;
    local v239 = {};
    local v240 = {};

    while true do
        if p206 > v227 then
            v239[v232 + 1] = 256;
            v233[256] = (v233[256] or 0) + 1;

            return v239, v231, v233, v240, v230, v235;
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
            v246 = 0;
            v248 = {};
            p205[v226] = v248;

            if v218 then
                v245 = v218[v226];
                v247 = v245 and (#v245 or 0) or 0;
            else
                v245 = v244;
                v247 = 0;
            end;
        end;

        if p206 <= p207 then
            v248[v246 + 1] = p206;
        end;

        local v249, v250;

        if v247 > 0 and (p206 + 2 <= p207 and (not v211 or v228 < v213)) then
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
                if v247 < 1 or v251 <= 0 then
                    v250 = v243;
                    break;
                end;

                local v255 = v245[v247];

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
                        v256 = v254;

                        while v254 <= v253 and v219[v258] == p204[v254] do
                            v254 = v254 + 1;
                            v258 = v258 + 1;
                        end;
                    end;

                    v250 = v254 - v241;

                    if v243 < v250 then
                        v249 = p206 - v255;
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

                v247 = v247 - 1;
                v251 = v251 - 1;

                if v247 == 0 and (v255 > 0 and v218) then
                    v245 = v218[v226];
                    v247 = v245 and (#v245 or 0) or 0;
                end;

                v243 = v250;
                v254 = v256;
            end;
        else
            v250 = v243;
            v249 = v229;
        end;

        if not v211 then
            v229 = v249;
            v228 = v250;
        end;

        if v211 and not v236 or (v228 <= 3 and (v228 ~= 3 or v229 >= 4096) or v250 > v228) then
            if v211 and not v236 then
                p206 = p206 + 1;
                v236 = true;
            else
                if v211 then
                    v241 = v241 - 1 or v241;
                end;

                local v259 = p204[v241];
                v232 = v232 + 1;
                v239[v232] = v259;
                v233[v259] = (v233[v259] or 0) + 1;
                p206 = p206 + 1;
            end;
        else
            local v260 = u5[v228];
            local v261 = u6[v228];
            local v262, v263, v264;

            if v229 <= 256 then
                v262 = u7[v229];
                v263 = u9[v229];
                v264 = u8[v229];
            else
                v262 = 16;
                v264 = 7;
                local v265 = 384;
                local v266 = 512;

                while true do
                    if v229 <= v265 then
                        v263 = (v229 - v266 / 2 - 1) % (v266 / 4);
                    end;

                    if v229 <= v266 then
                        v263 = (v229 - v266 / 2 - 1) % (v266 / 4);
                        v262 = v262 + 1;
                    end;

                    v262 = v262 + 2;
                    v264 = v264 + 1;
                    v265 = v265 * 2;
                    v266 = v266 * 2;
                end;
            end;

            v232 = v232 + 1;
            v239[v232] = v260;
            v233[v260] = (v233[v260] or 0) + 1;
            v234 = v234 + 1;
            v240[v234] = v262;
            v235[v262] = (v235[v262] or 0) + 1;

            if v261 > 0 then
                v238 = v238 + 1;
                v231[v238] = u4[v228];
            end;

            if v264 > 0 then
                v237 = v237 + 1;
                v230[v237] = v263;
            end;

            for i = p206 + 1, p206 + v228 - (v211 and 2 or 1) do
                v226 = (v226 * 256 + (p204[i - p208 + 2] or 0)) % 16777216;

                if v228 <= v216 then
                    local v267 = p205[v226];

                    if not v267 then
                        v267 = {};
                        p205[v226] = v267;
                    end;

                    v267[#v267 + 1] = i;
                end;
            end;

            p206 = p206 + v228 - (v211 and 1 or 0);
            v236 = false;
        end;

        v229 = v249;
        v228 = v250;
    end;
end;

local function GetBlockDynamicHuffmanHeader(p268, p269) -- Line: 1478
    -- upvalues: GetHuffmanBitlenAndCode (copy), RunLengthEncodeHuffmanBitlen (copy), u22 (copy)
    local v270, v271, v272 = GetHuffmanBitlenAndCode(p268, 15, 285);
    local v273, v274, v275 = GetHuffmanBitlenAndCode(p269, 15, 29);
    local v276, v277, v278 = RunLengthEncodeHuffmanBitlen(v270, v272, v273, v275);
    local v279, v280 = GetHuffmanBitlenAndCode(v278, 7, 18);
    local v281 = 0;

    for i = 1, 19 do
        if (v279[u22[i]] or 0) ~= 0 then
            v281 = i;
        end;
    end;

    local v282 = v275 + 1 - 1;

    return v272 + 1 - 257, v282 < 0 and 0 or v282, v281 - 4, v279, v280, v276, v277, v270, v271, v273, v274;
end;

local function GetDynamicHuffmanBlockSize(p283, p284, p285, p286, p287, p288, p289) -- Line: 1516
    -- upvalues: u10 (copy)
    local v290 = 17 + (p285 + 4) * 3;

    for i = 1, #p287 do
        local v291 = p287[i];
        v290 = v290 + p286[v291];

        if v291 >= 16 then
            v290 = v290 + (v291 == 16 and 2 or (v291 == 17 and 3 or 7));
        end;
    end;

    local v292 = 0;

    for i = 1, #p283 do
        local v293 = p283[i];
        v290 = v290 + p288[v293];

        if v293 > 256 then
            v292 = v292 + 1;

            if v293 > 264 and v293 < 285 then
                v290 = v290 + u10[v293 - 256];
            end;

            local v294 = p284[v292];
            v290 = v290 + p289[v294];

            if v294 > 3 then
                v290 = v290 + ((v294 - v294 % 2) / 2 - 1);
            end;
        end;
    end;

    return v290;
end;

local function CompressDynamicHuffmanBlock(p295, p296, p297, p298, p299, p300, p301, p302, p303, p304, p305, p306, p307, p308, p309, p310, p311) -- Line: 1564
    -- upvalues: u22 (copy), u10 (copy)
    p295(p296 and 1 or 0, 1);
    p295(2, 2);
    p295(p301, 5);
    p295(p302, 5);
    p295(p303, 4);

    for i = 1, p303 + 4 do
        p295(p304[u22[i]] or 0, 3);
    end;

    local v312 = 1;

    for i = 1, #p306 do
        local v313 = p306[i];
        p295(p305[v313], p304[v313]);

        if v313 >= 16 then
            p295(p307[v312], v313 == 16 and 2 or (v313 == 17 and 3 or 7));
            v312 = v312 + 1;
        end;
    end;

    local v314 = 0;
    local v315 = 0;
    local v316 = 0;

    for i = 1, #p297 do
        local v317 = p297[i];
        p295(p309[v317], p308[v317]);

        if v317 > 256 then
            v315 = v315 + 1;

            if v317 > 264 and v317 < 285 then
                v314 = v314 + 1;
                p295(p298[v314], u10[v317 - 256]);
            end;

            local v318 = p299[v315];
            p295(p311[v318], p310[v318]);

            if v318 > 3 then
                v316 = v316 + 1;
                p295(p300[v316], (v318 - v318 % 2) / 2 - 1);
            end;
        end;
    end;
end;

local function GetFixedHuffmanBlockSize(p319, p320) -- Line: 1635
    -- upvalues: u11 (ref), u10 (copy)
    local v321 = 3;
    local v322 = 0;

    for i = 1, #p319 do
        local v323 = p319[i];
        v321 = v321 + u11[v323];

        if v323 > 256 then
            v322 = v322 + 1;

            if v323 > 264 and v323 < 285 then
                v321 = v321 + u10[v323 - 256];
            end;

            local v324 = p320[v322];
            v321 = v321 + 5;

            if v324 > 3 then
                v321 = v321 + ((v324 - v324 % 2) / 2 - 1);
            end;
        end;
    end;

    return v321;
end;

local function CompressFixedHuffmanBlock(p325, p326, p327, p328, p329, p330) -- Line: 1664
    -- upvalues: u12 (ref), u11 (ref), u10 (copy), u14 (ref)
    p325(p326 and 1 or 0, 1);
    p325(1, 2);
    local v331 = 0;
    local v332 = 0;
    local v333 = 0;

    for i = 1, #p327 do
        local v334 = p327[i];
        p325(u12[v334], u11[v334]);

        if v334 > 256 then
            v331 = v331 + 1;

            if v334 > 264 and v334 < 285 then
                v332 = v332 + 1;
                p325(p328[v332], u10[v334 - 256]);
            end;

            local v335 = p329[v331];
            p325(u14[v335], 5);

            if v335 > 3 then
                v333 = v333 + 1;
                p325(p330[v333], (v335 - v335 % 2) / 2 - 1);
            end;
        end;
    end;
end;

local function GetStoreBlockSize(p336, p337, p338) -- Line: 1707
    assert(p337 - p336 + 1 <= 65535);

    return 3 + (8 - (p338 + 3) % 8) % 8 + 32 + (p337 - p336 + 1) * 8;
end;

local function CompressStoreBlock(p339, p340, p341, p342, p343, p344, p345) -- Line: 1721
    -- upvalues: u2 (copy)
    assert(p344 - p343 + 1 <= 65535);
    p339(p341 and 1 or 0, 1);
    p339(0, 2);
    local v346 = (8 - (p345 + 3) % 8) % 8;

    if v346 > 0 then
        p339(u2[v346] - 1, v346);
    end;

    local v347 = p344 - p343 + 1;
    p339(v347, 16);
    p339(255 - v347 % 256 + (255 - (v347 - v347 % 256) / 256) * 256, 16);
    p340(p342:sub(p343, p344));
end;

local function Deflate(p348, p349, p350, p351, p352, p353) -- Line: 1752
    -- upvalues: LoadStringToTable (copy), GetBlockLZ77Result (copy), GetBlockDynamicHuffmanHeader (copy), GetDynamicHuffmanBlockSize (copy), GetFixedHuffmanBlockSize (copy), CompressStoreBlock (copy), CompressFixedHuffmanBlock (copy), CompressDynamicHuffmanBlock (copy)
    local v354 = {};
    local v355 = {};
    local v356 = nil;
    local v357 = 0;
    local v358 = 0;
    local v359, _ = p351(3);
    local v360 = #p352;
    local v361 = nil;
    local v362 = nil;

    if p348 then
        if p348.level then
            v361 = p348.level;
        end;

        if p348.strategy then
            v362 = p348.strategy;
        end;
    end;

    if not v361 then
        if v360 < 2048 then
            v361 = 7;
        elseif v360 > 65536 then
            v361 = 3;
        else
            v361 = 5;
        end;
    end;

    while not v356 do
        local v363;

        if v357 == 0 then
            v357 = 1;
            v363 = 0;
            v358 = 65535;
        else
            v357 = v358 + 1;
            v358 = v358 + 32768;
            v363 = v357 - 32768 - 1;
        end;

        if v360 <= v358 then
            v358 = v360;
            v356 = true;
        else
            v356 = false;
        end;

        local v364, v365, v366, v367, v368, v369, v370, v371, v372, v373, v374, v375, v376, v377, v378, v379, v380;

        if v361 == 0 then
            v364 = {};
            v365 = nil;
            v366 = nil;
            v367 = {};
            v368 = {};
            v369 = {};
            v370 = {};
            v371 = {};
            v372 = {};
            v373 = {};
            v374 = {};
            v375 = {};
            v376 = nil;
            v377 = nil;
            v378 = {};
            v379 = nil;
            v380 = {};
        else
            LoadStringToTable(p352, v354, v357, v358 + 3, v363);

            if v357 == 1 and p353 then
                local string_table = p353.string_table;
                local strlen = p353.strlen;

                for i = 0, -strlen + 1 < -257 and -257 or -strlen + 1, -1 do
                    v354[i] = string_table[strlen + i];
                end;
            end;

            local v381, v382;

            if v362 == "huffman_only" then
                v372 = {};
                LoadStringToTable(p352, v372, v357, v358, v357 - 1);
                v372[v358 - v357 + 2] = 256;
                v381 = {};
                v370 = {};

                for i = 1, v358 - v357 + 2 do
                    local v383 = v372[i];
                    v381[v383] = (v381[v383] or 0) + 1;
                end;

                v367 = {};
                v382 = {};
                v375 = {};
            else
                v372, v370, v381, v375, v367, v382 = GetBlockLZ77Result(v361, v354, v355, v357, v358, v363, p353);
            end;

            v377, v376, v365, v374, v378, v369, v371, v368, v364, v380, v373 = GetBlockDynamicHuffmanHeader(v381, v382);
            v379 = GetDynamicHuffmanBlockSize(v372, v375, v365, v374, v369, v368, v380);
            v366 = GetFixedHuffmanBlockSize(v372, v375);
        end;

        assert(v358 - v357 + 1 <= 65535);
        local v384 = 3 + (8 - (v359 + 3) % 8) % 8 + 32 + (v358 - v357 + 1) * 8;
        local v385;

        if v366 and (v366 < v384 and v366) then
            v385 = v366;
        else
            v385 = v384;
        end;

        if v379 and (v379 < v385 and v379) then
            v385 = v379;
        end;

        if v361 == 0 or v362 ~= "fixed" and (v362 ~= "dynamic" and v384 == v385) then
            CompressStoreBlock(p349, p350, v356, p352, v357, v358, v359);
            v359 = v359 + v384;
        elseif v362 == "dynamic" or v362 ~= "fixed" and v366 ~= v385 then
            if v362 == "dynamic" or v379 == v385 then
                CompressDynamicHuffmanBlock(p349, v356, v372, v370, v375, v367, v377, v376, v365, v374, v378, v369, v371, v368, v364, v380, v373);
                v359 = v359 + assert(v379);
            end;
        else
            CompressFixedHuffmanBlock(p349, v356, v372, v370, v375, v367);
            v359 = v359 + assert(v366);
        end;

        local v386;

        if v356 then
            v386 = p351(3);
        else
            v386 = p351(0);
        end;

        assert(v386 == v359);

        if not v356 then
            if p353 and v357 == 1 then
                local v387 = 0;

                while v354[v387] do
                    v354[v387] = nil;
                    v387 = v387 - 1;
                end;
            end;

            local v388 = 1;
            p353 = nil;

            for i = v358 - 32767, v358 do
                v354[v388] = v354[i - v363];
                v388 = v388 + 1;
            end;

            for i, v in pairs(v355) do
                local v389 = #v;

                if v389 > 0 and v358 + 1 - v[1] > 32768 then
                    if v389 == 1 then
                        v355[i] = nil;
                    else
                        local v390 = 0;
                        local v391 = {};

                        for i2 = 2, v389 do
                            local v392 = v[i2];

                            if v358 + 1 - v392 <= 32768 then
                                v390 = v390 + 1;
                                v391[v390] = v392;
                            end;
                        end;

                        v355[i] = v391;
                    end;
                end;
            end;
        end;
    end;
end;

local function CompressDeflateInternal(p393, p394, p395) -- Line: 1966
    -- upvalues: CreateWriter (copy), Deflate (copy)
    local v396, v397, v398 = CreateWriter();
    Deflate(p395, v396, v397, v398, p393, p394);
    local v399, v400 = v398(1);
    assert(v400);

    return v400, (8 - v399 % 8) % 8;
end;

local function CompressZlibInternal(p401, p402, p403) -- Line: 1977
    -- upvalues: CreateWriter (copy), Deflate (copy), u21 (copy)
    local v404, v405, v406 = CreateWriter();
    v404(120, 8);
    local v407 = p402 and 1 or 0;
    local v408 = 128 + v407 * 32;
    v404(v408 + (31 - (30720 + v408) % 31), 8);

    if v407 == 1 then
        assert(p402);
        local adler32 = p402.adler32;
        local v409 = adler32 % 256;
        local v410 = (adler32 - v409) / 256;
        local v411 = v410 % 256;
        local v412 = (v410 - v411) / 256;
        local v413 = v412 % 256;
        v404((v412 - v413) / 256 % 256, 8);
        v404(v413, 8);
        v404(v411, 8);
        v404(v409, 8);
    end;

    Deflate(p403, v404, v405, v406, p401, p402);
    v406(2);
    local v414 = u21:Adler32(p401);
    local v415 = v414 % 256;
    local v416 = (v414 - v415) / 256;
    local v417 = v416 % 256;
    local v418 = (v416 - v417) / 256;
    local v419 = v418 % 256;
    v404((v418 - v419) / 256 % 256, 8);
    v404(v419, 8);
    v404(v417, 8);
    v404(v415, 8);
    local v420, v421 = v406(1);
    assert(v421);

    return v421, (8 - v420 % 8) % 8;
end;

function u21.CompressDeflate(p422, p423, p424) -- Line: 2048
    -- upvalues: IsValidArguments (copy), CompressDeflateInternal (copy)
    local v425, v426 = IsValidArguments(p423, false, nil, true, p424);

    if not v425 then
        error("Usage: LibDeflate:CompressDeflate(str, configs): " .. v426, 2);
    end;

    return CompressDeflateInternal(p423, nil, p424);
end;

function u21.CompressDeflateWithDict(p427, p428, p429, p430) -- Line: 2072
    -- upvalues: IsValidArguments (copy), CompressDeflateInternal (copy)
    local v431, v432 = IsValidArguments(p428, true, p429, true, p430);

    if not v431 then
        error("Usage: LibDeflate:CompressDeflateWithDict" .. "(str, dictionary, configs): " .. v432, 2);
    end;

    return CompressDeflateInternal(p428, p429, p430);
end;

function u21.CompressZlib(p433, p434, p435) -- Line: 2092
    -- upvalues: IsValidArguments (copy), CompressZlibInternal (copy)
    local v436, v437 = IsValidArguments(p434, false, nil, true, p435);

    if not v436 then
        error("Usage: LibDeflate:CompressZlib(str, configs): " .. v437, 2);
    end;

    return CompressZlibInternal(p434, nil, p435);
end;

function u21.CompressZlibWithDict(p438, p439, p440, p441) -- Line: 2113
    -- upvalues: IsValidArguments (copy), CompressZlibInternal (copy)
    local v442, v443 = IsValidArguments(p439, true, p440, true, p441);

    if not v442 then
        error("Usage: LibDeflate:CompressZlibWithDict" .. "(str, dictionary, configs): " .. v443, 2);
    end;

    return CompressZlibInternal(p439, p440, p441);
end;

local function CreateReader(u444) -- Line: 2142
    -- upvalues: u2 (copy), byte (copy), char (copy), sub (copy), u3 (copy)
    local u445 = #u444;
    local u446 = 1;
    local u447 = 0;
    local u448 = 0;

    return function(p449) -- Line: 2155, Name: ReadBits
        -- upvalues: u2 (ref), u447 (ref), u448 (ref), u444 (copy), u446 (ref), byte (ref)
        local v450 = u2[p449];

        if p449 <= u447 then
            local v451 = u448 % v450;
            u448 = (u448 - v451) / v450;
            u447 = u447 - p449;

            return v451;
        end;

        local v452 = u2[u447];
        local v453, v454, v455, v456 = byte(u444, u446, u446 + 3);
        u448 = u448 + ((v453 or 0) + (v454 or 0) * 256 + (v455 or 0) * 65536 + (v456 or 0) * 16777216) * v452;
        u446 = u446 + 4;
        u447 = u447 + 32 - p449;
        local v457 = u448 % v450;
        u448 = (u448 - v457) / v450;

        return v457;
    end, function(p458, p459, p460) -- Line: 2185, Name: ReadBytes
        -- upvalues: u447 (ref), u448 (ref), char (ref), u445 (copy), u446 (ref), u444 (copy), sub (ref)
        assert(u447 % 8 == 0);
        local v461;

        if u447 / 8 < p458 then
            v461 = u447 / 8 or p458;
        else
            v461 = p458;
        end;

        for _ = 1, v461 do
            local v462 = u448 % 256;
            p460 = p460 + 1;
            p459[p460] = char(v462);
            u448 = (u448 - v462) / 256;
        end;

        u447 = u447 - v461 * 8;
        local v463 = p458 - v461;

        if (u445 - u446 - v463 + 1) * 8 + u447 < 0 then
            return -1;
        end;

        for i = u446, u446 + v463 - 1 do
            p460 = p460 + 1;
            p459[p460] = sub(u444, i, i);
        end;

        u446 = u446 + v463;

        return p460;
    end, function(p464, p465, p466) -- Line: 2221, Name: Decode
        -- upvalues: u447 (ref), u444 (copy), u2 (ref), u446 (ref), byte (ref), u448 (ref), u3 (ref)
        local v467, v468, v469;

        if p466 > 0 then
            if u447 < 15 and u444 then
                local v470 = u2[u447];
                local v471, v472, v473, v474 = byte(u444, u446, u446 + 3);
                u448 = u448 + ((v471 or 0) + (v472 or 0) * 256 + (v473 or 0) * 65536 + (v474 or 0) * 16777216) * v470;
                u446 = u446 + 4;
                u447 = u447 + 32;
            end;

            local v475 = u2[p466];
            u447 = u447 - p466;
            local v476 = u448 % v475;
            u448 = (u448 - v476) / v475;
            local v477 = u3[p466][v476];
            v467 = p464[p466];

            if v477 < v467 then
                return p465[v477];
            end;

            v468 = v467 * 2;
            v469 = v477 * 2;
        else
            v469 = 0;
            v468 = 0;
            v467 = 0;
        end;

        for i = p466 + 1, 15 do
            local v478 = u448 % 2;
            u448 = (u448 - v478) / 2;
            u447 = u447 - 1;

            if v478 == 1 then
                v469 = v469 + 1 - v469 % 2 or v469;
            end;

            local v479 = p464[i] or 0;
            local v480 = v469 - v468;

            if v480 < v479 then
                return p465[v467 + v480];
            end;

            v467 = v467 + v479;
            v468 = (v468 + v479) * 2;
            v469 = v469 * 2;
        end;

        return -10;
    end, function() -- Line: 2273, Name: ReaderBitlenLeft
        -- upvalues: u445 (copy), u446 (ref), u447 (ref)
        return (u445 - u446 + 1) * 8 + u447;
    end, function() -- Line: 2277, Name: SkipToByteBoundary
        -- upvalues: u447 (ref), u2 (ref), u448 (ref)
        local v481 = u447 % 8;
        local v482 = u2[v481];
        u447 = u447 - v481;
        u448 = (u448 - u448 % v482) / v482;
    end;
end;

local function CreateDecompressState(p483, p484) -- Line: 2292
    -- upvalues: CreateReader (copy)
    local v485, v486, v487, v488, v489 = CreateReader(p483);

    return {
        buffer_size = 0,
        ReadBits = v485,
        ReadBytes = v486,
        Decode = v487,
        ReaderBitlenLeft = v488,
        SkipToByteBoundary = v489,
        buffer = {},
        result_buffer = {},
        dictionary = p484
    };
end;

local function GetHuffmanForDecode(p490, p491, p492) -- Line: 2318
    local v493 = p492;
    local v494 = {};

    for i = 0, p491 do
        local v495 = p490[i] or 0;

        if v495 > 0 and (v495 < p492 and v495) then
            p492 = v495;
        end;

        v494[v495] = (v494[v495] or 0) + 1;
    end;

    if v494[0] == p491 + 1 then
        return 0, v494, {}, 0;
    end;

    local v496 = 1;

    for i = 1, v493 do
        v496 = v496 * 2 - (v494[i] or 0);

        if v496 < 0 then
            return v496, {}, {}, 0;
        end;
    end;

    local v497 = { 0 };

    for i = 1, v493 - 1 do
        v497[i + 1] = v497[i] + (v494[i] or 0);
    end;

    local v498 = {};

    for i = 0, p491 do
        local v499 = p490[i] or 0;

        if v499 ~= 0 then
            v498[v497[v499]] = i;
            v497[v499] = v497[v499] + 1;
        end;
    end;

    return v496, v494, v498, p492;
end;

local function DecodeUntilEndOfBlock(p500, p501, p502, p503, p504, p505, p506) -- Line: 2380
    -- upvalues: u1 (copy), u15 (copy), u10 (copy), u16 (copy), u17 (copy), concat (copy)
    local buffer = p500.buffer;
    local buffer_size = p500.buffer_size;
    local ReadBits = p500.ReadBits;
    local Decode = p500.Decode;
    local ReaderBitlenLeft = p500.ReaderBitlenLeft;
    local result_buffer = p500.result_buffer;
    local dictionary = p500.dictionary;
    local v507, v508, v509;

    if dictionary and not buffer[0] then
        v507 = dictionary.string_table;
        v508 = dictionary.strlen;
        v509 = -v508 + 1;

        for i = 0, -v508 + 1 < -257 and -257 or -v508 + 1, -1 do
            buffer[i] = u1[v507[v508 + i]];
        end;
    else
        v509 = 1;
        v508 = nil;
        v507 = {};
    end;

    while true do
        local v510 = Decode(p501, p502, p503);

        if v510 < 0 or v510 > 285 then
            break;
        end;

        if v510 < 256 then
            buffer_size = buffer_size + 1;
            buffer[buffer_size] = u1[v510];
        elseif v510 > 256 then
            local v511 = v510 - 256;
            local v512 = u15[v511];

            if v511 >= 8 then
                v512 = v512 + ReadBits(u10[v511]) or v512;
            end;

            v510 = Decode(p504, p505, p506);

            if v510 < 0 or v510 > 29 then
                return -10;
            end;

            local v513 = u16[v510];

            if v513 > 4 then
                v513 = v513 + ReadBits(u17[v510]) or v513;
            end;

            local v514 = buffer_size - v513 + 1;

            if v514 < v509 then
                return -11;
            end;

            if v514 >= -257 then
                for _ = 1, v512 do
                    buffer_size = buffer_size + 1;
                    buffer[buffer_size] = buffer[v514];
                    v514 = v514 + 1;
                end;
            else
                local v515 = v508 + v514;

                for _ = 1, v512 do
                    buffer_size = buffer_size + 1;
                    buffer[buffer_size] = u1[v507[v515]];
                    v515 = v515 + 1;
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

        if v510 == 256 then
            p500.buffer_size = buffer_size;

            return 0;
        end;
    end;

    return -10;
end;

local function DecompressStoreBlock(p516) -- Line: 2480
    -- upvalues: concat (copy)
    local buffer = p516.buffer;
    local buffer_size = p516.buffer_size;
    local ReadBits = p516.ReadBits;
    local ReadBytes = p516.ReadBytes;
    local ReaderBitlenLeft = p516.ReaderBitlenLeft;
    local result_buffer = p516.result_buffer;
    p516.SkipToByteBoundary();
    local v517 = ReadBits(16);

    if ReaderBitlenLeft() < 0 then
        return 2;
    end;

    local v518 = ReadBits(16);

    if ReaderBitlenLeft() < 0 then
        return 2;
    end;

    if v517 % 256 + v518 % 256 ~= 255 then
        return -2;
    end;

    if (v517 - v517 % 256) / 256 + (v518 - v518 % 256) / 256 ~= 255 then
        return -2;
    end;

    local v519 = ReadBytes(v517, buffer, buffer_size);

    if v519 < 0 then
        return 2;
    end;

    if v519 >= 65536 then
        result_buffer[#result_buffer + 1] = concat(buffer, "", 1, 32768);

        for i = 32769, v519 do
            buffer[i - 32768] = buffer[i];
        end;

        v519 = v519 - 32768;
        buffer[v519 + 1] = nil;
    end;

    p516.buffer_size = v519;

    return 0;
end;

local function DecompressFixBlock(p520) -- Line: 2526
    -- upvalues: DecodeUntilEndOfBlock (copy), u13 (ref), u18 (ref), u19 (ref), u20 (ref)
    return DecodeUntilEndOfBlock(p520, u13, u18, 7, u19, u20, 5);
end;

local function DecompressDynamicBlock(p521) -- Line: 2536
    -- upvalues: u22 (copy), GetHuffmanForDecode (copy), DecodeUntilEndOfBlock (copy)
    local ReadBits = p521.ReadBits;
    local Decode = p521.Decode;
    local v522 = ReadBits(5) + 257;
    local v523 = ReadBits(5) + 1;
    local v524 = ReadBits(4) + 4;

    if v522 > 286 or v523 > 30 then
        return -3;
    end;

    local v525 = {};

    for i = 1, v524 do
        v525[u22[i]] = ReadBits(3);
    end;

    local v526, v527, v528, v529 = GetHuffmanForDecode(v525, 18, 7);

    if v526 ~= 0 then
        return -4;
    end;

    local v530 = 0;
    local v531 = {};
    local v532 = {};

    while v530 < v522 + v523 do
        local v533 = Decode(v527, v528, v529);

        if v533 < 0 then
            return v533;
        end;

        if v533 < 16 then
            if v530 < v522 then
                v531[v530] = v533;
            else
                v532[v530 - v522] = v533;
            end;

            v530 = v530 + 1;
        else
            local v534 = 0;
            local v535;

            if v533 == 16 then
                if v530 == 0 then
                    return -5;
                end;

                if v530 - 1 < v522 then
                    v534 = v531[v530 - 1];
                else
                    v534 = v532[v530 - v522 - 1];
                end;

                v535 = 3 + ReadBits(2);
            elseif v533 == 17 then
                v535 = 3 + ReadBits(3);
            else
                v535 = 11 + ReadBits(7);
            end;

            if v530 + v535 > v522 + v523 then
                return -6;
            end;

            while v535 > 0 do
                v535 = v535 - 1;

                if v530 < v522 then
                    v531[v530] = v534;
                else
                    v532[v530 - v522] = v534;
                end;

                v530 = v530 + 1;
            end;
        end;
    end;

    if (v531[256] or 0) == 0 then
        return -9;
    end;

    local v536, v537, v538, v539 = GetHuffmanForDecode(v531, v522 - 1, 15);

    if v536 ~= 0 and (v536 < 0 or v522 ~= (v537[0] or 0) + (v537[1] or 0)) then
        return -7;
    end;

    local v540, v541, v542, v543 = GetHuffmanForDecode(v532, v523 - 1, 15);

    return v540 ~= 0 and (v540 < 0 or v523 ~= (v541[0] or 0) + (v541[1] or 0)) and -8 or DecodeUntilEndOfBlock(p521, v537, v538, v539, v541, v542, v543);
end;

local function Inflate(p544) -- Line: 2650
    -- upvalues: DecompressStoreBlock (copy), DecodeUntilEndOfBlock (copy), u13 (ref), u18 (ref), u19 (ref), u20 (ref), DecompressDynamicBlock (copy), concat (copy)
    local ReadBits = p544.ReadBits;
    local v545 = nil;

    while not v545 do
        v545 = ReadBits(1) == 1;
        local v546 = ReadBits(2);
        local v547;

        if v546 == 0 then
            v547 = DecompressStoreBlock(p544);
        elseif v546 == 1 then
            v547 = DecodeUntilEndOfBlock(p544, u13, u18, 7, u19, u20, 5);
        else
            if v546 ~= 2 then
                return nil, -1;
            end;

            v547 = DecompressDynamicBlock(p544);
        end;

        if v547 ~= 0 then
            return nil, v547;
        end;
    end;

    p544.result_buffer[#p544.result_buffer + 1] = concat(p544.buffer, "", 1, p544.buffer_size);

    return concat(p544.result_buffer), 0;
end;

local function DecompressDeflateInternal(p548, p549) -- Line: 2678
    -- upvalues: CreateDecompressState (copy), Inflate (copy)
    local v550 = CreateDecompressState(p548, p549);
    local v551, v552 = Inflate(v550);

    if not v551 then
        return nil, v552;
    end;

    local v553 = v550.ReaderBitlenLeft();

    return v551, (v553 - v553 % 8) / 8;
end;

local function DecompressZlibInternal(p554, p555) -- Line: 2690
    -- upvalues: CreateDecompressState (copy), Inflate (copy), u21 (copy)
    local v556 = CreateDecompressState(p554, p555);
    local ReadBits = v556.ReadBits;
    local v557 = ReadBits(8);

    if v556.ReaderBitlenLeft() < 0 then
        return nil, 2;
    end;

    local v558 = v557 % 16;

    if v558 ~= 8 then
        return nil, -12;
    end;

    if (v557 - v558) / 16 > 7 then
        return nil, -13;
    end;

    local v559 = ReadBits(8);

    if v556.ReaderBitlenLeft() < 0 then
        return nil, 2;
    end;

    if (v557 * 256 + v559) % 31 ~= 0 then
        return nil, -14;
    end;

    local _ = (v559 - v559 % 64) / 64 % 4;

    if (v559 - v559 % 32) / 32 % 2 == 1 then
        if not p555 then
            return nil, -16;
        end;

        local v560 = ReadBits(8);
        local v561 = ReadBits(8);
        local v562 = ReadBits(8);
        local v563 = ReadBits(8);

        if v556.ReaderBitlenLeft() < 0 then
            return nil, 2;
        end;

        if (v560 * 16777216 + v561 * 65536 + v562 * 256 + v563) % 4294967296 ~= p555.adler32 % 4294967296 then
            return nil, -17;
        end;
    end;

    local v564, v565 = Inflate(v556);

    if not v564 then
        return nil, v565;
    end;

    v556.SkipToByteBoundary();
    local v566 = ReadBits(8);
    local v567 = ReadBits(8);
    local v568 = ReadBits(8);
    local v569 = ReadBits(8);

    if v556.ReaderBitlenLeft() < 0 then
        return nil, 2;
    end;

    local v570 = u21:Adler32(v564);

    if (v566 * 16777216 + v567 * 65536 + v568 * 256 + v569) % 4294967296 ~= v570 % 4294967296 then
        return nil, -15;
    end;

    local v571 = v556.ReaderBitlenLeft();

    return v564, (v571 - v571 % 8) / 8;
end;

function u21.DecompressDeflate(p572, p573) -- Line: 2772
    -- upvalues: DecompressDeflateInternal (copy)
    local v574, v575;

    if type(p573) == "string" then
        v574 = true;
        v575 = "";
    else
        v575 = ("\'str\' - string expected got \'%s\'."):format((type(p573)));
        v574 = false;
    end;

    if not v574 then
        error("Usage: LibDeflate:DecompressDeflate(str): " .. v575, 2);
    end;

    return DecompressDeflateInternal(p573);
end;

function u21.DecompressDeflateWithDict(p576, p577, p578) -- Line: 2798
    -- upvalues: IsValidDictionary (copy), DecompressDeflateInternal (copy)
    local v579, v580;

    if type(p577) == "string" then
        local v581;
        v581, v579 = IsValidDictionary(p578);

        if v581 then
            v580 = true;
            v579 = "";
        else
            v580 = false;
        end;
    else
        v579 = ("\'str\' - string expected got \'%s\'."):format((type(p577)));
        v580 = false;
    end;

    if not v580 then
        error("Usage: LibDeflate:DecompressDeflateWithDict(str, dictionary): " .. v579, 2);
    end;

    return DecompressDeflateInternal(p577, p578);
end;

function u21.DecompressZlib(p582, p583) -- Line: 2820
    -- upvalues: DecompressZlibInternal (copy)
    local v584, v585;

    if type(p583) == "string" then
        v584 = true;
        v585 = "";
    else
        v585 = ("\'str\' - string expected got \'%s\'."):format((type(p583)));
        v584 = false;
    end;

    if not v584 then
        error("Usage: LibDeflate:DecompressZlib(str): " .. v585, 2);
    end;

    return DecompressZlibInternal(p583);
end;

function u21.DecompressZlibWithDict(p586, p587, p588) -- Line: 2846
    -- upvalues: IsValidDictionary (copy), DecompressZlibInternal (copy)
    local v589, v590;

    if type(p587) == "string" then
        local v591;
        v591, v589 = IsValidDictionary(p588);

        if v591 then
            v590 = true;
            v589 = "";
        else
            v590 = false;
        end;
    else
        v589 = ("\'str\' - string expected got \'%s\'."):format((type(p587)));
        v590 = false;
    end;

    if not v590 then
        error("Usage: LibDeflate:DecompressZlibWithDict(str, dictionary): " .. v589, 2);
    end;

    return DecompressZlibInternal(p587, p588);
end;

u11 = {};

for i = 0, 143 do
    u11[i] = 8;
end;

for i = 144, 255 do
    u11[i] = 9;
end;

u11[256] = 7;
u11[257] = 7;
u11[258] = 7;
u11[259] = 7;
u11[260] = 7;
u11[261] = 7;
u11[262] = 7;
u11[263] = 7;
u11[264] = 7;
u11[265] = 7;
u11[266] = 7;
u11[267] = 7;
u11[268] = 7;
u11[269] = 7;
u11[270] = 7;
u11[271] = 7;
u11[272] = 7;
u11[273] = 7;
u11[274] = 7;
u11[275] = 7;
u11[276] = 7;
u11[277] = 7;
u11[278] = 7;
u11[279] = 7;
u11[280] = 8;
u11[281] = 8;
u11[282] = 8;
u11[283] = 8;
u11[284] = 8;
u11[285] = 8;
u11[286] = 8;
u11[287] = 8;
local v592 = {};

for i = 0, 31 do
    v592[i] = 5;
end;

local v593, v594, v595 = GetHuffmanForDecode(u11, 287, 9);
u13 = v594;
u18 = v595;
assert(v593 == 0);
local v596, v597, v598 = GetHuffmanForDecode(v592, 31, 5);
u19 = v597;
u20 = v598;
assert(v596 == 0);
u12 = GetHuffmanCodeFromBitlen(u13, u11, 287, 9);
u14 = GetHuffmanCodeFromBitlen(u19, v592, 31, 5);
local u599 = {
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

local function escape_for_gsub(p600) -- Line: 2907
    -- upvalues: u599 (copy)
    local v601, _ = p600:gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", u599);

    return v601;
end;

function u21.CreateCodec(p602, p603, p604, p605) -- Line: 2952
    -- upvalues: byte (copy), sub (copy), concat (copy), u599 (copy), u1 (copy), gsub (copy), find (copy)
    if type(p603) ~= "string" or (type(p604) ~= "string" or type(p605) ~= "string") then
        error(
            "Usage: LibDeflate:CreateCodec(reserved_chars, escape_chars, map_chars): All arguments must be string.",
            2
        );
    end;

    if p604 == "" then
        return nil, "No escape characters supplied.";
    end;

    if #p603 < #p605 then
        return nil, "The number of reserved characters must be at least as many as the number of mapped chars.";
    end;

    if p603 == "" then
        return nil, "No characters to encode.";
    end;

    local v606 = p603 .. p604 .. p605;
    local v607 = {};

    for i = 1, #v606 do
        local v608 = byte(v606, i, i);

        if v607[v608] then
            return nil, "There must be no duplicate characters in the concatenation of reserved_chars, escape_chars and map_chars.";
        end;

        v607[v608] = true;
    end;

    local u609 = {};
    local u610 = {};
    local v611 = {};
    local u612 = {};

    if #p605 > 0 then
        local v613 = {};
        local v614 = {};

        for i = 1, #p605 do
            local v615 = sub(p603, i, i);
            local v616 = sub(p605, i, i);
            u612[v615] = v616;
            v611[#v611 + 1] = v615;
            v613[v616] = v615;
            v614[#v614 + 1] = v616;
        end;

        local v617, _ = concat(v614):gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", u599);
        u609[#u609 + 1] = "([" .. v617 .. "])";
        u610[#u610 + 1] = v613;
    end;

    local v618 = 1;
    local v619 = sub(p604, v618, v618);
    local v620 = 0;
    local v621 = {};
    local v622 = {};

    for i = 1, #v606 do
        local v623 = sub(v606, i, i);

        if not u612[v623] then
            while v620 >= 256 or v607[v620] do
                v620 = v620 + 1;

                if v620 > 255 then
                    local v624, _ = v619:gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", u599);
                    local v625, _ = concat(v621):gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", u599);
                    u609[#u609 + 1] = v624 .. "([" .. v625 .. "])";
                    u610[#u610 + 1] = v622;
                    v618 = v618 + 1;
                    v619 = sub(p604, v618, v618);

                    if not v619 or v619 == "" then
                        return nil, "Out of escape characters.";
                    end;

                    v620 = 0;
                    v621 = {};
                    v622 = {};
                end;
            end;

            local v626 = u1[v620];
            u612[v623] = v619 .. v626;
            v611[#v611 + 1] = v623;
            v622[v626] = v623;
            v621[#v621 + 1] = v626;
            v620 = v620 + 1;
        end;

        if i == #v606 then
            local v627, _ = v619:gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", u599);
            local v628, _ = concat(v621):gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", u599);
            u609[#u609 + 1] = v627 .. "([" .. v628 .. "])";
            u610[#u610 + 1] = v622;
        end;
    end;

    local v629 = {};
    local v630, _ = concat(v611):gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", u599);
    local u631 = "([" .. v630 .. "])";

    function v629.Encode(p632, p633) -- Line: 3065
        -- upvalues: gsub (ref), u631 (copy), u612 (copy)
        if type(p633) ~= "string" then
            error(("Usage: codec:Encode(str): \'str\' - string expected got \'%s\'."):format((type(p633))), 2);
        end;

        local v634, _ = gsub(p633, u631, u612);

        return v634;
    end;

    local u635 = #u609;
    local v636, _ = p603:gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", u599);
    local u637 = "([" .. v636 .. "])";

    function v629.Decode(p638, p639) -- Line: 3078
        -- upvalues: find (ref), u637 (copy), u635 (copy), gsub (ref), u609 (copy), u610 (copy)
        if type(p639) ~= "string" then
            error(("Usage: codec:Decode(str): \'str\' - string expected got \'%s\'."):format((type(p639))), 2);
        end;

        if find(p639, u637) then
            return nil;
        end;

        for i = 1, u635 do
            p639 = gsub(p639, u609[i], u610[i]);
        end;

        return p639;
    end;

    return v629, "";
end;

u21.internals = {
    LoadStringToTable = LoadStringToTable,
    IsValidDictionary = IsValidDictionary,
    IsEqualAdler32 = IsEqualAdler32
};

return table.freeze(u21);