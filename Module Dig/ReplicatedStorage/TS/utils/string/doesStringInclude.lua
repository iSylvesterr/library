-- Decompiled with Potassium's decompiler.

return {
    doesStringInclude = function(p1, p2) -- Line: 2
        local v3 = string.lower(p1);
        local v4 = string.lower(p2);

        return #{ string.find(v3, v4) } > 0;
    end
};