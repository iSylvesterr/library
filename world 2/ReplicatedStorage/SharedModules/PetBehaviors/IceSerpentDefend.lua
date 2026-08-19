-- Decompiled with Potassium's decompiler.

local BehaviorBase = require(script.Parent.BehaviorBase);
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local PetTypes = require(ReplicatedStorage:WaitForChild("SharedData"):WaitForChild("PetTypes"));
local PetSizes = require(ReplicatedStorage:WaitForChild("SharedData"):WaitForChild("PetSizes"));
local Services = game:GetService("ServerScriptService"):WaitForChild("Services");
local u1 = nil;

local function GetDragonDefenseService() -- Line: 21
    -- upvalues: u1 (ref), Services (copy)
    if not u1 then
        u1 = require(Services:WaitForChild("DragonDefenseService"));
    end;

    return u1;
end;

local u2 = nil;

local function GetIceSerpentFireService() -- Line: 29
    -- upvalues: u2 (ref), Services (copy)
    if not u2 then
        u2 = require(Services:WaitForChild("IceSerpentFireService"));
    end;

    return u2;
end;

local u3 = nil;
local u4 = nil;

local function GetPetRecord(p5, p6) -- Line: 41
    -- upvalues: u4 (ref), u3 (ref), Services (copy)
    if not u4 then
        u3 = require(Services:WaitForChild("DataService"));
        u4 = u3.GetPet;
    end;

    return u4(u3, p5, p6);
end;

local u7 = {
    Big = 1.5,
    Huge = 2
};

local function DamageMultiplierForSize(p8) -- Line: 78
    -- upvalues: PetSizes (copy), u7 (copy)
    local v9 = PetSizes.Normalize(p8);

    return v9 and (u7[v9] or 1) or 1;
end;

local u10 = {
    Big = 1.5,
    Huge = 1.8
};

local function FreezeMultiplierForSize(p11) -- Line: 94
    -- upvalues: PetSizes (copy), u10 (copy)
    local v12 = PetSizes.Normalize(p11);

    return v12 and (u10[v12] or 1) or 1;
end;

local function FreezeMultiplierForType(p13) -- Line: 102
    -- upvalues: PetTypes (copy)
    return p13 == PetTypes.Rainbow and 1.25 or 1;
end;

local u14 = setmetatable({}, {
    __index = BehaviorBase
});
u14.__index = u14;
u14.Name = "IceSerpentDefend";

local function MakeGoalCFrame(p15, p16) -- Line: 114
    local v17 = p16 - p15;

    if v17.Magnitude < 0.001 then
        return CFrame.new(p16);
    end;

    return CFrame.lookAt(p16, p16 + v17.Unit);
end;

local function FlyToContact(p18, p19, p20) -- Line: 125
    local v21 = p18.Control:GetSlotPosition();

    if not v21 then
        return;
    end;

    local v22 = (not p18.Module or (not p18.Module.IsFlying or type(p18.Module.AirHeight) ~= "number")) and 0 or p18.Module.AirHeight;
    local v23 = Vector3.new(p19.X, v21.Y - v22, p19.Z);
    p18.Control:SetSlotAttribute("Hovering", true);
    local Control = p18.Control;
    local v24 = v23 - v21;
    local v25;

    if v24.Magnitude < 0.001 then
        v25 = CFrame.new(v23);
    else
        v25 = CFrame.lookAt(v23, v23 + v24.Unit);
    end;

    Control:SetGoal(v25, p20);
end;

local function HoldFacing(p26, p27, p28, p29) -- Line: 144
    local v30 = (not p26.Module or (not p26.Module.IsFlying or type(p26.Module.AirHeight) ~= "number")) and 0 or p26.Module.AirHeight;
    local v31 = Vector3.new(p27.X, p27.Y - v30, p27.Z);
    local v32 = p28 - p27;
    local v33 = v32.Magnitude <= 0.001 and Vector3.new(0, 0, -1) or v32.Unit;
    p26.Control:SetSlotAttribute("Hovering", true);
    p26.Control:SetGoal(CFrame.lookAt(v31, v31 + v33), p29);
end;

local function ClearCombatHover(p34) -- Line: 160
    if p34.Control and p34.Control.SetSlotAttribute then
        p34.Control:SetSlotAttribute("Hovering", nil);
    end;
end;

