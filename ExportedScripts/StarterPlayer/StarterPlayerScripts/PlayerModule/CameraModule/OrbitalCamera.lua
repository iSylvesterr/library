-- Decompiled with Potassium's decompiler.

local CameraUtils = require(script.Parent:WaitForChild("CameraUtils"));
local CameraInput = require(script.Parent:WaitForChild("CameraInput"));
local Players = game:GetService("Players");
local BaseCamera = require(script.Parent:WaitForChild("BaseCamera"));
local u1 = setmetatable({}, BaseCamera);
u1.__index = u1;

function u1.new() -- Line: 42
    -- upvalues: BaseCamera (copy), u1 (copy)
    local v2 = BaseCamera.new();
    local v3 = setmetatable(v2, u1);
    v3.lastUpdate = tick();
    v3.changedSignalConnections = {};
    v3.refAzimuthRad = nil;
    v3.curAzimuthRad = nil;
    v3.minAzimuthAbsoluteRad = nil;
    v3.maxAzimuthAbsoluteRad = nil;
    v3.useAzimuthLimits = nil;
    v3.curElevationRad = nil;
    v3.minElevationRad = nil;
    v3.maxElevationRad = nil;
    v3.curDistance = nil;
    v3.minDistance = nil;
    v3.maxDistance = nil;
    v3.gamepadDollySpeedMultiplier = 1;
    v3.lastUserPanCamera = tick();
    v3.externalProperties = {};
    v3.externalProperties.InitialDistance = 25;
    v3.externalProperties.MinDistance = 10;
    v3.externalProperties.MaxDistance = 100;
    v3.externalProperties.InitialElevation = 35;
    v3.externalProperties.MinElevation = 35;
    v3.externalProperties.MaxElevation = 35;
    v3.externalProperties.ReferenceAzimuth = -45;
    v3.externalProperties.CWAzimuthTravel = 90;
    v3.externalProperties.CCWAzimuthTravel = 90;
    v3.externalProperties.UseAzimuthLimits = false;
    v3:LoadNumberValueParameters();

    return v3;
end;

function u1.LoadOrCreateNumberValueParameter(u4, u5, p6, u7) -- Line: 81
    local v8 = script:FindFirstChild(u5);

    if v8 and v8:IsA(p6) then
        u4.externalProperties[u5] = v8.Value;
    else
        if u4.externalProperties[u5] == nil then
            return;
        end;

        v8 = Instance.new(p6);
        v8.Name = u5;
        v8.Parent = script;
        v8.Value = u4.externalProperties[u5];
    end;

    if u7 then
        if u4.changedSignalConnections[u5] then
            u4.changedSignalConnections[u5]:Disconnect();
        end;

        u4.changedSignalConnections[u5] = v8.Changed:Connect(function(p9) -- Line: 101
            -- upvalues: u4 (copy), u5 (copy), u7 (copy)
            u4.externalProperties[u5] = p9;
            u7(u4);
        end);
    end;
end;

function u1.SetAndBoundsCheckAzimuthValues(p10) -- Line: 108
    local v11 = math.rad(p10.externalProperties.ReferenceAzimuth);
    local v12 = math.rad(p10.externalProperties.CWAzimuthTravel);
    p10.minAzimuthAbsoluteRad = v11 - math.abs(v12);
    local v13 = math.rad(p10.externalProperties.ReferenceAzimuth);
    local v14 = math.rad(p10.externalProperties.CCWAzimuthTravel);
    p10.maxAzimuthAbsoluteRad = v13 + math.abs(v14);
    p10.useAzimuthLimits = p10.externalProperties.UseAzimuthLimits;

    if p10.useAzimuthLimits then
        p10.curAzimuthRad = math.max(p10.curAzimuthRad, p10.minAzimuthAbsoluteRad);
        p10.curAzimuthRad = math.min(p10.curAzimuthRad, p10.maxAzimuthAbsoluteRad);
    end;
