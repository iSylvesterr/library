-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local AssetCmds = require(ReplicatedStorage.Library.Client.AssetCmds);
local AreaEggs = require(ReplicatedStorage.Library.Types.AreaEggs);
local Assets = require(ReplicatedStorage.Directory.Assets);
local BaseUpgradeClient = require(ReplicatedStorage.Library.Client.BaseUpgradeClient);
local BaseUpgradeTransitionLifecycle = require(ReplicatedStorage.Library.Client.BaseUpgradeTransitionLifecycle);
local EggCmds = require(ReplicatedStorage.Library.Client.EggCmds);
local Signal = require(ReplicatedStorage.Library.Modules.Packages.Signal);
local GuardAreaLookupUtil = require(ReplicatedStorage.Library.Util.GuardAreaLookupUtil);
local PlacedEggRenderer = require(ReplicatedStorage.Library.Client.Eggs.PlacedEggRenderer);
local PlotCmds = require(ReplicatedStorage.Library.Client.PlotCmds);
local Player = require(ReplicatedStorage.Library.Player);
local Save = require(ReplicatedStorage.Library.Client.Save);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local u1 = {};
u1.__index = u1;
u1.__class = "MilestoneAdapter";
local LocalPlayer = Players.LocalPlayer;
local Main = require(LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("GUI"):WaitForChild("BackpackController"):WaitForChild("Main"));
local __OBJECTS = Workspace.__OBJECTS;
local v2 = __OBJECTS:IsA("Folder");
assert(v2, "Workspace.__OBJECTS must be a Folder");
local Areas = __OBJECTS.Areas;
local v3 = Areas:IsA("Folder");
assert(v3, "Workspace.__OBJECTS.Areas must be a Folder");
local SeparationLine = Areas.SeparationLine;
local v4 = SeparationLine:IsA("BasePart");
assert(v4, "Workspace.__OBJECTS.Areas.SeparationLine must be a BasePart");

function u1.new() -- Line: 69
    -- upvalues: u1 (copy), Signal (copy), Trove (copy)
    local v5 = setmetatable({}, u1);
    v5.Changed = Signal.new();
    v5._areaEggCarryState = nil;
    v5._destroyed = false;
    v5._hatchedEgg = false;
    v5._hadPlacedPet = false;
    v5._knownEggCount = 0;
    v5._treadmillIntroFinished = false;
    v5._trove = Trove.new();
    v5:_bindObservers();

    return v5;
end;

function u1._fireChanged(p6) -- Line: 90
    p6.Changed:Fire();
end;

function u1._getSaveData(p7) -- Line: 94
    -- upvalues: Save (copy)
    return Save.Get();
end;

function u1._getEquippedTool(p8, p9) -- Line: 98
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;

    if Character == nil then
        return nil;
    end;

    for _, child in ipairs(Character:GetChildren()) do
        if child:IsA("Tool") and child:GetAttribute("ItemType") == p9 then
            return child;
        end;
    end;

    return nil;
end;

local function countUnplacedEggs(p10) -- Line: 111
    if p10 == nil then
        return 0;
    end;

    local v11 = 0;

    for _, v in pairs(p10.EggInventory) do
        if v.Placement == nil then
            v11 = v11 + 1;
        end;
    end;

    return v11;
end;

local function getPlacedEggCount(p12) -- Line: 125
    if p12 == nil then
        return 0;
    end;

    local v13 = 0;

    for _, v in pairs(p12.EggInventory) do
        if v.Placement ~= nil then
            v13 = v13 + 1;
        end;
    end;

    return v13;
end;

local function getTotalEggCount(p14) -- Line: 139
    if p14 == nil then
        return 0;
    end;

    local v15 = 0;

    for _ in pairs(p14.EggInventory) do
        v15 = v15 + 1;
    end;

    return v15;
end;

local function getEggGrowthTime(p16) -- Line: 151
    -- upvalues: Assets (copy)
    local v17 = Assets.Directory[p16];
    local v18 = `Missing asset config for {p16}`;
    assert(v17 ~= nil, v18);

    return v17.Egg.GrowthTime;
end;

