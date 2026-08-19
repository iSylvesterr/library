-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
local v1 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0);
local UIPadding = script.Parent.Parent.Frame.Text_Element.UIPadding;
local u2 = TweenService:Create(UIPadding, v1, {
    PaddingLeft = UDim.new(0.04, 0)
});
local u3 = TweenService:Create(UIPadding, v1, {
    PaddingLeft = UDim.new(0, 0)
});
local ImageLabel = script.Parent.Parent.ImageLabel;
local ImageTransparency = script.Parent.Parent.ImageLabel.ImageTransparency;
local u4 = TweenService:Create(ImageLabel, v1, {
    ImageTransparency = 0
});
local u5 = TweenService:Create(ImageLabel, v1, {
    ImageTransparency = ImageTransparency
});
local Hover = game.SoundService.SFX.Hover;
script.Parent.MouseEnter:Connect(function() -- Line: 12
    -- upvalues: Hover (copy), u2 (copy), u4 (copy)
    Hover.PlaybackSpeed = 1 + math.random(-5, 5) / 100;
    Hover.Playing = true;
    Hover.TimePosition = 0;
    u2:Play();
    u4:Play();
end);
script.Parent.MouseLeave:Connect(function() -- Line: 19
    -- upvalues: u3 (copy), u5 (copy)
    u3:Play();
    u5:Play();
end);