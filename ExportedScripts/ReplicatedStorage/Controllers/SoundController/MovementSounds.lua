-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local LocalPlayer = Players.LocalPlayer;
local Sound = require(ReplicatedStorage.Classes.Sound);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Router = require(ReplicatedStorage.Database.Security.Router);
local Materials = require(ReplicatedStorage.Components.Common.VFXLibary.CreateImpact.Components.Materials);
local GetRayIgnore = require(ReplicatedStorage.Components.Common.GetRayIgnore);
local FlashEffect = require(ReplicatedStorage.Components.Common.VFXLibary.FlashEffect);
local u2 = {
    Concrete = "LandingConcrete",
    Brick = "LandingConcrete",
    Cobblestone = "LandingConcrete",
    Basalt = "LandingConcrete",
    Limestone = "LandingConcrete",
    Pavement = "LandingConcrete",
    Asphalt = "LandingConcrete",
    Rock = "LandingConcrete",
    Slate = "LandingConcrete",
    Granite = "LandingConcrete",
    Marble = "LandingConcrete",
    Pebble = "LandingConcrete",
    CeramicTiles = "LandingConcrete",
    Ground = "LandingDirt",
    Mud = "LandingDirt",
    Glass = "LandingGlass",
    Gravel = "LandingGravel",
    Rubber = "LandingRubber",
    Plastic = "LandingRubber",
    Sand = "LandingSand",
    Snow = "LandingSand",
    Grass = "LandingGrass",
    LeafyGrass = "LandingGrass",
    Metal = "LandingMetal",
    DiamondPlate = "LandingMetal",
    CorrodedMetal = "LandingMetal",
    ["Corroded Metal"] = "LandingMetal",
    Wood = "Wood",
    WoodPlanks = "WoodPlanks",
    Fabric = "LandingDirt",
    Carpet = "LandingDirt",
    Cardboard = "LandingDirt"
};
local u3 = nil;
local u4 = RaycastParams.new();
u4.FilterType = Enum.RaycastFilterType.Exclude;
u4.IgnoreWater = true;

local function GetFloorMaterial(p5, p6, p7) -- Line: 108
    -- upvalues: GetRayIgnore (copy), u4 (copy)
    local v8 = GetRayIgnore();

    if not table.find(v8, p5) then
        table.insert(v8, p5);
    end;

    u4.FilterDescendantsInstances = v8;
    local Position = p6.Position;

    for _, v in ipairs({ Vector3.new(0, 0, 0), Vector3.new(0.8, 0, 0), Vector3.new(-0.8, 0, 0), Vector3.new(0, 0, 0.8), Vector3.new(0, 0, -0.8) }) do
        local v9 = workspace:Raycast(Position + v, Vector3.new(0, -3.1, 0), u4);

        if v9 and v9.Normal.Y > 0.7 then
            return v9.Material.Name;
        end;
    end;

    if p7 then
        local v10 = p7:GetState();
        local FloorMaterial = p7.FloorMaterial;

        if ((v10 == Enum.HumanoidStateType.Running or v10 == Enum.HumanoidStateType.RunningNoPhysics) and true or v10 == Enum.HumanoidStateType.Landed) and FloorMaterial ~= Enum.Material.Air then
            return FloorMaterial.Name;
        end;
    end;

    return "Air";
end;

local function PlayFootstepSound(p11, p12, p13) -- Line: 162
    -- upvalues: u3 (ref), Materials (copy)
    if not u3 or (p12 == "" or p12 == "Air") then
        return nil;
    end;

    local v14 = u3.Sounds and not u3.Sounds:FindFirstChild(p12) and (Materials[p12] or "Ground") or p12;

    if not u3.Sounds or u3.Sounds:FindFirstChild(v14) then
        return u3:play({
            Parent = p11,
            Name = v14
        }, p13);
    end;

    warn(string.format("[FloorSound] Missing sound for category: \'%s\' (material: %s)", v14, p12));

    return nil;
end;

local function StopFootstepSound(p15) -- Line: 191
    if p15 and p15.Playing then
        p15:Stop();
    end;
end;

local function ResetAirborneTracking(p16) -- Line: 199
    p16.IsAirborne = false;
    p16.AirborneStartTime = 0;
    p16.PeakAirborneVelocityY = 0;
end;

local function ShouldRefreshFloorMaterial(p17, p18, p19, p20) -- Line: 207
    return p17.CurrentFloorMaterial == nil and true or (p17.IsAirborne or (p20 or ((p19 == Enum.HumanoidStateType.Freefall or (p19 == Enum.HumanoidStateType.Jumping or p19 == Enum.HumanoidStateType.Landed)) and true or math.abs(p18.Y) > 1)));
end;

