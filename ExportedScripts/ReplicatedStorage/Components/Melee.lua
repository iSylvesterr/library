-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local HttpService = game:GetService("HttpService");
local Players = game:GetService("Players");
require(ReplicatedStorage.Database.Custom.Types);
require(script:WaitForChild("Types"));
local HapticsController = require(ReplicatedStorage.Controllers.HapticsController);
local SoundController = require(ReplicatedStorage.Controllers.SoundController);
local InputController = require(ReplicatedStorage.Controllers.InputController);
local GetRayIgnore = require(ReplicatedStorage.Components.Common.GetRayIgnore);
local GetCharacterVelocity = require(ReplicatedStorage.Components.Common.GetCharacterVelocity);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local CreateBloodSplatter = require(ReplicatedStorage.Components.Common.VFXLibary.CreateBloodSplatter);
local CreateMarker = require(ReplicatedStorage.Components.Common.VFXLibary.CreateMarker);
local CreateImpact = require(ReplicatedStorage.Components.Common.VFXLibary.CreateImpact);
local BreakGlass = require(ReplicatedStorage.Components.Common.VFXLibary.BreakGlass);
local WeaponComponent = require(ReplicatedStorage.Classes.WeaponComponent);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local LocalPlayer = Players.LocalPlayer;
local CurrentCamera = workspace.CurrentCamera;

local function isPlayer(p2) -- Line: 52
    local v3 = p2 and p2.Parent and p2.Parent:FindFirstChildOfClass("Humanoid");

    return v3;
end;

local function isCurrentEquipped(p4) -- Line: 58
    -- upvalues: HttpService (copy), LocalPlayer (copy)
    return HttpService:JSONDecode(LocalPlayer:GetAttribute("CurrentEquipped") or "[]").Identifier == p4;
end;

local function isBackStab(p5, p6) -- Line: 64
    local HumanoidRootPart = p5:WaitForChild("HumanoidRootPart");
    local HumanoidRootPart2 = p6:WaitForChild("HumanoidRootPart");

    if not (HumanoidRootPart and HumanoidRootPart2) then
        return nil;
    end;

    local v7 = HumanoidRootPart2.CFrame.LookVector:Dot((HumanoidRootPart.Position - HumanoidRootPart2.Position).Unit);
    local v8 = math.acos(v7);

    return math.deg(v8) > 100;
end;

function u1.stopAllAnimations(p9) -- Line: 81
    if not p9.CharacterAnimator then
        return;
    end;

    if not (p9.Viewmodel and p9.Viewmodel.Animation) then
        return;
    end;

    p9.Viewmodel.Animation:cancelCrossfade();

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
end;

function u1.reload(p10) -- Line: 108
    if p10.IsInspecting or p10.IsInspectFadingOut then
        p10:cancelInspect(0.25);
    end;
end;

