-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local Character = require(ReplicatedStorage.Classes.Character);
local Sound = require(ReplicatedStorage.Classes.Sound);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
require(ReplicatedStorage.Controllers.CameraController);
local CaseSceneController = require(ReplicatedStorage.Controllers.CaseSceneController);
local CharacterKinematics = require(ReplicatedStorage.Controllers.Observers.Character.Components.CharacterKinematics);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController);
local LocalPlayer = Players.LocalPlayer;
local PlayerModule = require(LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"));
local CurrentCamera = workspace.CurrentCamera;
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = false;

local function resetMovementInputState() -- Line: 46
    -- upvalues: PlayerModule (copy)
    local v8 = PlayerModule:GetControls();

    if v8 then
        v8 = v8.activeController;
    end;

    if not v8 then
        return;
    end;

    v8.moveVector = Vector3.new(0, 0, 0);
    v8.backwardValue = 0;
    v8.forwardValue = 0;
    v8.rightValue = 0;
    v8.leftValue = 0;
end;

local function recoverCharacterControllerIfDesynced() -- Line: 59
    -- upvalues: u2 (ref), LocalPlayer (copy), u1 (copy)
    if u2 then
        return;
    end;

    local Character2 = LocalPlayer.Character;

    if not (Character2 and Character2:IsDescendantOf(workspace)) then
        return;
    end;

    local v9 = Character2:FindFirstChildOfClass("Humanoid");

    if not v9 or v9.Health <= 0 then
        return;
    end;

    if Character2:GetAttribute("Dead") == true then
        return;
    end;

    u1.characterAdded(Character2);
end;

function u1.getCurrentCharacter() -- Line: 80
    -- upvalues: u2 (ref)
    return u2;
end;

function u1.GetWalkState() -- Line: 84
    -- upvalues: u2 (ref)
    return u2 and u2.IsWalking;
end;

function u1.GetCrouchState() -- Line: 88
    -- upvalues: u2 (ref)
    return u2 and u2.IsCrouching;
end;

function u1.walk(p10) -- Line: 94
    -- upvalues: u2 (ref)
    if u2 then
        u2:ToggleWalkState(p10);
    end;
end;

function u1.crouch(p11) -- Line: 100
    -- upvalues: u2 (ref)
    if u2 then
        u2:ToggleCrouchInput(p11);
    end;
end;

function u1.PlantBomb() -- Line: 108
    -- upvalues: u2 (ref)
    if u2 then
        u2:PlantBomb();
    end;
end;

function u1.CancelBombPlant() -- Line: 114
    -- upvalues: u2 (ref)
    if u2 then
        u2:CancelBombPlant();
    end;
end;

function u1.jump() -- Line: 122
    -- upvalues: u2 (ref), LocalPlayer (copy)
    if u2 then
        u2.IsJumpRequested = true;
        u2:Jump();

        return;
    end;

    local Character2 = LocalPlayer.Character;

    if Character2 then
        local v12 = Character2:FindFirstChildOfClass("Humanoid");

        if v12 and v12.Health > 0 then
            v12.Jump = true;
        end;
    end;
end;

function u1.characterAdded(u13) -- Line: 141
    -- upvalues: u2 (ref), CaseSceneController (copy), PlayerModule (copy), CurrentCamera (copy), LocalPlayer (copy), u5 (ref), u3 (ref), u6 (ref), u4 (ref), u7 (ref), Character (copy), InventoryController (copy), Remotes (copy)
    if u2 then
        u2:Destroy();
        u2 = nil;
    end;

    local v14 = CaseSceneController.IsActive();
    local HumanoidRootPart = u13:WaitForChild("HumanoidRootPart", 20);
    local v15 = u13:FindFirstChildOfClass("Humanoid");

    if not v15 then
        local v16 = tick();

        repeat
            task.wait(0.1);
            v15 = u13:FindFirstChildOfClass("Humanoid");
        until v15 or tick() - v16 > 20;
    end;

    if not (u13:IsDescendantOf(workspace) and v15) then
        return;
    end;

    HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
    HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
    local v17 = PlayerModule:GetControls();

    if v17 then
        v17 = v17.activeController;
    end;

    if v17 then
        v17.moveVector = Vector3.new(0, 0, 0);
        v17.backwardValue = 0;
        v17.forwardValue = 0;
        v17.rightValue = 0;
        v17.leftValue = 0;
    end;

    if not v14 then
        CurrentCamera.CameraType = Enum.CameraType.Custom;
        CurrentCamera.CameraSubject = u13.Humanoid;
    end;

    LocalPlayer.ReplicationFocus = u13.Humanoid;

    if u5 then
        u5();
        u5 = nil;
    end;

    if u3 then
        u3:Disconnect();
        u3 = nil;
    end;

    if u6 then
        u6();
        u6 = nil;
    end;

    if u4 then
        u4:Disconnect();
        u4 = nil;
    end;

    u7 = false;
    u2 = Character.new(u13, HumanoidRootPart, v15);

    local function handleDeath() -- Line: 209
        -- upvalues: u7 (ref), u2 (ref), InventoryController (ref), u5 (ref), u3 (ref), u6 (ref), u4 (ref)
        if u7 then
            return;
        end;

        u7 = true;

        if u2 then
            u2:Destroy();
            u2 = nil;
        end;

        InventoryController.CleanupCurrentLoadout();

        if u5 then
            u5();
            u5 = nil;
        end;

        if u3 then
            u3:Disconnect();
            u3 = nil;
        end;

        if u6 then
            u6();
            u6 = nil;
        end;

        if u4 then
            u4:Disconnect();
            u4 = nil;
        end;
    end;

    u5 = Remotes.Character.CharacterDied.Listen(function() -- Line: 244
        -- upvalues: LocalPlayer (ref), u13 (copy), handleDeath (copy)
        if LocalPlayer.Character ~= u13 then
            return;
        end;

        if u13:GetAttribute("Dead") ~= true then
            local v18 = u13:FindFirstChildOfClass("Humanoid");

            if v18 and v18.Health > 0 then
                return;
            end;
        end;

        handleDeath();
    end);
    u3 = u13:GetAttributeChangedSignal("Dead"):Connect(function() -- Line: 260
        -- upvalues: u13 (copy), handleDeath (copy)
        if not u13:GetAttribute("Dead") then
            return;
        end;

        handleDeath();
    end);
    u6 = Remotes.UI.UIPlayerKilled.Listen(function(p19) -- Line: 268
        -- upvalues: LocalPlayer (ref), u13 (copy), handleDeath (copy)
        if not p19 or (p19.Victim ~= tostring(LocalPlayer.UserId) or LocalPlayer.Character ~= u13) then
            return;
        end;

        handleDeath();
    end);
    u4 = v15.HealthChanged:Connect(function(p20) -- Line: 278
        -- upvalues: handleDeath (copy)
        if p20 > 0 then
            return;
        end;

        handleDeath();
    end);

    if not u13:GetAttribute("Dead") and v15.Health > 0 then
        return;
    end;

    handleDeath();
end;

function u1.Initialize() -- Line: 296
    -- upvalues: LocalPlayer (copy), u1 (copy), u2 (ref), u5 (ref), u3 (ref), u6 (ref), u4 (ref), u7 (ref), GameState (copy), recoverCharacterControllerIfDesynced (copy), Remotes (copy), Sound (copy), Players (copy), CharacterKinematics (copy)
    LocalPlayer.CharacterAdded:Connect(function(p21) -- Line: 298
        -- upvalues: u1 (ref)
        u1.characterAdded(p21);
    end);
    LocalPlayer.CharacterRemoving:Connect(function() -- Line: 303
        -- upvalues: u2 (ref), u5 (ref), u3 (ref), u6 (ref), u4 (ref), u7 (ref)
        if u2 then
            u2:Destroy();
            u2 = nil;
        end;

        if u5 then
            u5();
            u5 = nil;
        end;

        if u3 then
            u3:Disconnect();
            u3 = nil;
        end;

        if u6 then
            u6();
            u6 = nil;
        end;

        if u4 then
            u4:Disconnect();
            u4 = nil;
        end;

        u7 = false;
    end);
    GameState.ListenToState(function(p22, p23) -- Line: 331
        -- upvalues: recoverCharacterControllerIfDesynced (ref)
        if p23 == "Buy Period" or p23 == "Round In Progress" then
            recoverCharacterControllerIfDesynced();
        end;
    end);
    Remotes.Character.CharacterDamaged.Listen(function(p24) -- Line: 338
        -- upvalues: LocalPlayer (ref), u2 (ref), Sound (ref), Players (ref), CharacterKinematics (ref)
        local VictimUserId = p24.VictimUserId;

        if VictimUserId == LocalPlayer.UserId then
            if u2 then
                Sound.new("Character"):playOneTime({
                    Name = "Character Damaged",
                    Parent = LocalPlayer.PlayerGui
                });
            end;

            return;
        end;

        if p24.Melee == true then
            return;
        end;

        local v25 = Players:GetPlayerByUserId(VictimUserId);

        if v25 then
            v25 = v25.Character;
        end;

        local Direction = p24.Direction;

        if v25 then
            if not Direction then
                return;
            end;

            if p24.Headshot == true then
                CharacterKinematics.flickHead(v25, Direction);

                return;
            end;

            CharacterKinematics.flinchBody(v25, Direction);
        end;
    end);
    Remotes.Character.ShotSlow.Listen(function(p26) -- Line: 374
        -- upvalues: u2 (ref)
        if u2 then
            u2.ShotSlowUntil = tick() + p26.Duration;
            u2.ShotSlowMultiplier = p26.Multiplier;
        end;
    end);
    Remotes.Character.ReplicateLookAngle.Listen(function(p27) -- Line: 382
        -- upvalues: CharacterKinematics (ref)
        local Player = p27.Player;
        local HorizontalAngle = p27.HorizontalAngle;
        local VerticalLook = p27.VerticalLook;

        if Player and (HorizontalAngle == HorizontalAngle and VerticalLook == VerticalLook) then
            CharacterKinematics.setTargetRotation(Player, HorizontalAngle);
            CharacterKinematics.setVerticalLook(Player, VerticalLook);
        end;
    end);
end;

function u1.Start() -- Line: 396
    -- upvalues: Router (copy), u1 (copy)
    Router.observerRouter("Plant Bomb", function() -- Line: 398
        -- upvalues: u1 (ref)
        u1.PlantBomb();
    end);
    Router.observerRouter("Cancel Bomb Plant", function() -- Line: 403
        -- upvalues: u1 (ref)
        u1.CancelBombPlant();
    end);
    Router.observerRouter("GetCurrentCharacter", function() -- Line: 408
        -- upvalues: u1 (ref)
        return u1.getCurrentCharacter();
    end);
end;

return u1;