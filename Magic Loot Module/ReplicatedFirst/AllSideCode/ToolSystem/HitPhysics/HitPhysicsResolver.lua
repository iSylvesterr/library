-- Decompiled with Potassium's decompiler.

local ReplicatedFirst = game:GetService("ReplicatedFirst");
local RunService = game:GetService("RunService");
local ServerStorage = game:GetService("ServerStorage");
local UtilsSystem = require(ReplicatedFirst.AllSideCode.UtilsSystem);
local NetWork = UtilsSystem.NetWork;
local NetMsg = UtilsSystem.NetMsg;
local Players = UtilsSystem.Players;
local PhysicsMotion = UtilsSystem.PhysicsMotion;
local SystemGameConfig = UtilsSystem.SystemGameConfig;
local MonsterClientSimulationGate = UtilsSystem.MonsterClientSimulationGate;
local Log = UtilsSystem.Log;
local HitPhysicsSubject = require(script.Parent.HitPhysicsSubject);
local v1 = {};
local u2 = SystemGameConfig.Get();
local u3 = nil;
local u4 = nil;

local function _getSystemEnemy() -- Line: 38
    -- upvalues: u3 (ref), ServerStorage (copy)
    if not u3 then
        u3 = require(ServerStorage.ServerSideCode.System.SystemEnemy);
    end;

    return u3;
end;

local function _getNpcPhysicsMotionWalkSpeed() -- Line: 50
    -- upvalues: u4 (ref), ServerStorage (copy)
    if not u4 then
        u4 = require(ServerStorage.ServerSideCode.AI.Shared.NPCPhysicsMotionWalkSpeed);
    end;

    return u4;
end;

local function _resolveEntity(p5) -- Line: 63
    -- upvalues: u3 (ref), ServerStorage (copy), UtilsSystem (copy)
    if not u3 then
        u3 = require(ServerStorage.ServerSideCode.System.SystemEnemy);
    end;

    local v6 = u3.getPackByModel(p5);

    if v6 and v6.entity then
        return v6.entity;
    end;

    local SystemSummon = UtilsSystem.SystemSummon;

    if SystemSummon and SystemSummon.getPackByModel then
        local v7 = SystemSummon.getPackByModel(p5);

        if v7 and v7.entity then
            return v7.entity;
        end;
    end;

    return nil;
end;

local function _tryLockMonsterWalkSpeed(p8, p9) -- Line: 84
    -- upvalues: PhysicsMotion (copy), u4 (ref), ServerStorage (copy)
    if not (p8 and PhysicsMotion) then
        return;
    end;

    local v10 = PhysicsMotion.getProfile(p9);

    if not v10 or v10.freezeWalkSpeed ~= true then
        return;
    end;

    if v10.mode == "impulse" then
        return;
    end;

    local v11 = tonumber(v10.duration) or 0;

    if v11 <= 0 then
        return;
    end;

    if not u4 then
        u4 = require(ServerStorage.ServerSideCode.AI.Shared.NPCPhysicsMotionWalkSpeed);
    end;

    u4.lock(p8, v11);
end;

local function _resolveHitKnockbackFlatDirection(p12, p13) -- Line: 117
    if not p12 then
        return nil;
    end;

    local Position = p13.Position;
    local v14 = Vector3.new(Position.X - p12.X, 0, Position.Z - p12.Z);

    if v14.Magnitude < 0.0001 then
        return nil;
    end;

    return v14.Unit;
end;

local function _isMonsterKnockbackOnPlayerEnabled() -- Line: 134
    -- upvalues: u2 (copy)
    local v15 = u2 and u2["技能系统"];

    if v15 then
        v15 = v15["命中物理"];
    end;

    if type(v15) == "table" then
        return v15["怪物对玩家击退"] == true;
    end;

    return false;
end;

local function _shouldSkipHitPhysicsForTarget(p16, p17) -- Line: 150
    -- upvalues: u2 (copy), Players (copy)
    if p16.hitboxOwnerType ~= "NPC" then
        return false;
    end;

    local v18 = u2 and u2["技能系统"];

    if v18 then
        v18 = v18["命中物理"];
    end;

    local v19;

    if type(v18) == "table" then
        v19 = v18["怪物对玩家击退"] == true;
    else
        v19 = false;
    end;

    if v19 then
        return false;
    end;

    return Players:GetPlayerFromCharacter(p17) ~= nil;
end;

