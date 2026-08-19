-- Decompiled with Potassium's decompiler.

local HatchPop = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui", (1 / 0)):WaitForChild("ScreenGui", (1 / 0)):WaitForChild("HatchPop", (1 / 0));
local v1 = HatchPop:FindFirstChild("ContentClip") or HatchPop;

return {
    UIRoot = HatchPop,
    Scroll = v1.Main._Scroll,
    Exit = v1.Top._Exit,
    Temp = v1.Main._Scroll._Temp
};