-- Decompiled with Potassium's decompiler.

local Library = game.ReplicatedStorage.Library;
local CurrencyUtil = require(Library.Util.CurrencyUtil);
require(Library.Items.CurrencyItem);

return function(p1, p2, p3, p4) -- Line: 5, Name: SetupPriceFrameForCurrency
    -- upvalues: CurrencyUtil (copy)
    local v5 = p4 or p3:GetAmount();
    CurrencyUtil.SetupPriceFrame(p1, p3:GetId(), v5, 2);
end;