function u1._getLowestHatchTimeEggUid(p19) -- Line: 157
    -- upvalues: Assets (copy)
    local v20 = p19:_getSaveData();

    if v20 == nil then
        return nil;
    end;

    local v21 = (1 / 0);
    local v22 = nil;

    for i, v in pairs(v20.EggInventory) do
        if v.Placement == nil then
            local AssetCategory = v.AssetCategory;
            local v23 = Assets.Directory[AssetCategory];
            local v24 = `Missing asset config for {AssetCategory}`;
            assert(v23 ~= nil, v24);
            local GrowthTime = v23.Egg.GrowthTime;

            if GrowthTime < v21 then
                v22 = i;
                v21 = GrowthTime;
            end;
        end;
    end;

    return v22;
end;

function u1._bindCharacterTools(u25, p26) -- Line: 179
    if p26 == nil then
        return;
    end;

    u25._trove:Connect(p26.ChildAdded, function(p27) -- Line: 184
        -- upvalues: u25 (copy)
        if p27:IsA("Tool") then
            u25:_fireChanged();
        end;
    end);
    u25._trove:Connect(p26.ChildRemoved, function(p28) -- Line: 189
        -- upvalues: u25 (copy)
        if p28:IsA("Tool") then
            u25:_fireChanged();
        end;
    end);
end;

function u1._bindObservers(u29) -- Line: 196
    -- upvalues: LocalPlayer (copy), Save (copy), PlotCmds (copy), AssetCmds (copy), BaseUpgradeTransitionLifecycle (copy), PlacedEggRenderer (copy), EggCmds (copy)
    local Backpack = LocalPlayer:WaitForChild("Backpack");
    local v30 = Backpack:IsA("Backpack");
    assert(v30, "LocalPlayer.Backpack must be a Backpack");
    local v31 = u29:_getSaveData();
    local v32;

    if v31 == nil then
        v32 = 0;
    else
        v32 = 0;

        for _ in pairs(v31.EggInventory) do
            v32 = v32 + 1;
        end;
    end;

    u29._knownEggCount = v32;
    u29._trove:Add(Save.GetStatChangedSignal("EggInventory"):Connect(function() -- Line: 201
        -- upvalues: u29 (copy)
        local v33 = u29:_getSaveData();
        local v34;

        if v33 == nil then
            v34 = 0;
        else
            v34 = 0;

            for _ in pairs(v33.EggInventory) do
                v34 = v34 + 1;
            end;
        end;

        if v34 < u29._knownEggCount then
            u29._hatchedEgg = true;
        end;

        u29._knownEggCount = v34;
        u29:_fireChanged();
    end));
    u29._trove:Add(Save.GetStatChangedSignal("Inventory"):Connect(function() -- Line: 209
        -- upvalues: u29 (copy)
        u29:_fireChanged();
    end));
    u29._trove:Add(Save.GetStatChangedSignal("Money"):Connect(function() -- Line: 212
        -- upvalues: u29 (copy)
        u29:_fireChanged();
    end));
    u29._trove:Add(Save.GetStatChangedSignal("BaseUpgradeLevel"):Connect(function() -- Line: 215
        -- upvalues: u29 (copy)
        u29:_fireChanged();
    end));
    u29._trove:Add(PlotCmds.OnLocalPlotUpdated:Connect(function() -- Line: 218
        -- upvalues: u29 (copy)
        u29:_fireChanged();
    end));
    u29._trove:Add(AssetCmds.RuntimeSnapshotUpdated:Connect(function() -- Line: 221
        -- upvalues: AssetCmds (ref), LocalPlayer (ref), u29 (copy)
        local v35 = next(AssetCmds.GetOwnerRuntimeRecords(LocalPlayer.UserId)) ~= nil;

        if v35 == u29._hadPlacedPet then
            return;
        end;

        u29._hadPlacedPet = v35;
        u29:_fireChanged();
    end));
    u29._trove:Add(BaseUpgradeTransitionLifecycle.Completed:Connect(function() -- Line: 229
        -- upvalues: u29 (copy)
        u29:_fireChanged();
    end));
    u29._trove:Add(PlacedEggRenderer.LocalEggHatchStarted:Connect(function() -- Line: 232
        -- upvalues: u29 (copy)
        u29._hatchedEgg = true;
        u29:_fireChanged();
    end));
    u29._trove:Add(EggCmds.RuntimeOwnerUpdated:Connect(function(p36) -- Line: 236
        -- upvalues: LocalPlayer (ref), u29 (copy)
        if p36 == LocalPlayer.UserId then
            u29:_fireChanged();
        end;
    end));
    u29._trove:Add(EggCmds.AreaEggCarryStateChanged:Connect(function(p37) -- Line: 241
        -- upvalues: u29 (copy)
        u29._areaEggCarryState = p37;
        u29:_fireChanged();
    end));
    u29._trove:Add(EggCmds.AreaEggSnapshotUpdated:Connect(function() -- Line: 245
        -- upvalues: u29 (copy)
        u29:_fireChanged();
    end));
    u29._trove:Add(EggCmds.AreaEggUpdated:Connect(function() -- Line: 248
        -- upvalues: u29 (copy)
        u29:_fireChanged();
    end));
    u29._trove:Add(EggCmds.AreaEggRemoved:Connect(function() -- Line: 251
        -- upvalues: u29 (copy)
        u29:_fireChanged();
    end));
    u29._trove:Connect(Backpack.ChildAdded, function() -- Line: 254
        -- upvalues: u29 (copy)
        u29:_fireChanged();
    end);
    u29._trove:Connect(Backpack.ChildRemoved, function() -- Line: 257
        -- upvalues: u29 (copy)
        u29:_fireChanged();
    end);
    u29._trove:Connect(LocalPlayer.CharacterAdded, function(p38) -- Line: 260
        -- upvalues: u29 (copy)
        u29:_bindCharacterTools(p38);
        u29:_fireChanged();
    end);
    u29:_bindCharacterTools(LocalPlayer.Character);
    u29._hadPlacedPet = next(AssetCmds.GetOwnerRuntimeRecords(LocalPlayer.UserId)) ~= nil;
