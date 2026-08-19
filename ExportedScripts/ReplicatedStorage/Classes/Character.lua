-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Workspace = game:GetService("Workspace");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local LocalPlayer = Players.LocalPlayer;
local Debris = workspace:WaitForChild("Debris");
local CurrentCamera = Workspace.CurrentCamera;
local CharacterAnimations = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("CharacterAnimations");
local GetMovementAnimation = require(script.Components.GetMovementAnimation);
local CharacterAnimator = require(script.Classes.CharacterAnimator);
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Signal = require(ReplicatedStorage.Packages.Signal);
local u2 = require(LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")):GetControls();
local u3 = RaycastParams.new();
u3.FilterType = Enum.RaycastFilterType.Exclude;
u3.RespectCanCollide = true;
local u4 = RaycastParams.new();
u4.FilterType = Enum.RaycastFilterType.Exclude;
u4.RespectCanCollide = true;
local u5 = { Vector3.new(0, 0, 0), Vector3.new(0.8, 0, 0), Vector3.new(-0.8, 0, 0), Vector3.new(0, 0, 0.8), Vector3.new(0, 0, -0.8) };
local u6 = { Debris, Debris, Debris };
local u7 = { Debris, Debris, Debris };

if not LocalPlayer:GetAttribute("DefaultCameraOffset") then
    LocalPlayer:SetAttribute("DefaultCameraOffset", Vector3.new(0, -0.15, 0));
end;

if not LocalPlayer:GetAttribute("CrouchCameraOffset") then
    LocalPlayer:SetAttribute("CrouchCameraOffset", Vector3.new(0, -1.4, 0));
end;

local u8 = {
    ["SSG 08"] = 13.6,
    ["SG 553"] = 12,
    AWP = 8,
    AUG = 12,
    ["SCAR-20"] = 8,
    G3SG1 = 8
};

local function GetCrouchTime(p9) -- Line: 209
    return math.min(p9 * 0.05 + 0.15, 0.4);
end;

local function BuildMovementAnimationNameCache() -- Line: 213
    -- upvalues: CharacterAnimations (copy)
    local Crouch = CharacterAnimations:FindFirstChild("Crouch");
    local Movement = CharacterAnimations:FindFirstChild("Movement");

    if Movement then
        Movement = Movement:FindFirstChild("Walking");
    end;

    if not (Crouch and Movement) then
        return nil;
    end;

    local v10 = {
        CharacterIdle = true
    };

    for _, descendant in ipairs(Crouch:GetDescendants()) do
        if descendant:IsA("Animation") then
            v10[descendant.Name] = true;
        end;
    end;

    for _, descendant in ipairs(Movement:GetDescendants()) do
        if descendant:IsA("Animation") then
            v10[descendant.Name] = true;
        end;
    end;

    return v10;
end;

local function IsMenuOpen() -- Line: 239
    -- upvalues: MenuState (copy)
    local v11 = MenuState.GetMenuFrame();

    return v11 and v11.Visible and true or MenuState.GetCurrentScreen() ~= nil;
end;

local u12 = nil;
local u13 = {
    CharacterIdle = true
};

local function GetMovementAnimationNames() -- Line: 255
    -- upvalues: u12 (ref), BuildMovementAnimationNameCache (copy), u13 (copy)
    if u12 then
        return u12;
    end;

    local v14 = BuildMovementAnimationNameCache();

    if not v14 then
        return u13;
    end;

    u12 = v14;

    return v14;
end;

local function ClipVelocity(p15, p16, p17) -- Line: 270
    local v18 = p15:Dot(p16) * p17;

    if v18 >= 0 then
        return p15;
    end;

    local v19 = p15 - p16 * v18;

    if math.abs(v19.X) < 0.1 then
        v19 = Vector3.new(0, v19.Y, v19.Z);
    end;

    if math.abs(v19.Y) < 0.1 then
        v19 = Vector3.new(v19.X, 0, v19.Z);
    end;

    if math.abs(v19.Z) < 0.1 then
        v19 = Vector3.new(v19.X, v19.Y, 0);
    end;

    return v19;
end;

local function isValidVector3(p20) -- Line: 297
    local v21;

    if p20 == p20 then
        v21 = p20.Magnitude < 10000;
    else
        v21 = false;
    end;

    return v21;
end;

local function shouldIgnoreTeammatesInRaycasts() -- Line: 303
    return workspace:GetAttribute("VIPPlayerCollisionsEnabled") ~= true;
end;

local function ResetSpawnHumanoidState(p22) -- Line: 307
    p22.PlatformStand = false;
    p22.Sit = false;
    p22.Jump = false;
    p22:SetStateEnabled(Enum.HumanoidStateType.Landed, false);
    p22:SetStateEnabled(Enum.HumanoidStateType.Climbing, false);
    p22:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false);
    p22:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true);
    p22:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false);
    p22:ChangeState(Enum.HumanoidStateType.Running);
end;

function u1.GetMaxSpeed(p23) -- Line: 322
    -- upvalues: GameState (copy), LocalPlayer (copy), InventoryController (copy), u8 (copy)
    if GameState.GetState() == "Buy Period" then
        return 0;
    end;

    if LocalPlayer:GetAttribute("IsDefusingBomb") then
        return 0;
    end;

    if LocalPlayer:GetAttribute("IsRescuingHostage") then
        return 0;
    end;

    local v24 = LocalPlayer:GetAttribute("IsCarryingHostage") and 0.75 or 1;
    local v25 = InventoryController.getCurrentEquipped();

    if v25 and (v25.Properties.Class == "C4" and v25.IsPlanting) then
        return 0;
    end;

    local v26 = 20;

    if v25 and v25.Properties then
        if v25.CurrentWalkSpeedOverride then
            v26 = v25.CurrentWalkSpeedOverride;
        elseif v25.Properties.WalkSpeed then
            v26 = v25.Properties.WalkSpeed;
        end;
    end;

    local v27 = v25 and (v25.IsAiming and u8[v25.Name]);

    if v27 then
        return v27 * (p23.IsWalking and 0.52 or 1) * (p23.IsClimbing and 0.5 or 1) * (p23.IsCrouching and not p23.IsJumping and 0.34 or 1);
    end;

    local v28 = p23.IsCrouching and not p23.IsJumping and 0.34 or (p23.IsWalking and 0.52 or 1);
    local v29 = p23.IsClimbing and 0.5 or 1;

    if p23.CanceledInertia then
        v26 = 2.424;
    elseif p23.IsJumping and not (p23.IsAirStrafing or p23.CanceledInertia) then
        v26 = math.max(p23.LocalVelocityOnJump.Magnitude, 2.424);
    end;

    return v26 * v28 * v29 * v24 * (tick() < p23.ShotSlowUntil and p23.ShotSlowMultiplier or 1);
end;

function u1.ValidateHumanoidRootPart(p30) -- Line: 410
    local HumanoidRootPart = p30.HumanoidRootPart;

    if HumanoidRootPart and (HumanoidRootPart.Parent and HumanoidRootPart:IsDescendantOf(workspace)) then
        return HumanoidRootPart;
    end;

    return nil;
end;

function u1.TakeStamina(p31, p32) -- Line: 420
    p31.Stamina = math.clamp(p31.Stamina - p32, 0, 100);
end;

function u1.ApplyFriction(p33, p34) -- Line: 426
    if p33.IsJumping then
        return;
    end;

    local Magnitude = p33.GlobalVelocity.Magnitude;

    if Magnitude < 0.001 then
        return;
    end;

    local v35;

    if p33.GlobalDirection.Magnitude < 0.1 then
        v35 = math.max(Magnitude, 5);
    else
        v35 = Magnitude;
    end;

    local v36 = math.max(Magnitude - v35 * 6 * p34, 0);

    if v36 ~= Magnitude then
        if v36 == 0 then
            p33.GlobalVelocity = Vector3.new(0, 0, 0);

            return;
        end;

        p33.GlobalVelocity = p33.GlobalVelocity.Unit * v36;
    end;
end;

function u1.Accelerate(p37, p38, p39, p40, p41) -- Line: 466
    local v42 = p39 - p37.GlobalVelocity:Dot(p38);

    if v42 <= 0 then
        return;
    end;

    local v43 = math.min(p40 * p41 * p39, v42);
    p37.GlobalVelocity = p37.GlobalVelocity + p38 * v43;
end;

function u1.AirAccelerate(p44, p45, p46, p47) -- Line: 479
    local v48 = math.min(p46, 2.5);
    local v49 = v48 - p44.GlobalVelocity:Dot(p45);

    if v49 <= 0 then
        return;
    end;

    local v50 = v48 * 100 * p47;

    if v49 >= v50 then
        v49 = v50;
    end;

    p44.GlobalVelocity = p44.GlobalVelocity + p45 * v49;
