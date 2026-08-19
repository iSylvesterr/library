-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local SoundService = game:GetService("SoundService");
local PetModules = require(ReplicatedStorage.SharedModules.PetModules);
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local PetSizes = require(ReplicatedStorage.SharedData.PetSizes);
local PetTypes = require(ReplicatedStorage.SharedData.PetTypes);
local ButterflyWingColors = require(ReplicatedStorage.SharedModules.ButterflyWingColors);
local PetSpeedMultiplier = require(ReplicatedStorage.SharedModules.PetSpeedMultiplier);

local function ApplyPetTypeTag(p1, p2) -- Line: 19
    -- upvalues: PetTypes (copy)
    if not p1 then
        return;
    end;

    if p2 == PetTypes.Rainbow then
        if not p1:HasTag("PetRainbow") then
            p1:AddTag("PetRainbow");
        end;
    elseif p1:HasTag("PetRainbow") then
        p1:RemoveTag("PetRainbow");
    end;
end;

local Assets = ReplicatedStorage:WaitForChild("Assets");
local u3 = {
    StartOrder = 6
};
local u4 = {};
local u5 = {};
local u6 = {};
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;

local function GetChaseSpeed(p12) -- Line: 75
    -- upvalues: PetSpeedMultiplier (copy)
    local v13 = p12.Slot and p12.Slot:GetAttribute("VisualChaseSpeed");

    if type(v13) ~= "number" or v13 <= 0 then
        v13 = nil;
    end;

    local v14 = (v13 or (p12.Module and (p12.Module.FollowSpeed or 14) or 14)) * PetSpeedMultiplier.Get();
    local Owner = p12.Owner;

    if not Owner then
        return v14;
    end;

    local Character = Owner.Character;

    if Character then
        Character = Character:FindFirstChildOfClass("Humanoid");
    end;

    if Character then
        return v14 * math.max(1, Character.WalkSpeed / 16);
    end;

    return v14;
end;

local function YawOnlyCFrameFromHRP(p15) -- Line: 92
    local CFrame2 = p15.CFrame;
    local LookVector = CFrame2.LookVector;
    local v16 = Vector3.new(LookVector.X, 0, LookVector.Z);
    local Position = CFrame2.Position;

    return CFrame.lookAt(Position, Position + (v16.Magnitude < 0.0001 and Vector3.new(0, 0, -1) or v16.Unit));
end;

local u17 = RaycastParams.new();
u17.FilterType = Enum.RaycastFilterType.Exclude;
u17.IgnoreWater = false;
u17.RespectCanCollide = false;

local function RefreshGroundFilter() -- Line: 118
    -- upvalues: Players (copy), u7 (ref), u17 (copy)
    local v18 = {};

    for _, v in pairs(Players:GetPlayers()) do
        local Character = v.Character;

        if Character then
            table.insert(v18, Character);
        end;
    end;

    local PlayerPetReferences = workspace:FindFirstChild("PlayerPetReferences");

    if PlayerPetReferences then
        table.insert(v18, PlayerPetReferences);
    end;

    if u7 then
        table.insert(v18, u7);
    end;

    local Gardens = workspace:FindFirstChild("Gardens");

    if typeof(Gardens) == "Instance" then
        for _, child in pairs(Gardens:GetChildren()) do
            local Plants = child:FindFirstChild("Plants");

            if Plants then
                table.insert(v18, Plants);
            end;
        end;
    end;

    local PottedPlantVisuals = workspace:FindFirstChild("PottedPlantVisuals");

    if PottedPlantVisuals then
        table.insert(v18, PottedPlantVisuals);
    end;

    u17.FilterDescendantsInstances = v18;
end;

local u19 = (-1 / 0);

local function RefreshGroundFilterIfDue() -- Line: 144
    -- upvalues: u19 (ref), RefreshGroundFilter (copy)
    local v20 = os.clock();

    if v20 - u19 < 1 then
        return;
    end;

    u19 = v20;
    RefreshGroundFilter();
end;

local u21 = RaycastParams.new();
u21.FilterType = Enum.RaycastFilterType.Exclude;
u21.IgnoreWater = false;
u21.RespectCanCollide = false;

local function CastGroundY(p22, p23) -- Line: 157
    -- upvalues: u17 (copy), u21 (copy)
    local v24 = Vector3.new(p22.X, p23 + 200, p22.Z);
    local v25 = workspace:Raycast(v24, Vector3.new(0, -600, 0), u17);

    if not (v25 and v25.Instance) then
        return nil;
    end;

    local Instance2 = v25.Instance;

    if Instance2.Transparency < 0.99 and Instance2.CanCollide then
        return v25.Position.Y;
    end;

    local v26 = table.clone(u17.FilterDescendantsInstances);
    table.insert(v26, Instance2);
    u21.FilterDescendantsInstances = v26;

    for _ = 1, 8 do
        local v27 = workspace:Raycast(v24, Vector3.new(0, -600, 0), u21);

        if not (v27 and v27.Instance) then
            return nil;
        end;

        local Instance3 = v27.Instance;

        if Instance3.Transparency < 0.99 and Instance3.CanCollide then
            return v27.Position.Y;
        end;

        table.insert(v26, Instance3);
        u21.FilterDescendantsInstances = v26;
    end;

    return nil;
end;

local function ThrottledSlotGroundY(p28, p29) -- Line: 202
    -- upvalues: CastGroundY (copy)
    local v30 = os.clock();

    if (p28.SlotGroundCastNext or 0) <= v30 then
        local v31 = CastGroundY(p29, p29.Y);

        if v31 ~= nil then
            p28.SlotGroundCachedY = v31;
        end;

        p28.SlotGroundCastNext = v30 + 0.06666666666666667;
    end;

    return p28.SlotGroundCachedY;
end;

local function ComputeJumpOffset(p32) -- Line: 217
    if p32:GetAttribute("PetSpecies") ~= "Frog" then
        return 0;
    end;

    local v33 = p32:GetAttribute("SlotJumpStart");

    if typeof(v33) ~= "number" then
        return 0;
    end;

    local v34 = p32:GetAttribute("SlotJumpPeak");

    if typeof(v34) ~= "number" or v34 <= 0 then
        return 0;
    end;

    local v35 = p32:GetAttribute("SlotJumpDuration");

    if typeof(v35) ~= "number" or v35 <= 0 then
        return 0;
    end;

    local v36 = workspace:GetServerTimeNow() - v33;

    if v36 < 0 or v35 < v36 then
        return 0;
    end;

    local v37 = v36 / v35;

    return v34 * 4 * v37 * (1 - v37);
end;

local function BumpGeneration(p38) -- Line: 238
    -- upvalues: u6 (copy)
    local v39 = (u6[p38] or 0) + 1;
    u6[p38] = v39;

    return v39;
end;

local function CurrentGeneration(p40) -- Line: 245
    -- upvalues: u6 (copy)
    return u6[p40] or 0;
end;

local function ResolveSlotOwner(p41) -- Line: 250
    -- upvalues: Players (copy)
    local Parent = p41.Parent;

    if Parent and Parent:IsA("Folder") then
        return Players:FindFirstChild(Parent.Name);
    end;

    return nil;
end;

local function GetSpeciesPivotCFrame(p42) -- Line: 257
    if not p42 then
        return CFrame.identity;
    end;

    local Pivot = p42.Pivot;

    if typeof(Pivot) == "Vector3" then
        return CFrame.Angles(math.rad(Pivot.X), math.rad(Pivot.Y), (math.rad(Pivot.Z)));
    end;

    return CFrame.identity;
end;

local function ComputeFootOffset(p43) -- Line: 265
    local Y = p43:GetPivot().Position.Y;
    local v44 = (1 / 0);

    for _, descendant in pairs(p43:GetDescendants()) do
        if descendant:IsA("BasePart") and descendant.Transparency < 1 then
            local CFrame2 = descendant.CFrame;
            local Size = descendant.Size;
            local v45 = Size.X * 0.5;
            local v46 = Size.Y * 0.5;
            local v47 = Size.Z * 0.5;

            for i = -1, 1, 2 do
                for i2 = -1, 1, 2 do
                    local Y2 = (CFrame2 * Vector3.new(i * v45, i2 * v46, -1 * v47)).Y;

                    if Y2 >= v44 then
                        Y2 = v44;
                    end;

                    v44 = (CFrame2 * Vector3.new(i * v45, i2 * v46, 1 * v47)).Y;

                    if v44 >= Y2 then
                        v44 = Y2;
                    end;
                end;
            end;
        end;
    end;

    return v44 == (1 / 0) and 0 or Y - v44;
end;

local function GetOrCreateAnimator(p48) -- Line: 288
    local v49 = p48:FindFirstChildOfClass("AnimationController");

    if not v49 then
        v49 = Instance.new("AnimationController");
        v49.Parent = p48;
    end;

    local v50 = v49:FindFirstChildOfClass("Animator");

    if not v50 then
        v50 = Instance.new("Animator");
        v50.Parent = v49;
    end;

    return v50;
end;

local function FindAnimationsOnModel(p51, p52) -- Line: 303
    local v53 = {};
    local Animations = p51:FindFirstChild("Animations");

    if p52 then
        local v54 = {};

        for _, v in pairs(p52) do
            if type(v) == "string" and (v ~= "" and not v54[v]) then
                v54[v] = true;
                local v55 = Animations and Animations:FindFirstChild(v) or p51:FindFirstChild(v);

                if v55 and v55:IsA("Animation") then
                    v53[v] = v55;
                end;
            end;
        end;

        return v53;
    end;

    if Animations then
        for _, child in pairs(Animations:GetChildren()) do
            if child:IsA("Animation") then
                v53[child.Name] = child;
            end;
        end;
    end;

    for _, child in pairs(p51:GetChildren()) do
        if child:IsA("Animation") then
            v53[child.Name] = child;
        end;
    end;

    return v53;