function u1.shoot(u11, p12) -- Line: 117
    -- upvalues: LocalPlayer (copy), Router (copy), SoundController (copy), GetRayIgnore (copy), CurrentCamera (copy), Remotes (copy), CreateImpact (copy), CreateBloodSplatter (copy), isBackStab (copy), BreakGlass (copy), CreateMarker (copy), HapticsController (copy), HttpService (copy), InputController (copy)
    if tick() - u11.WeaponEquippedTick <= 1 or LocalPlayer:GetAttribute("Dead") then
        return;
    end;

    if not u11.Properties.FireRate then
        return;
    end;

    if u11.IsShooting then
        return;
    end;

    local v13 = u11.Player and u11.Player.Character;

    if not v13 then
        return;
    end;

    if u11.IsInspecting or u11.IsInspectFadingOut then
        u11:cancelInspect(0.25);
    end;

    u11:stopAllAnimations();
    u11.IsInspecting = false;
    u11.IsInspectFadingOut = false;
    u11.IsShooting = true;
    Router.broadcastRouter("UpdatePlayerNoiseCone", "Melee", v13.PrimaryPart.Position, SoundController.GetMeleeRange(u11.Name), nil);
    local v14 = RaycastParams.new();
    v14.FilterType = Enum.RaycastFilterType.Exclude;
    v14.FilterDescendantsInstances = GetRayIgnore();
    v14.IgnoreWater = true;
    local v15 = CurrentCamera.CFrame.LookVector * u11.Properties.Range;
    local Position = CurrentCamera.CFrame.Position;
    local v16 = workspace:Raycast(Position, v15, v14) or workspace:Spherecast(Position, 1.5, v15, v14);
    local v17 = p12 and "Heavy Swing" or `Swing{math.random(1, 2)}`;
    Remotes.Spectate.ReplicateSpectateEvent.Send(v17);

    if v16 then
        local Instance = v16.Instance;
        local Position2 = v16.Position;
        local Material = v16.Material;
        local Normal = v16.Normal;
        local v18 = Instance and Instance.Parent and Instance.Parent:FindFirstChildOfClass("Humanoid");

        if v18 then
            CreateImpact(Instance, "Blood Splatter", Position2, Normal, false, true, true);
            CreateBloodSplatter(Position2, CurrentCamera.CFrame.LookVector);
            v17 = p12 and isBackStab(LocalPlayer.Character, Instance.Parent) and "BackStab" or v17;
        else
            local Parent = Instance.Parent;
            CreateImpact(Instance, Material.Name, Position2, Normal, false, true, true);

            if Parent and Parent:HasTag("BreakableGlass") then
                BreakGlass(Instance, Position2, v15.Unit);
            elseif not (Instance:HasTag("BreakableGlass") or Parent and Parent:HasTag("BreakableGlass")) then
                CreateMarker(Instance, "Melee", Position2, Normal);
            end;
        end;

        Remotes.Melee.MeleeAttack.Send({
            Direction = CurrentCamera.CFrame.LookVector * u11.Properties.Range,
            Material = v16.Material.Name,
            Distance = v16.Distance,
            Instance = v16.Instance,
            Position = v16.Position,
            Normal = v16.Normal,
            MeleeAttack = v17,
            Identifier = u11.Identifier
        });
    end;

    local v19 = u11.Viewmodel.Animation:play(v17);
    local v20 = u11.Properties.FireRate * (p12 and 2.05 or 1);
    HapticsController.vibrate(Enum.VibrationMotor.Small, 1.15, 0.2);
    u11.CharacterAnimator:play((v17 == "Swing1" or v17 == "Swing") and "Swing" or v17);
    task.delay(v20 or (v19 and v19.Length or 0.3), function() -- Line: 236
        -- upvalues: u11 (copy), HttpService (ref), LocalPlayer (ref), InputController (ref)
        if not u11.IsDestroyed then
            u11.IsShooting = false;

            if u11.Identifier ~= HttpService:JSONDecode(LocalPlayer:GetAttribute("CurrentEquipped") or "[]").Identifier then
                return;
            end;

            local v21 = InputController.isActionPressed("Fire", { Enum.UserInputType.MouseButton1, Enum.KeyCode.ButtonR2 }) or u11.IsFireHeld;
            local v22 = InputController.isActionPressed("Secondary Fire", { Enum.UserInputType.MouseButton2, Enum.KeyCode.ButtonL2 });

            if v21 or v22 then
                u11:shoot(v22);
            end;
        end;
    end);
end;

function u1.cancelInspect(u23, p24, p25) -- Line: 264
    if not (u23.IsInspecting or u23.IsInspectFadingOut) then
        return;
    end;

    if u23.InspectDelayThread then
        task.cancel(u23.InspectDelayThread);
        u23.InspectDelayThread = nil;
    end;

    local u26 = p24 or 1.2;
    u23.IsInspectFadingOut = true;
    u23.IsInspecting = false;
    u23.Viewmodel.Animation:markInspectCancel();

    if u23.CancelDelayThread then
        task.cancel(u23.CancelDelayThread);
        u23.CancelDelayThread = nil;
    end;

    if u23.FadeCompleteThread then
        task.cancel(u23.FadeCompleteThread);
        u23.FadeCompleteThread = nil;
    end;

    u23.CancelDelayThread = task.delay(p25 or 0.3, function() -- Line: 300
        -- upvalues: u23 (copy), u26 (copy)
        if u23.IsDestroyed then
            return;
        end;

        if not u23.IsInspectFadingOut then
            return;
        end;

        u23.Viewmodel.Animation:crossfadeTo("Idle", u26);
        u23.FadeCompleteThread = task.delay(u26, function() -- Line: 312
            -- upvalues: u23 (ref)
            if not u23.IsDestroyed then
                u23.FadeCompleteThread = nil;
                u23.IsInspectFadingOut = false;
            end;
        end);
    end);
end;

