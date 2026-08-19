-- Decompiled with Potassium's decompiler.

local Assets = game:GetService("ReplicatedStorage"):WaitForChild("Assets");

function UpdateUI(p1, p2, p3, p4, p5)
    -- upvalues: Assets (copy)
    p1.title.Text = p3;

    if typeof(p5) == "Color3" then
        p1.title.TextColor3 = p5;
    end;

    if p4 == "Mythical" or p4 == "Exclusive" then
        p1.title.TextColor3 = Color3.new(1, 1, 1);
        Assets.UI.Rarity:FindFirstChild(p4):Clone().Parent = p1.title;
    end;

    local v6 = string.find(p3, "<.->") ~= nil;
    p1.title.RichText = v6;
end;

return UpdateUI;