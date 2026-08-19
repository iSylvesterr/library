-- Decompiled with Potassium's decompiler.

local u1 = {
    StartOrder = 5
};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local GardenSyncController = require(script.Parent.GardenSyncController);
local PlantVisualizerController = require(script.Parent.PlantVisualizerController);
local Networking = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("Networking"));
local WeightFormat = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("WeightFormat"));
local GrowEffects = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("GrowEffects"));
local PerfFlags = require(ReplicatedStorage.SharedModules.Flags.PerfFlags);
local FruitFlags = require(ReplicatedStorage.SharedModules.Flags.FruitFlags);
local StealFlags = require(ReplicatedStorage.SharedModules.Flags.StealFlags);
local Environment = require(ReplicatedStorage.SharedModules.Environment);
local LocalPlayer = Players.LocalPlayer;
local Fruits = ReplicatedStorage.Assets.Fruits;
local Fruits2 = ReplicatedStorage.PlantGenerationModules.Fruits;
local Plants = ReplicatedStorage.PlantGenerationModules.Plants;
local u2 = {};
local SellValueData = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("SellValueData"));
local MutationData = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("MutationData"));
require(ReplicatedStorage.SharedModules.CalculateStealDuration);
local CalculateOvertimeGrowth = require(ReplicatedStorage.SharedModules.CalculateOvertimeGrowth);
local OvertimeGrowthFlags = require(ReplicatedStorage.SharedModules.Flags.OvertimeGrowthFlags);
local PlantBehaviorRules = require(ReplicatedStorage.SharedModules.PlantBehaviorRules);
local FruitIdentity = require(ReplicatedStorage.SharedModules.FruitIdentity);
local FruitGrowRate = require(ReplicatedStorage.SharedModules.FruitGrowRate);
local AtlanticGiantGrowth = require(ReplicatedStorage.SharedModules.AtlanticGiantGrowth);
local AtlanticGiantRenderScale = require(ReplicatedStorage.SharedModules.AtlanticGiantRenderScale);
local PlantInstanceDiet = require(ReplicatedStorage.SharedModules.PlantInstanceDiet);
local u3 = {};
local u4 = {};
local u5 = {};
local u6 = false;
local u7 = {};
local u8 = {};
local u9 = {};
local u10 = {};

local function getDesiredAgeUpdateHz() -- Line: 51
    local success, result = pcall(function() -- Line: 52
        return UserSettings().GameSettings;
    end);

    if not (success and result) then
        return 30;
    end;

    local SavedQualityLevel = result.SavedQualityLevel;
    local v11 = nil;

    if typeof(SavedQualityLevel) == "EnumItem" then
        SavedQualityLevel = SavedQualityLevel.Value;
    elseif type(SavedQualityLevel) ~= "number" then
        SavedQualityLevel = v11;
    end;

    return type(SavedQualityLevel) == "number" and (SavedQualityLevel == 0 and 30 or (SavedQualityLevel >= 7 and 60 or (SavedQualityLevel >= 4 and 25 or 30))) or 50;
end;

local function hzToTick(p12) -- Line: 83
    return p12 <= 0 and 0.02 or 1 / math.clamp(p12, 15, 60);
end;

local function getCurrentAgeUpdateTick() -- Line: 94
    -- upvalues: PerfFlags (copy), GrowEffects (copy), getDesiredAgeUpdateHz (copy)
    local v13 = 1 / PerfFlags.AgeUpdateMaxHz:Get();

    if not GrowEffects.SmoothGrow then
        return math.max(GrowEffects.GrowTick, 0.1, v13);
    end;

    local v14 = getDesiredAgeUpdateHz();
    local v15 = v14 <= 0 and 0.02 or 1 / math.clamp(v14, 15, 60);

    return math.max(v15, 0.1, v13);
end;

local v16 = 1 / PerfFlags.AgeUpdateMaxHz:Get();
local u17;

if GrowEffects.SmoothGrow then
    local v18 = getDesiredAgeUpdateHz();
    local v19 = v18 <= 0 and 0.02 or 1 / math.clamp(v18, 15, 60);
    u17 = math.max(v19, 0.1, v16);
else
    u17 = math.max(GrowEffects.GrowTick, 0.1, v16);
end;

local u20 = 0;
local u21 = 0;
local u22 = nil;

local function profileBegin(p23) -- Line: 124
    debug.profilebegin("Controllers/FruitVisualizerController/" .. p23);
end;

local function profileEnd() -- Line: 128
    debug.profileend();
end;

local function setFruitAgeWithScale(p24, p25, p26, p27, p28) -- Line: 132
    p24:SetAttribute("Age", p25);
end;

local function foreverElapsedSeconds(p29) -- Line: 155
    -- upvalues: GardenSyncController (copy)
    local FinishedGrowingAt = p29.FinishedGrowingAt;
    local UserId = p29.UserId;
    local PlantId = p29.PlantId;
    local FruitId = p29.FruitId;
    local v30;

    if UserId and (PlantId and FruitId) then
        local v31 = GardenSyncController:GetPlant(UserId, PlantId);
        v30 = v31 and v31.Fruits and v31.Fruits[FruitId];

        if v30 then
            v30 = v30.FinishedGrowingAt;
        end;

        if type(v30) == "number" then
            if v30 <= 0 then
                v30 = FinishedGrowingAt;
            end;
        else
            v30 = FinishedGrowingAt;
        end;
    else
        v30 = FinishedGrowingAt;
    end;

    return (type(v30) ~= "number" or v30 <= 0) and 0 or workspace:GetServerTimeNow() - v30;
end;

local u32 = RunService:IsStudio();

