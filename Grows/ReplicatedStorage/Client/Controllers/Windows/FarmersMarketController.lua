-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local AdService = game:GetService("AdService");
local Knit = require(ReplicatedStorage.Packages.Knit);
local Maid = require(ReplicatedStorage.Packages.Maid);
local SeedConfig = require(ReplicatedStorage.Shared.Info.SeedConfig);
local MutationText = require(ReplicatedStorage.Shared.Utility.MutationText);
local MutationRecolor = require(ReplicatedStorage.Shared.Utility.MutationRecolor);
require(ReplicatedStorage.Shared.Info.Products);
local u1 = {
    easy = "rbxassetid://87088527348949",
    medium = "rbxassetid://130086272128202",
    hard = "rbxassetid://108961923448735"
};
local u2 = Color3.fromRGB(0, 255, 0);
local u3 = Color3.fromRGB(94, 56, 40);
local u4 = Color3.fromRGB(255, 204, 0);

local function colorTag(p5, p6) -- Line: 28
    return string.format("<font color=\"rgb(%d,%d,%d)\">%s</font>", math.floor(p6.R * 255), math.floor(p6.G * 255), math.floor(p6.B * 255), p5);
end;

local function fruitLabelText(p7, p8) -- Line: 34
    -- upvalues: u2 (copy), u4 (copy)
    local fruitName = p7.fruitName;
    local v9 = p8 and u2 or Color3.new(1, 1, 1);
    local v10 = string.format("<font color=\"rgb(%d,%d,%d)\">%s</font>", math.floor(v9.R * 255), math.floor(v9.G * 255), math.floor(v9.B * 255), fruitName);

    if p7.sizeText then
        local sizeText = p7.sizeText;
        local v11 = u4;
        v10 = v10 .. " " .. string.format("<font color=\"rgb(%d,%d,%d)\">%s</font>", math.floor(v11.R * 255), math.floor(v11.G * 255), math.floor(v11.B * 255), sizeText);
    end;

    return v10;
end;

local u12 = Color3.fromRGB(0, 255, 0);
local u13 = Color3.fromRGB(140, 140, 140);
local u14 = Color3.fromRGB(255, 45, 45);
local u15 = Color3.fromRGB(255, 0, 0);
local v16 = Knit.CreateController({
    Name = "FarmersMarketController"
});

local function formatTimer(p17) -- Line: 46
    local v18 = math.floor(p17);
    local v19 = math.max(0, v18);
    local v20 = math.floor(v19 / 3600);
    local v21 = math.floor(v19 % 3600 / 60);
    local v22 = v19 % 60;

    if v20 > 0 then
        return string.format("%dh %dm %ds", v20, v21, v22);
    end;

    return string.format("%dm %ds", v21, v22);
end;

