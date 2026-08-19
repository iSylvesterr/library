-- Decompiled with Potassium's decompiler.

game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("RunService");
game:GetService("TweenService");
game:GetService("ContentProvider");
local Shared = ReplicatedStorage:WaitForChild("Shared");
local Client = ReplicatedStorage:WaitForChild("Client");
Client:WaitForChild("Modules"):WaitForChild("Utility");
local Utility = Shared:WaitForChild("Utility");
local Info = Shared:WaitForChild("Info");
local Packages = ReplicatedStorage:WaitForChild("Packages");
local UI_Manager = require(Client:WaitForChild("Controllers"):WaitForChild("UI_Manager"));
require(Packages:WaitForChild("Maid"));
local Knit = require(Packages:WaitForChild("Knit"));
require(Info:WaitForChild("Constants"));
local CustomEnum = require(Info:WaitForChild("CustomEnum"));
local ExpandedRarities = require(Info:WaitForChild("ExpandedRarities"));
local Images = require(Info:WaitForChild("Images"));
local PetAssets = require(Utility:WaitForChild("PetAssets"));
local PetConfig = require(Info:WaitForChild("PetConfig"));
local SeedConfig = require(Info:WaitForChild("SeedConfig"));
local IndexInfo = require(Info:WaitForChild("IndexInfo"));
local v1 = Knit.CreateController({
    Name = "IndexUIController"
});
local Index = game.Players.LocalPlayer.PlayerGui:WaitForChild("Windows"):WaitForChild("Index");
local LeftSide = Index:WaitForChild("LeftSide");
local Content = Index:WaitForChild("Content");
local Exit = Index:WaitForChild("Top"):WaitForChild("Exit");
local TextLabel = Content:WaitForChild("TitleSection"):WaitForChild("TextLabel");
local SeedsItemHolder = Content:WaitForChild("ScrollingFrameHolder"):WaitForChild("ScrollingFrame"):WaitForChild("SeedsItemHolder");
local FruitsItemHolder = Content:WaitForChild("ScrollingFrameHolder"):WaitForChild("ScrollingFrame"):WaitForChild("FruitsItemHolder");
local PetsItemHolder = Content:WaitForChild("ScrollingFrameHolder"):WaitForChild("ScrollingFrame"):WaitForChild("PetsItemHolder");
local CompletionSection = Content:WaitForChild("CompletionSection");
local Fill = CompletionSection:WaitForChild("Progress"):WaitForChild("Bar"):WaitForChild("Fill");
local DiscoverXMore = CompletionSection:WaitForChild("Progress"):WaitForChild("DiscoverXMore");
local Reward = CompletionSection:WaitForChild("Reward");
local RewardItems = Reward:WaitForChild("RewardItems");
local Reward2 = RewardItems:WaitForChild("Reward");
Reward2.Parent = script;
local RewardTitle = Reward:WaitForChild("RewardTitle");
local ClaimButton = Reward:WaitForChild("ClaimButton");
local Button = ClaimButton:WaitForChild("Button");
local AllFoundSection = Content:WaitForChild("AllFoundSection");
local Title = AllFoundSection:WaitForChild("Title");
local Buttons = LeftSide:WaitForChild("Buttons");
local Button2 = Buttons:WaitForChild("Seeds"):WaitForChild("Button");
local Button3 = Buttons:WaitForChild("Fruits"):WaitForChild("Button");
local Button4 = Buttons:WaitForChild("Pets"):WaitForChild("Button");
local FruitModels = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Greedy"):WaitForChild("FruitModels");
local Seeds = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Greedy"):WaitForChild("Seeds");
local u2 = nil;
local u3 = nil;
local u4 = {};
local u5 = {
    seeds = {},
    fruits = {},
    pets = {}
};
local u6 = {
    seeds = {},
    fruits = {},
    pets = {}
};
local SEEDS = CustomEnum.INDEXES.SEEDS;
local u7 = Color3.fromHex("#7383eb");
local u8 = Color3.fromHex("#404983");
local u9 = Color3.fromHex("#ffffff");
local u10 = Color3.fromHex("#000000");

