-- Decompiled with Potassium's decompiler.

local BehaviorBase = require(script.Parent.BehaviorBase);
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local PetSizes = require(ReplicatedStorage:WaitForChild("SharedData"):WaitForChild("PetSizes"));
local PetFlags = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("Flags"):WaitForChild("PetFlags"));
local RagdollModule = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("RagdollModule"));
local Debris = game:GetService("Debris");
local SoundService = game:GetService("SoundService");
local Services = game:GetService("ServerScriptService"):WaitForChild("Services");

local function FindHedgehogSound(p1) -- Line: 38
    -- upvalues: SoundService (copy)
    local SFX = SoundService:FindFirstChild("SFX");

    if SFX then
        SFX = SFX:FindFirstChild("Hedgehog");
    end;

    if SFX then
        SFX = SFX:FindFirstChild(p1);
    end;

    if SFX and SFX:IsA("Sound") then
        return SFX;
    end;

    return nil;
end;

local function StartRollSound(p2) -- Line: 50
    -- upvalues: SoundService (copy)
    local _RollSound = p2._RollSound;

    if _RollSound and _RollSound.Parent then
        return;
    end;

    local Slot = p2.Slot;

    if not (Slot and Slot.Parent) then
        return;
    end;

    local SFX = SoundService:FindFirstChild("SFX");

    if SFX then
        SFX = SFX:FindFirstChild("Hedgehog");
    end;

    if SFX then
        SFX = SFX:FindFirstChild("HedgehogRoll");
    end;

    if not (SFX and SFX:IsA("Sound")) then
        SFX = nil;
    end;

    if not SFX then
        return;
    end;

    local v3 = SFX:Clone();
    v3.Looped = true;
    v3.Parent = Slot;
    v3:Play();
    p2._RollSound = v3;
end;

local function StopRollSound(p4) -- Line: 65
    local _RollSound = p4._RollSound;
    p4._RollSound = nil;

    if not _RollSound then
        return;
    end;

    if _RollSound.Parent then
        _RollSound:Stop();
    end;

    _RollSound:Destroy();
end;

local function PlayHedgehogSound(p5, p6) -- Line: 75
    -- upvalues: SoundService (copy), Debris (copy)
    if not (p5 and p5.Parent) then
        return;
    end;

    local SFX = SoundService:FindFirstChild("SFX");

    if SFX then
        SFX = SFX:FindFirstChild("Hedgehog");
    end;

    if SFX then
        SFX = SFX:FindFirstChild(p6);
    end;

    if not (SFX and SFX:IsA("Sound")) then
        SFX = nil;
    end;

    if not SFX then
        return;
    end;

    local v7 = SFX:Clone();
    v7.Looped = false;
    v7.Parent = p5;
    v7:Play();
    Debris:AddItem(v7, (v7.TimeLength <= 0 and 5 or v7.TimeLength) + 1);
end;

local u8 = nil;

local function GetBeeDefenseService() -- Line: 88
    -- upvalues: u8 (ref), Services (copy)
    if not u8 then
        u8 = require(Services:WaitForChild("BeeDefenseService"));
    end;

    return u8;
end;

local u9 = nil;
local u10 = nil;

local function GetPetRecord(p11, p12) -- Line: 100
    -- upvalues: u10 (ref), u9 (ref), Services (copy)
    if not u10 then
        u9 = require(Services:WaitForChild("DataService"));
        u10 = u9.GetPet;
    end;

    return u10(u9, p11, p12);
end;

local u13 = nil;
local u14 = 20;

local function ExemptVictim(u15) -- Line: 113
    -- upvalues: u13 (ref), Services (copy), u14 (ref)
    if not (u15 and u15.Parent) then
        return;
    end;

    if not u13 then
        local AntiCheatService = Services:WaitForChild("AntiCheatService");
        u13 = require(AntiCheatService:WaitForChild("Exemptions"));
        u14 = require(AntiCheatService:WaitForChild("Config")).Exemption.HEDGEHOG_KNOCKBACK_DURATION or u14;
    end;

    pcall(function() -- Line: 121
        -- upvalues: u13 (ref), u15 (copy), u14 (ref)
        u13:Exempt(u15, u14);
    end);
