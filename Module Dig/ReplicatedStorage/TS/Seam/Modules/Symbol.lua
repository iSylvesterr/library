-- Decompiled with Potassium's decompiler.

return {
    new = function(u1) -- Line: 13, Name: new
        local v2 = newproxy(true);

        getmetatable(v2).__tostring = function() -- Line: 16
            -- upvalues: u1 (copy)
            return u1;
        end;

        return v2;
    end
};