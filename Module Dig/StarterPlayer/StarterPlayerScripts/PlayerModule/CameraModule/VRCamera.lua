-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local VRService = game:GetService("VRService");
UserSettings():GetService("UserGameSettings");
require(script.Parent:WaitForChild("CameraInput"));
require(script.Parent:WaitForChild("CameraUtils"));
local VRBaseCamera = require(script.Parent:WaitForChild("VRBaseCamera"));
local u1 = setmetatable({}, VRBaseCamera);
u1.__index = u1;

function u1.new() -- Line: 28
    -- upvalues: VRBaseCamera (copy), u1 (copy), Players (copy)
    local v2 = VRBaseCamera.new();
    local v3 = setmetatable(v2, u1);
    v3.lastUpdate = tick();
    v3.focusOffset = CFrame.new();
    v3:Reset();
    v3.controlModule = require(Players.LocalPlayer:WaitForChild("PlayerScripts").PlayerModule:WaitForChild("ControlModule"));
    v3.savedAutoRotate = true;

    return v3;
end;

function u1.Reset(p4) -- Line: 41
    -- upvalues: VRBaseCamera (copy)
    p4.needsReset = true;
    p4.needsBlackout = true;
    p4.motionDetTime = 0;
    p4.blackOutTimer = 0;
    p4.lastCameraResetPosition = nil;
    VRBaseCamera.Reset(p4);
end;

function u1.Update(p5, p6) -- Line: 50
    -- upvalues: Players (copy), VRService (copy)
    local CurrentCamera = workspace.CurrentCamera;
    local CFrame2 = CurrentCamera.CFrame;
    local Focus = CurrentCamera.Focus;
    local LocalPlayer = Players.LocalPlayer;
    p5:GetHumanoid();
    local _ = CurrentCamera.CameraSubject;

    if p5.lastUpdate == nil or p6 > 1 then
        p5.lastCameraTransform = nil;
    end;

    p5:UpdateFadeFromBlack(p6);
    p5:UpdateEdgeBlur(LocalPlayer, p6);
    local lastSubjectPosition = p5.lastSubjectPosition;
    local v7 = p5:GetSubjectPosition();

    if p5.needsBlackout then
        p5:StartFadeFromBlack();
        local v8 = math.clamp(p6, 0.0001, 0.1);
        p5.blackOutTimer = p5.blackOutTimer + v8;

        if p5.blackOutTimer > 0.1 and game:IsLoaded() then
            p5.needsBlackout = false;
            p5.needsReset = true;
        end;
    end;

    if v7 and (LocalPlayer and CurrentCamera) then
        local v9 = p5:GetVRFocus(v7, p6);

        if p5:IsInFirstPerson() then
            if VRService.AvatarGestures then
                CFrame2, Focus = p5:UpdateImmersionCamera(p6, CFrame2, v9, lastSubjectPosition, v7);
            else
                CFrame2, Focus = p5:UpdateFirstPersonTransform(p6, CFrame2, v9, lastSubjectPosition, v7);
            end;
        elseif VRService.ThirdPersonFollowCamEnabled then
            CFrame2, Focus = p5:UpdateThirdPersonFollowTransform(p6, CFrame2, v9, lastSubjectPosition, v7);
        else
            CFrame2, Focus = p5:UpdateThirdPersonComfortTransform(p6, CFrame2, v9, lastSubjectPosition, v7);
        end;

        p5.lastCameraTransform = CFrame2;
        p5.lastCameraFocus = Focus;
    end;

    p5.lastUpdate = tick();

    return CFrame2, Focus;
end;

function u1.GetAvatarFeetWorldYValue(p10) -- Line: 112
    local CameraSubject = workspace.CurrentCamera.CameraSubject;

    if not CameraSubject then
        return nil;
    end;

    if not (CameraSubject:IsA("Humanoid") and CameraSubject.RootPart) then
        return nil;
    end;

    local RootPart = CameraSubject.RootPart;

    return RootPart.Position.Y - RootPart.Size.Y / 2 - CameraSubject.HipHeight;
end;

function u1.UpdateFirstPersonTransform(p11, p12, p13, p14, p15, p16) -- Line: 127
    -- upvalues: Players (copy)
    if p11.needsReset then
        p11:StartFadeFromBlack();
        p11.needsReset = false;
    end;

    local LocalPlayer = Players.LocalPlayer;

    if (p15 - p16).magnitude > 0.01 then
        p11:StartVREdgeBlur(LocalPlayer);
    end;

    local p = p14.p;
    local v17 = p11:GetCameraLookVector();
    local Unit = Vector3.new(v17.X, 0, v17.Z).Unit;
    local v18 = p11:getRotation(p12);
    local v19 = p11:CalculateNewLookVectorFromArg(Unit, Vector2.new(v18, 0));

    return CFrame.new(p - 0.5 * v19, p), p14;
