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
u3.__index = u3;

local function GenerateCustomHandlerFunction(u4) -- Line: 92
    -- upvalues: u1 (copy)
    return function(p5) -- Line: 93
        -- upvalues: u1 (ref), u4 (copy)
        local u6 = u1[u4].Start:format(p5);

        return function(p7) -- Line: 96
            -- upvalues: u6 (copy), u1 (ref), u4 (ref)
            return `{u6}{p7}{u1[u4].End}`;
        end;
    end;
end;

local function GenerateChalkDataFunction(u8) -- Line: 102
    -- upvalues: u1 (copy)
    return function(p9) -- Line: 103
        -- upvalues: u1 (ref), u8 (copy)
        local v10 = u1[u8];

        return `{v10.Start}{p9}{v10.End}`;
    end;
end;

local function GenerateColorFunction(u11) -- Line: 109
    -- upvalues: u1 (copy)
    return function(p12) -- Line: 110
        -- upvalues: u11 (copy), u1 (ref)
        local v13 = math.floor(u11.r * 255);
        local v14 = math.floor(u11.g * 255);
        local v15 = math.floor(u11.b * 255);

        return `{u1.FONT_COLOR_RGB.Start:format(v13, v14, v15)}{p12}{u1.FONT_COLOR_RGB.End}`;
    end;
end;

local function ValidateHex(p16) -- Line: 121
    if typeof(p16) == "string" then
        local v17 = p16:gsub("#", "");

        return string.match(v17, "^%x%x%x%x%x%x$");
    end;
end;

local u18 = {};
local u19 = "FONT_SIZE";

function u18.size(p20) -- Line: 93
    -- upvalues: u1 (copy), u19 (copy)
    local u21 = u1[u19].Start:format(p20);

    return function(p22) -- Line: 96
        -- upvalues: u21 (copy), u1 (ref), u19 (ref)
        return `{u21}{p22}{u1[u19].End}`;
    end;
end;

local u23 = "FONT_FACE";

function u18.face(p24) -- Line: 93
    -- upvalues: u1 (copy), u23 (copy)
    local u25 = u1[u23].Start:format(p24);

    return function(p26) -- Line: 96
        -- upvalues: u25 (copy), u1 (ref), u23 (ref)
        return `{u25}{p26}{u1[u23].End}`;
    end;
end;

local u27 = "FONT_FAMILY";

function u18.family(p28) -- Line: 93
    -- upvalues: u1 (copy), u27 (copy)
    local u29 = u1[u27].Start:format(p28);

    return function(p30) -- Line: 96
        -- upvalues: u29 (copy), u1 (ref), u27 (ref)
        return `{u29}{p30}{u1[u27].End}`;
    end;
end;

local u31 = "FONT_WEIGHT";

function u18.weight(p32) -- Line: 93
    -- upvalues: u1 (copy), u31 (copy)
    local u33 = u1[u31].Start:format(p32);

    return function(p34) -- Line: 96
        -- upvalues: u33 (copy), u1 (ref), u31 (ref)
        return `{u33}{p34}{u1[u31].End}`;
    end;
end;

local u35 = "FONT_TRANSPARENCY";

function u18.transparency(p36) -- Line: 93
    -- upvalues: u1 (copy), u35 (copy)
    local u37 = u1[u35].Start:format(p36);

    return function(p38) -- Line: 96
        -- upvalues: u37 (copy), u1 (ref), u35 (ref)
        return `{u37}{p38}{u1[u35].End}`;
    end;
end;

function u18.stroke(p39) -- Line: 135
    -- upvalues: u1 (copy)
    local v40 = `#{p39.Color:ToHex()}`;
    local u41 = u1.STROKE.Start:format(v40, p39.Joins or "Round", p39.Thickness or 1, p39.Transparency or 0);

    return function(p42) -- Line: 145
        -- upvalues: u41 (copy), u1 (ref)
        return `{u41}{p42}{u1.STROKE.End}`;
    end;
end;

