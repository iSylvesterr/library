-- Decompiled with Potassium's decompiler.

local u1;

if game:GetService("RunService"):IsServer() then
    u1 = require(game:GetService("ServerScriptService").UserGenerated.Analytics);
else
    u1 = nil;
end;

local function truncate(p2) -- Line: 13
    if type(p2) ~= "string" then
        return nil;
    end;

    if #p2 <= 500 then
        return p2;
    end;

    return string.sub(p2, 1, 500);
end;

return function(p3) -- Line: 26
    -- upvalues: u1 (copy)
    p3:RegisterHook("AfterRun", function(u4) -- Line: 27
        -- upvalues: u1 (ref)
        if not u1 then
            return;
        end;

        local Executor = u4.Executor;

        if typeof(Executor) ~= "Instance" or not Executor:IsA("Player") then
            return;
        end;

        if not pcall(function() -- Line: 37
            -- upvalues: u1 (ref), Executor (copy), u4 (copy)
            local v5 = {
                Command = u4.Name,
                Alias = u4.Alias
            };
            local RawText = u4.RawText;

            if type(RawText) == "string" then
                if #RawText > 500 then
                    RawText = string.sub(RawText, 1, 500);
                end;
            else
                RawText = nil;
            end;

            v5.RawText = RawText;
            v5.Group = u4.Group;
            local Response = u4.Response;

            if type(Response) == "string" then
                if #Response > 500 then
                    Response = string.sub(Response, 1, 500);
                end;
            else
                Response = nil;
            end;

            v5.Response = Response;
            u1:LogPlayerEvent(Executor, "PlayerAdminCommand", v5);
        end) then
            warn((`[CmdrService] AfterRun analytics log failed for {u4.Name}`));
        end;
    end);
end;