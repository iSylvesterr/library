-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u1 = require(ReplicatedStorage.Library.Modules.Packages.Log).new();
local Signal = require(ReplicatedStorage.Library.Modules.Packages.Signal);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local u2 = {};
local u3 = {
    CacheUpdated = Signal.new()
};

local function updateFriendCache(u4) -- Line: 32
    -- upvalues: Players (copy), Constants (copy), u2 (copy), u1 (copy), u3 (copy)
    local success, result = pcall(function() -- Line: 33
        -- upvalues: Players (ref), u4 (copy), Constants (ref)
        local v5 = Players:GetFriendsAsync(u4.UserId);
        local v6 = {};

        while true do
            for _, v in ipairs(v5:GetCurrentPage()) do
                table.insert(v6, v.Id);
            end;

            if v5.IsFinished then
                return v6;
            end;

            v5:AdvanceToNextPageAsync();

            if Constants.IS_CLIENT then
                task.wait(0.05);
            end;
        end;
    end);
    local v7 = not success and ({} or result) or result;

    if u4.Parent then
        local v8 = {};

        for _, v in ipairs(v7) do
            v8[v] = true;
        end;

        u2[u4] = {
            List = v7,
            Set = v8
        };
    end;

    if not success then
        u1:AtWarning():Log(`Failed to get friends for {u4.Name}: {result}, cache:`, u2);
    end;

    u3.CacheUpdated:Fire(u4);
end;

Players.PlayerAdded:Connect(updateFriendCache);
Players.PlayerRemoving:Connect(function(p9) -- Line: 73
    -- upvalues: u2 (copy)
    u2[p9] = nil;
end);

for _, v in ipairs(Players:GetPlayers()) do
    task.spawn(updateFriendCache, v);
end;

function u3.GetCountByPlayer(p10) -- Line: 85
    -- upvalues: u2 (copy), Players (copy)
    local v11 = u2[p10];

    if not v11 then
        return 0;
    end;

    local v12 = 0;

    for _, v in ipairs(v11.List) do
        if Players:GetPlayerByUserId(v) ~= nil then
            v12 = v12 + 1;
        end;
    end;

    return v12;
end;

function u3.GetFriendIdsByPlayer(p13) -- Line: 99
    -- upvalues: u2 (copy)
    local v14 = u2[p13];

    return not v14 and {} or table.clone(v14.List);
end;

function u3.GetFriendIdSetByPlayer(p15) -- Line: 108
    -- upvalues: u2 (copy)
    local v16 = u2[p15];

    return not v16 and {} or table.clone(v16.Set);
end;

return u3;