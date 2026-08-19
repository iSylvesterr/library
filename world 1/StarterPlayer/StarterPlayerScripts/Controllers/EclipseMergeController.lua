-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ProximityPromptService = game:GetService("ProximityPromptService");
local TweenService = game:GetService("TweenService");
local SoundService = game:GetService("SoundService");
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local MergeFlags = require(ReplicatedStorage.SharedModules.Flags.MergeFlags);
local GuiController = require(LocalPlayer.PlayerScripts.Controllers.GuiController);
local GardenSyncController = require(script.Parent.GardenSyncController);
local PlantVisualizerController = require(script.Parent.PlantVisualizerController);
local NotificationController = require(script.Parent.NotificationController);
local u1 = Color3.fromRGB(150, 45, 255);
local u2 = Color3.fromRGB(120, 30, 220);
local u3 = {
    ["Sun Bloom"] = "Moon Bloom",
    ["Moon Bloom"] = "Sun Bloom"
};
local v4 = {
    StartOrder = 6
};
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = false;
local u11 = {};
local u12 = {};
local u13 = nil;
local u14 = false;

local function getPlantsFolder() -- Line: 59
    -- upvalues: PlantVisualizerController (copy), LocalPlayer (copy)
    return PlantVisualizerController:GetPlantsFolder(LocalPlayer.UserId);
end;

local function isFullyGrownModel(p15) -- Line: 63
    local v16 = p15:GetAttribute("Age");
    local v17 = p15:GetAttribute("MaxAge");

    if type(v16) == "number" and type(v17) == "number" then
        return v17 <= v16;
    end;

    return false;
end;

local function isPotted(p18) -- Line: 73
    -- upvalues: GardenSyncController (copy), LocalPlayer (copy)
    local v19 = GardenSyncController:GetPlant(LocalPlayer.UserId, p18);
    local v20;

    if v19 == nil then
        v20 = false;
    else
        v20 = v19.IsPotted == true;
    end;

    return v20;
end;

local function getOrCreateMergePart(p21) -- Line: 78
    local MergePart = p21:FindFirstChild("MergePart");

    if MergePart and MergePart:IsA("BasePart") then
        return MergePart;
    end;

    local v22 = p21.PrimaryPart or p21:FindFirstChildWhichIsA("BasePart");

    if not v22 then
        return nil;
    end;

    local Part = Instance.new("Part");
    Part.Name = "MergePart";
    Part.Size = Vector3.new(1, 1, 1);
    Part.Transparency = 1;
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanTouch = false;
    Part.CanQuery = false;
    Part.CFrame = v22.CFrame;
    Part.Parent = p21;

    return Part;
end;

local function addPromptToModel(p23, p24) -- Line: 98
    -- upvalues: getOrCreateMergePart (copy), MergeFlags (copy)
    if p23:FindFirstChild("MergePrompt", true) then
        return;
    end;

    local v25 = getOrCreateMergePart(p23);

    if not v25 then
        return;
    end;

    local ProximityPrompt = Instance.new("ProximityPrompt");
    ProximityPrompt.Name = "MergePrompt";
    ProximityPrompt.ActionText = "Merge";
    ProximityPrompt.ObjectText = "Eclipse Bloom";
    ProximityPrompt.MaxActivationDistance = 10;
    ProximityPrompt.RequiresLineOfSight = false;
    ProximityPrompt.HoldDuration = MergeFlags.PromptHoldSeconds:Get();
    ProximityPrompt.KeyboardKeyCode = Enum.KeyCode.M;
    ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom;
    ProximityPrompt:SetAttribute("PlantId", p24);
    ProximityPrompt:AddTag("MergePrompt");
    ProximityPrompt.Parent = v25;
end;

local function removePromptFromModel(p26) -- Line: 117
    if not p26 then
        return;
    end;

    local MergePrompt = p26:FindFirstChild("MergePrompt", true);

    if MergePrompt then
        MergePrompt:Destroy();
    end;

    local MergePart = p26:FindFirstChild("MergePart");

    if MergePart then
        MergePart:Destroy();
    end;
