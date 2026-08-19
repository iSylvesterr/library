-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Functions = require(ReplicatedStorage.Library.Functions);
local Audio = require(ReplicatedStorage.Library.Audio);
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Signal = require(ReplicatedStorage.Library.Modules.Packages.Signal);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local Rarities = require(ReplicatedStorage.Directory.Rarity).Rarities;
local u1 = require(ReplicatedStorage.Library.Modules.Packages.Log).new():LimitUnderLevel("Debug");
require(script.Types);
local RenderStepped = require(ReplicatedStorage.Library.Functions.RenderStepped);
local Mutations = require(ReplicatedStorage.Library.Modules.Mutations);
local ItemDisplay = require(ReplicatedStorage.Library.Modules.ItemDisplay);
require(ReplicatedStorage.Library.Types.AssetItem);
local Assets = require(ReplicatedStorage.Directory.Assets);
local Personalities = require(ReplicatedStorage.Directory.Assets.Personalities);
local AssetModelStreaming = require(ReplicatedStorage.Library.Client.AssetModelStreaming);
local Directory = Assets.Directory;
local InstanceCache = require(ReplicatedStorage.Library.Modules.Packages.InstanceCache);
local GetAssetsSoundParams = require(ReplicatedStorage.Library.Util.GetAssetsSoundParams);
local BBFromArrayVisibleOnly = require(ReplicatedStorage.Library.Functions.BBFromArrayVisibleOnly);
local AssetSoundUtil = require(ReplicatedStorage.Library.Util.AssetSoundUtil);
local RarityNumber = Rarities.BrainrotGod.RarityNumber;
local u2 = {};
local __OBJECTS = workspace:WaitForChild("__OBJECTS");
local BrainrotRollModelPool = __OBJECTS:FindFirstChild("BrainrotRollModelPool");

if not BrainrotRollModelPool then
    BrainrotRollModelPool = Instance.new("Folder");
    assert(BrainrotRollModelPool, "luau");
    BrainrotRollModelPool.Name = "BrainrotRollModelPool";
    BrainrotRollModelPool.Parent = __OBJECTS;
end;

local v3 = {
    AnyBrainrotEggOpened = Signal.new(),
    LocalPlayerBrainrotEggOpened = Signal.new(),
    LocalPlayerBrainrotEggOpenCompleted = Signal.new()
};

