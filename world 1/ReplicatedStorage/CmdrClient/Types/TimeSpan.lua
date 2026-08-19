-- Decompiled with Potassium's decompiler.

local u1 = {
    s = 1,
    sec = 1,
    secs = 1,
    second = 1,
    seconds = 1,
    m = 60,
    min = 60,
    mins = 60,
    minute = 60,
    minutes = 60,
    h = 3600,
    hr = 3600,
    hrs = 3600,
    hour = 3600,
    hours = 3600,
    d = 86400,
    day = 86400,
    days = 86400,
    w = 604800,
    wk = 604800,
    wks = 604800,
    week = 604800,
    weeks = 604800,
    mo = 2592000,
    mos = 2592000,
    month = 2592000,
    months = 2592000,
    y = 31536000,
    yr = 31536000,
    yrs = 31536000,
    year = 31536000,
    years = 31536000
};
local u2 = { "s", "m", "h", "d", "w", "mo", "y" };

local function ParseTimeSpan(p3) -- Line: 25
    -- upvalues: u1 (copy)
    if type(p3) ~= "string" or p3 == "" then
        return nil;
    end;

    local v4 = string.gsub(p3, "%s+", "");
    local v5 = string.lower(v4);
    local v6 = tonumber(v5);

    if v6 then
        if v6 > 0 then
            return v6;
        end;

        return nil;
    end;

    local v7 = 0;
    local v8 = 0;

    for i, v in string.gmatch(v5, "(%d+%.?%d*)(%a+)") do
        local v9 = u1[v];
        local v10 = tonumber(i);

        if not (v9 and v10) then
            return nil;
        end;

        v7 = v7 + v10 * v9;
        v8 = v8 + (#i + #v);
    end;

    if v8 == #v5 and v7 > 0 then
        return v7;
    end;

    return nil;
end;

local function AutocompleteTimeSpan(p11) -- Line: 51
    -- upvalues: u2 (copy)
    local v12, v13, v14 = string.match(p11, "^(.-)(%d+%.?%d*)(%a*)$");

    if not v13 then
        return {};
    end;

    local v15 = string.lower(v14);
    local v16 = {};

    for _, v in u2 do
        if v15 == "" or string.sub(v, 1, #v15) == v15 then
            local v17 = `{v12}{v13}{v}`;
            table.insert(v16, v17);
        end;
    end;

    return v16;
end;

return function(p18) -- Line: 65
    -- upvalues: ParseTimeSpan (copy), AutocompleteTimeSpan (copy)
    p18:RegisterType("timeSpan", {
        Transform = function(p19) -- Line: 67, Name: Transform
            -- upvalues: ParseTimeSpan (ref)
            return p19, ParseTimeSpan(p19);
        end,

        Validate = function(p20, p21) -- Line: 70, Name: Validate
            return p21 ~= nil, "Time must be a positive duration like 60s, 10m, 2h, 5d, 3w, 3mo, 1y, or a compound like 1d12h.";
        end,

        Autocomplete = function(p22) -- Line: 74, Name: Autocomplete
            -- upvalues: AutocompleteTimeSpan (ref)
            return AutocompleteTimeSpan(p22);
        end,

        Parse = function(p23, p24) -- Line: 77, Name: Parse
            return p24;
        end
    });
end;