end;

function u1.CheckGroundContact(p51) -- Line: 510
    -- upvalues: Workspace (copy), u7 (copy), Debris (copy), u4 (copy), u5 (copy)
    if not p51.HumanoidRootPart then
        return false, nil, nil;
    end;

    local CurrentCamera2 = Workspace.CurrentCamera;
    u7[1] = p51.Character;
    u7[2] = CurrentCamera2 or Debris;
    u4.FilterDescendantsInstances = u7;
    local v52 = p51.Player:GetAttribute("Team");

    if v52 and workspace:GetAttribute("VIPPlayerCollisionsEnabled") ~= true then
        u4.CollisionGroup = v52;
    else
        u4.CollisionGroup = "Default";
    end;

    local Position = p51.HumanoidRootPart.Position;

    for _, v in ipairs(u5) do
        local v53 = workspace:Raycast(Position + v, Vector3.new(0, -3.1, 0), u4);

        if v53 and (v53.Normal.Y > 0.7 and v53.Instance.CanCollide) then
            return true, v53.Instance, v53.Normal;
        end;
    end;

    return false, nil, nil;
end;

function u1.SetTargetMoveDirection(p54, p55) -- Line: 546
    if not p55:FuzzyEq(p54.TargetMoveDirection, 0.001) then
        p54.TargetMoveDirection = p55;
        p54.MoveDirectionChanged:Fire(p55);
    end;
end;

function u1.Jump(p56) -- Line: 555
    -- upvalues: GameState (copy), LocalPlayer (copy), InventoryController (copy)
    if GameState.GetState() == "Buy Period" then
        return;
    end;

    if LocalPlayer:GetAttribute("IsDefusingBomb") then
        return;
    end;

    local v57 = InventoryController.getCurrentEquipped();

    if v57 and (v57.Properties.Class == "C4" and v57.IsPlanting) then
        return;
    end;

    if not (p56.Character and (p56.Humanoid and p56.HumanoidRootPart)) then
        return;
    end;

    local v58 = tick() - p56.LastJumpTick;
    local v59 = tick() - p56.LastLandTick <= 0.5;

    if v58 < 0.15 and (p56.LastJumpTick > 0 and (not v59 or (p56.LastAirTime or 0) < 0.15)) then
        p56.IsJumpRequested = false;

        return;
    end;

    if not p56.IsClimbing then
        local v60 = p56.Humanoid:GetState();

        if v60 == Enum.HumanoidStateType.Freefall or v60 == Enum.HumanoidStateType.Jumping then
            p56.IsJumpRequested = false;

            return;
        end;
    end;

    local HumanoidRootPart = p56.HumanoidRootPart;

    if not p56.IsClimbing or (not p56.IsJumpRequested or p56.JumpedOffLadder) then
        if not p56.IsClimbing and (not p56.IsJumping and (p56.IsJumpRequested and p56.Stamina >= 20)) then
            p56.Humanoid.JumpPower = 19.5;

            if p56.AgainstWall then
                p56.GlobalVelocity = Vector3.new(0, 0, 0);
            end;

            local v61 = Vector3.new(p56.HumanoidRootPart.AssemblyLinearVelocity.X, 0, p56.HumanoidRootPart.AssemblyLinearVelocity.Z);
            local MoveDirection = p56.Humanoid.MoveDirection;

            if v61.Magnitude < 1 and MoveDirection.Magnitude > 0.1 then
                local v62 = RaycastParams.new();
                v62.FilterType = Enum.RaycastFilterType.Exclude;
                v62.FilterDescendantsInstances = { p56.Character };
                local v63 = workspace:Raycast(p56.HumanoidRootPart.Position, MoveDirection * 2, v62);

                if v63 and math.abs(v63.Normal.Y) < 0.5 then
                    local v64 = Vector3.new(v63.Normal.X, 0, v63.Normal.Z).Unit * 400;
                    p56.HumanoidRootPart:ApplyImpulse((Vector3.new(v64.X, p56.HumanoidRootPart.AssemblyLinearVelocity.Y, v64.Z)));
                end;
            end;

            if p56.HumanoidRootPart.AssemblyLinearVelocity.Y > 5 then
                local AssemblyLinearVelocity = p56.HumanoidRootPart.AssemblyLinearVelocity;
                p56.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z);
            end;

            p56.Humanoid.Jump = true;
            p56.IsJumping = true;
            p56.LastJumpTick = tick();
            p56.ReadyToJump = false;
            p56.IsJumpRequested = false;
            p56.Jumping:Fire();
            p56.CharacterAnimator:play("Jump", 0.2);
        end;

        return;
    end;

    local v65 = tick();
    p56.LastJumpTick = v65;
    p56.LastFreefallTick = v65;
    p56.PeakFallVelocity = 0;
    p56.LandingVelocityY = nil;
    p56.LastLadderJumpTick = tick();
    p56.JumpedOffLadder = true;
    local v66 = Vector3.new(0, 0, 1);
    local LadderZone = p56.LadderZone;

    if LadderZone then
        local v67 = p56:GetLadderCFrame(LadderZone);

        if v67 then
            local Position = HumanoidRootPart.Position;
            local Position2 = v67.Position;
            local v68 = Vector3.new(Position2.X - Position.X, 0, Position2.Z - Position.Z);

            if v68.Magnitude > 0.1 then
                v66 = -v68.Unit;
            end;
        end;
    end;

    local v69 = Vector3.new(v66.X * 12, -1 - (p56.LadderClimbPercentage or 0.5) * 2, v66.Z * 12);
    p56.ClimbEnded:Fire(p56.LadderZone, true);
    local v70;

    if v69 == v69 then
        v70 = v69.Magnitude < 10000;
    else
        v70 = false;
    end;

    if v70 then
        HumanoidRootPart.AssemblyLinearVelocity = v69;
        p56.GlobalVelocity = Vector3.new(v69.X, 0, v69.Z);
    end;

    p56.ReadyToJump = false;
    p56.Humanoid:ChangeState(Enum.HumanoidStateType.Freefall);
end;

function u1.AddLadder(p71, p72) -- Line: 725
    if not p71.LadderZones[p72] then
        p72.Anchored = true;
        p72.CollisionGroup = "Debris";
        p72.CastShadow = false;
        p72.CanCollide = false;
        p72.CanTouch = false;
        p72.Transparency = 1;
        p71.LadderZones[p72] = {
            CFrame = p72.CFrame,
            Extents = p72.Size / 2,
            Part = p72
        };
    end;
end;

function u1.RemoveLadder(p73, p74) -- Line: 744
    p73.LadderZones[p74] = nil;
end;

function u1.GetLadderCFrame(p75, p76) -- Line: 750
    if p76.Part and p76.Part.Parent then
        return p76.Part.CFrame;
    end;

    return nil;
end;

function u1.ForceExitLadder(p77, p78) -- Line: 764
    if p77.IsClimbing then
        p77.VectorForce.Enabled = false;
        p77.IsClimbing = false;
        p77.LadderZone = nil;
        p77.LadderClimbPercentage = 0;
        p77.LastLadderJumpTick = tick();

        if p77.Humanoid then
            p77.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false);
        end;

        p77.Climbing:Fire();
    end;
end;

function u1.GetLadderClimbPercentage(p79, p80) -- Line: 782
    local v81 = p79:ValidateHumanoidRootPart();

    if not v81 then
        return 0;
    end;

    local v82 = p79:GetLadderCFrame(p80);

    if not v82 then
        return 0;
    end;

    local v83 = p80.Extents.Y * 2;

    if v83 <= 0 then
        return 0.5;
    end;

    local v84 = v82.Position - Vector3.new(0, p80.Extents.Y, 0);
    local Position = v81.Position;

    if Position ~= Position or v84 ~= v84 then
        return 0.5;
    end;

    local v85 = math.clamp((Position.Y - v84.Y) / v83, 0, 1);

    return v85 ~= v85 and 0.5 or v85;
end;

