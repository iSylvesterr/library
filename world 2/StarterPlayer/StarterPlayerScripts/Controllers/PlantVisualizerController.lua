-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 4
};
local Players = game:GetService("Players");
local ProximityPromptService = game:GetService("ProximityPromptService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local GardenSyncController = require(script.Parent.GardenSyncController);
local OfflineGrowthAnimationController = require(script.Parent.OfflineGrowthAnimationController);
local SeedData = require(ReplicatedStorage.SharedModules.SeedData);
local PlantLifecycleHandler = require(script.Parent.PlantLifecycleHandler);
local PlantController = require(script.Parent.PlantController);
local Networking = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("Networking"));
require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("SellValueData"));
local GrowRateData = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("GrowRateData"));
local GrowEffects = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("GrowEffects"));
local PerfFlags = require(ReplicatedStorage.SharedModules.Flags.PerfFlags);
local StealFlags = require(ReplicatedStorage.SharedModules.Flags.StealFlags);
local PlantInstanceDiet = require(ReplicatedStorage.SharedModules.PlantInstanceDiet);
local PotScale = require(ReplicatedStorage.SharedModules.PotScale);
local u2 = nil;
require(ReplicatedStorage.SharedModules.CalculateStealDuration);
local LocalPlayer = Players.LocalPlayer;
local Gardens = workspace:WaitForChild("Gardens");
local Plants = ReplicatedStorage.PlantGenerationModules.Plants;
local u3 = {};
local u4 = {};
local u5 = {};
local u6 = {};
local u7 = {};
local u8 = {};
local u9 = false;
local u10 = {};
local u11 = 0;
local u12 = {};
local u13 = nil;

local function getDesiredAgeUpdateHz() -- Line: 69
    local success, result = pcall(function() -- Line: 70
        return UserSettings().GameSettings;
    end);

    if not (success and result) then
        return 30;
    end;

    local SavedQualityLevel = result.SavedQualityLevel;
    local v14 = nil;

    if typeof(SavedQualityLevel) == "EnumItem" then
        SavedQualityLevel = SavedQualityLevel.Value;
    elseif type(SavedQualityLevel) ~= "number" then
        SavedQualityLevel = v14;
    end;

    return type(SavedQualityLevel) == "number" and (SavedQualityLevel == 0 and 30 or (SavedQualityLevel >= 7 and 60 or (SavedQualityLevel >= 4 and 25 or 30))) or 50;
end;

local function hzToTick(p15) -- Line: 91
    return p15 <= 0 and 0.02 or 1 / math.clamp(p15, 15, 60);
end;

local function getCurrentAgeUpdateTick() -- Line: 102
    -- upvalues: PerfFlags (copy), LocalPlayer (copy), GrowEffects (copy), getDesiredAgeUpdateHz (copy)
    local v16 = 1 / PerfFlags.AgeUpdateMaxHz:Get();
    local v17 = tonumber(LocalPlayer:GetAttribute("AutoQualityAgeMaxHz"));

    if v17 and v17 > 0 then
        v16 = math.max(v16, 1 / v17);
    end;

    if not GrowEffects.SmoothGrow then
        return math.max(GrowEffects.GrowTick, 0.1, v16);
    end;

    local v18 = getDesiredAgeUpdateHz();
    local v19 = v18 <= 0 and 0.02 or 1 / math.clamp(v18, 15, 60);

    return math.max(v19, 0.1, v16);
end;

local u20 = getCurrentAgeUpdateTick();
local u21 = 0;

local function profileBegin(p22) -- Line: 123
    debug.profilebegin("Controllers/PlantVisualizerController/" .. p22);
end;

local function profileEnd() -- Line: 124
    debug.profileend();
end;

local function setPlantAgeWithScale(p23, p24, p25, p26) -- Line: 136
    -- upvalues: GrowEffects (copy)
    if GrowEffects.InitialScale == 1 then
        p23:SetAttribute("Age", p24);

        return;
    end;

    p23:SetAttribute("Age", p24);
    local v27 = p26 and 1 or GrowEffects.GetGrowthScale(p24, p25);
    local v28 = v27 - p23:GetScale();

    if math.abs(v28) > 0.0001 then
        p23:ScaleTo(v27);
    end;
end;

local function refreshPlantGrowthState(p29) -- Line: 161
    -- upvalues: u6 (copy), u12 (copy)
    local v30 = u6[p29];

    if not v30 then
        u12[p29] = nil;

        return;
    end;

    local v31 = v30.MaxAge or 0;

    if v31 > 0 and v31 <= (v30.CurrentAge or 0) then
        u12[p29] = nil;

        return;
    end;

    u12[p29] = true;
end;

local function getOrCreateHarvestPart(p32) -- Line: 176
    local HarvestPart = p32:FindFirstChild("HarvestPart");

    if HarvestPart and HarvestPart:IsA("BasePart") then
        return HarvestPart;
    end;

    local v33 = p32.PrimaryPart or p32:FindFirstChildWhichIsA("BasePart");

    if not v33 then
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
    Part.CFrame = v33.CFrame;
    Part.Parent = p32;

    return Part;
end;

function v1.AddGrowPrompt(p34, p35) -- Line: 196
    -- upvalues: getOrCreateHarvestPart (copy)
    if p35:FindFirstChild("GrowPrompt", true) then
        return;
    end;

    local v36 = getOrCreateHarvestPart(p35);

    if not v36 then
        return;
    end;

    local ProximityPrompt = Instance.new("ProximityPrompt");
    ProximityPrompt.Name = "GrowPrompt";
    ProximityPrompt.ActionText = "Grow Plant🌱";
    ProximityPrompt.MaxActivationDistance = 10;
    ProximityPrompt.RequiresLineOfSight = false;
    ProximityPrompt.HoldDuration = 0;
    ProximityPrompt.Enabled = true;
    ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom;
    ProximityPrompt:AddTag("GrowPrompt");
    ProximityPrompt.Parent = v36;
end;

function v1.RemoveGrowPrompt(p37, p38) -- Line: 214
    local GrowPrompt = p38:FindFirstChild("GrowPrompt", true);

    if GrowPrompt then
        GrowPrompt:Destroy();
    end;
end;

local function hasMeaningfulOfflineGrowthData(p39) -- Line: 219
    if not (p39 and (p39.oldPlants and p39.newPlants)) then
        return false;
    end;

    for i, v in p39.newPlants do
        local v40 = p39.oldPlants[i];
        local v41 = v40 and (v40.Age or 0) or 0;

        if math.abs((v.Age or v41) - v41) > 0.0001 then
            return true;
        end;

        local v42 = v40 and v40.Fruits or {};

        for i2, v2 in v.Fruits or {} do
            local v43 = v42[i2];
            local v44 = v43 and (v43.Age or 0) or 0;

            if math.abs((v2.Age or v44) - v44) > 0.0001 then
                return true;
            end;

            local v45 = v43 and (v43.OvertimeGrowth or 1) or 1;
            local v46 = v2.OvertimeGrowth or v45;
            local v47 = math.abs(v45);
            local v48 = math.max(v47, 0.0001);

            if math.abs(v46 - v45) / v48 > 0.05 then
                return true;
            end;
        end;
    end;

    return false;
