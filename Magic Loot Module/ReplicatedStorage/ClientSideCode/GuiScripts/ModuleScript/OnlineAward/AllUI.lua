-- Decompiled with Potassium's decompiler.

local OnlineAward = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui", (1 / 0)):WaitForChild("ScreenGui", (1 / 0)):WaitForChild("OnlineAward", (1 / 0));
local v1 = OnlineAward:FindFirstChild("ContentClip") or OnlineAward;

return {
    UIRoot = OnlineAward,
    ClaimAll = v1.Bottom._ClaimAll,
    OnlineScroll = v1.Main._OnlineScroll,
    Exit = v1.Top._Exit,
    Temp = v1.Main._OnlineScroll._Temp
};