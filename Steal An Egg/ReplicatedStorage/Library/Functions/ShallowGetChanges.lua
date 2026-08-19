-- Decompiled with Potassium's decompiler.

local DeepEquals = require(script.Parent.DeepEquals);
local DeepEqualsUnsafe = require(script.Parent.DeepEqualsUnsafe);

return function(p1, p2, p3) -- Line: 14
    -- upvalues: DeepEqualsUnsafe (copy), DeepEquals (copy)
    if typeof(p1) ~= "table" or typeof(p2) ~= "table" then
        return {}, {};
    end;

    local v4 = typeof(p3) == "table" and p3 and p3 or {};
    local SkipKeys = v4.SkipKeys;
    local v5 = {};

    for i, v in p2 do
        if not (SkipKeys and SkipKeys[i]) then
            local v6 = p1[i];

            if v6 ~= v then
                local v7;

                if typeof(v) == typeof(v6) and typeof(v) == "table" then
                    if v4.DeepEqualsUnsafe then
                        v7 = not DeepEqualsUnsafe(v, v6);
                    else
                        v7 = not DeepEquals(v, v6);
                    end;
                else
                    v7 = true;
                end;

                if v7 then
                    v5[i] = v;
                end;
            end;
        end;
    end;

    local v8 = {};

    for i in pairs(p1) do
        if not (SkipKeys and SkipKeys[i]) and p2[i] == nil then
            v8[i] = true;
        end;
    end;

    return v5, v8;
end;