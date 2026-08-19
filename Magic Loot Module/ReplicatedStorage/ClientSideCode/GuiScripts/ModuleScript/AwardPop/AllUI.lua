-- Decompiled with Potassium's decompiler.

local AwardPop = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui", (1 / 0)):WaitForChild("ScreenGui", (1 / 0)):WaitForChild("AwardPop", (1 / 0));
local v1 = AwardPop:FindFirstChild("ContentClip") or AwardPop;

return {
    UIRoot = AwardPop,
    AwardBtn = v1.Bottom._AwardBtn,
    Scroll = v1.Main._Scroll,
    Exit = v1.Top._Exit,
    MagicAward = v1.Main._Scroll._MagicAward,
    MoneyAward = v1.Main._Scroll._MoneyAward
};