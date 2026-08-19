-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local profilebegin = debug.profilebegin;
local profileend = debug.profileend;
local RunServiceController = require(game:GetService("ReplicatedStorage").Controllers.RunServiceController);
local new = CFrame.new;
local Angles = CFrame.Angles;
local rad = math.rad;
local u2 = Vector3.new();
local CameraShakeInstance = require(script.CameraShakeInstance);
local CameraShakeState = CameraShakeInstance.CameraShakeState;
u1.CameraShakeInstance = CameraShakeInstance;
u1.Presets = require(script.CameraShakePresets);

function u1.new(p3, p4) -- Line: 88
    -- upvalues: u2 (copy), u1 (copy)
    local v5 = type(p3) == "number";
    assert(v5, "RenderPriority must be a number (e.g.: Enum.RenderPriority.Camera.Value)");
    local v6 = type(p4) == "function";
    assert(v6, "Callback must be a function");

    return setmetatable({
        _running = false,
        _renderName = "CameraShaker",
        _renderPriority = p3,
        _posAddShake = u2,
        _rotAddShake = u2,
        _camShakeInstances = {},
        _removeInstances = {},
        _callback = p4
    }, u1);
end;

function u1.Start(u7) -- Line: 109
    -- upvalues: RunServiceController (copy), profilebegin (copy), profileend (copy)
    if u7._running then
        return;
    end;

    u7._running = true;
    local _callback = u7._callback;
    RunServiceController.BindToRenderStep(u7._renderName, u7._renderPriority, function(p8) -- Line: 113
        -- upvalues: profilebegin (ref), u7 (copy), profileend (ref), _callback (copy)
        profilebegin("CameraShakerUpdate");
        local v9 = u7:Update(p8);
        profileend();
        _callback(v9);
    end);
end;

function u1.Stop(p10) -- Line: 122
    -- upvalues: RunServiceController (copy)
    if not p10._running then
        return;
    end;

    RunServiceController.UnbindFromRenderStep(p10._renderName);
    p10._running = false;
end;

function u1.StopSustained(p11, p12) -- Line: 129
    for _, v in pairs(p11._camShakeInstances) do
        if v.fadeOutDuration == 0 then
            v:StartFadeOut(p12 or v.fadeInDuration);
        end;
    end;
end;

function u1.Update(p13, p14) -- Line: 138
    -- upvalues: u2 (copy), CameraShakeState (copy), new (copy), Angles (copy), rad (copy)
    local v15 = u2;
    local v16 = u2;
    local _camShakeInstances = p13._camShakeInstances;

    for i = 1, #_camShakeInstances do
        local v17 = _camShakeInstances[i];
        local v18 = v17:GetState();

        if v18 == CameraShakeState.Inactive and v17.DeleteOnInactive then
            p13._removeInstances[#p13._removeInstances + 1] = i;
        elseif v18 ~= CameraShakeState.Inactive then
            local v19 = v17:UpdateShake(p14);
            v15 = v15 + v19 * v17.PositionInfluence;
            v16 = v16 + v19 * v17.RotationInfluence;
        end;
    end;

    for i = #p13._removeInstances, 1, -1 do
        table.remove(_camShakeInstances, p13._removeInstances[i]);
        p13._removeInstances[i] = nil;
    end;

    return new(v15) * Angles(0, rad(v16.Y), 0) * Angles(rad(v16.X), 0, (rad(v16.Z)));
end;

function u1.Shake(p20, p21) -- Line: 175
    local v22;

    if type(p21) == "table" then
        v22 = p21._camShakeInstance;
    else
        v22 = false;
    end;

    assert(v22, "ShakeInstance must be of type CameraShakeInstance");
    p20._camShakeInstances[#p20._camShakeInstances + 1] = p21;

    return p21;
end;

function u1.ShakeSustain(p23, p24) -- Line: 182
    local v25;

    if type(p24) == "table" then
        v25 = p24._camShakeInstance;
    else
        v25 = false;
    end;

    assert(v25, "ShakeInstance must be of type CameraShakeInstance");
    p23._camShakeInstances[#p23._camShakeInstances + 1] = p24;
    p24:StartFadeIn(p24.fadeInDuration);

    return p24;
end;

function u1.ShakeOnce(p26, p27, p28, p29, p30, p31, p32) -- Line: 190
    -- upvalues: CameraShakeInstance (copy)
    local v33 = CameraShakeInstance.new(p27, p28, p29, p30);
    v33.PositionInfluence = typeof(p31) == "Vector3" and p31 and p31 or Vector3.new(0.15, 0.15, 0.15);
    v33.RotationInfluence = typeof(p32) == "Vector3" and p32 and p32 or Vector3.new(1, 1, 1);
    p26._camShakeInstances[#p26._camShakeInstances + 1] = v33;

    return v33;
end;

function u1.StartShake(p34, p35, p36, p37, p38, p39) -- Line: 199
    -- upvalues: CameraShakeInstance (copy)
    local v40 = CameraShakeInstance.new(p35, p36, p37);
    v40.PositionInfluence = typeof(p38) == "Vector3" and p38 and p38 or Vector3.new(0.15, 0.15, 0.15);
    v40.RotationInfluence = typeof(p39) == "Vector3" and p39 and p39 or Vector3.new(1, 1, 1);
    v40:StartFadeIn(p37);
    p34._camShakeInstances[#p34._camShakeInstances + 1] = v40;

    return v40;
end;

return u1;