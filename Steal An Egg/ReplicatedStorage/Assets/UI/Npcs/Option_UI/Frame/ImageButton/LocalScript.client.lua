-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
local SoundService = game:GetService("SoundService");
local v1 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0);
local Parent = script.Parent.Parent;
local UIPadding = Parent.Frame.Text_Element.UIPadding;
local ImageLabel = Parent.ImageLabel;
local ImageColor3 = ImageLabel.ImageColor3;
local u2 = TweenService:Create(UIPadding, v1, {
    PaddingLeft = UDim.new(0.04, 0)
});
local u3 = TweenService:Create(UIPadding, v1, {
    PaddingLeft = UDim.new(0, 0)
});
local u4 = TweenService:Create(ImageLabel, v1, {
    ImageColor3 = Color3.fromRGB(255, 255, 255)
});
local u5 = TweenService:Create(ImageLabel, v1, {
    ImageColor3 = ImageColor3
});
local Hover = SoundService.Hover;
script.Parent.MouseEnter:Connect(function() -- Line: 18
    -- upvalues: Hover (copy), u2 (copy), u4 (copy)
    Hover.PlaybackSpeed = 1 + math.random(-5, 5) / 100;
    Hover.Playing = true;
    Hover.TimePosition = 0;
    u2:Play();
    u4:Play();
end);
script.Parent.MouseLeave:Connect(function() -- Line: 26
    -- upvalues: u3 (copy), u5 (copy)
    u3:Play();
    u5:Play();
end);