-- Decompiled with Potassium's decompiler.

local u1 = {
    _TYPE = "module",
    _NAME = "compress.deflatelua",
    _VERSION = "0.3.20111128"
};
local sort = table.sort;
local max = math.max;
local _ = string.char;
local crc32 = require(script.crc32);

local function requireany(...) -- Line: 124
    local v2 = {};

    for i = 1, select("#", ...) do
        local v3 = select(i, ...);

        if type(v3) ~= "string" then
            return v3, "";
        end;

        local success, result = pcall(require, v3);

        if success then
            return result, v3;
        end;

        v2[#v2 + 1] = result;
    end;

    error(table.concat(v2, "\n"), 2);
end;

local u4 = bit32;
local u5, u6, u7;

if u4 then
    u5 = bit32.band;
    u6 = bit32.lshift;
    u7 = bit32.rshift;
else
    u6 = nil;
    u5 = nil;
    u7 = nil;
end;

local function debug(...) -- Line: 153
    print("DEBUG", ...);
end;

local function runtime_error(p8, p9) -- Line: 157
    error({ p8 }, (p9 or 1) + 1);
end;

local function make_outstate(p10) -- Line: 162
    return {
        outbs = p10,
        window = {},
        window_pos = 1
    };
end;

local function output(p11, p12) -- Line: 170
    local window_pos = p11.window_pos;
    p11.outbs(p12);
    p11.window[window_pos] = p12;
    p11.window_pos = window_pos % 32768 + 1;
end;

local function noeof(p13) -- Line: 178
    return assert(p13, "unexpected end of file");
end;

local function hasbit(p14, p15) -- Line: 182
    return p15 <= p14 % (p15 + p15);
end;

local function memoize(u16) -- Line: 186
    local v17 = {};
    local u18 = setmetatable({}, v17);

    function v17.__index(p19, p20) -- Line: 189
        -- upvalues: u16 (copy), u18 (copy)
        local v21 = u16(p20);
        u18[p20] = v21;

        return v21;
    end;

    return u18;
end;

local u23 = memoize(function(p22) -- Line: 198
    return 2 ^ p22;
end);

local function bytestream_from_file(u24) -- Line: 230
    return {
        read = function(p25) -- Line: 232, Name: read
            -- upvalues: u24 (copy)
            local v26 = u24:read(1);

            if v26 then
                return v26:byte();
            end;
        end
    };
end;

local function bytestream_from_string(u27) -- Line: 241
    local u28 = 1;

    return {
        read = function(p29) -- Line: 244, Name: read
            -- upvalues: u28 (ref), u27 (copy)
            local v30;

            if u28 <= #u27 then
                v30 = u27:byte(u28);
                u28 = u28 + 1;
            else
                v30 = nil;
            end;

            return v30;
        end
    };
end;

local function bytestream_from_function(u31) -- Line: 255
    local u32 = 0;
    local u33 = "";

    return {
        read = function(p34) -- Line: 259, Name: read
            -- upvalues: u32 (ref), u33 (ref), u31 (copy)
            u32 = u32 + 1;

            if u32 > #u33 then
                u33 = u31();

                if not u33 then
                    return;
                end;

                u32 = 1;
            end;

            return u33:byte(u32, u32);
        end
    };
end;

local function bitstream_from_bytestream(u35) -- Line: 273
    -- upvalues: u4 (copy), u6 (ref), u5 (ref), u7 (ref), u23 (copy)
    local u36 = 0;
    local u37 = 0;
    local v39 = {
        nbits_left_in_byte = function(p38) -- Line: 278, Name: nbits_left_in_byte
            -- upvalues: u37 (ref)
            return u37;
        end
    };

    if u4 then
        function v39.read(p40, p41) -- Line: 283
            -- upvalues: u37 (ref), u35 (copy), u36 (ref), u6 (ref), u5 (ref), u7 (ref)
            local v42 = p41 or 1;

            while u37 < v42 do
                local v43 = u35:read();

                if not v43 then
                    return;
                end;

                u36 = u36 + u6(v43, u37);
                u37 = u37 + 8;
            end;

            local v44;

            if v42 == 0 then
                v44 = 0;
            elseif v42 == 32 then
                v44 = u36;
                u36 = 0;
            else
                v44 = u5(u36, u7(4294967295, 32 - v42));
                u36 = u7(u36, v42);
            end;

            u37 = u37 - v42;

            return v44;
        end;
    else
        function v39.read(p45, p46) -- Line: 307
            -- upvalues: u37 (ref), u35 (copy), u36 (ref), u23 (ref)
            local v47 = p46 or 1;

            while u37 < v47 do
                local v48 = u35:read();

                if not v48 then
                    return;
                end;

                u36 = u36 + u23[u37] * v48;
                u37 = u37 + 8;
            end;

            local v49 = u23[v47];
            local v50 = u36 % v49;
            u36 = (u36 - v50) / v49;
            u37 = u37 - v47;

            return v50;
        end;
    end;

    is_bitstream[v39] = true;

    return v39;
end;

local function get_bitstream(u51) -- Line: 330
    -- upvalues: bitstream_from_bytestream (copy)
    local v52 = nil;

    if is_bitstream[u51] then
        return u51;
    end;

    if type(u51) == "string" then
        local u53 = 1;

        return bitstream_from_bytestream({
            read = function(p54) -- Line: 244, Name: read
                -- upvalues: u53 (ref), u51 (copy)
                local v55;

                if u53 <= #u51 then
                    v55 = u51:byte(u53);
                    u53 = u53 + 1;
                else
                    v55 = nil;
                end;

                return v55;
            end
        });
    end;

    if type(u51) ~= "function" then
        error({ "unrecognized type" }, (nil or 1) + 1);

        return v52;
    end;

    local u56 = 0;
    local u57 = "";

    return bitstream_from_bytestream({
        read = function(p58) -- Line: 259, Name: read
            -- upvalues: u56 (ref), u57 (ref), u51 (copy)
            u56 = u56 + 1;

            if u56 > #u57 then
                u57 = u51();

                if not u57 then
                    return;
                end;

                u56 = 1;
            end;

            return u57:byte(u56, u56);
        end
    });
end;

local function get_obytestream(p59) -- Line: 344
    if type(p59) == "function" then
        return p59;
    end;

    local v60 = { "unrecognized type: " .. tostring(p59) };
    error(v60, (nil or 1) + 1);

    return nil;
end;

local function HuffmanTable(p61, p62) -- Line: 354
    -- upvalues: sort (copy), u23 (copy), u4 (copy), u6 (ref), u5 (ref), u7 (ref), memoize (copy)
    local v63 = {};

    if p62 then
        for i, v in pairs(p61) do
            if v ~= 0 then
                v63[#v63 + 1] = {
                    val = i,
                    nbits = v
                };
            end;
        end;
    else
        for i = 1, #p61 - 2, 2 do
            local v64 = p61[i];
            local v65 = p61[i + 1];
            local v66 = p61[i + 2];

            if v65 ~= 0 then
                for i2 = v64, v66 - 1 do
                    v63[#v63 + 1] = {
                        val = i2,
                        nbits = v65
                    };
                end;
            end;
        end;
    end;

    sort(v63, function(p67, p68) -- Line: 374
        return p67.nbits == p68.nbits and p67.val < p68.val and true or p67.nbits < p68.nbits;
    end);
    local v69 = 0;
    local v70 = 1;

    for _, v in ipairs(v63) do
        if v.nbits ~= v69 then
            v70 = v70 * u23[v.nbits - v69];
            v69 = v.nbits;
        end;

        v.code = v70;
        v70 = v70 + 1;
    end;

    local u71 = (1 / 0);
    local u72 = {};

    for _, v in ipairs(v63) do
        u71 = math.min(u71, v.nbits);
        u72[v.code] = v.val;
    end;

    local u80 = u4 and function(p73, p74) -- Line: 405
        -- upvalues: u6 (ref), u5 (ref), u7 (ref)
        local v75 = 0;

        for _ = 1, p74 do
            v75 = u6(v75, 1) + u5(p73, 1);
            p73 = u7(p73, 1);
        end;

        return v75;
    end or function(p76, p77) -- Line: 413
        local v78 = 0;

        for _ = 1, p77 do
            local v79 = p76 % 2;
            p76 = (p76 - v79) / 2;
            v78 = v78 * 2 + v79;
        end;

        return v78;
    end;
    local u82 = memoize(function(p81) -- Line: 423
        -- upvalues: u23 (ref), u71 (ref), u80 (copy)
        return u23[u71] + u80(p81, u71);
    end);

    function v63.read(p83, p84) -- Line: 427
        -- upvalues: u82 (copy), u71 (ref), u72 (copy)
        local v85 = 0;
        local v86 = 1;

        while true do
            if v85 == 0 then
                local v87 = p84:read(u71);
                v86 = u82[assert(v87, "unexpected end of file")];
                v85 = v85 + u71;
            else
                local v88 = p84:read();
                local v89 = assert(v88, "unexpected end of file");
                v85 = v85 + 1;
                v86 = v86 * 2 + v89;
            end;

            local v90 = u72[v86];

            if v90 then
                return v90;
            end;
        end;
    end;

    return v63;
end;

local function parse_gzip_header(p91) -- Line: 454
    local v92 = p91:read(8);
    local v93 = p91:read(8);

    if v92 ~= 31 or v93 ~= 139 then
        error({ "not in gzip format" }, (nil or 1) + 1);
    end;

    p91:read(8);
    local v94 = p91:read(8);
    p91:read(32);
    p91:read(8);

    if not p91:read(8) then
        error({ "invalid header" }, (nil or 1) + 1);
    end;

    if v94 % 8 >= 4 then
        local v95 = 0;

        for _ = 1, p91:read(16) do
            v95 = p91:read(8);
        end;

        if not v95 then
            error({ "invalid header" }, (nil or 1) + 1);
        end;
    end;

    local function parse_zstring(p96) -- Line: 496
        while true do
            local v97 = p96:read(8);

            if not v97 then
                error({ "invalid header" }, (nil or 1) + 1);
            end;

            if v97 == 0 then
                return;
            end;
        end;
    end;

    if v94 % 16 >= 8 then
        parse_zstring(p91);
    end;

    if v94 % 32 >= 16 then
        parse_zstring(p91);
    end;

    if v94 % 4 >= 2 and not p91:read(16) then
        error({ "invalid header" }, (nil or 1) + 1);
    end;
end;

local function parse_zlib_header(p98) -- Line: 526
    local v99 = p98:read(4);
    local v100 = p98:read(4);
    local v101 = p98:read(5);
    local v102 = p98:read(1);
    local v103 = p98:read(2);

    if v99 ~= 8 then
        error({ "unrecognized zlib compression method: " .. v99 }, (nil or 1) + 1);
    end;

    if v100 > 7 then
        error({ "invalid zlib window size: cinfo=" .. v100 }, (nil or 1) + 1);
    end;

    if ((v100 * 16 + v99) * 256 + (v101 + v102 * 32 + v103 * 64)) % 31 ~= 0 then
        error({ "invalid zlib header (bad fcheck sum)" }, (nil or 1) + 1);
    end;

    if v102 == 1 then
        error({ "FIX:TODO - FDICT not currently implemented" }, (nil or 1) + 1);
        p98:read(32);
    end;

    return 2 ^ (v100 + 8);
end;

local function parse_huffmantables(u104) -- Line: 555
    -- upvalues: HuffmanTable (copy)
    local v105 = u104:read(5);
    local v106 = u104:read(5);
    local v107 = u104:read(4);
    local v108 = { 16, 17, 18, 0, 8, 7, 9, 6, 10, 5, 11, 4, 12, 3, 13, 2, 14, 1, 15 };
    local v109 = {};

    for i = 1, assert(v107, "unexpected end of file") + 4 do
        local v110 = u104:read(3);
        v109[v108[i]] = v110;
    end;

    local u111 = HuffmanTable(v109, true);

    local function decode(p112) -- Line: 590
        -- upvalues: u111 (copy), u104 (copy), HuffmanTable (ref)
        local v113 = 0;
        local v114 = {};
        local v115 = nil;

        while v113 < p112 do
            local v116 = u111:read(u104);
            local v117 = nil;

            if v116 <= 15 then
                v115 = v116;
                v117 = 1;
            elseif v116 == 16 then
                local v118 = u104:read(2);
                v117 = 3 + assert(v118, "unexpected end of file");
            elseif v116 == 17 then
                local v119 = u104:read(3);
                v117 = 3 + assert(v119, "unexpected end of file");
                v115 = 0;
            elseif v116 == 18 then
                local v120 = u104:read(7);
                v117 = 11 + assert(v120, "unexpected end of file");
                v115 = 0;
            else
                error("ASSERT");
            end;

            for _ = 1, v117 do
                v114[v113] = v115;
                v113 = v113 + 1;
            end;
        end;

        return HuffmanTable(v114, true);
    end;

    return decode(v105 + 257), decode(v106 + 1);
end;

local u121 = nil;
local u122 = nil;
local u123 = nil;
local u124 = nil;

local function parse_compressed_item(p125, p126, p127, p128) -- Line: 636
    -- upvalues: u121 (ref), u122 (ref), u4 (copy), max (copy), u7 (ref), u123 (ref), u124 (ref)
    local v129 = p127:read(p125);

    if v129 < 256 then
        local window_pos = p126.window_pos;
        p126.outbs(v129);
        p126.window[window_pos] = v129;
        p126.window_pos = window_pos % 32768 + 1;
    else
        if v129 == 256 then
            return true;
        end;

        if not u121 then
            local v130 = {
                [257] = 3
            };
            local v131 = 1;

            for i = 258, 285, 4 do
                for i2 = i, i + 3 do
                    v130[i2] = v130[i2 - 1] + v131;
                end;

                if i ~= 258 then
                    v131 = v131 * 2;
                end;
            end;

            v130[285] = 258;
            u121 = v130;
        end;

        if not u122 then
            local v132 = {};

            if u4 then
                for i = 257, 285 do
                    v132[i] = u7(max(i - 261, 0), 2);
                end;
            else
                for i = 257, 285 do
                    local v133 = max(i - 261, 0);
                    v132[i] = (v133 - v133 % 4) / 4;
                end;
            end;

            v132[285] = 0;
            u122 = v132;
        end;

        local v134 = u121[v129] + p125:read(u122[v129]);

        if not u123 then
            local v135 = { 1 };
            local v136 = 1;

            for i = 1, 29, 2 do
                for i2 = i, i + 1 do
                    v135[i2] = v135[i2 - 1] + v136;
                end;

                if i ~= 1 then
                    v136 = v136 * 2;
                end;
            end;

            u123 = v135;
        end;

        if not u124 then
            local v137 = {};

            if u4 then
                for i = 0, 29 do
                    v137[i] = u7(max(i - 2, 0), 1);
                end;
            else
                for i = 0, 29 do
                    local v138 = max(i - 2, 0);
                    v137[i] = (v138 - v138 % 2) / 2;
                end;
            end;

            u124 = v137;
        end;

        local v139 = p128:read(p125);
        local v140 = u123[v139] + p125:read(u124[v139]);

        for _ = 1, v134 do
            local v141 = assert(p126.window[(p126.window_pos - 1 - v140) % 32768 + 1], "invalid distance");
            local window_pos = p126.window_pos;
            p126.outbs(v141);
            p126.window[window_pos] = v141;
            p126.window_pos = window_pos % 32768 + 1;
        end;
    end;

    return false;
end;

local function parse_block(p142, p143) -- Line: 726
    -- upvalues: parse_huffmantables (copy), HuffmanTable (copy), parse_compressed_item (copy)
    local v144 = p142:read(1);
    local v145 = p142:read(2);

    if v145 == 0 then
        p142:read(p142:nbits_left_in_byte());
        local v146 = p142:read(16);
        local v147 = p142:read(16);
        assert(v147, "unexpected end of file");

        for _ = 1, v146 do
            local v148 = p142:read(8);
            local v149 = assert(v148, "unexpected end of file");
            local window_pos = p143.window_pos;
            p143.outbs(v149);
            p143.window[window_pos] = v149;
            p143.window_pos = window_pos % 32768 + 1;
        end;
    elseif v145 == 1 or v145 == 2 then
        local v150, v151;

        if v145 == 2 then
            v150, v151 = parse_huffmantables(p142);
        else
            v150 = HuffmanTable({ 0, 8, 144, 9, 256, 7, 280, 8, 288, nil });
            v151 = HuffmanTable({ 0, 5, 32, nil });
        end;

        while not parse_compressed_item(p142, p143, v150, v151) do

        end;
    else
        error({ "unrecognized compression type" }, (nil or 1) + 1);
    end;

    return v144 ~= 0;
end;

function u1.inflate(p152) -- Line: 768
    -- upvalues: get_bitstream (copy), parse_block (copy)
    local v153 = get_bitstream(p152.input);
    local output2 = p152.output;
    local v154 = nil;

    if type(output2) == "function" then
        v154 = output2;
    else
        local v155 = { "unrecognized type: " .. tostring(output2) };
        error(v155, (nil or 1) + 1);
    end;

    local v156 = {
        outbs = v154,
        window = {},
        window_pos = 1
    };

    while not parse_block(v153, v156) do

    end;
end;

local inflate = u1.inflate;

function u1.gunzip(p157) -- Line: 779
    -- upvalues: get_bitstream (copy), parse_gzip_header (copy), inflate (copy), crc32 (copy)
    local v158 = get_bitstream(p157.input);
    local output2 = p157.output;
    local u159 = nil;

    if type(output2) == "function" then
        u159 = output2;
    else
        local v160 = { "unrecognized type: " .. tostring(output2) };
        error(v160, (nil or 1) + 1);
    end;

    local disable_crc = p157.disable_crc;

    if disable_crc == nil then
        disable_crc = false;
    end;

    parse_gzip_header(v158);
    local u161 = 0;
    inflate({
        input = v158,
        output = disable_crc and u159 and u159 or function(p162) -- Line: 793
            -- upvalues: u161 (ref), crc32 (ref), u159 (copy)
            u161 = crc32(p162, u161);
            u159(p162);
        end
    });
    v158:read(v158:nbits_left_in_byte());
    local v163 = v158:read(32);
    v158:read(32);

    if not disable_crc and (u161 and u161 ~= v163) then
        error({ "invalid compressed data--crc error" }, (nil or 1) + 1);
    end;

    if v158:read() then
        warn("trailing garbage ignored");
    end;
end;

function u1.adler32(p164, p165) -- Line: 817
    local v166 = p165 % 65536;
    local v167 = (v166 + p164) % 65521;

    return ((p165 - v166) / 65536 + v167) % 65521 * 65536 + v167;
end;

function u1.inflate_zlib(p168) -- Line: 825
    -- upvalues: get_bitstream (copy), parse_zlib_header (copy), inflate (copy), u1 (copy)
    local v169 = get_bitstream(p168.input);
    local output2 = p168.output;
    local u170 = nil;

    if type(output2) == "function" then
        u170 = output2;
    else
        local v171 = { "unrecognized type: " .. tostring(output2) };
        error(v171, (nil or 1) + 1);
    end;

    local disable_crc = p168.disable_crc;

    if disable_crc == nil then
        disable_crc = false;
    end;

    parse_zlib_header(v169);
    local u172 = 1;
    inflate({
        input = v169,
        output = disable_crc and u170 and u170 or function(p173) -- Line: 839
            -- upvalues: u172 (ref), u1 (ref), u170 (copy)
            u172 = u1.adler32(p173, u172);
            u170(p173);
        end
    });
    v169:read(v169:nbits_left_in_byte());
    local v174 = v169:read(8);
    local v175 = v169:read(8);
    local v176 = v169:read(8);
    local v177 = v169:read(8);

    if not disable_crc and u172 ~= ((v174 * 256 + v175) * 256 + v176) * 256 + v177 then
        error({ "invalid compressed data--crc error" }, (nil or 1) + 1);
    end;

    if v169:read() then
        warn("trailing garbage ignored");
    end;
end;

return u1;