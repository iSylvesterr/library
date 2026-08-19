-- Decompiled with Potassium's decompiler.

local Sell = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui", (1 / 0)):WaitForChild("ScreenGui", (1 / 0)):WaitForChild("Sell", (1 / 0));
local v1 = Sell:FindFirstChild("ContentClip") or Sell;

return {
    UIRoot = Sell,
    AllPrice = v1.Bottom._AllPrice,
    SellAll = v1.Bottom._SellAll,
    BagScrollFrame = v1.Main._BagScrollFrame,
    Exit = v1.Top._Exit,
    MaterialTemp = v1.Main._BagScrollFrame._MaterialTemp
};