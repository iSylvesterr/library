-- Decompiled with Potassium's decompiler.

local BehaviorBase = require(script.Parent.BehaviorBase);
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local PetSizes = require(ReplicatedStorage:WaitForChild("SharedData"):WaitForChild("PetSizes"));
local PetFlags = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("Flags"):WaitForChild("PetFlags"));
local RagdollModule = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("RagdollModule"));
local SoundService = game:GetService("SoundService");
local Debris = game:GetService("Debris");
local Services = game:GetService("ServerScriptService"):WaitForChild("Services");

local function PlayDogSound(p1, p2, p3) -- Line: 32
    -- upvalues: SoundService (copy), Debris (copy)
    if not (p1 and p1.Parent) then
        return;
    end;

    local SFX = SoundService:FindFirstChild("SFX");

    if SFX then
        SFX = SFX:FindFirstChild("Dog");
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

local function GetBeeDefenseService() -- Line: 47
    -- upvalues: u5 (ref), Services (copy)
    if not u5 then
        u5 = require(Services:WaitForChild("BeeDefenseService"));
    end;

    return u5;
end;

local u6 = nil;
local u7 = nil;

local function GetPetRecord(p8, p9) -- Line: 59
    -- upvalues: u7 (ref), u6 (ref), Services (copy)
    if not u7 then
        u6 = require(Services:WaitForChild("DataService"));
        u7 = u6.GetPet;
    end;

    return u7(u6, p8, p9);
end;

local u10 = nil;

local function DropStolenFruit(u11, u12) -- Line: 73
    -- upvalues: u10 (ref), Services (copy)
    if not (u12 and u12.Parent) then
        return;
    end;

    if not u10 then
        local success, result = pcall(require, Services:WaitForChild("StealService"));

        if success then
            u10 = result;
        end;
    end;

    if u10 then
        pcall(function() -- Line: 80
            -- upvalues: u10 (ref), u12 (copy)
            u10:CancelActiveSteal(u12);
        end);
        pcall(function() -- Line: 81
            -- upvalues: u10 (ref), u11 (copy), u12 (copy)
            u10:RecoverStolenFruit(u11, u12, true);
        end);
    end;
end;

local function PickBySize(p13, p14, p15, p16) -- Line: 104
    -- upvalues: PetSizes (copy)
    local v17 = PetSizes.Normalize(p13);

    if v17 == "Huge" then
        return p16;
    end;

    if v17 == "Big" then
        return p15;
    end;

    return p14;
end;

local u18 = setmetatable({}, {
    __index = BehaviorBase
});
u18.__index = u18;
u18.Name = "DogBite";

local function MakeGoalCFrame(p19, p20) -- Line: 117
    local v21 = p20 - p19;
    local v22 = Vector3.new(v21.X, 0, v21.Z);

    if v22.Magnitude < 0.001 then
        return CFrame.new(p20);
    end;

    return CFrame.lookAt(p20, p20 + v22.Unit);
end;

local function MakeFacingCFrame(p23, p24) -- Line: 126
    local v25 = p24 - p23;
    local v26 = Vector3.new(v25.X, 0, v25.Z);

    if v26.Magnitude < 0.001 then
        return CFrame.new(p23);
    end;

    return CFrame.lookAt(p23, p23 + v26.Unit);
end;

local function MoveTo(p27, p28, p29) -- Line: 135
    local v30 = p27.Control:GetSlotPosition();

    if not v30 then
        return;
    end;

    local Control = p27.Control;
    local v31 = p28 - v30;
    local v32 = Vector3.new(v31.X, 0, v31.Z);
    local v33;

    if v32.Magnitude < 0.001 then
        v33 = CFrame.new(p28);
    else
        v33 = CFrame.lookAt(p28, p28 + v32.Unit);
    end;

    Control:SetGoal(v33, p29);
end;

