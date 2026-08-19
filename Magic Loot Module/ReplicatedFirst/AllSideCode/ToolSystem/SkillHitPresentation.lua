-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local SkillHitPresentationResolver = require(script.SkillHitPresentationResolver);
local SkillHitPresentationClient = require(script.SkillHitPresentationClient);
local SkillHitPresentationProfile = require(script.SkillHitPresentationProfile);
local v3 = {
    resolveProfile = function(p1) -- Line: 48, Name: resolveProfile
        -- upvalues: SkillHitPresentationProfile (copy)
        return SkillHitPresentationProfile.resolve(p1);
    end,

    resolveHitboxEntry = function(p2) -- Line: 58, Name: resolveHitboxEntry
        -- upvalues: SkillHitPresentationProfile (copy)
        return SkillHitPresentationProfile.resolveHitboxEntry(p2);
    end
};

if RunService:IsServer() then
    function v3.beginBatch(p4) -- Line: 68
        -- upvalues: SkillHitPresentationResolver (copy)
        SkillHitPresentationResolver.beginBatch(p4);
    end;

    function v3.flushBatch() -- Line: 77
        -- upvalues: SkillHitPresentationResolver (copy)
        SkillHitPresentationResolver.flushBatch();
    end;

    function v3.accumulateFromCombat(p5, p6, p7) -- Line: 88
        -- upvalues: SkillHitPresentationResolver (copy)
        SkillHitPresentationResolver.accumulateFromCombat(p5, p6, p7);
    end;

    function v3.handleIncoming(p8) -- Line: 92
    end;

    return v3;
end;

function v3.beginBatch(p9) -- Line: 95
end;

function v3.flushBatch() -- Line: 98
end;

function v3.accumulateFromCombat(p10, p11, p12) -- Line: 101
end;

function v3.handleIncoming(p13) -- Line: 109
    -- upvalues: SkillHitPresentationClient (copy)
    SkillHitPresentationClient.handleIncoming(p13);
end;

return v3;