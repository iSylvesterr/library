-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types);

return function(p1, ...) -- Line: 21, Name: difference
    local v2 = table.clone(p1);

    for _, v in { ... } do
        if typeof(v) == "table" then
            for i in v do
                v2[i] = nil;
            end;
        end;
    end;

    return v2;
end;