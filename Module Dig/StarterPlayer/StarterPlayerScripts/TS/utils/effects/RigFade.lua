-- Decompiled with Potassium's decompiler.

local TweenService = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").TweenService;

return {
    RigFade = {
        fadeIn = function(p1, p2) -- Line: 7, Name: fadeIn
            -- upvalues: TweenService (copy)
            local v3 = TweenInfo.new(p2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

            for _, descendant in p1:GetDescendants() do
                if descendant:IsA("BasePart") and descendant.Transparency < 1 then
                    local Transparency = descendant.Transparency;
                    descendant.Transparency = 1;
                    TweenService:Create(descendant, v3, {
                        Transparency = Transparency
                    }):Play();
                elseif descendant:IsA("Decal") and descendant.Transparency < 1 then
                    local Transparency = descendant.Transparency;
                    descendant.Transparency = 1;
                    TweenService:Create(descendant, v3, {
                        Transparency = Transparency
                    }):Play();
                end;
            end;
        end,

        fadeOut = function(p4, p5) -- Line: 26, Name: fadeOut
            -- upvalues: TweenService (copy)
            local v6 = TweenInfo.new(p5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

            for _, descendant in p4:GetDescendants() do
                if descendant:IsA("BasePart") and descendant.Transparency < 1 then
                    TweenService:Create(descendant, v6, {
                        Transparency = 1
                    }):Play();
                elseif descendant:IsA("Decal") and descendant.Transparency < 1 then
                    TweenService:Create(descendant, v6, {
                        Transparency = 1
                    }):Play();
                end;
            end;
        end
    }
};