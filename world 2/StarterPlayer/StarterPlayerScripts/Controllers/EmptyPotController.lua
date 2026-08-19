-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 6
};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CollectionService = game:GetService("CollectionService");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local GardenSyncController = require(script.Parent.GardenSyncController);
local PlantVisualizerController = require(script.Parent.PlantVisualizerController);
local SeedData = require(ReplicatedStorage.SharedModules.SeedData);
local NotificationController = require(script.Parent.NotificationController);
local MessagePrompt = require(ReplicatedStorage.ClientModules.MessagePrompt);
local ProximityPromptService = game:GetService("ProximityPromptService");
local u2 = { "Pot it", "Cancel" };
local u3 = { "Break it", "Cancel" };
local LocalPlayer = Players.LocalPlayer;
local u4 = {};
local u5 = nil;
local u6 = nil;
local u7 = false;
local u8 = false;
local Gardens = workspace:WaitForChild("Gardens");

local function GetLocalPlantsFolder() -- Line: 45
    -- upvalues: PlantVisualizerController (copy), LocalPlayer (copy)
    return PlantVisualizerController:GetPlantsFolder(LocalPlayer.UserId);
end;

local function ClearAllPrompts() -- Line: 50
    -- upvalues: u4 (copy)
    for i, v in u4 do
        if v and v.Parent then
            v:Destroy();
        end;

        u4[i] = nil;
    end;
end;

local function GetOrCreateHarvestPart(p9) -- Line: 60
    local HarvestPart = p9:FindFirstChild("HarvestPart");

    if HarvestPart and HarvestPart:IsA("BasePart") then
        return HarvestPart;
    end;

    local v10 = p9.PrimaryPart or p9:FindFirstChildWhichIsA("BasePart");

    if not v10 then
        return nil;
    end;

    local Part = Instance.new("Part");
    Part.Name = "HarvestPart";
    Part.Size = Vector3.new(1, 1, 1);
    Part.Transparency = 1;
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanTouch = false;
    Part.CanQuery = false;
    Part.CFrame = v10.CFrame;
    Part.Parent = p9;

    return Part;
end;

local function AddPromptToPlant(u11, u12) -- Line: 84
    -- upvalues: u4 (copy), GetOrCreateHarvestPart (copy), CollectionService (copy), AddPromptToPlant (copy), GardenSyncController (copy), LocalPlayer (copy), SeedData (copy), NotificationController (copy), u7 (ref), MessagePrompt (copy), u2 (copy), Networking (copy)
    if u4[u12] then
        return;
    end;

    local v13 = GetOrCreateHarvestPart(u11);

    if not v13 then
        return;
    end;

    if not u11:HasTag("InitializationComplete") then
        local u14 = nil;
        u14 = CollectionService:GetInstanceAddedSignal("InitializationComplete"):Connect(function(p15) -- Line: 95
            -- upvalues: u11 (copy), u14 (ref), AddPromptToPlant (ref), u12 (copy)
            if p15 ~= u11 then
                return;
            end;

            u14:Disconnect();
            AddPromptToPlant(u11, u12);
        end);

        return;
    end;

    local v16 = u12:match("^%d+_(.+)$") or u12;
    local u17 = GardenSyncController:GetPlant(LocalPlayer.UserId, v16);

    if not u17 then
        return;
    end;

    local v18 = nil;

    for _, v in SeedData do
        if v.SeedName == u17.PlantName then
            v18 = v;
            break;
        end;
    end;

    if not v18 or v18.IsSingleHarvest then
        return;
    end;

    if u17.IsPotted then
        return;
    end;

    local _, v19 = u11:GetBoundingBox();
    local v20 = math.max(v19.X, v19.Z) / 2 + 6;
    local v21 = math.clamp(v20, 8, 30);
    local ProximityPrompt = Instance.new("ProximityPrompt");
    ProximityPrompt.Name = "PotPrompt";
    ProximityPrompt.ActionText = "Pot Plant";
    ProximityPrompt.ObjectText = u17.PlantName or "Plant";
    ProximityPrompt.HoldDuration = 1;
    ProximityPrompt.Enabled = true;
    ProximityPrompt.MaxActivationDistance = v21;
    ProximityPrompt.RequiresLineOfSight = false;
    ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom;
    ProximityPrompt.Parent = v13;
    ProximityPrompt.Triggered:Connect(function(p22) -- Line: 139
        -- upvalues: LocalPlayer (ref), u11 (copy), u17 (copy), NotificationController (ref), u12 (copy), u7 (ref), MessagePrompt (ref), u2 (ref), Networking (ref)
        if p22 ~= LocalPlayer then
            return;
        end;

        if (u11:GetAttribute("Age") or 0) < (u11:GetAttribute("MaxAge") or (u17.MaxAge or 0)) then
            NotificationController:CreateNotification("This crop hasn\'t fully grown yet!");

            return;
        end;

        local u23 = u12:match("^%d+_(.+)$") or u12;

        if u7 then
            return;
        end;

        u7 = true;
        task.spawn(function() -- Line: 157
            -- upvalues: MessagePrompt (ref), u2 (ref), u7 (ref), Networking (ref), u23 (copy)
            local v24 = MessagePrompt.Prompt({
                message = "Potting will <font color=\"#FF6B5A\"><b>permanently remove</b></font> all fruit on this plant. Harvest it first!",
                titleOverride = "Pot This Plant?",
                yield = true,
                hideClose = true,
                options = u2
            });
            u7 = false;

            if not v24 then
                return;
            end;

            Networking.Garden.PotPlant:Fire(u23);
        end);
    end);
    u4[u12] = ProximityPrompt;
