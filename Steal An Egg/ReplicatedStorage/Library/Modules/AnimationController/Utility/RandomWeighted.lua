-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types);

return function(p1) -- Line: 3
    local v2 = 0;

    for i = 1, #p1 do
        v2 = v2 + (p1[i].weight or 1);
    end;

    local v3 = math.random() * v2;
    local v4 = 0;

    for i = 1, #p1 do
        local v5 = p1[i];
        v4 = v4 + (v5.weight or 1);

        if v3 <= v4 then
            return v5.anim, #p1, v5;
        end;
    end;

    local v6 = p1[#p1];

    return v6.anim, #p1, v6;
end;