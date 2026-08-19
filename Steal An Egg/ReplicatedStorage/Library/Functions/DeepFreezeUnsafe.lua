-- Decompiled with Potassium's decompiler.

local function freeze(p1) -- Line: 1
    -- upvalues: freeze (copy)
    if type(p1) == "table" then
        if not table.isfrozen(p1) then
            table.freeze(p1);
        end;

        for i, v in pairs(p1) do
            freeze(i);
            freeze(v);
        end;
    end;
end;

return function(p2) -- Line: 13
    -- upvalues: freeze (copy)
    freeze(p2);

    return p2;
end;