function u1.inspect(u27) -- Line: 323
    -- upvalues: Remotes (copy)
    if u27.IsShooting then
        return;
    end;

    if u27.IsInspecting and not u27.IsInspectFadingOut then
        return;
    end;

    local v28 = u27.IsInspectFadingOut == true;

    if v28 then
        u27.IsInspectFadingOut = false;

        if u27.CancelDelayThread then
            task.cancel(u27.CancelDelayThread);
            u27.CancelDelayThread = nil;
        end;

        if u27.FadeCompleteThread then
            task.cancel(u27.FadeCompleteThread);
            u27.FadeCompleteThread = nil;
        end;

        u27.Viewmodel.Animation:cancelCrossfade();
    end;

    u27.IsInspecting = true;
    u27.IsShooting = false;

    if u27.InspectDelayThread then
        task.cancel(u27.InspectDelayThread);
        u27.InspectDelayThread = nil;
    end;

    local v29 = u27.Viewmodel.Animation:pickInspectVariant();

    if v28 then
        if not u27.Viewmodel.Animation:crossfadeRestart(v29, 0.25) then
            u27:stopAllAnimations();
            u27.Viewmodel.Animation:play(v29);
        end;

        Remotes.Spectate.ReplicateSpectateEvent.Send(v29);
        local v30 = u27.Viewmodel.Animation:getAnimation(v29);

        if v30 then
            u27.InspectDelayThread = task.delay(v30.Length, function() -- Line: 377
                -- upvalues: u27 (copy)
                if not u27.IsDestroyed then
                    u27.InspectDelayThread = nil;
                    u27.IsInspecting = false;
                end;
            end);
        end;

        return;
    end;

    u27:stopAllAnimations();
    local v31 = u27.Viewmodel.Animation:play(v29);
    Remotes.Spectate.ReplicateSpectateEvent.Send(v29);
    u27.InspectDelayThread = task.delay(v31.Length, function() -- Line: 396
        -- upvalues: u27 (copy)
        if u27.IsDestroyed then
            return;
        end;

        u27.InspectDelayThread = nil;
        u27.IsInspecting = false;
    end);
end;

function u1.drop(p32) -- Line: 407
    -- upvalues: GameState (copy), Remotes (copy), GetCharacterVelocity (copy), LocalPlayer (copy), CurrentCamera (copy)
    if workspace:GetAttribute("Gamemode") == "Deathmatch" then
        return false;
    end;

    if GameState.GetState() == "Warmup" then
        return false;
    end;

    if workspace:GetAttribute("VIPKnifeDropEnabled") ~= true then
        return false;
    end;

    p32:unequip();
    Remotes.Inventory.DropWeapon.Send({
        CharacterVelocity = GetCharacterVelocity(LocalPlayer.Character),
        Direction = CurrentCamera.CFrame.LookVector,
        Identifier = p32.Identifier
    });

    return true;
end;

function u1.equip(p33) -- Line: 431
    p33.Viewmodel.Animation:stopAnimations();
    p33.CharacterAnimator:stopAnimations();
    p33.CharacterAnimator:play("Idle");
    p33.CharacterAnimator:play("Equip");
    p33.WeaponEquippedTick = tick();
    p33.Viewmodel:equip(false);
    p33.IsInspectFadingOut = false;
    p33.IsInspecting = false;
    p33.IsShooting = false;
    p33.IsFireHeld = false;
end;

function u1.unequip(p34) -- Line: 451
    p34.CharacterAnimator:stopAnimations();
    p34.Viewmodel:unequip();
    p34.IsInspectFadingOut = false;
    p34.IsInspecting = false;
    p34.IsShooting = false;
    p34.IsFireHeld = false;
end;

function u1.new(p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47) -- Line: 466
    -- upvalues: WeaponComponent (copy), u1 (copy)
    local v48 = WeaponComponent.new(p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46);
    local v49 = setmetatable(v48, u1);
    v49.IsInspectFadingOut = false;
    v49.IsInspecting = false;
    v49.IsShooting = false;
    v49.IsFireHeld = false;
    v49.InspectDelayThread = nil;
    v49.CancelDelayThread = nil;
    v49.FadeCompleteThread = nil;
    v49.AlternativeSwitchTick = 0;
    v49.WeaponEquippedTick = 0;

    return v49;
end;

function u1.destroy(p50) -- Line: 505
    -- upvalues: WeaponComponent (copy)
    if not p50.IsDestroyed then
        p50.IsDestroyed = true;

        if p50.InspectDelayThread then
            task.cancel(p50.InspectDelayThread);
            p50.InspectDelayThread = nil;
        end;

        if p50.CancelDelayThread then
            task.cancel(p50.CancelDelayThread);
            p50.CancelDelayThread = nil;
        end;

        if p50.FadeCompleteThread then
            task.cancel(p50.FadeCompleteThread);
            p50.FadeCompleteThread = nil;
        end;

        if p50.Janitor then
            p50.Janitor:Destroy();
            p50.Janitor = nil;
        end;

        p50.IsInspectFadingOut = nil;
        p50.IsInspecting = nil;
        p50.IsShooting = nil;
        p50.IsFireHeld = nil;
        p50.AlternativeSwitchTick = nil;
        p50.WeaponEquippedTick = nil;
        WeaponComponent.destroy(p50);
    end;
end;

return u1;