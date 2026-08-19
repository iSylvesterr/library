-- Decompiled with Potassium's decompiler.

return function() -- Line: 6
    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "cover_Moon2Cutscene";
    ScreenGui.IgnoreGuiInset = true;
    local Frame = Instance.new("Frame", ScreenGui);
    Frame.Name = "FadeFrame";
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.BackgroundTransparency = 1;
    Frame.BackgroundColor3 = Color3.new(0, 0, 0);
    ScreenGui.Parent = game:GetService("Players").LocalPlayer.PlayerGui;

    return Frame;
end;