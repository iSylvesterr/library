-- Decompiled with Potassium's decompiler.

local Holder = script.Parent.Holder;
local TweenService = game:GetService("TweenService");
local u1 = TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0);
Holder.Position = UDim2.new(1.25, 0, 0.5, 0);
local v2 = TweenService:Create(Holder, u1, {
    Position = UDim2.new(0.5, 0, 0.5, 0)
});
v2:Play();
game.Debris:AddItem(v2, u1.Time);
local v3 = { script.Parent };

for _, descendant in pairs(script.Parent:GetDescendants()) do
    if descendant:IsA("Frame") or (descendant:IsA("TextLabel") or (descendant:IsA("UIStroke") or (descendant:IsA("ImageLabel") or descendant:IsA("TextButton")))) then
        table.insert(v3, descendant);
    end;
end;

local u4 = {};

for _, v in pairs(v3) do
    if v:IsA("TextLabel") then
        local TextTransparency = v.TextTransparency;
        local TextStrokeTransparency = v.TextStrokeTransparency;
        v.TextTransparency = 1;
        v.TextStrokeTransparency = 1;
        local v5 = TweenService:Create(v, u1, {
            TextTransparency = TextTransparency,
            TextStrokeTransparency = TextStrokeTransparency
        });
        v5:Play();
        game.Debris:AddItem(v5, u1.Time);
        table.insert(u4, TweenService:Create(v, u1, {
            TextTransparency = 1,
            TextStrokeTransparency = 1
        }));
    elseif v:IsA("Frame") then
        local BackgroundTransparency = v.BackgroundTransparency;
        v.BackgroundTransparency = 1;
        local v6 = TweenService:Create(v, u1, {
            BackgroundTransparency = BackgroundTransparency
        });
        v6:Play();
        game.Debris:AddItem(v6, u1.Time);
        table.insert(u4, TweenService:Create(v, u1, {
            BackgroundTransparency = 1
        }));
    elseif v:IsA("UIStroke") then
        local Transparency = v.Transparency;
        v.Transparency = 1;
        local v7 = TweenService:Create(v, u1, {
            Transparency = Transparency
        });
        v7:Play();
        game.Debris:AddItem(v7, u1.Time);
        table.insert(u4, TweenService:Create(v, u1, {
            Transparency = 1
        }));
    elseif v:IsA("ImageLabel") then
        local ImageTransparency = v.ImageTransparency;
        local BackgroundTransparency = v.BackgroundTransparency;
        v.ImageTransparency = 1;
        v.BackgroundTransparency = 1;
        local v8 = TweenService:Create(v, u1, {
            ImageTransparency = ImageTransparency,
            BackgroundTransparency = BackgroundTransparency
        });
        v8:Play();
        game.Debris:AddItem(v8, u1.Time);
        table.insert(u4, TweenService:Create(v, u1, {
            ImageTransparency = 1,
            BackgroundTransparency = 1
        }));
    elseif v:IsA("TextButton") then
        local TextTransparency = v.TextTransparency;
        local BackgroundTransparency = v.BackgroundTransparency;
        v.TextTransparency = 1;
        v.BackgroundTransparency = 1;
        local v9 = TweenService:Create(v, u1, {
            TextTransparency = TextTransparency,
            BackgroundTransparency = BackgroundTransparency
        });
        v9:Play();
        game.Debris:AddItem(v9, u1.Time);
        table.insert(u4, TweenService:Create(v, u1, {
            TextTransparency = 1,
            BackgroundTransparency = 1
        }));
    end;
end;

task.spawn(function() -- Line: 89
    -- upvalues: u4 (copy), u1 (copy)
    task.wait(30);

    if script.Parent then
        for _, v in pairs(u4) do
            v:Play();
        end;

        game.Debris:AddItem(script.Parent, u1.Time);
    end;
end);