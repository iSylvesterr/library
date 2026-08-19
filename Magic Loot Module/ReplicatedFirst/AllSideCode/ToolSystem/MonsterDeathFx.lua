-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local MonsterDeathFxClient = require(script.MonsterDeathFxClient);
local v1 = {};

if RunService:IsServer() then
    function v1.handleIncoming(p2) -- Line: 33
    end;

    return v1;
end;

function v1.handleIncoming(p3) -- Line: 41
    -- upvalues: MonsterDeathFxClient (copy)
    MonsterDeathFxClient.handleIncoming(p3);
end;

return v1;