function u1.CheckLadderOverlap(p86, p87) -- Line: 825
    local v88 = p86:ValidateHumanoidRootPart();

    if not v88 then
        return false;
    end;

    local v89 = p86:GetLadderCFrame(p87);

    if not v89 then
        return false;
    end;

    local Position = v88.Position;
    local Extents = p87.Extents;
    local v90 = v89:Inverse() * Position;
    local v91 = p87.Part:GetAttribute("BlacklistedSide");
    local v92;

    if (Extents.X > Extents.Z and "Z" or "X") == "Z" then
        v92 = v90.Z;
    else
        v92 = v90.X;
    end;

    if v91 == (v92 < 0 and "Front" or (v92 > 0 and "Back" or "Center")) then
        return false;
    end;

    local v93 = math.abs(v90.X);
    local v94 = math.abs(v90.Z);
    local v95 = v90.Y >= Extents.Y - 1;
    local v96 = p86.Character:FindFirstChildOfClass("Humanoid");

    if v96 then
        v96 = v96.FloorMaterial ~= Enum.Material.Air;
    end;

    if v95 and v96 then
        return false;
    end;

    local v97;

    if Extents.X > Extents.Z then
        if Extents.Z * 0.5 <= v94 then
            v97 = v94 <= Extents.Z + 2;
        else
            v97 = false;
        end;
    elseif Extents.X * 0.5 <= v93 then
        v97 = v93 <= Extents.X + 2;
    else
        v97 = false;
    end;

    if v90.Y > Extents.Y + 0.8 + (v97 and 3 or 0.5) or v90.Y < -(Extents.Y + 0.8 + 3) then
        return false;
    end;

    if Extents.X > Extents.Z then
        if Extents.X + 0.8 < v93 then
            return false;
        end;

        if Extents.X < v93 and v94 < Extents.Z * 2 then
            return false;
        end;

        return v94 <= Extents.Z + 2;
    end;

    if Extents.Z + 0.8 < v94 then
        return false;
    end;

    if Extents.Z < v94 and v93 < Extents.X * 2 then
        return false;
    end;

    return v93 <= Extents.X + 2;
end;

function u1.FindNearestLadder(p98) -- Line: 953
    local v99 = p98:ValidateHumanoidRootPart();

    if not v99 then
        return nil;
    end;

    local Position = v99.Position;
    local v100 = (1 / 0);
    local v101 = nil;

    for _, v in pairs(p98.LadderZones) do
        local v102 = p98:GetLadderCFrame(v);

        if v102 then
            local Magnitude = Vector3.new(Position.X - v102.Position.X, 0, Position.Z - v102.Position.Z).Magnitude;

            if Magnitude <= 2 and (p98:CheckLadderOverlap(v) and Magnitude < v100) then
                v101 = v;
                v100 = Magnitude;
            end;
        end;
    end;

    return v101;
end;

function u1.ResolveGroundedFreefall(p103, p104, p105) -- Line: 988
    local v106 = p104 or p103:ValidateHumanoidRootPart();

    if not v106 then
        return false;
    end;

    if p103.Humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
        return false;
    end;

    if p105 == nil then
        p105 = p103:CheckGroundContact();
    end;

    if not p105 then
        return false;
    end;

    if v106.AssemblyLinearVelocity.Y > 1 then
        return false;
    end;

    local AssemblyLinearVelocity = v106.AssemblyLinearVelocity;
    local v107 = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z);
    local v108;

    if v107 == v107 then
        v108 = v107.Magnitude < 10000;
    else
        v108 = false;
    end;

    if v108 then
        v106.AssemblyLinearVelocity = v107;
    end;

    p103.Humanoid:ChangeState(Enum.HumanoidStateType.Running);
    p103.IsJumping = false;
    p103.IsLanded = true;
    p103.ReadyToJump = true;
    p103.LockedAirDirection = nil;

    return true;
end;