local function setModelAnchoredState(p4, p5) -- Line: 88
    for _, descendant in ipairs(p4:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.Anchored = p5;
        end;
    end;
end;

local function setRollModelPhysics(p6, p7, p8) -- Line: 96
    for _, descendant in ipairs(p6:GetDescendants()) do
        if descendant:IsA("BasePart") then
            if p8 then
                if descendant == p6.PrimaryPart then
                    descendant.Anchored = p7;
                end;
            else
                descendant.Anchored = p7;
            end;

            descendant.CanCollide = false;
            descendant.CanQuery = false;
            descendant.CanTouch = false;
            descendant.Massless = true;
        end;
    end;
end;

local function stripHumanoidAndAnimation(p9) -- Line: 114
    -- upvalues: ItemDisplay (copy)
    ItemDisplay.StripRuntimeRig(p9, true, true);
end;

local function forceLoadRollAssetModels(p10) -- Line: 118
    -- upvalues: AssetModelStreaming (copy), u1 (copy)
    local v11 = {};
    local u12 = {};

    for _, v in ipairs(p10) do
        local Category = v.Category;

        if not v11[Category] then
            v11[Category] = true;
            table.insert(u12, Category);
        end;
    end;

    if #u12 == 0 then
        return true;
    end;

    local success, result = pcall(function() -- Line: 135
        -- upvalues: AssetModelStreaming (ref), u12 (copy)
        AssetModelStreaming.ForceLoadAssetModels(u12);
    end);

    if success then
        return true;
    end;

    u1:AtWarning():Log((`Roll asset model force-load failed: {tostring(result)}`));

    return false;
end;

local function createExternalRollModel(p13, p14, p15) -- Line: 146
    -- upvalues: AssetModelStreaming (copy), ItemDisplay (copy)
    if p15 ~= true then
        AssetModelStreaming.ForceLoadAssetModels({ p13.Category });
    end;

    local v16 = ItemDisplay.CreateActiveModel(nil, p13, true, true, true);
    ItemDisplay.StripRuntimeRig(v16, true, true);
    local FXPart = v16:FindFirstChild("FXPart");
    local v17 = p14 and ItemDisplay.CreateDataBillboard(v16, p13.Category, p13);

    if v17 then
        v17.Name = "AnimationBillboard";
        v17.MaxDistance = 80;
        v17.Enabled = true;
    end;

    return v16, FXPart;
end;

local function attachGroundPivotAnchor(p18, p19) -- Line: 171
    -- upvalues: BBFromArrayVisibleOnly (copy)
    local PivotAnchor = p18:FindFirstChild("PivotAnchor");

    if PivotAnchor and PivotAnchor:IsA("BasePart") then
        p18.PrimaryPart = PivotAnchor;

        return;
    end;

    local v20 = p18.PrimaryPart or p18:FindFirstChild("HumanoidRootPart");

    if not (v20 and v20:IsA("BasePart")) then
        return;
    end;

    if p19 then
        p18:PivotTo(p19);
    end;

    local v21, v22 = BBFromArrayVisibleOnly(p18);
    local v23 = v21.Position.Y - v22.Y * 0.5;
    local v24, v25;

    if p19 then
        v24 = Vector3.new(p19.Position.X, v23, p19.Position.Z);
        v25 = p19.Rotation;
    else
        v24 = v21.Position - Vector3.new(0, v22.Y * 0.5, 0);
        v25 = v20.CFrame.Rotation;
    end;

    local Part = Instance.new("Part");
    Part.Name = "PivotAnchor";
    Part.Size = Vector3.new(0.1, 0.1, 0.1);
    Part.Transparency = 1;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CanTouch = false;
    Part.Massless = true;
    Part.Anchored = v20.Anchored;
    Part.CFrame = v25 + v24;
    Part.Parent = p18;
    p18.PrimaryPart = Part;
    local WeldConstraint = Instance.new("WeldConstraint");
    WeldConstraint.Part0 = Part;
    WeldConstraint.Part1 = v20;
    WeldConstraint.Parent = Part;
end;

function stripModelForPooling(p26)
    -- upvalues: setModelAnchoredState (copy)
    local v27 = {};

    for _, descendant in ipairs(p26:GetDescendants()) do
        if descendant.Name == "InitialPoses" or (descendant:IsA("Motor6D") or (descendant:IsA("Motor") or (descendant:IsA("Bone") or descendant:IsA("Constraint") and descendant.Name ~= "WeldConstraint"))) or (descendant:IsA("AnimationController") or descendant:IsA("Animator")) then
            table.insert(v27, descendant);
        end;
    end;

    for _, v in ipairs(v27) do
        v:Destroy();
    end;

    setModelAnchoredState(p26, true);

    for _, descendant in ipairs(p26:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false;
            descendant.CanQuery = false;
            descendant.CanTouch = false;
            descendant.Massless = true;
        end;
    end;
end;

local function cleanupRollModel(p28) -- Line: 258
    -- upvalues: Mutations (copy)
    for _, descendant in ipairs(p28:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") then
            descendant:Destroy();
        end;
    end;

    stripModelForPooling(p28);
    Mutations.RemoveAllMutations(p28);
    local v29 = p28:GetAttribute("BrainrotRollBaseScale");

    if typeof(v29) ~= "number" then
        v29 = p28:GetScale();
        p28:SetAttribute("BrainrotRollBaseScale", v29);
    end;

    return v29;
end;

local function moveModelToHiddenSpace(p30) -- Line: 277
    -- upvalues: InstanceCache (copy), BrainrotRollModelPool (ref)
    p30:PivotTo(InstanceCache.GetRandomHiddenCFrame());
    p30.Parent = BrainrotRollModelPool;
end;

local function resolveRollDefaultScale(p31) -- Line: 282
    -- upvalues: Directory (copy)
    local v32 = Directory[p31.Category];

    return (v32 and (v32.BaseModelScale or 1) or 1) * (p31.Scale or 1);
end;

local function createRollModelForCategory(p33, p34) -- Line: 290
    -- upvalues: AssetModelStreaming (copy), Personalities (copy), ItemDisplay (copy), cleanupRollModel (copy)
    if p34 ~= true then
        AssetModelStreaming.ForceLoadAssetModels({ p33 });
    end;

    local v35 = ItemDisplay.CreateActiveModel(nil, {
        Scale = 1,
        HasBeenFirstPlaced = true,
        Category = p33,
        Mutations = {},
        Personality = Personalities.Personalities.Normal
    });
    cleanupRollModel(v35);

    return v35;
end;

local function acquirePooledRollModel(p36, p37, p38) -- Line: 308
    -- upvalues: u2 (copy), Directory (copy), cleanupRollModel (copy), setModelAnchoredState (copy), createRollModelForCategory (copy)
    local Category = p36.Category;
    local v39 = u2[Category];
    local v40 = Directory[p36.Category];
    local v41 = (v40 and (v40.BaseModelScale or 1) or 1) * (p36.Scale or 1);
    local v42 = p37 == nil and true or p37;

    if not v39 or #v39 <= 0 then
        local v43 = createRollModelForCategory(Category, p38);
        v43:ScaleTo(v41);

        if not v42 then
            setModelAnchoredState(v43, false);
        end;

        return v43, v41;
    end;

    local v44 = table.remove(v39);
    assert(v44, "pooled model missing");
    cleanupRollModel(v44);
    v44:ScaleTo(v41);

    if not v42 then
        setModelAnchoredState(v44, false);
    end;

    return v44, v41;
end;

local function releasePooledRollModel(p45, p46) -- Line: 343
    -- upvalues: u2 (copy), cleanupRollModel (copy), InstanceCache (copy), BrainrotRollModelPool (ref)
    local v47 = u2[p45];

    if not v47 then
        v47 = {};
        u2[p45] = v47;
    end;

    if #v47 >= 5 then
        p46:Destroy();

        return;
    end;

    p46:ScaleTo((cleanupRollModel(p46)));
    p46:PivotTo(InstanceCache.GetRandomHiddenCFrame());
    p46.Parent = BrainrotRollModelPool;
    table.insert(v47, p46);
end;

local function cloneArray(p48) -- Line: 362
    return p48 == nil and {} or table.clone(p48);
end;

local function cloneRollAssetItemData(p49) -- Line: 370
    local v50 = table.clone(p49);

    if v50.Mutations then
        local Mutations2 = v50.Mutations;
        v50.Mutations = Mutations2 == nil and {} or table.clone(Mutations2);
    end;

    return v50;
end;

local function buildRollAssetItemDatas(p51, u52, p53, p54) -- Line: 380
    if not u52 then
        return {}, 0;
    end;

    local v55;

    if p51 then
        v55 = p51.DropTable;
    else
        v55 = nil;
    end;

    local Category = u52.Category;
    local u56 = u52.Mutations or (p53 or {});
    local u57 = u52.Scale or (p54 or 1);
    local u58 = {};
    local u59 = {};
    local u60 = 0;

    local function addCategory(p61) -- Line: 399
        -- upvalues: u59 (copy), u56 (copy), u57 (copy), u52 (copy), Category (copy), u58 (copy), u60 (ref)
        if typeof(p61) ~= "string" or u59[p61] then
            return;
        end;

        u59[p61] = true;
        local v62 = {
            Category = p61
        };
        local v63 = u56;
        v62.Mutations = v63 == nil and {} or table.clone(v63);
        v62.Scale = u57;
        v62.Personality = u52.Personality;
        v62.HasBeenFirstPlaced = u52.HasBeenFirstPlaced;

        if p61 == Category then
            local Mutations2 = u52.Mutations;
            v62.Mutations = Mutations2 == nil and {} or table.clone(Mutations2);
            v62.Scale = u52.Scale or u57;
        end;

        table.insert(u58, v62);

        if p61 == Category then
            u60 = #u58;
        end;
    end;

    if v55 then
        for _, v in ipairs(v55) do
            local v64 = v[1];

            if v64 ~= Category then
                addCategory(v64);
            end;
        end;
    end;

    addCategory(Category);
    u60 = u60 == 0 and #u58 or u60;

    return u58, u60;
end;

local function applyBlackHighlight(p65) -- Line: 444
    local GuardCaughtRevealHighlight = p65:FindFirstChild("GuardCaughtRevealHighlight", true);

    if GuardCaughtRevealHighlight and GuardCaughtRevealHighlight:IsA("Highlight") then
        return;
    end;

    local v66 = p65:FindFirstChild("Model") or p65;
    local Highlight = Instance.new("Highlight");
    Highlight.Name = "GuardCaughtRevealHighlight";
    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
    Highlight.FillColor = Color3.new(0, 0, 0);
    Highlight.FillTransparency = 0;
    Highlight.OutlineColor = Color3.new(0, 0, 0);
    Highlight.OutlineTransparency = 1;
    Highlight.Parent = v66;
end;

local function playRollAnimation(u67, p68, u69, p70, p71, p72, p73, p74, p75, p76, u77) -- Line: 462
    -- upvalues: forceLoadRollAssetModels (copy), ItemDisplay (copy), applyBlackHighlight (copy), setRollModelPhysics (copy), attachGroundPivotAnchor (copy), Trove (copy), acquirePooledRollModel (copy), releasePooledRollModel (copy), RenderStepped (copy), Functions (copy), Audio (copy)
    local u78 = #p70;

    if u78 == 0 then
        return nil;
    end;

    if not forceLoadRollAssetModels(p70) then
        if u67 then
            u67.forceFinalize = nil;
        end;

        return nil;
    end;

    local v79 = p73 == nil and true or p73;
    local v80 = p74 == nil and true or p74;
    local v81 = p76 == true;
    local v82 = p68:IsA("BasePart");
    local v83;

    if v82 then
        v83 = p68;
    else
        v83 = nil;
    end;

    local u84 = false;
    local u85 = ItemDisplay.CreateActiveModel(nil, p70[p71], true, true, true);
    ItemDisplay.StripRuntimeRig(u85, true, true);
    u85:FindFirstChild("FXPart");
    u85.Parent = p68;
    applyBlackHighlight(u85);

    if v82 then
        for _, descendant in ipairs(u85:GetDescendants()) do
            if descendant:IsA("BasePart") then
                descendant.Massless = true;
                descendant.Anchored = v79;
                descendant.CanCollide = false;
                descendant.CanQuery = false;
                descendant.CanTouch = false;
            end;

            if descendant:IsA("MeshPart") then
                descendant.Transparency = 0;
            end;
        end;
    else
        setRollModelPhysics(u85, v79, true);
    end;

    if v81 then
        attachGroundPivotAnchor(u85, u69);
    end;

    u85:PivotTo(u69);

    if v82 then
        local WeldConstraint = Instance.new("WeldConstraint");
        WeldConstraint.Part0 = v83;
        WeldConstraint.Part1 = u85.PrimaryPart;
        WeldConstraint.Parent = u85.PrimaryPart;
    end;

    if u78 == 1 then
        if u77 ~= nil and not u84 then
            u77(u85);
        end;

        if u67 then
            u67.forceFinalize = nil;
        end;

        return u85;
    end;

    local function shouldFinalizeEarly() -- Line: 542
        -- upvalues: u67 (copy)
        local v86;

        if u67 == nil then
            v86 = false;
        else
            v86 = u67.forceFinalize == true;
        end;

        return v86;
    end;

    local v87;

    if u67 == nil then
        v87 = false;
    else
        v87 = u67.forceFinalize == true;
    end;

    if v87 then
        if u77 ~= nil and not u84 then
            u77(u85);
        end;

        if u67 then
            u67.forceFinalize = nil;
        end;

        return u85;
    end;

    local v88 = Trove.new();
    local u89 = table.create(u78);
    local u90 = table.create(u78);
    u89[p71] = u85;
    u90[p71] = u85:GetScale();

    for i, v in ipairs(p70) do
        if i ~= p71 then
            local v91, u92;

            if v80 then
                local v93;
                v93, v91 = acquirePooledRollModel(v, v79, true);
                u92 = v93;
                u92.Parent = p68;
            else
                local v94 = ItemDisplay.CreateActiveModel(nil, v, true, true, true);
                ItemDisplay.StripRuntimeRig(v94, true, true);
                v94:FindFirstChild("FXPart");
                u92 = v94;
                u92.Parent = p68;

                if v81 then
                    attachGroundPivotAnchor(u92, u69);
                end;

                v91 = u92:GetScale();
            end;

            applyBlackHighlight(u92);
            u92:PivotTo(u69);

            if v82 then
                for _, descendant in ipairs(u92:GetDescendants()) do
                    if descendant:IsA("BasePart") then
                        descendant.Massless = true;
                        descendant.Anchored = v79;
                        descendant.CanCollide = false;
                        descendant.CanQuery = false;
                        descendant.CanTouch = false;
                    end;
                end;
            else
                setRollModelPhysics(u92, v79, true);
            end;

            u90[i] = v91;
            u89[i] = u92;

            if v80 then
                v88:Add(function() -- Line: 607
                    -- upvalues: releasePooledRollModel (ref), v (copy), u92 (ref)
                    releasePooledRollModel(v.Category, u92);
                end);
            else
                v88:Add(function() -- Line: 611
                    -- upvalues: u92 (ref)
                    if u92 and u92.Parent then
                        u92:Destroy();
                    end;
                end);
            end;
        end;
    end;

    local v95;

    if u67 == nil then
        v95 = false;
    else
        v95 = u67.forceFinalize == true;
    end;

    if v95 then
        v88:Destroy();

        if u77 ~= nil and not u84 then
            u77(u85);
        end;

        if u67 then
            u67.forceFinalize = nil;
        end;

        return u85;
    end;

    local v96 = {};
    local u97 = 0;

    for i, v in ipairs(u89) do
        if v82 then
            local PrimaryPart = v.PrimaryPart;

            if i ~= p71 then
                local WeldConstraint = Instance.new("WeldConstraint");
                assert(v83, "luau");
                WeldConstraint.Part0 = v83;
                WeldConstraint.Part1 = PrimaryPart;
                WeldConstraint.Parent = PrimaryPart;
                table.insert(v96, WeldConstraint);
            end;
        end;
    end;

    local function updateModels(p98, p99) -- Line: 652
        -- upvalues: u97 (ref), u89 (copy), u90 (copy), u78 (copy)
        local v100 = os.clock();

        if not p99 and v100 - u97 < 0.03333333333333333 then
            return 0;
        end;

        u97 = v100;
        local Position = workspace.CurrentCamera.CFrame.Position;

        for i, v in ipairs(u89) do
            local v101 = u90[i] or 1;
            local v102 = math.clamp((p98 - (i - 1)) % u78 * 0.5, 0, 1) * 3.141592653589793;
            local v103 = v101 * math.sin(v102) * 1.01;
            local v104 = math.clamp(v103, 0.0001, v101);

            if (Position - v:GetPivot().Position).Magnitude <= 250 and v.Parent then
                v:ScaleTo(v104);
            end;
        end;
    end;

    updateModels(0);
    local u105 = u78 * 12 + p71;
    local u106 = u105 - 1;
    local u107 = 1 % u78;
    RenderStepped(function(p108, p109) -- Line: 696
        -- upvalues: u67 (copy), u105 (copy), Functions (ref), updateModels (copy), u78 (copy), u107 (ref), u106 (copy), Audio (ref), u69 (copy), u84 (ref), u77 (copy), u85 (copy)
        local v110;

        if u67 == nil then
            v110 = false;
        else
            v110 = u67.forceFinalize == true;
        end;

        if v110 then
            return true;
        end;

        local v111 = 0 + (u105 - 0) * Functions.Easing(p109, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
        updateModels(v111);
        local v112 = math.floor(v111 + 1) % u78;

        if v112 ~= u107 then
            u107 = v112;

            if v111 < u106 then
                Audio.Play(16580611883, u69, 1, 2.5, 100);
            end;
        end;

        if not u84 and u106 <= v111 then
            u84 = true;

            if u77 ~= nil then
                u77(u85);
            end;
        end;

        return false;
    end, p72, true):Wait();
    updateModels(u105);

    if not u84 and u77 ~= nil then
        u84 = true;
        u77(u85);
    end;

    for _, v in ipairs(v96) do
        if v then
            v:Destroy();
        end;
    end;

    v88:Destroy();

    if u67 then
        u67.forceFinalize = nil;
    end;

    return u85;
end;

local function getRollEffectTarget(p113) -- Line: 743
    local PrimaryPart = p113.PrimaryPart;

    if PrimaryPart then
        return PrimaryPart;
    end;

    local HumanoidRootPart = p113:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
        return HumanoidRootPart;
    end;

    local CENTER = p113:FindFirstChild("CENTER");

    if CENTER and CENTER:IsA("BasePart") then
        return CENTER;
    end;

    return p113;
end;

local function playRollResultSound(p114, p115, p116) -- Line: 762
    -- upvalues: Directory (copy), RarityNumber (copy), AssetSoundUtil (copy), ItemDisplay (copy), GetAssetsSoundParams (copy), Audio (copy)
    local Category = p115.Category;

    if typeof(Category) ~= "string" then
        return;
    end;

    local v117 = Directory[Category];

    if not v117 then
        return;
    end;

    local PlaceSound = v117.PlaceSound;

    if not PlaceSound then
        return;
    end;

    local Rarity2 = v117.Rarity;

    if Rarity2 then
        Rarity2 = Rarity2.RarityNumber;
    end;

    if not p116 and (typeof(Rarity2) ~= "number" or Rarity2 < RarityNumber) then
        return;
    end;

    local PrimaryPart = p114.PrimaryPart;

    if not PrimaryPart then
        PrimaryPart = p114:FindFirstChild("HumanoidRootPart");

        if not (PrimaryPart and PrimaryPart:IsA("BasePart")) then
            PrimaryPart = p114:FindFirstChild("CENTER");

            if PrimaryPart then
                if not PrimaryPart:IsA("BasePart") then
                    PrimaryPart = p114;
                end;
            else
                PrimaryPart = p114;
            end;
        end;
    end;

    local v118 = AssetSoundUtil.CloneSoundFileWithMutationPlaybackSpeed(PlaceSound, p115.Mutations);
    local v119, v120 = GetAssetsSoundParams((ItemDisplay.GetDisplayScale(p115.Scale)));
    local Volume = v118.Data.Volume;

    if typeof(Volume) == "number" then
        v118.Data.Volume = Volume * v119;
    else
        v118.Data.Volume = v119;
    end;

    local PitchShiftSoundEffect = Instance.new("PitchShiftSoundEffect");
    PitchShiftSoundEffect.Octave = v120;
    local v121 = AssetSoundUtil.BuildPlaybackEffectChildren({ PitchShiftSoundEffect }, p115.Mutations);
    Audio.PlayFromSoundFile(v118, PrimaryPart.CFrame, v121);
end;

function v3.CreateExternalRollResultModel(p122) -- Line: 811
    -- upvalues: Asserts (copy), AssetModelStreaming (copy), ItemDisplay (copy), attachGroundPivotAnchor (copy), setRollModelPhysics (copy), playRollResultSound (copy)
    Asserts.table(p122);
    Asserts.Instance(p122.parent);
    Asserts.table(p122.assetItemData);
    local v123;

    if typeof(p122.pivot) == "function" then
        v123 = p122.pivot();
    else
        v123 = p122.pivot;
    end;

    local v124 = table.clone(p122.assetItemData);

    if v124.Mutations then
        local Mutations2 = v124.Mutations;
        v124.Mutations = Mutations2 == nil and {} or table.clone(Mutations2);
    end;

    AssetModelStreaming.ForceLoadAssetModels({ v124.Category });
    local v125 = ItemDisplay.CreateActiveModel(nil, v124, true, true, true);
    ItemDisplay.StripRuntimeRig(v125, true, true);
    v125:FindFirstChild("FXPart");

    if p122.groundAlignToPivot == true then
        attachGroundPivotAnchor(v125);
    end;

    v125.Parent = p122.parent;

    if p122.parent:IsA("BasePart") then
        local parent = p122.parent;

        for _, descendant in ipairs(v125:GetDescendants()) do
            if descendant:IsA("BasePart") then
                descendant.Massless = true;
                descendant.Anchored = true;
                descendant.CanCollide = false;
                descendant.CanQuery = false;
                descendant.CanTouch = false;
            end;

            if descendant:IsA("MeshPart") then
                descendant.Transparency = 0;
            end;
        end;

        v125:PivotTo(v123);
        local WeldConstraint = Instance.new("WeldConstraint");
        WeldConstraint.Part0 = parent;
        WeldConstraint.Part1 = v125.PrimaryPart;
        WeldConstraint.Parent = v125.PrimaryPart;
    else
        setRollModelPhysics(v125, true, true);
        v125:PivotTo(v123);
    end;

    if p122.playResultSound ~= false then
        playRollResultSound(v125, v124, true);
    end;

    return v125;
end;

function v3.PlayExternalRollAnimation(u126) -- Line: 862
    -- upvalues: Asserts (copy), Rarity (copy), u1 (copy), buildRollAssetItemDatas (copy), Audio (copy), playRollAnimation (copy), playRollResultSound (copy)
    Asserts.table(u126);
    Asserts.Instance(u126.parent);
    Asserts.table(u126.dropTable);
    Asserts.table(u126.assetItemData);
    Asserts.optional.func(u126.onFinalModelWillShow);
    local eggRarityAttr = u126.eggRarityAttr;

    if false then
        u1:AtWarning():Log((`Rarity config not found for: {eggRarityAttr}`));
    end;

    local v127 = table.clone(u126.assetItemData);

    if v127.Mutations then
        local Mutations2 = v127.Mutations;
        v127.Mutations = Mutations2 == nil and {} or table.clone(Mutations2);
    end;

    local v128, v129 = buildRollAssetItemDatas({
        DropTable = u126.dropTable
    }, v127, u126.eggMutations, u126.eggScale);

    if #v128 == 0 then
        return nil;
    end;

    local v130 = v128[v129];

    if not v130 then
        return nil;
    end;

    local function getPivotCFrame() -- Line: 906
        -- upvalues: u126 (copy)
        if typeof(u126.pivot) == "function" then
            return u126.pivot();
        end;

        return u126.pivot;
    end;

    local v131;

    if typeof(u126.pivot) == "function" then
        v131 = u126.pivot();
    else
        v131 = u126.pivot;
    end;

    Audio.Play("rbxassetid://79565241490029", v131);
    local v132 = playRollAnimation(nil, u126.parent, v131, v128, v129, u126.rollDuration or 6, true, u126.usePooledRollModels, u126.useStaticRollModels, u126.groundAlignToPivot, u126.onFinalModelWillShow);

    if v132 then
        playRollResultSound(v132, v130, true);
    end;

    return v132;
end;

return v3;