-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local LocalizationService = game:GetService("LocalizationService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Cache = require(ReplicatedStorage.UserGenerated.Concurrency.Cache);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local u3 = Cache.new({
    Callback = function(p1) -- Line: 29, Name: Callback
        -- upvalues: Players (copy), LocalizationService (copy)
        local v2 = Players:GetPlayerByUserId(p1);
        assert(v2, "PlayerNotOnline");

        return LocalizationService:GetCountryRegionForPlayerAsync(v2);
    end,

    AssertKey = Asserts.Integer
});
Players.PlayerRemoving:Connect(function(p4) -- Line: 36
    -- upvalues: Players (copy), u3 (copy)
    local UserId = p4.UserId;
    task.delay(60, function() -- Line: 39
        -- upvalues: Players (ref), UserId (copy), u3 (ref)
        if not Players:GetPlayerByUserId(UserId) then
            u3:Delete(UserId);
        end;
    end);
end);

if RunService:IsServer() then
    Players.PlayerAdded:Connect(function(p5) -- Line: 46
        -- upvalues: u3 (copy)
        u3:GetAsync(p5.UserId);
    end);
else
    task.spawn(function() -- Line: 50
        -- upvalues: u3 (copy), Players (copy)
        u3:GetAsync(Players.LocalPlayer.UserId);
    end);
end;

return table.freeze({
    GetCountryRegionForPlayerAsync = function(p6, p7) -- Line: 57, Name: GetCountryRegionForPlayerAsync
        -- upvalues: Asserts (copy), u3 (copy)
        Asserts.Player(p6);
        Asserts.Optional(Asserts.Boolean)(p7);

        if p7 then
            return u3:Get(p6.UserId);
        end;

        return u3:GetAsync(p6.UserId);
    end
});