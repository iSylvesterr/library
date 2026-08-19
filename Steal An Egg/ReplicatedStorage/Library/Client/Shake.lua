-- Decompiled with Potassium's decompiler.

local v1 = {};
local GuiService = game:GetService("GuiService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local HapticService = game:GetService("HapticService");
local Library = ReplicatedStorage:WaitForChild("Library");
local Variables = require(Library.Variables);
local Functions = require(Library.Functions);
local u2 = Random.new();
local u3 = 0;

function v1.Create(p4, p5, p6, p7, p8, u9) -- Line: 16
    -- upvalues: GuiService (copy), u3 (ref), Functions (copy), Players (copy), u2 (copy), Variables (copy), HapticService (copy), RunService (copy)
    if GuiService.ReducedMotionEnabled then
        return;
    end;

    if workspace.CurrentCamera.CameraType == Enum.CameraType.Scriptable then
        return;
    end;

    u3 = u3 + 1;
    local u10 = u3;
    local u11 = p4 or 1;
    local u12 = p5 or 1;
    local u13 = p6 or 0;
    local u14 = p7 == true;

    if p8 then
        local v15 = Functions.Distance(Players.LocalPlayer, p8.Origin);

        if v15 then
            if p8.MaxDistance < v15 then
                return;
            end;

            if p8.RollOffDistance < v15 then
                local v16 = p8.MaxDistance - p8.RollOffDistance;
                local v17 = math.clamp((v15 - p8.RollOffDistance) / (v16 == 0 and 0.001 or v16), 0, 1);

                if v17 >= 1 then
                    return;
                end;

                u12 = u12 * (1 - v17);
            end;
        end;
    end;

    task.spawn(function() -- Line: 55
        -- upvalues: u3 (ref), u10 (copy), u11 (copy), u13 (copy), u14 (copy), u2 (ref), u12 (ref), u9 (copy), Variables (ref), HapticService (ref), RunService (ref)
        local v18 = os.clock();
        local v19 = os.clock();
        local CurrentCamera = workspace.CurrentCamera;
        local v20 = Vector3.new();
        local v21 = nil;

        while u3 == u10 and os.clock() - v18 <= u11 do
            local v22 = (os.clock() - v18) / u11;

            if not v21 or u13 / 10 <= os.clock() - v19 then
                v19 = os.clock();
                local v23 = u14 and math.sin(v22 * 3.141592653589793) or math.sin((0.5 + v22 / 2) * 3.141592653589793);
                local v24 = u2:NextNumber(-v23, v23) * v23 * u12;
                local v25 = u2:NextNumber(-v23, v23) * v23 * u12;
                local v26 = u2:NextNumber(-v23, v23) * v23 * u12;
                v21 = Vector3.new(v24, v25, v26);

                if not u9 and (Variables.Console or Variables.Mobile) and HapticService:IsVibrationSupported(Enum.UserInputType.Gamepad1) then
                    HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, math.min(u12, 1) * v23);
                end;
            end;

            CurrentCamera.CFrame = CurrentCamera.CFrame * CFrame.new(-v20) * CFrame.new(v21);
            RunService.RenderStepped:Wait();
            v20 = v21;
        end;

        CurrentCamera.CFrame = CurrentCamera.CFrame * CFrame.new(-v20);

        if not u9 and (Variables.Console or Variables.Mobile) and HapticService:IsVibrationSupported(Enum.UserInputType.Gamepad1) then
            HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, 0);
        end;
    end);
end;

return v1;