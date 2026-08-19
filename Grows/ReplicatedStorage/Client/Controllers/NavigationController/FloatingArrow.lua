-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
ReplicatedStorage:WaitForChild("Packages");
local Utility = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Utility");
local CurrentCamera = workspace.CurrentCamera;
local LocalPlayer = Players.LocalPlayer;
local PVInstanceUtl = require(Utility:WaitForChild("PVInstanceUtl"));
local cframeSlerp = require(Utility:WaitForChild("cframeSlerp"));

return {
    Mode = "None",
    ArrowState = "Camera",
    Target = Vector3.new(0, 0, 0),
    FinalTarget = Vector3.new(0, 0, 0),
    NextTarget = Vector3.new(0, 0, 0),

    SetArrow = function(p1, p2, p3) -- Line: 35, Name: SetArrow
        if p1.ArrowInstance and p1.ArrowInstance ~= p2 then
            warn("Already called SetArrow");
            p1.ArrowInstance:Destroy();
        end;

        p1.ArrowInstance = p2;
        p1.ArrowCameraOffset = p3;
    end,

    Stop = function(p4) -- Line: 46, Name: Stop
        p4:Disconnect();
        p4:HideArrow();
        p4.Target = Vector3.new(0, 0, 0);
        p4.FinalTarget = Vector3.new(0, 0, 0);
        p4.NextTarget = Vector3.new(0, 0, 0);
        p4.Mode = "None";
    end,

    PointAt = function(u5, p6) -- Line: 58, Name: PointAt
        -- upvalues: RunService (copy), LocalPlayer (copy), PVInstanceUtl (copy), cframeSlerp (copy), CurrentCamera (copy)
        assert(u5.ArrowInstance, "FloatingArrow has no ArrowInstance! Did you forget to call FloatingArrow:SetArrow()?");
        u5.Mode = "PointAt";

        if u5.Target == p6 then
            return;
        end;

        u5:Disconnect();
        u5:ShowArrow();
        u5.Target = p6;
        u5.Stepped = RunService.RenderStepped:Connect(function(p7) -- Line: 72
            -- upvalues: LocalPlayer (ref), PVInstanceUtl (ref), u5 (copy), cframeSlerp (ref), CurrentCamera (ref)
            if not LocalPlayer.Character or LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                return;
            end;

            local Position = LocalPlayer.Character.HumanoidRootPart.Position;
            local Rotation = cframeSlerp(PVInstanceUtl:GetCFrame(u5.ArrowInstance), CFrame.lookAt(Position, u5.Target), 0.2).Rotation;
            local v8 = CFrame.new((CurrentCamera.CFrame * u5.ArrowCameraOffset).Position);

            if u5.ArrowState ~= "Camera" then
                u5.ArrowState = "Camera";
                Rotation = CFrame.lookAt(Position, u5.Target);
            end;

            PVInstanceUtl:SetCFrame(u5.ArrowInstance, v8 * Rotation);
        end);
    end,

    PointAtFloat = function(u9, p10, p11, u12, u13, u14, u15) -- Line: 97, Name: PointAtFloat
        -- upvalues: RunService (copy), LocalPlayer (copy), PVInstanceUtl (copy), CurrentCamera (copy), cframeSlerp (copy)
        if u9.FinalTarget ~= p10 then
            u9.FinalTarget = p10;
        end;

        if u9.NextTarget ~= p11 then
            u9.NextTarget = p11;
        end;

        if u9.Mode == "PointAtFloat" and (u9.Stepped and u9.Stepped.Connected) then
            return;
        end;

        if u9.Mode ~= "PointAtFloat" and (u9.Stepped and u9.Stepped.Connected) then
            u9:Disconnect();
        end;

        u9.Mode = "PointAtFloat";
        u9:ShowArrow();
        u9.Stepped = RunService.RenderStepped:Connect(function(p16) -- Line: 116
            -- upvalues: LocalPlayer (ref), PVInstanceUtl (ref), u9 (copy), u12 (copy), u13 (copy), CurrentCamera (ref), cframeSlerp (ref), u14 (copy), u15 (copy)
            if not LocalPlayer.Character or LocalPlayer.Character:FindFirstChild("HumanoidRootPart") == nil then
                return;
            end;

            local Position = LocalPlayer.Character.HumanoidRootPart.Position;
            local v17 = PVInstanceUtl:GetCFrame(u9.ArrowInstance);

            if (Position - u9.FinalTarget).Magnitude > u12 then
                local Rotation = cframeSlerp(v17, CFrame.lookAt(Position, u9.NextTarget), 0.2).Rotation;
                local v18 = CFrame.new((CurrentCamera.CFrame * u9.ArrowCameraOffset).Position);

                if u9.ArrowState ~= "Camera" then
                    u9.ArrowState = "Camera";
                    Rotation = CFrame.lookAt(Position, u9.NextTarget);
                end;

                PVInstanceUtl:SetCFrame(u9.ArrowInstance, v18 * Rotation);

                return;
            end;

            local v19 = CFrame.new(u9.FinalTarget) * CFrame.new(0, u13, 0);
            local v20 = CFrame.lookAt(v19.Position, u9.FinalTarget, CurrentCamera.CFrame.Position - v19.Position);

            if u13 < (v17.Position - v19.Position).Magnitude then
                u9.ArrowState = "Seek";
                local v21 = cframeSlerp(v17, v20, 0.1);
                PVInstanceUtl:SetCFrame(u9.ArrowInstance, v21);

                return;
            end;

            u9.ArrowState = "Bob";
            local v22 = os.clock() * u14;
            local v23 = math.sin(v22);
            local v24 = v20:Lerp(v20 * CFrame.new(0, 0, u15), v23);
            PVInstanceUtl:SetCFrame(u9.ArrowInstance, v24);
        end);
    end,

    ShowArrow = function(p25) -- Line: 162, Name: ShowArrow
        assert(p25.ArrowInstance, "FloatingArrow has no ArrowInstance! Did you forget to call FloatingArrow:SetArrow()?");

        if p25.ArrowInstance.Parent ~= workspace then
            p25.ArrowInstance.Parent = workspace;
        end;
    end,

    HideArrow = function(p26) -- Line: 170, Name: HideArrow
        -- upvalues: ReplicatedStorage (copy)
        if p26.ArrowInstance and p26.ArrowInstance.Parent == workspace then
            p26.ArrowInstance.Parent = ReplicatedStorage;
        end;
    end,

    Disconnect = function(p27) -- Line: 176, Name: Disconnect
        if p27.Stepped and p27.Stepped.Connected == true then
            p27.Stepped:Disconnect();
        end;
    end
};