-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
local Debris = game:GetService("Debris");
local Bubble = game:GetService("ReplicatedStorage").Assets.Models.Effects.Bubble;

return {
    CreateBubble = function(p1, p2, p3, p4, p5) -- Line: 10, Name: CreateBubble
        -- upvalues: Bubble (copy), Debris (copy), TweenService (copy)
        local v6 = Bubble:Clone();
        v6.CFrame = p1;
        v6.Anchored = true;
        v6.CanCollide = false;
        v6.Massless = true;
        v6.Material = Enum.Material.Glass;
        v6.Size = p2;
        v6.Transparency = p3;
        v6.Parent = workspace.__DEBRIS;
        Debris:AddItem(v6, p5);
        TweenService:Create(v6, TweenInfo.new(p5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {
            Transparency = 1,
            Size = p4
        }):Play();

        return v6;
    end
};