-- Decompiled with Potassium's decompiler.

return {
    quadraticBezier = function(p1, p2, p3, p4) -- Line: 13, Name: quadraticBezier
        local v5 = 1 - p4;

        return p1 * (v5 * v5) + p2 * (2 * v5 * p4) + p3 * (p4 * p4);
    end
};