end;

local function buildCutsceneParams(p49, u50) -- Line: 246
    -- upvalues: u2 (ref)
    return {
        oldPlants = p49.oldPlants,
        newPlants = p49.newPlants,
        effectiveGrowthTime = p49.effectiveGrowthTime,
        actualOfflineTime = p49.actualOfflineTime,
        skipCamera = p49.skipCamera == true,
        skipUI = p49.skipUI == true,
        skipLighting = p49.skipLighting == true,
        skipMusicDuck = p49.skipMusicDuck == true,
        skipSFX = p49.skipSFX == true,
        outlineGrowthPlants = p49.outlineGrowthPlants == true,
        targetUserId = p49.targetUserId,
        tweenCameraRestore = p49.tweenCameraRestore == true,
        titleOverride = p49.titleOverride,

        getSpawnPoint = function(p51) -- Line: 279, Name: getSpawnPoint
            -- upvalues: u50 (copy)
            return u50:GetSpawnPoint(p51);
        end,

        getSpawnedPlant = function(p52, p53) -- Line: 280, Name: getSpawnedPlant
            -- upvalues: u50 (copy)
            return u50:GetSpawnedPlant(p52, p53);
        end,

        getPlantGrowthData = function(p54, p55) -- Line: 281, Name: getPlantGrowthData
            -- upvalues: u50 (copy)
            return u50:GetPlantGrowthData(p54, p55);
        end,

        isSingleHarvestPlant = function(p56) -- Line: 282, Name: isSingleHarvestPlant
            -- upvalues: u50 (copy)
            return u50:IsSingleHarvestPlant(p56);
        end,

        addPlantHarvestPrompt = function(p57) -- Line: 283, Name: addPlantHarvestPrompt
            -- upvalues: u50 (copy)
            u50:AddHarvestPrompt(p57);
        end,

        getSpawnedFruit = function(p58, p59, p60) -- Line: 284, Name: getSpawnedFruit
            -- upvalues: u2 (ref)
            if u2 then
                return u2:GetSpawnedFruit(p58, p59, p60);
            end;

            return nil;
        end,

        getFruitGrowthData = function(p61, p62, p63) -- Line: 288, Name: getFruitGrowthData
            -- upvalues: u2 (ref)
            if u2 then
                return u2:GetFruitGrowthData(p61, p62, p63);
            end;

            return nil;
        end,

        addFruitHarvestPrompt = function(p64, p65, p66) -- Line: 292, Name: addFruitHarvestPrompt
            -- upvalues: u2 (ref)
            if u2 then
                u2:AddFruitHarvestPrompt(p64, p65, p66);
            end;
        end
    };
end;

local function applyFailedCutsceneFallback(p67, p68) -- Line: 300
    -- upvalues: LocalPlayer (copy), u3 (copy), u6 (copy), u2 (ref)
    for i, v in p68 do
        local v69 = `{LocalPlayer.UserId}_{i}`;
        local v70 = u3[v69];
        local v71 = u6[v69];

        if v70 and (v71 and v.Age) then
            v70:SetAttribute("Age", v.Age);
            v71.CurrentAge = v.Age;

            if v.Age >= v.MaxAge and p67:IsSingleHarvestPlant(v.PlantName) then
                p67:AddHarvestPrompt(v70);
            end;
        end;
    end;

    if u2 then
        for i, v in p68 do
            if v.Fruits then
                for i2, v2 in v.Fruits do
                    u2:FixFruitAgeAfterFailedCutscene(LocalPlayer.UserId, i, i2, v2);
                end;
            end;
        end;
    end;
end;

local function restoreGrowAllCutsceneState(p72) -- Line: 329
    -- upvalues: u10 (copy), LocalPlayer (copy), ProximityPromptService (copy), Networking (copy)
    p72:SetOfflineCutsceneState(false);
    u10[LocalPlayer.UserId] = nil;
    ProximityPromptService.Enabled = true;
    Networking.Garden.RequestGardens:Fire();
end;

local function runCutscene(p73, p74) -- Line: 342
    -- upvalues: OfflineGrowthAnimationController (copy), buildCutsceneParams (copy)
    return OfflineGrowthAnimationController:PlayOfflineCutscene((buildCutsceneParams(p74, p73)));
end;

local function reconcileLocalGardenUntilFilled() -- Line: 353
    -- upvalues: LocalPlayer (copy), GardenSyncController (copy), u3 (copy)
    while LocalPlayer:GetAttribute("LoadingScreenActive") == true do
        task.wait();
    end;

    local UserId = LocalPlayer.UserId;

    for _ = 1, 8 do
        local v75 = 0;
        local v76 = false;

        for i in GardenSyncController:GetGarden(UserId) do
            v75 = v75 + 1;

            if not u3[`{UserId}_{i}`] then
                v76 = true;
            end;
        end;

        if v75 > 0 and not v76 then
            return;
        end;

        GardenSyncController:ReconcileLocalGarden();
        task.wait(0.5);
    end;
end;

local function runOfflineLoginCutscene(p77) -- Line: 384
    -- upvalues: LocalPlayer (copy), Networking (copy), u10 (copy), RunService (copy), applyFailedCutsceneFallback (copy), ProximityPromptService (copy), OfflineGrowthAnimationController (copy), buildCutsceneParams (copy), reconcileLocalGardenUntilFilled (copy)
    repeat
        task.wait();
    until LocalPlayer:HasTag("DataLoaded");

    local v78 = os.clock();

    while LocalPlayer:GetAttribute("OfflineGrowthProcessed") ~= true and os.clock() - v78 < 10 do
        task.wait();
    end;

    local v79;

    if LocalPlayer:GetAttribute("OfflineGrowthProcessed") == true then
        v79 = Networking.Garden.RequestOfflineGrowthData:Fire();

        if v79 and v79.processed then
            v79 = nil;
        end;
    else
        v79 = nil;
    end;

    local v80 = v79 and (v79.oldPlants and v79.newPlants) and next(v79.newPlants) ~= nil;
    local v81;

    if v79 then
        v81 = (v79.actualOfflineTime or 0) >= 30;
    else
        v81 = v79;
    end;

    if v80 and v81 then
        u10[LocalPlayer.UserId] = v79.oldPlants;
    end;

    while LocalPlayer:GetAttribute("LoadingScreenActive") == true do
        task.wait();
    end;

    if v80 and v81 then
        if RunService:IsStudio() then
            applyFailedCutsceneFallback(p77, v79.newPlants);
        else
            p77:SetOfflineCutsceneState(true);
            ProximityPromptService.Enabled = false;
            u10[LocalPlayer.UserId] = v79.oldPlants;

            if not OfflineGrowthAnimationController:PlayOfflineCutscene((buildCutsceneParams(v79, p77))) then
                applyFailedCutsceneFallback(p77, v79.newPlants);
            end;
        end;
    end;

    ProximityPromptService.Enabled = true;
    p77:SetOfflineCutsceneState(false);
    u10[LocalPlayer.UserId] = nil;
    Networking.Garden.RequestGardens:Fire();
    reconcileLocalGardenUntilFilled();
