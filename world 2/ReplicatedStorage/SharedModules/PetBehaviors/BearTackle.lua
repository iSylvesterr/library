-- Decompiled with Potassium's decompiler.

local BehaviorBase = require(script.Parent.BehaviorBase);
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local PetTypes = require(ReplicatedStorage:WaitForChild("SharedData"):WaitForChild("PetTypes"));
local PetSizes = require(ReplicatedStorage:WaitForChild("SharedData"):WaitForChild("PetSizes"));
local PetFlags = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("Flags"):WaitForChild("PetFlags"));
local RagdollModule = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("RagdollModule"));
local SoundService = game:GetService("SoundService");
local Debris = game:GetService("Debris");
local Services = game:GetService("ServerScriptService"):WaitForChild("Services");

local function PlayBearSound(p1, p2, p3) -- Line: 39
    -- upvalues: SoundService (copy), Debris (copy)
    if not (p1 and p1.Parent) then
        return;
    end;

    local SFX = SoundService:FindFirstChild("SFX");

    if SFX then
        SFX = SFX:FindFirstChild("Bear");
    end;

    if SFX then
        SFX = SFX:FindFirstChild(p2);
    end;

    if not (SFX and SFX:IsA("Sound")) then
        return;
    end;

    local v4 = SFX:Clone();
    v4.Volume = p3;
    v4.Parent = p1;
    v4:Play();
    Debris:AddItem(v4, (v4.TimeLength <= 0 and 5 or v4.TimeLength) + 1);
end;

local u5 = nil;

local function GetBeeDefenseService() -- Line: 54
    -- upvalues: u5 (ref), Services (copy)
    if not u5 then
        u5 = require(Services:WaitForChild("BeeDefenseService"));
    end;

    return u5;
end;

local u6 = nil;
local u7 = nil;

local function GetPetRecord(p8, p9) -- Line: 66
    -- upvalues: u7 (ref), u6 (ref), Services (copy)
    if not u7 then
        u6 = require(Services:WaitForChild("DataService"));
        u7 = u6.GetPet;
    end;

    return u7(u6, p8, p9);
end;

local u10 = nil;
local u11 = 20;

local function ExemptVictim(u12) -- Line: 79
    -- upvalues: u10 (ref), Services (copy), u11 (ref)
    if not (u12 and u12.Parent) then
        return;
    end;

    if not u10 then
        local AntiCheatService = Services:WaitForChild("AntiCheatService");
        u10 = require(AntiCheatService:WaitForChild("Exemptions"));
        u11 = require(AntiCheatService:WaitForChild("Config")).Exemption.BEAR_TACKLE_DURATION or u11;
    end;

    pcall(function() -- Line: 87
        -- upvalues: u10 (ref), u12 (copy), u11 (ref)
        u10:Exempt(u12, u11);
    end);
end;

local u13 = nil;

local function DropStolenFruit(u14, u15) -- Line: 96
    -- upvalues: u13 (ref), Services (copy)
    if not (u15 and u15.Parent) then
        return;
    end;

    if not u13 then
        local success, result = pcall(require, Services:WaitForChild("StealService"));

        if success then
            u13 = result;
        end;
    end;

    if u13 then
        pcall(function() -- Line: 103
            -- upvalues: u13 (ref), u15 (copy)
            u13:CancelActiveSteal(u15);
        end);
        pcall(function() -- Line: 104
            -- upvalues: u13 (ref), u14 (copy), u15 (copy)
            u13:RecoverStolenFruit(u14, u15, true);
        end);
    end;
end;

local u16 = {
    Big = 1.3,
    Huge = 1.7
};

local function ThrowDistanceMultiplier(p17, p18) -- Line: 156
    -- upvalues: PetSizes (copy), u16 (copy), PetTypes (copy)
    local v19 = 1;
    local v20 = PetSizes.Normalize(p17);

    if v20 then
        v19 = v19 * (u16[v20] or 1);
    end;

    if p18 == PetTypes.Rainbow then
        v19 = v19 * 1.15;
    end;

    return v19;
end;

