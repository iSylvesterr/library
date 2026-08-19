-- Decompiled with Potassium's decompiler.

local BehaviorBase = require(script.Parent.BehaviorBase);
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SharedModules = ReplicatedStorage:WaitForChild("SharedModules");
local Networking = require(SharedModules.Networking);
local PetTypes = require(ReplicatedStorage:WaitForChild("SharedData"):WaitForChild("PetTypes"));
local PetSizes = require(ReplicatedStorage:WaitForChild("SharedData"):WaitForChild("PetSizes"));
local PetData = require(ReplicatedStorage:WaitForChild("SharedData"):WaitForChild("PetData"));
local Services = game:GetService("ServerScriptService"):WaitForChild("Services");
local u1 = nil;

local function GetBeeDefenseService() -- Line: 32
    -- upvalues: u1 (ref), Services (copy)
    if not u1 then
        u1 = require(Services:WaitForChild("BeeDefenseService"));
    end;

    return u1;
end;

local u2 = nil;

local function GetPetBehaviorService() -- Line: 40
    -- upvalues: u2 (ref), Services (copy)
    if not u2 then
        u2 = require(Services:WaitForChild("PetBehaviorService"));
    end;

    return u2;
end;

local u3 = nil;
local u4 = nil;

local function GetPetRecord(p5, p6) -- Line: 52
    -- upvalues: u4 (ref), u3 (ref), Services (copy)
    if not u4 then
        u3 = require(Services:WaitForChild("DataService"));
        u4 = u3.GetPet;
    end;

    return u4(u3, p5, p6);
end;

local u7 = {
    Big = 1.75,
    Huge = 2.5
};

local function StingDurationMultiplierForSize(p8) -- Line: 90
    -- upvalues: PetSizes (copy), u7 (copy)
    local v9 = PetSizes.Normalize(p8);

    return v9 and (u7[v9] or 1) or 1;
end;

local u10 = {
    Big = 1.5,
    Huge = 1.75
};

local function SwarmSpeedMultiplierForSize(p11) -- Line: 106
    -- upvalues: PetSizes (copy), u10 (copy)
    local v12 = PetSizes.Normalize(p11);

    return v12 and (u10[v12] or 1) or 1;
end;

local u13 = setmetatable({}, {
    __mode = "k"
});
local u14 = setmetatable({}, {
    __mode = "k"
});

local function GetLastStingAt(p15, p16) -- Line: 128
    -- upvalues: u14 (copy)
    local v17 = u14[p15];

    if v17 then
        return v17[p16];
    end;

    return nil;
end;

local function MarkLastStingAt(p18, p19, p20) -- Line: 134
    -- upvalues: u14 (copy)
    local v21 = u14[p18];

    if not v21 then
        v21 = {};
        u14[p18] = v21;
    end;

    v21[p19] = p20;
end;

local u22 = setmetatable({}, {
    __index = BehaviorBase
});
u22.__index = u22;
u22.Name = "DefendGarden";

local function MakeGoalCFrame(p23, p24) -- Line: 150
    local v25 = p24 - p23;

    if v25.Magnitude < 0.001 then
        return CFrame.new(p24);
    end;

    return CFrame.lookAt(p24, p24 + v25.Unit);
end;

local function FlyTo(p26, p27, p28) -- Line: 162
    local v29 = p26.Control:GetSlotPosition();

    if not v29 then
        return;
    end;

    local Control = p26.Control;
    local v30 = p27 - v29;
    local v31;

    if v30.Magnitude < 0.001 then
        v31 = CFrame.new(p27);
    else
        v31 = CFrame.lookAt(p27, p27 + v30.Unit);
    end;

    Control:SetGoal(v31, p28);
end;

local function FlyToContact(p32, p33, p34) -- Line: 175
    local v35 = p32.Control:GetSlotPosition();

    if not v35 then
        return;
    end;

    local v36 = (not p32.Module or (not p32.Module.IsFlying or type(p32.Module.AirHeight) ~= "number")) and 0 or p32.Module.AirHeight;
    local v37 = Vector3.new(p33.X, p33.Y - v36, p33.Z);
    p32.Control:SetSlotAttribute("Hovering", true);
    local Control = p32.Control;
    local v38 = v37 - v35;
    local v39;

    if v38.Magnitude < 0.001 then
        v39 = CFrame.new(v37);
    else
        v39 = CFrame.lookAt(v37, v37 + v38.Unit);
    end;

    Control:SetGoal(v39, p34);