end;

local function handleGrowAllStarting(u82) -- Line: 450
    -- upvalues: u11 (ref), ProximityPromptService (copy), u10 (copy), LocalPlayer (copy), Networking (copy)
    u11 = u11 + 1;
    local u83 = u11;
    u82:SetOfflineCutsceneState(true);
    ProximityPromptService.Enabled = false;
    task.delay(30, function() -- Line: 457
        -- upvalues: u11 (ref), u83 (copy), u82 (copy), u10 (ref), LocalPlayer (ref), ProximityPromptService (ref), Networking (ref)
        if u11 == u83 then
            u82:SetOfflineCutsceneState(false);
            u10[LocalPlayer.UserId] = nil;
            ProximityPromptService.Enabled = true;
            Networking.Garden.RequestGardens:Fire();
        end;
    end);
end;

local function handleGrowAllComplete(p84) -- Line: 468
    -- upvalues: u11 (ref), Networking (copy), u10 (copy), LocalPlayer (copy), ProximityPromptService (copy), OfflineGrowthAnimationController (copy), buildCutsceneParams (copy), applyFailedCutsceneFallback (copy)
    u11 = u11 + 1;
    local v85 = Networking.Garden.RequestGrowAllData:Fire();

    if not (v85 and v85.oldPlants and (v85.newPlants and next(v85.newPlants))) then
        p84:SetOfflineCutsceneState(false);
        u10[LocalPlayer.UserId] = nil;
        ProximityPromptService.Enabled = true;
        Networking.Garden.RequestGardens:Fire();

        return;
    end;

    local v86 = v85.playCutscene == true;
    local v87 = v85.skipUI == true and true or v85.skipCamera == true;
    u10[LocalPlayer.UserId] = v85.oldPlants;
    p84:SetOfflineCutsceneState(true);
    Networking.Garden.RequestGardens:Fire();

    if v86 then
        if v87 then
            ProximityPromptService.Enabled = true;
        else
            ProximityPromptService.Enabled = false;
        end;

        v85.tweenCameraRestore = true;

        if not OfflineGrowthAnimationController:PlayOfflineCutscene((buildCutsceneParams(v85, p84))) then
            applyFailedCutsceneFallback(p84, v85.newPlants);
        end;
    else
        applyFailedCutsceneFallback(p84, v85.newPlants);
    end;

    p84:SetOfflineCutsceneState(false);
    u10[LocalPlayer.UserId] = nil;
    ProximityPromptService.Enabled = true;
    Networking.Garden.RequestGardens:Fire();
end;

function v1.FormatTimeRemaining(p88, p89) -- Line: 523
    if p89 <= 0 then
        return "Done!";
    end;

    local v90 = math.floor(p89 / 3600);
    local v91 = math.floor(p89 % 3600 / 60);
    local v92 = math.floor(p89 % 60);

    if v90 > 0 then
        return string.format("%dh %dm", v90, v91);
    end;

    if v91 > 0 then
        return string.format("%dm %ds", v91, v92);
    end;

    return string.format("%ds", v92);
end;

function v1.Init(p93) -- Line: 534
    -- upvalues: Plants (copy), u4 (copy), SeedData (copy), u5 (copy), u2 (ref)
    for _, child in Plants:GetChildren() do
        if child:IsA("ModuleScript") then
            u4[child.Name] = require(child);
        end;
    end;

    for _, v in SeedData do
        u5[v.SeedName] = v;
    end;

    task.defer(function() -- Line: 543
        -- upvalues: u2 (ref)
        u2 = require(script.Parent.FruitVisualizerController);
    end);
end;

function v1.UpdatePlantMutation(p94, p95, p96, p97) -- Line: 548
    -- upvalues: u9 (ref), u3 (copy)
    if u9 then
        return;
    end;

    local v98 = u3[`{p95}_{p96}`];

    if v98 then
        if p97 and p97 ~= "" then
            v98:SetAttribute("Mutation", p97);

            return;
        end;

        v98:SetAttribute("Mutation", nil);
    end;
end;