local function renderPetViewport(p11, p12) -- Line: 108
    -- upvalues: PetAssets (copy)
    for _, child in p11:GetChildren() do
        if child:IsA("Model") or child:IsA("Camera") then
            child:Destroy();
        end;
    end;

    p11.ZIndex = 5;
    p11.BackgroundTransparency = 1;
    local v13 = PetAssets.resolvePet(p12);

    if not v13 then
        return;
    end;

    local v14 = v13:Clone();
    local v15;

    if v14:IsA("Model") then
        v15 = v14;
    else
        v15 = Instance.new("Model");
        v14.Parent = v15;
        v15.PrimaryPart = v14:IsA("BasePart") and v14 and v14 or nil;
    end;

    for _, descendant in v15:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true;
        end;
    end;

    local v16, v17 = v15:GetBoundingBox();
    v15:PivotTo(v15:GetPivot() + (Vector3.new(0, 0, 0) - v16.Position));
    v15.Parent = p11;
    local Camera = Instance.new("Camera");
    Camera.FieldOfView = 40;
    local v18 = v17.Magnitude * 1.1 + 2;
    Camera.CFrame = CFrame.lookAt(Vector3.new(v18 * 0.6, v17.Y * 0.5 + v18 * 0.4, v18 * 0.6), Vector3.new(0, 0, 0));
    Camera.Parent = p11;
    p11.CurrentCamera = Camera;
    p11.Ambient = Color3.fromRGB(200, 200, 200);
    p11.LightColor = Color3.fromRGB(255, 255, 255);
end;

local function renderFruitViewport(p19, p20) -- Line: 145
    -- upvalues: SeedConfig (copy), FruitModels (copy)
    for _, child in p19:GetChildren() do
        if child:IsA("Model") or child:IsA("Camera") then
            child:Destroy();
        end;
    end;

    p19.ZIndex = 5;
    p19.BackgroundTransparency = 1;
    local v21 = FruitModels:FindFirstChild(SeedConfig.FRUIT_MODEL_NAMES[p20] or "Acorn");

    if not v21 then
        return;
    end;

    local v22 = v21:Clone();
    local v23;

    if v22:IsA("Model") then
        v23 = v22;
    else
        v23 = Instance.new("Model");
        v22.Parent = v23;
        v23.PrimaryPart = v22:IsA("BasePart") and v22 and v22 or nil;
    end;

    for _, descendant in v23:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true;
        end;
    end;

    local v24, v25 = v23:GetBoundingBox();
    v23:PivotTo(v23:GetPivot() + (Vector3.new(0, 0, 0) - v24.Position));
    v23.Parent = p19;
    local Camera = Instance.new("Camera");
    Camera.FieldOfView = 40;
    local v26 = v25.Magnitude * 1.1 + 2;
    Camera.CFrame = CFrame.lookAt(Vector3.new(v26 * 0.6, v25.Y * 0.5 + v26 * 0.4, v26 * 0.6), Vector3.new(0, 0, 0));
    Camera.Parent = p19;
    p19.CurrentCamera = Camera;
    p19.Ambient = Color3.fromRGB(200, 200, 200);
    p19.LightColor = Color3.fromRGB(255, 255, 255);
end;

local function renderSeedViewport(p27, p28) -- Line: 182
    -- upvalues: SeedConfig (copy), Seeds (copy)
    for _, child in p27:GetChildren() do
        if child:IsA("Model") or child:IsA("Camera") then
            child:Destroy();
        end;
    end;

    p27.ZIndex = 5;
    p27.BackgroundTransparency = 1;
    local v29 = Seeds:FindFirstChild(SeedConfig.SEED_MODEL_NAMES[p28] or p28 .. "Seed");

    if not v29 then
        return;
    end;

    local v30 = v29:Clone();
    local v31;

    if v30:IsA("Model") then
        v31 = v30;
    else
        v31 = Instance.new("Model");
        v30.Parent = v31;
        v31.PrimaryPart = v30:IsA("BasePart") and v30 and v30 or nil;
    end;

    for _, descendant in v31:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true;
        end;
    end;

    local v32, v33 = v31:GetBoundingBox();
    v31:PivotTo(v31:GetPivot() + (Vector3.new(0, 0, 0) - v32.Position));
    v31.Parent = p27;
    local Camera = Instance.new("Camera");
    Camera.FieldOfView = 40;
    local v34 = v33.Magnitude * 1.1 + 2;
    Camera.CFrame = CFrame.lookAt(Vector3.new(v34 * 0.6, v33.Y * 0.5 + v34 * 0.4, v34 * 0.6), Vector3.new(0, 0, 0));
    Camera.Parent = p27;
    p27.CurrentCamera = Camera;
    p27.Ambient = Color3.fromRGB(200, 200, 200);
    p27.LightColor = Color3.fromRGB(255, 255, 255);
end;

