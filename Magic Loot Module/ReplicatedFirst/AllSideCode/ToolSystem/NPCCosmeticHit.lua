-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local NPCCosmeticHitClient = require(script.NPCCosmeticHitClient);
local v1 = {};

if RunService:IsServer() then
    function v1.handleIncoming(p2) -- Line: 34
    end;

    return v1;
end;

function v1.handleIncoming(p3) -- Line: 42
    -- upvalues: NPCCosmeticHitClient (copy)
    NPCCosmeticHitClient.handleIncoming(p3);
end;

return v1;