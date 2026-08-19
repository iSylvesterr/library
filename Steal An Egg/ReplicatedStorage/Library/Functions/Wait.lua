-- Decompiled with Potassium's decompiler.

local u1 = Random.new();

return function(p2, p3) -- Line: 3
    -- upvalues: u1 (copy)
    if p3 then
        p2 = u1:NextNumber(p2, p3);
    end;

    task.wait(p2);
end;