end;

local u16 = nil;

local function DropStolenFruit(u17, u18) -- Line: 130
    -- upvalues: u16 (ref), Services (copy)
    if not (u18 and u18.Parent) then
        return;
    end;

    if not u16 then
        local success, result = pcall(require, Services:WaitForChild("StealService"));

        if success then
            u16 = result;
        end;
    end;

    if u16 then
        pcall(function() -- Line: 137
            -- upvalues: u16 (ref), u18 (copy)
            u16:CancelActiveSteal(u18);
        end);
        pcall(function() -- Line: 138
            -- upvalues: u16 (ref), u17 (copy), u18 (copy)
            u16:RecoverStolenFruit(u17, u18, true);
        end);
    end;
end;

local function KnockbackDistanceMultiplier(p19) -- Line: 170
    -- upvalues: PetFlags (copy), PetSizes (copy)
    local v20 = PetFlags.HedgehogKnockbackDistanceByType:Get()[PetSizes.Normalize(p19) or "Normal"];

    return (type(v20) ~= "number" or v20 < 0) and 1 or v20;
end;

local function PickBySize(p21, p22, p23, p24) -- Line: 179
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

local function IsShovelAggroOnCooldown(p27) -- Line: 192
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

local function MarkShovelAggroStarted(p30, p31) -- Line: 198
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
u32.Name = "HedgehogRoll";

local function MakeGoalCFrame(p33, p34) -- Line: 209
    local v35 = p34 - p33;
    local v36 = Vector3.new(v35.X, 0, v35.Z);

    if v36.Magnitude < 0.001 then
        return CFrame.new(p34);
    end;

    return CFrame.lookAt(p34, p34 + v36.Unit);
end;

local function MakeFacingCFrame(p37, p38) -- Line: 218
    local v39 = Vector3.new(p38.X, 0, p38.Z);

    if v39.Magnitude < 0.001 then
        return CFrame.new(p37);
    end;

    return CFrame.lookAt(p37, p37 + v39.Unit);
end;

local function MoveTo(p40, p41, p42) -- Line: 226
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

local function DistanceTo(p47, p48) -- Line: 232
    local v49 = p47.Control:GetSlotPosition();

    return not v49 and (1 / 0) or (p48 - v49).Magnitude;
end;

local function TargetPosition(p50) -- Line: 238
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

local function RampedChaseSpeed(p51) -- Line: 250
    local _ChaseStartedAt = p51._ChaseStartedAt;
    local v52 = not _ChaseStartedAt and 0 or os.clock() - _ChaseStartedAt;
    local v53 = math.clamp(v52 / p51.RampDuration, 0, 1);
    local v54 = math.lerp(1, p51.MaxChaseSpeedMultiplier, v53);

    return p51.AttackSpeed * v54;
end;

local function TravelDirTo(p55, p56) -- Line: 260
    local v57 = p55.Control:GetSlotPosition();

    if not v57 then
        return nil;
    end;

    local v58 = Vector3.new(p56.X - v57.X, 0, p56.Z - v57.Z);

    if v58.Magnitude < 0.001 then
        return nil;
    end;

    return v58.Unit;
end;

local function IsUnattackable(p59) -- Line: 273
    return not p59 and true or (p59:GetAttribute("InSafeZone") == true and true or (p59:GetAttribute("IsInOwnGarden") == true and true or p59:GetAttribute("InMinigame") == true));
end;

local function IsTargetStillValid(p60, p61) -- Line: 287
    -- upvalues: u8 (ref), Services (copy)
    if not p61 then
        return false;
    end;

    local Player = p61.Player;

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

    local v62 = Character:FindFirstChildOfClass("Humanoid");

    if not v62 or v62.Health <= 0 then
        return false;
    end;

    if not p61.ShovelAggro then
        return true;
    end;

    if not u8 then
        u8 = require(Services:WaitForChild("BeeDefenseService"));
    end;

    local v63 = u8;

    if v63 then
        v63 = v63:GetShovelAggroTarget(p60.Player);
    end;

    return v63 == Player;
