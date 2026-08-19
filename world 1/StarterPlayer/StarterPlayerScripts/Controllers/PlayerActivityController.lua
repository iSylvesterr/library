-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 3
};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local WerewolfFlags = require(ReplicatedStorage.SharedModules.Flags.WerewolfFlags);
local LocalPlayer = Players.LocalPlayer;
local u2 = { "LoadingScreenDone", "OfflineCutscenePlaying", "CutsceneInputBlocked" };
local u3 = os.clock();
local u4 = nil;
local u5 = nil;

local function markActivity() -- Line: 38
    -- upvalues: u3 (ref)
    u3 = os.clock();
end;

local function isReady() -- Line: 42
    -- upvalues: LocalPlayer (copy)
    local v6;

    if LocalPlayer:GetAttribute("LoadingScreenDone") == true and LocalPlayer:GetAttribute("OfflineCutscenePlaying") ~= true then
        v6 = LocalPlayer:GetAttribute("CutsceneInputBlocked") ~= true;
    else
        v6 = false;
    end;

    return v6;
end;

local function isAfk() -- Line: 48
    -- upvalues: u3 (ref), WerewolfFlags (copy)
    return os.clock() - u3 >= WerewolfFlags.AfkIdleSeconds:Get();
end;

local function report() -- Line: 52
    -- upvalues: LocalPlayer (copy), u3 (ref), WerewolfFlags (copy), u4 (ref), u5 (ref), Networking (copy)
    local v7;

    if LocalPlayer:GetAttribute("LoadingScreenDone") == true and LocalPlayer:GetAttribute("OfflineCutscenePlaying") ~= true then
        v7 = LocalPlayer:GetAttribute("CutsceneInputBlocked") ~= true;
    else
        v7 = false;
    end;

    local v8 = os.clock() - u3 >= WerewolfFlags.AfkIdleSeconds:Get();

    if v7 == u4 and v8 == u5 then
        return;
    end;

    u4 = v7;
    u5 = v8;
    Networking.Activity.Report:Fire(v7, v8);
end;

function v1.Init(p9) -- Line: 63
end;

function v1.Start(p10) -- Line: 65
    -- upvalues: UserInputService (copy), u3 (ref), markActivity (copy), u2 (copy), LocalPlayer (copy), report (copy), WerewolfFlags (copy), u4 (ref), u5 (ref), Networking (copy)
    UserInputService.InputBegan:Connect(function(p11) -- Line: 70
        -- upvalues: u3 (ref)
        local UserInputType = p11.UserInputType;

        if UserInputType == Enum.UserInputType.Keyboard or (UserInputType == Enum.UserInputType.MouseButton1 or (UserInputType == Enum.UserInputType.MouseButton2 or (UserInputType == Enum.UserInputType.MouseButton3 or UserInputType == Enum.UserInputType.Gamepad1))) then
            u3 = os.clock();
        end;
    end);
    UserInputService.InputChanged:Connect(function(p12) -- Line: 82
        -- upvalues: UserInputService (ref), u3 (ref)
        if p12.UserInputType == Enum.UserInputType.MouseMovement then
            if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                u3 = os.clock();
            end;

            return;
        end;

        if (p12.KeyCode == Enum.KeyCode.Thumbstick1 or p12.KeyCode == Enum.KeyCode.Thumbstick2) and p12.Position.Magnitude > 0.15 then
            u3 = os.clock();
        end;
    end);
    UserInputService.TouchStarted:Connect(markActivity);
    UserInputService.TouchMoved:Connect(markActivity);

    for _, v in u2 do
        LocalPlayer:GetAttributeChangedSignal(v):Connect(report);
    end;

    task.spawn(function() -- Line: 108
        -- upvalues: LocalPlayer (ref), u3 (ref), WerewolfFlags (ref), u4 (ref), u5 (ref), Networking (ref)
        while true do
            local v13;

            if LocalPlayer:GetAttribute("LoadingScreenDone") == true and LocalPlayer:GetAttribute("OfflineCutscenePlaying") ~= true then
                v13 = LocalPlayer:GetAttribute("CutsceneInputBlocked") ~= true;
            else
                v13 = false;
            end;

            local v14 = os.clock() - u3 >= WerewolfFlags.AfkIdleSeconds:Get();

            if v13 ~= u4 or v14 ~= u5 then
                u4 = v13;
                u5 = v14;
                Networking.Activity.Report:Fire(v13, v14);
            end;

            task.wait(1);
        end;
    end);
end;

return v1;