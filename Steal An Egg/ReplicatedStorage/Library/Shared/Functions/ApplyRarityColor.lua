-- Decompiled with Potassium's decompiler.

local Assets = game:GetService("ReplicatedStorage"):WaitForChild("Assets");

return function(p1, p2) -- Line: 4
    -- upvalues: Assets (copy)
    Assets:WaitForChild("UI"):WaitForChild("Rarity"):WaitForChild(p2):WaitForChild("Gradient"):Clone().Parent = p1;
end;