end;

local function GetAnimNameForState(p56, p57) -- Line: 331
    if p56 then
        p56 = p56.Animations;
    end;

    if not p56 then
        return nil;
    end;

    if p57 == "idle" then
        return p56.Idle;
    end;

    if p57 == "walking" then
        return p56.Walk;
    end;

    if p57 == "flying" then
        return p56.Fly;
    end;

    if p57 == "flyidle" then
        return p56.FlyIdle or p56.Fly;
    end;

    if p57 == "landing" then
        return p56.Land;
    end;

    if p57 == "takeoff" then
        return p56.Takeoff;
    end;

    if p57 == "groundidle" then
        return p56.GroundIdle or p56.Idle;
    end;

    if p57 == "charge" then
        return p56.Charge or p56.Walk;
    end;

    if p57 == "bite" then
        return p56.Bite;
    end;

    if p57 == "tackle" then
        return p56.Tackle;
    end;

    if p57 == "idleangry" then
        return p56.IdleAngry or p56.Idle;
    end;

    if p57 == "throw" then
        return p56.Throw;
    end;

    if p57 == "peck" then
        return p56.Peck;
    end;

    if p57 == "dig" then
        return p56.Dig;
    end;

    if p57 == "spit" then
        return p56.Spit;
    end;

    if p57 == "targetplayer" then
        return p56.TargetPlayer or p56.Fly;
    end;

    if p57 == "grabplayer" then
        return p56.GrabPlayer;
    end;

    if p57 == "flyroar" then
        return p56.FlyRoar;
    end;

    if p57 == "groundroar" then
        return p56.GroundRoar;
    end;

    return nil;
end;

local function IsLoopingState(p58) -- Line: 357
    if p58 == "landing" then
        return false;
    end;

    if p58 == "takeoff" then
        return false;
    end;

    if p58 == "tackle" then
        return false;
    end;

    if p58 == "bite" then
        return false;
    end;

    if p58 == "throw" then
        return false;
    end;

    if p58 == "peck" then
        return false;
    end;

    if p58 == "grabplayer" then
        return false;
    end;

    if p58 == "spit" then
        return false;
    end;

    if p58 == "flyroar" then
        return false;
    end;

    return p58 ~= "groundroar";
end;

local function SwitchState(p59, p60) -- Line: 375
    -- upvalues: GetAnimNameForState (copy)
    if p60 == "takeoff" then
        local v61 = p59.Module and p59.Module.Animations;
        p60 = v61 and not v61.Takeoff and "flying" or p60;
    end;

    if p59.CurrentState == p60 then
        return;
    end;

    local CurrentState = p59.CurrentState;
    p59.CurrentState = p60;
    local v62;

    if CurrentState == "landing" or (CurrentState == "takeoff" or (CurrentState == "tackle" or (CurrentState == "bite" or (CurrentState == "throw" or (CurrentState == "peck" or (CurrentState == "grabplayer" or (CurrentState == "spit" or CurrentState == "flyroar"))))))) then
        v62 = false;
    else
        v62 = CurrentState ~= "groundroar";
    end;

    local v63 = v62 and 0.2 or 0.05;

    for _, v in pairs(p59.Tracks) do
        if v.IsPlaying then
            v:Stop(v63);
        end;
    end;

    local v64 = GetAnimNameForState(p59.Module, p60);

    if v64 then
        v64 = p59.Tracks[v64];
    end;

    if v64 then
        local v65;

        if p60 == "landing" or (p60 == "takeoff" or (p60 == "tackle" or (p60 == "bite" or (p60 == "throw" or (p60 == "peck" or (p60 == "grabplayer" or (p60 == "spit" or p60 == "flyroar"))))))) then
            v65 = false;
        else
            v65 = p60 ~= "groundroar";
        end;

        v64.Looped = v65;
        v64:Play(v64.Looped and 0.2 or 0.05);
    end;
end;

local function ApplyVisibility(p66, p67) -- Line: 400
    local v68 = p67 and 0 or 1;

    for _, descendant in pairs(p66.Model:GetDescendants()) do
        if descendant ~= p66.Model.PrimaryPart then
            if descendant:IsA("BasePart") then
                descendant.Transparency = v68;
            elseif descendant:IsA("Decal") then
                descendant.Transparency = v68;
            elseif descendant:IsA("ParticleEmitter") or (descendant:IsA("Trail") or (descendant:IsA("Beam") or (descendant:IsA("Fire") or (descendant:IsA("Smoke") or (descendant:IsA("Sparkles") or descendant:IsA("Light")))))) then
                if p67 then
                    local v69 = descendant:GetAttribute("OG_Enabled");

                    if v69 ~= nil then
                        descendant.Enabled = v69;
                        descendant:SetAttribute("OG_Enabled", nil);
                    end;
                else
                    if descendant:GetAttribute("OG_Enabled") == nil then
                        descendant:SetAttribute("OG_Enabled", descendant.Enabled);
                    end;

                    descendant.Enabled = false;
                end;
            end;
        end;
    end;
end;

