-- Decompiled with Potassium's decompiler.

local SkillEventConst = require(script.Parent.SkillEventConst);
local MultThunderTramplePath = require(script.Parent.Parent.SkillModule.MultThunderTrample1.MultThunderTramplePath);
local u1 = {};
local SyncEventType = SkillEventConst.SyncEventType;

function u1.baseContext(p2) -- Line: 16
    return {
        skillName = p2.skillName,
        skillCastId = p2.skillCastId,
        baseSkillInstanceId = p2.baseSkillInstanceId,
        activeBaseSkillIndex = p2.activeBaseSkillIndex,
        characterId = p2.characterId,
        characterType = p2.characterType,
        timelineTime = p2.nowTime
    };
end;

function u1.projectileHitConfirmed(p3, p4, p5, p6) -- Line: 31
    -- upvalues: u1 (copy), SyncEventType (copy)
    local v7 = u1.baseContext(p3);
    v7.eventType = SyncEventType.ProjectileHitConfirmed;
    v7.hitPosition = p4;
    v7.hitType = p5;
    v7.targetId = p6;

    return v7;
end;

function u1.baseSkillStarted(p8, p9, p10) -- Line: 43
    -- upvalues: MultThunderTramplePath (copy), SyncEventType (copy)
    local owner = p8.owner;
    local v11 = p8.baseSkills[1];
    local castInputSnapshot = p8.castInputSnapshot;
    local v12;

    if castInputSnapshot then
        v12 = castInputSnapshot.multThunderPathPoints;
    else
        v12 = castInputSnapshot;
    end;

    local v13;

    if type(v12) == "table" and #v12 >= 4 then
        v13 = MultThunderTramplePath.packPathPointsForSync(v12);
    else
        v13 = nil;
    end;

    local v14 = {
        activeBaseSkillIndex = 1,
        eventType = SyncEventType.BaseSkillStarted,
        skillCastId = p8.skillCastId,
        baseSkillInstanceId = v11 and v11.baseSkillInstanceId or p8.skillCastId .. "_B1",
        characterId = owner.characterId,
        characterType = owner.characterType,
        skillName = p9.baseSkillName
    };
    v14.releaseCF = p8.castInputSnapshot and p8.castInputSnapshot.releaseCF;
    v14.targetCF = p8.castInputSnapshot and p8.castInputSnapshot.targetCF;
    v14.moveDirectionStr = p8.castInputSnapshot and p8.castInputSnapshot.moveDirectionStr;
    v14.combatSeed = p8.combatSeed;
    v14.skillID = owner.skillID;
    v14.slotIndex = owner.slotIndex;
    v14.groupSkillName = owner.skillName;
    v14.trackTargetId = p8.castInputSnapshot and p8.castInputSnapshot.trackTargetId;
    v14.skillTargetData = p8.castInputSnapshot and p8.castInputSnapshot.skillTargetData;
    v14.moveFaceMode = p8.castInputSnapshot and p8.castInputSnapshot.moveFaceMode;
    v14.moveFaceWorldPos = p8.castInputSnapshot and p8.castInputSnapshot.moveFaceWorldPos;
    v14.multThunderPathPoints = v12;
    v14.multThunderPathPacked = v13;
    local v15;

    if castInputSnapshot then
        v15 = castInputSnapshot.multThunderSpawnGround;
    else
        v15 = castInputSnapshot;
    end;

    v14.multThunderSpawnGround = v15;

    if castInputSnapshot then
        castInputSnapshot = castInputSnapshot.approachLandWorldPos;
    end;

    v14.approachLandWorldPos = castInputSnapshot;
    v14.clientObserverMaxDuration = p10;

    return v14;
end;

