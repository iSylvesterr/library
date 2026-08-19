-- Decompiled with Potassium's decompiler.

local BehaviorBase = require(script.Parent.BehaviorBase);
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerScriptService = game:GetService("ServerScriptService");
local SoundService = game:GetService("SoundService");
local Debris = game:GetService("Debris");
local Services = ServerScriptService:WaitForChild("Services");
local DataService = require(Services.DataService);
local SeedService = require(Services.SeedService);
local PetData = require(ReplicatedStorage.SharedData.PetData);
local PetSizes = require(ReplicatedStorage.SharedData.PetSizes);
local PetTypes = require(ReplicatedStorage.SharedData.PetTypes);
local RarityVisuals = require(ReplicatedStorage.SharedModules.RarityVisuals);
local SeedData = require(ReplicatedStorage.SharedModules.SeedData);
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local u1 = {};

for _, v in SeedData do
    if type(v) == "table" and type(v.SeedName) == "string" then
        u1[v.SeedName] = v.Rarity or "Common";
    end;
end;

local function GetSeedRarity(p2) -- Line: 41
    -- upvalues: u1 (copy)
    return u1[p2] or "Common";
end;

local u3 = {
    Big = 2,
    Huge = 3
};

local function GetStealCapacity(p4) -- Line: 55
    -- upvalues: PetSizes (copy), u3 (copy)
    if not p4 then
        return 1;
    end;

    local v5 = p4:GetAttribute("PetSize");
    local Normalize = PetSizes.Normalize;

    if type(v5) ~= "string" then
        v5 = nil;
    end;

    local v6 = Normalize(v5);

    return v6 and u3[v6] or 1;
end;

local function DescribeStolenSeeds(p7) -- Line: 64
    -- upvalues: RarityVisuals (copy), u1 (copy)
    if #p7 == 1 then
        return "a " .. RarityVisuals.RichText(p7[1] .. " Seed", u1[p7[1]] or "Common");
    end;

    local v8 = {};

    for _, v in p7 do
        table.insert(v8, RarityVisuals.RichText(v .. " Seed", u1[v] or "Common"));
    end;

    return table.concat(v8, ", ");
end;

local u9 = {
    Big = 1.5,
    Huge = 2
};
local u10 = {
    NoTarget = true
};
local u11 = {};

local function IsVictimReserved(p12) -- Line: 111
    -- upvalues: u11 (copy)
    local v13 = u11[p12];

    if not v13 then
        return false;
    end;

    if os.clock() - v13 < 75 then
        return true;
    end;

    u11[p12] = nil;

    return false;
end;

local u14 = setmetatable({}, {
    __index = BehaviorBase
});
u14.__index = u14;
u14.Name = "StealSeed";
local u15 = nil;

local function GetWanderService() -- Line: 129
    -- upvalues: u15 (ref), Services (copy)
    if not u15 then
        local success, result = pcall(require, Services:FindFirstChild("WanderService"));

        if success then
            u15 = result;
        end;
    end;

    return u15;
end;

local function PlayFoxSound(p16, p17, p18) -- Line: 140
    -- upvalues: SoundService (copy), Debris (copy)
    if not (p16 and p16.Parent) then
        return;
    end;

    local SFX = SoundService:FindFirstChild("SFX");

    if SFX then
        SFX = SFX:FindFirstChild("Fox");
    end;

    if SFX then
        SFX = SFX:FindFirstChild(p17);
    end;

    if not (SFX and SFX:IsA("Sound")) then
        return;
    end;

    local v19 = SFX:Clone();
    v19.Volume = p18;
    v19.Parent = p16;
    v19:Play();
    Debris:AddItem(v19, (v19.TimeLength <= 0 and 5 or v19.TimeLength) + 1);
end;

local function GetVictimSeeds(p20) -- Line: 154
    -- upvalues: DataService (copy)
    local v21 = DataService.Profiles[p20];

    if not (v21 and v21.Data) then
        return nil;
    end;

    local v22 = DataService.GetWorldDataFromProfileData(v21.Data);

    if v22 then
        v22 = v22.Inventory;
    end;

    if v22 then
        v22 = v22.Seeds;
    end;

    if type(v22) == "table" then
        return v22;
    end;

    return nil;
end;

