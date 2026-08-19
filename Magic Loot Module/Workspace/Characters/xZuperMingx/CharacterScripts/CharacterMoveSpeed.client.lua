-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
game:GetService("TweenService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local LocalPlayer = UtilsSystem.LocalPlayer;
local GetData = UtilsSystem.GetData;
local EnumMgr = UtilsSystem.EnumMgr;
local FXUtil = UtilsSystem.FXUtil;
local AddListen = UtilsSystem.AddListen;
local CharacterMoveSpeedBind = require(LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("Manager"):WaitForChild("CharacterMoveSpeedBind"));
local Parent = script.Parent.Parent;
local Humanoid = Parent:WaitForChild("Humanoid");
local u1 = UtilsSystem.SystemGameConfig.GetValue({ "CharacterMoveSpeed", "玩家行走移动速度" });
local v2 = UtilsSystem.SystemGameConfig.GetValue({ "CharacterMoveSpeed", "玩家奔跑移动速度" });
local _ = Enum.EasingStyle.Quad;
local _ = Enum.EasingDirection.Out;
local _ = Enum.EasingStyle.Quad;
local _ = Enum.EasingDirection.Out;
local u3 = tostring(EnumMgr.PlrAttr.Move_Speed_P);
local u4 = {
    RUN_STATE = v2 - u1
};
local u5 = {
    RELEASE_SKILL_STATE = 0.1,
    RELEASE_SKILL_STATE_HALF = 0.5,
    MOVE_SPEED_LOCK = 0
};
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = {};
local u12 = nil;
local u13 = nil;
local _ = {
    startSpeed = 0,
    targetSpeed = 0,
    elapsed = 0,
    duration = 0,
    style = Enum.EasingStyle.Quad,
    direction = Enum.EasingDirection.Out
};

local function _publishExpectedWalkSpeed(p14) -- Line: 113
    -- upvalues: u6 (ref), LocalPlayer (copy)
    local v15 = math.max(0, p14);

    if u6 ~= nil and math.abs(u6 - v15) < 0.0001 then
        return;
    end;

    u6 = v15;
    LocalPlayer:SetAttribute("ExpectedWalkSpeed", v15);
end;

local function _getMoveSpeedPercentBonus() -- Line: 129
    -- upvalues: GetData (copy), LocalPlayer (copy), EnumMgr (copy)
    local v16 = GetData.GetPlrAttr(LocalPlayer, EnumMgr.PlrAttr.Move_Speed_P);

    return (type(v16) ~= "number" or v16 ~= v16) and 0 or v16;
end;

local function _getExtraMoveSpeedBonus() -- Line: 142
    -- upvalues: u13 (ref)
    local v17 = u13;

    if not v17 then
        return 0;
    end;

    local Value = v17.Value;

    return (type(Value) ~= "number" or (Value ~= Value or Value <= 0)) and 0 or math.floor(Value);
end;

local function _resolveCharacterAttachPart(p18) -- Line: 160
    local v19 = p18:FindFirstChild("主节点", true);

    if v19 and v19:IsA("BasePart") then
        return v19;
    end;

    local HumanoidRootPart = p18:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
        return HumanoidRootPart;
    end;

    return nil;
end;

local function _cleanupSpeedBuffVfx() -- Line: 178
    -- upvalues: u12 (ref), FXUtil (copy)
    if not u12 then
        return;
    end;

    local v20 = u12;
    u12 = nil;

    if v20.Parent then
        FXUtil.Stop_All_Emit(v20);
        FXUtil.SetEmittersTrailsBeamsEnabled(v20, false);
        v20:Destroy();
    end;
end;

local function _syncSpeedBuffVfx() -- Line: 197
    -- upvalues: GetData (copy), LocalPlayer (copy), EnumMgr (copy), u12 (ref), FXUtil (copy), Parent (copy)
    local v21 = GetData.GetPlrAttr(LocalPlayer, EnumMgr.PlrAttr.Move_Speed_P);

    if ((type(v21) ~= "number" or v21 ~= v21) and 0 or v21) <= 0 then
        if not u12 then
            return;
        end;

        local v22 = u12;
        u12 = nil;

        if v22.Parent then
            FXUtil.Stop_All_Emit(v22);
            FXUtil.SetEmittersTrailsBeamsEnabled(v22, false);
            v22:Destroy();
        end;

        return;
    end;

    if u12 and u12.Parent then
        return;
    end;

    local v23 = Parent;
    local v24 = v23:FindFirstChild("主节点", true);

    if not (v24 and v24:IsA("BasePart")) then
        v24 = v23:FindFirstChild("HumanoidRootPart");

        if not (v24 and v24:IsA("BasePart")) then
            v24 = nil;
        end;
    end;

    if not v24 then
        return;
    end;

    local v25 = FXUtil.CloneModelResEffectModel("加速特效");

    if not v25 then
        return;
    end;

    FXUtil.PrepEffectForWorldShared(v25, true);
    v25.Parent = Parent;

    if not FXUtil.WeldFxModelToBasePart(v25, v24) then
        v25:Destroy();

        return;
    end;

    FXUtil.EmitOnceThenEnableContinuous(v25);
    u12 = v25;
end;

local function _calculateTargetSpeed() -- Line: 233
    -- upvalues: u1 (copy), u4 (copy), LocalPlayer (copy), u13 (ref), GetData (copy), EnumMgr (copy), u5 (copy)
    local v26 = u1;

    for i, v in u4 do
        if LocalPlayer:GetAttribute(i) then
            v26 = v26 + v;
        end;
    end;

    local v27 = u13;
    local v28;

    if v27 then
        local Value = v27.Value;
        v28 = (type(Value) ~= "number" or (Value ~= Value or Value <= 0)) and 0 or math.floor(Value);
    else
        v28 = 0;
    end;

    local v29 = GetData.GetPlrAttr(LocalPlayer, EnumMgr.PlrAttr.Move_Speed_P);
    local v30 = (v26 + v28) * (((type(v29) ~= "number" or v29 ~= v29) and 0 or v29) + 1);

    for i, v in u5 do
        if LocalPlayer:GetAttribute(i) then
            v30 = v30 * v;
        end;
    end;

    return math.max(0, v30);
end;

local function _applySpeedInstant(p31) -- Line: 260
    -- upvalues: Humanoid (copy)
    if Humanoid and Humanoid.Parent then
        Humanoid.WalkSpeed = p31;
    end;
end;

local function _transitionToSpeed(p32, p33, p34) -- Line: 273
    -- upvalues: _calculateTargetSpeed (copy), u6 (ref), LocalPlayer (copy), Humanoid (copy)
    local v35 = _calculateTargetSpeed();
    local v36 = math.max(0, v35);

    if u6 == nil or math.abs(u6 - v36) >= 0.0001 then
        u6 = v36;
        LocalPlayer:SetAttribute("ExpectedWalkSpeed", v36);
    end;

    if Humanoid and Humanoid.Parent then
        Humanoid.WalkSpeed = v35;
    end;
end;

local function _updateCharacterSpeed(p37, p38, p39) -- Line: 344
    -- upvalues: _calculateTargetSpeed (copy), u6 (ref), LocalPlayer (copy), Humanoid (copy)
    local v40 = _calculateTargetSpeed();
    local v41 = math.max(0, v40);

    if u6 == nil or math.abs(u6 - v41) >= 0.0001 then
        u6 = v41;
        LocalPlayer:SetAttribute("ExpectedWalkSpeed", v41);
    end;

    if Humanoid and Humanoid.Parent then
        Humanoid.WalkSpeed = v40;
    end;
end;

local function _trackAttrsBuffChild(p42) -- Line: 364
    -- upvalues: u11 (copy), _calculateTargetSpeed (copy), u6 (ref), LocalPlayer (copy), Humanoid (copy), _syncSpeedBuffVfx (copy), u3 (copy)
    if not p42:IsA("NumberValue") then
        return;
    end;

    table.insert(u11, p42.Changed:Connect(function() -- Line: 368
        -- upvalues: _calculateTargetSpeed (ref), u6 (ref), LocalPlayer (ref), Humanoid (ref), _syncSpeedBuffVfx (ref)
        local v43 = _calculateTargetSpeed();
        local v44 = math.max(0, v43);

        if u6 == nil or math.abs(u6 - v44) >= 0.0001 then
            u6 = v44;
            LocalPlayer:SetAttribute("ExpectedWalkSpeed", v44);
        end;

        if Humanoid and Humanoid.Parent then
            Humanoid.WalkSpeed = v43;
        end;

        _syncSpeedBuffVfx();
    end));

    if p42.Name == u3 and p42.Value > 0 then
        task.defer(function() -- Line: 375
            -- upvalues: _calculateTargetSpeed (ref), u6 (ref), LocalPlayer (ref), Humanoid (ref), _syncSpeedBuffVfx (ref)
            local v45 = _calculateTargetSpeed();
            local v46 = math.max(0, v45);

            if u6 == nil or math.abs(u6 - v46) >= 0.0001 then
                u6 = v46;
                LocalPlayer:SetAttribute("ExpectedWalkSpeed", v46);
            end;

            if Humanoid and Humanoid.Parent then
                Humanoid.WalkSpeed = v45;
            end;

            _syncSpeedBuffVfx();
        end);
    end;
end;

local function _bindAttrsBuffFolder(p47) -- Line: 388
    -- upvalues: _trackAttrsBuffChild (copy), u11 (copy), _calculateTargetSpeed (copy), u6 (ref), LocalPlayer (copy), Humanoid (copy), _syncSpeedBuffVfx (copy)
    for _, child in p47:GetChildren() do
        _trackAttrsBuffChild(child);
    end;

    table.insert(u11, p47.ChildAdded:Connect(function(p48) -- Line: 393
        -- upvalues: _trackAttrsBuffChild (ref), _calculateTargetSpeed (ref), u6 (ref), LocalPlayer (ref), Humanoid (ref), _syncSpeedBuffVfx (ref)
        _trackAttrsBuffChild(p48);
        local v49 = _calculateTargetSpeed();
        local v50 = math.max(0, v49);

        if u6 == nil or math.abs(u6 - v50) >= 0.0001 then
            u6 = v50;
            LocalPlayer:SetAttribute("ExpectedWalkSpeed", v50);
        end;

        if Humanoid and Humanoid.Parent then
            Humanoid.WalkSpeed = v49;
        end;

        _syncSpeedBuffVfx();
    end));
    table.insert(u11, p47.ChildRemoved:Connect(function() -- Line: 398
        -- upvalues: _calculateTargetSpeed (ref), u6 (ref), LocalPlayer (ref), Humanoid (ref), _syncSpeedBuffVfx (ref)
        local v51 = _calculateTargetSpeed();
        local v52 = math.max(0, v51);

        if u6 == nil or math.abs(u6 - v52) >= 0.0001 then
            u6 = v52;
            LocalPlayer:SetAttribute("ExpectedWalkSpeed", v52);
        end;

        if Humanoid and Humanoid.Parent then
            Humanoid.WalkSpeed = v51;
        end;

        _syncSpeedBuffVfx();
    end));
    local v53 = _calculateTargetSpeed();
    local v54 = math.max(0, v53);

    if u6 == nil or math.abs(u6 - v54) >= 0.0001 then
        u6 = v54;
        LocalPlayer:SetAttribute("ExpectedWalkSpeed", v54);
    end;

    if Humanoid and Humanoid.Parent then
        Humanoid.WalkSpeed = v53;
    end;

    _syncSpeedBuffVfx();
end;

local function _updateMoveDirectionTransition(p55) -- Line: 431
    -- upvalues: Humanoid (copy), GetData (copy), LocalPlayer (copy), EnumMgr (copy), u12 (ref), _syncSpeedBuffVfx (copy), _calculateTargetSpeed (copy), u6 (ref), u7 (ref)
    if not (Humanoid and Humanoid.Parent) then
        return;
    end;

    local v56 = GetData.GetPlrAttr(LocalPlayer, EnumMgr.PlrAttr.Move_Speed_P);

    if ((type(v56) ~= "number" or v56 ~= v56) and 0 or v56) > 0 and not (u12 and u12.Parent) then
        _syncSpeedBuffVfx();
    end;

    local v57 = _calculateTargetSpeed();
    local v58 = math.max(0, v57);

    if u6 == nil or math.abs(u6 - v58) >= 0.0001 then
        u6 = v58;
        LocalPlayer:SetAttribute("ExpectedWalkSpeed", v58);
    end;

    if u7 then
        return;
    end;

    local v59 = Humanoid.MoveDirection.Magnitude >= 0.01 and _calculateTargetSpeed() or 0;

    if math.abs(Humanoid.WalkSpeed - v59) < 0.01 then
        return;
    end;

    if Humanoid and Humanoid.Parent then
        Humanoid.WalkSpeed = v59;
    end;
end;

local function _lockRunState() -- Line: 485
    -- upvalues: LocalPlayer (copy), _calculateTargetSpeed (copy), u6 (ref), Humanoid (copy)
    if LocalPlayer:GetAttribute("RUN_STATE") == true then
        return;
    end;

    LocalPlayer:SetAttribute("RUN_STATE", true);
    local v60 = _calculateTargetSpeed();
    local v61 = math.max(0, v60);

    if u6 == nil or math.abs(u6 - v61) >= 0.0001 then
        u6 = v61;
        LocalPlayer:SetAttribute("ExpectedWalkSpeed", v61);
    end;

    if Humanoid and Humanoid.Parent then
        Humanoid.WalkSpeed = v60;
    end;
end;

local function _cleanup() -- Line: 496
    -- upvalues: CharacterMoveSpeedBind (copy), _updateCharacterSpeed (copy), u7 (ref), u8 (ref), u9 (ref), u10 (ref), u11 (copy), u12 (ref), FXUtil (copy)
    CharacterMoveSpeedBind.clearHandler(_updateCharacterSpeed);

    if u7 then
        u7:Disconnect();
        u7 = nil;
    end;

    if u8 then
        u8:Disconnect();
        u8 = nil;
    end;

    if u9 then
        u9:Disconnect();
        u9 = nil;
    end;

    if u10 then
        u10:Disconnect();
        u10 = nil;
    end;

    for _, v in u11 do
        v:Disconnect();
    end;

    table.clear(u11);

    if not u12 then
        return;
    end;

    local v62 = u12;
    u12 = nil;

    if v62.Parent then
        FXUtil.Stop_All_Emit(v62);
        FXUtil.SetEmittersTrailsBeamsEnabled(v62, false);
        v62:Destroy();
    end;
end;

local function _bindExtraMoveSpeedListener() -- Line: 527
    -- upvalues: u13 (ref), GetData (copy), LocalPlayer (copy), EnumMgr (copy), u10 (ref), AddListen (copy), _calculateTargetSpeed (copy), u6 (ref), Humanoid (copy)
    u13 = GetData.WaitBagNumberValue(LocalPlayer, EnumMgr.ItemID.ExtraMoveSpeed);
    u10 = AddListen.NumValueAdd(u13, function() -- Line: 529
        -- upvalues: _calculateTargetSpeed (ref), u6 (ref), LocalPlayer (ref), Humanoid (ref)
        local v63 = _calculateTargetSpeed();
        local v64 = math.max(0, v63);

        if u6 == nil or math.abs(u6 - v64) >= 0.0001 then
            u6 = v64;
            LocalPlayer:SetAttribute("ExpectedWalkSpeed", v64);
        end;

        if Humanoid and Humanoid.Parent then
            Humanoid.WalkSpeed = v63;
        end;
    end, true);
end;

LocalPlayer:SetAttribute("RUN_STATE", true);
u9 = LocalPlayer:GetAttributeChangedSignal("RUN_STATE"):Connect(_lockRunState);
(function() -- Line: 412, Name: _bindAttrsBuffListener
    -- upvalues: LocalPlayer (copy), _bindAttrsBuffFolder (copy), u11 (copy)
    local Attrs_Buff = LocalPlayer:FindFirstChild("Attrs_Buff");

    if Attrs_Buff and Attrs_Buff:IsA("Folder") then
        _bindAttrsBuffFolder(Attrs_Buff);

        return;
    end;

    table.insert(u11, LocalPlayer.ChildAdded:Connect(function(p65) -- Line: 419
        -- upvalues: _bindAttrsBuffFolder (ref)
        if p65.Name == "Attrs_Buff" and p65:IsA("Folder") then
            _bindAttrsBuffFolder(p65);
        end;
    end));
end)();
u13 = GetData.WaitBagNumberValue(LocalPlayer, EnumMgr.ItemID.ExtraMoveSpeed);
u10 = AddListen.NumValueAdd(u13, function() -- Line: 529
    -- upvalues: _calculateTargetSpeed (copy), u6 (ref), LocalPlayer (copy), Humanoid (copy)
    local v66 = _calculateTargetSpeed();
    local v67 = math.max(0, v66);

    if u6 == nil or math.abs(u6 - v67) >= 0.0001 then
        u6 = v67;
        LocalPlayer:SetAttribute("ExpectedWalkSpeed", v67);
    end;

    if Humanoid and Humanoid.Parent then
        Humanoid.WalkSpeed = v66;
    end;
end, true);
local v68 = _calculateTargetSpeed();
local v69 = math.max(0, v68);

if u6 == nil or math.abs(u6 - v69) >= 0.0001 then
    u6 = v69;
    LocalPlayer:SetAttribute("ExpectedWalkSpeed", v69);
end;

if Humanoid and Humanoid.Parent then
    Humanoid.WalkSpeed = v68;
end;

_syncSpeedBuffVfx();
CharacterMoveSpeedBind.setHandler(_updateCharacterSpeed);
u8 = RunService.Heartbeat:Connect(function(p70) -- Line: 546
    -- upvalues: Parent (copy), _updateMoveDirectionTransition (copy)
    if Parent.Parent == nil then
        return;
    end;

    _updateMoveDirectionTransition(p70);
end);
Parent.AncestryChanged:Connect(function(p71, p72) -- Line: 553
    -- upvalues: _cleanup (copy)
    if p72 == nil then
        _cleanup();
    end;
end);