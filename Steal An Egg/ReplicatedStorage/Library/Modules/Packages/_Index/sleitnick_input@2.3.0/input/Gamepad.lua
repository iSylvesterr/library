-- Decompiled with Potassium's decompiler.

local Trove = require(script.Parent.Parent.Trove);
local Signal = require(script.Parent.Parent.Signal);
local UserInputService = game:GetService("UserInputService");
local HapticService = game:GetService("HapticService");
local GuiService = game:GetService("GuiService");
local RunService = game:GetService("RunService");

local function ApplyDeadzone(p1, p2) -- Line: 13
    return math.abs(p1) < p2 and 0 or (math.abs(p1) - p2) / (1 - p2) * math.sign(p1);
end;

local function GetActiveGamepad() -- Line: 20
    -- upvalues: UserInputService (copy)
    local v3 = nil;
    local v4 = UserInputService:GetNavigationGamepads();

    if #v4 > 1 then
        for _, v in ipairs(v4) do
            if v3 == nil or v.Value < v3.Value then
                v3 = v;
            end;
        end;
    else
        local v5 = UserInputService:GetConnectedGamepads();

        for _, v in ipairs(v5) do
            if v3 == nil or v.Value < v3.Value then
                v3 = v;
            end;
        end;
    end;

    if v3 and not UserInputService:GetGamepadConnected(v3) then
        v3 = nil;
    end;

    return v3;
end;

local function HeartbeatDelay(u6, u7) -- Line: 43
    -- upvalues: RunService (copy)
    local u8 = time();
    local u9 = nil;
    u9 = RunService.Heartbeat:Connect(function() -- Line: 46
        -- upvalues: u8 (copy), u6 (copy), u9 (ref), u7 (copy)
        if u6 <= time() - u8 then
            u9:Disconnect();
            u7();
        end;
    end);

    return u9;
end;

local u10 = {};
u10.__index = u10;

function u10.new(p11) -- Line: 232
    -- upvalues: u10 (copy), Trove (copy), Signal (copy)
    local v12 = setmetatable({}, u10);
    v12._trove = Trove.new();
    v12._gamepadTrove = v12._trove:Construct(Trove);
    v12.ButtonDown = v12._trove:Construct(Signal);
    v12.ButtonUp = v12._trove:Construct(Signal);
    v12.Connected = v12._trove:Construct(Signal);
    v12.Disconnected = v12._trove:Construct(Signal);
    v12.GamepadChanged = v12._trove:Construct(Signal);
    v12.DefaultDeadzone = 0.05;
    v12.SupportsVibration = false;
    v12.State = {};
    v12:_setupGamepad(p11);
    v12:_setupMotors();

    return v12;
end;

function u10._setupActiveGamepad(u13, u14) -- Line: 249
    -- upvalues: HapticService (copy), UserInputService (copy)
    local _gamepad = u13._gamepad;

    if u14 == _gamepad then
        return;
    end;

    u13._gamepadTrove:Clean();
    table.clear(u13.State);
    local v15;

    if u14 then
        v15 = HapticService:IsVibrationSupported(u14);
    else
        v15 = false;
    end;

    u13.SupportsVibration = v15;
    u13._gamepad = u14;

    if not u14 then
        u13.Disconnected:Fire();
        u13.GamepadChanged:Fire(nil);

        return;
    end;

    for _, v in ipairs(UserInputService:GetGamepadState(u14)) do
        u13.State[v.KeyCode] = v;
    end;

    u13._gamepadTrove:Add(u13, "StopMotors");
    u13._gamepadTrove:Connect(UserInputService.InputBegan, function(p16, p17) -- Line: 274
        -- upvalues: u14 (copy), u13 (copy)
        if p16.UserInputType == u14 then
            u13.ButtonDown:Fire(p16.KeyCode, p17);
        end;
    end);
    u13._gamepadTrove:Connect(UserInputService.InputEnded, function(p18, p19) -- Line: 280
        -- upvalues: u14 (copy), u13 (copy)
        if p18.UserInputType == u14 then
            u13.ButtonUp:Fire(p18.KeyCode, p19);
        end;
    end);

    if _gamepad == nil then
        u13.Connected:Fire();
    end;

    u13.GamepadChanged:Fire(u14);
end;

