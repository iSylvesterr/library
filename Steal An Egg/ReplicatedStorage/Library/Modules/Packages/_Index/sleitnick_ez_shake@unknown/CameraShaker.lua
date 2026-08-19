-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local CameraShakeInstance = require(script.CameraShakeInstance);
local CameraShakePresets = require(script.CameraShakePresets);
local Variables = require(ReplicatedStorage.Library.Variables);
local profilebegin = debug.profilebegin;
local profileend = debug.profileend;
local u1 = 0;
local new = CFrame.new;
local Angles = CFrame.Angles;
local rad = math.rad;
local u2 = Vector3.new();
local CameraShakeState = CameraShakeInstance.CameraShakeState;
local Value = Enum.RenderPriority.Last.Value;
local CurrentCamera = workspace.CurrentCamera;
local u3 = {};
u3.__index = u3;
u3.CameraShakeInstance = CameraShakeInstance;
u3.Presets = CameraShakePresets;

local function defaultCallback(p4) -- Line: 86
    -- upvalues: CurrentCamera (copy)
    local v5 = CurrentCamera;
    v5.CFrame = v5.CFrame * p4;
end;

function u3.new(p6, p7, p8) -- Line: 122
    -- upvalues: Asserts (copy), u3 (copy), Value (copy), u2 (copy), defaultCallback (copy)
    Asserts.optional.number(p6);
    Asserts.optional.func(p7);
    local v9 = {
        _running = false,
        _driftConn = nil,
        _renderName = u3.NextRenderName(),
        _renderPriority = p6 or Value,
        _posAddShake = u2,
        _rotAddShake = u2,
        _camShakeInstances = {},
        _removeInstances = {},
        _callback = p7 or defaultCallback,
        _optimizeDrift = p8 or false,
        _renderBindings = {},
        _renderDriftConnections = {}
    };

    return setmetatable(v9, u3);
end;

function u3.NextRenderName() -- Line: 154
    -- upvalues: u1 (ref)
    u1 = u1 + 1;

    return ("__shake_%.4i__"):format(u1);
end;

function u3.Start(u10, p11) -- Line: 159
    -- upvalues: Asserts (copy), RunService (copy), CurrentCamera (copy), profilebegin (copy), profileend (copy)
    if u10._running then
        return;
    end;

    Asserts.optional.string(p11);
    u10._running = true;
    local v12 = p11 or u10._renderName;
    local _callback = u10._callback;
    local u13 = nil;
    RunService:BindToRenderStep(v12, u10._renderPriority, function(p14) -- Line: 171
        -- upvalues: u13 (ref), CurrentCamera (ref), profilebegin (ref), u10 (copy), profileend (ref), _callback (copy)
        u13 = CurrentCamera.CFrame;
        profilebegin("CameraShakerUpdate");
        local v15 = u10:Update(p14);
        profileend();
        _callback(v15);
    end);
    u10._renderBindings[v12] = true;

    if not u10._optimizeDrift then
        return;
    end;

    u10._renderDriftConnections[v12] = RunService.Heartbeat:Connect(function() -- Line: 187
        -- upvalues: u13 (ref), CurrentCamera (ref)
        if not u13 then
            return;
        end;

        CurrentCamera.CFrame = u13;
    end);
end;

function u3.StopByRenderName(p16, p17) -- Line: 195
    -- upvalues: Asserts (copy), RunService (copy)
    Asserts.string(p17);
    local v18 = p16._renderBindings[p17];
    local v19 = `Attempt to remove an unBinded render name: "{p17}"`;
    assert(v18, v19);
    local v20 = p16._renderDriftConnections[p17];

    if v20 then
        v20:Disconnect();
        p16._renderDriftConnections[p17] = nil;
    end;

    p16._renderBindings[p17] = nil;
    RunService:UnbindFromRenderStep(p17);
end;

