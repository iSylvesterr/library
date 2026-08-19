-- Decompiled with Potassium's decompiler.

local u1 = {
    turnSpeedDeg = 540,
    alignLerpRate = 1,
    strafeYawMax = 1.0471975511965976,
    maxBodyRollRadians = 1.0471975511965976,
    responsiveness = 200,
    maxTorque = 500000,
    bodyOrientationOffset = CFrame.new(),
    takeoffCameraOffset = CFrame.new(1.5707963267948966, 0, 0)
};
local u2 = {};
u2.__index = u2;
local u3 = CFrame.new();

local function mergeConfig(p4, p5) -- Line: 129
    if not p5 then
        return table.clone(p4);
    end;

    local v6 = table.clone(p4);

    for i, v in pairs(p5) do
        v6[i] = v;
    end;

    return v6;
end;

local function getBodyOrientationOffset(p7) -- Line: 140
    -- upvalues: u1 (copy), u3 (copy)
    return p7.bodyOrientationOffset or (u1.bodyOrientationOffset or u3);
end;

local function cameraBasisWithoutRoll(p8) -- Line: 151
    local LookVector = p8.LookVector;

    if LookVector:Dot(LookVector) < 1e-8 then
        return p8;
    end;

    return CFrame.lookAt(p8.Position, p8.Position + LookVector, Vector3.new(0, 1, 0));
end;

local function resolveBodyTargetFromCamera(p9, p10, p11, p12) -- Line: 165
    -- upvalues: u1 (copy), u3 (copy)
    local v13 = p9.strafeYawMax or u1.strafeYawMax;
    local v14 = p12 or p9.bodyOrientationOffset or (u1.bodyOrientationOffset or u3);
    local LookVector = p10.LookVector;

    if LookVector:Dot(LookVector) >= 1e-8 then
        p10 = CFrame.lookAt(p10.Position, p10.Position + LookVector, Vector3.new(0, 1, 0));
    end;

    local v15 = -p11 * v13;

    if math.abs(v15) > 1e-6 then
        local Position = p10.Position;
        local v16 = CFrame.Angles(0, v15, 0):VectorToWorldSpace(p10.LookVector);

        if v16:Dot(v16) > 1e-8 then
            p10 = CFrame.lookAt(Position, Position + v16, Vector3.new(0, 1, 0));
        end;
    end;

    return p10:ToWorldSpace(v14);
end;

local function rotateTowardsOrientation(p17, p18, p19) -- Line: 189
    local v20 = p17 - p17.Position;
    local v21 = p18 - p18.Position;
    local v22, v23 = v20:ToObjectSpace(v21):ToAxisAngle();

    if v23 < 1e-6 then
        return CFrame.new(p17.Position) * v21;
    end;

    if v22.Magnitude < 1e-6 then
        return CFrame.new(p17.Position) * v21;
    end;

    local v24 = math.min(v23, p19);

    return CFrame.new(p17.Position) * (v20 * CFrame.fromAxisAngle(v22.Unit, v24));
end;

function u2.new(p25, p26) -- Line: 207
    -- upvalues: u1 (copy), u2 (copy)
    local v27 = {
        _alignOrientation = nil,
        _rootPart = nil
    };
    local v28 = u1;
    local v29;

    if p26 then
        v29 = table.clone(v28);

        for i, v in pairs(p26) do
            v29[i] = v;
        end;
    else
        v29 = table.clone(v28);
    end;

    v27._config = v29;

    return setmetatable(v27, u2);
end;

function u2.GetConfig(p30) -- Line: 216
    return table.clone(p30._config);
end;

function u2.SetConfig(p31, p32) -- Line: 220
    local _config = p31._config;
    local v33;

    if p32 then
        v33 = table.clone(_config);

        for i, v in pairs(p32) do
            v33[i] = v;
        end;
    else
        v33 = table.clone(_config);
    end;

    p31._config = v33;
    local _alignOrientation = p31._alignOrientation;

    if _alignOrientation and _alignOrientation.Parent then
        local _config2 = p31._config;

        if _config2.responsiveness ~= nil then
            _alignOrientation.Responsiveness = _config2.responsiveness;
        end;

        if _config2.maxTorque ~= nil then
            _alignOrientation.MaxTorque = _config2.maxTorque;
        end;
    end;
end;

function u2.IsAttached(p34) -- Line: 234
    local _alignOrientation = p34._alignOrientation;
    local v35;

    if _alignOrientation == nil then
        v35 = false;
    else
        v35 = _alignOrientation.Parent ~= nil;
    end;

    return v35;
end;

function u2.GetAlignOrientation(p36) -- Line: 239
    return p36._alignOrientation;
end;

