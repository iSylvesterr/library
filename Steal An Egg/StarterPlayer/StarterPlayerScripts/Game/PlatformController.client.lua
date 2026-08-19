-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Signal = require(ReplicatedStorage.Library.Signal);
local Variables = require(ReplicatedStorage.Library.Variables);
local u1 = Log.new();

local function resolvePlatform() -- Line: 19
    -- upvalues: UserInputService (copy)
    local PreferredInput = UserInputService.PreferredInput;

    return PreferredInput == Enum.PreferredInput.Gamepad and "Console" or (PreferredInput == Enum.PreferredInput.Touch and "Mobile" or "Desktop");
end;

local function publishPlatform() -- Line: 30
    -- upvalues: UserInputService (copy), Variables (copy), Signal (copy), u1 (copy)
    local PreferredInput = UserInputService.PreferredInput;
    local v2 = PreferredInput == Enum.PreferredInput.Gamepad and "Console" or (PreferredInput == Enum.PreferredInput.Touch and "Mobile" or "Desktop");

    if Variables.Platform == v2 then
        return;
    end;

    Variables.Platform = v2;
    Variables.Console = v2 == "Console";
    Variables.Mobile = v2 == "Mobile";
    Variables.Desktop = v2 == "Desktop";
    Variables.VR = UserInputService.VREnabled;
    Signal.Fire("Changed Platform", v2);
    u1:AtInfo():Log((`Preferred platform changed to {v2}`));
end;

Signal.Invoked("Platform: Get").OnInvoke = function() -- Line: 48
    -- upvalues: Variables (copy)
    return Variables.Platform;
end;

UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(publishPlatform);
Variables.Platform = "";
publishPlatform();