function u10._setupGamepad(u20, u21) -- Line: 292
    -- upvalues: UserInputService (copy), GetActiveGamepad (copy)
    if u21 then
        u20._trove:Connect(UserInputService.GamepadConnected, function(p22) -- Line: 296
            -- upvalues: u21 (copy), u20 (copy)
            if p22 == u21 then
                u20:_setupActiveGamepad(u21);
            end;
        end);
        u20._trove:Connect(UserInputService.GamepadDisconnected, function(p23) -- Line: 302
            -- upvalues: u21 (copy), u20 (copy)
            if p23 == u21 then
                u20:_setupActiveGamepad(nil);
            end;
        end);

        if UserInputService:GetGamepadConnected(u21) then
            u20:_setupActiveGamepad(u21);
        end;
    else
        local function CheckToSetupActive() -- Line: 314
            -- upvalues: GetActiveGamepad (ref), u20 (copy)
            local v24 = GetActiveGamepad();

            if v24 ~= u20._gamepad then
                u20:_setupActiveGamepad(v24);
            end;
        end;

        u20._trove:Connect(UserInputService.GamepadConnected, CheckToSetupActive);
        u20._trove:Connect(UserInputService.GamepadDisconnected, CheckToSetupActive);
        u20:_setupActiveGamepad((GetActiveGamepad()));
    end;
end;

function u10._setupMotors(p25) -- Line: 327
    p25._setMotorIds = {};

    for _, v in ipairs(Enum.VibrationMotor:GetEnumItems()) do
        p25._setMotorIds[v] = 0;
    end;
end;

function u10.GetThumbstick(p26, p27, p28) -- Line: 349
    local Position = p26.State[p27].Position;
    local v29 = p28 or p26.DefaultDeadzone;
    local new = Vector2.new;
    local X = Position.X;
    local v30 = math.abs(X) < v29 and 0 or (math.abs(X) - v29) / (1 - v29) * math.sign(X);
    local Y = Position.Y;

    return new(v30, math.abs(Y) < v29 and 0 or (math.abs(Y) - v29) / (1 - v29) * math.sign(Y));
end;

function u10.GetTrigger(p31, p32, p33) -- Line: 371
    local Z = p31.State[p32].Position.Z;
    local v34 = p33 or p31.DefaultDeadzone;

    return math.abs(Z) < v34 and 0 or (math.abs(Z) - v34) / (1 - v34) * math.sign(Z);
end;

function u10.IsButtonDown(p35, p36) -- Line: 389
    -- upvalues: UserInputService (copy)
    return UserInputService:IsGamepadButtonDown(p35._gamepad, p36);
end;

function u10.IsMotorSupported(p37, p38) -- Line: 408
    -- upvalues: HapticService (copy)
    return HapticService:IsMotorSupported(p37._gamepad, p38);
end;

function u10.SetMotor(p39, p40, p41) -- Line: 422
    -- upvalues: HapticService (copy)
    local _setMotorIds = p39._setMotorIds;
    _setMotorIds[p40] = _setMotorIds[p40] + 1;
    local v42 = p39._setMotorIds[p40];
    HapticService:SetMotor(p39._gamepad, p40, p41);

    return v42;
end;

function u10.PulseMotor(u43, u44, p45, u46) -- Line: 454
    -- upvalues: RunService (copy)
    local u47 = u43:SetMotor(u44, p45);

    local function u48() -- Line: 456
        -- upvalues: u43 (copy), u44 (copy), u47 (copy)
        if u43._setMotorIds[u44] ~= u47 then
            return;
        end;

        u43:StopMotor(u44);
    end;

    local u49 = time();
    local u50 = nil;
    u50 = RunService.Heartbeat:Connect(function() -- Line: 46
        -- upvalues: u49 (copy), u46 (copy), u50 (ref), u48 (copy)
        if u46 <= time() - u49 then
            u50:Disconnect();
            u48();
        end;
    end);
    u43._gamepadTrove:Add(u50);
end;

function u10.StopMotor(p51, p52) -- Line: 476
    p51:SetMotor(p52, 0);
end;

function u10.StopMotors(p53) -- Line: 490
    for _, v in ipairs(Enum.VibrationMotor:GetEnumItems()) do
        if p53:IsMotorSupported(v) then
            p53:StopMotor(v);
        end;
    end;
end;

function u10.IsConnected(p54) -- Line: 502
    -- upvalues: UserInputService (copy)
    if p54._gamepad then
        return UserInputService:GetGamepadConnected(p54._gamepad);
    end;

    return false;
end;

function u10.GetUserInputType(p55) -- Line: 511
    return p55._gamepad;
end;

function u10.SetAutoSelectGui(p56, p57) -- Line: 533
    -- upvalues: GuiService (copy)
    GuiService.AutoSelectGuiEnabled = p57;
end;

function u10.IsAutoSelectGuiEnabled(p58) -- Line: 542
    -- upvalues: GuiService (copy)
    return GuiService.AutoSelectGuiEnabled;
end;

function u10.Destroy(p59) -- Line: 549
    p59._trove:Destroy();
end;

return u10;