end;

local function AddPromptsToAllPlants() -- Line: 176
    -- upvalues: PlantVisualizerController (copy), LocalPlayer (copy), AddPromptToPlant (copy)
    local v25 = PlantVisualizerController:GetPlantsFolder(LocalPlayer.UserId);

    if not v25 then
        return;
    end;

    for _, child in v25:GetChildren() do
        if child:IsA("Model") then
            AddPromptToPlant(child, child.Name);
        end;
    end;
end;

local function OnToolEquipped(p26) -- Line: 190
    -- upvalues: u5 (ref), AddPromptsToAllPlants (copy), u6 (ref), PlantVisualizerController (copy), LocalPlayer (copy), AddPromptToPlant (copy)
    if not p26:GetAttribute("EmptyPot") then
        return;
    end;

    u5 = p26;
    AddPromptsToAllPlants();

    if u6 then
        u6:Disconnect();
        u6 = nil;
    end;

    local v27 = PlantVisualizerController:GetPlantsFolder(LocalPlayer.UserId);

    if v27 then
        u6 = v27.ChildAdded:Connect(function(p28) -- Line: 208
            -- upvalues: u5 (ref), AddPromptToPlant (ref)
            if u5 and p28:IsA("Model") then
                AddPromptToPlant(p28, p28.Name);
            end;
        end);
    end;
end;

local function OnToolUnequipped(p29) -- Line: 217
    -- upvalues: u5 (ref), u6 (ref), u4 (copy)
    if not p29:GetAttribute("EmptyPot") then
        return;
    end;

    u5 = nil;

    if u6 then
        u6:Disconnect();
        u6 = nil;
    end;

    for i, v in u4 do
        if v and v.Parent then
            v:Destroy();
        end;

        u4[i] = nil;
    end;
end;

local function IsPlantOnGardenBed(p30) -- Line: 231
    -- upvalues: GardenSyncController (copy), LocalPlayer (copy), Gardens (copy), CollectionService (copy)
    local v31 = p30:match("^%d+_(.+)$") or p30;
    local v32 = GardenSyncController:GetPlant(LocalPlayer.UserId, v31);

    if not (v32 and v32.Positions) then
        return false;
    end;

    local v33 = LocalPlayer:GetAttribute("PlotId");

    if v33 then
        v33 = Gardens:FindFirstChild("Plot" .. tostring(v33));
    end;

    if not v33 then
        return false;
    end;

    local SpawnPoint = v33:FindFirstChild("SpawnPoint");

    if not SpawnPoint then
        return false;
    end;

    local v34 = Vector3.new(v32.Positions.PosX, v32.Positions.PosY, v32.Positions.PosZ);
    local v35 = SpawnPoint.CFrame:PointToWorldSpace(v34);
    local v36 = {};

    for _, descendant in v33:GetDescendants() do
        if descendant:IsA("BasePart") and CollectionService:HasTag(descendant, "PlantArea") then
            table.insert(v36, descendant);
        end;
    end;

    if #v36 == 0 then
        return false;
    end;

    local v37 = RaycastParams.new();
    v37.FilterType = Enum.RaycastFilterType.Include;
    v37.FilterDescendantsInstances = v36;
    local v38 = workspace:Raycast(v35 + Vector3.new(0, 10, 0), Vector3.new(0, -20, 0), v37);

    if v38 then
        return v35.Y - v38.Position.Y <= 0.5;
    end;

    return false;
