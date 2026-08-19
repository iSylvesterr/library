-- Decompiled with Potassium's decompiler.

local u2 = {
    HalfExtents = function(p1) -- Line: 13, Name: HalfExtents
        local Size = p1.Size;

        return math.max(Size.X * 0.5 - 1.75, 0), math.max(Size.Z * 0.5 - 1.75, 0);
    end
};

function u2.ClampedPointToward(p3, p4) -- Line: 19
    -- upvalues: u2 (copy)
    local v5, v6 = u2.HalfExtents(p3);
    local v7 = p3.CFrame:PointToObjectSpace(p4);
    local v8 = math.clamp(v7.X, -v5, v5);
    local v9 = math.clamp(v7.Z, -v6, v6);

    return (p3.CFrame * CFrame.new(v8, 0, v9)).Position;
end;

function u2.RandomPoint(p10, p11) -- Line: 28
    -- upvalues: u2 (copy)
    local v12, v13 = u2.HalfExtents(p10);
    local v14 = p11:NextNumber(-v12, v12);
    local v15 = p11:NextNumber(-v13, v13);

    return (p10.CFrame * CFrame.new(v14, 0, v15)).Position;
end;

function u2.IsPositionInside(p16, p17) -- Line: 36
    -- upvalues: u2 (copy)
    local v18, v19 = u2.HalfExtents(p16);
    local v20 = p16.CFrame:PointToObjectSpace(p17);
    local v21;

    if math.abs(v20.X) <= v18 then
        v21 = math.abs(v20.Z) <= v19;
    else
        v21 = false;
    end;

    return v21;
end;

function u2.PointNearOwner(p22, p23, p24) -- Line: 43
    -- upvalues: u2 (copy)
    return u2.ClampedPointToward(p22, p23 + p24);
end;

return u2;