end;

function u1.SetAndBoundsCheckElevationValues(p15) -- Line: 118
    local v16 = math.max(p15.externalProperties.MinElevation, -80);
    local v17 = math.min(p15.externalProperties.MaxElevation, 80);
    local v18 = math.min(v16, v17);
    p15.minElevationRad = math.rad(v18);
    local v19 = math.max(v16, v17);
    p15.maxElevationRad = math.rad(v19);
    p15.curElevationRad = math.max(p15.curElevationRad, p15.minElevationRad);
    p15.curElevationRad = math.min(p15.curElevationRad, p15.maxElevationRad);
end;

function u1.SetAndBoundsCheckDistanceValues(p20) -- Line: 134
    p20.minDistance = p20.externalProperties.MinDistance;
    p20.maxDistance = p20.externalProperties.MaxDistance;
    p20.curDistance = math.max(p20.curDistance, p20.minDistance);
    p20.curDistance = math.min(p20.curDistance, p20.maxDistance);
end;

function u1.LoadNumberValueParameters(p21) -- Line: 142
    p21:LoadOrCreateNumberValueParameter("InitialElevation", "NumberValue", nil);
    p21:LoadOrCreateNumberValueParameter("InitialDistance", "NumberValue", nil);
    p21:LoadOrCreateNumberValueParameter("ReferenceAzimuth", "NumberValue", p21.SetAndBoundsCheckAzimuthValue);
    p21:LoadOrCreateNumberValueParameter("CWAzimuthTravel", "NumberValue", p21.SetAndBoundsCheckAzimuthValues);
    p21:LoadOrCreateNumberValueParameter("CCWAzimuthTravel", "NumberValue", p21.SetAndBoundsCheckAzimuthValues);
    p21:LoadOrCreateNumberValueParameter("MinElevation", "NumberValue", p21.SetAndBoundsCheckElevationValues);
    p21:LoadOrCreateNumberValueParameter("MaxElevation", "NumberValue", p21.SetAndBoundsCheckElevationValues);
    p21:LoadOrCreateNumberValueParameter("MinDistance", "NumberValue", p21.SetAndBoundsCheckDistanceValues);
    p21:LoadOrCreateNumberValueParameter("MaxDistance", "NumberValue", p21.SetAndBoundsCheckDistanceValues);
    p21:LoadOrCreateNumberValueParameter("UseAzimuthLimits", "BoolValue", p21.SetAndBoundsCheckAzimuthValues);
    p21.curAzimuthRad = math.rad(p21.externalProperties.ReferenceAzimuth);
    p21.curElevationRad = math.rad(p21.externalProperties.InitialElevation);
    p21.curDistance = p21.externalProperties.InitialDistance;
    p21:SetAndBoundsCheckAzimuthValues();
    p21:SetAndBoundsCheckElevationValues();
    p21:SetAndBoundsCheckDistanceValues();
end;

function u1.GetModuleName(p22) -- Line: 167
    return "OrbitalCamera";
end;

function u1.SetInitialOrientation(p23, p24) -- Line: 171
    -- upvalues: CameraUtils (copy)
    if not (p24 and p24.RootPart) then
        warn("OrbitalCamera could not set initial orientation due to missing humanoid");

        return;
    end;

    assert(p24.RootPart, "");
    local Unit = (p24.RootPart.CFrame.LookVector - Vector3.new(0, 0.23, 0)).Unit;
    local v25 = CameraUtils.GetAngleBetweenXZVectors(Unit, p23:GetCameraLookVector());
    local Y = p23:GetCameraLookVector().Y;
    local v26 = math.asin(Y) - math.asin(Unit.Y);
    CameraUtils.IsFinite(v25);
    CameraUtils.IsFinite(v26);
end;

function u1.GetCameraToSubjectDistance(p27) -- Line: 189
    return p27.curDistance;
end;

