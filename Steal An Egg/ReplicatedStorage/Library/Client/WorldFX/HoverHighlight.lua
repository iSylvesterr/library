-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Tween = require(ReplicatedStorage.Library.Functions.Tween);

return {
    FadeIn = function(p1, p2, p3) -- Line: 20, Name: FadeIn
        -- upvalues: Asserts (copy), Tween (copy)
        Asserts.Model(p1);
        Asserts.string(p2);
        Asserts.optional.number(p3);
        local Highlight = Instance.new("Highlight");
        Highlight.Name = p2;
        Highlight.Adornee = p1;
        Highlight.DepthMode = Enum.HighlightDepthMode.Occluded;
        Highlight.FillColor = Color3.new(1, 1, 1);
        Highlight.FillTransparency = 1;
        Highlight.OutlineColor = Color3.new(1, 1, 1);
        Highlight.OutlineTransparency = 1;
        Highlight.Parent = p1;
        Tween(Highlight, {
            OutlineTransparency = 0
        }, { p3 or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out });

        return Highlight;
    end,

    FadeOut = function(u4, p5) -- Line: 44, Name: FadeOut
        -- upvalues: Asserts (copy), Tween (copy)
        local v6 = u4:IsA("Highlight");
        assert(v6, "Expected Highlight");
        Asserts.optional.number(p5);
        Tween(u4, {
            OutlineTransparency = 1
        }, { p5 or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out }).Completed:Once(function(p7) -- Line: 52
            -- upvalues: u4 (copy)
            if p7 == Enum.PlaybackState.Completed then
                u4:Destroy();
            end;
        end);
    end
};