end;

function v1.Init(p39) -- Line: 265
end;

function v1.Start(p40) -- Line: 268
    -- upvalues: LocalPlayer (copy), OnToolEquipped (copy), u5 (ref), u6 (ref), u4 (copy), Networking (copy), ProximityPromptService (copy), IsPlantOnGardenBed (copy), NotificationController (copy), u8 (ref), MessagePrompt (copy), u3 (copy)
    local function SetupCharacter(p41) -- Line: 272
        -- upvalues: OnToolEquipped (ref), u5 (ref), u6 (ref), u4 (ref)
        for _, child in p41:GetChildren() do
            if child:IsA("Tool") then
                OnToolEquipped(child);
            end;
        end;

        p41.ChildAdded:Connect(function(p42) -- Line: 279
            -- upvalues: OnToolEquipped (ref)
            if p42:IsA("Tool") then
                OnToolEquipped(p42);
            end;
        end);
        p41.ChildRemoved:Connect(function(p43) -- Line: 284
            -- upvalues: u5 (ref), u6 (ref), u4 (ref)
            if p43:IsA("Tool") then
                if not p43:GetAttribute("EmptyPot") then
                    return;
                end;

                u5 = nil;

                if u6 then
                    u6:Disconnect();
                    u6 = nil;
                end;

                for i, v in u4 do
                    if v and v.Parent then
                        v:Destroy();
                    end;

                    u4[i] = nil;
                end;
            end;
        end);
    end;

    SetupCharacter(LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait());
    LocalPlayer.CharacterAdded:Connect(SetupCharacter);
    Networking.Garden.PlantPotted.OnClientEvent:Connect(function(p44) -- Line: 296
        -- upvalues: u4 (ref)
        local v45 = u4[p44];

        if v45 and v45.Parent then
            v45:Destroy();
        end;

        u4[p44] = nil;
    end);
    ProximityPromptService.PromptTriggered:Connect(function(p46, p47) -- Line: 305
        -- upvalues: LocalPlayer (ref), Networking (ref)
        if p47 ~= LocalPlayer then
            return;
        end;

        if p46.Name ~= "PickUpPottedPlantPrompt" then
            return;
        end;

        local v48 = p46:FindFirstAncestorOfClass("Model");

        if not v48 then
            return;
        end;

        if v48 and v48.Name == "PotVisual" then
            v48 = v48:FindFirstAncestorOfClass("Model");
        end;

        local v49 = v48:GetAttribute("PlantId");

        if not v49 then
            return;
        end;

        Networking.PotPlacement.PickUpPottedPlant:Fire(v49);
    end);
    ProximityPromptService.PromptTriggered:Connect(function(p50, p51) -- Line: 328
        -- upvalues: LocalPlayer (ref), IsPlantOnGardenBed (ref), NotificationController (ref), u8 (ref), MessagePrompt (ref), u3 (ref), Networking (ref)
        if p51 ~= LocalPlayer then
            return;
        end;

        if p50.Name ~= "BreakPotPrompt" then
            return;
        end;

        local v52 = p50:FindFirstAncestorOfClass("Model");

        if not v52 then
            return;
        end;

        if v52 and v52.Name == "PotVisual" then
            v52 = v52:FindFirstAncestorOfClass("Model");
        end;

        if not v52 then
            return;
        end;

        local u53 = v52:GetAttribute("PlantId");

        if not u53 then
            return;
        end;

        if not IsPlantOnGardenBed(u53) then
            NotificationController:CreateNotification("Plant must be in the garden!");

            return;
        end;

        if u8 then
            return;
        end;

        u8 = true;
        task.spawn(function() -- Line: 356
            -- upvalues: MessagePrompt (ref), u3 (ref), u8 (ref), Networking (ref), u53 (copy)
            local v54 = MessagePrompt.Prompt({
                message = "Breaking the pot will <font color=\"#FF6B5A\"><b>delete the pot</b></font> but keep the plant, replanted where the pot was.",
                titleOverride = "Break This Pot?",
                yield = true,
                hideClose = true,
                options = u3
            });
            u8 = false;

            if not v54 then
                return;
            end;

            Networking.PotPlacement.BreakPot:Fire(u53);
        end);
    end);
end;

return v1;