function u3.Stop(p21) -- Line: 209
    if not p21._running then
        return;
    end;

    p21._running = false;

    for i in p21._renderBindings do
        p21:StopByRenderName(i);
    end;
end;

function u3.StopSustained(p22, p23) -- Line: 220
    for _, v in pairs(p22._camShakeInstances) do
        if v.fadeOutDuration == 0 then
            v:StartFadeOut(p23 or v.fadeInDuration);
        end;
    end;
end;

function u3.Update(p24, p25) -- Line: 228
    -- upvalues: u2 (copy), CameraShakeState (copy), Variables (copy), new (copy), Angles (copy), rad (copy)
    local v26 = u2;
    local v27 = u2;
    local _camShakeInstances = p24._camShakeInstances;

    for i = 1, #_camShakeInstances do
        local v28 = _camShakeInstances[i];
        local v29 = v28:GetState();

        if v29 == CameraShakeState.Inactive and v28.DeleteOnInactive then
            p24._removeInstances[#p24._removeInstances + 1] = i;
        elseif v29 ~= CameraShakeState.Inactive then
            local v30 = v28:UpdateShake(p25);
            v26 = v26 + v30 * v28.PositionInfluence;
            v27 = v27 + v30 * v28.RotationInfluence;
        end;
    end;

    for i = #p24._removeInstances, 1, -1 do
        table.remove(_camShakeInstances, p24._removeInstances[i]);
        p24._removeInstances[i] = nil;
    end;

    if Variables.IsInteractingWithNpc then
        v26 = u2;
        v27 = u2;
    end;

    return new(v26) * Angles(0, rad(v27.Y), 0) * Angles(rad(v27.X), 0, (rad(v27.Z)));
end;

function u3.Shake(p31, p32) -- Line: 263
    local v33;

    if type(p32) == "table" then
        v33 = p32._camShakeInstance;
    else
        v33 = false;
    end;

    assert(v33, "ShakeInstance must be of type CameraShakeInstance");
    p31._camShakeInstances[#p31._camShakeInstances + 1] = p32;

    return p32;
end;

function u3.ShakeFromPresetName(p34, p35) -- Line: 274
    -- upvalues: Asserts (copy), CameraShakePresets (copy)
    Asserts.string(p35);

    return p34:Shake(CameraShakePresets[p35]);
end;

function u3.ShakeSustain(p36, p37) -- Line: 284
    local v38;

    if type(p37) == "table" then
        v38 = p37._camShakeInstance;
    else
        v38 = false;
    end;

    assert(v38, "ShakeInstance must be of type CameraShakeInstance");
    p36._camShakeInstances[#p36._camShakeInstances + 1] = p37;
    p37:StartFadeIn(p37.fadeInDuration);

    return p37;
end;

function u3.ShakeOnce(p39, p40, p41, p42, p43, p44, p45) -- Line: 296
    -- upvalues: CameraShakeInstance (copy)
    local v46 = CameraShakeInstance.new(p40, p41, p42, p43);
    v46.PositionInfluence = typeof(p44) == "Vector3" and p44 and p44 or Vector3.new(0.15, 0.15, 0.15);
    v46.RotationInfluence = typeof(p45) == "Vector3" and p45 and p45 or Vector3.new(1, 1, 1);
    p39._camShakeInstances[#p39._camShakeInstances + 1] = v46;

    return v46;
end;

function u3.StartShake(p47, p48, p49, p50, p51, p52) -- Line: 314
    -- upvalues: CameraShakeInstance (copy)
    local v53 = CameraShakeInstance.new(p48, p49, p50);
    v53.PositionInfluence = typeof(p51) == "Vector3" and p51 and p51 or Vector3.new(0.15, 0.15, 0.15);
    v53.RotationInfluence = typeof(p52) == "Vector3" and p52 and p52 or Vector3.new(1, 1, 1);
    v53:StartFadeIn(p50);
    p47._camShakeInstances[#p47._camShakeInstances + 1] = v53;

    return v53;
end;

return u3;