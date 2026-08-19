-- Decompiled with Potassium's decompiler.

local Parent = script.Parent;
local u1 = Parent:GetAttribute("Owner");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerScriptService = game:GetService("ServerScriptService");
local GameplayToolGuard = require(ServerScriptService.Library.Tools.Internal.GameplayToolGuard);
local Ragdoll = require(ReplicatedStorage.Library.Modules.Ragdoll);
local Network = require(ServerScriptService.Library.Network);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local Audio = require(ReplicatedStorage.Library.Audio);
local SubspaceMine = require(ReplicatedStorage.Directory.Gears._Index.Other.SubspaceMine);
local TRIGGER_RADIUS = SubspaceMine.TRIGGER_RADIUS;
local RAGDOLL_DURATION = SubspaceMine.RAGDOLL_DURATION;
local FADE_DURATION = SubspaceMine.FADE_DURATION;
local SubspaceMine2 = Constants.NETWORK_MAP.SubspaceMine;
local IMPULSE_STRENGTH = SubspaceMine.IMPULSE_STRENGTH;
local u2 = false;
local u3 = nil;
Parent.CanTouch = true;
(function() -- Line: 30, Name: fadeToInvisible
    -- upvalues: FADE_DURATION (copy), Parent (copy)
    local v4 = tick();

    while tick() - v4 < FADE_DURATION and (Parent and Parent.Parent) do
        Parent.Transparency = (tick() - v4) / FADE_DURATION;
        task.wait(0.05);
    end;

    if Parent and Parent.Parent then
        Parent.Transparency = 1;
    end;
end)();

local function getCharacterFromPart(p5) -- Line: 45
    while p5 and p5 ~= workspace do
        if p5:IsA("Model") and p5:FindFirstChildOfClass("Humanoid") then
            return p5;
        end;

        p5 = p5.Parent;
    end;

    return nil;
end;

local function applyEffectToPlayer(p6, p7) -- Line: 59
    -- upvalues: Network (copy), SubspaceMine2 (copy), RAGDOLL_DURATION (copy), GameplayToolGuard (copy), IMPULSE_STRENGTH (copy), Ragdoll (copy)
    local v8 = p6:FindFirstChildOfClass("Humanoid");
    local v9 = p6:FindFirstChild("HumanoidRootPart") or p6.PrimaryPart;

    if not v8 or (v8.Health <= 0 or not (v9 and v9:IsA("BasePart"))) then
        return;
    end;

    Network.FireAll(SubspaceMine2.APPLY_HIGHLIGHT, p7, RAGDOLL_DURATION);
    GameplayToolGuard.DropHeldEggFromPlayerHit(p7);
    local v10 = Vector3.new(0, IMPULSE_STRENGTH, 0) * v9.AssemblyMass;
    Ragdoll.TimedRagdoll(p6, RAGDOLL_DURATION, v10);
end;

local function activateTrap() -- Line: 74
    -- upvalues: u2 (ref), Parent (copy), u3 (ref), Audio (copy), Players (copy), u1 (copy), TRIGGER_RADIUS (copy), GameplayToolGuard (copy), applyEffectToPlayer (copy), RAGDOLL_DURATION (copy)
    if u2 or not Parent.Parent then
        return;
    end;

    u2 = true;

    if u3 then
        u3:Disconnect();
        u3 = nil;
    end;

    task.spawn(Audio.Play, 9126102254, Parent.Position, { 0.9, 1.1 }, 0.7, 60);
    Parent.Transparency = 1;
    Parent.CanCollide = false;
    Parent.CanTouch = false;
    local v11 = {};

    for _, v in Players:GetPlayers() do
        if v.Name ~= u1 and v.Character then
            local Character = v.Character;
            local v12 = Character:FindFirstChildOfClass("Humanoid");
            local v13 = Character:FindFirstChild("HumanoidRootPart") or Character.PrimaryPart;

            if v12 and (v12.Health > 0 and (v13 and (v13:IsA("BasePart") and (v13.Position - Parent.Position).Magnitude <= TRIGGER_RADIUS))) then
                table.insert(v11, Character);
            end;
        end;
    end;

    for _, v in v11 do
        local v14 = Players:GetPlayerFromCharacter(v);

        if v14 and GameplayToolGuard.IsPlayerInGameplayArea(v14) then
            applyEffectToPlayer(v, v14);
        end;
    end;

    task.delay(RAGDOLL_DURATION + 0.5, function() -- Line: 115
        -- upvalues: Parent (ref)
        if Parent and Parent.Parent then
            Parent:Destroy();
        end;
    end);
end;

local function checkForTargetsNearby() -- Line: 122
    -- upvalues: u2 (ref), Parent (copy), Players (copy), u1 (copy), TRIGGER_RADIUS (copy), GameplayToolGuard (copy)
    if u2 or not Parent.Parent then
        return false;
    end;

    for _, v in Players:GetPlayers() do
        if v.Name ~= u1 and v.Character then
            local Character = v.Character;
            local v15 = Character:FindFirstChildOfClass("Humanoid");
            local v16 = Character:FindFirstChild("HumanoidRootPart") or Character.PrimaryPart;

            if v15 and (v15.Health > 0 and (v16 and (v16:IsA("BasePart") and ((v16.Position - Parent.Position).Magnitude <= TRIGGER_RADIUS and GameplayToolGuard.IsPlayerInGameplayArea(v))))) then
                return true;
            end;
        end;
    end;

    return false;
end;

u3 = Parent.Touched:Connect(function(p17) -- Line: 145, Name: onTouched
    -- upvalues: u2 (ref), Parent (copy), getCharacterFromPart (copy), Players (copy), u1 (copy), GameplayToolGuard (copy), checkForTargetsNearby (copy), activateTrap (copy)
    if u2 or not Parent.Parent then
        return;
    end;

    if not p17 or p17:IsDescendantOf(Parent) then
        return;
    end;

    local v18 = getCharacterFromPart(p17);

    if not v18 then
        return;
    end;

    local v19 = Players:GetPlayerFromCharacter(v18);

    if v19 and v19.Name == u1 then
        return;
    end;

    if not (v19 and GameplayToolGuard.IsPlayerInGameplayArea(v19)) then
        return;
    end;

    local v20 = v18:FindFirstChildOfClass("Humanoid");

    if not v20 or v20.Health <= 0 then
        return;
    end;

    if checkForTargetsNearby() then
        activateTrap();
    end;
end);