-- Decompiled with Potassium's decompiler.

local StageJump = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui", (1 / 0)):WaitForChild("ScreenGui", (1 / 0)):WaitForChild("StageJump", (1 / 0));
local v1 = StageJump:FindFirstChild("ContentClip") or StageJump;

return {
    UIRoot = StageJump,
    Exit = v1.BG._Exit,
    ScrollingFrame = v1.Frame._ScrollingFrame,
    Temp = v1.Frame._ScrollingFrame._Temp
};