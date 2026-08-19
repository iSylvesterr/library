-- Decompiled with Potassium's decompiler.

return {
    ColorToGradient = function(p1) -- Line: 2
        local UIGradient = Instance.new("UIGradient");
        UIGradient.Color = ColorSequence.new(p1, p1:Lerp(Color3.fromRGB(255, 255, 255), 0.4));

        return UIGradient;
    end,

    HardSplitColorSequence = function(p2, p3, p4, p5) -- Line: 7
        local v6 = math.clamp(p4 == nil and 0.5 or p4, 0, 1);
        local v7 = v6 + math.clamp(p5 == nil and 0.0001 or p5, 1e-6, 0.1);
        local v8 = math.clamp(v7, 0, 1);

        if v6 <= 0 then
            return ColorSequence.new(p3);
        end;

        if v6 >= 1 then
            return ColorSequence.new(p2);
        end;

        return ColorSequence.new({
            ColorSequenceKeypoint.new(0, p2),
            ColorSequenceKeypoint.new(v6, p2),
            ColorSequenceKeypoint.new(v8, p3),
            ColorSequenceKeypoint.new(1, p3)
        });
    end,

    getColorJitter = function(p9, p10) -- Line: 25
        local v11 = p10 == nil and 0.1 or p10;
        local v12, v13, v14 = p9:ToHSV();
        local v15 = v11 * 0.1;
        local v16 = v12 + math.random(-v15, v15);

        if v16 < 0 then
            v16 = v16 + 1;
        end;

        if v16 >= 1 then
            v16 = v16 - 1;
        end;

        local v17 = v13 + math.random(-v11, v11);
        local v18 = math.clamp(v17, 0, 1);
        local v19 = v14 + math.random(-v11, v11);
        local v20 = math.clamp(v19, 0.3, 1);

        return Color3.fromHSV(v16, v18, v20);
    end
};