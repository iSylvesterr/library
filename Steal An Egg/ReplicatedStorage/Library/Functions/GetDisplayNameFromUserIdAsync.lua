-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserService = game:GetService("UserService");
local u8 = require(ReplicatedStorage.Library.Modules.SmartCache).new(15, 3600, 60, function(p1) -- Line: 12
    -- upvalues: Players (copy), UserService (copy)
    local v2 = Players:GetPlayerByUserId(p1);

    if v2 then
        return true, v2.DisplayName;
    end;

    local v3 = UserService:GetUserInfosByUserIdsAsync({ p1 })[1];
    local v4 = `Missing user info for user id {p1}`;
    assert(v3 ~= nil, v4);
    local DisplayName = v3.DisplayName;
    local v5 = type(DisplayName) == "string";
    local v6 = `Invalid display name payload for user id {p1}`;
    assert(v5, v6);
    local v7 = `Empty display name for user id {p1}`;
    assert(#DisplayName > 0, v7);

    return true, DisplayName;
end);

return function(p9) -- Line: 31
    -- upvalues: u8 (copy)
    local v10 = u8.get(p9, nil, true) or u8.get(p9);
    local v11 = type(v10) == "string";
    local v12 = `Cached display name must be a string for user id {p9}`;
    assert(v11, v12);

    return v10;
end;