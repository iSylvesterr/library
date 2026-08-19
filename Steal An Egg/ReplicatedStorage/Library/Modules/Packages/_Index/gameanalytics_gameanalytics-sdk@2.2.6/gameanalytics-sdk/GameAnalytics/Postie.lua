-- Decompiled with Potassium's decompiler.

local HttpService = game:GetService("HttpService");
local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");

if not ReplicatedStorage:FindFirstChild("PostieSent") then
    local RemoteEvent = Instance.new("RemoteEvent");
    RemoteEvent.Name = "PostieSent";
    RemoteEvent.Parent = ReplicatedStorage;
end;

if not ReplicatedStorage:FindFirstChild("PostieReceived") then
    local RemoteEvent = Instance.new("RemoteEvent");
    RemoteEvent.Name = "PostieReceived";
    RemoteEvent.Parent = ReplicatedStorage;
end;

local PostieSent = ReplicatedStorage.PostieSent;
local PostieReceived = ReplicatedStorage.PostieReceived;
local u1 = RunService:IsServer();
local u2 = {};
local u3 = {};
local v21 = {
    invokeClient = function(p4, u5, p6, ...) -- Line: 81, Name: invokeClient
        -- upvalues: u1 (copy), HttpService (copy), u3 (copy), PostieSent (copy)
        assert(u1, "Postie.invokeClient can only be called from the server");
        local u7 = coroutine.running();
        local u8 = false;
        local u9 = HttpService:GenerateGUID(false);

        u3[u9] = function(p10, p11, ...) -- Line: 89
            -- upvalues: u5 (copy), u8 (ref), u3 (ref), u9 (copy), u7 (copy)
            if p10 ~= u5 then
                return;
            end;

            u8 = true;
            u3[u9] = nil;

            if p11 then
                task.spawn(u7, true, ...);

                return;
            end;

            task.spawn(u7, false);
        end;

        task.delay(p6, function() -- Line: 104
            -- upvalues: u8 (ref), u3 (ref), u9 (copy), u7 (copy)
            if u8 then
                return;
            end;

            u3[u9] = nil;
            task.spawn(u7, false);
        end);
        PostieSent:FireClient(u5, p4, u9, ...);

        return coroutine.yield();
    end,

    invokeServer = function(p12, p13, ...) -- Line: 118, Name: invokeServer
        -- upvalues: u1 (copy), HttpService (copy), u3 (copy), PostieSent (copy)
        assert(not u1, "Postie.invokeServer can only be called from the client");
        local u14 = coroutine.running();
        local u15 = false;
        local u16 = HttpService:GenerateGUID(false);

        u3[u16] = function(p17, ...) -- Line: 126
            -- upvalues: u15 (ref), u3 (ref), u16 (copy), u14 (copy)
            u15 = true;
            u3[u16] = nil;

            if p17 then
                task.spawn(u14, true, ...);

                return;
            end;

            task.spawn(u14, false);
        end;

        task.delay(p13, function() -- Line: 137
            -- upvalues: u15 (ref), u3 (ref), u16 (copy), u14 (copy)
            if u15 then
                return;
            end;

            u3[u16] = nil;
            task.spawn(u14, false);
        end);
        PostieSent:FireServer(p12, u16, ...);

        return coroutine.yield();
    end,

    setCallback = function(p18, p19) -- Line: 151, Name: setCallback
        -- upvalues: u2 (copy)
        u2[p18] = p19;
    end,

    getCallback = function(p20) -- Line: 155, Name: getCallback
        -- upvalues: u2 (copy)
        return u2[p20];
    end
};

if u1 then
    PostieReceived.OnServerEvent:Connect(function(p22, p23, p24, ...) -- Line: 161
        -- upvalues: u3 (copy)
        local v25 = u3[p23];

        if not v25 then
            return;
        end;

        v25(p22, p24, ...);
    end);
    PostieSent.OnServerEvent:Connect(function(p26, p27, p28, ...) -- Line: 170
        -- upvalues: u2 (copy), PostieReceived (copy)
        local v29 = u2[p27];

        if v29 then
            PostieReceived:FireClient(p26, p28, true, v29(p26, ...));

            return;
        end;

        PostieReceived:FireClient(p26, p28, false);
    end);

    return v21;
end;

PostieReceived.OnClientEvent:Connect(function(p30, p31, ...) -- Line: 180
    -- upvalues: u3 (copy)
    local v32 = u3[p30];

    if not v32 then
        return;
    end;

    v32(p31, ...);
end);
PostieSent.OnClientEvent:Connect(function(p33, p34, ...) -- Line: 189
    -- upvalues: u2 (copy), PostieReceived (copy)
    local v35 = u2[p33];

    if v35 then
        PostieReceived:FireServer(p34, true, v35(...));

        return;
    end;

    PostieReceived:FireServer(p34, false);
end);

return v21;