-- Decompiled with Potassium's decompiler.

local v1 = {};
local u2 = {
    skillName = true,
    skillCooldown = true,
    skillElementType = true,
    syncRadius = true,
    hitConfirmRadius = true,
    stopSyncRadius = true,
    damageTipRadius = true,
    suppressions = true,
    predictPresentation = true,
    clientObserverMaxDuration = true,
    clientObserverFxTailSeconds = true
};

function v1.normalizeSkillData(p3) -- Line: 54
    -- upvalues: u2 (copy)
    local v4 = p3 or {};
    local v5 = type(v4.syncRadius) == "number" and (v4.syncRadius or 120) or 120;
    local v6 = {
        predictPresentation = false,
        skillName = v4.skillName,
        skillCooldown = type(v4.skillCooldown) == "number" and (v4.skillCooldown or 0) or 0,
        skillElementType = v4.skillElementType,
        syncRadius = v5
    };
    local v7;

    if type(v4.hitConfirmRadius) == "number" then
        v7 = v4.hitConfirmRadius or v5;
    else
        v7 = v5;
    end;

    v6.hitConfirmRadius = v7;

    if type(v4.stopSyncRadius) == "number" then
        v5 = v4.stopSyncRadius or v5;
    end;

    v6.stopSyncRadius = v5;
    v6.damageTipRadius = type(v4.damageTipRadius) == "number" and (v4.damageTipRadius or 60) or 60;
    v6.suppressions = v4.suppressions;
    local v8;

    if type(v4.clientObserverMaxDuration) == "number" and v4.clientObserverMaxDuration > 0 then
        v8 = v4.clientObserverMaxDuration or nil;
    else
        v8 = nil;
    end;

    v6.clientObserverMaxDuration = v8;
    local v9;

    if type(v4.clientObserverFxTailSeconds) == "number" and v4.clientObserverFxTailSeconds >= 0 then
        v9 = v4.clientObserverFxTailSeconds or nil;
    else
        v9 = nil;
    end;

    v6.clientObserverFxTailSeconds = v9;

    for i, v in pairs(v4) do
        if not u2[i] then
            v6[i] = v;
        end;
    end;

    return v6;
end;

return v1;