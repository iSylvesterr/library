-- Decompiled with Potassium's decompiler.

local ContextActionService = game:GetService("ContextActionService");
local UserInputService = game:GetService("UserInputService");
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local UserGameSettings = UserSettings():GetService("UserGameSettings");
local VRService = game:GetService("VRService");
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils");
local u1 = require(CommonUtils:WaitForChild("FlagUtil")).getUserFlag("UserCameraInputDt");
local LocalPlayer = Players.LocalPlayer;
local Value = Enum.ContextActionPriority.Medium.Value;
local u2 = Vector2.new(1, 0.77) * 0.06981317007977318;
local u3 = Vector2.new(1, 0.77) * 0.008726646259971648;
local u4 = Vector2.new(1, 0.77) * 0.12217304763960307;
local u5 = Vector2.new(1, 0.66) * 0.017453292519943295;

if u1 then
    u2 = u2 * 60;
end;

local success, result = pcall(function() -- Line: 41
    return UserSettings():IsUserFeatureEnabled("UserResetTouchStateOnMenuOpen");
end);
local u6 = success and result;
local success2, result2 = pcall(function() -- Line: 49
    return UserSettings():IsUserFeatureEnabled("UserClearPanOnCameraDisable");
end);
local u7 = success2 and result2;
local BindableEvent = Instance.new("BindableEvent");
local BindableEvent2 = Instance.new("BindableEvent");
local Event = BindableEvent.Event;
local Event2 = BindableEvent2.Event;
UserInputService.InputBegan:Connect(function(p8, p9) -- Line: 63
    -- upvalues: BindableEvent (copy)
    if not p9 and p8.UserInputType == Enum.UserInputType.MouseButton2 then
        BindableEvent:Fire();
    end;
end);
UserInputService.InputEnded:Connect(function(p10, p11) -- Line: 69
    -- upvalues: BindableEvent2 (copy)
    if p10.UserInputType == Enum.UserInputType.MouseButton2 then
        BindableEvent2:Fire();
    end;
end);

local function thumbstickCurve(p12) -- Line: 80
    local v13 = (math.abs(p12) - 0.1) / 0.9 * 2;
    local v14 = (math.exp(v13) - 1) / 6.38905609893065;

    return math.sign(p12) * math.clamp(v14, 0, 1);
end;

local function adjustTouchPitchSensitivity(p15) -- Line: 94
    local CurrentCamera = workspace.CurrentCamera;

    if not CurrentCamera then
        return p15;
    end;

    local v16 = CurrentCamera.CFrame:ToEulerAnglesYXZ();

    if p15.Y * v16 >= 0 then
        return p15;
    end;

    local v17 = (1 - (math.abs(v16) * 2 / 3.141592653589793) ^ 0.75) * 0.75 + 0.25;

    return Vector2.new(1, v17) * p15;
end;

local function isInDynamicThumbstickArea(p18) -- Line: 120
    -- upvalues: LocalPlayer (copy)
    local v19 = LocalPlayer:FindFirstChildOfClass("PlayerGui");

    if v19 then
        v19 = v19:FindFirstChild("TouchGui");
    end;

    local v20;

    if v19 then
        v20 = v19:FindFirstChild("TouchControlFrame");
    else
        v20 = v19;
    end;

    if v20 then
        v20 = v20:FindFirstChild("DynamicThumbstickFrame");
    end;

    if not v20 then
        return false;
    end;

    if not v19.Enabled then
        return false;
    end;

    local AbsolutePosition = v20.AbsolutePosition;
    local v21 = AbsolutePosition + v20.AbsoluteSize;
    local v22;

    if p18.X >= AbsolutePosition.X and (p18.Y >= AbsolutePosition.Y and p18.X <= v21.X) then
        v22 = p18.Y <= v21.Y;
    else
        v22 = false;
    end;

    return v22;
end;

local u23 = 0.016666666666666666;
RunService.Stepped:Connect(function(p24, p25) -- Line: 145
    -- upvalues: u23 (ref)
    u23 = p25;
end);
local v26 = {};
local u27 = {};
local u28 = 0;

local function incPanInputCount() -- Line: 155
    -- upvalues: u28 (ref)
    u28 = math.max(0, u28 + 1);
end;

local function decPanInputCount() -- Line: 159
    -- upvalues: u28 (ref)
    u28 = math.max(0, u28 - 1);
end;

local function resetPanInputCount() -- Line: 163
    -- upvalues: u28 (ref)
    u28 = 0;
