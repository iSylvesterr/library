-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
assert(RunService:IsClient());
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Network = ReplicatedStorage:WaitForChild("Network", 99999999);
local NETWORK_MAP = require(ReplicatedStorage.Library.Globals.Constants).NETWORK_MAP;
local v1 = {};
local u2 = { {}, {}, {}, {}, {}, {} };
local u3 = { "BindableEvent", "BindableFunction", "BindableEvent", "BindableEvent", "BindableFunction", "BindableEvent" };
local u4 = { {}, {}, {} };
local u5 = { "RemoteEvent", "RemoteFunction", "UnreliableRemoteEvent" };

for _, v in ipairs({ "ProfileFunction: Reset", "ProfileFunction: Print" }) do
    v1[v] = true;
end;

local u18 = { function(p6, u7) -- Line: 23
        local u8 = _bindable(1, p6, false);

        if u8 then
            u7.OnClientEvent:Connect(function(...) -- Line: 27
                -- upvalues: u8 (copy)
                u8:Fire(...);
            end);
        end;

        local v9 = _bindable(4, p6, false);

        if v9 then
            v9.Event:Connect(function(...) -- Line: 33
                -- upvalues: u7 (copy)
                u7:FireServer(...);
            end);
        end;
    end, function(p10, u11) -- Line: 39
        local u12 = _bindable(2, p10, false);

        if u12 then
            function u11.OnClientInvoke(...) -- Line: 43
                -- upvalues: u12 (copy)
                return u12:Invoke(...);
            end;
        end;

        local v13 = _bindable(5, p10, false);

        if v13 then
            function v13.OnInvoke(...) -- Line: 49
                -- upvalues: u11 (copy)
                return u11:InvokeServer(...);
            end;
        end;
    end, function(p14, u15) -- Line: 55
        local u16 = _bindable(3, p14, false);

        if u16 then
            u15.OnClientEvent:Connect(function(...) -- Line: 59
                -- upvalues: u16 (copy)
                u16:Fire(...);
            end);
        end;

        local v17 = _bindable(6, p14, false);

        if v17 then
            v17.Event:Connect(function(...) -- Line: 65
                -- upvalues: u15 (copy)
                u15:FireServer(...);
            end);
        end;
    end };

local function getName(p19, p20) -- Line: 72
    return p20;
end;

function _bindable(p21, p22, p23)
    -- upvalues: u2 (copy), u3 (copy)
    local v24 = u2[p21];
    local v25 = v24[p22];

    if not v25 and p23 then
        v25 = Instance.new(u3[p21]);
        v25.Name = p22;
        v25.Parent = script;
        v24[p22] = v25;
    end;

    return v25;
end;

function _bindableEventRx(p26)
    return _bindable(1, p26, true);
end;

function _bindableEventTx(p27)
    return _bindable(4, p27, true);
end;

function _bindableFunctionRx(p28)
    return _bindable(2, p28, true);
end;

function _bindableFunctionTx(p29)
    return _bindable(5, p29, true);
end;

function _bindableUnreliableEventRx(p30)
    return _bindable(3, p30, true);
end;

function _bindableUnreliableEventTx(p31)
    return _bindable(6, p31, true);
end;

function onChildAdded(p32)
    -- upvalues: u4 (copy), u5 (copy), u18 (copy)
    for i, v in pairs(u4) do
        if p32:IsA(u5[i]) then
            local Name = p32.Name;

            if v[Name] == nil then
                v[Name] = p32;
                u18[i](Name, p32);

                return;
            end;

            break;
        end;
    end;
end;

function _remote(p33, p34)
    -- upvalues: u4 (copy), Network (copy), u18 (copy)
    local v35 = u4[p33];
    local v36 = v35[p34];

    if not v36 then
        v36 = Network:FindFirstChild(p34);

        if not v36 then
            return nil;
        end;

        v35[p34] = v36;
        u18[p33](p34, v36);
    end;

    return v36;
end;

function _remoteEvent(p37)
    return _remote(1, p37);
end;

function _remoteFunction(p38)
    return _remote(2, p38);
end;

function _unreliableRemoteEvent(p39)
    return _remote(3, p39);
end;

Network.ChildAdded:Connect(onChildAdded);
local v59 = {
    NET_MAP = NETWORK_MAP,

    Fire = function(p40, ...) -- Line: 155, Name: Fire
        local u41 = _remoteEvent(p40);

        if u41 then
            task.spawn(function(...) -- Line: 158
                -- upvalues: u41 (copy)
                u41:FireServer(...);
            end, ...);

            return;
        end;

        local u42 = _bindableEventTx(p40);
        task.spawn(function(...) -- Line: 163
            -- upvalues: u42 (copy)
            u42:Fire(...);
        end, ...);
    end,

    Fired = function(p43) -- Line: 169, Name: Fired
        local v44 = _remoteEvent(p43);

        if v44 then
            return v44.OnClientEvent;
        end;

        return _bindableEventRx(p43).Event;
    end,

    UnreliableFire = function(p45, ...) -- Line: 178, Name: UnreliableFire
        local u46 = _unreliableRemoteEvent(p45);

        if u46 then
            task.spawn(function(...) -- Line: 181
                -- upvalues: u46 (copy)
                u46:FireServer(...);
            end, ...);

            return;
        end;

        local u47 = _bindableUnreliableEventTx(p45);
        task.spawn(function(...) -- Line: 186
            -- upvalues: u47 (copy)
            u47:Fire(...);
        end, ...);
    end,

    UnreliableFired = function(p48) -- Line: 192, Name: UnreliableFired
        local v49 = _unreliableRemoteEvent(p48);

        if v49 then
            return v49.OnClientEvent;
        end;

        return _bindableUnreliableEventRx(p48).Event;
    end,

    Invoke = function(p50, ...) -- Line: 201, Name: Invoke
        local v51 = _remoteFunction(p50);

        if v51 then
            return v51:InvokeServer(...);
        end;

        return _bindableFunctionTx(p50):Invoke(...);
    end,

    Invoked = function(p52) -- Line: 215, Name: Invoked
        if _bindable(2, p52, false) then
            return _bindableFunctionRx(p52);
        end;

        local u53 = _remoteFunction(p52);

        if u53 then
            return setmetatable({}, {
                __newindex = function(p54, p55, p56) -- Line: 223, Name: __newindex
                    -- upvalues: u53 (copy)
                    if p55 == "OnInvoke" then
                        u53.OnClientInvoke = p56;

                        return;
                    end;

                    error("\'" .. tostring(p55) .. "\' is not a valid member of NetworkFunction");
                end,

                __index = function(p57, p58) -- Line: 230, Name: __index
                    -- upvalues: u53 (copy)
                    if p58 == "OnInvoke" then
                        return u53.OnClientInvoke;
                    end;

                    error("\'" .. tostring(p58) .. "\' is not a valid member of NetworkFunction");
                end
            });
        end;

        return _bindableFunctionRx(p52);
    end
};

for _, child in ipairs(Network:GetChildren()) do
    onChildAdded(child);
end;

return v59;