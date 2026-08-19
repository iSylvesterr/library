-- Decompiled with Potassium's decompiler.

return {
    Solve = function(p1, p2) -- Line: 9, Name: Solve
        return p2.Instances[1].WorldPosition, p2.Instances[2].WorldPosition - p2.Instances[1].WorldPosition;
    end,

    UpdateToNextPosition = function(p3, p4) -- Line: 16, Name: UpdateToNextPosition
        return p4.Instances[1].WorldPosition;
    end,

    Visualize = function(p5, p6) -- Line: 20, Name: Visualize
        return CFrame.lookAt(p6.Instances[1].WorldPosition, p6.Instances[2].WorldPosition);
    end
};