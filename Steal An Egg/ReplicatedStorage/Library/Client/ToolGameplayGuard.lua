-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local GuardAreaLookupUtil = require(ReplicatedStorage.Library.Util.GuardAreaLookupUtil);
local Message = require(ReplicatedStorage.Library.Client.NotificationCmds.Message);
local Player = require(ReplicatedStorage.Library.Player);
local LocalPlayer = Players.LocalPlayer;
local __OBJECTS = Workspace.__OBJECTS;
local v1 = __OBJECTS:IsA("Folder");
assert(v1, "Workspace.__OBJECTS must be a Folder");
local Areas = __OBJECTS.Areas;
local v2 = Areas:IsA("Folder");
assert(v2, "Workspace.__OBJECTS.Areas must be a Folder");
local SeparationLine = Areas.SeparationLine;
local v3 = SeparationLine:IsA("BasePart");
assert(v3, "Workspace.__OBJECTS.Areas.SeparationLine must be a BasePart");
local u4 = {};

local function showSafeZoneMessage() -- Line: 44
    -- upvalues: Message (copy)
    Message.Bottom({
        Message = "Cannot use items in the safe zone!",
        Time = 2,
        Color = Color3.fromRGB(255, 70, 70)
    }, {
        PreventDuplicateText = true
    });
end;

local function isGameplayGearTool(p5) -- Line: 54
    return p5 == nil and true or typeof(p5:GetAttribute("GearName")) == "string";
end;

function u4.IsLocalPlayerInGameplayArea() -- Line: 66
    -- upvalues: Player (copy), LocalPlayer (copy), GuardAreaLookupUtil (copy), SeparationLine (copy)
    local v6 = Player.Optional.HumanoidRootPart(LocalPlayer);

    if v6 == nil or not v6:IsA("BasePart") then
        return false;
    end;

    return GuardAreaLookupUtil.IsInGameplaySide(SeparationLine, v6.Position);
end;

function u4.CanActivateLocal(p7) -- Line: 75
    -- upvalues: u4 (copy), showSafeZoneMessage (copy)
    if p7 ~= nil and typeof(p7:GetAttribute("GearName")) ~= "string" then
        return true;
    end;

    if u4.IsLocalPlayerInGameplayArea() then
        return true;
    end;

    showSafeZoneMessage();

    return false;
end;

return u4;