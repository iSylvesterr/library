-- Decompiled with Potassium's decompiler.

local u1 = nil;

local function v6(p2, p3, p4) -- Line: 3
    -- upvalues: u1 (ref)
    local v5 = p4 == nil and true or p4;

    for _, descendant in p2:GetDescendants() do
        if descendant:IsA("BasePart") then
            u1(descendant, p3);
            descendant.Anchored = v5;
        end;
    end;

    p3.Anchored = v5;
end;

u1 = function(p7, p8) -- Line: 15
    local WeldConstraint = Instance.new("WeldConstraint");
    WeldConstraint.Part0 = p7;
    WeldConstraint.Part1 = p8;
    WeldConstraint.Parent = p7;
    p7.Anchored = false;
end;

return {
    WeldDescendents = v6,
    WeldTo = u1
};