function u1.MoveFunction(p109, p110, p111) -- Line: 1030
    -- upvalues: CurrentCamera (copy), Workspace (copy), u6 (copy), Debris (copy), u3 (copy), ClipVelocity (copy), MenuState (copy), u2 (copy)
    local v112 = p109:ValidateHumanoidRootPart();

    if not v112 then
        if p109.IsClimbing then
            p109:ForceExitLadder("Invalid HumanoidRootPart at MoveFunction start");
        end;

        return;
    end;

    local v113 = tick();
    local v114 = v113 - p109.LastMoveUpdate;
    local v115, _, _ = p109:CheckGroundContact();
    p109:ResolveGroundedFreefall(v112, v115);
    local v116 = p109:GetMaxSpeed();
    p109.MaxSpeed = v116;

    if v116 <= 0 then
        p109.GlobalDirection = Vector3.new(0, 0, 0);
        p109.LocalVelocity = Vector3.new(0, 0, 0);
        p109.GlobalVelocity = Vector3.new(0, 0, 0);
        v112.AssemblyLinearVelocity = Vector3.new(0, v112.AssemblyLinearVelocity.Y, 0);
        v112.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
        p109.Humanoid.WalkSpeed = 0;
        p109.LastMoveUpdate = v113;

        return;
    end;

    p109.GlobalDirection = Vector3.new(0, 0, 0);
    local v117 = Vector3.new(0, 0, 0);
    local v118 = tick() - p109.LastJumpTick;

    if p109.IsJumping and (v115 and v118 >= 0.15) then
        local Y = v112.AssemblyLinearVelocity.Y;

        if Y <= 1 then
            p109.LastAirTime = tick() - (p109.LastFreefallTick or p109.LastJumpTick);
            p109.LandingVelocityY = p109.PeakFallVelocity or Y;
            p109.IsJumping = false;
            p109.IsLanded = true;
            p109.LandAtPosition = v112.CFrame.Position;
            p109.LastLandTick = tick();
            p109.ReadyToJump = true;
            p109.LockedAirDirection = nil;
            p109.CharacterAnimator:stop("Jump", 0.2);
            p109.Landed:Fire();
        end;
    end;

    local v119 = p109.Humanoid:GetState();

    if v119 == Enum.HumanoidStateType.Freefall and true or v119 == Enum.HumanoidStateType.Jumping then
        if not p109.LastFreefallTick then
            p109.LastFreefallTick = tick();
            p109.PeakFallVelocity = 0;
        end;

        local Y = v112.AssemblyLinearVelocity.Y;

        if Y < (p109.PeakFallVelocity or 0) then
            p109.PeakFallVelocity = Y;
        end;
    end;

    local CFrame2 = CurrentCamera.CFrame;
    local Position = CFrame2.Position;
    local v120, v121, v122 = CFrame2:ToEulerAnglesXYZ();
    local v123 = CFrame.new(Position) * CFrame.fromEulerAnglesXYZ(v120, v121, v122);

    if p110.Magnitude > 0 then
        if p111 then
            p109.GlobalDirection = v123:VectorToWorldSpace(p110);
        else
            p109.GlobalDirection = p110;
            p110 = v123:VectorToObjectSpace(p110);
        end;
    else
        p110 = v117;
    end;

    local v124 = Vector3.new(v123.LookVector.X, 0, v123.LookVector.Z);
    local Y = Vector3.new(p109.LastCameraCFrame.LookVector.X, 0, p109.LastCameraCFrame.LookVector.Z):Cross(v124).Y;
    p109.LocalVelocity = v123:VectorToObjectSpace(p109.GlobalVelocity);
    local v125 = p109.LocalVelocity:Angle(p110, Vector3.new(0, 1, 0));
    local _ = v125 == v125;
    v124.Unit:Angle(p109.GlobalDirection, Vector3.new(0, 1, 0));
    local v126 = p109.GlobalDirection:Angle(p109.GlobalVelocity, Vector3.new(0, 1, 0));
    math.abs(v126);
    local v127 = math.abs(p110.X) > 0.1;
    local v128 = p110.Z <= 0;
    local v129 = math.abs(Y) > 0.02;
    local v130 = math.sign(p110.X);
    local v131 = math.sign(Y);
    local IsJumping = p109.IsJumping;

    if IsJumping then
        if v127 then
            if v128 then
                if v129 then
                    v129 = v130 == -v131;
                end;
            else
                v129 = v128;
            end;
        else
            v129 = v127;
        end;
    else
        v129 = IsJumping;
    end;

    p109.IsAirStrafing = v129;
    local v132;

    if p109.GlobalDirection.Magnitude > 0 then
        v132 = p109.GlobalDirection.Unit;
    else
        v116 = 0;
        v132 = Vector3.new(0, 0, 0);
    end;

    if p109.IsJumping then
        local AssemblyLinearVelocity = v112.AssemblyLinearVelocity;
        p109.GlobalVelocity = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z);

        if v116 > 0 then
            p109:AirAccelerate(v132, v116, v114);
        end;

        if p109.IsAirStrafing then
            local Magnitude = p109.GlobalVelocity.Magnitude;

            if Magnitude > 0.1 then
                local v133 = Vector3.new(v124.X, 0, v124.Z);

                if v133.Magnitude > 0 then
                    local Unit = v133.Unit;
                    local Unit2 = p109.GlobalVelocity.Unit;
                    local v134 = math.min(1, 5 * v114 * 10);
                    local v135 = Unit2 + (Unit - Unit2) * v134;

                    if v135.Magnitude > 0 then
                        p109.GlobalVelocity = v135.Unit * Magnitude;
                    end;
                end;
            end;
        end;

        local Magnitude = p109.GlobalVelocity.Magnitude;

        if Magnitude > 24.5 then
            p109.GlobalVelocity = p109.GlobalVelocity * (24.5 / Magnitude);
        end;

        local v136 = Vector3.new(p109.GlobalVelocity.X, AssemblyLinearVelocity.Y, p109.GlobalVelocity.Z);
        local v137;

        if v136 == v136 then
            v137 = v136.Magnitude < 10000;
        else
            v137 = false;
        end;

        if v137 then
            v112.AssemblyLinearVelocity = v136;
        end;
    else
        local v138;

        if tick() - p109.LastLandTick < 0.5 then
            v138 = p109.IsJumpRequested;
        else
            v138 = false;
        end;

        if not v138 then
            p109:ApplyFriction(v114);
        end;

        if v116 > 0 then
            p109:Accelerate(v132, math.min(v116, 24.5), 6, v114);
        end;
    end;

    local Magnitude = Vector3.new(p109.GlobalVelocity.X, 0, p109.GlobalVelocity.Z).Magnitude;
    local _ = p109.IsJumping or p109.IsBhopAttempt;
    local v139 = 24.5;

    if v139 < Magnitude then
        local v140 = v139 / Magnitude;
        p109.GlobalVelocity = Vector3.new(p109.GlobalVelocity.X * v140, p109.GlobalVelocity.Y, p109.GlobalVelocity.Z * v140);
    end;

    p109.Humanoid.WalkSpeed = p109.LocalVelocity.Magnitude;
    local CurrentCamera2 = Workspace.CurrentCamera;
    u6[1] = p109.Character;
    u6[2] = CurrentCamera2 or Debris;
    u3.FilterDescendantsInstances = u6;
    local v141 = p109.Player:GetAttribute("Team");

    if v141 and workspace:GetAttribute("VIPPlayerCollisionsEnabled") ~= true then
        u3.CollisionGroup = v141;
    else
        u3.CollisionGroup = "Default";
    end;

    p109.AgainstWall = false;
    p109.WallNormal = nil;

    if p109.IsJumping then
        local AssemblyLinearVelocity = v112.AssemblyLinearVelocity;
        local v142 = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z);
        local Magnitude2 = v142.Magnitude;
        local Position2 = v112.Position;
        local v143 = tick();

        if p109.LastWallNormal and v143 - p109.LastWallHitTime < 0.15 then
            local LastWallNormal = p109.LastWallNormal;
            local v144 = v142:Dot((Vector3.new(LastWallNormal.X, 0, LastWallNormal.Z)));

            if v144 > 0.5 then
                AssemblyLinearVelocity = AssemblyLinearVelocity - Vector3.new(LastWallNormal.X, 0, LastWallNormal.Z) * v144;
                local v145;

                if AssemblyLinearVelocity == AssemblyLinearVelocity then
                    v145 = AssemblyLinearVelocity.Magnitude < 10000;
                else
                    v145 = false;
                end;

                if v145 then
                    v112.AssemblyLinearVelocity = AssemblyLinearVelocity;
                end;

                v142 = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z);
                Magnitude2 = v142.Magnitude;
            end;
        end;

        local v146 = { Vector3.new(0, 0, 0), v112.CFrame.RightVector * 1 * 0.8, -v112.CFrame.RightVector * 1 * 0.8 };
        local v147 = {};

        if Magnitude2 > 0.5 then
            table.insert(v147, v142.Unit);
        end;

        local v148 = Vector3.new(p109.GlobalDirection.X, 0, p109.GlobalDirection.Z);

        if v148.Magnitude > 0.1 then
            table.insert(v147, v148.Unit);
        end;

        for _, v in ipairs(v147) do
            for _, v2 in ipairs(v146) do
                local v149 = workspace:Raycast(Position2 + v2, v * (0.5 + (Magnitude2 > 0.5 and (Magnitude2 * 0.02 or 0.3) or 0.3)), u3);

                if v149 then
                    local Normal = v149.Normal;

                    if math.abs(Normal.Y) < 0.7 then
                        p109.AgainstWall = true;
                        p109.WallNormal = Normal;
                        p109.LastWallNormal = Normal;
                        p109.LastWallHitTime = v143;
                        local v150 = ClipVelocity(AssemblyLinearVelocity, Normal, 1);
                        local v151 = Vector3.new(v150.X, 0, v150.Z);

                        if v151.Magnitude < Magnitude2 * 0.3 then
                            v150 = Vector3.new(0, AssemblyLinearVelocity.Y, 0);
                            p109.GlobalVelocity = Vector3.new(0, 0, 0);
                        else
                            p109.GlobalVelocity = v151;
                        end;

                        local v152;

                        if v150 == v150 then
                            v152 = v150.Magnitude < 10000;
                        else
                            v152 = false;
                        end;

                        if v152 then
                            v112.AssemblyLinearVelocity = v150;
                        end;

                        break;
                    end;
                end;
            end;

            if p109.AgainstWall then
                break;
            end;
        end;
    end;

    if v112 and (p109.IsCrouching and not p109.CrouchInputDown) then
        p109.CrouchHeadBlocked = workspace:Spherecast(v112.CFrame.Position, 1.5, Vector3.new(0, 1, 0), u3) ~= nil;
    end;

    if v112 then
        if p109.IsClimbing then
            local LadderZone = p109.LadderZone;

            if LadderZone then
                local v153 = p109:GetLadderCFrame(LadderZone);

                if not v153 then
                    p109:ForceExitLadder("Ladder part removed");

                    return;
                end;

                local Position2 = v112.Position;
                local v154 = Position2.Y - 2.5;
                local Position3 = v153.Position;
                local v155 = Position3.Y - LadderZone.Extents.Y;
                local v156 = Position3.Y + LadderZone.Extents.Y;
                local v157 = math.clamp((v154 - v155) / (v156 - v155), 0, 1);
                p109.LadderClimbPercentage = v157;
                local Magnitude2 = Vector3.new(Position2.X - Position3.X, 0, Position2.Z - Position3.Z).Magnitude;

                if Magnitude2 > 50 then
                    p109:ForceExitLadder("Distance sanity check failed");

                    return;
                end;

                local v158 = v157 <= 0.15;
                local v159 = v157 >= 0.98;
                local v160 = Magnitude2 > 2.5;
                local GlobalDirection = p109.GlobalDirection;
                local v161 = Vector3.new(GlobalDirection.X, 0, GlobalDirection.Z);

                if v161.Magnitude > 0.1 then
                    v161 = v161.Unit;
                end;

                local v162 = Vector3.new(v123.LookVector.X, 0, v123.LookVector.Z);

                if v162.Magnitude > 0 then
                    v162 = v162.Unit;
                end;

                local v163 = v161:Dot(v162);
                local v164 = Vector3.new(Position3.X - Position2.X, 0, Position3.Z - Position2.Z);

                if v164.Magnitude > 0.1 and v162:Dot(v164.Unit) <= 0 then
                    v163 = -v163;
                end;

                local v165 = v163 > 0.1;
                local v166 = v163 < -0.1;
                local v167 = tick() - (p109.LastLadderAttachTick or 0) >= 0.1;

                if v160 then
                    v167 = v160;
                elseif not (v158 and (v166 and v167)) then
                    if v159 then
                        if not v165 then
                            v167 = v165;
                        end;
                    else
                        v167 = v159;
                    end;
                end;

                if v156 + 0.5 <= v154 and true or v167 then
                    if v159 and v165 then
                        local v168 = v162 * 8;
                        local v169 = Vector3.new(v168.X, 2, v168.Z);
                        local v170;

                        if v169 == v169 then
                            v170 = v169.Magnitude < 10000;
                        else
                            v170 = false;
                        end;

                        if v170 then
                            v112.AssemblyLinearVelocity = v169;
                            p109.GlobalVelocity = v168;
                        end;
                    end;

                    p109.ClimbEnded:Fire(LadderZone, false);
                end;
            end;
        else
            local v171 = tick() - (p109.LastLadderJumpTick or 0) > (p109.JumpedOffLadder and 0.5 or 0.25) and p109:FindNearestLadder();

            if v171 then
                p109.ClimbBegan:Fire(v171);
            end;
        end;
    end;

    local v172 = Vector3.new(0, 0, 0);

    if p109.IsClimbing and not p109.JumpedOffLadder then
        local LadderZone = p109.LadderZone;
        p109.GlobalVelocity = Vector3.new(0, 0, 0);

        if LadderZone and v112 then
            local GlobalDirection = p109.GlobalDirection;
            local v173 = Vector3.new(GlobalDirection.X, 0, GlobalDirection.Z);
            local v174 = Vector3.new(v123.LookVector.X, 0, v123.LookVector.Z);
            local v175 = Vector3.new(v123.RightVector.X, 0, v123.RightVector.Z);

            if v173.Magnitude > 0.1 then
                v173 = v173.Unit;
            end;

            local v176 = v174.Magnitude <= 0 and Vector3.new(0, 0, -1) or v174.Unit;

            if v175.Magnitude > 0 then
                v175 = v175.Unit;
            end;

            local v177 = p109.LadderClimbPercentage or 0;
            local v178 = v173:Dot(v176);
            local v179 = v173:Dot(v175);
            local v180 = GlobalDirection.Magnitude > 0.1;
            local v181 = p109:GetLadderCFrame(LadderZone);

            if not v181 then
                p109:ForceExitLadder("Ladder part removed during climb");

                return;
            end;

            local Position2 = v112.Position;
            local Position3 = v181.Position;
            local v182 = Vector3.new(Position3.X - Position2.X, 0, Position3.Z - Position2.Z);

            if v182.Magnitude > 0.1 and v176:Dot(v182.Unit) <= 0 then
                v178 = -v178;
            end;

            local v183 = tick() - (p109.LastLadderAttachTick or 0) >= 0.1;

            if v177 >= 0.98 and (v178 > 0.1 and v183) then
                local v184 = v176 * 8;
                local v185 = Vector3.new(v184.X, 2, v184.Z);
                local v186;

                if v185 == v185 then
                    v186 = v185.Magnitude < 10000;
                else
                    v186 = false;
                end;

                if v186 then
                    v112.AssemblyLinearVelocity = v185;
                    p109.GlobalVelocity = v184;
                end;

                p109.ClimbEnded:Fire(LadderZone, false);

                return;
            end;

            if v177 <= 0.15 and (v178 < -0.1 and v183) then
                p109.ClimbEnded:Fire(LadderZone, false);

                return;
            end;

            if v180 then
                if math.abs(v178) > 0.1 then
                    local v187 = 14 * v178;

                    if math.abs(v179) > 0.1 then
                        v187 = v187 * 1.15;
                    end;

                    v172 = Vector3.new(0, v187, 0);
                end;

                if math.abs(v179) > 0.1 then
                    local v188 = p109:GetLadderCFrame(LadderZone);

                    if not v188 then
                        p109:ForceExitLadder("Ladder part removed during strafe");

                        return;
                    end;

                    local RightVector = v188.RightVector;
                    local X = v188:VectorToObjectSpace(Position2 - Position3).X;

                    if LadderZone.Extents.X * 0.8 > math.abs(X + v179 * 0.5) then
                        v172 = v172 + RightVector * (5.6000000000000005 * v179);
                    end;
                end;
            end;
        end;

        local v189 = v112 and p109.Character.PrimaryPart;

        if v189 then
            local v190;

            if v172 == v172 then
                v190 = v172.Magnitude < 10000;
            else
                v190 = false;
            end;

            if v190 then
                v189.AssemblyLinearVelocity = v172;
            end;
        end;
    end;

    local v191 = MenuState.GetMenuFrame();
    local v192;

    if v191 and v191.Visible and true or MenuState.GetCurrentScreen() ~= nil then
        v192 = false;
    else
        v192 = u2.activeController:GetIsJumping() or u2.touchJumpController and u2.touchJumpController:GetIsJumping();
    end;

    if v192 and not (p109.IsJumping or p109.IsJumpRequested) then
        p109.IsJumpRequested = true;
    elseif not v192 then
        p109.IsJumpRequested = false;
    end;

    p109:Jump();
    p109.LastCameraCFrame = v123;
    p109.Humanoid:MoveTo(p109.HumanoidRootPart.Position + p109.GlobalVelocity);
    p109.LastMoveUpdate = v113;