local function VictimHasAnySeed(p23) -- Line: 165
    -- upvalues: DataService (copy)
    local v24 = DataService.Profiles[p23];
    local v25;

    if v24 and v24.Data then
        v25 = DataService.GetWorldDataFromProfileData(v24.Data);

        if v25 then
            v25 = v25.Inventory;
        end;

        if v25 then
            v25 = v25.Seeds;
        end;

        if type(v25) ~= "table" then
            v25 = nil;
        end;
    else
        v25 = nil;
    end;

    if not v25 then
        return false;
    end;

    for _, v in v25 do
        if type(v) == "number" and v > 0 then
            return true;
        end;
    end;

    return false;
end;

local function PickVictimSeed(p26) -- Line: 183
    -- upvalues: DataService (copy)
    local v27 = DataService.Profiles[p26];
    local v28;

    if v27 and v27.Data then
        v28 = DataService.GetWorldDataFromProfileData(v27.Data);

        if v28 then
            v28 = v28.Inventory;
        end;

        if v28 then
            v28 = v28.Seeds;
        end;

        if type(v28) ~= "table" then
            v28 = nil;
        end;
    else
        v28 = nil;
    end;

    if not v28 then
        return nil;
    end;

    local function Holds(p29, p30) -- Line: 187
        local v31;

        if type(p29) == "string" and (type(p30) == "number" and p30 > 0) then
            v31 = p30 == p30;
        else
            v31 = false;
        end;

        return v31;
    end;

    local v32 = 0;

    for i, v in v28 do
        local v33;

        if type(i) == "string" and (type(v) == "number" and v > 0) then
            v33 = v == v;
        else
            v33 = false;
        end;

        if v33 then
            v32 = v32 + v;
        end;
    end;

    if v32 <= 0 then
        return nil;
    end;

    local v34 = math.random() * v32;
    local v35 = 0;
    local v36 = nil;

    for i, v in v28 do
        local v37;

        if type(i) == "string" and (type(v) == "number" and v > 0) then
            v37 = v == v;
        else
            v37 = false;
        end;

        if v37 then
            v35 = v35 + v;

            if v34 <= v35 then
                return i;
            end;

            v36 = i;
        end;
    end;

    return v36;
end;

local function GetPlotFolder(p38) -- Line: 213
    local v39 = p38:GetAttribute("PlotId");

    if type(v39) ~= "number" then
        return nil;
    end;

    local Gardens = workspace:FindFirstChild("Gardens");

    if Gardens then
        return Gardens:FindFirstChild("Plot" .. tostring(v39));
    end;

    return nil;
end;

local function IsNightTime() -- Line: 222
    -- upvalues: ReplicatedStorage (copy)
    local Night = ReplicatedStorage:FindFirstChild("Night");

    if Night and Night:IsA("BoolValue") then
        return Night.Value == true;
    end;

    return false;
end;

local function IsUnattackable(p40) -- Line: 231
    return not p40 and true or (p40:GetAttribute("InSafeZone") == true and true or (p40:GetAttribute("IsInOwnGarden") == true and true or p40:GetAttribute("InMinigame") == true));
end;

local function TargetPosition(p41) -- Line: 242
    if not p41 then
        return nil;
    end;

    local Character = p41.Character;

    if not Character then
        return nil;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
        return HumanoidRootPart.Position;
    end;

    return nil;
end;

local function GetSpeedMultiplier(p42) -- Line: 253
    -- upvalues: PetSizes (copy), u9 (copy), PetTypes (copy)
    if not p42 then
        return 1;
    end;

    local v43 = 1;
    local v44 = p42:GetAttribute("PetSize");
    local Normalize = PetSizes.Normalize;

    if type(v44) ~= "string" then
        v44 = nil;
    end;

    local v45 = Normalize(v44);

    if v45 and u9[v45] then
        v43 = v43 * u9[v45];
    end;

    if p42:GetAttribute("PetType") == PetTypes.Rainbow then
        v43 = v43 * 1.25;
    end;

    return v43;
end;

local function MakeGoalCFrame(p46, p47) -- Line: 268
    local v48 = Vector3.new(p47.X - p46.X, 0, p47.Z - p46.Z);

    if v48.Magnitude < 0.001 then
        return CFrame.new(p47);
    end;

    return CFrame.lookAt(p47, p47 + v48.Unit);
end;

local function ClearCarryAttributes(p49) -- Line: 277
    p49:SetSlotAttribute("CarryingSeed", nil);
    p49:SetSlotAttribute("CarryingSeedVictim", nil);
end;

