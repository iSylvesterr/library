-- Decompiled with Potassium's decompiler.

return function(...) -- Line: 1
    local v1 = ...;

    return not v1 and {} or (type(v1) ~= "table" and { ... } or (#v1 <= 0 and next(v1) and { ... } or v1));
end;