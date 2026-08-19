-- Decompiled with Potassium's decompiler.

return {
    Start = function(p1) -- Line: 3, Name: Start
        for _, child in script:GetChildren() do
            task.spawn(function() -- Line: 9
                -- upvalues: child (copy)
                require(child)();
            end);
        end;
    end
};