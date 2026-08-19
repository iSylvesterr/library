-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerScriptService = game:GetService("ServerScriptService");
local RunService = game:GetService("RunService");

return {
    Name = "globalRemoveScheduledEvent",
    Description = "Schedules an event in all servers",
    Group = "Moderator",
    Args = { function(p1) -- Line: 10
            -- upvalues: RunService (copy), ServerScriptService (copy), ReplicatedStorage (copy)
            local v2;

            if RunService:IsServer() then
                v2 = require(ServerScriptService.Controllers.AdminAbuseService).GetScheduledEvents();
            else
                local Network = require(ReplicatedStorage.Library.Client.Network);
                v2 = Network.Invoke(Network.NET_MAP.AdminAbuse.GET_SCHEDULED_EVENTS);
            end;

            local v3 = {};

            for i in v2 do
                table.insert(v3, i);
            end;

            return {
                Name = "ScheduledEventKey",
                Type = p1.Cmdr.Util.MakeEnumType("scheduleEventKey", v3)
            };
        end }
};