-- Decompiled with Potassium's decompiler.

local u1 = {
    FONT_COLOR_RGB = {
        Start = "<font color=\"rgb(%s,%s,%s)\">",
        End = "</font>"
    },
    FONT_COLOR_HEX = {
        Start = "<font color=\"#%s\">",
        End = "</font>"
    },
    FONT_SIZE = {
        Start = "<font size=\"%d\">",
        End = "</font>"
    },
    FONT_FACE = {
        Start = "<font face=\"%s\">",
        End = "</font>"
    },
    FONT_FAMILY = {
        Start = "<font family=\"%s\">",
        End = "</font>"
    },
    FONT_WEIGHT = {
        Start = "<font weight=\"%s\">",
        End = "</font>"
    },
    FONT_TRANSPARENCY = {
        Start = "<font transparency=\"%s\">",
        End = "</font>"
    },
    STROKE = {
        Start = "<stroke color=\"#%s\" joins=\"%s\" thickness=\"%s\" transparency=\"%s\">",
        End = "</stroke>"
    },
    BOLD = {
        Start = "<b>",
        End = "</b>"
    },
    ITALIC = {
        Start = "<i>",
        End = "</i>"
    },
    UNDERLINE = {
        Start = "<u>",
        End = "</u>"
    },
    STRIKETHROUGH = {
        Start = "<s>",
        End = "</s>"
    },
    UPPERCASE = {
        Start = "<uppercase>",
        End = "</uppercase>"
    },
    SMALLCAPS = {
        Start = "<smallcaps>",
        End = "</smallcaps>"
    }
};
local u2 = {};
local u3 = {};
local u4 = {};
u4.__index = u4;

local function GenerateCustomHandlerFunction(u5) -- Line: 65
    -- upvalues: u1 (copy)
    return function(p6) -- Line: 66
        -- upvalues: u1 (ref), u5 (copy)
        local u7 = u1[u5].Start:format(p6);

        return function(p8) -- Line: 68
            -- upvalues: u7 (copy), u1 (ref), u5 (ref)
            return string.format("%s%s%s", u7, p8, u1[u5].End);
        end;
    end;
end;

local function GenerateDirectFunction(u9) -- Line: 74
    -- upvalues: u1 (copy)
    return function(p10) -- Line: 75
        -- upvalues: u1 (ref), u9 (copy)
        local v11 = u1[u9];

        return string.format("%s%s%s", v11.Start, p10, v11.End);
    end;
end;

local function GenerateColorFunction(u12) -- Line: 81
    -- upvalues: u1 (copy)
    return function(p13) -- Line: 82
        -- upvalues: u12 (copy), u1 (ref)
        local v14 = math.floor(u12.R * 255);
        local v15 = math.floor(u12.G * 255);
        local v16 = math.floor(u12.B * 255);

        return string.format("%s%s%s", u1.FONT_COLOR_RGB.Start:format(v14, v15, v16), p13, u1.FONT_COLOR_RGB.End);
    end;
end;

local function ValidateHex(p17) -- Line: 95
    if typeof(p17) ~= "string" then
        return false;
    end;

    local v18 = p17:gsub("#", "");

    return string.match(v18, "^%x%x%x%x%x%x$") ~= nil;
end;

local u19 = "FONT_SIZE";

function u3.size(p20) -- Line: 66
    -- upvalues: u1 (copy), u19 (copy)
    local u21 = u1[u19].Start:format(p20);

    return function(p22) -- Line: 68
        -- upvalues: u21 (copy), u1 (ref), u19 (ref)
        return string.format("%s%s%s", u21, p22, u1[u19].End);
    end;
end;

local u23 = "FONT_FACE";

function u3.face(p24) -- Line: 66
    -- upvalues: u1 (copy), u23 (copy)
    local u25 = u1[u23].Start:format(p24);

    return function(p26) -- Line: 68
        -- upvalues: u25 (copy), u1 (ref), u23 (ref)
        return string.format("%s%s%s", u25, p26, u1[u23].End);
    end;
end;

local u27 = "FONT_FAMILY";

function u3.family(p28) -- Line: 66
    -- upvalues: u1 (copy), u27 (copy)
    local u29 = u1[u27].Start:format(p28);

    return function(p30) -- Line: 68
        -- upvalues: u29 (copy), u1 (ref), u27 (ref)
        return string.format("%s%s%s", u29, p30, u1[u27].End);
    end;
end;

local u31 = "FONT_WEIGHT";

function u3.weight(p32) -- Line: 66
    -- upvalues: u1 (copy), u31 (copy)
    local u33 = u1[u31].Start:format(p32);

    return function(p34) -- Line: 68
        -- upvalues: u33 (copy), u1 (ref), u31 (ref)
        return string.format("%s%s%s", u33, p34, u1[u31].End);
    end;
end;

local u35 = "FONT_TRANSPARENCY";

function u3.transparency(p36) -- Line: 66
    -- upvalues: u1 (copy), u35 (copy)
    local u37 = u1[u35].Start:format(p36);

    return function(p38) -- Line: 68
        -- upvalues: u37 (copy), u1 (ref), u35 (ref)
        return string.format("%s%s%s", u37, p38, u1[u35].End);
    end;