end;

local u29 = 1;
local u30 = {
    Thumbstick2 = Vector2.new()
};
local u31 = {
    Left = 0,
    Right = 0,
    I = 0,
    O = 0
};
local u32 = {
    Wheel = 0,
    Pinch = 0,
    Movement = Vector2.new(),
    Pan = Vector2.new()
};
local u33 = {
    Pinch = 0,
    Move = Vector2.new()
};
local BindableEvent3 = Instance.new("BindableEvent");
v26.gamepadZoomPress = BindableEvent3.Event;
local u34 = VRService.VREnabled and Instance.new("BindableEvent") or nil;

if VRService.VREnabled then
    v26.gamepadReset = u34.Event;
end;

function v26.getRotationActivated() -- Line: 207
    -- upvalues: u28 (ref), u30 (copy)
    return u28 > 0 and true or u30.Thumbstick2.Magnitude > 0;
end;

function v26.addTouchMove(p35) -- Line: 211
    -- upvalues: u33 (copy)
    local v36 = u33;
    v36.Move = v36.Move + p35;
end;

function v26.setTouchSensitivity(p37) -- Line: 216
    -- upvalues: u29 (ref)
    u29 = math.clamp(p37 or 1, 0.1, 10);
end;

function v26.getRotation(p38, p39) -- Line: 220
    -- upvalues: UserGameSettings (copy), u1 (copy), u31 (copy), u23 (ref), u30 (copy), u32 (copy), adjustTouchPitchSensitivity (copy), u33 (copy), u2 (ref), u3 (copy), u4 (copy), u5 (copy), u29 (ref)
    local v40 = Vector2.new(1, UserGameSettings:GetCameraYInvertValue());
    local v41;

    if u1 then
        v41 = Vector2.new(u31.Right - u31.Left, 0) * p38;
    else
        v41 = Vector2.new(u31.Right - u31.Left, 0) * u23;
    end;

    local v42 = u30.Thumbstick2 * UserGameSettings.GamepadCameraSensitivity;

    if u1 then
        v42 = v42 * p38;
    end;

    local Movement = u32.Movement;
    local Pan = u32.Pan;
    local v43 = adjustTouchPitchSensitivity(u33.Move);

    if p39 then
        v41 = Vector2.new();
    end;

    return (v41 * 2.0943951023931953 + v42 * u2 + Movement * u3 + Pan * u4 + v43 * u5 * u29) * v40;
end;

function v26.getZoomDelta() -- Line: 273
    -- upvalues: u31 (copy), u32 (copy), u33 (copy)
    return (u31.O - u31.I) * 0.1 + (-u32.Wheel + u32.Pinch) * 1 + -u33.Pinch * 0.04;
end;

local function thumbstick(p44, p45, p46) -- Line: 281
    -- upvalues: u30 (copy), thumbstickCurve (ref)
    local Position = p46.Position;
    u30[p46.KeyCode.Name] = Vector2.new(thumbstickCurve(Position.X), -thumbstickCurve(Position.Y));

    return Enum.ContextActionResult.Pass;
end;

local function mouseMovement(p47) -- Line: 287
    -- upvalues: u32 (copy)
    local Delta = p47.Delta;
    u32.Movement = Vector2.new(Delta.X, Delta.Y);
end;

local function mouseWheel(p48, p49, p50) -- Line: 292
    -- upvalues: u32 (copy)
    u32.Wheel = p50.Position.Z;

    return Enum.ContextActionResult.Pass;
end;

local function keypress(p51, p52, p53) -- Line: 297
    -- upvalues: u31 (copy)
    u31[p53.KeyCode.Name] = p52 == Enum.UserInputState.Begin and 1 or 0;
end;

local function gamepadZoomPress(p54, p55, p56) -- Line: 301
    -- upvalues: BindableEvent3 (copy)
    if p55 == Enum.UserInputState.Begin then
        BindableEvent3:Fire();
    end;
end;

local function gamepadReset(p57, p58, p59) -- Line: 307
    -- upvalues: u34 (copy)
    if p58 == Enum.UserInputState.Begin then
        u34:Fire();
    end;
end;

local function resetInputDevices() -- Line: 313
    -- upvalues: u30 (copy), u31 (copy), u32 (copy), u33 (copy), u7 (ref), u28 (ref)
    for _, v in pairs({
        u30,
        u31,
        u32,
        u33
    }) do
        for i, v2 in pairs(v) do
            if type(v2) == "boolean" then
                v[i] = false;
            else
                v[i] = v[i] * 0;
            end;
        end;
    end;

    if u7 then
        u28 = 0;
    end;
