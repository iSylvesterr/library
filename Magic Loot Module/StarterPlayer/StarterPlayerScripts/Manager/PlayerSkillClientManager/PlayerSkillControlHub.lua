-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local HumanModule = UtilsSystem.HumanModule;
local AutoCastLookAt = UtilsSystem.AutoCastLookAt;
local ReplicatedStorage = UtilsSystem.ReplicatedStorage;
local LocalPlayer = UtilsSystem.LocalPlayer;
local CharacterMorphUtil = UtilsSystem.CharacterMorphUtil;
local CameraModule = UtilsSystem.CameraModule;
local GetData = UtilsSystem.GetData;
local PlayerSkillContext = require(script.Parent.PlayerSkillContext);
local SkillSlotConfig = require(script.Parent.SkillSlotConfig);
local PlayerSkillInput = require(script.Parent.PlayerSkillInput);
local SkillCommon = require(game.ReplicatedStorage.ClientSideCode.SystemSkill.SkillModule._Templates.SkillCommon);
local v1 = {};
local u2 = false;
local u3 = true;
local u4 = nil;

local function _isDungeonPassiveSlot(p5) -- Line: 58
    -- upvalues: PlayerSkillContext (copy), SkillCommon (copy)
    local v6 = PlayerSkillContext.localPlayerSkill[p5];

    if v6 and v6.groupSkillModule then
        return SkillCommon.isDungeonPassiveSkill(v6.groupSkillModule);
    end;

    return false;
end;

local function _hasDungeonPassiveReady() -- Line: 70
    -- upvalues: SkillSlotConfig (copy), PlayerSkillContext (copy), SkillCommon (copy)
    for i = 1, SkillSlotConfig.MAX_SKILL_COUNT do
        local v7 = PlayerSkillContext.localPlayerSkill[i];
        local v8;

        if v7 and v7.groupSkillModule then
            v8 = SkillCommon.isDungeonPassiveSkill(v7.groupSkillModule);
        else
            v8 = false;
        end;

        if v8 then
            local v9 = PlayerSkillContext.localPlayerSkill[i];

            if not (v9.isCooldownActiveByTimestamp and v9:isCooldownActiveByTimestamp()) then
                return true;
            end;
        end;
    end;

    return false;
end;

local function _isAutoTraining() -- Line: 87
    -- upvalues: LocalPlayer (copy)
    local IsAutoTraining = LocalPlayer:FindFirstChild("IsAutoTraining");

    if IsAutoTraining and IsAutoTraining:IsA("BoolValue") then
        return IsAutoTraining.Value == true;
    end;

    return false;
end;

local function _isInDungeonChallenge() -- Line: 99
    -- upvalues: GetData (copy), LocalPlayer (copy)
    return GetData.IsInDungeonChallenge(LocalPlayer) == true;
end;

local function _isInStageSafeArea() -- Line: 107
    -- upvalues: LocalPlayer (copy)
    local InStageSafeArea = LocalPlayer:FindFirstChild("InStageSafeArea");

    if InStageSafeArea and InStageSafeArea:IsA("NumberValue") then
        return InStageSafeArea.Value > 0;
    end;

    return false;
end;

local function _hasAutoLockTarget() -- Line: 119
    -- upvalues: ReplicatedStorage (copy)
    local NowTargetCurrent = ReplicatedStorage:FindFirstChild("NowTargetCurrent");

    if not (NowTargetCurrent and NowTargetCurrent:IsA("ObjectValue")) then
        return false;
    end;

    local Value = NowTargetCurrent.Value;

    return Value and Value.Parent and true or false;
end;

local function _isHoldingWeapon() -- Line: 135
    -- upvalues: HumanModule (copy), LocalPlayer (copy)
    local v10, _ = HumanModule.GetHeldItemType(LocalPlayer);

    return v10 == "Weapon";
end;

local function _hasAnyActiveSkillRelease() -- Line: 144
    -- upvalues: PlayerSkillContext (copy)
    for _, v in PlayerSkillContext.localPlayerSkill do
        if v and (v.hasActiveBaseSkill and v:hasActiveBaseSkill()) then
            return true;
        end;
    end;

    return false;
end;

local function _isSlotReadyForRelease(p11) -- Line: 158
    -- upvalues: PlayerSkillContext (copy), SkillSlotConfig (copy), LocalPlayer (copy)
    local v12 = PlayerSkillContext.localPlayerSkill[p11];

    if not v12 then
        return false;
    end;

    if p11 ~= SkillSlotConfig.NORMAL_ATTACK_SLOT_INDEX then
        if v12.shouldBypassCooldownForLocalPress and v12:shouldBypassCooldownForLocalPress() then
            return true;
        end;

        if v12.isCooldownActiveByTimestamp and v12:isCooldownActiveByTimestamp() then
            return false;
        end;

        return not SkillSlotConfig.isPlayerGlobalCooldownBlockingSlot(p11);
    end;

    local IsAutoTraining = LocalPlayer:FindFirstChild("IsAutoTraining");
    local v13;

    if IsAutoTraining and IsAutoTraining:IsA("BoolValue") then
        v13 = IsAutoTraining.Value == true;
    else
        v13 = false;
    end;

    if v13 then
        return false;
    end;

    return v12.shouldBypassCooldownForLocalPress and v12:shouldBypassCooldownForLocalPress() and true or not SkillSlotConfig.isPlayerGlobalCooldownBlockingSlot(p11);