end;

function u1.StopMovementAnimations(p193) -- Line: 1656
    -- upvalues: u12 (ref), BuildMovementAnimationNameCache (copy), u13 (copy)
    local v194;

    if u12 then
        v194 = u12;
    else
        v194 = BuildMovementAnimationNameCache();

        if v194 then
            u12 = v194;
        else
            v194 = u13;
        end;
    end;

    for i, v in pairs(p193.CharacterAnimator.Animations) do
        if i ~= "Jump" and (v194[i] and v.IsPlaying) then
            p193.CharacterAnimator:stop(i, 0.2);
        end;
    end;
end;

function u1.ToggleWalkState(p195, p196) -- Line: 1670
    -- upvalues: Remotes (copy)
    if p196 ~= p195.IsWalking then
        p195.IsWalking = p196;
        Remotes.Character.UpdateWalkState.Send(p195.IsWalking);
        p195.Walking:Fire(p195.IsWalking);
    end;
end;

function u1.ToggleCrouchInput(p197, p198) -- Line: 1680
    p197.CrouchInputDown = p198;
end;

function u1.PlantBomb(p199) -- Line: 1686
    -- upvalues: TweenService (copy)
    if not p199.IsPlantingBomb then
        p199.IsPlantingBomb = true;

        if p199.BombPlantTween then
            p199.BombPlantTween:Cancel();
            p199.BombPlantTween = nil;
        end;

        p199.BombPlantTween = p199.Janitor:Add(TweenService:Create(p199.Humanoid, TweenInfo.new(0.75, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
            CameraOffset = Vector3.new(0, -0.9, 0) + p199.DefaultCameraOffset
        }));
        p199.BombPlantTween:Play();
    end;
end;

function u1.CancelBombPlant(p200) -- Line: 1710
    -- upvalues: TweenService (copy)
    if p200.IsPlantingBomb then
        p200.IsPlantingBomb = false;

        if p200.BombPlantTween then
            p200.BombPlantTween:Cancel();
            p200.BombPlantTween = nil;
        end;

        p200.Janitor:Add(TweenService:Create(p200.Humanoid, TweenInfo.new(0.35, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
            CameraOffset = p200.DefaultCameraOffset
        })):Play();
    end;
end;

function u1.ToggleCrouchState(p201, p202) -- Line: 1737
    -- upvalues: InventoryController (copy), Remotes (copy), TweenService (copy)
    local v203 = InventoryController.getCurrentEquipped();

    if v203 and (v203.Properties.Class == "C4" and v203.IsPlanting) then
        return;
    end;

    if p202 == p201.IsCrouching then
        return;
    end;

    local v204 = tick();
    p201.IsCrouching = p202;
    Remotes.Character.UpdateCrouchState.Send(p201.IsCrouching);

    if p201.CrouchTween then
        p201.CrouchTween:Cancel();
        p201.CrouchTween = nil;
    end;

    if p201.IsCrouching then
        p201.CrouchCount = p201.CrouchCount + 1;

        if v204 - p201.LastCrouchTick > 0.5 then
            p201.CrouchCount = 0;
        end;

        local v205 = math.min(p201.CrouchCount * 0.05 + 0.15, 0.4);
        p201.LastCrouchTick = v204;
        p201.CrouchTween = p201.Janitor:Add(TweenService:Create(p201.Humanoid, TweenInfo.new(v205, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
            CameraOffset = p201.CrouchCameraOffset + p201.DefaultCameraOffset
        }));
        p201.CrouchTween:Play();
    else
        local v206 = math.min(p201.CrouchCount * 0.05 + 0.15, 0.4);
        p201.CrouchTween = p201.Janitor:Add(TweenService:Create(p201.Humanoid, TweenInfo.new(v206, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
            CameraOffset = p201.DefaultCameraOffset
        }));
        p201.CrouchTween:Play();
    end;

    p201.LastCrouchTick = v204;
    p201.Crouching:Fire(p201.IsCrouching);
end;

function u1.UpdateCharacterAnimations(p207, p208) -- Line: 1809
    -- upvalues: GetMovementAnimation (copy)
    if p207.IsJumping then
        p207.CurrentMovementAnimation = nil;
        p207:StopMovementAnimations();

        return;
    end;

    local v209 = p207.CharacterAnimator:getAnimation("CrouchIdle");
    local v210 = GetMovementAnimation(p207.Character);
    local v211;

    if p207.IsCrouching then
        if p207.GlobalDirection.Magnitude <= 0.1 then
            if not v209.IsPlaying then
                p207.CurrentMovementAnimation = nil;
                p207:StopMovementAnimations();
                p207.CharacterAnimator:play("CrouchIdle", (math.min(p207.CrouchCount * 0.05 + 0.15, 0.4)));
            end;

            return;
        end;

        v211 = `Crouch{v210}`;

        if v209.IsPlaying then
            p207.CharacterAnimator:stop("CrouchIdle", (math.min(p207.CrouchCount * 0.05 + 0.15, 0.4)));
        end;
    else
        if v209.IsPlaying then
            p207.CharacterAnimator:stop("CrouchIdle", (math.min(p207.CrouchCount * 0.05 + 0.15, 0.4)));
        end;

        v211 = v210 or "CharacterIdle";
    end;

    local v212 = p207.CharacterAnimator:getAnimation(v211);

    if v212 and v211 ~= "CharacterIdle" then
        v212:AdjustSpeed((p207.HumanoidRootPart.AssemblyLinearVelocity * Vector3.new(1, 0, 1)).Magnitude / (p207.IsCrouching and 12 or 16));
    end;

    if p207.CurrentMovementAnimation ~= v211 then
        p207.CurrentMovementAnimation = v211;
        p207:StopMovementAnimations();

        if v212 then
            v212:Play(0.15);
        end;
    end;
