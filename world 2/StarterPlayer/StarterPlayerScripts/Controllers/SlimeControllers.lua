-- Decompiled with Potassium's decompiler.

local v1 = {};
local u2 = game.ReplicatedStorage.Assets["Venom Spitter Slime"];
local TweenService = game:GetService("TweenService");
local u3 = TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out, 0, false, 0);
local u4 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0);
local u5 = TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0);

function v1.Init(p6) -- Line: 11
end;

function v1.AddSlime(p7, p8) -- Line: 15
    -- upvalues: u2 (copy), TweenService (copy), u3 (copy), u4 (copy)
    if p8 then
        for _, child in pairs(p8:GetChildren()) do
            if child:IsA("BasePart") and child.Name ~= u2.Name then
                local v9 = u2:Clone();
                v9.Size = child.Size * 1.2;
                v9.CFrame = child.CFrame;
                v9.Parent = p8;
                v9.Transparency = 1;
                local WeldConstraint = Instance.new("WeldConstraint");
                WeldConstraint.Part0 = child;
                WeldConstraint.Part1 = v9;
                WeldConstraint.Parent = v9;
                local v10 = TweenService:Create(v9, u3, {
                    Size = child.Size * 1.3
                });
                v10:Play();
                game.Debris:AddItem(v10, u3.Time);
                TweenService:Create(v9, u4, {
                    Transparency = 0.4
                }):Play();
            end;
        end;
    end;
end;

function v1.RemoveSlime(p11, p12) -- Line: 40
    -- upvalues: u2 (copy), TweenService (copy), u5 (copy)
    if p12 then
        for _, child in pairs(p12:GetChildren()) do
            if child:IsA("BasePart") and child.Name == u2.Name then
                local v13 = TweenService:Create(child, u5, {
                    Transparency = 1
                });
                v13:Play();
                game.Debris:AddItem(v13, u5.Time);
                game.Debris:AddItem(child, u5.Time);
            end;
        end;
    end;
end;

return v1;