end;

local function _hasActiveDungeonPassive() -- Line: 194
    -- upvalues: SkillSlotConfig (copy), PlayerSkillContext (copy), SkillCommon (copy)
    for i = 1, SkillSlotConfig.MAX_SKILL_COUNT do
        local v14 = PlayerSkillContext.localPlayerSkill[i];
        local v15;

        if v14 and v14.groupSkillModule then
            v15 = SkillCommon.isDungeonPassiveSkill(v14.groupSkillModule);
        else
            v15 = false;
        end;

        if v15 then
            local v16 = PlayerSkillContext.localPlayerSkill[i];

            if v16 and (v16.hasActiveBaseSkill and v16:hasActiveBaseSkill()) then
                return true;
            end;
        end;
    end;

    return false;
end;

local function _selectReleasableSlotIndex() -- Line: 213
    -- upvalues: _hasActiveDungeonPassive (copy), SkillSlotConfig (copy), PlayerSkillContext (copy), SkillCommon (copy), _isSlotReadyForRelease (copy)
    local v17 = false;

    if _hasActiveDungeonPassive() then
        for i = 1, SkillSlotConfig.MAX_SKILL_COUNT do
            local v18 = PlayerSkillContext.localPlayerSkill[i];
            local v19;

            if v18 and v18.groupSkillModule then
                v19 = SkillCommon.isDungeonPassiveSkill(v18.groupSkillModule);
            else
                v19 = false;
            end;

            if v19 and _isSlotReadyForRelease(i) then
                v17 = true;
                break;
            end;
        end;

        if v17 then
            return nil;
        end;
    else
        for i = 1, SkillSlotConfig.MAX_SKILL_COUNT do
            local v20 = PlayerSkillContext.localPlayerSkill[i];
            local v21;

            if v20 and v20.groupSkillModule then
                v21 = SkillCommon.isDungeonPassiveSkill(v20.groupSkillModule);
            else
                v21 = false;
            end;

            if v21 and _isSlotReadyForRelease(i) then
                return i;
            end;
        end;
    end;

    for i = 1, SkillSlotConfig.MAX_SKILL_COUNT do
        if _isSlotReadyForRelease(i) then
            return i;
        end;
    end;

    local NORMAL_ATTACK_SLOT_INDEX = SkillSlotConfig.NORMAL_ATTACK_SLOT_INDEX;

    if _isSlotReadyForRelease(NORMAL_ATTACK_SLOT_INDEX) then
        return NORMAL_ATTACK_SLOT_INDEX;
    end;

    return nil;
end;

local function _canAutoReleaseNow() -- Line: 248
    -- upvalues: u3 (ref), GetData (copy), LocalPlayer (copy), _hasDungeonPassiveReady (copy), ReplicatedStorage (copy), HumanModule (copy), PlayerSkillInput (copy)
    if not u3 then
        return false;
    end;

    if GetData.IsInDungeonChallenge(LocalPlayer) ~= true then
        return false;
    end;

    local InStageSafeArea = LocalPlayer:FindFirstChild("InStageSafeArea");
    local v22;

    if InStageSafeArea and InStageSafeArea:IsA("NumberValue") then
        v22 = InStageSafeArea.Value > 0;
    else
        v22 = false;
    end;

    if v22 then
        return false;
    end;

    if not _hasDungeonPassiveReady() then
        local NowTargetCurrent = ReplicatedStorage:FindFirstChild("NowTargetCurrent");
        local v23;

        if NowTargetCurrent and NowTargetCurrent:IsA("ObjectValue") then
            local Value = NowTargetCurrent.Value;
            v23 = Value and Value.Parent and true or false;
        else
            v23 = false;
        end;

        if not v23 then
            return false;
        end;
    end;

    local v24, _ = HumanModule.GetHeldItemType(LocalPlayer);

    if v24 ~= "Weapon" then
        return false;
    end;

    if PlayerSkillInput.canReleaseSkillInCurrentState() then
        return HumanModule.IsPlrCharAlive(LocalPlayer) and true or false;
    end;

    return false;
end;

local function _hasNonNormalAttackPhase1Incomplete() -- Line: 278
    -- upvalues: SkillSlotConfig (copy), PlayerSkillContext (copy)
    local NORMAL_ATTACK_SLOT_INDEX = SkillSlotConfig.NORMAL_ATTACK_SLOT_INDEX;

    for i, v in PlayerSkillContext.localPlayerSkill do
        if i ~= NORMAL_ATTACK_SLOT_INDEX and (v and (v.hasPhase1Incomplete and v:hasPhase1Incomplete())) then
            return true;
        end;
    end;

    return false;
