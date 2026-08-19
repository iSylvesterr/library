-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local CollectionService = UtilsSystem.CollectionService;
local SystemPlrAttr = UtilsSystem.SystemPlrAttr;
local SystemEnemy = UtilsSystem.SystemEnemy;
local SystemSummon = UtilsSystem.SystemSummon;
local SummonAggroSystem = UtilsSystem.SummonAggroSystem;
local VisibleMgr = UtilsSystem.VisibleMgr;
local GetData = UtilsSystem.GetData;
local SoundModule = UtilsSystem.SoundModule;
local Players = UtilsSystem.Players;
local RunService = UtilsSystem.RunService;
local GetSkillData = require(script.Parent.GetSkillData);
local SkillDamageRateFromCfg = require(script.Parent.SkillDamageRateFromCfg);
local DamageResolver = require(script.Parent.DamageResolver);
local DamageContext = require(script.Parent.DamageContext);
local HitPolicy = require(script.Parent.HitPolicy);
local EntityUtil = require(script.Parent.EntityUtil);
local HitQueryContext = require(script.Parent.HitQueryContext);
local InsMgr = UtilsSystem.InsMgr;
local Debris = UtilsSystem.Debris;
local EnemyVisibilityUtil = UtilsSystem.EnemyVisibilityUtil;
local PhysicsMotion = UtilsSystem.PhysicsMotion;
local NetWork = UtilsSystem.NetWork;
local NetMsg = UtilsSystem.NetMsg;
local u1 = UtilsSystem.SystemGameConfig.Get();
local SkillBuffUtil = UtilsSystem.SkillBuffUtil;
local HitCameraShake = UtilsSystem.HitCameraShake;
local HitPhysics = UtilsSystem.HitPhysics;

local function _resolveAttackerUserIdForShake(p2) -- Line: 58
    -- upvalues: GetSkillData (copy)
    local hitboxOwnerType = p2.hitboxOwnerType;
    local hitboxOwnerId = p2.hitboxOwnerId;

    if hitboxOwnerType == "Player" then
        return tonumber(hitboxOwnerId);
    end;

    if hitboxOwnerType == "Mirror" then
        local v3 = GetSkillData.getCharacter("Mirror", hitboxOwnerId);

        if v3 then
            v3 = v3:GetAttribute("OwnerUserId");
        end;

        if typeof(v3) == "number" then
            return v3;
        end;

        return nil;
    end;

    if hitboxOwnerType ~= "Summon" then
        return nil;
    end;

    local v4 = GetSkillData.getCharacter("Summon", hitboxOwnerId);

    if v4 then
        v4 = v4:GetAttribute("OwnerId");
    end;

    if typeof(v4) == "number" then
        return v4;
    end;

    return nil;
end;

local function _resolveBuffCasterPlayer(p5, p6) -- Line: 94
    -- upvalues: _resolveAttackerUserIdForShake (copy), Players (copy)
    local v7 = _resolveAttackerUserIdForShake(p5);

    if not v7 and p6 then
        if p6.characterType == "Player" then
            v7 = tonumber(p6.characterId);
        end;

        local skillInputData = p6.skillInputData;

        if not v7 and (skillInputData and skillInputData.characterType == "Player") then
            v7 = tonumber(skillInputData.characterId);
        end;
    end;

    if not v7 and p5.hitboxOwnerType == "Player" then
        v7 = tonumber(p5.hitboxOwnerId);
    end;

    local v8 = tonumber(v7);
    local v9 = v8 and (v8 > 0 and Players:GetPlayerByUserId(v8));

    if v9 then
        return v9;
    end;

    local v10;

    if p6 then
        v10 = p6.character;
    else
        v10 = p6;
    end;

    if typeof(v10) == "Instance" and v10:IsA("Model") then
        return Players:GetPlayerFromCharacter(v10);
    end;

    if p6 then
        p6 = p6.skillInputData;
    end;

    if p6 then
        p6 = p6.character;
    end;

    if typeof(p6) == "Instance" and p6:IsA("Model") then
        return Players:GetPlayerFromCharacter(p6);
    end;

    return nil;
end;

local function _firePlayerHitPresentation(p11, p12) -- Line: 132
    -- upvalues: NetWork (copy), NetMsg (copy)
    for _, v in p11 do
        NetWork.FireClient(v, NetMsg.PLAYER_HIT_PRESENTATION, p12);
    end;
end;

