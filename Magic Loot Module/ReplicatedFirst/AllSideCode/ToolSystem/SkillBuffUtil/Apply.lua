-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local ServerStorage = game:GetService("ServerStorage");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local CfgFind = UtilsSystem.CfgFind;
local EnumMgr = UtilsSystem.EnumMgr;
local InsMgr = UtilsSystem.InsMgr;
local Config = require(script.Parent.Config);
local RuntimeWindow = require(script.Parent.RuntimeWindow);
local ElementAttach = require(script.Parent.ElementAttach);
local SkillDot = require(script.Parent.Dot.SkillDot);
require(script.Parent.Dot.Util);
local Stun = require(script.Parent.Handlers.Stun);
local BeSheep = require(script.Parent.Handlers.BeSheep);
local SpaceMirrorCast = require(script.Parent.Handlers.SpaceMirrorCast);
local u1 = {};
local u2 = 0;
local v3 = {};

local function addAttrsBuffDelta(p4, p5, p6) -- Line: 58
    -- upvalues: InsMgr (copy)
    local v7 = InsMgr.GetIns("Attrs_Buff", "Folder", p4);
    local v8 = InsMgr.GetIns(tostring(p5), "NumberValue", v7);
    v8.Value = v8.Value + p6;
end;

local function removeAttrBuffLease(p9, p10) -- Line: 64
    -- upvalues: u1 (copy)
    for i = #u1, 1, -1 do
        local v11 = u1[i];

        if v11.owner == p9 and v11.channel == p10 then
            table.remove(u1, i);
        end;
    end;
end;

local function revokeSelfAttrBuffByChannel(p12, p13) -- Line: 80
    -- upvalues: u2 (ref), u1 (copy), InsMgr (copy)
    if p13 == "" then
        return;
    end;

    u2 = u2 + 1;

    for i = #u1, 1, -1 do
        local v14 = u1[i];

        if v14.owner == p12 and v14.channel == p13 then
            local attrPlrId = v14.attrPlrId;
            local v15 = -v14.delta;
            local v16 = InsMgr.GetIns("Attrs_Buff", "Folder", p12);
            local v17 = InsMgr.GetIns(tostring(attrPlrId), "NumberValue", v16);
            v17.Value = v17.Value + v15;
            table.remove(u1, i);
        end;
    end;
end;

local function attrBuffChannel(p18) -- Line: 94
    local v19;

    if p18 then
        v19 = p18.RuntimeTag;
    else
        v19 = p18;
    end;

    if type(v19) == "string" and v19 ~= "" then
        return v19;
    end;

    return "buffTp_" .. tostring(p18 and p18.BuffTp or 0);
end;

