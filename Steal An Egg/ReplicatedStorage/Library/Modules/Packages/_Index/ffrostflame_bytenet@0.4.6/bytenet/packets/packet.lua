-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
require(script.Parent.Parent.types);
local client = require(script.Parent.Parent.process.client);
local server = require(script.Parent.Parent.process.server);
local u1 = RunService:IsServer() and "server" or "client";

return function(p2, u3) -- Line: 16
    -- upvalues: server (copy), client (copy), u1 (copy), Players (copy)
    local v4 = p2.reliabilityType or "reliable";
    local u5 = {};
    local u6;

    if v4 == "reliable" then
        u6 = server.sendPlayerReliable;
    else
        u6 = server.sendPlayerUnreliable;
    end;

    local u7;

    if v4 == "reliable" then
        u7 = server.sendAllReliable;
    else
        u7 = server.sendAllUnreliable;
    end;

    local u8;

    if v4 == "reliable" then
        u8 = client.sendReliable;
    else
        u8 = client.sendUnreliable;
    end;

    local write = p2.value.write;
    local v9 = {};
    setmetatable(v9, {
        __index = function(p10) -- Line: 43, Name: __index
            -- upvalues: u1 (ref)
            if (p10 == "sendTo" or (p10 == "sendToAllExcept" or p10 == "sendToAll")) and u1 == "client" then
                error("You cannot use sendTo, sendToAllExcept, or sendToAll on the client");

                return;
            end;

            if p10 == "send" and u1 == "server" then
                error("You cannot use send on the server");
            end;
        end
    });
    v9.reader = p2.value.read;

    if u1 == "server" then
        function v9.sendToList(p11, p12) -- Line: 59
            -- upvalues: u6 (copy), u3 (copy), write (copy)
            for _, v in p12 do
                u6(v, u3, write, p11);
            end;
        end;

        function v9.sendTo(p13, p14) -- Line: 65
            -- upvalues: u6 (copy), u3 (copy), write (copy)
            u6(p14, u3, write, p13);
        end;

        function v9.sendToAllExcept(p15, p16) -- Line: 69
            -- upvalues: Players (ref), u6 (copy), u3 (copy), write (copy)
            for _, v in Players:GetPlayers() do
                if v ~= p16 then
                    u6(v, u3, write, p15);
                end;
            end;
        end;

        function v9.sendToAll(p17) -- Line: 77
            -- upvalues: u7 (copy), u3 (copy), write (copy)
            u7(u3, write, p17);
        end;
    elseif u1 == "client" then
        function v9.send(p18) -- Line: 81
            -- upvalues: u8 (copy), u3 (copy), write (copy)
            u8(u3, write, p18);
        end;
    end;

    function v9.wait() -- Line: 86
        -- upvalues: u5 (copy)
        local u19 = nil;
        local u20 = coroutine.running();
        table.insert(u5, function(p21, p22) -- Line: 91
            -- upvalues: u20 (copy), u5 (ref), u19 (ref)
            task.spawn(u20, p21, p22);
            table.remove(u5, u19);
        end);
        u19 = #u5;

        return coroutine.yield();
    end;

    function v9.listen(p23) -- Line: 105
        -- upvalues: u5 (copy)
        table.insert(u5, p23);
    end;

    function v9.getListeners() -- Line: 109
        -- upvalues: u5 (copy)
        return u5;
    end;

    return v9;
end;