-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local HitCameraShakeProfile = require(script.HitCameraShakeProfile);
local HitCameraShakeResolver = require(script.HitCameraShakeResolver);
local HitCameraShakeClient = require(script.HitCameraShakeClient);
local v2 = {
    resolveProfile = function(p1) -- Line: 38, Name: resolveProfile
        -- upvalues: HitCameraShakeProfile (copy)
        return HitCameraShakeProfile.resolve(p1);
    end
};

if RunService:IsServer() then
    function v2.tryDispatch(p3, p4, p5, p6) -- Line: 51
        -- upvalues: HitCameraShakeResolver (copy)
        HitCameraShakeResolver.tryDispatch(p3, p4, p5, p6);
    end;

    function v2.handleIncoming(p7, p8) -- Line: 60
    end;

    return v2;
end;

function v2.tryDispatch(p9, p10, p11, p12) -- Line: 63
end;

function v2.handleIncoming(p13, p14) -- Line: 77
    -- upvalues: HitCameraShakeClient (copy)
    HitCameraShakeClient.handleIncoming(p13, p14);
end;

return v2;