end;

function u1.HasStolenFirstEgg(p39) -- Line: 272
    local v40 = true;
    local v41 = p39:_getSaveData();
    local v42;

    if v41 == nil then
        v42 = 0;
    else
        v42 = 0;

        for _, v in pairs(v41.EggInventory) do
            if v.Placement == nil then
                v42 = v42 + 1;
            end;
        end;
    end;

    if v42 <= 0 then
        local v43 = p39:_getSaveData();
        local v44;

        if v43 == nil then
            v44 = 0;
        else
            v44 = 0;

            for _, v in pairs(v43.EggInventory) do
                if v.Placement ~= nil then
                    v44 = v44 + 1;
                end;
            end;
        end;

        v40 = v44 > 0;
    end;

    return v40;
end;

function u1.IsCarryingAreaEgg(p45) -- Line: 276
    local _areaEggCarryState = p45._areaEggCarryState;
    local v46;

    if _areaEggCarryState == nil then
        v46 = false;
    else
        v46 = _areaEggCarryState.IsCarrying;
    end;

    return v46;
end;

function u1.HasReturnedToPen(p47) -- Line: 281
    -- upvalues: Player (copy), PlotCmds (copy)
    local v48 = Player.Optional.HumanoidRootPart();
    local v49 = PlotCmds.GetPlotData();

    if v48 == nil or v49 == nil then
        return false;
    end;

    if PlotCmds.IsWorldPositionWithinLocalPlotBounds(v48.Position) then
        return true;
    end;

    local PetArea = v49.PetArea;
    local v50 = PetArea.CFrame:PointToObjectSpace(v48.Position);
    local v51 = PetArea.Size * 0.5;
    local v52 = math.clamp(v50.X, -v51.X, v51.X);
    local v53 = math.clamp(v50.Y, -v51.Y, v51.Y);
    local v54 = math.clamp(v50.Z, -v51.Z, v51.Z);
    local v55 = Vector3.new(v52, v53, v54);
    local v56 = PetArea.CFrame:PointToWorldSpace(v55);

    return (v48.Position - v56).Magnitude <= 18;
end;

function u1.HasEquippedEgg(p57) -- Line: 304
    return p57:_getEquippedTool("AssetEgg") ~= nil;
end;

