-- Decompiled with Potassium's decompiler.

local v1 = {};
local TweenService = game:GetService("TweenService");
local Lighting = game:GetService("Lighting");
local u2 = Lighting:FindFirstChild("Blur") or Instance.new("BlurEffect", Lighting);

function v1.SetBlur(p3, p4) -- Line: 7
    -- upvalues: TweenService (copy), u2 (copy)
    local v5 = p4 or 0.3;
    local v6 = TweenService:Create(u2, TweenInfo.new(v5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = p3
    });
    v6:Play();
    game.Debris:AddItem(v6, v5);
end;

return v1;