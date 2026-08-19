-- Decompiled with Potassium's decompiler.

local HttpService = game:GetService("HttpService");

return function(u1) -- Line: 32, Name: HTTP
    -- upvalues: HttpService (copy)
    local success, result = pcall(function() -- Line: 33
        -- upvalues: HttpService (ref), u1 (copy)
        return HttpService:RequestAsync(u1);
    end);

    return (not success or type(result) ~= "table") and {
        Success = false,
        StatusCode = 400,
        Body = nil,
        TransportError = true,
        StatusMessage = tostring(result),
        Headers = {}
    } or result;
end;