function v1.Start(u99) -- Line: 561
    -- upvalues: GardenSyncController (copy), u3 (copy), Networking (copy), PlantLifecycleHandler (copy), u20 (ref), getCurrentAgeUpdateTick (copy), PerfFlags (copy), LocalPlayer (copy), RunService (copy), u21 (ref), u2 (ref), runOfflineLoginCutscene (copy), u11 (ref), ProximityPromptService (copy), u10 (copy), handleGrowAllComplete (copy), OfflineGrowthAnimationController (copy), buildCutsceneParams (copy)
    GardenSyncController:OnPlantMutationUpdated(function(p100, p101, p102) -- Line: 562
        -- upvalues: u99 (copy)
        u99:UpdatePlantMutation(p100, p101, p102);
    end);
    GardenSyncController:OnPlantAdded(function(p103, p104, p105) -- Line: 565
        -- upvalues: u99 (copy)
        u99:SpawnPlantFromData(p103, p104, p105);
    end);
    GardenSyncController:OnPlantVisualCheck(function(p106, p107, p108) -- Line: 568
        -- upvalues: u3 (ref), u99 (copy)
        if not u3[`{p106}_{p107}`] then
            u99:SpawnPlantFromData(p106, p107, p108);
        end;
    end);
    GardenSyncController:OnPlantRemoved(function(p109, p110) -- Line: 574
        -- upvalues: u99 (copy)
        u99:RemovePlantById(p109, p110);
    end);
    GardenSyncController:OnPlantMoved(function(p111, p112, p113, p114) -- Line: 577
        -- upvalues: u99 (copy)
        u99:RepositionPlant(p111, p112, p113, p114);
    end);
    GardenSyncController:OnPlantGrowthUpdated(function(p115, p116, p117, p118, p119, p120, p121) -- Line: 580
        -- upvalues: u99 (copy)
        u99:UpdatePlantGrowthData(p115, p116, p117, p118, p119, p120, p121);
    end);
    GardenSyncController:OnPlantAgeSync(function(p122, p123) -- Line: 583
        -- upvalues: u99 (copy)
        u99:SyncPlantAges(p122, p123);
    end);
    Networking.Garden.PlantLifecycleUpdated.OnClientEvent:Connect(function(p124, p125, p126, p127) -- Line: 587
        -- upvalues: u3 (ref), PlantLifecycleHandler (ref)
        local v128 = u3[tostring(p124) .. "_" .. p125];
        local v129;

        if v128 then
            v129 = v128:GetAttribute("Mutation") or nil;
        else
            v129 = nil;
        end;

        PlantLifecycleHandler:RegisterPlantModel(p124, p125, p126, p127, v128, v129);
    end);
    local success, result = pcall(function() -- Line: 594
        return UserSettings().GameSettings;
    end);

    if success and (result and result.GetPropertyChangedSignal) then
        result:GetPropertyChangedSignal("SavedQualityLevel"):Connect(function() -- Line: 596
            -- upvalues: u20 (ref), getCurrentAgeUpdateTick (ref)
            u20 = getCurrentAgeUpdateTick();
        end);
    end;

    PerfFlags.AgeUpdateMaxHz.Changed:Connect(function() -- Line: 601
        -- upvalues: u20 (ref), getCurrentAgeUpdateTick (ref)
        u20 = getCurrentAgeUpdateTick();
    end);
    LocalPlayer:GetAttributeChangedSignal("AutoQualityAgeMaxHz"):Connect(function() -- Line: 605
        -- upvalues: u20 (ref), getCurrentAgeUpdateTick (ref)
        u20 = getCurrentAgeUpdateTick();
    end);
    RunService.Heartbeat:Connect(function(p130) -- Line: 609
        -- upvalues: u21 (ref), u20 (ref), u99 (copy)
        debug.profilebegin("Controllers/PlantVisualizerController/Heartbeat");
        u21 = u21 + p130;
        local v131 = 0;

        while u20 <= u21 and v131 < 5 do
            u21 = u21 - u20;
            u99:UpdatePlantAges(u20);
            v131 = v131 + 1;
        end;

        if u21 >= 1 then
            local v132 = math.min(u21, 5);
            u21 = 0;
            u99:UpdatePlantAges(v132);
        end;

        debug.profileend();
    end);
    u2 = require(script.Parent.FruitVisualizerController);
    u99:SetOfflineCutsceneState(false);
    task.spawn(runOfflineLoginCutscene, u99);
    Networking.Garden.GrowAllStarting.OnClientEvent:Connect(function() -- Line: 631
        -- upvalues: u99 (copy), u11 (ref), ProximityPromptService (ref), u10 (ref), LocalPlayer (ref), Networking (ref)
        local u133 = u99;
        u11 = u11 + 1;
        local u134 = u11;
        u133:SetOfflineCutsceneState(true);
        ProximityPromptService.Enabled = false;
        task.delay(30, function() -- Line: 457
            -- upvalues: u11 (ref), u134 (copy), u133 (copy), u10 (ref), LocalPlayer (ref), ProximityPromptService (ref), Networking (ref)
            if u11 == u134 then
                u133:SetOfflineCutsceneState(false);
                u10[LocalPlayer.UserId] = nil;
                ProximityPromptService.Enabled = true;
                Networking.Garden.RequestGardens:Fire();
            end;
        end);
    end);
    Networking.Garden.GrowAllComplete.OnClientEvent:Connect(function() -- Line: 635
        -- upvalues: handleGrowAllComplete (ref), u99 (copy)
        task.spawn(handleGrowAllComplete, u99);
    end);
    Networking.Garden.GrowAllStartingForObserver.OnClientEvent:Connect(function(p135, p136) -- Line: 642
        -- upvalues: LocalPlayer (ref), u10 (ref)
        if typeof(p135) ~= "number" or type(p136) ~= "table" then
            return;
        end;

        if p135 == LocalPlayer.UserId then
            return;
        end;

        u10[p135] = p136;
    end);
    Networking.Garden.GrowAllCompleteForObserver.OnClientEvent:Connect(function(u137, u138, p139) -- Line: 652
        -- upvalues: LocalPlayer (ref), u10 (ref), OfflineGrowthAnimationController (ref), buildCutsceneParams (ref), u99 (copy), u2 (ref)
        if typeof(u137) ~= "number" then
            return;
        end;

        if u137 == LocalPlayer.UserId then
            return;
        end;

        if type(u138) ~= "table" or next(u138) == nil then
            u10[u137] = nil;

            return;
        end;

        local u140 = u10[u137];

        if type(u140) ~= "table" then
            return;
        end;

        local u141 = type(p139) ~= "table" and {} or p139;
        task.spawn(function() -- Line: 674
            -- upvalues: u140 (copy), u138 (copy), u141 (copy), u137 (copy), OfflineGrowthAnimationController (ref), buildCutsceneParams (ref), u99 (ref), u2 (ref), u10 (ref)
            local u142 = {
                effectiveGrowthTime = 86400,
                actualOfflineTime = 86400,
                oldPlants = u140,
                newPlants = u138,
                skipCamera = u141.skipCamera == true,
                skipUI = u141.skipUI == true,
                skipLighting = u141.skipLighting == true,
                skipMusicDuck = u141.skipMusicDuck == true,
                skipSFX = u141.skipSFX == true,
                targetUserId = u137
            };
            local success2, _ = pcall(function() -- Line: 687
                -- upvalues: OfflineGrowthAnimationController (ref), buildCutsceneParams (ref), u142 (copy), u99 (ref)
                OfflineGrowthAnimationController:PlayOfflineCutscene((buildCutsceneParams(u142, u99)));
            end);

            if not success2 and u2 then
                for i, v in u138 do
                    if v.Fruits then
                        for i2, v2 in v.Fruits do
                            u2:FixFruitAgeAfterFailedCutscene(u137, i, i2, v2);
                        end;
                    end;
                end;
            end;

            u10[u137] = nil;
        end);
    end);
end;

function v1.GetPlayerPlot(p143, p144) -- Line: 717
    -- upvalues: Players (copy), Gardens (copy)
    local v145 = Players:GetPlayerByUserId(p144);

    if not v145 then
        return nil;
    end;

    local v146 = v145:GetAttribute("PlotId");

    if not v146 then
        for _ = 1, 50 do
            task.wait(0.1);
            local v147 = Players:GetPlayerByUserId(p144);

            if not v147 then
                return nil;
            end;

            v146 = v147:GetAttribute("PlotId");

            if v146 then
                break;
            end;
        end;
    end;

    if v146 then
        return Gardens:WaitForChild("Plot" .. v146, 10);
    end;

    return nil;
end;

function v1.GetSpawnPoint(p148, p149) -- Line: 741
    local v150 = p148:GetPlayerPlot(p149);

    if v150 then
        return v150:WaitForChild("SpawnPoint", 10);
    end;

    return nil;
end;

function v1.GetPlantsFolder(p151, p152) -- Line: 747
    local v153 = p151:GetPlayerPlot(p152);

    if v153 then
        return v153:WaitForChild("Plants", 10);
    end;

    return nil;
end;

function v1.GetSeedData(p154, p155) -- Line: 753
    -- upvalues: u5 (copy)
    return u5[p155];
end;