local function PickBySize(p21, p22, p23, p24) -- Line: 169
    -- upvalues: PetSizes (copy)
    local v25 = PetSizes.Normalize(p21);

    if v25 == "Huge" then
        return p24;
    end;

    if v25 == "Big" then
        return p23;
    end;

    return p22;
end;

local u26 = setmetatable({}, {
    __mode = "k"
});

local function IsShovelAggroOnCooldown(p27) -- Line: 182
    -- upvalues: u26 (copy)
    if not p27 then
        return false;
    end;

    local v28 = u26[p27];
    local v29;

    if v28 == nil then
        v29 = false;
    else
        v29 = os.clock() < v28;
    end;

    return v29;
end;

local function MarkShovelAggroStarted(p30, p31) -- Line: 188
    -- upvalues: u26 (copy)
    if not p30 then
        return;
    end;

    u26[p30] = os.clock() + p31;
end;

local u32 = setmetatable({}, {
    __index = BehaviorBase
});
u32.__index = u32;
u32.Name = "BearTackle";

local function MakeGoalCFrame(p33, p34) -- Line: 199
    local v35 = p34 - p33;
    local v36 = Vector3.new(v35.X, 0, v35.Z);

    if v36.Magnitude < 0.001 then
        return CFrame.new(p34);
    end;

    return CFrame.lookAt(p34, p34 + v36.Unit);
end;

local function MakeFacingCFrame(p37, p38) -- Line: 208
    local v39 = Vector3.new(p38.X, 0, p38.Z);

    if v39.Magnitude < 0.001 then
        return CFrame.new(p37);
    end;

    return CFrame.lookAt(p37, p37 + v39.Unit);
end;

local function MoveTo(p40, p41, p42) -- Line: 216
    local v43 = p40.Control:GetSlotPosition();

    if not v43 then
        return;
    end;

    local Control = p40.Control;
    local v44 = p41 - v43;
    local v45 = Vector3.new(v44.X, 0, v44.Z);
    local v46;

    if v45.Magnitude < 0.001 then
        v46 = CFrame.new(p41);
    else
        v46 = CFrame.lookAt(p41, p41 + v45.Unit);
    end;

    Control:SetGoal(v46, p42);
end;

local function DistanceTo(p47, p48) -- Line: 222
    local v49 = p47.Control:GetSlotPosition();

    return not v49 and (1 / 0) or (p48 - v49).Magnitude;
end;

local function TargetPosition(p50) -- Line: 228
    if not (p50 and p50.Player) then
        return nil;
    end;

    local Character = p50.Player.Character;

    if not Character then
        return nil;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
        return HumanoidRootPart.Position;
    end;

    return nil;
end;

local function IsUnattackable(p51) -- Line: 242
    return not p51 and true or (p51:GetAttribute("InSafeZone") == true and true or (p51:GetAttribute("IsInOwnGarden") == true and true or p51:GetAttribute("InMinigame") == true));
end;

local function IsTargetStillValid(p52, p53) -- Line: 255
    -- upvalues: u5 (ref), Services (copy)
    if not p53 then
        return false;
    end;

    local Player = p53.Player;

    if not (Player and Player.Parent) then
        return false;
    end;

    if not Player and true or (Player:GetAttribute("InSafeZone") == true and true or (Player:GetAttribute("IsInOwnGarden") == true and true or Player:GetAttribute("InMinigame") == true)) then
        return false;
    end;

    local Character = Player.Character;

    if not Character then
        return false;
    end;

    if not Character:FindFirstChild("HumanoidRootPart") then
        return false;
    end;

    local v54 = Character:FindFirstChildOfClass("Humanoid");

    if not v54 or v54.Health <= 0 then
        return false;
    end;

    if not p53.ShovelAggro then
        return true;
    end;

    if not u5 then
        u5 = require(Services:WaitForChild("BeeDefenseService"));
    end;

    local v55 = u5;

    if v55 then
        v55 = v55:GetShovelAggroTarget(p52.Player);
    end;

    return v55 == Player;
end;

