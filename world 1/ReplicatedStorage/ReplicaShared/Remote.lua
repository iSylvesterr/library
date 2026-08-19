-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local v1 = RunService:IsStudio();
local u2 = RunService:IsServer();
local u3 = {};
local u4 = nil;
local u5;

if u2 == true then
    u5 = ReplicatedStorage:FindFirstChild("RemoteEvents");

    if u5 == nil then
        u5 = Instance.new("Folder");
        u5.Name = "RemoteEvents";
        u5.Parent = ReplicatedStorage;
    else
        local _ = v1 == true;
    end;
else
    u5 = ReplicatedStorage:FindFirstChild("RemoteEvents");

    if u5 == nil then
        u4 = Instance.new("BindableEvent");
        task.spawn(function() -- Line: 49
            -- upvalues: u5 (ref), ReplicatedStorage (copy), u4 (ref)
            while task.wait() do
                u5 = ReplicatedStorage:FindFirstChild("RemoteEvents");

                if u5 ~= nil then
                    u4:Fire();

                    return;
                end;
            end;
        end);
    end;
end;

local u6 = {};
u6.__index = u6;

function u6.New(p7) -- Line: 70
    -- upvalues: u6 (copy)
    return setmetatable({
        is_disconnected = false,
        real_connection = nil,
        fn = p7
    }, u6);
end;

function u6.Disconnect(p8) -- Line: 78
    p8.is_disconnected = true;

    if p8.real_connection ~= nil then
        p8.real_connection:Disconnect();
    end;
end;

local u9 = {};
u9.__index = u9;

function u9.New(u10, p11) -- Line: 88
    -- upvalues: u2 (copy), u3 (copy), u5 (ref), u6 (copy), u9 (copy), u4 (ref)
    if type(u10) ~= "string" then
        error((`[{script.Name}]: name must be a string`));
    end;

    if u2 == true then
        if u3[u10] ~= nil then
            error((`[{script.Name}]: RemoteEvent {u10} was already defined`));
        end;

        u3[u10] = true;
        local v12 = Instance.new(p11 == true and "UnreliableRemoteEvent" or "RemoteEvent");
        v12.Name = u10;
        v12.Parent = u5;

        return v12;
    end;

    local u13 = u5 and u5:FindFirstChild(u10);

    if u13 ~= nil then
        return u13;
    end;

    local u14 = {};
    local u18 = setmetatable({
        RemoteEvent = nil,
        OnClientEvent = {
            Connect = function(p15, p16) -- Line: 120, Name: Connect
                -- upvalues: u13 (ref), u6 (ref), u14 (ref)
                if u13 ~= nil then
                    return u13.OnClientEvent:Connect(p16);
                end;

                local v17 = u6.New(p16);
                table.insert(u14, v17);

                return v17;
            end
        },
        OnServerEvent = {
            Connect = function() -- Line: 133, Name: Connect
                error((`[{script.Name}]: Can't connect to "OnServerEvent" client-side`));
            end
        }
    }, u9);

    local function on_container_ready() -- Line: 140
        -- upvalues: u13 (ref), u5 (ref), u10 (copy), u14 (ref), u18 (copy)
        local v19 = os.clock();

        while true do
            u13 = u5:FindFirstChild(u10);

            if u13 ~= nil then
                break;
            end;

            if v19 ~= nil and os.clock() - v19 > 20 then
                v19 = nil;
            end;

            task.wait();
        end;

        for _, v in ipairs(u14) do
            if v.is_disconnected == false then
                v.real_connection = u13.OnClientEvent:Connect(v.fn);
            end;
        end;

        u18.RemoteEvent = u13;
        u14 = nil;
    end;

    if u5 == nil then
        local u20 = nil;
        u20 = u4.Event:Connect(function() -- Line: 171
            -- upvalues: u20 (ref), on_container_ready (copy)
            u20:Disconnect();
            on_container_ready();
        end);
    else
        task.spawn(on_container_ready);
    end;

    return u18;
end;

function u9.FireServer(p21, ...) -- Line: 183
    if p21.RemoteEvent ~= nil then
        p21.RemoteEvent:FireServer(...);
    end;
end;

function u9.FireClient(p22) -- Line: 189
    error((`[{script.Name}]: Can't use "FireClient" client-side`));
end;

function u9.FireAllClients(p23) -- Line: 193
    error((`[{script.Name}]: Can't use "FireAllClients" client-side`));
end;

return u9;