function v1.UpdateUI(p35) -- Line: 219
    -- upvalues: UI_Manager (copy), u8 (copy), u7 (copy), SEEDS (ref), CustomEnum (copy), SeedsItemHolder (copy), FruitsItemHolder (copy), PetsItemHolder (copy), TextLabel (copy), Button2 (copy), Button3 (copy), Button4 (copy)
    if not p35.DataClient.currentData then
        return;
    end;

    local function updateButton(p36, p37) -- Line: 222
        -- upvalues: UI_Manager (ref), u8 (ref), u7 (ref)
        if p37 then
            UI_Manager:LockSideButtonOut(p36);
            p36.BackgroundColor3 = u8;
            p36.WhiteStroke.Enabled = false;

            return;
        end;

        UI_Manager:UnlockSideButtonOut(p36);
        p36.BackgroundColor3 = u7;
        p36.WhiteStroke.Enabled = true;
    end;

    if SEEDS == CustomEnum.INDEXES.SEEDS then
        SeedsItemHolder.Visible = true;
        FruitsItemHolder.Visible = false;
        PetsItemHolder.Visible = false;
        TextLabel.Text = "Seeds";
        local v38 = Button2;
        UI_Manager:LockSideButtonOut(v38);
        v38.BackgroundColor3 = u8;
        v38.WhiteStroke.Enabled = false;
        local v39 = Button3;
        UI_Manager:UnlockSideButtonOut(v39);
        v39.BackgroundColor3 = u7;
        v39.WhiteStroke.Enabled = true;
        local v40 = Button4;
        UI_Manager:UnlockSideButtonOut(v40);
        v40.BackgroundColor3 = u7;
        v40.WhiteStroke.Enabled = true;
    elseif SEEDS == CustomEnum.INDEXES.FRUIT then
        SeedsItemHolder.Visible = false;
        FruitsItemHolder.Visible = true;
        PetsItemHolder.Visible = false;
        TextLabel.Text = "Fruit";
        local v41 = Button2;
        UI_Manager:UnlockSideButtonOut(v41);
        v41.BackgroundColor3 = u7;
        v41.WhiteStroke.Enabled = true;
        local v42 = Button3;
        UI_Manager:LockSideButtonOut(v42);
        v42.BackgroundColor3 = u8;
        v42.WhiteStroke.Enabled = false;
        local v43 = Button4;
        UI_Manager:UnlockSideButtonOut(v43);
        v43.BackgroundColor3 = u7;
        v43.WhiteStroke.Enabled = true;
    elseif SEEDS == CustomEnum.INDEXES.PETS then
        SeedsItemHolder.Visible = false;
        FruitsItemHolder.Visible = false;
        PetsItemHolder.Visible = true;
        TextLabel.Text = "Pets";
        local v44 = Button2;
        UI_Manager:UnlockSideButtonOut(v44);
        v44.BackgroundColor3 = u7;
        v44.WhiteStroke.Enabled = true;
        local v45 = Button3;
        UI_Manager:UnlockSideButtonOut(v45);
        v45.BackgroundColor3 = u7;
        v45.WhiteStroke.Enabled = true;
        local v46 = Button4;
        UI_Manager:LockSideButtonOut(v46);
        v46.BackgroundColor3 = u8;
        v46.WhiteStroke.Enabled = false;
    end;

    p35:UpdateDisplayedInv();
end;

