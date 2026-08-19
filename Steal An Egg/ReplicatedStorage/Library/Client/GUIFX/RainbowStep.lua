-- Decompiled with Potassium's decompiler.

return function(p1, p2) -- Line: 7
    local u3 = p1 or 1;
    local u4 = p2 or math.random();

    return function(p5) -- Line: 11
        -- upvalues: u4 (ref), u3 (copy)
        u4 = u4 + p5 * u3;

        return Color3.fromHSV(u4 % 1, 1, 1);
    end;
end;