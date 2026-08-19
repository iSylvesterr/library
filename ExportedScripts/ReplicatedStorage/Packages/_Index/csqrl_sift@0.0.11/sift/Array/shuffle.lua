-- Decompiled with Potassium's decompiler.

local copy = require(script.Parent.copy);

return function(p1) -- Line: 19, Name: shuffle
    -- upvalues: copy (copy)
    local v2 = Random.new(os.time() * #p1);
    local v3 = copy(p1);

    for i = #v3, 1, -1 do
        local v4 = v2:NextInteger(1, i);
        local v5 = v3[i];
        v3[i] = v3[v4];
        v3[v4] = v5;
    end;

    return v3;
end;