-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CollectionService = game:GetService("CollectionService");
local Players = game:GetService("Players");
local Workspace = game:GetService("Workspace");
require(ReplicatedStorage.Database.Custom.Types);
require(script.Parent.Parent.Types);
local LocalPlayer = Players.LocalPlayer;
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local CenterScreenRaycast = require(ReplicatedStorage.Components.Common.CenterScreenRaycast);
local FlashEffect = require(ReplicatedStorage.Components.Common.VFXLibary.FlashEffect);
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties);
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local NumberSlots = require(ReplicatedStorage.Database.Custom.GameStats.NumberSlots);
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities);
local Grenades = require(ReplicatedStorage.Database.Custom.GameStats.Grenades);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local u1 = RaycastParams.new();
u1.FilterType = Enum.RaycastFilterType.Exclude;
u1.IgnoreWater = true;
local u2;

if table.find(GetUserPlatform(), "Mobile") == nil then
    u2 = false;
else
    u2 = #GetUserPlatform() <= 1;
end;

local u3 = nil;
local u4 = nil;
local u5 = false;
local u6 = true;
local u7 = nil;
local u8 = {
    UserInputType = Enum.UserInputType.Touch
};
local u9 = nil;

local function IsEnemy(p10) -- Line: 72
    -- upvalues: Players (copy), LocalPlayer (copy)
    if not (p10 and p10.Parent) then
        return false;
    end;

    local Parent = p10.Parent;
    local v11 = Parent:FindFirstChildOfClass("Humanoid");

    if not v11 or v11.Health <= 0 then
        return false;
    end;

    local v12 = Players:GetPlayerFromCharacter(Parent);

    if not v12 then
        return false;
    end;

    local v13 = LocalPlayer:GetAttribute("Team");
    local v14 = v12:GetAttribute("Team");

    if v14 then
        return workspace:GetAttribute("Gamemode") == "Deathmatch" and true or v14 ~= v13;
    end;

    return false;
end;

local function CountTargetGrenades(p15, p16) -- Line: 107
    local v17 = 0;

    for _, v in ipairs(p15) do
        if v.Name == p16 then
            v17 = v17 + 1;
        end;
    end;

    return v17;
end;

local function computePriority(p18, p19) -- Line: 121
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;

    if not (Character and Character.PrimaryPart) then
        return false;
    end;

    local v20 = p18:GetAttribute("HoveringState");
    local v21 = p19:GetAttribute("HoveringState");

    if v20 == "Hovering" then
        return true;
    end;

    if v21 == "Hovering" then
        return false;
    end;

    local v22 = p18:GetAttribute("CanPickup");
    local v23 = p19:GetAttribute("CanPickup");

    if v22 == false then
        return false;
    end;

    if v23 == false then
        return true;
    end;

    if p18.PrimaryPart and p19.PrimaryPart then
        return (Character.PrimaryPart.Position - p18.PrimaryPart.Position).Magnitude < (Character.PrimaryPart.Position - p19.PrimaryPart.Position).Magnitude;
    end;

    return false;
end;

local function GetHoveredHostage() -- Line: 161
    -- upvalues: CenterScreenRaycast (copy)
    return CenterScreenRaycast.GetHoveredHostage(5);
end;

local function GetHoveredBreakableDoor() -- Line: 165
    -- upvalues: CenterScreenRaycast (copy), CollectionService (copy)
    local v24 = {};
    local v25 = CenterScreenRaycast.FindTaggedAncestor("BreakableDoor", 8);

    if v25 and (v25:IsA("Model") and v25:GetAttribute("Destroyed") ~= true) then
        table.insert(v24, v25);

        for _, v in CollectionService:GetTagged("BreakableDoor") do
            if v ~= v25 and v:GetAttribute("Destroyed") ~= true then
                local BreakableDoorHingePivot = v25:FindFirstChild("BreakableDoorHingePivot");
                local BreakableDoorHingePivot2 = v:FindFirstChild("BreakableDoorHingePivot");

                if BreakableDoorHingePivot and (BreakableDoorHingePivot2 and (BreakableDoorHingePivot.Position - BreakableDoorHingePivot2.Position).Magnitude <= 20) then
                    table.insert(v24, v);
                end;
            end;
        end;
    end;

    return v24;