function v16.KnitStart(u23) -- Line: 55
    -- upvalues: Players (copy), Knit (copy), ReplicatedStorage (copy), SeedConfig (copy), MutationRecolor (copy), u2 (copy), u3 (copy), u4 (copy), u12 (copy), u14 (copy), u13 (copy), u1 (copy), MutationText (copy), u15 (copy), AdService (copy), Maid (copy), RunService (copy), formatTimer (copy)
    local LocalPlayer = Players.LocalPlayer;
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
    local u24 = Knit.GetService("FarmersMarketService");
    local u25 = Knit.GetService("PurchaseManager");
    local UI_Manager = u23.UI_Manager;
    local DataClient = u23.DataClient;
    local SoundController = u23.SoundController;
    local NotificationController = u23.NotificationController;
    local FruitModels = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Greedy"):WaitForChild("FruitModels");
    local FarmersMarket = PlayerGui:WaitForChild("Windows"):WaitForChild("FarmersMarket");
    local Timer = FarmersMarket.Top:WaitForChild("Timer");
    local Exit = FarmersMarket.Top:WaitForChild("Exit");
    local ItemHolder = FarmersMarket.Content:WaitForChild("ScrollingFrame"):WaitForChild("ItemHolder");
    local u26 = ItemHolder:WaitForChild("Row"):Clone();

    for _, child in ItemHolder:GetChildren() do
        if child.Name == "Row" then
            child:Destroy();
        end;
    end;

    local u27 = false;
    local u28 = nil;
    local u29 = nil;
    local u30 = {};

    local function renderFruitViewport(p31, p32, p33) -- Line: 89
        -- upvalues: SeedConfig (ref), FruitModels (copy), MutationRecolor (ref)
        for _, child in p31:GetChildren() do
            if child:IsA("Model") or child:IsA("Camera") then
                child:Destroy();
            end;
        end;

        local ImageLabel = p31.Parent:FindFirstChild("ImageLabel");

        if ImageLabel then
            ImageLabel.Visible = false;
        end;

        p31.ZIndex = 5;
        p31.BackgroundTransparency = 1;
        local v34 = FruitModels:FindFirstChild(SeedConfig.FRUIT_MODEL_NAMES[p32] or "Acorn");

        if not v34 then
            return;
        end;

        local v35 = v34:Clone();
        local v36;

        if v35:IsA("Model") then
            v36 = v35;
        else
            v36 = Instance.new("Model");
            v35.Parent = v36;
            v36.PrimaryPart = v35:IsA("BasePart") and v35 and v35 or nil;
        end;

        for _, descendant in v36:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Anchored = true;
            end;
        end;

        if p33 then
            MutationRecolor.applyGoldenFruit(v36, { p33 });
        end;

        local v37, v38 = v36:GetBoundingBox();
        v36:PivotTo(v36:GetPivot() + (Vector3.new(0, 0, 0) - v37.Position));
        v36.Parent = p31;
        local Camera = Instance.new("Camera");
        Camera.FieldOfView = 40;
        local v39 = v38.Magnitude * 1.1 + 2;
        Camera.CFrame = CFrame.lookAt(Vector3.new(v39 * 0.6, v38.Y * 0.5 + v39 * 0.4, v39 * 0.6), Vector3.new(0, 0, 0));
        Camera.Parent = p31;
        p31.CurrentCamera = Camera;
        p31.Ambient = Color3.fromRGB(200, 200, 200);
        p31.LightColor = Color3.fromRGB(255, 255, 255);
    end;

    local function hasFruit(p40) -- Line: 133
        -- upvalues: DataClient (copy)
        local currentData = DataClient.currentData;

        if not (currentData and currentData.Inventory) then
            return false;
        end;

        for _, v in { "Hotbar", "Storage" } do
            for _, v2 in currentData.Inventory[v] or {} do
                if v2.itemType == "Fruit" and (v2.seedType == p40.seedType and ((v2.multiplier or 0) >= p40.size and (not p40.mutation or v2.mutations and table.find(v2.mutations, p40.mutation) ~= nil))) then
                    return true;
                end;
            end;
        end;

        return false;
    end;

    local function rowComplete(p41) -- Line: 148
        for _, v in p41.cells do
            if not v.given then
                return false;
            end;
        end;

        return true;
    end;

    local function refreshStates() -- Line: 160
        -- upvalues: u28 (ref), u30 (ref), u2 (ref), u3 (ref), u4 (ref), hasFruit (copy), u12 (ref), u14 (ref)
        if not u28 then
            return;
        end;

        for i, v in u30 do
            local v42 = u28.rows[i];

            if v42 then
                for i2, v2 in v42.cells do
                    local v43 = v.cells[i2];

                    if v43 then
                        local v44 = v.claimed or v43.given;
                        v43.frame.BackgroundColor3 = v44 and u2 or u3;
                        local Fruit = v43.frame.Fruit;
                        local fruitName = v43.fruitName;
                        local v45 = v44 and u2 or Color3.new(1, 1, 1);
                        local v46 = string.format("<font color=\"rgb(%d,%d,%d)\">%s</font>", math.floor(v45.R * 255), math.floor(v45.G * 255), math.floor(v45.B * 255), fruitName);

                        if v43.sizeText then
                            local sizeText = v43.sizeText;
                            local v47 = u4;
                            v46 = v46 .. " " .. string.format("<font color=\"rgb(%d,%d,%d)\">%s</font>", math.floor(v47.R * 255), math.floor(v47.G * 255), math.floor(v47.B * 255), sizeText);
                        end;

                        Fruit.Text = v46;
                        local Parent = v43.giveButton.Parent;
                        local v48 = not v44 and hasFruit(v2);
                        Parent.Visible = v48;
                    end;
                end;

                if not v.claimed then
                    local v49 = true;

                    for _, v2 in v.cells do
                        if not v2.given then
                            v49 = false;
                            break;
                        end;
                    end;

                    v.claimButton.BackgroundColor3 = v49 and u12 or u14;
                end;
            end;
        end;
    end;

    local function setClaimed(p50) -- Line: 179
        -- upvalues: u13 (ref)
        p50.claimed = true;
        p50.claimButton.BackgroundColor3 = u13;
        p50.claimText.Text = "CLAIMED";
    end;

    local function populate(p51) -- Line: 185
        -- upvalues: u28 (ref), u30 (ref), ItemHolder (copy), UI_Manager (copy), u26 (copy), u1 (ref), MutationText (ref), renderFruitViewport (copy), u24 (copy), refreshStates (copy), SoundController (copy), LocalPlayer (copy), u13 (ref), NotificationController (copy), u15 (ref)
        u28 = p51;
        u30 = {};

        for _, child in ItemHolder:GetChildren() do
            if child:IsA("Frame") and child.Name == "RowInstance" then
                local Reward = child:FindFirstChild("Reward");

                if Reward then
                    local ImageLabel = Reward:FindFirstChild("ImageLabel");
                    local v52 = ImageLabel and ImageLabel:GetAttribute("EmitterIndex");

                    if v52 then
                        UI_Manager:RemoveEmitter(v52);
                    end;
                end;

                child:Destroy();
            end;
        end;

        for i, v in p51.rows do
            local v53 = u26:Clone();
            v53.Name = "RowInstance";
            v53.LayoutOrder = i;
            local Reward = v53.Reward;
            Reward.TextLabel.Text = string.format("%d Tickets", v.reward);
            local ImageLabel = Reward:FindFirstChild("ImageLabel");

            if ImageLabel then
                ImageLabel.Image = u1[v.difficulty] or "rbxassetid://87088527348949";
                ImageLabel.Visible = true;
                ImageLabel:SetAttribute("EmitterIndex", (UI_Manager:AddEmitterTemplate(ImageLabel, UDim2.new(0.5, 0, 0.5, 0), UI_Manager.PARTICLE_TEMPLATES.SPARKLE, {
                    zIndex = 4,
                    em_delay = 0.8 + i * 0.05
                })));
            end;

            local TicketOLD = Reward:FindFirstChild("TicketOLD");

            if TicketOLD then
                TicketOLD.Visible = false;
            end;

            local Button = Reward.ClaimButton.Button;
            local Identifier = Button:FindFirstChild("Identifier");
            local v54 = {};

            for _, child in v53.FruitsFrame.FruitReq:GetChildren() do
                if child:IsA("Frame") and child.Name == "Cell" then
                    table.insert(v54, child);
                end;
            end;

            for i2, v2 in v54 do
                v2.LayoutOrder = i2;
            end;

            local u55 = {
                claimed = false,
                frame = v53,
                claimButton = Button,
                claimText = Identifier,
                cells = {}
            };
            u30[i] = u55;

            for i2, v2 in v.cells do
                local v56 = v54[i2];

                if v56 then
                    v56.Mutation.RichText = true;
                    v56.Mutation.Visible = v2.mutation ~= nil;
                    v56.Mutation.Text = v2.mutation and (MutationText.coloredName(v2.mutation) or "") or "";
                    local Amount = v56:FindFirstChild("Amount");

                    if Amount then
                        Amount.Visible = false;
                    end;

                    renderFruitViewport(v56.ViewportFrame, v2.seedType, v2.mutation);
                    v56.Fruit.RichText = true;
                    v56.Fruit.ZIndex = 6;
                    v56.Mutation.ZIndex = 6;
                    v56.GiveButton.ZIndex = 6;

                    for _, descendant in v56.GiveButton:GetDescendants() do
                        if descendant:IsA("GuiObject") then
                            descendant.ZIndex = 7;
                        end;
                    end;

                    local Button2 = v56.GiveButton.Button;
                    local u57 = {
                        frame = v56,
                        giveButton = Button2,
                        given = v2.given == true,
                        fruitName = v2.fruitName
                    };
                    local v58;

                    if v.kind == "huge" then
                        v58 = string.format("%.1fx", v2.size) or nil;
                    else
                        v58 = nil;
                    end;

                    u57.sizeText = v58;
                    u55.cells[i2] = u57;
                    UI_Manager:AddBounceButton(Button2, 1.05, false);
                    Button2.Activated:Connect(function() -- Line: 276
                        -- upvalues: u55 (copy), u57 (copy), u24 (ref), i (copy), i2 (copy), refreshStates (ref), SoundController (ref), LocalPlayer (ref)
                        if u55.claimed or u57.given then
                            return;
                        end;

                        local v59, v60 = u24:GiveFruit(i, i2):await();

                        if v59 and v60 then
                            u57.given = true;
                            refreshStates();
                            SoundController:PlaySound("MarketGive", LocalPlayer);
                        end;
                    end);
                end;
            end;

            if p51.claimed[i] then
                u55.claimed = true;
                u55.claimButton.BackgroundColor3 = u13;
                u55.claimText.Text = "CLAIMED";
            end;

            UI_Manager:AddBounceButton(Button, 1.05, false);
            Button.Activated:Connect(function() -- Line: 292
                -- upvalues: u55 (copy), NotificationController (ref), u15 (ref), u24 (ref), i (copy), u13 (ref), refreshStates (ref), SoundController (ref), LocalPlayer (ref)
                if u55.claimed then
                    return;
                end;

                local v61 = true;

                for _, v2 in u55.cells do
                    if not v2.given then
                        v61 = false;
                        break;
                    end;
                end;

                if not v61 then
                    NotificationController:SendNotification("Missing fruits!", 3, u15);

                    return;
                end;

                local v62, v63 = u24:ClaimRow(i):await();

                if v62 and v63 then
                    local v64 = u55;
                    v64.claimed = true;
                    v64.claimButton.BackgroundColor3 = u13;
                    v64.claimText.Text = "CLAIMED";
                    refreshStates();
                    SoundController:PlaySound("ShopBuy", LocalPlayer);
                end;
            end);
            v53.Parent = ItemHolder;
        end;

        refreshStates();
    end;

    local function open() -- Line: 316
        -- upvalues: u24 (copy), populate (copy), u27 (ref), UI_Manager (copy), FarmersMarket (copy), u29 (ref)
        local v65, v66 = u24:GetOffers():await();

        if not (v65 and v66) then
            return;
        end;

        populate(v66);
        u27 = true;
        UI_Manager:OpenWindow(FarmersMarket, true);

        if u29 and u29.Enabled then
            u29.Enabled = false;
            u24:MarkOpened();
        end;
    end;

    UI_Manager:AddBounceButton(Exit, 1.05, true);
    Exit.Activated:Connect(function() -- Line: 330
        -- upvalues: u27 (ref), UI_Manager (copy), FarmersMarket (copy)
        u27 = false;
        UI_Manager:CloseWindow(FarmersMarket, true);
    end);
    local Button = FarmersMarket.Top:WaitForChild("AdSkipButton"):WaitForChild("Button");
    local Button2 = FarmersMarket.Top:WaitForChild("RobuxSkipButton"):WaitForChild("Button");

    local function checkForAds() -- Line: 349
        -- upvalues: AdService (ref), Button (copy), Button2 (copy)
        local success, result = pcall(function() -- Line: 350
            -- upvalues: AdService (ref)
            return AdService:GetAdAvailabilityNowAsync(Enum.AdFormat.RewardedVideo);
        end);

        if success and result.AdAvailabilityResult == Enum.AdAvailabilityResult.IsAvailable then
            Button.Visible = true;
            Button2.Visible = false;

            return;
        end;

        warn("INELIGIBLE FOR ADS", result.AdAvailabilityResult);
        Button.Visible = false;
        Button2.Visible = true;
    end;

    u23.PurchaseManager.RewardedAdFeedback:Connect(function(p67, p68) -- Line: 368
        -- upvalues: checkForAds (copy)
        if p68 == Enum.ShowAdResult.ShowCompleted then
            checkForAds();
        end;
    end);
    FarmersMarket:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 374
        -- upvalues: FarmersMarket (copy), checkForAds (copy)
        if FarmersMarket.Visible then
            checkForAds();
        end;
    end);
    UI_Manager:AddBounceButton(Button, 1.05, false);
    Button.Activated:Connect(function() -- Line: 381
        -- upvalues: u23 (copy)
        u23.PurchaseManager.RequestRewardedAd:Fire("SkipMarketTimer");
    end);
    UI_Manager:AddBounceButton(Button2, 1.05, false);
    Button2.Activated:Connect(function() -- Line: 386
        -- upvalues: u25 (copy)
        u25.PromptProductPurchase:Fire("SkipMarketTimer");
    end);
    u24.OffersSkipped:Connect(function(p69) -- Line: 390
        -- upvalues: u27 (ref), populate (copy)
        if u27 and p69 then
            populate(p69);
        end;
    end);
    u23._maid = Maid.new();
    u23._maid:GiveTask(DataClient.EV_UPDATE:Connect(function() -- Line: 396
        -- upvalues: u27 (ref), refreshStates (copy)
        if u27 then
            refreshStates();
        end;
    end));
    u23._maid:GiveTask(RunService.Heartbeat:Connect(function() -- Line: 400
        -- upvalues: u27 (ref), u28 (ref), Timer (copy), formatTimer (ref), open (copy)
        if not (u27 and u28) then
            return;
        end;

        local v70 = u28.expiresAt - os.time();
        Timer.Text = "New offers in " .. formatTimer(v70);

        if v70 <= 0 then
            open();
        end;
    end));
    u23.OpenMarket = open;
    task.spawn(function() -- Line: 417
        -- upvalues: u29 (ref), DataClient (copy), u23 (copy), open (copy)
        local PromptHolder = workspace:WaitForChild("BigField"):WaitForChild("MarketStand"):WaitForChild("PromptHolder");
        local ProximityPrompt = PromptHolder:WaitForChild("ProximityPrompt");
        local RebirthReq = PromptHolder:WaitForChild("RebirthReq");
        u29 = PromptHolder:WaitForChild("Alert");

        local function refreshStand() -- Line: 424
            -- upvalues: DataClient (ref), RebirthReq (copy), ProximityPrompt (copy), u29 (ref)
            local currentData = DataClient.currentData;
            local v71 = (currentData and (currentData.Rebirth or 0) or 0) >= 2;
            RebirthReq.Enabled = not v71;
            ProximityPrompt.Enabled = v71;

            if v71 then
                if currentData then
                    currentData = currentData.OpenedFarmersMarket == true;
                end;

                v71 = not currentData;
            end;

            u29.Enabled = v71;
        end;

        local currentData = DataClient.currentData;
        local v72 = (currentData and (currentData.Rebirth or 0) or 0) >= 2;
        RebirthReq.Enabled = not v72;
        ProximityPrompt.Enabled = v72;

        if v72 then
            if currentData then
                currentData = currentData.OpenedFarmersMarket == true;
            end;

            v72 = not currentData;
        end;

        u29.Enabled = v72;
        u23._maid:GiveTask(DataClient.EV_UPDATE:Connect(refreshStand));
        ProximityPrompt.Triggered:Connect(function() -- Line: 434
            -- upvalues: DataClient (ref), open (ref)
            if (DataClient.currentData and DataClient.currentData.Rebirth or 0) >= 2 then
                open();
            end;
        end);
    end);
end;

function v16.KnitInit(p73) -- Line: 440
    -- upvalues: Knit (copy)
    p73.UI_Manager = Knit.GetController("UI_Manager");
    p73.DataClient = Knit.GetController("DataClient");
    p73.SoundController = Knit.GetController("SoundController");
    p73.NotificationController = Knit.GetController("NotificationController");
    p73.FarmersMarketService = Knit.GetService("FarmersMarketService");
    p73.PurchaseManager = Knit.GetService("PurchaseManager");
end;

return v16;