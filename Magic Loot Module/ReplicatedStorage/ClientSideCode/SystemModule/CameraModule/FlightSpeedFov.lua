-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local u1 = CFrame.new();
local u2 = {
    helperEventName = "飞行_移速影响相机FOV",
    suppressGroundSpeedFov = true,
    groundHelperEventName = "移速影响相机FOV",
    speedEnterSpeed = 16,
    speedExitSpeed = 0.01,
    sprintMinHold = 0.35,
    sprintResumeDelay = 0,
    maxChangeFov = 20,
    fovChangeSpeed = 30,
    fovResumeSpeed = 15,
    fovDriveMode = "proportional",
    proportionalBlendSpeed = 20,
    speedEnterRatio = 1,
    speedExitRatio = 0.08,
    easingStyle = Enum.EasingStyle.Sine,
    easingDirection = Enum.EasingDirection.Out
};
local u3 = {};
u3.__index = u3;

local function mergeConfig(p4, p5) -- Line: 92
    if not p5 then
        return table.clone(p4);
    end;

    local v6 = table.clone(p4);

    for i, v in pairs(p5) do
        v6[i] = v;
    end;

    return v6;
end;

function u3.new(p7, p8) -- Line: 103
    -- upvalues: u2 (copy), u3 (copy)
    local v9 = {
        _active = false,
        _currentSpeed = 0,
        _runtimeSpeedCap = nil,
        _speedFov = 0,
        _fovState = "Min",
        _sprintEnteredClock = nil,
        _resumeAfterClock = nil,
        _fovTweenConnection = nil,
        _suppressedGroundHelper = false,
        _cameraModule = p7
    };
    local v10 = u2;
    local v11;

    if p8 then
        v11 = table.clone(v10);

        for i, v in pairs(p8) do
            v11[i] = v;
        end;
    else
        v11 = table.clone(v10);
    end;

    v9._config = v11;

    return setmetatable(v9, u3);
end;

function u3.GetConfig(p12) -- Line: 120
    return table.clone(p12._config);
end;

function u3.SetConfig(p13, p14) -- Line: 124
    local _config = p13._config;
    local v15;

    if p14 then
        v15 = table.clone(_config);

        for i, v in pairs(p14) do
            v15[i] = v;
        end;
    else
        v15 = table.clone(_config);
    end;

    p13._config = v15;
end;

function u3.SetSpeed(p16, p17, p18) -- Line: 128
    p16._currentSpeed = math.max(0, p17);

    if p18 ~= nil and p18 > 0 then
        p16._runtimeSpeedCap = p18;
    end;
end;

function u3.SyncThresholdsFromMaxSpeed(p19, p20) -- Line: 135
    local _config = p19._config;
    local speedEnterRatio = _config.speedEnterRatio;
    local speedExitRatio = _config.speedExitRatio;

    if speedEnterRatio == nil and speedExitRatio == nil then
        return;
    end;

    local v21 = {};

    if speedEnterRatio ~= nil then
        v21.speedEnterSpeed = p20 * speedEnterRatio;
    end;

    if speedExitRatio ~= nil then
        v21.speedExitSpeed = math.max(p20 * speedExitRatio, 0.01);
    end;

    p19:SetConfig(v21);
end;

function u3.GetSpeed(p22) -- Line: 152
    return p22._currentSpeed;
end;

function u3.GetFovOffset(p23) -- Line: 156
    return p23._speedFov;
end;

function u3.IsActive(p24) -- Line: 160
    return p24._active;
end;

function u3._disconnectFovTween(p25) -- Line: 164
    if p25._fovTweenConnection then
        p25._fovTweenConnection:Disconnect();
        p25._fovTweenConnection = nil;
    end;
end;

function u3.ComputeUniformTargetFov(p26) -- Line: 179
    -- upvalues: u2 (copy)
    local _config = p26._config;
    local v27 = _config.maxChangeFov or u2.maxChangeFov;
    local speedEnterRatio = _config.speedEnterRatio;
    local v28 = speedEnterRatio == nil and 1 or speedEnterRatio;
    local v29 = _config.speedExitRatio or u2.speedExitRatio;
    local v30, v31;

    if p26._runtimeSpeedCap and p26._runtimeSpeedCap > 0 then
        v30 = p26._runtimeSpeedCap * v28;
        v31 = math.max(p26._runtimeSpeedCap * v29, 0.01);
    else
        v30 = _config.speedEnterSpeed or u2.speedEnterSpeed;
        v31 = _config.speedExitSpeed or u2.speedExitSpeed;
    end;

    local v32 = math.max(v30 - v31, 0.001);

    return v27 * math.clamp((p26._currentSpeed - v31) / v32, 0, 1);
end;

function u3._tickUniform(p33) -- Line: 205
    p33:_disconnectFovTween();
    p33._speedFov = p33:ComputeUniformTargetFov();
end;

function u3._tickProportional(p34, p35) -- Line: 211
    -- upvalues: u2 (copy)
    p34:_disconnectFovTween();
    local v36 = p34:ComputeUniformTargetFov();
    p34._speedFov = p34._speedFov + (v36 - p34._speedFov) * (p35 * (p34._config.proportionalBlendSpeed or u2.proportionalBlendSpeed));
end;