function v1.GetOfflineCutsceneOldPlantAge(p156, p157, p158) -- Line: 757
    -- upvalues: u10 (copy)
    local v159 = u10[p157];

    if not v159 then
        return nil;
    end;

    local v160 = v159[p158];

    if v160 and typeof(v160.Age) == "number" then
        return v160.Age;
    end;

    return nil;
end;

function v1.GetOfflineCutsceneOldFruitAge(p161, p162, p163, p164) -- Line: 765
    -- upvalues: u10 (copy)
    local v165 = u10[p162];

    if not v165 then
        return nil;
    end;

    local v166 = v165[p163];

    if v166 then
        v166 = v166.Fruits;
    end;

    if v166 then
        v166 = v166[p164];
    end;

    return (not v166 or typeof(v166.Age) ~= "number") and 0 or v166.Age;
end;

function v1.HasOfflineCutsceneSnapshot(p167, p168) -- Line: 784
    -- upvalues: u10 (copy)
    return u10[p168] ~= nil;
end;

function v1.IsSingleHarvestPlant(p169, p170) -- Line: 788
    local v171 = p169:GetSeedData(p170);

    if v171 then
        return v171.IsSingleHarvest == true;
    end;

    return false;
end;

function v1.AddHarvestPrompt(p172, p173) -- Line: 794
    -- upvalues: getOrCreateHarvestPart (copy), LocalPlayer (copy), StealFlags (copy)
    if p173:FindFirstChild("HarvestPrompt", true) then
        return;
    end;

    if p173:FindFirstChild("StealPrompt", true) then
        return;
    end;

    local v174 = getOrCreateHarvestPart(p173);

    if not v174 then
        return;
    end;

    local v175 = tonumber(p173:GetAttribute("UserId")) == LocalPlayer.UserId;
    local ProximityPrompt = Instance.new("ProximityPrompt");
    ProximityPrompt.MaxActivationDistance = 10;
    ProximityPrompt.RequiresLineOfSight = false;
    ProximityPrompt.Enabled = true;
    ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom;

    if v175 then
        ProximityPrompt.Name = "HarvestPrompt";
        ProximityPrompt.ActionText = "Harvest";
        ProximityPrompt.HoldDuration = 0;
        ProximityPrompt:AddTag("HarvestPrompt");
    else
        local v176 = p173:GetAttribute("SeedName");
        ProximityPrompt.Name = "StealPrompt";
        ProximityPrompt.ActionText = "Steal";
        ProximityPrompt:AddTag("StealPrompt");

        if StealFlags.IsPlantStealable(v176) then
            ProximityPrompt.HoldDuration = StealFlags.GetStealHoldDuration(v176);
        else
            ProximityPrompt.HoldDuration = 0;
        end;
    end;

    ProximityPrompt.Parent = v174;
end;

local GrowSFX = game.SoundService.SFX.GrowSFX;
local u177 = {
    {
        Range = 3,
        SFX = GrowSFX.Small,
        VolumeRange = {
            Lowest = 0,
            Highest = 3
        },
        VolumeRangeSFX = {
            Lowest = 0.02,
            Highest = 0.07
        }
    },
    {
        Range = 40,
        SFX = GrowSFX.Medium,
        VolumeRange = {
            Lowest = 3,
            Highest = 40
        },
        VolumeRangeSFX = {
            Lowest = 0.07,
            Highest = 0.125
        }
    },
    {
        Range = (1 / 0),
        SFX = GrowSFX.Large,
        VolumeRange = {
            Lowest = 40,
            Highest = 100
        },
        VolumeRangeSFX = {
            Lowest = 0.125,
            Highest = 0.5
        }
    }
};
local _ = game.ReplicatedStorage.PlantGenerationModules.Plants;
local TweenService = game:GetService("TweenService");
local u178 = TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0);
local u179 = {};

local function createGrowSfx(p180, p181) -- Line: 894
    -- upvalues: TweenService (copy), u178 (copy)
    local PrimaryPart = p180.PrimaryPart;

    if not PrimaryPart then
        return;
    end;

    local GrowSFX2 = PrimaryPart:FindFirstChild("GrowSFX");

    if GrowSFX2 then
        if not GrowSFX2:HasTag("Removing") then
            return;
        end;

        GrowSFX2:Destroy();
    end;

    local v182 = p181.sfx:Clone();
    v182.Name = "GrowSFX";
    v182.Looped = true;
    v182.Playing = true;
    v182.Volume = 0;
    local v183 = TweenService:Create(v182, u178, {
        Volume = p181.volume
    });
    v183:Play();
    game.Debris:AddItem(v183, u178.Time);
    v182.RollOffMaxDistance = p181.rollOffMax;
    v182.PlaybackSpeed = p181.playbackSpeed;
    v182.Parent = PrimaryPart;
end;

local function fadeOutGrowSfx(p184) -- Line: 921
    -- upvalues: TweenService (copy), u178 (copy)
    local GrowSFX2 = p184:FindFirstChild("GrowSFX", true);

    if not GrowSFX2 then
        return;
    end;

    if GrowSFX2:HasTag("Removing") then
        return;
    end;

    GrowSFX2:AddTag("Removing");
    local v185 = TweenService:Create(GrowSFX2, u178, {
        Volume = 0
    });
    v185:Play();
    game.Debris:AddItem(v185, u178.Time);
    game.Debris:AddItem(GrowSFX2, u178.Time);
end;

function v1.AddGrowthSFX(p186, p187, p188) -- Line: 932
    -- upvalues: u179 (copy), u177 (copy), GrowRateData (copy)
    if not p187.PrimaryPart then
        return;
    end;

    if u179[p187] then
        return;
    end;

    local _, v189 = p187:GetBoundingBox();
    local Magnitude = v189.Magnitude;
    local v190 = nil;
    local v191 = 0;

    for _, v in u177 do
        if Magnitude <= v.Range then
            local Lowest = v.VolumeRange.Lowest;
            local Highest = v.VolumeRange.Highest;
            local Lowest2 = v.VolumeRangeSFX.Lowest;
            local Highest2 = v.VolumeRangeSFX.Highest;
            v191 = Lowest2 + (Lowest >= Highest and 0 or math.clamp((Magnitude - Lowest) / (Highest - Lowest), 0, 1)) * (Highest2 - Lowest2);
            v190 = v.SFX;
            break;
        end;
    end;

    if not v190 then
        return;
    end;

    local v192 = GrowRateData[p188.SeedName];
    local v193 = math.clamp(0.7 + (v192 and v192.GrowRate or 0.2) * 3, 0.7, 1.3);
    u179[p187] = {
        sfx = v190,
        volume = v191 * math.random(9, 11) * 0.1,
        rollOffMax = math.sqrt(v191 * 100) * 10 * math.random(9, 11) * 0.1,
        playbackSpeed = v193 * (math.random(9, 11) * 0.1)
    };
end;

function v1.RemoveGrowthSFX(p194, p195) -- Line: 978
    -- upvalues: u179 (copy), fadeOutGrowSfx (copy)
    u179[p195] = nil;
    fadeOutGrowSfx(p195);