function u2.Attach(p37, p38) -- Line: 243
    -- upvalues: u1 (copy)
    p37:Detach();
    local RootAttachment = p38:FindFirstChild("RootAttachment");

    if not (RootAttachment and RootAttachment:IsA("Attachment")) then
        warn("[FlightCameraAlign] HumanoidRootPart 缺少 RootAttachment，无法创建 AlignOrientation");

        return nil;
    end;

    local _config = p37._config;
    local AlignOrientation = Instance.new("AlignOrientation");
    AlignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment;
    AlignOrientation.Attachment0 = RootAttachment;
    AlignOrientation.Responsiveness = _config.responsiveness or u1.responsiveness;
    AlignOrientation.MaxTorque = _config.maxTorque or u1.maxTorque;
    AlignOrientation.Parent = p38;
    p37._alignOrientation = AlignOrientation;
    p37._rootPart = p38;

    return AlignOrientation;
end;

function u2.Detach(p39) -- Line: 265
    local _alignOrientation = p39._alignOrientation;

    if _alignOrientation then
        _alignOrientation:Destroy();
    end;

    p39._alignOrientation = nil;
    p39._rootPart = nil;
end;

function u2.ApplyTakeoffOrientation(p40, p41) -- Line: 279
    local _alignOrientation = p40._alignOrientation;
    local _rootPart = p40._rootPart;

    if not (_alignOrientation and (_alignOrientation.Parent and _rootPart)) then
        return;
    end;

    _alignOrientation.CFrame = _rootPart.CFrame;
end;

local function resolveBodyTargetFromFlatLook(p42, p43, p44) -- Line: 293
    -- upvalues: u1 (copy), u3 (copy)
    local _rootPart = p42._rootPart;
    local v45 = not _rootPart and Vector3.new(0, 0, 0) or _rootPart.Position;
    local v46 = Vector3.new(p44.X, 0, p44.Z);
    local v47;

    if v46.Magnitude < 0.0001 then
        if _rootPart then
            v46 = Vector3.new(_rootPart.CFrame.LookVector.X, 0, _rootPart.CFrame.LookVector.Z);
        end;

        v47 = v46.Magnitude < 0.0001 and Vector3.new(0, 0, -1) or v46.Unit;
    else
        v47 = v46.Unit;
    end;

    return CFrame.lookAt(v45, v45 + v47, Vector3.new(0, 1, 0)) * (p43.bodyOrientationOffset or (u1.bodyOrientationOffset or u3));
end;

local function applyAlignTowardTarget(p48, p49, p50, p51) -- Line: 320
    -- upvalues: u1 (copy), rotateTowardsOrientation (copy)
    local _alignOrientation = p48._alignOrientation;

    if not (_alignOrientation and _alignOrientation.Parent) then
        return;
    end;

    local _config = p48._config;
    local v52 = _config.maxBodyRollRadians or u1.maxBodyRollRadians;
    local v53 = math.clamp(p51, -v52, v52);
    local v54 = p50 * CFrame.Angles(0, 0, v53);
    local turnSpeedDeg = _config.turnSpeedDeg;

    if not turnSpeedDeg or turnSpeedDeg <= 0 then
        _alignOrientation.CFrame = _alignOrientation.CFrame:Lerp(p50, p49 * (_config.alignLerpRate or u1.alignLerpRate)) * CFrame.Angles(0, 0, v53);

        return;
    end;

    local v55 = math.rad(turnSpeedDeg) * p49;
    _alignOrientation.CFrame = rotateTowardsOrientation(_alignOrientation.CFrame, v54, v55);
end;

function u2.ComputeTargetCFrame(p56, p57, p58, p59) -- Line: 344
    -- upvalues: u1 (copy), resolveBodyTargetFromCamera (copy)
    local _config = p56._config;
    local v60 = _config.maxBodyRollRadians or u1.maxBodyRollRadians;
    local v61 = math.clamp(p59, -v60, v60);

    return resolveBodyTargetFromCamera(_config, p57, p58) * CFrame.Angles(0, 0, v61);
end;

function u2.ComputeTargetCFrameFromDirection(p62, p63, p64) -- Line: 358
    -- upvalues: u1 (copy), resolveBodyTargetFromFlatLook (copy)
    local _config = p62._config;
    local v65 = _config.maxBodyRollRadians or u1.maxBodyRollRadians;
    local v66 = math.clamp(p64, -v65, v65);

    return resolveBodyTargetFromFlatLook(p62, _config, p63) * CFrame.Angles(0, 0, v66);
end;

function u2.Update(p67, p68, p69, p70, p71) -- Line: 368
    -- upvalues: resolveBodyTargetFromCamera (copy), applyAlignTowardTarget (copy)
    applyAlignTowardTarget(p67, p68, resolveBodyTargetFromCamera(p67._config, p69, p70), p71);
end;

function u2.UpdateTowardDirection(p72, p73, p74, p75) -- Line: 379
    -- upvalues: resolveBodyTargetFromFlatLook (copy), applyAlignTowardTarget (copy)
    applyAlignTowardTarget(p72, p73, resolveBodyTargetFromFlatLook(p72, p72._config, p74), p75);
end;

return u2;