local function disableCollisionIfOversized(p33) -- Line: 178
    -- upvalues: FruitFlags (copy)
    local _, v34 = p33:GetBoundingBox();

    if math.max(v34.X, v34.Y, v34.Z) <= FruitFlags.MaxCollidableExtentStuds:Get() then
        return;
    end;

    for _, v in p33:QueryDescendants("BasePart[CanCollide = true]") do
        v.CanCollide = false;
    end;
end;

local function applyForeverGrowthScale(p35, p36) -- Line: 193
    -- upvalues: foreverElapsedSeconds (copy), AtlanticGiantRenderScale (copy), u32 (copy), FruitFlags (copy)
    local v37 = foreverElapsedSeconds(p36);
    local v38 = p36.SizeMultiplier or 1;
    local v39 = v37 <= 0 and 1 or AtlanticGiantRenderScale(v37);
    local v40 = v39 - p35:GetScale();

    if math.abs(v40) > 0.001 then
        if u32 then
            print(string.format("[GiantGrowth/Client] rescale %s | stamp=%s elapsed=%.0fs base=x%.3f -> scale x%.3f (was x%.3f)", p35:GetFullName(), tostring(p36.FinishedGrowingAt), v37, v38, v39, p35:GetScale()));
        end;

        p35:ScaleTo(v39);
        local _, v41 = p35:GetBoundingBox();

        if math.max(v41.X, v41.Y, v41.Z) <= FruitFlags.MaxCollidableExtentStuds:Get() then
            return;
        end;

        for _, v in p35:QueryDescendants("BasePart[CanCollide = true]") do
            v.CanCollide = false;
        end;
    end;
end;

local function setFruitGrowthState(p42, p43) -- Line: 210
    -- upvalues: u7 (copy), u8 (copy), u5 (copy), u10 (copy)
    if p43 then
        u7[p42] = nil;
        u8[p42] = true;
        local v44 = u5[p42];

        if v44 and v44.GrowsForever then
            if type(v44.FinishedGrowingAt) ~= "number" or v44.FinishedGrowingAt <= 0 then
                v44.FinishedGrowingAt = workspace:GetServerTimeNow();
            end;

            u10[p42] = true;
        end;
    else
        u8[p42] = nil;
        u7[p42] = true;
        u10[p42] = nil;
    end;
end;

local function computeFruitVisibleCenter(p45) -- Line: 231
    local PrimaryPart = p45.PrimaryPart;
    local v46 = Vector3.new(0, 0, 0);
    local v47 = 0;

    for _, v in p45:QueryDescendants("BasePart:not([Transparency = 1])") do
        if v ~= PrimaryPart then
            v46 = v46 + v.Position;
            v47 = v47 + 1;
        end;
    end;

    if v47 == 0 then
        return nil;
    end;

    return v46 / v47;
end;

local function reportFruitWorldPosition(u48, u49, u50, p51) -- Line: 245
    -- upvalues: LocalPlayer (copy), Networking (copy), reportFruitWorldPosition (copy)
    if type(u48) ~= "string" or type(u49) ~= "string" then
        return;
    end;

    if tonumber(u50:GetAttribute("UserId")) ~= LocalPlayer.UserId then
        return;
    end;

    local PrimaryPart = u50.PrimaryPart;
    local v52 = Vector3.new(0, 0, 0);
    local v53 = 0;

    for _, v in u50:QueryDescendants("BasePart:not([Transparency = 1])") do
        if v ~= PrimaryPart then
            v52 = v52 + v.Position;
            v53 = v53 + 1;
        end;
    end;

    local v54;

    if v53 == 0 then
        v54 = nil;
    else
        v54 = v52 / v53;
    end;

    local v55 = v54 or u50:GetPivot().Position;
    Networking.ObjectPositionService.CreateServerValue:Fire(u48, u49, v55);

    if not p51 then
        task.delay(3, function() -- Line: 254
            -- upvalues: u50 (copy), reportFruitWorldPosition (ref), u48 (copy), u49 (copy)
            if u50 and u50.Parent then
                reportFruitWorldPosition(u48, u49, u50, true);
            end;
        end);
    end;
end;

local function refreshFruitGrowthState(p56) -- Line: 262
    -- upvalues: u5 (copy), u7 (copy), u8 (copy), u10 (copy)
    local v57 = u5[p56];

    if not v57 then
        u7[p56] = nil;
        u8[p56] = nil;

        return;
    end;

    local v58 = v57.CurrentAge or 0;
    local v59 = v57.MaxAge or 0;
    local v60;

    if v59 > 0 then
        v60 = v59 <= v58;
    else
        v60 = false;
    end;

    if v60 then
        u7[p56] = nil;
        u8[p56] = true;
        local v61 = u5[p56];

        if v61 and v61.GrowsForever then
            if type(v61.FinishedGrowingAt) ~= "number" or v61.FinishedGrowingAt <= 0 then
                v61.FinishedGrowingAt = workspace:GetServerTimeNow();
            end;

            u10[p56] = true;
        end;
    else
        u8[p56] = nil;
        u7[p56] = true;
        u10[p56] = nil;
    end;
end;

local function getOrCreateHarvestPart(p62) -- Line: 275
    local HarvestPart = p62:FindFirstChild("HarvestPart");

    if HarvestPart and HarvestPart:IsA("BasePart") then
        return HarvestPart;
    end;

    local v63 = p62.PrimaryPart or p62:FindFirstChildWhichIsA("BasePart");

    if not v63 then
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
    Part.CFrame = v63.CFrame;
    Part.Parent = p62;

    return Part;
end;

