-- Decompiled with Potassium's decompiler.

local GetSkillData = require(script.Parent.GetSkillData);
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
local _ = UtilsSystem.GetData;
local u10 = {
    buildCombinedSeed = function(p1, p2, p3) -- Line: 23, Name: buildCombinedSeed
        return (p1 or 0) + (p2 or 0) * 10000 + (p3 or 0) * 100;
    end,

    rollCritical = function(p4, p5, p6) -- Line: 36, Name: rollCritical
        if not p6 then
            return false, 1;
        end;

        local v7 = p4.criticalRate or 0;
        local v8 = p4.criticalDamage or 0.5;
        local v9 = (p5 and p5:NextNumber() or math.random()) < v7;

        return v9, v9 and 1 + v8 or 1;
    end
};

function u10.resolveDamage(p11) -- Line: 65
    -- upvalues: ElementTp (copy), GetSkillData (copy), u10 (copy)
    local attackerData = p11.attackerData;
    local defenderData = p11.defenderData;

    if not (attackerData and defenderData) then
        warn("[DamageResolver] 攻击者或被攻击者数据为空");

        return {
            finalDamage = 0,
            isCritical = false
        };
    end;

    local v12 = p11.damageRate or 1;
    local _ = p11.summonDirectDamage;
    local v13 = 1;
    local v14 = p11.powerMult or 1;
    local v15 = p11.canCritical ~= false;
    local v16 = p11.randomOffset or 0.05;
    local v17 = p11.elementType or ElementTp.None;
    local v18 = GetSkillData.ElementCounterDamage[v17] and GetSkillData.ElementCounterDamage[v17][defenderData.elementType or ElementTp.None] or 1;
    local v19 = p11.combatSeed or attackerData.combatSeed;
    local v20 = p11.hitIndex or (attackerData.hitIndex or 0);
    local v21 = p11.hitboxIndex or (attackerData.hitboxIndex or 0);
    local v22 = u10.buildCombinedSeed(v19, v20, v21);
    local v23;

    if type(v19) == "number" then
        v23 = Random.new(v22) or nil;
    else
        v23 = nil;
    end;

    local v24, v25 = u10.rollCritical(attackerData, v23, v15);
    local v26 = 1 - (defenderData.finalDamageReduction or 0);
    local baseDamageOverride = p11.baseDamageOverride;

    if baseDamageOverride == nil then
        baseDamageOverride = (attackerData.attackPower or 1) * v12 * v13;
    end;

    local v27 = baseDamageOverride * v14 * v18 * v25 * (1 + (attackerData.finalDamageBonus or 0)) * v26;
    local v28;

    if v23 then
        v28 = (1 - 2 * v23:NextNumber()) * v16;
    else
        v28 = (1 - 2 * math.random()) * v16;
    end;

    local v29 = math.floor(v27 * (v28 + 1) + 0.5);

    return {
        finalDamage = math.max(0, v29),
        isCritical = v24,
        elementMultiplier = v18,
        powerMultiplier = v14,
        reductionMultiplier = v26,
        randomInfo = {
            combatSeed = v19,
            combinedSeed = v22,
            hitIndex = v20,
            hitboxIndex = v21
        }
    };
end;

function u10.createDamageResult(p30, p31) -- Line: 157
    -- upvalues: ElementTp (copy), u10 (copy)
    if not (p30 and p31) then
        return nil;
    end;

    local attackerData = p30.attackerData;
    local defenderData = p30.defenderData;

    if not (attackerData and defenderData) then
        return nil;
    end;

    local damageRate = p31.damageRate;
    local baseDamage = p31.baseDamage;
    local v32 = baseDamage == nil and damageRate == nil and 1 or damageRate;
    local v33 = {
        powerMult = 1,
        attackerData = attackerData,
        defenderData = defenderData,
        summonDirectDamage = p30.summonDirectDamage,
        canCritical = p31.canCritical ~= false,
        hitIndex = p30.hitIndex,
        hitboxIndex = p30.hitboxIndex,
        combatSeed = p30.combatSeed,
        elementType = p31.elementType or (p30.elementType or ElementTp.None),
        randomOffset = p31.randomOffset or 0.05
    };

    if baseDamage == nil then
        v33.damageRate = v32 or 1;
    else
        v33.damageRate = 1;
        v33.baseDamageOverride = baseDamage;
    end;

    local v34 = u10.resolveDamage(v33);

    return {
        finalDamage = v34.finalDamage,
        isCritical = v34.isCritical,
        showDamageText = p31.showDamageText ~= false,
        damageTags = p31.damageTags or {}
    };
end;

function u10.calculate(p35, p36, p37, p38) -- Line: 213
    -- upvalues: u10 (copy)
    if not p38 then
        return nil;
    end;

    local v39 = require(script.Parent.DamageContext).create(p35, p36, p37, nil);

    if v39 and p37 then
        v39.hitIndex = p37.hitIndex or v39.hitIndex;
        v39.hitboxIndex = p37.hitboxIndex or v39.hitboxIndex;
        v39.combatSeed = p37.combatSeed or v39.combatSeed;
    end;

    return u10.createDamageResult(v39, p38);
end;

return u10;