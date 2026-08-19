-- Decompiled with Potassium's decompiler.

local BaseSkillDefinitionLoader = require(script.Parent.BaseSkillDefinitionLoader);
local SkillDataSchema = require(script.Parent.SkillDataSchema);
local v1 = {};

local function sumStateDurations(p2) -- Line: 16
    if p2 then
        p2 = p2.States;
    end;

    if type(p2) ~= "table" then
        return 0;
    end;

    local v3 = 0;

    for _, v in pairs(p2) do
        if type(v) == "table" and not v.IsTerminal then
            local Duration = v.Duration;

            if type(Duration) == "number" and Duration > 0 then
                v3 = v3 + Duration;
            end;
        end;
    end;

    return v3;
end;

local function segmentUpperBoundSeconds(p4) -- Line: 33
    -- upvalues: BaseSkillDefinitionLoader (copy), sumStateDurations (copy)
    local v5 = BaseSkillDefinitionLoader.load(p4);

    if not (v5 and v5.skillModule) then
        return 30, 0;
    end;

    local skillModule = v5.skillModule;
    local skillTotalTime = skillModule.skillTotalTime;

    if type(skillTotalTime) == "number" and skillTotalTime > 0 then
        local visualFadeoutTime = skillModule.visualFadeoutTime;

        return skillTotalTime, (type(visualFadeoutTime) ~= "number" or (visualFadeoutTime <= 0 or not visualFadeoutTime)) and 0 or visualFadeoutTime;
    end;

    local v6 = sumStateDurations(skillModule);
    local visualFadeoutTime = skillModule.visualFadeoutTime;

    return v6 <= 0 and 30 or v6, (type(visualFadeoutTime) ~= "number" or (visualFadeoutTime <= 0 or not visualFadeoutTime)) and 0 or visualFadeoutTime;
end;

function v1.estimateForGroupSkill(p7) -- Line: 58
    -- upvalues: SkillDataSchema (copy), segmentUpperBoundSeconds (copy)
    if type(p7) ~= "table" then
        return 180;
    end;

    local v8 = SkillDataSchema.normalizeSkillData(p7.Data);
    local clientObserverMaxDuration = v8.clientObserverMaxDuration;

    if type(clientObserverMaxDuration) == "number" and clientObserverMaxDuration > 0 then
        return math.clamp(clientObserverMaxDuration, 2, 180);
    end;

    local clientObserverFxTailSeconds = v8.clientObserverFxTailSeconds;
    local v9 = (type(clientObserverFxTailSeconds) ~= "number" or clientObserverFxTailSeconds < 0) and 0.5 or clientObserverFxTailSeconds;
    local Skill = p7.Skill;

    if type(Skill) ~= "table" then
        return math.clamp(30 + v9, 2, 180);
    end;

    local v10 = 0;

    for _, v in Skill do
        if type(v) == "table" and type(v.baseSkillName) == "string" then
            local v11, v12 = segmentUpperBoundSeconds(v.baseSkillName);
            v10 = v10 + (v11 + v12);
        end;
    end;

    return math.clamp((v10 <= 0 and 30 or v10) + v9, 2, 180);
end;

return v1;