-- Decompiled with Potassium's decompiler.

local TopLayer = game:GetService("Workspace"):WaitForChild("Baseplate"):WaitForChild("TopLayer");

return table.freeze({
    Get = function() -- Line: 19, Name: Get
        -- upvalues: TopLayer (copy)
        return TopLayer.Position.Y + TopLayer.Size.X * 0.5 + 0.347;
    end
});