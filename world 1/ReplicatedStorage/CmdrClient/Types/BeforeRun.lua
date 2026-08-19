-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local DevAllowedIDs = require(ReplicatedStorage.SharedModules.DevAllowedIDs);
local u1;

if RunService:IsServer() then
    u1 = require(game:GetService("ServerScriptService").UserGenerated.Analytics);
else
    u1 = nil;
end;

local u2 = {
    fillgarden = 132935919810877,
    fg = 132935919810877
};

local function truncate(p3) -- Line: 21
    if type(p3) ~= "string" then
        return nil;
    end;

    if #p3 <= 500 then
        return p3;
    end;

    return string.sub(p3, 1, 500);
end;

return function(p4) -- Line: 31
    -- upvalues: u2 (copy), DevAllowedIDs (copy), u1 (copy)
    p4:RegisterHook("BeforeRun", function(u5) -- Line: 32
        -- upvalues: u2 (ref), DevAllowedIDs (ref), u1 (ref)
        local v6 = u2[u5.Name];

        if v6 and game.PlaceId == v6 then
            return;
        end;

        if not (DevAllowedIDs.IsAllowed(u5.Executor.UserId) or game:GetService("RunService"):IsStudio()) then
            local Executor = u5.Executor;

            if u1 and (typeof(Executor) == "Instance" and Executor:IsA("Player")) then
                pcall(function() -- Line: 44
                    -- upvalues: u1 (ref), Executor (copy), u5 (copy)
                    local v7 = {
                        Command = u5.Name
                    };
                    local RawText = u5.RawText;

                    if type(RawText) == "string" then
                        if #RawText > 500 then
                            RawText = string.sub(RawText, 1, 500);
                        end;
                    else
                        RawText = nil;
                    end;

                    v7.RawText = RawText;
                    u1:LogPlayerEvent(Executor, "PlayerAdminCommandDenied", v7);
                end);
            end;

            return "Not allowed";
        end;
    end);
end;