local function GetHomePos(p56) -- Line: 275
    local v57 = nil;
    local v58 = p56.Player:GetAttribute("PlotId");

    if type(v58) == "number" then
        local Gardens = workspace:FindFirstChild("Gardens");

        if Gardens then
            v57 = Gardens:FindFirstChild("Plot" .. tostring(v58));
        end;
    end;

    if not v57 then
        return nil;
    end;

    local SpawnPoint = v57:FindFirstChild("SpawnPoint");

    if SpawnPoint and SpawnPoint:IsA("BasePart") then
        return SpawnPoint.Position;
    end;

    if v57:IsA("Model") then
        return v57:GetPivot().Position;
    end;

    return nil;
end;

local function GroundPinPosition(p59, p60, p61) -- Line: 295
    local v62 = RaycastParams.new();
    v62.FilterType = Enum.RaycastFilterType.Exclude;
    v62.IgnoreWater = true;
    local v63 = {};
    local PlayerPetReferences = workspace:FindFirstChild("PlayerPetReferences");

    if PlayerPetReferences then
        table.insert(v63, PlayerPetReferences);
    end;

    if p60 then
        table.insert(v63, p60);
    end;

    v62.FilterDescendantsInstances = v63;
    local v64 = workspace:Raycast(p59 + Vector3.new(0, 5, 0), Vector3.new(0, -250, 0), v62);
    local v65;

    if v64 then
        v65 = v64.Position.Y;
    else
        v65 = p59.Y - 3;
    end;

    return Vector3.new(p59.X, v65 + p61, p59.Z);
end;

local function PickTarget(p66) -- Line: 310
    -- upvalues: u5 (ref), Services (copy), u26 (copy)
    if not u5 then
        u5 = require(Services:WaitForChild("BeeDefenseService"));
    end;

    local v67 = u5;

    if not v67 then
        return nil;
    end;

    local Slot = p66.Slot;
    local v68;

    if Slot then
        local v69 = u26[Slot];

        if v69 == nil then
            v68 = false;
        else
            v68 = os.clock() < v69;
        end;
    else
        v68 = false;
    end;

    if not v68 then
        local v70 = v67:GetShovelAggroTarget(p66.Player);

        if v70 and (v70 and (v70:GetAttribute("InSafeZone") ~= true and (v70:GetAttribute("IsInOwnGarden") ~= true and v70:GetAttribute("InMinigame") ~= true))) then
            local Slot2 = p66.Slot;
            local ShovelAggroCooldown = p66.ShovelAggroCooldown;

            if Slot2 then
                u26[Slot2] = os.clock() + ShovelAggroCooldown;
            end;

            return {
                ShovelAggro = true,
                Player = v70
            };
        end;
    end;

    local v71 = v67:PickTargetFor(p66.Player);

    if v71 and v71.Player then
        local Player = v71.Player;

        if Player and (Player:GetAttribute("InSafeZone") ~= true and (Player:GetAttribute("IsInOwnGarden") ~= true and Player:GetAttribute("InMinigame") ~= true)) then
            return {
                ShovelAggro = false,
                Player = v71.Player
            };
        end;
    end;

    return nil;
end;

local function BeginPin(p72, p73, p74) -- Line: 335
    -- upvalues: RagdollModule (copy), ExemptVictim (copy)
    local Character = p73.Character;

    if not Character then
        return false;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        return false;
    end;

    pcall(function() -- Line: 343
        -- upvalues: RagdollModule (ref), Character (copy)
        RagdollModule:Ragdoll(Character);
    end);
    ExemptVictim(p73);
    local Attachment = Instance.new("Attachment");
    Attachment.Name = "BearTackleAttachment";
    Attachment.Parent = HumanoidRootPart;
    local AlignPosition = Instance.new("AlignPosition");
    AlignPosition.Name = "BearTackleAlign";
    AlignPosition.Mode = Enum.PositionAlignmentMode.OneAttachment;
    AlignPosition.Attachment0 = Attachment;
    AlignPosition.Position = p74;
    AlignPosition.MaxForce = 1000000;
    AlignPosition.MaxVelocity = 60;
    AlignPosition.Responsiveness = 50;
    AlignPosition.ApplyAtCenterOfMass = true;
    AlignPosition.Parent = HumanoidRootPart;
    HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
    p72._PinnedChar = Character;
    p72._PinnedHRP = HumanoidRootPart;
    p72._PinAttachment = Attachment;
    p72._PinAlign = AlignPosition;

    return true;
