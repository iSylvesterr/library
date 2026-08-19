-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Logging = require(ReplicatedStorage.UserGenerated.Logging);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local u5 = table.freeze({
    __index = table.freeze({
        Disconnect = function(p1) -- Line: 51, Name: Disconnect
            p1.Connection:Disconnect();
            p1:OnDisconnected();
        end,

        OnDisconnected = function(p2) -- Line: 56, Name: OnDisconnected
            if p2.Vars.Disconnected then
                return;
            end;

            p2.Vars.Disconnected = true;

            for _, v in ipairs(p2.Callbacks) do
                task.spawn(v);
            end;

            table.clear(p2.Callbacks);
        end,

        Then = function(p3, p4) -- Line: 67, Name: Then
            -- upvalues: Asserts (copy)
            Asserts.Function(p4);

            if p3.Vars.Disconnected then
                task.spawn(p4);

                return;
            end;

            table.insert(p3.Callbacks, p4);
        end
    })
});

function new(u6, u7)
    -- upvalues: Asserts (copy), u5 (copy), RunService (copy), Logging (copy)
    Asserts.FiniteNonNegative(u6);
    Asserts.Function(u7);
    local u8 = setmetatable({
        Connection = nil,
        Callbacks = {},
        Vars = {
            Disconnected = false
        }
    }, u5);
    local u9 = 0;
    local u10 = nil;
    u10 = RunService.RenderStepped:Connect(function(p11) -- Line: 94
        -- upvalues: u9 (ref), u6 (copy), u10 (ref), u7 (copy), Logging (ref), u8 (copy)
        local v12 = false;
        local v13 = u9;
        u9 = u9 + p11;

        if u6 <= u9 then
            u9 = u6;
            u10:Disconnect();
            v12 = true;
        end;

        local success, result = pcall(u7, u6 <= u9 and 1 or u9 / u6, u9, u9 - v13);

        if not success then
            Logging.Warn("RenderError", result);
        end;

        if not success or result ~= nil then
            u10:Disconnect();
            v12 = true;
        end;

        if v12 then
            u8:OnDisconnected();
        end;
    end);
    u8.Connection = u10;
    table.freeze(u8);

    return u8;
end;

return new;