end;

local function DoesRaycastIntersectSmoke(p26, p27, p28) -- Line: 189
    -- upvalues: Workspace (copy)
    local function RayIntersectsAABB(p29, p30, p31, p32, p33) -- Line: 190
        local v34 = 0;
        local v35, v36;

        if math.abs(p30.X) < 0.0001 then
            if p29.X < p31.X or p29.X > p32.X then
                return false;
            end;

            v35 = p33;
            v36 = v34;
        else
            local v37 = 1 / p30.X;
            v35 = (p31.X - p29.X) * v37;
            v36 = (p32.X - p29.X) * v37;

            if v36 >= v35 then
                local v38 = v35;
                v35 = v36;
                v36 = v38;
            end;

            if v34 >= v36 then
                v36 = v34;
            end;

            if v35 >= p33 then
                v35 = p33;
            end;

            if v35 < v36 then
                return false;
            end;
        end;

        if math.abs(p30.Y) < 0.0001 then
            if p29.Y < p31.Y or p29.Y > p32.Y then
                return false;
            end;
        else
            local v39 = 1 / p30.Y;
            local v40 = (p31.Y - p29.Y) * v39;
            local v41 = (p32.Y - p29.Y) * v39;

            if v41 >= v40 then
                local v42 = v40;
                v40 = v41;
                v41 = v42;
            end;

            if v36 >= v41 then
                v41 = v36;
            end;

            if v40 >= v35 then
                v40 = v35;
            end;

            if v40 < v41 then
                return false;
            end;

            v35 = v40;
            v36 = v41;
        end;

        if math.abs(p30.Z) < 0.0001 then
            if p29.Z < p31.Z or p29.Z > p32.Z then
                return false;
            end;
        else
            local v43 = 1 / p30.Z;
            local v44 = (p31.Z - p29.Z) * v43;
            local v45 = (p32.Z - p29.Z) * v43;

            if v45 >= v44 then
                local v46 = v44;
                v44 = v45;
                v45 = v46;
            end;

            if v36 >= v45 then
                v45 = v36;
            end;

            if v44 >= v35 then
                v44 = v35;
            end;

            if v44 < v45 then
                return false;
            end;

            v36 = v45;
        end;

        local v47;

        if v36 >= 0 then
            v47 = v36 <= p33;
        else
            v47 = false;
        end;

        return v47;
    end;

    local Debris = Workspace:FindFirstChild("Debris");

    if not Debris then
        return false;
    end;

    for _, child in ipairs(Debris:GetChildren()) do
        if child.Name:match("^VoxelSmoke_") and child:IsA("Folder") then
            for _, child2 in ipairs(child:GetChildren()) do
                if child2:IsA("BasePart") and child2.Name == "SmokeVoxel" then
                    local Size = child2.Size;
                    local Position = child2.Position;

                    if RayIntersectsAABB(p26, p27, Position - Size / 2, Position + Size / 2, p28) then
                        return true;
                    end;
                end;
            end;
        end;
    end;

    return false;
end;