end;

local function SetPinPosition(p75, p76) -- Line: 371
    if p75._PinAlign and p75._PinAlign.Parent then
        p75._PinAlign.Position = p76;
    end;
end;

local function DestroyPinConstraints(p77) -- Line: 378
    if p77._PinAlign then
        if p77._PinAlign.Parent then
            p77._PinAlign:Destroy();
        end;

        p77._PinAlign = nil;
    end;

    if p77._PinAttachment then
        if p77._PinAttachment.Parent then
            p77._PinAttachment:Destroy();
        end;

        p77._PinAttachment = nil;
    end;
end;

local function ReleasePin(p78) -- Line: 392
    -- upvalues: RagdollModule (copy)
    if p78._PinAlign then
        if p78._PinAlign.Parent then
            p78._PinAlign:Destroy();
        end;

        p78._PinAlign = nil;
    end;

    if p78._PinAttachment then
        if p78._PinAttachment.Parent then
            p78._PinAttachment:Destroy();
        end;

        p78._PinAttachment = nil;
    end;

    if p78._PinnedChar then
        local _PinnedChar = p78._PinnedChar;
        pcall(function() -- Line: 396
            -- upvalues: RagdollModule (ref), _PinnedChar (copy)
            RagdollModule:Unragdoll(_PinnedChar);
        end);
    end;

    p78._PinnedChar = nil;
    p78._PinnedHRP = nil;
end;

