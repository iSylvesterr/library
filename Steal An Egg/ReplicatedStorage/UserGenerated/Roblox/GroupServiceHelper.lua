-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local GroupService = game:GetService("GroupService");
local RunService = game:GetService("RunService");
local Cache = require(game.ReplicatedStorage.UserGenerated.Concurrency.Cache);
local Asserts = require(game.ReplicatedStorage.UserGenerated.Lang.Asserts);
local u2 = Cache.new({
    MaxAge = (1 / 0),

    Callback = function(p1) -- Line: 38, Name: Callback
        -- upvalues: GroupService (copy)
        return GroupService:GetGroupsAsync(p1);
    end,

    AssertKey = Asserts.Integer
});
Players.PlayerRemoving:Connect(function(p3) -- Line: 44
    -- upvalues: Players (copy), u2 (copy)
    local UserId = p3.UserId;
    task.delay(60, function() -- Line: 47
        -- upvalues: Players (ref), UserId (copy), u2 (ref)
        if not Players:GetPlayerByUserId(UserId) then
            u2:Delete(UserId);
        end;
    end);
end);

if RunService:IsServer() then
    Players.PlayerAdded:Connect(function(p4) -- Line: 54
        -- upvalues: u2 (copy)
        u2:GetAsync(p4.UserId);
    end);
else
    task.spawn(function() -- Line: 58
        -- upvalues: u2 (copy), Players (copy)
        u2:GetAsync(Players.LocalPlayer.UserId);
    end);
end;

return table.freeze({
    Cache = u2,

    GetGroupsAsync = function(p5, p6) -- Line: 67, Name: GetGroupsAsync
        -- upvalues: Asserts (copy), u2 (copy)
        Asserts.Integer(p5);
        Asserts.Optional(Asserts.Boolean)(p6);

        if p6 then
            return u2:Get(p5);
        end;

        return u2:GetAsync(p5);
    end
});