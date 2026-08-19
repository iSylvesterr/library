-- Decompiled with Potassium's decompiler.

return function(p1, p2) -- Line: 1
    local v3 = 0;
    local X = p2.X;
    local Y = p2.Y;
    local Z = p2.Z;
    local v4 = 0;

    if p2.X < -p1.X then
        local v5 = X + p1.X;
        v3 = v3 + v5 * v5;
        X = -p1.X;
    elseif p2.X > p1.X then
        local v6 = X - p1.X;
        v3 = v3 + v6 * v6;
        X = p1.X;
    else
        v4 = v4 + 1;
    end;

    if p2.Y < -p1.Y then
        local v7 = Y + p1.Y;
        v3 = v3 + v7 * v7;
        Y = -p1.Y;
    elseif p2.Y > p1.Y then
        local v8 = Y - p1.Y;
        v3 = v3 + v8 * v8;
        Y = p1.Y;
    else
        v4 = v4 + 1;
    end;

    if p2.Z < -p1.Z then
        local v9 = Z + p1.Z;
        v3 = v3 + v9 * v9;
        Z = -p1.Z;
    elseif p2.Z > p1.Z then
        local v10 = Z - p1.Z;
        v3 = v3 + v10 * v10;
        Z = p1.Z;
    else
        v4 = v4 + 1;
    end;

    return math.sqrt(v3), Vector3.new(X, Y, Z), v4 >= 3;
end;