-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local Players = game:GetService("Players");
require(script.Parent.Parent.Types);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local LocalPlayer = Players.LocalPlayer;
local CurrentCamera = Workspace.CurrentCamera;
local u1 = 0;
local u2 = RaycastParams.new();
u2.FilterType = Enum.RaycastFilterType.Exclude;
u2.IgnoreWater = false;

local function IsCharacterAlive(p3) -- Line: 40
    local Character = p3.Character;

    if Character and Character:IsDescendantOf(workspace) then
        local v4 = Character:FindFirstChildOfClass("Humanoid");

        if v4 and v4.Health > 0 then
            return true;
        end;
    end;

    return false;
end;

local function GetWeaponDataFromInstance(p5) -- Line: 55
    -- upvalues: CollectionService (copy)
    while p5 do
        if CollectionService:HasTag(p5, "WeaponDropped") then
            local v6 = p5:GetAttribute("Weapon");
            local v7 = p5:GetAttribute("Skin");

            if v6 and v7 then
                return v6, v7, p5.Name;
            end;

            break;
        end;

        p5 = p5.Parent;
    end;

    return nil, nil, nil;
end;

local function GetRaycastResult(...) -- Line: 79
    -- upvalues: CurrentCamera (copy), u2 (copy)
    local v8 = { CurrentCamera, ... };
    u2.FilterDescendantsInstances = v8;
    local v9 = workspace:Raycast(CurrentCamera.CFrame.Position, CurrentCamera.CFrame.LookVector * 1000, u2);

    while v9 and v9.Instance do
        local Instance = v9.Instance;

        if not Instance:IsA("BasePart") or Instance.Transparency <= 0.98 then
            break;
        end;

        table.insert(v8, Instance);
        u2.FilterDescendantsInstances = v8;
        v9 = workspace:Raycast(v9.Position, CurrentCamera.CFrame.LookVector.Unit * (1000 - v9.Distance), u2);
    end;

    return v9 or nil;
end;

return table.freeze({
    Name = "Ping",
    Group = "Gameplay",
    Category = "UI Keys",

    Callback = function(p10) -- Line: 124, Name: onInput
        -- upvalues: DataController (copy), LocalPlayer (copy), GetRaycastResult (copy), GetWeaponDataFromInstance (copy), Remotes (copy), u1 (ref)
        if workspace:GetAttribute("Gamemode") == "Deathmatch" then
            return;
        end;

        if DataController.Get(LocalPlayer, "Settings.Game.HUD.Player Pings") == "Disabled" then
            return;
        end;

        local Character = LocalPlayer.Character;
        local v11;

        if Character and Character:IsDescendantOf(workspace) then
            local v12 = Character:FindFirstChildOfClass("Humanoid");
            v11 = v12 and v12.Health > 0 and true or false;
        else
            v11 = false;
        end;

        local v13 = v11 and (p10 == Enum.UserInputState.Begin and GetRaycastResult(LocalPlayer.Character));

        if not v13 then
            return;
        end;

        local v14, v15, v16 = GetWeaponDataFromInstance(v13.Instance);
        local v17;

        if v14 then
            if v15 then
                v17 = v16;
            else
                v17 = v15;
            end;
        else
            v17 = v14;
        end;

        if v17 then
            Remotes.Ping.CreatePlayerPositionPing.Send({
                IsDanger = false,
                Position = v13.Position,
                WeaponIdentity = v16,
                WeaponName = v14,
                WeaponSkin = v15
            });
        else
            Remotes.Ping.CreatePlayerPositionPing.Send({
                IsDanger = tick() - u1 < 0.5,
                Position = v13.Position
            });
        end;

        u1 = tick();
    end
});