end;

local function _tryAutoReleaseTick() -- Line: 293
    -- upvalues: u2 (ref), _canAutoReleaseNow (copy), _hasAnyActiveSkillRelease (copy), LocalPlayer (copy), PlayerSkillInput (copy), _hasNonNormalAttackPhase1Incomplete (copy), PlayerSkillContext (copy), SkillSlotConfig (copy), _selectReleasableSlotIndex (copy)
    if u2 then
        return;
    end;

    if not _canAutoReleaseNow() then
        return;
    end;

    if _hasAnyActiveSkillRelease() then
        local IsAutoTraining = LocalPlayer:FindFirstChild("IsAutoTraining");
        local v25;

        if IsAutoTraining and IsAutoTraining:IsA("BoolValue") then
            v25 = IsAutoTraining.Value == true;
        else
            v25 = false;
        end;

        if not v25 and PlayerSkillInput.tryAutoCastNormalAttackDerive() then
            return;
        end;

        if _hasNonNormalAttackPhase1Incomplete() then
            return;
        end;

        local v26 = PlayerSkillContext.localPlayerSkill[SkillSlotConfig.NORMAL_ATTACK_SLOT_INDEX];

        if v26 and (v26.hasActiveBaseSkill and v26:hasActiveBaseSkill()) then
            return;
        end;
    end;

    local v27 = _selectReleasableSlotIndex();

    if not v27 then
        return;
    end;

    u2 = true;

    if PlayerSkillInput.simulateSlotPressRelease(v27, v27 == SkillSlotConfig.NORMAL_ATTACK_SLOT_INDEX) then
        task.delay(PlayerSkillInput.getSimulatePressReleaseDelay() + 0.01, function() -- Line: 327
            -- upvalues: u2 (ref)
            u2 = false;
        end);

        return;
    end;

    u2 = false;
end;

local function _onLeaveDungeonChallenge() -- Line: 335
    -- upvalues: SkillSlotConfig (copy), PlayerSkillContext (copy), SkillCommon (copy), CameraModule (copy), LocalPlayer (copy), CharacterMorphUtil (copy)
    for i = 1, SkillSlotConfig.MAX_SKILL_COUNT do
        local v28 = PlayerSkillContext.localPlayerSkill[i];
        local v29;

        if v28 and v28.groupSkillModule then
            v29 = SkillCommon.isDungeonPassiveSkill(v28.groupSkillModule);
        else
            v29 = false;
        end;

        if v29 then
            local v30 = PlayerSkillContext.localPlayerSkill[i];

            if v30 and v30.interruptAllRunningCasts then
                v30:interruptAllRunningCasts();
            end;
        end;
    end;

    if CameraModule and CameraModule.DisableCameraEvent_Helper then
        CameraModule.DisableCameraEvent_Helper("GiantBodyScaleCam");
    end;

    local Character = LocalPlayer.Character;

    if Character and CharacterMorphUtil then
        CharacterMorphUtil.RestoreArms(Character);
    end;
end;

local function _hookDungeonChallengeWatch() -- Line: 359
    -- upvalues: u4 (ref), LocalPlayer (copy), _onLeaveDungeonChallenge (copy)
    if u4 then
        return;
    end;

    local u31 = LocalPlayer:FindFirstChild("InDungeonChallenge") or LocalPlayer:WaitForChild("InDungeonChallenge", 30);

    if not (u31 and u31:IsA("NumberValue")) then
        return;
    end;

    local Value = u31.Value;
    u4 = u31:GetPropertyChangedSignal("Value"):Connect(function() -- Line: 371
        -- upvalues: u31 (ref), Value (ref), _onLeaveDungeonChallenge (ref)
        local Value2 = u31.Value;

        if Value > 0 and Value2 <= 0 then
            _onLeaveDungeonChallenge();
        end;

        Value = Value2;
    end);
end;

function v1.setDebugAutoAttackEnabled(p32) -- Line: 386
    -- upvalues: u3 (ref)
    u3 = p32;
end;

function v1.isDebugAutoAttackEnabled() -- Line: 395
    -- upvalues: u3 (ref)
    return u3;
end;

function v1.start() -- Line: 402
    -- upvalues: AutoCastLookAt (copy), _canAutoReleaseNow (copy), _hookDungeonChallengeWatch (copy), _tryAutoReleaseTick (copy)
    AutoCastLookAt.start(_canAutoReleaseNow);
    _hookDungeonChallengeWatch();
    task.spawn(function() -- Line: 406
        -- upvalues: _tryAutoReleaseTick (ref)
        while task.wait(0.1) do
            _tryAutoReleaseTick();
        end;
    end);
end;

return v1;