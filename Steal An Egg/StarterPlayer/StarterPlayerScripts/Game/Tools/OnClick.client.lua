-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local UserInputService = game:GetService("UserInputService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Gears = require(ReplicatedStorage.Directory.Gears);
local Network = require(ReplicatedStorage.Library.Client.Network);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local ToolGameplayGuard = require(ReplicatedStorage.Library.Client.ToolGameplayGuard);
local ToolInput = Constants.NETWORK_MAP.ToolInput;
local u1 = {
    [Enum.UserInputType.MouseButton1] = true,
    [Enum.UserInputType.Touch] = true
};
local LocalPlayer = Players.LocalPlayer;

local function isBatTool(p2) -- Line: 29
    -- upvalues: Asserts (copy), Gears (copy)
    local v3 = p2:GetAttribute("GearName");
    Asserts.optional.string(v3);

    if v3 == nil then
        return false;
    end;

    local v4 = Gears.Types.GearNameExists(v3) and Gears.Directory[v3].BatControllerData ~= nil;

    return v4;
end;

local function trySendActivation() -- Line: 40
    -- upvalues: LocalPlayer (copy), ToolGameplayGuard (copy), Asserts (copy), Gears (copy), Network (copy), ToolInput (copy)
    local v5 = LocalPlayer;

    if not v5 then
        return;
    end;

    local Character = v5.Character;

    if not Character then
        return;
    end;

    local v6 = Character:FindFirstChildWhichIsA("Tool");

    if not v6 then
        return;
    end;

    if not ToolGameplayGuard.CanActivateLocal(v6) then
        return;
    end;

    local v7 = v6:GetAttribute("GearName");
    Asserts.optional.string(v7);
    local v8;

    if v7 == nil then
        v8 = false;
    else
        v8 = Gears.Types.GearNameExists(v7) and Gears.Directory[v7].BatControllerData ~= nil;
    end;

    if v8 then
        return;
    end;

    Network.Fire(ToolInput.ACTIVATE, v6);
end;

UserInputService.InputBegan:Connect(function(p9) -- Line: 69
    -- upvalues: u1 (copy), trySendActivation (copy)
    if not u1[p9.UserInputType] then
        return;
    end;

    trySendActivation();
end);