-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local LocalPlayer = Players.LocalPlayer;
local WeaponComponent = require(ReplicatedStorage.Classes.WeaponComponent);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local GetCharacterVelocity = require(ReplicatedStorage.Components.Common.GetCharacterVelocity);
require(ReplicatedStorage.Classes.Sound);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local CurrentCamera = workspace.CurrentCamera;
local Debris = workspace:WaitForChild("Debris");
local u2 = nil;
local u3 = RaycastParams.new();
u3.FilterType = Enum.RaycastFilterType.Exclude;
u3.IgnoreWater = true;

local function IsCharacterAlive(p4) -- Line: 51
    if p4 and p4:IsDescendantOf(workspace) then
        local Humanoid = p4:FindFirstChild("Humanoid");

        if Humanoid and Humanoid.Health > 0 then
            return true;
        end;
    end;

    return false;
end;

local function PlayerCanPlantC4() -- Line: 63
    -- upvalues: LocalPlayer (copy), CurrentCamera (copy), Debris (copy), Players (copy), u3 (copy)
    local Character = LocalPlayer.Character;
    local v5;

    if Character and Character:IsDescendantOf(workspace) then
        local Humanoid = Character:FindFirstChild("Humanoid");
        v5 = Humanoid and Humanoid.Health > 0 and true or false;
    else
        v5 = false;
    end;

    if v5 then
        local Humanoid = Character:FindFirstChild("Humanoid");

        if Humanoid then
            local v6 = Humanoid:GetState();

            if v6 == Enum.HumanoidStateType.Freefall or v6 == Enum.HumanoidStateType.Jumping then
                return false;
            end;
        end;

        local PrimaryPart = Character.PrimaryPart;

        if PrimaryPart and PrimaryPart.Position then
            local v7 = { CurrentCamera, Debris };

            for _, v in ipairs(Players:GetPlayers()) do
                if v.Character then
                    table.insert(v7, v.Character);
                end;
            end;

            u3.FilterDescendantsInstances = v7;
            local v8 = workspace:Raycast(PrimaryPart.Position, Vector3.new(-0, -5, -0), u3);

            if v8 then
                local Instance = v8.Instance;

                if Instance:HasTag("PlantArea") and Instance:GetAttribute("Site") then
                    return true;
                end;
            end;
        end;
    end;

    return false;
end;

function u1.stopAllAnimations(p9) -- Line: 106
    if not p9.CharacterAnimator then
        return;
    end;

    if not (p9.Viewmodel and p9.Viewmodel.Animation) then
        return;
    end;

    for i, v in pairs(p9.CharacterAnimator.Animations) do
        if v.IsPlaying and v.Name ~= "Idle" then
            p9.CharacterAnimator:stop(i);
        end;
    end;

    for i, v in pairs(p9.Viewmodel.Animation.Animations) do
        if v.IsPlaying and v.Name ~= "Idle" then
            p9.Viewmodel.Animation:stop(i);
        end;
    end;

    p9.Viewmodel.Animation:stopSounds();
end;

function u1.reload(p10) -- Line: 132
end;

function u1.shoot(u11) -- Line: 138
    -- upvalues: PlayerCanPlantC4 (copy), Remotes (copy), Router (copy)
    if u11.IsPlanting then
        return;
    end;

    if u11.Janitor:Get("BombAnimationEnded") then
        u11.Janitor:Remove("BombAnimationEnded");
    end;

    if PlayerCanPlantC4() then
        u11.IsInspecting = false;
        u11.IsPlanting = true;
        u11.PlantStartedTick = tick();
        u11:stopAllAnimations();
        Remotes.Spectate.ReplicateSpectateEvent.Send("Use");
        local v12 = u11.Viewmodel.Animation:play("Use");
        Remotes.Spectate.ReplicateSpectateEvent.Send("Use");
        u11.CharacterAnimator:play("Use");
        Remotes.C4.Start.Send(u11.Identifier);
        Router.broadcastRouter("Plant Bomb");
        u11.Janitor:Add(v12.Ended:Connect(function() -- Line: 176
            -- upvalues: u11 (copy), PlayerCanPlantC4 (ref), Remotes (ref), Router (ref)
            if not u11.IsPlanting then
                return;
            end;

            if PlayerCanPlantC4() then
                Remotes.C4.Planted.Send(u11.Identifier);
                u11.IsPlanting = false;
            end;

            Router.broadcastRouter("Cancel Bomb Plant");
        end), "Disconnect", "BombAnimationEnded");
    end;
