-- Decompiled with Potassium's decompiler.

local bxor = bit32.bxor;
local bor = bit32.bor;
local band = bit32.band;
local bnot = bit32.bnot;
local v8 = {
    band = function(p1, p2) -- Line: 8, Name: band
        -- upvalues: band (copy)
        return band(p1 // 4294967296, p2 // 4294967296) * 4294967296 + band(p1, p2);
    end,

    bnot = function(p3) -- Line: 12, Name: bnot
        -- upvalues: bnot (copy), band (copy)
        return band(bnot(p3 // 4294967296), 2097151) * 4294967296 + bnot(p3);
    end,

    bor = function(p4, p5) -- Line: 16, Name: bor
        -- upvalues: bor (copy)
        return bor(p4 // 4294967296, p5 // 4294967296) * 4294967296 + bor(p4, p5);
    end,

    bxor = function(p6, p7) -- Line: 20, Name: bxor
        -- upvalues: bxor (copy)
        return bxor(p6 // 4294967296, p7 // 4294967296) * 4294967296 + bxor(p6, p7);
    end
};
table.freeze(v8);
local v9 = v8.bxor(5337546457632111, 927896922657421) == 4993512435277794;
assert(v9);
local v10 = v8.bor(5337546457632111, 927896922657421) == 5629477907783663;
assert(v10);
local v11 = v8.band(5337546457632111, 927896922657421) == 635965472505869;
assert(v11);
local v12 = v8.bnot(5337546457632111) == 3669652797108880;
assert(v12);

return v8;