end;

local function PickTarget(p64) -- Line: 307
    -- upvalues: u8 (ref), Services (copy), u26 (copy)
    if not u8 then
        u8 = require(Services:WaitForChild("BeeDefenseService"));
    end;

    local v65 = u8;

    if not v65 then
        return nil;
    end;

    local Slot = p64.Slot;
    local v66;

    if Slot then
        local v67 = u26[Slot];

        if v67 == nil then
            v66 = false;
        else
            v66 = os.clock() < v67;
        end;
    else
        v66 = false;
    end;

    if not v66 then
        local v68 = v65:GetShovelAggroTarget(p64.Player);

        if v68 and (v68 and (v68:GetAttribute("InSafeZone") ~= true and (v68:GetAttribute("IsInOwnGarden") ~= true and v68:GetAttribute("InMinigame") ~= true))) then
            local Slot2 = p64.Slot;
            local ShovelAggroCooldown = p64.ShovelAggroCooldown;

            if Slot2 then
                u26[Slot2] = os.clock() + ShovelAggroCooldown;
            end;

            return {
                ShovelAggro = true,
                Player = v68
            };
        end;
    end;

    local v69 = v65:PickTargetFor(p64.Player);

    if v69 and v69.Player then
        local Player = v69.Player;

        if Player and (Player:GetAttribute("InSafeZone") ~= true and (Player:GetAttribute("IsInOwnGarden") ~= true and Player:GetAttribute("InMinigame") ~= true)) then
            return {
                ShovelAggro = false,
                Player = v69.Player
            };
        end;
    end;

    return nil;
end;

local function KnockBack(u70, p71, p72) -- Line: 329
    -- upvalues: RagdollModule (copy), ExemptVictim (copy), Debris (copy)
    local Character = p71.Character;

    if not Character then
        return;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        return;
    end;

    pcall(function() -- Line: 335
        -- upvalues: RagdollModule (ref), Character (copy), u70 (copy)
        RagdollModule:Ragdoll(Character, u70.StunDuration);
    end);
    ExemptVictim(p71);
    local v73 = p72 * (u70.KnockbackForce * u70.KnockbackDistanceMult) + Vector3.new(0, u70.KnockbackUp, 0);
    HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
    local BodyVelocity = Instance.new("BodyVelocity");
    BodyVelocity.MaxForce = Vector3.new(inf, inf, inf);
    BodyVelocity.Velocity = v73;
    BodyVelocity.Parent = HumanoidRootPart;
    Debris:AddItem(BodyVelocity, 0.35);
end;

