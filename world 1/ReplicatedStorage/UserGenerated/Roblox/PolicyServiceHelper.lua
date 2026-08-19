-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local PolicyService = game:GetService("PolicyService");
local RunService = game:GetService("RunService");
local Cache = require(game.ReplicatedStorage.UserGenerated.Concurrency.Cache);
local Asserts = require(game.ReplicatedStorage.UserGenerated.Lang.Asserts);
local u1 = {
    Discord = 0,
    Facebook = 1,
    Twitch = 2,
    YouTube = 3,
    X = 4,
    GitHub = 5,
    Guilded = 6
};
table.freeze(u1);
local u4 = Cache.new({
    Callback = function(p2) -- Line: 50, Name: Callback
        -- upvalues: Players (copy), PolicyService (copy)
        local v3 = Players:GetPlayerByUserId(p2);
        assert(v3, "PlayerNotOnline");

        return PolicyService:GetPolicyInfoForPlayerAsync(v3);
    end,

    AssertKey = Asserts.Integer
});
Players.PlayerRemoving:Connect(function(p5) -- Line: 57
    -- upvalues: Players (copy), u4 (copy)
    local UserId = p5.UserId;
    task.delay(60, function() -- Line: 60
        -- upvalues: Players (ref), UserId (copy), u4 (ref)
        if not Players:GetPlayerByUserId(UserId) then
            u4:Delete(UserId);
        end;
    end);
end);

if RunService:IsServer() then
    Players.PlayerAdded:Connect(function(p6) -- Line: 67
        -- upvalues: u4 (copy)
        u4:GetAsync(p6.UserId);
    end);
end;

return table.freeze({
    ExternalLinkReference = u1,

    ExternalLinkReferencesToInts = function(p7) -- Line: 77, Name: ExternalLinkReferencesToInts
        -- upvalues: u1 (copy)
        local v8 = {};

        for _, v in ipairs(p7) do
            local v9 = u1[v];

            if v9 then
                table.insert(v8, v9);
            end;
        end;

        return v8;
    end,

    GetPolicyInfoForPlayerAsync = function(p10, p11) -- Line: 90, Name: GetPolicyInfoForPlayerAsync
        -- upvalues: Asserts (copy), u4 (copy)
        Asserts.Player(p10);
        Asserts.Optional(Asserts.Boolean)(p11);

        if p11 then
            return u4:Get(p10.UserId);
        end;

        return u4:GetAsync(p10.UserId);
    end
});