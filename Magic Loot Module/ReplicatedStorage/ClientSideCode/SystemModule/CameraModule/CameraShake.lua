-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
local RunService = game:GetService("RunService");
local u1 = {};
u1.__index = u1;
local profilebegin = debug.profilebegin;
local profileend = debug.profileend;
local new = CFrame.new;
local Angles = CFrame.Angles;
local rad = math.rad;
local u2 = Vector3.new();
local CameraShakeInstance = require(script.CameraShakeInstance);
local CameraShakeState = CameraShakeInstance.CameraShakeState;
u1.CameraShakeInstance = CameraShakeInstance;
u1.Presets = require(script.CameraShakePresets);

function u1.new(p3, p4) -- Line: 73
    -- upvalues: u2 (copy), u1 (copy)
    local v5 = type(p3) == "number";
    assert(v5, "RenderPriority must be a number (e.g.: Enum.RenderPriority.Camera.Value)");
    local v6 = type(p4) == "function";
    assert(v6, "Callback must be a function");

    return setmetatable({
        _running = false,
        _renderName = "CameraShaker",
        _playTime = 1,
        _time = 0,
        _renderPriority = p3,
        _posAddShake = u2,
        _rotAddShake = u2,
        _camShakeInstances = {},
        _removeInstances = {},
        _callback = p4
    }, u1);
end;

function u1.newFixed(p7, p8) -- Line: 100
    -- upvalues: u2 (copy), u1 (copy)
    local v9 = type(p7) == "number";
    assert(v9, "RenderPriority must be a number (e.g.: Enum.RenderPriority.Camera.Value)");
    local v10 = type(p8) == "function";
    assert(v10, "Callback must be a function");
    local v11 = {
        _running = false,
        _playTime = 1,
        _time = 0
    };
    local v12 = tick() * 100;
    local v13 = math.ceil(v12);
    v11._renderName = "CameraShaker" .. tostring(v13);
    v11._renderPriority = p7;
    v11._posAddShake = u2;
    v11._rotAddShake = u2;
    v11._camShakeInstances = {};
    v11._removeInstances = {};
    v11._callback = p8;

    return setmetatable(v11, u1);
end;

function u1.StartRun(p14) -- Line: 123
    if p14._running then
        return;
    end;

    p14._running = true;
end;

function u1.StopRun(p15) -- Line: 131
    if not p15._running then
        return;
    end;

    p15._running = false;
end;

function u1.Start(u16) -- Line: 139
    -- upvalues: RunService (copy), profilebegin (copy), profileend (copy)
    if u16._running then
        return;
    end;

    u16._running = true;
    local _callback = u16._callback;
    RunService:BindToRenderStep(u16._renderName, u16._renderPriority, function(p17) -- Line: 143
        -- upvalues: profilebegin (ref), u16 (copy), profileend (ref), _callback (copy)
        profilebegin("CameraShakerUpdate");
        local v18 = u16:Update(p17);
        profileend();
        _callback(v18);
    end);
end;

function u1.StartFixed(u19) -- Line: 154
    -- upvalues: RunService (copy), profilebegin (copy), profileend (copy)
    if u19._running then
        return;
    end;

    u19._running = true;
    local _callback = u19._callback;
    RunService:BindToRenderStep(u19._renderName, u19._renderPriority, function(p20) -- Line: 158
        -- upvalues: profilebegin (ref), u19 (copy), profileend (ref), _callback (copy)
        profilebegin("CameraShakerUpdate");
        local v21 = u19;
        v21._time = v21._time + p20;
        local v22, v23 = u19:UpdateFixed(p20);
        profileend();
        _callback(v22);

        if v23 then
            u19:Stop();
        end;
    end);
end;

function u1.Stop(p24) -- Line: 173
    -- upvalues: RunService (copy)
    if not p24._running then
        return;
    end;

    RunService:UnbindFromRenderStep(p24._renderName);
    p24._running = false;
end;

function u1.StopSustained(p25, p26) -- Line: 185
    for _, v in pairs(p25._camShakeInstances) do
        if v.fadeOutDuration == 0 then
            v:StartFadeOut(p26 or v.fadeInDuration);
        end;
    end;
end;