local function applyTimedAttrsBuff(u20, u21, u22, p23, p24) -- Line: 103
    -- upvalues: Config (copy), EnumMgr (copy), InsMgr (copy), u1 (copy), u2 (ref), removeAttrBuffLease (copy)
    if p23 <= 0 or (u22 == 0 or u22 ~= u22) then
        return;
    end;

    if not Config.rowHasBuffAddTp(p24, EnumMgr.SkillBuffAddTp.RfDur) then
        local v25 = InsMgr.GetIns("Attrs_Buff", "Folder", u20);
        local v26 = InsMgr.GetIns(tostring(u21), "NumberValue", v25);
        v26.Value = v26.Value + u22;
        task.delay(p23, function() -- Line: 110
            -- upvalues: u20 (copy), u21 (copy), u22 (copy), InsMgr (ref)
            if u20.Parent then
                local v27 = InsMgr.GetIns("Attrs_Buff", "Folder", u20);
                local v28 = InsMgr.GetIns(tostring(u21), "NumberValue", v27);
                v28.Value = v28.Value + -u22;
            end;
        end);

        return;
    end;

    local u29;

    if p24 then
        u29 = p24.RuntimeTag;
    else
        u29 = p24;
    end;

    if type(u29) ~= "string" or u29 == "" then
        u29 = "buffTp_" .. tostring(p24 and p24.BuffTp or 0);
    end;

    local v30 = nil;

    for _, v in u1 do
        if v.owner == u20 and (v.channel == u29 and v.attrPlrId == u21) then
            v30 = v;
            break;
        end;
    end;

    if v30 then
        u2 = u2 + 1;
        v30.removeGen = u2;
        local u31 = u2;
        local delta = v30.delta;
        task.delay(p23, function() -- Line: 158
            -- upvalues: u20 (copy), removeAttrBuffLease (ref), u29 (copy), u1 (ref), u31 (copy), delta (copy), InsMgr (ref)
            if u20.Parent then
                for _, v in u1 do
                    if v.owner == u20 and (v.channel == u29 and v.removeGen == u31) then
                        local attrPlrId = v.attrPlrId;
                        local v32 = InsMgr.GetIns("Attrs_Buff", "Folder", u20);
                        local v33 = InsMgr.GetIns(tostring(attrPlrId), "NumberValue", v32);
                        v33.Value = v33.Value + -delta;
                        removeAttrBuffLease(u20, u29);

                        return;
                    end;
                end;

                return;
            end;

            removeAttrBuffLease(u20, u29);
        end);

        return;
    end;

    local v34 = InsMgr.GetIns("Attrs_Buff", "Folder", u20);
    local v35 = InsMgr.GetIns(tostring(u21), "NumberValue", v34);
    v35.Value = v35.Value + u22;
    u2 = u2 + 1;
    local u36 = u2;
    table.insert(u1, {
        owner = u20,
        channel = u29,
        attrPlrId = u21,
        delta = u22,
        removeGen = u36
    });
    task.delay(p23, function() -- Line: 138
        -- upvalues: u20 (copy), removeAttrBuffLease (ref), u29 (copy), u1 (ref), u36 (copy), InsMgr (ref)
        if u20.Parent then
            for _, v in u1 do
                if v.owner == u20 and (v.channel == u29 and v.removeGen == u36) then
                    local attrPlrId = v.attrPlrId;
                    local v37 = -v.delta;
                    local v38 = InsMgr.GetIns("Attrs_Buff", "Folder", u20);
                    local v39 = InsMgr.GetIns(tostring(attrPlrId), "NumberValue", v38);
                    v39.Value = v39.Value + v37;
                    removeAttrBuffLease(u20, u29);

                    return;
                end;
            end;

            return;
        end;

        removeAttrBuffLease(u20, u29);
    end);
end;

local function applyBuffInstance(p40, p41, p42) -- Line: 174
    -- upvalues: CfgFind (copy), EnumMgr (copy), Config (copy), applyTimedAttrsBuff (copy), RuntimeWindow (copy)
    local v43 = tonumber(p41.BuffTp);

    if not v43 or v43 <= 0 then
        warn("[SkillBuffUtil] invalid BuffTp on skillbuffConf row");

        return;
    end;

    local v44 = CfgFind.FindSkillBuffType(v43);

    if not v44 then
        warn("[SkillBuffUtil] missing skillbufftypeConf for BuffTp " .. tostring(v43));

        return;
    end;

    local v45 = tonumber(v44.EffectType) or 0;

    if v45 == EnumMgr.SkillBuffEffectType.ElementTrait or (v45 == EnumMgr.SkillBuffEffectType.CastTrait or v45 == EnumMgr.SkillBuffEffectType.DungeonPassive) then
        return;
    end;

    local v46 = Config.durFromRow(p41);
    local v47 = tonumber(v44.Attr);
    local v48 = Config.primaryScalarFromBuffRow(p41);
    local v49 = (not v48 or v48 ~= v48) and 0 or v48 * p42;

    if v47 and (v47 > 0 and (v49 ~= 0 and v49 == v49)) then
        if v46 <= 0 then
            warn("[SkillBuffUtil] DurSec<=0 skip Attr buff apply BuffTp " .. tostring(v43));
        else
            applyTimedAttrsBuff(p40, v47, v49, v46, p41);
        end;
    end;

    local v50 = RuntimeWindow.windowChannelForBuffTp(v43);

    if v50 and v46 > 0 then
        RuntimeWindow.registerSkillBuffWindow(p40, v50, v46);
    end;
end;

