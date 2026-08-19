-- Decompiled with Potassium's decompiler.

local BehaviorBase = require(script.Parent.BehaviorBase);
local ServerScriptService = game:GetService("ServerScriptService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SoundService = game:GetService("SoundService");
local Debris = game:GetService("Debris");
local Services = ServerScriptService:WaitForChild("Services");
local DataService = require(Services.DataService);
local ObjectPositionService = require(Services.ObjectPositionService);
local PetData = require(ReplicatedStorage.SharedData.PetData);
local PetSizes = require(ReplicatedStorage.SharedData.PetSizes);
local PetTypes = require(ReplicatedStorage.SharedData.PetTypes);
local PetFlags = require(ReplicatedStorage.SharedModules.Flags.PetFlags);
local RarityVisuals = require(ReplicatedStorage.SharedModules.RarityVisuals);
local SeedData = require(ReplicatedStorage.SharedModules.SeedData);
local PlantBehaviorRules = require(ReplicatedStorage.SharedModules.PlantBehaviorRules);
local FruitIdentity = require(ReplicatedStorage.SharedModules.FruitIdentity);
local u1 = {};

for _, v in SeedData do
    if type(v) == "table" and type(v.SeedName) == "string" then
        u1[v.SeedName] = v.Rarity or "Common";
    end;
end;

local function GetFruitRarity(p2) -- Line: 38
    -- upvalues: u1 (copy)
    return u1[p2] or "Common";
end;

local function GetSpeciesRarity(p3) -- Line: 42
    -- upvalues: PetData (copy)
    local v4 = PetData[p3];

    return (type(v4) ~= "table" or type(v4.Rarity) ~= "string") and "Common" or v4.Rarity;
end;

local u5 = nil;

local function GetMonkeyService() -- Line: 52
    -- upvalues: u5 (ref), Services (copy)
    if not u5 then
        u5 = require(Services:WaitForChild("MonkeyService"));
    end;

    return u5;
end;

local u6 = {
    Big = 1.3,
    Huge = 1.6
};
local u7 = setmetatable({}, {
    __index = BehaviorBase
});
u7.__index = u7;
u7.Name = "PickFruit";

local function OwnerIsHome(p8) -- Line: 83
    return p8:GetAttribute("IsInOwnGarden") == true;
end;

local function PickRandomOwnFruit(p9) -- Line: 88
    -- upvalues: DataService (copy), u5 (ref), Services (copy), PlantBehaviorRules (copy)
    local v10 = DataService:GetAllPlants(p9);

    if not v10 then
        return nil;
    end;

    if not u5 then
        u5 = require(Services:WaitForChild("MonkeyService"));
    end;

    local v11 = u5;
    local v12 = {};

    for i, v in pairs(v10) do
        if not (v.IsPotted or PlantBehaviorRules.GrowsForever(v.PlantName)) then
            local Fruits = v.Fruits;

            if Fruits then
                for i2, v2 in pairs(Fruits) do
                    if type(v2) == "table" and (v2.Age and (v2.MaxAge and (v2.Age >= v2.MaxAge and not v11:IsFruitReserved(p9, i, i2)))) then
                        table.insert(v12, {
                            PlantId = i,
                            FruitId = i2,
                            PlantData = v,
                            FruitData = v2
                        });
                    end;
                end;
            end;
        end;
    end;

    if #v12 == 0 then
        return nil;
    end;

    return v12[math.random(1, #v12)];
end;

local function FruitIsStillValid(p13, p14, p15) -- Line: 123
    -- upvalues: DataService (copy)
    if not (p13 and p13.Parent) then
        return false;
    end;

    local v16 = DataService:GetFruit(p13, p14, p15);

    if not v16 then
        return false;
    end;

    if v16.Age and v16.MaxAge then
        return v16.Age >= v16.MaxAge;
    end;

    return false;
end;

local function MakeGoalCFrame(p17, p18) -- Line: 133
    local v19 = Vector3.new(p18.X - p17.X, 0, p18.Z - p17.Z);

    if v19.Magnitude < 0.001 then
        return CFrame.new(p18);
    end;

    return CFrame.lookAt(p18, p18 + v19.Unit);
end;

local function WalkTo(p20, p21, p22) -- Line: 141
    local v23 = p20.Control:GetSlotPosition();

    if not v23 then
        return;
    end;

    local Control = p20.Control;
    local v24 = Vector3.new(p21.X - v23.X, 0, p21.Z - v23.Z);
    local v25;

    if v24.Magnitude < 0.001 then
        v25 = CFrame.new(p21);
    else
        v25 = CFrame.lookAt(p21, p21 + v24.Unit);
    end;

    Control:SetGoal(v25, p22);
end;

local function DistanceTo(p26, p27) -- Line: 147
    local v28 = p26.Control:GetSlotPosition();

    if not v28 then
        return (1 / 0);
    end;

    local v29 = p27.X - v28.X;
    local v30 = p27.Z - v28.Z;

    return math.sqrt(v29 * v29 + v30 * v30);
end;

local function OwnerPosition(p31) -- Line: 156
    local Character = p31.Character;

    if not Character then
        return nil;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
        return HumanoidRootPart.Position;
    end;

    return nil;
end;

local function GetSpeedMultiplier(p32) -- Line: 166
    -- upvalues: PetSizes (copy), u6 (copy), PetTypes (copy)
    if not p32 then
        return 1;
    end;

    local v33 = 1;
    local v34 = PetSizes.Normalize(p32:GetAttribute("PetSize"));

    if v34 and u6[v34] then
        v33 = v33 * u6[v34];
    end;

    if p32:GetAttribute("PetType") == PetTypes.Rainbow then
        v33 = v33 * 1.15;
    end;

    return v33;
end;

local function ClearCarryAttributes(p35) -- Line: 179
    p35:SetSlotAttribute("CarryingFruit", nil);
    p35:SetSlotAttribute("CarryingFruitSeed", nil);
    p35:SetSlotAttribute("CarryingFruitSize", nil);
    p35:SetSlotAttribute("CarryingFruitOvertimeGrowth", nil);
    p35:SetSlotAttribute("CarryingFruitMutation", nil);
end;

local function PlaySquirrelSound(p36, p37, p38) -- Line: 190
    -- upvalues: SoundService (copy), Debris (copy)
    if not (p36 and p36.Parent) then
        return;
    end;

    local SFX = SoundService:FindFirstChild("SFX");

    if SFX then
        SFX = SFX:FindFirstChild("Squirrel");
    end;

    if SFX then
        SFX = SFX:FindFirstChild(p37);
    end;

    if not (SFX and SFX:IsA("Sound")) then
        return;
    end;

    local v39 = SFX:Clone();
    v39.Volume = p38;
    v39.Parent = p36;
    v39:Play();
    Debris:AddItem(v39, (v39.TimeLength <= 0 and 5 or v39.TimeLength) + 1);
end;

local function BuildStates() -- Line: 203
    -- upvalues: PickRandomOwnFruit (copy), u5 (ref), Services (copy), FruitIdentity (copy), ObjectPositionService (copy), DataService (copy), ClearCarryAttributes (copy), PlaySquirrelSound (copy), RarityVisuals (copy), PetData (copy), u1 (copy)
    return {
        Targeting = {
            Enter = function(p40) -- Line: 208, Name: Enter
                -- upvalues: PickRandomOwnFruit (ref), u5 (ref), Services (ref), FruitIdentity (ref), ObjectPositionService (ref)
                local v41 = PickRandomOwnFruit(p40.Player);

                if not v41 then
                    p40:Stop("NoFruit");

                    return;
                end;

                if not u5 then
                    u5 = require(Services:WaitForChild("MonkeyService"));
                end;

                if not u5:TryReserve(p40.Player, v41.PlantId, v41.FruitId) then
                    p40:Stop("Reserved");

                    return;
                end;

                p40.PlantId = v41.PlantId;
                p40.FruitId = v41.FruitId;
                p40.FruitName = FruitIdentity.ResolveFruitName(v41.PlantData.PlantName);
                p40.Reserved = true;
                local v42 = ObjectPositionService:GetStoredFruitEntry(p40.Player, v41.FruitId, v41.PlantId);

                if v42 then
                    v42 = v42.Position;
                end;

                if typeof(v42) ~= "Vector3" then
                    p40:Stop("NoFruitPosition");

                    return;
                end;

                p40.FruitWorldPos = v42;
                p40:TransitionTo("Outbound");
            end
        },
        Outbound = {
            Enter = function(p43) -- Line: 239, Name: Enter
                local FruitWorldPos = p43.FruitWorldPos;
                local TravelSpeed = p43.TravelSpeed;
                local v44 = p43.Control:GetSlotPosition();

                if not v44 then
                    return;
                end;

                local Control = p43.Control;
                local v45 = Vector3.new(FruitWorldPos.X - v44.X, 0, FruitWorldPos.Z - v44.Z);
                local v46;

                if v45.Magnitude < 0.001 then
                    v46 = CFrame.new(FruitWorldPos);
                else
                    v46 = CFrame.lookAt(FruitWorldPos, FruitWorldPos + v45.Unit);
                end;

                Control:SetGoal(v46, TravelSpeed);
            end,

            Update = function(p47, p48, p49) -- Line: 243, Name: Update
                -- upvalues: DataService (ref)
                local Player = p47.Player;
                local PlantId = p47.PlantId;
                local FruitId = p47.FruitId;
                local v50;

                if Player and Player.Parent then
                    local v51 = DataService:GetFruit(Player, PlantId, FruitId);

                    if v51 and (v51.Age and v51.MaxAge) then
                        v50 = v51.Age >= v51.MaxAge;
                    else
                        v50 = false;
                    end;
                else
                    v50 = false;
                end;

                if not v50 then
                    p47:TransitionTo("Aborting");

                    return;
                end;

                local FruitWorldPos = p47.FruitWorldPos;
                local TravelSpeed = p47.TravelSpeed;
                local v52 = p47.Control:GetSlotPosition();

                if v52 then
                    local Control = p47.Control;
                    local v53 = Vector3.new(FruitWorldPos.X - v52.X, 0, FruitWorldPos.Z - v52.Z);
                    local v54;

                    if v53.Magnitude < 0.001 then
                        v54 = CFrame.new(FruitWorldPos);
                    else
                        v54 = CFrame.lookAt(FruitWorldPos, FruitWorldPos + v53.Unit);
                    end;

                    Control:SetGoal(v54, TravelSpeed);
                end;

                local FruitWorldPos2 = p47.FruitWorldPos;
                local v55 = p47.Control:GetSlotPosition();
                local v56;

                if v55 then
                    local v57 = FruitWorldPos2.X - v55.X;
                    local v58 = FruitWorldPos2.Z - v55.Z;
                    v56 = math.sqrt(v57 * v57 + v58 * v58);
                else
                    v56 = (1 / 0);
                end;

                if v56 <= 3 then
                    p47:TransitionTo("Picking");

                    return;
                end;

                if p47:TimeInState() < p47.LegTimeout then
                    return;
                end;

                p47:TransitionTo("Aborting");
            end
        },
        Picking = {
            Enter = function(p59) -- Line: 265, Name: Enter
                local v60 = p59.Control:GetSlotPosition();

                if v60 then
                    local v61 = p59.Control:GetSlotPosition();

                    if not v61 then
                        return;
                    end;

                    local Control = p59.Control;
                    local v62 = Vector3.new(v60.X - v61.X, 0, v60.Z - v61.Z);
                    local v63;

                    if v62.Magnitude < 0.001 then
                        v63 = CFrame.new(v60);
                    else
                        v63 = CFrame.lookAt(v60, v60 + v62.Unit);
                    end;

                    Control:SetGoal(v63, 0);
                end;
            end,

            Update = function(p64, p65, p66) -- Line: 272, Name: Update
                -- upvalues: DataService (ref), u5 (ref), Services (ref)
                if p64:TimeInState() < p64.PickDuration then
                    return;
                end;

                if p64.PickedUp then
                    return;
                end;

                local Player = p64.Player;
                local PlantId = p64.PlantId;
                local FruitId = p64.FruitId;
                local v67;

                if Player and Player.Parent then
                    local v68 = DataService:GetFruit(Player, PlantId, FruitId);

                    if v68 and (v68.Age and v68.MaxAge) then
                        v67 = v68.Age >= v68.MaxAge;
                    else
                        v67 = false;
                    end;
                else
                    v67 = false;
                end;

                if not v67 then
                    p64:TransitionTo("Aborting");

                    return;
                end;

                local v69 = DataService:GetFruit(p64.Player, p64.PlantId, p64.FruitId);

                if not v69 then
                    p64:TransitionTo("Aborting");

                    return;
                end;

                p64.Control:SetSlotAttribute("CarryingFruitSeed", v69.Seed or 0);
                p64.Control:SetSlotAttribute("CarryingFruitSize", v69.SizeMultiplier or 1);
                p64.Control:SetSlotAttribute("CarryingFruitOvertimeGrowth", (math.max(v69.OvertimeGrowth or 1, 1)));
                p64.Control:SetSlotAttribute("CarryingFruitMutation", v69.Mutation or "");
                p64.Control:SetSlotAttribute("CarryingFruit", p64.FruitName);

                if not u5 then
                    u5 = require(Services:WaitForChild("MonkeyService"));
                end;

                u5:MarkPickedUp(p64.Player, p64.PlantId, p64.FruitId);
                p64.PickedUp = true;
                p64:TransitionTo("Returning");
            end
        },
        Returning = {
            Update = function(p70, p71, p72) -- Line: 305, Name: Update
                local Character = p70.Player.Character;
                local v73;

                if Character then
                    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

                    if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
                        v73 = HumanoidRootPart.Position;
                    else
                        v73 = nil;
                    end;
                else
                    v73 = nil;
                end;

                if not v73 then
                    if p70:TimeInState() >= p70.LegTimeout * 2 then
                        p70:TransitionTo("Aborting");
                    end;

                    return;
                end;

                local TravelSpeed = p70.TravelSpeed;
                local v74 = p70.Control:GetSlotPosition();

                if v74 then
                    local Control = p70.Control;
                    local v75 = Vector3.new(v73.X - v74.X, 0, v73.Z - v74.Z);
                    local v76;

                    if v75.Magnitude < 0.001 then
                        v76 = CFrame.new(v73);
                    else
                        v76 = CFrame.lookAt(v73, v73 + v75.Unit);
                    end;

                    Control:SetGoal(v76, TravelSpeed);
                end;

                local v77 = p70.Control:GetSlotPosition();
                local v78;

                if v77 then
                    local v79 = v73.X - v77.X;
                    local v80 = v73.Z - v77.Z;
                    v78 = math.sqrt(v79 * v79 + v80 * v80);
                else
                    v78 = (1 / 0);
                end;

                if v78 <= p70.DeliveryRadius then
                    p70:TransitionTo("Delivering");

                    return;
                end;

                if p70:TimeInState() < p70.LegTimeout * 2 then
                    return;
                end;

                p70:TransitionTo("Aborting");
            end
        },
        Delivering = {
            Enter = function(p81) -- Line: 330, Name: Enter
                -- upvalues: u5 (ref), Services (ref), ClearCarryAttributes (ref), PlaySquirrelSound (ref), RarityVisuals (ref), PetData (ref), u1 (ref)
                if not u5 then
                    u5 = require(Services:WaitForChild("MonkeyService"));
                end;

                local v82, v83 = u5:Commit(p81.Player, p81.PlantId, p81.FruitId);
                p81.Reserved = false;
                p81.PickedUp = false;
                ClearCarryAttributes(p81.Control);

                if v82 then
                    if p81.Species == "Squirrel" then
                        PlaySquirrelSound(p81.Slot, "SquirrelHarvest", 1);
                    end;

                    local RichText = RarityVisuals.RichText;
                    local v84 = PetData.GetSpeciesDisplayName(p81.Species);
                    local v85 = PetData[p81.Species];
                    local v86 = RichText(v84, (type(v85) ~= "table" or type(v85.Rarity) ~= "string") and "Common" or v85.Rarity);
                    local v87 = RarityVisuals.RichText(tostring(p81.FruitName), u1[p81.FruitName] or "Common");
                    p81.Control:Notify((`Your {v86} brought you a {v87}!`));
                elseif v83 == "Full" then
                    p81.Control:Notify((`Your {PetData.GetSpeciesDisplayName(p81.Species)} couldn't deliver -- your inventory is full!`));
                end;

                p81:Stop("Delivered");
            end
        },
        Aborting = {
            Enter = function(p88) -- Line: 360, Name: Enter
                local Character = p88.Player.Character;
                local v89;

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

                if v89 then
                    local TravelSpeed = p88.TravelSpeed;
                    local v90 = p88.Control:GetSlotPosition();

                    if not v90 then
                        return;
                    end;

                    local Control = p88.Control;
                    local v91 = Vector3.new(v89.X - v90.X, 0, v89.Z - v90.Z);
                    local v92;

                    if v91.Magnitude < 0.001 then
                        v92 = CFrame.new(v89);
                    else
                        v92 = CFrame.lookAt(v89, v89 + v91.Unit);
                    end;

                    Control:SetGoal(v92, TravelSpeed);
                end;
            end,

            Update = function(p93, p94, p95) -- Line: 367, Name: Update
                if p93:TimeInState() >= p93.LegTimeout then
                    p93:Stop("Aborted");
                end;
            end
        }
    };
end;

function u7.new(p96) -- Line: 377
    -- upvalues: BehaviorBase (copy), u7 (copy), PetSizes (copy), u6 (copy), PetTypes (copy), BuildStates (copy)
    local v97 = BehaviorBase.New(u7, p96);
    local v98 = v97.Config.TravelSpeed or 20;
    local Slot = v97.Slot;
    local v99;

    if Slot then
        v99 = 1;
        local v100 = PetSizes.Normalize(Slot:GetAttribute("PetSize"));

        if v100 and u6[v100] then
            v99 = v99 * u6[v100];
        end;

        if Slot:GetAttribute("PetType") == PetTypes.Rainbow then
            v99 = v99 * 1.15;
        end;
    else
        v99 = 1;
    end;

    v97.TravelSpeed = v98 * v99;
    v97.LegTimeout = v97.Config.LegTimeout or 20;
    v97.PickDuration = v97.Config.PickDuration or 1;
    v97.DeliveryRadius = v97.Config.DeliveryRadius or 8;
    v97.PlantId = nil;
    v97.FruitId = nil;
    v97.FruitName = nil;
    v97.FruitWorldPos = nil;
    v97.Reserved = false;
    v97.PickedUp = false;
    v97.States = BuildStates();

    return v97;
end;

function u7.GetInitialState(p101) -- Line: 396
    return "Targeting";
end;

function u7.GetChanceMultiplier(p102, p103) -- Line: 406
    -- upvalues: u5 (ref), Services (copy), PetSizes (copy), PetTypes (copy), PetFlags (copy)
    if not u5 then
        u5 = require(Services:WaitForChild("MonkeyService"));
    end;

    local v104 = u5:GetChanceMultiplier();

    if p103 then
        local v105 = p103:GetAttribute("PetSize");
        local v106 = p103:GetAttribute("PetType");
        local GetBoostMultiplier = PetSizes.GetBoostMultiplier;

        if type(v105) ~= "string" then
            v105 = nil;
        end;

        local v107 = v104 * GetBoostMultiplier(v105);
        local GetBoostMultiplier2 = PetTypes.GetBoostMultiplier;

        if type(v106) ~= "string" then
            v106 = nil;
        end;

        v104 = v107 * GetBoostMultiplier2(v106);
    end;

    if p102 == "Squirrel" then
        v104 = v104 * PetFlags.SquirrelHarvestSpeedMultiplier:Get();
    end;

    if not u5 then
        u5 = require(Services:WaitForChild("MonkeyService"));
    end;

    return v104 * u5:GetSpeciesChanceMultiplier(p102);
end;

function u7.CanStart(p108) -- Line: 424
    -- upvalues: PickRandomOwnFruit (copy)
    local Player = p108.Player;

    if not (Player and Player.Parent) then
        return false;
    end;

    if Player:GetAttribute("IsInOwnGarden") == true then
        return PickRandomOwnFruit(Player) ~= nil;
    end;

    return false;
end;

function u7.OnStop(p109, p110) -- Line: 434
    -- upvalues: ClearCarryAttributes (copy), u5 (ref), Services (copy)
    if p109.Control then
        ClearCarryAttributes(p109.Control);
    end;

    if p109.Reserved and (p109.PlantId and p109.FruitId) then
        if not u5 then
            u5 = require(Services:WaitForChild("MonkeyService"));
        end;

        u5:Release(p109.Player, p109.PlantId, p109.FruitId);
        p109.Reserved = false;
    end;
end;

return u7;