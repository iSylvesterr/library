-- Decompiled with Potassium's decompiler.

local function setupTool(p1) -- Line: 9
    if p1:IsA("Tool") then
        p1.CanBeDropped = false;
    end;

    local Handle = p1:FindFirstChild("Handle");

    if not Handle then
        return nil;
    end;

    for _, descendant in p1:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.CanTouch = false;
            descendant.Massless = true;

            if descendant.Name ~= "Handle" then
                local WeldConstraint = Instance.new("WeldConstraint");
                WeldConstraint.Part0 = descendant;
                WeldConstraint.Part1 = Handle;
                WeldConstraint.Parent = descendant;
                descendant.Anchored = false;
                descendant.CanCollide = false;
                Handle.CanCollide = false;
                Handle.Anchored = false;
            end;
        end;
    end;
end;

return {
    setupTool = setupTool,

    basePartToTool = function(p2) -- Line: 35, Name: basePartToTool
        -- upvalues: setupTool (copy)
        if p2:IsA("Tool") then
            return p2;
        end;

        if p2:IsA("BasePart") then
            local Tool = Instance.new("Tool");
            Tool.Name = p2.Name;
            p2.Name = "Handle";
            p2.Anchored = false;
            p2.Massless = true;
            p2.Parent = Tool;
            setupTool(Tool);

            return Tool;
        end;

        if not p2:IsA("Model") then
            return nil;
        end;

        local Tool = Instance.new("Tool");
        Tool.Name = p2.Name;
        p2.Parent = Tool;

        for _, child in p2:GetChildren() do
            child.Parent = Tool;
        end;

        p2:Destroy();
        setupTool(Tool);

        return Tool;
    end
};