local function _buildPayload(p20, p21, p22) -- Line: 168
    -- upvalues: HitPhysicsSubject (copy)
    local hitPhysicsEffectName = p21.hitPhysicsEffectName;

    if type(hitPhysicsEffectName) ~= "string" or hitPhysicsEffectName == "" then
        return nil;
    end;

    local v23, v24 = HitPhysicsSubject.encode(p20);

    if not (v23 and v24) then
        return nil;
    end;

    local v25 = nil;

    if p21.getWorldCenter then
        v25 = p21:getWorldCenter();
    else
        local hitbox = p21.hitbox;

        if hitbox and (typeof(hitbox) == "Instance" and hitbox:IsA("BasePart")) then
            v25 = hitbox.Position;
        elseif hitbox and hitbox.Position then
            v25 = hitbox.Position;
        end;
    end;

    local v26;

    if v25 then
        local Position = p22.Position;
        local v27 = Vector3.new(Position.X - v25.X, 0, Position.Z - v25.Z);

        if v27.Magnitude < 0.0001 then
            v26 = nil;
        else
            v26 = v27.Unit;
        end;
    else
        v26 = nil;
    end;

    return v26 and {
        subjectRoot = v23,
        subjectKey = v24,
        profileName = hitPhysicsEffectName,
        direction = v26
    } or nil;
end;

local function _deferServerApply(u28, u29) -- Line: 210
    -- upvalues: PhysicsMotion (copy)
    if not PhysicsMotion then
        return;
    end;

    task.defer(function() -- Line: 214
        -- upvalues: u28 (copy), PhysicsMotion (ref), u29 (copy)
        if not u28.Parent then
            return;
        end;

        PhysicsMotion.apply({
            subject = u28,
            profileName = u29.profileName,
            direction = u29.direction
        });
    end);
end;

function v1.tryApplyFromHitbox(u30, p31) -- Line: 233
    -- upvalues: RunService (copy), u2 (copy), Players (copy), MonsterClientSimulationGate (copy), u3 (ref), ServerStorage (copy), UtilsSystem (copy), Log (copy), _buildPayload (copy), _tryLockMonsterWalkSpeed (copy), NetWork (copy), NetMsg (copy), PhysicsMotion (copy)
    if not RunService:IsServer() then
        return;
    end;

    local v32;

    if p31.hitboxOwnerType == "NPC" then
        local v33 = u2 and u2["技能系统"];

        if v33 then
            v33 = v33["命中物理"];
        end;

        local v34;

        if type(v33) == "table" then
            v34 = v33["怪物对玩家击退"] == true;
        else
            v34 = false;
        end;

        if v34 then
            v32 = false;
        else
            v32 = Players:GetPlayerFromCharacter(u30) ~= nil;
        end;
    else
        v32 = false;
    end;

    if v32 then
        return;
    end;

    local v35 = MonsterClientSimulationGate.resolvePhysicsRoot(u30);

    if not v35 then
        return;
    end;

    if not u3 then
        u3 = require(ServerStorage.ServerSideCode.System.SystemEnemy);
    end;

    local v36 = u3.getPackByModel(u30);
    local v37;

    if v36 and v36.entity then
        v37 = v36.entity;
    else
        local SystemSummon = UtilsSystem.SystemSummon;

        if SystemSummon and SystemSummon.getPackByModel then
            local v38 = SystemSummon.getPackByModel(u30);

            if v38 and v38.entity then
                v37 = v38.entity;
            else
                v37 = nil;
            end;
        else
            v37 = nil;
        end;
    end;

    if v37 and v37.isLogical == true then
        if Log and Log.warn then
            if u30 then
                u30 = u30.Name;
            end;

            Log.warn("HitPhysics: 逻辑怪不应进入物理击退，请走 LogicalDisplace", u30);
        end;

        return;
    end;

    local u39 = _buildPayload(u30, p31, v35);

    if not u39 then
        return;
    end;

    if v37 and Players:GetPlayerFromCharacter(u30) == nil then
        _tryLockMonsterWalkSpeed(v37, u39.profileName);
    end;

    local v40 = MonsterClientSimulationGate.resolve(u30, v35, {
        syncOwnership = true,
        entity = v37
    });

    if v40.runOnClient and v40.clientPlayer then
        NetWork.FireClient(v40.clientPlayer, NetMsg.HIT_PHYSICS, u39);

        return;
    end;

    if not PhysicsMotion then
        return;
    end;

    task.defer(function() -- Line: 214
        -- upvalues: u30 (copy), PhysicsMotion (ref), u39 (copy)
        if not u30.Parent then
            return;
        end;

        PhysicsMotion.apply({
            subject = u30,
            profileName = u39.profileName,
            direction = u39.direction
        });
    end);
end;

return v1;