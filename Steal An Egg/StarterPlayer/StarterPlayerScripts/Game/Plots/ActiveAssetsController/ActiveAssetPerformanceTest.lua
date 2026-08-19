-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Assets = require(ReplicatedStorage.Directory.Assets);
local Personalities = require(ReplicatedStorage.Directory.Assets.Personalities);
local AssetRuntime = require(ReplicatedStorage.Library.Types.AssetRuntime);
local AssetGenderUtil = require(ReplicatedStorage.Library.Util.AssetGenderUtil);
local AssetGenerationUtil = require(ReplicatedStorage.Library.Util.AssetGenerationUtil);
local EggItemUtil = require(ReplicatedStorage.Library.Util.EggItemUtil);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local PlotCmds = require(ReplicatedStorage.Library.Client.PlotCmds);
require(script.Parent.AssetBillboardController);
local AssetComponent = require(script.Parent.AssetComponent);
require(script.Parent.AssetMovementBatch);
local ActiveAssetPerformanceTestConfig = require(script.Parent.ActiveAssetPerformanceTestConfig);
local u1 = Log.new();
local u2 = Random.new();
local u3 = {};
local u4 = {};
local u5 = nil;
local u6 = nil;
local u7 = nil;

for i in pairs(Assets.Directory) do
    if i ~= "Frigo Camelo" then
        table.insert(u3, i);
    end;
end;

table.sort(u3);
assert(#u3 > 0, "Active asset performance test requires at least one eligible category");
local v8 = {};

local function buildRuntimeRecord(p9, p10) -- Line: 57
    -- upvalues: u3 (copy), u2 (copy), EggItemUtil (copy), AssetGenderUtil (copy), Personalities (copy), Players (copy), AssetGenerationUtil (copy), AssetRuntime (copy)
    local v11 = u3[u2:NextInteger(1, #u3)];
    local v12 = EggItemUtil.BuildSavedEgg(v11, u2);
    v12.AssetGender = AssetGenderUtil.ResolveForCategory(v11, nil, u2);
    v12.AssetPersonality = Personalities.Roll(u2);
    local v13 = EggItemUtil.BuildAssetItemData(v12);
    v13.HasBeenFirstPlaced = true;
    local v14 = `PERFORMANCE_TEST_{p9}_{p10}`;
    local v15 = {
        OwnerUserId = Players.LocalPlayer.UserId,
        UID = v14,
        ItemData = v13,
        MoneyPerSecond = AssetGenerationUtil.GetRate(v13, 0),
        Seed = u2:NextInteger(1, 2147483647)
    };
    local v16 = AssetRuntime.SchemaValidation.RuntimeAssetRecord(v15);
    assert(v16, "Invalid performance-test asset record");

    return v15;
end;

local function destroySlot(p17) -- Line: 76
    -- upvalues: u4 (copy), u5 (ref)
    local v18 = u4[p17];

    if v18 == nil then
        return;
    end;

    u4[p17] = nil;

    for _, v in ipairs(v18.Components) do
        u5:Remove(v:GetModel());
        v:Destroy();
    end;

    v18.Container:Destroy();
end;

local function activateSlot(p19, p20) -- Line: 89
    -- upvalues: u6 (ref), ActiveAssetPerformanceTestConfig (copy), buildRuntimeRecord (copy), AssetComponent (copy), Players (copy), u5 (ref), u7 (ref), u4 (copy), u1 (copy)
    local Folder = Instance.new("Folder");
    Folder.Name = `Plot{p19}`;
    Folder.Parent = u6;
    local v21 = {};

    for i = 1, ActiveAssetPerformanceTestConfig.PetsPerPlot do
        local v22 = buildRuntimeRecord(p19, i);
        local v23 = AssetComponent.new(v22, Players.LocalPlayer, p20, Folder, u5, u7, nil);
        u5:Add(v23:GetModel(), v22.ItemData, v22.MoneyPerSecond);
        table.insert(v21, v23);
    end;

    u4[p19] = {
        Area = p20,
        Components = v21,
        Container = Folder
    };
    u1:AtInfo():Log((`Created {ActiveAssetPerformanceTestConfig.PetsPerPlot} performance-test pets for plot {p19}`));
end;

local function syncSlot(p24) -- Line: 109
    -- upvalues: PlotCmds (copy), u4 (copy), destroySlot (copy), activateSlot (copy)
    local v25 = nil;
    local v26 = PlotCmds.GetPlotsFolder();
    local v27, v28;

    if v26 == nil then
        v27 = v25;
        v28 = false;
    else
        local v29 = v26:FindFirstChild((tostring(p24)));
        v28 = v29 ~= nil;
        local v30;

        if v29 == nil then
            v30 = nil;
        else
            v30 = v29:FindFirstChild("ToUpdate");
        end;

        if v30 == nil or not v30:IsA("Model") then
            v27 = nil;
        else
            v27 = v30:FindFirstChild("PetArea");
        end;

        if v27 == nil then
            v27 = v25;
        elseif not v27:IsA("BasePart") then
            v27 = v25;
        end;
    end;

    local v31 = u4[p24];

    if not v28 then
        destroySlot(p24);

        return;
    end;

    if v27 == nil then
        return;
    end;

    if v31 == nil then
        activateSlot(p24, v27);

        return;
    end;

    if v31.Area == v27 then
        return;
    end;

    v31.Area = v27;

    for _, v in ipairs(v31.Components) do
        v:SetAssetArea(v27);
    end;
end;

local function syncAllSlots() -- Line: 143
    -- upvalues: PlotCmds (copy), syncSlot (copy), u4 (copy), destroySlot (copy)
    local v32 = PlotCmds.GetPlotsFolder();
    local v33 = {};

    if v32 ~= nil then
        for _, child in ipairs(v32:GetChildren()) do
            local v34 = tonumber(child.Name);

            if v34 ~= nil then
                v33[v34] = true;
                syncSlot(v34);
            end;
        end;
    end;

    for i in pairs(u4) do
        if v33[i] ~= true then
            destroySlot(i);
        end;
    end;
end;

function v8.Start(p35, p36, p37) -- Line: 166
    -- upvalues: ActiveAssetPerformanceTestConfig (copy), u5 (ref), u7 (ref), u6 (ref), PlotCmds (copy), syncSlot (copy), syncAllSlots (copy)
    local v38;

    if ActiveAssetPerformanceTestConfig.PetsPerPlot > 0 then
        v38 = ActiveAssetPerformanceTestConfig.PetsPerPlot % 1 == 0;
    else
        v38 = false;
    end;

    assert(v38, "PetsPerPlot must be a positive integer");
    u5 = p36;
    u7 = p37;
    u6 = Instance.new("Folder");
    u6.Name = "PerformanceTestAssets";
    u6.Parent = p35;
    PlotCmds.OnAnyPlotUpdated:Connect(syncSlot);
    PlotCmds.OnPlotsFolderUpdated:Connect(syncAllSlots);
    syncAllSlots();
end;

return v8;