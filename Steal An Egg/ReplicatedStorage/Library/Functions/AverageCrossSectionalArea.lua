-- Decompiled with Potassium's decompiler.

local u8 = {
    [Enum.PartType.Block] = function(p1) -- Line: 4
        return (p1.X * p1.Y + p1.X * p1.Z + p1.Y * p1.Z) / 3;
    end,

    [Enum.PartType.Wedge] = function(p2) -- Line: 7
        return (p2.X * p2.Y + p2.X * p2.Z + p2.Y * p2.Z / 2) / 3;
    end,

    [Enum.PartType.Cylinder] = function(p3) -- Line: 10
        local v4 = p3.X / 2;

        return (v4 * 3.141592653589793 * v4 + v4 * 2 * p3.Y) / 2;
    end,

    [Enum.PartType.CornerWedge] = function(p5) -- Line: 14
        return (p5.X * p5.Y / 2 + p5.X * p5.Z / 2 + p5.Y * p5.Z / 2) / 3;
    end,

    [Enum.PartType.Ball] = function(p6) -- Line: 17
        local v7 = p6.X / 2;

        return v7 * 12.566370614359172 * v7 / 3;
    end
};

return function(p9, p10) -- Line: 23, Name: AverageCrossSectionalArea
    -- upvalues: u8 (copy)
    return (u8[p9] or u8[Enum.PartType.Block])(p10);
end;