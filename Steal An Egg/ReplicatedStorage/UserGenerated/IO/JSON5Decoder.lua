-- Decompiled with Potassium's decompiler.

local u1 = { " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", "　", " ", "\r\n", "\t", "\n", "\11", "\f", "\r", " " };

local function MAKE_LOOKUP(p2) -- Line: 67
    local v3 = {};

    for _, v in ipairs(p2) do
        v3[v] = true;
    end;

    return v3;
end;

local v4 = {};
local u5 = { " ", " ", "\r\n", "\r", "\n" };

for _, v in ipairs(u1) do
    v4[v] = true;
end;

local u6 = {};

for _, v in ipairs(u5) do
    u6[v] = true;
end;

local u7 = {
    ["0"] = "\0",
    ["\'"] = "\'",
    ["\""] = "\"",
    ["\\"] = "\\",
    b = "\8",
    f = "\f",
    n = "\n",
    r = "\r",
    t = "\t",
    v = "\11"
};

local function Q(p8) -- Line: 91
    return string.format("%q", p8):gsub("\r", "\\r"):gsub("\n", "\\n");
end;

local function formatError(p9, p10) -- Line: 97
    return string.format("%s at line %d col %d", p9, p10[1], p10[2]);
end;

local function advanceNewline(p11, p12) -- Line: 103
    -- upvalues: u6 (copy)
    if not u6[p11] then
        return false;
    end;

    p12[1] = p12[1] + 1;
    p12[2] = 1;

    return true;
end;