end;

local function ClearCombatHover(p40) -- Line: 189
    if p40.Control and p40.Control.SetSlotAttribute then
        p40.Control:SetSlotAttribute("Hovering", nil);
    end;
end;

local function SetChasing(p41, p42) -- Line: 199
    if p41.Control and p41.Control.SetSlotAttribute then
        p41.Control:SetSlotAttribute("BeeChasing", p42 and true or nil);
    end;
end;

local function DistanceTo(p43, p44) -- Line: 205
    local v45 = p43.Control:GetSlotPosition();

    return not v45 and (1 / 0) or (p44 - v45).Magnitude;
end;

local function TargetKey(p46) -- Line: 211
    if not p46 then
        return nil;
    end;

    if p46.Kind == "Player" and p46.Player then
        return "P:" .. tostring(p46.Player.UserId);
    end;

    if p46.Kind == "Raccoon" and (p46.RaccoonOwner and p46.RaccoonPetId) then
        return "R:" .. tostring(p46.RaccoonOwner.UserId) .. ":" .. tostring(p46.RaccoonPetId);
    end;

    return nil;
end;

local function TargetPosition(p47) -- Line: 224
    if not p47 then
        return nil;
    end;

    if p47.Kind ~= "Player" or not p47.Player then
        if p47.Kind == "Raccoon" and (p47.Slot and p47.Slot.Parent) then
            return p47.Slot.Position;
        end;

        return nil;
    end;

    local Character = p47.Player.Character;

    if not Character then
        return nil;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
        return HumanoidRootPart.Position;
    end;

    return nil;
end;

local function IsTargetStillValid(p48, p49) -- Line: 246
    -- upvalues: u1 (ref), Services (copy)
    if not p49 then
        return false;
    end;

    if p49.Kind ~= "Player" then
        if p49.Kind ~= "Raccoon" then
            return false;
        end;

        if not (p49.Slot and p49.Slot.Parent) then
            return false;
        end;

        if p49.Slot:GetAttribute("PetSpecies") == "Raccoon" then
            return p49.Slot:GetAttribute("PetClaim") == "StealFruit";
        end;

        return false;
    end;

    local Player = p49.Player;

    if not (Player and Player.Parent) then
        return false;
    end;

    if Player:GetAttribute("InSafeZone") == true then
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

    local v50 = Character:FindFirstChildOfClass("Humanoid");

    if not v50 or v50.Health <= 0 then
        return false;
    end;

    if p49.ShovelAggro then
        if not u1 then
            u1 = require(Services:WaitForChild("BeeDefenseService"));
        end;

        local v51 = u1;

        if v51 then
            v51 = v51:GetShovelAggroTarget(p48.Player);
        end;

        if v51 ~= Player then
            return false;
        end;
    end;

    return true;
end;

local function GetHomePos(p52) -- Line: 281
    local v53 = nil;
    local v54 = p52.Player:GetAttribute("PlotId");

    if type(v54) == "number" then
        local Gardens = workspace:FindFirstChild("Gardens");

        if Gardens then
            v53 = Gardens:FindFirstChild("Plot" .. tostring(v54));
        end;
    end;

    if not v53 then
        return nil;
    end;

    local SpawnPoint = v53:FindFirstChild("SpawnPoint");

    if SpawnPoint and SpawnPoint:IsA("BasePart") then
        return SpawnPoint.Position;
    end;

    if v53:IsA("Model") then
        return v53:GetPivot().Position;
    end;

    return nil;
end;