function u1.Update(p27, p28) -- Line: 200
    -- upvalues: u2 (copy), CameraShakeState (copy), new (copy), Angles (copy), rad (copy)
    local v29 = u2;
    local v30 = u2;
    local _camShakeInstances = p27._camShakeInstances;

    for i = 1, #_camShakeInstances do
        local v31 = _camShakeInstances[i];
        local v32 = v31:GetState();

        if v32 == CameraShakeState.Inactive and v31.DeleteOnInactive then
            p27._removeInstances[#p27._removeInstances + 1] = i;
        elseif v32 ~= CameraShakeState.Inactive then
            local v33 = v31:UpdateShake(p28);
            v29 = v29 + v33 * v31.PositionInfluence;
            v30 = v30 + v33 * v31.RotationInfluence;
        end;
    end;

    for i = #p27._removeInstances, 1, -1 do
        table.remove(_camShakeInstances, p27._removeInstances[i]);
        p27._removeInstances[i] = nil;
    end;

    return new(v29) * Angles(0, rad(v30.Y), 0) * Angles(rad(v30.X), 0, (rad(v30.Z)));
end;

function u1.UpdateFixed(p34, p35) -- Line: 240
    -- upvalues: u2 (copy), CameraShakeState (copy), TweenService (copy), new (copy), Angles (copy), rad (copy)
    local v36 = u2;
    local v37 = u2;
    local _camShakeInstances = p34._camShakeInstances;
    local v38 = false;

    for i = 1, #_camShakeInstances do
        local v39 = _camShakeInstances[i];
        local v40 = v39:GetState();

        if v40 == CameraShakeState.Inactive and v39.DeleteOnInactive then
            p34._removeInstances[#p34._removeInstances + 1] = i;
        elseif v40 ~= CameraShakeState.Inactive then
            local v41 = v39.playTime or 1;
            v38 = v41 < p34._time and true or v38;
            local v42 = math.clamp(p34._time / v41, 0, 1);
            local v43 = math.clamp((p34._time - p35) / v41, 0, 1);
            v36 = (TweenService:GetValue(v42, v39.EasingStyle, v39.EasingDirection) - TweenService:GetValue(v43, v39.EasingStyle, v39.EasingDirection)) * v39.PositionInfluence;
            v37 = (TweenService:GetValue(v42, v39.EasingStyle, v39.EasingDirection) - TweenService:GetValue(v43, v39.EasingStyle, v39.EasingDirection)) * v39.RotationInfluence;
        end;
    end;

    for i = #p34._removeInstances, 1, -1 do
        table.remove(_camShakeInstances, p34._removeInstances[i]);
        p34._removeInstances[i] = nil;
    end;

    return new(v36) * Angles(0, rad(v37.Y), 0) * Angles(rad(v37.X), 0, (rad(v37.Z))), v38;
end;

function u1.Shake(p44, p45) -- Line: 291
    local v46;

    if type(p45) == "table" then
        v46 = p45._camShakeInstance;
    else
        v46 = false;
    end;

    assert(v46, "ShakeInstance must be of type CameraShakeInstance");
    p44._camShakeInstances[#p44._camShakeInstances + 1] = p45;

    return p45;
end;

function u1.ShakeSustain(p47, p48) -- Line: 304
    local v49;

    if type(p48) == "table" then
        v49 = p48._camShakeInstance;
    else
        v49 = false;
    end;

    assert(v49, "ShakeInstance must be of type CameraShakeInstance");
    p47._camShakeInstances[#p47._camShakeInstances + 1] = p48;
    p48:StartFadeIn(p48.fadeInDuration);

    return p48;
end;

function u1.ShakeOnce(p50, p51, p52, p53, p54, p55, p56) -- Line: 323
    -- upvalues: CameraShakeInstance (copy)
    local v57 = CameraShakeInstance.new(p51, p52, p53, p54);
    v57.PositionInfluence = typeof(p55) == "Vector3" and p55 and p55 or Vector3.new(0.15, 0.15, 0.15);
    v57.RotationInfluence = typeof(p56) == "Vector3" and p56 and p56 or Vector3.new(1, 1, 1);
    p50._camShakeInstances[#p50._camShakeInstances + 1] = v57;

    return v57;
end;

function u1.StartShake(p58, p59, p60, p61, p62, p63) -- Line: 341
    -- upvalues: CameraShakeInstance (copy)
    local v64 = CameraShakeInstance.new(p59, p60, p61);
    v64.PositionInfluence = typeof(p62) == "Vector3" and p62 and p62 or Vector3.new(0.15, 0.15, 0.15);
    v64.RotationInfluence = typeof(p63) == "Vector3" and p63 and p63 or Vector3.new(1, 1, 1);
    v64:StartFadeIn(p61);
    p58._camShakeInstances[#p58._camShakeInstances + 1] = v64;

    return v64;
end;

return u1;