end;

task.spawn(function() -- Line: 985
    -- upvalues: u179 (copy), fadeOutGrowSfx (copy), createGrowSfx (copy)
    local v196 = {};

    while true do
        local v197;

        repeat
            task.wait(0.33);
            v197 = workspace.CurrentCamera;
        until v197;

        local Position = v197.CFrame.Position;
        table.clear(v196);

        for i, v in u179 do
            if i.Parent and i.PrimaryPart then
                local Magnitude = (i.PrimaryPart.Position - Position).Magnitude;

                if Magnitude <= v.rollOffMax + 5 then
                    table.insert(v196, {
                        plant = i,
                        distance = Magnitude
                    });
                else
                    fadeOutGrowSfx(i);
                end;
            else
                u179[i] = nil;
            end;
        end;

        table.sort(v196, function(p198, p199) -- Line: 1009
            return p198.distance < p199.distance;
        end);

        for i, v in v196 do
            if i <= 30 then
                createGrowSfx(v.plant, u179[v.plant]);
            else
                fadeOutGrowSfx(v.plant);
            end;
        end;
    end;
end);

function v1.RemoveHarvestPrompt(p200, p201) -- Line: 1023
    local HarvestPrompt = p201:FindFirstChild("HarvestPrompt", true);

    if HarvestPrompt then
        HarvestPrompt:Destroy();
    end;
end;

function v1.CreateDebugGui(p202, p203, p204) -- Line: 1028
    local BillboardGui = Instance.new("BillboardGui");
    BillboardGui.Name = "DebugGui";
    BillboardGui.Size = UDim2.new(0, 250, 0, 60);
    BillboardGui.StudsOffset = Vector3.new(0, 3, 0);
    BillboardGui.AlwaysOnTop = true;
    BillboardGui.Parent = p203;
    BillboardGui.Enabled = false;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Size = UDim2.new(1, 0, 1, 0);
    TextLabel.BackgroundColor3 = Color3.new(0, 0, 0);
    TextLabel.BackgroundTransparency = 0.5;
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.Font = Enum.Font.SourceSansBold;
    TextLabel.Parent = BillboardGui;
end;

function v1._StepPlantVisual(p205, p206, p207, p208) -- Line: 1049
    -- upvalues: u3 (copy), u10 (copy), u6 (copy), setPlantAgeWithScale (copy), u12 (copy)
    local v209 = u3[p206];

    if not (v209 and v209.Parent) then
        u12[p206] = nil;

        if v209 then
            p205:RemoveGrowthSFX(v209);
        end;

        return true;
    end;

    if p208 then
        local v210 = tonumber(v209:GetAttribute("UserId"));

        if v210 and u10[v210] then
            return false;
        end;
    end;

    local v211 = u6[p206];

    if v211 then
        local v212 = v211.CurrentAge or 0;
        local v213 = math.min(v212 + p207 * v211.StableGrowthAmount, v211.MaxAge);
        local v214 = v212 < v211.MaxAge;
        local v215 = v211.MaxAge <= v213;
        v211.CurrentAge = v213;
        setPlantAgeWithScale(v209, v213, v211.MaxAge, v215);

        if v214 and v215 then
            u12[p206] = nil;
            p205:RemoveGrowPrompt(v209);
            local v216 = v209:GetAttribute("SeedName");
            p205:RemoveGrowthSFX(v209);

            if p205:IsSingleHarvestPlant(v216) then
                p205:AddHarvestPrompt(v209);
            end;

            return true;
        end;

        local DebugGui = v209:FindFirstChild("DebugGui");
        local v217 = DebugGui and (DebugGui:IsA("BillboardGui") and DebugGui:FindFirstChildOfClass("TextLabel"));

        if v217 then
            v217.Text = string.format("%.2f/%.0f | %s\nRate: %.2f/s", v213, v211.MaxAge, p205:FormatTimeRemaining(v211.StableGrowthAmount > 0 and ((v211.MaxAge - v213) / v211.StableGrowthAmount or 0) or 0), v211.StableGrowthAmount);
        end;
    end;

    return false;
end;

function v1.UpdatePlantAges(p218, p219) -- Line: 1103
    -- upvalues: u9 (ref), u10 (copy), u12 (copy), u6 (copy), u13 (ref), PerfFlags (copy), LocalPlayer (copy)
    if u9 then
        return;
    end;

    local v220 = next(u10) ~= nil;
    debug.profilebegin("Controllers/PlantVisualizerController/UpdatePlantAges/accumulate");
    local v221 = 0;

    for i in u12 do
        local v222 = u6[i];

        if v222 then
            v222._pendingDt = (v222._pendingDt or 0) + p219;
        end;

        v221 = v221 + 1;
    end;

    debug.profileend();

    if v221 == 0 then
        u13 = nil;

        return;
    end;

    debug.profilebegin("Controllers/PlantVisualizerController/UpdatePlantAges/iterateGrowingPlants");
    local v223 = PerfFlags.PlantVisualizerBudget:Get();
    local v224 = math.floor(v223);
    local v225 = tonumber(LocalPlayer:GetAttribute("AutoQualityPlantBudget"));

    if v225 and v225 > 0 then
        local v226 = math.floor(v225);
        v224 = math.min(v224, v226);
    end;

    local v227 = math.min(v224, v221);
    local v228 = u13;

    if v228 ~= nil and not u12[v228] then
        v228 = nil;
    end;

    local v229 = 0;

    while v229 < v227 do
        local v230 = next(u12, v228);

        if v230 == nil then
            v230 = next(u12, nil);

            if v230 == nil then
                break;
            end;
        end;

        local v231 = u6[v230];
        local v232 = v231 and (v231._pendingDt or 0) or 0;

        if v231 then
            v231._pendingDt = 0;
        end;

        p218:_StepPlantVisual(v230, v232, v220);
        v229 = v229 + 1;
        v228 = v230;
    end;

    u13 = v228;
    debug.profileend();
end;