local function DistanceTo(p34, p35) -- Line: 141
    local v36 = p34.Control:GetSlotPosition();

    return not v36 and (1 / 0) or (p35 - v36).Magnitude;
end;

local function TargetPosition(p37) -- Line: 147
    if not (p37 and p37.Player) then
        return nil;
    end;

    local Character = p37.Player.Character;

    if not Character then
        return nil;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
        return HumanoidRootPart.Position;
    end;

    return nil;
end;

local function IsUnattackable(p38) -- Line: 159
    return not p38 and true or (p38:GetAttribute("InSafeZone") == true and true or (p38:GetAttribute("IsInOwnGarden") == true and true or p38:GetAttribute("InMinigame") == true));
end;

local function IsTargetStillValid(p39, p40) -- Line: 169
    if not p40 then
        return false;
    end;

    local Player = p40.Player;

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

    local v41 = Character:FindFirstChildOfClass("Humanoid");

    return v41 and v41.Health > 0 and true or false;
end;

local function PickTarget(p42) -- Line: 187
    -- upvalues: u5 (ref), Services (copy)
    if not u5 then
        u5 = require(Services:WaitForChild("BeeDefenseService"));
    end;

    local v43 = u5;

    if not v43 then
        return nil;
    end;

    local v44 = v43:PickTargetFor(p42.Player);

    if v44 and (v44.Kind == "Player" and v44.Player) then
        local Player = v44.Player;

        if Player and (Player:GetAttribute("InSafeZone") ~= true and (Player:GetAttribute("IsInOwnGarden") ~= true and Player:GetAttribute("InMinigame") ~= true)) then
            return {
                Player = v44.Player
            };
        end;
    end;

    return nil;
end;

local function InvalidateThreatCache(p45) -- Line: 200
    -- upvalues: u5 (ref), Services (copy)
    local u46 = p45.Player:GetAttribute("PlotId");

    if type(u46) ~= "number" then
        return;
    end;

    if not u5 then
        u5 = require(Services:WaitForChild("BeeDefenseService"));
    end;

    local u47 = u5;

    if u47 then
        pcall(function() -- Line: 205
            -- upvalues: u47 (copy), u46 (copy)
            u47:Invalidate(u46);
        end);
    end;
end;

