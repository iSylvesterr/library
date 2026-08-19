-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 5
    local v2 = math.abs(p1.RightVector.Y);
    local v3 = math.abs(p1.UpVector.Y);
    local v4 = math.abs(p1.LookVector.Y);

    return v2 <= v3 and v4 <= v3 and Vector3.new(0, 1, 0) or (v4 <= v2 and Vector3.new(1, 0, 0) or Vector3.new(0, 0, 1));
end;