function v1.UpdateDisplayedInv(p47) -- Line: 273
    -- upvalues: SEEDS (ref), CustomEnum (copy), u6 (copy), u5 (copy), SeedsItemHolder (copy), IndexInfo (copy), FruitsItemHolder (copy), PetsItemHolder (copy), ExpandedRarities (copy), u2 (ref), u9 (copy), u10 (copy), CompletionSection (copy), AllFoundSection (copy), DiscoverXMore (copy), Fill (copy), ClaimButton (copy), RewardTitle (copy), u4 (copy), Reward2 (copy), RewardItems (copy), Images (copy), Title (copy)
    local v48 = {};
    local u49 = nil;
    local v50 = nil;
    local v51 = nil;
    local v52 = nil;
    local v53 = nil;
    local v54 = nil;

    if SEEDS == CustomEnum.INDEXES.SEEDS then
        u49 = u6.seeds;
        v50 = u5.seeds;
        v51 = SeedsItemHolder;
        v52 = p47.DataClient.currentData.Index.Seeds;
        v53 = p47.DataClient.currentData.Index.SeedsLevel;
        v54 = IndexInfo.rewardTiers.seeds;
    elseif SEEDS == CustomEnum.INDEXES.FRUIT then
        u49 = u6.fruits;
        v50 = u5.fruits;
        v51 = FruitsItemHolder;
        v52 = p47.DataClient.currentData.Index.Fruits;
        v53 = p47.DataClient.currentData.Index.FruitsLevel;
        v54 = IndexInfo.rewardTiers.fruits;
    elseif SEEDS == CustomEnum.INDEXES.PETS then
        u49 = u6.pets;
        v50 = u5.pets;
        v51 = PetsItemHolder;
        v52 = p47.DataClient.currentData.Index.Pets;
        v53 = p47.DataClient.currentData.Index.PetsLevel;
        v54 = IndexInfo.rewardTiers.pets;
    end;

    for i, v in u49 do
        v.owned = v52[i];
        table.insert(v48, i);
    end;

    table.sort(v48, function(p55, p56) -- Line: 327
        -- upvalues: u49 (ref), ExpandedRarities (ref)
        local v57 = u49[p55];
        local v58 = u49[p56];
        local rarityTier = ExpandedRarities[v57.rarity].rarityTier;
        local rarityTier2 = ExpandedRarities[v58.rarity].rarityTier;

        if rarityTier == rarityTier2 then
            return v57.displayName < v58.displayName;
        end;

        return rarityTier < rarityTier2;
    end);
    local v59 = 1;
    local v60 = 0;
    local v61 = 1;

    for _ = 1, math.ceil(#v48 / 6) do
        if not v50[v59] then
            v50[v59] = u2:Clone();
            v50[v59].Parent = v51;
        end;

        v50[v59].LayoutOrder = v59;

        for i = 1, 6 do
            if v48[v61] then
                local v62 = u49[v48[v61]];
                v62.slot.Parent = v50[v59].Inner;
                v62.slot.LayoutOrder = i;
                v62.slot.BackgroundColor3 = ExpandedRarities[v62.rarity].mainColor;

                if v62.owned then
                    v62.slot.TextLabel.Text = v62.displayName;
                    v62.slot.ViewportFrame.ImageColor3 = u9;
                    v60 = v60 + 1;
                else
                    v62.slot.TextLabel.Text = "???";
                    v62.slot.ViewportFrame.ImageColor3 = u10;
                end;

                v61 = v61 + 1;
            end;
        end;

        v59 = v59 + 1;
    end;

    while v59 <= #v50 do
        v50[v59]:Destroy();
        v50[v59] = nil;
        v59 = v59 + 1;
    end;

    local v63 = v54[v53];

    if v63 then
        CompletionSection.Visible = true;
        AllFoundSection.Visible = false;
        local goal = v63.goal;
        local v64 = goal - v60;

        if v64 >= 1 then
            DiscoverXMore.Text = "Discover " .. v64 .. " More";
            Fill.Size = UDim2.fromScale(v60 / goal, 1);
            ClaimButton.Visible = false;
            RewardTitle.Visible = true;
        else
            DiscoverXMore.Text = goal .. "/" .. goal .. " Discovered!";
            Fill.Size = UDim2.fromScale(1, 1);
            ClaimButton.Visible = true;
            RewardTitle.Visible = false;
        end;

        for _, v in u4 do
            v.Visible = false;
        end;

        for i, v in v63.rewards do
            if not u4[i] then
                u4[i] = Reward2:Clone();
                u4[i].Parent = RewardItems;
            end;

            u4[i].Visible = true;

            if v.rewardType == CustomEnum.REWARD_TYPES.CASH then
                u4[i].ImageLabel.Image = Images.CASH_STACK;
                u4[i].TextLabel.Text = "x" .. v.amt;
            elseif v.rewardType == CustomEnum.REWARD_TYPES.TICKETS then
                u4[i].ImageLabel.Image = Images.TICKET_ONE;
                u4[i].TextLabel.Text = "x" .. v.amt;
            end;
        end;
    else
        CompletionSection.Visible = false;
        AllFoundSection.Visible = true;

        if SEEDS == CustomEnum.INDEXES.SEEDS then
            Title.Text = "All Seeds Found!";
        elseif SEEDS == CustomEnum.INDEXES.FRUIT then
            Title.Text = "All Fruits Found!";
        elseif SEEDS == CustomEnum.INDEXES.PETS then
            Title.Text = "All Pets Found!";
        end;
    end;
end;

function v1.SetupSeedAndFruitCells(p65) -- Line: 445
    -- upvalues: u2 (ref), SeedsItemHolder (copy), u3 (ref), SeedConfig (copy), renderSeedViewport (copy), u6 (copy), renderFruitViewport (copy)
    u2 = SeedsItemHolder:WaitForChild("Row");
    u2.Parent = script;
    local Inner = u2:WaitForChild("Inner");
    u3 = Inner:WaitForChild("Cell");
    u3.Parent = script;

    for _, child in Inner:GetChildren() do
        if child:IsA("Frame") then
            child:Destroy();
        end;
    end;

    for i, v in SeedConfig.Seeds do
        local v66 = u3:Clone();
        v66.Parent = script;
        local v67 = SeedConfig.SeedDisplayName(i);
        v66.TextLabel.Text = v67;
        renderSeedViewport(v66.ViewportFrame, i);
        u6.seeds[i] = {
            owned = false,
            slot = v66,
            rarity = v.rarity,
            displayName = v67
        };
        local v68 = u3:Clone();
        v68.Parent = script;
        local v69 = v.fruitName or "Fruit";
        v68.TextLabel.Text = v69;
        renderFruitViewport(v68.ViewportFrame, i);
        u6.fruits[i] = {
            owned = false,
            slot = v68,
            rarity = v.rarity,
            displayName = v69
        };
    end;
end;

function v1.SetupPetCells(p70) -- Line: 496
    -- upvalues: PetConfig (copy), u3 (ref), renderPetViewport (copy), u6 (copy)
    for i, v in PetConfig.Pets do
        local v71 = u3:Clone();
        v71.Parent = script;
        v71.TextLabel.Text = i;
        renderPetViewport(v71.ViewportFrame, i);
        u6.pets[i] = {
            owned = false,
            slot = v71,
            rarity = v.rarity,
            displayName = i
        };
    end;
end;

function v1.SetupUIMetaElements(u72) -- Line: 517
    -- upvalues: UI_Manager (copy), Exit (copy), Index (copy), Button2 (copy), SEEDS (ref), CustomEnum (copy), Button3 (copy), Button4 (copy), Button (copy)
    UI_Manager:AddBounceButton(Exit, 1.1);
    Exit.Activated:Connect(function() -- Line: 519
        -- upvalues: UI_Manager (ref), Index (ref)
        UI_Manager:CloseWindow(Index, true);
    end);
    UI_Manager:AddSideBounceButton(Button2, 1.1, 1.2, false);
    Button2.Activated:Connect(function() -- Line: 524
        -- upvalues: SEEDS (ref), CustomEnum (ref), u72 (copy)
        SEEDS = CustomEnum.INDEXES.SEEDS;
        u72:UpdateUI();
    end);
    UI_Manager:AddSideBounceButton(Button3, 1.1, 1.2, false);
    Button3.Activated:Connect(function() -- Line: 531
        -- upvalues: SEEDS (ref), CustomEnum (ref), u72 (copy)
        SEEDS = CustomEnum.INDEXES.FRUIT;
        u72:UpdateUI();
    end);
    UI_Manager:AddSideBounceButton(Button4, 1.1, 1.2, false);
    Button4.Activated:Connect(function() -- Line: 538
        -- upvalues: SEEDS (ref), CustomEnum (ref), u72 (copy)
        SEEDS = CustomEnum.INDEXES.PETS;
        u72:UpdateUI();
    end);
    UI_Manager:AddBounceButton(Button, 1.1);
    Button.Activated:Connect(function() -- Line: 545
        -- upvalues: u72 (copy), SEEDS (ref)
        u72.IndexService.ClaimIndexReward:Fire(SEEDS);
    end);
end;

function v1.KnitStart(u73) -- Line: 550
    -- upvalues: Index (copy)
    u73:SetupSeedAndFruitCells();
    u73:SetupPetCells();
    u73:SetupUIMetaElements();
    u73.DataClient.EV_UPDATE:Connect(function() -- Line: 556
        -- upvalues: u73 (copy)
        u73:UpdateUI();
    end);
    Index:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 560
        -- upvalues: Index (ref), u73 (copy)
        if Index.Visible then
            u73:UpdateUI();
        end;
    end);
end;

function v1.KnitInit(p74) -- Line: 567
    -- upvalues: Knit (copy)
    p74.DataClient = Knit.GetController("DataClient");
    p74.UserInputParser = Knit.GetController("UserInputParser");
    p74.UI_Manager = Knit.GetController("UI_Manager");
    p74.SoundController = Knit.GetController("SoundController");
    p74.IndexService = Knit.GetService("IndexService");
end;

return v1;