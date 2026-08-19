-- Decompiled with Potassium's decompiler.

local u1 = { "Skip Polish 1", "Skip Polish 2", "Skip Polish 3", "Skip Polish 4", "Skip Polish 5", "Skip Polish 6", "Skip Polish 7", "Skip Polish 8", "Skip Polish 9", "Skip Polish 10" };
local u2 = { 300, 900, 1800, 3600, 7200, 10800, 18000, 25200, 32400 };

return {
    skipPolishTier = function(p3) -- Line: 5, Name: skipPolishTier
        -- upvalues: u2 (copy)
        local v4 = 0;

        while v4 < #u2 and u2[v4 + 1] < p3 do
            v4 = v4 + 1;
        end;

        return v4;
    end,

    skipPolishProduct = function(p5) -- Line: 12, Name: skipPolishProduct
        -- upvalues: u1 (copy), u2 (copy)
        local v6 = 0;

        while v6 < #u2 and u2[v6 + 1] < p5 do
            v6 = v6 + 1;
        end;

        return u1[v6 + 1];
    end,

    skipPolishProductTier = function(p7) -- Line: 15, Name: skipPolishProductTier
        -- upvalues: u1 (copy)
        return (table.find(u1, p7) or 0) - 1;
    end
};