local function applyBuffInstanceToDefenderModel(p51, p52, p53, p54, p55) -- Line: 214
    -- upvalues: CfgFind (copy), EnumMgr (copy), RunService (copy), SkillDot (copy), ElementAttach (copy), Config (copy), applyTimedAttrsBuff (copy), RuntimeWindow (copy)
    local v56 = tonumber(p52.BuffTp);

    if not v56 or v56 <= 0 then
        warn("[SkillBuffUtil] invalid BuffTp on skillbuffConf row (defender)");

        return;
    end;

    local v57 = CfgFind.FindSkillBuffType(v56);

    if not v57 then
        warn("[SkillBuffUtil] missing skillbufftypeConf for BuffTp " .. tostring(v56));

        return;
    end;

    local v58 = tonumber(v57.EffectType) or 0;

    if v58 == EnumMgr.SkillBuffEffectType.Dot then
        if RunService:IsServer() then
            SkillDot.register(p51, p52, v57, p54);
        end;

        return;
    end;

    if v58 == EnumMgr.SkillBuffEffectType.ElementTrait then
        if RunService:IsServer() then
            local v59 = tonumber(p55) or 0;

            if v59 > 0 then
                ElementAttach.registerFromBuffRow(p51, v59, p52, v57, p54);

                return;
            end;

            warn("[SkillBuffUtil] ElementTrait missing buffInstId BuffTp " .. tostring(v56));
        end;

        return;
    end;

    local v60 = Config.durFromRow(p52);
    local v61 = tonumber(p52.IsDebuff) == 1 and 1 or p53;

    if v58 == EnumMgr.SkillBuffEffectType.StatMod or v58 == EnumMgr.SkillBuffEffectType.CrowdControl then
        local v62 = tonumber(v57.Attr);
        local v63 = Config.primaryScalarFromBuffRow(p52);
        local v64 = (not v63 or v63 ~= v63) and 0 or v63 * v61;

        if v62 and (v62 > 0 and (v64 ~= 0 and v64 == v64)) then
            if v60 <= 0 then
                warn("[SkillBuffUtil] DurSec<=0 skip defender Attr buff BuffTp " .. tostring(v56));
            else
                applyTimedAttrsBuff(p51, v62, v64, v60, p52);
            end;
        end;

        local v65 = RuntimeWindow.windowChannelForBuffTp(v56);

        if v65 and v60 > 0 then
            RuntimeWindow.registerSkillBuffWindow(p51, v65, v60);
        end;
    end;
end;

local function skillConfEligibleForRaceSkillBuffMerge(p66) -- Line: 282
    -- upvalues: EnumMgr (copy)
    if p66 then
        p66 = p66.isBase;
    end;

    return tonumber(p66) == EnumMgr.SkillTp.Skill;
end;

local function collectMergedEnemyBuffInstIdsForDefender(p67, p68) -- Line: 287
    local u69 = {};
    local u70 = {};

    local function appendList(p71) -- Line: 290
        -- upvalues: u69 (copy), u70 (copy)
        if type(p71) ~= "table" then
            return;
        end;

        for _, v in p71 do
            local v72 = tonumber(v);

            if v72 and (v72 > 0 and not u69[v72]) then
                u69[v72] = true;
                table.insert(u70, v72);
            end;
        end;
    end;

    if p67 and type(p67.buffs) == "table" then
        appendList(p67.buffs);
    end;

    return u70;
end;

local function applyEnemyBuffInstToDefenderModel(p73, p74, p75, p76) -- Line: 319
    -- upvalues: CfgFind (copy), Config (copy), Stun (copy), ServerStorage (copy), applyBuffInstanceToDefenderModel (copy), BeSheep (copy)
    local v77 = CfgFind.FindSkillBuffInst(p74);

    if not (v77 and (Config.isSkillBuffRow(v77) and Config.isEnemyBuff(v77.EffectTarget))) then
        return;
    end;

    local v78 = CfgFind.FindSkillBuffType(tonumber(v77.BuffTp) or 0);

    if Stun.isStunBuff(v77, v78) then
        local success, result = pcall(function() -- Line: 327
            -- upvalues: ServerStorage (ref)
            return require(ServerStorage.ServerSideCode.AI.Shared.NPCStun);
        end);

        if success and (result and (result.isImmune and result.isImmune(p73))) then
            return;
        end;
    end;

    applyBuffInstanceToDefenderModel(p73, v77, p75, p76, p74);
    BeSheep.tryApply(p73, v77, v78);
    Stun.tryApply(p73, v77, v78);
end;

function v3.PruneAttrBuffLeases() -- Line: 340
    -- upvalues: u1 (copy)
    for i = #u1, 1, -1 do
        if not u1[i].owner.Parent then
            table.remove(u1, i);
        end;
    end;
end;

