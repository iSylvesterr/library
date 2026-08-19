-- Decompiled with Potassium's decompiler.

function DeepCopyWithMetatables(p1, p2)
    if type(p1) ~= "table" then
        return p1;
    end;

    local v3 = p2 or {};
    local v4 = v3[p1];

    if v4 then
        return v4;
    end;

    local v5 = {};
    v3[p1] = v5;

    for i, v in next, p1 do
        v5[DeepCopyWithMetatables(i, v3)] = DeepCopyWithMetatables(v, v3);
    end;

    local v6 = getmetatable(p1);

    if v6 then
        setmetatable(v5, v6);
    end;

    return v5;
end;

return DeepCopyWithMetatables;