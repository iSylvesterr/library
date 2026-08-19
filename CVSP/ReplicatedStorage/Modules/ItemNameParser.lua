-- Decompiled with Potassium's decompiler.

local function trim(p1) -- Line: 9
    return p1:match("^%s*(.-)%s*$");
end;

local u2 = {
    Gold = true,
    Rainbow = true
};

return function(p3) -- Line: 18, Name: parseItemInfo
    -- upvalues: trim (copy), u2 (copy)
    local v4 = "";
    local v5 = "";
    local v6 = 1;

    if typeof(p3) ~= "string" then
        return nil;
    end;

    local v7 = {};

    for i in p3:gmatch("%[(.-)%]") do
        table.insert(v7, i);
    end;

    for _, v in ipairs(v7) do
        local v8 = v:match("^(%d+%.?%d*)x$");

        if v8 then
            v6 = tonumber(v8);
        end;
    end;

    if #v7 >= 1 then
        for _, v in ipairs(v7) do
            if not v:match("^(%d+%.?%d*)x$") then
                local v9 = {};

                for i in v:gmatch("([^,]+)") do
                    table.insert(v9, trim(i));
                end;

                if u2[v9[1]] then
                    v4 = v9[1];
                    table.remove(v9, 1);
                end;

                if #v9 > 0 then
                    v5 = table.concat(v9, ", ");
                end;

                break;
            end;
        end;
    end;

    return v4, v5, v6, p3:gsub("%b[]%s*", ""):match("^%s*(.-)%s*$");
end;