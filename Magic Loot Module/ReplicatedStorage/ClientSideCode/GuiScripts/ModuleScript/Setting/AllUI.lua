-- Decompiled with Potassium's decompiler.

local Setting = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).LocalPlayer:WaitForChild("PlayerGui", (1 / 0)):WaitForChild("ScreenGui", (1 / 0)):FindFirstChild("Setting");

if not (Setting and Setting:IsA("Frame")) then
    error("[Setting.AllUI] ScreenGui 下缺少 Setting Frame");
end;

local v1 = Setting:FindFirstChild("ContentClip") or Setting;

return {
    UIRoot = Setting,
    TopTab = v1._TopTab,
    ["滑动条bg"] = v1.BG["_滑动条bg"],
    ScrollingFrame = v1.Frame._ScrollingFrame,
    Exit = v1.Top._Exit,
    TabTemp = v1._TopTab._TabTemp,
    SecondFrame = v1.Frame._ScrollingFrame._SecondFrame,
    Temp = v1.Frame._ScrollingFrame._SecondFrame._Temp,
    TempBar = v1.Frame._ScrollingFrame._SecondFrame._TempBar,
    TempChoose = v1.Frame._ScrollingFrame._SecondFrame._TempChoose,
    TempInput = v1.Frame._ScrollingFrame._SecondFrame._TempInput
};