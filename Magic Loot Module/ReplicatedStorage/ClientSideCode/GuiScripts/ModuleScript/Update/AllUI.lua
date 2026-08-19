-- Decompiled with Potassium's decompiler.

local Update = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui", (1 / 0)):WaitForChild("ScreenGui", (1 / 0)):WaitForChild("Update", (1 / 0));
local v1 = Update:FindFirstChild("ContentClip") or Update;

return {
    UIRoot = Update,
    AnimClips = v1.Main._AnimClips,
    Tag = v1.Main._Tag,
    Exit = v1.Top._Exit,
    UpdateContent = v1.Main._AnimClips._UpdateContent,
    UpdatePanelTag = v1.Main._Tag._UpdatePanelTag,
    UpdateTagTemp = v1.Main._Tag._UpdatePanelTag._UpdateTagTemp,
    UpdateCfgTitle = v1.Main._AnimClips._UpdateContent.Title._UpdateCfgTitle
};