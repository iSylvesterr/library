-- Decompiled with Potassium's decompiler.

Vector2.new(0, 0);
local u1 = 0;
local u2 = CFrame.fromOrientation(-0.2617993877991494, 0, 0);
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils");
local FlagUtil = require(CommonUtils:WaitForChild("FlagUtil"));
local u3 = FlagUtil.getUserFlag("UserCameraInputDt");
local u4 = FlagUtil.getUserFlag("UserFixCameraFPError");
local Players = game:GetService("Players");
local CameraInput = require(script.Parent:WaitForChild("CameraInput"));
local CameraUtils = require(script.Parent:WaitForChild("CameraUtils"));
local BaseCamera = require(script.Parent:WaitForChild("BaseCamera"));
local u5 = setmetatable({}, BaseCamera);
u5.__index = u5;

function u5.new() -- Line: 40
    -- upvalues: BaseCamera (copy), u5 (copy), CameraUtils (copy)
    local v6 = BaseCamera.new();
    local v7 = setmetatable(v6, u5);
    v7.isFollowCamera = false;
    v7.isCameraToggle = false;
    v7.lastUpdate = tick();
    v7.cameraToggleSpring = CameraUtils.Spring.new(5, 0);

    return v7;
end;

function u5.GetCameraToggleOffset(p8, p9) -- Line: 51
    -- upvalues: CameraInput (copy), CameraUtils (copy)
    if not p8.isCameraToggle then
        return Vector3.new();
    end;

    local currentSubjectDistance = p8.currentSubjectDistance;

    if CameraInput.getTogglePan() then
        local cameraToggleSpring = p8.cameraToggleSpring;
        local v10 = CameraUtils.map(currentSubjectDistance, 0.5, p8.FIRST_PERSON_DISTANCE_THRESHOLD, 0, 1);
        cameraToggleSpring.goal = math.clamp(v10, 0, 1);
    else
        p8.cameraToggleSpring.goal = 0;
    end;

    local v11 = CameraUtils.map(currentSubjectDistance, 0.5, 64, 0, 1);
    local v12 = math.clamp(v11, 0, 1) + 1;
    local v13 = p8.cameraToggleSpring:step(p9) * v12;

    return Vector3.new(0, v13, 0);
end;

function u5.SetCameraMovementMode(p14, p15) -- Line: 69
    -- upvalues: BaseCamera (copy)
    BaseCamera.SetCameraMovementMode(p14, p15);
    p14.isFollowCamera = p15 == Enum.ComputerCameraMovementMode.Follow;
    p14.isCameraToggle = p15 == Enum.ComputerCameraMovementMode.CameraToggle;
end;

