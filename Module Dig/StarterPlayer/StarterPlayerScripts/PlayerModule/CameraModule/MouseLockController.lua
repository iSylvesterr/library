-- Decompiled with Potassium's decompiler.

local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils");
local FlagUtil = require(CommonUtils:WaitForChild("FlagUtil"));
local Value = Enum.ContextActionPriority.Medium.Value;
local Players = game:GetService("Players");
local ContextActionService = game:GetService("ContextActionService");
local UserInputService = game:GetService("UserInputService");
local GameSettings = UserSettings().GameSettings;
local CameraUtils = require(script.Parent:WaitForChild("CameraUtils"));
local u1 = FlagUtil.getUserFlag("UserPreferredInputPlayerScripts2");
local u2 = {};
u2.__index = u2;

function u2.new() -- Line: 34
    -- upvalues: u2 (copy), GameSettings (copy), Players (copy), u1 (copy), UserInputService (copy)
    local u3 = setmetatable({}, u2);
    u3.isMouseLocked = false;
    u3.savedMouseCursor = nil;
    u3.boundKeys = { Enum.KeyCode.LeftShift, Enum.KeyCode.RightShift };
    u3.mouseLockToggledEvent = Instance.new("BindableEvent");
    local BoundKeys = script:FindFirstChild("BoundKeys");

    if not (BoundKeys and BoundKeys:IsA("StringValue")) then
        if BoundKeys then
            BoundKeys:Destroy();
        end;

        BoundKeys = Instance.new("StringValue");
        assert(BoundKeys, "");
        BoundKeys.Name = "BoundKeys";
        BoundKeys.Value = "LeftShift,RightShift";
        BoundKeys.Parent = script;
    end;

    if BoundKeys then
        BoundKeys.Changed:Connect(function(p4) -- Line: 59
            -- upvalues: u3 (copy)
            u3:OnBoundKeysObjectChanged(p4);
        end);
        u3:OnBoundKeysObjectChanged(BoundKeys.Value);
    end;

    GameSettings.Changed:Connect(function(p5) -- Line: 66
        -- upvalues: u3 (copy)
        if p5 == "ControlMode" or p5 == "ComputerMovementMode" then
            u3:UpdateMouseLockAvailability();
        end;
    end);
    Players.LocalPlayer:GetPropertyChangedSignal("DevEnableMouseLock"):Connect(function() -- Line: 73
        -- upvalues: u3 (copy)
        u3:UpdateMouseLockAvailability();
    end);
    Players.LocalPlayer:GetPropertyChangedSignal("DevComputerMovementMode"):Connect(function() -- Line: 78
        -- upvalues: u3 (copy)
        u3:UpdateMouseLockAvailability();
    end);

    if u1 then
        UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function() -- Line: 83
            -- upvalues: u3 (copy)
            u3:UpdateMouseLockAvailability();
        end);
    end;

    u3:UpdateMouseLockAvailability();

    return u3;
end;

function u2.GetIsMouseLocked(p6) -- Line: 93
    return p6.isMouseLocked;
end;

function u2.GetBindableToggleEvent(p7) -- Line: 97
    return p7.mouseLockToggledEvent.Event;
end;

function u2.GetMouseLockOffset(p8) -- Line: 101
    return Vector3.new(1.75, 0, 0);
end;

function u2.UpdateMouseLockAvailability(p9) -- Line: 105
    -- upvalues: Players (copy), GameSettings (copy), UserInputService (copy), u1 (copy)
    local DevEnableMouseLock = Players.LocalPlayer.DevEnableMouseLock;
    local v10 = Players.LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.Scriptable;
    local v11 = GameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch;
    local v12 = GameSettings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove;
    local v13 = UserInputService.PreferredInput == Enum.PreferredInput.KeyboardAndMouse;

    if u1 and not v13 then
        v11 = v13;
    elseif DevEnableMouseLock then
        if v11 then
            v11 = not v12 and not v10;
        end;
    else
        v11 = DevEnableMouseLock;
    end;

    if v11 ~= p9.enabled then
        p9:EnableMouseLock(v11);
    end;
end;

function u2.OnBoundKeysObjectChanged(p14, p15) -- Line: 118
    p14.boundKeys = {};

    for i in string.gmatch(p15, "[^%s,]+") do
        for _, v in pairs(Enum.KeyCode:GetEnumItems()) do
            if i == v.Name then
                p14.boundKeys[#p14.boundKeys + 1] = v;
                break;
            end;
        end;
    end;

    p14:UnbindContextActions();
    p14:BindContextActions();
end;

function u2.OnMouseLockToggled(p16) -- Line: 133
    -- upvalues: CameraUtils (copy)
    p16.isMouseLocked = not p16.isMouseLocked;

    if p16.isMouseLocked then
        local CursorImage = script:FindFirstChild("CursorImage");

        if CursorImage and (CursorImage:IsA("StringValue") and CursorImage.Value) then
            CameraUtils.setMouseIconOverride(CursorImage.Value);
        else
            if CursorImage then
                CursorImage:Destroy();
            end;

            local StringValue = Instance.new("StringValue");
            assert(StringValue, "");
            StringValue.Name = "CursorImage";
            StringValue.Value = "rbxasset://textures/MouseLockedCursor.png";
            StringValue.Parent = script;
            CameraUtils.setMouseIconOverride("rbxasset://textures/MouseLockedCursor.png");
        end;
    else
        CameraUtils.restoreMouseIcon();
    end;

    p16.mouseLockToggledEvent:Fire();
end;

function u2.DoMouseLockSwitch(p17, p18, p19, p20) -- Line: 158
    if p19 ~= Enum.UserInputState.Begin then
        return Enum.ContextActionResult.Pass;
    end;

    p17:OnMouseLockToggled();

    return Enum.ContextActionResult.Sink;
end;

function u2.BindContextActions(u21) -- Line: 166
    -- upvalues: ContextActionService (copy), Value (copy)
    ContextActionService:BindActionAtPriority("MouseLockSwitchAction", function(p22, p23, p24) -- Line: 167
        -- upvalues: u21 (copy)
        return u21:DoMouseLockSwitch(p22, p23, p24);
    end, false, Value, unpack(u21.boundKeys));
end;

function u2.UnbindContextActions(p25) -- Line: 172
    -- upvalues: ContextActionService (copy)
    ContextActionService:UnbindAction("MouseLockSwitchAction");
end;

function u2.IsMouseLocked(p26) -- Line: 176
    return p26.enabled and p26.isMouseLocked;
end;

function u2.EnableMouseLock(p27, p28) -- Line: 180
    -- upvalues: CameraUtils (copy)
    if p28 ~= p27.enabled then
        p27.enabled = p28;

        if p27.enabled then
            p27:BindContextActions();

            return;
        end;

        CameraUtils.restoreMouseIcon();
        p27:UnbindContextActions();

        if p27.isMouseLocked then
            p27.mouseLockToggledEvent:Fire();
        end;

        p27.isMouseLocked = false;
    end;
end;

return u2;