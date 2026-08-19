-- Decompiled with Potassium's decompiler.

local SkillHitPresentationConfig = require(script.Parent.SkillHitPresentationConfig);
local u3 = {
    resolve = function(p1) -- Line: 27, Name: resolve
        -- upvalues: SkillHitPresentationConfig (copy)
        if type(p1) ~= "string" or p1 == "" then
            return nil;
        end;

        local v2 = SkillHitPresentationConfig[p1];

        if type(v2) ~= "table" then
            return nil;
        end;

        if v2.skipPresentation == true then
            return {
                effectName = "",
                soundKey = "",
                skipPresentation = true
            };
        end;

        local effectName = v2.effectName;
        local soundKey = v2.soundKey;

        if type(effectName) ~= "string" or effectName == "" then
            warn("[SkillHitPresentationProfile] 无效预设 effectName:", p1);

            return nil;
        end;

        if type(soundKey) == "string" and soundKey ~= "" then
            return {
                skipPresentation = false,
                effectName = effectName,
                soundKey = soundKey
            };
        end;

        warn("[SkillHitPresentationProfile] 无效预设 soundKey:", p1);

        return nil;
    end
};

function u3.resolveHitboxEntry(p4) -- Line: 69
    -- upvalues: u3 (copy)
    local v5;

    if p4 then
        v5 = p4.HitPresentationProfile;
    else
        v5 = p4;
    end;

    if type(v5) == "string" and v5 ~= "" then
        local v6 = u3.resolve(v5);

        if v6 then
            return v6;
        end;

        warn("[SkillHitPresentationProfile] 未知预设，回退通用受击:", v5);
    end;

    local v7;

    if p4 then
        v7 = p4.EffectName;
    else
        v7 = p4;
    end;

    if p4 then
        p4 = p4.SoundName;
    end;

    local v8 = (type(v7) ~= "string" or v7 == "") and "通用受击" or v7;
    local v9 = (type(p4) ~= "string" or p4 == "") and "通用受击" or p4;
    local v10 = u3.resolve("通用受击");

    return (not v10 or v10.skipPresentation == true) and {
        skipPresentation = false,
        effectName = v8,
        soundKey = v9
    } or v10;
end;

return u3;