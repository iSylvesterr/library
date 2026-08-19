-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local RunService = game:GetService("RunService");
require(ReplicatedStorage.Database.Custom.Types);
require(script:WaitForChild("Types"));
local WeaponComponent = require(ReplicatedStorage.Classes.WeaponComponent);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local GetCharacterVelocity = require(ReplicatedStorage.Components.Common.GetCharacterVelocity);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local CurrentCamera = workspace.CurrentCamera;
local LocalPlayer = game:GetService("Players").LocalPlayer;

local function isCompetitiveFreezeTime() -- Line: 41
    -- upvalues: GameState (copy)
    local v2;

    if workspace:GetAttribute("ServerGamemode") == "Competitive" then
        v2 = GameState.GetState() == "Buy Period";
    else
        v2 = false;
    end;

    return v2;
end;

function u1.stopAllAnimations(p3) -- Line: 49
    if not p3.CharacterAnimator then
        return;
    end;

    if not (p3.Viewmodel and p3.Viewmodel.Animation) then
        return;
    end;

    for i, v in pairs(p3.CharacterAnimator.Animations) do
        if v.IsPlaying and v.Name ~= "Idle" then
            p3.CharacterAnimator:stop(i);
        end;
    end;

    for i, v in pairs(p3.Viewmodel.Animation.Animations) do
        if v.IsPlaying and v.Name ~= "Idle" then
            p3.Viewmodel.Animation:stop(i);
        end;
    end;
end;

function u1.StartThrow(p4) -- Line: 77
    -- upvalues: GameState (copy), LocalPlayer (copy), CurrentCamera (copy), Remotes (copy)
    if p4.IsDestroyed then
        return;
    end;

    local v5;

    if workspace:GetAttribute("ServerGamemode") == "Competitive" then
        v5 = GameState.GetState() == "Buy Period";
    else
        v5 = false;
    end;

    if v5 then
        return;
    end;

    if p4.EquipTime > 0 and tick() - p4.EquipTime < 0.7 then
        return;
    end;

    local v6 = tick();

    if p4.LastThrowTime > 0 and v6 - p4.LastThrowTime < 0.7 then
        return;
    end;

    if p4.ThrowStarted and not p4.ThrowFinished then
        return;
    end;

    if p4.ThrowFinished then
        p4.ThrowFinished = false;
        p4.ThrowStarted = false;

        if p4.Janitor:Get("ThrowGrenadeFinished") then
            p4.Janitor:Remove("ThrowGrenadeFinished");
        end;

        if p4.Janitor:Get("ThrowGrenadeStoppedFallback") then
            p4.Janitor:Remove("ThrowGrenadeStoppedFallback");
        end;
    end;

    local v7 = tick();

    if p4.LastThrowTime > 0 and v7 - p4.LastThrowTime < 0.7 then
        return;
    end;

    if LocalPlayer and (LocalPlayer.Character and LocalPlayer.Character:GetAttribute("Dead")) then
        return;
    end;

    p4.ThrowStarted = true;

    if not p4.Viewmodel then
        return;
    end;

    if p4.Viewmodel.IsDestroyed then
        return;
    end;

    if not p4.Viewmodel.Model then
        return;
    end;

    if p4.Viewmodel.Model.Parent ~= CurrentCamera then
        if p4.Viewmodel.IsDestroyed or not p4.Viewmodel.equip then
            return;
        end;

        p4.Viewmodel:equip(false);
    end;

    if p4.Viewmodel.Hidden then
        p4.Viewmodel:unhide();
    end;

    local v8 = tick();

    if p4.LastThrowTime > 0 and v8 - p4.LastThrowTime < 0.7 then
        p4.ThrowStarted = false;

        return;
    end;

    if p4.Viewmodel.IsDestroyed then
        return;
    end;

    local Equip = p4.Viewmodel.Animation.Animations.Equip;

    if Equip then
        Equip = Equip.IsPlaying;
    end;

    if Equip then
        for i, v in pairs(p4.Viewmodel.Animation.Animations) do
            if v.IsPlaying and (v.Name ~= "Idle" and v.Name ~= "Equip") then
                p4.Viewmodel.Animation:stop(i);
            end;
        end;

        for i, v in pairs(p4.CharacterAnimator.Animations) do
            if v.IsPlaying and (v.Name ~= "Idle" and v.Name ~= "Equip") then
                p4.CharacterAnimator:stop(i);
            end;
        end;
    else
        p4:stopAllAnimations();
    end;

    p4.CharacterAnimator:play("StartThrow");
    p4.CharacterAnimator:play("ThrowIdle");

    if p4.Viewmodel and (not p4.Viewmodel.IsDestroyed and (p4.Viewmodel.Model and p4.Viewmodel.Model.Parent == CurrentCamera)) then
        local v9 = p4.Viewmodel.Animation:play("ThrowIdle");
        p4.Viewmodel.Animation:play("StartThrow");
        Remotes.Spectate.ReplicateSpectateEvent.Send("StartThrow");

        if v9 then
            v9.Looped = true;
        end;
    end;
