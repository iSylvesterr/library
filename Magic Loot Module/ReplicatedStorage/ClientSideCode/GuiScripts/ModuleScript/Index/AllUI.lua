-- Decompiled with Potassium's decompiler.

local Index = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui", (1 / 0)):WaitForChild("ScreenGui", (1 / 0)):WaitForChild("Index", (1 / 0));
local v1 = Index:FindFirstChild("ContentClip") or Index;

return {
    UIRoot = Index,
    ["材料"] = v1.Bottom["_材料"],
    ["药水"] = v1.Bottom["_药水"],
    List = v1.Main._List,
    Title = v1.Main._Title,
    ["收集进度条"] = v1.Main["_收集进度条"],
    Exit = v1.Top._Exit,
    ["奖励图标"] = v1.Main["_收集进度条"]["增加容量"]["_奖励图标"],
    ["可领取"] = v1.Main["_收集进度条"]["增加容量"]["_奖励图标"]["_可领取"],
    ["奖励数值"] = v1.Main["_收集进度条"]["增加容量"]["_奖励图标"]["_奖励数值"]
};