local function BuildStates() -- Line: 348
    -- upvalues: PickTarget (copy), SoundService (copy), IsTargetStillValid (copy), DropStolenFruit (copy), KnockBack (copy), PlayHedgehogSound (copy), u8 (ref), Services (copy)
    return {
        Acquire = {
            Enter = function(p74) -- Line: 352, Name: Enter
                -- upvalues: PickTarget (ref)
                local v75 = PickTarget(p74);

                if not v75 then
                    p74:Stop("NoThreat");

                    return;
                end;

                p74.Target = v75;
                p74:TransitionTo("Chase");
            end
        },
        Chase = {
            Enter = function(p76) -- Line: 364, Name: Enter
                -- upvalues: SoundService (ref)
                local v77 = p76.Target and p76.Target.Player;

                if p76._RampTarget ~= v77 or not p76._ChaseStartedAt then
                    p76._RampTarget = v77;
                    p76._ChaseStartedAt = os.clock();
                end;

                p76.Control:SetSlotAttribute("AnimOverride", "charge");
                local _RollSound = p76._RollSound;

                if not (_RollSound and _RollSound.Parent) then
                    local Slot = p76.Slot;

                    if Slot and Slot.Parent then
                        local SFX = SoundService:FindFirstChild("SFX");

                        if SFX then
                            SFX = SFX:FindFirstChild("Hedgehog");
                        end;

                        if SFX then
                            SFX = SFX:FindFirstChild("HedgehogRoll");
                        end;

                        if not (SFX and SFX:IsA("Sound")) then
                            SFX = nil;
                        end;

                        if SFX then
                            local v78 = SFX:Clone();
                            v78.Looped = true;
                            v78.Parent = Slot;
                            v78:Play();
                            p76._RollSound = v78;
                        end;
                    end;
                end;

                local Target = p76.Target;
                local v79;

                if Target and Target.Player then
                    local Character = Target.Player.Character;

                    if Character then
                        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

                        if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
                            v79 = HumanoidRootPart.Position;
                        else
                            v79 = nil;
                        end;
                    else
                        v79 = nil;
                    end;
                else
                    v79 = nil;
                end;

                if v79 then
                    local v80 = p76.Control:GetSlotPosition();
                    local v81;

                    if v80 then
                        local v82 = Vector3.new(v79.X - v80.X, 0, v79.Z - v80.Z);

                        if v82.Magnitude < 0.001 then
                            v81 = nil;
                        else
                            v81 = v82.Unit;
                        end;
                    else
                        v81 = nil;
                    end;

                    if v81 then
                        p76._TravelDir = v81;
                    end;

                    local _ChaseStartedAt = p76._ChaseStartedAt;
                    local v83 = not _ChaseStartedAt and 0 or os.clock() - _ChaseStartedAt;
                    local v84 = math.clamp(v83 / p76.RampDuration, 0, 1);
                    local v85 = math.lerp(1, p76.MaxChaseSpeedMultiplier, v84);
                    local v86 = p76.AttackSpeed * v85;
                    p76.Control:SetSlotAttribute("VisualChaseSpeed", v86);
                    local v87 = p76.Control:GetSlotPosition();

                    if not v87 then
                        return;
                    end;

                    local Control = p76.Control;
                    local v88 = v79 - v87;
                    local v89 = Vector3.new(v88.X, 0, v88.Z);
                    local v90;

                    if v89.Magnitude < 0.001 then
                        v90 = CFrame.new(v79);
                    else
                        v90 = CFrame.lookAt(v79, v79 + v89.Unit);
                    end;

                    Control:SetGoal(v90, v86);
                end;
            end,

            Update = function(p91, p92, p93) -- Line: 386, Name: Update
                -- upvalues: IsTargetStillValid (ref)
                if not IsTargetStillValid(p91, p91.Target) then
                    p91:TransitionTo("Acquire");

                    return;
                end;

                local Target = p91.Target;
                local v94;

                if Target and Target.Player then
                    local Character = Target.Player.Character;

                    if Character then
                        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

                        if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
                            v94 = HumanoidRootPart.Position;
                        else
                            v94 = nil;
                        end;
                    else
                        v94 = nil;
                    end;
                else
                    v94 = nil;
                end;

                if not v94 then
                    p91:TransitionTo("Acquire");

                    return;
                end;

                local v95 = p91.Control:GetSlotPosition();
                local v96;

                if v95 then
                    local v97 = Vector3.new(v94.X - v95.X, 0, v94.Z - v95.Z);

                    if v97.Magnitude < 0.001 then
                        v96 = nil;
                    else
                        v96 = v97.Unit;
                    end;
                else
                    v96 = nil;
                end;

                if v96 then
                    p91._TravelDir = v96;
                end;

                local _ChaseStartedAt = p91._ChaseStartedAt;
                local v98 = not _ChaseStartedAt and 0 or os.clock() - _ChaseStartedAt;
                local v99 = math.clamp(v98 / p91.RampDuration, 0, 1);
                local v100 = math.lerp(1, p91.MaxChaseSpeedMultiplier, v99);
                local v101 = p91.AttackSpeed * v100;
                p91.Control:SetSlotAttribute("VisualChaseSpeed", v101);
                local v102 = p91.Control:GetSlotPosition();

                if v102 then
                    local Control = p91.Control;
                    local v103 = v94 - v102;
                    local v104 = Vector3.new(v103.X, 0, v103.Z);
                    local v105;

                    if v104.Magnitude < 0.001 then
                        v105 = CFrame.new(v94);
                    else
                        v105 = CFrame.lookAt(v94, v94 + v104.Unit);
                    end;

                    Control:SetGoal(v105, v101);
                end;

                local v106 = p91.Control:GetSlotPosition();

                if (not v106 and (1 / 0) or (v94 - v106).Magnitude) <= p91.TackleRadius then
                    p91:TransitionTo("Tackle");

                    return;
                end;

                if p91:TimeInState() < p91.ChaseLegTimeout then
                    return;
                end;

                p91:TransitionTo("Acquire");
            end
        },
        Tackle = {
            Enter = function(p107) -- Line: 417, Name: Enter
                -- upvalues: DropStolenFruit (ref), KnockBack (ref), PlayHedgehogSound (ref)
                local _RollSound = p107._RollSound;
                p107._RollSound = nil;

                if _RollSound then
                    if _RollSound.Parent then
                        _RollSound:Stop();
                    end;

                    _RollSound:Destroy();
                end;

                p107.Control:SetSlotAttribute("VisualChaseSpeed", nil);
                local Target = p107.Target;
                local v108;

                if Target and Target.Player then
                    local Character = Target.Player.Character;

                    if Character then
                        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

                        if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
                            v108 = HumanoidRootPart.Position;
                        else
                            v108 = nil;
                        end;
                    else
                        v108 = nil;
                    end;
                else
                    v108 = nil;
                end;

                local v109 = p107.Target and p107.Target.Player;

                if not (v108 and v109) then
                    p107:TransitionTo("Return");

                    return;
                end;

                local v110 = p107.Control:GetSlotPosition();
                local v111;

                if v110 then
                    local v112 = Vector3.new(v108.X - v110.X, 0, v108.Z - v110.Z);

                    if v112.Magnitude < 0.001 then
                        v111 = nil;
                    else
                        v111 = v112.Unit;
                    end;
                else
                    v111 = nil;
                end;

                local v113 = v111 or (p107._TravelDir or Vector3.new(0, 0, -1));
                DropStolenFruit(p107.Player, v109);
                KnockBack(p107, v109, v113);
                PlayHedgehogSound(p107.Slot, "HedgehogHit");
                p107.Control:SetSlotAttribute("AnimOverride", "tackle");
                local v114 = p107.Control:GetSlotPosition();

                if v114 then
                    local Control = p107.Control;
                    local v115 = Vector3.new(v113.X, 0, v113.Z);
                    local v116;

                    if v115.Magnitude < 0.001 then
                        v116 = CFrame.new(v114);
                    else
                        v116 = CFrame.lookAt(v114, v114 + v115.Unit);
                    end;

                    Control:SetGoal(v116, p107.AttackSpeed);
                end;

                p107._RecoverEndsAt = os.clock() + p107.TackleAnimDuration;
                p107:TransitionTo("Recover");
            end
        },
        Recover = {
            Update = function(p117, p118, p119) -- Line: 453, Name: Update
                if p117._RecoverEndsAt <= p118 then
                    p117:TransitionTo("Return");
                end;
            end
        },
        Return = {
            Enter = function(u120) -- Line: 461, Name: Enter
                -- upvalues: u8 (ref), Services (ref)
                if not u8 then
                    u8 = require(Services:WaitForChild("BeeDefenseService"));
                end;

                local u121 = u8;

                if u121 then
                    pcall(function() -- Line: 469
                        -- upvalues: u121 (copy), u120 (copy)
                        u121:ClearShovelAggro(u120.Player);
                    end);
                end;

                u120:Stop("Disengaged");
            end
        }
    };
