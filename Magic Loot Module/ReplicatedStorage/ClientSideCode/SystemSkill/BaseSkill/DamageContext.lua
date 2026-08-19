-- Decompiled with Potassium's decompiler.

local ElementTp = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).EnumMgr.ElementTp;

return {
    create = function(p1, p2, p3, p4) -- Line: 22, Name: create
        -- upvalues: ElementTp (copy)
        if not (p1 and p2) then
            return nil;
        end;

        local v5 = p3 or {};

        return {
            attackerData = p1,
            defenderData = p2,
            summonDirectDamage = v5.summonDirectDamage == true,
            combatSeed = v5.combatSeed or p1.combatSeed,
            elementType = v5.elementType or ElementTp.None,
            hitIndex = v5.hitIndex or (p4 and ((p4._hitCounter or 0) + 1 or 0) or 0),
            hitboxIndex = v5.hitboxIndex or (p4 and p4.hitboxIndex or 0),
            damageProfileId = v5.damageProfileId
        };
    end
};