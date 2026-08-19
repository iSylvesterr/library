-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");

return function(u1, p2, p3) -- Line: 3
    -- upvalues: RunService (copy)
    RunService:BindToRenderStep(u1, p2, p3);

    return function() -- Line: 5
        -- upvalues: RunService (ref), u1 (copy)
        RunService:UnbindFromRenderStep(u1);
    end;
end;