end;

function u3.stroke(p39) -- Line: 109
    -- upvalues: u1 (copy)
    local v40 = string.format("#%s", p39.Color:ToHex());
    local u41 = u1.STROKE.Start:format(v40, p39.Joins or "Round", p39.Thickness or 1, p39.Transparency or 0);

    return function(p42) -- Line: 115
        -- upvalues: u41 (copy), u1 (ref)
        return string.format("%s%s%s", u41, p42, u1.STROKE.End);
    end;
end;

function u3.color(...) -- Line: 120
    -- upvalues: u1 (copy)
    local v43 = { ... };
    local v44 = v43[1];
    local v45;

    if typeof(v44) == "string" then
        local v46 = v44:gsub("#", "");
        v45 = string.match(v46, "^%x%x%x%x%x%x$") ~= nil;
    else
        v45 = false;
    end;

    local v47;

    if typeof(v44) == "Color3" then
        v47 = v44;
    else
        v47 = Color3.fromRGB(v44, v43[2], v43[3]);
    end;

    local u48;

    if v45 then
        u48 = u1.FONT_COLOR_HEX.Start:format(v44:gsub("#", ""));
    else
        local v49 = math.floor(v47.R * 255);
        local v50 = math.floor(v47.G * 255);
        local v51 = math.floor(v47.B * 255);
        u48 = u1.FONT_COLOR_RGB.Start:format(v49, v50, v51);
    end;

    return function(p52) -- Line: 143
        -- upvalues: u48 (ref), u1 (ref)
        return string.format("%s%s%s", u48, p52, u1.FONT_COLOR_RGB.End);
    end;
end;

local u53 = "BOLD";

function u2.bold(p54) -- Line: 75
    -- upvalues: u1 (copy), u53 (copy)
    local v55 = u1[u53];

    return string.format("%s%s%s", v55.Start, p54, v55.End);
end;

local u56 = "ITALIC";

function u2.italic(p57) -- Line: 75
    -- upvalues: u1 (copy), u56 (copy)
    local v58 = u1[u56];

    return string.format("%s%s%s", v58.Start, p57, v58.End);
end;

local u59 = "UNDERLINE";

function u2.underline(p60) -- Line: 75
    -- upvalues: u1 (copy), u59 (copy)
    local v61 = u1[u59];

    return string.format("%s%s%s", v61.Start, p60, v61.End);
end;

local u62 = "STRIKETHROUGH";

function u2.strikethrough(p63) -- Line: 75
    -- upvalues: u1 (copy), u62 (copy)
    local v64 = u1[u62];

    return string.format("%s%s%s", v64.Start, p63, v64.End);
end;

local u65 = "UPPERCASE";

function u2.uppercase(p66) -- Line: 75
    -- upvalues: u1 (copy), u65 (copy)
    local v67 = u1[u65];

    return string.format("%s%s%s", v67.Start, p66, v67.End);
end;

local u68 = "SMALLCAPS";

function u2.smallcaps(p69) -- Line: 75
    -- upvalues: u1 (copy), u68 (copy)
    local v70 = u1[u68];

    return string.format("%s%s%s", v70.Start, p69, v70.End);
end;

local u71 = Color3.fromRGB(255, 255, 255);

function u2.white(p72) -- Line: 82
    -- upvalues: u71 (copy), u1 (copy)
    local v73 = math.floor(u71.R * 255);
    local v74 = math.floor(u71.G * 255);
    local v75 = math.floor(u71.B * 255);

    return string.format("%s%s%s", u1.FONT_COLOR_RGB.Start:format(v73, v74, v75), p72, u1.FONT_COLOR_RGB.End);
end;

local u76 = Color3.fromRGB(0, 0, 0);

function u2.black(p77) -- Line: 82
    -- upvalues: u76 (copy), u1 (copy)
    local v78 = math.floor(u76.R * 255);
    local v79 = math.floor(u76.G * 255);
    local v80 = math.floor(u76.B * 255);

    return string.format("%s%s%s", u1.FONT_COLOR_RGB.Start:format(v78, v79, v80), p77, u1.FONT_COLOR_RGB.End);
end;

local u81 = Color3.fromRGB(255, 0, 0);

function u2.red(p82) -- Line: 82
    -- upvalues: u81 (copy), u1 (copy)
    local v83 = math.floor(u81.R * 255);
    local v84 = math.floor(u81.G * 255);
    local v85 = math.floor(u81.B * 255);

    return string.format("%s%s%s", u1.FONT_COLOR_RGB.Start:format(v83, v84, v85), p82, u1.FONT_COLOR_RGB.End);
end;

local u86 = Color3.fromRGB(153, 51, 0);

function u2.brown(p87) -- Line: 82
    -- upvalues: u86 (copy), u1 (copy)
    local v88 = math.floor(u86.R * 255);
    local v89 = math.floor(u86.G * 255);
    local v90 = math.floor(u86.B * 255);

    return string.format("%s%s%s", u1.FONT_COLOR_RGB.Start:format(v88, v89, v90), p87, u1.FONT_COLOR_RGB.End);
