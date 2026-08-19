-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local Modules = ReplicatedStorage:WaitForChild("Library"):WaitForChild("Modules");
local u14 = require(Modules.SmartCache).new(15, 3600, 60, function(p1) -- Line: 9
    -- upvalues: Players (copy)
    local v2 = p1:split("-");
    local v3 = tonumber(v2[1]);
    local v4 = `missing userid for key {p1}`;
    assert(v3, v4);
    local v5 = Enum.ThumbnailType[v2[2]];
    local v6 = `missing thumbnail type for: {p1}`;
    assert(v5, v6);
    local v7 = Enum.ThumbnailSize[v2[3]];
    local v8 = `missing thumbnail size for: {p1}`;
    assert(v7, v8);
    local v9 = Players:GetUserThumbnailAsync(v3, v5, v7);
    local v10 = type(v9) == "string";
    local v11 = `thumbnail url is not a string for key {p1}`;
    assert(v10, v11);
    local v12;

    if #v9 > 0 then
        v12 = #v9 <= 100;
    else
        v12 = false;
    end;

    local v13 = `thumbnail url length is invalid for key {p1}`;
    assert(v12, v13);

    return true, v9;
end);

return function(p15, p16, p17) -- Line: 25
    -- upvalues: u14 (copy)
    local v18 = p15 .. "-" .. p16.Name .. "-" .. p17.Name;

    return u14.get(v18, nil, true) or u14.get(v18);
end;