end;

local function collectParents(p27) -- Line: 126
    -- upvalues: LocalPlayer (copy), u3 (copy), u11 (copy), GardenSyncController (copy)
    local v28 = {
        ["Sun Bloom"] = {},
        ["Moon Bloom"] = {}
    };

    for _, child in p27:GetChildren() do
        if child:IsA("Model") and child:GetAttribute("UserId") == LocalPlayer.UserId then
            local v29 = child:GetAttribute("SeedName");

            if type(v29) == "string" and (u3[v29] and not u11[child.Name]) then
                local v30 = child:GetAttribute("Age");
                local v31 = child:GetAttribute("MaxAge");
                local v32;

                if type(v30) == "number" and type(v31) == "number" then
                    v32 = v31 <= v30;
                else
                    v32 = false;
                end;

                if v32 then
                    local v33 = child:GetAttribute("PlantId");

                    if type(v33) == "string" then
                        local v34 = GardenSyncController:GetPlant(LocalPlayer.UserId, v33);
                        local v35;

                        if v34 == nil then
                            v35 = false;
                        else
                            v35 = v34.IsPotted == true;
                        end;

                        if not v35 then
                            local v36 = v28[v29];
                            local v37 = {
                                model = child,
                                plantId = v33,
                                position = child:GetPivot().Position
                            };
                            table.insert(v36, v37);
                        end;
                    end;
                end;
            end;
        end;
    end;

    return v28;
end;

local function sweep() -- Line: 151
    -- upvalues: PlantVisualizerController (copy), LocalPlayer (copy), MergeFlags (copy), collectParents (copy), u12 (copy), addPromptToModel (copy)
    local v38 = {};
    local v39 = PlantVisualizerController:GetPlantsFolder(LocalPlayer.UserId);

    if MergeFlags.Enabled:Get() and v39 then
        local v40 = collectParents(v39);
        local v41 = MergeFlags.RangeStuds:Get();

        for _, v in v40["Sun Bloom"] do
            for _, v2 in v40["Moon Bloom"] do
                if (v.position - v2.position).Magnitude <= v41 then
                    v38[v.model.Name] = v;
                    v38[v2.model.Name] = v2;
                end;
            end;
        end;
    end;

    for i in u12 do
        if not v38[i] then
            local v42;

            if v39 then
                v42 = v39:FindFirstChild(i);
            else
                v42 = v39;
            end;

            if v42 then
                local MergePrompt = v42:FindFirstChild("MergePrompt", true);

                if MergePrompt then
                    MergePrompt:Destroy();
                end;

                local MergePart = v42:FindFirstChild("MergePart");

                if MergePart then
                    MergePart:Destroy();
                end;
            end;

            u12[i] = nil;
        end;
    end;

    for i, v in v38 do
        if not u12[i] then
            addPromptToModel(v.model, v.plantId);
            u12[i] = true;
        end;
    end;
end;

