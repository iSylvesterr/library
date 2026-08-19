-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local u1 = {
    eventName = "扫帚飞行_滚转倾斜",
    tiltScale = 1.5,
    maxTiltRadians = 0.08726646259971647,
    enabled = true,
    smoothFactor = 4,
    returnSmoothFactor = 5,
    targetScale = 1.5707963267948966,
    renderPriority = Enum.RenderPriority.Last.Value
};
local u2 = {};
u2.__index = u2;

local function mergeConfig(p3, p4) -- Line: 133
    if not p4 then
        return table.clone(p3);
    end;

    local v5 = table.clone(p3);

    for i, v in pairs(p4) do
        v5[i] = v;
    end;

    return v5;
end;

local function getRenderStepName(p6) -- Line: 144
    -- upvalues: u1 (copy)
    return p6.eventName or u1.eventName;
end;

function u2.new(p7, p8) -- Line: 152
    -- upvalues: u1 (copy), u2 (copy)
    local v9 = {
        _rollAngle = 0,
        _active = false,
        _cameraModule = p7
    };
    local v10 = u1;
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

    return setmetatable(v9, u2);
end;

function u2.GetRollAngle(p12) -- Line: 162
    return p12._rollAngle;
end;

function u2.GetConfig(p13) -- Line: 166
    return table.clone(p13._config);
end;

function u2.SetConfig(p14, p15) -- Line: 170
    local _config = p14._config;
    local v16;

    if p15 then
        v16 = table.clone(_config);

        for i, v in pairs(p15) do
            v16[i] = v;
        end;
    else
        v16 = table.clone(_config);
    end;

    p14._config = v16;
end;

function u2.SetRollAngle(p17, p18) -- Line: 174
    p17._rollAngle = p18;
end;

function u2.ComputeRollTarget(p19, p20, p21, p22) -- Line: 186
    -- upvalues: u1 (copy)
    local v23 = p19._config.targetScale or u1.targetScale;

    return (p20:Dot(p21) * 0.4 + -(p22 or 0)) * v23;
end;

function u2.StepRoll(p24, p25, p26) -- Line: 202
    -- upvalues: u1 (copy)
    local _config = p24._config;
    local v27 = _config.smoothFactor or u1.smoothFactor;
    local v28 = _config.returnSmoothFactor or v27;

    if math.abs(p26) >= math.abs(p24._rollAngle) then
        v28 = v27;
    end;

    local v29 = math.min(p25 * v28, 1);
    p24._rollAngle = p24._rollAngle + (p26 - p24._rollAngle) * v29;
end;

function u2.ComputeTiltOffset(p30, p31) -- Line: 211
    -- upvalues: u1 (copy)
    local _config = p30._config;

    if p31 == nil then
        p31 = p30._rollAngle;
    end;

    local v32 = p31 * (_config.tiltScale or u1.tiltScale);
    local maxTiltRadians = _config.maxTiltRadians;

    if maxTiltRadians ~= nil then
        v32 = math.clamp(v32, -maxTiltRadians, maxTiltRadians);
    end;

    return CFrame.Angles(0, 0, v32);
end;

function u2._applyTilt(p33) -- Line: 227
    local v34 = p33._cameraModule and p33._cameraModule.Camera or workspace.CurrentCamera;

    if not v34 then
        return;
    end;

    v34.CFrame = v34.CFrame * p33:ComputeTiltOffset();
end;

function u2.IsActive(p35) -- Line: 235
    return p35._active;
end;

function u2.Enable(u36) -- Line: 239
    -- upvalues: u1 (copy), RunService (copy)
    if u36._active then
        return;
    end;

    if u36._config.enabled == false then
        return;
    end;

    RunService:BindToRenderStep(u36._config.eventName or u1.eventName, u36._config.renderPriority or u1.renderPriority, function() -- Line: 250
        -- upvalues: u36 (copy)
        u36:_applyTilt();
    end);
    u36._active = true;
end;

function u2.Disable(p37) -- Line: 256
    -- upvalues: u1 (copy), RunService (copy)
    if not p37._active then
        return;
    end;

    local v38 = p37._config.eventName or u1.eventName;
    RunService:UnbindFromRenderStep(v38);

    if p37._cameraModule and p37._cameraModule.DisableCameraEvent_Helper then
        p37._cameraModule.DisableCameraEvent_Helper(v38);
    end;

    p37._active = false;
    p37._rollAngle = 0;
end;

return u2;