end;

local u91 = Color3.fromRGB(255, 153, 0);

function u2.orange(p92) -- Line: 82
    -- upvalues: u91 (copy), u1 (copy)
    local v93 = math.floor(u91.R * 255);
    local v94 = math.floor(u91.G * 255);
    local v95 = math.floor(u91.B * 255);

    return string.format("%s%s%s", u1.FONT_COLOR_RGB.Start:format(v93, v94, v95), p92, u1.FONT_COLOR_RGB.End);
end;

local u96 = Color3.fromRGB(255, 255, 0);

function u2.yellow(p97) -- Line: 82
    -- upvalues: u96 (copy), u1 (copy)
    local v98 = math.floor(u96.R * 255);
    local v99 = math.floor(u96.G * 255);
    local v100 = math.floor(u96.B * 255);

    return string.format("%s%s%s", u1.FONT_COLOR_RGB.Start:format(v98, v99, v100), p97, u1.FONT_COLOR_RGB.End);
end;

local u101 = Color3.fromRGB(153, 255, 0);

function u2.lime(p102) -- Line: 82
    -- upvalues: u101 (copy), u1 (copy)
    local v103 = math.floor(u101.R * 255);
    local v104 = math.floor(u101.G * 255);
    local v105 = math.floor(u101.B * 255);

    return string.format("%s%s%s", u1.FONT_COLOR_RGB.Start:format(v103, v104, v105), p102, u1.FONT_COLOR_RGB.End);
end;

local u106 = Color3.fromRGB(0, 255, 0);

function u2.green(p107) -- Line: 82
    -- upvalues: u106 (copy), u1 (copy)
    local v108 = math.floor(u106.R * 255);
    local v109 = math.floor(u106.G * 255);
    local v110 = math.floor(u106.B * 255);

    return string.format("%s%s%s", u1.FONT_COLOR_RGB.Start:format(v108, v109, v110), p107, u1.FONT_COLOR_RGB.End);
end;

local u111 = Color3.fromRGB(0, 0, 255);

function u2.blue(p112) -- Line: 82
    -- upvalues: u111 (copy), u1 (copy)
    local v113 = math.floor(u111.R * 255);
    local v114 = math.floor(u111.G * 255);
    local v115 = math.floor(u111.B * 255);

    return string.format("%s%s%s", u1.FONT_COLOR_RGB.Start:format(v113, v114, v115), p112, u1.FONT_COLOR_RGB.End);
end;

local u116 = Color3.fromRGB(102, 0, 153);

function u2.purple(p117) -- Line: 82
    -- upvalues: u116 (copy), u1 (copy)
    local v118 = math.floor(u116.R * 255);
    local v119 = math.floor(u116.G * 255);
    local v120 = math.floor(u116.B * 255);

    return string.format("%s%s%s", u1.FONT_COLOR_RGB.Start:format(v118, v119, v120), p117, u1.FONT_COLOR_RGB.End);
end;

local u121 = Color3.fromRGB(255, 0, 255);

function u2.pink(p122) -- Line: 82
    -- upvalues: u121 (copy), u1 (copy)
    local v123 = math.floor(u121.R * 255);
    local v124 = math.floor(u121.G * 255);
    local v125 = math.floor(u121.B * 255);

    return string.format("%s%s%s", u1.FONT_COLOR_RGB.Start:format(v123, v124, v125), p122, u1.FONT_COLOR_RGB.End);
end;

function u4.new(p126) -- Line: 167
    -- upvalues: u3 (copy), u2 (copy)
    local v127 = {};
    local v128 = {};
    local u129 = {};
    v127.Formatters = u129;
    local u130 = nil;
    local u131 = nil;

    function v128.__call(p132, ...) -- Line: 177
        -- upvalues: u130 (ref), u129 (copy)
        local v133 = { ... };

        if u130 then
            local v134 = u130;
            u130 = nil;

            return v134(unpack(v133));
        end;

        local v135 = {};

        for _, v in ipairs(v133) do
            for _, v2 in ipairs(u129) do
                local v = v2(v);
            end;

            table.insert(v135, v);
        end;

        return unpack(v135);
    end;

    function v128.__index(p136, p137) -- Line: 196
        -- upvalues: u3 (ref), u130 (ref), u129 (copy), u131 (ref), u2 (ref)
        local u138 = u3[p137];

        if u138 then
            u130 = function(...) -- Line: 199
                -- upvalues: u138 (copy), u129 (ref), u131 (ref)
                local v139 = u138(...);
                table.insert(u129, v139);

                return u131;
            end;

            return u131;
        end;

        local v140 = u2[p137];

        if v140 then
            table.insert(u129, v140);

            return p136;
        end;
    end;

    if p126 then
        v128.__index(v127, p126);
    end;

    u131 = setmetatable(v127, v128);

    return u131;
end;

return setmetatable({}, {
    __index = function(p141, p142) -- Line: 223, Name: __index
        -- upvalues: u4 (copy)
        return u4.new(p142);
    end,

    __newindex = function() -- Line: 226, Name: __newindex
        error("Chalk is READONLY");
    end
});