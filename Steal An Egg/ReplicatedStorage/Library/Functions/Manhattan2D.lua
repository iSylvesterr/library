-- Decompiled with Potassium's decompiler.

return function(p1, p2) -- Line: 1
    local v3 = p2.CFrame:PointToObjectSpace(p1);

    if math.abs(v3.X) > p2.Size.X / 2 then
        return false;
    end;

    return math.abs(v3.Z) <= p2.Size.Z / 2;
end;