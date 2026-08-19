-- Decompiled with Potassium's decompiler.

local HttpService = game:GetService("HttpService");

return {
    Name = "json-array-encode",
    Description = "Encodes a comma-separated list into a JSON array",
    Group = "DefaultUtil",
    Aliases = {},
    Args = { {
            Type = "string",
            Name = "CSV",
            Description = "The comma-separated list"
        } },

    Run = function(p1, p2) -- Line: 16, Name: Run
        -- upvalues: HttpService (copy)
        return HttpService:JSONEncode(p2:split(","));
    end
};