local function GetHoveredEnemy(p48) -- Line: 250
    -- upvalues: LocalPlayer (copy), u1 (copy), IsEnemy (copy), DoesRaycastIntersectSmoke (copy)
    if not (workspace.CurrentCamera and LocalPlayer.Character) then
        return nil;
    end;

    u1.FilterDescendantsInstances = { LocalPlayer.Character, workspace.CurrentCamera };
    local CurrentCamera = workspace.CurrentCamera;
    local Position = CurrentCamera.CFrame.Position;
    local v49 = {
        CurrentCamera.CFrame.LookVector,
        (CurrentCamera.CFrame * CFrame.Angles(0.017453292519943295, 0, 0)).LookVector,
        (CurrentCamera.CFrame * CFrame.Angles(-0.017453292519943295, 0, 0)).LookVector,
        (CurrentCamera.CFrame * CFrame.Angles(0, 0.017453292519943295, 0)).LookVector,
        (CurrentCamera.CFrame * CFrame.Angles(0, -0.017453292519943295, 0)).LookVector,
        (CurrentCamera.CFrame * CFrame.Angles(0.012217304763960306, 0.012217304763960306, 0)).LookVector,
        (CurrentCamera.CFrame * CFrame.Angles(0.012217304763960306, -0.012217304763960306, 0)).LookVector,
        (CurrentCamera.CFrame * CFrame.Angles(-0.012217304763960306, 0.012217304763960306, 0)).LookVector,
        (CurrentCamera.CFrame * CFrame.Angles(-0.012217304763960306, -0.012217304763960306, 0)).LookVector
    };

    for _, v in ipairs(v49) do
        local v50 = workspace:Raycast(Position, v * p48, u1);

        if v50 and (IsEnemy(v50.Instance) and not DoesRaycastIntersectSmoke(Position, v, v50.Distance)) then
            return v50.Instance.Parent;
        end;
    end;

    return nil;
end;

local function StartAutoFire() -- Line: 293
    -- upvalues: u6 (ref), u7 (ref), RunServiceController (copy), InventoryController (copy), GetHoveredEnemy (copy), u3 (ref), u4 (ref), u9 (ref), FlashEffect (copy), u8 (copy), u5 (ref)
    if not u6 then
        return;
    end;

    if u7 then
        return;
    end;

    u7 = RunServiceController.BindToRenderStep("InputController.Use.AutoFire", function() -- Line: 301
        -- upvalues: InventoryController (ref), GetHoveredEnemy (ref), u3 (ref), u4 (ref), u9 (ref), FlashEffect (ref), u8 (ref), u5 (ref)
        local v51 = InventoryController.getCurrentEquipped();
        local v52;

        if v51 then
            v52 = v51.Properties.Class == "Weapon";
        else
            v52 = v51;
        end;

        local v53 = GetHoveredEnemy(v52 and v51.IsAiming and (v51.Properties.Range or 180) or 180) ~= nil;

        if not v52 then
            v53 = false;
        end;

        local v54 = tick();

        if v53 then
            if not u3 then
                u3 = v54;
            end;

            if v54 - u3 >= 0.05 and ((not u4 or (v51.Properties.FireRate or 0.15) <= v54 - u4) and (u9 and not FlashEffect.IsFlashed())) then
                u9(Enum.UserInputState.Begin, u8);
                u4 = v54;
            end;
        else
            u3 = nil;
            u4 = nil;

            if u5 and u9 then
                u9(Enum.UserInputState.End, u8);
            end;
        end;

        u5 = v53;
    end);
end;

local function StopAutoFire() -- Line: 374
    -- upvalues: u7 (ref), u5 (ref), u9 (ref), u8 (copy), u3 (ref), u4 (ref)
    if u7 then
        u7:Disconnect();
        u7 = nil;
    end;

    if u5 then
        if u9 then
            u9(Enum.UserInputState.End, u8);
        end;

        u5 = false;
    end;

    u3 = nil;
    u4 = nil;
end;