local function findPartner(p43) -- Line: 185
    -- upvalues: PlantVisualizerController (copy), LocalPlayer (copy), u3 (copy), MergeFlags (copy), u11 (copy), GardenSyncController (copy)
    local v44 = PlantVisualizerController:GetSpawnedPlant(LocalPlayer.UserId, p43);

    if not v44 then
        return nil;
    end;

    local v45 = u3[v44:GetAttribute("SeedName")];

    if not v45 then
        return nil;
    end;

    local v46 = PlantVisualizerController:GetPlantsFolder(LocalPlayer.UserId);

    if not v46 then
        return nil;
    end;

    local Position = v44:GetPivot().Position;
    local v47 = MergeFlags.RangeStuds:Get();
    local v48 = (1 / 0);
    local v49 = nil;

    for _, child in v46:GetChildren() do
        if child:IsA("Model") and (child:GetAttribute("SeedName") == v45 and (child:GetAttribute("UserId") == LocalPlayer.UserId and not u11[child.Name])) then
            local v50 = child:GetAttribute("Age");
            local v51 = child:GetAttribute("MaxAge");
            local v52;

            if type(v50) == "number" and type(v51) == "number" then
                v52 = v51 <= v50;
            else
                v52 = false;
            end;

            if v52 then
                local v53 = child:GetAttribute("PlantId");

                if type(v53) == "string" and v53 ~= p43 then
                    local v54 = GardenSyncController:GetPlant(LocalPlayer.UserId, v53);
                    local v55;

                    if v54 == nil then
                        v55 = false;
                    else
                        v55 = v54.IsPotted == true;
                    end;

                    if not v55 then
                        local Magnitude = (Position - child:GetPivot().Position).Magnitude;

                        if Magnitude <= v47 and Magnitude < v48 then
                            v49 = v53;
                            v48 = Magnitude;
                        end;
                    end;
                end;
            end;
        end;
    end;

    return v49;
end;

local function closeGui() -- Line: 217
    -- upvalues: u9 (ref), u7 (ref), u5 (ref), GuiController (copy)
    u9 = nil;

    if u7 then
        u7.Active = true;
    end;

    if u5 and GuiController:IsOpen("EclipseMerge") then
        GuiController:Close();
    end;
end;

local function openMergeGui(p56, p57) -- Line: 225
    -- upvalues: u5 (ref), u9 (ref), u7 (ref), GuiController (copy)
    if not u5 then
        return;
    end;

    u9 = {
        promptId = p56,
        partnerId = p57
    };

    if u7 then
        u7.Active = true;
    end;

    GuiController:Open("EclipseMerge", nil, { "HUD" });
end;

local function submitMerge() -- Line: 232
    -- upvalues: u10 (ref), u9 (ref), u7 (ref), Networking (copy), u5 (ref), GuiController (copy), NotificationController (copy)
    if u10 then
        return;
    end;

    local u58 = u9;

    if not u58 then
        return;
    end;

    u10 = true;

    if u7 then
        u7.Active = false;
    end;

    task.spawn(function() -- Line: 240
        -- upvalues: Networking (ref), u58 (copy), u10 (ref), u7 (ref), u9 (ref), u5 (ref), GuiController (ref), NotificationController (ref)
        local v59, v60, v61 = pcall(function() -- Line: 241
            -- upvalues: Networking (ref), u58 (ref)
            return Networking.Garden.RequestMerge:Fire(u58.promptId, u58.partnerId);
        end);
        u10 = false;

        if u7 then
            u7.Active = true;
        end;

        u9 = nil;

        if u7 then
            u7.Active = true;
        end;

        if u5 and GuiController:IsOpen("EclipseMerge") then
            GuiController:Close();
        end;

        if v59 and (v60 == false and (type(v61) == "string" and v61 ~= "")) then
            NotificationController:CreateNotification(v61);
        end;
    end);
end;

local u62 = { "ExitButton", "CloseButton", "XButton", "X", "Close", "Exit" };

local function resolveRefs(p63) -- Line: 256
    -- upvalues: u62 (copy), u8 (ref), u6 (ref), u7 (ref)
    local Frame = p63:FindFirstChild("Frame");

    if not Frame then
        return;
    end;

    for _, v in u62 do
        local v64 = Frame:FindFirstChild(v, true);

        if v64 and v64:IsA("GuiButton") then
            u8 = v64;
            break;
        end;
    end;

    local Content = Frame:FindFirstChild("Content");

    if not Content then
        return;
    end;

    local Buttons = Content:FindFirstChild("Buttons");

    if not Buttons then
        return;
    end;

    local CancelButton = Buttons:FindFirstChild("CancelButton");
    local MergeButton = Buttons:FindFirstChild("MergeButton");

    if CancelButton and CancelButton:IsA("GuiButton") then
        u6 = CancelButton;
    end;

    if MergeButton and MergeButton:IsA("GuiButton") then
        u7 = MergeButton;
    end;
