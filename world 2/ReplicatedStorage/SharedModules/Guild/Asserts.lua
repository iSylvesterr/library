-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
require(script.Parent.Types);
local IconPool = require(script.Parent.IconPool);
local v1 = {};
local u2 = {
    Owner = true,
    Elder = true,
    Member = true
};
local DEFAULT_ICON_ID = IconPool.DEFAULT_ICON_ID;

function v1.AssertGuildId(p3) -- Line: 60
    -- upvalues: Asserts (copy)
    if typeof(p3) ~= "string" or p3 == "" then
        error("AssertGuildId: expected non-empty string", 2);
    end;

    if not Asserts.IsASCII(p3) then
        error("AssertGuildId: must be ASCII", 2);
    end;

    if #p3 > 64 then
        error("AssertGuildId: too long", 2);
    end;

    return p3;
end;

function v1.AssertName(p4) -- Line: 73
    -- upvalues: Asserts (copy)
    if typeof(p4) ~= "string" then
        error("AssertName: expected string", 2);
    end;

    if #p4 < 3 or #p4 > 24 then
        error(`AssertName: must be {3}-{24} characters`, 2);
    end;

    if not Asserts.IsASCII(p4) then
        error("AssertName: must be ASCII", 2);
    end;

    if not string.match(p4, "^[A-Za-z0-9 _%-\']+$") then
        error("AssertName: only letters, digits, spaces, dashes, apostrophes, underscores", 2);
    end;

    return p4;
end;

function v1.AssertTag(p5) -- Line: 89
    if typeof(p5) ~= "string" then
        error("AssertTag: expected string", 2);
    end;

    if #p5 < 2 or #p5 > 5 then
        error(`AssertTag: must be {2}-{5} characters`, 2);
    end;

    if not string.match(p5, "^[A-Z0-9]+$") then
        error("AssertTag: must be uppercase letters / digits", 2);
    end;

    return p5;
end;

function v1.AssertDescription(p6) -- Line: 106
    -- upvalues: Asserts (copy)
    if typeof(p6) ~= "string" then
        error("AssertDescription: expected string", 2);
    end;

    local v7 = utf8.len(p6);

    if not v7 then
        error("AssertDescription: invalid UTF-8", 2);
    end;

    if v7 > 200 then
        error(`AssertDescription: must be <= {200} characters`, 2);
    end;

    if not Asserts.IsASCII(p6) then
        error("AssertDescription: must be ASCII", 2);
    end;

    return p6;
end;

function v1.AssertGuildRole(p8) -- Line: 127
    -- upvalues: u2 (copy)
    if typeof(p8) ~= "string" or not u2[p8] then
        error("AssertGuildRole: must be \'Owner\' | \'Elder\' | \'Member\'", 2);
    end;

    return p8;
end;

function v1.AssertSlotCount(p9) -- Line: 134
    if typeof(p9) ~= "number" or p9 ~= math.floor(p9) then
        error("AssertSlotCount: must be an integer", 2);
    end;

    if p9 < 20 or p9 > 50 then
        error(`AssertSlotCount: must be in [{20}, {50}]`, 2);
    end;

    return p9;
end;

function v1.AssertUserId(p10) -- Line: 144
    if typeof(p10) ~= "number" or (p10 ~= math.floor(p10) or p10 <= 0) then
        error("AssertUserId: must be a positive integer", 2);
    end;

    return p10;
end;

function v1.AssertHexColor(p11) -- Line: 151
    if typeof(p11) ~= "string" then
        error("AssertHexColor: expected string", 2);
    end;

    if not string.match(p11, "^#[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f]$") then
        error("AssertHexColor: must be #RRGGBB", 2);
    end;

    return string.upper(p11);
end;

function v1.AssertIconId(p12) -- Line: 164
    if typeof(p12) ~= "number" or (p12 ~= math.floor(p12) or p12 <= 0) then
        error("AssertIconId: must be a positive integer", 2);
    end;

    return p12;
end;

function v1.IsPoolIcon(p13) -- Line: 173
    -- upvalues: IconPool (copy)
    return IconPool.IsPoolIcon(p13);
end;

function v1.IconAssetString(p14) -- Line: 179
    -- upvalues: DEFAULT_ICON_ID (copy)
    local v15 = DEFAULT_ICON_ID;

    if typeof(p14) == "number" and p14 == p14 then
        if p14 <= 0 then
            p14 = v15;
        end;
    else
        p14 = v15;
    end;

    return `rbxassetid://{math.round(p14)}`;
end;

v1.MIN_NAME_LENGTH = 3;
v1.MAX_NAME_LENGTH = 24;
v1.MIN_TAG_LENGTH = 2;
v1.MAX_TAG_LENGTH = 5;
v1.MAX_DESCRIPTION_LENGTH = 200;
v1.MIN_SLOTS = 20;
v1.MAX_SLOTS = 50;
v1.MAX_ELDERS = 5;
v1.GUILD_ROLES = u2;
v1.DEFAULT_COLOR = "#6EE7A7";
v1.PRESET_COLORS = { "#6EE7A7", "#FBBF24", "#FB7185", "#A78BFA", "#60A5FA", "#34D399", "#F87171", "#FB923C", "#FACC15", "#22D3EE", "#F472B6", "#94A3B8" };
v1.GetIconPool = IconPool.GetPool;
v1.RandomIcon = IconPool.Random;
v1.DEFAULT_ICON_ID = DEFAULT_ICON_ID;

return table.freeze(v1);