local function PlayLandingSound(p21, p22, p23, p24, p25) -- Line: 224
    -- upvalues: GetFloorMaterial (copy), FlashEffect (copy), u2 (copy), PlayFootstepSound (copy), Router (copy)
    local v26 = tick();

    if v26 - p21.LastFloorSoundTime < 0.1 then
        return;
    end;

    p21.LastFloorSoundTime = v26;
    local v27 = p21.Player:GetAttribute("IsCrouching");
    local v28 = p25 or GetFloorMaterial(p23, p22, p24);
    local v29 = p21.IsLocalPlayer and FlashEffect.GetAudioFadeMultiplier() or 1;
    PlayFootstepSound(p22, u2[v28] or "LandingConcrete", (v27 and 0.4 or 1) * v29);

    if p21.IsLocalPlayer then
        Router.broadcastRouter("UpdatePlayerNoiseCone", "Landing", p22.Position, v28, v27);
    end;
end;

function u1.SetCharacter(u30, p31) -- Line: 248
    -- upvalues: GetFloorMaterial (copy)
    u30.Janitor:Cleanup();

    if not p31 then
        local CurrentFootstepSound = u30.CurrentFootstepSound;

        if CurrentFootstepSound and CurrentFootstepSound.Playing then
            CurrentFootstepSound:Stop();
        end;

        u30.CurrentFootstepSound = nil;
        u30.CurrentFloorMaterial = nil;
        u30.PrimaryPart = nil;
        u30.TimePassed = 0.25;
        u30.Character = nil;
        u30.Humanoid = nil;
        u30.IsAirborne = false;
        u30.AirborneStartTime = 0;
        u30.PeakAirborneVelocityY = 0;

        return;
    end;

    local HumanoidRootPart = p31:WaitForChild("HumanoidRootPart", 5);
    local v32 = p31:FindFirstChildOfClass("Humanoid");

    if not v32 then
        local v33 = tick();

        repeat
            task.wait(0.1);
            v32 = p31:FindFirstChildOfClass("Humanoid");
        until v32 or tick() - v33 > 5;
    end;

    if not (v32 and (HumanoidRootPart and p31.Parent)) then
        return;
    end;

    u30.PrimaryPart = HumanoidRootPart;
    u30.Humanoid = v32;
    u30.Character = p31;
    u30.TimePassed = 0.25;
    local v34 = GetFloorMaterial(p31, HumanoidRootPart, v32);
    u30.CurrentFloorMaterial = v34;
    u30.IsAirborne = v34 == "Air";
    u30.AirborneStartTime = not u30.IsAirborne and 0 or tick();
    u30.PeakAirborneVelocityY = not u30.IsAirborne and 0 or HumanoidRootPart.AssemblyLinearVelocity.Y;
    u30.Janitor:Add(v32.StateChanged:Connect(function(p35, p36) -- Line: 295
        -- upvalues: u30 (copy)
        u30:OnStateChanged(p35, p36);
    end));
end;

function u1.OnStateChanged(p37, p38, p39) -- Line: 302
    -- upvalues: PlayLandingSound (copy), GetFloorMaterial (copy), FlashEffect (copy), PlayFootstepSound (copy), Router (copy)
    local PrimaryPart = p37.PrimaryPart;
    local Character = p37.Character;
    local Humanoid = p37.Humanoid;

    if not (Humanoid and (PrimaryPart and Character)) then
        warn("[FloorSound] Character validation failed in OnStateChanged");

        return;
    end;

    if p39 == Enum.HumanoidStateType.Jumping or p39 == Enum.HumanoidStateType.Freefall then
        local CurrentFootstepSound = p37.CurrentFootstepSound;

        if CurrentFootstepSound and CurrentFootstepSound.Playing then
            CurrentFootstepSound:Stop();
        end;

        p37.CurrentFootstepSound = nil;
    end;

    if p38 ~= Enum.HumanoidStateType.Freefall and p39 ~= Enum.HumanoidStateType.Landed then
        if p39 == Enum.HumanoidStateType.Jumping then
            local v40 = tick();

            if v40 - p37.LastFloorSoundTime < 0.1 then
                return;
            end;

            p37.LastFloorSoundTime = v40;
            local v41 = p37.Player:GetAttribute("IsCrouching");
            local v42 = GetFloorMaterial(Character, PrimaryPart, Humanoid);
            local v43 = (v41 and 0.4 or 1) * (p37.IsLocalPlayer and FlashEffect.GetAudioFadeMultiplier() or 1);
            PlayFootstepSound(PrimaryPart, "Jump", v43);
            PlayFootstepSound(PrimaryPart, v42, v43);

            if p37.IsLocalPlayer then
                Router.broadcastRouter("UpdatePlayerNoiseCone", "Jump", PrimaryPart.Position, v42, v41);
            end;
        end;

        return;
    end;

    p37.IsAirborne = false;
    p37.AirborneStartTime = 0;
    p37.PeakAirborneVelocityY = 0;
    PlayLandingSound(p37, PrimaryPart, Character, Humanoid);
end;