end;

function u1.Throw(u10, u11) -- Line: 229
    -- upvalues: GameState (copy), LocalPlayer (copy), CurrentCamera (copy), RunService (copy), Remotes (copy), GetCharacterVelocity (copy)
    if u10.ThrowFinished then
        return;
    end;

    local v12;

    if workspace:GetAttribute("ServerGamemode") == "Competitive" then
        v12 = GameState.GetState() == "Buy Period";
    else
        v12 = false;
    end;

    if v12 then
        if u10.ThrowStarted and not u10.ThrowFinished then
            u10:Cancel();
        end;

        return;
    end;

    if LocalPlayer and (LocalPlayer.Character and LocalPlayer.Character:GetAttribute("Dead")) then
        return;
    end;

    if not u10.Viewmodel or (u10.Viewmodel.IsDestroyed or not u10.Viewmodel.Model) then
        u10.ThrowStarted = false;

        return;
    end;

    if u10.Viewmodel.Model.Parent ~= CurrentCamera then
        if u10.Viewmodel.IsDestroyed or not u10.Viewmodel.equip then
            u10.ThrowStarted = false;

            return;
        end;

        u10.Viewmodel:equip(false);
        RunService.Heartbeat:Wait();

        if u10.Viewmodel.Model.Parent ~= CurrentCamera then
            u10.ThrowStarted = false;

            return;
        end;
    end;

    if u10.Viewmodel.Hidden then
        u10.Viewmodel:unhide();
    end;

    if not u10.Viewmodel.Animation then
        u10.ThrowStarted = false;

        return;
    end;

    if u10.Janitor:Get("ThrowGrenadeFinished") then
        u10.Janitor:Remove("ThrowGrenadeFinished");
    end;

    if u10.Janitor:Get("ThrowGrenadeStoppedFallback") then
        u10.Janitor:Remove("ThrowGrenadeStoppedFallback");
    end;

    local Equip = u10.Viewmodel.Animation.Animations.Equip;

    if Equip then
        Equip = Equip.IsPlaying;
    end;

    if Equip then
        u10.Viewmodel.Animation:stop("Equip");
        u10.CharacterAnimator:stop("Equip");

        for i, v in pairs(u10.Viewmodel.Animation.Animations) do
            if v.IsPlaying and v.Name ~= "Idle" then
                u10.Viewmodel.Animation:stop(i);
            end;
        end;

        for i, v in pairs(u10.CharacterAnimator.Animations) do
            if v.IsPlaying and v.Name ~= "Idle" then
                u10.CharacterAnimator:stop(i);
            end;
        end;

        RunService.Heartbeat:Wait();
    else
        if u10.Viewmodel.Animation.Animations.StartThrow then
            u10.Viewmodel.Animation:stop("StartThrow");
        end;

        if u10.Viewmodel.Animation.Animations.ThrowIdle then
            u10.Viewmodel.Animation:stop("ThrowIdle");
        end;

        if u10.CharacterAnimator.Animations.StartThrow then
            u10.CharacterAnimator:stop("StartThrow");
        end;

        if u10.CharacterAnimator.Animations.ThrowIdle then
            u10.CharacterAnimator:stop("ThrowIdle");
        end;
    end;

    if not u10.Viewmodel or (u10.Viewmodel.IsDestroyed or not u10.Viewmodel.Animation) then
        u10.ThrowStarted = false;

        return;
    end;

    local v13 = u10.Viewmodel.Animation:play(u11);

    if not v13 then
        u10.ThrowStarted = false;

        return;
    end;

    local v14 = tick();

    while v13.Length == 0 and tick() - v14 < 0.5 do
        RunService.Heartbeat:Wait();
    end;

    if u10.IsDestroyed or (not u10.Viewmodel or u10.Viewmodel.IsDestroyed) then
        u10.ThrowStarted = false;

        return;
    end;

    u10.CharacterAnimator:play("Throw");
    Remotes.Spectate.ReplicateSpectateEvent.Send("Throw");
    u10.ThrowCompleted = false;

    local function completeThrow() -- Line: 373
        -- upvalues: u10 (copy), LocalPlayer (ref), GetCharacterVelocity (ref), Remotes (ref), CurrentCamera (ref), u11 (copy)
        if u10.ThrowCompleted then
            return;
        end;

        u10.ThrowCompleted = true;

        if u10.IsDestroyed or not u10.Identifier then
            return;
        end;

        u10.ThrowFinished = true;
        u10.ThrowStarted = false;
        u10.LastThrowTime = tick();
        local Character = LocalPlayer.Character;
        local v15 = GetCharacterVelocity(Character);

        if Character then
            Character = Character:FindFirstChildOfClass("Humanoid");
        end;

        local v16;

        if Character == nil then
            v16 = false;
        else
            v16 = Character:GetAttribute("Crouching") == true;
        end;

        Remotes.Inventory.ThrowGrenade.Send({
            Direction = CurrentCamera.CFrame.LookVector,
            Position = CurrentCamera.CFrame.Position,
            Identifier = u10.Identifier,
            Animation = u11,
            CharacterVelocity = v15,
            IsCrouching = v16
        });
    end;

    if not (v13 and v13.IsPlaying) then
        u10.ThrowStarted = false;

        return;
    end;

    u10.Janitor:Add(v13:GetMarkerReachedSignal("Throw"):Once(function() -- Line: 409
        -- upvalues: completeThrow (copy)
        completeThrow();
    end), "Disconnect", "ThrowGrenadeFinished");
    u10.Janitor:Add(v13.Stopped:Once(function() -- Line: 414
        -- upvalues: u10 (copy), completeThrow (copy)
        task.delay(0.05, function() -- Line: 416
            -- upvalues: u10 (ref), completeThrow (ref)
            if not (u10.ThrowCompleted or u10.IsDestroyed) then
                completeThrow();
            end;
        end);
    end), "Disconnect", "ThrowGrenadeStoppedFallback");

    if v13.Length > 0 then
        local u17 = task.delay(v13.Length * 0.7, function() -- Line: 426
            -- upvalues: u10 (copy), completeThrow (copy)
            if not u10.ThrowCompleted and (not u10.IsDestroyed and (u10.ThrowStarted and not u10.ThrowFinished)) then
                completeThrow();
            end;
        end);
        u10.Janitor:Add(function() -- Line: 431
            -- upvalues: u17 (copy)
            task.cancel(u17);
        end, false, "ThrowGrenadeDelayFallback2");
    end;

    local u18 = task.delay(2, function() -- Line: 437
        -- upvalues: u10 (copy), completeThrow (copy)
        if not u10.ThrowCompleted and (not u10.IsDestroyed and (u10.ThrowStarted and not u10.ThrowFinished)) then
            completeThrow();
        end;
    end);
    u10.Janitor:Add(function() -- Line: 442
        -- upvalues: u18 (copy)
        task.cancel(u18);
    end, false, "ThrowGrenadeDelayFallback3");
