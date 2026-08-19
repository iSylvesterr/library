-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local CfgFind = UtilsSystem.CfgFind;
local EnumMgr = UtilsSystem.EnumMgr;
local u10 = {
    getDotMinInterval = function() -- Line: 43, Name: getDotMinInterval
        return 0.05;
    end,

    durFromRow = function(p1) -- Line: 52, Name: durFromRow
        if p1 then
            p1 = p1.DurSec;
        end;

        local v2 = tonumber(p1);

        return (not v2 or (v2 ~= v2 or v2 < 0)) and 0 or v2;
    end,

    rowHasBuffAddTp = function(p3, p4) -- Line: 61, Name: rowHasBuffAddTp
        if p3 then
            p3 = p3.BuffAddTp;
        end;

        if type(p3) ~= "table" then
            return false;
        end;

        local v5 = tonumber(p4);

        if not v5 then
            return false;
        end;

        for _, v in p3 do
            if tonumber(v) == v5 then
                return true;
            end;
        end;

        return false;
    end,

    primaryScalarFromBuffRow = function(p6) -- Line: 79, Name: primaryScalarFromBuffRow
        local v7;

        if p6 then
            v7 = p6.FixValue;
        else
            v7 = p6;
        end;

        if type(v7) == "table" then
            local v8 = tonumber(v7[1]);

            if v8 and (v8 == v8 and v8 ~= 0) then
                return v8;
            end;
        end;

        if p6 then
            p6 = p6.PerValue;
        end;

        if type(p6) == "table" then
            local v9 = tonumber(p6[1]);

            if v9 and (v9 == v9 and v9 ~= 0) then
                return v9 / 100;
            end;
        end;

        return nil;
    end
};

function u10.primaryScalarForBuffTp(p11) -- Line: 98
    -- upvalues: CfgFind (copy), u10 (copy)
    local v12 = CfgFind.GetCfgByName("skillbuffConf");

    if not v12 or type(v12) ~= "table" then
        return nil;
    end;

    local v13 = tonumber(p11);

    if not v13 then
        return nil;
    end;

    local v14 = (1 / 0);
    local v15 = nil;

    for i, v in pairs(v12) do
        if tonumber(v.BuffTp) == v13 then
            local v16 = tonumber(i) or (1 / 0);
            local v17 = u10.primaryScalarFromBuffRow(v);

            if v17 ~= nil and (v17 == v17 and v16 < v14) then
                v15 = v17;
                v14 = v16;
            end;
        end;
    end;

    return v15;
end;

function u10.isSelfBuff(p18) -- Line: 126
    -- upvalues: EnumMgr (copy)
    return tonumber(p18) == EnumMgr.SkillEffectTarget.Self;
end;

function u10.isEnemyBuff(p19) -- Line: 131
    -- upvalues: EnumMgr (copy)
    return tonumber(p19) == EnumMgr.SkillEffectTarget.Enemy;
end;

function u10.isSkillBuffRow(p20) -- Line: 136
    -- upvalues: EnumMgr (copy)
    if p20 then
        p20 = p20.tp;
    end;

    return tonumber(p20) == EnumMgr.ItemType.SkillBuff;
end;

function u10.buffInstByTag(p21) -- Line: 145
    -- upvalues: CfgFind (copy), u10 (copy)
    if type(p21) ~= "string" or p21 == "" then
        return nil, nil;
    end;

    local v22 = CfgFind.GetCfgByName("skillbuffConf");

    if not v22 or type(v22) ~= "table" then
        return nil, nil;
    end;

    local v23 = (1 / 0);
    local v24 = nil;

    for i, v in pairs(v22) do
        if v and (v.RuntimeTag == p21 and u10.isSkillBuffRow(v)) then
            local v25 = tonumber(i) or (1 / 0);

            if v25 < v23 then
                v24 = v;
                v23 = v25;
            end;
        end;
    end;

    if v24 then
        return v23, v24;
    end;

    return nil, nil;
end;

function u10.buffTpFromTag(p26) -- Line: 174
    -- upvalues: u10 (copy)
    local _, v27 = u10.buffInstByTag(p26);

    if not v27 then
        return nil;
    end;

    local v28 = tonumber(v27.BuffTp);

    if v28 and v28 > 0 then
        return v28;
    end;

    return nil;
end;

function u10.dotCoeffFromBuffRow(p29) -- Line: 191
    if p29 then
        p29 = p29.PerValue;
    end;

    if type(p29) ~= "table" then
        return nil;
    end;

    local v30 = tonumber(p29[1]);

    if v30 and (v30 == v30 and v30 ~= 0) then
        return v30 / 100;
    end;

    return nil;
end;

function u10.dotIntervalFromBuffRow(p31) -- Line: 204
    if p31 then
        p31 = p31.DotSec;
    end;

    local v32 = tonumber(p31);

    if (not v32 or (v32 ~= v32 or v32 <= 0)) and type(p31) == "table" then
        v32 = tonumber(p31[1]);
    end;

    return (not v32 or (v32 ~= v32 or v32 <= 0)) and 1 or (v32 < 0.05 and 0.05 or v32);
end;

function u10.elementTpFromSkillBuffDotType(p33) -- Line: 220
    -- upvalues: EnumMgr (copy)
    local v34 = tonumber(p33) or 0;

    if v34 == EnumMgr.SkillBuffDotType.Burn then
        return EnumMgr.ElementTp.Fire;
    end;

    if v34 == EnumMgr.SkillBuffDotType.DarkMagic then
        return EnumMgr.ElementTp.Dark;
    end;

    return EnumMgr.ElementTp.None;
end;

