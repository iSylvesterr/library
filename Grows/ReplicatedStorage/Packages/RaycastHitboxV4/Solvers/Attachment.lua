-- Decompiled with Potassium's decompiler.

return {
    Solve = function(p1, p2) -- Line: 9, Name: Solve
        if not p2.LastPosition then
            p2.LastPosition = p2.Instances[1].WorldPosition;
        end;

        return p2.LastPosition, p2.Instances[1].WorldPosition - p2.LastPosition;
    end,

    UpdateToNextPosition = function(p3, p4) -- Line: 21, Name: UpdateToNextPosition
        return p4.Instances[1].WorldPosition;
    end,

    Visualize = function(p5, p6) -- Line: 25, Name: Visualize
        return CFrame.lookAt(p6.Instances[1].WorldPosition, p6.LastPosition);
    end
};