function u1.HasPlacedEgg(p58) -- Line: 308
    local v59 = p58:_getSaveData();
    local v60;

    if v59 == nil then
        v60 = 0;
    else
        v60 = 0;

        for _, v in pairs(v59.EggInventory) do
            if v.Placement ~= nil then
                v60 = v60 + 1;
            end;
        end;
    end;

    return v60 > 0;
end;

function u1.HasHatchableEgg(p61) -- Line: 312
    -- upvalues: EggCmds (copy), LocalPlayer (copy)
    for i in pairs(EggCmds.GetOwnerRuntimeRecords(LocalPlayer.UserId)) do
        if EggCmds.IsLocalEggReady(i) then
            return true;
        end;
    end;

    return false;
end;

function u1.HasHatchedEgg(p62) -- Line: 321
    return p62._hatchedEgg;
end;

function u1.HasPlacedPet(p63) -- Line: 325
    return p63._hadPlacedPet;
end;

function u1.HasPetInInventory(p64) -- Line: 329
    if p64:_getEquippedTool("Asset") ~= nil then
        return true;
    end;

    local v65 = p64:_getSaveData();
    local v66;

    if v65 == nil then
        v66 = false;
    else
        v66 = next(v65.Inventory) ~= nil;
    end;

    return v66;
end;

function u1.IsLocalPlayerInGameplay(p67) -- Line: 338
    -- upvalues: Player (copy), GuardAreaLookupUtil (copy), SeparationLine (copy)
    local v68 = Player.Optional.HumanoidRootPart();
    local v69;

    if v68 == nil then
        v69 = false;
    else
        v69 = GuardAreaLookupUtil.IsInGameplaySide(SeparationLine, v68.Position);
    end;

    return v69;
end;

function u1.GetClosestAreaEggTarget(p70) -- Line: 343
    -- upvalues: Player (copy), EggCmds (copy), AreaEggs (copy)
    local v71 = Player.Optional.HumanoidRootPart();
    local v72 = not v71 and Vector3.new(0, 0, 0) or v71.Position;
    local v73 = (1 / 0);
    local v74 = nil;

    for _, v in ipairs(EggCmds.GetAreaEggSnapshot().Records) do
        if v.State == AreaEggs.States.Slot and string.find(v.Uid, "FirstAreaEgg_", 1, true) == 1 then
            local Magnitude = (v.BottomCFrame.Position - v72).Magnitude;

            if Magnitude < v73 then
                v74 = v.BottomCFrame.Position;
                v73 = Magnitude;
            end;
        end;
    end;

    return v74;
end;

function u1.GetGameplayExitTarget(p75) -- Line: 364
    -- upvalues: SeparationLine (copy), Player (copy)
    local v76 = SeparationLine.Position + Vector3.new(0, 3, 0) - SeparationLine.CFrame.LookVector.Unit * 1;
    local v77 = Player.Optional.HumanoidRootPart();

    if v77 == nil then
        return v76;
    end;

    return Vector3.new(v76.X, v76.Y, v77.Position.Z);
end;

function u1.GetGameplayEntryTarget(p78) -- Line: 372
    -- upvalues: SeparationLine (copy)
    return SeparationLine.Position + Vector3.new(0, 3, 0) + SeparationLine.CFrame.LookVector.Unit * 1;
end;

function u1.GetPlotSpawnTarget(p79) -- Line: 378
    -- upvalues: PlotCmds (copy)
    local v80 = PlotCmds.GetPlotData();

    if v80 == nil then
        return nil;
    end;

    local RespawnPointCFrame = v80.RespawnPointCFrame;

    if RespawnPointCFrame then
        return RespawnPointCFrame.Position;
    end;

    return v80.CenterPoint.Position;
end;

function u1.GetEggPlacementBillboardCFrame(p81) -- Line: 387
    -- upvalues: PlotCmds (copy), Player (copy)
    local v82 = PlotCmds.GetPlotData();
    local v83 = Player.Optional.HumanoidRootPart();

    if v82 == nil or (v83 == nil or v82.RespawnPointCFrame == nil) then
        return nil;
    end;

    local PetArea = v82.PetArea;
    local RespawnPointCFrame = v82.RespawnPointCFrame;
    local v84 = PetArea.CFrame:PointToObjectSpace(v83.Position);
    local v85 = PetArea.Size * 0.5;
    local v86 = math.clamp(v84.X, -v85.X, v85.X);
    local Y = v85.Y;
    local v87 = math.clamp(v84.Z, -v85.Z, v85.Z);
    local v88 = Vector3.new(v86, Y, v87);
    local v89 = PetArea.CFrame:PointToWorldSpace(v88);
    local v90 = RespawnPointCFrame + RespawnPointCFrame.LookVector * 13;

    return CFrame.new(v90.Position.X, v89.Y, v90.Position.Z);
