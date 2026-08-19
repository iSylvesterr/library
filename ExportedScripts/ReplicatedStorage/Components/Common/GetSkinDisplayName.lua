-- Decompiled with Potassium's decompiler.

local u1 = table.freeze({
    ["Lebron James"] = "LeGoat",
    ["Medal.tv"] = "Medal"
});

return function(p2, p3) -- Line: 14
    -- upvalues: u1 (copy)
    if not p2:find("PATTERN") then
        return u1[p2] or p2;
    end;

    local v4, v5 = table.unpack(p2:split("_PATTERN_"));

    if p3 then
        v4 = `{v4} • Pattern {v5}` or v4;
    end;

    return v4;
end;