end;

function u1.new(u213, p214, u215) -- Line: 1880
    -- upvalues: u1 (copy), Janitor (copy), LocalPlayer (copy), CharacterAnimator (copy), ResetSpawnHumanoidState (copy), CurrentCamera (copy), Signal (copy), u2 (copy), Remotes (copy), RunServiceController (copy), CollectionService (copy)
    local u216 = setmetatable({}, u1);
    u216.Janitor = Janitor.new();
    u216.DefaultCameraOffset = LocalPlayer:GetAttribute("DefaultCameraOffset") or Vector3.new(0, -0.15, 0);
    u216.CrouchCameraOffset = LocalPlayer:GetAttribute("CrouchCameraOffset") or Vector3.new(0, -1.4, 0);
    u216.Janitor:Add(LocalPlayer:GetAttributeChangedSignal("DefaultCameraOffset"):Connect(function() -- Line: 1891
        -- upvalues: u216 (copy), LocalPlayer (ref)
        u216.DefaultCameraOffset = LocalPlayer:GetAttribute("DefaultCameraOffset") or Vector3.new(0, -0.15, 0);
    end));
    u216.Janitor:Add(LocalPlayer:GetAttributeChangedSignal("CrouchCameraOffset"):Connect(function() -- Line: 1895
        -- upvalues: u216 (copy), LocalPlayer (ref)
        u216.CrouchCameraOffset = LocalPlayer:GetAttribute("CrouchCameraOffset") or Vector3.new(0, -1.4, 0);
    end));
    u216.CharacterAnimator = CharacterAnimator.new(u213);
    u216.HumanoidRootPart = p214;
    u216.Character = u213;
    u216.Humanoid = u215;
    u216.Player = LocalPlayer;
    u216.Janitor:Add(p214.AncestryChanged:Connect(function(p217, p218) -- Line: 1909
        -- upvalues: u216 (copy)
        if not p218 then
            if u216.IsClimbing then
                u216:ForceExitLadder("HumanoidRootPart removed");
            end;

            u216.HumanoidRootPart = nil;
        end;
    end));
    u216.Humanoid.WalkSpeed = 20;
    u216.Humanoid.AutoRotate = false;
    u216.Humanoid.MaxSlopeAngle = 90;

    if LocalPlayer:GetAttribute("SV_ACCELERATE") == nil then
        LocalPlayer:SetAttribute("SV_ACCELERATE", 6);
    end;

    if LocalPlayer:GetAttribute("SV_STOPSPEED") == nil then
        LocalPlayer:SetAttribute("SV_STOPSPEED", 5);
    end;

    if LocalPlayer:GetAttribute("SV_FRICTION") == nil then
        LocalPlayer:SetAttribute("SV_FRICTION", 6);
    end;

    local function setupPartCollision(p219) -- Line: 1937
        if p219.Name == "CollisionCapsule" then
            p219.CanCollide = false;

            return;
        end;

        if p219.Name ~= "HumanoidRootPart" or not p219:IsA("Part") then
            if p219.Name == "Head" then
                p219.CanCollide = true;

                return;
            end;

            if p219.Name == "UpperTorso" or p219.Name == "LowerTorso" then
                p219.CanCollide = false;

                return;
            end;

            p219.CanCollide = false;

            return;
        end;

        p219.CanCollide = true;
        p219.Size = Vector3.new(2, 2, 2);
        p219.Shape = Enum.PartType.Ball;
        p219.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0, 1, 1);
    end;

    for _, descendant in ipairs(u213:GetDescendants()) do
        if descendant:IsA("BasePart") then
            setupPartCollision(descendant);
        end;
    end;

    u216.Janitor:Add(u213.DescendantAdded:Connect(function(p220) -- Line: 1967
        -- upvalues: setupPartCollision (copy)
        if p220:IsA("BasePart") then
            setupPartCollision(p220);
        end;
    end));
    u216.Humanoid.UseJumpPower = true;
    u216.Humanoid.JumpPower = 19.5;
    ResetSpawnHumanoidState(u216.Humanoid);
    u216.GlobalVelocity = Vector3.new(0, 0, 0);
    u216.LocalVelocity = Vector3.new(0, 0, 0);
    u216.LocalVelocityOnJump = Vector3.new(0, 0, 0);
    u216.GlobalDirection = Vector3.new(0, 0, 0);
    u216.LastCameraCFrame = CFrame.new();
    u216.LastMoveUpdate = 0;
    u216.JumpCooldownActive = false;
    u216.ReadyToJump = false;
    u216.LastJumpTick = 0;
    u216.JumpCount = 0;
    u216.LastWallHitTick = 0;
    u216.WallJumpCooldown = false;
    u216.LockedAirDirection = nil;
    u216.LastAirDirectionChangeTick = 0;
    u216.LastLandTick = 0;
    u216.LastFreefallTick = nil;
    u216.LastAirTime = 0;
    u216.PeakFallVelocity = 0;
    u216.LandingVelocityY = nil;
    u216.LastCrouchTick = 0;
    u216.CrouchCount = 0;
    u216.CrouchHeadBlocked = false;
    u216.CrouchInputDown = false;
    u216.CurrentMovementAnimation = nil;
    u216.LadderZones = {};
    u216.LadderPart = nil;
    u216.LadderZone = nil;
    u216.LadderClimbPercentage = 0;
    u216.LastLadderJumpTick = 0;
    u216.LastLadderAttachTick = 0;
    local _, v221, _ = CurrentCamera.CFrame:ToEulerAnglesYXZ();
    u216.CurrentYRotation = v221;
    u216.TargetYRotation = v221;
    local RootAttachment = p214:FindFirstChild("RootAttachment");

    if not RootAttachment then
        warn("[Character] RootAttachment not found - creating one");
        RootAttachment = Instance.new("Attachment");
        RootAttachment.Name = "RootAttachment";
        RootAttachment.Parent = p214;
    end;

    local AssemblyMass = p214.AssemblyMass;

    if AssemblyMass ~= AssemblyMass or AssemblyMass <= 0 then
        warn("[Character] Invalid initial AssemblyMass:", AssemblyMass, "- using fallback");
        AssemblyMass = 10;
    end;

    u216.VectorForce = u216.Janitor:Add(Instance.new("VectorForce"));
    u216.VectorForce.Force = Vector3.new(0, AssemblyMass * workspace.Gravity, 0);
    u216.VectorForce.RelativeTo = Enum.ActuatorRelativeTo.World;
    u216.VectorForce.Enabled = false;
    u216.VectorForce.ApplyAtCenterOfMass = false;
    u216.VectorForce.Attachment0 = RootAttachment;
    u216.VectorForce.Parent = p214;
    u216.AlignOrientation = u216.Janitor:Add(Instance.new("AlignOrientation"));
    u216.AlignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment;
    u216.AlignOrientation.Attachment0 = p214:FindFirstChild("RootAttachment");
    u216.AlignOrientation.RigidityEnabled = true;
    u216.AlignOrientation.MaxTorque = (1 / 0);
    u216.AlignOrientation.Responsiveness = 200;
    u216.AlignOrientation.CFrame = CFrame.Angles(0, u216.CurrentYRotation, 0);
    u216.AlignOrientation.Parent = p214;
    u216.JumpedOffLadder = false;
    u216.IsPlantingBomb = false;
    u216.IsCrouching = false;
    u216.IsClimbing = false;
    u216.IsJumping = false;
    u216.IsWalking = false;
    u216.IsLanded = false;
    u216.IsBhopAttempt = false;
    u216.AgainstWall = false;
    u216.WallNormal = nil;
    u216.LastWallHitTime = 0;
    u216.LastWallNormal = nil;
    u216.Stamina = 100;
    u216.CurrentMoveDirection = Vector3.new(0, 0, 0);
    u216.TargetMoveDirection = Vector3.new(0, 0, 0);
    u216.MaxSpeed = 20;
    u216.ShotSlowUntil = 0;
    u216.ShotSlowMultiplier = 1;
    u216.LastLookAngle = 0;
    u216.LastVerticalLook = 0;
    u216.LastLookAngleUpdate = 0;
    u216.MoveDirectionChanged = u216.Janitor:Add(Signal.new());
    u216.Crouching = u216.Janitor:Add(Signal.new());
    u216.ClimbBegan = u216.Janitor:Add(Signal.new());
    u216.ClimbEnded = u216.Janitor:Add(Signal.new());
    u216.Climbing = u216.Janitor:Add(Signal.new());
    u216.Jumping = u216.Janitor:Add(Signal.new());
    u216.Walking = u216.Janitor:Add(Signal.new());
    u216.Landed = u216.Janitor:Add(Signal.new());
    u216.Janitor:Add(function() -- Line: 2103
        -- upvalues: u216 (copy)
        if u216.CharacterAnimator then
            u216.CharacterAnimator:destroy();
        end;
    end);
    u216.Janitor:Add(u216.Humanoid.StateChanged:Connect(function(p222, p223) -- Line: 2110
        -- upvalues: u216 (copy), ResetSpawnHumanoidState (ref)
        if (p223 == Enum.HumanoidStateType.Ragdoll or p223 == Enum.HumanoidStateType.FallingDown) and u216.Humanoid.Health > 0 then
            ResetSpawnHumanoidState(u216.Humanoid);

            return;
        end;

        local v224 = p223 == Enum.HumanoidStateType.Jumping and true or p223 == Enum.HumanoidStateType.Freefall;
        local v225;

        if p222 == Enum.HumanoidStateType.Freefall then
            v225 = not v224;
        else
            v225 = false;
        end;

        if p223 == Enum.HumanoidStateType.Freefall then
            u216.LastFreefallTick = tick();
            u216.PeakFallVelocity = 0;
        end;

        if v225 then
            u216.LastAirTime = tick() - (u216.LastFreefallTick or 0);
            u216.LandingVelocityY = math.min(u216.HumanoidRootPart and u216.HumanoidRootPart.AssemblyLinearVelocity.Y or 0, u216.PeakFallVelocity or 0);
            u216.IsJumping = false;
            u216.IsLanded = true;
            u216.LandAtPosition = u216.HumanoidRootPart.CFrame.Position;
            u216.LastLandTick = tick();
            u216.ReadyToJump = true;
            u216.LockedAirDirection = nil;
            u216.CharacterAnimator:stop("Jump", 0.2);
            u216.Landed:Fire();
        end;
    end));
    u216.OriginalMoveFunction = u2.moveFunction;
    u216.IsDestroyed = false;
    task.delay(0.15, function() -- Line: 2157
        -- upvalues: u216 (copy), LocalPlayer (ref), u213 (copy), u215 (copy), ResetSpawnHumanoidState (ref)
        if u216.IsDestroyed then
            return;
        end;

        if LocalPlayer.Character == u213 and (u215.Parent and u215.Health > 0) then
            ResetSpawnHumanoidState(u215);
        end;
    end);
    local u226 = setmetatable({
        instance = u216
    }, {
        __mode = "v"
    });
    u216._characterRef = u226;

    function u2.moveFunction(p227, ...) -- Line: 2171
        -- upvalues: u226 (copy), u2 (ref)
        local instance = u226.instance;

        if instance and not instance.IsDestroyed then
            instance:MoveFunction(...);

            return;
        end;

        if instance and instance.OriginalMoveFunction then
            u2.moveFunction = instance.OriginalMoveFunction;
        end;
    end;

    u216.Janitor:Add(function() -- Line: 2186
        -- upvalues: u226 (copy), u216 (copy), u2 (ref)
        if u226 then
            u226.instance = nil;
        end;

        if not u216.IsDestroyed then
            u216.IsDestroyed = true;

            if u216.OriginalMoveFunction then
                u2.moveFunction = u216.OriginalMoveFunction;
                u216.OriginalMoveFunction = nil;
            end;
        end;
    end, true, "MoveFunctionCleanup");
    u216.Janitor:Add(u216.Landed:Connect(function() -- Line: 2202
        -- upvalues: u216 (copy), Remotes (ref)
        local v228 = u216.LandingVelocityY or u216.HumanoidRootPart.AssemblyLinearVelocity.Y;
        u216.CanceledInertia = false;
        u216.IsCrouchJumping = false;
        u216.JumpedOffLadder = false;

        if u216.HumanoidRootPart then
            local AssemblyLinearVelocity = u216.HumanoidRootPart.AssemblyLinearVelocity;
            local v229 = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z);
            local Magnitude = v229.Magnitude;

            if Magnitude > 19 then
                local v230 = v229 * math.max(0.4, 1 - (0.1 + (Magnitude - 19) * 0.03));
                u216.GlobalVelocity = v230;
                u216.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(v230.X, AssemblyLinearVelocity.Y, v230.Z);
            end;
        end;

        if v228 <= -42 and u216.LastLandTick - (u216.LastFreefallTick or u216.LastJumpTick) >= 0.3 then
            Remotes.Character.FallDamage.Send((math.abs((v228 - -42) / -35 * 100)));
            u216:TakeStamina(100);
        end;

        u216.LandingVelocityY = nil;
        u216.LastFreefallTick = nil;
    end), "Disconnect");
    u216.Janitor:Add(u216.Jumping:Connect(function() -- Line: 2256
        -- upvalues: u216 (copy), CurrentCamera (ref)
        u216.LocalVelocityOnJump = CurrentCamera.CFrame:VectorToObjectSpace(u216.GlobalVelocity);
        u216.GlobalDirectionOnJump = u216.GlobalDirection;
        u216.ReadyToJump = false;
    end), "Disconnect");
    u216.Janitor:Add(u216.ClimbBegan:Connect(function(p231) -- Line: 2266
        -- upvalues: u216 (copy)
        if not (p231 and (p231.Part and p231.Part.Parent)) then
            return;
        end;

        local v232 = u216:GetLadderCFrame(p231);

        if not v232 then
            return;
        end;

        local Position = v232.Position;

        if Position ~= Position or (math.abs(Position.X) > 50000 or (math.abs(Position.Y) > 50000 or math.abs(Position.Z) > 50000)) then
            return;
        end;

        local v233 = u216:ValidateHumanoidRootPart();

        if not v233 then
            return;
        end;

        local Position2 = v233.Position;

        if Position2 ~= Position2 or (math.abs(Position2.X) > 50000 or (math.abs(Position2.Y) > 50000 or math.abs(Position2.Z) > 50000)) then
            return;
        end;

        u216.GlobalVelocity = Vector3.new(0, 0, 0);
        v233.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
        v233.AssemblyAngularVelocity = Vector3.new(0, 0, 0);

        if not (u216.VectorForce.Attachment0 and u216.VectorForce.Attachment0.Parent) then
            return;
        end;

        local AssemblyMass2 = v233.AssemblyMass;
        local v234 = Vector3.new(0, ((AssemblyMass2 ~= AssemblyMass2 or (AssemblyMass2 <= 0 or AssemblyMass2 > 10000)) and 10 or AssemblyMass2) * workspace.Gravity, 0);

        if v234 ~= v234 or v234.Magnitude > 100000 then
            return;
        end;

        u216.VectorForce.Force = v234;
        task.defer(function() -- Line: 2335
            -- upvalues: u216 (ref)
            if u216.IsDestroyed or not u216.IsClimbing then
                return;
            end;

            local v235 = u216:ValidateHumanoidRootPart();

            if not v235 then
                u216:ForceExitLadder("HRP invalid after defer");

                return;
            end;

            local Position3 = v235.Position;

            if Position3 == Position3 then
                u216.VectorForce.Enabled = true;

                return;
            end;

            u216:ForceExitLadder("Position NaN during defer");
        end);
        u216.LadderZone = p231;
        u216.IsClimbing = true;
        u216.LastLadderAttachTick = tick();
        u216.LadderClimbPercentage = u216:GetLadderClimbPercentage(p231);
        u216.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true);
        u216.IsJumping = false;
        u216.IsJumpRequested = false;
        u216.JumpedOffLadder = false;
        u216.LastFreefallTick = nil;
        u216.PeakFallVelocity = 0;
        u216.LandingVelocityY = nil;
        u216.Climbing:Fire();
    end), "Disconnect");
    u216.Janitor:Add(u216.ClimbEnded:Connect(function(p236, p237) -- Line: 2381
        -- upvalues: u216 (copy)
        u216.VectorForce.Enabled = false;
        u216.IsClimbing = false;
        u216.LadderZone = nil;
        u216.LadderClimbPercentage = 0;
        u216.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false);
        u216.LastLadderJumpTick = tick();

        if p237 then
            u216.JumpedOffLadder = true;
        end;

        u216.Climbing:Fire();
    end), "Disconnect");
    local v238 = RunServiceController.CreateBindingName("Classes.Character.Update");
    u216.Janitor:Add(RunServiceController.BindToStepped(v238, function(p239, p240) -- Line: 2408
        -- upvalues: u216 (copy), CurrentCamera (ref), Remotes (ref)
        if u216.IsDestroyed then
            return;
        end;

        if u216.HumanoidRootPart and u216.HumanoidRootPart.Parent then
            local Position = u216.HumanoidRootPart.Position;

            if Position ~= Position or (math.abs(Position.X) > 50000 or (math.abs(Position.Y) > 50000 or math.abs(Position.Z) > 50000)) then
                warn("[Character] Detected invalid HumanoidRootPart position:", Position, "- forcing ladder exit and resetting velocity");

                if u216.IsClimbing then
                    u216:ForceExitLadder("Invalid position detected");
                end;

                if (Vector3.new(0, 0, 0)).Magnitude < 10000 then
                    u216.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
                    u216.GlobalVelocity = Vector3.new(0, 0, 0);
                end;

                return;
            end;
        end;

        u216:UpdateCharacterAnimations(p240);

        if u216.CrouchInputDown then
            u216:ToggleCrouchState(true);
        elseif not u216.CrouchHeadBlocked then
            u216:ToggleCrouchState(false);
        end;

        if not u216.IsClimbing and u216.Humanoid:GetState() == Enum.HumanoidStateType.Climbing then
            u216.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false);
            u216.Humanoid:ChangeState(Enum.HumanoidStateType.Running);
        end;

        u216:ResolveGroundedFreefall(u216.HumanoidRootPart);

        if u216.IsClimbing and u216.LadderZone then
            u216.LadderClimbPercentage = u216:GetLadderClimbPercentage(u216.LadderZone);
        end;

        if u216.Stamina < 100 then
            u216.Stamina = math.min(u216.Stamina + p240 * 100, 100);
        end;

        local _, v241, _ = CurrentCamera.CFrame:ToEulerAnglesYXZ();
        u216.TargetYRotation = v241;

        if (Vector3.new(u216.GlobalVelocity.X, 0, u216.GlobalVelocity.Z).Magnitude > 0.1 or u216.Humanoid.MoveDirection.Magnitude > 0.1) and true or u216.IsClimbing then
            local v242 = u216.TargetYRotation - u216.CurrentYRotation;

            if v242 == v242 and math.abs(v242) ~= (1 / 0) then
                local v243 = 0;

                while v242 > 3.141592653589793 and v243 < 10 do
                    v242 = v242 - 6.283185307179586;
                    v243 = v243 + 1;
                end;

                local v244 = 0;

                while v242 < -3.141592653589793 and v244 < 10 do
                    v242 = v242 + 6.283185307179586;
                    v244 = v244 + 1;
                end;
            else
                warn("[Character] Detected invalid rotation values - resetting. TargetY:", u216.TargetYRotation, "CurrentY:", u216.CurrentYRotation);
                u216.CurrentYRotation = v241;
                u216.TargetYRotation = v241;
                v242 = 0;
            end;

            local v245 = math.min(1, p240 * 20);
            u216.CurrentYRotation = u216.CurrentYRotation + v242 * v245;
            u216.AlignOrientation.RigidityEnabled = true;
            u216.AlignOrientation.MaxTorque = (1 / 0);
            u216.AlignOrientation.Enabled = true;
        else
            if v241 ~= v241 or math.abs(v241) == (1 / 0) then
                warn("[Character] Detected invalid camera rotation - skipping stationary rotation update");

                return;
            end;

            u216.CurrentYRotation = u216.TargetYRotation;
            u216.AlignOrientation.Enabled = false;

            if u216.HumanoidRootPart and u216.HumanoidRootPart.Parent then
                local Position = u216.HumanoidRootPart.Position;

                if Position == Position and (math.abs(Position.X) < 50000 and (math.abs(Position.Y) < 50000 and math.abs(Position.Z) < 50000)) then
                    u216.HumanoidRootPart.CFrame = CFrame.new(Position) * CFrame.Angles(0, u216.CurrentYRotation, 0);
                end;
            end;
        end;

        if u216.CurrentYRotation == u216.CurrentYRotation and math.abs(u216.CurrentYRotation) < 100 then
            u216.AlignOrientation.CFrame = CFrame.Angles(0, u216.CurrentYRotation, 0);
        end;

        local v246 = tick();

        if v246 - u216.LastLookAngleUpdate >= 0.05 then
            local Y = CurrentCamera.CFrame.LookVector.Y;
            local v247 = math.abs(v241 - u216.LastLookAngle);
            local v248 = math.abs(Y - u216.LastVerticalLook);

            if v247 > 0.1 or v248 > 0.1 then
                u216.LastLookAngle = v241;
                u216.LastVerticalLook = Y;
                u216.LastLookAngleUpdate = v246;
                Remotes.Character.UpdateLookAngle.Send({
                    HorizontalAngle = v241,
                    VerticalLook = Y
                });
            end;
        end;
    end));
    local v249 = CollectionService:GetTagged("Ladder");

    for _, v in pairs(v249) do
        u216:AddLadder(v);
    end;

    u216.Janitor:Add(CollectionService:GetInstanceAddedSignal("Ladder"):Connect(function(p250) -- Line: 2580
        -- upvalues: u216 (copy)
        if p250:IsA("BasePart") then
            u216:AddLadder(p250);
        end;
    end));
    u216.Janitor:Add(CollectionService:GetInstanceRemovedSignal("Ladder"):Connect(function(p251) -- Line: 2587
        -- upvalues: u216 (copy)
        if p251:IsA("BasePart") then
            u216:RemoveLadder(p251);
        end;
    end));
    u216._deadAttributeConnection = u213:GetAttributeChangedSignal("Dead"):Connect(function() -- Line: 2596
        -- upvalues: u213 (copy), u216 (copy)
        if u213:GetAttribute("Dead") and not u216.IsDestroyed then
            u216:Destroy();
        end;
    end);

    return u216;