end;

function u1.Cancel(p19) -- Line: 454
    -- upvalues: Remotes (copy)
    if p19.ThrowFinished then
        return;
    end;

    if p19.Janitor:Get("ThrowGrenadeFinished") then
        p19.Janitor:Remove("ThrowGrenadeFinished");
    end;

    if p19.Janitor:Get("ThrowGrenadeStoppedFallback") then
        p19.Janitor:Remove("ThrowGrenadeStoppedFallback");
    end;

    if p19.Janitor:Get("ThrowGrenadeDelayFallback2") then
        p19.Janitor:Remove("ThrowGrenadeDelayFallback2");
    end;

    if p19.Janitor:Get("ThrowGrenadeDelayFallback3") then
        p19.Janitor:Remove("ThrowGrenadeDelayFallback3");
    end;

    p19.ThrowFinished = false;
    p19.ThrowStarted = false;
    p19.ThrowCompleted = false;
    p19:stopAllAnimations();
    Remotes.Spectate.ReplicateSpectateEvent.Send("CancelThrow");
end;

function u1.inspect(u20) -- Line: 490
    -- upvalues: Remotes (copy)
    if u20.IsInspecting then
        return;
    end;

    if u20.ThrowStarted and not u20.ThrowFinished then
        u20:Cancel();
    end;

    u20.IsInspecting = true;
    u20:stopAllAnimations();
    local v21 = u20.Viewmodel.Animation:play("Inspect");
    Remotes.Spectate.ReplicateSpectateEvent.Send("Inspect");
    task.delay(v21.Length, function() -- Line: 512
        -- upvalues: u20 (copy)
        u20.IsInspecting = false;
    end);
