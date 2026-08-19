-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local MonsterLocomotionClient = require(script.MonsterLocomotionClient);
local MonsterLocomotionPlay = require(script.MonsterLocomotionPlay);
local v1 = {};

if RunService:IsServer() then
    function v1.handleIncoming(p2) -- Line: 36
    end;

    function v1.flushPending(p3) -- Line: 45
        return false;
    end;

    return v1;
end;

function v1.handleIncoming(p4) -- Line: 54
    -- upvalues: MonsterLocomotionClient (copy)
    MonsterLocomotionClient.handleIncoming(p4);
end;

function v1.flushPending(p5) -- Line: 64
    -- upvalues: MonsterLocomotionPlay (copy)
    return MonsterLocomotionPlay.flushPending(p5);
end;

return v1;