end;

local u60 = {};
local u61 = nil;
local u62 = nil;

local function touchBegan(p63, p64) -- Line: 341
    -- upvalues: u61 (ref), isInDynamicThumbstickArea (copy), u28 (ref), u60 (ref)
    assert(p63.UserInputType == Enum.UserInputType.Touch);
    assert(p63.UserInputState == Enum.UserInputState.Begin);

    if u61 == nil and (isInDynamicThumbstickArea(p63.Position) and not p64) then
        u61 = p63;

        return;
    end;

    if not p64 then
        u28 = math.max(0, u28 + 1);
    end;

    u60[p63] = p64;
end;

local function touchEnded(p65, p66) -- Line: 361
    -- upvalues: u61 (ref), u60 (ref), u62 (ref), u28 (ref)
    assert(p65.UserInputType == Enum.UserInputType.Touch);
    assert(p65.UserInputState == Enum.UserInputState.End);

    if p65 == u61 then
        u61 = nil;
    end;

    if u60[p65] == false then
        u62 = nil;
        u28 = math.max(0, u28 - 1);
    end;

    u60[p65] = nil;
end;

local function touchChanged(p67, p68) -- Line: 380
    -- upvalues: u61 (ref), u60 (ref), u33 (copy), u62 (ref)
    assert(p67.UserInputType == Enum.UserInputType.Touch);
    assert(p67.UserInputState == Enum.UserInputState.Change);

    if p67 == u61 then
        return;
    end;

    if u60[p67] == nil then
        u60[p67] = p68;
    end;

    local v69 = {};

    for i, v in pairs(u60) do
        if not v then
            table.insert(v69, i);
        end;
    end;

    if #v69 == 1 and u60[p67] == false then
        local Delta = p67.Delta;
        local v70 = u33;
        v70.Move = v70.Move + Vector2.new(Delta.X, Delta.Y);
    end;

    if #v69 ~= 2 then
        u62 = nil;

        return;
    end;

    local Magnitude = (v69[1].Position - v69[2].Position).Magnitude;

    if u62 then
        local v71 = u33;
        v71.Pinch = v71.Pinch + (Magnitude - u62);
    end;

    u62 = Magnitude;
end;

local function resetTouchState() -- Line: 424
    -- upvalues: u60 (ref), u61 (ref), u62 (ref), u6 (ref), u28 (ref)
    u60 = {};
    u61 = nil;
    u62 = nil;

    if u6 then
        u28 = 0;
    end;
end;

local function pointerAction(p72, p73, p74, p75) -- Line: 434
    -- upvalues: u32 (copy)
    if not p75 then
        u32.Wheel = p72;
        u32.Pan = p73;
        u32.Pinch = -p74;
    end;
end;

local function inputBegan(p76, p77) -- Line: 442
    -- upvalues: touchBegan (ref), u28 (ref)
    if p76.UserInputType == Enum.UserInputType.Touch then
        touchBegan(p76, p77);

        return;
    end;

    if p76.UserInputType == Enum.UserInputType.MouseButton2 and not p77 then
        u28 = math.max(0, u28 + 1);
    end;
end;

local function inputChanged(p78, p79) -- Line: 451
    -- upvalues: touchChanged (ref), u32 (copy)
    if p78.UserInputType == Enum.UserInputType.Touch then
        touchChanged(p78, p79);

        return;
    end;

    if p78.UserInputType == Enum.UserInputType.MouseMovement then
        local Delta = p78.Delta;
        u32.Movement = Vector2.new(Delta.X, Delta.Y);
    end;
end;

local function inputEnded(p80, p81) -- Line: 460
    -- upvalues: touchEnded (ref), u28 (ref)
    if p80.UserInputType == Enum.UserInputType.Touch then
        touchEnded(p80, p81);

        return;
    end;

    if p80.UserInputType == Enum.UserInputType.MouseButton2 then
        u28 = math.max(0, u28 - 1);
    end;
end;

local u82 = false;

