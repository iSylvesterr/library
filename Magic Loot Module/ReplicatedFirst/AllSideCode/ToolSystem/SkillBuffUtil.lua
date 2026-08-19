-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local EnumMgr = UtilsSystem.EnumMgr;
local CfgFind = UtilsSystem.CfgFind;
local Config = require(script.Config);
local RuntimeWindow = require(script.RuntimeWindow);
local Apply = require(script.Apply);
local BeSheep = require(script.BeSheep);
require(script.Dot.Registry);
local EnvDot = require(script.Dot.EnvDot);
local Tick = require(script.Dot.Tick);
local ElementAttach = require(script.ElementAttach);

return {
    PlayBeSheepPresentation = function(p1) -- Line: 49, Name: PlayBeSheepPresentation
        -- upvalues: BeSheep (copy)
        BeSheep.playPresentation(p1);
    end,

    IsBeSheepExcludedTarget = function(p2) -- Line: 53, Name: IsBeSheepExcludedTarget
        -- upvalues: BeSheep (copy)
        return BeSheep.isExcludedTarget(p2);
    end,

    IsPolymorphActive = function(p3) -- Line: 57, Name: IsPolymorphActive
        -- upvalues: BeSheep (copy)
        return BeSheep.isPolymorphActive(p3);
    end,

    PlayBeSheepCasterSuccessFx = function(p4, p5) -- Line: 61, Name: PlayBeSheepCasterSuccessFx
        -- upvalues: BeSheep (copy)
        BeSheep.playCasterSuccessFx(p4, p5);
    end,

    PlayBeSheepCasterSuccessFxFromMaterial = function(p6, p7) -- Line: 65, Name: PlayBeSheepCasterSuccessFxFromMaterial
        -- upvalues: BeSheep (copy)
        BeSheep.playCasterSuccessFxFromMaterial(p6, p7);
    end,

    TryApplyBeSheepToEnemy = function(p8, p9, p10, p11) -- Line: 69, Name: TryApplyBeSheepToEnemy
        -- upvalues: BeSheep (copy)
        return BeSheep.tryApplyToEnemy(p8, p9, p10, p11);
    end,

    ResolveEnvHazardDotParams = function(p12) -- Line: 82, Name: ResolveEnvHazardDotParams
        -- upvalues: Config (copy)
        return Config.resolveEnvHazardDotParams(p12);
    end,

    GetDurSecForBuffInstance = function(p13) -- Line: 86, Name: GetDurSecForBuffInstance
        -- upvalues: Config (copy)
        return Config.getDurSecForBuffInstance(p13);
    end,

    GetDurSecFromSkillBuffs = function(p14) -- Line: 90, Name: GetDurSecFromSkillBuffs
        -- upvalues: Config (copy)
        return Config.getDurSecFromSkillBuffs(p14);
    end,

    GetDurSecForBuffRuntimeTag = function(p15) -- Line: 94, Name: GetDurSecForBuffRuntimeTag
        -- upvalues: Config (copy)
        return Config.getDurSecForBuffRuntimeTag(p15);
    end,

    GetPrimaryScalarForBuffRuntimeTag = function(p16) -- Line: 98, Name: GetPrimaryScalarForBuffRuntimeTag
        -- upvalues: Config (copy)
        return Config.getPrimaryScalarForBuffRuntimeTag(p16);
    end,

    IsSkillBuffRuntimeWindowActive = function(p17, p18) -- Line: 102, Name: IsSkillBuffRuntimeWindowActive
        -- upvalues: RuntimeWindow (copy)
        return RuntimeWindow.isSkillBuffRuntimeWindowActive(p17, p18);
    end,

    IsReflectThornsWindowActive = function(p19) -- Line: 106, Name: IsReflectThornsWindowActive
        -- upvalues: RuntimeWindow (copy)
        return RuntimeWindow.isReflectThornsWindowActive(p19);
    end,

    GetPrimaryScalarFromBuffInst = function(p20) -- Line: 110, Name: GetPrimaryScalarFromBuffInst
        -- upvalues: Config (copy)
        return Config.getPrimaryScalarFromBuffInst(p20);
    end,

    GetProcChanceFromBuffInst = function(p21) -- Line: 114, Name: GetProcChanceFromBuffInst
        -- upvalues: CfgFind (copy), Config (copy)
        local v22 = tonumber(p21);

        if not v22 or v22 <= 0 then
            return nil;
        end;

        local v23 = CfgFind.FindSkillBuffInst(v22);

        return Config.procChanceFromBuffRow(v23);
    end,

    GetReflectThornsPrimaryScalar = function() -- Line: 123, Name: GetReflectThornsPrimaryScalar
        -- upvalues: Config (copy), EnumMgr (copy)
        return Config.getPrimaryScalarForBuffRuntimeTag(EnumMgr.SkillBuffRuntimeTag.ReflectThorns);
    end,

    HasElementAttach = function(p24, p25) -- Line: 127, Name: HasElementAttach
        -- upvalues: ElementAttach (copy)
        return ElementAttach.hasAttach(p24, p25);
    end,

    GetElementTraitAmp = function(p26, p27) -- Line: 131, Name: GetElementTraitAmp
        -- upvalues: ElementAttach (copy)
        return ElementAttach.getTraitAmp(p26, p27);
    end,

    GetActiveElementTps = function(p28) -- Line: 135, Name: GetActiveElementTps
        -- upvalues: ElementAttach (copy)
        return ElementAttach.getActiveElementTps(p28);
    end,

    ConsumeElementAttach = function(p29, p30) -- Line: 139, Name: ConsumeElementAttach
        -- upvalues: ElementAttach (copy)
        return ElementAttach.consumeAttach(p29, p30);
    end,

    GetElementAttachTier = function(p31, p32) -- Line: 143, Name: GetElementAttachTier
        -- upvalues: ElementAttach (copy)
        return ElementAttach.getAttachTier(p31, p32);
    end,

    GetEnvHazardActiveLeaseSec = function() -- Line: 147, Name: GetEnvHazardActiveLeaseSec
        -- upvalues: EnvDot (copy)
        return EnvDot.getActiveLeaseSec();
    end,

    SyncEnvHazardDot = function(p33, p34, p35, p36, p37) -- Line: 151, Name: SyncEnvHazardDot
        -- upvalues: EnvDot (copy)
        EnvDot.sync(p33, p34, p35, p36, p37);
    end,

    ExtendEnvHazardDotLease = function(p38, p39, p40) -- Line: 161, Name: ExtendEnvHazardDotLease
        -- upvalues: EnvDot (copy)
        return EnvDot.extendLease(p38, p39, p40);
    end,

    ClearEnvHazardDotsForPlayer = function(p41) -- Line: 165, Name: ClearEnvHazardDotsForPlayer
        -- upvalues: EnvDot (copy)
        EnvDot.clearForPlayer(p41);
    end,

    ApplyBuffsFromSkillForCaster = function(p42, p43, p44) -- Line: 173, Name: ApplyBuffsFromSkillForCaster
        -- upvalues: Apply (copy)
        Apply.ApplyBuffsFromSkillForCaster(p42, p43, p44);
    end,

    ApplySelfBuffInst = function(p45, p46, p47) -- Line: 177, Name: ApplySelfBuffInst
        -- upvalues: Apply (copy)
        Apply.ApplySelfBuffInst(p45, p46, p47);
    end,

    RevokeSelfAttrBuffByRuntimeTag = function(p48, p49) -- Line: 181, Name: RevokeSelfAttrBuffByRuntimeTag
        -- upvalues: Apply (copy)
        Apply.RevokeSelfAttrBuffByRuntimeTag(p48, p49);
    end,

    TryProcCastTraitsOnSkillCast = function(p50, p51, p52) -- Line: 185, Name: TryProcCastTraitsOnSkillCast
        -- upvalues: Apply (copy)
        Apply.TryProcCastTraitsOnSkillCast(p50, p51, p52);
    end,

    ApplySkillBuffsToDefender = function(p53, p54, p55) -- Line: 189, Name: ApplySkillBuffsToDefender
        -- upvalues: Apply (copy)
        Apply.ApplySkillBuffsToDefender(p53, p54, p55);
    end,

    TickSkillBuffRuntime = function() -- Line: 193, Name: TickSkillBuffRuntime
        -- upvalues: RunService (copy), RuntimeWindow (copy), ElementAttach (copy), Apply (copy), Tick (copy)
        if not RunService:IsServer() then
            return;
        end;

        local v56 = workspace:GetServerTimeNow();
        RuntimeWindow.pruneExpired(v56);
        ElementAttach.runDotTicks(v56);
        ElementAttach.pruneExpired(v56);
        Apply.PruneAttrBuffLeases();
        Tick.run(v56);
    end
};