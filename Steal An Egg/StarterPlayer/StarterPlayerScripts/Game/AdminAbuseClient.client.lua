-- Decompiled with Potassium's decompiler.

game:GetService("Workspace");
game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local Network = require(ReplicatedStorage.Library.Client.Network);
local _ = Constants.NETWORK_MAP.ServerLuck;
local u1 = {};
local u2 = {};

for _, child in script.Events:GetChildren() do
    if child:IsA("ModuleScript") then
        xpcall(function() -- Line: 34
            -- upvalues: u1 (copy), child (copy)
            u1[child.Name] = require(child);
        end, function(p3) -- Line: 36
            warn((`[{script.Name}] {p3}`));
        end);
    end;
end;

Network.Fired(Network.NET_MAP.AdminAbuse.EVENT_STARTED):Connect(function(u4, p5, p6) -- Line: 41
    -- upvalues: u2 (copy), u1 (copy)
    local u7 = os.time() + p5;
    u2[u4] = u7;

    if not u1[u4] then
        return;
    end;

    u1[u4]:StartEvent(p5, p6);
    task.delay(p5, function() -- Line: 49
        -- upvalues: u2 (ref), u4 (copy), u7 (copy), u1 (ref)
        if u2[u4] ~= u7 then
            return;
        end;

        u1[u4]:StopEvent();
        u2[u4] = nil;
    end);
end);
Network.Fired(Network.NET_MAP.AdminAbuse.EVENT_STOPPED):Connect(function(p8) -- Line: 56
    -- upvalues: u2 (copy), u1 (copy)
    u2[p8] = nil;

    if not u1[p8] then
        return;
    end;

    u1[p8]:StopEvent();
end);