-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Library.Types.Currency);
local CurrencyItem = require(ReplicatedStorage.Library.Items.CurrencyItem);

return function(p1, p2, p3, p4) -- Line: 9
    -- upvalues: CurrencyItem (copy)
    p1.boost.Text = string.format("+%d%% %s", p4, p3);
    p1.icon.Image = CurrencyItem(p3):GetIcon();
    local v5 = p1.boost:FindFirstChild(p3);

    if v5 then
        v5.Enabled = true;
    end;
end;