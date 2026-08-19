-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local LocalPlayer = Players.LocalPlayer;
local Parent = script.Parent;
local Network = require(ReplicatedStorage.Library.Client.Network);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local ToolGameplayGuard = require(ReplicatedStorage.Library.Client.ToolGameplayGuard);
local Traps = Constants.NETWORK_MAP.Traps;
local u1 = 0;
Parent.Activated:Connect(function() -- Line: 16, Name: onActivated
    -- upvalues: ToolGameplayGuard (copy), Parent (copy), u1 (ref), LocalPlayer (copy), Network (copy), Traps (copy)
    if not ToolGameplayGuard.CanActivateLocal(Parent) then
        return;
    end;

    local v2 = tick();

    if v2 - u1 < 1 then
        return;
    end;

    if not (LocalPlayer.Character and LocalPlayer.Character.PrimaryPart) then
        return;
    end;

    u1 = v2;
    local Character = LocalPlayer.Character;
    local PrimaryPart = Character.PrimaryPart;
    local LookVector = PrimaryPart.CFrame.LookVector;
    local v3 = PrimaryPart.Position + LookVector * 4;
    local v4 = RaycastParams.new();
    v4.FilterType = Enum.RaycastFilterType.Exclude;
    v4.FilterDescendantsInstances = { Character };

    if workspace:Raycast(PrimaryPart.Position, LookVector * 4, v4) then
        return;
    end;

    local v5 = Vector3.new(v3.X, v3.Y + 5, v3.Z);
    local v6 = workspace:Raycast(v5, Vector3.new(0, -100, 0), v4);

    if v6 then
        v3 = v6.Position;
    end;

    local v7 = Parent:GetAttribute("GearName");

    if typeof(v7) ~= "string" then
        v7 = Parent.Name;
    end;

    Network.Fire(Traps.REQUEST_PLACE, v7, v3);
end);