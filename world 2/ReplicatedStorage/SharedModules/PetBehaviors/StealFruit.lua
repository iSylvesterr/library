-- Decompiled with Potassium's decompiler.

local BehaviorBase = require(script.Parent.BehaviorBase);
local Players = game:GetService("Players");
local HttpService = game:GetService("HttpService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Services = game:GetService("ServerScriptService"):WaitForChild("Services");
local DataService = require(Services.DataService);
local ShovelService = require(Services.ShovelService);
local ObjectPositionService = require(Services.ObjectPositionService);
local FruitHarvestService = require(Services.FruitHarvestService);
local GardenZoneService = require(Services.GardenZoneService);
local BadgesService = require(Services.BadgesService);
local Fruits = ReplicatedStorage:WaitForChild("PlantGenerationModules"):WaitForChild("Fruits");
local PetData = require(ReplicatedStorage.SharedData.PetData);
local PetSizes = require(ReplicatedStorage.SharedData.PetSizes);
local PetTypes = require(ReplicatedStorage.SharedData.PetTypes);
local RarityVisuals = require(ReplicatedStorage.SharedModules.RarityVisuals);
local SeedData = require(ReplicatedStorage.SharedModules.SeedData);
local FruitValueCalc = require(ReplicatedStorage.SharedModules.FruitValueCalc);
local FruitIdentity = require(ReplicatedStorage.SharedModules.FruitIdentity);
local u1 = {};

for _, v in SeedData do
    if type(v) == "table" and type(v.SeedName) == "string" then
        u1[v.SeedName] = v.Rarity or "Common";
    end;
end;

local function GetFruitRarity(p2) -- Line: 37
    -- upvalues: u1 (copy)
    return u1[p2] or "Common";
end;

local function GetSpeciesRarity(p3) -- Line: 41
    -- upvalues: PetData (copy)
    local v4 = PetData[p3];

    return (type(v4) ~= "table" or type(v4.Rarity) ~= "string") and "Common" or v4.Rarity;
end;

local u5 = {
    Big = 1.5,
    Huge = 2
};
local u6 = {
    NoTarget = true,
    NoFruitPosition = true
};
local u7 = {};

local function FruitReservationKey(p8, p9, p10) -- Line: 93
    return tostring(p8) .. ":" .. tostring(p9) .. ":" .. tostring(p10);
end;

local function IsFruitReserved(p11) -- Line: 97
    -- upvalues: u7 (copy)
    local v12 = u7[p11];

    if not v12 then
        return false;
    end;

    if os.clock() - v12 < 75 then
        return true;
    end;

    u7[p11] = nil;

    return false;
end;

local u13 = setmetatable({}, {
    __index = BehaviorBase
});
u13.__index = u13;
u13.Name = "StealFruit";
local u14 = nil;

local function GetWanderService() -- Line: 115
    -- upvalues: u14 (ref), Services (copy)
    if not u14 then
        local success, result = pcall(require, Services:FindFirstChild("WanderService"));

        if success then
            u14 = result;
        end;
    end;

    return u14;
end;

local u15 = nil;

local function GetGardenSyncService() -- Line: 126
    -- upvalues: u15 (ref), Services (copy)
    if not u15 then
        local success, result = pcall(require, Services:FindFirstChild("GardenSyncService"));

        if success then
            u15 = result;
        end;
    end;

    return u15;
end;

local function RestoreStolenFruit(p16, p17, p18) -- Line: 138
    -- upvalues: Players (copy), DataService (copy), u15 (ref), Services (copy)
    if not (p16 and p16:IsDescendantOf(Players)) then
        return;
    end;

    if not DataService:GetPlant(p16, p17) then
        return;
    end;

    local v19 = DataService:AddFruit(p16, p17, p18.Seed, p18.MaxAge, p18.SpawnLocationIndex, p18.GrowRate, p18.Mutation, p18.SizeMultiplier);

    if not v19 then
        return;
    end;

    DataService:UpdateFruit(p16, p17, v19, {
        Age = p18.MaxAge,
        FinishedGrowingAt = p18.FinishedGrowingAt or os.time(),
        OvertimeGrowth = p18.OvertimeGrowth or 1
    });
    local v20 = DataService:GetFruit(p16, p17, v19);

    if not u15 then
        local success, result = pcall(require, Services:FindFirstChild("GardenSyncService"));

        if success then
            u15 = result;
        end;
    end;

    local v21 = u15;

    if v20 and v21 then
        v21:BroadcastFruitAdded(p16, p17, v19, v20);
    end;
end;

local function GetFruitBaseWeight(p22) -- Line: 163
    -- upvalues: Fruits (copy)
    local v23 = Fruits:FindFirstChild(p22);

    if not v23 then
        return 1;
    end;

    local success, result = pcall(require, v23);

    return success and (result and result.GrowData) and (result.GrowData.BaseWeight or 1) or 1;
end;

local function GetPlotFolder(p24) -- Line: 172
    local v25 = p24:GetAttribute("PlotId");

    if type(v25) ~= "number" then
        return nil;
    end;

    local Gardens = workspace:FindFirstChild("Gardens");

    if Gardens then
        return Gardens:FindFirstChild("Plot" .. tostring(v25));
    end;

    return nil;
end;

local function IsNightTime() -- Line: 181
    -- upvalues: ReplicatedStorage (copy)
    local Night = ReplicatedStorage:FindFirstChild("Night");

    if Night and Night:IsA("BoolValue") then
        return Night.Value == true;
    end;

    return false;
end;

local function GardenIsEmpty(p26) -- Line: 188
    -- upvalues: GardenZoneService (copy)
    local v27 = p26:GetAttribute("PlotId");

    if type(v27) == "number" then
        return #GardenZoneService:GetPlayersInGarden(v27) == 0;
    end;

    return false;
end;

local function GetSpeedMultiplier(p28) -- Line: 197
    -- upvalues: PetSizes (copy), u5 (copy), PetTypes (copy)
    if not p28 then
        return 1;
    end;

    local v29 = 1;
    local v30 = p28:GetAttribute("PetSize");
    local Normalize = PetSizes.Normalize;

    if type(v30) ~= "string" then
        v30 = nil;
    end;

    local v31 = Normalize(v30);

    if v31 and u5[v31] then
        v29 = v29 * u5[v31];
    end;

    if p28:GetAttribute("PetType") == PetTypes.Rainbow then
        v29 = v29 * 1.25;
    end;

    return v29;
end;

local function MakeGoalCFrame(p32, p33) -- Line: 212
    local v34 = Vector3.new(p33.X - p32.X, 0, p33.Z - p32.Z);

    if v34.Magnitude < 0.001 then
        return CFrame.new(p33);
    end;

    return CFrame.lookAt(p33, p33 + v34.Unit);
end;

local function ClearCarryAttributes(p35) -- Line: 221
    p35:SetSlotAttribute("CarryingFruit", nil);
    p35:SetSlotAttribute("CarryingFruitSeed", nil);
    p35:SetSlotAttribute("CarryingFruitSize", nil);
    p35:SetSlotAttribute("CarryingFruitOvertimeGrowth", nil);
    p35:SetSlotAttribute("CarryingFruitMutation", nil);
end;

local function PickRandomTarget(p36) -- Line: 230
    -- upvalues: ReplicatedStorage (copy), Players (copy), GardenZoneService (copy), DataService (copy), u7 (copy), ObjectPositionService (copy), FruitValueCalc (copy), FruitIdentity (copy)
    local Night = ReplicatedStorage:FindFirstChild("Night");
    local v37;

    if Night and Night:IsA("BoolValue") then
        v37 = Night.Value == true;
    else
        v37 = false;
    end;

    if not v37 then
        return nil;
    end;

    local v38 = 0;
    local v39 = {};

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= p36 and v:HasTag("DataLoaded") then
            local v40 = v:GetAttribute("PlotId");
            local v41;

            if type(v40) == "number" then
                v41 = #GardenZoneService:GetPlayersInGarden(v40) == 0;
            else
                v41 = false;
            end;

            if v41 then
                local v42 = DataService:GetAllPlants(v);

                if v42 then
                    for i, v2 in pairs(v42) do
                        if not v2.IsPotted then
                            local Fruits2 = v2.Fruits;

                            if Fruits2 then
                                for i2, v3 in pairs(Fruits2) do
                                    if type(v3) == "table" and (v3.Age and (v3.MaxAge and v3.Age >= v3.MaxAge)) then
                                        local v43 = tostring(v.UserId) .. ":" .. tostring(i) .. ":" .. tostring(i2);
                                        local v44 = u7[v43];
                                        local v45;

                                        if v44 then
                                            if os.clock() - v44 >= 75 then
                                                u7[v43] = nil;
                                                v45 = false;
                                            else
                                                v45 = true;
                                            end;
                                        else
                                            v45 = false;
                                        end;

                                        if not v45 then
                                            local v46 = ObjectPositionService:GetStoredFruitEntry(v, i2, i);

                                            if v46 and typeof(v46.Position) == "Vector3" then
                                                local v47 = FruitValueCalc(FruitIdentity.ResolveFruitName(v2.PlantName), v3.SizeMultiplier or 1, v3.Mutation, p36, v3.DecayAlpha);
                                                local v48 = math.max(v47, 1);
                                                v38 = v38 + v48;
                                                table.insert(v39, {
                                                    VictimPlayer = v,
                                                    PlantId = i,
                                                    PlantData = v2,
                                                    FruitId = i2,
                                                    FruitData = v3,
                                                    Weight = v48
                                                });
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    if #v39 == 0 then
        return nil;
    end;

    local v49 = math.random() * v38;

    for _, v in v39 do
        v49 = v49 - v.Weight;

        if v49 <= 0 then
            return v;
        end;
    end;

    return v39[#v39];
end;

local function ResolveFruitWorldPos(p50, p51, p52) -- Line: 304
    -- upvalues: ObjectPositionService (copy)
    local v53 = ObjectPositionService:GetStoredFruitEntry(p50, p52, p51);

    if v53 and typeof(v53.Position) == "Vector3" then
        return v53.Position;
    end;

    return nil;
end;

local function FruitIsStillValid(p54, p55, p56) -- Line: 311
    -- upvalues: DataService (copy)
    if not (p54 and p54.Parent) then
        return false;
    end;

    local v57 = DataService:GetFruit(p54, p55, p56);

    if not v57 then
        return false;
    end;

    if v57.Age and v57.MaxAge then
        return v57.Age >= v57.MaxAge;
    end;

    return false;
end;

local function FlyTo(p58, p59, p60) -- Line: 321
    local v61 = p58.Control:GetSlotPosition();

    if not v61 then
        return;
    end;

    local v62 = Vector3.new(p59.X - v61.X, 0, p59.Z - v61.Z);
    local v63;

    if v62.Magnitude < 0.001 then
        v63 = CFrame.new(p59);
    else
        v63 = CFrame.lookAt(p59, p59 + v62.Unit);
    end;

    p58.Control:SetGoal(v63, p60);
end;

local function DistanceTo(p64, p65) -- Line: 329
    local v66 = p64.Control:GetSlotPosition();

    if not v66 then
        return (1 / 0);
    end;

    local v67 = p65.X - v66.X;
    local v68 = p65.Z - v66.Z;

    return math.sqrt(v67 * v67 + v68 * v68);
end;

local function NotifyScare(p69, p70) -- Line: 338
    if p70 then
        p70 = p70.Scarer;
    end;

    local v71 = p69.Species or "Pet";
    local Player = p69.Player;

    if p70 and p70.Parent then
        p69.Control:NotifyPlayer(p70, "You shooed away " .. (Player and (Player.Name or "a player") or "a player") .. "\'s " .. v71 .. "!");
    end;

    if Player and (Player.Parent and p70 ~= Player) then
        p69.Control:Notify((p70 and p70.Name or "Someone") .. " shooed away your " .. v71 .. "!");
    end;
end;

local function BuildStates() -- Line: 352
    -- upvalues: PickRandomTarget (copy), FruitIdentity (copy), ObjectPositionService (copy), u7 (copy), DataService (copy), NotifyScare (copy), Fruits (copy), HttpService (copy), ShovelService (copy), RestoreStolenFruit (copy), ClearCarryAttributes (copy), BadgesService (copy), FruitHarvestService (copy), RarityVisuals (copy), PetData (copy), u1 (copy)
    return {
        Targeting = {
            Enter = function(p72) -- Line: 358, Name: Enter
                -- upvalues: PickRandomTarget (ref), FruitIdentity (ref), ObjectPositionService (ref), u7 (ref)
                local v73 = PickRandomTarget(p72.Player);

                if not v73 then
                    p72:Stop("NoTarget");

                    return;
                end;

                p72.VictimPlayer = v73.VictimPlayer;
                p72.VictimUserId = v73.VictimPlayer.UserId;
                p72.PlantId = v73.PlantId;
                p72.FruitId = v73.FruitId;
                p72.FruitName = FruitIdentity.ResolveFruitName(v73.PlantData.PlantName);
                p72.FruitData = v73.FruitData;
                local v74 = ObjectPositionService:GetStoredFruitEntry(v73.VictimPlayer, v73.FruitId, v73.PlantId);
                local v75;

                if v74 and typeof(v74.Position) == "Vector3" then
                    v75 = v74.Position;
                else
                    v75 = nil;
                end;

                p72.FruitWorldPos = v75;

                if not p72.FruitWorldPos then
                    p72:Stop("NoFruitPosition");

                    return;
                end;

                local PlantId = p72.PlantId;
                local FruitId = p72.FruitId;
                p72.ReservedKey = tostring(p72.VictimUserId) .. ":" .. tostring(PlantId) .. ":" .. tostring(FruitId);
                u7[p72.ReservedKey] = os.clock();
                p72:TransitionTo("Outbound");
            end
        },
        Outbound = {
            Enter = function(p76) -- Line: 389, Name: Enter
                local FruitWorldPos = p76.FruitWorldPos;
                local TravelSpeed = p76.TravelSpeed;
                local v77 = p76.Control:GetSlotPosition();

                if not v77 then
                    return;
                end;

                local v78 = Vector3.new(FruitWorldPos.X - v77.X, 0, FruitWorldPos.Z - v77.Z);
                local v79;

                if v78.Magnitude < 0.001 then
                    v79 = CFrame.new(FruitWorldPos);
                else
                    v79 = CFrame.lookAt(FruitWorldPos, FruitWorldPos + v78.Unit);
                end;

                p76.Control:SetGoal(v79, TravelSpeed);
            end,

            Update = function(p80, p81, p82) -- Line: 393, Name: Update
                -- upvalues: DataService (ref)
                local VictimPlayer = p80.VictimPlayer;
                local PlantId = p80.PlantId;
                local FruitId = p80.FruitId;
                local v83;

                if VictimPlayer and VictimPlayer.Parent then
                    local v84 = DataService:GetFruit(VictimPlayer, PlantId, FruitId);

                    if v84 and (v84.Age and v84.MaxAge) then
                        v83 = v84.Age >= v84.MaxAge;
                    else
                        v83 = false;
                    end;
                else
                    v83 = false;
                end;

                if not v83 then
                    p80:TransitionTo("Aborting");

                    return;
                end;

                local FruitWorldPos = p80.FruitWorldPos;
                local TravelSpeed = p80.TravelSpeed;
                local v85 = p80.Control:GetSlotPosition();

                if v85 then
                    local v86 = Vector3.new(FruitWorldPos.X - v85.X, 0, FruitWorldPos.Z - v85.Z);
                    local v87;

                    if v86.Magnitude < 0.001 then
                        v87 = CFrame.new(FruitWorldPos);
                    else
                        v87 = CFrame.lookAt(FruitWorldPos, FruitWorldPos + v86.Unit);
                    end;

                    p80.Control:SetGoal(v87, TravelSpeed);
                end;

                local FruitWorldPos2 = p80.FruitWorldPos;
                local v88 = p80.Control:GetSlotPosition();
                local v89;

                if v88 then
                    local v90 = FruitWorldPos2.X - v88.X;
                    local v91 = FruitWorldPos2.Z - v88.Z;
                    v89 = math.sqrt(v90 * v90 + v91 * v91);
                else
                    v89 = (1 / 0);
                end;

                if v89 <= 3 then
                    p80:TransitionTo("Stealing");

                    return;
                end;

                if p80:TimeInState() < p80.LegTimeout then
                    return;
                end;

                p80:TransitionTo("Aborting");
            end,

            OnEvent = function(p92, p93, p94) -- Line: 416, Name: OnEvent
                -- upvalues: NotifyScare (ref)
                if p93 == "Scared" then
                    NotifyScare(p92, p94);
                    p92:TransitionTo("Aborting");
                end;
            end
        },
        Stealing = {
            Enter = function(p95) -- Line: 426, Name: Enter
                local v96 = p95.Control:GetSlotPosition();

                if v96 then
                    local v97 = p95.Control:GetSlotPosition();

                    if not v97 then
                        return;
                    end;

                    local v98 = Vector3.new(v96.X - v97.X, 0, v96.Z - v97.Z);
                    local v99;

                    if v98.Magnitude < 0.001 then
                        v99 = CFrame.new(v96);
                    else
                        v99 = CFrame.lookAt(v96, v96 + v98.Unit);
                    end;

                    p95.Control:SetGoal(v99, 0);
                end;
            end,

            Update = function(p100, p101, p102) -- Line: 434, Name: Update
                -- upvalues: DataService (ref), Fruits (ref), HttpService (ref), ShovelService (ref), RestoreStolenFruit (ref)
                if not (p100.VictimPlayer and p100.VictimPlayer.Parent) then
                    p100:TransitionTo("Aborting");

                    return;
                end;

                if p100:TimeInState() < p100.StealDuration then
                    return;
                end;

                if p100.StealCommitInFlight then
                    return;
                end;

                p100.StealCommitInFlight = true;
                local v103 = DataService:GetFruit(p100.VictimPlayer, p100.PlantId, p100.FruitId);

                if not v103 then
                    p100:TransitionTo("Aborting");

                    return;
                end;

                if not v103.Age or (not v103.MaxAge or v103.Age < v103.MaxAge) then
                    p100:TransitionTo("Aborting");

                    return;
                end;

                local v104 = Fruits:FindFirstChild(p100.FruitName);
                local v105;

                if v104 then
                    local success, result = pcall(require, v104);
                    v105 = success and (result and result.GrowData) and (result.GrowData.BaseWeight or 1) or 1;
                else
                    v105 = 1;
                end;

                local v106 = v103.SizeMultiplier or 1;
                local v107 = v103.OvertimeGrowth or 1;
                local v108 = v105 * v106 * math.max(v107, 1);
                p100.HarvestedPayload = {
                    Src = "Raccoon",
                    Id = HttpService:GenerateGUID(false),
                    Seed = v103.Seed,
                    Weight = v108,
                    FruitName = p100.FruitName,
                    SizeMultiplier = v106,
                    OvertimeGrowth = v107,
                    Mutation = v103.Mutation,
                    SrcFrom = p100.VictimUserId
                };
                local v109 = {
                    Seed = v103.Seed,
                    MaxAge = v103.MaxAge,
                    SpawnLocationIndex = v103.SpawnLocationIndex,
                    GrowRate = v103.GrowRate,
                    Mutation = v103.Mutation,
                    SizeMultiplier = v106,
                    Age = v103.Age,
                    FinishedGrowingAt = v103.FinishedGrowingAt,
                    OvertimeGrowth = v103.OvertimeGrowth
                };
                ShovelService:RemoveFruit(p100.VictimPlayer, p100.PlantId, p100.FruitId);
                local v110 = DataService:SaveProfileSync(p100.VictimPlayer);
                local v111 = DataService.Profiles[p100.VictimPlayer];

                if not (v110 and (v111 and v111:IsActive())) then
                    RestoreStolenFruit(p100.VictimPlayer, p100.PlantId, v109);
                    p100.HarvestedPayload = nil;
                    p100:TransitionTo("Aborting");

                    return;
                end;

                p100.Control:SetSlotAttribute("CarryingFruitSeed", v103.Seed or 0);
                p100.Control:SetSlotAttribute("CarryingFruitSize", v106);
                p100.Control:SetSlotAttribute("CarryingFruitOvertimeGrowth", v107);
                p100.Control:SetSlotAttribute("CarryingFruitMutation", v103.Mutation or "");
                p100.Control:SetSlotAttribute("CarryingFruit", p100.FruitName);
                p100:TransitionTo("Returning");
            end,

            OnEvent = function(p112, p113, p114) -- Line: 523, Name: OnEvent
                -- upvalues: NotifyScare (ref)
                if p113 == "Scared" then
                    NotifyScare(p112, p114);
                    p112:TransitionTo("Aborting");
                end;
            end
        },
        Returning = {
            Enter = function(p115) -- Line: 533, Name: Enter
                local v116 = p115.Player:GetAttribute("PlotId");
                local v117;

                if type(v116) == "number" then
                    local Gardens = workspace:FindFirstChild("Gardens");

                    if Gardens then
                        v117 = Gardens:FindFirstChild("Plot" .. tostring(v116));
                    else
                        v117 = nil;
                    end;
                else
                    v117 = nil;
                end;

                if not v117 then
                    p115:TransitionTo("Aborting");

                    return;
                end;

                local SpawnPoint = v117:FindFirstChild("SpawnPoint");
                p115.HomePos = SpawnPoint and SpawnPoint.Position or v117:GetPivot().Position;
                local HomePos = p115.HomePos;
                local TravelSpeed = p115.TravelSpeed;
                local v118 = p115.Control:GetSlotPosition();

                if not v118 then
                    return;
                end;

                local v119 = Vector3.new(HomePos.X - v118.X, 0, HomePos.Z - v118.Z);
                local v120;

                if v119.Magnitude < 0.001 then
                    v120 = CFrame.new(HomePos);
                else
                    v120 = CFrame.lookAt(HomePos, HomePos + v119.Unit);
                end;

                p115.Control:SetGoal(v120, TravelSpeed);
            end,

            Update = function(p121, p122, p123) -- Line: 544, Name: Update
                local HomePos = p121.HomePos;
                local TravelSpeed = p121.TravelSpeed;
                local v124 = p121.Control:GetSlotPosition();

                if v124 then
                    local v125 = Vector3.new(HomePos.X - v124.X, 0, HomePos.Z - v124.Z);
                    local v126;

                    if v125.Magnitude < 0.001 then
                        v126 = CFrame.new(HomePos);
                    else
                        v126 = CFrame.lookAt(HomePos, HomePos + v125.Unit);
                    end;

                    p121.Control:SetGoal(v126, TravelSpeed);
                end;

                local HomePos2 = p121.HomePos;
                local v127 = p121.Control:GetSlotPosition();
                local v128;

                if v127 then
                    local v129 = HomePos2.X - v127.X;
                    local v130 = HomePos2.Z - v127.Z;
                    v128 = math.sqrt(v129 * v129 + v130 * v130);
                else
                    v128 = (1 / 0);
                end;

                if v128 <= p121.DeliveryRadius then
                    p121:TransitionTo("Delivering");

                    return;
                end;

                if p121:TimeInState() < p121.LegTimeout * 2 then
                    return;
                end;

                p121:TransitionTo("Aborting");
            end,

            OnEvent = function(p131, p132, p133) -- Line: 558, Name: OnEvent
                -- upvalues: ClearCarryAttributes (ref), NotifyScare (ref)
                if p132 == "Scared" then
                    p131.HarvestedPayload = nil;
                    ClearCarryAttributes(p131.Control);
                    NotifyScare(p131, p133);
                    p131:TransitionTo("Aborting");
                end;
            end
        },
        Delivering = {
            Enter = function(p134) -- Line: 571, Name: Enter
                -- upvalues: DataService (ref), BadgesService (ref), FruitHarvestService (ref), RarityVisuals (ref), PetData (ref), u1 (ref), ClearCarryAttributes (ref)
                if p134.HarvestedPayload and (p134.Player and p134.Player.Parent) then
                    DataService:AddHarvestedFruit(p134.Player, p134.HarvestedPayload);
                    BadgesService:OnFruitHarvested(p134.Player, p134.HarvestedPayload);
                    FruitHarvestService:refreshPlayerFruitTools(p134.Player, DataService:GetAllHarvestedFruits(p134.Player));
                    local v135 = p134.VictimPlayer and (p134.VictimPlayer.Name or "someone") or "someone";
                    local v136 = p134.Slot and p134.Slot:GetAttribute("PetSize");
                    local RichText = RarityVisuals.RichText;
                    local v137 = PetData.GetDisplayName(p134.Species, v136);
                    local v138 = PetData[p134.Species];
                    local v139 = RichText(v137, (type(v138) ~= "table" or type(v138.Rarity) ~= "string") and "Common" or v138.Rarity);
                    local v140 = RarityVisuals.RichText(tostring(p134.FruitName), u1[p134.FruitName] or "Common");
                    p134.Control:Notify((`Your {v139} stole a {v140} from {v135}!`));
                end;

                ClearCarryAttributes(p134.Control);
                p134:Stop("Delivered");
            end
        },
        Aborting = {
            Enter = function(p141) -- Line: 591, Name: Enter
                -- upvalues: ClearCarryAttributes (ref)
                p141.HarvestedPayload = nil;
                ClearCarryAttributes(p141.Control);
                local v142 = p141.Player:GetAttribute("PlotId");
                local v143;

                if type(v142) == "number" then
                    local Gardens = workspace:FindFirstChild("Gardens");

                    if Gardens then
                        v143 = Gardens:FindFirstChild("Plot" .. tostring(v142));
                    else
                        v143 = nil;
                    end;
                else
                    v143 = nil;
                end;

                local v144;

                if v143 then
                    v144 = v143:FindFirstChild("SpawnPoint");
                else
                    v144 = v143;
                end;

                p141.HomePos = v144 and v144.Position or (v143 and v143:GetPivot().Position or nil);

                if p141.HomePos then
                    local HomePos = p141.HomePos;
                    local TravelSpeed = p141.TravelSpeed;
                    local v145 = p141.Control:GetSlotPosition();

                    if not v145 then
                        return;
                    end;

                    local v146 = Vector3.new(HomePos.X - v145.X, 0, HomePos.Z - v145.Z);
                    local v147;

                    if v146.Magnitude < 0.001 then
                        v147 = CFrame.new(HomePos);
                    else
                        v147 = CFrame.lookAt(HomePos, HomePos + v146.Unit);
                    end;

                    p141.Control:SetGoal(v147, TravelSpeed);
                end;
            end,

            Update = function(p148, p149, p150) -- Line: 604, Name: Update
                if not p148.HomePos then
                    p148:Stop("Aborted");

                    return;
                end;

                local HomePos = p148.HomePos;
                local v151 = p148.Control:GetSlotPosition();
                local v152;

                if v151 then
                    local v153 = HomePos.X - v151.X;
                    local v154 = HomePos.Z - v151.Z;
                    v152 = math.sqrt(v153 * v153 + v154 * v154);
                else
                    v152 = (1 / 0);
                end;

                if v152 <= 50 then
                    p148:Stop("Aborted");

                    return;
                end;

                if p148:TimeInState() < p148.LegTimeout then
                    return;
                end;

                p148:Stop("Aborted");
            end
        }
    };
end;

function u13.new(p155) -- Line: 626
    -- upvalues: BehaviorBase (copy), u13 (copy), GetSpeedMultiplier (copy), BuildStates (copy)
    local v156 = BehaviorBase.New(u13, p155);
    v156.TravelSpeed = (v156.Config.TravelSpeed or 24) * GetSpeedMultiplier(v156.Slot);
    v156.LegTimeout = v156.Config.LegTimeout or 20;
    v156.StealDuration = v156.Config.StealDuration or 1;
    v156.DeliveryRadius = v156.Config.DeliveryRadius or 8;
    v156.NoOpCooldown = v156.Config.NoOpCooldown or 3;
    v156.VictimPlayer = nil;
    v156.VictimUserId = nil;
    v156.PlantId = nil;
    v156.FruitId = nil;
    v156.FruitName = nil;
    v156.FruitData = nil;
    v156.FruitWorldPos = nil;
    v156.HarvestedPayload = nil;
    v156.ReservedKey = nil;
    v156.HomePos = nil;
    v156.States = BuildStates();

    return v156;
end;

function u13.GetInitialState(p157) -- Line: 661
    return "Targeting";
end;

function u13.CanStart(p158) -- Line: 666
    -- upvalues: ReplicatedStorage (copy), PickRandomTarget (copy)
    local Player = p158.Player;

    if not (Player and Player.Parent) then
        return false;
    end;

    local Night = ReplicatedStorage:FindFirstChild("Night");
    local v159;

    if Night and Night:IsA("BoolValue") then
        v159 = Night.Value == true;
    else
        v159 = false;
    end;

    if v159 then
        return PickRandomTarget(Player) ~= nil;
    end;

    return false;
end;

function u13.GetCooldownSeconds(p160, p161) -- Line: 679
    -- upvalues: u6 (copy)
    if u6[p160.StopReason or ""] then
        return p160.NoOpCooldown;
    end;

    return p161;
end;

function u13.OnStop(p162, p163) -- Line: 687
    -- upvalues: u7 (copy), ClearCarryAttributes (copy), u14 (ref), Services (copy)
    if p162.ReservedKey then
        u7[p162.ReservedKey] = nil;
        p162.ReservedKey = nil;
    end;

    if p162.Control then
        ClearCarryAttributes(p162.Control);
    end;

    local Player = p162.Player;
    local PetId = p162.PetId;
    task.defer(function() -- Line: 705
        -- upvalues: Player (copy), u14 (ref), Services (ref), PetId (copy)
        if not (Player and Player.Parent) then
            return;
        end;

        if not u14 then
            local success, result = pcall(require, Services:FindFirstChild("WanderService"));

            if success then
                u14 = result;
            end;
        end;

        local v164 = u14;

        if v164 and v164.OnPetReleased then
            v164:OnPetReleased(Player, PetId);
        end;
    end);
end;

return u13;