function u1.Update(p44, p45, p46) -- Line: 356
    -- upvalues: GetFloorMaterial (copy), PlayLandingSound (copy), FlashEffect (copy), PlayFootstepSound (copy), Router (copy)
    local PrimaryPart = p44.PrimaryPart;
    local Character = p44.Character;
    local Humanoid = p44.Humanoid;
    local Player = p44.Player;

    if not PrimaryPart or (not Character or (not Character.Parent or (not Humanoid or Humanoid.Health <= 0))) then
        return;
    end;

    if p46 and not p44.IsLocalPlayer then
        local v47 = PrimaryPart.Position.X - p46.X;
        local v48 = PrimaryPart.Position.Y - p46.Y;
        local v49 = PrimaryPart.Position.Z - p46.Z;

        if v47 * v47 + v48 * v48 + v49 * v49 > 5625 then
            p44.IsAirborne = false;
            p44.AirborneStartTime = 0;
            p44.PeakAirborneVelocityY = 0;
            p44.CurrentFloorMaterial = nil;

            return;
        end;
    end;

    local v50 = tick();
    local AssemblyLinearVelocity = PrimaryPart.AssemblyLinearVelocity;
    local v51 = (AssemblyLinearVelocity.X * AssemblyLinearVelocity.X + AssemblyLinearVelocity.Z * AssemblyLinearVelocity.Z) ^ 0.5;
    local v52 = Humanoid:GetState();
    local v53 = Player:GetAttribute("IsCrouching");
    local v54 = Player:GetAttribute("IsWalking");
    local v55 = p44.IsLocalPlayer and Player:GetAttribute("IsSniperScoped") == true;
    local v56 = p44.TimePassed + p45;
    local v57 = not (v54 or (v53 or v55));

    if v57 then
        if v56 >= 0.3 then
            v57 = v51 >= 7.5;
        else
            v57 = false;
        end;
    end;

    if p44.CurrentFloorMaterial == nil and true or (p44.IsAirborne or (v57 or ((v52 == Enum.HumanoidStateType.Freefall or (v52 == Enum.HumanoidStateType.Jumping or v52 == Enum.HumanoidStateType.Landed)) and true or math.abs(AssemblyLinearVelocity.Y) > 1))) then
        p44.CurrentFloorMaterial = GetFloorMaterial(Character, PrimaryPart, Humanoid);
    end;

    local v58 = p44.CurrentFloorMaterial or "Air";

    if v58 ~= "Air" then
        if p44.IsAirborne then
            local v59 = v50 - p44.AirborneStartTime;
            local PeakAirborneVelocityY = p44.PeakAirborneVelocityY;
            p44.IsAirborne = false;
            p44.AirborneStartTime = 0;
            p44.PeakAirborneVelocityY = 0;

            if v59 >= 0.08 and PeakAirborneVelocityY <= -2.5 then
                PlayLandingSound(p44, PrimaryPart, Character, Humanoid, v58);
            end;
        end;
    elseif p44.IsAirborne then
        p44.PeakAirborneVelocityY = math.min(p44.PeakAirborneVelocityY, AssemblyLinearVelocity.Y);
    else
        p44.IsAirborne = true;
        p44.AirborneStartTime = v50;
        p44.PeakAirborneVelocityY = AssemblyLinearVelocity.Y;
    end;

    if v54 or v53 then
        return;
    end;

    if v55 then
        return;
    end;

    local v60 = v53 and 3.5 or 7.5;
    local v61 = v53 and 0.55 or 0.3;
    p44.TimePassed = p44.TimePassed + p45;

    if v61 <= p44.TimePassed then
        p44.TimePassed = p44.TimePassed - v61;

        if v50 - p44.LastFloorSoundTime < 0.1 then
            return;
        end;

        if v60 <= v51 then
            p44.LastFloorSoundTime = v50;
            p44.CurrentFootstepSound = PlayFootstepSound(PrimaryPart, v58, (v53 and 0.4 or 1) * (p44.IsLocalPlayer and FlashEffect.GetAudioFadeMultiplier() or 1));

            if p44.IsLocalPlayer then
                Router.broadcastRouter("UpdatePlayerNoiseCone", "Footstep", PrimaryPart.Position, v58, v53);
            end;
        end;
    end;
end;

function u1.new(p62) -- Line: 469
    -- upvalues: u1 (copy), Janitor (copy), LocalPlayer (copy), u3 (ref), Sound (copy)
    local v63 = setmetatable({}, u1);
    v63.Janitor = Janitor.new();
    v63.IsLocalPlayer = p62 == LocalPlayer;
    v63.Player = p62;
    v63.PrimaryPart = nil;
    v63.Character = nil;
    v63.Humanoid = nil;
    v63.TimePassed = 0.25;
    v63.CurrentFootstepSound = nil;
    v63.CurrentFloorMaterial = nil;
    v63.LastFloorSoundTime = 0;
    v63.IsAirborne = false;
    v63.AirborneStartTime = 0;
    v63.PeakAirborneVelocityY = 0;

    if not u3 then
        u3 = Sound.new("FloorSounds");
    end;

    return v63;
end;

function u1.Destroy(p64) -- Line: 507
    p64.Janitor:Destroy();
end;

return u1;