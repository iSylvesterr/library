-- Decompiled with Potassium's decompiler.

local UserInputService = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).UserInputService;
local v1 = {};
local u2 = false;
local u3 = false;

local function _resolveDeviceFlags() -- Line: 54
    -- upvalues: UserInputService (copy), u2 (ref), u3 (ref)
    local PreferredInput = UserInputService.PreferredInput;
    u2 = PreferredInput == Enum.PreferredInput.Touch;
    u3 = PreferredInput == Enum.PreferredInput.KeyboardAndMouse;

    if UserInputService.TouchEnabled and not (UserInputService.MouseEnabled or (UserInputService.KeyboardEnabled or UserInputService.GamepadEnabled)) then
        u2 = true;
    end;

    if u2 then
        u3 = false;
    end;
end;

local PreferredInput = UserInputService.PreferredInput;

if PreferredInput == Enum.PreferredInput.Touch then
    u2 = true;
else
    u2 = false;
end;

if PreferredInput == Enum.PreferredInput.KeyboardAndMouse then
    u3 = true;
else
    u3 = false;
end;

u2 = UserInputService.TouchEnabled and not (UserInputService.MouseEnabled or (UserInputService.KeyboardEnabled or UserInputService.GamepadEnabled)) and true or u2;

if u2 then
    u3 = false;
end;

function v1.IsMobile() -- Line: 83
    -- upvalues: u2 (ref)
    return u2;
end;

function v1.IsPc() -- Line: 91
    -- upvalues: u3 (ref)
    return u3;
end;

function v1.IsGamepad() -- Line: 99
    -- upvalues: UserInputService (copy)
    return UserInputService.GamepadEnabled;
end;

return v1;