function u10.elementTpFromElementTraitBuffTp(p35) -- Line: 232
    -- upvalues: EnumMgr (copy)
    local v36 = tonumber(p35) or 0;

    if v36 == EnumMgr.SkillBuffTypeTp.WetAttach then
        return EnumMgr.ElementTp.Water;
    end;

    if v36 == EnumMgr.SkillBuffTypeTp.ScorchAttach then
        return EnumMgr.ElementTp.Fire;
    end;

    if v36 == EnumMgr.SkillBuffTypeTp.PoisonAttach then
        return EnumMgr.ElementTp.Poison;
    end;

    return EnumMgr.ElementTp.None;
end;

function u10.elementTpFromElementTraitRuntimeTag(p37) -- Line: 247
    -- upvalues: EnumMgr (copy)
    if p37 == EnumMgr.SkillBuffRuntimeTag.ElemAttach_Water then
        return EnumMgr.ElementTp.Water;
    end;

    if p37 == EnumMgr.SkillBuffRuntimeTag.ElemAttach_Fire then
        return EnumMgr.ElementTp.Fire;
    end;

    if p37 == EnumMgr.SkillBuffRuntimeTag.ElemAttach_Poison then
        return EnumMgr.ElementTp.Poison;
    end;

    return EnumMgr.ElementTp.None;
end;

function u10.elementTraitKindFromCombatValKey(p38) -- Line: 261
    -- upvalues: EnumMgr (copy)
    if type(p38) ~= "string" or p38 == "" then
        return nil;
    end;

    if p38 == "潮湿CondDmgAmp" or p38 == "灼热CondDmgAmp" then
        return EnumMgr.ElementTraitKind.CondDmgAmp;
    end;

    if p38 == "中毒StackDot" then
        return EnumMgr.ElementTraitKind.Dot;
    end;

    return nil;
end;

function u10.shouldPlayDotHit(p39) -- Line: 275
    if p39 then
        p39 = p39.DotHit ~= nil and p39.DotHit or p39.DotHitPresentation;
    end;

    if p39 == nil or p39 == "" then
        return false;
    end;

    return tonumber(p39) == 1;
end;

function u10.getDurSecForBuffInstance(p40) -- Line: 289
    -- upvalues: CfgFind (copy)
    local v41 = CfgFind.FindSkillBuffInst(p40);

    if v41 then
        v41 = v41.DurSec;
    end;

    local v42 = tonumber(v41);

    return (not v42 or (v42 ~= v42 or v42 <= 0)) and 0 or v42;
end;

function u10.getDurSecFromSkillBuffs(p43) -- Line: 299
    -- upvalues: CfgFind (copy), EnumMgr (copy), u10 (copy)
    local v44 = CfgFind.FindCfgByID(p43, EnumMgr.ItemType.Skill);

    if not (v44 and v44.buffs) then
        return 0;
    end;

    local v45 = 0;

    for _, v in v44.buffs do
        local v46 = tonumber(v);

        if v46 and v46 > 0 then
            local v47 = u10.getDurSecForBuffInstance(v46);

            if v45 < v47 then
                v45 = v47;
            end;
        end;
    end;

    return v45;
end;

function u10.getDurSecForBuffRuntimeTag(p48) -- Line: 318
    -- upvalues: CfgFind (copy), u10 (copy)
    if type(p48) ~= "string" or p48 == "" then
        return 0;
    end;

    local v49 = CfgFind.GetCfgByName("skillbuffConf");

    if not v49 or type(v49) ~= "table" then
        return 0;
    end;

    local v50 = 0;

    for _, v in pairs(v49) do
        if v and (v.RuntimeTag == p48 and u10.isSkillBuffRow(v)) then
            local v51 = u10.durFromRow(v);

            if v50 < v51 then
                v50 = v51;
            end;
        end;
    end;

    return v50;
end;

function u10.getPrimaryScalarForBuffRuntimeTag(p52) -- Line: 339
    -- upvalues: u10 (copy)
    local v53 = u10.buffTpFromTag(p52);

    if v53 then
        return u10.primaryScalarForBuffTp(v53);
    end;

    return nil;
end;

function u10.getPrimaryScalarFromBuffInst(p54) -- Line: 348
    -- upvalues: CfgFind (copy), u10 (copy)
    local v55 = CfgFind.FindSkillBuffInst(p54);

    if v55 then
        return u10.primaryScalarFromBuffRow(v55);
    end;

    return nil;
end;

function u10.perValueScalarAt(p56, p57) -- Line: 357
    if p56 then
        p56 = p56.PerValue;
    end;

    if type(p56) ~= "table" then
        return nil;
    end;

    local v58 = tonumber(p56[p57]);

    if v58 and (v58 == v58 and v58 ~= 0) then
        return v58 / 100;
    end;

    return nil;
end;

function u10.procChanceFromBuffRow(p59) -- Line: 370
    -- upvalues: u10 (copy)
    return u10.perValueScalarAt(p59, 1);
end;

function u10.mirrorDamageMulFromBuffRow(p60) -- Line: 375
    -- upvalues: u10 (copy)
    return u10.perValueScalarAt(p60, 2);
end;

function u10.castTraitKindFromBuffTp(p61) -- Line: 380
    -- upvalues: EnumMgr (copy)
    if p61 == EnumMgr.SkillBuffTypeTp.SpaceMirrorCast then
        return EnumMgr.CastTraitKind.SpaceMirror;
    end;

    return nil;
end;

function u10.resolveEnvHazardDotParams(p62) -- Line: 388
    -- upvalues: u10 (copy)
    local _, v63 = u10.buffInstByTag(p62);

    if not v63 then
        return nil, nil;
    end;

    local v64 = u10.dotCoeffFromBuffRow(v63);

    if v64 and (v64 == v64 and v64 > 0) then
        return v64, u10.dotIntervalFromBuffRow(v63);
    end;

    return nil, nil;
end;

return u10;