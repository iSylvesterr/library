-- Decompiled with Potassium's decompiler.

local EntityUtil = require(script.Parent.EntityUtil);
local HitPolicy = require(script.Parent.HitPolicy);

return {
    create = function(p1, p2, p3) -- Line: 21, Name: create
        -- upvalues: HitPolicy (copy), EntityUtil (copy)
        if not (p1 and p2) then
            return nil;
        end;

        local v4 = p1.hitPolicy or HitPolicy.default();
        local v5, v6 = EntityUtil.getEntityIdentity(p2);
        local v7 = EntityUtil.isOwnedBy(p1.hitboxOwnerId, p1.hitboxOwnerType, p2);
        local v8 = EntityUtil.isFriendly({
            id = p1.hitboxOwnerId,
            type = p1.hitboxOwnerType
        }, p2);
        local v9 = EntityUtil.isForeignPlayerOwnedSummon(p1.hitboxOwnerId, p1.hitboxOwnerType, p2);
        local v10 = {
            attackerId = p1.hitboxOwnerId,
            attackerType = p1.hitboxOwnerType,
            targetId = v5,
            targetType = v6,
            targetModel = p2,
            hitboxIndex = p1.hitboxIndex,
            hitPolicy = v4,
            nowTime = p3 or 0
        };
        local v11;

        if v5 == nil then
            v11 = false;
        else
            v11 = EntityUtil.idsEqual(p1.hitboxOwnerId, v5) and p1.hitboxOwnerType == v6;
        end;

        v10.sameEntity = v11;
        v10.isOwner = v7;
        v10.isFriendly = v8;
        v10.isForeignPlayerSummon = v9;
        v10._activationHitCount = p1._activationHitCount or 0;
        v10._hitHistory = p1.hitHistory or {};

        return v10;
    end,

    isDetectableTarget = function(p12) -- Line: 59, Name: isDetectableTarget
        -- upvalues: HitPolicy (copy)
        if not p12 then
            return false;
        end;

        local v13 = p12.hitPolicy or HitPolicy.default();

        if not v13.allowSelfHit and p12.isOwner then
            return false;
        end;

        if v13.allowFriendlyFire or not p12.isFriendly then
            return not p12.isForeignPlayerSummon;
        end;

        return false;
    end
};