local function BuildStates() -- Line: 402
    -- upvalues: PickTarget (copy), IsTargetStillValid (copy), GroundPinPosition (copy), BeginPin (copy), DropStolenFruit (copy), PlayBearSound (copy), GetHomePos (copy), ExemptVictim (copy), u5 (ref), Services (copy), RagdollModule (copy)
    return {
        Acquire = {
            Enter = function(p79) -- Line: 406, Name: Enter
                -- upvalues: PickTarget (ref)
                local v80 = PickTarget(p79);

                if not v80 then
                    p79:Stop("NoThreat");

                    return;
                end;

                p79.Target = v80;
                p79:TransitionTo("Chase");
            end
        },
        Chase = {
            Enter = function(p81) -- Line: 418, Name: Enter
                p81.Control:SetSlotAttribute("AnimOverride", "charge");
                local Target = p81.Target;
                local v82;

                if Target and Target.Player then
                    local Character = Target.Player.Character;

                    if Character then
                        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

                        if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
                            v82 = HumanoidRootPart.Position;
                        else
                            v82 = nil;
                        end;
                    else
                        v82 = nil;
                    end;
                else
                    v82 = nil;
                end;

                if v82 then
                    local ChaseSpeed = p81.ChaseSpeed;
                    local v83 = p81.Control:GetSlotPosition();

                    if not v83 then
                        return;
                    end;

                    local Control = p81.Control;
                    local v84 = v82 - v83;
                    local v85 = Vector3.new(v84.X, 0, v84.Z);
                    local v86;

                    if v85.Magnitude < 0.001 then
                        v86 = CFrame.new(v82);
                    else
                        v86 = CFrame.lookAt(v82, v82 + v85.Unit);
                    end;

                    Control:SetGoal(v86, ChaseSpeed);
                end;
            end,

            Update = function(p87, p88, p89) -- Line: 424, Name: Update
                -- upvalues: IsTargetStillValid (ref)
                if not IsTargetStillValid(p87, p87.Target) then
                    p87:TransitionTo("Acquire");

                    return;
                end;

                local Target = p87.Target;
                local v90;

                if Target and Target.Player then
                    local Character = Target.Player.Character;

                    if Character then
                        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

                        if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
                            v90 = HumanoidRootPart.Position;
                        else
                            v90 = nil;
                        end;
                    else
                        v90 = nil;
                    end;
                else
                    v90 = nil;
                end;

                if not v90 then
                    p87:TransitionTo("Acquire");

                    return;
                end;

                local ChaseSpeed = p87.ChaseSpeed;
                local v91 = p87.Control:GetSlotPosition();

                if v91 then
                    local Control = p87.Control;
                    local v92 = v90 - v91;
                    local v93 = Vector3.new(v92.X, 0, v92.Z);
                    local v94;

                    if v93.Magnitude < 0.001 then
                        v94 = CFrame.new(v90);
                    else
                        v94 = CFrame.lookAt(v90, v90 + v93.Unit);
                    end;

                    Control:SetGoal(v94, ChaseSpeed);
                end;

                local v95 = p87.Control:GetSlotPosition();

                if (not v95 and (1 / 0) or (v90 - v95).Magnitude) <= p87.TackleRadius then
                    p87:TransitionTo("Tackle");

                    return;
                end;

                if p87:TimeInState() < p87.ChaseLegTimeout then
                    return;
                end;

                p87:TransitionTo("Acquire");
            end
        },
        Tackle = {
            Enter = function(p96) -- Line: 450, Name: Enter
                -- upvalues: GroundPinPosition (ref), BeginPin (ref), DropStolenFruit (ref), PlayBearSound (ref)
                local Target = p96.Target;
                local v97;

                if Target and Target.Player then
                    local Character = Target.Player.Character;

                    if Character then
                        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

                        if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
                            v97 = HumanoidRootPart.Position;
                        else
                            v97 = nil;
                        end;
                    else
                        v97 = nil;
                    end;
                else
                    v97 = nil;
                end;

                local v98 = p96.Target and p96.Target.Player;

                if not (v97 and v98) then
                    p96:TransitionTo("Return");

                    return;
                end;

                p96._GroundPos = GroundPinPosition(v97, v98.Character, p96.PinHeight);

                if not BeginPin(p96, v98, p96._GroundPos) then
                    p96:TransitionTo("Return");

                    return;
                end;

                DropStolenFruit(p96.Player, v98);
                PlayBearSound(p96.Slot, "BearBite", 1);
                p96.Control:SetSlotAttribute("AnimOverride", "tackle");
                p96._AngrySet = false;
                local _GroundPos = p96._GroundPos;
                local AttackSpeed = p96.AttackSpeed;
                local v99 = p96.Control:GetSlotPosition();

                if v99 then
                    local Control = p96.Control;
                    local v100 = _GroundPos - v99;
                    local v101 = Vector3.new(v100.X, 0, v100.Z);
                    local v102;

                    if v101.Magnitude < 0.001 then
                        v102 = CFrame.new(_GroundPos);
                    else
                        v102 = CFrame.lookAt(_GroundPos, _GroundPos + v101.Unit);
                    end;

                    Control:SetGoal(v102, AttackSpeed);
                end;

                p96._HoldEndsAt = os.clock() + p96.HoldDuration;
                p96:TransitionTo("Hold");
            end
        },
        Hold = {
            Update = function(p103, p104, p105) -- Line: 480, Name: Update
                local v106 = p103.Target and p103.Target.Player;

                if not (v106 and (v106.Parent and (p103._PinnedHRP and p103._PinnedHRP.Parent))) then
                    p103:TransitionTo("Return");

                    return;
                end;

                local _PinnedChar = p103._PinnedChar;

                if _PinnedChar then
                    _PinnedChar = _PinnedChar:FindFirstChildOfClass("Humanoid");
                end;

                if not _PinnedChar or (not _PinnedChar.Parent or _PinnedChar.Health <= 0) then
                    p103:TransitionTo("Return");

                    return;
                end;

                local _GroundPos = p103._GroundPos;

                if p103._PinAlign and p103._PinAlign.Parent then
                    p103._PinAlign.Position = _GroundPos;
                end;

                local _GroundPos2 = p103._GroundPos;
                local AttackSpeed = p103.AttackSpeed;
                local v107 = p103.Control:GetSlotPosition();

                if v107 then
                    local Control = p103.Control;
                    local v108 = _GroundPos2 - v107;
                    local v109 = Vector3.new(v108.X, 0, v108.Z);
                    local v110;

                    if v109.Magnitude < 0.001 then
                        v110 = CFrame.new(_GroundPos2);
                    else
                        v110 = CFrame.lookAt(_GroundPos2, _GroundPos2 + v109.Unit);
                    end;

                    Control:SetGoal(v110, AttackSpeed);
                end;

                if not p103._AngrySet and p103:TimeInState() >= p103.TackleAnimDuration then
                    p103._AngrySet = true;
                    p103.Control:SetSlotAttribute("AnimOverride", "idleangry");
                end;

                if p103._HoldEndsAt <= p104 then
                    p103:TransitionTo("Lift");
                end;
            end
        },
        Lift = {
            Enter = function(p111) -- Line: 508, Name: Enter
                -- upvalues: GetHomePos (ref)
                p111.Control:SetSlotAttribute("AnimOverride", "throw");
                local v112 = p111.Control:GetSlotPosition() or p111._GroundPos;
                local v113 = GetHomePos(p111);
                local v114;

                if v113 then
                    v114 = v112 - v113;
                else
                    v114 = nil;
                end;

                if not v114 or Vector3.new(v114.X, 0, v114.Z).Magnitude < 0.001 then
                    v114 = v112 - p111._GroundPos;
                end;

                local v115 = Vector3.new(v114.X, 0, v114.Z);

                if v115.Magnitude < 0.001 then
                    p111._ThrowDir = Vector3.new(0, 0, -1);
                else
                    p111._ThrowDir = v115.Unit;
                end;

                p111._LiftEndsAt = os.clock() + p111.LiftDuration;
                local Control = p111.Control;
                local _ThrowDir = p111._ThrowDir;
                local v116 = Vector3.new(_ThrowDir.X, 0, _ThrowDir.Z);
                local v117;

                if v116.Magnitude < 0.001 then
                    v117 = CFrame.new(v112);
                else
                    v117 = CFrame.lookAt(v112, v112 + v116.Unit);
                end;

                Control:SetGoal(v117, p111.AttackSpeed);
            end,

            Update = function(p118, p119, p120) -- Line: 533, Name: Update
                local v121 = p118.Target and p118.Target.Player;

                if not (v121 and (v121.Parent and (p118._PinnedHRP and p118._PinnedHRP.Parent))) then
                    p118:TransitionTo("Return");

                    return;
                end;

                local v122 = p118.Control:GetSlotPosition() or p118._GroundPos;
                local v123 = v122 + Vector3.new(0, p118.LiftHeight, 0);

                if p118._PinAlign and p118._PinAlign.Parent then
                    p118._PinAlign.Position = v123;
                end;

                local Control = p118.Control;
                local _ThrowDir = p118._ThrowDir;
                local v124 = Vector3.new(_ThrowDir.X, 0, _ThrowDir.Z);
                local v125;

                if v124.Magnitude < 0.001 then
                    v125 = CFrame.new(v122);
                else
                    v125 = CFrame.lookAt(v122, v122 + v124.Unit);
                end;

                Control:SetGoal(v125, p118.AttackSpeed);

                if p118._LiftEndsAt <= p119 then
                    p118:TransitionTo("Throw");
                end;
            end
        },
        Throw = {
            Enter = function(u126) -- Line: 553, Name: Enter
                -- upvalues: ExemptVictim (ref), u5 (ref), Services (ref), PlayBearSound (ref), RagdollModule (ref)
                local _PinnedHRP = u126._PinnedHRP;
                local _PinnedChar = u126._PinnedChar;
                local v127 = u126._ThrowDir or Vector3.new(0, 0, -1);
                local v128 = u126.Target and u126.Target.Player;

                if v128 then
                    ExemptVictim(v128);
                end;

                if not u5 then
                    u5 = require(Services:WaitForChild("BeeDefenseService"));
                end;

                local u129 = u5;

                if u129 then
                    pcall(function() -- Line: 571
                        -- upvalues: u129 (copy), u126 (copy)
                        u129:ClearShovelAggro(u126.Player);
                    end);
                end;

                if u126._PinAlign then
                    if u126._PinAlign.Parent then
                        u126._PinAlign:Destroy();
                    end;

                    u126._PinAlign = nil;
                end;

                if u126._PinAttachment then
                    if u126._PinAttachment.Parent then
                        u126._PinAttachment:Destroy();
                    end;

                    u126._PinAttachment = nil;
                end;

                u126._PinnedChar = nil;
                u126._PinnedHRP = nil;
                PlayBearSound(u126.Slot, "BearThrow", 1.75);

                if _PinnedHRP and _PinnedHRP.Parent then
                    local v130 = v127 * (u126.ThrowForce * u126.ThrowDistanceMult) + Vector3.new(0, u126.ThrowUp, 0);
                    local BodyVelocity = Instance.new("BodyVelocity");
                    BodyVelocity.MaxForce = Vector3.new(inf, inf, inf);
                    BodyVelocity.Velocity = v130;
                    BodyVelocity.Parent = _PinnedHRP;
                    task.delay(0.35, function() -- Line: 593
                        -- upvalues: BodyVelocity (copy)
                        if BodyVelocity and BodyVelocity.Parent then
                            BodyVelocity:Destroy();
                        end;
                    end);
                end;

                if _PinnedChar then
                    task.delay(1.5, function() -- Line: 601
                        -- upvalues: RagdollModule (ref), _PinnedChar (copy)
                        pcall(function() -- Line: 602
                            -- upvalues: RagdollModule (ref), _PinnedChar (ref)
                            RagdollModule:Unragdoll(_PinnedChar);
                        end);
                    end);
                end;

                local v131 = u126.Control:GetSlotPosition();

                if v131 then
                    local Control = u126.Control;
                    local v132 = Vector3.new(v127.X, 0, v127.Z);
                    local v133;

                    if v132.Magnitude < 0.001 then
                        v133 = CFrame.new(v131);
                    else
                        v133 = CFrame.lookAt(v131, v131 + v132.Unit);
                    end;

                    Control:SetGoal(v133, u126.AttackSpeed);
                end;

                u126._ThrowEndsAt = os.clock() + u126.ThrowAnimDuration;
            end,

            Update = function(p134, p135, p136) -- Line: 615, Name: Update
                local v137 = p134.Control:GetSlotPosition();

                if v137 then
                    local v138 = p134._ThrowDir or Vector3.new(0, 0, -1);
                    local Control = p134.Control;
                    local v139 = Vector3.new(v138.X, 0, v138.Z);
                    local v140;

                    if v139.Magnitude < 0.001 then
                        v140 = CFrame.new(v137);
                    else
                        v140 = CFrame.lookAt(v137, v137 + v139.Unit);
                    end;

                    Control:SetGoal(v140, p134.AttackSpeed);
                end;

                if p134._ThrowEndsAt <= p135 then
                    p134:TransitionTo("Return");
                end;
            end
        },
        Return = {
            Enter = function(p141) -- Line: 628, Name: Enter
                p141:Stop("Disengaged");
            end
        }
    };
