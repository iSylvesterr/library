-- Decompiled with Potassium's decompiler.

local v1 = {};
local Players = game:GetService("Players");
local UserService = game:GetService("UserService");
local u2 = {};
local u3 = {};

function v1.FetchIcon(p4, u5, u6, u7) -- Line: 12
    -- upvalues: u2 (copy), Players (copy)
    if not u2[u5] then
        u2[u5] = {};
    end;

    if not u2[u5][u6] then
        u2[u5][u6] = {};
    end;

    if not u2[u5][u6][u7] then
        local v8 = false;
        local v9 = 0;

        while not v8 do
            local v10;
            v8, v10 = pcall(function() -- Line: 27
                -- upvalues: u2 (ref), u5 (copy), u6 (copy), u7 (copy), Players (ref)
                u2[u5][u6][u7] = Players:GetUserThumbnailAsync(u5, u6, u7);
            end);

            if not v8 then
                v9 = v9 + 1;
            end;

            if v9 > 3 then
                return "";
            end;
        end;
    end;

    return u2[u5][u6][u7];
end;

function v1.FetchDisplayName(p11, u12) -- Line: 48
    -- upvalues: u3 (copy), UserService (copy)
    if not u3[u12] then
        local v13 = false;
        local v14 = 0;

        while not v13 do
            local v15;
            v13, v15 = pcall(function() -- Line: 55
                -- upvalues: u3 (ref), u12 (copy), UserService (ref)
                u3[u12] = UserService:GetUserInfosByUserIdsAsync({ (tonumber(u12)) })[1].DisplayName;
            end);

            if not v13 then
                v14 = v14 + 1;
            end;

            if v14 > 3 then
                return tostring(u12);
            end;
        end;
    end;

    return u3[u12];
end;

return v1;