end;

function u1.cancel(p13) -- Line: 194
    -- upvalues: Remotes (copy), Router (copy)
    if p13.IsPlanting then
        p13.Viewmodel.Model.Weapon.Interactive.SurfaceGui.TextLabel.Text = "*******";
        p13.IsPlanting = false;
        p13:stopAllAnimations();
        Remotes.Spectate.ReplicateSpectateEvent.Send("Cancel Plant");
        Remotes.C4.Cancel.Send(p13.Identifier);
        Router.broadcastRouter("Cancel Bomb Plant");

        if p13.Janitor:Get("BombAnimationEnded") then
            p13.Janitor:Remove("BombAnimationEnded");
        end;
    end;
end;

function u1.inspect(u14) -- Line: 222
    -- upvalues: Remotes (copy)
    if u14.IsInspecting or u14.IsPlanting then
        return;
    end;

    u14.IsInspecting = true;
    u14:stopAllAnimations();
    local v15 = u14.Viewmodel.Animation:play("Inspect");
    Remotes.Spectate.ReplicateSpectateEvent.Send("Inspect");
    task.delay(v15.Length, function() -- Line: 239
        -- upvalues: u14 (copy)
        u14.IsInspecting = false;
    end);
end;

function u1.drop(p16) -- Line: 246
    -- upvalues: GameState (copy), Remotes (copy), GetCharacterVelocity (copy), LocalPlayer (copy), CurrentCamera (copy)
    if workspace:GetAttribute("Gamemode") == "Deathmatch" then
        return false;
    end;

    if GameState.GetState() == "Warmup" then
        return false;
    end;

    if p16.IsPlanting then
        return false;
    end;

    if not p16.Properties.Droppable then
        return false;
    end;

    p16:unequip();
    Remotes.Inventory.DropWeapon.Send({
        CharacterVelocity = GetCharacterVelocity(LocalPlayer.Character),
        Direction = CurrentCamera.CFrame.LookVector,
        Identifier = p16.Identifier
    });

    return true;
end;

function u1.equip(p17) -- Line: 275
    -- upvalues: u2 (ref)
    p17.Viewmodel.Animation:stopAnimations();
    p17.CharacterAnimator:stopAnimations();
    p17.CharacterAnimator:play("Idle");
    p17.CharacterAnimator:play("Equip");
    p17.Viewmodel:equip(false);
    u2 = p17;
end;

function u1.unequip(p18) -- Line: 286
    -- upvalues: u2 (ref)
    if p18.IsPlanting then
        p18:cancel();
    end;

    p18.CharacterAnimator:stopAnimations();
    p18.Viewmodel:unequip();

    if u2 and u2 == p18 then
        u2 = nil;
    end;
end;

function u1.new(p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31) -- Line: 303
    -- upvalues: WeaponComponent (copy), u1 (copy), RunServiceController (copy), PlayerCanPlantC4 (copy)
    local v32 = WeaponComponent.new(p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30);
    local u33 = setmetatable(v32, u1);
    u33.IsInspecting = false;
    u33.IsPlanting = false;
    u33.PlantStartedTick = 0;
    u33.Janitor:Add(RunServiceController.BindToHeartbeat(`Components.C4.{p20}.PlantValidation`, function(p34) -- Line: 328
        -- upvalues: u33 (copy), PlayerCanPlantC4 (ref)
        if not u33.IsPlanting or PlayerCanPlantC4() then
            return;
        end;

        u33:cancel();
    end));

    return u33;
end;

function u1.destroy(p35) -- Line: 348
    -- upvalues: u2 (ref), WeaponComponent (copy)
    if not p35.IsDestroyed then
        p35.IsDestroyed = true;

        if p35.IsPlanting then
            p35:cancel();
        end;

        if u2 and u2 == p35 then
            u2 = nil;
        end;

        if p35.Janitor then
            p35.Janitor:Destroy();
            p35.Janitor = nil;
        end;

        p35.PlantStartedTick = nil;
        p35.IsInspecting = nil;
        p35.IsPlanting = nil;
        WeaponComponent.destroy(p35);
    end;
end;

Remotes.C4.ForceCancel.Listen(function() -- Line: 383
    -- upvalues: u2 (ref)
    if not (u2 and u2.IsPlanting) then
        return;
    end;

    u2:cancel();
end);

return u1;