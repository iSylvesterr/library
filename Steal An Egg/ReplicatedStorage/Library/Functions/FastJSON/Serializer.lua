-- Decompiled with Potassium's decompiler.

local v1 = {};
local u2 = {
    ["\""] = "\\\"",
    ["\\"] = "\\\\",
    ["\8"] = "\\b",
    ["\f"] = "\\f",
    ["\n"] = "\\n",
    ["\r"] = "\\r",
    ["\t"] = "\\t"
};
setmetatable(u2, {
    __index = function(p3, p4) -- Line: 14, Name: __index
        return string.format("\\u00%02X", p4:byte());
    end
});

local function escapeString(p5) -- Line: 19
    -- upvalues: u2 (copy)
    if p5:find("[\0-\31\"\\]") then
        p5 = p5:gsub("[\0-\31\"\\]", u2);
    end;

    return p5;
end;

local u6 = {};

function v1.new() -- Line: 28
    -- upvalues: u6 (copy)
    return setmetatable({
        fragments = {}
    }, {
        __index = u6
    });
end;

local function kindOf(p7) -- Line: 32
    if type(p7) ~= "table" then
        return type(p7);
    end;

    local v8 = 1;

    for _ in pairs(p7) do
        if p7[v8] == nil then
            return "table";
        end;

        v8 = v8 + 1;
    end;

    return v8 == 1 and "table" or "array";
end;

function u6.WriteKey(p9, p10) -- Line: 46
    -- upvalues: kindOf (copy), u2 (copy)
    local v11 = kindOf(p10);

    if v11 == "array" then
        error("Can\'t encode array as key.");

        return p9;
    end;

    if v11 == "table" then
        error("Can\'t encode table as key.");

        return p9;
    end;

    if v11 == "string" then
        local format = string.format;

        if p10:find("[\0-\31\"\\]") then
            p10 = p10:gsub("[\0-\31\"\\]", u2);
        end;

        p9:WriteRaw(format("\"%s\"", p10));

        return p9;
    end;

    if v11 ~= "number" then
        error(v11);

        return p9;
    end;

    p9:WriteRaw("\"");
    p9:WriteRaw((tostring(p10)));
    p9:WriteRaw("\"");

    return p9;
end;

function u6.WriteArray(p12, p13) -- Line: 64
    p12:WriteRaw("[");

    for i, v in ipairs(p13) do
        p12:WriteRaw(i == 1 and "" or ",");
        p12:WriteObject(v);
    end;

    p12:WriteRaw("]");

    return p12;
end;

function u6.WriteTable(p14, p15) -- Line: 74
    p14:WriteRaw("{");
    local v16 = 0;

    for i, v in pairs(p15) do
        if v ~= nil then
            p14:WriteRaw(v16 == 0 and "" or ",");
            p14:WriteKey(i);
            p14:WriteObject(v);
            v16 = v16 + 1;
        end;
    end;

    p14:WriteRaw("}");

    return p14;
end;

function u6.WriteObject(p17, p18) -- Line: 89
    -- upvalues: kindOf (copy), u2 (copy)
    local v19 = kindOf(p18);

    if v19 == "array" then
        p17:WriteArray(p18);

        return p17;
    end;

    if v19 == "table" then
        p17:WriteTable(p18);

        return p17;
    end;

    if v19 ~= "string" then
        if v19 == "number" or v19 == "boolean" then
            p17:WriteRaw((tostring(p18)));

            return p17;
        end;

        if v19 == "nil" then
            p17:WriteRaw("null");

            return p17;
        end;

        error(v19);

        return p17;
    end;

    local format = string.format;

    if p18:find("[\0-\31\"\\]") then
        p18 = p18:gsub("[\0-\31\"\\]", u2);
    end;

    p17:WriteRaw(format("\"%s\"", p18));

    return p17;
end;

function u6.WriteRaw(p20, p21) -- Line: 107
    table.insert(p20.fragments, p21);
end;

function u6.ToString(p22) -- Line: 111
    return table.concat(p22.fragments);
end;

return v1;