local function RefreshAutoFire() -- Line: 395
    -- upvalues: u2 (copy), u6 (ref), u9 (ref), u7 (ref), RunServiceController (copy), InventoryController (copy), GetHoveredEnemy (copy), u3 (ref), u4 (ref), FlashEffect (copy), u8 (copy), u5 (ref)
    if not u2 then
        return;
    end;

    if u6 and u9 then
        if not u6 then
            return;
        end;

        if u7 then
            return;
        end;

        u7 = RunServiceController.BindToRenderStep("InputController.Use.AutoFire", function() -- Line: 301
            -- upvalues: InventoryController (ref), GetHoveredEnemy (ref), u3 (ref), u4 (ref), u9 (ref), FlashEffect (ref), u8 (ref), u5 (ref)
            local v55 = InventoryController.getCurrentEquipped();
            local v56;

            if v55 then
                v56 = v55.Properties.Class == "Weapon";
            else
                v56 = v55;
            end;

            local v57 = GetHoveredEnemy(v56 and v55.IsAiming and (v55.Properties.Range or 180) or 180) ~= nil;

            if not v56 then
                v57 = false;
            end;

            local v58 = tick();

            if v57 then
                if not u3 then
                    u3 = v58;
                end;

                if v58 - u3 >= 0.05 and ((not u4 or (v55.Properties.FireRate or 0.15) <= v58 - u4) and (u9 and not FlashEffect.IsFlashed())) then
                    u9(Enum.UserInputState.Begin, u8);
                    u4 = v58;
                end;
            else
                u3 = nil;
                u4 = nil;

                if u5 and u9 then
                    u9(Enum.UserInputState.End, u8);
                end;
            end;

            u5 = v57;
        end);

        return;
    end;

    if u7 then
        u7:Disconnect();
        u7 = nil;
    end;

    if u5 then
        if u9 then
            u9(Enum.UserInputState.End, u8);
        end;

        u5 = false;
    end;

    u3 = nil;
    u4 = nil;
end;