local function FlyTo(p50, p51, p52) -- Line: 283
    local v53 = p50.Control:GetSlotPosition();

    if not v53 then
        return;
    end;

    local v54 = Vector3.new(p51.X - v53.X, 0, p51.Z - v53.Z);
    local v55;

    if v54.Magnitude < 0.001 then
        v55 = CFrame.new(p51);
    else
        v55 = CFrame.lookAt(p51, p51 + v54.Unit);
    end;

    p50.Control:SetGoal(v55, p52);
end;

local function DistanceTo(p56, p57) -- Line: 291
    local v58 = p56.Control:GetSlotPosition();

    if not v58 then
        return (1 / 0);
    end;

    local v59 = p57.X - v58.X;
    local v60 = p57.Z - v58.Z;

    return math.sqrt(v59 * v59 + v60 * v60);
end;

local function ReturnSeedsToVictim(p61) -- Line: 302
    -- upvalues: SeedService (copy)
    if not p61.SeedCommitted then
        return;
    end;

    p61.SeedCommitted = false;
    local VictimPlayer = p61.VictimPlayer;

    if not (VictimPlayer and (VictimPlayer.Parent and VictimPlayer:HasTag("DataLoaded"))) then
        return;
    end;

    if p61.StolenSeeds then
        for _, v in p61.StolenSeeds do
            SeedService:GiveSeed(VictimPlayer, v, 1);
        end;
    end;
end;

local function NotifyScare(p62, p63) -- Line: 315
    if p63 then
        p63 = p63.Scarer;
    end;

    local v64 = p62.Species or "Pet";
    local Player = p62.Player;

    if p63 and p63.Parent then
        p62.Control:NotifyPlayer(p63, "You shooed away " .. (Player and (Player.Name or "a player") or "a player") .. "\'s " .. v64 .. "!");
    end;

    if Player and (Player.Parent and p63 ~= Player) then
        p62.Control:Notify((p63 and p63.Name or "Someone") .. " shooed away your " .. v64 .. "!");
    end;
end;

