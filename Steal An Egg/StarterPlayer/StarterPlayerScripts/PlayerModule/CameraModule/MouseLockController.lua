-- Decompiled with Potassium's decompiler.

local ContextActionService = game:GetService("ContextActionService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local CameraUtils = require(script.Parent.CameraUtils);
local FlagUtil = require(script.Parent.Parent.CommonUtils.FlagUtil);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Signal = require(ReplicatedStorage.Library.Modules.Packages.Signal);
local Variables = require(ReplicatedStorage.Library.Variables);
local u1 = {};
u1.__index = u1;
u1.__class = "MouseLockController";
local Value = Enum.ContextActionPriority.Medium.Value;
local u2 = FlagUtil.getUserFlag("UserPreferredInputPlayerScripts2");
local GameSettings = UserSettings().GameSettings;
local LocalPlayer = Players.LocalPlayer;
local u3 = Log.new();

function u1.new() -- Line: 46
    -- upvalues: u1 (copy), Signal (copy)
    local v4 = setmetatable({}, u1);
    v4.boundKeys = { Enum.KeyCode.LeftShift, Enum.KeyCode.RightShift };
    v4.enabled = false;
    v4.isMouseLocked = false;
    v4.mouseLockToggledEvent = Signal.new();
    v4:_init();

    return v4;
end;

function u1._updateMouseLockAvailability(p5) -- Line: 62
    -- upvalues: LocalPlayer (copy), GameSettings (copy), UserInputService (copy), Variables (copy), u2 (copy), u3 (copy)
    local DevEnableMouseLock = LocalPlayer.DevEnableMouseLock;
    local v6 = LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.Scriptable;
    local v7 = GameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch;
    local v8 = GameSettings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove;
    local v9 = UserInputService.PreferredInput == Enum.PreferredInput.KeyboardAndMouse;
    local v10 = not Variables.Locks.DisableShiftLock:IsLocked();

    if not u2 or v9 then
        v9 = DevEnableMouseLock and (v7 and not v8) and (not v6 and v10);
    end;

    if v9 ~= p5.enabled then
        if not v10 then
            u3:AtDebug():Log("PlayerModule mouse lock suppressed by a gameplay lock");
        end;

        p5:EnableMouseLock(v9);
    end;
end;

function u1._onBoundKeysObjectChanged(p11, p12) -- Line: 84
    local v13 = {};

    for i in string.gmatch(p12, "[^%s,]+") do
        for _, v in Enum.KeyCode:GetEnumItems() do
            if v.Name == i then
                table.insert(v13, v);
                break;
            end;
        end;
    end;

    p11.boundKeys = v13;
    p11:_unbindContextActions();

    if p11.enabled then
        p11:_bindContextActions();
    end;
end;

function u1._onMouseLockToggled(p14) -- Line: 101
    -- upvalues: CameraUtils (copy)
    p14.isMouseLocked = not p14.isMouseLocked;

    if p14.isMouseLocked then
        local CursorImage = script:FindFirstChild("CursorImage");
        local v15 = (CursorImage == nil or not CursorImage:IsA("StringValue")) and "rbxasset://textures/MouseLockedCursor.png" or CursorImage.Value;
        CameraUtils.setMouseIconOverride(v15);
    else
        CameraUtils.restoreMouseIcon();
    end;

    p14.mouseLockToggledEvent:Fire();
end;

function u1._doMouseLockSwitch(p16, p17, p18, p19) -- Line: 118
    if p18 ~= Enum.UserInputState.Begin then
        return Enum.ContextActionResult.Pass;
    end;

    p16:_onMouseLockToggled();

    return Enum.ContextActionResult.Sink;
end;

function u1._bindContextActions(u20) -- Line: 131
    -- upvalues: ContextActionService (copy), Value (copy)
    ContextActionService:BindActionAtPriority("MouseLockSwitchAction", function(p21, p22, p23) -- Line: 134
        -- upvalues: u20 (copy)
        return u20:_doMouseLockSwitch(p21, p22, p23);
    end, false, Value, table.unpack(u20.boundKeys));
end;

function u1._unbindContextActions(p24) -- Line: 143
    -- upvalues: ContextActionService (copy)
    ContextActionService:UnbindAction("MouseLockSwitchAction");
end;

function u1.GetIsMouseLocked(p25) -- Line: 151
    return p25.isMouseLocked;
end;

function u1.GetBindableToggleEvent(p26) -- Line: 155
    return p26.mouseLockToggledEvent;
end;

function u1.GetMouseLockOffset(p27) -- Line: 159
    return Vector3.new(1.75, 0, 0);
end;

function u1.IsMouseLocked(p28) -- Line: 163
    return p28.enabled and p28.isMouseLocked;
end;

function u1.EnableMouseLock(p29, p30) -- Line: 167
    -- upvalues: CameraUtils (copy)
    if p30 == p29.enabled then
        return;
    end;

    p29.enabled = p30;

    if p30 then
        p29:_bindContextActions();

        return;
    end;

    CameraUtils.restoreMouseIcon();
    p29:_unbindContextActions();

    if p29.isMouseLocked then
        p29.isMouseLocked = false;
        p29.mouseLockToggledEvent:Fire();
    end;
end;

function u1._init(u31) -- Line: 190
    -- upvalues: GameSettings (copy), LocalPlayer (copy), u2 (copy), UserInputService (copy), Variables (copy)
    local BoundKeys = script:FindFirstChild("BoundKeys");

    if BoundKeys ~= nil and BoundKeys:IsA("StringValue") then
        BoundKeys.Changed:Connect(function(p32) -- Line: 193
            -- upvalues: u31 (copy)
            u31:_onBoundKeysObjectChanged(p32);
        end);
        u31:_onBoundKeysObjectChanged(BoundKeys.Value);
    end;

    GameSettings.Changed:Connect(function(p33) -- Line: 199
        -- upvalues: u31 (copy)
        if p33 == "ControlMode" or p33 == "ComputerMovementMode" then
            u31:_updateMouseLockAvailability();
        end;
    end);
    LocalPlayer:GetPropertyChangedSignal("DevEnableMouseLock"):Connect(function() -- Line: 204
        -- upvalues: u31 (copy)
        u31:_updateMouseLockAvailability();
    end);
    LocalPlayer:GetPropertyChangedSignal("DevComputerMovementMode"):Connect(function() -- Line: 207
        -- upvalues: u31 (copy)
        u31:_updateMouseLockAvailability();
    end);

    if u2 then
        UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function() -- Line: 211
            -- upvalues: u31 (copy)
            u31:_updateMouseLockAvailability();
        end);
    end;

    Variables.Locks.DisableShiftLock.Modified:Connect(function() -- Line: 215
        -- upvalues: u31 (copy)
        u31:_updateMouseLockAvailability();
    end);
    u31:_updateMouseLockAvailability();
end;

return u1;