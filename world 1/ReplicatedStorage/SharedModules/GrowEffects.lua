-- Decompiled with Potassium's decompiler.

local u1 = {
    SmoothGrow = false,
    GrowTick = 0.25,
    InitialScale = 1
};

function u1.GetGrowthScale(p2, p3) -- Line: 24
    -- upvalues: u1 (copy)
    local InitialScale = u1.InitialScale;

    if InitialScale == 1 then
        return 1;
    end;

    if p3 <= 0 then
        return 1;
    end;

    local v4 = math.clamp(p2 / p3, 0, 1);

    return math.lerp(InitialScale, 1, v4);
end;

function u1.AddDescendantsAtBaseline(p5, p6) -- Line: 48
    local v7 = p5:GetScale();

    if math.abs(v7 - 1) < 0.0001 then
        p6();

        return;
    end;

    p5:ScaleTo(1);
    p6();
    p5:ScaleTo(v7);
end;

return table.freeze(u1);