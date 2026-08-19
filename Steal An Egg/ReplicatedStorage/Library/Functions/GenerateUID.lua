-- Decompiled with Potassium's decompiler.

local HttpService = game:GetService("HttpService");

return function() -- Line: 3
    -- upvalues: HttpService (copy)
    return HttpService:GenerateGUID(false):gsub("-", ""):lower();
end;