task.defer(function() -- Line: 540
    -- upvalues: u9 (ref), u2 (copy), u6 (ref), u7 (ref), RunServiceController (copy), InventoryController (copy), GetHoveredEnemy (copy), u3 (ref), u4 (ref), FlashEffect (copy), u8 (copy), u5 (ref)
    u9 = require(script.Parent.Fire).Callback;

    if not u2 then
        return;
    end;

    if u6 and u9 then
        if not u6 then
            return;
        end;

        if u7 then
            return;
        end;

        u7 = RunServiceController.BindToRenderStep("InputController.Use.AutoFire", function() -- Line: 301
            -- upvalues: InventoryController (ref), GetHoveredEnemy (ref), u3 (ref), u4 (ref), u9 (ref), FlashEffect (ref), u8 (ref), u5 (ref)
            local v59 = InventoryController.getCurrentEquipped();
            local v60;

            if v59 then
                v60 = v59.Properties.Class == "Weapon";
            else
                v60 = v59;
            end;

            local v61 = GetHoveredEnemy(v60 and v59.IsAiming and (v59.Properties.Range or 180) or 180) ~= nil;

            if not v60 then
                v61 = false;
            end;

            local v62 = tick();

            if v61 then
                if not u3 then
                    u3 = v62;
                end;

                if v62 - u3 >= 0.05 and ((not u4 or (v59.Properties.FireRate or 0.15) <= v62 - u4) and (u9 and not FlashEffect.IsFlashed())) then
                    u9(Enum.UserInputState.Begin, u8);
                    u4 = v62;
                end;
            else
                u3 = nil;
                u4 = nil;

                if u5 and u9 then
                    u9(Enum.UserInputState.End, u8);
                end;
            end;

            u5 = v61;
        end);

        return;
    end;

    if u7 then
        u7:Disconnect();
        u7 = nil;
    end;

    if u5 then
        if u9 then
            u9(Enum.UserInputState.End, u8);
        end;

        u5 = false;
    end;

    u3 = nil;
    u4 = nil;
end);
LocalPlayer.CharacterRemoving:Connect(function() -- Line: 547
    -- upvalues: u2 (copy), u7 (ref), u5 (ref), u9 (ref), u8 (copy), u3 (ref), u4 (ref)
    if not u2 then
        return;
    end;

    if u7 then
        u7:Disconnect();
        u7 = nil;
    end;

    if u5 then
        if u9 then
            u9(Enum.UserInputState.End, u8);
        end;

        u5 = false;
    end;

    u3 = nil;
    u4 = nil;
end);
LocalPlayer.CharacterAdded:Connect(function() -- Line: 555
    -- upvalues: u2 (copy), u6 (ref), u9 (ref), u7 (ref), RunServiceController (copy), InventoryController (copy), GetHoveredEnemy (copy), u3 (ref), u4 (ref), FlashEffect (copy), u8 (copy), u5 (ref)
    if not u2 then
        return;
    end;

    if not u2 then
        return;
    end;

    if u6 and u9 then
        if not u6 then
            return;
        end;

        if u7 then
            return;
        end;

        u7 = RunServiceController.BindToRenderStep("InputController.Use.AutoFire", function() -- Line: 301
            -- upvalues: InventoryController (ref), GetHoveredEnemy (ref), u3 (ref), u4 (ref), u9 (ref), FlashEffect (ref), u8 (ref), u5 (ref)
            local v63 = InventoryController.getCurrentEquipped();
            local v64;

            if v63 then
                v64 = v63.Properties.Class == "Weapon";
            else
                v64 = v63;
            end;

            local v65 = GetHoveredEnemy(v64 and v63.IsAiming and (v63.Properties.Range or 180) or 180) ~= nil;

            if not v64 then
                v65 = false;
            end;

            local v66 = tick();

            if v65 then
                if not u3 then
                    u3 = v66;
                end;

                if v66 - u3 >= 0.05 and ((not u4 or (v63.Properties.FireRate or 0.15) <= v66 - u4) and (u9 and not FlashEffect.IsFlashed())) then
                    u9(Enum.UserInputState.Begin, u8);
                    u4 = v66;
                end;
            else
                u3 = nil;
                u4 = nil;

                if u5 and u9 then
                    u9(Enum.UserInputState.End, u8);
                end;
            end;

            u5 = v65;
        end);

        return;
    end;

    if u7 then
        u7:Disconnect();
        u7 = nil;
    end;

    if u5 then
        if u9 then
            u9(Enum.UserInputState.End, u8);
        end;

        u5 = false;
    end;

    u3 = nil;
    u4 = nil;
end);
DataController.CreateListener(LocalPlayer, "Settings.Game.Other.Mobile Auto Shoot", function(p67) -- Line: 563
    -- upvalues: u6 (ref), u2 (copy), u9 (ref), u7 (ref), RunServiceController (copy), InventoryController (copy), GetHoveredEnemy (copy), u3 (ref), u4 (ref), FlashEffect (copy), u8 (copy), u5 (ref)
    u6 = p67 ~= false;

    if not u2 then
        return;
    end;

    if u6 and u9 then
        if not u6 then
            return;
        end;

        if u7 then
            return;
        end;

        u7 = RunServiceController.BindToRenderStep("InputController.Use.AutoFire", function() -- Line: 301
            -- upvalues: InventoryController (ref), GetHoveredEnemy (ref), u3 (ref), u4 (ref), u9 (ref), FlashEffect (ref), u8 (ref), u5 (ref)
            local v68 = InventoryController.getCurrentEquipped();
            local v69;

            if v68 then
                v69 = v68.Properties.Class == "Weapon";
            else
                v69 = v68;
            end;

            local v70 = GetHoveredEnemy(v69 and v68.IsAiming and (v68.Properties.Range or 180) or 180) ~= nil;

            if not v69 then
                v70 = false;
            end;

            local v71 = tick();

            if v70 then
                if not u3 then
                    u3 = v71;
                end;

                if v71 - u3 >= 0.05 and ((not u4 or (v68.Properties.FireRate or 0.15) <= v71 - u4) and (u9 and not FlashEffect.IsFlashed())) then
                    u9(Enum.UserInputState.Begin, u8);
                    u4 = v71;
                end;
            else
                u3 = nil;
                u4 = nil;

                if u5 and u9 then
                    u9(Enum.UserInputState.End, u8);
                end;
            end;

            u5 = v70;
        end);

        return;
    end;

    if u7 then
        u7:Disconnect();
        u7 = nil;
    end;

    if u5 then
        if u9 then
            u9(Enum.UserInputState.End, u8);
        end;

        u5 = false;
    end;

    u3 = nil;
    u4 = nil;
end);

