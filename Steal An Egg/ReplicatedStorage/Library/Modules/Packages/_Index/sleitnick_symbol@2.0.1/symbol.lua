-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 45, Name: Symbol
    local v2 = newproxy(true);
    local u3 = p1 or "";

    getmetatable(v2).__tostring = function() -- Line: 50
        -- upvalues: u3 (ref)
        return "Symbol(" .. u3 .. ")";
    end;

    return v2;
end;