local u26 = {
    getEntityIdentity = function(p13) -- Line: 143, Name: getEntityIdentity
        -- upvalues: EntityUtil (copy)
        return EntityUtil.getEntityIdentity(p13);
    end,

    getEntityCamp = function(p14) -- Line: 150, Name: getEntityCamp
        -- upvalues: EntityUtil (copy)
        return EntityUtil.getEntityCamp(p14);
    end,

    getEntityOwnerId = function(p15) -- Line: 157, Name: getEntityOwnerId
        -- upvalues: EntityUtil (copy)
        return EntityUtil.getEntityOwnerId(p15);
    end,

    isSameEntity = function(p16, p17) -- Line: 164, Name: isSameEntity
        -- upvalues: EntityUtil (copy)
        return EntityUtil.isSameEntity(p16, p17);
    end,

    isOwner = function(p18, p19) -- Line: 174, Name: isOwner
        -- upvalues: EntityUtil (copy)
        if p18 and p19 then
            return EntityUtil.isOwnedBy(p18.hitboxOwnerId, p18.hitboxOwnerType, p19);
        end;

        return false;
    end,

    isFriendly = function(p20, p21) -- Line: 182, Name: isFriendly
        -- upvalues: EntityUtil (copy)
        if p20 and p21 then
            return EntityUtil.isFriendly({
                id = p20.hitboxOwnerId,
                type = p20.hitboxOwnerType
            }, p21);
        end;

        return false;
    end,

    canApplyHitFromContext = function(p22) -- Line: 195, Name: canApplyHitFromContext
        -- upvalues: HitPolicy (copy)
        if not p22 then
            return false;
        end;

        local v23 = p22.hitPolicy or HitPolicy.default();
        local v24 = p22.nowTime or 0;

        if not v23.allowSelfHit and p22.isOwner then
            return false;
        end;

        if not v23.allowFriendlyFire and p22.isFriendly then
            return false;
        end;

        if p22.isForeignPlayerSummon then
            return false;
        end;

        if v23.hitOncePerActivation and (p22._activationHitCount or 0) >= 1 then
            return false;
        end;

        local v25 = v23.hitOncePerTarget and (p22._hitHistory or {})[p22.targetModel];

        if v25 then
            if (v23.repeatHitCooldown or 0) <= 0 then
                return false;
            end;

            if v24 - v25 < v23.repeatHitCooldown then
                return false;
            end;
        end;

        return true;
    end
};

function u26.canApplyHit(p27, p28, p29, p30) -- Line: 229
    -- upvalues: HitQueryContext (copy), u26 (copy)
    local v31 = HitQueryContext.create(p27, p28, p30);

    if not v31 then
        return false;
    end;

    if p29 then
        v31.hitPolicy = p29;
    end;

    return u26.canApplyHitFromContext(v31);
end;

local function _getHitboxPhysicsSpeed(p32) -- Line: 243
    -- upvalues: PhysicsMotion (copy)
    if not (p32 and PhysicsMotion) then
        return 0;
    end;

    local hitPhysicsEffectName = p32.hitPhysicsEffectName;

    if type(hitPhysicsEffectName) ~= "string" or hitPhysicsEffectName == "" then
        return 0;
    end;

    local v33 = PhysicsMotion.getProfile(hitPhysicsEffectName);

    return type(v33) == "table" and (tonumber(v33.speed) or 0) or 0;
end;