function u1.CalculateFruitWeight(p64, p65) -- Line: 300
    -- upvalues: GardenSyncController (copy), FruitIdentity (copy), u10 (copy), u5 (copy), foreverElapsedSeconds (copy), AtlanticGiantGrowth (copy), OvertimeGrowthFlags (copy), u4 (copy)
    local v66 = tonumber(p65:GetAttribute("UserId"));
    local v67 = p65:GetAttribute("PlantId");
    local v68 = p65:GetAttribute("FruitId");
    local v69 = p65:GetAttribute("CorePartName");

    if v66 and v67 then
        local v70 = GardenSyncController:GetPlant(v66, v67);

        if v70 and v70.PlantName then
            v69 = FruitIdentity.ResolveFruitName(v70.PlantName);
        end;
    end;

    local v71 = p65:GetAttribute("SizeMulti") or 1;
    local v72 = 1;
    local v73;

    if v66 and (v67 and v68) then
        v73 = `{v66}_{v67}_{v68}`;
    else
        v73 = nil;
    end;

    local v74 = v73 and u10[v73] and u5[v73];

    if v74 then
        local v75 = foreverElapsedSeconds(v74);

        if v75 > 0 then
            v72 = AtlanticGiantGrowth(v75);
        end;
    elseif OvertimeGrowthFlags.Enabled:Get() and (v66 and (v67 and v68)) then
        local v76 = GardenSyncController:GetPlant(v66, v67);
        local v77 = v76 and v76.Fruits and v76.Fruits[v68];

        if v77 and v77.OvertimeGrowth then
            v72 = v77.OvertimeGrowth;
        end;
    end;

    local v78 = u4[v69];
    local v79 = v78 and v78.GrowData and v78.GrowData.BaseWeight;

    if v79 then
        return v79 * v71 * v72;
    end;

    return nil;
end;

function u1.IsGrowsForeverFruit(p80, p81) -- Line: 347
    -- upvalues: GardenSyncController (copy), PlantBehaviorRules (copy)
    local v82 = p81:GetAttribute("CorePartName");
    local v83 = tonumber(p81:GetAttribute("UserId"));
    local v84 = p81:GetAttribute("PlantId");

    if v83 and v84 then
        local v85 = GardenSyncController:GetPlant(v83, v84);

        if v85 and v85.PlantName then
            v82 = v85.PlantName;
        end;
    end;

    return PlantBehaviorRules.GrowsForever(v82);
end;

local u86 = RunService:IsStudio() or Environment.env == "Dev";

local function dprintWeight(...) -- Line: 366
    -- upvalues: u86 (copy)
    if u86 then
        print("[PlantWeight]", ...);
    end;
end;

function u1.CalculatePlantWeight(p87, p88) -- Line: 372
    -- upvalues: dprintWeight (copy), GardenSyncController (copy), u2 (copy), OvertimeGrowthFlags (copy), CalculateOvertimeGrowth (copy)
    local v89 = tonumber(p88:GetAttribute("UserId"));
    local v90 = p88:GetAttribute("PlantId");

    if not v89 or type(v90) ~= "string" then
        dprintWeight("FAIL: missing UserId/PlantId attributes on", p88:GetFullName(), "UserId =", p88:GetAttribute("UserId"), "PlantId =", p88:GetAttribute("PlantId"));

        return nil;
    end;

    local v91 = GardenSyncController:GetPlant(v89, v90);

    if not (v91 and v91.PlantName) then
        dprintWeight("FAIL: GardenSyncController:GetPlant returned", v91 == nil and "nil" or "data with no PlantName", "for", v89, v90);

        return nil;
    end;

    local v92 = u2[v91.PlantName];
    local v93 = v92 and v92.GrowData and v92.GrowData.BaseWeight;

    if not v93 then
        dprintWeight("FAIL:", v91.PlantName, v92 == nil and "has no Plants generation module" or "module has no GrowData.BaseWeight");

        return nil;
    end;

    local v94 = v91.SizeMultiplier or 1;
    local v95;

    if OvertimeGrowthFlags.Enabled:Get() then
        local OvertimeGrowth = v91.OvertimeGrowth;

        if type(OvertimeGrowth) ~= "number" or OvertimeGrowth <= 0 then
            local FinishedGrowingAt = v91.FinishedGrowingAt;

            if type(FinishedGrowingAt) == "number" and FinishedGrowingAt > 0 then
                local v96 = CalculateOvertimeGrowth(workspace:GetServerTimeNow() - FinishedGrowingAt);
                OvertimeGrowth = math.max(v96, 1);
            else
                OvertimeGrowth = 1;
            end;
        end;

        v95 = math.clamp(OvertimeGrowth, 1, 100);
    else
        v95 = 1;
    end;

    dprintWeight(("OK: %s base=%.1f size=%.2f overtime=%.2f -> %.1fg"):format(v91.PlantName, v93, v94, v95, v93 * v94 * v95));

    return v93 * v94 * v95;
end;

local function getPromptObjectText(p97) -- Line: 421
    -- upvalues: GardenSyncController (copy), FruitIdentity (copy), u1 (copy), WeightFormat (copy)
    local v98 = tonumber(p97:GetAttribute("UserId"));
    local v99 = p97:GetAttribute("PlantId");
    local v100 = "Fruit";

    if v98 and v99 then
        local v101 = GardenSyncController:GetPlant(v98, v99);

        if v101 and v101.PlantName then
            v100 = FruitIdentity.ResolveFruitName(v101.PlantName);
        end;
    end;

    local v102 = p97:GetAttribute("Mutation");
    local v103 = v102 and v102 ~= "" and (` [{v102}]` or "") or "";
    local v104 = u1:CalculateFruitWeight(p97) or 0;

    return `{v100}{v103} [{WeightFormat.FormatGrams(v104)}]`;
end;

