-- Decompiled with Potassium's decompiler.

return {
    WeldDescendents = function(p1, p2, p3) -- Line: 2
        for _, descendant in p1:GetDescendants() do
            if descendant:IsA("BasePart") then
                if descendant == p2 then
                    descendant.CanCollide = false;
                    descendant.Anchored = p3;
                else
                    descendant.CanCollide = false;
                    descendant.Anchored = p3;
                    local WeldConstraint = Instance.new("WeldConstraint");
                    WeldConstraint.Part0 = descendant;
                    WeldConstraint.Part1 = p2;
                    WeldConstraint.Parent = descendant;
                end;
            end;
        end;
    end
};