local function _hitBroken(p34, u35, p36, p37, p38) -- Line: 261
    -- upvalues: GetData (copy), InsMgr (copy), u1 (copy), Debris (copy), VisibleMgr (copy), CollectionService (copy), Players (copy), SoundModule (copy)
    if not p34 then
        return;
    end;

    local v39 = GetData.GetDmg(p34, nil, p36);
    local v40 = u35:GetAttribute("HP");

    if v40 then
        local v41 = v40 - v39;
        u35:SetAttribute("HP", v41);

        if v41 <= 0 then
            local u42 = u35:GetPivot();
            local Parent = u35.Parent;
            u35.Parent = InsMgr.GetIns("可破坏物缓存", "Folder", game.ServerStorage);
            task.delay(u1["可破坏物"]["恢复时间"], function() -- Line: 280
                -- upvalues: GetData (ref), u42 (copy), u1 (ref), u35 (copy), Parent (copy)
                while GetData.FindNearestPlayer(u42.Position, u1["可破坏物"]["检测周围有人距离"]) do
                    task.wait(u1["可破坏物"]["检测周围有人距离时间"]);
                end;

                u35.Parent = Parent;
                u35:PivotTo(u42);
                u35:SetAttribute("HP", u35:GetAttribute("HPMAX"));
            end);
            local u43 = u35:Clone();
            Debris:AddItem(u43, 10);
            task.delay(5, function() -- Line: 306
                -- upvalues: VisibleMgr (ref), u43 (copy)
                VisibleMgr.fadeAllTween(u43);
            end);
            u43.Parent = workspace;
            u43:PivotTo(u42);
            VisibleMgr.SetCollideID(u43, "BrokenEnd");
            VisibleMgr.UnAnchoredAll(u43);

            for _, descendant in pairs(u43:GetDescendants()) do
                CollectionService:RemoveTag(descendant, "WindShake");

                if descendant:IsA("BasePart") then
                    descendant.Massless = true;
                    descendant.CanCollide = true;
                end;
            end;

            local v44 = u35:GetAttribute("Sound");

            if v44 then
                local v45 = {
                    Is2D = false,
                    SoundName = v44,
                    PlayPosition = u42.Position
                };

                for _, v in Players:GetPlayers() do
                    SoundModule:PlaySound(v, v45);
                end;
            end;

            local v46 = p37 and p37.getWorldCenter and p37:getWorldCenter() or (p37 and (p37.hitbox and p37.hitbox.Position) or u35:GetPivot().Position);

            for _, child in pairs(u43:GetChildren()) do
                local v47 = child:IsA("Model") and child.PrimaryPart or (child:IsA("BasePart") and child and child or nil);

                if v47 then
                    local v48 = v47.Position - v46;
                    local v49 = Vector3.new(v48.X, 0, v48.Z);

                    if v49.Magnitude > 0.001 then
                        local Unit = v49.Unit;
                        local v50 = v47:FindFirstChildOfClass("BodyVelocity");

                        if v50 then
                            v50:Destroy();
                        end;

                        local u51 = InsMgr.GetIns("Bodymover", "BodyVelocity", v47);
                        u51.MaxForce = Vector3.new(25000, 0, 25000);
                        u51.Velocity = Unit * p38;
                        u51.Parent = v47;
                        task.delay(0.15, function() -- Line: 363
                            -- upvalues: Debris (ref), u51 (copy)
                            Debris:AddItem(u51, 0);
                        end);
                    end;
                end;
            end;
        end;
    end;
end;

local function _attachPlayerMonsterHitPresentation(p52, p53, p54, p55) -- Line: 383
    -- upvalues: RunService (copy)
    if not RunService:IsServer() then
        return;
    end;

    if p52.hitboxOwnerType ~= "Player" then
        return;
    end;

    local v56;

    if p53 and p53:IsA("BasePart") then
        v56 = p53.Position;
    else
        v56 = p54:GetPivot().Position;
    end;

    if p52.hitSuppressPresentation == true then
        p55.hitPresentation = {
            suppressPresentation = true,
            hitPos = v56
        };

        return;
    end;

    local hitEffectName = p52.hitEffectName;
    local v57 = (typeof(hitEffectName) ~= "string" or hitEffectName == "") and "通用受击" or hitEffectName;
    local hitSoundName = p52.hitSoundName;
    p55.hitPresentation = {
        effectName = v57,
        skillSoundKey = (typeof(hitSoundName) ~= "string" or hitSoundName == "") and "通用受击" or hitSoundName,
        hitPos = v56
    };
end;

