-- Decompiled with Potassium's decompiler.

local Util = require(script.Parent.Parent.Shared.Util);
local u1 = {
    Years = 31556926,
    Months = 2629744,
    Weeks = 604800,
    Days = 86400,
    Hours = 3600,
    Minutes = 60,
    Seconds = 1
};
local v2 = {};

for i, _ in pairs(u1) do
    table.insert(v2, i);
end;

local u3 = Util.MakeFuzzyFinder(v2);

local function stringToSecondDuration(p4) -- Line: 19
    -- upvalues: u3 (copy), u1 (copy)
    if p4 == nil or p4 == "" then
        return nil;
    end;

    local v5 = tonumber(p4);

    if v5 and v5 == 0 then
        return 0, 0, true;
    end;

    local v6 = p4:gsub("-?%d+%a+", ""):match("-?%d+");

    if v6 then
        return nil, tonumber(v6), true;
    end;

    local v7 = nil;
    local v8 = nil;

    for i in p4:gmatch("-?%d+%a+") do
        local v9;
        v8, v9 = i:match("(-?%d+)(%a+)");
        local v10 = u3(v9);

        if #v10 == 0 then
            return nil, tonumber(v8);
        end;

        v7 = (v7 == nil and 0 or v7) + (v9:lower() == "m" and 60 or u1[v10[1]]) * tonumber(v8);
    end;

    if v7 == nil then
        return nil;
    end;

    return v7, tonumber(v8);
end;

local function mapUnits(p11, p12, p13, p14) -- Line: 58
    local v15 = p14 or 1;
    local v16 = {};

    for i, v in pairs(p11) do
        if p13 == 1 then
            v16[i] = p12 .. v:sub(v15, #v - 1);
        else
            v16[i] = p12 .. v:sub(v15);
        end;
    end;

    return v16;
end;

local u29 = {
    Transform = function(p17) -- Line: 72, Name: Transform
        -- upvalues: stringToSecondDuration (copy)
        return p17, stringToSecondDuration(p17);
    end,

    Validate = function(p18, p19) -- Line: 76, Name: Validate
        return p19 ~= nil;
    end,

    Autocomplete = function(p20, p21, p22, p23, p24) -- Line: 80, Name: Autocomplete
        -- upvalues: u3 (copy), mapUnits (copy)
        local v25 = {};

        if not (p23 or p24) then
            if p21 ~= nil then
                local v26 = p20:match("^.*-?%d+(%a+)%s?$");
                v25 = mapUnits(u3(v26), p20, p22, #v26 + 1);
                table.sort(v25);
            end;

            return v25;
        end;

        if p23 == true then
            p24 = u3("") or p24;
        end;

        if p23 == true then
            return mapUnits(p24, p20, p22);
        end;

        return mapUnits(p24, p20, p20:match("^.*(%a+)$"):len() + 1);
    end,

    Parse = function(p27, p28) -- Line: 104, Name: Parse
        return p28;
    end
};

return function(p30) -- Line: 109
    -- upvalues: u29 (copy), Util (copy)
    p30:RegisterType("duration", u29);
    p30:RegisterType("durations", Util.MakeListableType(u29));
end;