local function getNewline(p13, p14) -- Line: 115
    -- upvalues: u5 (copy), u6 (copy)
    for _, v in ipairs(u5) do
        if p13:sub(1, #v) == v then
            local v15;

            if u6[v] then
                p14[1] = p14[1] + 1;
                p14[2] = 1;
                v15 = true;
            else
                v15 = false;
            end;

            if v15 then
                return v;
            end;
        end;
    end;

    return nil;
end;

local function getWhitespace(p16, p17) -- Line: 127
    -- upvalues: u1 (copy), u6 (copy)
    if #p16 == 0 then
        return nil;
    end;

    for _, v in ipairs(u1) do
        if p16:sub(1, #v) == v then
            p17[2] = p17[2] + #v;

            if not u6[v] then
                return v;
            end;

            p17[1] = p17[1] + 1;
            p17[2] = 1;

            return v;
        end;
    end;

    return nil;
end;

local function stripWhitespace(p18, p19) -- Line: 145
    -- upvalues: getWhitespace (copy)
    while true do
        local v20 = getWhitespace(p18, p19);

        if v20 == nil then
            break;
        end;

        p18 = p18:sub(#v20 + 1);
    end;

    return p18;
end;

local function stripInlineComments(p21, p22) -- Line: 162
    -- upvalues: getNewline (copy)
    while #p21 ~= 0 do
        local v23 = getNewline(p21, p22);

        if v23 then
            return p21:sub(#v23 + 1);
        end;

        p21 = p21:sub(2);
        p22[2] = p22[2] + 1;
    end;

    return p21;
end;

local function stripBlockComments(p24, p25) -- Line: 186
    -- upvalues: getNewline (copy), formatError (copy)
    while #p24 > 0 do
        if p24:sub(1, 2) == "*/" then
            p25[2] = p25[2] + 2;

            return p24:sub(3);
        end;

        local v26 = getNewline(p24, p25);

        if v26 then
            p24 = p24:sub(#v26 + 1);
        else
            p25[2] = p25[2] + 1;
            p24 = p24:sub(2);
        end;
    end;

    error(formatError("missing multiline comment close tag", p25));

    return "";
end;

local function codepointToutf8(p27) -- Line: 210
    if p27 <= 127 then
        return string.char(p27);
    end;

    if p27 <= 2047 then
        local v28 = math.floor(p27 / 64) + 192;

        return string.char(v28, p27 % 64 + 128);
    end;

    if p27 <= 65535 then
        local v29 = math.floor(p27 / 4096) + 224;
        local v30 = math.floor(p27 % 4096 / 64) + 128;

        return string.char(v29, v30, p27 % 64 + 128);
    end;

    if p27 > 1114111 then
        return nil, string.format("invalid unicode codepoint \'%x\'", p27);
    end;

    local v31 = math.floor(p27 / 262144) + 240;
    local v32 = math.floor(p27 % 262144 / 4096) + 128;
    local v33 = math.floor(p27 % 4096 / 64) + 128;

    return string.char(v31, v32, v33, p27 % 64 + 128);
end;

local function parseUnicodeImpl(p34, p35) -- Line: 232
    -- upvalues: formatError (copy)
    local v36 = p34:match("^\\u(%x%x%x%x)");

    if not v36 then
        error(formatError("invalid unicode hex escape sequence", p35));
    end;

    local v37 = tonumber(v36, 16);

    if not v37 then
        error(formatError("invalid unicode hex escape sequence", p35));
    end;

    p35[2] = p35[2] + 6;

    return v37, p34:sub(7);
end;

local function getSurrogatePair(p38, p39) -- Line: 249
    return (p39 - 55296) * 1024 + (p38 - 56320) + 65536;
end;

local function parseUnicode(p40, p41) -- Line: 255
    -- upvalues: parseUnicodeImpl (copy), codepointToutf8 (copy), formatError (copy)
    local v42 = p41[1];
    local v43 = p41[2];
    local v44, v45 = parseUnicodeImpl(p40, p41);

    if v44 >= 55296 and v44 < 56320 then
        local v46;
        v46, v45 = parseUnicodeImpl(v45, p41);

        if v46 and (v46 >= 56320 and v46 <= 57343) then
            v44 = (v44 - 55296) * 1024 + (v46 - 56320) + 65536;
        end;
    end;

    local v47, v48 = codepointToutf8(v44);

    if not v47 then
        error(formatError(assert(v48), { v42, v43 }));
    end;

    return v47, v45;
end;

local function parseStringImpl(p49, p50, p51, p52) -- Line: 285
    -- upvalues: u7 (copy), formatError (copy), parseUnicode (copy), getNewline (copy)
    local v53 = {};

    while not p50(p49) do
        local v54 = p49:sub(1, 1);

        if v54 == "\\" then
            local v55 = p49:sub(2, 2);
            p52[2] = p52[2] + 1;

            if u7[v55] then
                p52[2] = p52[2] + 1;

                if p51 then
                    error(formatError("escape sequence not allowed", p52));
                end;

                v53[#v53 + 1] = u7[v55];
                p49 = p49:sub(3);
            elseif v55 == "u" then
                local v56;
                v56, p49 = parseUnicode(p49, p52);
                v53[#v53 + 1] = v56;
            elseif v55 == "x" then
                if p51 then
                    error(formatError("hex escape sequence not allowed", p52));
                end;

                p52[2] = p52[2] + 2;
                local v57 = p49:sub(2, 3);
                local v58 = tonumber(v57, 16);

                if not v58 then
                    error(formatError("invalid hex escape sequence", p52));
                end;

                v53[#v53 + 1] = string.char(v58);
                p52[2] = p52[2] + 2;
                p49 = p49:sub(5);
            else
                if p51 then
                    error(formatError("invalid escape sequence", p52));
                end;

                local v59 = getNewline(p49:sub(2), p52);
                p49 = p49:sub(not v59 and 2 or #v59 + 2);
            end;
        elseif v54:byte(1, 1) < 32 then
            error(formatError("control character found", p52));
        else
            v53[#v53 + 1] = v54;
            p49 = p49:sub(2);
            p52[2] = p52[2] + 1;
        end;
    end;

    return table.concat(v53), p49;
end;

local function parseString(p60, p61) -- Line: 364
    -- upvalues: parseStringImpl (copy)
    local u62 = p60:sub(1, 1);
    local v64, v65 = parseStringImpl(p60:sub(2), function(p63) -- Line: 369, Name: stopCriterion
        -- upvalues: u62 (copy)
        return p63:sub(1, 1) == u62;
    end, false, p61);
    p61[2] = p61[2] + 1;

    return v64, v65:sub(2);
end;

local function parseNumber(p66, p67) -- Line: 382
    -- upvalues: getWhitespace (copy), formatError (copy)
    local v68 = 1;
    local v69 = p66:sub(1, 1);
    local v70 = p67[1];
    local v71 = p67[2];

    if v69 == "+" then
        p66 = p66:sub(2);
        p67[2] = p67[2] + 1;
        v68 = 1;
    elseif v69 == "-" then
        p66 = p66:sub(2);
        p67[2] = p67[2] + 1;
        v68 = -1;
    end;

    if p66:sub(1, 3) == "NaN" then
        p67[2] = p67[2] + 3;

        return (0 / 0), p66:sub(4);
    end;

    if p66:find("Infinity", 1, true) == 1 then
        p67[2] = p67[2] + 8;

        return (1 / 0) * v68, p66:sub(9);
    end;

    local v72 = p66;
    local v73 = 0;

    while not getWhitespace(p66, p67) do
        local v74 = p66:sub(1, 1);

        if v74 == "" or (v74 == "," or (v74 == "]" or v74 == "}")) then
            break;
        end;

        v73 = v73 + 1;
        p66 = p66:sub(2);
        p67[2] = p67[2] + 1;
    end;

    local v75 = v72:sub(1, v73);
    local v76;

    if v75:sub(1, 1) == "0" and v75:sub(2):find("^%d+$") then
        v76 = nil;
    else
        v76 = tonumber(v75);
    end;

    if v76 == nil then
        error(formatError("invalid number sequence " .. string.format("%q", v75):gsub("\r", "\\r"):gsub("\n", "\\n"), { v70, v71 }));
    end;

    p67[2] = p67[2] + v73;

    return v76 * v68, v72:sub(v73 + 1);
end;

local function parseBoolean(p77, p78) -- Line: 460
    -- upvalues: formatError (copy)
    if p77:sub(1, 4) == "true" then
        p78[2] = p78[2] + 4;

        return true, p77:sub(5);
    end;

    if p77:sub(1, 5) == "false" then
        p78[2] = p78[2] + 5;

        return false, p77:sub(6);
    end;

    error(formatError("invalid boolean literal", p78));
end;

local function stripComments(p79, p80) -- Line: 474
    -- upvalues: stripInlineComments (copy), stripBlockComments (copy)
    local v81 = p79:sub(1, 2);

    if v81 == "//" then
        p80[2] = p80[2] + 2;

        return stripInlineComments(p79:sub(3), p80);
    end;

    if v81 ~= "/*" then
        return p79;
    end;

    p80[2] = p80[2] + 2;

    return stripBlockComments(p79:sub(3), p80);
end;

local function stripWhitespaceAndComments(p82, p83) -- Line: 489
    -- upvalues: stripWhitespace (copy), stripComments (copy)
    while true do
        local v84 = stripComments(stripWhitespace(p82, p83), p83);

        if v84 == p82 then
            break;
        end;

        p82 = v84;
    end;

    return p82;
end;

local u85 = nil;

local function testIdentifier(p86) -- Line: 556
    local v87 = p86:byte(1, 1);

    if v87 >= 48 and v87 <= 57 then
        return false;
    end;

    for i = 1, #p86 do
        local v88 = p86:byte(i, i);

        if v88 < 36 then
            return false;
        end;

        if v88 >= 37 and v88 <= 47 then
            return false;
        end;

        if v88 >= 58 and v88 <= 64 then
            return false;
        end;

        if v88 >= 91 and v88 <= 94 then
            return false;
        end;

        if v88 == 96 then
            return false;
        end;

        if v88 >= 123 and v88 <= 128 then
            return false;
        end;
    end;

    return true;
end;

local function stopIdentifier(p89) -- Line: 593
    -- upvalues: getWhitespace (copy)
    return p89:sub(1, 1) == ":" and true or getWhitespace(p89, { 0, 0 }) ~= nil;
end;

local function parseIdentifier(p90, p91) -- Line: 599
    -- upvalues: parseString (copy), parseStringImpl (copy), stopIdentifier (copy), testIdentifier (copy), formatError (copy)
    local v92 = p90:sub(1, 1);
    local v93, v94;

    if v92 == "\'" or v92 == "\"" then
        v93, v94 = parseString(p90, p91);
    else
        local v95 = p91[1];
        local v96 = p91[2];
        v93, v94 = parseStringImpl(p90, stopIdentifier, true, p91);

        if not testIdentifier(v93) then
            error(formatError("invalid identifier " .. string.format("%q", v93):gsub("\r", "\\r"):gsub("\n", "\\n"), { v95, v96 }));
        end;
    end;

    return v93, v94;
end;

local u127 = {
    ["-"] = parseNumber,
    ["+"] = parseNumber,
    ["."] = parseNumber,
    ["0"] = parseNumber,
    ["1"] = parseNumber,
    ["2"] = parseNumber,
    ["3"] = parseNumber,
    ["4"] = parseNumber,
    ["5"] = parseNumber,
    ["6"] = parseNumber,
    ["7"] = parseNumber,
    ["8"] = parseNumber,
    ["9"] = parseNumber,
    N = parseNumber,
    I = parseNumber,

    n = function(p97, p98, p99) -- Line: 449, Name: parseNull
        -- upvalues: formatError (copy)
        if p97:sub(1, 4) ~= "null" then
            error(formatError("invalid null literal", p98));
        end;

        p98[2] = p98[2] + 1;

        return p99, p97:sub(5);
    end,

    t = parseBoolean,
    f = parseBoolean,
    ["\'"] = parseString,
    ["\""] = parseString,

    ["["] = function(p100, p101, p102) -- Line: 514, Name: parseArray
        -- upvalues: stripWhitespaceAndComments (copy), u85 (ref), formatError (copy)
        local v103 = p100:sub(2);
        p101[2] = p101[2] + 1;
        local v104 = {};

        while true do
            local v105 = stripWhitespaceAndComments(v103, p101);

            if v105:sub(1, 1) == "]" then
                p101[2] = p101[2] + 1;
                v103 = v105:sub(2);
                break;
            end;

            local v106, v107 = u85(v105, p101, p102);
            local v108 = stripWhitespaceAndComments(v107, p101);
            v104[#v104 + 1] = v106;
            local v109 = v108:sub(1, 1);
            v103 = v108:sub(2);

            if v109 == "]" then
                p101[2] = p101[2] + 1;
                break;
            end;

            if v109 ~= "," then
                error(formatError("expected comma got " .. string.format("%q", v109):gsub("\r", "\\r"):gsub("\n", "\\n"), p101));
            end;

            p101[2] = p101[2] + 1;
        end;

        return v104, v103;
    end,

    ["{"] = function(p110, p111, p112) -- Line: 624, Name: parseObject
        -- upvalues: stripWhitespaceAndComments (copy), parseIdentifier (copy), formatError (copy), u85 (ref)
        p111[2] = p111[2] + 1;
        local v113 = p110:sub(2);
        local v114 = {};

        while true do
            local v115 = stripWhitespaceAndComments(v113, p111);

            if v115:sub(1, 1) == "}" then
                p111[2] = p111[2] + 1;
                v113 = v115:sub(2);
                break;
            end;

            local v116, v117 = parseIdentifier(v115, p111);
            local v118 = stripWhitespaceAndComments(v117, p111);

            if v118:sub(1, 1) ~= ":" then
                local v119 = error;
                local v120 = v118:sub(1, 1);
                v119(formatError("expected colon after identifier, got " .. string.format("%q", v120):gsub("\r", "\\r"):gsub("\n", "\\n"), p111));
            end;

            p111[2] = p111[2] + 1;
            local v121, v122 = u85(stripWhitespaceAndComments(v118:sub(2), p111), p111, p112);
            local v123 = stripWhitespaceAndComments(v122, p111);
            v114[v116] = v121;
            local v124 = v123:sub(1, 1);
            v113 = v123:sub(2);

            if v124 == "}" then
                p111[2] = p111[2] + 1;
                break;
            end;

            if v124 ~= "," then
                error(formatError("expected comma got " .. string.format("%q", v124):gsub("\r", "\\r"):gsub("\n", "\\n"), p111));
            end;

            p111[2] = p111[2] + 1;
        end;

        return v114, v113;
    end,

    [""] = function(p125, p126) -- Line: 684, Name: catchEOF
        -- upvalues: formatError (copy)
        error(formatError("unexpected eof", p126));
    end
};

u85 = function(p128, p129, p130) -- Line: 718
    -- upvalues: stripWhitespaceAndComments (copy), u127 (copy), formatError (copy)
    local v131 = stripWhitespaceAndComments(p128, p129);
    local v132 = v131:sub(1, 1);
    local v133 = u127[v132];

    if not v133 then
        error(formatError("invalid value literal " .. string.format("%q", v132):gsub("\r", "\\r"):gsub("\n", "\\n"), p129));
    end;

    return v133(v131, p129, p130);
end;

local v139 = {
    Null = newproxy(false),

    Decode = function(p134, p135) -- Line: 747, Name: Decode
        -- upvalues: stripWhitespaceAndComments (copy), u85 (ref), formatError (copy)
        local v136 = { 1, 1 };
        local v137, v138 = u85(stripWhitespaceAndComments(p134, v136), v136, p135);

        if #stripWhitespaceAndComments(v138, v136) > 0 then
            error(formatError("trailing garbage", v136));
        end;

        return v137;
    end
};

return table.freeze(v139);