function v1.UpdatePlantGrowthData(p233, p234, p235, p236, p237, p238, p239, p240) -- Line: 1172
    -- upvalues: u9 (ref), u10 (copy), u6 (copy), u7 (copy), u3 (copy), setPlantAgeWithScale (copy), u12 (copy)
    if u9 then
        return;
    end;

    if u10[p234] then
        return;
    end;

    local v241 = `{p234}_{p235}`;
    local v242 = p238 or 0;
    local v243 = v242 <= 0 and 0 or os.clock() + v242;
    local v244 = p239 or p237;
    local v245 = p240 or 0;
    local v246 = u6[v241];

    if not v246 then
        u7[v241] = {
            Age = p236,
            StableGrowthAmount = p237,
            BoostExpiresClock = v243,
            PostBoostRate = v244,
            BoostSources = v245
        };

        return;
    end;

    local v247 = v246.CurrentAge < v246.MaxAge;
    local v248 = math.max(v246.CurrentAge or 0, p236);
    local v249 = v246.MaxAge <= v248;
    v246.StableGrowthAmount = p237;
    v246.BoostExpiresClock = v243;
    v246.PostBoostRate = v244;
    v246.BoostSources = v245;
    v246.CurrentAge = v248;
    local v250 = u3[v241];

    if v250 then
        if v250.Parent then
            setPlantAgeWithScale(v250, v248, v246.MaxAge, v249);
        end;

        if v247 and v249 then
            local v251 = v250:GetAttribute("SeedName");
            p233:RemoveGrowPrompt(v250);
            p233:RemoveGrowthSFX(v250);

            if p233:IsSingleHarvestPlant(v251) then
                p233:AddHarvestPrompt(v250);
            end;
        end;
    end;

    local v252 = u6[v241];

    if not v252 then
        u12[v241] = nil;

        return;
    end;

    local v253 = v252.MaxAge or 0;

    if v253 > 0 and v253 <= (v252.CurrentAge or 0) then
        u12[v241] = nil;

        return;
    end;

    u12[v241] = true;
end;

function v1.SyncPlantAges(p254, p255, p256) -- Line: 1230
    -- upvalues: u9 (ref), u10 (copy), u6 (copy), u3 (copy), u8 (copy), setPlantAgeWithScale (copy), u12 (copy)
    if u9 then
        return;
    end;

    if u10[p255] then
        return;
    end;

    for i, v in p256 do
        local v257 = `{p255}_{i}`;
        local v258 = u6[v257];
        local v259 = u3[v257];

        if v258 and v259 then
            local v260 = v258.CurrentAge < v258.MaxAge;
            local v261 = math.max(v258.CurrentAge or 0, v);

            if v258.CurrentAge >= v258.MaxAge and v < v258.MaxAge then
                v261 = v258.MaxAge;
            end;

            v258.CurrentAge = v261;

            if v260 and v258.MaxAge <= v261 then
                local v262 = v259:GetAttribute("SeedName");
                p254:RemoveGrowPrompt(v259);
                p254:RemoveGrowthSFX(v259);

                if p254:IsSingleHarvestPlant(v262) then
                    p254:AddHarvestPrompt(v259);
                end;
            end;

            if v258.CurrentAge >= v258.MaxAge and v < v258.MaxAge then
                local v = v258.MaxAge or v;
            end;

            setPlantAgeWithScale(v259, v, v258.MaxAge, v258.MaxAge <= v);
            local v263 = u6[v257];

            if v263 then
                local v264 = v263.MaxAge or 0;

                if v264 > 0 and v264 <= (v263.CurrentAge or 0) then
                    u12[v257] = nil;
                else
                    u12[v257] = true;
                end;
            else
                u12[v257] = nil;
            end;
        else
            u8[v257] = math.max(u8[v257] or 0, v);
        end;
    end;
end;

function v1.SpawnPlantFromData(p265, p266, p267, p268) -- Line: 1272
    -- upvalues: u3 (copy), u4 (copy), u7 (copy), GrowRateData (copy), u8 (copy), u6 (copy), PlantInstanceDiet (copy), GrowEffects (copy), PlantLifecycleHandler (copy), u12 (copy), ReplicatedStorage (copy), PotScale (copy), LocalPlayer (copy), u9 (ref), u10 (copy), PlantController (copy)
    local v269 = `{p266}_{p267}`;

    if u3[v269] then
        p265:RemovePlantById(p266, p267);
    end;

    local v270 = p265:GetSpawnPoint(p266);

    if not v270 then
        return;
    end;

    local v271 = p265:GetPlantsFolder(p266);

    if not v271 then
        return;
    end;

    local PlantName = p268.PlantName;

    if not PlantName then
        return;
    end;

    local v272 = Vector3.new(p268.Positions.PosX, p268.Positions.PosY, p268.Positions.PosZ);
    local Rotation = p268.Positions.Rotation;
    local v273 = v270.CFrame:PointToWorldSpace(v272);
    local v274 = CFrame.new(Vector3.new(0, 0, 0)) * CFrame.Angles(0, math.rad(Rotation), 0);
    local _, v275, _ = v270.CFrame:ToWorldSpace(v274):ToEulerAnglesYXZ();
    local v276 = CFrame.new(v273) * CFrame.Angles(0, v275, 0);
    local v277 = u4[PlantName];
    local v278 = p265:GetSeedData(PlantName);

    if not v277 then
        return error((`[{script.Name}] Missing Generation Module for {PlantName}`));
    end;

    local v279 = v278.PlantModel:Clone();
    v279.Name = v269;
    v279:SetAttribute("PlantId", p267);
    v279:SetAttribute("UserId", p266);
    v279:SetAttribute("SeedName", PlantName);
    v279:SetAttribute("MaxAge", p268.MaxAge);

    if p268.PlantedAt then
        v279:SetAttribute("PlantedAt", p268.PlantedAt);
    end;

    v279.Parent = v271;
    v279:PivotTo(v276);
    local v280 = p268.Age or 0;
    local v281 = u7[v269];
    local v282 = v281 and v281.StableGrowthAmount or (GrowRateData[PlantName] and GrowRateData[PlantName].GrowRate or 0.2);
    local v283;

    if v281 and v281.Age ~= nil then
        v283 = math.max(v280, v281.Age);
    else
        v283 = v280;
    end;

    if u8[v269] ~= nil then
        v283 = math.max(v283, u8[v269]);
    end;

    local v284 = p265:GetOfflineCutsceneOldPlantAge(p266, p267);

    if typeof(v284) ~= "number" then
        v284 = v283;
    end;

    local v285 = {
        CurrentAge = v284,
        StableGrowthAmount = v282
    };

    if v281 then
        v282 = v281.PostBoostRate or v282;
    end;

    v285.PostBoostRate = v282;
    v285.BoostExpiresClock = v281 and (v281.BoostExpiresClock or 0) or 0;
    v285.BoostSources = v281 and v281.BoostSources or 0;
    v285.MaxAge = p268.MaxAge;
    v285._syncedAge = v280;
    u6[v269] = v285;
    u7[v269] = nil;
    u8[v269] = nil;
    v279:SetAttribute("Age", v284);
    v279:SetAttribute("Mutation", p268.Mutation);
    v277.InitPlant(v279, p268.Seed or 0, p268.SizeMultiplier or 1, p268.PlantedAt or os.time());
    u3[v269] = v279;

    if not v279:HasTag("InitializationComplete") then
        repeat
            task.wait();
        until v279:HasTag("InitializationComplete");
    end;

    v277.BeginPlantGrowth(v279);
    PlantInstanceDiet.Apply(v279, PlantName);
    v279:SetAttribute("PlantGrowthReady", true);

    if GrowEffects.InitialScale ~= 1 and v284 < p268.MaxAge then
        local v286 = GrowEffects.GetGrowthScale(v284, p268.MaxAge);

        if math.abs(v286 - 1) > 0.0001 then
            v279:ScaleTo(v286);
        end;
    end;

    PlantLifecycleHandler:RegisterPlantModel(p266, p267, PlantName, p268.PrimeStartedAt, v279, p268.Mutation, p268.ReviveProgress);
    local v287 = u6[v269];

    if v287 then
        local v288 = v287.MaxAge or 0;

        if v288 > 0 and v288 <= (v287.CurrentAge or 0) then
            u12[v269] = nil;
        else
            u12[v269] = true;
        end;
    else
        u12[v269] = nil;
    end;

    if p268.IsPotted then
        local v289 = ReplicatedStorage.Assets.POT:Clone();
        v289.Name = "PotVisual";
        v289:ScaleTo((p268.SizeMultiplier or 1) * PotScale.Get(PlantName));

        for _, v in v289:QueryDescendants("BasePart") do
            v.Anchored = true;
            v.CanCollide = true;
            v.CanQuery = true;
        end;

        local _, v290 = v289:GetBoundingBox();
        local v291 = v289:GetPivot();
        v289:PivotTo(CFrame.new(v276.Position.X, v276.Position.Y + (v291.Position.Y - (v291.Position.Y - v290.Y / 2)), v276.Position.Z) * CFrame.Angles(0, v275, 0));
        v289.Parent = workspace;
        local PlantRoot = v289:FindFirstChild("PlantRoot", true);

        if PlantRoot then
            local v292 = PlantRoot.WorldPosition.Y - v276.Position.Y;
            v279:PivotTo(v279:GetPivot() * CFrame.new(0, v292, 0));
        end;

        v289.Parent = v279;
        local PrimaryPart = v289.PrimaryPart;

        if PrimaryPart then
            local ProximityPrompt = Instance.new("ProximityPrompt");
            ProximityPrompt.Name = "PickUpPottedPlantPrompt";
            ProximityPrompt.ActionText = "Pick Up";
            ProximityPrompt.ObjectText = PlantName .. " [Potted]";
            ProximityPrompt.HoldDuration = 2;
            ProximityPrompt.KeyboardKeyCode = Enum.KeyCode.E;
            ProximityPrompt.MaxActivationDistance = 10;
            ProximityPrompt.RequiresLineOfSight = false;
            ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom;
            ProximityPrompt.UIOffset = Vector2.new(0, 40);
            ProximityPrompt:AddTag("PickUpPottedPlantPrompt");
            ProximityPrompt.Parent = PrimaryPart;
            local ProximityPrompt2 = Instance.new("ProximityPrompt");
            ProximityPrompt2.Name = "BreakPotPrompt";
            ProximityPrompt2.ActionText = "Break Pot";
            ProximityPrompt2.ObjectText = PlantName .. " [Potted]";
            ProximityPrompt2.HoldDuration = 2;
            ProximityPrompt2.KeyboardKeyCode = Enum.KeyCode.Q;
            ProximityPrompt2.MaxActivationDistance = 10;
            ProximityPrompt2.RequiresLineOfSight = false;
            ProximityPrompt2.Style = Enum.ProximityPromptStyle.Custom;
            ProximityPrompt2.UIOffset = Vector2.new(0, -40);
            ProximityPrompt2:AddTag("BreakPotPrompt");
            ProximityPrompt2.Parent = PrimaryPart;

            if tonumber(p266) ~= LocalPlayer.UserId then
                ProximityPrompt.Enabled = false;
                ProximityPrompt2.Enabled = false;
            end;
        end;
    end;

    local v293 = u6[v269];

    if v293 then
        v284 = v293.CurrentAge or v284;
    end;

    if not (u9 or u10[p266]) then
        if p268.MaxAge <= v284 then
            if p265:IsSingleHarvestPlant(PlantName) then
                p265:AddHarvestPrompt(v279);
            end;
        else
            p265:AddGrowthSFX(v279, v278);

            if p266 == LocalPlayer.UserId and not p268.IsPotted then
                PlantController:EnsureSeedMarker(p266, p267, v279, v276.Position);
            end;
        end;
    end;