function u26.applyHit(u58, u59, p60, u61, p62) -- Line: 432
    -- upvalues: HitQueryContext (copy), u26 (copy), GetSkillData (copy), DamageContext (copy), DamageResolver (copy), SkillDamageRateFromCfg (copy), RunService (copy), _resolveAttackerUserIdForShake (copy), _resolveBuffCasterPlayer (copy), Players (copy), SkillBuffUtil (copy), CollectionService (copy), _hitBroken (copy), PhysicsMotion (copy), SystemSummon (copy), EnemyVisibilityUtil (copy), _attachPlayerMonsterHitPresentation (copy), SystemEnemy (copy), SummonAggroSystem (copy), SystemPlrAttr (copy), NetWork (copy), NetMsg (copy), UtilsSystem (copy), HitPhysics (copy), HitCameraShake (copy)
    if not (u58 and (u59 and u61)) then
        return;
    end;

    local v63 = HitQueryContext.create(u59, u61, u58.nowTime);

    if not (v63 and u26.canApplyHitFromContext(v63)) then
        return;
    end;

    local v64 = GetSkillData.getAttackerData(u59.hitboxOwnerId, u59.hitboxOwnerType);
    local v65 = GetSkillData.getDefenderData(u61);

    if not (v64 and v65) then
        warn("[HitResolver] 攻击者或被攻击者数据为空，跳过结算");

        return;
    end;

    v64.hitboxIndex = u59.hitboxIndex;
    v64.skillName = u59.skillName or u58.skillName;
    v64.skillID = u58.skillID;
    v64.combatSeed = u59.combatSeed or u58.combatSeed;
    u59._hitCounter = (u59._hitCounter or 0) + 1;
    v64.hitIndex = u59._hitCounter;
    local v66 = u59.hitboxOwnerType == "Summon";
    local v67 = p62 or {};
    v67.hitIndex = v67.hitIndex or u59._hitCounter;
    v67.hitboxIndex = v67.hitboxIndex or u59.hitboxIndex;
    v67.combatSeed = v67.combatSeed or u58.combatSeed;

    if v66 then
        v67.summonDirectDamage = true;
    end;

    local v68 = DamageContext.create(v64, v65, v67, u59);
    local v69, v70;

    if v68 and (v68.damageProfileId and (u58.skillModule and u58.skillModule.DamageProfiles)) then
        v69 = u58.skillModule.DamageProfiles[v68.damageProfileId];
        v70 = DamageResolver.createDamageResult(v68, v69);
    else
        v70 = nil;
        v69 = nil;
    end;

    if not v70 then
        local v71, v72 = GetSkillData.calculateSkillDamage(v64, v65);
        v70 = {
            showDamageText = true,
            finalDamage = v71 or 0,
            isCritical = v72 or false,
            damageTags = {}
        };
    end;

    local finalDamage = v70.finalDamage;
    local isCritical = v70.isCritical;
    local _ = v70.showDamageText == false;
    local skillModule = u58.skillModule;
    local v73 = SkillDamageRateFromCfg.get(u58.skillID, u59.hitboxIndex);

    if v69 then
        if v69.baseDamage == nil then
            if v69.damageRate ~= nil then
                v73 = v69.damageRate;
            end;
        else
            v73 = 0;
        end;
    end;

    if not v66 and (not v69 or v69.baseDamage == nil) then
        v73 = v73 * 1 * 1;
    end;

    if u59.hitboxOwnerType == "Mirror" then
        local v74 = GetSkillData.getCharacter("Mirror", u59.hitboxOwnerId);

        if v74 then
            v74 = tonumber(v74:GetAttribute("MirrorDamageMul"));
        end;

        if v74 and v74 > 0 then
            v73 = v73 * v74;
            local v75 = math.floor(finalDamage * v74 + 0.5);
            finalDamage = math.max(0, v75);
        end;
    end;

    local v76 = nil;

    if u59 and u59.getWorldCenter then
        v76 = u59:getWorldCenter();
    else
        local v77;

        if u59 then
            v77 = u59.hitbox;
        else
            v77 = u59;
        end;

        if v77 and (typeof(v77) == "Instance" and v77:IsA("BasePart")) then
            v76 = v77.Position;
        elseif p60 and p60:IsA("BasePart") then
            v76 = p60.Position;
        end;
    end;

    local u78 = {
        attackerPlayerId = tonumber(u59.hitboxOwnerId),
        damageRate = v73,
        eleTp = skillModule.skillElementType,
        isCrit = isCritical,
        hitboxWorldPosition = v76,
        skillid = v64.skillID
    };

    local function tryApplyEnemySkillBuffs() -- Line: 533
        -- upvalues: RunService (ref), finalDamage (ref), u58 (copy), u78 (copy), _resolveAttackerUserIdForShake (ref), u59 (copy), _resolveBuffCasterPlayer (ref), Players (ref), SkillBuffUtil (ref), u61 (copy)
        if RunService:IsServer() and (finalDamage or 0) > 0 then
            local v79 = tonumber(u58.skillID);

            if v79 and v79 > 0 then
                local v80 = tonumber(u78.attackerPlayerId) or (_resolveAttackerUserIdForShake(u59) or u58 and u58.characterType == "Player" and tonumber(u58.characterId));

                if not v80 then
                    v80 = u58 and u58.skillInputData;

                    if v80 then
                        if u58.skillInputData.characterType == "Player" then
                            v80 = tonumber(u58.skillInputData.characterId);
                        else
                            v80 = false;
                        end;
                    end;
                end;

                local v81 = _resolveBuffCasterPlayer(u59, u58);

                if not v81 and (v80 and v80 > 0) then
                    v81 = Players:GetPlayerByUserId(v80);
                end;

                SkillBuffUtil.ApplySkillBuffsToDefender(u61, v79, {
                    attacker = v81,
                    casterUserId = v80,
                    attackerPlayerId = v80
                });
            end;
        end;
    end;

    if u59.hitboxOwnerType == "Player" then
        if CollectionService:HasTag(u61, "CanBroke") then
            local v82 = Players:GetPlayerByUserId(u59.hitboxOwnerId);
            local v83;

            if u59 and PhysicsMotion then
                local hitPhysicsEffectName = u59.hitPhysicsEffectName;

                if type(hitPhysicsEffectName) == "string" and hitPhysicsEffectName ~= "" then
                    local v84 = PhysicsMotion.getProfile(hitPhysicsEffectName);
                    v83 = type(v84) == "table" and (tonumber(v84.speed) or 0) or 0;
                else
                    v83 = 0;
                end;
            else
                v83 = 0;
            end;

            _hitBroken(v82, u61, u78, u59, v83);
            tryApplyEnemySkillBuffs();

            return;
        end;

        local Summons = workspace:FindFirstChild("Summons");

        if Summons and u61:IsDescendantOf(Summons) then
            if SystemSummon and SystemSummon.Hit then
                SystemSummon.Hit(u59.hitboxOwnerId, u61.Name, u78);
            end;
        else
            if not EnemyVisibilityUtil.canPlayerInteract(u61, u59.hitboxOwnerId) then
                return;
            end;

            _attachPlayerMonsterHitPresentation(u59, p60, u61, u78);
            SystemEnemy.Hit(u59.hitboxOwnerId, u61.Name, u78);

            if (finalDamage or 0) > 0 then
                local v85 = Players:GetPlayerByUserId(u59.hitboxOwnerId);

                if v85 and SummonAggroSystem then
                    SummonAggroSystem.onOwnerHitMonster(v85, u61);
                end;
            end;
        end;
    elseif u59.hitboxOwnerType == "Mirror" then
        local v86 = GetSkillData.getCharacter("Mirror", u59.hitboxOwnerId);

        if v86 then
            v86 = v86:GetAttribute("OwnerUserId");
        end;

        if typeof(v86) == "number" then
            u78.attackerPlayerId = v86;

            if CollectionService:HasTag(u61, "CanBroke") then
                local v87 = Players:GetPlayerByUserId(v86);

                if v87 then
                    local v88;

                    if u59 and PhysicsMotion then
                        local hitPhysicsEffectName = u59.hitPhysicsEffectName;

                        if type(hitPhysicsEffectName) == "string" and hitPhysicsEffectName ~= "" then
                            local v89 = PhysicsMotion.getProfile(hitPhysicsEffectName);
                            v88 = type(v89) == "table" and (tonumber(v89.speed) or 0) or 0;
                        else
                            v88 = 0;
                        end;
                    else
                        v88 = 0;
                    end;

                    _hitBroken(v87, u61, u78, u59, v88);
                end;

                tryApplyEnemySkillBuffs();

                return;
            end;

            local Summons = workspace:FindFirstChild("Summons");

            if Summons and u61:IsDescendantOf(Summons) then
                if SystemSummon and SystemSummon.Hit then
                    SystemSummon.Hit(v86, u61.Name, u78);
                end;
            else
                if not EnemyVisibilityUtil.canPlayerInteract(u61, v86) then
                    return;
                end;

                SystemEnemy.Hit(v86, u61.Name, u78);

                if (finalDamage or 0) > 0 then
                    local v90 = Players:GetPlayerByUserId(v86);

                    if v90 and SummonAggroSystem then
                        SummonAggroSystem.onOwnerHitMonster(v90, u61);
                    end;
                end;
            end;
        end;
    elseif u59.hitboxOwnerType == "NPC" then
        local v91 = GetSkillData.getCharacter(u59.hitboxOwnerType, u59.hitboxOwnerId);

        if CollectionService:HasTag(u61, "CanBroke") and v91 then
            local v92;

            if u59 and PhysicsMotion then
                local hitPhysicsEffectName = u59.hitPhysicsEffectName;

                if type(hitPhysicsEffectName) == "string" and hitPhysicsEffectName ~= "" then
                    local v93 = PhysicsMotion.getProfile(hitPhysicsEffectName);
                    v92 = type(v93) == "table" and (tonumber(v93.speed) or 0) or 0;
                else
                    v92 = 0;
                end;
            else
                v92 = 0;
            end;

            _hitBroken(v91, u61, u78, u59, v92);
            tryApplyEnemySkillBuffs();

            return;
        end;

        local v94 = Players:GetPlayerFromCharacter(u61);

        if v91 and v94 then
            if not EnemyVisibilityUtil.canPlayerInteract(v91, v94.UserId) then
                return;
            end;

            if SystemPlrAttr.HitPlr(v91, v94, u78) > 0 then
                local Position = u61:GetPivot().Position;
                local v95 = {};

                for _, v in Players:GetPlayers() do
                    local Character = v.Character;

                    if Character and (Character:GetPivot().Position - Position).Magnitude < 150 then
                        table.insert(v95, v);
                    end;
                end;

                local UserId = v94.UserId;

                for _, v in v95 do
                    NetWork.FireClient(v, NetMsg.PLAYER_HIT_PRESENTATION, UserId);
                end;
            end;
        else
            local Summons = workspace:FindFirstChild("Summons");

            if v91 and (Summons and u61:IsDescendantOf(Summons)) then
                u78.attackerModel = v91;
                SystemSummon.HitFromNpc(u61.Name, u78);
            end;
        end;
    elseif u59.hitboxOwnerType == "Summon" then
        local v96 = GetSkillData.getCharacter("Summon", u59.hitboxOwnerId);
        local v97;

        if v96 then
            v97 = v96:GetAttribute("OwnerId");
        else
            v97 = v96;
        end;

        if typeof(v97) == "number" then
            u78.attackerPlayerId = v97;
        end;

        if CollectionService:HasTag(u61, "CanBroke") and v96 then
            local v98;

            if u59 and PhysicsMotion then
                local hitPhysicsEffectName = u59.hitPhysicsEffectName;

                if type(hitPhysicsEffectName) == "string" and hitPhysicsEffectName ~= "" then
                    local v99 = PhysicsMotion.getProfile(hitPhysicsEffectName);
                    v98 = type(v99) == "table" and (tonumber(v99.speed) or 0) or 0;
                else
                    v98 = 0;
                end;
            else
                v98 = 0;
            end;

            _hitBroken(v96, u61, u78, u59, v98);
            tryApplyEnemySkillBuffs();

            return;
        end;

        local Monster = workspace:FindFirstChild("Monster");

        if Monster and u61:IsDescendantOf(Monster) then
            if typeof(v97) == "number" and v96 then
                if not EnemyVisibilityUtil.canPlayerInteract(u61, v97) then
                    return;
                end;

                u78.attackerModel = v96;
                SystemEnemy.Hit(v97, u61.Name, u78);
            end;

            return;
        end;

        local v100 = Players:GetPlayerFromCharacter(u61);

        if v96 and (v100 and SystemPlrAttr.HitPlr(v96, v100, u78) > 0) then
            local Position = u61:GetPivot().Position;
            local v101 = {};

            for _, v in Players:GetPlayers() do
                local Character = v.Character;

                if Character and (Character:GetPivot().Position - Position).Magnitude < 150 then
                    table.insert(v101, v);
                end;
            end;

            local UserId = v100.UserId;

            for _, v in v101 do
                NetWork.FireClient(v, NetMsg.PLAYER_HIT_PRESENTATION, UserId);
            end;
        end;
    end;

    tryApplyEnemySkillBuffs();

    if RunService:IsServer() then
        local v102 = SystemEnemy and SystemEnemy.getPackByModel and SystemEnemy.getPackByModel(u61);

        if v102 and (v102.entity and v102.entity.isLogical == true) then
            local LogicalDisplace = UtilsSystem.LogicalDisplace;

            if LogicalDisplace then
                LogicalDisplace.tryApplyFromHitbox(v102.entity, u61, u59);
            end;
        elseif HitPhysics then
            HitPhysics.tryApplyFromHitbox(u61, u59);
        end;
    end;

    if u59.recordHit then
        u59:recordHit(u61, u58.nowTime);
    end;

    if RunService:IsServer() and (finalDamage or 0) > 0 then
        HitCameraShake.tryDispatch(u58, u59, u61, {
            skillDamage = finalDamage,
            hitPos = v76,
            attackerUserId = _resolveAttackerUserIdForShake(u59)
        });
    end;
end;

return u26;