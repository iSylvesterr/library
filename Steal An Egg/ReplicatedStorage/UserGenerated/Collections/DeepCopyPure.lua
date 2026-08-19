-- Decompiled with Potassium's decompiler.

function DeepCopyPure(p1, p2)
    if type(p1) ~= "table" then
        return p1;
    end;

    local v3 = not getmetatable(p1);
    assert(v3);
    local v4 = p2 or {};
    assert(not v4[p1]);
    v4[p1] = true;
    local v5 = {};

    for i, v in next, p1 do
        v5[DeepCopyPure(i, v4)] = DeepCopyPure(v, v4);
    end;

    v4[p1] = nil;

    return v5;
end;

return DeepCopyPure;