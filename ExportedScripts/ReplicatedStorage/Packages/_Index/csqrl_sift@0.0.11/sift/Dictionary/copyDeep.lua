-- Decompiled with Potassium's decompiler.

local function copyDeep(p1) -- Line: 20
    -- upvalues: copyDeep (copy)
    local v2 = table.clone(p1);

    for i, v in pairs(p1) do
        if type(v) == "table" then
            v2[i] = copyDeep(v);
        end;
    end;

    return v2;
end;

return copyDeep;