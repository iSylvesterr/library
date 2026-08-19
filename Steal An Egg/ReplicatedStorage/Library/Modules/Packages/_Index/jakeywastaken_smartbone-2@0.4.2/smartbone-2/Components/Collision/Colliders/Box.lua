-- Decompiled with Potassium's decompiler.

local function SafeUnit(p1) -- Line: 1
    return p1.Magnitude == 0 and Vector3.new(0, 0, 0) or p1.Unit;
end;

local function ClosestPointFunc(p2, p3, p4) -- Line: 9
    local v5 = p2:pointToObjectSpace(p4);
    local x = p3.x;
    local y = p3.y;
    local z = p3.z;
    local x2 = v5.x;
    local y2 = v5.y;
    local z2 = v5.z;
    local v6 = math.clamp(x2, -x * 0.5, x * 0.5);
    local v7 = math.clamp(y2, -y * 0.5, y * 0.5);
    local v8 = math.clamp(z2, -z * 0.5, z * 0.5);

    if v6 ~= x2 or (v7 ~= y2 or v8 ~= z2) then
        local v9 = p2 * Vector3.new(v6, v7, v8);
        local v10 = p4 - v9;

        return false, v9, v10.Magnitude == 0 and Vector3.new(0, 0, 0) or v10.Unit;
    end;

    local v11 = x2 - x * 0.5;
    local v12 = y2 - y * 0.5;
    local v13 = z2 - z * 0.5;
    local v14 = -x2 - x * 0.5;
    local v15 = -y2 - y * 0.5;
    local v16 = -z2 - z * 0.5;
    local v17 = math.max(v11, v12, v13, v14, v15, v16);

    if v17 == v11 then
        return true, p2 * Vector3.new(x * 0.5, y2, z2), p2.XVector;
    end;

    if v17 == v12 then
        return true, p2 * Vector3.new(x2, y * 0.5, z2), p2.YVector;
    end;

    if v17 == v13 then
        return true, p2 * Vector3.new(x2, y2, z * 0.5), p2.ZVector;
    end;

    if v17 == v14 then
        return true, p2 * Vector3.new(-x * 0.5, y2, z2), -p2.XVector;
    end;

    if v17 == v15 then
        return true, p2 * Vector3.new(x2, -y * 0.5, z2), -p2.YVector;
    end;

    if v17 == v16 then
        return true, p2 * Vector3.new(x2, y2, -z * 0.5), -p2.ZVector;
    end;

    warn("CLOSEST POINT ON BOX FAIL");

    return false, p2.Position, Vector3.new(0, 0, 0);
end;

return function(p18, p19, p20, p21) -- Line: 60
    -- upvalues: ClosestPointFunc (copy)
    local v22, v23, v24 = ClosestPointFunc(p18, p19, p20);

    if v22 then
        return v22, v23, v24;
    end;

    return (v23 - p20).Magnitude < p21, v23, v24;
end;