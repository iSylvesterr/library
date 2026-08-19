-- Decompiled with Potassium's decompiler.

return function(p1, p2, p3) -- Line: 2, Name: cframeSlerp
    local v4 = p1.Position:Lerp(p2.Position, p3);
    local v5 = p1.LookVector:Dot(p2.LookVector);
    local v6 = math.acos(v5);
    local v7;

    if v6 < 0.05 then
        v7 = p1.LookVector;
    else
        v7 = math.sin((1 - p3) * v6) / math.sin(v6) * p1.LookVector + math.sin(p3 * v6) / math.sin(v6) * p2.LookVector;
    end;

    return CFrame.new(v4, v4 + v7);
end;