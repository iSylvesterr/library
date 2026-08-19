-- Decompiled with Potassium's decompiler.

return {
    StartOrder = 10,

    Start = function(p1) -- Line: 5, Name: Start
        for _, child in script:GetChildren() do
            if child:IsA("ModuleScript") then
                task.spawn(function() -- Line: 8
                    -- upvalues: child (copy)
                    require(child):Start();
                end);
            end;
        end;
    end
};