end;

function u1.UpdateImmersionCamera(p20, p21, p22, p23, p24, p25) -- Line: 153
    -- upvalues: Players (copy), VRService (copy)
    local v26 = p20:GetSubjectCFrame();
    local CurrentCamera = workspace.CurrentCamera;
    local Character = Players.LocalPlayer.Character;
    local v27 = p20:GetHumanoid();

    if not v27 then
        return CurrentCamera.CFrame, CurrentCamera.Focus;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return CurrentCamera.CFrame, CurrentCamera.Focus;
    end;

    p20.characterOrientation = HumanoidRootPart:FindFirstChild("CharacterAlignOrientation");

    if not p20.characterOrientation then
        local RootAttachment = HumanoidRootPart:FindFirstChild("RootAttachment");

        if not RootAttachment then
            return;
        end;

        p20.characterOrientation = Instance.new("AlignOrientation");
        p20.characterOrientation.Name = "CharacterAlignOrientation";
        p20.characterOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment;
        p20.characterOrientation.Attachment0 = RootAttachment;
        p20.characterOrientation.RigidityEnabled = true;
        p20.characterOrientation.Parent = HumanoidRootPart;
    end;

    if p20.characterOrientation.Enabled == false then
        p20.characterOrientation.Enabled = true;
    end;

    if p20.needsReset then
        p20.needsReset = false;
        p20.savedAutoRotate = v27.AutoRotate;
        v27.AutoRotate = false;

        if p20.NoRecenter then
            p20.NoRecenter = false;
            VRService:RecenterUserHeadCFrame();
        end;

        p20:StartFadeFromBlack();
    elseif v27.Sit then
        if (v26.Position - CurrentCamera.CFrame.Position).Magnitude > 0.01 then
            p20:StartVREdgeBlur(Players.LocalPlayer);
        end;
    else
        local v28 = p20.controlModule:GetEstimatedVRTorsoFrame();
        p20.characterOrientation.CFrame = CurrentCamera.CFrame * v28;

        if p20.controlModule.inputMoveVector.Magnitude > 0 then
            p20.motionDetTime = 0.1;
        end;

        if p20.controlModule.inputMoveVector.Magnitude > 0 or p20.motionDetTime > 0 then
            p20.motionDetTime = p20.motionDetTime - p21;
            p20:StartVREdgeBlur(Players.LocalPlayer);
            local v29 = VRService:GetUserCFrame(Enum.UserCFrame.Head);
            local HumanoidRootPart2 = Character.HumanoidRootPart;
            local v30 = CurrentCamera.CFrame * (v29.Rotation + v29.Position * CurrentCamera.HeadScale) * CFrame.new(0, -0.7 * HumanoidRootPart2.Size.Y / 2, 0);
            local LookVector = HumanoidRootPart2.CFrame.LookVector;
            local v31 = p25 - (v30 - Vector3.new(LookVector.X, 0, LookVector.Z).Unit * HumanoidRootPart2.Size.Y * 0.125).Position + CurrentCamera.CFrame.Position;
            local v32 = Vector3.new(v31.X, p25.Y, v31.Z);
            v26 = CurrentCamera.CFrame.Rotation + v32;
        else
            v26 = CurrentCamera.CFrame.Rotation + Vector3.new(CurrentCamera.CFrame.Position.X, p25.Y, CurrentCamera.CFrame.Position.Z);
        end;

        local v33 = p20:getRotation(p21);

        if math.abs(v33) > 0 then
            local v34 = VRService:GetUserCFrame(Enum.UserCFrame.Head);
            local v35 = v34.Rotation + v34.Position * CurrentCamera.HeadScale;
            local v36 = v26 * v35;
            v26 = CFrame.new(v36.Position) * CFrame.Angles(0, -math.rad(v33 * 90), 0) * v36.Rotation * v35:Inverse();
        end;
    end;

    return v26, v26 * CFrame.new(0, 0, -0.5);
end;

