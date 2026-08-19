-- Decompiled with Potassium's decompiler.

return function(u1) -- Line: 1
    return function(p2, ...) -- Line: 2
        -- upvalues: u1 (copy)
        local v3 = u1[p2] or u1._;

        if v3 then
            return v3(...);
        end;
    end;
end;