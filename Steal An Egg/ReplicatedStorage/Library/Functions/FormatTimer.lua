-- Decompiled with Potassium's decompiler.

return function(p1, p2) -- Line: 1
    local function formatDoubleZero(p3) -- Line: 3
        local v4 = 0;

        for _ in p3:gmatch("(00:)") do
            v4 = v4 + 1;
        end;

        if v4 == 0 then
            return "00:" .. p3;
        end;

        if v4 == 1 then
            return p3;
        end;

        local v5, v6 = p3:match("^(00:)(.*)");
        assert(v5, v6);

        return v5 .. v6:gsub("(00:)", "");
    end;

    local v7 = math.round(p1 / 60 / 60 / 24 - 0.5);
    local v8 = os.date("!%X", p1);

    if v7 and v7 > 0 then
        v8 = v7 .. ":" .. v8;
    end;

    if p1 < 86400 then
        if p2 then
            return formatDoubleZero(v8);
        end;

        return v8;
    end;

    local v9 = game:GetService("Workspace"):GetServerTimeNow();
    local day = os.date("*t", v9 + p1).day;

    return os.date("%B ", v9 + p1) .. day .. (day % 10 == 1 and day ~= 11 and "st" or (day % 10 == 2 and day ~= 12 and "nd" or (day % 10 == 3 and day ~= 13 and "rd" or "th")));
end;