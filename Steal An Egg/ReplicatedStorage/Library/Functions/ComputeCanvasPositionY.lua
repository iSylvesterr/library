-- Decompiled with Potassium's decompiler.

return function(p1, p2) -- Line: 1
    local Y = p1.AbsoluteWindowSize.Y;
    local Y2 = p2.AbsolutePosition.Y;
    local Y3 = p2.AbsoluteSize.Y;
    local Y4 = p1.CanvasPosition.Y;

    if Y2 < 0 then
        return Y4;
    end;

    if Y2 + Y3 / 2 <= Y then
        return Y4;
    end;

    return math.min(Y2, Y2 + Y3 - Y) + Y4;
end;