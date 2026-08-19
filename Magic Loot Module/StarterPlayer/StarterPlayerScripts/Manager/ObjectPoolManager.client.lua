-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local ObjectPoolUtil = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).ObjectPoolUtil;
local u1 = 0;

local function _onHeartbeat(p2) -- Line: 45
    -- upvalues: u1 (ref), ObjectPoolUtil (copy)
    u1 = u1 + p2;

    if u1 >= 60 then
        u1 = 0;
        ObjectPoolUtil.clearIdleObjects();
    end;
end;

ObjectPoolUtil.Init();
RunService.Heartbeat:Connect(_onHeartbeat);