function u3._tweenFovTo(u37, p38) -- Line: 218
    -- upvalues: u2 (copy), RunService (copy), TweenService (copy)
    u37:_disconnectFovTween();
    local _config = u37._config;
    local u39 = _config.maxChangeFov or u2.maxChangeFov;
    local v40 = _config.fovChangeSpeed or u2.fovChangeSpeed;
    local v41 = _config.fovResumeSpeed or u2.fovResumeSpeed;
    local u42 = _config.easingStyle or u2.easingStyle;
    local u43 = _config.easingDirection or u2.easingDirection;
    local _speedFov = u37._speedFov;
    local u44 = _speedFov < p38;
    local v45;

    if u44 then
        v45 = u39 - _speedFov;
    else
        v45 = _speedFov;
    end;

    if v45 <= 1e-6 then
        u37._speedFov = p38;

        return;
    end;

    if u44 then
        v41 = v40;
    end;

    local u46 = v45 / v41;
    local u47 = 0;
    u37._fovTweenConnection = RunService.Heartbeat:Connect(function(p48) -- Line: 240
        -- upvalues: u47 (ref), TweenService (ref), u46 (copy), u42 (copy), u43 (copy), u44 (copy), u37 (copy), _speedFov (copy), u39 (copy)
        u47 = u47 + p48;
        local v49 = TweenService:GetValue(math.clamp(u47 / u46, 0, 1), u42, u43);

        if u44 then
            u37._speedFov = _speedFov + v49 * (u39 - _speedFov);
        else
            u37._speedFov = _speedFov - v49 * _speedFov;
        end;

        if v49 >= 1 then
            u37:_disconnectFovTween();
        end;
    end);
end;

function u3._beginRaiseFov(p50) -- Line: 260
    -- upvalues: u2 (copy)
    p50._fovState = "Max";
    p50:_tweenFovTo(p50._config.maxChangeFov or u2.maxChangeFov);
end;

function u3._beginLowerFov(p51) -- Line: 265
    p51._fovState = "Min";
    p51:_tweenFovTo(0);
end;

function u3._tickStateMachine(p52) -- Line: 270
    -- upvalues: u2 (copy)
    local _config = p52._config;
    local v53 = time();
    local _currentSpeed = p52._currentSpeed;
    local v54 = _config.speedEnterSpeed or u2.speedEnterSpeed;
    local v55 = _config.speedExitSpeed or u2.speedExitSpeed;
    local v56 = _config.sprintMinHold or u2.sprintMinHold;
    local v57 = _config.sprintResumeDelay or u2.sprintResumeDelay;

    if p52._fovState == "Max" then
        if v55 <= _currentSpeed then
            p52._resumeAfterClock = nil;
        elseif v56 <= v53 - (p52._sprintEnteredClock or v53) and p52._resumeAfterClock == nil then
            p52._resumeAfterClock = v53 + v57;
        end;

        if p52._resumeAfterClock ~= nil and p52._resumeAfterClock <= v53 then
            p52:_beginLowerFov();
            p52._sprintEnteredClock = nil;
            p52._resumeAfterClock = nil;
        end;
    elseif p52._fovState == "Min" then
        p52._resumeAfterClock = nil;

        if v54 < _currentSpeed then
            p52._sprintEnteredClock = v53;
            p52:_beginRaiseFov();
        end;
    end;
end;

function u3._tickDrive(p58, p59) -- Line: 303
    -- upvalues: u2 (copy)
    local v60 = p58._config.fovDriveMode or u2.fovDriveMode;

    if v60 == "binary" then
        p58:_tickStateMachine();

        return;
    end;

    if v60 == "proportional" then
        p58:_tickProportional(p59);

        return;
    end;

    p58:_tickUniform();
end;

function u3.Enable(u61) -- Line: 314
    -- upvalues: u2 (copy), u1 (copy)
    if u61._active then
        return;
    end;

    local _config = u61._config;
    local _cameraModule = u61._cameraModule;

    if _config.suppressGroundSpeedFov ~= false then
        _cameraModule.DisableCameraEvent_Helper(_config.groundHelperEventName or u2.groundHelperEventName);
        u61._suppressedGroundHelper = true;
    end;

    _cameraModule.EnableCameraEvent_Helper(_config.helperEventName or u2.helperEventName, function(p62, p63) -- Line: 329
        -- upvalues: u61 (copy), u1 (ref)
        u61:_tickDrive(p63);

        return u1, u61._speedFov;
    end);
    u61._active = true;
    u61._fovState = "Min";
    u61._speedFov = 0;
    u61._sprintEnteredClock = nil;
    u61._resumeAfterClock = nil;
end;

function u3.Disable(p64) -- Line: 341
    -- upvalues: u2 (copy)
    if not p64._active then
        return;
    end;

    local _config = p64._config;
    local _cameraModule = p64._cameraModule;
    local v65 = _config.helperEventName or u2.helperEventName;
    p64:_disconnectFovTween();
    _cameraModule.DisableCameraEvent_Helper(v65);

    if p64._suppressedGroundHelper then
        local v66 = _config.groundHelperEventName or u2.groundHelperEventName;

        if _cameraModule.RestoreCameraEvent_Helper then
            _cameraModule.RestoreCameraEvent_Helper(v66);
        end;

        p64._suppressedGroundHelper = false;
    end;

    p64._active = false;
    p64._currentSpeed = 0;
    p64._runtimeSpeedCap = nil;
    p64._speedFov = 0;
    p64._fovState = "Min";
    p64._sprintEnteredClock = nil;
    p64._resumeAfterClock = nil;
end;

return u3;