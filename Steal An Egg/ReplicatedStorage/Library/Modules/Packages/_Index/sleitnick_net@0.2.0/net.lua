-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");

return {
    RemoteEvent = function(p1, p2) -- Line: 25, Name: RemoteEvent
        -- upvalues: RunService (copy)
        local v3 = "RE/" .. p2;

        if RunService:IsServer() then
            local v4 = script:FindFirstChild(v3);

            if not v4 then
                v4 = Instance.new("RemoteEvent");
                v4.Name = v3;
                v4.Parent = script;
            end;

            return v4;
        end;

        local v5 = script:WaitForChild(v3, 10);

        if not v5 then
            error("Failed to find RemoteEvent: " .. v3, 2);
        end;

        return v5;
    end,

    UnreliableRemoteEvent = function(p6, p7) -- Line: 59, Name: UnreliableRemoteEvent
        -- upvalues: RunService (copy)
        local v8 = "URE/" .. p7;

        if RunService:IsServer() then
            local v9 = script:FindFirstChild(v8);

            if not v9 then
                v9 = Instance.new("UnreliableRemoteEvent");
                v9.Name = v8;
                v9.Parent = script;
            end;

            return v9;
        end;

        local v10 = script:WaitForChild(v8, 10);

        if not v10 then
            error("Failed to find UnreliableRemoteEvent: " .. v8, 2);
        end;

        return v10;
    end,

    Connect = function(p11, p12, p13) -- Line: 91, Name: Connect
        -- upvalues: RunService (copy)
        if RunService:IsServer() then
            return p11:RemoteEvent(p12).OnServerEvent:Connect(p13);
        end;

        return p11:RemoteEvent(p12).OnClientEvent:Connect(p13);
    end,

    ConnectUnreliable = function(p14, p15, p16) -- Line: 112, Name: ConnectUnreliable
        -- upvalues: RunService (copy)
        if RunService:IsServer() then
            return p14:UnreliableRemoteEvent(p15).OnServerEvent:Connect(p16);
        end;

        return p14:UnreliableRemoteEvent(p15).OnClientEvent:Connect(p16);
    end,

    RemoteFunction = function(p17, p18) -- Line: 135, Name: RemoteFunction
        -- upvalues: RunService (copy)
        local v19 = "RF/" .. p18;

        if RunService:IsServer() then
            local v20 = script:FindFirstChild(v19);

            if not v20 then
                v20 = Instance.new("RemoteFunction");
                v20.Name = v19;
                v20.Parent = script;
            end;

            return v20;
        end;

        local v21 = script:WaitForChild(v19, 10);

        if not v21 then
            error("Failed to find RemoteFunction: " .. v19, 2);
        end;

        return v21;
    end,

    Handle = function(p22, p23, p24) -- Line: 164, Name: Handle
        p22:RemoteFunction(p23).OnServerInvoke = p24;
    end,

    Invoke = function(p25, p26, ...) -- Line: 176, Name: Invoke
        return p25:RemoteFunction(p26):InvokeServer(...);
    end,

    Clean = function(p27) -- Line: 186, Name: Clean
        script:ClearAllChildren();
    end
};