local function PickRandomTarget(p65) -- Line: 329
    -- upvalues: ReplicatedStorage (copy), Players (copy), u11 (copy), DataService (copy)
    local Night = ReplicatedStorage:FindFirstChild("Night");
    local v66;

    if Night and Night:IsA("BoolValue") then
        v66 = Night.Value == true;
    else
        v66 = false;
    end;

    if not v66 then
        return nil;
    end;

    local v67 = {};

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= p65 and v:HasTag("DataLoaded") and (v and (v:GetAttribute("InSafeZone") ~= true and (v:GetAttribute("IsInOwnGarden") ~= true and v:GetAttribute("InMinigame") ~= true))) then
            local UserId = v.UserId;
            local v68 = u11[UserId];
            local v69;

            if v68 then
                if os.clock() - v68 >= 75 then
                    u11[UserId] = nil;
                    v69 = false;
                else
                    v69 = true;
                end;
            else
                v69 = false;
            end;

            if not v69 then
                local v70;

                if v then
                    local Character = v.Character;

                    if Character then
                        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

                        if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
                            v70 = HumanoidRootPart.Position;
                        else
                            v70 = nil;
                        end;
                    else
                        v70 = nil;
                    end;
                else
                    v70 = nil;
                end;

                if v70 then
                    local v71 = DataService.Profiles[v];
                    local v72;

                    if v71 and v71.Data then
                        v72 = DataService.GetWorldDataFromProfileData(v71.Data);

                        if v72 then
                            v72 = v72.Inventory;
                        end;

                        if v72 then
                            v72 = v72.Seeds;
                        end;

                        if type(v72) ~= "table" then
                            v72 = nil;
                        end;
                    else
                        v72 = nil;
                    end;

                    local v73;

                    if v72 then
                        v73 = false;

                        for _, v2 in v72 do
                            if type(v2) == "number" and v2 > 0 then
                                v73 = true;
                                break;
                            end;
                        end;
                    else
                        v73 = false;
                    end;

                    if v73 then
                        table.insert(v67, {
                            VictimPlayer = v
                        });
                    end;
                end;
            end;
        end;
    end;

    if #v67 == 0 then
        return nil;
    end;

    return v67[math.random(1, #v67)];
end;

local function BuildStates() -- Line: 362
    -- upvalues: PickRandomTarget (copy), u11 (copy), DataService (copy), NotifyScare (copy), PickVictimSeed (copy), SeedService (copy), PlayFoxSound (copy), Networking (copy), PetData (copy), DescribeStolenSeeds (copy), ReturnSeedsToVictim (copy)
    return {
        Targeting = {
            Enter = function(p74) -- Line: 369, Name: Enter
                -- upvalues: PickRandomTarget (ref), u11 (ref)
                local v75 = PickRandomTarget(p74.Player);

                if not v75 then
                    p74:Stop("NoTarget");

                    return;
                end;

                p74.VictimPlayer = v75.VictimPlayer;
                p74.VictimUserId = v75.VictimPlayer.UserId;
                p74.ReservedUserId = p74.VictimUserId;
                u11[p74.ReservedUserId] = os.clock();
                p74:TransitionTo("Outbound");
            end
        },
        Outbound = {
            Enter = function(p76) -- Line: 390, Name: Enter
                local VictimPlayer = p76.VictimPlayer;
                local v77;

                if VictimPlayer then
                    local Character = VictimPlayer.Character;

                    if Character then
                        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

                        if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
                            v77 = HumanoidRootPart.Position;
                        else
                            v77 = nil;
                        end;
                    else
                        v77 = nil;
                    end;
                else
                    v77 = nil;
                end;

                if v77 then
                    local TravelSpeed = p76.TravelSpeed;
                    local v78 = p76.Control:GetSlotPosition();

                    if not v78 then
                        return;
                    end;

                    local v79 = Vector3.new(v77.X - v78.X, 0, v77.Z - v78.Z);
                    local v80;

                    if v79.Magnitude < 0.001 then
                        v80 = CFrame.new(v77);
                    else
                        v80 = CFrame.lookAt(v77, v77 + v79.Unit);
                    end;

                    p76.Control:SetGoal(v80, TravelSpeed);
                end;
            end,

            Update = function(p81, p82, p83) -- Line: 395, Name: Update
                -- upvalues: DataService (ref)
                if not (p81.VictimPlayer and p81.VictimPlayer.Parent) then
                    p81:TransitionTo("Aborting");

                    return;
                end;

                local VictimPlayer = p81.VictimPlayer;

                if not VictimPlayer and true or (VictimPlayer:GetAttribute("InSafeZone") == true and true or (VictimPlayer:GetAttribute("IsInOwnGarden") == true and true or VictimPlayer:GetAttribute("InMinigame") == true)) then
                    p81:TransitionTo("Aborting");

                    return;
                end;

                local v84 = DataService.Profiles[p81.VictimPlayer];
                local v85;

                if v84 and v84.Data then
                    v85 = DataService.GetWorldDataFromProfileData(v84.Data);

                    if v85 then
                        v85 = v85.Inventory;
                    end;

                    if v85 then
                        v85 = v85.Seeds;
                    end;

                    if type(v85) ~= "table" then
                        v85 = nil;
                    end;
                else
                    v85 = nil;
                end;

                local v86;

                if v85 then
                    v86 = false;

                    for _, v in v85 do
                        if type(v) == "number" and v > 0 then
                            v86 = true;
                            break;
                        end;
                    end;
                else
                    v86 = false;
                end;

                if not v86 then
                    p81:TransitionTo("Aborting");

                    return;
                end;

                local VictimPlayer2 = p81.VictimPlayer;
                local v87;

                if VictimPlayer2 then
                    local Character = VictimPlayer2.Character;

                    if Character then
                        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

                        if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
                            v87 = HumanoidRootPart.Position;
                        else
                            v87 = nil;
                        end;
                    else
                        v87 = nil;
                    end;
                else
                    v87 = nil;
                end;

                if not v87 then
                    p81:TransitionTo("Aborting");

                    return;
                end;

                local TravelSpeed = p81.TravelSpeed;
                local v88 = p81.Control:GetSlotPosition();

                if v88 then
                    local v89 = Vector3.new(v87.X - v88.X, 0, v87.Z - v88.Z);
                    local v90;

                    if v89.Magnitude < 0.001 then
                        v90 = CFrame.new(v87);
                    else
                        v90 = CFrame.lookAt(v87, v87 + v89.Unit);
                    end;

                    p81.Control:SetGoal(v90, TravelSpeed);
                end;

                local v91 = p81.Control:GetSlotPosition();
                local v92;

                if v91 then
                    local v93 = v87.X - v91.X;
                    local v94 = v87.Z - v91.Z;
                    v92 = math.sqrt(v93 * v93 + v94 * v94);
                else
                    v92 = (1 / 0);
                end;

                if v92 <= 3 then
                    p81:TransitionTo("Stealing");

                    return;
                end;

                if p81:TimeInState() < p81.LegTimeout then
                    return;
                end;

                p81:TransitionTo("Aborting");
            end,

            OnEvent = function(p95, p96, p97) -- Line: 433, Name: OnEvent
                -- upvalues: NotifyScare (ref)
                if p96 == "Scared" then
                    NotifyScare(p95, p97);
                    p95:TransitionTo("Aborting");
                end;
            end
        },
        Stealing = {
            Enter = function(p98) -- Line: 445, Name: Enter
                local VictimPlayer = p98.VictimPlayer;
                local v99;

                if VictimPlayer then
                    local Character = VictimPlayer.Character;

                    if Character then
                        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

                        if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
                            v99 = HumanoidRootPart.Position;
                        else
                            v99 = nil;
                        end;
                    else
                        v99 = nil;
                    end;
                else
                    v99 = nil;
                end;

                if v99 then
                    local TravelSpeed = p98.TravelSpeed;
                    local v100 = p98.Control:GetSlotPosition();

                    if not v100 then
                        return;
                    end;

                    local v101 = Vector3.new(v99.X - v100.X, 0, v99.Z - v100.Z);
                    local v102;

                    if v101.Magnitude < 0.001 then
                        v102 = CFrame.new(v99);
                    else
                        v102 = CFrame.lookAt(v99, v99 + v101.Unit);
                    end;

                    p98.Control:SetGoal(v102, TravelSpeed);
                end;
            end,

            Update = function(p103, p104, p105) -- Line: 452, Name: Update
                -- upvalues: PickVictimSeed (ref), SeedService (ref), DataService (ref), PlayFoxSound (ref), Networking (ref), PetData (ref), DescribeStolenSeeds (ref)
                if not (p103.VictimPlayer and p103.VictimPlayer.Parent) then
                    p103:TransitionTo("Aborting");

                    return;
                end;

                local VictimPlayer = p103.VictimPlayer;

                if not VictimPlayer and true or (VictimPlayer:GetAttribute("InSafeZone") == true and true or (VictimPlayer:GetAttribute("IsInOwnGarden") == true and true or VictimPlayer:GetAttribute("InMinigame") == true)) then
                    p103:TransitionTo("Aborting");

                    return;
                end;

                local VictimPlayer2 = p103.VictimPlayer;
                local v106;

                if VictimPlayer2 then
                    local Character = VictimPlayer2.Character;

                    if Character then
                        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

                        if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
                            v106 = HumanoidRootPart.Position;
                        else
                            v106 = nil;
                        end;
                    else
                        v106 = nil;
                    end;
                else
                    v106 = nil;
                end;

                if v106 then
                    local TravelSpeed = p103.TravelSpeed;
                    local v107 = p103.Control:GetSlotPosition();

                    if v107 then
                        local v108 = Vector3.new(v106.X - v107.X, 0, v106.Z - v107.Z);
                        local v109;

                        if v108.Magnitude < 0.001 then
                            v109 = CFrame.new(v106);
                        else
                            v109 = CFrame.lookAt(v106, v106 + v108.Unit);
                        end;

                        p103.Control:SetGoal(v109, TravelSpeed);
                    end;
                end;

                if p103:TimeInState() < p103.StealDuration then
                    return;
                end;

                if p103.StealCommitInFlight then
                    return;
                end;

                p103.StealCommitInFlight = true;
                local v110 = {};

                for _ = 1, p103.Capacity do
                    local v111 = PickVictimSeed(p103.VictimPlayer);

                    if not v111 then
                        break;
                    end;

                    if SeedService:RemoveSeed(p103.VictimPlayer, v111, 1) then
                        table.insert(v110, v111);
                    end;
                end;

                if #v110 == 0 then
                    p103:TransitionTo("Aborting");

                    return;
                end;

                local v112 = DataService:SaveProfileSync(p103.VictimPlayer);
                local v113 = DataService.Profiles[p103.VictimPlayer];

                if not (v112 and (v113 and v113:IsActive())) then
                    for _, v in v110 do
                        SeedService:GiveSeed(p103.VictimPlayer, v, 1);
                    end;

                    p103:TransitionTo("Aborting");

                    return;
                end;

                p103.StolenSeeds = v110;
                p103.SeedCommitted = true;

                if p103.Done or p103.State ~= "Stealing" then
                    return;
                end;

                PlayFoxSound(p103.Slot, "FoxSteal", 1);

                if p103.Player and p103.Player.Parent then
                    Networking.SFX.PlaySound:FireClient(p103.Player, "FoxSteal");
                end;

                if p103.VictimPlayer and p103.VictimPlayer.Parent then
                    Networking.SFX.PlaySound:FireClient(p103.VictimPlayer, "FoxSteal");
                end;

                p103.Control:SetSlotAttribute("CarryingSeedVictim", p103.VictimUserId);
                p103.Control:SetSlotAttribute("CarryingSeed", table.concat(v110, "|"));
                local v114 = p103.Player and (p103.Player.Name or "Someone") or "Someone";
                local v115 = p103.VictimPlayer and (p103.VictimPlayer.Name or "someone") or "someone";
                local v116 = p103.Slot and p103.Slot:GetAttribute("PetSize");
                local v117 = PetData.GetDisplayName(p103.Species, v116);
                local v118 = DescribeStolenSeeds(v110);
                p103.Control:Notify((`Your {v117} is stealing {v118} from {v115}!`));

                if p103.VictimPlayer and p103.VictimPlayer.Parent then
                    p103.Control:NotifyPlayer(p103.VictimPlayer, (`{v114}'s {v117} is attempting to steal {v118} from you!`));
                end;

                p103:TransitionTo("Returning");
            end,

            OnEvent = function(p119, p120, p121) -- Line: 551, Name: OnEvent
                -- upvalues: NotifyScare (ref)
                if p120 == "Scared" then
                    NotifyScare(p119, p121);
                    p119:TransitionTo("Aborting");
                end;
            end
        },
        Returning = {
            Enter = function(p122) -- Line: 561, Name: Enter
                local v123 = p122.Player:GetAttribute("PlotId");
                local v124;

                if type(v123) == "number" then
                    local Gardens = workspace:FindFirstChild("Gardens");

                    if Gardens then
                        v124 = Gardens:FindFirstChild("Plot" .. tostring(v123));
                    else
                        v124 = nil;
                    end;
                else
                    v124 = nil;
                end;

                if not v124 then
                    p122:TransitionTo("Aborting");

                    return;
                end;

                local SpawnPoint = v124:FindFirstChild("SpawnPoint");
                p122.HomePos = SpawnPoint and SpawnPoint.Position or v124:GetPivot().Position;
                local HomePos = p122.HomePos;
                local TravelSpeed = p122.TravelSpeed;
                local v125 = p122.Control:GetSlotPosition();

                if not v125 then
                    return;
                end;

                local v126 = Vector3.new(HomePos.X - v125.X, 0, HomePos.Z - v125.Z);
                local v127;

                if v126.Magnitude < 0.001 then
                    v127 = CFrame.new(HomePos);
                else
                    v127 = CFrame.lookAt(HomePos, HomePos + v126.Unit);
                end;

                p122.Control:SetGoal(v127, TravelSpeed);
            end,

            Update = function(p128, p129, p130) -- Line: 572, Name: Update
                -- upvalues: ReturnSeedsToVictim (ref)
                local HomePos = p128.HomePos;
                local TravelSpeed = p128.TravelSpeed;
                local v131 = p128.Control:GetSlotPosition();

                if v131 then
                    local v132 = Vector3.new(HomePos.X - v131.X, 0, HomePos.Z - v131.Z);
                    local v133;

                    if v132.Magnitude < 0.001 then
                        v133 = CFrame.new(HomePos);
                    else
                        v133 = CFrame.lookAt(HomePos, HomePos + v132.Unit);
                    end;

                    p128.Control:SetGoal(v133, TravelSpeed);
                end;

                local HomePos2 = p128.HomePos;
                local v134 = p128.Control:GetSlotPosition();
                local v135;

                if v134 then
                    local v136 = HomePos2.X - v134.X;
                    local v137 = HomePos2.Z - v134.Z;
                    v135 = math.sqrt(v136 * v136 + v137 * v137);
                else
                    v135 = (1 / 0);
                end;

                if v135 <= p128.DeliveryRadius then
                    p128:TransitionTo("Delivering");

                    return;
                end;

                if p128:TimeInState() < p128.LegTimeout * 2 then
                    return;
                end;

                ReturnSeedsToVictim(p128);
                local Control = p128.Control;
                Control:SetSlotAttribute("CarryingSeed", nil);
                Control:SetSlotAttribute("CarryingSeedVictim", nil);
                p128:TransitionTo("Aborting");
            end,

            OnEvent = function(p138, p139, p140) -- Line: 589, Name: OnEvent
                -- upvalues: DescribeStolenSeeds (ref), ReturnSeedsToVictim (ref), NotifyScare (ref)
                if p139 == "Scared" then
                    local v141;

                    if p138.SeedCommitted and p138.StolenSeeds then
                        v141 = DescribeStolenSeeds(p138.StolenSeeds);
                    else
                        v141 = nil;
                    end;

                    ReturnSeedsToVictim(p138);
                    local Control = p138.Control;
                    Control:SetSlotAttribute("CarryingSeed", nil);
                    Control:SetSlotAttribute("CarryingSeedVictim", nil);
                    NotifyScare(p138, p140);

                    if v141 and (p138.VictimPlayer and p138.VictimPlayer.Parent) then
                        p138.Control:NotifyPlayer(p138.VictimPlayer, (`You retrieved {v141}!`));
                    end;

                    p138:TransitionTo("Aborting");
                end;
            end
        },
        Delivering = {
            Enter = function(p142) -- Line: 606, Name: Enter
                -- upvalues: SeedService (ref), PetData (ref), DescribeStolenSeeds (ref)
                if p142.SeedCommitted and (p142.StolenSeeds and (#p142.StolenSeeds > 0 and (p142.Player and p142.Player.Parent))) then
                    local StolenSeeds = p142.StolenSeeds;

                    for _, v in StolenSeeds do
                        SeedService:GiveSeed(p142.Player, v, 1);
                    end;

                    p142.SeedCommitted = false;
                    local v143 = p142.Player and (p142.Player.Name or "Someone") or "Someone";
                    local v144 = p142.VictimPlayer and (p142.VictimPlayer.Name or "someone") or "someone";
                    local v145 = p142.Slot and p142.Slot:GetAttribute("PetSize");
                    local v146 = PetData.GetDisplayName(p142.Species, v145);
                    local v147 = DescribeStolenSeeds(StolenSeeds);
                    p142.Control:Notify((`Your {v146} successfully stole {v147} from {v144}!`));

                    if p142.VictimPlayer and p142.VictimPlayer.Parent then
                        p142.Control:NotifyPlayer(p142.VictimPlayer, (`{v143}'s {v146} successfully stole {v147} from you!`));
                    end;

                    if p142.Control.LogEvent then
                        p142.Control:LogEvent("PlayerPetSeedStolen", {
                            Species = p142.Species,
                            PetSize = v145 or "Normal",
                            SeedCount = #StolenSeeds,
                            Seeds = StolenSeeds,
                            VictimUserId = p142.VictimUserId or 0
                        });
                    end;
                end;

                local Control = p142.Control;
                Control:SetSlotAttribute("CarryingSeed", nil);
                Control:SetSlotAttribute("CarryingSeedVictim", nil);
                p142:Stop("Delivered");
            end
        },
        Aborting = {
            Enter = function(p148) -- Line: 647, Name: Enter
                local Control = p148.Control;
                Control:SetSlotAttribute("CarryingSeed", nil);
                Control:SetSlotAttribute("CarryingSeedVictim", nil);
                local v149 = p148.Player:GetAttribute("PlotId");
                local v150;

                if type(v149) == "number" then
                    local Gardens = workspace:FindFirstChild("Gardens");

                    if Gardens then
                        v150 = Gardens:FindFirstChild("Plot" .. tostring(v149));
                    else
                        v150 = nil;
                    end;
                else
                    v150 = nil;
                end;

                local v151;

                if v150 then
                    v151 = v150:FindFirstChild("SpawnPoint");
                else
                    v151 = v150;
                end;

                p148.HomePos = v151 and v151.Position or (v150 and v150:GetPivot().Position or nil);

                if p148.HomePos then
                    local HomePos = p148.HomePos;
                    local TravelSpeed = p148.TravelSpeed;
                    local v152 = p148.Control:GetSlotPosition();

                    if not v152 then
                        return;
                    end;

                    local v153 = Vector3.new(HomePos.X - v152.X, 0, HomePos.Z - v152.Z);
                    local v154;

                    if v153.Magnitude < 0.001 then
                        v154 = CFrame.new(HomePos);
                    else
                        v154 = CFrame.lookAt(HomePos, HomePos + v153.Unit);
                    end;

                    p148.Control:SetGoal(v154, TravelSpeed);
                end;
            end,

            Update = function(p155, p156, p157) -- Line: 659, Name: Update
                if not p155.HomePos then
                    p155:Stop("Aborted");

                    return;
                end;

                local HomePos = p155.HomePos;
                local v158 = p155.Control:GetSlotPosition();
                local v159;

                if v158 then
                    local v160 = HomePos.X - v158.X;
                    local v161 = HomePos.Z - v158.Z;
                    v159 = math.sqrt(v160 * v160 + v161 * v161);
                else
                    v159 = (1 / 0);
                end;

                if v159 <= 50 then
                    p155:Stop("Aborted");

                    return;
                end;

                if p155:TimeInState() < p155.LegTimeout then
                    return;
                end;

                p155:Stop("Aborted");
            end
        }
    };
end;

function u14.new(p162) -- Line: 681
    -- upvalues: BehaviorBase (copy), u14 (copy), GetSpeedMultiplier (copy), PetSizes (copy), u3 (copy), BuildStates (copy)
    local v163 = BehaviorBase.New(u14, p162);
    v163.TravelSpeed = (v163.Config.TravelSpeed or 24) * GetSpeedMultiplier(v163.Slot);
    v163.LegTimeout = v163.Config.LegTimeout or 20;
    v163.StealDuration = v163.Config.StealDuration or 1;
    v163.DeliveryRadius = v163.Config.DeliveryRadius or 8;
    v163.NoOpCooldown = v163.Config.NoOpCooldown or 3;
    local Slot = v163.Slot;
    local v164;

    if Slot then
        local v165 = Slot:GetAttribute("PetSize");
        local Normalize = PetSizes.Normalize;

        if type(v165) ~= "string" then
            v165 = nil;
        end;

        local v166 = Normalize(v165);
        v164 = v166 and u3[v166] or 1;
    else
        v164 = 1;
    end;

    v163.Capacity = v164;
    v163.VictimPlayer = nil;
    v163.VictimUserId = nil;
    v163.StolenSeeds = nil;
    v163.SeedCommitted = false;
    v163.ReservedUserId = nil;
    v163.HomePos = nil;
    v163.States = BuildStates();

    return v163;
end;

function u14.GetInitialState(p167) -- Line: 718
    return "Targeting";
end;

function u14.CanStart(p168) -- Line: 723
    -- upvalues: ReplicatedStorage (copy), PickRandomTarget (copy)
    local Player = p168.Player;

    if not (Player and Player.Parent) then
        return false;
    end;

    local Night = ReplicatedStorage:FindFirstChild("Night");
    local v169;

    if Night and Night:IsA("BoolValue") then
        v169 = Night.Value == true;
    else
        v169 = false;
    end;

    if v169 then
        return PickRandomTarget(Player) ~= nil;
    end;

    return false;
end;

function u14.GetCooldownSeconds(p170, p171) -- Line: 735
    -- upvalues: u10 (copy)
    if u10[p170.StopReason or ""] then
        return p170.NoOpCooldown;
    end;

    return p171;
end;

function u14.OnStop(p172, p173) -- Line: 743
    -- upvalues: u11 (copy), ReturnSeedsToVictim (copy), u15 (ref), Services (copy)
    if p172.ReservedUserId then
        u11[p172.ReservedUserId] = nil;
        p172.ReservedUserId = nil;
    end;

    ReturnSeedsToVictim(p172);

    if p172.Control then
        local Control = p172.Control;
        Control:SetSlotAttribute("CarryingSeed", nil);
        Control:SetSlotAttribute("CarryingSeedVictim", nil);
    end;

    local Player = p172.Player;
    local PetId = p172.PetId;
    task.defer(function() -- Line: 770
        -- upvalues: Player (copy), u15 (ref), Services (ref), PetId (copy)
        if not (Player and Player.Parent) then
            return;
        end;

        if not u15 then
            local success, result = pcall(require, Services:FindFirstChild("WanderService"));

            if success then
                u15 = result;
            end;
        end;

        local v174 = u15;

        if v174 and v174.OnPetReleased then
            v174:OnPetReleased(Player, PetId);
        end;
    end);
end;

return u14;