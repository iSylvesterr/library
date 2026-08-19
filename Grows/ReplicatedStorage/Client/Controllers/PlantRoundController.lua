-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local CollectionService = game:GetService("CollectionService");
local ContentProvider = game:GetService("ContentProvider");
local Debris = game:GetService("Debris");
local SoundService = game:GetService("SoundService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local UserInputService = game:GetService("UserInputService");
local Knit = require(ReplicatedStorage.Packages.Knit);
local Maid = require(ReplicatedStorage.Packages.Maid);
local CustomEnum = require(ReplicatedStorage.Shared.Info.CustomEnum);
local SeedConfig = require(ReplicatedStorage.Shared.Info.SeedConfig);
local LightningBolt = require(ReplicatedStorage.Shared.Utility.LightningBolt);
local MutationRecolor = require(ReplicatedStorage.Shared.Utility.MutationRecolor);
local MutationConfig = require(ReplicatedStorage.Shared.Info.MutationConfig);
local MutationText = require(ReplicatedStorage.Shared.Utility.MutationText);
local TreeMountPoint = require(ReplicatedStorage.Shared.Utility.TreeMountPoint);
local u1 = { {
        stageNum = 1,
        minMult = 0,
        maxMult = 1.5
    }, {
        stageNum = 2,
        minMult = 1.5,
        maxMult = 3
    }, {
        stageNum = 3,
        minMult = 3,
        maxMult = 7.5
    }, {
        stageNum = 4,
        minMult = 7.5,
        maxMult = (1 / 0)
    } };
Color3.fromRGB(125, 255, 44);

local function getDestroySound(p2) -- Line: 63
    return p2 < 3 and "growth_sound_end_small" or (p2 < 8 and "growth_sound_end_medium" or (p2 < 20 and "growth_sound_end_large" or "growth_sound_end_huge"));
end;

local u3 = {
    growth_sound_end_large = 0.35
};
Color3.fromRGB(255, 50, 50);
local u4 = Color3.new(1, 1, 1);
local _ = Enum.KeyCode.F;
local Q = Enum.KeyCode.Q;

local function myPlotGrowthMult() -- Line: 78
    -- upvalues: Players (copy), SeedConfig (copy)
    local BigField = workspace:FindFirstChild("BigField");

    if BigField then
        BigField = BigField:FindFirstChild("PlayerPlots");
    end;

    for _, v in BigField and BigField:GetChildren() or {} do
        if v:GetAttribute("OwnerUserId") == Players.LocalPlayer.UserId then
            return SeedConfig.PlotGrowthMult(v);
        end;
    end;

    return 1;
end;

local E = Enum.KeyCode.E;
local u5 = Color3.fromRGB(116, 116, 116);
local u6 = Color3.fromRGB(50, 50, 50);
local u7 = Knit.CreateController({
    Name = "PlantRoundController"
});
u7.localRoundVisible = false;
u7.localGhostGrowing = false;

local function getStageIndex(p8) -- Line: 123
    -- upvalues: u1 (copy)
    for i, v in ipairs(u1) do
        if p8 < v.maxMult then
            return i;
        end;
    end;

    return #u1;
end;

local function getNaturalHeight(p9) -- Line: 134
    local v10 = (1 / 0);
    local v11 = (-1 / 0);

    for _, descendant in p9:GetDescendants() do
        if descendant:IsA("BasePart") then
            local CFrame2 = descendant.CFrame;
            local Size = descendant.Size;
            local v12 = math.abs(CFrame2.RightVector.Y) * Size.X / 2 + math.abs(CFrame2.UpVector.Y) * Size.Y / 2 + math.abs(CFrame2.LookVector.Y) * Size.Z / 2;
            local v13 = CFrame2.Position.Y + v12;
            local v14 = CFrame2.Position.Y - v12;

            if v14 >= v10 then
                v14 = v10;
            end;

            if v11 < v13 then
                v11 = v13;
                v10 = v14;
            else
                v10 = v14;
            end;
        end;
    end;

    return v10 == (1 / 0) and 1 or math.max(v11 - v10, 1);
end;

local function calcModelScale(p15, p16) -- Line: 153
    return math.max(0.05, p16) * 2 / p15;
end;

local function getPartWorldBottomY(p17) -- Line: 157
    local CFrame2 = p17.CFrame;
    local Size = p17.Size;
    local v18 = math.abs(CFrame2.RightVector.Y) * Size.X / 2 + math.abs(CFrame2.UpVector.Y) * Size.Y / 2 + math.abs(CFrame2.LookVector.Y) * Size.Z / 2;

    return CFrame2.Position.Y - v18;
end;

local function scaleAndPosition(p19, p20, p21) -- Line: 166
    -- upvalues: getPartWorldBottomY (copy)
    p19:ScaleTo(p21);
    local PrimaryPart = p19.PrimaryPart;

    if not PrimaryPart then
        return;
    end;

    local v22 = getPartWorldBottomY(PrimaryPart);
    p19:PivotTo(p19:GetPivot() + Vector3.new(p20.X - PrimaryPart.Position.X, p20.Y - v22, p20.Z - PrimaryPart.Position.Z));
end;

local function getEquippedSeedTool(p23) -- Line: 185
    local Character = p23.Character;

    if not Character then
        return nil;
    end;

    for _, child in Character:GetChildren() do
        if child:IsA("Tool") and child:GetAttribute("IsSeed") then
            return child;
        end;
    end;

    return nil;
end;

local function generateCrashPoint() -- Line: 196
    local v24 = 0.99 / (1 - math.random()) * 100;
    local v25 = math.floor(v24) / 100;

    return math.max(2.5, v25);
end;

local function preloadCrashSounds() -- Line: 208
    -- upvalues: SoundService (copy), ContentProvider (copy)
    task.spawn(function() -- Line: 209
        -- upvalues: SoundService (ref), ContentProvider (ref)
        local u26 = {};

        for _, v in { "growth_sound_end_small", "growth_sound_end_medium", "growth_sound_end_large", "growth_sound_end_huge", "Lightning" } do
            local v27 = SoundService:FindFirstChild(v, true);

            if v27 then
                table.insert(u26, v27);
            end;
        end;

        if #u26 > 0 then
            pcall(function() -- Line: 217
                -- upvalues: ContentProvider (ref), u26 (copy)
                ContentProvider:PreloadAsync(u26);
            end);
        end;
    end);
end;

function u7.KnitStart(u28) -- Line: 222
    -- upvalues: Maid (copy), SoundService (copy), ContentProvider (copy), Players (copy), Knit (copy), ReplicatedStorage (copy), CollectionService (copy), LightningBolt (copy), Debris (copy), u5 (copy), u6 (copy), CustomEnum (copy), u7 (copy), TreeMountPoint (copy), SeedConfig (copy), u1 (copy), getNaturalHeight (copy), scaleAndPosition (copy), MutationRecolor (copy), TweenService (copy), RunService (copy), getEquippedSeedTool (copy), UserInputService (copy), E (copy), Q (copy), myPlotGrowthMult (copy), u4 (copy), MutationConfig (copy), MutationText (copy), u3 (copy)
    local v29 = Maid.new();
    task.spawn(function() -- Line: 209
        -- upvalues: SoundService (ref), ContentProvider (ref)
        local u30 = {};

        for _, v in { "growth_sound_end_small", "growth_sound_end_medium", "growth_sound_end_large", "growth_sound_end_huge", "Lightning" } do
            local v31 = SoundService:FindFirstChild(v, true);

            if v31 then
                table.insert(u30, v31);
            end;
        end;

        if #u30 > 0 then
            pcall(function() -- Line: 217
                -- upvalues: ContentProvider (ref), u30 (copy)
                ContentProvider:PreloadAsync(u30);
            end);
        end;
    end);
    local SoundController = u28.SoundController;
    local LocalPlayer = Players.LocalPlayer;
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
    local u32 = Knit.GetService("PlantRoundService");
    local u33 = Knit.GetController("WeatherController");

    local function weatherActive() -- Line: 232
        -- upvalues: u33 (copy)
        return u33:GetCurrent() ~= nil;
    end;

    PlayerGui:WaitForChild("HUD"):WaitForChild("CursorUI");
    local u34 = LocalPlayer:GetMouse();
    local CurrentCamera = workspace.CurrentCamera;
    local PlantStages = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Greedy"):WaitForChild("PlantStages");
    local FruitModels = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Greedy"):WaitForChild("FruitModels");
    local Seeds = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Greedy"):FindFirstChild("Seeds");
    local u35 = CollectionService:GetTagged("MainField");
    local Clouds = workspace.Terrain:WaitForChild("Clouds");
    local VFX = workspace:WaitForChild("BigField"):WaitForChild("VFX");
    local NormalRain = VFX:WaitForChild("NormalRain");
    local LightningRain = VFX:WaitForChild("LightningRain");
    local LightningExplosion = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Greedy"):WaitForChild("VFX"):WaitForChild("LightningExplosion");
    local TreeVFX = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Greedy"):WaitForChild("TreeVFX");

    local function strikeLightning(p36) -- Line: 283
        -- upvalues: LightningBolt (ref), LightningExplosion (copy), SoundController (copy), Debris (ref)
        LightningBolt.strike(p36 + Vector3.new(0, 300, 0), p36, {
            bolts = 1,
            points = 20,
            minWidth = 6,
            maxWidth = 10,
            fadeTime = 0.15,
            growMin = 1,
            growMax = 2,
            jitter = 5,
            color = Color3.fromRGB(180, 210, 255)
        });
        local v37 = LightningExplosion:Clone();
        v37.Parent = workspace;

        if v37:IsA("Model") then
            v37:PivotTo(CFrame.new(p36));
        elseif v37:IsA("BasePart") then
            v37.Anchored = true;
            v37.CFrame = CFrame.new(p36);
        end;

        for _, descendant in v37:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Anchored = true;
            end;

            if descendant:IsA("ParticleEmitter") then
                descendant:Emit(descendant:GetAttribute("EmitCount") or 20);
            end;
        end;

        SoundController:PlaySound("Lightning", v37, {
            RollOffMaxDistance = 300
        });
        Debris:AddItem(v37, 2.5);
    end;

    local u38 = RaycastParams.new();
    u38.FilterType = Enum.RaycastFilterType.Include;
    u38.FilterDescendantsInstances = u35;
    CollectionService:GetInstanceAddedSignal("MainField"):Connect(function(p39) -- Line: 320
        -- upvalues: u35 (copy), u38 (copy)
        table.insert(u35, p39);
        u38.FilterDescendantsInstances = u35;
    end);
    CollectionService:GetInstanceRemovedSignal("MainField"):Connect(function(p40) -- Line: 324
        -- upvalues: u35 (copy), u38 (copy)
        local v41 = table.find(u35, p40);

        if v41 then
            table.remove(u35, v41);
        end;

        u38.FilterDescendantsInstances = u35;
    end);
    local Center = PlayerGui:WaitForChild("HUD"):WaitForChild("Bottom"):WaitForChild("Center");
    local PlantSeed = Center:FindFirstChild("PlantSeed");

    if PlantSeed then
        PlantSeed.Visible = false;
    end;

    local Harvest = Center:FindFirstChild("Harvest");

    if Harvest then
        Harvest.Visible = false;
    end;

    local u42 = false;
    local u43 = "idle";
    local u44 = false;
    local u45 = {};
    local u46 = 5.95;
    local u47 = false;
    local u48 = false;
    local u49 = 0;

    local function stopGrowthSounds(p50) -- Line: 360
        if not p50 then
            return;
        end;

        if p50.growthLoopThread then
            task.cancel(p50.growthLoopThread);
            p50.growthLoopThread = nil;
        end;

        if p50.growthEmitter then
            p50.growthEmitter:Destroy();
            p50.growthEmitter = nil;
        end;
    end;

    local function startGrowthSounds(u51, p52) -- Line: 372
        -- upvalues: SoundController (copy)
        if u51 then
            if u51.growthLoopThread then
                task.cancel(u51.growthLoopThread);
                u51.growthLoopThread = nil;
            end;

            if u51.growthEmitter then
                u51.growthEmitter:Destroy();
                u51.growthEmitter = nil;
            end;
        end;

        local Part = Instance.new("Part");
        Part.Name = "GrowthSoundEmitter";
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.CanTouch = false;
        Part.Transparency = 1;
        Part.Size = Vector3.new(1, 1, 1);
        Part.CFrame = CFrame.new(p52);
        Part.Parent = workspace;
        u51.growthEmitter = Part;
        SoundController:PlaySound("GrowthA", Part);
        u51.growthLoopThread = task.delay(13, function() -- Line: 390
            -- upvalues: u51 (copy), Part (copy), SoundController (ref)
            u51.growthLoopThread = nil;

            if u51.growthEmitter == Part and not u51.crashed then
                SoundController:PlaySound("GrowthBLoop", Part);
            end;
        end);
    end;

    local function setVfxEnabled(p53, p54) -- Line: 402
        for _, descendant in p53:GetDescendants() do
            if descendant:IsA("ParticleEmitter") or (descendant:IsA("Beam") or descendant:IsA("Trail")) then
                descendant.Enabled = p54;
            end;
        end;
    end;

    local function lerpWeather(p55) -- Line: 410
        -- upvalues: Clouds (copy), u5 (ref), u6 (ref)
        Clouds.Cover = p55 * -0.09999999999999998 + 0.83;
        Clouds.Density = p55 * 0.30000000000000004 + 0.5;
        Clouds.Color = u5:Lerp(u6, p55);
    end;

    local function resetWeatherFull() -- Line: 416
        -- upvalues: u47 (ref), u48 (ref), u33 (copy), Clouds (copy), u5 (ref), u6 (ref), setVfxEnabled (copy), NormalRain (copy), LightningRain (copy)
        u47 = false;
        u48 = false;

        if u33:GetCurrent() ~= nil then
            return;
        end;

        Clouds.Cover = 0.83;
        Clouds.Density = 0.5;
        Clouds.Color = u5:Lerp(u6, 0);
        setVfxEnabled(NormalRain, true);
        setVfxEnabled(LightningRain, false);
    end;

    local u56 = nil;
    local u57 = nil;
    local u58 = 0;
    local u59 = nil;
    local CustomProxPrompt = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Greedy"):WaitForChild("CustomProxPrompt");

    local function triggerHarvest() -- Line: 441
        -- upvalues: u59 (ref), u32 (copy)
        if u59 == "Collect" then
            u32:CollectDeadTree();

            return;
        end;

        if u59 == "Harvest" then
            u32:StopPlant();
        end;
    end;

    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "RoundBillboards";
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.Parent = PlayerGui;

    local function destroyHarvestBillboard() -- Line: 455
        -- upvalues: u58 (ref), u59 (ref), u57 (ref), u56 (ref)
        u58 = u58 + 1;
        u59 = nil;

        if u57 then
            u57:Disconnect();
            u57 = nil;
        end;

        if u56 then
            u56:Destroy();
            u56 = nil;
        end;
    end;

    local function showHarvestBillboard(u60, u61) -- Line: 468
        -- upvalues: u58 (ref), u59 (ref), u57 (ref), u56 (ref), LocalPlayer (copy), CustomProxPrompt (copy), Knit (ref), CustomEnum (ref), triggerHarvest (copy), ScreenGui (copy)
        u58 = u58 + 1;
        u59 = nil;

        if u57 then
            u57:Disconnect();
            u57 = nil;
        end;

        if u56 then
            u56:Destroy();
            u56 = nil;
        end;

        if not u60 then
            return;
        end;

        u59 = u61;
        local u62 = u58;
        task.spawn(function() -- Line: 473
            -- upvalues: LocalPlayer (ref), u60 (copy), u62 (copy), u58 (ref), CustomProxPrompt (ref), u61 (copy), Knit (ref), CustomEnum (ref), u57 (ref), triggerHarvest (ref), ScreenGui (ref), u56 (ref)
            local v63 = workspace:WaitForChild("BigField"):WaitForChild("PlantRound_" .. LocalPlayer.UserId .. "_" .. u60, 5);

            if v63 then
                v63 = v63:WaitForChild("MultDisplay", 5);
            end;

            if not v63 or u62 ~= u58 then
                return;
            end;

            local v64 = CustomProxPrompt:Clone();
            v64.Adornee = v63;
            v64.MaxDistance = 10000;
            v64.Enabled = true;
            local Button = v64:FindFirstChild("Button");
            local v65;

            if Button then
                v65 = Button:FindFirstChild("MainFrame");
            else
                v65 = Button;
            end;

            local v66;

            if v65 then
                v66 = v65:FindFirstChild("TextLabel");
            else
                v66 = v65;
            end;

            if v66 then
                v66.Text = u61;
            end;

            if v65 then
                v65 = v65:FindFirstChild("Keybind");
            end;

            if v65 then
                v65.Image = Knit.GetController("UserInputParser"):getInputType() == CustomEnum.INPUT_TYPES.MOBILE and "rbxassetid://120515921874906" or "rbxassetid://74611557201552";
            end;

            if Button then
                u57 = Button.Activated:Connect(triggerHarvest);
            end;

            v64.Parent = ScreenGui;
            u56 = v64;
        end);
    end;

    local function clientReset() -- Line: 505
        -- upvalues: u42 (ref), u43 (ref), u44 (ref), u7 (ref), u47 (ref), u48 (ref), u33 (copy), Clouds (copy), u5 (ref), u6 (ref), setVfxEnabled (copy), NormalRain (copy), LightningRain (copy), u58 (ref), u59 (ref), u57 (ref), u56 (ref)
        u42 = false;
        u43 = "idle";
        u44 = false;
        u7.localRoundVisible = false;
        u47 = false;
        u48 = false;

        if u33:GetCurrent() == nil then
            Clouds.Cover = 0.83;
            Clouds.Density = 0.5;
            Clouds.Color = u5:Lerp(u6, 0);
            setVfxEnabled(NormalRain, true);
            setVfxEnabled(LightningRain, false);
        end;

        u58 = u58 + 1;
        u59 = nil;

        if u57 then
            u57:Disconnect();
            u57 = nil;
        end;

        if u56 then
            u56:Destroy();
            u56 = nil;
        end;
    end;

    local function destroyRoundPlant(p67) -- Line: 518
        if p67.plantModel then
            p67.plantModel:Destroy();
            p67.plantModel = nil;
        end;

        p67.currentStageIndex = 0;
    end;

    local function prepareDisplayParts(p68) -- Line: 526
        -- upvalues: TreeMountPoint (ref)
        for _, descendant in p68:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Anchored = true;
                descendant.CanCollide = false;
            end;
        end;

        TreeMountPoint.hide(p68);
    end;

    local function populateFruits(p69, p70) -- Line: 536
        -- upvalues: SeedConfig (ref), FruitModels (copy)
        local FruitSpawns = p69:FindFirstChild("FruitSpawns");

        if not FruitSpawns then
            return;
        end;

        local v71 = FruitModels:FindFirstChild(SeedConfig.FRUIT_MODEL_NAMES[p70] or "Acorn");

        if not v71 then
            return;
        end;

        for _, child in FruitSpawns:GetChildren() do
            if child:IsA("BasePart") then
                child.Transparency = 1;
                local ProximityPrompt = child:FindFirstChild("ProximityPrompt");

                if ProximityPrompt then
                    ProximityPrompt:Destroy();
                end;

                local v72 = v71:Clone();
                v72.Name = "SimFruit_" .. child.Name;

                for _, descendant in v72:GetDescendants() do
                    if descendant:IsA("BasePart") then
                        descendant.Anchored = true;
                        descendant.CanCollide = false;
                    end;

                    if descendant:IsA("ProximityPrompt") then
                        descendant:Destroy();
                    end;
                end;

                if v72:IsA("Model") then
                    local _, v73 = v72:GetBoundingBox();
                    local Size = child.Size;
                    v72:ScaleTo((math.min(Size.X / v73.X, Size.Y / v73.Y, Size.Z / v73.Z)));
                end;

                local AnchorFruitTop = SeedConfig.AnchorFruitTop;
                local v74 = math.random(0, 359);
                AnchorFruitTop(v72, child, math.rad(v74), p70);
                v72.Parent = FruitSpawns;
            end;
        end;
    end;

    local function getStageTemplate(p75, p76) -- Line: 578
        -- upvalues: PlantStages (copy), u1 (ref)
        local v77 = PlantStages:FindFirstChild(p75);
        local v78 = v77 and v77:FindFirstChild(p75 .. p76);

        if v78 then
            return v78;
        end;

        local v79 = u1[p76];

        if v79 then
            v79 = PlantStages:FindFirstChild("Stage" .. v79.stageNum);
        end;

        return v79;
    end;

    local function getDeadTemplate(p80) -- Line: 588
        -- upvalues: PlantStages (copy)
        local v81 = PlantStages:FindFirstChild(p80);

        return v81 and v81:FindFirstChild(p80 .. "Dead") or PlantStages:FindFirstChild("Dead");
    end;

    local function spawnStageForRound(p82, p83, p84) -- Line: 597
        -- upvalues: PlantStages (copy), u1 (ref), prepareDisplayParts (copy), populateFruits (copy), getNaturalHeight (ref), scaleAndPosition (ref), MutationRecolor (ref)
        if p82.plantModel then
            p82.plantModel:Destroy();
            p82.plantModel = nil;
        end;

        local v85 = p82.seedType or "Oak";
        local v86 = PlantStages:FindFirstChild(v85);
        local v87 = v86 and v86:FindFirstChild(v85 .. p83);

        if not v87 then
            v87 = u1[p83];

            if v87 then
                v87 = PlantStages:FindFirstChild("Stage" .. v87.stageNum);
            end;
        end;

        if not v87 then
            return;
        end;

        local v88 = v87:Clone();
        v88.Name = "ActivePlant";
        prepareDisplayParts(v88);

        if p83 == 4 then
            populateFruits(v88, p82.seedType or "Oak");
        end;

        v88.Parent = workspace;
        p82.plantModel = v88;
        p82.currentStageIndex = p83;
        p82.naturalHeight = getNaturalHeight(v87);
        local naturalHeight = p82.naturalHeight;
        scaleAndPosition(v88, p82.plantPosition, math.max(0.05, p84) * 2 / naturalHeight);

        if p82.mutationKey then
            MutationRecolor.apply(v88, p82.mutationKey);
        end;
    end;

    local function spawnDeadForRound(p89, p90) -- Line: 627
        -- upvalues: PlantStages (copy), prepareDisplayParts (copy), MutationRecolor (ref), getNaturalHeight (ref), scaleAndPosition (ref)
        if p89.plantModel then
            p89.plantModel:Destroy();
            p89.plantModel = nil;
        end;

        local v91 = p89.seedType or "Oak";
        local v92 = PlantStages:FindFirstChild(v91);
        local v93 = v92 and v92:FindFirstChild(v91 .. "Dead") or PlantStages:FindFirstChild("Dead");

        if not v93 then
            return;
        end;

        local v94 = v93:Clone();
        v94.Name = "ActivePlant";
        prepareDisplayParts(v94);

        if p89.mutationKey and p89.mutationKey ~= "" then
            MutationRecolor.apply(v94, p89.mutationKey);
        end;

        v94.Parent = workspace;
        p89.plantModel = v94;
        p89.currentStageIndex = -1;
        p89.naturalHeight = getNaturalHeight(v93);
        local naturalHeight = p89.naturalHeight;
        scaleAndPosition(v94, p89.plantPosition, math.max(0.05, p90) * 2 / naturalHeight);
    end;

    local function makeModelTranslucent(p95) -- Line: 652
        for _, descendant in p95:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Transparency = math.max(descendant.Transparency, 0.5);
            end;
        end;
    end;

    local function scaleEmitter(p96, p97) -- Line: 660
        local v98 = {};

        for _, v in p96.Size.Keypoints do
            table.insert(v98, NumberSequenceKeypoint.new(v.Time, v.Value * p97, v.Envelope * p97));
        end;

        p96.Size = NumberSequence.new(v98);
        p96.Speed = NumberRange.new(p96.Speed.Min * p97, p96.Speed.Max * p97);
        p96.Acceleration = p96.Acceleration * p97;
    end;

    local function playTreeVFX(p99) -- Line: 672
        -- upvalues: TreeVFX (copy), scaleEmitter (copy)
        if not (p99 and TreeVFX) then
            return;
        end;

        local v100, v101 = p99:GetBoundingBox();
        local v102 = math.clamp(v101.Y / 8, 0.3, 5);
        local u103 = TreeVFX:Clone();
        u103.Anchored = true;
        u103.CanCollide = false;
        u103.CFrame = v100;
        u103.Parent = workspace;

        for _, descendant in u103:GetDescendants() do
            if descendant:IsA("ParticleEmitter") then
                scaleEmitter(descendant, v102);
                descendant:Emit(descendant:GetAttribute("EmitCount") or 10);
            end;
        end;

        task.delay(3, function() -- Line: 690
            -- upvalues: u103 (copy)
            u103:Destroy();
        end);
    end;

    local function updatePlantVisual(p104, p105) -- Line: 695
        -- upvalues: u1 (ref), spawnStageForRound (copy), playTreeVFX (copy), scaleAndPosition (ref)
        if p104.plantModel and p104.currentStageIndex > 0 then
            for i, v in ipairs(u1) do
                if p105 < v.maxMult then
                    break;
                end;
            end;

            if i == p104.currentStageIndex then
                local naturalHeight = p104.naturalHeight;
                scaleAndPosition(p104.plantModel, p104.plantPosition, math.max(0.05, p105) * 2 / naturalHeight);
            else
                local v106 = p104.currentStageIndex < i;
                spawnStageForRound(p104, i, p105);

                if v106 then
                    playTreeVFX(p104.plantModel);

                    return;
                end;
            end;

            return;
        end;

        for i, v in ipairs(u1) do
            if p105 < v.maxMult then
                break;
            end;
        end;

        spawnStageForRound(p104, i, p105);
    end;

    local function raycastToField() -- Line: 718
        -- upvalues: CurrentCamera (copy), u34 (copy), u38 (copy)
        local v107 = CurrentCamera:ScreenPointToRay(u34.X, u34.Y);
        local v108 = workspace:Raycast(v107.Origin, v107.Direction * 500, u38);

        if v108 and v108.Instance then
            return v108.Position;
        end;

        return nil;
    end;

    local function playSeedAnimation(p109, p110) -- Line: 731
        -- upvalues: Seeds (copy), SeedConfig (ref), TweenService (ref), RunService (ref)
        if not Seeds then
            return;
        end;

        local v111 = Seeds:FindFirstChild(SeedConfig.SEED_MODEL_NAMES[p110] or p110 .. "Seed");

        if not v111 then
            return;
        end;

        if not v111:IsA("BasePart") then
            if v111:IsA("Model") then
                local u112 = v111:Clone();

                for _, descendant in u112:GetDescendants() do
                    if descendant:IsA("BasePart") then
                        descendant.Anchored = true;
                        descendant.CanCollide = false;
                    end;
                end;

                u112:PivotTo(CFrame.new(p109 + Vector3.new(0, 3, 0)));
                u112.Parent = workspace;
                local u113 = CFrame.new(p109 + Vector3.new(0, 3, 0));
                local u114 = CFrame.new(p109);
                local u115 = os.clock();
                local u116 = nil;
                u116 = RunService.Heartbeat:Connect(function() -- Line: 772
                    -- upvalues: u115 (copy), u112 (copy), u113 (copy), u114 (copy), u116 (ref)
                    local v117 = (os.clock() - u115) / 0.4;
                    local v118 = math.clamp(v117, 0, 1);
                    local v119 = v118 * v118;
                    u112:PivotTo(u113:Lerp(u114, v119));

                    if v119 >= 1 then
                        u116:Disconnect();
                        u112:Destroy();
                    end;
                end);
            end;

            return;
        end;

        local u120 = v111:Clone();
        u120.Anchored = true;
        u120.CanCollide = false;
        u120.CanQuery = false;
        u120.CanTouch = false;
        u120.CFrame = CFrame.new(p109 + Vector3.new(0, 3, 0));
        u120.Parent = workspace;
        local v121 = TweenService:Create(u120, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            CFrame = CFrame.new(p109)
        });
        v121:Play();
        v121.Completed:Once(function() -- Line: 753
            -- upvalues: u120 (copy)
            u120:Destroy();
        end);
    end;

    local function startTrackingRound(p122, p123, p124, p125, p126, p127, p128, p129, p130, p131) -- Line: 788
        -- upvalues: u45 (copy), LocalPlayer (copy), u7 (ref), spawnStageForRound (copy), u1 (ref), spawnDeadForRound (copy), startGrowthSounds (copy)
        local v132 = u45[p122];

        if v132 and v132.plantModel then
            local BigField = workspace:FindFirstChild("BigField");
            local roundId = v132.roundId;

            if roundId then
                if BigField then
                    BigField = BigField:FindFirstChild("PlantRound_" .. p122 .. "_" .. v132.roundId);
                end;
            else
                BigField = roundId;
            end;

            if BigField then
                v132.plantModel.Parent = BigField;
            else
                v132.plantModel:Destroy();
            end;

            v132.plantModel = nil;
        end;

        local v133 = {
            plantModel = nil,
            currentStageIndex = 0,
            plantPosition = p123,
            startTime = p124,
            stopped = p125 or false,
            stoppedAt = p126,
            crashed = p127 or false,
            crashPoint = p128,
            roundId = p129,
            seedType = p130 or "Oak"
        };

        if p131 == "" or not p131 then
            p131 = nil;
        end;

        v133.mutationKey = p131;
        u45[p122] = v133;

        if p122 == LocalPlayer.UserId then
            u7.localRoundVisible = true;
            u7.localGhostGrowing = v133.stopped and not v133.crashed;
        end;

        local v134;

        if p127 then
            if p125 then
                v134 = v133;

                for i, v in ipairs(u1) do
                    if p126 < v.maxMult then
                        break;
                    end;
                end;

                spawnStageForRound(v133, i, p126);
            else
                spawnDeadForRound(v133, p128);
                v134 = v133;
            end;
        else
            if not p125 then
                local v135 = workspace:GetServerTimeNow() - p124;
                local v136 = math.max(0, v135);
                local v137 = (math.exp(v136 * 0.28) - 1) * 100;
                local v138 = math.floor(v137) / 100;
                local v139 = math.max(0, v138);
                v134 = v133;

                for i, v in ipairs(u1) do
                    if v139 < v.maxMult then
                        break;
                    end;
                end;

                spawnStageForRound(v133, i, v139);

                if not (p127 or p125) then
                    startGrowthSounds(v134, p123);
                end;
            end;

            v134 = v133;

            for i, v in ipairs(u1) do
                if p126 < v.maxMult then
                    break;
                end;
            end;

            spawnStageForRound(v133, i, p126);
        end;

        if not (p127 or p125) then
            startGrowthSounds(v134, p123);
        end;
    end;

    local function stopTrackingRound(p140) -- Line: 843
        -- upvalues: u45 (copy), LocalPlayer (copy), u7 (ref)
        local v141 = u45[p140];

        if not v141 then
            return;
        end;

        if v141 then
            if v141.growthLoopThread then
                task.cancel(v141.growthLoopThread);
                v141.growthLoopThread = nil;
            end;

            if v141.growthEmitter then
                v141.growthEmitter:Destroy();
                v141.growthEmitter = nil;
            end;
        end;

        if v141.plantModel then
            v141.plantModel:Destroy();
            v141.plantModel = nil;
        end;

        v141.currentStageIndex = 0;
        u45[p140] = nil;

        if p140 == LocalPlayer.UserId then
            u7.localRoundVisible = false;
            u7.localGhostGrowing = false;
        end;
    end;

    setVfxEnabled(NormalRain, true);
    setVfxEnabled(LightningRain, false);
    local ConveyorSeeds = workspace:WaitForChild("BigField"):WaitForChild("ConveyorSeeds");
    local Position = ConveyorSeeds:WaitForChild("SeedSpawner").Position;
    local Position2 = ConveyorSeeds:WaitForChild("SeedDestroyer").Position;
    local Part = Instance.new("Part");
    Part.Name = "CreekEmitter";
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CanTouch = false;
    Part.Transparency = 1;
    Part.Size = Vector3.new(1, 1, 1);
    Part.Position = Position;
    Part.Parent = ConveyorSeeds;
    SoundController:PlaySound("CreekStream", Part, {
        Looped = true,
        RollOffMaxDistance = 50
    });
    local u142 = Position2 - Position;
    local u143 = u142:Dot(u142);
    RunService.Heartbeat:Connect(function() -- Line: 885
        -- upvalues: LocalPlayer (copy), u143 (copy), Position (copy), u142 (copy), Part (copy)
        local Character = LocalPlayer.Character;

        if Character then
            Character = Character:FindFirstChild("HumanoidRootPart");
        end;

        if not Character then
            return;
        end;

        local v144;

        if u143 > 0 then
            local v145 = (Character.Position - Position):Dot(u142) / u143;
            v144 = math.clamp(v145, 0, 1) or 0;
        else
            v144 = 0;
        end;

        Part.Position = Position + u142 * v144;
    end);
    SoundController:PlaySound("CalmRain", LocalPlayer, {
        Looped = true
    });

    local function isEligibleToPlant() -- Line: 899
        -- upvalues: u42 (ref), getEquippedSeedTool (ref), LocalPlayer (copy)
        if u42 then
            return false;
        end;

        return getEquippedSeedTool(LocalPlayer) and true or false;
    end;

    local MobileButtons = PlayerGui:WaitForChild("HUD"):FindFirstChild("MobileButtons");

    if MobileButtons then
        MobileButtons = MobileButtons:FindFirstChild("PlantSeed");
    end;

    if MobileButtons then
        MobileButtons.Visible = false;
    end;

    v29:GiveTask(UserInputService.InputBegan:Connect(function(p146, p147) -- Line: 914
        -- upvalues: E (ref), u59 (ref), Knit (ref), u32 (copy), Q (ref), u42 (ref), getEquippedSeedTool (ref), LocalPlayer (copy), SeedConfig (ref), myPlotGrowthMult (ref), u4 (ref)
        if p147 then
            return;
        end;

        if p146.KeyCode == E then
            if u59 and not Knit.GetController("UI_Manager"):IsOpen() then
                if u59 == "Collect" then
                    u32:CollectDeadTree();

                    return;
                end;

                if u59 == "Harvest" then
                    u32:StopPlant();
                end;
            end;

            return;
        end;

        if p146.KeyCode ~= Q then
            return;
        end;

        local v148;

        if u42 then
            v148 = false;
        else
            v148 = getEquippedSeedTool(LocalPlayer) and true or false;
        end;

        if not v148 then
            return;
        end;

        local v149 = getEquippedSeedTool(LocalPlayer);

        if not v149 then
            return;
        end;

        local v150 = v149:GetAttribute("SeedType") or "Oak";
        math.randomseed(os.clock() * 1000 + tick());
        local v151 = 0.99 / (1 - math.random()) * 100;
        local v152 = math.floor(v151) / 100;
        local v153 = math.max(2.5, v152);
        local v154 = LocalPlayer:GetAttribute("FertilizerAmount");

        if v154 and (type(v154) == "number" and v154 > 0) then
            v153 = v153 * v154;
        end;

        local v155 = math.floor(v153 * 100) / 100;
        local v156 = SeedConfig.CalcWoodValue(v150, v155);
        local v157;

        if SeedConfig.GetStageIndex(v155) >= #SeedConfig.STAGE_CONFIG then
            local v158 = SeedConfig.CalcPlotFruitValue(v150, v155) * SeedConfig.FRUIT_SPAWN_COUNT;
            local v159 = SeedConfig.GetFruitGrowthTime(v155, myPlotGrowthMult()) / 60;
            v157 = string.format(", Fruit Return: $%d/%.1fmin", v158, v159);
        else
            v157 = "";
        end;

        Knit.GetController("NotificationController"):SendNotification(string.format("Crashed at: %.2fx, Value: $%d%s", v155, v156 <= 0 and 1 or v156, v157), 3, u4);
    end));

    local function spawnDetachedVisual(p160, p161, p162, p163, p164, p165, p166, p167) -- Line: 963
        -- upvalues: u1 (ref), PlantStages (copy), prepareDisplayParts (copy), scaleAndPosition (ref), getNaturalHeight (ref), MutationRecolor (ref)
        local v168 = p166 or "Oak";

        if p167 == "" or not p167 then
            p167 = nil;
        end;

        local v169 = nil;
        local v170;

        if not (p162 and p163) then
            local v171 = PlantStages:FindFirstChild(v168);
            local v172 = v171 and v171:FindFirstChild(v168 .. "Dead") or PlantStages:FindFirstChild("Dead");

            if v172 then
                v169 = v172:Clone();
                v169.Name = "DetachedPlant";
                prepareDisplayParts(v169);
                v169.Parent = workspace;
                local v173 = getNaturalHeight(v172);
                scaleAndPosition(v169, p161, math.max(0.05, p164) * 2 / v173);
            end;

            if v169 and p165 then
                v170 = workspace:FindFirstChild("BigField");

                if v170 then
                    v170 = v170:FindFirstChild("PlantRound_" .. p160 .. "_" .. p165);
                end;

                if v170 then
                    v169.Parent = v170;
                end;
            end;

            return;
        end;

        for i, v in ipairs(u1) do
            if p163 < v.maxMult then
                break;
            end;
        end;

        local v174 = PlantStages:FindFirstChild(v168);
        local v175 = v174 and v174:FindFirstChild(v168 .. i);

        if not v175 then
            v175 = u1[i];

            if v175 then
                v175 = PlantStages:FindFirstChild("Stage" .. v175.stageNum);
            end;
        end;

        if v175 then
            v169 = v175:Clone();
            v169.Name = "DetachedPlant";
            prepareDisplayParts(v169);
            v169.Parent = workspace;
            local v176 = getNaturalHeight(v175);
            scaleAndPosition(v169, p161, math.max(0.05, p163) * 2 / v176);

            if p167 then
                MutationRecolor.apply(v169, p167);
            end;
        end;

        if v169 and p165 then
            v170 = workspace:FindFirstChild("BigField");

            if v170 then
                v170 = v170:FindFirstChild("PlantRound_" .. p160 .. "_" .. p165);
            end;

            if v170 then
                v169.Parent = v170;
            end;
        end;
    end;

    task.spawn(function() -- Line: 1001
        -- upvalues: u32 (copy), spawnDetachedVisual (copy), u45 (copy), startTrackingRound (copy), LocalPlayer (copy), u42 (ref), u43 (ref), u44 (ref), u58 (ref), u59 (ref), u57 (ref), u56 (ref), CustomProxPrompt (copy), Knit (ref), CustomEnum (ref), triggerHarvest (copy), ScreenGui (copy)
        local v177, v178 = u32:GetActiveRounds():await();

        if v177 and v178 then
            for _, v in v178 do
                if v.detached then
                    spawnDetachedVisual(v.userId, v.plantPosition, v.stopped, v.stoppedAt, v.crashPoint, v.roundId, v.seedType, v.mutationKey);
                elseif not u45[v.userId] then
                    startTrackingRound(v.userId, v.plantPosition, v.startTime, v.stopped, v.stoppedAt, v.crashed, v.crashPoint, v.roundId, v.seedType, v.mutationKey);

                    if v.userId == LocalPlayer.UserId then
                        u42 = true;
                        u43 = v.crashed and "crashed" or "running";
                        u44 = v.stopped;

                        if not v.stopped then
                            local roundId = v.roundId;
                            local u179 = v.crashed and "Collect" or "Harvest";
                            u58 = u58 + 1;
                            u59 = nil;

                            if u57 then
                                u57:Disconnect();
                                u57 = nil;
                            end;

                            if u56 then
                                u56:Destroy();
                                u56 = nil;
                            end;

                            if roundId then
                                u59 = u179;
                                local u180 = u58;
                                task.spawn(function() -- Line: 473
                                    -- upvalues: LocalPlayer (ref), roundId (copy), u180 (copy), u58 (ref), CustomProxPrompt (ref), u179 (copy), Knit (ref), CustomEnum (ref), u57 (ref), triggerHarvest (ref), ScreenGui (ref), u56 (ref)
                                    local v181 = workspace:WaitForChild("BigField"):WaitForChild("PlantRound_" .. LocalPlayer.UserId .. "_" .. roundId, 5);

                                    if v181 then
                                        v181 = v181:WaitForChild("MultDisplay", 5);
                                    end;

                                    if not v181 or u180 ~= u58 then
                                        return;
                                    end;

                                    local v182 = CustomProxPrompt:Clone();
                                    v182.Adornee = v181;
                                    v182.MaxDistance = 10000;
                                    v182.Enabled = true;
                                    local Button = v182:FindFirstChild("Button");
                                    local v183;

                                    if Button then
                                        v183 = Button:FindFirstChild("MainFrame");
                                    else
                                        v183 = Button;
                                    end;

                                    local v184;

                                    if v183 then
                                        v184 = v183:FindFirstChild("TextLabel");
                                    else
                                        v184 = v183;
                                    end;

                                    if v184 then
                                        v184.Text = u179;
                                    end;

                                    if v183 then
                                        v183 = v183:FindFirstChild("Keybind");
                                    end;

                                    if v183 then
                                        v183.Image = Knit.GetController("UserInputParser"):getInputType() == CustomEnum.INPUT_TYPES.MOBILE and "rbxassetid://120515921874906" or "rbxassetid://74611557201552";
                                    end;

                                    if Button then
                                        u57 = Button.Activated:Connect(triggerHarvest);
                                    end;

                                    v182.Parent = ScreenGui;
                                    u56 = v182;
                                end);
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end);
    v29:GiveTask(u32.RoundStartedAll:Connect(function(p185, u186, p187, u188, p189, p190, p191) -- Line: 1036
        -- upvalues: startTrackingRound (copy), u28 (copy), u33 (copy), SoundController (copy), LocalPlayer (copy), u46 (ref), u42 (ref), u43 (ref), u44 (ref), u58 (ref), u59 (ref), u57 (ref), u56 (ref), CustomProxPrompt (copy), Knit (ref), CustomEnum (ref), triggerHarvest (copy), ScreenGui (copy), u47 (ref), u48 (ref), Clouds (copy), u5 (ref), u6 (ref), setVfxEnabled (copy), NormalRain (copy), LightningRain (copy), playSeedAnimation (copy), MutationConfig (ref), MutationText (ref)
        startTrackingRound(p185, u186, p187, false, nil, false, nil, u188, p190, p191);
        task.delay(0.3, function() -- Line: 1039
            -- upvalues: u28 (ref), u186 (copy)
            u28.ParticleController:VoxelParticleAt(u186 + Vector3.new(0, 0.1, 0), "DIRT", 10);
        end);

        if p191 and p191 ~= "" then
            u33:PlayBurst(p191, u186);
            SoundController:PlaySoundAtPosition(p191, u186, {
                RollOffMinDistance = 30,
                RollOffMaxDistance = 350,
                AcousticSimulationEnabled = false,
                RollOffMode = Enum.RollOffMode.Linear
            });
        end;

        if p185 == LocalPlayer.UserId then
            u46 = p189 or 5.95;
            u42 = true;
            u43 = "running";
            u44 = false;
            u58 = u58 + 1;
            u59 = nil;

            if u57 then
                u57:Disconnect();
                u57 = nil;
            end;

            if u56 then
                u56:Destroy();
                u56 = nil;
            end;

            if u188 then
                u59 = "Harvest";
                local u192 = u58;
                local u193 = "Harvest";
                task.spawn(function() -- Line: 473
                    -- upvalues: LocalPlayer (ref), u188 (copy), u192 (copy), u58 (ref), CustomProxPrompt (ref), u193 (copy), Knit (ref), CustomEnum (ref), u57 (ref), triggerHarvest (ref), ScreenGui (ref), u56 (ref)
                    local v194 = workspace:WaitForChild("BigField"):WaitForChild("PlantRound_" .. LocalPlayer.UserId .. "_" .. u188, 5);

                    if v194 then
                        v194 = v194:WaitForChild("MultDisplay", 5);
                    end;

                    if not v194 or u192 ~= u58 then
                        return;
                    end;

                    local v195 = CustomProxPrompt:Clone();
                    v195.Adornee = v194;
                    v195.MaxDistance = 10000;
                    v195.Enabled = true;
                    local Button = v195:FindFirstChild("Button");
                    local v196;

                    if Button then
                        v196 = Button:FindFirstChild("MainFrame");
                    else
                        v196 = Button;
                    end;

                    local v197;

                    if v196 then
                        v197 = v196:FindFirstChild("TextLabel");
                    else
                        v197 = v196;
                    end;

                    if v197 then
                        v197.Text = u193;
                    end;

                    if v196 then
                        v196 = v196:FindFirstChild("Keybind");
                    end;

                    if v196 then
                        v196.Image = Knit.GetController("UserInputParser"):getInputType() == CustomEnum.INPUT_TYPES.MOBILE and "rbxassetid://120515921874906" or "rbxassetid://74611557201552";
                    end;

                    if Button then
                        u57 = Button.Activated:Connect(triggerHarvest);
                    end;

                    v195.Parent = ScreenGui;
                    u56 = v195;
                end);
            end;

            u47 = false;
            u48 = false;

            if u33:GetCurrent() == nil then
                Clouds.Cover = 0.83;
                Clouds.Density = 0.5;
                Clouds.Color = u5:Lerp(u6, 0);
                setVfxEnabled(NormalRain, true);
                setVfxEnabled(LightningRain, false);
            end;

            SoundController:PlaySound("DistantThunderstorm", LocalPlayer, {
                Looped = true
            });
            playSeedAnimation(u186, p190 or "Oak");

            if p191 and (p191 ~= "" and MutationConfig.Get(p191)) then
                Knit.GetController("NotificationController"):SendNotification(string.format("Your seed became %s!", MutationText.coloredName(p191)), 3, Color3.fromRGB(255, 255, 255), nil, nil, nil, nil, true);
            end;
        end;
    end));
    v29:GiveTask(RunService.Heartbeat:Connect(function() -- Line: 1084
        -- upvalues: u45 (copy), updatePlantVisual (copy), makeModelTranslucent (copy), LocalPlayer (copy), u44 (ref), u33 (copy), u48 (ref), Clouds (copy), u5 (ref), u6 (ref), u47 (ref), setVfxEnabled (copy), NormalRain (copy), LightningRain (copy), u49 (ref)
        local v198 = workspace:GetServerTimeNow();

        for i, v in pairs(u45) do
            if not v.crashed then
                local v199 = (math.exp(0.28 * (v198 - v.startTime)) - 1) * 100;
                local v200 = math.floor(v199) / 100;
                local v201 = math.max(0, v200);
                local currentStageIndex = v.currentStageIndex;
                updatePlantVisual(v, v201);

                if v.stopped and (v.plantModel and (v.currentStageIndex ~= currentStageIndex or not v.ghostApplied)) then
                    makeModelTranslucent(v.plantModel);
                    v.ghostApplied = true;
                end;

                if i == LocalPlayer.UserId and not u44 and u33:GetCurrent() == nil then
                    local v202 = math.clamp(v201 / 1.5, 0, 1);

                    if not u48 then
                        Clouds.Cover = v202 * -0.09999999999999998 + 0.83;
                        Clouds.Density = v202 * 0.30000000000000004 + 0.5;
                        Clouds.Color = u5:Lerp(u6, v202);
                    end;

                    if v202 >= 1 and not u47 then
                        u47 = true;
                        setVfxEnabled(NormalRain, false);
                        setVfxEnabled(LightningRain, true);
                    end;
                end;
            end;
        end;

        if u48 and u33:GetCurrent() == nil then
            local v203 = (os.clock() - u49) / 3;
            local v204 = 1 - math.clamp(v203, 0, 1);
            Clouds.Cover = v204 * -0.09999999999999998 + 0.83;
            Clouds.Density = v204 * 0.30000000000000004 + 0.5;
            Clouds.Color = u5:Lerp(u6, v204);

            if v204 <= 0 then
                u47 = false;
                u48 = false;

                if u33:GetCurrent() ~= nil then
                    return;
                end;

                Clouds.Cover = 0.83;
                Clouds.Density = 0.5;
                Clouds.Color = u5:Lerp(u6, 0);
                setVfxEnabled(NormalRain, true);
                setVfxEnabled(LightningRain, false);
            end;
        end;
    end));
    v29:GiveTask(u32.PlantStoppedAll:Connect(function(p205, p206) -- Line: 1133
        -- upvalues: u45 (copy), updatePlantVisual (copy), makeModelTranslucent (copy), LocalPlayer (copy), u44 (ref), u42 (ref), u43 (ref), u7 (ref), u58 (ref), u59 (ref), u57 (ref), u56 (ref), SoundController (copy)
        local v207 = u45[p205];

        if v207 then
            v207.stopped = true;
            v207.stoppedAt = p206;
            updatePlantVisual(v207, p206);

            if v207.plantModel then
                makeModelTranslucent(v207.plantModel);
            end;
        end;

        if p205 == LocalPlayer.UserId then
            u44 = true;
            u42 = false;
            u43 = "idle";
            u7.localGhostGrowing = true;
            u58 = u58 + 1;
            u59 = nil;

            if u57 then
                u57:Disconnect();
                u57 = nil;
            end;

            if u56 then
                u56:Destroy();
                u56 = nil;
            end;

            SoundController:FadeOutSound("DistantThunderstorm", LocalPlayer, 1);
        end;
    end));

    local function applyHighlight(p208) -- Line: 1160
        if not p208 then
            return;
        end;

        if p208:FindFirstChildWhichIsA("Highlight") then
            return;
        end;

        local Highlight = Instance.new("Highlight");
        Highlight.FillTransparency = 1;
        Highlight.OutlineColor = Color3.new(1, 1, 1);
        Highlight.OutlineTransparency = 0;
        Highlight.Parent = p208;
    end;

    v29:GiveTask(u32.LightningNegated:Connect(function(p209, p210, p211) -- Line: 1175
        -- upvalues: u45 (copy), LocalPlayer (copy), strikeLightning (copy), SoundController (copy), u28 (copy), Knit (ref)
        local v212 = u45[LocalPlayer.UserId];

        if v212 and (v212.roundId == p209 and v212.plantPosition) then
            strikeLightning(v212.plantPosition);

            for _, v in { "ShieldOff", "ShieldOff2" } do
                SoundController:PlaySoundAtPosition(v, v212.plantPosition, {
                    RollOffMinDistance = 30,
                    RollOffMaxDistance = 350,
                    AcousticSimulationEnabled = false,
                    RollOffMode = Enum.RollOffMode.Linear
                });
            end;

            u28.ParticleController:SimpleParticleAt("ShieldBreakVFX", v212.plantPosition + Vector3.new(0, 2, 0), 3);
        end;

        Knit.GetController("NotificationController"):SendNotification(string.format("Lightning negated by %s!", (tostring(p211))), 4, Color3.fromRGB(125, 255, 44));
    end));
    v29:GiveTask(u32.CrashedAll:Connect(function(u213, p214) -- Line: 1202
        -- upvalues: u45 (copy), spawnDeadForRound (copy), makeModelTranslucent (copy), LocalPlayer (copy), SoundController (copy), u3 (ref), strikeLightning (copy), u7 (ref), u44 (ref), u43 (ref), u58 (ref), u59 (ref), u57 (ref), u56 (ref), CustomProxPrompt (copy), Knit (ref), CustomEnum (ref), triggerHarvest (copy), ScreenGui (copy), u48 (ref), u49 (ref), u33 (copy), setVfxEnabled (copy), LightningRain (copy), NormalRain (copy), u42 (ref)
        local u215 = u45[u213];

        if u215 then
            u215.crashed = true;
            u215.crashPoint = p214;

            if u215 then
                if u215.growthLoopThread then
                    task.cancel(u215.growthLoopThread);
                    u215.growthLoopThread = nil;
                end;

                if u215.growthEmitter then
                    u215.growthEmitter:Destroy();
                    u215.growthEmitter = nil;
                end;
            end;

            spawnDeadForRound(u215, p214);

            if u215.stopped and u215.plantModel then
                makeModelTranslucent(u215.plantModel);
            end;

            if not u215.stopped and (u215.plantModel and u213 == LocalPlayer.UserId) then
                local plantModel = u215.plantModel;

                if plantModel and not plantModel:FindFirstChildWhichIsA("Highlight") then
                    local Highlight = Instance.new("Highlight");
                    Highlight.FillTransparency = 1;
                    Highlight.OutlineColor = Color3.new(1, 1, 1);
                    Highlight.OutlineTransparency = 0;
                    Highlight.Parent = plantModel;
                end;
            end;
        end;

        if u215 and u215.plantPosition then
            local v216 = p214 < 3 and "growth_sound_end_small" or (p214 < 8 and "growth_sound_end_medium" or (p214 < 20 and "growth_sound_end_large" or "growth_sound_end_huge"));
            local v217 = SoundController:PlaySoundAtPosition(v216, u215.plantPosition, {
                RollOffMaxDistance = 500
            });
            local v218 = u3[v216];

            if v218 then
                if v217 then
                    v217 = v217:FindFirstChildWhichIsA("Sound");
                end;
            else
                v217 = v218;
            end;

            if v217 then
                v217.TimePosition = v218;
            end;

            strikeLightning(u215.plantPosition);
        end;

        if u213 ~= LocalPlayer.UserId then
            task.delay(3, function() -- Line: 1261
                -- upvalues: u45 (ref), u213 (copy), u215 (copy), LocalPlayer (ref), u7 (ref)
                if u45[u213] == u215 then
                    local v219 = u213;
                    local v220 = u45[v219];

                    if not v220 then
                        return;
                    end;

                    if v220 then
                        if v220.growthLoopThread then
                            task.cancel(v220.growthLoopThread);
                            v220.growthLoopThread = nil;
                        end;

                        if v220.growthEmitter then
                            v220.growthEmitter:Destroy();
                            v220.growthEmitter = nil;
                        end;
                    end;

                    if v220.plantModel then
                        v220.plantModel:Destroy();
                        v220.plantModel = nil;
                    end;

                    v220.currentStageIndex = 0;
                    u45[v219] = nil;

                    if v219 == LocalPlayer.UserId then
                        u7.localRoundVisible = false;
                        u7.localGhostGrowing = false;
                    end;
                end;
            end);

            return;
        end;

        u7.localGhostGrowing = false;

        if not u44 then
            u43 = "crashed";
            local u221;

            if u215 then
                u221 = u215.roundId;
            else
                u221 = u215;
            end;

            u58 = u58 + 1;
            u59 = nil;

            if u57 then
                u57:Disconnect();
                u57 = nil;
            end;

            if u56 then
                u56:Destroy();
                u56 = nil;
            end;

            if u221 then
                u59 = "Collect";
                local u222 = u58;
                local u223 = "Collect";
                task.spawn(function() -- Line: 473
                    -- upvalues: LocalPlayer (ref), u221 (copy), u222 (copy), u58 (ref), CustomProxPrompt (ref), u223 (copy), Knit (ref), CustomEnum (ref), u57 (ref), triggerHarvest (ref), ScreenGui (ref), u56 (ref)
                    local v224 = workspace:WaitForChild("BigField"):WaitForChild("PlantRound_" .. LocalPlayer.UserId .. "_" .. u221, 5);

                    if v224 then
                        v224 = v224:WaitForChild("MultDisplay", 5);
                    end;

                    if not v224 or u222 ~= u58 then
                        return;
                    end;

                    local v225 = CustomProxPrompt:Clone();
                    v225.Adornee = v224;
                    v225.MaxDistance = 10000;
                    v225.Enabled = true;
                    local Button = v225:FindFirstChild("Button");
                    local v226;

                    if Button then
                        v226 = Button:FindFirstChild("MainFrame");
                    else
                        v226 = Button;
                    end;

                    local v227;

                    if v226 then
                        v227 = v226:FindFirstChild("TextLabel");
                    else
                        v227 = v226;
                    end;

                    if v227 then
                        v227.Text = u223;
                    end;

                    if v226 then
                        v226 = v226:FindFirstChild("Keybind");
                    end;

                    if v226 then
                        v226.Image = Knit.GetController("UserInputParser"):getInputType() == CustomEnum.INPUT_TYPES.MOBILE and "rbxassetid://120515921874906" or "rbxassetid://74611557201552";
                    end;

                    if Button then
                        u57 = Button.Activated:Connect(triggerHarvest);
                    end;

                    v225.Parent = ScreenGui;
                    u56 = v225;
                end);
            end;
        end;

        SoundController:FadeOutSound("DistantThunderstorm", LocalPlayer, 1);
        u48 = true;
        u49 = os.clock();

        if u33:GetCurrent() == nil then
            setVfxEnabled(LightningRain, false);
            setVfxEnabled(NormalRain, true);
        end;

        task.delay(3, function() -- Line: 1247
            -- upvalues: u44 (ref), u45 (ref), u213 (copy), u215 (copy), LocalPlayer (ref), u7 (ref), u43 (ref), u42 (ref)
            if u44 then
                if u45[u213] == u215 then
                    local v228 = u213;
                    local v229 = u45[v228];

                    if not v229 then
                        return;
                    end;

                    if v229 then
                        if v229.growthLoopThread then
                            task.cancel(v229.growthLoopThread);
                            v229.growthLoopThread = nil;
                        end;

                        if v229.growthEmitter then
                            v229.growthEmitter:Destroy();
                            v229.growthEmitter = nil;
                        end;
                    end;

                    if v229.plantModel then
                        v229.plantModel:Destroy();
                        v229.plantModel = nil;
                    end;

                    v229.currentStageIndex = 0;
                    u45[v228] = nil;

                    if v228 == LocalPlayer.UserId then
                        u7.localRoundVisible = false;
                        u7.localGhostGrowing = false;
                    end;
                end;
            else
                if u43 ~= "crashed" then
                    return;
                end;

                u42 = false;
                u43 = "idle";
            end;
        end);
    end));
    v29:GiveTask(u32.RoundResetAll:Connect(function(p230) -- Line: 1273
        -- upvalues: u45 (copy), LocalPlayer (copy), u7 (ref), u42 (ref), u43 (ref), u44 (ref), u47 (ref), u48 (ref), u33 (copy), Clouds (copy), u5 (ref), u6 (ref), setVfxEnabled (copy), NormalRain (copy), LightningRain (copy), u58 (ref), u59 (ref), u57 (ref), u56 (ref)
        local v231 = u45[p230];

        if v231 then
            if v231 then
                if v231.growthLoopThread then
                    task.cancel(v231.growthLoopThread);
                    v231.growthLoopThread = nil;
                end;

                if v231.growthEmitter then
                    v231.growthEmitter:Destroy();
                    v231.growthEmitter = nil;
                end;
            end;

            if v231.plantModel then
                v231.plantModel:Destroy();
                v231.plantModel = nil;
            end;

            v231.currentStageIndex = 0;
            u45[p230] = nil;

            if p230 == LocalPlayer.UserId then
                u7.localRoundVisible = false;
                u7.localGhostGrowing = false;
            end;
        end;

        if p230 == LocalPlayer.UserId then
            u42 = false;
            u43 = "idle";
            u44 = false;
            u7.localRoundVisible = false;
            u47 = false;
            u48 = false;

            if u33:GetCurrent() == nil then
                Clouds.Cover = 0.83;
                Clouds.Density = 0.5;
                Clouds.Color = u5:Lerp(u6, 0);
                setVfxEnabled(NormalRain, true);
                setVfxEnabled(LightningRain, false);
            end;

            u58 = u58 + 1;
            u59 = nil;

            if u57 then
                u57:Disconnect();
                u57 = nil;
            end;

            if u56 then
                u56:Destroy();
                u56 = nil;
            end;
        end;
    end));
    u28._maid = v29;
end;

function u7.KnitInit(p232) -- Line: 1292
    -- upvalues: Knit (copy)
    p232.UI_Manager = Knit.GetController("UI_Manager");
    p232.SoundController = Knit.GetController("SoundController");
    p232.ParticleController = Knit.GetController("ParticleController");
end;

return u7;