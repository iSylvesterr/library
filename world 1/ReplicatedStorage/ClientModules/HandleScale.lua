-- Decompiled with Potassium's decompiler.

local v1 = {};
local RunService = game:GetService("RunService");

function v1.ScaleGripTranslation(p2, p3) -- Line: 7
    return CFrame.new(p2.Position * p3) * p2.Rotation;
end;

function v1.ScaleClone(p4, p5) -- Line: 12
    if math.abs(p5 - 1) <= 0.0001 then
        return;
    end;

    if p4:IsA("Model") then
        p4:ScaleTo(p5);

        return;
    end;

    if p4:IsA("BasePart") then
        p4.Size = p4.Size * p5;
    end;
end;

function v1.MonitorCharacterScale(u6, u7, u8) -- Line: 25
    -- upvalues: RunService (copy)
    local u9 = u6:GetScale();
    local u10 = nil;
    u10 = RunService.Heartbeat:Connect(function() -- Line: 31
        -- upvalues: u6 (copy), u10 (ref), u7 (copy), u9 (ref), u8 (copy)
        if not (u6 and u6.Parent) then
            u10:Disconnect();

            return;
        end;

        local v11 = false;

        for _, child in u6:GetChildren() do
            if child:IsA("Tool") and u7(child) then
                v11 = true;
                break;
            end;
        end;

        local v12 = v11 and (u6:FindFirstChild("Right Arm") or u6:FindFirstChild("RightHand"));

        if v12 then
            local RightGrip = v12:FindFirstChild("RightGrip");
            local RightGripAttachment = v12:FindFirstChild("RightGripAttachment");

            if RightGrip and (RightGrip:IsA("Weld") and RightGripAttachment) then
                local C0 = RightGrip.C0;
                local Position = RightGripAttachment.CFrame.Position;

                if (C0.Position - Position).Magnitude > 0.0001 then
                    RightGrip.C0 = CFrame.new(Position) * (C0 - C0.Position);
                end;
            end;
        end;

        if not v11 then
            return;
        end;

        local v13 = u6:GetScale();

        if math.abs(v13 - u9) < 0.0001 then
            return;
        end;

        u9 = v13;

        for _, child in u6:GetChildren() do
            if child:IsA("Tool") and u7(child) then
                u8(child, u6);
            end;
        end;
    end);
end;

return v1;