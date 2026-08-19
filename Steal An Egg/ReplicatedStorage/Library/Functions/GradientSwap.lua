-- Decompiled with Potassium's decompiler.

return function(p1, p2) -- Line: 1
    for _, child in p1:GetChildren() do
        if child:IsA("UIGradient") then
            child:Destroy();
        end;
    end;

    if p2 == nil then
        return nil;
    end;

    local v3 = p2:Clone();
    v3.Parent = p1;

    return v3;
end;