function u1.UpdateThirdPersonComfortTransform(p37, p38, p39, p40, p41, p42) -- Line: 265
    -- upvalues: Players (copy), VRService (copy)
    local v43 = p37:GetCameraToSubjectDistance();
    local v44 = v43 < 0.5 and 0.5 or v43;

    if p41 ~= nil and p37.lastCameraFocus ~= nil then
        local _ = Players.LocalPlayer;
        local v45 = p37.controlModule:GetMoveVector();
        local v46 = (p41 - p42).magnitude > 0.01 and true or v45.magnitude > 0.01;

        if v46 then
            p37.motionDetTime = 0.1;
        end;

        p37.motionDetTime = p37.motionDetTime - p38;

        if (p37.motionDetTime > 0 and true or v46) and not p37.needsReset then
            local lastCameraFocus = p37.lastCameraFocus;
            p37.VRCameraFocusFrozen = true;

            return p39, lastCameraFocus;
        end;

        local v47 = p37.lastCameraResetPosition == nil and true or (p42 - p37.lastCameraResetPosition).Magnitude > 1;
        local v48 = p37:getRotation(p38);

        if math.abs(v48) > 0 then
            local v49 = p40:ToObjectSpace(p39);
            p39 = p40 * CFrame.Angles(0, -v48, 0) * v49;
        end;

        if p37.VRCameraFocusFrozen and v47 or p37.needsReset then
            VRService:RecenterUserHeadCFrame();
            p37.VRCameraFocusFrozen = false;
            p37.needsReset = false;
            p37.lastCameraResetPosition = p42;
            p37:ResetZoom();
            p37:StartFadeFromBlack();
            local v50 = p37:GetHumanoid();
            local v51 = v50.Torso and v50.Torso.CFrame.lookVector or Vector3.new(1, 0, 0);
            local v52 = Vector3.new(v51.X, 0, v51.Z);
            local v53 = p40.Position - v52 * v44;
            local v54 = Vector3.new(p40.Position.X, v53.Y, p40.Position.Z);
            p39 = CFrame.new(v53, v54);
        end;
    end;

    return p39, p40;
end;

function u1.UpdateThirdPersonFollowTransform(p55, p56, p57, p58, p59, p60) -- Line: 332
    -- upvalues: VRService (copy), Players (copy)
    local CurrentCamera = workspace.CurrentCamera;
    local v61 = p55:GetCameraToSubjectDistance();
    local v62 = p55:GetVRFocus(p60, p56);

    if p55.needsReset then
        p55.needsReset = false;
        VRService:RecenterUserHeadCFrame();
        p55:ResetZoom();
        p55:StartFadeFromBlack();
    end;

    if p55.recentered then
        local v63 = p55:GetSubjectCFrame();

        if not v63 then
            return CurrentCamera.CFrame, CurrentCamera.Focus;
        end;

        local v64 = v62 * v63.Rotation * CFrame.new(0, 0, v61);
        p55.focusOffset = v62:ToObjectSpace(v64);
        p55.recentered = false;

        return v64, v62;
    end;

    local v65 = v62:ToWorldSpace(p55.focusOffset);
    local _ = Players.LocalPlayer;
    local controlModule = p55.controlModule;
    local v66 = controlModule:GetMoveVector();

    if (p59 - p60).magnitude > 0.01 or v66.magnitude > 0 then
        local v67 = controlModule:GetEstimatedVRTorsoFrame();
        local v68 = CurrentCamera.CFrame * (v67.Rotation + v67.Position * CurrentCamera.HeadScale);
        local LookVector = v68.LookVector;
        local v69 = Vector3.new(LookVector.X, 0, LookVector.Z).Unit * v61;
        v65 = v65:Lerp(CFrame.new(CurrentCamera.CFrame.Position + (v62.Position - v69) - v68.Position) * v65.Rotation, 0.01);
    end;

    local v70 = p55:getRotation(p56);

    if math.abs(v70) > 0 then
        local v71 = v62:ToObjectSpace(v65);
        v65 = v62 * CFrame.Angles(0, -v70, 0) * v71;
    end;

    p55.focusOffset = v62:ToObjectSpace(v65);
    local v72 = v65 * CFrame.new(0, 0, -v61);

    if (v72.Position - CurrentCamera.Focus.Position).Magnitude > 0.01 then
        p55:StartVREdgeBlur(Players.LocalPlayer);
    end;

    return v65, v72;
end;

function u1.LeaveFirstPerson(p73) -- Line: 410
    -- upvalues: VRBaseCamera (copy)
    VRBaseCamera.LeaveFirstPerson(p73);
    p73.needsReset = true;

    if p73.VRBlur then
        p73.VRBlur.Visible = false;
    end;

    if p73.characterOrientation then
        p73.characterOrientation.Enabled = false;
    end;

    local v74 = p73:GetHumanoid();

    if v74 then
        v74.AutoRotate = p73.savedAutoRotate;
    end;
end;

return u1;