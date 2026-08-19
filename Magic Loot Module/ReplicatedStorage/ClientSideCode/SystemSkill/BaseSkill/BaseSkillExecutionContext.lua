-- Decompiled with Potassium's decompiler.

local GetSkillData = require(script.Parent.GetSkillData);

return {
    create = function(p1) -- Line: 30, Name: create
        -- upvalues: GetSkillData (copy)
        local v2 = p1 or {};
        local v3 = {
            character = nil,
            skillInputData = nil,
            characterId = v2.characterId,
            characterType = v2.characterType,
            skillCastId = v2.skillCastId,
            baseSkillInstanceId = v2.baseSkillInstanceId,
            activeBaseSkillIndex = v2.activeBaseSkillIndex,
            releaseCF = v2.releaseCF,
            targetCF = v2.targetCF,
            moveDirectionStr = v2.moveDirectionStr,
            combatSeed = v2.combatSeed,
            trackTargetId = v2.trackTargetId,
            skillTargetData = v2.skillTargetData,
            skillID = v2.skillID
        };
        v3.character = GetSkillData.getCharacter(v3.characterType, v3.characterId);
        v3.skillInputData = {
            characterId = v3.characterId,
            characterType = v3.characterType,
            releaseCF = v3.releaseCF,
            targetCF = v3.targetCF,
            moveDirectionStr = v3.moveDirectionStr,
            character = v3.character,
            skillCastId = v3.skillCastId,
            baseSkillInstanceId = v3.baseSkillInstanceId,
            activeBaseSkillIndex = v3.activeBaseSkillIndex,
            trackTargetId = v3.trackTargetId,
            skillTargetData = v3.skillTargetData
        };

        return v3;
    end,

    refreshCharacter = function(p4) -- Line: 69, Name: refreshCharacter
        -- upvalues: GetSkillData (copy)
        p4.character = GetSkillData.getCharacter(p4.characterType, p4.characterId);

        if p4.skillInputData then
            p4.skillInputData.character = p4.character;
        end;
    end,

    update = function(p5, p6) -- Line: 79, Name: update
        -- upvalues: GetSkillData (copy)
        if not p6 then
            return;
        end;

        for i, v in pairs(p6) do
            if i ~= "skillInputData" and i ~= "character" then
                p5[i] = v;
            end;

            if i == "trackTargetId" and p5.skillInputData then
                p5.skillInputData.trackTargetId = v;
            end;

            if i == "skillTargetData" and p5.skillInputData then
                p5.skillInputData.skillTargetData = v;
            end;
        end;

        if p5.skillInputData then
            if p6.skillCastId ~= nil then
                p5.skillInputData.skillCastId = p6.skillCastId;
            end;

            if p6.baseSkillInstanceId ~= nil then
                p5.skillInputData.baseSkillInstanceId = p6.baseSkillInstanceId;
            end;

            if p6.activeBaseSkillIndex ~= nil then
                p5.skillInputData.activeBaseSkillIndex = p6.activeBaseSkillIndex;
            end;

            if p6.releaseCF ~= nil then
                p5.skillInputData.releaseCF = p6.releaseCF;
            end;

            if p6.targetCF ~= nil then
                local skillDistanceLimit = p6.skillModule.skillDistanceLimit;

                if skillDistanceLimit then
                    p5.skillInputData.targetCF = GetSkillData.getLimitedTargetCF(p5.skillInputData.releaseCF, p6.targetCF, skillDistanceLimit);
                else
                    p5.skillInputData.targetCF = p6.targetCF;
                end;
            end;

            if p6.moveDirectionStr ~= nil then
                p5.skillInputData.moveDirectionStr = p6.moveDirectionStr;
            end;

            if p6.approachLandWorldPos ~= nil then
                p5.skillInputData.approachLandWorldPos = p6.approachLandWorldPos;
            end;

            if p6.moveFaceMode ~= nil then
                p5.skillInputData.moveFaceMode = p6.moveFaceMode;
            end;

            if p6.moveFaceWorldPos ~= nil then
                p5.skillInputData.moveFaceWorldPos = p6.moveFaceWorldPos;
            end;

            if p6.multThunderPathPoints ~= nil then
                p5.skillInputData.multThunderPathPoints = p6.multThunderPathPoints;
            end;

            if typeof(p6.multThunderSpawnGround) == "Vector3" then
                p5.skillInputData.multThunderSpawnGround = p6.multThunderSpawnGround;
            end;

            if p6.character ~= nil then
                p5.skillInputData.character = p6.character;
            end;
        end;
    end
};