local function BuildStates() -- Line: 209
    -- upvalues: PickTarget (copy), IsTargetStillValid (copy), RagdollModule (copy), DropStolenFruit (copy), InvalidateThreatCache (copy), PlayDogSound (copy)
    return {
        Acquire = {
            Enter = function(p48) -- Line: 213, Name: Enter
                -- upvalues: PickTarget (ref)
                local v49 = PickTarget(p48);

                if not v49 then
                    p48:Stop("NoThreat");

                    return;
                end;

                p48.Target = v49;
                p48:TransitionTo("Chase");
            end
        },
        Chase = {
            Enter = function(p50) -- Line: 225, Name: Enter
                p50.Control:SetSlotAttribute("AnimOverride", "charge");
                local Target = p50.Target;
                local v51;

                if Target and Target.Player then
                    local Character = Target.Player.Character;

                    if Character then
                        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

                        if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
                            v51 = HumanoidRootPart.Position;
                        else
                            v51 = nil;
                        end;
                    else
                        v51 = nil;
                    end;
                else
                    v51 = nil;
                end;

                if v51 then
                    local ChaseSpeed = p50.ChaseSpeed;
                    local v52 = p50.Control:GetSlotPosition();

                    if not v52 then
                        return;
                    end;

                    local Control = p50.Control;
                    local v53 = v51 - v52;
                    local v54 = Vector3.new(v53.X, 0, v53.Z);
                    local v55;

                    if v54.Magnitude < 0.001 then
                        v55 = CFrame.new(v51);
                    else
                        v55 = CFrame.lookAt(v51, v51 + v54.Unit);
                    end;

                    Control:SetGoal(v55, ChaseSpeed);
                end;
            end,

            Update = function(p56, p57, p58) -- Line: 231, Name: Update
                -- upvalues: IsTargetStillValid (ref)
                if not IsTargetStillValid(p56, p56.Target) then
                    p56:TransitionTo("Acquire");

                    return;
                end;

                local Target = p56.Target;
                local v59;

                if Target and Target.Player then
                    local Character = Target.Player.Character;

                    if Character then
                        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

                        if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
                            v59 = HumanoidRootPart.Position;
                        else
                            v59 = nil;
                        end;
                    else
                        v59 = nil;
                    end;
                else
                    v59 = nil;
                end;

                if not v59 then
                    p56:TransitionTo("Acquire");

                    return;
                end;

                local ChaseSpeed = p56.ChaseSpeed;
                local v60 = p56.Control:GetSlotPosition();

                if v60 then
                    local Control = p56.Control;
                    local v61 = v59 - v60;
                    local v62 = Vector3.new(v61.X, 0, v61.Z);
                    local v63;

                    if v62.Magnitude < 0.001 then
                        v63 = CFrame.new(v59);
                    else
                        v63 = CFrame.lookAt(v59, v59 + v62.Unit);
                    end;

                    Control:SetGoal(v63, ChaseSpeed);
                end;

                local v64 = p56.Control:GetSlotPosition();

                if (not v64 and (1 / 0) or (v59 - v64).Magnitude) <= p56.BiteRadius then
                    p56:TransitionTo("Bite");

                    return;
                end;

                if p56:TimeInState() < p56.ChaseLegTimeout then
                    return;
                end;

                p56:TransitionTo("Acquire");
            end
        },
        Bite = {
            Enter = function(u65) -- Line: 257, Name: Enter
                -- upvalues: RagdollModule (ref), DropStolenFruit (ref), InvalidateThreatCache (ref), PlayDogSound (ref)
                local Target = u65.Target;
                local v66;

                if Target and Target.Player then
                    local Character = Target.Player.Character;

                    if Character then
                        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

                        if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
                            v66 = HumanoidRootPart.Position;
                        else
                            v66 = nil;
                        end;
                    else
                        v66 = nil;
                    end;
                else
                    v66 = nil;
                end;

                local v67 = u65.Target and u65.Target.Player;

                if not (v66 and v67) then
                    u65:TransitionTo("Reacquire");

                    return;
                end;

                local Character = v67.Character;

                if Character then
                    pcall(function() -- Line: 268
                        -- upvalues: RagdollModule (ref), Character (copy), u65 (copy)
                        RagdollModule:Ragdoll(Character, u65.StunDuration);
                    end);
                end;

                DropStolenFruit(u65.Player, v67);
                InvalidateThreatCache(u65);
                PlayDogSound(u65.Slot, "DogBite", 1);
                u65.Control:SetSlotAttribute("AnimOverride", "bite");
                local v68 = u65.Control:GetSlotPosition();

                if v68 then
                    local Control = u65.Control;
                    local v69 = v66 - v68;
                    local v70 = Vector3.new(v69.X, 0, v69.Z);
                    local v71;

                    if v70.Magnitude < 0.001 then
                        v71 = CFrame.new(v68);
                    else
                        v71 = CFrame.lookAt(v68, v68 + v70.Unit);
                    end;

                    Control:SetGoal(v71, u65.AttackSpeed);
                end;

                u65._BiteEndsAt = os.clock() + u65.BiteHoldDuration;
            end,

            Update = function(p72, p73, p74) -- Line: 288, Name: Update
                local v75 = p72.Control:GetSlotPosition();
                local Target = p72.Target;
                local v76;

                if Target and Target.Player then
                    local Character = Target.Player.Character;

                    if Character then
                        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

                        if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
                            v76 = HumanoidRootPart.Position;
                        else
                            v76 = nil;
                        end;
                    else
                        v76 = nil;
                    end;
                else
                    v76 = nil;
                end;

                if v75 and v76 then
                    local Control = p72.Control;
                    local v77 = v76 - v75;
                    local v78 = Vector3.new(v77.X, 0, v77.Z);
                    local v79;

                    if v78.Magnitude < 0.001 then
                        v79 = CFrame.new(v75);
                    else
                        v79 = CFrame.lookAt(v75, v75 + v78.Unit);
                    end;

                    Control:SetGoal(v79, p72.AttackSpeed);
                end;

                if p72._BiteEndsAt <= p73 then
                    p72:TransitionTo("Reacquire");
                end;
            end
        },
        Reacquire = {
            Enter = function(p80) -- Line: 305, Name: Enter
                -- upvalues: PickTarget (ref)
                local v81 = PickTarget(p80);

                if not v81 then
                    p80:Stop("Disengaged");

                    return;
                end;

                p80.Target = v81;
                p80:TransitionTo("Chase");
            end
        }
    };
