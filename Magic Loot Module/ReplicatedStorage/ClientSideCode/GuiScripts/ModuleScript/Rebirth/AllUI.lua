-- Decompiled with Potassium's decompiler.

local Rebirth = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui", (1 / 0)):WaitForChild("ScreenGui", (1 / 0)):WaitForChild("Rebirth", (1 / 0));
local v1 = Rebirth:FindFirstChild("ContentClip") or Rebirth;

return {
    UIRoot = Rebirth,
    Frame = v1._Frame,
    MaxRebirth = v1._MaxRebirth,
    Exit = v1.BG._Exit,
    RebirthBtn = v1._Frame._RebirthBtn,
    SkipBtn = v1._Frame._SkipBtn,
    ["等级文本"] = v1._Frame.Progress.Progress["_等级文本"],
    ["等级进度条"] = v1._Frame.Progress.Progress["_等级进度条"],
    ["重生后经验倍率"] = v1._Frame.Next["经验加成"].Frame["_重生后经验倍率"],
    ["重生后金币倍率"] = v1._Frame.Next["金币加成"].Frame["__重生后金币倍率"],
    ["当前经验倍率"] = v1._Frame.Now["经验加成"].Frame["_当前经验倍率"],
    ["当前金币倍率"] = v1._Frame.Now["金币加成"].Frame["_当前金币倍率"]
};