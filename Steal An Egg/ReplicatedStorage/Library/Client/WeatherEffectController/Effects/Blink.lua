-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
local Workspace = game:GetService("Workspace");
require(script:FindFirstAncestor("Effects").Parent.Types);
local v1 = {};
local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect");
ColorCorrectionEffect.Brightness = 0;
ColorCorrectionEffect.TintColor = Color3.fromRGB(255, 255, 255);
ColorCorrectionEffect.Parent = Workspace.CurrentCamera;
local u2 = TweenService:Create(ColorCorrectionEffect, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
    Brightness = 0
});

function v1.Activate() -- Line: 18
    -- upvalues: ColorCorrectionEffect (copy), u2 (copy)
    ColorCorrectionEffect.Brightness = 10;
    u2:Cancel();
    u2:Play();
end;

return v1;