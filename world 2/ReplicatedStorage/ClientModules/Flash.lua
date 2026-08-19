-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local u1 = {
    FadeInTime = 1,
    FadeOutTime = 1,
    HoldTime = 0,
    Transparency = 0,
    Color = Color3.new(1, 1, 1),
    FadeInEasingStyle = Enum.EasingStyle.Exponential,
    FadeInEasingDirection = Enum.EasingDirection.Out
};

local function GetHolder() -- Line: 32
    -- upvalues: Players (copy)
    local LocalPlayer = Players.LocalPlayer;

    if LocalPlayer then
        LocalPlayer = LocalPlayer:FindFirstChildOfClass("PlayerGui");
    end;

    if not LocalPlayer then
        return nil;
    end;

    local FlashGui = LocalPlayer:FindFirstChild("FlashGui");

    if FlashGui and FlashGui:IsA("ScreenGui") then
        return FlashGui;
    end;

    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "FlashGui";
    ScreenGui.DisplayOrder = 999;
    ScreenGui.IgnoreGuiInset = true;
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.Parent = LocalPlayer;

    return ScreenGui;
end;

return function(p2) -- Line: 54
    -- upvalues: u1 (copy), GetHolder (copy), TweenService (copy)
    local v3 = p2 or {};
    local u4 = v3.FadeInTime or u1.FadeInTime;
    local u5 = v3.FadeOutTime or u1.FadeOutTime;
    local u6 = v3.HoldTime or u1.HoldTime;
    local u7 = v3.Color or u1.Color;
    local u8 = v3.Transparency or u1.Transparency;
    local u9 = v3.FadeInEasingStyle or u1.FadeInEasingStyle;
    local u10 = v3.FadeInEasingDirection or u1.FadeInEasingDirection;
    task.spawn(function() -- Line: 64
        -- upvalues: GetHolder (ref), u7 (copy), u4 (copy), TweenService (ref), u9 (copy), u10 (copy), u8 (copy), u6 (copy), u5 (copy)
        local v11 = GetHolder();

        if not v11 then
            return;
        end;

        local Frame = Instance.new("Frame");
        Frame.BackgroundTransparency = 1;
        Frame.BackgroundColor3 = u7;
        Frame.Size = UDim2.fromScale(2, 2);
        Frame.AnchorPoint = Vector2.new(0.5, 0.5);
        Frame.Position = UDim2.fromScale(0.5, 0.5);
        Frame.BorderSizePixel = 0;
        Frame.Parent = v11;

        if u4 > 0 then
            TweenService:Create(Frame, TweenInfo.new(u4, u9, u10), {
                BackgroundTransparency = u8
            }):Play();
            task.wait(u4);
        else
            Frame.BackgroundTransparency = u8;
        end;

        task.wait(u6);

        if u5 > 0 then
            TweenService:Create(Frame, TweenInfo.new(u5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                BackgroundTransparency = 1
            }):Play();
            task.wait(u5);
        else
            Frame.BackgroundTransparency = 1;
        end;

        Frame:Destroy();
    end);
end;