function u5.Update(p16, p17) -- Line: 76
    -- upvalues: u3 (copy), u2 (copy), Players (copy), CameraInput (copy), u1 (ref), CameraUtils (copy), u4 (copy)
    local v18 = tick();
    local v19 = v18 - p16.lastUpdate;

    if u3 then
        v19 = p17;
    end;

    local CurrentCamera = workspace.CurrentCamera;
    local CFrame2 = CurrentCamera.CFrame;
    local Focus = CurrentCamera.Focus;
    local v20;

    if p16.resetCameraAngle then
        local v21 = p16:GetHumanoidRootPart();

        if v21 then
            v20 = (v21.CFrame * u2).lookVector;
        else
            v20 = u2.lookVector;
        end;

        p16.resetCameraAngle = false;
    else
        v20 = nil;
    end;

    local LocalPlayer = Players.LocalPlayer;
    local v22 = p16:GetHumanoid();
    local CameraSubject = CurrentCamera.CameraSubject;
    local v23;

    if CameraSubject then
        v23 = CameraSubject:IsA("VehicleSeat");
    else
        v23 = CameraSubject;
    end;

    local v24;

    if CameraSubject then
        v24 = CameraSubject:IsA("SkateboardPlatform");
    else
        v24 = CameraSubject;
    end;

    local v25;

    if v22 then
        v25 = v22:GetState() == Enum.HumanoidStateType.Climbing;
    else
        v25 = v22;
    end;

    if p16.lastUpdate == nil or v19 > 1 then
        p16.lastCameraTransform = nil;
    end;

    local v26 = CameraInput.getRotation(v19);
    p16:StepZoom();
    local v27 = p16:GetCameraHeight();

    if v26 ~= Vector2.new() then
        u1 = 0;
        p16.lastUserPanCamera = tick();
    end;

    local v28 = v18 - p16.lastUserPanCamera < 2;
    local v29 = p16:GetSubjectPosition();

    if v29 and (LocalPlayer and CurrentCamera) then
        local v30 = p16:GetCameraToSubjectDistance();
        local v31 = v30 < 0.5 and 0.5 or v30;

        if p16:GetIsMouseLocked() and not p16:IsInFirstPerson() then
            local v32 = p16:CalculateNewLookCFrameFromArg(v20, v26);
            local v33 = p16:GetMouseLockOffset();

            if v22 then
                v33 = v33 + v22.CameraOffset;
            end;

            local v34 = v33.X * v32.RightVector + v33.Y * v32.UpVector + v33.Z * v32.LookVector;

            if CameraUtils.IsFiniteVector3(v34) then
                v29 = v29 + v34;
            end;
        elseif v26 == Vector2.new() and p16.lastCameraTransform then
            local v35 = p16:IsInFirstPerson();

            if (v23 or (v24 or p16.isFollowCamera and v25)) and (p16.lastUpdate and (v22 and v22.Torso)) then
                if v35 then
                    if p16.lastSubjectCFrame and (v23 or v24) and CameraSubject:IsA("BasePart") then
                        local v36 = -CameraUtils.GetAngleBetweenXZVectors(p16.lastSubjectCFrame.lookVector, CameraSubject.CFrame.lookVector);

                        if CameraUtils.IsFinite(v36) then
                            v26 = v26 + Vector2.new(v36, 0);
                        end;

                        u1 = 0;
                    end;
                elseif not v28 then
                    local lookVector = v22.Torso.CFrame.lookVector;
                    u1 = math.clamp(u1 + 3.839724354387525 * v19, 0, 4.363323129985824);
                    local v37 = math.clamp(u1 * v19, 0, 1);
                    local v38 = p16:IsInFirstPerson() and not (p16.isFollowCamera and p16.isClimbing) and 1 or v37;
                    local v39 = CameraUtils.GetAngleBetweenXZVectors(lookVector, p16:GetCameraLookVector());

                    if CameraUtils.IsFinite(v39) and math.abs(v39) > 0.0001 then
                        v26 = v26 + Vector2.new(v39 * v38, 0);
                    end;
                end;
            elseif p16.isFollowCamera and not (v35 or v28) then
                local v40 = CameraUtils.GetAngleBetweenXZVectors(-(p16.lastCameraTransform.p - v29), p16:GetCameraLookVector());

                if CameraUtils.IsFinite(v40) and (math.abs(v40) > 0.0001 and math.abs(v40) > 0.4 * v19) then
                    v26 = v26 + Vector2.new(v40, 0);
                end;
            end;
        end;

        local v41, v42;

        if p16.isFollowCamera then
            local v43 = p16:CalculateNewLookVectorFromArg(v20, v26);
            v41 = CFrame.new(v29);

            if u4 then
                v42 = CFrame.lookAlong(v41.p - v31 * v43, v43);
            else
                v42 = CFrame.new(v41.p - v31 * v43, v41.p) + Vector3.new(0, v27, 0);
            end;
        else
            v41 = CFrame.new(v29);
            local p = v41.p;
            local v44 = p16:CalculateNewLookVectorFromArg(v20, v26);

            if u4 then
                v42 = CFrame.lookAlong(p - v31 * v44, v44);
            else
                v42 = CFrame.new(p - v31 * v44, p);
            end;
        end;

        local v45 = p16:GetCameraToggleOffset(v19);
        Focus = v41 + v45;
        CFrame2 = v42 + v45;
        p16.lastCameraTransform = CFrame2;
        p16.lastCameraFocus = Focus;

        if (v23 or v24) and CameraSubject:IsA("BasePart") then
            p16.lastSubjectCFrame = CameraSubject.CFrame;
        else
            p16.lastSubjectCFrame = nil;
        end;
    end;

    p16.lastUpdate = v18;

    return CFrame2, Focus;
end;

return u5;