function u1.SetCameraToSubjectDistance(p28, p29) -- Line: 193
    -- upvalues: Players (copy)
    if Players.LocalPlayer then
        p28.currentSubjectDistance = math.clamp(p29, p28.minDistance, p28.maxDistance);
        p28.currentSubjectDistance = math.max(p28.currentSubjectDistance, p28.FIRST_PERSON_DISTANCE_THRESHOLD);
    end;

    p28.inFirstPerson = false;
    p28:UpdateMouseBehavior();

    return p28.currentSubjectDistance;
end;

function u1.CalculateNewLookVector(p30, p31, p32) -- Line: 206
    local v33 = p31 or p30:GetCameraLookVector();
    local v34 = math.asin(v33.Y);
    local v35 = math.clamp(p32.Y, v34 - 1.3962634015954636, v34 - -1.3962634015954636);
    local v36 = Vector2.new(p32.X, v35);
    local v37 = CFrame.new(Vector3.new(0, 0, 0), v33);

    return (CFrame.Angles(0, -v36.X, 0) * v37 * CFrame.Angles(-v36.Y, 0, 0)).LookVector;
end;

function u1.Update(p38, p39) -- Line: 217
    -- upvalues: CameraInput (copy), Players (copy)
    local v40 = tick();
    local v41 = v40 - p38.lastUpdate;
    local v42 = CameraInput.getRotation(p39) ~= Vector2.new();
    local CurrentCamera = workspace.CurrentCamera;
    local CFrame2 = CurrentCamera.CFrame;
    local Focus = CurrentCamera.Focus;
    local LocalPlayer = Players.LocalPlayer;
    local v43;

    if CurrentCamera then
        v43 = CurrentCamera.CameraSubject;
    else
        v43 = CurrentCamera;
    end;

    local v44;

    if v43 then
        v44 = v43:IsA("VehicleSeat");
    else
        v44 = v43;
    end;

    local v45;

    if v43 then
        v45 = v43:IsA("SkateboardPlatform");
    else
        v45 = v43;
    end;

    if p38.lastUpdate == nil or v41 > 1 then
        p38.lastCameraTransform = nil;
    end;

    if v42 then
        p38.lastUserPanCamera = tick();
    end;

    local v46 = p38:GetSubjectPosition();

    if v46 and (LocalPlayer and CurrentCamera) then
        if p38.gamepadDollySpeedMultiplier ~= 1 then
            p38:SetCameraToSubjectDistance(p38.currentSubjectDistance * p38.gamepadDollySpeedMultiplier);
        end;

        Focus = CFrame.new(v46);
        local v47 = CameraInput.getRotation(p39);
        p38.curAzimuthRad = p38.curAzimuthRad - v47.X;

        if p38.useAzimuthLimits then
            p38.curAzimuthRad = math.clamp(p38.curAzimuthRad, p38.minAzimuthAbsoluteRad, p38.maxAzimuthAbsoluteRad);
        else
            p38.curAzimuthRad = p38.curAzimuthRad == 0 and 0 or (math.sign(p38.curAzimuthRad) * (math.abs(p38.curAzimuthRad) % 6.283185307179586) or 0);
        end;

        p38.curElevationRad = math.clamp(p38.curElevationRad + v47.Y, p38.minElevationRad, p38.maxElevationRad);
        local v48 = v46 + p38.currentSubjectDistance * (CFrame.fromEulerAnglesYXZ(-p38.curElevationRad, p38.curAzimuthRad, 0) * Vector3.new(0, 0, 1));
        CFrame2 = CFrame.new(v48, v46);
        p38.lastCameraTransform = CFrame2;
        p38.lastCameraFocus = Focus;

        if (v44 or v45) and v43:IsA("BasePart") then
            p38.lastSubjectCFrame = v43.CFrame;
        else
            p38.lastSubjectCFrame = nil;
        end;
    end;

    p38.lastUpdate = v40;

    return CFrame2, Focus;
end;

return u1;