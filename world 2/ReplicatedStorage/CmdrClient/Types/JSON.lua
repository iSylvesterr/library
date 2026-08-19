-- Decompiled with Potassium's decompiler.

local HttpService = game:GetService("HttpService");

return function(p1) -- Line: 3
    -- upvalues: HttpService (copy)
    p1:RegisterType("json", {
        Validate = function(p2) -- Line: 5, Name: Validate
            -- upvalues: HttpService (ref)
            return pcall(HttpService.JSONDecode, HttpService, p2);
        end,

        Parse = function(p3) -- Line: 9, Name: Parse
            -- upvalues: HttpService (ref)
            return HttpService:JSONDecode(p3);
        end
    });
end;