-- Decompiled with Potassium's decompiler.

return function() -- Line: 1
    local u1 = false;

    return function(p2, p3) -- Line: 3
        -- upvalues: u1 (ref)
        if u1 then
            return false;
        end;

        u1 = true;
        task.delay(p2, function() -- Line: 8
            -- upvalues: u1 (ref)
            u1 = false;
        end);

        if p3 then
            p3();
        end;

        return true;
    end;
end;