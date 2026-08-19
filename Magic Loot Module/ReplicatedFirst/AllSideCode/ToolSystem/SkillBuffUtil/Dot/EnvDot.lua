-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local CfgFind = UtilsSystem.CfgFind;
local Config = require(script.Parent.Parent.Config);
local Registry = require(script.Parent.Registry);
local Presentation = require(script.Parent.Presentation);
local Util = require(script.Parent.Util);
local u1 = {};
local u2 = {};
local u15 = {
    getActiveLeaseSec = function() -- Line: 25, Name: getActiveLeaseSec
        -- upvalues: Util (copy)
        return Util.ENV_HAZARD_ACTIVE_LEASE_SEC;
    end,

    applyTick = function(p3, p4, p5, p6, p7) -- Line: 30, Name: applyTick
        -- upvalues: Players (copy), Util (copy), u1 (copy), UtilsSystem (copy), Presentation (copy)
        local v8 = Players:GetPlayerFromCharacter(p3);

        if not v8 or p3 ~= v8.Character then
            return;
        end;

        local v9 = p3:FindFirstChildOfClass("Humanoid");

        if not v9 or v9.Health <= 0 then
            return;
        end;

        local v10 = workspace:GetServerTimeNow();
        local v11 = tonumber(p6) or 1;

        if v11 < Util.SKILL_DOT_MIN_INTERVAL then
            v11 = Util.SKILL_DOT_MIN_INTERVAL;
        end;

        local v12 = u1[v8.UserId];

        if v12 and v10 < v12 + v11 then
            return;
        end;

        u1[v8.UserId] = v10;
        local GetData = UtilsSystem.GetData;
        local SystemEnvironment = UtilsSystem.SystemEnvironment;

        if SystemEnvironment and SystemEnvironment.AdvanceMagmaResOnDotTick then
            SystemEnvironment.AdvanceMagmaResOnDotTick(v8, v10);
        end;

        local v13 = not (SystemEnvironment and SystemEnvironment.GetMagmaEnvResMul) and 1 or SystemEnvironment.GetMagmaEnvResMul(v8, v10);
        local v14 = GetData.GetEnvHazardDotTickDamage(p3, p4, p5, v13);

        if v14 <= 0 then
            return;
        end;

        Util.dotDmgPlr(v8, v14);

        if p7 == true then
            Presentation.firePlayerDotHitReaction(v8);
        end;
    end
};

function u15.sync(p16, p17, p18, p19, p20) -- Line: 76
    -- upvalues: RunService (copy), Config (copy), CfgFind (copy), Registry (copy), Util (copy), Presentation (copy), u15 (copy), u2 (copy)
    if not RunService:IsServer() then
        return;
    end;

    if not p16 or (not p16.Parent or (type(p17) ~= "string" or p17 == "")) then
        return;
    end;

    local Character = p16.Character;

    if not Character then
        return;
    end;

    local _, v21 = Config.buffInstByTag(p17);

    if not v21 then
        warn("[SkillBuffUtil] SyncEnvHazardDot 无 skillbuffConf RuntimeTag=" .. p17);

        return;
    end;

    local RuntimeTag = v21.RuntimeTag;

    if type(RuntimeTag) ~= "string" or RuntimeTag == "" then
        warn("[SkillBuffUtil] SyncEnvHazardDot 配表缺 RuntimeTag tag=" .. p17);

        return;
    end;

    local v22 = CfgFind.FindSkillBuffType(tonumber(v21.BuffTp) or 0);

    if not v22 then
        return;
    end;

    local v23 = Config.elementTpFromSkillBuffDotType(v22.DotType);
    local v24 = Registry.genKey(RuntimeTag);
    local v25 = tonumber(p19);

    if not v25 or (v25 ~= v25 or v25 <= 0) then
        return;
    end;

    local v26 = tonumber(p20) or 1;

    if v26 < Util.SKILL_DOT_MIN_INTERVAL then
        v26 = Util.SKILL_DOT_MIN_INTERVAL;
    end;

    local ENV_HAZARD_ACTIVE_LEASE_SEC = Util.ENV_HAZARD_ACTIVE_LEASE_SEC;
    local v27 = workspace:GetServerTimeNow();
    local v28 = type(v22.Effects) == "string" and (v22.Effects or "") or "";
    local v29 = Config.shouldPlayDotHit(v22);

    if not p18 then
        if v28 ~= "" then
            Presentation.broadcastEnvDotVfxStop(p16, v28);
        end;

        Registry.invalidate(Character, v24, true);

        return;
    end;

    local v30 = Character:FindFirstChildOfClass("Humanoid");

    if not v30 or v30.Health <= 0 then
        return;
    end;

    local v31 = Registry.getUniqueEnvEntry(Character, v24);

    if v31 then
        Registry.renew(v31, math.max(v31.endAt, v27 + ENV_HAZARD_ACTIVE_LEASE_SEC), v22, Character, p16.UserId, ENV_HAZARD_ACTIVE_LEASE_SEC, true);

        return;
    end;

    Registry.removeEntries(Character, v24, true);
    local v32 = Registry.bumpGen(Character, v24);
    local insert = Registry.insert;
    local v33 = {
        isEnvHazard = true,
        defender = Character,
        genKey = v24,
        casterUserId = p16.UserId,
        eleTp = v23,
        coeff = v25,
        endAt = v27 + ENV_HAZARD_ACTIVE_LEASE_SEC,
        interval = v26,
        nextTickAt = v27 + v26,
        typeRow = v22,
        vfxDurationSec = ENV_HAZARD_ACTIVE_LEASE_SEC
    };

    if v28 == "" then
        v28 = nil;
    end;

    v33.envVfxName = v28;
    v33.playDotHit = v29;
    insert(v33, v32);
    u15.applyTick(Character, v23, v25, v26, v29);
    Presentation.fireDotVfxFromTypeRow(v22, Character, p16.UserId, ENV_HAZARD_ACTIVE_LEASE_SEC * 4);
    u2[p16.UserId] = v27;