end;

function u32.new(p122) -- Line: 479
    -- upvalues: BehaviorBase (copy), u32 (copy), u10 (ref), u9 (ref), Services (copy), PetFlags (copy), PetSizes (copy), BuildStates (copy)
    local v123 = BehaviorBase.New(u32, p122);
    local Player = v123.Player;
    local PetId = v123.PetId;

    if not u10 then
        u9 = require(Services:WaitForChild("DataService"));
        u10 = u9.GetPet;
    end;

    local v124 = u10(u9, Player, PetId);
    local v125;

    if v124 then
        v125 = v124.Size;
    else
        v125 = nil;
    end;

    v123.AttackSpeed = PetFlags.HedgehogAttackSpeed:Get();
    v123.RampDuration = v123.Config.RampDuration or 6;
    v123.MaxChaseSpeedMultiplier = v123.Config.MaxChaseSpeedMultiplier or 2;
    local v126 = v123.Config.TackleRadius or 4;
    local v127 = v123.Config.TackleRadiusBig or 6;
    local v128 = v123.Config.TackleRadiusHuge or 8;
    local v129 = PetSizes.Normalize(v125);

    if v129 == "Huge" then
        v126 = v128;
    elseif v129 == "Big" then
        v126 = v127;
    end;

    v123.TackleRadius = v126;
    v123.ChaseLegTimeout = v123.Config.ChaseLegTimeout or 6;
    v123.ShovelAggroCooldown = v123.Config.ShovelAggroCooldown or 10;
    v123.StunDuration = PetFlags.HedgehogStunDuration:Get();
    v123.TackleAnimDuration = v123.Config.TackleAnimDuration or 0.6;
    v123.KnockbackForce = v123.Config.KnockbackForce or 60;
    v123.KnockbackUp = v123.Config.KnockbackUp or 18;
    local v130 = PetFlags.HedgehogKnockbackDistanceByType:Get()[PetSizes.Normalize(v125) or "Normal"];
    v123.KnockbackDistanceMult = (type(v130) ~= "number" or v130 < 0) and 1 or v130;
    v123.Target = nil;
    v123._ChaseStartedAt = nil;
    v123._RampTarget = nil;
    v123._TravelDir = nil;
    v123._RecoverEndsAt = 0;
    v123._RollSound = nil;
    v123.States = BuildStates();

    return v123;