function u1.baseSkillDerived(p16, p17, p18, p19, p20) -- Line: 82
    -- upvalues: SyncEventType (copy)
    local owner = p16.owner;
    local v21 = {
        eventType = SyncEventType.BaseSkillDerived,
        skillCastId = p16.skillCastId,
        fromBaseSkillIndex = p17,
        toBaseSkillIndex = p18,
        breakLastSkill = p20.breakLastSkill
    };
    v21.releaseCF = p16.castInputSnapshot and p16.castInputSnapshot.releaseCF;
    v21.targetCF = p16.castInputSnapshot and p16.castInputSnapshot.targetCF;
    v21.moveDirectionStr = p16.castInputSnapshot and p16.castInputSnapshot.moveDirectionStr;
    v21.combatSeed = p16.combatSeed;
    v21.characterId = owner.characterId;
    v21.characterType = owner.characterType;
    v21.skillName = p20.baseSkillName;
    v21.baseSkillInstanceId = p19.baseSkillInstanceId;
    v21.activeBaseSkillIndex = p18;
    v21.nextBaseSkillName = p20.baseSkillName;
    v21.skillID = owner.skillID;
    v21.trackTargetId = p16.castInputSnapshot and p16.castInputSnapshot.trackTargetId;
    v21.skillTargetData = p16.castInputSnapshot and p16.castInputSnapshot.skillTargetData;

    return v21;
end;

function u1.proximityStrikeWave(p22, p23, p24, p25) -- Line: 109
    -- upvalues: u1 (copy), SyncEventType (copy)
    local v26 = u1.baseContext(p22);
    v26.eventType = SyncEventType.ProximityStrikeWave;
    v26.waveIndex = p23;
    v26.centerPos = p24;
    v26.positions = p25;

    return v26;
end;

function u1.solarFlareMeteorShot(p27, p28, p29, p30) -- Line: 121
    -- upvalues: u1 (copy), SyncEventType (copy)
    local v31 = u1.baseContext(p27);
    v31.eventType = SyncEventType.SolarFlareMeteorShot;
    v31.meteorIndex = p28;
    v31.startPos = p29;
    v31.endPos = p30;

    return v31;
end;

function u1.projectilePathConfirmed(p32, p33, p34, p35, p36) -- Line: 138
    -- upvalues: u1 (copy), SyncEventType (copy)
    local v37 = u1.baseContext(p32);
    v37.eventType = SyncEventType.ProjectilePathConfirmed;
    v37.projectileIndex = p33;
    v37.startPos = p34;
    v37.endPos = p35;
    v37.flyDir = p36;

    return v37;
end;

function u1.baseSkillStateTransitionFromSkill(p38, p39, p40) -- Line: 160
    -- upvalues: u1 (copy), SyncEventType (copy)
    local skillInputData = p38.skillInputData;
    local v41 = u1.baseContext(p38);
    v41.eventType = SyncEventType.BaseSkillStateTransition;
    v41.transitionEvent = p39;
    v41.groupSkillName = p40 or p38.skillName;
    v41.skillID = p38.skillID;

    if skillInputData then
        v41.releaseCF = skillInputData.releaseCF;
        v41.targetCF = skillInputData.targetCF;
        v41.moveDirectionStr = skillInputData.moveDirectionStr;
        v41.trackTargetId = skillInputData.trackTargetId;
        v41.skillTargetData = skillInputData.skillTargetData;
    end;

    return v41;
end;

function u1.baseSkillStateTransition(p42, p43, p44) -- Line: 181
    -- upvalues: SyncEventType (copy)
    local owner = p42.owner;
    local v45 = {
        eventType = SyncEventType.BaseSkillStateTransition,
        skillCastId = p42.skillCastId,
        baseSkillInstanceId = p43.baseSkillInstanceId,
        activeBaseSkillIndex = p42.activeBaseSkillIndex,
        characterId = owner.characterId,
        characterType = owner.characterType,
        skillName = p43.skillName,
        groupSkillName = owner.skillName,
        slotIndex = owner.slotIndex,
        transitionEvent = p44,
        timelineTime = p43.nowTime,
        combatSeed = p42.combatSeed,
        skillID = owner.skillID
    };
    v45.releaseCF = p42.castInputSnapshot and p42.castInputSnapshot.releaseCF;
    v45.targetCF = p42.castInputSnapshot and p42.castInputSnapshot.targetCF;
    v45.moveDirectionStr = p42.castInputSnapshot and p42.castInputSnapshot.moveDirectionStr;
    v45.trackTargetId = p42.castInputSnapshot and p42.castInputSnapshot.trackTargetId;
    v45.skillTargetData = p42.castInputSnapshot and p42.castInputSnapshot.skillTargetData;

    return v45;
end;

return u1;