local function FireSting(u55, u56) -- Line: 302
    -- upvalues: u4 (ref), u3 (ref), Services (copy), u1 (ref), PetSizes (copy), u7 (copy), PetTypes (copy), PetData (copy), Networking (copy)
    if not (u56 and u56.Parent) then
        return;
    end;

    local Player = u55.Player;
    local PetId = u55.PetId;

    if not u4 then
        u3 = require(Services:WaitForChild("DataService"));
        u4 = u3.GetPet;
    end;

    local v57 = u4(u3, Player, PetId);
    local v58;

    if v57 then
        v58 = v57.Size;
    else
        v58 = nil;
    end;

    if not u1 then
        u1 = require(Services:WaitForChild("BeeDefenseService"));
    end;

    local v59 = u1;
    local u60;

    if v59 then
        local v61 = PetSizes.Normalize(v58);
        local v62;

        if v57 then
            v62 = v57.Type;
        else
            v62 = nil;
        end;

        u60 = v59:ApplyStingEffect(u56, (v61 and (u7[v61] or 1) or 1) * PetTypes.GetBoostMultiplier(v62));
    else
        u60 = 0;
    end;

    local v63 = u55.Slot and u55.Slot:GetAttribute("PetSpecies");
    local u64 = (typeof(v63) ~= "string" or v63 == "") and "Bee" or PetData.GetDisplayName(v63, v58);
    pcall(function() -- Line: 327
        -- upvalues: Networking (ref), u56 (copy), u55 (copy), u64 (copy)
        Networking.Notification:FireClient(u56, (`{u55.Player.Name}'s {u64} stung you! You feel woozy...`));
    end);
    pcall(function() -- Line: 334
        -- upvalues: Networking (ref), u56 (copy), u60 (ref)
        Networking.Bee.Sting:FireClient(u56, u60);
    end);
    local Character = u56.Character;

    if not Character then
        return;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        return;
    end;

    local u65 = Character:FindFirstChildOfClass("Humanoid");
    local v66 = u55.Control:GetSlotPosition() or HumanoidRootPart.Position;
    local v67 = HumanoidRootPart.Position - v66;
    local v68 = Vector3.new(v67.X, 0, v67.Z);
    local v69;

    if v68.Magnitude < 0.001 then
        local v70 = HumanoidRootPart.CFrame.LookVector * -1;
        local v71 = Vector3.new(v70.X, 0, v70.Z);
        v69 = v71.Magnitude < 0.001 and Vector3.new(0, 0, -1) or v71.Unit;
    else
        v69 = v68.Unit;
    end;

    if u65 then
        u65.PlatformStand = true;
        task.delay(0.5, function() -- Line: 365
            -- upvalues: u65 (copy)
            if u65 and u65.Parent then
                u65.PlatformStand = false;
            end;
        end);
    end;

    local BodyVelocity = Instance.new("BodyVelocity");
    BodyVelocity.MaxForce = Vector3.new(inf, inf, inf);
    BodyVelocity.Velocity = v69 * 6 + Vector3.new(0, 12, 0);
    BodyVelocity.Parent = HumanoidRootPart;
    task.delay(0.3, function() -- Line: 378
        -- upvalues: BodyVelocity (copy)
        if BodyVelocity and BodyVelocity.Parent then
            BodyVelocity:Destroy();
        end;
    end);
end;

local function TryHit(u72, u73, p74) -- Line: 394
    -- upvalues: TargetKey (copy), u14 (copy), u1 (ref), Services (copy), FireSting (copy), u2 (ref)
    local v75 = TargetKey(u73);

    if not v75 then
        return false;
    end;

    if u73.Kind ~= "Player" or not u73.Player then
        if u73.Kind ~= "Raccoon" or not (u73.RaccoonOwner and u73.RaccoonPetId) then
            return false;
        end;

        if not u2 then
            u2 = require(Services:WaitForChild("PetBehaviorService"));
        end;

        local u76 = u2;

        if u76 then
            pcall(function() -- Line: 422
                -- upvalues: u76 (copy), u73 (copy), u72 (copy)
                u76:OnPetScared(u73.RaccoonOwner, u73.RaccoonPetId, u72.Player);
            end);
        end;

        return true;
    end;

    local Player = u73.Player;
    local v77 = u14[u72.Slot];
    local v78;

    if v77 then
        v78 = v77[v75];
    else
        v78 = nil;
    end;

    if v78 and p74 - v78 < u72.StingCooldown then
        return false;
    end;

    if not u1 then
        u1 = require(Services:WaitForChild("BeeDefenseService"));
    end;

    local v79 = u1;

    if v79 and v79:IsTargetStingInvulnerable(Player) then
        return false;
    end;

    local Slot = u72.Slot;
    local v80 = u14[Slot];

    if not v80 then
        v80 = {};
        u14[Slot] = v80;
    end;

    v80[v75] = p74;

    if v79 then
        v79:MarkTargetStung(Player);
    end;

    FireSting(u72, Player);

    return true;
