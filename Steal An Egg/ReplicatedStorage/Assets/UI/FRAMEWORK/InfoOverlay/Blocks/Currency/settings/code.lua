-- Decompiled with Potassium's decompiler.

local CurrencyUtil = require(game.ReplicatedStorage.Library.Util.CurrencyUtil);

return function(p1, p2, p3, p4) -- Line: 2
    -- upvalues: CurrencyUtil (copy)
    local v5 = p4 or p3:GetAmount();
    CurrencyUtil.SetupPriceFrame(p1, p3:GetId(), v5, 2);
end;