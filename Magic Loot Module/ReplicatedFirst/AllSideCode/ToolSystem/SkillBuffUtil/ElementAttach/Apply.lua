-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local EnumMgr = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).EnumMgr;
local Config = require(script.Parent.Parent.Config);
local Util = require(script.Parent.Parent.Dot.Util);
local Presentation = require(script.Parent.Presentation);
local Registry = require(script.Parent.Registry);

return {
    registerFromBuffRow = function(p1, p2, p3, p4, p5) -- Line: 25, Name: registerFromBuffRow
        -- upvalues: RunService (copy), EnumMgr (copy), Config (copy), Util (copy), Registry (copy), Presentation (copy)
        if not RunService:IsServer() then
            return false;
        end;

        if not (p1 and p1.Parent) then
            return false;
        end;

        local v6;

        if p4 then
            v6 = p4.EffectType;
        else
            v6 = p4;
        end;

        if (tonumber(v6) or 0) ~= EnumMgr.SkillBuffEffectType.ElementTrait then
            return false;
        end;

        local v7;

        if p3 then
            v7 = p3.BuffTp;
        else
            v7 = p3;
        end;

        local v8 = tonumber(v7) or 0;
        local v9 = Config.elementTpFromElementTraitBuffTp(v8);

        if v9 == EnumMgr.ElementTp.None then
            local v10;

            if p3 then
                v10 = p3.RuntimeTag;
            else
                v10 = p3;
            end;

            v9 = Config.elementTpFromElementTraitRuntimeTag(v10);
        end;

        if v9 == EnumMgr.ElementTp.None then
            warn("[SkillBuffUtil] ElementTrait missing element mapping BuffTp " .. tostring(v8));

            return false;
        end;

        local v11 = Config.durFromRow(p3);

        if v11 <= 0 then
            warn("[SkillBuffUtil] ElementTrait DurSec<=0 BuffInst " .. tostring(p2));

            return false;
        end;

        local v12 = tonumber(p2) or 0;

        if v12 <= 0 then
            return false;
        end;

        local v13;

        if p3 then
            v13 = p3.CombatValKey;
        else
            v13 = p3;
        end;

        local v14;

        if Config.elementTraitKindFromCombatValKey(v13) == EnumMgr.ElementTraitKind.Dot then
            local v15 = Util.resolveCasterPlayer(p5);

            if not v15 then
                warn("[SkillBuffUtil] StackDot ElementTrait 需 Player 施法者 BuffInst " .. tostring(p2));

                return false;
            end;

            local v16;

            if p3 then
                v16 = p3.MaxTier;
            else
                v16 = p3;
            end;

            local v17 = tonumber(v16) or 1;
            local v18 = Config.dotIntervalFromBuffRow(p3);
            v14 = Registry.registerStackDotHit(p1, v9, v11, v12, v17, v18, v15.UserId, Config.shouldPlayDotHit(p4));
        else
            local v19;

            if p3 then
                v19 = p3.MaxTier;
            else
                v19 = p3;
            end;

            local v20 = tonumber(v19) or 1;
            v14 = Registry.register(p1, v9, v11, v12, v20);
        end;

        if v14 then
            local v21 = Util.resolveCasterPlayer(p5);
            local v22 = not v21 and 0 or v21.UserId;
            Presentation.fireAttachVfxFromTypeRow(p4, p1, v22, v11);
            Presentation.fireAttachTipFromBuffRow(p3, p1, v22, v9);
        end;

        return v14;
    end
};