end;

function u1.GetNearestHatchableEggTarget(p91) -- Line: 408
    -- upvalues: Player (copy), EggCmds (copy), LocalPlayer (copy), PlotCmds (copy)
    local v92 = Player.Optional.HumanoidRootPart();
    local v93 = not v92 and Vector3.new(0, 0, 0) or v92.Position;
    local v94 = (1 / 0);
    local v95 = nil;

    for i, v in pairs(EggCmds.GetOwnerRuntimeRecords(LocalPlayer.UserId)) do
        if v.Placement ~= nil and EggCmds.IsLocalEggReady(i) then
            local v96 = PlotCmds.GetPlotData();

            if v96 ~= nil then
                local Position = (v96.CenterPoint.CFrame * v.Placement.LocalCFrame).Position;
                local Magnitude = (Position - v93).Magnitude;

                if Magnitude < v94 then
                    v95 = Position;
                    v94 = Magnitude;
                end;
            end;
        end;
    end;

    return v95;
end;

function u1.GetEggHotbarTarget(p97) -- Line: 432
    -- upvalues: Main (copy)
    local v98 = p97:_getLowestHatchTimeEggUid();

    if v98 then
        return Main:GetEggSlotFrame(v98);
    end;

    return nil;
end;

function u1.ForceBestEggIntoHotbar(p99) -- Line: 437
    -- upvalues: Main (copy)
    local v100 = p99:_getLowestHatchTimeEggUid();

    if v100 then
        return Main:ForceEggIntoTutorialHotbar(v100);
    end;

    return nil;
end;

function u1.HasPetToolEquipped(p101) -- Line: 442
    return p101:_getEquippedTool("Asset") ~= nil;
end;

function u1.CanAffordFirstBaseExpansion(p102) -- Line: 446
    -- upvalues: BaseUpgradeClient (copy)
    local v103 = p102:_getSaveData();
    local v104;

    if v103 == nil or v103.BaseUpgradeLevel ~= 0 then
        v104 = false;
    else
        v104 = BaseUpgradeClient.CanAffordNext(v103);
    end;

    return v104;
end;

function u1.HasFinishedFirstBaseExpansion(p105) -- Line: 451
    -- upvalues: BaseUpgradeTransitionLifecycle (copy)
    local v106 = p105:_getSaveData();
    local v107;

    if v106 == nil or v106.BaseUpgradeLevel <= 0 then
        v107 = false;
    else
        v107 = not BaseUpgradeTransitionLifecycle.IsPlaying();
    end;

    return v107;
end;

function u1.GetPlotUpgradeSignTarget(p108) -- Line: 456
    -- upvalues: PlotCmds (copy)
    local v109 = PlotCmds.GetPlotData();

    if v109 == nil then
        return nil;
    end;

    local PlotUpgrade = v109.PlotFolder:FindFirstChild("PlotUpgrade");

    if PlotUpgrade == nil or not PlotUpgrade:IsA("Model") then
        return nil;
    end;

    local Sign = PlotUpgrade:FindFirstChild("Sign");

    if Sign == nil or not Sign:IsA("BasePart") then
        return nil;
    end;

    return Sign;
end;

function u1.HasFinishedTreadmillIntro(p110) -- Line: 470
    return p110._treadmillIntroFinished;
end;

function u1.MarkTreadmillIntroFinished(p111) -- Line: 474
    if p111._treadmillIntroFinished then
        return;
    end;

    p111._treadmillIntroFinished = true;
    p111:_fireChanged();
end;

function u1.Destroy(p112) -- Line: 482
    p112._destroyed = true;
    p112._trove:Destroy();
    p112.Changed:Destroy();
end;

return u1;