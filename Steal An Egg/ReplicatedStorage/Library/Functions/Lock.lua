-- Decompiled with Potassium's decompiler.

local finally = require(script.Parent.finally);

return function() -- Line: 5
    -- upvalues: finally (copy)
    local u1 = false;

    return function(p2, ...) -- Line: 7, Name: acquire
        -- upvalues: u1 (ref), finally (ref)
        if u1 then
            return false;
        end;

        u1 = true;

        return true, finally(p2, function() -- Line: 12
            -- upvalues: u1 (ref)
            u1 = false;
        end, ...);
    end;
end;