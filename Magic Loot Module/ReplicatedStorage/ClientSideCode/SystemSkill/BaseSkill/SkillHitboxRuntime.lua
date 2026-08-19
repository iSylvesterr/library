-- Decompiled with Potassium's decompiler.

local ReplicatedFirst = game:GetService("ReplicatedFirst");
local Hitbox = require(script.Parent.Hitbox);
local HitPolicy = require(script.Parent.HitPolicy);
local SkillHitPresentationProfile = require(ReplicatedFirst.AllSideCode.ToolSystem.SkillHitPresentation.SkillHitPresentationProfile);

return {
    create = function(p1) -- Line: 23, Name: create
        return {
            owner = p1,
            instances = {}
        };
    end,

    spawnAll = function(p2, p3) -- Line: 35, Name: spawnAll
        -- upvalues: SkillHitPresentationProfile (copy), HitPolicy (copy), Hitbox (copy)
        local owner = p2.owner;

        for _, v in owner.skillModule.hitboxConfig or {} do
            local v4 = SkillHitPresentationProfile.resolveHitboxEntry(v);
            local v5 = {
                hitboxOwnerType = p3.characterType,
                hitboxOwnerId = p3.characterId,
                hitboxIndex = v.HitboxIndex,
                PartName = v.PartName,
                collisionGroup = v.CollisionGroup,
                ActiveRange = v.ActiveRange or NumberRange.new(0, 0),
                EffectName = v4.effectName,
                SoundName = v4.soundKey,
                SuppressHitPresentation = v4.skipPresentation == true,
                PhysicsEffectName = v.PhysicsEffectName,
                skillName = owner.skillName,
                skillID = owner.skillID,
                combatSeed = p3.combatSeed or owner.combatSeed,
                hitPolicy = HitPolicy.fromHitboxEntry(v)
            };
            local v6 = Hitbox.new(v5);
            p2.instances[v.HitboxIndex] = v6;
        end;
    end,

    startHitbox = function(p7, p8, p9) -- Line: 67, Name: startHitbox
        local v10 = p7.instances[p8];

        if v10 and v10.start then
            v10:start(p9);
        end;
    end,

    stopHitbox = function(p11, p12) -- Line: 79, Name: stopHitbox
        local v13 = p11.instances[p12];

        if v13 and v13.stop then
            v13:stop();
        end;
    end,

    destroyAll = function(p14) -- Line: 90, Name: destroyAll
        for _, v in p14.instances do
            if v and v.destroy then
                v:destroy();
            end;
        end;

        p14.instances = {};
    end
};