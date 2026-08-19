-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local HitPhysicsResolver = require(script.HitPhysicsResolver);
local HitPhysicsClient = require(script.HitPhysicsClient);
local v1 = {};

if RunService:IsServer() then
    function v1.tryApplyFromHitbox(p2, p3) -- Line: 37
        -- upvalues: HitPhysicsResolver (copy)
        HitPhysicsResolver.tryApplyFromHitbox(p2, p3);
    end;

    function v1.handleIncoming(p4) -- Line: 41
    end;

    return v1;
end;

function v1.tryApplyFromHitbox(p5, p6) -- Line: 44
end;

function v1.handleIncoming(p7) -- Line: 52
    -- upvalues: HitPhysicsClient (copy)
    HitPhysicsClient.handleIncoming(p7);
end;

return v1;