-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local SkillSyncRouter = require(script.Parent.SkillSyncRouter);
local GetSkillData = require(script.Parent.GetSkillData);
local u1 = {
    SyncPolicy = {
        BaseSkillStarted = {
            track = true,
            defaultRadius = "syncRadius"
        },
        Derived = {
            track = true,
            defaultRadius = "syncRadius"
        },
        BaseSkillStateTransition = {
            track = true,
            defaultRadius = "syncRadius"
        },
        ProjectileHitConfirmed = {
            track = true,
            defaultRadius = "hitConfirmRadius",
            fallback = "syncRadius"
        },
        ProximityStrikeWave = {
            track = true,
            defaultRadius = "syncRadius"
        },
        SolarFlareMeteorShot = {
            track = true,
            defaultRadius = "syncRadius"
        },
        ProjectilePathConfirmed = {
            track = true,
            defaultRadius = "syncRadius"
        },
        StopSkill = {
            track = true,
            deliverTrackedAudience = true,
            defaultRadius = "stopSyncRadius",
            fallback = "syncRadius"
        },
        DamageTip = {
            track = false,
            defaultRadius = "damageTipRadius",
            fallback = 60
        }
    }
};

local function getCasterPlayer(p2) -- Line: 33
    -- upvalues: Players (copy), GetSkillData (copy)
    local v3 = p2.owner or p2;
    local characterType = v3.characterType;
    local characterId = v3.characterId;

    if characterType == "Player" and characterId then
        return Players:GetPlayerByUserId(characterId);
    end;

    if characterType == "Mirror" and characterId then
        local v4 = GetSkillData.getCharacter("Mirror", characterId);

        if v4 then
            v4 = v4:GetAttribute("OwnerUserId");
        end;

        if typeof(v4) == "number" then
            return Players:GetPlayerByUserId(v4);
        end;
    end;

    return nil;
end;

local function getNpcVisibilityModel(p5) -- Line: 50
    -- upvalues: GetSkillData (copy)
    local v6 = p5.owner or p5;

    if v6.characterType == "NPC" and v6.characterId then
        local v7 = GetSkillData.getCharacter("NPC", v6.characterId);

        if v7 and v7:IsA("Model") then
            return v7;
        end;
    end;

    return nil;
end;

local function resolveRadius(p8, p9, p10) -- Line: 67
    if p8.getSyncRadius then
        return p8:getSyncRadius(p10);
    end;

    if p8.groupSkillModule and p8.groupSkillModule.Data then
        local Data = p8.groupSkillModule.Data;
        local defaultRadius = p9.defaultRadius;

        if type(Data[defaultRadius]) == "number" then
            return Data[defaultRadius];
        end;

        if type(p9.fallback) == "string" and type(Data[p9.fallback]) == "number" then
            return Data[p9.fallback];
        end;

        if type(p9.fallback) == "number" then
            return p9.fallback;
        end;
    end;

    return p9.fallback == 60 and 60 or 120;
end;

function u1.dispatch(p11, p12, p13, p14) -- Line: 94
    -- upvalues: u1 (copy), resolveRadius (copy), getCasterPlayer (copy), GetSkillData (copy), SkillSyncRouter (copy)
    local v15 = u1.SyncPolicy[p12];

    if not v15 then
        warn("[SkillSyncDispatcher] 未知事件类型:", p12);

        return;
    end;

    local v16 = resolveRadius(p11, v15, p12);
    local v17 = getCasterPlayer(p11);
    local v18 = p11.owner or p11;
    local v19;

    if v18.characterType == "NPC" and v18.characterId then
        v19 = GetSkillData.getCharacter("NPC", v18.characterId);

        if not (v19 and v19:IsA("Model")) then
            v19 = nil;
        end;
    else
        v19 = nil;
    end;

    local skillCastId = p11.skillCastId;

    if p12 == "DamageTip" then
        local v20 = p13.hitPos or p14;
        SkillSyncRouter.broadcastDamageTipRelevant(v20, v16, v20, p13.damageText or "0", p13.isCrit or false, p13.dmgType, v17, v19);

        return;
    end;

    if v15.deliverTrackedAudience then
        SkillSyncRouter.broadcastStopTrackedAndClear(skillCastId, p13, p14, v16, v17, v19);

        return;
    end;

    if v15.track then
        SkillSyncRouter.broadcastRelevantAndTrack(skillCastId, p14, v16, p13, v17, v19);

        return;
    end;

    SkillSyncRouter.broadcastRelevant(p14, v16, p13, v17, v19);
end;

return u1;