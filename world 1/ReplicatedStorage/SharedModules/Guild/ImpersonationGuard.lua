-- Decompiled with Potassium's decompiler.

local v1 = {};
local u2 = {
    ["0"] = "o",
    ["1"] = "i",
    ["2"] = "z",
    ["3"] = "e",
    ["4"] = "a",
    ["5"] = "s",
    ["6"] = "g",
    ["7"] = "t",
    ["8"] = "b",
    ["9"] = "g",
    ["@"] = "a",
    ["$"] = "s",
    ["!"] = "i",
    ["|"] = "i",
    ["+"] = "t",
    ["("] = "c"
};
local u3 = { "staff", "developer", "moderator", "moderation", "administrator", "administration", "official", "support", "gamemaster", "roblox", "robloxstaff", "verified", "security", "helpers", "eldoradogg" };
local u4 = {
    dev = true,
    devs = true,
    mod = true,
    mods = true,
    admin = true,
    admins = true,
    owner = true,
    owners = true,
    coowner = true,
    gm = true,
    helper = true,
    system = true,
    server = true,
    guard = true,
    guards = true,
    team = true,
    bot = true,
    staffteam = true
};

local function normalize(p5) -- Line: 85
    -- upvalues: u2 (copy)
    local v6 = string.lower(p5);
    local v7 = string.gsub(v6, "[0-9@$!|+(]", u2);

    return string.gsub(v7, "[^a-z]", "");
end;

function v1.IsImpersonation(p8) -- Line: 92
    -- upvalues: u2 (copy), u3 (copy), u4 (copy)
    if typeof(p8) ~= "string" then
        return false;
    end;

    local v9 = string.lower(p8);
    local v10 = string.gsub(v9, "[0-9@$!|+(]", u2);
    local v11 = string.gsub(v10, "[^a-z]", "");

    if v11 == "" then
        return false;
    end;

    for _, v in u3 do
        if string.find(v11, v, 1, true) then
            return true;
        end;
    end;

    if u4[v11] then
        return true;
    end;

    for i in string.gmatch(p8, "[^%s_%-\']+") do
        local v12 = string.lower(i);
        local v13 = string.gsub(v12, "[0-9@$!|+(]", u2);
        local v14 = string.gsub(v13, "[^a-z]", "");

        if v14 ~= "" and u4[v14] then
            return true;
        end;
    end;

    return false;
end;

return table.freeze(v1);