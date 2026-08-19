-- Decompiled with Potassium's decompiler.

local HttpService = game:GetService("HttpService");
local Keys = require(game.ReplicatedStorage.UserGenerated.Lang.Keys);
local Asserts = require(game.ReplicatedStorage.UserGenerated.Lang.Asserts);
local JSONEncoder = require(game.ReplicatedStorage.UserGenerated.IO.JSONEncoder);
local u1 = {
    http = 80,
    https = 443
};
local v2 = Asserts.Optional(Asserts.Set(Keys(u1)));
local String = Asserts.String;
local v3 = Asserts.Optional(Asserts.IntegerRange(0, 65535));

local function v5(p4) -- Line: 34
    if type(p4) ~= "string" then
        error("string", 2);
    end;

    if not utf8.len(p4) then
        error("UTF8", 2);
    end;

    if #p4 > 0 and string.byte(p4, 1) ~= 47 then
        error("PathPrefix", 2);
    end;

    return p4;
end;

local u6 = Asserts.Map(Asserts.String, Asserts.Any);
local u7 = Asserts.Table({
    Protocol = v2,
    Host = String,
    Port = v3,
    Path = v5,
    Params = Asserts.Optional(u6),
    Fragment = Asserts.Optional(Asserts.String)
});
local u15 = {
    AssertProtocol = v2,
    AssertHost = String,
    AssertPort = v3,
    AssertPath = v5,
    AssertEncodeParams = u6,
    AssertParams = u7,

    EncodePath = function(p8) -- Line: 77, Name: EncodePath
        -- upvalues: Asserts (copy), HttpService (copy)
        Asserts.String(p8);

        return p8:gsub("([^/]+)", function(p9) -- Line: 79
            -- upvalues: HttpService (ref)
            return HttpService:UrlEncode(p9);
        end);
    end,

    EncodeParams = function(p10) -- Line: 85, Name: EncodeParams
        -- upvalues: u6 (copy), Keys (copy), JSONEncoder (copy), HttpService (copy)
        u6(p10);
        local v11 = Keys(p10);
        table.sort(v11);
        local v12 = {};

        for _, v in ipairs(v11) do
            local v13 = JSONEncoder.Compact(p10[v]);
            local v14 = HttpService:UrlEncode(v) .. "=" .. HttpService:UrlEncode(v13);
            table.insert(v12, v14);
        end;

        return table.concat(v12, "&");
    end
};

function u15.Build(p16) -- Line: 97
    -- upvalues: u7 (copy), u1 (copy), u15 (copy), HttpService (copy)
    u7(p16);
    local v17 = p16.Protocol or "https";
    local v18 = u1[v17] or 80;
    local v19 = p16.Port or v18;
    local v20 = {};
    table.insert(v20, v17);
    table.insert(v20, "://");
    table.insert(v20, p16.Host);

    if v19 ~= v18 then
        table.insert(v20, ":");
        local v21 = tostring(v19);
        table.insert(v20, v21);
    end;

    table.insert(v20, u15.EncodePath(p16.Path));
    local Params = p16.Params;

    if Params and next(Params) ~= nil then
        table.insert(v20, "?");
        table.insert(v20, u15.EncodeParams(Params));
    end;

    if p16.Fragment then
        table.insert(v20, "#");
        table.insert(v20, HttpService:UrlEncode(p16.Fragment));
    end;

    return table.concat(v20);
end;

return table.freeze(u15);