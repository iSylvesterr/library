-- Decompiled with Potassium's decompiler.

function DeepCopyPureUnsafe(p1)
    if type(p1) ~= "table" then
        return p1;
    end;

    local v2 = {};

    for i, v in next, p1 do
        v2[DeepCopyPureUnsafe(i)] = DeepCopyPureUnsafe(v);
    end;

    return v2;
end;

return DeepCopyPureUnsafe;