-- Decompiled with Potassium's decompiler.

return {
    FormatGrams = function(p1) -- Line: 3, Name: FormatGrams
        local v2 = (tonumber(p1) or 0) * 100 + 0.5;
        local v3 = math.floor(v2) / 100;

        return string.format("%.2fkg", v3);
    end
};