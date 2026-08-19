-- Decompiled with Potassium's decompiler.

return {
    roundToTenth = function(p1) -- Line: 2, Name: roundToTenth
        return math.round(p1 * 10) / 10;
    end,

    roundToHundredth = function(p2) -- Line: 5, Name: roundToHundredth
        return math.round(p2 * 100) / 100;
    end
};