function u18.color(...) -- Line: 149
    -- upvalues: u1 (copy)
    local v43 = { ... };
    local v44 = v43[1];
    local v45;

    if typeof(v44) == "string" then
        local v46 = v44:gsub("#", "");
        v45 = string.match(v46, "^%x%x%x%x%x%x$");
    else
        v45 = nil;
    end;

    local v47 = typeof(v43[1]) == "Color3";
    local v48 = v43[1];
    local v49 = v47 and v48 and v48 or Color3.fromRGB(v48, v43[2], v43[3]);
    local u50 = v45 and u1.FONT_COLOR_HEX.Start:format(v48:gsub("#", "")) or u1.FONT_COLOR_RGB.Start:format(math.floor(v49.R * 255), math.floor(v49.G * 255), (math.floor(v49.B * 255)));

    return function(p51) -- Line: 163
        -- upvalues: u50 (copy), u1 (ref)
        return `{u50}{p51}{u1.FONT_COLOR_RGB.End}`;
    end;
end;

local u52 = "BOLD";

function u2.bold(p53) -- Line: 103
    -- upvalues: u1 (copy), u52 (copy)
    local v54 = u1[u52];

    return `{v54.Start}{p53}{v54.End}`;
end;

local u55 = "ITALIC";

function u2.italic(p56) -- Line: 103
    -- upvalues: u1 (copy), u55 (copy)
    local v57 = u1[u55];

    return `{v57.Start}{p56}{v57.End}`;
end;

local u58 = "UNDERLINE";

function u2.underline(p59) -- Line: 103
    -- upvalues: u1 (copy), u58 (copy)
    local v60 = u1[u58];

    return `{v60.Start}{p59}{v60.End}`;
end;

local u61 = "STRIKETHROUGH";

function u2.strikethrough(p62) -- Line: 103
    -- upvalues: u1 (copy), u61 (copy)
    local v63 = u1[u61];

    return `{v63.Start}{p62}{v63.End}`;
end;

local u64 = "UPPERCASE";

function u2.uppercase(p65) -- Line: 103
    -- upvalues: u1 (copy), u64 (copy)
    local v66 = u1[u64];

    return `{v66.Start}{p65}{v66.End}`;
end;

local u67 = "SMALLCAPS";

function u2.smallcaps(p68) -- Line: 103
    -- upvalues: u1 (copy), u67 (copy)
    local v69 = u1[u67];

    return `{v69.Start}{p68}{v69.End}`;
end;

local u70 = Color3.fromRGB(255, 255, 255);

function u2.white(p71) -- Line: 110
    -- upvalues: u70 (copy), u1 (copy)
    local v72 = math.floor(u70.r * 255);
    local v73 = math.floor(u70.g * 255);
    local v74 = math.floor(u70.b * 255);

    return `{u1.FONT_COLOR_RGB.Start:format(v72, v73, v74)}{p71}{u1.FONT_COLOR_RGB.End}`;
end;

local u75 = Color3.fromRGB(0, 0, 0);

function u2.black(p76) -- Line: 110
    -- upvalues: u75 (copy), u1 (copy)
    local v77 = math.floor(u75.r * 255);
    local v78 = math.floor(u75.g * 255);
    local v79 = math.floor(u75.b * 255);

    return `{u1.FONT_COLOR_RGB.Start:format(v77, v78, v79)}{p76}{u1.FONT_COLOR_RGB.End}`;
end;

local u80 = Color3.fromRGB(255, 0, 0);

function u2.red(p81) -- Line: 110
    -- upvalues: u80 (copy), u1 (copy)
    local v82 = math.floor(u80.r * 255);
    local v83 = math.floor(u80.g * 255);
    local v84 = math.floor(u80.b * 255);

    return `{u1.FONT_COLOR_RGB.Start:format(v82, v83, v84)}{p81}{u1.FONT_COLOR_RGB.End}`;
end;

local u85 = Color3.fromRGB(153, 51, 0);

function u2.brown(p86) -- Line: 110
    -- upvalues: u85 (copy), u1 (copy)
    local v87 = math.floor(u85.r * 255);
    local v88 = math.floor(u85.g * 255);
    local v89 = math.floor(u85.b * 255);

    return `{u1.FONT_COLOR_RGB.Start:format(v87, v88, v89)}{p86}{u1.FONT_COLOR_RGB.End}`;
end;

local u90 = Color3.fromRGB(255, 153, 0);

function u2.orange(p91) -- Line: 110
    -- upvalues: u90 (copy), u1 (copy)
    local v92 = math.floor(u90.r * 255);
    local v93 = math.floor(u90.g * 255);
    local v94 = math.floor(u90.b * 255);

    return `{u1.FONT_COLOR_RGB.Start:format(v92, v93, v94)}{p91}{u1.FONT_COLOR_RGB.End}`;
end;

