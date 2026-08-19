-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local MarketplaceService = game:GetService("MarketplaceService");
local Players = game:GetService("Players");
local ProximityPromptService = game:GetService("ProximityPromptService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local SoundService = game:GetService("SoundService");
local UserInputService = game:GetService("UserInputService");
local Knit = require(ReplicatedStorage.Packages.Knit);
local Maid = require(ReplicatedStorage.Packages.Maid);
local SeedConfig = require(ReplicatedStorage.Shared.Info.SeedConfig);
local MutationConfig = require(ReplicatedStorage.Shared.Info.MutationConfig);
local MutationText = require(ReplicatedStorage.Shared.Utility.MutationText);
local MutationRecolor = require(ReplicatedStorage.Shared.Utility.MutationRecolor);
local TreeMountPoint = require(ReplicatedStorage.Shared.Utility.TreeMountPoint);
local AbbreviateNumber = require(ReplicatedStorage.Shared.Utility.AbbreviateNumber);
local ExpandedRarities = require(ReplicatedStorage.Shared.Info.ExpandedRarities);
local Products = require(ReplicatedStorage.Shared.Info.Products);
local CustomEnum = require(ReplicatedStorage.Shared.Info.CustomEnum);
local PetAssets = require(ReplicatedStorage.Shared.Utility.PetAssets);
local F = Enum.KeyCode.F;
local u1 = Knit.CreateController({
    Name = "PlayerPlotController"
});

local function formatCountdown(p2) -- Line: 54
    local v3 = math.floor(p2);
    local v4 = math.max(0, v3);
    local v5 = math.floor(v4 / 3600);
    local v6 = math.floor(v4 % 3600 / 60);
    local v7 = v4 % 60;

    if v5 > 0 then
        return string.format("%dh %dm %ds", v5, v6, v7);
    end;

    if v6 > 0 then
        return string.format("%dm %ds", v6, v7);
    end;

    return string.format("%ds", v7);
end;

local function getEquippedTreeTool(p8) -- Line: 67
    local Character = p8.Character;

    if not Character then
        return nil;
    end;

    for _, child in Character:GetChildren() do
        if child:IsA("Tool") and child:GetAttribute("IsTree") then
            return child;
        end;
    end;

    return nil;
end;

local function getEquippedPetTool(p9) -- Line: 78
    local Character = p9.Character;

    if not Character then
        return nil;
    end;

    for _, child in Character:GetChildren() do
        if child:IsA("Tool") and child:GetAttribute("IsPet") then
            return child;
        end;
    end;

    return nil;
end;

local function getEquippedEggTool(p10) -- Line: 89
    local Character = p10.Character;

    if not Character then
        return nil;
    end;

    for _, child in Character:GetChildren() do
        if child:IsA("Tool") and child:GetAttribute("IsEgg") then
            return child;
        end;
    end;

    return nil;
end;

local function getEquippedAxe(p11) -- Line: 100
    local Character = p11.Character;

    if not Character then
        return nil;
    end;

    for _, child in Character:GetChildren() do
        if child:IsA("Tool") and child:GetAttribute("IsAxe") then
            return child;
        end;
    end;

    return nil;
end;

local function getFruitModelHeight(p12) -- Line: 111
    local v13 = (1 / 0);
    local v14 = (-1 / 0);

    for _, descendant in p12:GetDescendants() do
        if descendant:IsA("BasePart") then
            local CFrame2 = descendant.CFrame;
            local Size = descendant.Size;
            local v15 = math.abs(CFrame2.RightVector.Y) * Size.X / 2 + math.abs(CFrame2.UpVector.Y) * Size.Y / 2 + math.abs(CFrame2.LookVector.Y) * Size.Z / 2;
            local v16 = CFrame2.Position.Y + v15;
            local v17 = CFrame2.Position.Y - v15;

            if v17 >= v13 then
                v17 = v13;
            end;

            if v14 < v16 then
                v14 = v16;
                v13 = v17;
            else
                v13 = v17;
            end;
        end;
    end;

    return v13 == (1 / 0) and 1 or math.max(v14 - v13, 0.1);
end;

function u1.KnitStart(p18) -- Line: 134
    -- upvalues: Maid (copy), Players (copy), UserInputService (copy), Knit (copy), SoundService (copy), ReplicatedStorage (copy), MarketplaceService (copy), Products (copy), CustomEnum (copy), getEquippedTreeTool (copy), getEquippedEggTool (copy), getEquippedPetTool (copy), RunService (copy), PetAssets (copy), SeedConfig (copy), getFruitModelHeight (copy), MutationRecolor (copy), TreeMountPoint (copy), F (copy), MutationText (copy), AbbreviateNumber (copy), MutationConfig (copy), u1 (copy), formatCountdown (copy), ProximityPromptService (copy), ExpandedRarities (copy), CollectionService (copy), getEquippedAxe (copy)
    local u19 = Maid.new();
    p18._maid = u19;
    local LocalPlayer = Players.LocalPlayer;
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
    local CurrentCamera = workspace.CurrentCamera;
    local u20 = LocalPlayer:GetMouse();
    local u21 = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled;
    local u22 = Knit.GetService("PlayerPlotService");
    local u23 = Knit.GetService("PurchaseManager");
    local u24 = Knit.GetController("SoundController");
    local u25 = Knit.GetController("DataClient");
    local FruitHarvest = SoundService:FindFirstChild("FruitHarvest", true);
    local u26 = nil;

    local function playHarvestSound() -- Line: 152
        -- upvalues: FruitHarvest (copy), u24 (copy), LocalPlayer (copy), u26 (ref)
        local v27 = FruitHarvest and FruitHarvest:GetChildren();

        if not v27 or #v27 == 0 then
            u24:PlaySound("FruitHarvest", LocalPlayer);

            return;
        end;

        local v28 = {};

        for _, v in v27 do
            if v ~= u26 then
                table.insert(v28, v);
            end;
        end;

        if #v28 ~= 0 then
            v27 = v28;
        end;

        local v29 = v27[math.random(1, #v27)];
        u26 = v29;
        u24:PlaySound(v29, LocalPlayer);
    end;

    local CursorUI = PlayerGui:WaitForChild("HUD"):WaitForChild("CursorUI");
    local PlantSeed = CursorUI:FindFirstChild("PlantSeed");

    if PlantSeed then
        PlantSeed:FindFirstChild("TextLabel");
    end;

    local TreeInfo = CursorUI:FindFirstChild("TreeInfo");
    local HoverInfo = CursorUI:FindFirstChild("HoverInfo");
    local u30 = false;

    if PlantSeed then
        PlantSeed.Visible = false;
    end;

    if TreeInfo then
        TreeInfo.Visible = false;
    end;

    CursorUI.Visible = false;
    local Greedy = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Greedy");
    local FruitModels = Greedy:WaitForChild("FruitModels");
    local PlantStages = Greedy:FindFirstChild("PlantStages");
    local FruitBillboard_WithPrompt = Greedy:WaitForChild("UI"):WaitForChild("FruitBillboard_WithPrompt");
    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "PlotBillboards";
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.Parent = PlayerGui;

    local function setupCustomPromptButton(p31, p32, u33) -- Line: 196
        -- upvalues: u21 (copy), u19 (copy)
        p31.Visible = false;
        local MainFrame = p31:FindFirstChild("MainFrame");
        local v34;

        if MainFrame then
            v34 = MainFrame:FindFirstChild("TextLabel");
        else
            v34 = MainFrame;
        end;

        if MainFrame then
            MainFrame = MainFrame:FindFirstChild("Keybind");
        end;

        if v34 then
            v34.Text = p32;
        end;

        if MainFrame then
            MainFrame.Image = u21 and "rbxassetid://120515921874906" or "rbxassetid://74611557201552";
        end;

        u19:GiveTask(p31.Activated:Connect(function() -- Line: 203
            -- upvalues: u33 (copy)
            local v35 = u33();

            if v35 then
                v35:InputHoldBegin();
                task.wait();
                v35:InputHoldEnd();
            end;
        end));
    end;

    local u36 = nil;
    local u37 = nil;
    local u38 = nil;
    local u39 = nil;
    local u40 = 0;
    local u41 = nil;
    local u42 = false;
    local u43 = false;
    local u44 = {};
    local u45 = {};
    local u46 = {};
    local u47 = false;
    local u48 = false;
    local u49 = { "GrowAll", "CollectAll", "GroupRewardStand", "CraftingBench" };
    local u50 = {};
    local u51 = "GrowAll10";
    local u52 = nil;
    local u53 = {
        {
            icon = UDim2.new(0.425, 0, 0.5, 0),
            text = UDim2.new(0.575, 0, 0.5, 0)
        },
        {
            icon = UDim2.new(0.375, 0, 0.5, 0),
            text = UDim2.new(0.525, 0, 0.5, 0)
        },
        {
            icon = UDim2.new(0.325, 0, 0.5, 0),
            text = UDim2.new(0.475, 0, 0.5, 0)
        }
    };
    local u54 = {};

    local function getProductPrice(u55) -- Line: 254
        -- upvalues: u54 (copy), MarketplaceService (ref)
        if u54[u55] then
            return u54[u55];
        end;

        local success, result = pcall(function() -- Line: 256
            -- upvalues: MarketplaceService (ref), u55 (copy)
            return MarketplaceService:GetProductInfo(u55, Enum.InfoType.Product);
        end);

        if not (success and (result and result.PriceInRobux)) then
            return nil;
        end;

        u54[u55] = result.PriceInRobux;

        return result.PriceInRobux;
    end;

    local function setSignPrice(p56, p57) -- Line: 265
        -- upvalues: u37 (ref), Products (ref), u54 (copy), MarketplaceService (ref), u53 (copy)
        local v58 = u37 and u37:FindFirstChild(p56);

        if v58 then
            v58 = v58:FindFirstChild("SubSign");
        end;

        if v58 then
            v58 = v58:FindFirstChild("SurfaceGui");
        end;

        if v58 then
            v58 = v58:FindFirstChild("MainFrame");
        end;

        if v58 then
            v58 = v58:FindFirstChild("Frame");
        end;

        if not v58 then
            return;
        end;

        local Id = Products[p57].Id;
        local v59;

        if u54[Id] then
            v59 = u54[Id];
        else
            local success, result = pcall(function() -- Line: 256
                -- upvalues: MarketplaceService (ref), Id (copy)
                return MarketplaceService:GetProductInfo(Id, Enum.InfoType.Product);
            end);

            if success and (result and result.PriceInRobux) then
                u54[Id] = result.PriceInRobux;
                v59 = result.PriceInRobux;
            else
                v59 = nil;
            end;
        end;

        if not v59 then
            return;
        end;

        local v60 = tostring(v59);
        local v61 = u53[math.clamp(#v60, 1, 3)];
        local Price = v58:FindFirstChild("Price");
        local Icon = v58:FindFirstChild("Icon");

        if Price then
            Price.Text = v60;
            Price.Position = v61.text;
        end;

        if Icon then
            Icon.Position = v61.icon;
        end;
    end;

    local function signAllowed(p62) -- Line: 286
        -- upvalues: u25 (copy)
        local v63 = u25 and u25.currentData;

        if p62 == "CollectAll" or p62 == "CraftingBench" then
            local v64;

            if v63 == nil then
                v64 = false;
            else
                v64 = (v63.Rebirth or 0) >= 1;
            end;

            return v64;
        end;

        if p62 ~= "GroupRewardStand" then
            return true;
        end;

        local v65;

        if v63 == nil or (v63.Rebirth or 0) < 1 then
            v65 = false;
        else
            v65 = not v63.ClaimedGroupReward;
        end;

        return v65;
    end;

    local function setSignVisible(p66, p67, p68) -- Line: 297
        local v69 = p66:FindFirstChild(p67);

        if not v69 then
            return;
        end;

        for _, descendant in v69:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.LocalTransparencyModifier = p68 and 0 or 1;
                descendant.CanCollide = p68;
            elseif descendant:IsA("ParticleEmitter") then
                descendant.Enabled = p68;
            elseif descendant:IsA("SurfaceGui") or descendant:IsA("BillboardGui") then
                descendant.Enabled = p68;
            end;
        end;
    end;

    local function refreshLikePrompts() -- Line: 314
        -- upvalues: u25 (copy), LocalPlayer (copy)
        local v70 = workspace:FindFirstChild("BigField") and workspace.BigField:FindFirstChild("PlayerPlots");

        if not v70 then
            return;
        end;

        local v71 = u25 and u25.currentData;
        local v72 = v71 and v71.LikedPlots or {};

        for _, child in v70:GetChildren() do
            if child:IsA("Model") and child.Name:match("^PlayerPlot") then
                local OwnerSign = child:FindFirstChild("OwnerSign");

                if OwnerSign then
                    OwnerSign = OwnerSign:FindFirstChild("PromptPart");
                end;

                if OwnerSign then
                    OwnerSign = OwnerSign:FindFirstChild("LikePrompt");
                end;

                if OwnerSign then
                    local v73 = child:GetAttribute("OwnerUserId");
                    local v74;

                    if v73 == nil or v73 == LocalPlayer.UserId then
                        v74 = false;
                    else
                        v74 = not v72[tostring(v73)];
                    end;

                    OwnerSign.Enabled = v74;
                end;
            end;
        end;
    end;

    local function refreshCompostBins() -- Line: 333
        -- upvalues: u25 (copy), LocalPlayer (copy)
        local v75 = workspace:FindFirstChild("BigField") and workspace.BigField:FindFirstChild("PlayerPlots");

        if not v75 then
            return;
        end;

        local v76 = (u25 and u25.currentData or {}).UsedCompost == true;

        for _, child in v75:GetChildren() do
            if child:IsA("Model") and child.Name:match("^PlayerPlot") then
                local CompostBin = child:FindFirstChild("CompostBin");

                if CompostBin then
                    local v77 = child:GetAttribute("OwnerUserId") == LocalPlayer.UserId;

                    for _, descendant in CompostBin:GetDescendants() do
                        if descendant:IsA("BasePart") then
                            descendant.LocalTransparencyModifier = v77 and 0 or 1;
                            descendant.CanCollide = v77;
                        elseif descendant:IsA("ParticleEmitter") or (descendant:IsA("SurfaceGui") or (descendant:IsA("BillboardGui") or descendant:IsA("ProximityPrompt"))) then
                            local v78;

                            if v77 then
                                local v79;

                                if descendant.Name == "Alert" then
                                    v79 = v76;
                                else
                                    v79 = false;
                                end;

                                v78 = not v79;
                            else
                                v78 = v77;
                            end;

                            descendant.Enabled = v78;
                        end;
                    end;
                end;
            end;
        end;
    end;

    task.spawn(function() -- Line: 354
        -- upvalues: u19 (copy), refreshLikePrompts (copy), refreshCompostBins (copy), u25 (copy)
        local BigField = workspace:WaitForChild("BigField", 30);

        if BigField then
            BigField = BigField:WaitForChild("PlayerPlots", 30);
        end;

        if not BigField then
            return;
        end;

        local function hookPlot(p80) -- Line: 358
            -- upvalues: u19 (ref), refreshLikePrompts (ref), refreshCompostBins (ref)
            if p80:IsA("Model") and p80.Name:match("^PlayerPlot") then
                u19:GiveTask(p80:GetAttributeChangedSignal("OwnerUserId"):Connect(function() -- Line: 360
                    -- upvalues: refreshLikePrompts (ref), refreshCompostBins (ref)
                    refreshLikePrompts();
                    refreshCompostBins();
                end));
            end;
        end;

        for _, child in BigField:GetChildren() do
            hookPlot(child);
        end;

        u19:GiveTask(BigField.ChildAdded:Connect(function(p81) -- Line: 367
            -- upvalues: hookPlot (copy), refreshLikePrompts (ref), refreshCompostBins (ref)
            hookPlot(p81);
            task.defer(refreshLikePrompts);
            task.defer(refreshCompostBins);
        end));
        u19:GiveTask(BigField.DescendantAdded:Connect(function(p82) -- Line: 373
            -- upvalues: refreshLikePrompts (ref), refreshCompostBins (ref)
            if p82.Name == "LikePrompt" then
                task.defer(refreshLikePrompts);
            end;

            if p82.Name == "CompostBin" or p82:FindFirstAncestor("CompostBin") then
                task.defer(refreshCompostBins);
            end;
        end));
        u19:GiveTask(u25.EV_UPDATE:Connect(function() -- Line: 379
            -- upvalues: refreshLikePrompts (ref), refreshCompostBins (ref)
            refreshLikePrompts();
            refreshCompostBins();
        end));
        refreshLikePrompts();
        refreshCompostBins();
    end);

    local function refreshBenchAlert() -- Line: 389
        -- upvalues: u37 (ref), u25 (copy)
        local v83 = u37 and u37:FindFirstChild("CraftingBench");

        if v83 then
            v83 = v83:FindFirstChild("Alert", true);
        end;

        if not v83 then
            return;
        end;

        local v84 = u25 and u25.currentData;
        local v85 = v84 and (v84.Gamepasses and v84.Gamepasses.EMOTE_VIP) and v84.Gamepasses.EMOTE_VIP.Owned == true;
        local v86 = u25 and u25.currentData;
        local v87;

        if v86 == nil then
            v87 = false;
        else
            v87 = (v86.Rebirth or 0) >= 1;
        end;

        if v87 then
            if v85 == true then
                if v84 then
                    v84 = v84.OpenedCustomizeFence;
                end;

                v87 = not v84;
            else
                v87 = false;
            end;
        end;

        v83.Enabled = v87;
    end;

    local u88 = {};

    local function ensureSignWatcher(u89, u90) -- Line: 399
        -- upvalues: u88 (copy), u37 (ref), setSignVisible (copy), u19 (copy), u25 (copy)
        u88[u89] = u88[u89] or {};

        if u88[u89][u90] then
            return;
        end;

        u88[u89][u90] = true;

        local function onParts() -- Line: 403
            -- upvalues: u89 (copy), u37 (ref), setSignVisible (ref), u90 (copy)
            if u89 ~= u37 then
                setSignVisible(u89, u90, false);
            end;
        end;

        u19:GiveTask(u89.ChildAdded:Connect(function(p91) -- Line: 406
            -- upvalues: u90 (copy), setSignVisible (ref), u89 (copy), u37 (ref), u25 (ref), u19 (ref), onParts (copy)
            if p91.Name == u90 then
                local v92;

                if u89 == u37 then
                    local v93 = u90;
                    local v94 = u25 and u25.currentData;

                    if v93 == "CollectAll" or v93 == "CraftingBench" then
                        if v94 == nil then
                            v92 = false;
                        else
                            v92 = (v94.Rebirth or 0) >= 1;
                        end;
                    elseif v93 == "GroupRewardStand" then
                        if v94 == nil or (v94.Rebirth or 0) < 1 then
                            v92 = false;
                        else
                            v92 = not v94.ClaimedGroupReward;
                        end;
                    else
                        v92 = true;
                    end;
                else
                    v92 = false;
                end;

                setSignVisible(u89, u90, v92);
                u19:GiveTask(p91.DescendantAdded:Connect(onParts));
            end;
        end));
        local v95 = u89:FindFirstChild(u90);

        if v95 then
            u19:GiveTask(v95.DescendantAdded:Connect(onParts));
        end;
    end;

    local function updateSignVisibility() -- Line: 416
        -- upvalues: u49 (copy), setSignVisible (copy), u37 (ref), u25 (copy), ensureSignWatcher (copy), refreshBenchAlert (copy)
        local v96 = workspace:FindFirstChild("BigField") and workspace.BigField:FindFirstChild("PlayerPlots");

        if not v96 then
            return;
        end;

        for _, child in v96:GetChildren() do
            if child:IsA("Model") and child.Name:match("^PlayerPlot") then
                for _, v in u49 do
                    local v97;

                    if child == u37 then
                        local v98 = u25 and u25.currentData;

                        if v == "CollectAll" or v == "CraftingBench" then
                            if v98 == nil then
                                v97 = false;
                            else
                                v97 = (v98.Rebirth or 0) >= 1;
                            end;
                        elseif v == "GroupRewardStand" then
                            if v98 == nil or (v98.Rebirth or 0) < 1 then
                                v97 = false;
                            else
                                v97 = not v98.ClaimedGroupReward;
                            end;
                        else
                            v97 = true;
                        end;
                    else
                        v97 = false;
                    end;

                    setSignVisible(child, v, v97);
                    ensureSignWatcher(child, v);
                end;
            end;
        end;

        refreshBenchAlert();
    end;

    local u99 = -1;
    local u100 = nil;
    local u101 = nil;
    u19:GiveTask(u25.EV_UPDATE:Connect(function() -- Line: 435, Name: refreshSignGating
        -- upvalues: u25 (copy), u99 (ref), u100 (ref), u101 (ref), updateSignVisibility (copy), u50 (copy)
        local v102 = u25 and u25.currentData;
        local v103 = v102 and (v102.Rebirth or 0) or 0;
        local v104;

        if v102 then
            v104 = v102.ClaimedGroupReward or false;
        else
            v104 = false;
        end;

        local v105 = (v102 and (v102.Gamepasses and v102.Gamepasses.EMOTE_VIP) and v102.Gamepasses.EMOTE_VIP.Owned) == true;

        if v105 then
            if v102 then
                v102 = v102.OpenedCustomizeFence;
            end;

            v105 = not v102;
        end;

        if v103 == u99 and (v104 == u100 and v105 == u101) then
            return;
        end;

        u99 = v103;
        u100 = v104;
        u101 = v105;
        updateSignVisibility();

        for _, v in { "CollectAll", "GroupRewardStand", "CraftingBench" } do
            local v106 = u50[v];

            if v106 then
                local v107 = u25 and u25.currentData;
                local v108;

                if v == "CollectAll" or v == "CraftingBench" then
                    if v107 == nil then
                        v108 = false;
                    else
                        v108 = (v107.Rebirth or 0) >= 1;
                    end;
                elseif v == "GroupRewardStand" then
                    if v107 == nil or (v107.Rebirth or 0) < 1 then
                        v108 = false;
                    else
                        v108 = not v107.ClaimedGroupReward;
                    end;
                else
                    v108 = true;
                end;

                v106.Enabled = v108;
            end;
        end;
    end));

    local function setupMySignPrompt(p109, p110, p111, p112, p113) -- Line: 453
        -- upvalues: u37 (ref), u25 (copy), u50 (copy), u19 (copy)
        if not u37 then
            return;
        end;

        local v114 = u37:FindFirstChild(p109);

        if not v114 then
            return;
        end;

        local v115 = v114:FindFirstChild(p113 or "PromptPart");

        if not v115 then
            return;
        end;

        v115.Transparency = 1;

        if v115:FindFirstChildWhichIsA("ProximityPrompt") then
            return;
        end;

        local ProximityPrompt = Instance.new("ProximityPrompt");
        ProximityPrompt.ActionText = p110;
        ProximityPrompt.ObjectText = p111;
        ProximityPrompt.MaxActivationDistance = 7.5;
        ProximityPrompt.RequiresLineOfSight = false;
        ProximityPrompt.HoldDuration = 0;
        ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom;
        local v116 = u25 and u25.currentData;
        local v117;

        if p109 == "CollectAll" or p109 == "CraftingBench" then
            if v116 == nil then
                v117 = false;
            else
                v117 = (v116.Rebirth or 0) >= 1;
            end;
        elseif p109 == "GroupRewardStand" then
            if v116 == nil or (v116.Rebirth or 0) < 1 then
                v117 = false;
            else
                v117 = not v116.ClaimedGroupReward;
            end;
        else
            v117 = true;
        end;

        ProximityPrompt.Enabled = v117;
        ProximityPrompt.Parent = v115;
        u50[p109] = ProximityPrompt;
        u19:GiveTask(ProximityPrompt.Triggered:Connect(p112));
    end;

    local function findActiveDirt() -- Line: 478
        -- upvalues: u37 (ref)
        if not u37 then
            return nil;
        end;

        for _, v in { "Plot3", "Plot2", "Plot1" } do
            local v118 = u37:FindFirstChild(v);

            if v118 then
                v118 = v118:FindFirstChild("Dirt");
            end;

            if v118 then
                return v118;
            end;
        end;

        return nil;
    end;

    local function collectPlanterDirts() -- Line: 489
        -- upvalues: u37 (ref)
        local v119 = {};

        if not u37 then
            return v119;
        end;

        for _, child in u37:GetChildren() do
            if child:IsA("Model") and (child.Name:match("^PlotDecor_") and child:GetAttribute("FurnitureType") == "Planters") then
                local Dirt = child:FindFirstChild("Dirt");

                if Dirt and Dirt:IsA("BasePart") then
                    table.insert(v119, Dirt);
                end;
            end;
        end;

        return v119;
    end;

    local function applyDirt() -- Line: 504
        -- upvalues: u38 (ref), findActiveDirt (copy), collectPlanterDirts (copy), u39 (ref)
        u38 = findActiveDirt();
        local v120 = {};

        if u38 then
            table.insert(v120, u38);
        end;

        for _, v in collectPlanterDirts() do
            table.insert(v120, v);
        end;

        if #v120 <= 0 then
            u39 = nil;

            return;
        end;

        u39 = RaycastParams.new();
        u39.FilterType = Enum.RaycastFilterType.Include;
        u39.FilterDescendantsInstances = v120;
    end;

    local function setupPlot(p121) -- Line: 520
        -- upvalues: u36 (ref), u37 (ref), applyDirt (copy), setupMySignPrompt (copy), u23 (copy), u51 (ref), Knit (ref), u25 (copy), CustomEnum (ref), updateSignVisibility (copy), u52 (ref), u40 (ref), u38 (ref), u47 (ref), u19 (copy), u48 (ref), u22 (copy)
        u36 = p121;
        local PlayerPlots = workspace:WaitForChild("BigField"):WaitForChild("PlayerPlots");
        u37 = PlayerPlots:WaitForChild("PlayerPlot" .. p121);

        local function resolveComponents() -- Line: 526
            -- upvalues: applyDirt (ref), setupMySignPrompt (ref), u23 (ref), u51 (ref), Knit (ref), u25 (ref), CustomEnum (ref), updateSignVisibility (ref), u52 (ref)
            applyDirt();
            setupMySignPrompt("GrowAll", "Buy", "Grow All Fruits", function() -- Line: 528
                -- upvalues: u23 (ref), u51 (ref)
                u23.PromptProductPurchase:Fire(u51);
            end);
            setupMySignPrompt("CollectAll", "Buy", "Collect All Fruits", function() -- Line: 531
                -- upvalues: u23 (ref)
                u23.PromptProductPurchase:Fire("CollectAllFruits");
            end);
            setupMySignPrompt("GroupRewardStand", "Claim", "Group Reward", function() -- Line: 534
                -- upvalues: Knit (ref)
                Knit.GetController("GroupRewardController"):Open();
            end, "SpawnPart");
            setupMySignPrompt("CraftingBench", "Customize", "", function() -- Line: 537
                -- upvalues: u25 (ref), Knit (ref), CustomEnum (ref)
                local v122 = u25 and u25.currentData;

                if v122 and (v122.Gamepasses and v122.Gamepasses.EMOTE_VIP) and v122.Gamepasses.EMOTE_VIP.Owned == true then
                    Knit.GetController("CustomizeFenceController"):Open();

                    return;
                end;

                Knit.GetService("BundlesService").attemptBuyBundle:Fire(CustomEnum.BUNDLES.EMOTES, nil);
            end);
            updateSignVisibility();

            if u52 then
                u52();
            end;
        end;

        u40 = u40 + 1;
        resolveComponents();

        if not u38 then
            local u123 = u40;
            task.spawn(function() -- Line: 555
                -- upvalues: u123 (copy), u40 (ref), resolveComponents (copy), u38 (ref)
                for _ = 1, 50 do
                    task.wait(0.2);

                    if u123 ~= u40 then
                        return;
                    end;

                    resolveComponents();

                    if u38 then
                        break;
                    end;
                end;
            end);
        end;

        if not u47 then
            u47 = true;
            u19:GiveTask(PlayerPlots.ChildAdded:Connect(function(p124) -- Line: 567
                -- upvalues: updateSignVisibility (ref)
                if p124:IsA("Model") and p124.Name:match("^PlayerPlot") then
                    task.defer(updateSignVisibility);
                end;
            end));
        end;

        if not u48 then
            u48 = true;
            u19:GiveTask(u22.DecorPlaced:Connect(function() -- Line: 578
                -- upvalues: applyDirt (ref)
                task.defer(applyDirt);
            end));
            u19:GiveTask(u22.DecorRemoved:Connect(function() -- Line: 579
                -- upvalues: applyDirt (ref)
                task.defer(applyDirt);
            end));
            u19:GiveTask(u37.DescendantAdded:Connect(function(p125) -- Line: 580
                -- upvalues: applyDirt (ref)
                if p125.Name == "Dirt" and p125:IsA("BasePart") then
                    task.defer(applyDirt);
                end;
            end));
        end;
    end;

    local function raycastToPlotDirt() -- Line: 590
        -- upvalues: u39 (ref), CurrentCamera (copy), u20 (copy)
        if not u39 then
            return nil;
        end;

        local v126 = CurrentCamera:ScreenPointToRay(u20.X, u20.Y);
        local v127 = workspace:Raycast(v126.Origin, v126.Direction * 500, u39);

        if v127 and v127.Instance then
            return v127.Position;
        end;

        return nil;
    end;

    local function ghostSubject() -- Line: 601
        -- upvalues: getEquippedTreeTool (ref), LocalPlayer (copy), getEquippedEggTool (ref), getEquippedPetTool (ref)
        local v128 = getEquippedTreeTool(LocalPlayer);

        if v128 then
            return v128, "Tree";
        end;

        local v129 = getEquippedEggTool(LocalPlayer);

        if v129 then
            return v129, "Egg";
        end;

        local v130 = getEquippedPetTool(LocalPlayer);

        if v130 then
            return v130, "Pet";
        end;

        return nil, nil;
    end;

    local function treeFrontTarget() -- Line: 612
        -- upvalues: u38 (ref), LocalPlayer (copy)
        if not u38 then
            return nil;
        end;

        local Character = LocalPlayer.Character;

        if Character then
            Character = Character:FindFirstChild("HumanoidRootPart");
        end;

        if not Character then
            return nil;
        end;

        local LookVector = Character.CFrame.LookVector;
        local v131 = Vector3.new(LookVector.X, 0, LookVector.Z);
        local v132 = Character.Position + (v131.Magnitude > 0.01 and v131.Unit or Vector3.new(0, 0, -1)) * 5;

        return Vector3.new(v132.X, u38.Position.Y + u38.Size.Y / 2, v132.Z);
    end;

    local u133 = Knit.GetController("UserInputParser");

    local function isMobileInput() -- Line: 629
        -- upvalues: RunService (ref), u133 (copy), CustomEnum (ref)
        return RunService:IsStudio() and workspace:GetAttribute("debugForceMobile") and true or u133:getInputType() == CustomEnum.INPUT_TYPES.MOBILE;
    end;

    local u134 = Maid.new();
    u19:GiveTask(u134);
    local u135 = nil;
    local u136 = nil;
    local u137 = nil;
    local u138 = {};
    local u139 = nil;
    local identity = CFrame.identity;
    local u140 = 0;

    local function partWorldBottomY(p141) -- Line: 646
        local CFrame2 = p141.CFrame;
        local Size = p141.Size;
        local v142 = math.abs(CFrame2.RightVector.Y) * Size.X / 2 + math.abs(CFrame2.UpVector.Y) * Size.Y / 2 + math.abs(CFrame2.LookVector.Y) * Size.Z / 2;

        return CFrame2.Position.Y - v142;
    end;

    local function resolveStageTemplate(p143, p144, p145) -- Line: 653
        -- upvalues: PlantStages (copy)
        if not PlantStages then
            return nil;
        end;

        local v146 = PlantStages:FindFirstChild(p143);

        if p145 then
            return v146 and v146:FindFirstChild(p143 .. "Dead") or PlantStages:FindFirstChild("Dead");
        end;

        return v146 and v146:FindFirstChild(p143 .. p144) or PlantStages:FindFirstChild("Stage" .. p144);
    end;

    local u147 = false;
    local u148 = {};

    local function setHeldTreeHidden(p149) -- Line: 667
        -- upvalues: u137 (ref), u147 (ref), u148 (ref)
        if not u137 then
            return;
        end;

        local v150 = p149 ~= u147;

        if not (p149 or v150) then
            return;
        end;

        u147 = p149;

        for _, descendant in u137:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.LocalTransparencyModifier = p149 and 1 or 0;
            elseif v150 and (p149 and (descendant:IsA("ParticleEmitter") or descendant:IsA("Light"))) and descendant.Enabled then
                descendant.Enabled = false;
                table.insert(u148, descendant);
            end;
        end;

        if not p149 then
            for _, v in u148 do
                if v and v.Parent then
                    v.Enabled = true;
                end;
            end;

            u148 = {};
        end;
    end;

    local function destroyTreeGhost() -- Line: 689
        -- upvalues: setHeldTreeHidden (copy), u137 (ref), u134 (copy), u135 (ref), u136 (ref), u138 (ref), u139 (ref)
        setHeldTreeHidden(false);
        u137 = nil;
        u134:DoCleaning();
        u135 = nil;
        u136 = nil;
        u138 = {};
        u139 = nil;
    end;

    local function setTreeGhostState(p151) -- Line: 701
        -- upvalues: setHeldTreeHidden (copy), u138 (ref), u139 (ref)
        setHeldTreeHidden(p151 ~= "hidden");

        for _, v in u138 do
            v.part.Transparency = p151 == "hidden" and 1 or v.transparency;
        end;

        if not u139 then
            return;
        end;

        u139.Enabled = p151 ~= "hidden";

        if p151 == "valid" then
            u139.FillColor = Color3.fromRGB(80, 230, 100);
            u139.FillTransparency = 0.6;
            u139.OutlineColor = Color3.fromRGB(150, 255, 170);
        end;
    end;

    local function buildTreeGhost(p152, p153) -- Line: 715
        -- upvalues: setHeldTreeHidden (copy), u137 (ref), u134 (copy), u135 (ref), u136 (ref), u138 (ref), u139 (ref), u140 (ref), PetAssets (ref), resolveStageTemplate (copy), SeedConfig (ref), getFruitModelHeight (ref), MutationRecolor (ref), TreeMountPoint (ref), identity (ref)
        setHeldTreeHidden(false);
        u137 = nil;
        u134:DoCleaning();
        u135 = nil;
        u136 = nil;
        u138 = {};
        u139 = nil;
        u137 = p152;
        u140 = 0;
        u136 = p152:GetAttribute("ItemId");
        local v154;

        if p153 == "Egg" then
            v154 = PetAssets.resolveEgg(p152:GetAttribute("EggId"));
        elseif p153 == "Pet" then
            v154 = PetAssets.resolvePet(p152:GetAttribute("PetType"));
        else
            v154 = resolveStageTemplate(p152:GetAttribute("SeedType") or "Oak", p152:GetAttribute("StageIndex") or 4, p152:GetAttribute("IsDead") == true);
        end;

        if not (v154 and v154:IsA("Model")) then
            return;
        end;

        local v155 = v154:Clone();
        v155.Name = "TreeGhost";

        if p153 == "Tree" then
            local v156 = p152:GetAttribute("Multiplier") or 1;
            local v157 = math.min(v156, SeedConfig.MAX_PLACED_VISUAL_MULT);
            v155:ScaleTo(SeedConfig.BASE_HEIGHT * v157 / getFruitModelHeight(v155));
            local v158 = p152:GetAttribute("Mutations");
            local pickTreeKey = MutationRecolor.pickTreeKey;

            if v158 then
                v158 = string.split(v158, ",");
            end;

            local v159 = pickTreeKey(v158);

            if v159 then
                MutationRecolor.apply(v155, v159);
            end;

            TreeMountPoint.hide(v155);
            local FruitSpawns = v155:FindFirstChild("FruitSpawns");

            if FruitSpawns then
                for _, child in FruitSpawns:GetChildren() do
                    if child:IsA("BasePart") then
                        child.Transparency = 1;
                    end;

                    for _, descendant in child:GetDescendants() do
                        if descendant:IsA("BasePart") then
                            descendant.Transparency = 1;
                        end;
                    end;
                end;
            end;
        end;

        for _, descendant in v155:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Anchored = true;
                descendant.CanCollide = false;
                descendant.CanQuery = false;
                descendant.CanTouch = false;

                if descendant.Transparency < 1 then
                    descendant.Transparency = math.max(descendant.Transparency, 0.4);
                    table.insert(u138, {
                        part = descendant,
                        transparency = descendant.Transparency
                    });
                end;
            elseif descendant:IsA("Script") or (descendant:IsA("LocalScript") or (descendant:IsA("ProximityPrompt") or descendant:IsA("Sound"))) then
                descendant:Destroy();
            end;
        end;

        local Highlight = Instance.new("Highlight");
        Highlight.FillTransparency = 0.6;
        Highlight.OutlineTransparency = 0;
        Highlight.Parent = v155;
        v155.Parent = workspace;
        u134:GiveTask(v155);
        u135 = v155;
        identity = v155:GetPivot().Rotation;
        u139 = Highlight;
        setHeldTreeHidden(false);

        for _, v in u138 do
            v.part.Transparency = 1;
        end;

        if not u139 then
            return;
        end;

        u139.Enabled = false;
    end;

    local function positionTreeGhost(p160) -- Line: 791
        -- upvalues: u135 (ref), partWorldBottomY (copy), u140 (ref), identity (ref)
        if not u135 then
            return;
        end;

        local PrimaryPart = u135.PrimaryPart;
        local v161, v162, v163;

        if PrimaryPart then
            v161 = PrimaryPart.Position.X;
            v162 = PrimaryPart.Position.Z;
            v163 = partWorldBottomY(PrimaryPart);
        else
            local Position = u135:GetPivot().Position;
            v161 = Position.X;
            v162 = Position.Z;
            v163 = (1 / 0);

            for _, descendant in u135:GetDescendants() do
                if descendant:IsA("BasePart") then
                    local v164 = partWorldBottomY(descendant);
                    v163 = math.min(v163, v164);
                end;
            end;

            if v163 == (1 / 0) then
                return;
            end;
        end;

        local v165 = u135:GetPivot().Position + Vector3.new(p160.X - v161, p160.Y - v163, p160.Z - v162);
        u135:PivotTo(CFrame.new(v165) * CFrame.Angles(0, u140, 0) * identity);
    end;

    u19:GiveTask(RunService.Heartbeat:Connect(function() -- Line: 814
        -- upvalues: getEquippedTreeTool (ref), LocalPlayer (copy), getEquippedEggTool (ref), getEquippedPetTool (ref), RunService (ref), u133 (copy), CustomEnum (ref), u39 (ref), u135 (ref), u136 (ref), setHeldTreeHidden (copy), u137 (ref), u134 (copy), u138 (ref), u139 (ref), u30 (ref), u41 (ref), buildTreeGhost (copy), u43 (ref), treeFrontTarget (copy), positionTreeGhost (copy), CurrentCamera (copy), u20 (copy)
        local v166 = getEquippedTreeTool(LocalPlayer);
        local v167;

        if v166 then
            v167 = "Tree";
        else
            v166 = getEquippedEggTool(LocalPlayer);

            if v166 then
                v167 = "Egg";
            else
                v166 = getEquippedPetTool(LocalPlayer);

                if v166 then
                    v167 = "Pet";
                else
                    v167 = nil;
                    v166 = nil;
                end;
            end;
        end;

        if v167 == "Pet" then
            if RunService:IsStudio() and workspace:GetAttribute("debugForceMobile") and true or u133:getInputType() == CustomEnum.INPUT_TYPES.MOBILE then
                v166 = nil;
            end;
        end;

        if not (v166 and u39) then
            if u135 or u136 then
                setHeldTreeHidden(false);
                u137 = nil;
                u134:DoCleaning();
                u135 = nil;
                u136 = nil;
                u138 = {};
                u139 = nil;
            end;

            u30 = false;
            u41 = nil;

            return;
        end;

        if u136 ~= v166:GetAttribute("ItemId") then
            buildTreeGhost(v166, v167);
        end;

        if not u135 then
            return;
        end;

        if not (RunService:IsStudio() and workspace:GetAttribute("debugForceMobile")) and u133:getInputType() ~= CustomEnum.INPUT_TYPES.MOBILE then
            local v168;

            if u39 then
                local v169 = CurrentCamera:ScreenPointToRay(u20.X, u20.Y);
                local v170 = workspace:Raycast(v169.Origin, v169.Direction * 500, u39);

                if v170 and v170.Instance then
                    v168 = v170.Position;
                else
                    v168 = nil;
                end;
            else
                v168 = nil;
            end;

            if v168 then
                positionTreeGhost(v168);
                setHeldTreeHidden(true);

                for _, v in u138 do
                    v.part.Transparency = v.transparency;
                end;

                if u139 then
                    u139.Enabled = true;
                    u139.FillColor = Color3.fromRGB(80, 230, 100);
                    u139.FillTransparency = 0.6;
                    u139.OutlineColor = Color3.fromRGB(150, 255, 170);
                end;

                u41 = v168;
                u30 = true;

                return;
            end;

            u41 = nil;
            u30 = false;
            setHeldTreeHidden(false);

            for _, v in u138 do
                v.part.Transparency = 1;
            end;

            if not u139 then
                return;
            end;

            u139.Enabled = false;

            return;
        end;

        u41 = nil;
        u30 = false;
        local v171 = u43 and treeFrontTarget() or nil;

        if not v171 then
            setHeldTreeHidden(false);

            for _, v in u138 do
                v.part.Transparency = 1;
            end;

            if not u139 then
                return;
            end;

            u139.Enabled = false;

            return;
        end;

        positionTreeGhost(v171);
        setHeldTreeHidden(true);

        for _, v in u138 do
            v.part.Transparency = v.transparency;
        end;

        if not u139 then
            return;
        end;

        u139.Enabled = true;
        u139.FillColor = Color3.fromRGB(80, 230, 100);
        u139.FillTransparency = 0.6;
        u139.OutlineColor = Color3.fromRGB(150, 255, 170);
    end));

    local function isOnMyPlot() -- Line: 861
        -- upvalues: u38 (ref), LocalPlayer (copy)
        if not u38 then
            return false;
        end;

        local Character = LocalPlayer.Character;

        if Character then
            Character = Character:FindFirstChild("HumanoidRootPart") or Character.PrimaryPart;
        end;

        if not Character then
            return false;
        end;

        local v172 = u38.CFrame:PointToObjectSpace(Character.Position);
        local v173;

        if math.abs(v172.X) <= u38.Size.X / 2 + 2 then
            v173 = math.abs(v172.Z) <= u38.Size.Z / 2 + 2;
        else
            v173 = false;
        end;

        return v173;
    end;

    local function doPlacePet() -- Line: 872
        -- upvalues: u42 (ref), u39 (ref), CurrentCamera (copy), u20 (copy), isOnMyPlot (copy), Knit (ref), getEquippedPetTool (ref), LocalPlayer (copy), u22 (copy)
        if u42 then
            return false;
        end;

        local v174;

        if u39 then
            local v175 = CurrentCamera:ScreenPointToRay(u20.X, u20.Y);
            local v176 = workspace:Raycast(v175.Origin, v175.Direction * 500, u39);

            if v176 and v176.Instance then
                v174 = v176.Position;
            else
                v174 = nil;
            end;
        else
            v174 = nil;
        end;

        if not (v174 or isOnMyPlot()) then
            Knit.GetController("NotificationController"):SendNotification("Place pet inside of your plot!", 3, Color3.fromRGB(255, 80, 80));

            return false;
        end;

        local v177 = getEquippedPetTool(LocalPlayer);

        if v177 then
            v177 = v177:GetAttribute("ItemId");
        end;

        if not v177 then
            return false;
        end;

        u42 = true;
        u22:PlacePet(v177, v174);
        u42 = false;

        return true;
    end;

    local function doPlotPlant() -- Line: 892
        -- upvalues: u42 (ref), u39 (ref), CurrentCamera (copy), u20 (copy), getEquippedTreeTool (ref), LocalPlayer (copy), getEquippedEggTool (ref), getEquippedPetTool (ref), u22 (copy), u140 (ref), CursorUI (copy), u41 (ref)
        if u42 then
            return;
        end;

        if not u39 then
            return;
        end;

        local v178;

        if u39 then
            local v179 = CurrentCamera:ScreenPointToRay(u20.X, u20.Y);
            local v180 = workspace:Raycast(v179.Origin, v179.Direction * 500, u39);

            if v180 and v180.Instance then
                v178 = v180.Position;
            else
                v178 = nil;
            end;
        else
            v178 = nil;
        end;

        if not v178 then
            return;
        end;

        local v181 = getEquippedTreeTool(LocalPlayer);
        local v182;

        if v181 then
            v182 = "Tree";
        else
            v181 = getEquippedEggTool(LocalPlayer);

            if v181 then
                v182 = "Egg";
            else
                v181 = getEquippedPetTool(LocalPlayer);

                if v181 then
                    v182 = "Pet";
                else
                    v181 = nil;
                    v182 = nil;
                end;
            end;
        end;

        if v181 then
            v181 = v181:GetAttribute("ItemId");
        end;

        if not v181 or v182 == "Pet" then
            return;
        end;

        u42 = true;
        local v183;

        if v182 == "Egg" then
            v183 = u22:PlaceEgg(v181, { (CFrame.new(v178) * CFrame.Angles(0, u140, 0)):GetComponents() });
        else
            v183 = u22:PlantTree(v181, v178, u140);
        end;

        u42 = false;

        if v183 then
            CursorUI.Visible = false;
            u41 = nil;
        end;
    end;

    u19:GiveTask(UserInputService.InputBegan:Connect(function(p184, p185) -- Line: 918
        -- upvalues: u21 (copy), getEquippedPetTool (ref), LocalPlayer (copy), doPlacePet (copy), getEquippedTreeTool (ref), getEquippedEggTool (ref), u135 (ref), RunService (ref), u133 (copy), CustomEnum (ref), u140 (ref), F (ref), doPlotPlant (copy)
        if p185 then
            return;
        end;

        if not u21 and (p184.UserInputType == Enum.UserInputType.MouseButton1 and getEquippedPetTool(LocalPlayer)) then
            doPlacePet();

            return;
        end;

        if not (getEquippedTreeTool(LocalPlayer) or getEquippedEggTool(LocalPlayer) or getEquippedPetTool(LocalPlayer)) then
            return;
        end;

        if u135 and (not (RunService:IsStudio() and workspace:GetAttribute("debugForceMobile")) and u133:getInputType() ~= CustomEnum.INPUT_TYPES.MOBILE) then
            if p184.KeyCode == Enum.KeyCode.Q then
                u140 = u140 - 0.2617993877991494;

                return;
            end;

            if p184.KeyCode == Enum.KeyCode.R then
                u140 = u140 + 0.2617993877991494;

                return;
            end;
        end;

        if p184.KeyCode == F then
            doPlotPlant();

            return;
        end;

        if not u21 and p184.UserInputType == Enum.UserInputType.MouseButton1 then
            doPlotPlant();
        end;
    end));

    local function getMutationAssets() -- Line: 956
        -- upvalues: ReplicatedStorage (ref)
        local Assets = ReplicatedStorage:FindFirstChild("Assets");

        if Assets then
            Assets = Assets:FindFirstChild("Greedy");
        end;

        if Assets then
            Assets = Assets:FindFirstChild("MutationAssets");
        end;

        return Assets;
    end;

    local u186 = false;

    local function applyFruitMutationFX(p187, p188) -- Line: 967
        -- upvalues: u186 (ref), ReplicatedStorage (ref)
        if p187.mutationFX then
            for _, v in p187.mutationFX do
                if v then
                    v:Destroy();
                end;
            end;
        end;

        p187.mutationFX = {};

        if u186 then
            return;
        end;

        if not p188 or (#p188 == 0 or not p187.model) then
            return;
        end;

        local Assets = ReplicatedStorage:FindFirstChild("Assets");

        if Assets then
            Assets = Assets:FindFirstChild("Greedy");
        end;

        if Assets then
            Assets = Assets:FindFirstChild("MutationAssets");
        end;

        if Assets then
            Assets = Assets:FindFirstChild("Fruits");
        end;

        if not Assets then
            return;
        end;

        local PrimaryPart = p187.model.PrimaryPart;
        local v189, v190;

        if PrimaryPart and PrimaryPart.Name == "Base" then
            v189 = PrimaryPart.CFrame;
            v190 = PrimaryPart.Size;
        else
            v189, v190 = p187.model:GetBoundingBox();
        end;

        local naturalSize = p187.naturalSize;
        local v191 = naturalSize and (naturalSize.X > 0 and v190.X / naturalSize.X) or 1;
        local v192 = p187.model.Parent or p187.model;

        for _, v in p188 do
            local v193 = Assets:FindFirstChild(v);

            if v193 then
                local v194 = v193:Clone();

                for _, descendant in v194:GetDescendants() do
                    if descendant:IsA("BasePart") then
                        descendant.Anchored = true;
                        descendant.CanCollide = false;
                        descendant.CanQuery = false;
                        descendant.CanTouch = false;
                        descendant.Transparency = 1;
                    end;
                end;

                if v194:IsA("BasePart") then
                    v194.Anchored = true;
                    v194.CanCollide = false;
                    v194.Transparency = 1;
                    v194.Size = v194.Size * v191;
                    v194.CFrame = v189;
                    v194.Parent = v192;
                elseif v194:IsA("Model") then
                    v194:ScaleTo(v191);
                    local v195 = select(1, v194:GetBoundingBox());
                    v194:PivotTo(v194:GetPivot() + (v189.Position - v195.Position));
                    v194.Parent = v192;
                end;

                for _, descendant in v194:GetDescendants() do
                    if descendant:IsA("ParticleEmitter") then
                        descendant.Enabled = true;
                    end;
                end;

                table.insert(p187.mutationFX, v194);
            end;
        end;
    end;

    local function fruitEffectiveSize(p196) -- Line: 1024
        -- upvalues: SeedConfig (ref)
        return SeedConfig.FruitSize(p196.multiplier or 1, p196.sizeMult);
    end;

    local function refreshFruitMutations(p197) -- Line: 1030
        -- upvalues: MutationText (ref), MutationRecolor (ref), SeedConfig (ref), fruitEffectiveSize (copy), AbbreviateNumber (ref), MutationConfig (ref)
        local v198 = p197.ready and p197.mutations or p197.treeMutations;

        if p197.mutationLabel then
            MutationText.apply(p197.mutationLabel, v198);
        end;

        if p197.model then
            MutationRecolor.applyGoldenFruit(p197.model, v198);
        end;

        if p197.ready and (p197.valueLabel and p197.seedType) then
            local v199 = SeedConfig.CalcPlotFruitValue(p197.seedType, fruitEffectiveSize(p197));
            local valueLabel = p197.valueLabel;
            local v200 = v199 * MutationConfig.ProductMult(p197.mutations);
            valueLabel.Text = "$" .. AbbreviateNumber((math.floor(v200)));
        end;
    end;

    local function refreshFruitSize(p201) -- Line: 1047
        -- upvalues: SeedConfig (ref), fruitEffectiveSize (copy)
        if not p201.spawnPart then
            return;
        end;

        p201.sizeMult = p201.spawnPart:GetAttribute("FruitSizeMult") or 1;
        p201.fullScale = SeedConfig.CalcFruitScale(p201.seedType, fruitEffectiveSize(p201));
    end;

    function u1.GetTutorialFruitTarget(p202, p203) -- Line: 1054
        -- upvalues: u44 (copy)
        local v204 = u44[p203];

        if not v204 then
            return nil;
        end;

        for _, v in v204 do
            if v.ready and v.spawnPart then
                return v.spawnPart.Position;
            end;
        end;

        return nil;
    end;

    local function refreshPerformanceMode() -- Line: 1064
        -- upvalues: u25 (copy), u186 (ref), u44 (copy), applyFruitMutationFX (copy), u45 (ref)
        local v205 = u25 and u25.currentData;
        local v206 = (v205 and v205.Settings and v205.Settings.PerformanceMode) == true;

        if v206 == u186 then
            return;
        end;

        u186 = v206;

        for _, v in u44 do
            for _, v2 in v do
                if v2.ready then
                    applyFruitMutationFX(v2, v2.mutations);
                end;
            end;
        end;

        for _, v in u45 do
            for _, v2 in v do
                if v2.ready then
                    applyFruitMutationFX(v2, v2.mutations);
                end;
            end;
        end;
    end;

    u19:GiveTask(u25.EV_UPDATE:Connect(refreshPerformanceMode));
    refreshPerformanceMode();

    local function createFruitVisual(p207, p208, u209, p210) -- Line: 1083
        -- upvalues: SeedConfig (ref), FruitModels (copy), FruitBillboard_WithPrompt (copy), ScreenGui (copy), setupCustomPromptButton (copy), formatCountdown (ref), u37 (ref), getFruitModelHeight (ref), MutationConfig (ref)
        local v211 = p208.seedType or "Oak";
        local v212 = FruitModels:FindFirstChild(SeedConfig.FRUIT_MODEL_NAMES[v211] or "Acorn");

        if not v212 then
            return nil;
        end;

        local v213 = v212:Clone();
        v213.Name = "FruitVisual_" .. p210;

        for _, descendant in v213:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Anchored = true;
                descendant.CanCollide = false;
            end;
        end;

        v213.Parent = p207;
        local v214 = FruitBillboard_WithPrompt:Clone();
        v214.Adornee = u209;
        v214.Parent = ScreenGui;
        v214.StudsOffset = Vector3.new(0, -3, 0);
        v214.MaxDistance = 1000;
        v214.Enabled = false;
        local MainFrame = v214:FindFirstChild("MainFrame");
        local v215;

        if MainFrame then
            v215 = MainFrame:FindFirstChild("GrowthProgress");
        else
            v215 = MainFrame;
        end;

        local v216;

        if MainFrame then
            v216 = MainFrame:FindFirstChild("Name");
        else
            v216 = MainFrame;
        end;

        local v217;

        if MainFrame then
            v217 = MainFrame:FindFirstChild("Value");
        else
            v217 = MainFrame;
        end;

        local v218;

        if MainFrame then
            v218 = MainFrame:FindFirstChild("Mutations");
        else
            v218 = MainFrame;
        end;

        if MainFrame then
            MainFrame = MainFrame:FindFirstChild("CustomPrompt");
        end;

        if MainFrame then
            setupCustomPromptButton(MainFrame, "Collect", function() -- Line: 1117
                -- upvalues: u209 (copy)
                local v219 = u209 and u209:FindFirstChildWhichIsA("ProximityPrompt");

                return v219;
            end);
        end;

        if v215 then
            v215.Visible = true;
            v215.Text = formatCountdown(SeedConfig.GetFruitGrowthTime(p208.multiplier or 1, SeedConfig.PlotGrowthMult(u37)));
        end;

        if v216 then
            local v220 = SeedConfig.GetSeed(v211);
            v216.Text = v220 and v220.fruitName or "Fruit";
        end;

        if v217 then
            v217.Visible = false;
        end;

        if v218 then
            v218.Visible = false;
        end;

        local v221;

        if v212:IsA("Model") then
            local PrimaryPart = v212.PrimaryPart;

            if PrimaryPart and PrimaryPart.Name == "Base" then
                v221 = PrimaryPart.Size;
            else
                local v222;
                v222, v221 = v212:GetBoundingBox();
            end;
        else
            v221 = v212.Size;
        end;

        local v223 = u209:GetAttribute("FruitSizeMult") or 1;
        local v224 = {
            highlight = nil,
            ready = false,
            model = v213,
            billboard = v214,
            naturalHeight = getFruitModelHeight(v212),
            naturalSize = v221,
            fullScale = SeedConfig.CalcFruitScale(v211, SeedConfig.FruitSize(p208.multiplier or 1, v223)),
            sizeMult = v223,
            spawnPart = u209,
            seedType = v211,
            multiplier = p208.multiplier or 1,
            growthLabel = v215,
            nameLabel = v216,
            valueLabel = v217,
            mutationLabel = v218,
            customPrompt = MainFrame,
            mutations = {},
            treeMutations = MutationConfig.Sanitize(p208.mutations)
        };
        local v225 = math.random(0, 359);
        v224.yawAngle = math.rad(v225);

        return v224;
    end;

    local function updateFruitScale(p226, p227) -- Line: 1170
        -- upvalues: SeedConfig (ref)
        local model = p226.model;

        if not (model and model.Parent) then
            return;
        end;

        local spawnPart = p226.spawnPart;
        model:ScaleTo((math.max(0.01, p227 * (p226.fullScale or 1))));
        SeedConfig.AnchorFruitTop(model, spawnPart, p226.yawAngle or 0, p226.seedType);

        if p226.mutationFX then
            local PrimaryPart = model.PrimaryPart;
            local v228 = PrimaryPart and PrimaryPart.Name == "Base" and PrimaryPart.Position or select(1, model:GetBoundingBox()).Position;

            for _, v in p226.mutationFX do
                if v and v.Parent then
                    if v:IsA("Model") then
                        local v229 = select(1, v:GetBoundingBox());
                        v:PivotTo(v:GetPivot() + (v228 - v229.Position));
                    elseif v:IsA("BasePart") then
                        v.Position = v228;
                    end;
                end;
            end;
        end;
    end;

    local function setFruitReady(p230, p231) -- Line: 1199
        -- upvalues: SeedConfig (ref), fruitEffectiveSize (copy), updateFruitScale (copy), applyFruitMutationFX (copy), MutationConfig (ref), AbbreviateNumber (ref), refreshFruitMutations (copy)
        p230.ready = true;

        if p230.spawnPart then
            p230.sizeMult = p230.spawnPart:GetAttribute("FruitSizeMult") or 1;
            p230.fullScale = SeedConfig.CalcFruitScale(p230.seedType, fruitEffectiveSize(p230));
        end;

        updateFruitScale(p230, 1);
        applyFruitMutationFX(p230, p230.mutations);

        if p230.growthLabel then
            p230.growthLabel.Visible = false;
        end;

        if p230.valueLabel then
            p230.valueLabel.Visible = true;
            local v232 = SeedConfig.CalcPlotFruitValue(p231.seedType, fruitEffectiveSize(p230)) * MutationConfig.ProductMult(p230.mutations);
            local v233 = math.floor(v232);
            p230.valueLabel.Text = "$" .. AbbreviateNumber(v233);
        end;

        if p230.nameLabel then
            local v234 = SeedConfig.GetSeed(p231.seedType);
            p230.nameLabel.Text = string.format("%s (%.1fx)", v234 and v234.fruitName or "Fruit", fruitEffectiveSize(p230));
        end;

        refreshFruitMutations(p230);

        if not p230.highlight and p230.model then
            local Highlight = Instance.new("Highlight");
            Highlight.OutlineColor = Color3.new(1, 1, 1);
            Highlight.FillTransparency = 1;
            Highlight.OutlineTransparency = 0;
            Highlight.Enabled = false;
            Highlight.Parent = p230.model;
            p230.highlight = Highlight;
        end;
    end;

    local function destroyFruitVisual(p235) -- Line: 1232
        if p235.mutationFX then
            for _, v in p235.mutationFX do
                if v then
                    v:Destroy();
                end;
            end;

            p235.mutationFX = nil;
        end;

        if p235.model then
            p235.model:Destroy();
        end;

        if p235.billboard then
            p235.billboard:Destroy();
        end;

        if p235.highlight then
            p235.highlight:Destroy();
        end;
    end;

    local function resetFruitVisual(p236, p237, p238) -- Line: 1244
        -- upvalues: SeedConfig (ref), FruitModels (copy), getFruitModelHeight (ref), fruitEffectiveSize (copy), formatCountdown (ref), u37 (ref), refreshFruitMutations (copy)
        if p236.model then
            p236.model:Destroy();
        end;

        if p236.highlight then
            p236.highlight:Destroy();
            p236.highlight = nil;
        end;

        local v239 = p237.seedType or "Oak";
        local v240 = FruitModels:FindFirstChild(SeedConfig.FRUIT_MODEL_NAMES[v239] or "Acorn");

        if not v240 then
            return;
        end;

        local v241 = v240:Clone();
        v241.Name = "FruitVisual_reset";

        for _, descendant in v241:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Anchored = true;
                descendant.CanCollide = false;
            end;
        end;

        local v242 = p236.spawnPart and p236.spawnPart:FindFirstAncestorWhichIsA("Model");
        v241.Parent = v242 or workspace;
        p236.model = v241;
        p236.naturalHeight = getFruitModelHeight(v240);
        local v243 = math.random(0, 359);
        p236.yawAngle = math.rad(v243);

        if p236.spawnPart then
            p236.sizeMult = p236.spawnPart:GetAttribute("FruitSizeMult") or 1;
            p236.fullScale = SeedConfig.CalcFruitScale(p236.seedType, fruitEffectiveSize(p236));
        end;

        p236.ready = false;

        if p236.customPrompt then
            p236.customPrompt.Visible = false;
        end;

        if p236.billboard then
            p236.billboard.Enabled = false;
        end;

        if p236.growthLabel then
            p236.growthLabel.Visible = true;
            p236.growthLabel.Text = formatCountdown(SeedConfig.GetFruitGrowthTime(p237 and p237.multiplier or 1, SeedConfig.PlotGrowthMult(u37)));
        end;

        if p236.valueLabel then
            p236.valueLabel.Visible = false;
        end;

        if p236.nameLabel then
            local v244 = SeedConfig.GetSeed(v239);
            p236.nameLabel.Text = v244 and v244.fruitName or "Fruit";
        end;

        p236.mutations = p236.mutations or {};

        if p236.mutationFX then
            for _, v in p236.mutationFX do
                if v then
                    v:Destroy();
                end;
            end;

            p236.mutationFX = nil;
        end;

        refreshFruitMutations(p236);
    end;

    local u245 = {};

    u52 = function() -- Line: 1298
        -- upvalues: u245 (copy), u51 (ref), Products (ref), setSignPrice (copy)
        task.spawn(function() -- Line: 1299
            -- upvalues: u245 (ref), u51 (ref), Products (ref), setSignPrice (ref)
            local v246 = 0;

            for _ in u245 do
                v246 = v246 + 1;
            end;

            u51 = Products.GetGrowAllProduct(v246);
            setSignPrice("GrowAll", u51);
            setSignPrice("CollectAll", "CollectAllFruits");
        end);
    end;

    u19:GiveTask(RunService.Heartbeat:Connect(function() -- Line: 1310
        -- upvalues: u37 (ref), u245 (copy), u44 (copy), SeedConfig (ref), fruitEffectiveSize (copy), updateFruitScale (copy), formatCountdown (ref)
        if not u37 then
            return;
        end;

        local v247 = workspace:GetServerTimeNow();

        for i, v in u245 do
            local v248 = u44[i];

            if v248 then
                for i2, v2 in v248 do
                    if v2 and v2.model then
                        local v249 = v.fruitStartTimes[i2];

                        if v249 then
                            local v250 = v247 - v249;
                            local v251 = v250 / SeedConfig.GetFruitGrowthTime(v.multiplier, SeedConfig.PlotGrowthMult(u37));
                            local v252 = math.clamp(v251, 0, 1);

                            if v2.spawnPart and ((v2.spawnPart:GetAttribute("FruitSizeMult") or 1) ~= v2.sizeMult and v2.spawnPart) then
                                v2.sizeMult = v2.spawnPart:GetAttribute("FruitSizeMult") or 1;
                                v2.fullScale = SeedConfig.CalcFruitScale(v2.seedType, fruitEffectiveSize(v2));
                            end;

                            updateFruitScale(v2, v252);

                            if v252 < 1 and (v2.growthLabel and v2.growthLabel.Visible) then
                                local v253 = SeedConfig.GetFruitGrowthTime(v.multiplier, SeedConfig.PlotGrowthMult(u37)) - v250;
                                v2.growthLabel.Text = formatCountdown(v253);
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end));

    local function recolorPlotTree(p254, p255) -- Line: 1348
        -- upvalues: MutationRecolor (ref), u37 (ref)
        local v256 = MutationRecolor.pickTreeKey(p255);

        if not (v256 and u37) then
            return;
        end;

        local v257 = u37:FindFirstChild("PlotTree_" .. p254);

        if v257 then
            MutationRecolor.apply(v257, v256);
        end;
    end;

    local function recolorPlotTreeWhenReady(u258, u259) -- Line: 1359
        -- upvalues: u37 (ref), MutationRecolor (ref)
        if not (u259 and u259[1]) then
            return;
        end;

        task.spawn(function() -- Line: 1361
            -- upvalues: u37 (ref), u258 (copy), u259 (copy), MutationRecolor (ref)
            for _ = 1, 25 do
                local v260 = u37 and u37:FindFirstChild("PlotTree_" .. u258);

                if v260 and (v260:FindFirstChild("Leaves") or v260:FindFirstChild("Wood")) then
                    break;
                end;

                task.wait(0.2);
            end;

            local v261 = u258;
            local v262 = MutationRecolor.pickTreeKey(u259);

            if v262 then
                if not u37 then
                    return;
                end;

                local v263 = u37:FindFirstChild("PlotTree_" .. v261);

                if v263 then
                    MutationRecolor.apply(v263, v262);
                end;
            end;
        end);
    end;

    local function setupFruitVisualsForTree(p264, p265) -- Line: 1373
        -- upvalues: u37 (ref), u44 (copy), destroyFruitVisual (copy), SeedConfig (ref), createFruitVisual (copy), MutationConfig (ref), refreshFruitMutations (copy), u245 (copy), updateFruitScale (copy), setFruitReady (copy)
        if p265.stageIndex ~= 4 then
            return;
        end;

        if not u37 then
            return;
        end;

        local v266 = u37:FindFirstChild("PlotTree_" .. p264);

        if not v266 then
            return;
        end;

        local FruitSpawns = v266:FindFirstChild("FruitSpawns");

        if not FruitSpawns then
            return;
        end;

        local v267 = u44[p264];

        if v267 then
            for _, v in v267 do
                destroyFruitVisual(v);
            end;
        end;

        u44[p264] = {};
        local v268 = workspace:GetServerTimeNow();
        local v269 = p265.fruitsReady == true;
        local v270 = SeedConfig.GetFruitGrowthTime(p265.multiplier, SeedConfig.PlotGrowthMult(u37));
        local fruitStartTimes = p265.fruitStartTimes;
        local v271 = {};

        for _, child in FruitSpawns:GetChildren() do
            if child:IsA("BasePart") then
                local v272 = child:GetAttribute("SpawnIndex");

                if not v272 then
                    child:GetAttributeChangedSignal("SpawnIndex"):Wait();
                    v272 = child:GetAttribute("SpawnIndex");
                end;

                if v272 then
                    child.Transparency = 1;
                    local v273 = createFruitVisual(v266, p265, child, v272);

                    if v273 then
                        u44[p264][v272] = v273;
                        local v274 = p265.fruitMutations and p265.fruitMutations[tostring(v272)];
                        v273.mutations = MutationConfig.Sanitize(v274);
                        refreshFruitMutations(v273);
                        local v275;

                        if fruitStartTimes then
                            v275 = fruitStartTimes[v272];
                        else
                            v275 = fruitStartTimes;
                        end;

                        if v275 then
                            v271[v272] = v275;
                        elseif v269 then
                            v271[v272] = v268 - v270;
                        else
                            v271[v272] = v268;
                        end;
                    end;
                end;
            end;
        end;

        local v276 = {
            seedType = p265.seedType,
            multiplier = p265.multiplier,
            fruitStartTimes = v271,
            treeMutations = MutationConfig.Sanitize(p265.mutations)
        };
        u245[p264] = v276;

        for i, v in u44[p264] do
            local v277 = math.clamp((v268 - v271[i]) / v270, 0, 1);

            if v277 >= 1 then
                updateFruitScale(v, 1);
                setFruitReady(v, v276);
            else
                updateFruitScale(v, v277);
            end;
        end;
    end;

    local u278 = false;

    local function setTreeHighlightEnabled(p279, p280) -- Line: 1449
        local AxeCollectHighlight = p279:FindFirstChild("AxeCollectHighlight");

        if not p280 then
            if AxeCollectHighlight then
                AxeCollectHighlight.Enabled = false;
            end;

            return;
        end;

        if not AxeCollectHighlight then
            AxeCollectHighlight = Instance.new("Highlight");
            AxeCollectHighlight.Name = "AxeCollectHighlight";
            AxeCollectHighlight.FillTransparency = 1;
            AxeCollectHighlight.OutlineColor = Color3.new(1, 1, 1);
            AxeCollectHighlight.OutlineTransparency = 0;
            AxeCollectHighlight.Parent = p279;
        end;

        AxeCollectHighlight.Enabled = true;
    end;

    local function treeModelFromPromptPart(p281) -- Line: 1466
        -- upvalues: u37 (ref)
        if not (p281 and p281:IsA("BasePart")) then
            return nil;
        end;

        if not p281.Name:match("^TreeBasePrompt_") then
            return nil;
        end;

        if not u37 then
            return nil;
        end;

        local v282 = u37:FindFirstChild("PlotTree_" .. p281.Name:gsub("^TreeBasePrompt_", ""));

        if not (v282 and (v282:IsA("Model") and v282)) then
            v282 = nil;
        end;

        return v282;
    end;

    local function populateTreeInfo(p283, p284, p285, p286, p287) -- Line: 1475
        -- upvalues: SeedConfig (ref), AbbreviateNumber (ref), MutationText (ref), MutationConfig (ref)
        local MainFrame = p283:FindFirstChild("MainFrame");
        local v288;

        if MainFrame then
            v288 = MainFrame:FindFirstChild("Name");
        else
            v288 = MainFrame;
        end;

        local v289;

        if MainFrame then
            v289 = MainFrame:FindFirstChild("Value");
        else
            v289 = MainFrame;
        end;

        local v290;

        if MainFrame then
            v290 = MainFrame:FindFirstChild("GrowthProgress");
        else
            v290 = MainFrame;
        end;

        if MainFrame then
            MainFrame = MainFrame:FindFirstChild("Mutations");
        end;

        local v291 = SeedConfig.GetSeed(p284);
        local v292 = v291 and v291.displayName or "Tree";
        local v293 = p285 or 1;

        if v290 then
            v290.Visible = false;
        end;

        if v288 then
            v288.Text = p287 and string.format("Dead %s (%.1fx)", v292, v293) or string.format("%s (%.1fx)", v292, v293);
        end;

        if v289 then
            v289.Visible = true;
            v289.Text = "$" .. AbbreviateNumber(p287 and SeedConfig.CalcDeadWoodValue(p284, v293, p286) or SeedConfig.CalcTotalTreeValue(p284, v293, p286));
        end;

        if MainFrame then
            MutationText.apply(MainFrame, MutationConfig.Sanitize(p286));
        end;
    end;

    local function destroyTreeBillboard(p294) -- Line: 1501
        -- upvalues: u46 (copy)
        local v295 = u46[p294];

        if not v295 then
            return;
        end;

        if v295.billboard then
            v295.billboard:Destroy();
        end;

        u46[p294] = nil;
    end;

    local function setupTreeBillboard(u296, p297) -- Line: 1508
        -- upvalues: u37 (ref), u46 (copy), FruitBillboard_WithPrompt (copy), ScreenGui (copy), populateTreeInfo (copy), setupCustomPromptButton (copy)
        if not u37 then
            return;
        end;

        local v298 = u46[u296];

        if v298 then
            if v298.billboard then
                v298.billboard:Destroy();
            end;

            u46[u296] = nil;
        end;

        local v299 = u37:WaitForChild("TreeBasePrompt_" .. u296, 10);

        if not v299 then
            return;
        end;

        local v300 = FruitBillboard_WithPrompt:Clone();
        v300.Adornee = v299;
        v300.Enabled = false;
        v300.MaxDistance = 10000;
        v300.Parent = ScreenGui;
        local MainFrame = v300:FindFirstChild("MainFrame");

        if MainFrame then
            MainFrame = MainFrame:FindFirstChild("CustomPrompt");
        end;

        populateTreeInfo(v300, p297.seedType, p297.multiplier, p297.mutations, p297.isDead == true);

        if MainFrame then
            setupCustomPromptButton(MainFrame, "Collect", function() -- Line: 1526
                -- upvalues: u37 (ref), u296 (copy)
                local v301 = u37 and u37:FindFirstChild("TreeBasePrompt_" .. u296);

                if v301 then
                    v301 = v301:FindFirstChildWhichIsA("ProximityPrompt");
                end;

                return v301;
            end);
        end;

        u46[u296] = {
            billboard = v300,
            customPrompt = MainFrame
        };
    end;

    local function expectedFruitCount(p302) -- Line: 1535
        -- upvalues: PlantStages (copy)
        if not PlantStages then
            return 0;
        end;

        local v303 = PlantStages:FindFirstChild(p302);

        if v303 then
            v303 = v303:FindFirstChild(p302 .. "4");
        end;

        if v303 then
            v303 = v303:FindFirstChild("FruitSpawns");
        end;

        if not v303 then
            return 0;
        end;

        local v304 = 0;

        for _, child in v303:GetChildren() do
            if child:IsA("BasePart") then
                v304 = v304 + 1;
            end;
        end;

        return v304;
    end;

    local function restoreTreeVisuals(u305, u306) -- Line: 1548
        -- upvalues: u37 (ref), expectedFruitCount (copy), setupFruitVisualsForTree (copy), setupTreeBillboard (copy), MutationRecolor (ref)
        task.spawn(function() -- Line: 1549
            -- upvalues: u37 (ref), u305 (copy), u306 (copy), expectedFruitCount (ref), setupFruitVisualsForTree (ref), setupTreeBillboard (ref), MutationRecolor (ref)
            if not u37 then
                return;
            end;

            local v307 = u37:WaitForChild("PlotTree_" .. u305, 20);

            if not v307 then
                return;
            end;

            local v308 = u306.stageIndex == 4 and (not u306.isDead and v307:WaitForChild("FruitSpawns", 20));

            if v308 then
                local v309 = expectedFruitCount(u306.seedType or "Oak");

                for _ = 1, 100 do
                    local v310 = 0;

                    for _, child in v308:GetChildren() do
                        if child:IsA("BasePart") then
                            v310 = v310 + 1;
                        end;
                    end;

                    if v310 > 0 and (v309 == 0 or v309 <= v310) then
                        break;
                    end;

                    task.wait(0.2);
                end;
            end;

            setupFruitVisualsForTree(u305, u306);
            setupTreeBillboard(u305, u306);
            local u311 = u305;
            local mutations = u306.mutations;

            if mutations then
                if not mutations[1] then
                    return;
                end;

                task.spawn(function() -- Line: 1361
                    -- upvalues: u37 (ref), u311 (copy), mutations (copy), MutationRecolor (ref)
                    for _ = 1, 25 do
                        local v312 = u37 and u37:FindFirstChild("PlotTree_" .. u311);

                        if v312 and (v312:FindFirstChild("Leaves") or v312:FindFirstChild("Wood")) then
                            break;
                        end;

                        task.wait(0.2);
                    end;

                    local v313 = u311;
                    local v314 = MutationRecolor.pickTreeKey(mutations);

                    if v314 then
                        if not u37 then
                            return;
                        end;

                        local v315 = u37:FindFirstChild("PlotTree_" .. v313);

                        if v315 then
                            MutationRecolor.apply(v315, v314);
                        end;
                    end;
                end);
            end;
        end);
    end;

    local function treeIdFromPromptPart(p316) -- Line: 1573
        return p316.Name:gsub("^TreeBasePrompt_", "");
    end;

    local function decorModelFromPromptPart(p317) -- Line: 1578
        -- upvalues: u37 (ref)
        if not (p317 and p317:IsA("BasePart")) then
            return nil;
        end;

        if not p317.Name:match("^DecorPickupPrompt_") then
            return nil;
        end;

        if not u37 then
            return nil;
        end;

        local v318 = u37:FindFirstChild("PlotDecor_" .. p317.Name:gsub("^DecorPickupPrompt_", ""));

        if not (v318 and (v318:IsA("Model") and v318)) then
            v318 = nil;
        end;

        return v318;
    end;

    u19:GiveTask(ProximityPromptService.PromptShown:Connect(function(p319) -- Line: 1587
        -- upvalues: u278 (ref), treeModelFromPromptPart (copy), u46 (copy), decorModelFromPromptPart (copy)
        if not u278 then
            return;
        end;

        local v320 = treeModelFromPromptPart(p319.Parent);

        if v320 then
            local AxeCollectHighlight = v320:FindFirstChild("AxeCollectHighlight");

            if not AxeCollectHighlight then
                AxeCollectHighlight = Instance.new("Highlight");
                AxeCollectHighlight.Name = "AxeCollectHighlight";
                AxeCollectHighlight.FillTransparency = 1;
                AxeCollectHighlight.OutlineColor = Color3.new(1, 1, 1);
                AxeCollectHighlight.OutlineTransparency = 0;
                AxeCollectHighlight.Parent = v320;
            end;

            AxeCollectHighlight.Enabled = true;
            local v321 = u46[p319.Parent.Name:gsub("^TreeBasePrompt_", "")];

            if v321 then
                if v321.billboard then
                    v321.billboard.Enabled = true;
                end;

                if v321.customPrompt then
                    v321.customPrompt.Visible = true;
                end;
            end;
        end;

        local v322 = decorModelFromPromptPart(p319.Parent);

        if v322 then
            local AxeCollectHighlight = v322:FindFirstChild("AxeCollectHighlight");

            if not AxeCollectHighlight then
                AxeCollectHighlight = Instance.new("Highlight");
                AxeCollectHighlight.Name = "AxeCollectHighlight";
                AxeCollectHighlight.FillTransparency = 1;
                AxeCollectHighlight.OutlineColor = Color3.new(1, 1, 1);
                AxeCollectHighlight.OutlineTransparency = 0;
                AxeCollectHighlight.Parent = v322;
            end;

            AxeCollectHighlight.Enabled = true;
        end;
    end));
    u19:GiveTask(ProximityPromptService.PromptHidden:Connect(function(p323) -- Line: 1602
        -- upvalues: treeModelFromPromptPart (copy), u46 (copy), decorModelFromPromptPart (copy)
        local v324 = treeModelFromPromptPart(p323.Parent);

        if v324 then
            local AxeCollectHighlight = v324:FindFirstChild("AxeCollectHighlight");

            if AxeCollectHighlight then
                AxeCollectHighlight.Enabled = false;
            end;

            local v325 = u46[p323.Parent.Name:gsub("^TreeBasePrompt_", "")];

            if v325 then
                if v325.billboard then
                    v325.billboard.Enabled = false;
                end;

                if v325.customPrompt then
                    v325.customPrompt.Visible = false;
                end;
            end;
        end;

        local v326 = decorModelFromPromptPart(p323.Parent);
        local v327 = v326 and v326:FindFirstChild("AxeCollectHighlight");

        if v327 then
            v327.Enabled = false;
        end;
    end));
    local u328 = nil;

    local function targetUnderPoint(p329, p330) -- Line: 1621
        -- upvalues: CurrentCamera (copy), LocalPlayer (copy)
        local v331 = CurrentCamera:ScreenPointToRay(p329, p330);
        local v332 = RaycastParams.new();
        v332.FilterType = Enum.RaycastFilterType.Exclude;
        v332.FilterDescendantsInstances = { LocalPlayer.Character };
        local v333 = workspace:Raycast(v331.Origin, v331.Direction * 1000, v332);

        if v333 then
            v333 = v333.Instance;
        end;

        while v333 and v333 ~= workspace do
            if v333:IsA("Model") and v333.Name:match("^FruitVisual_") then
                return nil, v333;
            end;

            if v333:IsA("Model") and (v333.Name:match("^PlotTree_") and v333:GetAttribute("SeedType")) then
                return v333, nil;
            end;

            v333 = v333.Parent;
        end;

        return nil, nil;
    end;

    local function findFruitVisual(p334) -- Line: 1640
        -- upvalues: u44 (copy), u45 (ref)
        for _, v in u44 do
            for _, v2 in v do
                if v2.model == p334 then
                    return v2;
                end;
            end;
        end;

        for _, v in u45 do
            for _, v2 in v do
                if v2.model == p334 then
                    return v2;
                end;
            end;
        end;

        return nil;
    end;

    local function ensureCursorRarityLabel() -- Line: 1651
        -- upvalues: TreeInfo (copy)
        if not TreeInfo then
            return nil;
        end;

        local Rarity = TreeInfo:FindFirstChild("Rarity");

        if Rarity then
            return Rarity;
        end;

        local Name = TreeInfo:FindFirstChild("Name");
        local Value = TreeInfo:FindFirstChild("Value");

        if not (Name and Value) then
            return nil;
        end;

        local v335 = Name:Clone();
        v335.Name = "Rarity";
        v335.Size = Value.Size;
        v335.LayoutOrder = 3;
        Value.LayoutOrder = 4;
        v335.Parent = TreeInfo;

        return v335;
    end;

    local function populateCursorTreeInfo(p336) -- Line: 1669
        -- upvalues: TreeInfo (copy), SeedConfig (ref), AbbreviateNumber (ref), ensureCursorRarityLabel (copy), ExpandedRarities (ref), CollectionService (ref), MutationText (ref), MutationConfig (ref)
        if not TreeInfo then
            return;
        end;

        local v337 = p336:GetAttribute("SeedType");
        local v338 = p336:GetAttribute("Multiplier") or 1;
        local v339 = p336:GetAttribute("IsDead") == true;
        local v340 = {};
        local v341 = p336:GetAttribute("Mutations");

        if v341 and v341 ~= "" then
            for _, v in string.split(v341, ",") do
                if v ~= "" then
                    table.insert(v340, v);
                end;
            end;
        end;

        local v342 = SeedConfig.GetSeed(v337);
        local v343 = v342 and (v342.displayName or "Tree") or "Tree";
        local Name = TreeInfo:FindFirstChild("Name");
        local Value = TreeInfo:FindFirstChild("Value");
        local Mutations = TreeInfo:FindFirstChild("Mutations");
        local FruitMoney = TreeInfo:FindFirstChild("FruitMoney");

        if Name then
            Name.Text = v339 and string.format("Dead %s (%.1fx)", v343, v338) or string.format("%s (%.1fx)", v343, v338);
        end;

        if Value then
            Value.Text = "$" .. AbbreviateNumber(v339 and SeedConfig.CalcDeadWoodValue(v337, v338, v340) or SeedConfig.CalcTotalTreeValue(v337, v338, v340));
        end;

        local v344 = ensureCursorRarityLabel();

        if v344 then
            local v345 = v342 and v342.rarity or "COMMON";
            local v346 = ExpandedRarities[v345];
            local v347;

            if v346 then
                v347 = v346.name or v345;
            else
                v347 = v345;
            end;

            v344.Text = v347;
            CollectionService:RemoveTag(v344, "ShinyTextLabel");
            local v348 = v344:FindFirstChildWhichIsA("UIGradient");

            if v348 then
                v348:Destroy();
            end;

            v344:SetAttribute("rarity", v345);
            CollectionService:AddTag(v344, "ShinyTextLabel");
        end;

        if Mutations then
            MutationText.apply(Mutations, MutationConfig.Sanitize(v340));
        end;

        if FruitMoney then
            FruitMoney.Visible = false;
        end;
    end;

    local function hideHoverTree() -- Line: 1715
        -- upvalues: u328 (ref), TreeInfo (copy), u30 (ref), HoverInfo (copy), CursorUI (copy)
        u328 = nil;

        if TreeInfo then
            TreeInfo.Visible = false;
        end;

        if not (u30 or HoverInfo and HoverInfo.Visible) then
            CursorUI.Visible = false;
        end;
    end;

    local function populateCursorFruitInfo(p349) -- Line: 1724
        -- upvalues: TreeInfo (copy), SeedConfig (ref), fruitEffectiveSize (copy), AbbreviateNumber (ref), MutationConfig (ref), ensureCursorRarityLabel (copy), ExpandedRarities (ref), CollectionService (ref), MutationText (ref)
        if not TreeInfo then
            return;
        end;

        local v350 = SeedConfig.GetSeed(p349.seedType);
        local v351 = v350 and (v350.fruitName or "Fruit") or "Fruit";
        local Name = TreeInfo:FindFirstChild("Name");
        local Value = TreeInfo:FindFirstChild("Value");
        local Mutations = TreeInfo:FindFirstChild("Mutations");
        local FruitMoney = TreeInfo:FindFirstChild("FruitMoney");

        if Name then
            Name.Text = string.format("%s (%.1fx)", v351, fruitEffectiveSize(p349));
        end;

        if Value then
            if p349.ready then
                local v352 = SeedConfig.CalcPlotFruitValue(p349.seedType, fruitEffectiveSize(p349)) * MutationConfig.ProductMult(p349.mutations);
                Value.Text = "$" .. AbbreviateNumber((math.floor(v352)));
            else
                Value.Text = p349.growthLabel and (p349.growthLabel.Text or "") or "";
            end;
        end;

        local v353 = ensureCursorRarityLabel();

        if v353 then
            local v354 = v350 and v350.rarity or "COMMON";
            local v355 = ExpandedRarities[v354];
            local v356;

            if v355 then
                v356 = v355.name or v354;
            else
                v356 = v354;
            end;

            v353.Text = v356;
            CollectionService:RemoveTag(v353, "ShinyTextLabel");
            local v357 = v353:FindFirstChildWhichIsA("UIGradient");

            if v357 then
                v357:Destroy();
            end;

            v353:SetAttribute("rarity", v354);
            CollectionService:AddTag(v353, "ShinyTextLabel");
        end;

        if Mutations then
            MutationText.apply(Mutations, MutationConfig.Sanitize(p349.ready and p349.mutations or p349.treeMutations));
        end;

        if FruitMoney then
            FruitMoney.Visible = false;
        end;
    end;

    local function showHoverFruit(p358, p359, p360) -- Line: 1760
        -- upvalues: TreeInfo (copy), u30 (ref), u328 (ref), HoverInfo (copy), CursorUI (copy), populateCursorFruitInfo (copy), PlantSeed (copy)
        if not TreeInfo or u30 then
            u328 = nil;

            if TreeInfo then
                TreeInfo.Visible = false;
            end;

            if not (u30 or HoverInfo and HoverInfo.Visible) then
                CursorUI.Visible = false;
            end;

            return;
        end;

        if p358.billboard and p358.billboard.Enabled then
            u328 = nil;

            if TreeInfo then
                TreeInfo.Visible = false;
            end;

            if not (u30 or HoverInfo and HoverInfo.Visible) then
                CursorUI.Visible = false;
            end;

            return;
        end;

        populateCursorFruitInfo(p358);
        u328 = nil;

        if PlantSeed then
            PlantSeed.Visible = false;
        end;

        TreeInfo.Visible = true;
        CursorUI.Position = UDim2.fromOffset(p359, p360 + 10);
        CursorUI.Visible = true;
    end;

    local function showHoverTree(p361, p362, p363) -- Line: 1772
        -- upvalues: TreeInfo (copy), u30 (ref), u328 (ref), HoverInfo (copy), CursorUI (copy), u46 (copy), populateCursorTreeInfo (copy), PlantSeed (copy)
        if not TreeInfo or u30 then
            u328 = nil;

            if TreeInfo then
                TreeInfo.Visible = false;
            end;

            if not (u30 or HoverInfo and HoverInfo.Visible) then
                CursorUI.Visible = false;
            end;

            return;
        end;

        local v364 = p361.Name:gsub("^PlotTree_", "");
        local v365 = u46[v364];

        if v365 and (v365.billboard and v365.billboard.Enabled) then
            u328 = nil;

            if TreeInfo then
                TreeInfo.Visible = false;
            end;

            if not (u30 or HoverInfo and HoverInfo.Visible) then
                CursorUI.Visible = false;
            end;

            return;
        end;

        populateCursorTreeInfo(p361);
        u328 = v364;

        if PlantSeed then
            PlantSeed.Visible = false;
        end;

        TreeInfo.Visible = true;
        CursorUI.Position = UDim2.fromOffset(p362, p363 + 10);
        CursorUI.Visible = true;
    end;

    if u21 then
        u19:GiveTask(UserInputService.InputBegan:Connect(function(p366, p367) -- Line: 1788
            -- upvalues: targetUnderPoint (copy), findFruitVisual (copy), showHoverTree (copy), showHoverFruit (copy)
            if p367 or p366.UserInputType ~= Enum.UserInputType.Touch then
                return;
            end;

            local v368, v369 = targetUnderPoint(p366.Position.X, p366.Position.Y);

            if v369 then
                v369 = findFruitVisual(v369);
            end;

            if v368 then
                showHoverTree(v368, p366.Position.X, p366.Position.Y);

                return;
            end;

            if v369 then
                showHoverFruit(v369, p366.Position.X, p366.Position.Y);
            end;
        end));
        u19:GiveTask(UserInputService.InputEnded:Connect(function(p370) -- Line: 1798
            -- upvalues: u328 (ref), TreeInfo (copy), u30 (ref), HoverInfo (copy), CursorUI (copy)
            if p370.UserInputType == Enum.UserInputType.Touch then
                u328 = nil;

                if TreeInfo then
                    TreeInfo.Visible = false;
                end;

                if not (u30 or HoverInfo and HoverInfo.Visible) then
                    CursorUI.Visible = false;
                end;
            end;
        end));
    else
        u19:GiveTask(RunService.Heartbeat:Connect(function() -- Line: 1802
            -- upvalues: u30 (ref), u328 (ref), TreeInfo (copy), HoverInfo (copy), CursorUI (copy), targetUnderPoint (copy), u20 (copy), findFruitVisual (copy), showHoverTree (copy), showHoverFruit (copy)
            if u30 then
                u328 = nil;

                if TreeInfo then
                    TreeInfo.Visible = false;
                end;

                if not (u30 or HoverInfo and HoverInfo.Visible) then
                    CursorUI.Visible = false;
                end;

                return;
            end;

            local v371, v372 = targetUnderPoint(u20.X, u20.Y);

            if v372 then
                v372 = findFruitVisual(v372);
            end;

            if v371 then
                showHoverTree(v371, u20.X, u20.Y);

                return;
            end;

            if v372 then
                showHoverFruit(v372, u20.X, u20.Y);

                return;
            end;

            u328 = nil;

            if TreeInfo then
                TreeInfo.Visible = false;
            end;

            if not (u30 or HoverInfo and HoverInfo.Visible) then
                CursorUI.Visible = false;
            end;
        end));
    end;

    local function getRootPosition() -- Line: 1816
        -- upvalues: LocalPlayer (copy)
        local Character = LocalPlayer.Character;

        if not Character then
            return nil;
        end;

        local v373 = Character:FindFirstChild("HumanoidRootPart") or Character.PrimaryPart;

        return v373 and v373.Position or nil;
    end;

    local function horizontalDistance(p374, p375) -- Line: 1823
        return (Vector3.new(p374.X, 0, p374.Z) - Vector3.new(p375.X, 0, p375.Z)).Magnitude;
    end;

    local u376 = Knit.GetController("MobileControls");

    local function placeInFront() -- Line: 1835
        -- upvalues: u42 (ref), getEquippedTreeTool (ref), LocalPlayer (copy), getEquippedEggTool (ref), getEquippedPetTool (ref), treeFrontTarget (copy), u22 (copy), u140 (ref)
        if u42 then
            return;
        end;

        local v377 = getEquippedTreeTool(LocalPlayer);
        local v378;

        if v377 then
            v378 = "Tree";
        else
            v377 = getEquippedEggTool(LocalPlayer);

            if v377 then
                v378 = "Egg";
            else
                v377 = getEquippedPetTool(LocalPlayer);

                if v377 then
                    v378 = "Pet";
                else
                    v377 = nil;
                    v378 = nil;
                end;
            end;
        end;

        if v377 then
            v377 = v377:GetAttribute("ItemId");
        end;

        if not v377 then
            return;
        end;

        local v379 = treeFrontTarget();

        if not v379 then
            return;
        end;

        u42 = true;

        if v378 == "Egg" then
            u22:PlaceEgg(v377, { (CFrame.new(v379) * CFrame.Angles(0, u140, 0)):GetComponents() });
        else
            u22:PlantTree(v377, v379, u140);
        end;

        u42 = false;
    end;

    u376.TreePlantButton:Connect(function() -- Line: 1853
        -- upvalues: getEquippedPetTool (ref), LocalPlayer (copy), doPlacePet (copy), placeInFront (copy)
        if getEquippedPetTool(LocalPlayer) then
            doPlacePet();

            return;
        end;

        placeInFront();
    end);
    local u380 = {
        Tree = "PLANT TREE",
        Egg = "PLACE EGG",
        Pet = "PLACE PET"
    };
    local u381 = false;
    local u382 = nil;
    u19:GiveTask(RunService.Heartbeat:Connect(function() -- Line: 1861
        -- upvalues: getEquippedTreeTool (ref), LocalPlayer (copy), getEquippedEggTool (ref), getEquippedPetTool (ref), isOnMyPlot (copy), u43 (ref), u381 (ref), u376 (copy), u382 (ref), u380 (copy)
        local v383 = getEquippedTreeTool(LocalPlayer) and "Tree" or (getEquippedEggTool(LocalPlayer) and "Egg" or (getEquippedPetTool(LocalPlayer) and "Pet" or nil));
        local v384;

        if v383 == nil then
            v384 = false;
        else
            v384 = isOnMyPlot();
        end;

        u43 = v384;

        if v384 ~= u381 then
            u381 = v384;
            u376:SetTreePlaceVisible(v384);
        end;

        if v384 and v383 ~= u382 then
            u382 = v383;
            u376:SetTreePlaceText(u380[v383] or "PLANT TREE");
        end;
    end));

    local function refreshAxeState() -- Line: 1876
        -- upvalues: u37 (ref), LocalPlayer (copy), u278 (ref)
        if not u37 then
            return;
        end;

        local Character = LocalPlayer.Character;
        local v385;

        if Character then
            local v386 = Character:FindFirstChild("HumanoidRootPart") or Character.PrimaryPart;
            v385 = v386 and v386.Position or nil;
        else
            v385 = nil;
        end;

        for _, child in u37:GetChildren() do
            if child:IsA("BasePart") then
                local v387 = child.Name:match("^TreeBasePrompt_") ~= nil;
                local v388 = child.Name:match("^DecorPickupPrompt_") ~= nil;

                if v387 or v388 then
                    local v389 = child:FindFirstChildWhichIsA("ProximityPrompt");

                    if v389 then
                        if not v387 then
                            if v385 == nil then
                                v387 = false;
                            else
                                local Position = child.Position;
                                v387 = (Vector3.new(Position.X, 0, Position.Z) - Vector3.new(v385.X, 0, v385.Z)).Magnitude <= 50;
                            end;
                        end;

                        local v390;

                        if v388 then
                            local v391 = u37:FindFirstChild("PlotDecor_" .. child.Name:gsub("^DecorPickupPrompt_", ""));

                            if v391 == nil then
                                v390 = false;
                            else
                                v390 = v391:GetAttribute("PickupLocked") == true;
                            end;
                        else
                            v390 = false;
                        end;

                        u278 = u278;

                        if u278 then
                            if v387 then
                                v387 = not v390;
                            end;
                        end;

                        v389.Enabled = v387;
                    end;
                end;
            end;
        end;
    end;

    local u392 = false;

    local function getEquippedFruit() -- Line: 1906
        -- upvalues: LocalPlayer (copy)
        local Character = LocalPlayer.Character;

        if not Character then
            return nil;
        end;

        for _, child in Character:GetChildren() do
            if child:IsA("Tool") and child:GetAttribute("IsFruit") then
                return child;
            end;
        end;

        return nil;
    end;

    local function refreshStandState() -- Line: 1915
        -- upvalues: u37 (ref), LocalPlayer (copy), u392 (ref)
        if not u37 then
            return;
        end;

        local Character = LocalPlayer.Character;
        local v393;

        if Character then
            local v394 = Character:FindFirstChild("HumanoidRootPart") or Character.PrimaryPart;
            v393 = v394 and v394.Position or nil;
        else
            v393 = nil;
        end;

        for _, child in u37:GetChildren() do
            if child:IsA("Model") and child.Name:match("^PlotDecor_") then
                for _, descendant in child:GetDescendants() do
                    if descendant:IsA("BasePart") and descendant.Name == "SpawnPart" then
                        local v395 = descendant:FindFirstChildWhichIsA("ProximityPrompt");

                        if v395 then
                            local v396 = descendant:FindFirstChild("FruitDisplay") ~= nil;
                            local v397;

                            if v393 == nil then
                                v397 = false;
                            else
                                local Position = descendant.Position;
                                v397 = (Vector3.new(Position.X, 0, Position.Z) - Vector3.new(v393.X, 0, v393.Z)).Magnitude <= 50;
                            end;

                            if v397 then
                                v397 = v396 or u392;
                            end;

                            v395.Enabled = v397;
                        end;
                    end;
                end;
            end;
        end;
    end;

    local function updateHolding() -- Line: 1936
        -- upvalues: getEquippedAxe (ref), LocalPlayer (copy), u278 (ref), refreshAxeState (copy), getEquippedFruit (copy), u392 (ref), refreshStandState (copy)
        local v398 = getEquippedAxe(LocalPlayer) ~= nil;

        if v398 ~= u278 then
            u278 = v398;
            refreshAxeState();
        end;

        local v399 = getEquippedFruit() ~= nil;

        if v399 ~= u392 then
            u392 = v399;
            refreshStandState();
        end;
    end;

    local function watchCharacter(p400) -- Line: 1949
        -- upvalues: u278 (ref), getEquippedAxe (ref), LocalPlayer (copy), u392 (ref), getEquippedFruit (copy), refreshAxeState (copy), refreshStandState (copy), u19 (copy), updateHolding (copy)
        u278 = getEquippedAxe(LocalPlayer) ~= nil;
        u392 = getEquippedFruit() ~= nil;
        refreshAxeState();
        refreshStandState();
        u19:GiveTask(p400.ChildAdded:Connect(function(p401) -- Line: 1954
            -- upvalues: updateHolding (ref)
            if p401:IsA("Tool") then
                task.defer(updateHolding);
            end;
        end));
        u19:GiveTask(p400.ChildRemoved:Connect(function(p402) -- Line: 1957
            -- upvalues: updateHolding (ref)
            if p402:IsA("Tool") then
                task.defer(updateHolding);
            end;
        end));
    end;

    if LocalPlayer.Character then
        watchCharacter(LocalPlayer.Character);
    end;

    u19:GiveTask(LocalPlayer.CharacterAdded:Connect(watchCharacter));
    local u403 = 0;
    u19:GiveTask(RunService.Heartbeat:Connect(function(p404) -- Line: 1968
        -- upvalues: u403 (ref), u278 (ref), refreshAxeState (copy), refreshStandState (copy)
        u403 = u403 + p404;

        if u403 < 0.15 then
            return;
        end;

        u403 = 0;

        if u278 then
            refreshAxeState();
        end;

        refreshStandState();
    end));
    u19:GiveTask(u22.TreePlanted:Connect(function(p405, u406) -- Line: 1980
        -- upvalues: u36 (ref), u37 (ref), expectedFruitCount (copy), setupFruitVisualsForTree (copy), setupTreeBillboard (copy), MutationRecolor (ref), refreshAxeState (copy), u52 (ref)
        if p405 ~= u36 then
            return;
        end;

        local id = u406.id;
        task.spawn(function() -- Line: 1549
            -- upvalues: u37 (ref), id (copy), u406 (copy), expectedFruitCount (ref), setupFruitVisualsForTree (ref), setupTreeBillboard (ref), MutationRecolor (ref)
            if not u37 then
                return;
            end;

            local v407 = u37:WaitForChild("PlotTree_" .. id, 20);

            if not v407 then
                return;
            end;

            local v408 = u406.stageIndex == 4 and (not u406.isDead and v407:WaitForChild("FruitSpawns", 20));

            if v408 then
                local v409 = expectedFruitCount(u406.seedType or "Oak");

                for _ = 1, 100 do
                    local v410 = 0;

                    for _, child in v408:GetChildren() do
                        if child:IsA("BasePart") then
                            v410 = v410 + 1;
                        end;
                    end;

                    if v410 > 0 and (v409 == 0 or v409 <= v410) then
                        break;
                    end;

                    task.wait(0.2);
                end;
            end;

            setupFruitVisualsForTree(id, u406);
            setupTreeBillboard(id, u406);
            local u411 = id;
            local mutations = u406.mutations;

            if mutations then
                if not mutations[1] then
                    return;
                end;

                task.spawn(function() -- Line: 1361
                    -- upvalues: u37 (ref), u411 (copy), mutations (copy), MutationRecolor (ref)
                    for _ = 1, 25 do
                        local v412 = u37 and u37:FindFirstChild("PlotTree_" .. u411);

                        if v412 and (v412:FindFirstChild("Leaves") or v412:FindFirstChild("Wood")) then
                            break;
                        end;

                        task.wait(0.2);
                    end;

                    local v413 = u411;
                    local v414 = MutationRecolor.pickTreeKey(mutations);

                    if v414 then
                        if not u37 then
                            return;
                        end;

                        local v415 = u37:FindFirstChild("PlotTree_" .. v413);

                        if v415 then
                            MutationRecolor.apply(v415, v414);
                        end;
                    end;
                end);
            end;
        end);
        task.defer(refreshAxeState);
        u52();
    end));
    u19:GiveTask(u22.TreeRemoved:Connect(function(p416, p417) -- Line: 1987
        -- upvalues: u36 (ref), u44 (copy), destroyFruitVisual (copy), u46 (copy), u245 (copy), u52 (ref)
        if p416 ~= u36 then
            return;
        end;

        local v418 = u44[p417];

        if v418 then
            for _, v in v418 do
                destroyFruitVisual(v);
            end;

            u44[p417] = nil;
        end;

        local v419 = u46[p417];

        if v419 then
            if v419.billboard then
                v419.billboard:Destroy();
            end;

            u46[p417] = nil;
        end;

        u245[p417] = nil;
        u52();
    end));
    u19:GiveTask(u22.FruitReady:Connect(function(p420, p421, p422, p423, p424) -- Line: 2003
        -- upvalues: u36 (ref), u44 (copy), MutationConfig (ref), u245 (copy), SeedConfig (ref), u37 (ref), setFruitReady (copy)
        if p420 ~= u36 then
            return;
        end;

        local v425 = u44[p421];

        if not v425 then
            return;
        end;

        local v426 = v425[p422];

        if not v426 then
            return;
        end;

        v426.mutations = MutationConfig.Sanitize(p424);
        local v427 = u245[p421];

        if v427 then
            v427.fruitStartTimes[p422] = workspace:GetServerTimeNow() - SeedConfig.GetFruitGrowthTime(v427.multiplier, SeedConfig.PlotGrowthMult(u37));
            setFruitReady(v426, v427);
        end;
    end));
    u19:GiveTask(u22.FruitMutated:Connect(function(p428, p429, p430, p431, p432) -- Line: 2020
        -- upvalues: u36 (ref), u44 (copy), MutationConfig (ref), applyFruitMutationFX (copy), refreshFruitMutations (copy), AbbreviateNumber (ref)
        if p428 ~= u36 then
            return;
        end;

        local v433 = u44[p429];

        if not v433 then
            return;
        end;

        local v434 = v433[p430];

        if not v434 then
            return;
        end;

        v434.mutations = MutationConfig.Sanitize(p431);

        if v434.ready then
            applyFruitMutationFX(v434, v434.mutations);
        end;

        refreshFruitMutations(v434);

        if v434.valueLabel and v434.ready then
            v434.valueLabel.Text = "$" .. AbbreviateNumber(p432);
        end;
    end));
    u19:GiveTask(u22.FindCollected:Connect(function(p435) -- Line: 2039
        -- upvalues: playHarvestSound (copy)
        if p435 == "Fruit" or (p435 == "Seed" or p435 == "Egg") then
            playHarvestSound();
        end;
    end));
    u19:GiveTask(u22.CompostFed:Connect(function(p436) -- Line: 2044
        -- upvalues: SoundService (ref), u24 (copy)
        local Compost = SoundService:FindFirstChild("Compost", true);

        if Compost and p436 then
            u24:PlaySoundAtPosition(Compost, p436);
        end;
    end));
    u19:GiveTask(u22.FruitCollected:Connect(function(p437, p438, p439) -- Line: 2049
        -- upvalues: u36 (ref), playHarvestSound (copy), u44 (copy), u245 (copy), resetFruitVisual (copy)
        if p437 ~= u36 then
            return;
        end;

        playHarvestSound();
        local v440 = u44[p438];

        if not v440 then
            return;
        end;

        local v441 = v440[p439];

        if not v441 then
            return;
        end;

        local v442 = u245[p438];

        if v442 then
            resetFruitVisual(v441, v442, p438);
            v442.fruitStartTimes[p439] = workspace:GetServerTimeNow();
        end;
    end));
    u45 = {};
    local u443 = {};

    local function splitMuts(p444) -- Line: 2074
        local v445;

        if p444 then
            v445 = p444 ~= "" and string.split(p444, ",") or nil;
        else
            v445 = nil;
        end;

        return v445;
    end;

    local function clearOtherTree(p446) -- Line: 2078
        -- upvalues: u443 (copy), u45 (ref), destroyFruitVisual (copy)
        if u443[p446] then
            for _, v in u443[p446] do
                v:Disconnect();
            end;

            u443[p446] = nil;
        end;

        local v447 = u45[p446];

        if not v447 then
            return;
        end;

        for _, v in v447 do
            destroyFruitVisual(v);
        end;

        u45[p446] = nil;
    end;

    local function buildOtherTree(u448) -- Line: 2089
        -- upvalues: u45 (ref), u37 (ref), u443 (copy), createFruitVisual (copy), MutationConfig (ref), refreshFruitMutations (copy), applyFruitMutationFX (copy)
        if u45[u448] then
            return;
        end;

        if u448.Parent == u37 then
            return;
        end;

        local u449 = u448:GetAttribute("SeedType");
        local u450 = u448:GetAttribute("Multiplier");
        local FruitSpawns = u448:FindFirstChild("FruitSpawns");

        if not (u449 and (u450 and FruitSpawns)) then
            return;
        end;

        local v451 = u448:GetAttribute("Mutations");
        local u452;

        if v451 and v451 ~= "" then
            u452 = string.split(v451, ",") or nil;
        else
            u452 = nil;
        end;

        local u453 = {};
        local u454 = {};
        u45[u448] = u453;
        u443[u448] = u454;

        local function buildSpawn(u455) -- Line: 2101
            -- upvalues: u453 (copy), createFruitVisual (ref), u448 (copy), u449 (copy), u450 (copy), MutationConfig (ref), u452 (copy), refreshFruitMutations (ref), u454 (copy), applyFruitMutationFX (ref)
            if not u455:IsA("BasePart") then
                return;
            end;

            local v456 = u455:GetAttribute("SpawnIndex") or #u453 + 1;

            if u453[v456] then
                return;
            end;

            u455.Transparency = 1;
            local u457 = createFruitVisual(u448, {
                seedType = u449,
                multiplier = u450
            }, u455, v456);

            if not u457 then
                return;
            end;

            u453[v456] = u457;

            if u457.customPrompt then
                u457.customPrompt.Visible = false;
            end;

            u457.treeMutations = MutationConfig.Sanitize(u452);
            local v458 = u455:GetAttribute("FruitMutations");
            local v459;

            if v458 and v458 ~= "" then
                v459 = string.split(v458, ",") or nil;
            else
                v459 = nil;
            end;

            u457.mutations = MutationConfig.Sanitize(v459 or u452);
            refreshFruitMutations(u457);
            local v460 = u455:GetAttributeChangedSignal("FruitMutations");
            table.insert(u454, v460:Connect(function() -- Line: 2114
                -- upvalues: u457 (copy), MutationConfig (ref), u455 (copy), applyFruitMutationFX (ref), refreshFruitMutations (ref)
                local Sanitize = MutationConfig.Sanitize;
                local v461 = u455:GetAttribute("FruitMutations");
                local v462;

                if v461 and v461 ~= "" then
                    v462 = string.split(v461, ",") or nil;
                else
                    v462 = nil;
                end;

                u457.mutations = Sanitize(v462);

                if u457.ready then
                    applyFruitMutationFX(u457, u457.mutations);
                end;

                refreshFruitMutations(u457);
            end));
        end;

        for _, child in FruitSpawns:GetChildren() do
            buildSpawn(child);
        end;

        table.insert(u454, FruitSpawns.ChildAdded:Connect(buildSpawn));
    end;

    local function observeTree(u463) -- Line: 2128
        -- upvalues: buildOtherTree (copy)
        task.spawn(function() -- Line: 2129
            -- upvalues: u463 (copy), buildOtherTree (ref)
            for _ = 1, 50 do
                if not u463.Parent then
                    return;
                end;

                if u463:GetAttribute("SeedType") and (u463:GetAttribute("Multiplier") and u463:FindFirstChild("FruitSpawns")) then
                    buildOtherTree(u463);

                    return;
                end;

                task.wait(0.2);
            end;
        end);
    end;

    local function recolorOther(u464) -- Line: 2144
        -- upvalues: u37 (ref), MutationRecolor (ref)
        task.spawn(function() -- Line: 2145
            -- upvalues: u464 (copy), u37 (ref), MutationRecolor (ref)
            for _ = 1, 25 do
                if not u464.Parent then
                    return;
                end;

                if u464:FindFirstChild("Leaves") or u464:FindFirstChild("Wood") then
                    break;
                end;

                task.wait(0.2);
            end;

            if u464.Parent and u464.Parent ~= u37 then
                local pickTreeKey = MutationRecolor.pickTreeKey;
                local v465 = u464:GetAttribute("Mutations");
                local v466;

                if v465 and v465 ~= "" then
                    v466 = string.split(v465, ",") or nil;
                else
                    v466 = nil;
                end;

                local v467 = pickTreeKey(v466);

                if v467 then
                    MutationRecolor.apply(u464, v467);
                end;
            end;
        end);
    end;

    local function watchPlot(p468) -- Line: 2158
        -- upvalues: buildOtherTree (copy), u37 (ref), MutationRecolor (ref), u19 (copy), u45 (ref), clearOtherTree (copy)
        for _, child in p468:GetChildren() do
            if child.Name:match("^PlotTree_") then
                task.spawn(function() -- Line: 2129
                    -- upvalues: child (copy), buildOtherTree (ref)
                    for _ = 1, 50 do
                        if not child.Parent then
                            return;
                        end;

                        if child:GetAttribute("SeedType") and (child:GetAttribute("Multiplier") and child:FindFirstChild("FruitSpawns")) then
                            buildOtherTree(child);

                            return;
                        end;

                        task.wait(0.2);
                    end;
                end);
                task.spawn(function() -- Line: 2145
                    -- upvalues: child (copy), u37 (ref), MutationRecolor (ref)
                    for _ = 1, 25 do
                        if not child.Parent then
                            return;
                        end;

                        if child:FindFirstChild("Leaves") or child:FindFirstChild("Wood") then
                            break;
                        end;

                        task.wait(0.2);
                    end;

                    if child.Parent and child.Parent ~= u37 then
                        local pickTreeKey = MutationRecolor.pickTreeKey;
                        local v469 = child:GetAttribute("Mutations");
                        local v470;

                        if v469 and v469 ~= "" then
                            v470 = string.split(v469, ",") or nil;
                        else
                            v470 = nil;
                        end;

                        local v471 = pickTreeKey(v470);

                        if v471 then
                            MutationRecolor.apply(child, v471);
                        end;
                    end;
                end);
            end;
        end;

        u19:GiveTask(p468.ChildAdded:Connect(function(u472) -- Line: 2162
            -- upvalues: buildOtherTree (ref), u37 (ref), MutationRecolor (ref)
            if u472.Name:match("^PlotTree_") then
                task.spawn(function() -- Line: 2129
                    -- upvalues: u472 (copy), buildOtherTree (ref)
                    for _ = 1, 50 do
                        if not u472.Parent then
                            return;
                        end;

                        if u472:GetAttribute("SeedType") and (u472:GetAttribute("Multiplier") and u472:FindFirstChild("FruitSpawns")) then
                            buildOtherTree(u472);

                            return;
                        end;

                        task.wait(0.2);
                    end;
                end);
                task.spawn(function() -- Line: 2145
                    -- upvalues: u472 (copy), u37 (ref), MutationRecolor (ref)
                    for _ = 1, 25 do
                        if not u472.Parent then
                            return;
                        end;

                        if u472:FindFirstChild("Leaves") or u472:FindFirstChild("Wood") then
                            break;
                        end;

                        task.wait(0.2);
                    end;

                    if u472.Parent and u472.Parent ~= u37 then
                        local pickTreeKey = MutationRecolor.pickTreeKey;
                        local v473 = u472:GetAttribute("Mutations");
                        local v474;

                        if v473 and v473 ~= "" then
                            v474 = string.split(v473, ",") or nil;
                        else
                            v474 = nil;
                        end;

                        local v475 = pickTreeKey(v474);

                        if v475 then
                            MutationRecolor.apply(u472, v475);
                        end;
                    end;
                end);
            end;
        end));
        u19:GiveTask(p468.ChildRemoved:Connect(function(p476) -- Line: 2165
            -- upvalues: u45 (ref), clearOtherTree (ref)
            if u45[p476] then
                clearOtherTree(p476);
            end;
        end));
    end;

    u19:GiveTask(RunService.Heartbeat:Connect(function() -- Line: 2171
        -- upvalues: u45 (ref), u37 (ref), clearOtherTree (copy), SeedConfig (ref), setFruitReady (copy), resetFruitVisual (copy), fruitEffectiveSize (copy), updateFruitScale (copy), formatCountdown (ref)
        local v477 = workspace:GetServerTimeNow();

        for i, v in u45 do
            if i.Parent and i.Parent ~= u37 then
                local v478 = i:GetAttribute("Multiplier") or 1;
                local v479 = SeedConfig.GetFruitGrowthTime(v478, SeedConfig.PlotGrowthMult(i.Parent));
                local v480 = {
                    seedType = i:GetAttribute("SeedType") or "Oak",
                    multiplier = v478
                };

                for _, v2 in v do
                    if v2.model and v2.spawnPart then
                        local v481 = v2.spawnPart:GetAttribute("FruitStartTime");

                        if v481 then
                            local v482 = v477 - v481;
                            local v483 = math.clamp(v482 / v479, 0, 1);

                            if v483 >= 1 then
                                if not v2.ready then
                                    setFruitReady(v2, v480);
                                end;
                            else
                                if v2.ready then
                                    resetFruitVisual(v2, v480);
                                end;

                                if v2.spawnPart and ((v2.spawnPart:GetAttribute("FruitSizeMult") or 1) ~= v2.sizeMult and v2.spawnPart) then
                                    v2.sizeMult = v2.spawnPart:GetAttribute("FruitSizeMult") or 1;
                                    v2.fullScale = SeedConfig.CalcFruitScale(v2.seedType, fruitEffectiveSize(v2));
                                end;

                                updateFruitScale(v2, v483);

                                if v2.growthLabel and v2.growthLabel.Visible then
                                    v2.growthLabel.Text = formatCountdown(v479 - v482);
                                end;
                            end;
                        end;
                    end;
                end;
            else
                clearOtherTree(i);
            end;
        end;
    end));
    task.spawn(function() -- Line: 2206
        -- upvalues: watchPlot (copy), u19 (copy)
        local PlayerPlots = workspace:WaitForChild("BigField"):WaitForChild("PlayerPlots");

        for _, child in PlayerPlots:GetChildren() do
            if child:IsA("Model") and child.Name:match("^PlayerPlot") then
                watchPlot(child);
            end;
        end;

        u19:GiveTask(PlayerPlots.ChildAdded:Connect(function(p484) -- Line: 2211
            -- upvalues: watchPlot (ref)
            if p484:IsA("Model") and p484.Name:match("^PlayerPlot") then
                watchPlot(p484);
            end;
        end));
    end);
    u19:GiveTask(RunService.Heartbeat:Connect(function() -- Line: 2222
        -- upvalues: LocalPlayer (copy), RunService (ref), u133 (copy), CustomEnum (ref), UserInputService (ref), u44 (copy), u45 (ref), isOnMyPlot (copy)
        local CurrentCamera2 = workspace.CurrentCamera;
        local Character = LocalPlayer.Character;

        if Character then
            Character = Character:FindFirstChild("HumanoidRootPart");
        end;

        if Character then
            Character = Character.Position;
        end;

        local u485 = nil;
        local u486 = 0.97;

        if CurrentCamera2 and Character then
            local Position = CurrentCamera2.CFrame.Position;
            local LookVector = CurrentCamera2.CFrame.LookVector;

            if not (RunService:IsStudio() and workspace:GetAttribute("debugForceMobile")) and u133:getInputType() ~= CustomEnum.INPUT_TYPES.MOBILE then
                local v487 = UserInputService:GetMouseLocation();
                LookVector = CurrentCamera2:ScreenPointToRay(v487.X, v487.Y).Direction.Unit;
            end;

            local function consider(p488, p489) -- Line: 2238
                -- upvalues: Character (copy), Position (copy), LookVector (ref), u486 (ref), u485 (ref)
                local v490;

                if p488 then
                    v490 = p488.spawnPart;
                else
                    v490 = p488;
                end;

                if not (v490 and (v490.Parent and p488.billboard)) then
                    return;
                end;

                if p489 < (v490.Position - Character).Magnitude then
                    return;
                end;

                local v491 = v490.Position - Position;
                local Magnitude = v491.Magnitude;

                if Magnitude < 1 then
                    return;
                end;

                local v492 = LookVector:Dot(v491 / Magnitude);

                if u486 < v492 then
                    u486 = v492;
                    u485 = p488;
                end;
            end;

            for _, v in u44 do
                for _, v2 in v do
                    consider(v2, (1 / 0));
                end;
            end;

            for _, v in u45 do
                for _, v2 in v do
                    consider(v2, 35);
                end;
            end;
        end;

        local u493 = u485 and (u485.spawnPart and u485.spawnPart.Parent) and u485.spawnPart.Parent.Parent;

        local function growingVisible(p494) -- Line: 2257
            -- upvalues: u493 (copy), Character (copy)
            local spawnPart = p494.spawnPart;

            if not (u493 and (spawnPart and Character)) then
                return false;
            end;

            if spawnPart.Parent == nil or spawnPart.Parent.Parent ~= u493 then
                return false;
            end;

            return (spawnPart.Position - Character).Magnitude <= 60;
        end;

        local v495;

        if u485 == nil or u485.ready ~= true then
            v495 = nil;
        else
            v495 = u485 or nil;
        end;

        if not v495 and Character then
            local v496 = (1 / 0);

            for _, v in u44 do
                for _, v2 in v do
                    local v497;

                    if v2.ready == true then
                        v497 = v2.spawnPart or nil;
                    else
                        v497 = nil;
                    end;

                    if v497 and v497.Parent then
                        local Magnitude = (v497.Position - Character).Magnitude;

                        if Magnitude <= 35 and Magnitude < v496 then
                            v495 = v2;
                            v496 = Magnitude;
                        end;
                    end;
                end;
            end;
        end;

        local v498 = isOnMyPlot();

        for _, v in u44 do
            for _, v2 in v do
                if v2.billboard then
                    local v499 = v2 == v495;
                    local v500;

                    if v2.ready then
                        v500 = v499;
                    else
                        local spawnPart = v2.spawnPart;

                        if u493 and (spawnPart and Character) and (spawnPart.Parent ~= nil and spawnPart.Parent.Parent == u493) then
                            v500 = (spawnPart.Position - Character).Magnitude <= 60;
                        else
                            v500 = false;
                        end;
                    end;

                    v2.billboard.Enabled = v500;
                    local v501 = v2.spawnPart and v2.spawnPart:FindFirstChildWhichIsA("ProximityPrompt");

                    if v501 then
                        v501.Enabled = v499 and v498;
                    end;

                    if v2.highlight then
                        v2.highlight.Enabled = v499 and v498;
                    end;

                    if v2.customPrompt then
                        v2.customPrompt.Visible = v499 and v498;
                    end;
                end;
            end;
        end;

        for _, v in u45 do
            for _, v2 in v do
                if v2.billboard then
                    local v502;

                    if v2.ready then
                        v502 = v2 == u485;
                    else
                        local spawnPart = v2.spawnPart;

                        if u493 and (spawnPart and Character) and (spawnPart.Parent ~= nil and spawnPart.Parent.Parent == u493) then
                            v502 = (spawnPart.Position - Character).Magnitude <= 60;
                        else
                            v502 = false;
                        end;
                    end;

                    v2.billboard.Enabled = v502;
                end;

                if v2.highlight then
                    v2.highlight.Enabled = false;
                end;

                if v2.customPrompt then
                    v2.customPrompt.Visible = false;
                end;
            end;
        end;
    end));
    task.spawn(function() -- Line: 2311
        -- upvalues: u22 (copy), setupPlot (copy), u37 (ref), expectedFruitCount (copy), setupFruitVisualsForTree (copy), setupTreeBillboard (copy), MutationRecolor (ref), refreshAxeState (copy), u52 (ref)
        local v503, v504 = u22:GetMyPlot():await();

        if v503 and v504 then
            setupPlot(v504);
            local v505, v506 = u22:GetPlotTrees():await();

            if v505 and v506 then
                for _, v in v506 do
                    local id = v.id;
                    task.spawn(function() -- Line: 1549
                        -- upvalues: u37 (ref), id (copy), v (copy), expectedFruitCount (ref), setupFruitVisualsForTree (ref), setupTreeBillboard (ref), MutationRecolor (ref)
                        if not u37 then
                            return;
                        end;

                        local v507 = u37:WaitForChild("PlotTree_" .. id, 20);

                        if not v507 then
                            return;
                        end;

                        local v508 = v.stageIndex == 4 and (not v.isDead and v507:WaitForChild("FruitSpawns", 20));

                        if v508 then
                            local v509 = expectedFruitCount(v.seedType or "Oak");

                            for _ = 1, 100 do
                                local v510 = 0;

                                for _, child in v508:GetChildren() do
                                    if child:IsA("BasePart") then
                                        v510 = v510 + 1;
                                    end;
                                end;

                                if v510 > 0 and (v509 == 0 or v509 <= v510) then
                                    break;
                                end;

                                task.wait(0.2);
                            end;
                        end;

                        setupFruitVisualsForTree(id, v);
                        setupTreeBillboard(id, v);
                        local u511 = id;
                        local mutations = v.mutations;

                        if mutations then
                            if not mutations[1] then
                                return;
                            end;

                            task.spawn(function() -- Line: 1361
                                -- upvalues: u37 (ref), u511 (copy), mutations (copy), MutationRecolor (ref)
                                for _ = 1, 25 do
                                    local v512 = u37 and u37:FindFirstChild("PlotTree_" .. u511);

                                    if v512 and (v512:FindFirstChild("Leaves") or v512:FindFirstChild("Wood")) then
                                        break;
                                    end;

                                    task.wait(0.2);
                                end;

                                local v513 = u511;
                                local v514 = MutationRecolor.pickTreeKey(mutations);

                                if v514 then
                                    if not u37 then
                                        return;
                                    end;

                                    local v515 = u37:FindFirstChild("PlotTree_" .. v513);

                                    if v515 then
                                        MutationRecolor.apply(v515, v514);
                                    end;
                                end;
                            end);
                        end;
                    end);
                end;
            end;

            refreshAxeState();
            u52();
        end;
    end);
    u19:GiveTask(u22.PlotAssigned:Connect(function(p516) -- Line: 2327
        -- upvalues: setupPlot (copy), refreshAxeState (copy)
        setupPlot(p516);
        task.defer(refreshAxeState);
    end));
end;

function u1.KnitInit(p517) -- Line: 2333
end;

return u1;