function u1.Init(p105) -- Line: 441
    -- upvalues: Fruits2 (copy), u4 (copy), Plants (copy), u2 (copy)
    for _, child in Fruits2:GetChildren() do
        if child:IsA("ModuleScript") then
            u4[child.Name] = require(child);
        end;
    end;

    for _, child in Plants:GetChildren() do
        if child:IsA("ModuleScript") then
            u2[child.Name] = require(child);
        end;
    end;
end;

function u1.UpdateFruitMutation(p106, p107, p108, p109, p110) -- Line: 454
    -- upvalues: u6 (ref), u3 (copy)
    if u6 then
        return;
    end;

    local v111 = u3[`{p107}_{p108}_{p109}`];

    if v111 then
        if p110 and p110 ~= "" then
            v111:SetAttribute("Mutation", p110);
        else
            v111:SetAttribute("Mutation", nil);
        end;

        local v112 = v111:FindFirstChild("HarvestPrompt", true) or v111:FindFirstChild("StealPrompt", true);

        if v112 then
            v112:IsA("ProximityPrompt");
        end;
    end;
end;

function u1.Start(u113) -- Line: 476
    -- upvalues: GardenSyncController (copy), u3 (copy), u17 (ref), PerfFlags (copy), GrowEffects (copy), getDesiredAgeUpdateHz (copy), RunService (copy), u20 (ref), u21 (ref), u8 (copy), u9 (copy), reportFruitWorldPosition (copy)
    GardenSyncController:OnFruitMutationUpdated(function(p114, p115, p116, p117) -- Line: 477
        -- upvalues: u113 (copy)
        u113:UpdateFruitMutation(p114, p115, p116, p117);
    end);
    GardenSyncController:OnFruitAdded(function(p118, p119, p120, p121) -- Line: 481
        -- upvalues: u113 (copy)
        u113:SpawnFruitFromData(p118, p119, p120, p121);
    end);
    GardenSyncController:OnFruitVisualCheck(function(p122, p123, p124, p125) -- Line: 485
        -- upvalues: u3 (ref), u113 (copy)
        if not u3[`{p122}_{p123}_{p124}`] then
            u113:SpawnFruitFromData(p122, p123, p124, p125);
        end;
    end);
    GardenSyncController:OnFruitRemoved(function(p126, p127, p128) -- Line: 492
        -- upvalues: u113 (copy)
        u113:RemoveFruitById(p126, p127, p128);
    end);
    GardenSyncController:OnFruitGrowthUpdated(function(p129, p130, p131, p132, p133, p134) -- Line: 496
        -- upvalues: u113 (copy)
        u113:UpdateFruitGrowthData(p129, p130, p131, p132, p133, p134);
    end);
    GardenSyncController:OnFruitAgeSync(function(p135, p136, p137) -- Line: 500
        -- upvalues: u113 (copy)
        u113:SyncFruitAges(p135, p136, p137);
    end);
    GardenSyncController:OnFruitOvertimeGrowthUpdated(function(p138, p139, p140, p141) -- Line: 504
        -- upvalues: u113 (copy)
        u113:UpdateFruitOvertimeGrowth(p138, p139, p140, p141);
    end);
    local success, result = pcall(function() -- Line: 508
        return UserSettings().GameSettings;
    end);

    if success and (result and result.GetPropertyChangedSignal) then
        result:GetPropertyChangedSignal("SavedQualityLevel"):Connect(function() -- Line: 512
            -- upvalues: u17 (ref), PerfFlags (ref), GrowEffects (ref), getDesiredAgeUpdateHz (ref)
            local v142 = 1 / PerfFlags.AgeUpdateMaxHz:Get();
            local v143;

            if GrowEffects.SmoothGrow then
                local v144 = getDesiredAgeUpdateHz();
                local v145 = v144 <= 0 and 0.02 or 1 / math.clamp(v144, 15, 60);
                v143 = math.max(v145, 0.1, v142);
            else
                v143 = math.max(GrowEffects.GrowTick, 0.1, v142);
            end;

            u17 = v143;
        end);
    end;

    PerfFlags.AgeUpdateMaxHz.Changed:Connect(function() -- Line: 517
        -- upvalues: u17 (ref), PerfFlags (ref), GrowEffects (ref), getDesiredAgeUpdateHz (ref)
        local v146 = 1 / PerfFlags.AgeUpdateMaxHz:Get();
        local v147;

        if GrowEffects.SmoothGrow then
            local v148 = getDesiredAgeUpdateHz();
            local v149 = v148 <= 0 and 0.02 or 1 / math.clamp(v148, 15, 60);
            v147 = math.max(v149, 0.1, v146);
        else
            v147 = math.max(GrowEffects.GrowTick, 0.1, v146);
        end;

        u17 = v147;
    end);
    RunService.Heartbeat:Connect(function(p150) -- Line: 521
        -- upvalues: u20 (ref), u21 (ref), u17 (ref), u113 (copy), u8 (ref), u9 (ref), u3 (ref), reportFruitWorldPosition (ref)
        debug.profilebegin("Controllers/FruitVisualizerController/Heartbeat");
        u20 = u20 + p150;
        u21 = u21 + p150;
        local v151 = 0;

        while u17 <= u20 and v151 < 5 do
            u20 = u20 - u17;
            u113:UpdateFruitAges(u17);
            v151 = v151 + 1;
        end;

        if u20 >= 1 then
            local v152 = math.min(u20, 5);
            u20 = 0;
            u113:UpdateFruitAges(v152);
        end;

        u113:UpdateForeverGrowth();

        if u21 >= 0.5 then
            u21 = 0;

            for i in u8 do
                if not u9[i] then
                    local v153 = u3[i];

                    if v153 and v153.Parent then
                        u9[i] = true;
                        reportFruitWorldPosition(v153:GetAttribute("PlantId"), v153:GetAttribute("FruitId"), v153);
                    end;
                end;
            end;
        end;

        debug.profileend();
    end);