local function BreatheLean(p35, p36, p37, p38, p39) -- Line: 170
    local v40 = (not p35.Module or (not p35.Module.IsFlying or type(p35.Module.AirHeight) ~= "number")) and 0 or p35.Module.AirHeight;
    local v41 = Vector3.new(p37.X - p36.X, 0, p37.Z - p36.Z);
    local Magnitude = v41.Magnitude;
    local v42 = p36 + (Magnitude <= 0.001 and Vector3.new(0, 0, -1) or v41.Unit) * (math.min(4, Magnitude * 0.5) * p38);
    local v43 = Vector3.new(v42.X, p36.Y - v40, v42.Z);
    local v44 = p37 - v42;
    local v45 = v44.Magnitude <= 0.001 and Vector3.new(0, 0, -1) or v44.Unit;
    p35.Control:SetSlotAttribute("Hovering", true);
    p35.Control:SetGoal(CFrame.lookAt(v43, v43 + v45), p39);
end;

local function WithinBreathRange(p46, p47) -- Line: 200
    local v48 = p46.Control:GetSlotPosition();

    if not v48 then
        return false;
    end;

    local v49 = p47.X - v48.X;
    local v50 = p47.Z - v48.Z;

    return math.sqrt(v49 * v49 + v50 * v50) <= 10;
end;

local function TargetPosition(p51) -- Line: 210
    if not (p51 and p51.Player) then
        return nil;
    end;

    local Character = p51.Player.Character;

    if not Character then
        return nil;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
        return HumanoidRootPart.Position;
    end;

    return nil;
end;

local function TargetTorsoPosition(p52) -- Line: 221
    if not (p52 and p52.Player) then
        return nil;
    end;

    local Character = p52.Player.Character;

    if not Character then
        return nil;
    end;

    local v53 = Character:FindFirstChild("UpperTorso") or (Character:FindFirstChild("Torso") or Character:FindFirstChild("HumanoidRootPart"));

    if v53 and v53:IsA("BasePart") then
        return v53.Position;
    end;

    return nil;
end;

local function IsTargetStillValid(p54, p55) -- Line: 235
    -- upvalues: u1 (ref), Services (copy)
    if not p55 then
        return false;
    end;

    local Player = p55.Player;

    if not (Player and Player.Parent) then
        return false;
    end;

    if Player:GetAttribute("InSafeZone") == true then
        return false;
    end;

    if Player:GetAttribute("IsInOwnGarden") == true then
        return false;
    end;

    if Player:GetAttribute("InMinigame") == true then
        return false;
    end;

    local Character = Player.Character;

    if not Character then
        return false;
    end;

    if not Character:FindFirstChild("HumanoidRootPart") then
        return false;
    end;

    local v56 = Character:FindFirstChildOfClass("Humanoid");

    if not v56 or v56.Health <= 0 then
        return false;
    end;

    if not p55.ShovelAggro then
        return Player:GetAttribute("CarryingStolenFruit") == true;
    end;

    if not u1 then
        u1 = require(Services:WaitForChild("DragonDefenseService"));
    end;

    local v57 = u1;

    if v57 then
        v57 = v57:GetDragonAggroTarget(p54.Player);
    end;

    return v57 == Player;
end;

local function PickTarget(p58) -- Line: 262
    -- upvalues: u1 (ref), Services (copy)
    if not u1 then
        u1 = require(Services:WaitForChild("DragonDefenseService"));
    end;

    local v59 = u1;

    if not v59 then
        return nil;
    end;

    local v60 = v59:GetDragonAggroTarget(p58.Player);

    if v60 then
        return {
            ShovelAggro = true,
            Player = v60
        };
    end;

    local v61 = v59:PickTargetFor(p58.Player);

    return v61 and v61.Player and {
        ShovelAggro = false,
        Player = v61.Player
    } or nil;
end;