end;

function u15.extendLease(p34, p35, p36) -- Line: 158
    -- upvalues: RunService (copy), Registry (copy), Util (copy), u2 (copy), Presentation (copy)
    if not RunService:IsServer() then
        return false;
    end;

    if not p34 or (not p34.Parent or (type(p35) ~= "string" or p35 == "")) then
        return false;
    end;

    local Character = p34.Character;

    if not Character then
        return false;
    end;

    local v37 = tonumber(p36);

    if not v37 or v37 <= 0 then
        return false;
    end;

    local v38 = Registry.getUniqueEnvEntry(Character, Registry.genKey(p35));

    if not v38 then
        return false;
    end;

    local v39 = workspace:GetServerTimeNow();
    local v40 = math.max(v37, Util.ENV_HAZARD_ACTIVE_LEASE_SEC);
    v38.endAt = math.max(v38.endAt, v39 + v40);

    if v39 - (u2[p34.UserId] or 0) >= Util.ENV_VFX_RENEW_SEC then
        local envVfxName = v38.envVfxName;

        if type(envVfxName) == "string" and envVfxName ~= "" then
            Presentation.broadcastDotVfx(Character, envVfxName, p34.UserId, Util.ENV_HAZARD_ACTIVE_LEASE_SEC * 4);
            u2[p34.UserId] = v39;
        end;
    end;

    return true;
end;

function u15.clearForPlayer(p41) -- Line: 192
    -- upvalues: RunService (copy), u1 (copy), u2 (copy), Registry (copy), Presentation (copy)
    if not RunService:IsServer() then
        return;
    end;

    if not (p41 and p41.Parent) then
        return;
    end;

    local UserId = p41.UserId;
    local Character = p41.Character;
    u1[UserId] = nil;
    u2[UserId] = nil;
    local v42 = Registry.getEntries();
    local v43 = {};

    for i = #v42, 1, -1 do
        local v44 = v42[i];

        if v44.isEnvHazard == true and (v44.casterUserId == UserId or Character and v44.defender == Character) then
            local envVfxName = v44.envVfxName;

            if type(envVfxName) == "string" and (envVfxName ~= "" and not v43[envVfxName]) then
                v43[envVfxName] = true;
                Presentation.broadcastEnvDotVfxStop(p41, envVfxName);
            end;

            local defender = v44.defender;

            if defender and defender.Parent then
                Registry.bumpGen(defender, v44.genKey);
            end;

            Registry.removeAtIndex(i);
        end;
    end;
end;

return u15;