end;

function u1.AddFruitHarvestPrompt(p154, p155, p156, p157) -- Line: 555
    -- upvalues: getOrCreateHarvestPart (copy), LocalPlayer (copy), SellValueData (copy), MutationData (copy), StealFlags (copy)
    if p155:FindFirstChild("HarvestPrompt", true) then
        return;
    end;

    if p155:FindFirstChild("StealPrompt", true) then
        return;
    end;

    local v158 = getOrCreateHarvestPart(p155);

    if not v158 then
        return;
    end;

    local v159 = tonumber(p155:GetAttribute("UserId")) == LocalPlayer.UserId;
    local ProximityPrompt = Instance.new("ProximityPrompt");
    ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom;

    if v159 then
        ProximityPrompt.MaxActivationDistance = 10;
        ProximityPrompt.RequiresLineOfSight = false;
        ProximityPrompt.Enabled = true;
        ProximityPrompt.Name = "HarvestPrompt";
        ProximityPrompt.ActionText = "Harvest";
        ProximityPrompt.HoldDuration = 0;
        ProximityPrompt:AddTag("HarvestPrompt");
    else
        local v160 = p155:GetAttribute("CorePartName");
        local v161 = p155:GetAttribute("SizeMulti") or 1;
        local v162 = p155:GetAttribute("Mutation");
        local v163 = SellValueData[v160] or 100;
        local v164 = not v162 and 1 or MutationData.ReturnPriceMultiplier(v162);
        math.floor(v163 * v161 ^ 3 * v164);
        ProximityPrompt.Name = "StealPrompt";
        ProximityPrompt.ActionText = "Steal";
        ProximityPrompt:AddTag("StealPrompt");

        if StealFlags.IsPlantStealable(v160) then
            ProximityPrompt.HoldDuration = StealFlags.GetStealHoldDuration(v160);
        else
            ProximityPrompt.HoldDuration = 0;
        end;
    end;

    ProximityPrompt.Parent = v158;
end;

function u1.RemoveFruitHarvestPrompt(p165, p166) -- Line: 611
    local v167 = p166:FindFirstChild("HarvestPrompt", true) or p166:FindFirstChild("StealPrompt", true);

    if v167 then
        v167:Destroy();
    end;
end;

function u1._StepFruitVisual(p168, p169, p170) -- Line: 618
    -- upvalues: u3 (copy), u7 (copy), u8 (copy), u10 (copy), PlantVisualizerController (copy), u5 (copy), reportFruitWorldPosition (copy)
    local v171 = u3[p169];

    if not (v171 and v171.Parent) then
        u7[p169] = nil;
        u8[p169] = nil;
        u10[p169] = nil;

        return;
    end;

    local v172 = tonumber(v171:GetAttribute("UserId"));

    if v172 and PlantVisualizerController:HasOfflineCutsceneSnapshot(v172) then
        return;
    end;

    local v173 = u5[p169];

    if not v173 then
        return;
    end;

    local v174 = v173.CurrentAge or 0;
    local v175 = math.min(v174 + p170 * v173.GrowthRate, v173.MaxAge);
    local v176 = v174 < v173.MaxAge;
    local v177 = v173.MaxAge <= v175;
    v173.CurrentAge = v175;
    local _ = v173.MaxAge;
    local _ = v173.OvertimeGrowth or 1;
    v171:SetAttribute("Age", v175);

    if v176 and v177 then
        local v178 = v171:GetAttribute("FruitId");
        local v179 = v171:GetAttribute("PlantId");
        p168:AddFruitHarvestPrompt(v171, v179, v178);
        u7[p169] = nil;
        u8[p169] = true;
        local v180 = u5[p169];

        if v180 and v180.GrowsForever then
            if type(v180.FinishedGrowingAt) ~= "number" or v180.FinishedGrowingAt <= 0 then
                v180.FinishedGrowingAt = workspace:GetServerTimeNow();
            end;

            u10[p169] = true;
        end;

        reportFruitWorldPosition(v179, v178, v171);
    end;
end;

function u1.UpdateFruitAges(p181, p182) -- Line: 659
    -- upvalues: u6 (ref), u7 (copy), u5 (copy), u22 (ref)
    if u6 then
        return;
    end;

    debug.profilebegin("Controllers/FruitVisualizerController/UpdateFruitAges/accumulate");
    local v183 = 0;

    for i in u7 do
        local v184 = u5[i];

        if v184 then
            v184._pendingDt = (v184._pendingDt or 0) + p182;
        end;

        v183 = v183 + 1;
    end;

    debug.profileend();

    if v183 == 0 then
        u22 = nil;

        return;
    end;

    debug.profilebegin("Controllers/FruitVisualizerController/UpdateFruitAges/iterateGrowingFruits");
    local v185 = math.min(150, v183);
    local v186 = u22;

    if v186 ~= nil and not u7[v186] then
        v186 = nil;
    end;

    local v187 = 0;

    while v187 < v185 do
        local v188 = next(u7, v186);

        if v188 == nil then
            v188 = next(u7, nil);

            if v188 == nil then
                break;
            end;
        end;

        local v189 = u5[v188];
        local v190 = v189 and (v189._pendingDt or 0) or 0;

        if v189 then
            v189._pendingDt = 0;
        end;

        p181:_StepFruitVisual(v188, v190);
        v187 = v187 + 1;
        v186 = v188;
    end;

    u22 = v186;
    debug.profileend();
end;