local function BuildStates() -- Line: 278
    -- upvalues: PickTarget (copy), FlyToContact (copy), IsTargetStillValid (copy), TargetTorsoPosition (copy), BreatheLean (copy), u2 (ref), Services (copy), HoldFacing (copy)
    return {
        Acquire = {
            Enter = function(p62) -- Line: 282, Name: Enter
                -- upvalues: PickTarget (ref)
                local v63 = PickTarget(p62);

                if not v63 then
                    p62:Stop("NoThreat");

                    return;
                end;

                p62.Target = v63;
                p62:TransitionTo("Approach");
            end
        },
        Approach = {
            Enter = function(p64) -- Line: 294, Name: Enter
                -- upvalues: FlyToContact (ref)
                local Target = p64.Target;
                local v65;

                if Target and Target.Player then
                    local Character = Target.Player.Character;

                    if Character then
                        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

                        if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
                            v65 = HumanoidRootPart.Position;
                        else
                            v65 = nil;
                        end;
                    else
                        v65 = nil;
                    end;
                else
                    v65 = nil;
                end;

                if v65 then
                    FlyToContact(p64, v65, p64.ApproachSpeed);
                end;
            end,

            Update = function(p66, p67, p68) -- Line: 299, Name: Update
                -- upvalues: IsTargetStillValid (ref), FlyToContact (ref)
                if not IsTargetStillValid(p66, p66.Target) then
                    p66:TransitionTo("Return");

                    return;
                end;

                local Target = p66.Target;
                local v69;

                if Target and Target.Player then
                    local Character = Target.Player.Character;

                    if Character then
                        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

                        if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
                            v69 = HumanoidRootPart.Position;
                        else
                            v69 = nil;
                        end;
                    else
                        v69 = nil;
                    end;
                else
                    v69 = nil;
                end;

                if not v69 then
                    p66:TransitionTo("Return");

                    return;
                end;

                FlyToContact(p66, v69, p66.ApproachSpeed);
                local v70 = p66.Control:GetSlotPosition();
                local v71;

                if v70 then
                    local v72 = v69.X - v70.X;
                    local v73 = v69.Z - v70.Z;
                    v71 = math.sqrt(v72 * v72 + v73 * v73) <= 10;
                else
                    v71 = false;
                end;

                if v71 then
                    if p66.BreathReadyAt <= p67 then
                        p66:TransitionTo("Breathe");

                        return;
                    end;

                    p66:TransitionTo("Cooldown");

                    return;
                end;

                if p66:TimeInState() < p66.ApproachLegTimeout then
                    return;
                end;

                p66:TransitionTo("Acquire");
            end
        },
        Breathe = {
            Enter = function(p74) -- Line: 330, Name: Enter
                local Target = p74.Target;
                local v75;

                if Target and Target.Player then
                    local Character = Target.Player.Character;

                    if Character then
                        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

                        if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
                            v75 = HumanoidRootPart.Position;
                        else
                            v75 = nil;
                        end;
                    else
                        v75 = nil;
                    end;
                else
                    v75 = nil;
                end;

                if not v75 then
                    p74:TransitionTo("Return");

                    return;
                end;

                p74._BreathAnchor = p74.Control:GetSlotPosition() or v75;
                p74._BreathLastPos = v75;
                p74._BreathStartAt = os.clock();
                p74._BreathFireAt = p74._BreathStartAt + p74.BreathWindup;
                p74._BreathEndsAt = p74._BreathFireAt + p74.BreathDuration;
                p74._BreathFired = false;
            end,

            Update = function(u76, p77, p78) -- Line: 345, Name: Update
                -- upvalues: TargetTorsoPosition (ref), IsTargetStillValid (ref), BreatheLean (ref), u2 (ref), Services (ref)
                local v79 = TargetTorsoPosition(u76.Target);
                local Target = u76.Target;
                local v80;

                if Target and Target.Player then
                    local Character = Target.Player.Character;

                    if Character then
                        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

                        if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
                            v80 = HumanoidRootPart.Position;
                        else
                            v80 = nil;
                        end;
                    else
                        v80 = nil;
                    end;
                else
                    v80 = nil;
                end;

                if v79 then
                    u76._BreathLastPos = v79;
                end;

                if not (u76._BreathFired and p77 < u76._BreathEndsAt) then
                    if not IsTargetStillValid(u76, u76.Target) then
                        u76:TransitionTo("Return");

                        return;
                    end;

                    if not v80 then
                        u76:TransitionTo("Return");

                        return;
                    end;

                    if (v80 - u76._BreathAnchor).Magnitude > u76.BreathLeash then
                        u76.BreathReadyAt = p77 + u76.BreathCooldown;
                        u76:TransitionTo("Approach");

                        return;
                    end;
                end;

                local v81 = v79 or (u76._BreathLastPos or u76._BreathAnchor);
                local v82 = math.max(0.001, u76._BreathEndsAt - u76._BreathStartAt);
                local v83 = math.clamp((p77 - u76._BreathStartAt) / v82, 0, 1) * 3.141592653589793;
                local v84 = math.sin(v83);
                BreatheLean(u76, u76._BreathAnchor, v81, v84, u76.ApproachSpeed);

                if not u76._BreathFired and u76._BreathFireAt <= p77 then
                    u76._BreathFired = true;

                    if not u2 then
                        u2 = require(Services:WaitForChild("IceSerpentFireService"));
                    end;

                    local u85 = u2;

                    if u85 then
                        pcall(function() -- Line: 388
                            -- upvalues: u85 (copy), u76 (copy)
                            u85:StartBreath(u76.Slot, u76.Player, u76.Target.Player, u76.BreathDuration, u76.DmgMult, u76.FreezeMult);
                        end);
                    end;
                end;

                if u76._BreathEndsAt > p77 then
                    return;
                end;

                u76.BreathReadyAt = p77 + u76.BreathCooldown;
                u76:TransitionTo("Cooldown");
            end
        },
        Cooldown = {
            Update = function(p86, p87, p88) -- Line: 403, Name: Update
                -- upvalues: IsTargetStillValid (ref), FlyToContact (ref), HoldFacing (ref)
                if not IsTargetStillValid(p86, p86.Target) then
                    p86:TransitionTo("Return");

                    return;
                end;

                local Target = p86.Target;
                local v89;

                if Target and Target.Player then
                    local Character = Target.Player.Character;

                    if Character then
                        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

                        if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
                            v89 = HumanoidRootPart.Position;
                        else
                            v89 = nil;
                        end;
                    else
                        v89 = nil;
                    end;
                else
                    v89 = nil;
                end;

                if not v89 then
                    p86:TransitionTo("Return");

                    return;
                end;

                local v90 = p86.Control:GetSlotPosition();
                local v91;

                if v90 then
                    local v92 = v89.X - v90.X;
                    local v93 = v89.Z - v90.Z;
                    v91 = math.sqrt(v92 * v92 + v93 * v93) <= 10;
                else
                    v91 = false;
                end;

                if v91 then
                    HoldFacing(p86, p86.Control:GetSlotPosition() or v89, v89, p86.ApproachSpeed);
                else
                    FlyToContact(p86, v89, p86.ApproachSpeed);
                end;

                if p86.BreathReadyAt <= p87 then
                    local v94 = p86.Control:GetSlotPosition();
                    local v95;

                    if v94 then
                        local v96 = v89.X - v94.X;
                        local v97 = v89.Z - v94.Z;
                        v95 = math.sqrt(v96 * v96 + v97 * v97) <= 10;
                    else
                        v95 = false;
                    end;

                    if v95 then
                        p86:TransitionTo("Breathe");

                        return;
                    end;

                    p86:TransitionTo("Approach");
                end;
            end
        },
        Return = {
            Enter = function(p98) -- Line: 437, Name: Enter
                if p98.Control and p98.Control.SetSlotAttribute then
                    p98.Control:SetSlotAttribute("Hovering", nil);
                end;

                p98:Stop("Disengaged");
            end
        }
    };
