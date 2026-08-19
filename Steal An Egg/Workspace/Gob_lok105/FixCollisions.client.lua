-- Decompiled with Potassium's decompiler.

local u1 = { "UpperTorso", "LowerTorso" };

local function processDescendant(p2) -- Line: 10
    -- upvalues: u1 (copy)
    if p2:IsA("BasePart") and table.find(u1, p2.Name) then
        p2.CanCollide = false;
    end;
end;

local function disableCollisions(p3) -- Line: 16
    -- upvalues: u1 (copy)
    for _, descendant in ipairs(p3:GetDescendants()) do
        if descendant:IsA("BasePart") and table.find(u1, descendant.Name) then
            descendant.CanCollide = false;
        end;
    end;
end;

while task.wait(0.4) do
    for _, descendant in ipairs(script.Parent:GetDescendants()) do
        if descendant:IsA("BasePart") and table.find(u1, descendant.Name) then
            descendant.CanCollide = false;
        end;
    end;
end;