function u1.UpdateForeverGrowth(p191) -- Line: 717
    -- upvalues: u6 (ref), u10 (copy), u3 (copy), u5 (copy), applyForeverGrowthScale (copy)
    if u6 then
        return;
    end;

    debug.profilebegin("Controllers/FruitVisualizerController/UpdateForeverGrowth");

    for i, _ in u10 do
        local v192 = u3[i];

        if v192 and v192.Parent then
            local v193 = u5[i];

            if v193 then
                applyForeverGrowthScale(v192, v193);
            else
                u10[i] = nil;
            end;
        else
            u10[i] = nil;
        end;
    end;

    debug.profileend();
end;

function u1.UpdateFruitGrowthData(p194, p195, p196, p197, p198, p199, p200) -- Line: 739
    -- upvalues: u6 (ref), PlantVisualizerController (copy), u5 (copy), u3 (copy), u7 (copy), u8 (copy), u10 (copy)
    if u6 then
        return;
    end;

    if PlantVisualizerController:HasOfflineCutsceneSnapshot(p195) then
        return;
    end;

    local v201 = `{p195}_{p196}_{p197}`;
    local v202 = u5[v201];

    if not v202 then
        return;
    end;

    local v203 = v202.CurrentAge < v202.MaxAge;
    v202.GrowthRate = p199;

    if p200 ~= nil then
        v202.BoostSources = p200;
    end;

    local v204 = math.max(p198, v202.CurrentAge);
    local v205 = math.min(v204, v202.MaxAge);
    v202.CurrentAge = v205;
    local v206 = v202.MaxAge <= v205;
    local v207 = u3[v201];

    if v207 and v207.Parent then
        local _ = v202.MaxAge;
        local _ = v202.OvertimeGrowth or 1;
        v207:SetAttribute("Age", v205);

        if v203 and v206 then
            p194:AddFruitHarvestPrompt(v207, p196, p197);
        end;
    end;

    local v208 = u5[v201];

    if not v208 then
        u7[v201] = nil;
        u8[v201] = nil;

        return;
    end;

    local v209 = v208.CurrentAge or 0;
    local v210 = v208.MaxAge or 0;
    local v211;

    if v210 > 0 then
        v211 = v210 <= v209;
    else
        v211 = false;
    end;

    if v211 then
        u7[v201] = nil;
        u8[v201] = true;
        local v212 = u5[v201];

        if v212 and v212.GrowsForever then
            if type(v212.FinishedGrowingAt) ~= "number" or v212.FinishedGrowingAt <= 0 then
                v212.FinishedGrowingAt = workspace:GetServerTimeNow();
            end;

            u10[v201] = true;
        end;
    else
        u8[v201] = nil;
        u7[v201] = true;
        u10[v201] = nil;
    end;
end;

function u1.SyncFruitAges(p213, p214, p215, p216) -- Line: 776
    -- upvalues: u6 (ref), PlantVisualizerController (copy), u5 (copy), u3 (copy), u7 (copy), u8 (copy), u10 (copy)
    if u6 then
        return;
    end;

    if PlantVisualizerController:HasOfflineCutsceneSnapshot(p214) then
        return;
    end;

    for i, v in p216 do
        local v217 = `{p214}_{p215}_{i}`;
        local v218 = u5[v217];
        local v219 = u3[v217];

        if v218 then
            local v220 = v218.CurrentAge < v218.MaxAge;
            local v221 = math.max(v, v218.CurrentAge);

            if v218.CurrentAge >= v218.MaxAge and v < v218.MaxAge then
                v221 = v218.MaxAge;
            end;

            local v222 = math.min(v221, v218.MaxAge);
            local v223 = v218.MaxAge <= v222;
            v218.CurrentAge = v222;

            if v220 and (v223 and v219) then
                p213:AddFruitHarvestPrompt(v219, p215, i);
            end;
        end;

        if v219 then
            if v218 then
                local v = v218.CurrentAge or v;
            end;

            if v218 then
                local _ = v218.MaxAge;
                local _ = v218.MaxAge <= v;
                local _ = v218.OvertimeGrowth or 1;
                v219:SetAttribute("Age", v);
            else
                v219:SetAttribute("Age", v);
            end;
        end;

        local v224 = u5[v217];

        if v224 then
            local v225 = v224.CurrentAge or 0;
            local v226 = v224.MaxAge or 0;
            local v227;

            if v226 > 0 then
                v227 = v226 <= v225;
            else
                v227 = false;
            end;

            if v227 then
                u7[v217] = nil;
                u8[v217] = true;
                local v228 = u5[v217];

                if v228 and v228.GrowsForever then
                    if type(v228.FinishedGrowingAt) ~= "number" or v228.FinishedGrowingAt <= 0 then
                        v228.FinishedGrowingAt = workspace:GetServerTimeNow();
                    end;

                    u10[v217] = true;
                end;
            else
                u8[v217] = nil;
                u7[v217] = true;
                u10[v217] = nil;
            end;
        else
            u7[v217] = nil;
            u8[v217] = nil;
        end;
    end;
end;

function u1.GetPlantModel(p229, p230, p231) -- Line: 816
    -- upvalues: PlantVisualizerController (copy)
    local v232 = `{p230}_{p231}`;
    local v233 = PlantVisualizerController:GetPlantsFolder(p230);

    if v233 then
        return v233:FindFirstChild(v232);
    end;

    return nil;
end;

