-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local CurrentCamera = workspace.CurrentCamera;

function u1.new() -- Line: 31
    -- upvalues: u1 (copy)
    local v2 = setmetatable({}, u1);
    v2.rootPart = nil;
    v2.head = nil;
    v2.humanoid = nil;
    v2.enabled = false;
    v2._isInternalChange = false;
    v2._cameraSubjectConn = nil;

    return v2;
end;

function u1.initCharacter(u3, p4) -- Line: 49
    -- upvalues: CurrentCamera (copy)
    u3.head = p4:WaitForChild("Head");
    u3.humanoid = p4:WaitForChild("Humanoid");
    u3.rootPart = p4:WaitForChild("HumanoidRootPart");

    if u3._cameraSubjectConn then
        u3._cameraSubjectConn:Disconnect();
    end;

    u3._cameraSubjectConn = CurrentCamera:GetPropertyChangedSignal("CameraSubject"):Connect(function() -- Line: 58
        -- upvalues: u3 (copy), CurrentCamera (ref)
        if u3._isInternalChange then
            u3._isInternalChange = false;

            return;
        end;

        local CameraSubject = CurrentCamera.CameraSubject;

        if not CameraSubject or (not CameraSubject:IsA("BasePart") or CameraSubject.Name ~= "Head") and not CameraSubject:IsA("Humanoid") then
            u3:toggle(false);

            return;
        end;

        if not u3.humanoid then
            return;
        end;

        CurrentCamera.CameraSubject = u3.humanoid;
        u3._isInternalChange = true;
        u3:toggle(true);
    end);
    CurrentCamera.CameraSubject = u3.head;
end;

function u1.toggle(p5, p6) -- Line: 87
    if p5.enabled == p6 then
        return;
    end;

    p5.enabled = p6;

    if p5.humanoid then
        p5.humanoid.CameraOffset = Vector3.new(0, 0, 0);
    end;
end;

function u1.update(p7, p8) -- Line: 105
    if not p7.enabled then
        return;
    end;

    if p7.rootPart and (p7.head and p7.humanoid) then
        local v9 = (p7.rootPart.CFrame + Vector3.new(0, 1.5, 0)):PointToObjectSpace(p7.head.Position);
        p7.humanoid.CameraOffset = p7.humanoid.CameraOffset:Lerp(v9, p8 * 2);

        return true;
    end;
end;

function u1.renderStepped(p10, p11) -- Line: 128
    if not p10:update(p11) then
        p10:toggle(false);
    end;
end;

function u1.destroy(p12) -- Line: 137
    if p12._cameraSubjectConn then
        p12._cameraSubjectConn:Disconnect();
        p12._cameraSubjectConn = nil;
    end;

    p12:toggle(false);
    p12.rootPart = nil;
    p12.head = nil;
    p12.humanoid = nil;
end;

return u1;