end;

function v1.RepositionPlant(p294, p295, p296, p297, p298) -- Line: 1490
    -- upvalues: u3 (copy)
    local v299 = u3[`{p295}_{p296}`];

    if not v299 then
        return;
    end;

    local v300 = p294:GetSpawnPoint(p295);

    if not v300 then
        return;
    end;

    local v301 = v300.CFrame:PointToWorldSpace(p297);
    local v302 = CFrame.new(Vector3.new(0, 0, 0)) * CFrame.Angles(0, math.rad(p298), 0);
    local _, v303, _ = v300.CFrame:ToWorldSpace(v302):ToEulerAnglesYXZ();
    v299:PivotTo(CFrame.new(v301) * CFrame.Angles(0, v303, 0));
end;

function v1.RemovePlantById(p304, p305, p306) -- Line: 1509
    -- upvalues: u3 (copy), PlantLifecycleHandler (copy), u6 (copy), u7 (copy), u8 (copy), u12 (copy)
    local v307 = p305 .. "_" .. p306;
    local v308 = u3[v307];

    if v308 then
        PlantLifecycleHandler:UnregisterPlantModel(p305, p306);
        v308:Destroy();
        u3[v307] = nil;
        u6[v307] = nil;
        u7[v307] = nil;
        u8[v307] = nil;
        u12[v307] = nil;
    end;
end;

function v1.SetOfflineCutsceneState(p309, p310) -- Line: 1523
    -- upvalues: u9 (ref), u10 (copy), LocalPlayer (copy), u2 (ref)
    u9 = p310;

    if not p310 then
        u10[LocalPlayer.UserId] = nil;
        p309:AddMissingPrompts();
    end;

    if u2 then
        u2:SetOfflineCutsceneState(p310);
    end;
end;

function v1.GetOfflineCutsceneState(p311) -- Line: 1538
    -- upvalues: u9 (ref)
    return u9;
end;

function v1.AddMissingPrompts(p312) -- Line: 1542
    -- upvalues: u3 (copy), u6 (copy), u12 (copy)
    for i, v in u3 do
        if v and v.Parent then
            local v313 = u6[i];

            if v313 and v313.CurrentAge >= v313.MaxAge then
                u12[i] = nil;
                p312:RemoveGrowPrompt(v);
                p312:RemoveGrowthSFX(v);

                if not v:FindFirstChild("HarvestPrompt", true) and (not v:FindFirstChild("StealPrompt", true) and p312:IsSingleHarvestPlant((v:GetAttribute("SeedName")))) then
                    p312:AddHarvestPrompt(v);
                end;
            end;
        end;
    end;
end;

function v1.GetSpawnedPlant(p314, p315, p316) -- Line: 1564
    -- upvalues: u3 (copy)
    return u3[`{p315}_{p316}`];
end;

function v1.GetPlantGrowthData(p317, p318, p319) -- Line: 1568
    -- upvalues: u6 (copy)
    return u6[`{p318}_{p319}`];
end;

return v1;