end;

function u14.new(p99) -- Line: 447
    -- upvalues: BehaviorBase (copy), u14 (copy), u4 (ref), u3 (ref), Services (copy), PetSizes (copy), u7 (copy), PetTypes (copy), u10 (copy), u2 (ref), BuildStates (copy)
    local v100 = BehaviorBase.New(u14, p99);
    local Player = v100.Player;
    local PetId = v100.PetId;

    if not u4 then
        u3 = require(Services:WaitForChild("DataService"));
        u4 = u3.GetPet;
    end;

    local v101 = u4(u3, Player, PetId);
    local v102;

    if v101 then
        v102 = v101.Size;
    else
        v102 = nil;
    end;

    local v103;

    if v101 then
        v103 = v101.Type;
    else
        v103 = nil;
    end;

    v100.ApproachSpeed = v100.Config.ApproachSpeed or 22;
    v100.BreathDuration = v100.Config.BreathDuration or 1.5;
    v100.BreathCooldown = v100.Config.BreathCooldown or 8;
    v100.ApproachLegTimeout = v100.Config.ApproachLegTimeout or 8;
    v100.BreathWindup = v100.Config.BreathWindup or 1;
    local v104 = PetSizes.Normalize(v102);
    v100.DmgMult = (v104 and (u7[v104] or 1) or 1) * PetTypes.GetBoostMultiplier(v103);
    local v105 = PetSizes.Normalize(v102);
    v100.FreezeMult = (v105 and (u10[v105] or 1) or 1) * (v103 == PetTypes.Rainbow and 1.25 or 1);

    if not u2 then
        u2 = require(Services:WaitForChild("IceSerpentFireService"));
    end;

    local v106 = u2;

    if v106 then
        v100.StartBreathDistance = v106:GetStartBreathDistance(v102);
        v100.BreathLeash = v106:GetBreathLeash(v102);
    else
        v100.StartBreathDistance = 8;
        v100.BreathLeash = 40;
    end;

    v100.Target = nil;
    v100.BreathReadyAt = 0;
    v100._BreathAnchor = nil;
    v100._BreathLastPos = nil;
    v100._BreathStartAt = 0;
    v100._BreathFireAt = 0;
    v100._BreathEndsAt = 0;
    v100._BreathFired = false;
    v100.States = BuildStates();

    return v100;
end;

function u14.GetInitialState(p107) -- Line: 491
    return "Acquire";
end;

function u14.OnStop(p108, p109) -- Line: 495
    if p108.Control and p108.Control.SetSlotAttribute then
        p108.Control:SetSlotAttribute("Hovering", nil);
    end;
end;

function u14.CanStart(p110) -- Line: 499
    -- upvalues: PickTarget (copy)
    local Player = p110.Player;

    if Player and Player.Parent then
        return PickTarget(p110) ~= nil;
    end;

    return false;
end;

return u14;