end;

function u1.reload(p22) -- Line: 519
end;

function u1.drop(p23) -- Line: 525
    -- upvalues: GameState (copy), Remotes (copy), GetCharacterVelocity (copy), LocalPlayer (copy), CurrentCamera (copy)
    if workspace:GetAttribute("Gamemode") == "Deathmatch" then
        return false;
    end;

    if GameState.GetState() == "Warmup" then
        return false;
    end;

    if not p23.Properties.Droppable then
        return false;
    end;

    p23:unequip();
    Remotes.Inventory.DropWeapon.Send({
        CharacterVelocity = GetCharacterVelocity(LocalPlayer.Character),
        Direction = CurrentCamera.CFrame.LookVector,
        Identifier = p23.Identifier
    });

    return true;
end;

function u1.equip(u24) -- Line: 549
    -- upvalues: GameState (copy), UserInputService (copy)
    u24.EquipTime = tick();

    if u24.Janitor:Get("EquipDelayThrow") then
        u24.Janitor:Remove("EquipDelayThrow");
    end;

    u24.Viewmodel.Animation:stopAnimations();
    u24.CharacterAnimator:stopAnimations();
    u24.ThrowStarted = false;
    u24.ThrowFinished = false;
    u24.ThrowCompleted = false;
    u24.CharacterAnimator:play("Idle");
    u24.CharacterAnimator:play("Equip");
    u24.Viewmodel:equip(false);
    local u25 = task.delay(0.7, function() -- Line: 567
        -- upvalues: u24 (copy), GameState (ref), UserInputService (ref)
        if u24.IsDestroyed then
            return;
        end;

        if GameState.GetState() == "Buy Period" then
            return;
        end;

        if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or UserInputService:IsKeyDown(Enum.KeyCode.ButtonR2) then
            u24:StartThrow();
        end;
    end);
    u24.Janitor:Add(function() -- Line: 576
        -- upvalues: u25 (copy)
        task.cancel(u25);
    end, false, "EquipDelayThrow");
end;

function u1.unequip(p26) -- Line: 581
    if p26.Janitor:Get("EquipDelayThrow") then
        p26.Janitor:Remove("EquipDelayThrow");
    end;

    p26.CharacterAnimator:stopAnimations();
    p26.Viewmodel:unequip();
    p26.IsInspecting = false;

    if not p26.ThrowStarted or p26.ThrowFinished then
        return;
    end;

    p26:Cancel();
end;

function u1.new(p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39) -- Line: 601
    -- upvalues: WeaponComponent (copy), u1 (copy)
    local v40 = WeaponComponent.new(p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38);
    local v41 = setmetatable(v40, u1);
    v41.IsInspecting = false;
    v41.ThrowStarted = false;
    v41.ThrowFinished = false;
    v41.ThrowCompleted = false;
    v41.LastThrowTime = 0;
    v41.EquipTime = 0;

    return v41;
end;

function u1.destroy(p42) -- Line: 633
    -- upvalues: WeaponComponent (copy)
    if not p42.IsDestroyed then
        p42.IsDestroyed = true;

        if p42.Janitor then
            p42.Janitor:Destroy();
            p42.Janitor = nil;
        end;

        p42.ThrowFinished = nil;
        p42.ThrowStarted = nil;
        p42.ThrowCompleted = nil;
        p42.IsInspecting = nil;
        WeaponComponent.destroy(p42);
    end;
end;

return u1;