end;

local function IsShovelAggroOnCooldown(p81) -- Line: 433
    -- upvalues: u13 (copy)
    if not p81 then
        return false;
    end;

    local v82 = u13[p81];
    local v83;

    if v82 == nil then
        v83 = false;
    else
        v83 = os.clock() < v82;
    end;

    return v83;
end;

local function MarkShovelAggroStarted(p84, p85) -- Line: 439
    -- upvalues: u13 (copy)
    if not p84 then
        return;
    end;

    u13[p84] = os.clock() + p85;
end;

local function BuildStates() -- Line: 444
    -- upvalues: u1 (ref), Services (copy), u13 (copy), TargetPosition (copy), FlyToContact (copy), IsTargetStillValid (copy), TryHit (copy), GetHomePos (copy)
    return {
        Acquire = {
            Enter = function(p86) -- Line: 451, Name: Enter
                -- upvalues: u1 (ref), Services (ref), u13 (ref)
                if not u1 then
                    u1 = require(Services:WaitForChild("BeeDefenseService"));
                end;

                local v87 = u1;

                if v87 then
                    local Slot = p86.Slot;
                    local v88;

                    if Slot then
                        local v89 = u13[Slot];

                        if v89 == nil then
                            v88 = false;
                        else
                            v88 = os.clock() < v89;
                        end;
                    else
                        v88 = false;
                    end;

                    local v90 = not v88 and v87:GetShovelAggroTarget(p86.Player);

                    if v90 then
                        local Slot2 = p86.Slot;
                        local ShovelAggroCooldown = p86.ShovelAggroCooldown;

                        if Slot2 then
                            u13[Slot2] = os.clock() + ShovelAggroCooldown;
                        end;

                        p86.Target = {
                            Kind = "Player",
                            ShovelAggro = true,
                            Player = v90
                        };
                        p86:TransitionTo("Dive");

                        return;
                    end;
                end;

                if v87 then
                    v87 = v87:PickTargetFor(p86.Player);
                end;

                if not v87 then
                    p86:Stop("NoThreat");

                    return;
                end;

                p86.Target = v87;
                p86:TransitionTo("Dive");
            end
        },
        Dive = {
            Enter = function(p91) -- Line: 485, Name: Enter
                -- upvalues: TargetPosition (ref), FlyToContact (ref)
                if p91.Control and p91.Control.SetSlotAttribute then
                    p91.Control:SetSlotAttribute("BeeChasing", true);
                end;

                local v92 = TargetPosition(p91.Target);

                if v92 then
                    FlyToContact(p91, v92, p91.AttackSpeed);
                end;
            end,

            Update = function(p93, p94, p95) -- Line: 491, Name: Update
                -- upvalues: IsTargetStillValid (ref), TargetPosition (ref), FlyToContact (ref), TryHit (ref)
                if not IsTargetStillValid(p93, p93.Target) then
                    p93:TransitionTo("Acquire");

                    return;
                end;

                local v96 = TargetPosition(p93.Target);

                if not v96 then
                    p93:TransitionTo("Acquire");

                    return;
                end;

                FlyToContact(p93, v96, p93.AttackSpeed);
                local v97 = p93.Control:GetSlotPosition();

                if (not v97 and (1 / 0) or (v96 - v97).Magnitude) <= p93.HitRadius then
                    TryHit(p93, p93.Target, p94);
                    p93:TransitionTo("Orbit");

                    return;
                end;

                if p93:TimeInState() < p93.DiveLegTimeout then
                    return;
                end;

                p93:TransitionTo("Acquire");
            end
        },
        Orbit = {
            Enter = function(p98) -- Line: 524, Name: Enter
                -- upvalues: TargetPosition (ref), FlyToContact (ref)
                if p98.Control and p98.Control.SetSlotAttribute then
                    p98.Control:SetSlotAttribute("BeeChasing", true);
                end;

                local v99 = TargetPosition(p98.Target);

                if not v99 then
                    return;
                end;

                local v100 = math.random() * 3.141592653589793 * 2;
                local v101 = p98.OrbitYMin + math.random() * (p98.OrbitYMax - p98.OrbitYMin);
                p98._OrbitBaseY = v101;
                local v102 = v101 + (math.random() * 2 - 1) * p98.OrbitYJitter;
                local v103 = math.cos(v100) * p98.OrbitRadius;
                local v104 = math.sin(v100) * p98.OrbitRadius;
                FlyToContact(p98, v99 + Vector3.new(v103, v102, v104), p98.AttackSpeed);
                p98._OrbitAngle = v100;
                p98._OrbitDir = math.random() < 0.5 and 1 or -1;
            end,

            Update = function(p105, p106, p107) -- Line: 547, Name: Update
                -- upvalues: TargetPosition (ref), FlyToContact (ref), u1 (ref), Services (ref), u13 (ref), IsTargetStillValid (ref)
                local v108 = TargetPosition(p105.Target);

                if v108 and p105._OrbitAngle then
                    p105._OrbitAngle = p105._OrbitAngle + p105._OrbitDir * 4 * p107;
                    local v109 = p105._OrbitBaseY + (math.random() * 2 - 1) * p105.OrbitYJitter;
                    local v110 = math.cos(p105._OrbitAngle) * p105.OrbitRadius;
                    local v111 = math.sin(p105._OrbitAngle) * p105.OrbitRadius;
                    FlyToContact(p105, v108 + Vector3.new(v110, v109, v111), p105.AttackSpeed);
                end;

                if p105:TimeInState() < p105.OrbitDuration then
                    return;
                end;

                if not u1 then
                    u1 = require(Services:WaitForChild("BeeDefenseService"));
                end;

                local v112 = u1;
                local v113 = p105.Target and p105.Target.ShovelAggro;

                if v112 and not v113 then
                    local Slot = p105.Slot;
                    local v114;

                    if Slot then
                        local v115 = u13[Slot];

                        if v115 == nil then
                            v114 = false;
                        else
                            v114 = os.clock() < v115;
                        end;
                    else
                        v114 = false;
                    end;

                    local v116 = not v114 and v112:GetShovelAggroTarget(p105.Player);

                    if v116 then
                        local Slot2 = p105.Slot;
                        local ShovelAggroCooldown = p105.ShovelAggroCooldown;

                        if Slot2 then
                            u13[Slot2] = os.clock() + ShovelAggroCooldown;
                        end;

                        p105.Target = {
                            Kind = "Player",
                            ShovelAggro = true,
                            Player = v116
                        };
                        p105:TransitionTo("Dive");

                        return;
                    end;
                end;

                if v113 then
                    if IsTargetStillValid(p105, p105.Target) then
                        p105:TransitionTo("Dive");

                        return;
                    end;

                    p105:TransitionTo("Return");

                    return;
                end;

                if v112 then
                    v112 = v112:PickTargetFor(p105.Player);
                end;

                if not v112 then
                    p105:TransitionTo("Return");

                    return;
                end;

                p105.Target = v112;
                p105:TransitionTo("Dive");
            end
        },
        Return = {
            Enter = function(p117) -- Line: 614, Name: Enter
                -- upvalues: GetHomePos (ref)
                if p117.Control and p117.Control.SetSlotAttribute then
                    p117.Control:SetSlotAttribute("Hovering", nil);
                end;

                if p117.Control and p117.Control.SetSlotAttribute then
                    p117.Control:SetSlotAttribute("BeeChasing", nil);
                end;

                p117.HomePos = GetHomePos(p117);

                if p117.HomePos then
                    local HomePos = p117.HomePos;
                    local ReturnSpeed = p117.ReturnSpeed;
                    local v118 = p117.Control:GetSlotPosition();

                    if not v118 then
                        return;
                    end;

                    local Control = p117.Control;
                    local v119 = HomePos - v118;
                    local v120;

                    if v119.Magnitude < 0.001 then
                        v120 = CFrame.new(HomePos);
                    else
                        v120 = CFrame.lookAt(HomePos, HomePos + v119.Unit);
                    end;

                    Control:SetGoal(v120, ReturnSpeed);
                end;
            end,

            Update = function(p121, p122, p123) -- Line: 625, Name: Update
                if not p121.HomePos then
                    p121:Stop("NoHome");

                    return;
                end;

                local HomePos = p121.HomePos;
                local ReturnSpeed = p121.ReturnSpeed;
                local v124 = p121.Control:GetSlotPosition();

                if v124 then
                    local Control = p121.Control;
                    local v125 = HomePos - v124;
                    local v126;

                    if v125.Magnitude < 0.001 then
                        v126 = CFrame.new(HomePos);
                    else
                        v126 = CFrame.lookAt(HomePos, HomePos + v125.Unit);
                    end;

                    Control:SetGoal(v126, ReturnSpeed);
                end;

                local HomePos2 = p121.HomePos;
                local v127 = p121.Control:GetSlotPosition();

                if (not v127 and (1 / 0) or (HomePos2 - v127).Magnitude) <= p121.ReturnArriveRadius then
                    p121:Stop("Returned");

                    return;
                end;

                if p121:TimeInState() < p121.ReturnLegTimeout then
                    return;
                end;

                p121:Stop("ReturnTimeout");
            end
        }
    };