function u1.WaitForPlantModel(p234, p235, p236) -- Line: 824
    -- upvalues: PlantVisualizerController (copy)
    local v237 = os.clock();
    local v238 = `{p235}_{p236}`;
    local v239 = nil;

    while os.clock() - v237 < 10 do
        v239 = PlantVisualizerController:GetPlantsFolder(p235);

        if v239 then
            break;
        end;

        task.wait();
    end;

    if not v239 then
        return nil;
    end;

    local v240 = v239:FindFirstChild(v238);

    while not v240 and os.clock() - v237 < 10 do
        task.wait();
        v240 = v239:FindFirstChild(v238);
    end;

    if not v240 then
        return nil;
    end;

    while not v240:HasTag("InitializationComplete") and os.clock() - v237 < 10 do
        task.wait();
    end;

    if not v240:HasTag("InitializationComplete") then
        return nil;
    end;

    while v240:GetAttribute("PlantGrowthReady") ~= true and os.clock() - v237 < 10 do
        task.wait();
    end;

    if v240:GetAttribute("PlantGrowthReady") == true then
        return v240;
    end;

    return nil;
end;

function u1.ApplyOversizedCollision(p241, u242, p243) -- Line: 856
    -- upvalues: FruitFlags (copy)
    local u244 = FruitFlags.MaxCollidableExtentStuds:Get();

    if p243 <= u244 then
        return;
    end;

    local function evaluate() -- Line: 875
        -- upvalues: u242 (copy), u244 (copy)
        local _, v245 = u242:GetBoundingBox();

        if u244 >= math.max(v245.X, v245.Y, v245.Z) then
            return;
        end;

        for _, v in u242:QueryDescendants("BasePart[CanCollide = true]") do
            v.CanCollide = false;
        end;
    end;

    local _, v246 = u242:GetBoundingBox();

    if u244 < math.max(v246.X, v246.Y, v246.Z) then
        for _, v in u242:QueryDescendants("BasePart[CanCollide = true]") do
            v.CanCollide = false;
        end;
    end;

    u242:GetAttributeChangedSignal("Age"):Connect(evaluate);
end;

function u1.SpawnFruitFromData(p247, p248, p249, p250, p251) -- Line: 891
    -- upvalues: u3 (copy), u6 (ref), GardenSyncController (copy), FruitIdentity (copy), u4 (copy), Fruits (copy), FruitGrowRate (copy), PlantVisualizerController (copy), u5 (copy), PlantBehaviorRules (copy), Networking (copy), PlantInstanceDiet (copy), u7 (copy), u8 (copy), u10 (copy), reportFruitWorldPosition (copy)
    local v252 = `{p248}_{p249}_{p250}`;

    if u3[v252] then
        if u6 then
            return;
        end;

        p247:RemoveFruitById(p248, p249, p250);
    end;

    local v253 = p247:WaitForPlantModel(p248, p249);

    if not v253 then
        return;
    end;

    local v254 = GardenSyncController:GetPlant(p248, p249);

    if not v254 then
        return;
    end;

    local PlantName = v254.PlantName;

    if not PlantName then
        return;
    end;

    local v255 = FruitIdentity.ResolveFruitName(PlantName);
    local v256 = u4[v255];

    if not v256 then
        return;
    end;

    local FruitSpawnLocations = v253:FindFirstChild("FruitSpawnLocations");

    if not FruitSpawnLocations then
        return;
    end;

    local v257 = FruitSpawnLocations:GetChildren()[p251.SpawnLocationIndex];

    if not (v257 and v257:IsA("BasePart")) then
        return;
    end;

    local v258 = Fruits:FindFirstChild(v255);

    if not v258 then
        return;
    end;

    local v259 = v258:Clone();
    v259.Name = v252;
    v259:SetAttribute("FruitId", p250);
    v259:SetAttribute("PlantId", p249);
    v259:SetAttribute("UserId", p248);
    v259:SetAttribute("MaxAge", p251.MaxAge);
    v259:SetAttribute("SizeMulti", p251.SizeMultiplier or 1);
    v259:SetAttribute("CorePartName", v255);
    v259:SetAttribute("PlantSeed", v254.Seed or 0);
    local Fruits3 = v253:FindFirstChild("Fruits");

    if not Fruits3 then
        Fruits3 = Instance.new("Folder");
        Fruits3.Name = "Fruits";
        Fruits3.Parent = v253;
    end;

    local v260 = p251.Age or 0;
    local v261 = p251.GrowRate or FruitGrowRate(PlantName);
    local v262 = p251.OvertimeGrowth or 1;
    local v263 = PlantVisualizerController:GetOfflineCutsceneOldFruitAge(p248, p249, p250);
    local v264 = v263 ~= nil;

    if not v264 then
        v263 = v260;
    end;

    u5[v252] = {
        CurrentAge = v263,
        GrowthRate = v261,
        MaxAge = p251.MaxAge,
        OvertimeGrowth = v262,
        BoostSources = p251.BoostSources or 0,
        _syncedAge = v260,
        GrowsForever = PlantBehaviorRules.GrowsForever(PlantName),
        SizeMultiplier = p251.SizeMultiplier or 1,
        FinishedGrowingAt = p251.FinishedGrowingAt,
        UserId = p248,
        PlantId = p249,
        FruitId = p250
    };
    v259:SetAttribute("Age", v263);
    v259:SetAttribute("Mutation", p251.Mutation);
    v259:PivotTo(v257.CFrame);
    v256.InitFruit(v259, p251.Seed, (p251.SizeMultiplier or 1) * FruitIdentity.GetVisualScale(PlantName));
    Networking.ObjectPositionService.CreateServerValue:Fire(p249, p250, v257.Position);

    repeat
        task.wait();
    until v259:HasTag("InitializationComplete");

    local _, v265 = v259:GetBoundingBox();
    local v266 = math.max(v265.X, v265.Y, v265.Z);
    v256.BeginFruitGrowth(v259);
    p247:ApplyOversizedCollision(v259, v266);
    PlantInstanceDiet.Apply(v259, v255);
    v259.Parent = Fruits3;

    if v264 then
        v259:SetAttribute("Age", v263);
        u5[v252].CurrentAge = v263;
    end;

    u3[v252] = v259;
    local v267 = u5[v252];

    if v267 then
        local v268 = v267.CurrentAge or 0;
        local v269 = v267.MaxAge or 0;
        local v270;

        if v269 > 0 then
            v270 = v269 <= v268;
        else
            v270 = false;
        end;

        if v270 then
            u7[v252] = nil;
            u8[v252] = true;
            local v271 = u5[v252];

            if v271 and v271.GrowsForever then
                if type(v271.FinishedGrowingAt) ~= "number" or v271.FinishedGrowingAt <= 0 then
                    v271.FinishedGrowingAt = workspace:GetServerTimeNow();
                end;

                u10[v252] = true;
            end;
        else
            u8[v252] = nil;
            u7[v252] = true;
            u10[v252] = nil;
        end;
    else
        u7[v252] = nil;
        u8[v252] = nil;
    end;

    local v272 = u5[v252];

    if v272 then
        v260 = v272.CurrentAge or v260;
    end;

    if v272 then
        local _ = v272.OvertimeGrowth;
    end;

    if not v264 and (v272 and v272.MaxAge or p251.MaxAge) <= v260 then
        p247:AddFruitHarvestPrompt(v259, p249, p250);
        reportFruitWorldPosition(p249, p250, v259);
    end;
