-- Decompiled with Potassium's decompiler.

local Parent = script.Parent;
local Result = Parent.Result;
Parent:BindToMessageParallel("GetPartsInPart", function(p1, p2, p3) -- Line: 7
    -- upvalues: Result (copy)
    task.defer(Result.Fire, Result, p1:GetPartsInPart(p3, p2));
end);