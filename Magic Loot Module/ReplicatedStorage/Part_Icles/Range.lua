-- Decompiled with Potassium's decompiler.

return {
    RandomValueFromRange = function(p1) -- Line: 4, Name: RandomValueFromRange
        if p1.Min == p1.Max then
            return p1.Min;
        end;

        return p1.Min + (p1.Max - p1.Min) * math.random();
    end
};