end;

local function bindButtons() -- Line: 281
    -- upvalues: u8 (ref), closeGui (copy), u6 (ref), u7 (ref), submitMerge (copy)
    if u8 then
        u8.MouseButton1Click:Connect(closeGui);
    end;

    if u6 then
        u6.MouseButton1Click:Connect(closeGui);
    end;

    if u7 then
        u7.MouseButton1Click:Connect(submitMerge);
    end;
end;

local function playMergeSound(p65) -- Line: 297
    -- upvalues: SoundService (copy)
    if not p65 then
        return;
    end;

    local EclipseMerge = SoundService:FindFirstChild("EclipseMerge", true);

    if not (EclipseMerge and EclipseMerge:IsA("Sound")) then
        warn("[EclipseMergeController] EclipseMerge sound not found under SoundService");

        return;
    end;

    local v66 = EclipseMerge:Clone();
    v66.Parent = p65;
    v66.PlayOnRemove = true;
    v66:Destroy();
end;

local function makePulseHighlight(p67) -- Line: 311
    -- upvalues: u1 (copy)
    if not p67 then
        return nil;
    end;

    local Highlight = Instance.new("Highlight");
    Highlight.Name = "EclipseMergePulse";
    Highlight.FillColor = u1;
    Highlight.OutlineColor = u1;
    Highlight.FillTransparency = 1;
    Highlight.OutlineTransparency = 1;
    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded;
    Highlight.Adornee = p67;
    Highlight.Parent = p67;

    return Highlight;
end;

local function tweenHighlight(p68, p69, p70) -- Line: 325
    -- upvalues: TweenService (copy)
    if not p68 then
        return;
    end;

    TweenService:Create(p68, TweenInfo.new(p70, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
        FillTransparency = p69 and 0.2 or 1,
        OutlineTransparency = p69 and 0.1 or 1
    }):Play();
end;

local function ensureFlashFrame() -- Line: 336
    -- upvalues: u13 (ref), u2 (copy), PlayerGui (copy)
    if u13 and u13.Parent then
        return u13;
    end;

    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "EclipseMergeFlash";
    ScreenGui.IgnoreGuiInset = true;
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.DisplayOrder = 1000000;
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
    local Frame = Instance.new("Frame");
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.BackgroundColor3 = u2;
    Frame.BackgroundTransparency = 1;
    Frame.BorderSizePixel = 0;
    Frame.Parent = ScreenGui;
    ScreenGui.Parent = PlayerGui;
    u13 = Frame;

    return Frame;
end;

local function fadeOutScreenFlash() -- Line: 359
    -- upvalues: u14 (ref), u13 (ref), TweenService (copy)
    if not u14 then
        return;
    end;

    u14 = false;

    if not u13 then
        return;
    end;

    TweenService:Create(u13, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 1
    }):Play();
end;

local function playScreenFlash() -- Line: 372
    -- upvalues: ensureFlashFrame (copy), u14 (ref), TweenService (copy)
    local v71 = ensureFlashFrame();
    u14 = true;
    v71.BackgroundTransparency = 1;
    TweenService:Create(v71, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0
    }):Play();
end;

local function watchEclipseGrowthThenFade(p72, p73) -- Line: 387
    -- upvalues: PlantVisualizerController (copy), u14 (ref), fadeOutScreenFlash (copy)
    local v74 = os.clock() + 10;
    local v75;

    while true do
        v75 = PlantVisualizerController:GetSpawnedPlant(p72, p73);

        if v75 then
            break;
        end;

        task.wait(0.1);

        if v74 < os.clock() then
            break;
        end;
    end;

    if v75 then
        local v76 = v75:GetAttribute("Age");

        if type(v76) ~= "number" then
            v76 = 0;
        end;

        while u14 and (os.clock() < v74 and v75.Parent) do
            local v77 = v75:GetAttribute("Age");

            if type(v77) == "number" and v76 + 0.01 < v77 then
                break;
            end;

            task.wait();
        end;
    end;

    fadeOutScreenFlash();