end;

function u32.new(p142) -- Line: 637
    -- upvalues: BehaviorBase (copy), u32 (copy), u7 (ref), u6 (ref), Services (copy), PetFlags (copy), PetSizes (copy), u16 (copy), PetTypes (copy), BuildStates (copy)
    local v143 = BehaviorBase.New(u32, p142);
    local Player = v143.Player;
    local PetId = v143.PetId;

    if not u7 then
        u6 = require(Services:WaitForChild("DataService"));
        u7 = u6.GetPet;
    end;

    local v144 = u7(u6, Player, PetId);
    local v145;

    if v144 then
        v145 = v144.Size;
    else
        v145 = nil;
    end;

    v143.AttackSpeed = PetFlags.BearAttackSpeed:Get();
    v143.ChaseSpeed = v143.AttackSpeed * (v143.Config.ChaseSpeedMultiplier or 1.3);
    local v146 = v143.Config.TackleRadius or 4;
    local v147 = v143.Config.TackleRadiusBig or 6;
    local v148 = v143.Config.TackleRadiusHuge or 8;
    local v149 = PetSizes.Normalize(v145);

    if v149 == "Huge" then
        v146 = v148;
    elseif v149 == "Big" then
        v146 = v147;
    end;

    v143.TackleRadius = v146;
    local v150 = v143.Config.LiftHeight or 5;
    local v151 = v143.Config.LiftHeightBig or 8;
    local v152 = v143.Config.LiftHeightHuge or 12;
    local v153 = PetSizes.Normalize(v145);

    if v153 == "Huge" then
        v150 = v152;
    elseif v153 == "Big" then
        v150 = v151;
    end;

    v143.LiftHeight = v150;
    v143.LiftDuration = v143.Config.LiftDuration or 0.5;
    v143.ThrowForce = v143.Config.ThrowForce or 80;
    v143.ThrowUp = v143.Config.ThrowUp or 40;
    v143.ChaseLegTimeout = v143.Config.ChaseLegTimeout or 6;
    v143.ShovelAggroCooldown = v143.Config.ShovelAggroCooldown or 10;
    v143.PinHeight = v143.Config.PinHeight or 0.5;
    v143.HoldDuration = PetFlags.BearHoldDuration:Get();
    v143.TackleAnimDuration = v143.Config.TackleAnimDuration or 0.6;
    v143.ThrowAnimDuration = v143.Config.ThrowAnimDuration or 0.7;
    local v154;

    if v144 then
        v154 = v144.Type;
    else
        v154 = nil;
    end;

    local v155 = 1;
    local v156 = PetSizes.Normalize(v145);

    if v156 then
        v155 = v155 * (u16[v156] or 1);
    end;

    if v154 == PetTypes.Rainbow then
        v155 = v155 * 1.15;
    end;

    v143.ThrowDistanceMult = v155;
    v143.Target = nil;
    v143._GroundPos = nil;
    v143._ThrowDir = nil;
    v143._HoldEndsAt = 0;
    v143._LiftEndsAt = 0;
    v143._ThrowEndsAt = 0;
    v143._PinnedChar = nil;
    v143._PinnedHRP = nil;
    v143._PinAttachment = nil;
    v143._PinAlign = nil;
    v143._AngrySet = false;
    v143.States = BuildStates();

    return v143;
