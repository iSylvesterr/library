-- Decompiled with Potassium's decompiler.

local HttpService = game:GetService("HttpService");
local Asserts = require(game.ReplicatedStorage.UserGenerated.Lang.Asserts);
local v1 = Asserts.Set({ "GET", "HEAD", "POST", "PUT", "DELETE", "OPTIONS", "TRACE", "PATCH" });
local v2 = Asserts.Optional(Asserts.Enum(Enum.HttpCompression));
local u3 = Asserts.Table({
    Url = Asserts.String,
    Method = v1,
    Headers = Asserts.Optional(Asserts.Map(Asserts.String, Asserts.String)),
    Body = Asserts.Optional(Asserts.RawString),
    Compress = v2,
    NoCache = Asserts.Optional(Asserts.Boolean)
});

return table.freeze({
    AssertCompress = v2,
    AssertMethod = v1,
    AssertParams = u3,

    Execute = function(p4) -- Line: 69, Name: Execute
        -- upvalues: u3 (copy), HttpService (copy)
        u3(p4);
        local v5 = p4.Headers or {};

        if p4.NoCache then
            v5 = table.clone(v5);
            v5["Cache-Control"] = "no-cache, no-store, must-revalidate";
            v5.Pragma = "no-cache";
            v5.Expires = "0";
        end;

        local success, result = pcall(HttpService.RequestAsync, HttpService, {
            Url = p4.Url,
            Method = p4.Method,
            Headers = v5,
            Body = p4.Body,
            Compress = p4.Compress
        });

        return not success and {
            Success = false,
            StatusCode = 400,
            StatusMessage = tostring(result),
            Headers = {}
        } or result;
    end
});