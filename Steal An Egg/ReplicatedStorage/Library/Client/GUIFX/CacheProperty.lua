-- Decompiled with Potassium's decompiler.

local u1 = {};

return function(p2, p3) -- Line: 9
    -- upvalues: u1 (copy)
    if not p2 then
        return nil;
    end;

    if u1[p2] == nil then
        u1[p2] = {};
    end;

    if u1[p2][p3] == nil then
        u1[p2][p3] = p2[p3];
    end;

    return u1[p2][p3];
end;