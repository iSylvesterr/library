-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local VoiceChatService = game:GetService("VoiceChatService");
local Cache = require(game.ReplicatedStorage.UserGenerated.Concurrency.Cache);
local Asserts = require(game.ReplicatedStorage.UserGenerated.Lang.Asserts);
local u2 = Cache.new({
    MaxAge = (1 / 0),

    Callback = function(p1) -- Line: 27, Name: Callback
        -- upvalues: VoiceChatService (copy)
        return VoiceChatService:IsVoiceEnabledForUserIdAsync(p1);
    end,

    AssertKey = Asserts.Integer
});
Players.PlayerRemoving:Connect(function(p3) -- Line: 34
    -- upvalues: Players (copy), u2 (copy)
    local UserId = p3.UserId;
    task.delay(60, function() -- Line: 37
        -- upvalues: Players (ref), UserId (copy), u2 (ref)
        if not Players:GetPlayerByUserId(UserId) then
            u2:Delete(UserId);
        end;
    end);
end);
task.spawn(function() -- Line: 43
    -- upvalues: u2 (copy), Players (copy)
    u2:GetAsync(Players.LocalPlayer.UserId);
end);

return table.freeze({
    IsVoiceEnabledForUserIdAsync = function(p4, p5) -- Line: 49, Name: IsVoiceEnabledForUserIdAsync
        -- upvalues: Asserts (copy), u2 (copy)
        Asserts.Integer(p4);
        Asserts.Optional(Asserts.Boolean)(p5);

        if p5 then
            return u2:Get(p4);
        end;

        return u2:GetAsync(p4);
    end
});