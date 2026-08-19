-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerScriptService = game:GetService("ServerScriptService");
local RunService = game:GetService("RunService");

if RunService:IsServer() then
    local AdminPanelService = require(ServerScriptService.Controllers.AdminPanelService);

    return function(p1) -- Line: 8
        -- upvalues: AdminPanelService (copy), RunService (copy)
        p1:RegisterHook("BeforeRun", function(p2) -- Line: 9
            -- upvalues: AdminPanelService (ref), RunService (ref)
            local _ = p2.Group;

            if not (AdminPanelService.IsAdmin(p2.Executor) or RunService:IsStudio()) then
                return "You do not have permission to run this function.";
            end;
        end);
    end;
end;

local Network = require(ReplicatedStorage.Library.Client.Network);
local AdminPanel = require(ReplicatedStorage.Library.Globals.Constants).NETWORK_MAP.AdminPanel;
local u3 = false;
Network.Fired(AdminPanel.ADMIN_STATUS_RESPONSE):Connect(function(p4) -- Line: 27
    -- upvalues: u3 (ref)
    u3 = p4;
end);
Network.Fire(AdminPanel.CHECK_ADMIN_STATUS);

return function(p5) -- Line: 32
    -- upvalues: u3 (ref), RunService (copy)
    p5:RegisterHook("BeforeRun", function(p6) -- Line: 33
        -- upvalues: u3 (ref), RunService (ref)
        local _ = p6.Executor;
        local _ = p6.Group;

        if not (u3 or RunService:IsStudio()) then
            return "You do not have permission to run this function.";
        end;
    end);
end;