end;

function u1.Destroy(p252) -- Line: 2612
    -- upvalues: u2 (copy)
    if p252.IsDestroyed then
        return;
    end;

    p252.IsDestroyed = true;

    if p252.CharacterAnimator then
        p252.CharacterAnimator:destroy();
        p252.CharacterAnimator = nil;
    end;

    if p252._characterRef then
        p252._characterRef.instance = nil;
        p252._characterRef = nil;
    end;

    if p252.OriginalMoveFunction then
        u2.moveFunction = p252.OriginalMoveFunction;
        p252.OriginalMoveFunction = nil;
    end;

    if p252._deadAttributeConnection then
        p252._deadAttributeConnection:Disconnect();
        p252._deadAttributeConnection = nil;
    end;

    if p252.MoveDirectionChanged then
        p252.MoveDirectionChanged:Destroy();
        p252.MoveDirectionChanged = nil;
    end;

    if p252.Crouching then
        p252.Crouching:Destroy();
        p252.Crouching = nil;
    end;

    if p252.ClimbBegan then
        p252.ClimbBegan:Destroy();
        p252.ClimbBegan = nil;
    end;

    if p252.ClimbEnded then
        p252.ClimbEnded:Destroy();
        p252.ClimbEnded = nil;
    end;

    if p252.Climbing then
        p252.Climbing:Destroy();
        p252.Climbing = nil;
    end;

    if p252.Jumping then
        p252.Jumping:Destroy();
        p252.Jumping = nil;
    end;

    if p252.Walking then
        p252.Walking:Destroy();
        p252.Walking = nil;
    end;

    if p252.Landed then
        p252.Landed:Destroy();
        p252.Landed = nil;
    end;

    if p252.LadderZones then
        table.clear(p252.LadderZones);
        p252.LadderZones = nil;
    end;

    p252.Character = nil;
    p252.HumanoidRootPart = nil;
    p252.Humanoid = nil;
    p252.LadderZone = nil;
    p252.LadderPart = nil;

    if p252.VectorForce then
        p252.VectorForce = nil;
    end;

    if p252.AlignOrientation then
        p252.AlignOrientation = nil;
    end;

    if p252.BombPlantTween then
        p252.BombPlantTween = nil;
    end;

    if p252.CrouchTween then
        p252.CrouchTween = nil;
    end;

    p252.DefaultCameraOffset = nil;
    p252.CrouchCameraOffset = nil;
    p252.GlobalVelocity = nil;
    p252.LocalVelocity = nil;
    p252.LocalVelocityOnJump = nil;
    p252.GlobalDirection = nil;
    p252.TargetMoveDirection = nil;
    p252.CurrentMoveDirection = nil;
    p252.WallNormal = nil;
    p252.LastWallNormal = nil;
    p252.LandingVelocityY = nil;
    p252.LockedAirDirection = nil;
    p252.Janitor:Destroy();
    p252.Janitor = nil;
end;

return u1;