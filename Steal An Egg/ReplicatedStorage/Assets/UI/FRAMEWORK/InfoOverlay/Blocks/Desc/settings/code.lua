-- Decompiled with Potassium's decompiler.

local Rarity = game:GetService("ReplicatedStorage"):WaitForChild("Assets").UI.Rarity;

return function(p1, p2, p3, p4) -- Line: 4
    -- upvalues: Rarity (copy)
    p1.title.Text = p3;

    if p4 == "Exclusive" then
        p1.title.TextColor3 = Color3.new(1, 1, 1);
        local v5 = Rarity:FindFirstChild(p4);

        if v5 then
            v5:Clone().Parent = p1.title;
        end;
    end;
end;