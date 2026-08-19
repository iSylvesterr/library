-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local Log = UtilsSystem.Log;
local Config = require(script.Parent.Parent.Config);
local Registry = require(script.Parent.Registry);
local Presentation = require(script.Parent.Presentation);
local Util = require(script.Parent.Util);

return {
    applyTick = function(p1, p2, p3, p4, p5, p6) -- Line: 21, Name: applyTick
        -- upvalues: UtilsSystem (copy), Util (copy), Players (copy), Presentation (copy), Log (copy)
        local v7 = UtilsSystem.GetData.GetSkillDotTickDamage(p2, p1, p3, p4);

        if v7 <= 0 then
            return;
        end;

        local SKILL_DOT_MIN_FINAL_DMG = Util.SKILL_DOT_MIN_FINAL_DMG;
        local v8 = math.floor(v7 + 0.5);
        local v9 = math.max(SKILL_DOT_MIN_FINAL_DMG, v8);
        local v10 = Players:GetPlayerFromCharacter(p1);

        if v10 then
            Util.dotDmgPlr(v10, v9);

            if p6 == true then
                Presentation.firePlayerDotHitReaction(v10);
            end;

            return;
        end;

        local SystemEnemy = UtilsSystem.SystemEnemy;
        local SystemSummon = UtilsSystem.SystemSummon;

        if not (SystemEnemy and SystemEnemy.getPackByModel) then
            return;
        end;

        local v11 = SystemEnemy.getPackByModel(p1);

        if not v11 and (SystemSummon and SystemSummon.getPackByModel) then
            v11 = SystemSummon.getPackByModel(p1);
        end;

        local v12 = {
            damageRate = 1,
            isCrit = false,
            attackerPlayerId = p5,
            eleTp = p3,
            skillDotFixedDamage = v9,
            dotHitReaction = p6 == true
        };

        if v11 and (v11.entity and v11.entity.onHit) then
            v11.entity.onHit(v11.entity, v12);

            return;
        end;

        Log.warn("[SkillDot] skip dot tick: no registered onHit for", p1.Name);
    end,

    register = function(p13, p14, p15, p16) -- Line: 68, Name: register
        -- upvalues: Config (copy), Util (copy), Registry (copy)
        local RuntimeTag = p14.RuntimeTag;

        if type(RuntimeTag) ~= "string" or RuntimeTag == "" then
            warn("[SkillBuffUtil] DoT 需配置 RuntimeTag 以供同标签刷新持续时间");

            return;
        end;

        local v17 = Config.durFromRow(p14);

        if v17 <= 0 then
            warn("[SkillBuffUtil] DoT DurSec<=0 跳过 BuffTp " .. tostring(p14.BuffTp));

            return;
        end;

        local v18 = Config.dotCoeffFromBuffRow(p14);

        if v18 == nil or (v18 ~= v18 or v18 == 0) then
            warn("[SkillBuffUtil] DoT 系数无效（须配置 PerValue[1]，按百分比÷100）BuffTp " .. tostring(p14.BuffTp));

            return;
        end;

        local v19 = Config.dotIntervalFromBuffRow(p14);
        local v20 = Config.elementTpFromSkillBuffDotType(p15.DotType);
        local v21 = Util.resolveCasterPlayer(p16);

        if not v21 then
            warn("[SkillBuffUtil] DoT 需 casterCtx.attacker 为 Player；未应用 BuffTp " .. tostring(p14.BuffTp));

            return;
        end;

        local v22 = Registry.genKey(RuntimeTag);
        local v23 = Registry.bumpGen(p13, v22);
        local v24 = workspace:GetServerTimeNow();
        Registry.insert({
            isEnvHazard = false,
            defender = p13,
            genKey = v22,
            casterUserId = v21.UserId,
            eleTp = v20,
            coeff = v18,
            endAt = v24 + v17,
            interval = v19,
            nextTickAt = v24 + v19,
            typeRow = p15,
            vfxDurationSec = v17,
            playDotHit = Config.shouldPlayDotHit(p15)
        }, v23);
    end
};