-- Decompiled with Potassium's decompiler.

local Map = game:GetService("Workspace"):WaitForChild("World"):WaitForChild("Map");

local function optimizeModel(p1) -- Line: 43
    if not p1:IsA("Model") then
        return;
    end;

    for _, descendant in p1:GetDescendants() do
        if descendant:IsA("BasePart") and descendant.CanTouch then
            descendant.CanTouch = false;
        end;
    end;
end;

local function watchFolder(p2) -- Line: 53
    -- upvalues: optimizeModel (copy)
    for _, child in p2:GetChildren() do
        task.spawn(optimizeModel, child);
    end;

    p2.ChildAdded:Connect(function(p3) -- Line: 58
        -- upvalues: optimizeModel (ref)
        task.defer(optimizeModel, p3);
        p3.DescendantAdded:Connect(function(p4) -- Line: 63
            if p4:IsA("BasePart") and p4.CanTouch then
                p4.CanTouch = false;
            end;
        end);
    end);
end;

for _, v in { { "PlacedItems", "Client" }, { "Plants", "Client" }, { "PottedPlants", "Client" } } do
    task.spawn(function() -- Line: 72
        -- upvalues: Map (copy), v (copy), watchFolder (copy)
        local v5 = Map;

        for _, v2 in v do
            v5 = v5:WaitForChild(v2, 30);

            if not v5 then
                return;
            end;
        end;

        watchFolder(v5);
    end);
end;