end;

function u1.RemoveFruitById(p273, p274, p275, p276) -- Line: 1024
    -- upvalues: u3 (copy), u5 (copy), u7 (copy), u8 (copy), u10 (copy), u9 (copy)
    local v277 = `{p274}_{p275}_{p276}`;
    local v278 = u3[v277];

    if v278 then
        v278:Destroy();
        u3[v277] = nil;
        u5[v277] = nil;
        u7[v277] = nil;
        u8[v277] = nil;
        u10[v277] = nil;
        u9[v277] = nil;
    end;
end;

function u1.UpdateFruitOvertimeGrowth(p279, p280, p281, p282, p283) -- Line: 1039
    -- upvalues: u6 (ref), u5 (copy)
    if u6 then
        return;
    end;

    local v284 = u5[`{p280}_{p281}_{p282}`];

    if v284 then
        v284.OvertimeGrowth = p283;
    end;
end;

function u1.SetOfflineCutsceneState(u285, p286) -- Line: 1053
    -- upvalues: u6 (ref)
    u6 = p286;

    if not p286 then
        u285:AddMissingPrompts();
        u285:ResyncForeverGrowth();
        task.delay(2, function() -- Line: 1063
            -- upvalues: u285 (copy)
            u285:ResyncForeverGrowth();
        end);
    end;
end;

function u1.ResyncForeverGrowth(p287) -- Line: 1072
    -- upvalues: u3 (copy), u5 (copy), GardenSyncController (copy), u10 (copy)
    for i, v in u3 do
        if v and v.Parent then
            local v288 = u5[i];

            if v288 and v288.GrowsForever then
                local v289 = tonumber(v:GetAttribute("UserId"));
                local v290 = v:GetAttribute("PlantId");
                local v291 = v:GetAttribute("FruitId");

                if v289 and (v290 and v291) then
                    local v292 = GardenSyncController:GetPlant(v289, v290);
                    local v293 = v292 and v292.Fruits and v292.Fruits[v291];

                    if v293 then
                        local v294 = v293.MaxAge or (v288.MaxAge or 0);

                        if v294 > 0 and (v293.Age or 0) >= v294 then
                            local FinishedGrowingAt = v293.FinishedGrowingAt;

                            if type(FinishedGrowingAt) == "number" and FinishedGrowingAt > 0 then
                                v288.FinishedGrowingAt = FinishedGrowingAt;
                            elseif type(v288.FinishedGrowingAt) ~= "number" or v288.FinishedGrowingAt <= 0 then
                                v288.FinishedGrowingAt = os.time();
                            end;

                            v288.CurrentAge = v294;
                            u10[i] = true;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

function u1.AddMissingPrompts(p295) -- Line: 1101
    -- upvalues: u3 (copy), u5 (copy)
    for i, v in u3 do
        if v and (v.Parent and not (v:FindFirstChild("HarvestPrompt", true) or v:FindFirstChild("StealPrompt", true))) then
            local v296 = u5[i];

            if v296 and v296.CurrentAge >= v296.MaxAge then
                local v297 = v:GetAttribute("PlantId");
                local v298 = v:GetAttribute("FruitId");

                if v297 and v298 then
                    p295:AddFruitHarvestPrompt(v, v297, v298);
                end;
            end;
        end;
    end;
end;

function u1.GetSpawnedFruit(p299, p300, p301, p302) -- Line: 1119
    -- upvalues: u3 (copy)
    return u3[`{p300}_{p301}_{p302}`];
end;

function u1.GetFruitGrowthData(p303, p304, p305, p306) -- Line: 1124
    -- upvalues: u5 (copy)
    return u5[`{p304}_{p305}_{p306}`];
end;

function u1.FixFruitAgeAfterFailedCutscene(p307, p308, p309, p310, p311) -- Line: 1129
    -- upvalues: u3 (copy), u5 (copy)
    local v312 = `{p308}_{p309}_{p310}`;
    local v313 = u3[v312];
    local v314 = u5[v312];

    if v313 and (v314 and p311.Age) then
        v313:SetAttribute("Age", p311.Age);
        v314.CurrentAge = p311.Age;

        if p311.OvertimeGrowth then
            v314.OvertimeGrowth = p311.OvertimeGrowth;
        end;

        if p311.Age >= p311.MaxAge then
            p307:AddFruitHarvestPrompt(v313, p309, p310);
        end;
    end;
end;

return u1;