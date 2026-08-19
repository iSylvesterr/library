-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 7
    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "vignette_Moon2Cutscene";
    ScreenGui.ClipToDeviceSafeArea = false;
    ScreenGui.IgnoreGuiInset = true;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
    ImageLabel.ImageTransparency = 0.5;
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.Image = p1 or "rbxassetid://12175750943";
    ImageLabel.Parent = ScreenGui;
    ScreenGui.Parent = game:GetService("Players").LocalPlayer.PlayerGui;

    return function() -- Line: 23
        -- upvalues: ScreenGui (copy)
        ScreenGui:Destroy();
    end, ScreenGui, ImageLabel;
end;