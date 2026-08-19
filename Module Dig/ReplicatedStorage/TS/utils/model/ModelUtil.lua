-- Decompiled with Potassium's decompiler.

return {
    GivePrimaryPart = function(p1) -- Line: 2
        if p1.PrimaryPart then
            return nil;
        end;

        local v2, v3 = p1:GetBoundingBox();
        local Part = Instance.new("Part");
        Part.Size = v3;
        Part.CFrame = v2;
        Part.CanCollide = false;
        Part.Anchored = false;
        Part.Transparency = 1;
        Part.Parent = p1;
        local v4 = {};

        for _, descendant in p1:GetDescendants() do
            if descendant:IsA("BasePart") and descendant ~= Part then
                table.insert(v4, descendant);
            end;
        end;

        for _, v in v4 do
            local WeldConstraint = Instance.new("WeldConstraint");
            WeldConstraint.Part0 = v;
            WeldConstraint.Part1 = Part;
            WeldConstraint.Parent = v;
        end;

        if #v4 == 0 then
            return nil;
        end;

        local v5 = v4[math.random(1, #v4) + 1];
        local WeldConstraint = Instance.new("WeldConstraint");
        WeldConstraint.Part0 = Part;
        WeldConstraint.Part1 = v5;
        WeldConstraint.Parent = Part;
        p1.PrimaryPart = Part;

        return Part;
    end
};