return table.freeze({
    Category = "Weapon Keys",
    Group = "Gameplay",
    Name = "Use",

    Callback = function(p72, p73) -- Line: 409, Name: onInput
        -- upvalues: LocalPlayer (copy), CollectionService (copy), Router (copy), GetHoveredBreakableDoor (copy), Remotes (copy), CenterScreenRaycast (copy), computePriority (copy), Grenades (copy), GetWeaponProperties (copy), NumberSlots (copy), InventoryController (copy), Skins (copy), Rarities (copy)
        if LocalPlayer:GetAttribute("IsPlayerChatting") then
            return;
        end;

        if not LocalPlayer.Character then
            return;
        end;

        if p72 == Enum.UserInputState.Begin then
            local v74 = CollectionService:GetTagged("Bomb")[1];

            if v74 and (v74:GetAttribute("CanDefuse") and not (v74:GetAttribute("IsGettingDefused") or v74:GetAttribute("Defused"))) then
                Router.broadcastRouter("Start Defuse Bomb");

                return;
            end;

            local v75 = GetHoveredBreakableDoor();

            if #v75 > 0 then
                for _, v in v75 do
                    Remotes.BreakableDoor.Use.Send(v);
                end;

                return;
            end;

            local v76 = CenterScreenRaycast.GetHoveredHostage(5);

            if v76 then
                local v77 = LocalPlayer:GetAttribute("Team");

                if not LocalPlayer:GetAttribute("IsCarryingHostage") and (not LocalPlayer:GetAttribute("IsRescuingHostage") and v77 == "Counter-Terrorists") then
                    local v78 = v76:GetAttribute("RescuingPlayer");
                    local v79 = v76:GetAttribute("CarryingPlayer");

                    if (not v78 or v78 == LocalPlayer.Name) and not v79 then
                        Router.broadcastRouter("Start Rescue Hostage");

                        return;
                    end;
                end;
            end;

            local v80 = CollectionService:GetTagged("IsHoveringInteractable");

            if #v80 == 0 then
                return;
            end;

            table.sort(v80, computePriority);
            local v81 = v80[1];
            local v82 = v81:GetAttribute("Weapon");
            local v83 = v81:GetAttribute("Skin");

            if v82 == "C4" and LocalPlayer:GetAttribute("Team") ~= "Terrorists" then
                return;
            end;

            if Grenades[v82] ~= nil then
                local v84 = GetWeaponProperties(v82);

                if v84 then
                    local v85 = InventoryController.getInventorySlot(NumberSlots[v84.Slot]);

                    if v85 then
                        local v86 = 0;

                        for _, v in ipairs(v85._items) do
                            if v.Name == v82 then
                                v86 = v86 + 1;
                            end;
                        end;

                        if Grenades[v82] <= v86 or #v85._items >= v85._settings._strict_slot_space then
                            return;
                        end;
                    end;
                end;
            end;

            if v81:GetAttribute("CanPickup") then
                local v87 = Skins.GetSkinInformation(v82, v83);

                if v87 then
                    local v88 = Rarities[v87.rarity];
                    local v89 = math.floor(v88.Color.R * 255);
                    local v90 = math.floor(v88.Color.G * 255);
                    local v91 = math.floor(v88.Color.B * 255);
                    Router.broadcastRouter("CreateNotification", "Item Picked Up", `You picked up a <font color = "rgb({v89}, {v90}, {v91})"><b>{v82:find("Zeus") and "Taser" or v82} | {v83}</b></font>`, 2);
                end;

                Remotes.Inventory.PickupWeapon.Send({
                    AllowAutoEquip = true,
                    Identity = v81.Name
                });
            end;
        elseif p72 == Enum.UserInputState.End then
            if CollectionService:GetTagged("Bomb")[1] and (LocalPlayer:GetAttribute("IsDefusingBomb") or LocalPlayer:GetAttribute("IsLocallyDefusingBomb")) then
                Router.broadcastRouter("Cancel Defuse Bomb");

                return;
            end;

            if LocalPlayer:GetAttribute("IsRescuingHostage") then
                Router.broadcastRouter("Cancel Rescue Hostage");
            end;
        end;
    end
});