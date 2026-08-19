-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 3
};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local UserInputService = game:GetService("UserInputService");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local AntiAfkFlags = require(ReplicatedStorage.SharedModules.Flags.AntiAfkFlags);
local LocalPlayer = Players.LocalPlayer;
local u2 = os.clock();
local u3 = false;

local function markActivity() -- Line: 27
    -- upvalues: u2 (ref), u3 (ref)
    u2 = os.clock();
    u3 = false;
end;

local function getThreshold() -- Line: 32
    -- upvalues: LocalPlayer (copy), AntiAfkFlags (copy)
    local v4 = LocalPlayer:GetAttribute("AntiAfkIdleOverride");

    if type(v4) == "number" and v4 > 0 then
        return v4;
    end;

    return AntiAfkFlags.IdleSeconds:Get();
end;

function v1.Init(p5) -- Line: 40
end;

function v1.Start(p6) -- Line: 43
    -- upvalues: UserInputService (copy), u2 (ref), u3 (ref), markActivity (copy), RunService (copy), AntiAfkFlags (copy), LocalPlayer (copy), Networking (copy)
    UserInputService.InputBegan:Connect(function(p7) -- Line: 47
        -- upvalues: u2 (ref), u3 (ref)
        local UserInputType = p7.UserInputType;

        if UserInputType == Enum.UserInputType.Keyboard or (UserInputType == Enum.UserInputType.MouseButton1 or (UserInputType == Enum.UserInputType.MouseButton2 or (UserInputType == Enum.UserInputType.MouseButton3 or UserInputType == Enum.UserInputType.Gamepad1))) then
            u2 = os.clock();
            u3 = false;
        end;
    end);
    UserInputService.InputChanged:Connect(function(p8) -- Line: 59
        -- upvalues: UserInputService (ref), u2 (ref), u3 (ref)
        if p8.UserInputType == Enum.UserInputType.MouseMovement then
            if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                u2 = os.clock();
                u3 = false;
            end;

            return;
        end;

        if (p8.KeyCode == Enum.KeyCode.Thumbstick1 or p8.KeyCode == Enum.KeyCode.Thumbstick2) and p8.Position.Magnitude > 0.15 then
            u2 = os.clock();
            u3 = false;
        end;
    end);
    UserInputService.TouchStarted:Connect(markActivity);
    UserInputService.TouchMoved:Connect(markActivity);
    task.spawn(function() -- Line: 82
        -- upvalues: RunService (ref), AntiAfkFlags (ref), u3 (ref), u2 (ref), LocalPlayer (ref), Networking (ref)
        while task.wait(1) do
            if not RunService:IsStudio() and (AntiAfkFlags.Enabled:Get() and not u3) then
                local v9 = os.clock() - u2;
                local v10 = LocalPlayer:GetAttribute("AntiAfkIdleOverride");

                if type(v10) ~= "number" or v10 <= 0 then
                    v10 = AntiAfkFlags.IdleSeconds:Get();
                end;

                if v10 <= v9 then
                    u3 = true;
                    Networking.AntiAfk.RequestHop:Fire();
                end;
            end;
        end;
    end);
end;

return v1;