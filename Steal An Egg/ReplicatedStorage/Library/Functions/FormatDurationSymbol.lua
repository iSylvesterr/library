-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FormatDuration = require(script.Parent.FormatDuration);
local Asserts = require(ReplicatedStorage.Library.Asserts);

return function(p1) -- Line: 11
    -- upvalues: Asserts (copy), FormatDuration (copy)
    Asserts.number(p1);
    local v2 = math.max(p1, 0);
    local v3 = math.ceil(v2);

    if v3 < 60 then
        return FormatDuration(v3);
    end;

    if v3 < 3600 then
        local v4 = v3 // 60;
        local v5 = v3 % 60;

        if v5 <= 0 then
            return `{v4}m`;
        end;

        return `{v4}m {v5}s`;
    end;

    if v3 < 86400 then
        local v6 = v3 // 3600;
        local v7 = v3 % 3600 // 60;

        if v7 <= 0 then
            return `{v6}h`;
        end;

        return `{v6}h {v7}m`;
    end;

    local v8 = v3 // 86400;
    local v9 = v3 % 86400 // 3600;

    if v9 <= 0 then
        return `{v8}d`;
    end;

    return `{v8}d {v9}h`;
end;