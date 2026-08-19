-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local UserInputService = UtilsSystem.UserInputService;
local HumanModule = UtilsSystem.HumanModule;
local GetSkillData = UtilsSystem.GetSkillData;
local LocalPlayer = UtilsSystem.LocalPlayer;
local PlayerSkillContext = require(script.Parent.PlayerSkillContext);
local SkillSlotConfig = require(script.Parent.SkillSlotConfig);
local u1 = {};

local function _isAutoTraining() -- Line: 31
    -- upvalues: LocalPlayer (copy)
    local IsAutoTraining = LocalPlayer:FindFirstChild("IsAutoTraining");

    if IsAutoTraining and IsAutoTraining:IsA("BoolValue") then
        return IsAutoTraining.Value == true;
    end;

    return false;
end;

local function _magicBlockKeyboardInputDbg(p2) -- Line: 43
end;

function u1.canReleaseSkillInCurrentState() -- Line: 54
    -- upvalues: LocalPlayer (copy)
    local CurrentCamera = workspace.CurrentCamera;

    if not CurrentCamera then
        return true;
    end;

    if CurrentCamera.CameraType == Enum.CameraType.Scriptable then
        return false;
    end;

    return not LocalPlayer:FindFirstChild("退出炼金短暂不允许施法");
end;

function u1.getSimulatePressReleaseDelay() -- Line: 72
    return 0.05;
end;

function u1.getMagicBlockDebugFn() -- Line: 80
    -- upvalues: _magicBlockKeyboardInputDbg (copy)
    return _magicBlockKeyboardInputDbg;
end;

local function _trySkillSlotInputBegan(p3, p4) -- Line: 90
    -- upvalues: u1 (copy), HumanModule (copy), LocalPlayer (copy), SkillSlotConfig (copy), PlayerSkillContext (copy), GetSkillData (copy)
    if not u1.canReleaseSkillInCurrentState() then
        return false;
    end;

    if not HumanModule.IsPlrCharAlive(LocalPlayer) then
        return false;
    end;

    if p3 == SkillSlotConfig.NORMAL_ATTACK_SLOT_INDEX then
        local IsAutoTraining = LocalPlayer:FindFirstChild("IsAutoTraining");
        local v5;

        if IsAutoTraining and IsAutoTraining:IsA("BoolValue") then
            v5 = IsAutoTraining.Value == true;
        else
            v5 = false;
        end;

        if v5 then
            return false;
        end;
    end;

    if p3 ~= SkillSlotConfig.DASH_SLOT_INDEX then
        local v6, _ = HumanModule.GetHeldItemType(LocalPlayer);

        if not v6 or v6 ~= "Weapon" then
            return false;
        end;
    end;

    local v7 = PlayerSkillContext.localPlayerSkill[p3];

    if not v7 then
        return false;
    end;

    if not p4 and (not v7:shouldBypassCooldownForLocalPress() and v7:isCooldownActiveByTimestamp()) then
        return false;
    end;

    if not v7:hasPhase1Incomplete() and SkillSlotConfig.isPlayerGlobalCooldownBlockingSlot(p3) then
        return false;
    end;

    local v8 = v7:getInterruptionPriority();

    for _, v in PlayerSkillContext.localPlayerSkill do
        if v ~= v7 and (v:hasPhase1Incomplete() and v8 <= v:getInterruptionPriority()) then
            return false;
        end;
    end;

    for _, v in PlayerSkillContext.localPlayerSkill do
        if v ~= v7 and v:hasPhase1Incomplete() then
            v:interruptAllCastingForCrossSlot();
        end;
    end;

    local v9, v10 = GetSkillData.getLocalPlayerSkillInputData();

    if not (v9 and v10) then
        return false;
    end;

    v7:updateSkillInput(v9, v10);

    if p4 then
        v7._hubSkipCooldownOnce = true;
    end;

    v7:onInputBegan();

    return true;
end;

local function _trySkillSlotInputEnded(p11) -- Line: 157
    -- upvalues: HumanModule (copy), LocalPlayer (copy), PlayerSkillContext (copy), GetSkillData (copy), SkillSlotConfig (copy)
    if not HumanModule.IsPlrCharAlive(LocalPlayer) then
        return;
    end;

    local v12 = PlayerSkillContext.localPlayerSkill[p11];

    if not v12 then
        return;
    end;

    local v13 = v12:getInterruptionPriority();

    for _, v in PlayerSkillContext.localPlayerSkill do
        if v ~= v12 and (v:hasPhase1Incomplete() and v13 <= v:getInterruptionPriority()) then
            return;
        end;
    end;

    local v14, v15 = GetSkillData.getLocalPlayerSkillInputData();

    if not (v14 and v15) then
        return;
    end;

    v12:updateSkillInput(v14, v15);

    if p11 == SkillSlotConfig.BLOCK_SLOT_INDEX then
        string.format("InputEnded (before onInputEnded) clock=%.4f phase1Incomplete=%s lastDerivableCastId=%s", os.clock(), tostring(v12:hasPhase1Incomplete()), (tostring(v12.lastDerivableSkillCastId)));
    end;

    v12:onInputEnded();
end;

function u1.tryAutoCastNormalAttackDerive() -- Line: 198
    -- upvalues: LocalPlayer (copy), u1 (copy), HumanModule (copy), SkillSlotConfig (copy), PlayerSkillContext (copy), GetSkillData (copy)
    local IsAutoTraining = LocalPlayer:FindFirstChild("IsAutoTraining");
    local v16;

    if IsAutoTraining and IsAutoTraining:IsA("BoolValue") then
        v16 = IsAutoTraining.Value == true;
    else
        v16 = false;
    end;

    if v16 then
        return false;
    end;

    if not u1.canReleaseSkillInCurrentState() then
        return false;
    end;

    if not HumanModule.IsPlrCharAlive(LocalPlayer) then
        return false;
    end;

    local v17 = PlayerSkillContext.localPlayerSkill[SkillSlotConfig.NORMAL_ATTACK_SLOT_INDEX];

    if not (v17 and v17.canAutoCastDeriveInput) then
        return false;
    end;

    if not v17:canAutoCastDeriveInput() then
        return false;
    end;

    local v18, v19 = GetSkillData.getLocalPlayerSkillInputData();

    if not (v18 and v19) then
        return false;
    end;

    v17:updateSkillInput(v18, v19);

    return v17:sendAutoCastDeriveInput();
end;

function u1.simulateSlotPressRelease(u20, p21) -- Line: 232
    -- upvalues: _trySkillSlotInputBegan (copy), _trySkillSlotInputEnded (copy)
    if not _trySkillSlotInputBegan(u20, p21) then
        return false;
    end;

    task.delay(0.05, function() -- Line: 236
        -- upvalues: _trySkillSlotInputEnded (ref), u20 (copy)
        _trySkillSlotInputEnded(u20);
    end);

    return true;
end;

function u1.onInputBegan(p22, p23) -- Line: 248
    return nil;
end;

function u1.onInputEnded(p24, p25) -- Line: 305
end;

function u1.connect() -- Line: 328
    -- upvalues: UserInputService (copy), u1 (copy)
    UserInputService.InputBegan:Connect(u1.onInputBegan);
    UserInputService.InputEnded:Connect(u1.onInputEnded);
end;

return u1;