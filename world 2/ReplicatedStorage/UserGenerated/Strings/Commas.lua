-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TrimmedNumberString = require(ReplicatedStorage.UserGenerated.Strings.TrimmedNumberString);

return function(p1) -- Line: 35, Name: Commas
    -- upvalues: TrimmedNumberString (copy)
    if type(p1) ~= "string" then
        p1 = TrimmedNumberString(p1);
    end;

    local v2, v3, v4 = string.match(p1, "^(.-)([0-9,]+)(.*)$");

    if not v3 then
        return p1;
    end;

    local v5 = {};

    if v2 then
        table.insert(v5, v2);
    end;

    local v6 = string.gsub(v3, ",", "");
    local v7 = 1;
    local v8 = #v6 % 3;

    if v8 > 0 then
        local v9 = string.sub(v6, v7, v7 + v8 - 1);
        table.insert(v5, v9);
        v7 = v7 + v8;
    end;

    while v7 <= #v6 do
        if v7 > 1 then
            table.insert(v5, ",");
        end;

        local v10 = string.sub(v6, v7, v7 + 2);
        table.insert(v5, v10);
        v7 = v7 + 3;
    end;

    if v4 then
        table.insert(v5, v4);
    end;

    return table.concat(v5);
end;