end;

function u32.GetInitialState(p131) -- Line: 514
    return "Acquire";
end;

function u32.OnStop(p132, p133) -- Line: 521
    local _RollSound = p132._RollSound;
    p132._RollSound = nil;

    if _RollSound then
        if _RollSound.Parent then
            _RollSound:Stop();
        end;

        _RollSound:Destroy();
    end;

    if p132.Control then
        p132.Control:SetSlotAttribute("AnimOverride", nil);
        p132.Control:SetSlotAttribute("VisualChaseSpeed", nil);
    end;
end;

function u32.CanStart(p134) -- Line: 529
    -- upvalues: u8 (ref), Services (copy), u26 (copy)
    local Player = p134.Player;

    if not (Player and Player.Parent) then
        return false;
    end;

    if not u8 then
        u8 = require(Services:WaitForChild("BeeDefenseService"));
    end;

    local v135 = u8;

    if not v135 then
        return false;
    end;

    local Slot = p134.Slot;
    local v136;

    if Slot then
        local v137 = u26[Slot];

        if v137 == nil then
            v136 = false;
        else
            v136 = os.clock() < v137;
        end;
    else
        v136 = false;
    end;

    if not v136 then
        local v138 = v135:GetShovelAggroTarget(Player);

        if v138 and (v138 and (v138:GetAttribute("InSafeZone") ~= true and (v138:GetAttribute("IsInOwnGarden") ~= true and v138:GetAttribute("InMinigame") ~= true))) then
            return true;
        end;
    end;

    local v139 = v135:PickTargetFor(Player);
    local v140;

    if v139 == nil or v139.Player == nil then
        v140 = false;
    else
        local Player2 = v139.Player;
        local v141 = not Player2 and true or (Player2:GetAttribute("InSafeZone") == true and true or (Player2:GetAttribute("IsInOwnGarden") == true and true or Player2:GetAttribute("InMinigame") == true));
        v140 = not v141;
    end;

    return v140;
end;

return u32;