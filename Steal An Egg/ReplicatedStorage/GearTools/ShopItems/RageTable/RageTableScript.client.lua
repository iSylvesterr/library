-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ToolGameplayGuard = require(ReplicatedStorage.Library.Client.ToolGameplayGuard);
local LocalPlayer = Players.LocalPlayer;
local Parent = script.Parent;
local ThrowingTableRemote = Parent:WaitForChild("ThrowingTableRemote");
local anim = require(ReplicatedStorage.Directory.Animations.Pipeline):GetAndSerializeAnimation("rbxassetid://94226315418073").anim;
local u1 = 0;
local u2 = false;

local function getAnimator() -- Line: 21
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChildOfClass("Humanoid");
    end;

    return Character and Character:FindFirstChildOfClass("Animator") or nil;
end;

local function palyThrowAnim() -- Line: 27
    -- upvalues: LocalPlayer (copy), anim (copy)
    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChildOfClass("Humanoid");
    end;

    local v3 = Character and Character:FindFirstChildOfClass("Animator") or nil;

    if not v3 then
        return;
    end;

    local v4 = v3:LoadAnimation(anim);
    v4.Priority = Enum.AnimationPriority.Action;
    v4:Play();
end;

Parent.Activated:Connect(function() -- Line: 38, Name: onActivated
    -- upvalues: u2 (ref), ToolGameplayGuard (copy), Parent (copy), LocalPlayer (copy), u1 (ref), anim (copy), ThrowingTableRemote (copy)
    if u2 then
        return;
    end;

    if not ToolGameplayGuard.CanActivateLocal(Parent) then
        warn("cannot activate");

        return;
    end;

    local Character = LocalPlayer.Character;

    if not Character then
        return;
    end;

    local v5 = Character:FindFirstChildOfClass("Humanoid");

    if not (v5 and (Character:FindFirstChild("UpperTorso") or Character:FindFirstChild("Torso"))) then
        return;
    end;

    if v5.Health <= 0 then
        return;
    end;

    local v6 = tick();

    if v6 - u1 < 8 then
        return;
    end;

    u2 = true;
    u1 = v6;
    warn("rage table activated");
    local Character2 = LocalPlayer.Character;

    if Character2 then
        Character2 = Character2:FindFirstChildOfClass("Humanoid");
    end;

    local v7 = Character2 and Character2:FindFirstChildOfClass("Animator") or nil;

    if v7 then
        local v8 = v7:LoadAnimation(anim);
        v8.Priority = Enum.AnimationPriority.Action;
        v8:Play();
    end;

    ThrowingTableRemote:FireServer();
    task.wait(0.5);
    u2 = false;
end);