-- Decompiled with Potassium's decompiler.

local Language = require(script.Parent.Language);
local u1 = {};
local u2 = {
    ["zh-tw"] = "zh-cn"
};
local u3 = "en-us";
local u4 = {};
local key = Language.key;

local function _replacePlaceholders(p5, p6) -- Line: 73
    -- upvalues: u1 (copy)
    for i, v in pairs(p6) do
        if typeof(v) == "table" then
            local v7 = u1.FormatByKey(v[1]);
            p5 = string.gsub(p5, "{" .. i .. "}", v7);
        else
            p5 = string.gsub(p5, "{" .. i .. "}", (tostring(v)));
        end;
    end;

    return p5;
end;

function u1.GetLocaleId() -- Line: 95
    -- upvalues: u3 (ref)
    return u3;
end;

function u1.SetLocaleId(p8) -- Line: 104
    -- upvalues: u3 (ref)
    if typeof(p8) ~= "string" or p8 == "" then
        return;
    end;

    u3 = p8;
end;

function u1.FormatByKey(p9, p10) -- Line: 119
    -- upvalues: u4 (ref), u3 (ref), _replacePlaceholders (copy), u2 (copy)
    local v11 = u4[p9];

    if not v11 then
        return "未本地化-" .. p9, true;
    end;

    if v11[u3] then
        if p10 then
            return _replacePlaceholders(v11[u3], p10), false;
        end;

        return v11[u3], false;
    end;

    local v12 = u2[u3];

    if v12 and v11[v12] then
        if p10 then
            return _replacePlaceholders(v11[v12], p10), false;
        end;

        return v11[v12], false;
    end;

    if p10 then
        return _replacePlaceholders(v11["en-us"], p10), true;
    end;

    return v11["en-us"], true;
end;

u4 = (function() -- Line: 46, Name: _buildCfg
    -- upvalues: Language (copy), key (copy)
    local v13 = {};

    for i, v in pairs(Language) do
        if i ~= "key" then
            local v14 = key[i];

            for i2, v2 in pairs(v) do
                local v15 = {};

                for i3, v3 in pairs(v2) do
                    v15[tostring(v14[i3])] = v3;
                end;

                v13[i2] = v15;
            end;
        end;
    end;

    return v13;
end)();
Language.key = nil;
Language.localizationtableConf = nil;

return u1;