-- Decompiled with Potassium's decompiler.

local u1 = {};

function u1.isInfinite(p2) -- Line: 8
    -- upvalues: u1 (copy)
    local v3 = u1.getData(p2);

    if v3 then
        v3 = v3:FindFirstChild("Infinite");
    end;

    local v4;

    if v3 == nil then
        v4 = false;
    else
        v4 = v3.Value == true;
    end;

    return v4;
end;

function u1.getData(p5) -- Line: 14
    return script:FindFirstChild(p5) or nil;
end;

return u1;