end;

function u18.new(p82) -- Line: 320
    -- upvalues: BehaviorBase (copy), u18 (copy), u7 (ref), u6 (ref), Services (copy), PetFlags (copy), PetSizes (copy), BuildStates (copy)
    local v83 = BehaviorBase.New(u18, p82);
    local Player = v83.Player;
    local PetId = v83.PetId;

    if not u7 then
        u6 = require(Services:WaitForChild("DataService"));
        u7 = u6.GetPet;
    end;

    local v84 = u7(u6, Player, PetId);
    local v85;

    if v84 then
        v85 = v84.Size;
    else
        v85 = nil;
    end;

    v83.AttackSpeed = PetFlags.DogAttackSpeed:Get();
    v83.ChaseSpeed = v83.AttackSpeed * (v83.Config.ChaseSpeedMultiplier or 1.3);
    local v86 = v83.Config.BiteRadius or 4;
    local v87 = v83.Config.BiteRadiusBig or 6;
    local v88 = v83.Config.BiteRadiusHuge or 8;
    local v89 = PetSizes.Normalize(v85);

    if v89 == "Huge" then
        v86 = v88;
    elseif v89 == "Big" then
        v86 = v87;
    end;

    v83.BiteRadius = v86;
    v83.BiteAnimDuration = v83.Config.BiteAnimDuration or 0.5;
    v83.BiteHoldDuration = v83.Config.BiteHoldDuration or 1;
    local v90 = PetFlags.DogStunDuration:Get();
    local v91 = PetSizes.Normalize(v85);
    v83.StunDuration = v90 * (v91 == "Huge" and 2 or (v91 == "Big" and 1.5 or 1));
    v83.ChaseLegTimeout = v83.Config.ChaseLegTimeout or 6;
    v83.Target = nil;
    v83._BiteEndsAt = 0;
    v83.States = BuildStates();

    return v83;
end;

function u18.GetInitialState(p92) -- Line: 347
    return "Acquire";
end;

function u18.OnStop(p93, p94) -- Line: 351
    if p93.Control then
        p93.Control:SetSlotAttribute("AnimOverride", nil);
    end;
end;

function u18.CanStart(p95) -- Line: 357
    -- upvalues: u5 (ref), Services (copy)
    local Player = p95.Player;

    if not (Player and Player.Parent) then
        return false;
    end;

    if not u5 then
        u5 = require(Services:WaitForChild("BeeDefenseService"));
    end;

    local v96 = u5;

    if not v96 then
        return false;
    end;

    local v97 = v96:PickTargetFor(Player);
    local v98;

    if v97 == nil or (v97.Kind ~= "Player" or v97.Player == nil) then
        v98 = false;
    else
        local Player2 = v97.Player;
        local v99 = not Player2 and true or (Player2:GetAttribute("InSafeZone") == true and true or (Player2:GetAttribute("IsInOwnGarden") == true and true or Player2:GetAttribute("InMinigame") == true));
        v98 = not v99;
    end;

    return v98;
end;

return u18;