end;

local function playMergeAnimation(p78, p79, p80, p81) -- Line: 415
    -- upvalues: u11 (copy), PlantVisualizerController (copy), playMergeSound (copy), u12 (copy), LocalPlayer (copy), u9 (ref), u7 (ref), u5 (ref), GuiController (copy), u1 (copy), MergeFlags (copy), tweenHighlight (copy), GardenSyncController (copy), playScreenFlash (copy), watchEclipseGrowthThenFade (copy)
    local v82 = `{p78}_{p79}`;
    local v83 = `{p78}_{p80}`;
    u11[v82] = true;
    u11[v83] = true;
    local v84 = PlantVisualizerController:GetSpawnedPlant(p78, p79);
    local v85 = PlantVisualizerController:GetSpawnedPlant(p78, p80);
    local v86 = v84 or v85;

    if v86 then
        playMergeSound(v86.PrimaryPart or v86:FindFirstChildWhichIsA("BasePart"));
    end;

    if v84 then
        local MergePrompt = v84:FindFirstChild("MergePrompt", true);

        if MergePrompt then
            MergePrompt:Destroy();
        end;

        local MergePart = v84:FindFirstChild("MergePart");

        if MergePart then
            MergePart:Destroy();
        end;
    end;

    if v85 then
        local MergePrompt = v85:FindFirstChild("MergePrompt", true);

        if MergePrompt then
            MergePrompt:Destroy();
        end;

        local MergePart = v85:FindFirstChild("MergePart");

        if MergePart then
            MergePart:Destroy();
        end;
    end;

    u12[v82] = nil;
    u12[v83] = nil;

    if p78 == LocalPlayer.UserId then
        u9 = nil;

        if u7 then
            u7.Active = true;
        end;

        if u5 and GuiController:IsOpen("EclipseMerge") then
            GuiController:Close();
        end;
    end;

    local v87;

    if v84 then
        v87 = Instance.new("Highlight");
        v87.Name = "EclipseMergePulse";
        v87.FillColor = u1;
        v87.OutlineColor = u1;
        v87.FillTransparency = 1;
        v87.OutlineTransparency = 1;
        v87.DepthMode = Enum.HighlightDepthMode.Occluded;
        v87.Adornee = v84;
        v87.Parent = v84;
    else
        v87 = nil;
    end;

    local v88;

    if v85 then
        v88 = Instance.new("Highlight");
        v88.Name = "EclipseMergePulse";
        v88.FillColor = u1;
        v88.OutlineColor = u1;
        v88.FillTransparency = 1;
        v88.OutlineTransparency = 1;
        v88.DepthMode = Enum.HighlightDepthMode.Occluded;
        v88.Adornee = v85;
        v88.Parent = v85;
    else
        v88 = nil;
    end;

    local v89 = MergeFlags.PulseSeconds:Get();
    local v90 = os.clock();
    local v91 = 0;

    while os.clock() - v90 < v89 do
        local v92 = (os.clock() - v90) / v89;
        local v93 = math.clamp(v92, 0, 1);
        local v94 = math.lerp(0.5, 0.08, v93);
        local v95 = v91 % 2 == 0;
        tweenHighlight(v87, v95, v94);
        tweenHighlight(v88, not v95, v94);
        v91 = v91 + 1;
        task.wait(v94);
    end;

    if v87 then
        v87:Destroy();
    end;

    if v88 then
        v88:Destroy();
    end;

    GardenSyncController:HandlePlantRemoved(p78, p79);
    GardenSyncController:HandlePlantRemoved(p78, p80);
    u11[v82] = nil;
    u11[v83] = nil;

    if p78 == LocalPlayer.UserId then
        playScreenFlash();
        task.spawn(watchEclipseGrowthThenFade, p78, p81);
    end;
