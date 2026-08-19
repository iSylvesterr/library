-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local HapticService = game:GetService("HapticService");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local LocalPlayer = Players.LocalPlayer;
local DataController = require(ReplicatedStorage.Controllers.DataController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local u2 = {};
local u3 = nil;

local function isMotorSupported(p4, p5) -- Line: 28
    -- upvalues: HapticService (copy)
    return HapticService:IsMotorSupported(p4, p5);
end;

local function IsVibrationsEnabled() -- Line: 34
    -- upvalues: UserInputService (copy), DataController (copy), LocalPlayer (copy)
    local v6 = UserInputService:GetLastInputType() == Enum.UserInputType.Touch and "Mobile" or "Controller";
    local v7 = DataController.Get(LocalPlayer, "Settings.Game.Other." .. v6 .. " Haptics/Vibrations");

    if v7 == nil then
        return false;
    end;

    return v7 ~= false;
end;

local function stopUpdateLoop() -- Line: 48
    -- upvalues: u3 (ref)
    if u3 then
        u3:Disconnect();
        u3 = nil;
    end;
end;

local function updateQueue(p8) -- Line: 55
    -- upvalues: u2 (copy), HapticService (copy), u3 (ref)
    for i, v in pairs(u2) do
        v.Length = v.Length - p8;

        if HapticService:IsMotorSupported(v.InputMotor, i) then
            HapticService:SetMotor(v.InputMotor, i, v.Intensity);
        end;

        if v.Length <= 0 then
            HapticService:SetMotor(v.InputMotor, i, 0);
            u2[i] = nil;
        end;
    end;

    if next(u2) == nil and u3 then
        u3:Disconnect();
        u3 = nil;
    end;
end;

local function ensureUpdateLoop() -- Line: 74
    -- upvalues: u3 (ref), RunServiceController (copy), updateQueue (copy)
    if u3 then
        return;
    end;

    u3 = RunServiceController.BindToRenderStep("HapticsController.UpdateQueue", updateQueue);
end;

function v1.vibrate(p9, p10, p11) -- Line: 85
    -- upvalues: UserInputService (copy), DataController (copy), LocalPlayer (copy), u2 (copy), u3 (ref), RunServiceController (copy), updateQueue (copy)
    local v12 = UserInputService:GetLastInputType() == Enum.UserInputType.Touch and "Mobile" or "Controller";
    local v13 = DataController.Get(LocalPlayer, "Settings.Game.Other." .. v12 .. " Haptics/Vibrations");
    local v14;

    if v13 == nil then
        v14 = false;
    else
        v14 = v13 ~= false;
    end;

    if v14 then
        local Gamepad1 = Enum.UserInputType.Gamepad1;

        if u2[p9] then
            local v15 = u2[p9];
            v15.InputMotor = Gamepad1;

            if v15.Length < p11 then
                v15.Length = p11;
            end;

            if v15.Intensity < p10 then
                v15.Intensity = p10;
            end;
        else
            u2[p9] = {
                InputMotor = Gamepad1,
                Intensity = p10,
                Length = p11
            };
        end;

        if u3 then
            return;
        end;

        u3 = RunServiceController.BindToRenderStep("HapticsController.UpdateQueue", updateQueue);
    end;
end;

return v1;