end;

function u22.new(p128) -- Line: 647
    -- upvalues: BehaviorBase (copy), u22 (copy), u4 (ref), u3 (ref), Services (copy), PetTypes (copy), PetSizes (copy), u10 (copy), BuildStates (copy)
    local v129 = BehaviorBase.New(u22, p128);
    local Player = v129.Player;
    local PetId = v129.PetId;

    if not u4 then
        u3 = require(Services:WaitForChild("DataService"));
        u4 = u3.GetPet;
    end;

    local v130 = u4(u3, Player, PetId);
    local v131;

    if v130 then
        v131 = v130.Type;
    else
        v131 = nil;
    end;

    local v132 = PetTypes.GetBoostMultiplier(v131);
    local v133;

    if v130 then
        v133 = v130.Size;
    else
        v133 = nil;
    end;

    local v134 = PetSizes.Normalize(v133);
    v129.AttackSpeed = (v129.Config.AttackSpeed or 27) * (v132 * (v134 and (u10[v134] or 1) or 1));
    v129.ReturnSpeed = v129.Config.ReturnSpeed or 27;
    v129.StingCooldown = v129.Config.StingCooldown or 10;
    v129.HitRadius = v129.Config.HitRadius or 3.5;
    v129.OrbitRadius = v129.Config.OrbitRadius or 9;
    v129.OrbitDuration = v129.Config.OrbitDuration or 0.8;
    v129.OrbitYJitter = v129.Config.OrbitYJitter or 1;
    v129.OrbitYMin = v129.Config.OrbitYMin or -1;
    v129.OrbitYMax = v129.Config.OrbitYMax or 5;
    v129.DiveLegTimeout = v129.Config.DiveLegTimeout or 2.5;
    v129.ReturnLegTimeout = v129.Config.ReturnLegTimeout or 6;
    v129.ReturnArriveRadius = v129.Config.ReturnArriveRadius or 6;
    v129.ShovelAggroCooldown = v129.Config.ShovelAggroCooldown or 10;
    v129.Target = nil;
    v129.HomePos = nil;
    v129._OrbitAngle = nil;
    v129._OrbitDir = 1;
    v129._OrbitBaseY = 0;
    v129.States = BuildStates();

    return v129;
end;

function u22.GetInitialState(p135) -- Line: 683
    return "Acquire";
end;

function u22.OnStop(p136, p137) -- Line: 691
    if p136.Control and p136.Control.SetSlotAttribute then
        p136.Control:SetSlotAttribute("Hovering", nil);
    end;

    if p136.Control and p136.Control.SetSlotAttribute then
        p136.Control:SetSlotAttribute("BeeChasing", nil);
    end;
end;

function u22.CanStart(p138) -- Line: 699
    -- upvalues: u1 (ref), Services (copy), u13 (copy)
    local Player = p138.Player;

    if not (Player and Player.Parent) then
        return false;
    end;

    if not u1 then
        u1 = require(Services:WaitForChild("BeeDefenseService"));
    end;

    local v139 = u1;

    if not v139 then
        return false;
    end;

    local Slot = p138.Slot;
    local v140;

    if Slot then
        local v141 = u13[Slot];

        if v141 == nil then
            v140 = false;
        else
            v140 = os.clock() < v141;
        end;
    else
        v140 = false;
    end;

    return not v140 and v139:GetShovelAggroTarget(Player) and true or v139:PickTargetFor(Player) ~= nil;
end;

return u22;