end;

function u32.GetInitialState(p157) -- Line: 684
    return "Acquire";
end;

function u32.OnStop(p158, p159) -- Line: 690
    -- upvalues: RagdollModule (copy)
    if p158._PinAlign then
        if p158._PinAlign.Parent then
            p158._PinAlign:Destroy();
        end;

        p158._PinAlign = nil;
    end;

    if p158._PinAttachment then
        if p158._PinAttachment.Parent then
            p158._PinAttachment:Destroy();
        end;

        p158._PinAttachment = nil;
    end;

    if p158._PinnedChar then
        local _PinnedChar = p158._PinnedChar;
        pcall(function() -- Line: 396
            -- upvalues: RagdollModule (ref), _PinnedChar (copy)
            RagdollModule:Unragdoll(_PinnedChar);
        end);
    end;

    p158._PinnedChar = nil;
    p158._PinnedHRP = nil;

    if p158.Control then
        p158.Control:SetSlotAttribute("AnimOverride", nil);
    end;
end;

function u32.CanStart(p160) -- Line: 697
    -- upvalues: u5 (ref), Services (copy), u26 (copy)
    local Player = p160.Player;

    if not (Player and Player.Parent) then
        return false;
    end;

    if not u5 then
        u5 = require(Services:WaitForChild("BeeDefenseService"));
    end;

    local v161 = u5;

    if not v161 then
        return false;
    end;

    local Slot = p160.Slot;
    local v162;

    if Slot then
        local v163 = u26[Slot];

        if v163 == nil then
            v162 = false;
        else
            v162 = os.clock() < v163;
        end;
    else
        v162 = false;
    end;

    if not v162 then
        local v164 = v161:GetShovelAggroTarget(Player);

        if v164 and (v164 and (v164:GetAttribute("InSafeZone") ~= true and (v164:GetAttribute("IsInOwnGarden") ~= true and v164:GetAttribute("InMinigame") ~= true))) then
            return true;
        end;
    end;

    local v165 = v161:PickTargetFor(Player);
    local v166;

    if v165 == nil or v165.Player == nil then
        v166 = false;
    else
        local Player2 = v165.Player;
        local v167 = not Player2 and true or (Player2:GetAttribute("InSafeZone") == true and true or (Player2:GetAttribute("IsInOwnGarden") == true and true or Player2:GetAttribute("InMinigame") == true));
        v166 = not v167;
    end;

    return v166;
end;

return u32;