function v3.ApplySelfBuffInst(p79, p80, p81) -- Line: 356
    -- upvalues: RunService (copy), CfgFind (copy), Config (copy), applyBuffInstance (copy)
    if not RunService:IsServer() then
        return;
    end;

    local v82 = tonumber(p80);

    if not p79 or (not v82 or v82 <= 0) then
        return;
    end;

    local v83 = CfgFind.FindSkillBuffInst(v82);

    if not (v83 and (Config.isSkillBuffRow(v83) and Config.isSelfBuff(v83.EffectTarget))) then
        return;
    end;

    applyBuffInstance(p79, v83, tonumber(p81) or 1);
end;

function v3.RevokeSelfAttrBuffByRuntimeTag(p84, p85) -- Line: 378
    -- upvalues: RunService (copy), revokeSelfAttrBuffByChannel (copy)
    if not RunService:IsServer() then
        return;
    end;

    if not p84 or (type(p85) ~= "string" or p85 == "") then
        return;
    end;

    revokeSelfAttrBuffByChannel(p84, p85);
end;

function v3.ApplyBuffsFromSkillForCaster(p86, p87, p88) -- Line: 389
    -- upvalues: RunService (copy), CfgFind (copy), EnumMgr (copy), Config (copy), applyBuffInstance (copy)
    if not RunService:IsServer() then
        return;
    end;

    if not p86 or (not p87 or p87 <= 0) then
        return;
    end;

    local v89 = CfgFind.FindCfgByID(p87, EnumMgr.ItemType.Skill);

    if not (v89 and v89.buffs) then
        return;
    end;

    for _, v in v89.buffs do
        local v90 = tonumber(v);

        if v90 and v90 > 0 then
            local v91 = CfgFind.FindSkillBuffInst(v90);

            if v91 and (Config.isSkillBuffRow(v91) and Config.isSelfBuff(v91.EffectTarget)) then
                applyBuffInstance(p86, v91, 1);
            end;
        end;
    end;
end;

function v3.TryProcCastTraitsOnSkillCast(p92, p93, p94) -- Line: 414
    -- upvalues: RunService (copy), CfgFind (copy), EnumMgr (copy), Config (copy), SpaceMirrorCast (copy)
    if not RunService:IsServer() or (not p92 or (not p93 or p93 <= 0)) then
        return;
    end;

    local v95 = CfgFind.FindCfgByID(p93, EnumMgr.ItemType.Skill);

    if not v95 or type(v95.buffs) ~= "table" then
        return;
    end;

    for _, v in v95.buffs do
        local v96 = tonumber(v);

        if v96 and v96 > 0 then
            local v97 = CfgFind.FindSkillBuffInst(v96);

            if v97 and (Config.isSkillBuffRow(v97) and Config.isSelfBuff(v97.EffectTarget)) then
                local v98 = tonumber(v97.BuffTp);

                if v98 then
                    local v99 = CfgFind.FindSkillBuffType(v98);

                    if v99 and (tonumber(v99.EffectType) == EnumMgr.SkillBuffEffectType.CastTrait and Config.castTraitKindFromBuffTp(v98) == EnumMgr.CastTraitKind.SpaceMirror) then
                        SpaceMirrorCast.tryProc({
                            plr = p92,
                            skillId = p93,
                            buffInstId = v96,
                            instRow = v97,
                            typeRow = v99,
                            skillPower = p94.skillPower,
                            skillPurity = p94.skillPurity,
                            mpTp = p94.mpTp,
                            combatSeed = p94.combatSeed,
                            skillName = p94.skillName,
                            slotIndex = p94.slotIndex,
                            skillInputData = p94.skillInputData
                        });
                    end;
                end;
            end;
        end;
    end;
end;

function v3.ApplySkillBuffsToDefender(p100, p101, p102) -- Line: 457
    -- upvalues: RunService (copy), CfgFind (copy), EnumMgr (copy), collectMergedEnemyBuffInstIdsForDefender (copy), applyEnemyBuffInstToDefenderModel (copy)
    if not RunService:IsServer() then
        return;
    end;

    if not p100 or (not p101 or p101 <= 0) then
        return;
    end;

    local v103 = CfgFind.FindCfgByID(p101, EnumMgr.ItemType.Skill);

    if not v103 then
        return;
    end;

    local v104 = collectMergedEnemyBuffInstIdsForDefender(v103, p102);

    if #v104 == 0 then
        return;
    end;

    for _, v in ipairs(v104) do
        applyEnemyBuffInstToDefenderModel(p100, v, 1, p102);
    end;
end;

return v3;