local function GetSpitEmitters(p70) -- Line: 433
    if p70.SpitEmitters then
        return p70.SpitEmitters;
    end;

    local Model = p70.Model;

    if not Model then
        return nil;
    end;

    local v71 = nil;

    for _, descendant in pairs(Model:GetDescendants()) do
        if descendant:IsA("Attachment") and descendant.Name == "Spit" then
            v71 = descendant;
            break;
        end;
    end;

    if not v71 then
        return nil;
    end;

    local v72 = {};

    for _, descendant in pairs(v71:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            table.insert(v72, descendant);
        end;
    end;

    p70.SpitEmitters = v72;

    return v72;
end;

local function ApplySpitParticles(p73, p74) -- Line: 460
    -- upvalues: GetSpitEmitters (copy)
    local v75 = p74:GetAttribute("SwanSpitActive") == true;

    if p73.SpitParticlesOn == v75 then
        return;
    end;

    p73.SpitParticlesOn = v75;
    local v76 = GetSpitEmitters(p73);

    if not v76 then
        return;
    end;

    for _, v in pairs(v76) do
        v.Enabled = v75;
    end;
end;

local function GetHedgehogRollEffects(p77) -- Line: 475
    if p77.HedgehogRollEffects then
        return p77.HedgehogRollEffects;
    end;

    local Model = p77.Model;

    if not Model then
        return nil;
    end;

    local v78 = Model:FindFirstChild("RootPart", true) or Model.PrimaryPart;

    if not v78 then
        return nil;
    end;

    local v79 = {};

    for _, descendant in pairs(v78:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") then
            table.insert(v79, descendant);
        end;
    end;

    p77.HedgehogRollEffects = v79;

    return v79;
end;

local function ApplyHedgehogRollEffects(p80, p81) -- Line: 497
    -- upvalues: GetHedgehogRollEffects (copy)
    if p80.Species ~= "Hedgehog" then
        return;
    end;

    local v82 = p81:GetAttribute("AnimOverride");
    local v83 = v82 == "charge" and true or v82 == "tackle";

    if p80.HedgehogRollOn == v83 then
        return;
    end;

    local v84 = GetHedgehogRollEffects(p80);

    if not v84 then
        return;
    end;

    p80.HedgehogRollOn = v83;

    for _, v in pairs(v84) do
        if v:GetAttribute("OG_Enabled") == nil then
            v.Enabled = v83;
        else
            v:SetAttribute("OG_Enabled", v83);
        end;
    end;
end;

local function IsSlotPetVisible(p85) -- Line: 518
    -- upvalues: Players (copy)
    if p85:GetAttribute("PetVisible") == false then
        return false;
    end;

    local Parent = p85.Parent;
    local v86;

    if Parent and Parent:IsA("Folder") then
        v86 = Players:FindFirstChild(Parent.Name);
    else
        v86 = nil;
    end;

    if v86 and v86:GetAttribute("PetsHidden") == true then
        return false;
    end;

    if v86 then
        v86 = v86.Character;
    end;

    return (not v86 or v86:GetAttribute("Invisible") ~= true) and true or false;
end;

local function CloneSpeciesModel(p87) -- Line: 530
    -- upvalues: PetModules (copy), Assets (copy)
    local v88 = PetModules[p87];

    if not v88 then
        return nil, nil;
    end;

    local Pets = Assets:FindFirstChild("Pets");
    local v89 = Pets and Pets:FindFirstChild(v88.AssetName) or Assets:FindFirstChild(v88.AssetName);

    if not (v89 and v89:IsA("Model")) then
        return nil, nil;
    end;

    local v90 = v89:Clone();

    for _, descendant in pairs(v90:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.Anchored = false;
            descendant.CanCollide = false;
            descendant.CanQuery = false;
            descendant.CanTouch = true;
            descendant.Massless = true;
        end;
    end;

    return v90, v88;
end;

local function EnsurePrimaryPart(p91) -- Line: 550
    local PrimaryPart = p91.PrimaryPart;

    if PrimaryPart and PrimaryPart.Parent then
        return PrimaryPart;
    end;

    local v92 = p91:FindFirstChild("Torso") or (p91:FindFirstChild("RootPart") or p91:FindFirstChildWhichIsA("BasePart"));

    if v92 then
        p91.PrimaryPart = v92;
    end;

    return v92;
end;

local function EnsureSlotAttachment(p93, p94, p95) -- Line: 561
    local PetTarget = p93:FindFirstChild("PetTarget");

    if not PetTarget then
        PetTarget = Instance.new("Attachment");
        PetTarget.Name = "PetTarget";
        PetTarget.Parent = p93;
    end;

    local v96 = p95 or CFrame.identity;
    PetTarget.CFrame = CFrame.new(0, p94, 0) * v96;

    return PetTarget;
end;

local function BuildConstraints(p97, p98, p99) -- Line: 574
    local Attachment = Instance.new("Attachment");
    Attachment.Name = "PetPivot";
    Attachment.CFrame = p98;
    Attachment.Parent = p97;

    return Attachment;
end;

local u100 = Color3.fromRGB(255, 0, 0);
local u101 = Color3.new(0, 0, 0);
local u102 = { "LeftEye", "RightEye" };

local function ApplyEyeColor(p103, p104) -- Line: 589
    -- upvalues: u100 (copy), u101 (copy), u102 (copy)
    local Model = p103.Model;

    if not Model then
        return;
    end;

    local v105;

    if p104 then
        v105 = u100;
    else
        v105 = u101;
    end;

    for _, v in u102 do
        local v106 = Model:FindFirstChild(v);

        if v106 and v106:IsA("BasePart") then
            v106.Color = v105;
        end;
    end;
end;

local function SyncAttached(p107) -- Line: 602
    local v108 = p107.Slot:GetAttribute("PetAttached") ~= false;
    p107.Model:SetAttribute("AttachedToPetPart", v108);
end;

local function DestroyActive(p109) -- Line: 609
    -- upvalues: u6 (copy), u5 (copy), u4 (copy)
    u6[p109] = (u6[p109] or 0) + 1;
    u5[p109] = nil;
    local v110 = u4[p109];

    if v110 then
        u4[p109] = nil;

        for _, v in pairs(v110.Connections) do
            v:Disconnect();
        end;

        v110.Connections = {};

        for _, v in pairs(v110.Tracks) do
            v:Stop(0);
        end;

        if v110.CarryFruitModel then
            v110.CarryFruitModel:Destroy();
            v110.CarryFruitModel = nil;
        end;

        if v110.CarrySeedModel then
            v110.CarrySeedModel:Destroy();
            v110.CarrySeedModel = nil;
        end;

        if v110.StealHighlight then
            v110.StealHighlight:Destroy();
            v110.StealHighlight = nil;
        end;

        if v110.Model and v110.Model.Parent then
            v110.Model:Destroy();
        end;
    end;

    u6[p109] = nil;
end;

local function SnapModelToSlot(p111) -- Line: 636
    local Slot = p111.Slot;

    if not Slot.Parent then
        return;
    end;

    p111.Model:PivotTo(Slot.CFrame * p111.SlotAttachment.CFrame);
end;

local function BuildSlotModel(u112, u113) -- Line: 644
    -- upvalues: u5 (copy), u6 (copy), u4 (copy), u10 (ref), Players (copy), CloneSpeciesModel (copy), ButterflyWingColors (copy), PetSizes (copy), ComputeFootOffset (copy), EnsureSlotAttachment (copy), RunService (copy), u8 (ref), GetOrCreateAnimator (copy), FindAnimationsOnModel (copy), ApplyPetTypeTag (copy), ApplyEyeColor (copy), DestroyActive (ref), SwitchState (copy), ApplyVisibility (copy), IsSlotPetVisible (copy)
    if u5[u112] then
        return;
    end;

    local u114 = (u6[u112] or 0) + 1;
    u6[u112] = u114;
    u5[u112] = u114;

    local function Bail() -- Line: 653
        -- upvalues: u5 (ref), u112 (copy), u114 (copy), u113 (copy), u4 (ref), u10 (ref)
        if u5[u112] == u114 then
            u5[u112] = nil;
        end;

        if not u112.Parent then
            return;
        end;

        local v115 = u112:GetAttribute("PetSpecies");

        if type(v115) == "string" and (v115 ~= "" and (v115 ~= u113 or not u4[u112])) then
            task.defer(u10, u112);
        end;
    end;

    local Parent = u112.Parent;
    local v116;

    if Parent and Parent:IsA("Folder") then
        v116 = Players:FindFirstChild(Parent.Name);
    else
        v116 = nil;
    end;

    if not v116 then
        return Bail();
    end;

    local v117, v118 = CloneSpeciesModel(u113);

    if not (v117 and v118) then
        return Bail();
    end;

    v117:SetAttribute("PetID", u112:GetAttribute("PetId"));
    v117:SetAttribute("Owner", v116.Name);
    v117:SetAttribute("OwnerSlot", u112.Name);
    ButterflyWingColors.ApplyToModel(v117, u112:GetAttribute("PetId"));
    local PrimaryPart = v117.PrimaryPart;

    if not (PrimaryPart and PrimaryPart.Parent) then
        PrimaryPart = v117:FindFirstChild("Torso") or (v117:FindFirstChild("RootPart") or v117:FindFirstChildWhichIsA("BasePart"));

        if PrimaryPart then
            v117.PrimaryPart = PrimaryPart;
        end;
    end;

    if not PrimaryPart then
        v117:Destroy();

        return Bail();
    end;

    local v119;

    if v118 then
        local Pivot = v118.Pivot;

        if typeof(Pivot) == "Vector3" then
            v119 = CFrame.Angles(math.rad(Pivot.X), math.rad(Pivot.Y), (math.rad(Pivot.Z)));
        else
            v119 = CFrame.identity;
        end;
    else
        v119 = CFrame.identity;
    end;

    v117:PivotTo(v119);
    local v120 = PetSizes.GetScale(u112:GetAttribute("PetSize"), {
        Big = v118.BigScale,
        Huge = v118.HugeScale
    });

    if v120 ~= 1 then
        v117:ScaleTo(v120);
    end;

    local v121 = ComputeFootOffset(v117);
    local v122 = PrimaryPart.CFrame:Inverse() * v117:GetPivot();
    local v123 = EnsureSlotAttachment(u112, v121, v119);
    RunService.Heartbeat:Wait();
    local v124 = 0;

    while v124 < 60 and (u112.Position.Magnitude <= 1 and not u112:GetAttribute("SlotVisualIndex")) do
        RunService.Heartbeat:Wait();
        v124 = v124 + 1;

        if (u6[u112] or 0) ~= u114 or (not u112.Parent or u112:GetAttribute("PetSpecies") ~= u113) then
            v117:Destroy();

            return Bail();
        end;
    end;

    if (u6[u112] or 0) ~= u114 or (not u112.Parent or u112:GetAttribute("PetSpecies") ~= u113) then
        v117:Destroy();

        return Bail();
    end;

    v117:PivotTo(u112.CFrame * v123.CFrame);
    local Attachment = Instance.new("Attachment");
    Attachment.Name = "PetPivot";
    Attachment.CFrame = v122;
    Attachment.Parent = PrimaryPart;
    PrimaryPart.Anchored = true;
    v117.Parent = u8;

    if (u6[u112] or 0) ~= u114 or (not u112.Parent or u112:GetAttribute("PetSpecies") ~= u113) then
        if v117.Parent then
            v117:Destroy();
        end;

        return Bail();
    end;

    local u125 = GetOrCreateAnimator(v117);
    local v126 = FindAnimationsOnModel(v117, v118.Animations);
    local v127 = {};

    for i, v in pairs(v126) do
        local success, result = pcall(function() -- Line: 729
            -- upvalues: u125 (copy), v (copy)
            return u125:LoadAnimation(v);
        end);

        if success and result then
            result.Looped = true;
            result.Priority = Enum.AnimationPriority.Movement;
            v127[i] = result;
        end;
    end;

    local u128 = {
        Owner = v116,
        Slot = u112,
        Species = u113,
        Module = v118,
        Model = v117,
        Primary = PrimaryPart,
        Animator = u125,
        Tracks = v127,
        CurrentState = "",
        SlotAttachment = v123,
        PetAttachment = Attachment,
        FootOffset = v121,
        SpeciesPivotCFrame = v119,
        Generation = u114,
        Connections = {},
        LastAnimPos = u112.Position,
        LastAnimTime = os.clock(),
        AnimState = "idle",
        IsFlyer = v118.IsFlying == true
    };
    u4[u112] = u128;
    ApplyPetTypeTag(v117, u112:GetAttribute("PetType"));
    ApplyEyeColor(u128, u112:GetAttribute("BeeChasing") == true);
    table.insert(u128.Connections, v117.AncestryChanged:Connect(function(p129, p130) -- Line: 762
        -- upvalues: DestroyActive (ref), u112 (copy)
        if p130 == nil then
            DestroyActive(u112);
        end;
    end));
    task.spawn(function() -- Line: 766
        -- upvalues: RunService (ref), u4 (ref), u112 (copy), u128 (copy)
        RunService.Heartbeat:Wait();

        if not u4[u112] then
            return;
        end;

        local v131 = u128;
        local Slot = v131.Slot;

        if Slot.Parent then
            v131.Model:PivotTo(Slot.CFrame * v131.SlotAttachment.CFrame);
        end;

        u128.LastAnimPos = u112.Position;
        u128.LastAnimTime = os.clock();
    end);
    task.spawn(function() -- Line: 774
        -- upvalues: RunService (ref), u4 (ref), u112 (copy), u128 (copy), SwitchState (ref)
        RunService.Heartbeat:Wait();

        if not u4[u112] then
            return;
        end;

        local v132;

        if u128.IsFlyer then
            local v133 = u112:GetAttribute("FlightPhase") or "Flying";
            v132 = v133 == "Flying" and "flying" or (v133 == "Landing" and "landing" or (v133 == "Grounded" and "groundidle" or (v133 == "Takeoff" and "takeoff" or "flying")));
        else
            v132 = "idle";
        end;

        u128.CurrentState = "";
        SwitchState(u128, v132);
    end);
    ApplyVisibility(u128, (IsSlotPetVisible(u112)));

    if u5[u112] == u114 then
        u5[u112] = nil;
    end;
end;

u10 = function(p134) -- Line: 802, Name: SyncSlot
    -- upvalues: u4 (copy), DestroyActive (ref), u6 (copy), u5 (copy), Players (copy), u8 (ref), BuildSlotModel (copy), ApplyVisibility (copy), IsSlotPetVisible (copy)
    local v135 = p134:GetAttribute("PetSpecies");
    local v136 = u4[p134];

    if v136 and v136.Species ~= v135 then
        DestroyActive(p134);
        v136 = nil;
    end;

    if type(v135) == "string" and v135 ~= "" then
        if type(v135) == "string" and (v135 ~= "" and not v136) then
            BuildSlotModel(p134, v135);

            return;
        end;

        if v136 then
            v136.Model:SetAttribute("PetID", p134:GetAttribute("PetId"));
            ApplyVisibility(v136, (IsSlotPetVisible(p134)));
            local v137 = v136.Slot:GetAttribute("PetAttached") ~= false;
            v136.Model:SetAttribute("AttachedToPetPart", v137);
        end;

        return;
    end;

    u6[p134] = (u6[p134] or 0) + 1;
    u5[p134] = nil;
    local Parent = p134.Parent;
    local v138;

    if Parent and Parent:IsA("Folder") then
        v138 = Players:FindFirstChild(Parent.Name);
    else
        v138 = nil;
    end;

    if v138 and u8 then
        for _, child in pairs(u8:GetChildren()) do
            if child:GetAttribute("OwnerSlot") == p134.Name and child:GetAttribute("Owner") == v138.Name then
                child:Destroy();
            end;
        end;
    end;
end;

local u139 = nil;
local u140 = nil;
local u141 = nil;
local u142 = nil;
local u143 = {};

local function GetCarryFruitGenModule(p144) -- Line: 844
    -- upvalues: u143 (copy), u141 (ref), u142 (ref), ReplicatedStorage (copy)
    if u143[p144] ~= nil then
        return u143[p144];
    end;

    local v145 = not (u141 and u142) and ReplicatedStorage:FindFirstChild("PlantGenerationModules");

    if v145 then
        u141 = v145:FindFirstChild("Fruits");
        u142 = v145:FindFirstChild("Plants");
    end;

    local v146 = nil;

    if u141 and u141:FindFirstChild(p144) then
        v146 = u141;
    elseif u142 and u142:FindFirstChild(p144) then
        v146 = u142;
    end;

    if not v146 then
        u143[p144] = false;

        return false;
    end;

    local v147 = v146:FindFirstChild(p144);
    local success, result = pcall(require, v147);

    if success and result then
        u143[p144] = {
            Module = result,
            IsPlant = v146 == u142
        };

        return u143[p144];
    end;

    u143[p144] = false;

    return false;
end;

local function GetCarryFruitAsset(p148) -- Line: 874
    -- upvalues: u139 (ref), u140 (ref), ReplicatedStorage (copy)
    local v149 = not (u139 and u140) and ReplicatedStorage:FindFirstChild("Assets");

    if v149 then
        u139 = v149:FindFirstChild("Fruits");
        u140 = v149:FindFirstChild("Plants");
    end;

    local v150 = u139 and u139:FindFirstChild(p148);

    if v150 then
        return v150, false;
    end;

    local v151 = u140 and u140:FindFirstChild(p148);

    if v151 then
        return v151, true;
    end;

    return nil, false;
end;

local function LockCarryPart(p152) -- Line: 895
    p152.CanCollide = false;
    p152.CanQuery = false;
    p152.CanTouch = false;
    p152.Massless = true;
    p152.Anchored = false;
end;

local function AttachCarryFruit(u153, p154, p155, p156, p157, p158) -- Line: 904
    -- upvalues: GetCarryFruitAsset (copy), GetCarryFruitGenModule (copy), u9 (ref)
    if u153.CarryFruitModel then
        u153.CarryFruitModel:Destroy();
        u153.CarryFruitModel = nil;
    end;

    if not (u153.Primary and u153.Primary.Parent) then
        return;
    end;

    local FruitPosition = u153.Primary:FindFirstChild("FruitPosition");

    if not (FruitPosition and FruitPosition:IsA("Attachment")) then
        return;
    end;

    local v159, v160 = GetCarryFruitAsset(p154);

    if not v159 then
        return;
    end;

    local v161 = GetCarryFruitGenModule(p154);

    if not v161 then
        return;
    end;

    u153.CarryFruitToken = (u153.CarryFruitToken or 0) + 1;
    local CarryFruitToken = u153.CarryFruitToken;
    local u162 = v159:Clone();

    for _, descendant in pairs(u162:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false;
            descendant.CanQuery = false;
            descendant.CanTouch = false;
            descendant.Massless = true;
            descendant.Anchored = false;
        end;
    end;

    u162.DescendantAdded:Connect(function(p163) -- Line: 930
        if p163:IsA("BasePart") then
            p163.CanCollide = false;
            p163.CanQuery = false;
            p163.CanTouch = false;
            p163.Massless = true;
            p163.Anchored = false;
        end;
    end);

    if p158 and p158 ~= "" then
        u162:SetAttribute("Mutation", p158);
    end;

    local v164 = nil;

    if v160 and type(v161.Module.InitPlant) == "function" then
        v164 = pcall(v161.Module.InitPlant, u162, p155, p156, os.time());
    elseif type(v161.Module.InitFruit) == "function" then
        v164 = pcall(v161.Module.InitFruit, u162, p155, p156);
    end;

    if not v164 then
        u162:Destroy();

        return;
    end;

    u162:PivotTo(CFrame.new(0, -5000, 0));
    u162.Parent = u9;
    task.spawn(function() -- Line: 954
        -- upvalues: u162 (copy), u153 (copy), CarryFruitToken (copy), FruitPosition (copy)
        local v165 = 0;

        while u162 and (u162.Parent and not u162:HasTag("InitializationComplete")) do
            task.wait();
            v165 = v165 + 1;

            if v165 > 600 then
                break;
            end;
        end;

        if u153.CarryFruitToken ~= CarryFruitToken or not u162.Parent then
            u162:Destroy();

            return;
        end;

        u162:PivotTo(FruitPosition.WorldCFrame);
        local Part = Instance.new("Part");
        Part.Name = "CarryAnchor";
        Part.Size = Vector3.new(0.01, 0.01, 0.01);
        Part.Transparency = 1;
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.CanTouch = false;
        Part.Massless = true;
        Part.Anchored = true;
        Part.CFrame = FruitPosition.WorldCFrame;
        Part.Parent = u162;
        u162.PrimaryPart = Part;

        for _, descendant in pairs(u162:GetDescendants()) do
            if descendant:IsA("BasePart") and descendant ~= Part then
                descendant.Anchored = false;
                descendant.CanCollide = false;
                descendant.CanQuery = false;
                descendant.CanTouch = false;
                descendant.Massless = true;
            end;
        end;

        for _, descendant in pairs(u162:GetDescendants()) do
            if descendant:IsA("BasePart") and descendant ~= Part then
                local WeldConstraint = Instance.new("WeldConstraint");
                WeldConstraint.Part0 = Part;
                WeldConstraint.Part1 = descendant;
                WeldConstraint.Parent = descendant;
            end;
        end;

        u153.CarryFruitModel = u162;
        u153.CarryFruitAnchor = Part;
        u153.CarryFruitAttach = FruitPosition;
    end);
end;

local function ClearCarryFruit(p166) -- Line: 1007
    p166.CarryFruitToken = (p166.CarryFruitToken or 0) + 1;
    p166.CarryFruitAnchor = nil;
    p166.CarryFruitAttach = nil;

    if p166.CarryFruitModel then
        p166.CarryFruitModel:Destroy();
        p166.CarryFruitModel = nil;
    end;
end;

local u167 = nil;

local function GetCarrySeedAsset(p168) -- Line: 1019
    -- upvalues: u167 (ref), Assets (copy)
    if not u167 then
        u167 = Assets:FindFirstChild("Seeds");
    end;

    if u167 then
        return u167:FindFirstChild(p168);
    end;

    return nil;
end;

local function AttachOneSeed(p169, p170, p171, p172, p173) -- Line: 1033
    -- upvalues: u167 (ref), Assets (copy)
    if not u167 then
        u167 = Assets:FindFirstChild("Seeds");
    end;

    local v174;

    if u167 then
        v174 = u167:FindFirstChild(p171);
    else
        v174 = nil;
    end;

    if not v174 then
        return p173;
    end;

    local v175 = v174:Clone();
    local v176;

    if v175:IsA("Model") then
        v176 = v175;
    else
        if not v175:IsA("BasePart") then
            v175:Destroy();

            return p173;
        end;

        v176 = Instance.new("Model");
        v175.Parent = v176;
    end;

    for _, descendant in pairs(v176:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false;
            descendant.CanQuery = false;
            descendant.CanTouch = false;
            descendant.Massless = true;
            descendant.Anchored = false;
        end;
    end;

    if p172 ~= 1 then
        v176:ScaleTo(p172);
    end;

    v176:PivotTo(p170.CFrame);
    local v177, v178 = v176:GetBoundingBox();
    local Y = v178.Y;
    local Y2 = (p170.CFrame:Inverse() * v177.Position).Y;
    v176:PivotTo(p170.CFrame * CFrame.new(0, p173 + Y / 2 - Y2, 0));

    for _, descendant in pairs(v176:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.Anchored = false;
            local WeldConstraint = Instance.new("WeldConstraint");
            WeldConstraint.Part0 = p170;
            WeldConstraint.Part1 = descendant;
            WeldConstraint.Parent = descendant;
        end;
    end;

    for _, child in pairs(v176:GetChildren()) do
        child.Parent = p169;
    end;

    v176:Destroy();

    return p173 + Y;
end;

local function AttachCarrySeed(p179, p180) -- Line: 1089
    -- upvalues: PetSizes (copy), AttachOneSeed (copy), u9 (ref)
    if p179.CarrySeedModel then
        p179.CarrySeedModel:Destroy();
        p179.CarrySeedModel = nil;
    end;

    p179.CarrySeedAnchor = nil;
    p179.CarrySeedAttach = nil;

    if not (p179.Primary and p179.Primary.Parent) then
        return;
    end;

    if type(p180) ~= "table" or #p180 == 0 then
        return;
    end;

    local FruitPosition = p179.Primary:FindFirstChild("FruitPosition");

    if not (FruitPosition and FruitPosition:IsA("Attachment")) then
        return;
    end;

    local GetScale = PetSizes.GetScale;
    local v181 = p179.Slot and p179.Slot:GetAttribute("PetSize");
    local v182 = {};
    v182.Big = p179.Module and p179.Module.BigScale;
    v182.Huge = p179.Module and p179.Module.HugeScale;
    local v183 = GetScale(v181, v182);
    local Model = Instance.new("Model");
    Model.Name = "CarrySeeds";
    local Part = Instance.new("Part");
    Part.Name = "CarryAnchor";
    Part.Size = Vector3.new(0.01, 0.01, 0.01);
    Part.Transparency = 1;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CanTouch = false;
    Part.Massless = true;
    Part.Anchored = true;
    Part.CFrame = FruitPosition.WorldCFrame;
    Part.Parent = Model;
    Model.PrimaryPart = Part;
    local v184 = 0;

    for _, v in p180 do
        if type(v) == "string" and v ~= "" then
            v184 = AttachOneSeed(Model, Part, v, v183, v184);
        end;
    end;

    Model.Parent = u9;
    p179.CarrySeedModel = Model;
    p179.CarrySeedAnchor = Part;
    p179.CarrySeedAttach = FruitPosition;
end;

local function SetStealHighlight(p185, p186) -- Line: 1141
    if not p186 then
        if p185.StealHighlight then
            p185.StealHighlight:Destroy();
            p185.StealHighlight = nil;
        end;

        return;
    end;

    if p185.StealHighlight and p185.StealHighlight.Parent then
        return;
    end;

    if not p185.Model then
        return;
    end;

    local Highlight = Instance.new("Highlight");
    Highlight.Name = "FoxStealHighlight";
    Highlight.FillColor = Color3.fromRGB(255, 0, 0);
    Highlight.OutlineColor = Color3.fromRGB(255, 0, 0);
    Highlight.FillTransparency = 0.5;
    Highlight.OutlineTransparency = 0;
    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
    Highlight.Adornee = p185.Model;
    Highlight.Parent = p185.Model;
    p185.StealHighlight = Highlight;
end;

local function ClearCarrySeed(p187) -- Line: 1162
    p187.CarrySeedAnchor = nil;
    p187.CarrySeedAttach = nil;

    if p187.CarrySeedModel then
        p187.CarrySeedModel:Destroy();
        p187.CarrySeedModel = nil;
    end;
end;

local function WatchSlot(u188) -- Line: 1172
    -- upvalues: u10 (ref), DestroyActive (ref), u4 (copy), ApplyVisibility (copy), IsSlotPetVisible (copy), ApplyPetTypeTag (copy), ApplyEyeColor (copy), AttachCarryFruit (copy), AttachCarrySeed (copy), SetStealHighlight (copy), Players (copy)
    u188.CanQuery = false;
    u188:GetAttributeChangedSignal("PetSpecies"):Connect(function() -- Line: 1175
        -- upvalues: u10 (ref), u188 (copy)
        u10(u188);
    end);
    u188:GetAttributeChangedSignal("PetSize"):Connect(function() -- Line: 1177
        -- upvalues: DestroyActive (ref), u188 (copy), u10 (ref)
        DestroyActive(u188);
        u10(u188);
    end);
    u188:GetAttributeChangedSignal("PetVisible"):Connect(function() -- Line: 1182
        -- upvalues: u4 (ref), u188 (copy), ApplyVisibility (ref), IsSlotPetVisible (ref)
        local v189 = u4[u188];

        if not v189 then
            return;
        end;

        ApplyVisibility(v189, (IsSlotPetVisible(u188)));
    end);
    u188:GetAttributeChangedSignal("PetAttached"):Connect(function() -- Line: 1188
        -- upvalues: u4 (ref), u188 (copy)
        local v190 = u4[u188];

        if not v190 then
            return;
        end;

        local v191 = v190.Slot:GetAttribute("PetAttached") ~= false;
        v190.Model:SetAttribute("AttachedToPetPart", v191);
    end);
    u188:GetAttributeChangedSignal("PetId"):Connect(function() -- Line: 1194
        -- upvalues: u4 (ref), u188 (copy)
        local v192 = u4[u188];

        if not v192 then
            return;
        end;

        v192.Model:SetAttribute("PetID", u188:GetAttribute("PetId"));
    end);
    u188:GetAttributeChangedSignal("PetType"):Connect(function() -- Line: 1200
        -- upvalues: u4 (ref), u188 (copy), ApplyPetTypeTag (ref)
        local v193 = u4[u188];

        if not v193 then
            return;
        end;

        ApplyPetTypeTag(v193.Model, u188:GetAttribute("PetType"));
    end);
    u188:GetAttributeChangedSignal("BeeChasing"):Connect(function() -- Line: 1206
        -- upvalues: u4 (ref), u188 (copy), ApplyEyeColor (ref)
        local v194 = u4[u188];

        if not v194 then
            return;
        end;

        ApplyEyeColor(v194, u188:GetAttribute("BeeChasing") == true);
    end);
    u188:GetAttributeChangedSignal("CarryingFruit"):Connect(function() -- Line: 1212
        -- upvalues: u4 (ref), u188 (copy), AttachCarryFruit (ref)
        local v195 = u4[u188];

        if not v195 then
            return;
        end;

        local v196 = u188:GetAttribute("CarryingFruit");

        if typeof(v196) == "string" and v196 ~= "" then
            AttachCarryFruit(v195, v196, u188:GetAttribute("CarryingFruitSeed") or 0, u188:GetAttribute("CarryingFruitSize") or 1, u188:GetAttribute("CarryingFruitOvertimeGrowth") or 1, u188:GetAttribute("CarryingFruitMutation") or "");

            return;
        end;

        v195.CarryFruitToken = (v195.CarryFruitToken or 0) + 1;
        v195.CarryFruitAnchor = nil;
        v195.CarryFruitAttach = nil;

        if v195.CarryFruitModel then
            v195.CarryFruitModel:Destroy();
            v195.CarryFruitModel = nil;
        end;
    end);
    u188:GetAttributeChangedSignal("CarryingSeed"):Connect(function() -- Line: 1227
        -- upvalues: u4 (ref), u188 (copy), AttachCarrySeed (ref), SetStealHighlight (ref), Players (ref)
        local v197 = u4[u188];

        if not v197 then
            return;
        end;

        local v198 = u188:GetAttribute("CarryingSeed");

        if typeof(v198) == "string" and v198 ~= "" then
            AttachCarrySeed(v197, string.split(v198, "|"));
            SetStealHighlight(v197, u188:GetAttribute("CarryingSeedVictim") == Players.LocalPlayer.UserId);

            return;
        end;

        v197.CarrySeedAnchor = nil;
        v197.CarrySeedAttach = nil;

        if v197.CarrySeedModel then
            v197.CarrySeedModel:Destroy();
            v197.CarrySeedModel = nil;
        end;

        if v197.StealHighlight then
            v197.StealHighlight:Destroy();
            v197.StealHighlight = nil;
        end;
    end);
    u188.AncestryChanged:Connect(function(p199, p200) -- Line: 1240
        -- upvalues: DestroyActive (ref), u188 (copy)
        if p200 == nil then
            DestroyActive(u188);
        end;
    end);
    u10(u188);
end;

local function WatchPlayerFolder(p201) -- Line: 1247
    -- upvalues: WatchSlot (copy)
    for _, child in pairs(p201:GetChildren()) do
        if child:IsA("BasePart") and string.match(child.Name, "^PetPart%d+$") then
            WatchSlot(child);
        end;
    end;

    p201.ChildAdded:Connect(function(p202) -- Line: 1253
        -- upvalues: WatchSlot (ref)
        if p202:IsA("BasePart") and string.match(p202.Name, "^PetPart%d+$") then
            WatchSlot(p202);
        end;
    end);
end;

local function WatchRoot(p203) -- Line: 1260
    -- upvalues: WatchPlayerFolder (copy)
    for _, child in pairs(p203:GetChildren()) do
        if child:IsA("Folder") then
            WatchPlayerFolder(child);
        end;
    end;

    p203.ChildAdded:Connect(function(p204) -- Line: 1264
        -- upvalues: WatchPlayerFolder (ref)
        if p204:IsA("Folder") then
            WatchPlayerFolder(p204);
        end;
    end);
end;

local function RefreshVisibilityForPlayer(p205) -- Line: 1271
    -- upvalues: u4 (copy), ApplyVisibility (copy), IsSlotPetVisible (copy)
    for i, v in pairs(u4) do
        if v.Owner == p205 then
            ApplyVisibility(v, (IsSlotPetVisible(i)));
        end;
    end;
end;

local function WatchPlayerInvisibility(u206) -- Line: 1281
    -- upvalues: RefreshVisibilityForPlayer (copy)
    local function HookCharacter(p207) -- Line: 1282
        -- upvalues: RefreshVisibilityForPlayer (ref), u206 (copy)
        if not p207 then
            return;
        end;

        p207:GetAttributeChangedSignal("Invisible"):Connect(function() -- Line: 1284
            -- upvalues: RefreshVisibilityForPlayer (ref), u206 (ref)
            RefreshVisibilityForPlayer(u206);
        end);
        RefreshVisibilityForPlayer(u206);
    end;

    local Character = u206.Character;

    if Character then
        Character:GetAttributeChangedSignal("Invisible"):Connect(function() -- Line: 1284
            -- upvalues: RefreshVisibilityForPlayer (ref), u206 (copy)
            RefreshVisibilityForPlayer(u206);
        end);
        RefreshVisibilityForPlayer(u206);
    end;

    u206.CharacterAdded:Connect(HookCharacter);
    u206:GetAttributeChangedSignal("PetsHidden"):Connect(function() -- Line: 1294
        -- upvalues: RefreshVisibilityForPlayer (ref), u206 (copy)
        RefreshVisibilityForPlayer(u206);
    end);
end;

function u3.SnapPetsForPlayer(p208, p209) -- Line: 1299
    -- upvalues: u4 (copy)
    for i, v in pairs(u4) do
        if v.Owner == p209 and i.Parent then
            local v210 = i:GetAttribute("PetClaim");

            if type(v210) ~= "string" or v210 == "" then
                v.Model:PivotTo(i.CFrame * v.SlotAttachment.CFrame);
                v.LastAnimPos = i.Position;
                v.LastAnimTime = os.clock();
                v.LastVisualPos = v.Primary and v.Primary.Position;
                v.LastVisualTime = os.clock();
                v.SmoothedSpeed = 0;
                v.LastGoalChangeTime = nil;
                v.LastTrackedGoalXZ = nil;
            end;
        end;
    end;
end;

function u3.SnapLocalPetsToFollow(p211) -- Line: 1319
    -- upvalues: Players (copy), u4 (copy), CastGroundY (copy)
    local LocalPlayer = Players.LocalPlayer;
    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    if not Character then
        return;
    end;

    local CFrame2 = Character.CFrame;
    local LookVector = CFrame2.LookVector;
    local v212 = Vector3.new(LookVector.X, 0, LookVector.Z);
    local Position = CFrame2.Position;
    local v213 = CFrame.lookAt(Position, Position + (v212.Magnitude < 0.0001 and Vector3.new(0, 0, -1) or v212.Unit));

    for i, v in pairs(u4) do
        if v.Owner == LocalPlayer and (i.Parent and (v.Primary and v.Primary.Parent)) then
            local v214 = i:GetAttribute("PetClaim");

            if type(v214) ~= "string" or v214 == "" then
                local v215 = i:GetAttribute("SlotOffsetX");
                local v216 = i:GetAttribute("SlotOffsetZ");

                if typeof(v215) == "number" and typeof(v216) == "number" then
                    local v217 = i:GetAttribute("SlotHeightOffset") or 0;
                    local v218 = v213 * CFrame.new(v215, -2.5, v216);
                    local Position2 = v218.Position;
                    local v219 = CastGroundY(Position2, Position2.Y);

                    if v219 == nil then
                        v219 = Position2.Y;
                    end;

                    v.LastLocalGroundY = v219;
                    local v220;

                    if v.IsFlyer then
                        v220 = v219 + (v.FootOffset or 0) + v217;
                    else
                        v220 = v219 + (v.FootOffset or 0);
                    end;

                    local v221 = Vector3.new(Position2.X, v220, Position2.Z);
                    local v222 = v218 - v218.Position;
                    local v223 = math.atan2(-v222.LookVector.X, -v222.LookVector.Z);
                    local v224 = v.SpeciesPivotCFrame or CFrame.identity;
                    v.Primary.CFrame = CFrame.new(v221) * CFrame.Angles(0, v223, 0) * v224;
                    v.LocalGoalPos = v221;
                    v.LocalGoalRotation = v222;
                    v.LastYaw = v223;
                    v.LocalChase = true;
                    v.VirtualSlotPos = nil;
                    v.ForceFollowUntil = os.clock() + 0.4;
                    v.LastVisualPos = v221;
                    v.LastVisualTime = os.clock();
                    v.SmoothedSpeed = 0;
                    v.LastGoalChangeTime = nil;
                    v.LastTrackedGoalXZ = nil;
                    v.AnimState = "idle";
                end;
            end;
        end;
    end;
end;

local function FlightPhaseToState(p225) -- Line: 1378
    return p225 == "Flying" and "flying" or (p225 == "Landing" and "landing" or (p225 == "Grounded" and "groundidle" or (p225 == "Takeoff" and "takeoff" or "flying")));
end;

local function FindLocalOwlPrimary() -- Line: 1388
    -- upvalues: Players (copy), u4 (copy)
    local LocalPlayer = Players.LocalPlayer;

    for _, v in pairs(u4) do
        if v.Owner == LocalPlayer and v.Species == "Owl" then
            local Primary = v.Primary;

            if Primary and Primary.Parent then
                return Primary;
            end;
        end;
    end;

    return nil;
end;

local function PlayOwlHoot(p226) -- Line: 1401
    -- upvalues: u11 (ref), FindLocalOwlPrimary (copy), Players (copy), SoundService (copy)
    if type(p226) ~= "string" or p226 == "" then
        return;
    end;

    if u11 and (u11.Parent and u11.IsPlaying) then
        return;
    end;

    local v227 = FindLocalOwlPrimary();
    local v228;

    if v227 then
        v228 = v227;
    else
        v228 = Players.LocalPlayer.Character;

        if v228 then
            v228 = v228:FindFirstChild("HumanoidRootPart");
        end;

        if v228 then
            if not v228:IsA("BasePart") then
                v228 = v227;
            end;
        else
            v228 = v227;
        end;
    end;

    if not v228 then
        return;
    end;

    local Sound = Instance.new("Sound");
    Sound.Name = "OwlHoot";
    Sound.SoundId = p226;
    Sound.Volume = 4.5;
    Sound.RollOffMode = Enum.RollOffMode.InverseTapered;
    Sound.RollOffMinDistance = 10;
    Sound.RollOffMaxDistance = 400;
    local SFXGroup = SoundService:FindFirstChild("SFXGroup");

    if SFXGroup and SFXGroup:IsA("SoundGroup") then
        Sound.SoundGroup = SFXGroup;
    end;

    Sound.Parent = v228;
    u11 = Sound;
    Sound:Play();
    Sound.Ended:Once(function() -- Line: 1425
        -- upvalues: u11 (ref), Sound (copy)
        if u11 == Sound then
            u11 = nil;
        end;

        Sound:Destroy();
    end);
end;

function u3.Init(p229) -- Line: 1431
end;

function u3.Start(p230) -- Line: 1433
    -- upvalues: u7 (ref), u8 (ref), u9 (ref), WatchRoot (copy), Players (copy), WatchPlayerInvisibility (copy), Networking (copy), PlayOwlHoot (copy), RunService (copy), u3 (copy), u19 (ref), RefreshGroundFilter (copy), u4 (copy), GetChaseSpeed (copy), CastGroundY (copy), ComputeJumpOffset (copy), GetSpitEmitters (copy), ApplyHedgehogRollEffects (copy), SwitchState (copy)
    u7 = Instance.new("Folder");
    u7.Name = "_PetVisualClient";
    u7.Parent = workspace;
    u8 = Instance.new("Folder");
    u8.Name = "Models";
    u8.Parent = u7;
    u9 = Instance.new("Folder");
    u9.Name = "Carry";
    u9.Parent = u7;
    local v231 = workspace:FindFirstChild("PlayerPetReferences") or workspace:WaitForChild("PlayerPetReferences", 30);

    if not (v231 and v231:IsA("Folder")) then
        return;
    end;

    WatchRoot(v231);

    for _, v in pairs(Players:GetPlayers()) do
        WatchPlayerInvisibility(v);
    end;

    Players.PlayerAdded:Connect(WatchPlayerInvisibility);
    Networking.SFX.OwlHoot.OnClientEvent:Connect(PlayOwlHoot);
    Networking.Place.TeleportedBack.OnClientEvent:Connect(function() -- Line: 1457
        -- upvalues: RunService (ref), u3 (ref), Players (ref)
        task.spawn(function() -- Line: 1458
            -- upvalues: RunService (ref), u3 (ref), Players (ref)
            RunService.Heartbeat:Wait();
            u3:SnapPetsForPlayer(Players.LocalPlayer);
        end);
    end);
    local u232 = 0;

    local function HookLocalHumanoid(p233) -- Line: 1471
        -- upvalues: u232 (ref), Networking (ref)
        p233.Jumping:Connect(function(p234) -- Line: 1472
            -- upvalues: u232 (ref), Networking (ref)
            if not p234 then
                return;
            end;

            local v235 = os.clock();

            if v235 - u232 < 0.2 then
                return;
            end;

            u232 = v235;
            Networking.Pets.FrogJump:Fire();
        end);
    end;

    local function HookLocalCharacter(p236) -- Line: 1480
        -- upvalues: u232 (ref), Networking (ref)
        local v237 = p236:FindFirstChildOfClass("Humanoid") or p236:WaitForChild("Humanoid", 10);

        if v237 and v237:IsA("Humanoid") then
            v237.Jumping:Connect(function(p238) -- Line: 1472
                -- upvalues: u232 (ref), Networking (ref)
                if not p238 then
                    return;
                end;

                local v239 = os.clock();

                if v239 - u232 < 0.2 then
                    return;
                end;

                u232 = v239;
                Networking.Pets.FrogJump:Fire();
            end);
        end;
    end;

    Players.LocalPlayer.CharacterAdded:Connect(HookLocalCharacter);

    if Players.LocalPlayer.Character then
        task.spawn(HookLocalCharacter, Players.LocalPlayer.Character);
    end;

    Networking.Pets.SnapPetsBroadcast.OnClientEvent:Connect(function(p240) -- Line: 1493
        -- upvalues: Players (ref), RunService (ref), u3 (ref)
        if p240 == Players.LocalPlayer.UserId then
            return;
        end;

        local u241 = Players:GetPlayerByUserId(p240);

        if not u241 then
            return;
        end;

        task.spawn(function() -- Line: 1497
            -- upvalues: RunService (ref), u3 (ref), u241 (copy)
            RunService.Heartbeat:Wait();
            u3:SnapPetsForPlayer(u241);
        end);
    end);
    RunService:BindToRenderStep("PetVisualFollow", Enum.RenderPriority.Camera.Value + 1, function(p242) -- Line: 1504
        -- upvalues: Players (ref), u19 (ref), RefreshGroundFilter (ref), u4 (ref), GetChaseSpeed (ref), CastGroundY (ref), ComputeJumpOffset (ref)
        local LocalPlayer = Players.LocalPlayer;
        local Character = LocalPlayer.Character;

        if Character then
            Character = Character:FindFirstChild("HumanoidRootPart");
        end;

        local v243 = os.clock();

        if v243 - u19 >= 1 then
            u19 = v243;
            RefreshGroundFilter();
        end;

        for i, v in pairs(u4) do
            if i.Parent and (v.Primary and v.Primary.Parent) then
                local v244 = nil;
                local v245 = i:GetAttribute("SlotOverride");
                local v246 = i:GetAttribute("SlotOffsetX");
                local v247 = i:GetAttribute("SlotOffsetZ");
                local v248 = i:GetAttribute("SlotHeightOffset") or 0;
                local v249 = i:GetAttribute("PetClaim");
                local v250;

                if type(v249) == "string" then
                    v250 = v249 ~= "";
                else
                    v250 = false;
                end;

                if v250 then
                    v.ForceFollowUntil = nil;
                    v245 = true;
                elseif v.ForceFollowUntil and os.clock() < v.ForceFollowUntil then
                    if v.Owner == LocalPlayer and Character then
                        v245 = false;
                    else
                        v.ForceFollowUntil = nil;
                    end;
                elseif v.ForceFollowUntil then
                    v.ForceFollowUntil = nil;
                end;

                if v.Owner == LocalPlayer and (Character and (v245 ~= true and (typeof(v246) == "number" and typeof(v247) == "number"))) then
                    local CFrame2 = Character.CFrame;
                    local LookVector = CFrame2.LookVector;
                    local v251 = Vector3.new(LookVector.X, 0, LookVector.Z);
                    local Position = CFrame2.Position;
                    local v252 = CFrame.lookAt(Position, Position + (v251.Magnitude < 0.0001 and Vector3.new(0, 0, -1) or v251.Unit)) * CFrame.new(v246, -2.5, v247);
                    local Position2 = v252.Position;
                    local v253;

                    if v.IsFlyer then
                        v253 = Position2.Y + v248;
                    else
                        v253 = Position2.Y;
                    end;

                    local v254 = Vector3.new(Position2.X, v253, Position2.Z);
                    local v255 = v252 - v252.Position;
                    v.LocalGoalPos = v254;
                    v.LocalGoalRotation = v255;
                    v.LocalChase = true;
                    local v256 = Vector3.new(v254.X, 0, v254.Z);

                    if v.LastTrackedGoalXZ and (v256 - v.LastTrackedGoalXZ).Magnitude > 0.005 then
                        v.LastGoalChangeTime = os.clock();
                    end;

                    v.LastTrackedGoalXZ = v256;
                else
                    local CFrame2 = i.CFrame;

                    if CFrame2 ~= v.LastSlotCF then
                        local v257 = os.clock();

                        if v.LastSlotTickAt then
                            local v258 = v257 - v.LastSlotTickAt;

                            if v.SlotTickPeriod then
                                v.SlotTickPeriod = v.SlotTickPeriod * 0.7 + math.clamp(v258, 0.01, 0.2) * 0.3;
                            else
                                v.SlotTickPeriod = math.clamp(v258, 0.01, 0.2);
                            end;
                        end;

                        v.PrevSlotCF = v.LastSlotCF or CFrame2;
                        v.LastSlotCF = CFrame2;
                        v.LastSlotTickAt = v257;
                        v.LastGoalChangeTime = v257;
                    end;

                    if v.PrevSlotCF and v.LastSlotTickAt then
                        local v259 = v.SlotTickPeriod or 0.03333333333333333;
                        local v260 = (os.clock() - v.LastSlotTickAt) / v259;
                        local v261 = math.clamp(v260, 0, 1);
                        CFrame2 = v.PrevSlotCF:Lerp(CFrame2, v261);
                    end;

                    v244 = CFrame2 * v.SlotAttachment.CFrame;
                    v.InterpSlotCF = CFrame2;
                    v.LocalChase = false;
                end;

                if v.LocalChase then
                    local LocalGoalPos = v.LocalGoalPos;
                    local LocalGoalRotation = v.LocalGoalRotation;
                    local Position = v.Primary.CFrame.Position;
                    local v262 = LocalGoalPos.X - Position.X;
                    local v263 = LocalGoalPos.Z - Position.Z;
                    local v264 = math.sqrt(v262 * v262 + v263 * v263);
                    local v265 = 1 - math.exp(-60 * p242);
                    local v266 = GetChaseSpeed(v) * p242;
                    local v267, v268;

                    if v264 <= 0.05 or v264 <= v266 then
                        v267 = LocalGoalPos.X;
                        v268 = LocalGoalPos.Z;
                    else
                        local v269 = 1 / v264;
                        local v270 = v266 / math.max(v265, 0.001);
                        v267 = Position.X + v262 * v269 * v270;
                        v268 = Position.Z + v263 * v269 * v270;
                    end;

                    local v271;

                    if v.IsFlyer then
                        local v272 = (i:GetAttribute("SlotHeightOffset") or 0) / 1.5;
                        local v273 = math.clamp(v272, 0, 1);
                        local Y = LocalGoalPos.Y;
                        local v274;

                        if v273 < 1 then
                            local v275 = CastGroundY(Vector3.new(v267, Position.Y, v268), Position.Y) or (v.LastChaseGroundY or Position.Y);
                            local v276 = v.LastChaseGroundY or v275;
                            local v277 = math.clamp(18 * p242, 0, 1);
                            local v278 = v276 + (v275 - v276) * v277;
                            v.LastChaseGroundY = v278;
                            v274 = v278 + (v.FootOffset or 0);
                        else
                            v274 = Y;
                        end;

                        v271 = v274 * (1 - v273) + Y * v273;
                    else
                        local v279 = CastGroundY(Vector3.new(v267, Position.Y, v268), Position.Y) or (v.LastChaseGroundY or Position.Y);
                        local v280 = v.LastChaseGroundY or v279;
                        local v281 = math.clamp(18 * p242, 0, 1);
                        local v282 = v280 + (v279 - v280) * v281;
                        v.LastChaseGroundY = v282;
                        v271 = v282 + (v.FootOffset or 0) + ComputeJumpOffset(i);
                    end;

                    local v283 = Vector3.new(v267, v271, v268);
                    local v284 = v283 - Position;
                    local v285 = v284.Magnitude / math.max(p242, 0.001);
                    local v286 = math.atan2(-LocalGoalRotation.LookVector.X, -LocalGoalRotation.LookVector.Z);

                    if v285 > 0.5 then
                        local v287 = Vector3.new(v284.X, 0, v284.Z);

                        if v287.Magnitude > 0.0001 then
                            local Unit = v287.Unit;
                            v286 = math.atan2(-Unit.X, -Unit.Z);
                        end;
                    end;

                    local v288 = v.LastYaw or v286;
                    local v289 = v288 + ((v286 - v288 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * math.clamp(12 * p242, 0, 1);
                    v.LastYaw = v289;
                    v.VirtualSlotPos = nil;
                    local v290 = v.SpeciesPivotCFrame or CFrame.identity;
                    local v291 = CFrame.new(v283) * CFrame.Angles(0, v289, 0) * v290;
                    v.Primary.CFrame = v.Primary.CFrame:Lerp(v291, v265);
                else
                    local Position = v.Primary.CFrame.Position;
                    local Position2 = v244.Position;
                    local v292 = Position2.X - Position.X;
                    local v293 = Position2.Z - Position.Z;
                    local v294 = math.sqrt(v292 * v292 + v293 * v293);
                    local v295 = 1 - math.exp(-60 * p242);
                    local v296 = GetChaseSpeed(v) * p242;
                    local v297, v298, v299;

                    if v294 > 0.05 and v296 < v294 then
                        local v300 = 1 / v294;
                        local v301 = v296 / math.max(v295, 0.001);
                        v297 = Position.X + v292 * v300 * v301;
                        v298 = Position.Z + v293 * v300 * v301;
                        v299 = true;
                    else
                        v297 = Position2.X;
                        v298 = Position2.Z;
                        v299 = false;
                    end;

                    local v302;

                    if v.IsFlyer then
                        v302 = Position2.Y;
                    else
                        local v303 = CastGroundY(Vector3.new(v297, Position.Y, v298), Position.Y) or (v.LastChaseGroundY or Position.Y);
                        local v304 = v.LastChaseGroundY or v303;
                        local v305 = math.clamp(18 * p242, 0, 1);
                        local v306 = v304 + (v303 - v304) * v305;
                        v.LastChaseGroundY = v306;
                        v302 = v306 + (v.FootOffset or 0) + ComputeJumpOffset(i);
                    end;

                    local v307 = Vector3.new(v297, v302, v298);
                    local LookVector = (v.InterpSlotCF or v244).LookVector;
                    local v308 = math.atan2(-LookVector.X, -LookVector.Z);
                    local v309 = v307 - Position;

                    if v299 and v309.Magnitude / math.max(p242, 0.001) > 0.5 then
                        local v310 = Vector3.new(v309.X, 0, v309.Z);

                        if v310.Magnitude > 0.0001 then
                            local Unit = v310.Unit;
                            v308 = math.atan2(-Unit.X, -Unit.Z);
                        end;
                    end;

                    local v311 = v.LastYaw or v308;
                    local v312 = v311 + ((v308 - v311 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * math.clamp(12 * p242, 0, 1);
                    v.LastYaw = v312;
                    local v313 = v.SpeciesPivotCFrame or CFrame.identity;
                    local v314 = CFrame.new(v307) * CFrame.Angles(0, v312, 0) * v313;
                    v.Primary.CFrame = v.Primary.CFrame:Lerp(v314, v295);
                    v.VirtualSlotPos = nil;
                end;

                if v.CarryFruitAnchor and (v.CarryFruitAnchor.Parent and (v.CarryFruitAttach and v.CarryFruitAttach.Parent)) then
                    v.CarryFruitAnchor.CFrame = v.CarryFruitAttach.WorldCFrame;
                end;

                if v.CarrySeedAnchor and (v.CarrySeedAnchor.Parent and (v.CarrySeedAttach and v.CarrySeedAttach.Parent)) then
                    v.CarrySeedAnchor.CFrame = v.CarrySeedAttach.WorldCFrame;
                end;
            end;
        end;
    end);
    RunService.Heartbeat:Connect(function(p315) -- Line: 1743
        -- upvalues: u19 (ref), RefreshGroundFilter (ref), u4 (ref), CastGroundY (ref), GetSpitEmitters (ref), ApplyHedgehogRollEffects (ref), SwitchState (ref)
        local v316 = os.clock();

        if v316 - u19 >= 1 then
            u19 = v316;
            RefreshGroundFilter();
        end;

        for i, v in pairs(u4) do
            if i.Parent then
                local Position = i.Position;
                local SlotAttachment = v.SlotAttachment;

                if SlotAttachment and SlotAttachment.Parent then
                    local v317 = v.SpeciesPivotCFrame or CFrame.identity;
                    local v318;

                    if v.IsFlyer then
                        local v319 = (i:GetAttribute("SlotHeightOffset") or 0) / 1.5;
                        local v320 = math.clamp(v319, 0, 1);
                        local v321 = v.FootOffset or 0;
                        local v322 = i:GetAttribute("Perched") == true;
                        local v323 = i:GetAttribute("FlightPhase") == "Takeoff";
                        local v324;

                        if v320 < 1 and not (v322 or v323) then
                            local v325 = os.clock();

                            if (v.SlotGroundCastNext or 0) <= v325 then
                                local v326 = CastGroundY(Position, Position.Y);

                                if v326 ~= nil then
                                    v.SlotGroundCachedY = v326;
                                end;

                                v.SlotGroundCastNext = v325 + 0.06666666666666667;
                            end;

                            local SlotGroundCachedY = v.SlotGroundCachedY;

                            if SlotGroundCachedY == nil then
                                SlotGroundCachedY = v.LastGroundY or Position.Y;
                            end;

                            local v327 = v.LastGroundY or SlotGroundCachedY;
                            local v328 = math.clamp(18 * p315, 0, 1);
                            local v329 = v327 + (SlotGroundCachedY - v327) * v328;
                            v.LastGroundY = v329;
                            v324 = v329 - Position.Y + (v.FootOffset or 0);
                        else
                            v324 = v321;
                        end;

                        v318 = v324 * (1 - v320) + v321 * v320;
                    else
                        local v330 = os.clock();

                        if (v.SlotGroundCastNext or 0) <= v330 then
                            local v331 = CastGroundY(Position, Position.Y);

                            if v331 ~= nil then
                                v.SlotGroundCachedY = v331;
                            end;

                            v.SlotGroundCastNext = v330 + 0.06666666666666667;
                        end;

                        local SlotGroundCachedY = v.SlotGroundCachedY;

                        if SlotGroundCachedY == nil then
                            SlotGroundCachedY = v.LastGroundY or Position.Y;
                        end;

                        local v332 = v.LastGroundY or SlotGroundCachedY;
                        local v333 = math.clamp(18 * p315, 0, 1);
                        local v334 = v332 + (SlotGroundCachedY - v332) * v333;
                        v.LastGroundY = v334;
                        v318 = v334 - Position.Y + (v.FootOffset or 0);
                    end;

                    SlotAttachment.CFrame = CFrame.new(0, v318, 0) * v317;
                end;

                local v335 = i:GetAttribute("SwanSpitActive") == true;

                if v.SpitParticlesOn ~= v335 then
                    v.SpitParticlesOn = v335;
                    local v336 = GetSpitEmitters(v);

                    if v336 then
                        for _, v2 in pairs(v336) do
                            v2.Enabled = v335;
                        end;
                    end;
                end;

                ApplyHedgehogRollEffects(v, i);
                local v337 = i:GetAttribute("AnimOverride");

                if type(v337) == "string" and v337 ~= "" then
                    v.AnimState = v337;
                    SwitchState(v, v337);
                elseif v.IsFlyer then
                    local v338 = i:GetAttribute("FlightPhase") or "Flying";
                    local v339 = v338 == "Flying" and "flying" or (v338 == "Landing" and "landing" or (v338 == "Grounded" and "groundidle" or (v338 == "Takeoff" and "takeoff" or "flying")));
                    local v340 = v.Module and v.Module.Animations;

                    if v339 == "flying" and (v340 and v340.FlyIdle) then
                        local v341 = os.clock();
                        local v342 = 0;
                        local v343 = v.Primary and v.Primary.Position;

                        if v343 then
                            if v.LastVisualPos and v.LastVisualTime then
                                local v344 = math.max(0.001, v341 - v.LastVisualTime);
                                local Magnitude = (v343 - v.LastVisualPos).Magnitude;

                                if Magnitude < 50 then
                                    v342 = Magnitude / v344;
                                end;
                            end;

                            v.LastVisualPos = v343;
                            v.LastVisualTime = v341;
                        end;

                        local v345 = math.clamp(p315 * 6, 0, 1);
                        v.SmoothedSpeed = (v.SmoothedSpeed or 0) * (1 - v345) + v342 * v345;
                        local SmoothedSpeed = v.SmoothedSpeed;
                        local AnimState = v.AnimState;
                        v339 = SmoothedSpeed > 2 and "flying" or (SmoothedSpeed < 0.6 and "flyidle" or (AnimState ~= "flying" and AnimState ~= "flyidle" and "flying" or AnimState));
                    end;

                    v.AnimState = v339;
                    SwitchState(v, v339);
                else
                    local v346 = os.clock();
                    local v347 = 0;
                    local v348 = v.Primary and v.Primary.Position;

                    if v348 then
                        if v.LastVisualPos and v.LastVisualTime then
                            local v349 = math.max(0.001, v346 - v.LastVisualTime);
                            local Magnitude = (v348 - v.LastVisualPos).Magnitude;

                            if Magnitude < 50 then
                                v347 = Magnitude / v349;
                            end;
                        end;

                        v.LastVisualPos = v348;
                        v.LastVisualTime = v346;
                    end;

                    local v350 = math.clamp(p315 * 6, 0, 1);
                    v.SmoothedSpeed = (v.SmoothedSpeed or 0) * (1 - v350) + v347 * v350;
                    local SmoothedSpeed = v.SmoothedSpeed;
                    local v351 = v.AnimState or "idle";
                    local v352 = v351 ~= "idle" and v351 ~= "walking" and "idle" or v351;
                    local v353 = v352 == "idle" and SmoothedSpeed > 2 and "walking" or (v352 == "walking" and SmoothedSpeed < 0.6 and "idle" or v352);
                    v.AnimState = v353;
                    SwitchState(v, v353);
                end;
            end;
        end;
    end);
end;

return u3;