-- Decompiled with Potassium's decompiler.

require(game.ReplicatedStorage.UserGenerated.Randoms.Base);
local Xorshift128 = require(game.ReplicatedStorage.UserGenerated.Randoms.Xorshift128);

return table.freeze({
    DefaultXorshift128 = Xorshift128.R,

    Xorshift128 = function(p1) -- Line: 28, Name: Xorshift128
        -- upvalues: Xorshift128 (copy)
        return Xorshift128.new(p1);
    end,

    UniqueXorshift128 = function(p2) -- Line: 31, Name: UniqueXorshift128
        -- upvalues: Xorshift128 (copy)
        return Xorshift128.Unique(p2);
    end
});