-- Decompiled with Potassium's decompiler.

local u7 = {
    ClampMagnitude = function(p1, p2) -- Line: 46, Name: ClampMagnitude
        if p2 < p1.Magnitude then
            p1 = p1.Unit * p2 or p1;
        end;

        return p1;
    end,

    AngleBetween = function(p3, p4) -- Line: 51, Name: AngleBetween
        local v5 = p3.Unit:Dot(p4.Unit);
        local v6 = math.clamp(v5, -1, 1);

        return math.acos(v6);
    end
};

function u7.AngleBetweenSigned(p8, p9, p10) -- Line: 56
    -- upvalues: u7 (copy)
    local v11 = u7.AngleBetween(p8, p9);
    local v12 = p10:Dot(p8:Cross(p9));

    return v11 * math.sign(v12);
end;

function u7.SquaredMagnitude(p13) -- Line: 61
    return p13.X ^ 2 + p13.Y ^ 2 + p13.Z ^ 2;
end;

return u7;