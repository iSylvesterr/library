-- Decompiled with Potassium's decompiler.

local u1 = {
    None = newproxy()
};

function u1.DeepFreeze(p2) -- Line: 14
    -- upvalues: u1 (copy)
    table.freeze(p2);

    for _, v in p2 do
        if type(v) == "table" then
            u1.DeepFreeze(v);
        end;
    end;

    return p2;
end;

function u1.DeepCopy(p3) -- Line: 25
    -- upvalues: u1 (copy)
    local v4 = table.clone(p3);

    for i, v in v4 do
        if type(v) == "table" then
            v4[i] = u1.DeepCopy(v);
        end;
    end;

    return v4;
end;

function u1.Extend(p5, p6) -- Line: 37
    -- upvalues: u1 (copy)
    local v7 = u1.DeepCopy(p5);

    for i, v in p6 do
        if type(v) == "table" then
            if type(p5[i]) == "table" then
                v7[i] = u1.Extend(p5[i], v);
            else
                v7[i] = u1.DeepCopy(v);
            end;
        elseif v == u1.None then
            v7[i] = nil;
        else
            v7[i] = v;
        end;
    end;

    return v7;
end;

return u1;