local u95 = Color3.fromRGB(255, 255, 0);

function u2.yellow(p96) -- Line: 110
    -- upvalues: u95 (copy), u1 (copy)
    local v97 = math.floor(u95.r * 255);
    local v98 = math.floor(u95.g * 255);
    local v99 = math.floor(u95.b * 255);

    return `{u1.FONT_COLOR_RGB.Start:format(v97, v98, v99)}{p96}{u1.FONT_COLOR_RGB.End}`;
end;

local u100 = Color3.fromRGB(153, 255, 0);

function u2.lime(p101) -- Line: 110
    -- upvalues: u100 (copy), u1 (copy)
    local v102 = math.floor(u100.r * 255);
    local v103 = math.floor(u100.g * 255);
    local v104 = math.floor(u100.b * 255);

    return `{u1.FONT_COLOR_RGB.Start:format(v102, v103, v104)}{p101}{u1.FONT_COLOR_RGB.End}`;
end;

local u105 = Color3.fromRGB(0, 255, 0);

function u2.green(p106) -- Line: 110
    -- upvalues: u105 (copy), u1 (copy)
    local v107 = math.floor(u105.r * 255);
    local v108 = math.floor(u105.g * 255);
    local v109 = math.floor(u105.b * 255);

    return `{u1.FONT_COLOR_RGB.Start:format(v107, v108, v109)}{p106}{u1.FONT_COLOR_RGB.End}`;
end;

local u110 = Color3.fromRGB(0, 0, 255);

function u2.blue(p111) -- Line: 110
    -- upvalues: u110 (copy), u1 (copy)
    local v112 = math.floor(u110.r * 255);
    local v113 = math.floor(u110.g * 255);
    local v114 = math.floor(u110.b * 255);

    return `{u1.FONT_COLOR_RGB.Start:format(v112, v113, v114)}{p111}{u1.FONT_COLOR_RGB.End}`;
end;

local u115 = Color3.fromRGB(102, 0, 153);

function u2.purple(p116) -- Line: 110
    -- upvalues: u115 (copy), u1 (copy)
    local v117 = math.floor(u115.r * 255);
    local v118 = math.floor(u115.g * 255);
    local v119 = math.floor(u115.b * 255);

    return `{u1.FONT_COLOR_RGB.Start:format(v117, v118, v119)}{p116}{u1.FONT_COLOR_RGB.End}`;
end;

local u120 = Color3.fromRGB(255, 0, 255);

function u2.pink(p121) -- Line: 110
    -- upvalues: u120 (copy), u1 (copy)
    local v122 = math.floor(u120.r * 255);
    local v123 = math.floor(u120.g * 255);
    local v124 = math.floor(u120.b * 255);

    return `{u1.FONT_COLOR_RGB.Start:format(v122, v123, v124)}{p121}{u1.FONT_COLOR_RGB.End}`;
end;

function u3.new(p125) -- Line: 188
    -- upvalues: u18 (copy), u2 (copy)
    local v126 = {};
    local v127 = {};
    local u128 = {};
    v126.Formatters = u128;
    local u129 = nil;
    local u130 = nil;

    function v127.__call(p131, ...) -- Line: 196
        -- upvalues: u129 (ref), u128 (copy)
        local v132 = { ... };

        if u129 then
            local v133 = u129;
            u129 = nil;

            return v133(unpack(v132));
        end;

        local v134 = {};

        for _, v in v132 do
            for _, v2 in u128 do
                local v = v2(v);
            end;

            table.insert(v134, v);
        end;

        return unpack(v134);
    end;

    function v127.__index(p135, p136) -- Line: 220
        -- upvalues: u18 (ref), u129 (ref), u128 (copy), u130 (ref), u2 (ref)
        local u137 = u18[p136];

        if u137 then
            u129 = function(...) -- Line: 224
                -- upvalues: u137 (copy), u128 (ref), u130 (ref)
                local v138 = u137(...);
                table.insert(u128, v138);

                return u130;
            end;

            return u130;
        end;

        table.insert(u128, u2[p136]);

        return p135;
    end;

    v127:__index(p125);
    u130 = setmetatable(v126, v127);

    return u130;
end;

return setmetatable({}, {
    __index = function(p139, p140) -- Line: 249, Name: __index
        -- upvalues: u3 (copy)
        return u3.new(p140);
    end,

    __newindex = function() -- Line: 252, Name: __newindex
        return error("Chalk is READONLY");
    end
});