function v26.setInputEnabled(p83) -- Line: 471
    -- upvalues: u82 (ref), resetInputDevices (copy), resetTouchState (ref), ContextActionService (copy), thumbstick (copy), Value (copy), keypress (copy), VRService (copy), gamepadReset (copy), gamepadZoomPress (copy), u27 (ref), UserInputService (copy), inputBegan (copy), inputChanged (copy), inputEnded (copy), pointerAction (copy), u6 (ref)
    if u82 == p83 then
        return;
    end;

    u82 = p83;
    resetInputDevices();
    resetTouchState();

    if u82 then
        ContextActionService:BindActionAtPriority("RbxCameraThumbstick", thumbstick, false, Value, Enum.KeyCode.Thumbstick2);
        ContextActionService:BindActionAtPriority("RbxCameraKeypress", keypress, false, Value, Enum.KeyCode.I);

        if VRService.VREnabled then
            ContextActionService:BindAction("RbxCameraGamepadReset", gamepadReset, false, Enum.KeyCode.ButtonL3);
        end;

        ContextActionService:BindAction("RbxCameraGamepadZoom", gamepadZoomPress, false, Enum.KeyCode.ButtonR3);
        table.insert(u27, UserInputService.InputBegan:Connect(inputBegan));
        table.insert(u27, UserInputService.InputChanged:Connect(inputChanged));
        table.insert(u27, UserInputService.InputEnded:Connect(inputEnded));
        table.insert(u27, UserInputService.PointerAction:Connect(pointerAction));

        if u6 then
            local MenuOpened = game:GetService("GuiService").MenuOpened;
            table.insert(u27, MenuOpened:connect(resetTouchState));
        end;
    else
        ContextActionService:UnbindAction("RbxCameraThumbstick");
        ContextActionService:UnbindAction("RbxCameraMouseMove");
        ContextActionService:UnbindAction("RbxCameraMouseWheel");
        ContextActionService:UnbindAction("RbxCameraKeypress");
        ContextActionService:UnbindAction("RbxCameraGamepadZoom");

        if VRService.VREnabled then
            ContextActionService:UnbindAction("RbxCameraGamepadReset");
        end;

        for _, v in pairs(u27) do
            v:Disconnect();
        end;

        u27 = {};
    end;
end;

function v26.getInputEnabled() -- Line: 543
    -- upvalues: u82 (ref)
    return u82;
end;

function v26.resetInputForFrameEnd() -- Line: 547
    -- upvalues: u32 (copy), u33 (copy)
    u32.Movement = Vector2.new();
    u33.Move = Vector2.new();
    u33.Pinch = 0;
    u32.Wheel = 0;
    u32.Pan = Vector2.new();
    u32.Pinch = 0;
end;

UserInputService.WindowFocused:Connect(resetInputDevices);
UserInputService.WindowFocusReleased:Connect(resetInputDevices);
local u84 = false;
local u85 = false;
local u86 = 0;

function v26.getHoldPan() -- Line: 568
    -- upvalues: u84 (ref)
    return u84;
end;

function v26.getTogglePan() -- Line: 572
    -- upvalues: u85 (ref)
    return u85;
end;

function v26.getPanning() -- Line: 576
    -- upvalues: u85 (ref), u84 (ref)
    return u85 or u84;
end;

function v26.setTogglePan(p87) -- Line: 580
    -- upvalues: u85 (ref)
    u85 = p87;
end;

local u88 = false;
local u89 = nil;
local u90 = nil;

function v26.enableCameraToggleInput() -- Line: 588
    -- upvalues: u88 (ref), u84 (ref), u85 (ref), u89 (ref), u90 (ref), Event (ref), u86 (ref), Event2 (ref), UserInputService (copy)
    if u88 then
        return;
    end;

    u88 = true;
    u84 = false;
    u85 = false;

    if u89 then
        u89:Disconnect();
    end;

    if u90 then
        u90:Disconnect();
    end;

    u89 = Event:Connect(function() -- Line: 605
        -- upvalues: u84 (ref), u86 (ref)
        u84 = true;
        u86 = tick();
    end);
    u90 = Event2:Connect(function() -- Line: 610
        -- upvalues: u84 (ref), u86 (ref), u85 (ref), UserInputService (ref)
        u84 = false;

        if tick() - u86 < 0.3 and (u85 or UserInputService:GetMouseDelta().Magnitude < 2) then
            u85 = not u85;
        end;
    end);
end;

function v26.disableCameraToggleInput() -- Line: 618
    -- upvalues: u88 (ref), u89 (ref), u90 (ref)
    if not u88 then
        return;
    end;

    u88 = false;

    if u89 then
        u89:Disconnect();
        u89 = nil;
    end;

    if u90 then
        u90:Disconnect();
        u90 = nil;
    end;
end;

return v26;