end;

function v4.Init(p96) -- Line: 475
end;

function v4.Start(p97) -- Line: 477
    -- upvalues: PlayerGui (copy), u5 (ref), resolveRefs (copy), u8 (ref), closeGui (copy), u6 (ref), u7 (ref), submitMerge (copy), GuiController (copy), u9 (ref), ProximityPromptService (copy), LocalPlayer (copy), MergeFlags (copy), findPartner (copy), NotificationController (copy), openMergeGui (copy), Networking (copy), playMergeAnimation (copy), GardenSyncController (copy), sweep (copy)
    task.spawn(function() -- Line: 478
        -- upvalues: PlayerGui (ref), u5 (ref), resolveRefs (ref), u8 (ref), closeGui (ref), u6 (ref), u7 (ref), submitMerge (ref), GuiController (ref), u9 (ref)
        local EclipseMerge = PlayerGui:WaitForChild("EclipseMerge", 60);

        if EclipseMerge and EclipseMerge:IsA("ScreenGui") then
            u5 = EclipseMerge;
            EclipseMerge.Enabled = false;
            resolveRefs(EclipseMerge);

            if u8 then
                u8.MouseButton1Click:Connect(closeGui);
            end;

            if u6 then
                u6.MouseButton1Click:Connect(closeGui);
            end;

            if u7 then
                u7.MouseButton1Click:Connect(submitMerge);
            end;

            GuiController.GuiUnfocusedSignal:Connect(function(p98) -- Line: 486
                -- upvalues: EclipseMerge (copy), u9 (ref), u7 (ref)
                if p98 == EclipseMerge then
                    u9 = nil;

                    if u7 then
                        u7.Active = true;
                    end;
                end;
            end);
        end;
    end);
    ProximityPromptService.PromptTriggered:Connect(function(p99, p100) -- Line: 495
        -- upvalues: LocalPlayer (ref), MergeFlags (ref), findPartner (ref), NotificationController (ref), openMergeGui (ref)
        if p100 ~= LocalPlayer then
            return;
        end;

        if not p99:HasTag("MergePrompt") then
            return;
        end;

        if not MergeFlags.Enabled:Get() then
            return;
        end;

        local v101 = p99:GetAttribute("PlantId");

        if type(v101) ~= "string" then
            return;
        end;

        local v102 = findPartner(v101);

        if v102 then
            openMergeGui(v101, v102);

            return;
        end;

        NotificationController:CreateNotification("No nearby plant to merge with!");
    end);
    Networking.Garden.MergeStarted.OnClientEvent:Connect(function(p103, p104, p105, p106) -- Line: 509
        -- upvalues: playMergeAnimation (ref)
        if type(p103) ~= "number" or (type(p104) ~= "string" or type(p105) ~= "string") then
            return;
        end;

        if type(p106) ~= "string" then
            return;
        end;

        task.spawn(playMergeAnimation, p103, p104, p105, p106);
    end);
    GardenSyncController:OnPlantMoved(function() -- Line: 518
        -- upvalues: sweep (ref)
        task.spawn(sweep);
    end);
    GardenSyncController:OnPlantRemoved(function() -- Line: 519
        -- upvalues: sweep (ref)
        task.spawn(sweep);
    end);
    MergeFlags.Enabled.Changed:Connect(function() -- Line: 520
        -- upvalues: sweep (ref)
        task.spawn(sweep);
    end);
    task.spawn(function() -- Line: 522
        -- upvalues: sweep (ref)
        while true do
            local v107 = { pcall(sweep) };

            if not v107[1] then
                warn((`[EclipseMergeController] sweep errored: {v107[2]}`));
            end;

            task.wait(0.4);
        end;
    end);
end;

return v4;