-- Decompiled with Potassium's decompiler.

local Login = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui", (1 / 0)):WaitForChild("ScreenGui", (1 / 0)):WaitForChild("Login", (1 / 0));
local v1 = Login:FindFirstChild("ContentClip") or Login;

return {
    UIRoot = Login,
    LoginFrame = v1.Main._LoginFrame,
    Exit = v1.Top._Exit,
    BigFrame = v1.Main._LoginFrame._BigFrame,
    Temp = v1.Main._LoginFrame.SmallTemp._Temp,
    BigTemp = v1.Main._LoginFrame._BigFrame._BigTemp
};