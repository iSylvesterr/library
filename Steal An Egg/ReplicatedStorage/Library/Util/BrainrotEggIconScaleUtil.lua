-- Decompiled with Potassium's decompiler.

return {
    MIN_EGG_SCALE = 0.8,
    MAX_EGG_SCALE = 3,
    MIN_ICON_SCALE = 0.5,
    MAX_ICON_SCALE = 1.1,

    MapEggScaleToIconScale = function(p1) -- Line: 8, Name: mapEggScaleToIconScale
        return (typeof(p1) ~= "number" or (p1 ~= p1 or p1 <= 0)) and 1.1 or (math.clamp(p1, 0.8, 3) - 0.8) / 2.2 * 0.6000000000000001 + 0.5;
    end,

    ApplyIconScaleToImageLabel = function(p2, p3) -- Line: 23, Name: applyIconScaleToImageLabel
        local v4 = (typeof(p3) ~= "number" or (p3 ~= p3 or p3 <= 0)) and 1.1 or (math.clamp(p3, 0.8, 3) - 0.8) / 2.2 * 0.6000000000000001 + 0.5;
        p2.Size = UDim2.fromScale(v4, v4);
    end
};