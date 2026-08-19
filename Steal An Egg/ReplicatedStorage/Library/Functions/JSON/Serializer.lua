-- Decompiled with Potassium's decompiler.

local Constant = require(script.Parent.Constant);
local NULL = Constant.NULL;
local ESC_MAP = Constant.ESC_MAP;
local u1 = {
    DEFAULT_PRINT_ADDRESSS = false,
    DEFAULT_MAX_DEPTH = 1000
};

function u1.new(p2, p3) -- Line: 10
    -- upvalues: u1 (copy)
    if p3 == nil then
        p3 = u1.DEFAULT_PRINT_ADDRESSS;
    end;

    return setmetatable({
        depth = 0,
        max_depth = p2 or u1.DEFAULT_MAX_DEPTH,
        print_address = p3,
        fragments = {}
    }, {
        __index = u1
    });
end;

local function kindOf(p4) -- Line: 23
    -- upvalues: NULL (copy)
    if type(p4) ~= "table" then
        return type(p4);
    end;

    if p4 == NULL then
        return "table";
    end;

    local v5 = 1;

    for _ in pairs(p4) do
        if p4[v5] == nil then
            return "table";
        end;

        v5 = v5 + 1;
    end;

    return v5 == 1 and "table" or "array";
end;

local function escapeStr(p6) -- Line: 40
    -- upvalues: ESC_MAP (copy)
    for i, v in pairs(ESC_MAP) do
        p6 = p6:gsub(i, v);
    end;

    return p6;
end;

function u1.space(p7, p8) -- Line: 47
    for _ = 1, p8 or 0 do
        p7:write(" ");
    end;

    return p7;
end;

function u1.key(p9, p10) -- Line: 54
    -- upvalues: kindOf (copy), ESC_MAP (copy)
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
        for i, v in pairs(ESC_MAP) do
            p10 = p10:gsub(i, v);
        end;

        p9:write("\"", p10, "\"");

        return p9;
    end;

    if v11 == "number" then
        p9:write("\"", tostring(p10), "\"");

        return p9;
    end;

    if p9.print_address then
        p9:write((tostring(p10)));

        return p9;
    end;

    error("Unjsonifiable type: " .. v11 .. ".");

    return p9;
end;

function u1.array(p12, p13, p14, p15, p16) -- Line: 77
    p12:write("[");

    for i, v in ipairs(p13) do
        if p14 then
            local v = p14(i, v);
        end;

        p12:write(i == 1 and "" or ",");
        p12:write(p16 > 0 and "\n" or "");
        p12:space(p15);
        p12:json(v, p14, p15 + p16, p16);
    end;

    if #p13 > 0 then
        p12:write(p16 > 0 and "\n" or "");
        p12:space(p15 - p16);
    end;

    p12:write("]");

    return p12;
end;

function u1.table(p17, p18, p19, p20, p21) -- Line: 96
    p17:write("{");
    local v22 = 0;

    for i, v in pairs(p18) do
        if p19 then
            local v = p19(i, v);
        end;

        if v ~= nil then
            p17:write(v22 == 0 and "" or ",");
            p17:write(p21 > 0 and "\n" or "");
            p17:space(p20);
            p17:key(i);
            p17:write(p21 > 0 and ": " or ":");
            p17:json(v, p19, p20 + p21, p21);
            v22 = v22 + 1;
        end;
    end;

    if v22 > 0 then
        p17:write(p21 > 0 and "\n" or "");
        p17:space(p20 - p21);
    end;

    p17:write("}");

    return p17;
end;

function u1.json(p23, p24, p25, p26, p27) -- Line: 121
    -- upvalues: kindOf (copy), ESC_MAP (copy)
    local v28 = kindOf(p24);
    p23.depth = p23.depth + 1;

    if p23.depth > p23.max_depth then
        error("Reach max depth: " .. tostring(p23.max_depth));
    end;

    if v28 == "array" then
        p23:array(p24, p25, p26, p27);
    elseif v28 == "table" then
        p23:table(p24, p25, p26, p27);
    elseif v28 == "string" then
        for i, v in pairs(ESC_MAP) do
            p24 = p24:gsub(i, v);
        end;

        p23:write("\"", p24, "\"");
    elseif v28 == "number" then
        p23:write((tostring(p24)));
    elseif v28 == "boolean" then
        p23:write((tostring(p24)));
    elseif v28 == "nil" then
        p23:write("null");
    elseif p23.print_address then
        p23:write((tostring(p24)));
    end;

    p23.depth = p23.depth - 1;

    return p23;
end;

function u1.write(p29, ...) -- Line: 146
    local v30 = { ... };
    local fragments = p29.fragments;
    table.move(v30, 1, #v30, #fragments + 1, fragments);
end;

function u1.toString(p31) -- Line: 152
    return table.concat(p31.fragments);
end;

return u1;