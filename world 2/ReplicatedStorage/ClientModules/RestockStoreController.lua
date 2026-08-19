-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local NumberUtils = require(ReplicatedStorage.SharedModules.NumberUtils);
local Worlds = require(game.ReplicatedStorage.SharedModules.Worlds);
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local PlayerStateClient = require(ReplicatedStorage.ClientModules.PlayerStateClient);
local DevProductController = require(LocalPlayer.PlayerScripts.Controllers.DevProductController);
local SfxController = require(LocalPlayer.PlayerScripts.Controllers.SfxController);
local NotificationController = require(LocalPlayer.PlayerScripts.Controllers.NotificationController);
local Gradients = ReplicatedStorage.SharedModules.RarityData.Gradients;
local GuiController = require(game.Players.LocalPlayer.PlayerScripts.Controllers.GuiController);
local GreenbeanAvatarController = require(game.Players.LocalPlayer.PlayerScripts.Controllers.GreenbeanAvatarController);
local GreenbeanCheck = require(ReplicatedStorage.SharedData.GreenbeanCheck);
local WatchButtonHold = require(ReplicatedStorage.ClientModules.WatchButtonHold);
local AnimatedTextGradient = require(ReplicatedStorage.ClientModules.AnimatedTextGradient);
local CrateName = PlayerGui:WaitForChild("Odds"):WaitForChild("Frame"):WaitForChild("CrateName");
local PlayerSelector = PlayerGui:WaitForChild("PlayerSelector");
local FX_UI = PlayerGui:WaitForChild("FX_UI");
local u1 = PlayerStateClient:WaitForLocalReplica(30);
local u2 = Color3.new(0.0784314, 0.188235, 0);
local u3 = Color3.new(0.188235, 0, 0);
local u4 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u5 = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0);
local u6 = {
    Interval = 1,
    Colors = { Color3.fromRGB(227, 40, 40), Color3.fromRGB(255, 255, 255), Color3.fromRGB(43, 87, 224) }
};
local u7 = {
    ["1Button"] = 1,
    ["3Button"] = 3,
    ["10Button"] = 10,
    GiftButton1 = 1,
    GiftButton3 = 3,
    GiftButton10 = 10
};

local function recipientOwnsGamepass(p8, p9) -- Line: 67
    -- upvalues: Players (copy)
    local v10 = p9:match("^Gamepass:([^:]+)");

    if not v10 then
        return false;
    end;

    local v11 = p8.Player or Players:GetPlayerByUserId(p8.UserId);

    if not v11 then
        return false;
    end;

    local v12 = v11:GetAttribute("OwnedGamepasses");

    if type(v12) ~= "string" or v12 == "" then
        return false;
    end;

    for i in v12:gmatch("[^,]+") do
        if i == v10 then
            return true;
        end;
    end;

    return false;
end;

local function handleGiftButton(u13) -- Line: 80
    -- upvalues: PlayerSelector (copy), recipientOwnsGamepass (copy), ReplicatedStorage (copy), Networking (copy), DevProductController (copy)
    local u14 = nil;
    task.spawn(function() -- Line: 82
        -- upvalues: PlayerSelector (ref), u14 (ref)
        local v15 = PlayerSelector.PlayerSelected.Event:Wait();

        if v15 == nil then
            u14 = "cancelled";

            return;
        end;

        u14 = v15;
    end);
    PlayerSelector.Enabled = true;

    repeat
        task.wait();
    until u14 ~= nil;

    if u14 == "cancelled" then
        return;
    end;

    if recipientOwnsGamepass(u14, u13) then
        ReplicatedStorage:FindFirstChild("Notify"):Fire((`<font color="#5B9CF5">@{u14.Name}</font> already owns this gamepass!`));

        return;
    end;

    local success, result = pcall(function() -- Line: 105
        -- upvalues: Networking (ref), u14 (ref)
        Networking.DevProducts.SetGiftTarget:Fire(u14.UserId);
    end);

    if not success then
        warn((`[RestockStoreController] SetGiftTarget fire failed ({u13}): {result}`));
    end;

    local success2, result2 = pcall(function() -- Line: 111
        -- upvalues: DevProductController (ref), u13 (copy)
        DevProductController:PromptPurchase((`{u13}:Gift`));
    end);

    if not success2 then
        warn((`[RestockStoreController] Gift purchase prompt failed ({u13}): {result2}`));
    end;
end;

local function FormatCountdown(p16) -- Line: 119
    local v17 = math.floor(p16);
    local v18 = math.max(0, v17);
    local v19 = v18 // 86400;
    local v20 = v18 % 86400 // 3600;
    local v21 = v18 % 3600 // 60;
    local v22 = v18 % 60;

    if v19 >= 1 then
        return string.format("%02d:%02d:%02d:%02d", v19, v20, v21, v22);
    end;

    return string.format("%02d:%02d:%02d", v20, v21, v22);
end;

local function SetStockAppearance(p23, p24) -- Line: 133
    -- upvalues: u2 (copy), u3 (copy)
    for _, child in p23:GetChildren() do
        if child:IsA("UIGradient") or child:IsA("UIStroke") then
            if child.Name == "NoStock" then
                child.Enabled = not p24;
            elseif child:IsA("UIStroke") then
                child.Enabled = true;
                local v25;

                if p24 then
                    v25 = u2;
                else
                    v25 = u3;
                end;

                child.Color = v25;
            else
                child.Enabled = p24;
            end;
        end;
    end;
end;

local function PLAYEFFECT(p26) -- Line: 148
    -- upvalues: FX_UI (copy), TweenService (copy), u5 (copy)
    local Frame = Instance.new("Frame");
    Frame.Parent = FX_UI;
    Frame.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.Size = UDim2.new(0, p26.AbsoluteSize.X, 0, p26.AbsoluteSize.Y * 1.5);
    Frame.Position = UDim2.new(0, p26.AbsolutePosition.X + p26.AbsoluteSize.X / 2, 0, p26.AbsolutePosition.Y + p26.AbsoluteSize.Y / 2);
    local v27 = TweenService:Create(Frame, u5, {
        BackgroundTransparency = 1,
        Size = Frame.Size + UDim2.new(0.1, 0, 0, 0)
    });
    v27:Play();
    game.Debris:AddItem(Frame, u5.Time);
    game.Debris:AddItem(v27, u5.Time);
end;

return {
    Init = function(u28) -- Line: 163, Name: Init
        -- upvalues: Worlds (copy), u1 (copy), u7 (copy), DevProductController (copy), NumberUtils (copy), SetStockAppearance (copy), GuiController (copy), CrateName (copy), Gradients (copy), LocalPlayer (copy), AnimatedTextGradient (copy), u6 (copy), TweenService (copy), u4 (copy), NotificationController (copy), GreenbeanCheck (copy), GreenbeanAvatarController (copy), PLAYEFFECT (copy), SfxController (copy), WatchButtonHold (copy), handleGiftButton (copy), RunService (copy), FormatCountdown (copy)
        local scrollingFrame = u28.scrollingFrame;
        local ItemTemplate = scrollingFrame:WaitForChild("ItemTemplate");
        ItemTemplate.Visible = false;
        local Sheckles_Shelf = scrollingFrame:WaitForChild("Sheckles_Shelf");
        local Robux_Shelf = scrollingFrame:WaitForChild("Robux_Shelf");
        local BuyButton = Sheckles_Shelf.Main_Frame.Buttons.BuyButton;
        local ToggleRobux = Sheckles_Shelf.Main_Frame.Buttons.ToggleRobux;
        local ToggleSheckles = Robux_Shelf.Main_Frame.Buttons.ToggleSheckles;
        local Buttons = Robux_Shelf.Main_Frame.Buttons;
        local Text = ToggleSheckles:FindFirstChild("Text");

        if Text then
            Text = Text:FindFirstChild("TextLabel");
        end;

        if Text and Text:IsA("TextLabel") then
            Text.Text = Worlds.Current.CurrencySuffix;
            local TextLabel = Text:FindFirstChild("TextLabel");

            if TextLabel and TextLabel:IsA("TextLabel") then
                TextLabel.Text = Worlds.Current.CurrencySuffix;
            end;
        end;

        local u29 = {};
        local u30 = {};
        local v31 = {};
        local u32 = {};
        local u33 = nil;

        local function ResolveCost(p34, p35) -- Line: 202
            -- upvalues: u28 (copy)
            if u28.priceOverrides then
                local v36 = u28.priceOverrides:Get()[p34];

                if type(v36) == "number" and v36 >= 0 then
                    return v36;
                end;
            end;

            return p35;
        end;

        local function CanAfford(p37) -- Line: 212
            -- upvalues: u30 (copy), u1 (ref)
            local v38 = u30[p37];

            if not v38 then
                return false;
            end;

            if u1 then
                return (u1.Data.Sheckles or 0) >= v38.price;
            end;

            return false;
        end;

        local function ShowShecklesShelf() -- Line: 219
            -- upvalues: Sheckles_Shelf (copy), Robux_Shelf (copy)
            Sheckles_Shelf.Visible = true;
            Robux_Shelf.Visible = false;
        end;

        local function ShowRobuxShelf() -- Line: 224
            -- upvalues: Sheckles_Shelf (copy), Robux_Shelf (copy), u33 (ref), u30 (copy), u7 (ref), Buttons (copy), DevProductController (ref), u28 (copy), NumberUtils (ref)
            Sheckles_Shelf.Visible = false;
            Robux_Shelf.Visible = true;
            local v39;

            if u33 then
                v39 = u30[u33.Name];

                if v39 then
                    v39 = v39.isEquippable;
                end;
            else
                v39 = false;
            end;

            for i, _ in pairs(u7) do
                local v40 = Buttons:FindFirstChild(i);

                if v40 then
                    if i == "1Button" then
                        v40.Visible = true;

                        if v39 and u33 then
                            local v41 = DevProductController:WaitForPreloadedProductInfo((`{u28.devProductPrefix}:{u33.Name}:1`));

                            if v41 then
                                v40.TextDisplay.TextLabel.Text = `{NumberUtils.FormatWithCommas(v41.PriceInRobux)}`;
                                v40.TextDisplay.TextLabel.TextLabel.Text = v40.TextDisplay.TextLabel.Text;
                            end;
                        else
                            v40.TextDisplay.TextLabel.Text = "x1";
                            v40.TextDisplay.TextLabel.TextLabel.Text = "x1";
                        end;
                    else
                        v40.Visible = not v39;
                    end;
                end;
            end;
        end;

        local function UpdateShelf(p42) -- Line: 257
            -- upvalues: u30 (copy), u28 (copy), BuyButton (copy), u1 (ref), SetStockAppearance (ref), ToggleRobux (copy)
            local Cost_Text = p42:FindFirstChild("Cost_Text");

            if not Cost_Text then
                return;
            end;

            local Text2 = Cost_Text.Text;
            local Name = p42.Parent.Name;
            local v43 = u30[Name];

            if not (v43 and v43.isEquippable) then
                local v44 = Text2 ~= "NO STOCK";

                if v43 then
                    v43 = v43.devProductKey ~= nil;
                end;

                if v44 then
                    local v45 = u30[Name];

                    if v45 and u1 then
                        v44 = (u1.Data.Sheckles or 0) >= v45.price;
                    else
                        v44 = false;
                    end;
                end;

                BuyButton.TextDisplay.TextLabel.Text = Text2;
                BuyButton.TextDisplay.TextLabel.TextLabel.Text = Text2;
                SetStockAppearance(BuyButton, v44);
                SetStockAppearance(BuyButton.TextDisplay.TextLabel.TextLabel, v44);
                local ImageLabel = BuyButton.TextDisplay:FindFirstChild("ImageLabel");

                if ImageLabel then
                    ImageLabel.Visible = true;
                end;

                ToggleRobux.Visible = v43;

                return;
            end;

            local v46 = u28.ownsEquippableGear and u28.ownsEquippableGear(Name);
            local v47 = u28.isGearEquipped and u28.isGearEquipped(Name);
            local ImageLabel = BuyButton.TextDisplay:FindFirstChild("ImageLabel");

            if v46 then
                local v48 = v47 and "Unequip" or "Equip";
                BuyButton.TextDisplay.TextLabel.Text = v48;
                BuyButton.TextDisplay.TextLabel.TextLabel.Text = v48;
                SetStockAppearance(BuyButton, not v47);
                SetStockAppearance(BuyButton.TextDisplay.TextLabel.TextLabel, not v47);

                if ImageLabel then
                    ImageLabel.Visible = false;
                end;

                ToggleRobux.Visible = false;

                return;
            end;

            BuyButton.TextDisplay.TextLabel.Text = v43.costText;
            BuyButton.TextDisplay.TextLabel.TextLabel.Text = v43.costText;
            local v49 = u30[Name];
            local v50;

            if v49 and u1 then
                v50 = (u1.Data.Sheckles or 0) >= v49.price;
            else
                v50 = false;
            end;

            SetStockAppearance(BuyButton, v50);
            SetStockAppearance(BuyButton.TextDisplay.TextLabel.TextLabel, v50);

            if ImageLabel then
                ImageLabel.Visible = true;
            end;

            ToggleRobux.Visible = v43.devProductKey ~= nil;
        end;

        local function GetRemainingStock(p51) -- Line: 309
            -- upvalues: u30 (copy), u1 (ref), u28 (copy), u29 (copy)
            local v52 = u30[p51];

            return not v52 and 0 or math.max((u29[p51] ~= nil and u29[p51] or v52.maxStock) - (u1 and (u1.Data.PurchasedThisRestock and u1.Data.PurchasedThisRestock[u28.purchasedRestockKey]) and (u1.Data.PurchasedThisRestock[u28.purchasedRestockKey][p51] or 0) or 0), 0);
        end;

        local function RefreshStock(p53) -- Line: 320
            -- upvalues: u30 (copy), u28 (copy), SetStockAppearance (ref), u1 (ref), u33 (ref), UpdateShelf (copy), u29 (copy)
            local v54 = u30[p53];

            if not v54 then
                return;
            end;

            local mainFrame = v54.mainFrame;

            if not (mainFrame and (mainFrame:FindFirstChild("Cost_Text") and mainFrame:FindFirstChild("Stock_Text"))) then
                return;
            end;

            if v54.isEquippable then
                local v55 = u28.ownsEquippableGear and u28.ownsEquippableGear(p53);
                local v56 = u28.isGearEquipped and u28.isGearEquipped(p53);

                if v55 then
                    v54.mainFrame.Cost_Text.Text = "OWNED";
                    v54.mainFrame.Cost_Text.TextLabel.Text = "OWNED";
                    local NoStock = v54.mainFrame.Cost_Text.TextLabel:FindFirstChild("NoStock");
                    local v57 = v54.mainFrame.Cost_Text.TextLabel:FindFirstChildWhichIsA("UIGradient");

                    if NoStock then
                        NoStock.Enabled = not v56;
                    end;

                    if v57 then
                        v57.Enabled = v56;
                    end;

                    v54.mainFrame.Stock_Text.Text = v56 and "Equipped" or "Unequipped";
                    local Stock_Text = v54.mainFrame.Stock_Text;
                    local v58;

                    if v56 then
                        v58 = Color3.new(0, 0.7, 0);
                    else
                        v58 = Color3.new(0.7, 0, 0);
                    end;

                    Stock_Text.TextColor3 = v58;
                else
                    v54.mainFrame.Cost_Text.Text = v54.costText;
                    v54.mainFrame.Cost_Text.TextLabel.Text = v54.costText;
                    v54.mainFrame.Stock_Text.Text = "Not Owned";
                    local v59 = u30[p53];
                    local v60;

                    if v59 and u1 then
                        v60 = (u1.Data.Sheckles or 0) >= v59.price;
                    else
                        v60 = false;
                    end;

                    SetStockAppearance(v54.mainFrame.Cost_Text.TextLabel, v60);
                end;

                if u33 and u33.Name == p53 then
                    UpdateShelf(v54.mainFrame);
                end;

                return;
            end;

            local v61 = u30[p53];
            local v62 = not v61 and 0 or math.max((u29[p53] ~= nil and u29[p53] or v61.maxStock) - (u1 and (u1.Data.PurchasedThisRestock and u1.Data.PurchasedThisRestock[u28.purchasedRestockKey]) and (u1.Data.PurchasedThisRestock[u28.purchasedRestockKey][p53] or 0) or 0), 0);
            local v63 = v62 >= 1;
            v54.mainFrame.Cost_Text.Text = not v63 and "NO STOCK" or v54.costText;
            v54.mainFrame.Cost_Text.TextLabel.Text = not v63 and "NO STOCK" or v54.costText;
            v54.mainFrame.Stock_Text.Text = "x" .. tostring(v62) .. " in Stock";
            SetStockAppearance(v54.mainFrame.Cost_Text.TextLabel, v63);

            if u33 and u33.Name == p53 then
                UpdateShelf(v54.mainFrame);
            end;
        end;

        local u64 = {};

        local function QueueRefresh(u65) -- Line: 377
            -- upvalues: u64 (copy), RefreshStock (copy)
            if u64[u65] then
                return;
            end;

            u64[u65] = true;
            task.defer(function() -- Line: 380
                -- upvalues: u64 (ref), u65 (copy), RefreshStock (ref)
                u64[u65] = nil;
                RefreshStock(u65);
            end);
        end;

        local u66 = false;

        for i, v in ipairs(u28.items) do
            local u67 = u28.getItemName(v);
            local v68;

            if u28.getDisplayName then
                v68 = u28.getDisplayName(v);
            else
                v68 = u67;
            end;

            local v69 = u28.getItemImage(v);
            local v70 = u28.getItemCost(v);
            local v71;

            if u28.priceOverrides then
                v71 = u28.priceOverrides:Get()[u67];

                if type(v71) ~= "number" or v71 < 0 then
                    v71 = v70;
                end;
            else
                v71 = v70;
            end;

            local v72;

            if u28.getItemRarity then
                v72 = u28.getItemRarity(v);
            else
                v72 = nil;
            end;

            if not u28.requireRarity or v72 ~= nil then
                local v73 = not u28.isItemEnabled and true or u28.isItemEnabled(v) == true;
                local v74 = ItemTemplate:Clone();
                v74.Name = u67;
                v74.LayoutOrder = i * 3;
                v74.Visible = v73;
                v74.Parent = scrollingFrame;
                local Odds = v74.Main_Frame:FindFirstChild("Odds");

                if Odds then
                    Odds.ImageButton.MouseButton1Click:Connect(function() -- Line: 416
                        -- upvalues: GuiController (ref), CrateName (ref), u67 (copy)
                        GuiController:Open("Odds", nil, { "HUD" });
                        CrateName.Value = u67;
                    end);
                end;

                local Main_Frame = v74.Main_Frame;
                Main_Frame.Seed_Text.Text = v68;
                Main_Frame.Seed_Text.TextLabel.Text = v68;

                if v69 then
                    Main_Frame.ImageDisplay.Vector.Image = v69;
                end;

                local Rarity = Main_Frame.Rarity;

                for _, child in Rarity:GetChildren() do
                    if child:IsA("UIGradient") then
                        child:Destroy();
                    end;
                end;

                if v72 then
                    local v75 = Gradients:FindFirstChild(v72);

                    if v75 then
                        local v76 = v75:Clone();
                        v76.Parent = Rarity;

                        if v75.Name == "Super" or v75.Name == "Secret" then
                            v76:AddTag("InfiniteGradient");
                        end;
                    end;

                    Rarity.Rarity_Text.Text = v72;
                    Rarity.Rarity_Text.TextLabel.Text = v72;
                end;

                local v77 = NumberUtils.Abbreviate(v71) .. Worlds.Current.CurrencySuffix;
                local v78 = u28.stockItems:FindFirstChild(u67);
                local u79;

                if u28.getRequiredGroupId then
                    u79 = u28.getRequiredGroupId(v);
                else
                    u79 = nil;
                end;

                local v80 = {
                    frame = v74,
                    data = v,
                    mainFrame = Main_Frame,
                    costText = v77,
                    price = v71,
                    baseCost = v70,
                    maxStock = v78 and v78.Value or 0,
                    devProductKey = `{u28.devProductPrefix}:{u67}:1`
                };
                local v81;

                if u28.isEquippableGear then
                    v81 = u28.isEquippableGear(v);
                else
                    v81 = false;
                end;

                v80.isEquippable = v81;
                v80.requiredGroupId = u79;
                u30[u67] = v80;
                local Like_Group = Main_Frame:FindFirstChild("Like_Group");

                if Like_Group then
                    local v82;

                    if u79 then
                        local success, result = pcall(function() -- Line: 472
                            -- upvalues: LocalPlayer (ref), u79 (copy)
                            return LocalPlayer:IsInGroup(u79);
                        end);
                        v82 = not (success and result);
                    else
                        v82 = false;
                    end;

                    Like_Group.Visible = v82;
                end;

                if u28.getLimitedEndTime and u28.getLimitedEndTime(v) then
                    local Limited = Main_Frame:FindFirstChild("Limited");
                    local v83 = {};
                    local v84 = nil;

                    if Limited then
                        Limited.Visible = true;
                        local v85 = u28.getLimitedFramePosition and u28.getLimitedFramePosition(v);

                        if v85 then
                            Limited.Position = v85;
                        end;

                        local v86 = u28.getLimitedFrameSize and u28.getLimitedFrameSize(v);

                        if v86 then
                            Limited.Size = v86;
                        end;

                        local LimitedText = Limited:FindFirstChild("LimitedText");

                        if LimitedText then
                            local TextLabel = LimitedText:FindFirstChild("TextLabel");

                            if TextLabel and TextLabel:IsA("TextLabel") then
                                table.insert(v83, AnimatedTextGradient.Apply(TextLabel, u6));
                            end;
                        end;

                        local Timer = Limited:FindFirstChild("Timer");

                        if Timer then
                            local TextLabel = Timer:FindFirstChild("TextLabel");

                            if TextLabel and TextLabel:IsA("TextLabel") then
                                v84 = AnimatedTextGradient.Apply(TextLabel, u6);
                                table.insert(v83, v84);
                            end;
                        end;
                    end;

                    table.insert(u32, {
                        frame = v74,
                        mainFrame = Main_Frame,

                        getEndTime = function() -- Line: 528, Name: getEndTime
                            -- upvalues: u28 (copy), v (copy)
                            return u28.getLimitedEndTime(v);
                        end,

                        timerFx = v84,
                        fxHandles = v83
                    });
                end;

                RefreshStock(u67);
                table.insert(v31, v74);
            end;
        end;

        if u28.priceOverrides then
            local function RefreshAllPrices() -- Line: 545
                -- upvalues: u30 (copy), u28 (copy), NumberUtils (ref), Worlds (ref), u64 (copy), RefreshStock (copy)
                for i, v in pairs(u30) do
                    local baseCost = v.baseCost;

                    if u28.priceOverrides then
                        local v87 = u28.priceOverrides:Get()[i];

                        if type(v87) == "number" and v87 >= 0 then
                            baseCost = v87;
                        end;
                    end;

                    v.price = baseCost;
                    v.costText = NumberUtils.Abbreviate(baseCost) .. Worlds.Current.CurrencySuffix;

                    if not u64[i] then
                        u64[i] = true;
                        task.defer(function() -- Line: 380
                            -- upvalues: u64 (ref), i (copy), RefreshStock (ref)
                            u64[i] = nil;
                            RefreshStock(i);
                        end);
                    end;
                end;
            end;

            u28.priceOverrides.Changed:Connect(RefreshAllPrices);
            u28.priceOverrides.Loaded:Connect(RefreshAllPrices);
        end;

        if u28.enabledFlag and u28.isItemEnabled then
            local function RefreshAllVisibility() -- Line: 562
                -- upvalues: u30 (copy), u28 (copy)
                for _, v in pairs(u30) do
                    v.frame.Visible = u28.isItemEnabled(v.data) == true;
                end;
            end;

            u28.enabledFlag.Changed:Connect(RefreshAllVisibility);
            u28.enabledFlag.Loaded:Connect(RefreshAllVisibility);
        end;

        if u1 then
            u1:OnChange(function(p88, p89) -- Line: 573
                -- upvalues: u28 (copy), u64 (copy), RefreshStock (copy), u30 (copy), u33 (ref), UpdateShelf (copy)
                if not p89 or (p89[1] ~= "PurchasedThisRestock" or p89[2] ~= u28.purchasedRestockKey) then
                    local v90 = p89 and (p89[1] == "Sheckles" and (u33 and u30[u33.Name]));

                    if v90 then
                        UpdateShelf(v90.mainFrame);
                    end;

                    return;
                end;

                if p89[3] == nil then
                    for i in pairs(u30) do
                        if not u64[i] then
                            u64[i] = true;
                            task.defer(function() -- Line: 380
                                -- upvalues: u64 (ref), i (copy), RefreshStock (ref)
                                u64[i] = nil;
                                RefreshStock(i);
                            end);
                        end;
                    end;

                    return;
                end;

                local u91 = tostring(p89[3]);

                if u64[u91] then
                    return;
                end;

                u64[u91] = true;
                task.defer(function() -- Line: 380
                    -- upvalues: u64 (ref), u91 (copy), RefreshStock (ref)
                    u64[u91] = nil;
                    RefreshStock(u91);
                end);
            end);
        end;

        local function WatchStockValue(u92) -- Line: 597
            -- upvalues: u30 (copy), u64 (copy), RefreshStock (copy)
            u92:GetPropertyChangedSignal("Value"):Connect(function() -- Line: 598
                -- upvalues: u30 (ref), u92 (copy), u64 (ref), RefreshStock (ref)
                local v93 = u30[u92.Name];

                if v93 then
                    v93.maxStock = u92.Value;
                    local Name = u92.Name;

                    if u64[Name] then
                        return;
                    end;

                    u64[Name] = true;
                    task.defer(function() -- Line: 380
                        -- upvalues: u64 (ref), Name (copy), RefreshStock (ref)
                        u64[Name] = nil;
                        RefreshStock(Name);
                    end);
                end;
            end);
        end;

        for _, child in u28.stockItems:GetChildren() do
            local v94 = u30[child.Name];

            if v94 then
                v94.maxStock = child.Value;
                RefreshStock(child.Name);
            end;

            child:GetPropertyChangedSignal("Value"):Connect(function() -- Line: 598
                -- upvalues: u30 (copy), child (copy), u64 (copy), RefreshStock (copy)
                local v95 = u30[child.Name];

                if v95 then
                    v95.maxStock = child.Value;
                    local Name = child.Name;

                    if u64[Name] then
                        return;
                    end;

                    u64[Name] = true;
                    task.defer(function() -- Line: 380
                        -- upvalues: u64 (ref), Name (copy), RefreshStock (ref)
                        u64[Name] = nil;
                        RefreshStock(Name);
                    end);
                end;
            end);
        end;

        u28.stockItems.ChildAdded:Connect(function(u96) -- Line: 619
            -- upvalues: u30 (copy), u64 (copy), RefreshStock (copy)
            local v97 = u30[u96.Name];

            if v97 then
                v97.maxStock = u96.Value;
                local Name = u96.Name;

                if not u64[Name] then
                    u64[Name] = true;
                    task.defer(function() -- Line: 380
                        -- upvalues: u64 (ref), Name (copy), RefreshStock (ref)
                        u64[Name] = nil;
                        RefreshStock(Name);
                    end);
                end;
            end;

            u96:GetPropertyChangedSignal("Value"):Connect(function() -- Line: 598
                -- upvalues: u30 (ref), u96 (copy), u64 (ref), RefreshStock (ref)
                local v98 = u30[u96.Name];

                if v98 then
                    v98.maxStock = u96.Value;
                    local Name = u96.Name;

                    if u64[Name] then
                        return;
                    end;

                    u64[Name] = true;
                    task.defer(function() -- Line: 380
                        -- upvalues: u64 (ref), Name (copy), RefreshStock (ref)
                        u64[Name] = nil;
                        RefreshStock(Name);
                    end);
                end;
            end);
        end);

        if u28.personalRestockEvent then
            u28.personalRestockEvent.OnClientEvent:Connect(function(p99) -- Line: 630
                -- upvalues: u29 (copy), u30 (copy), u64 (copy), RefreshStock (copy)
                table.clear(u29);

                for i, v in pairs(p99) do
                    u29[i] = v;
                end;

                for i in pairs(u30) do
                    if not u64[i] then
                        u64[i] = true;
                        task.defer(function() -- Line: 380
                            -- upvalues: u64 (ref), i (copy), RefreshStock (ref)
                            u64[i] = nil;
                            RefreshStock(i);
                        end);
                    end;
                end;
            end);
        end;

        local u100 = {};

        for _, v in v31 do
            table.insert(u100, v);
        end;

        table.sort(u100, function(p101, p102) -- Line: 648
            return p101.LayoutOrder < p102.LayoutOrder;
        end);

        for _, v in v31 do
            v.Main_Frame.TextButton.Activated:Connect(function() -- Line: 653
                -- upvalues: u33 (ref), v (copy), Sheckles_Shelf (copy), Robux_Shelf (copy), UpdateShelf (copy), u100 (copy), TweenService (ref), scrollingFrame (copy), u4 (ref)
                if u33 == v then
                    Sheckles_Shelf.Visible = false;
                    Robux_Shelf.Visible = false;
                    u33 = nil;

                    return;
                end;

                Sheckles_Shelf.Visible = true;
                Robux_Shelf.Visible = false;
                Sheckles_Shelf.LayoutOrder = v.LayoutOrder + 1;
                Robux_Shelf.LayoutOrder = v.LayoutOrder + 1;
                u33 = v;
                UpdateShelf(v.Main_Frame);
                local v103 = 0;

                for _, v2 in ipairs(u100) do
                    if v2.Visible then
                        v103 = v103 + 1;
                    end;

                    if v2 == v then
                        break;
                    end;
                end;

                local v104 = TweenService:Create(scrollingFrame, u4, {
                    CanvasPosition = Vector2.new(0, v.AbsoluteSize.Y * (v103 - 1))
                });
                v104:Play();
                game.Debris:AddItem(v104, u4.Time);
            end);
        end;

        ToggleRobux.MouseButton1Click:Connect(function() -- Line: 688
            -- upvalues: ShowRobuxShelf (copy)
            if workspace:GetAttribute("InTutorial") then
                return;
            end;

            ShowRobuxShelf();
        end);
        ToggleSheckles.MouseButton1Click:Connect(function() -- Line: 693
            -- upvalues: Sheckles_Shelf (copy), Robux_Shelf (copy)
            Sheckles_Shelf.Visible = true;
            Robux_Shelf.Visible = false;
        end);

        local function PassesGroupGate(p105) -- Line: 697
            -- upvalues: u30 (copy), LocalPlayer (ref), NotificationController (ref)
            local u106 = u30[p105];

            if not (u106 and u106.requiredGroupId) then
                return true;
            end;

            local success, result = pcall(function() -- Line: 700
                -- upvalues: LocalPlayer (ref), u106 (copy)
                return LocalPlayer:IsInGroup(u106.requiredGroupId);
            end);

            if success and result then
                return true;
            end;

            NotificationController:CreateNotification("Join Group + Like👍");

            return false;
        end;

        local function PassesGreenbeanGate(p107) -- Line: 709
            -- upvalues: GreenbeanCheck (ref), LocalPlayer (ref), NotificationController (ref), GreenbeanAvatarController (ref)
            if not GreenbeanCheck.SeedRequiresGreenbean(p107) then
                return true;
            end;

            if GreenbeanCheck.IsCharacterGreenbean(LocalPlayer.Character) then
                return true;
            end;

            NotificationController:CreateNotification("Equip the Green Bean avatar to buy this seed!");
            GreenbeanAvatarController:Prompt();

            return false;
        end;

        local u108 = false;

        local function executeBuy() -- Line: 722
            -- upvalues: u66 (ref), u33 (ref), u30 (copy), LocalPlayer (ref), NotificationController (ref), GreenbeanCheck (ref), GreenbeanAvatarController (ref), u28 (copy), u1 (ref), PLAYEFFECT (ref), BuyButton (copy), SfxController (ref), u29 (copy)
            if u66 then
                return;
            end;

            if not u33 then
                return;
            end;

            local Name = u33.Name;
            local v109 = u30[Name];
            local u110 = u30[Name];
            local v111;

            if u110 and u110.requiredGroupId then
                local success, result = pcall(function() -- Line: 700
                    -- upvalues: LocalPlayer (ref), u110 (copy)
                    return LocalPlayer:IsInGroup(u110.requiredGroupId);
                end);

                if success and result then
                    v111 = true;
                else
                    NotificationController:CreateNotification("Join Group + Like👍");
                    v111 = false;
                end;
            else
                v111 = true;
            end;

            if not v111 then
                return;
            end;

            local v112;

            if GreenbeanCheck.SeedRequiresGreenbean(Name) and not GreenbeanCheck.IsCharacterGreenbean(LocalPlayer.Character) then
                NotificationController:CreateNotification("Equip the Green Bean avatar to buy this seed!");
                GreenbeanAvatarController:Prompt();
                v112 = false;
            else
                v112 = true;
            end;

            if not v112 then
                return;
            end;

            if not (v109 and v109.isEquippable) then
                local v113 = u30[Name];

                if (not v113 and 0 or math.max((u29[Name] ~= nil and u29[Name] or v113.maxStock) - (u1 and (u1.Data.PurchasedThisRestock and u1.Data.PurchasedThisRestock[u28.purchasedRestockKey]) and (u1.Data.PurchasedThisRestock[u28.purchasedRestockKey][Name] or 0) or 0), 0)) < 1 then
                    return;
                end;

                local v114 = u30[Name];
                local v115;

                if v114 and u1 then
                    v115 = (u1.Data.Sheckles or 0) >= v114.price;
                else
                    v115 = false;
                end;

                if not v115 then
                    return;
                end;

                PLAYEFFECT(BuyButton);
                u66 = true;
                local success, result = pcall(function() -- Line: 787
                    -- upvalues: u28 (ref), Name (copy)
                    u28.purchaseEvent:Fire(Name);
                end);

                if not success then
                    warn((`[RestockStoreController] Purchase fire failed ({Name}): {result}`));
                end;

                task.wait();
                u66 = false;

                return;
            end;

            local v116 = u28.ownsEquippableGear and u28.ownsEquippableGear(Name);

            if v116 then
                PLAYEFFECT(BuyButton);
                u66 = true;
                local u117 = u28.isGearEquipped and u28.isGearEquipped(Name);
                pcall(function() -- Line: 754
                    -- upvalues: u117 (copy), NotificationController (ref), Name (copy), SfxController (ref)
                    if u117 then
                        NotificationController:CreateNotification(Name .. " Unequipped");
                        SfxController:PlaySFX("ItemUnequip");

                        return;
                    end;

                    NotificationController:CreateNotification(Name .. " Equipped");
                    SfxController:PlaySFX("ItemEquip");
                end);
                local success, result = pcall(function() -- Line: 764
                    -- upvalues: u117 (copy), u28 (ref), Name (copy)
                    if u117 then
                        u28.unequipGearEvent:Fire(Name);

                        return;
                    end;

                    u28.equipGearEvent:Fire(Name);
                end);

                if not success then
                    warn((`[RestockStoreController] Gear {u117 and "unequip" or "equip"} fire failed ({Name}): {result}`));
                end;

                task.wait();
                u66 = false;

                return;
            end;

            local v118 = u30[Name];
            local v119;

            if v118 and u1 then
                v119 = (u1.Data.Sheckles or 0) >= v118.price;
            else
                v119 = false;
            end;

            if not v119 then
                return;
            end;

            PLAYEFFECT(BuyButton);
            u66 = true;
            local success, result = pcall(function() -- Line: 739
                -- upvalues: u28 (ref), Name (copy)
                u28.purchaseEvent:Fire(Name);
            end);

            if not success then
                warn((`[RestockStoreController] Purchase fire failed ({Name}): {result}`));
            end;

            task.wait();
            u66 = false;
        end;

        local u120 = false;
        local u121 = 0;
        WatchButtonHold(BuyButton, function(p122, p123) -- Line: 804
            -- upvalues: u121 (ref), u120 (ref), u108 (ref), executeBuy (copy)
            if p123 then
                u121 = 0;

                if u120 then
                    u120 = false;
                end;

                return;
            end;

            if not u120 then
                u120 = true;
            end;

            if os.clock() < u121 then
                return;
            end;

            local v124 = ((1 - math.exp(p122 * -0.3)) * 24 + 8) // 1;
            local v125 = math.max(v124, 1);
            u121 = os.clock() + 0.125;

            for _ = 1, v125 do
                u108 = true;
                executeBuy();
            end;
        end, {
            minimumHoldTime = 1,
            interval = 0.125
        });
        BuyButton.Activated:Connect(function() -- Line: 833
            -- upvalues: u108 (ref), executeBuy (copy)
            if u108 then
                u108 = false;

                return;
            end;

            executeBuy();
        end);

        for i, v in pairs(u7) do
            local u126 = Buttons:FindFirstChild(i);

            if u126 then
                local u127 = string.find(i, "Gift") ~= nil;
                u126.Activated:Connect(function() -- Line: 850
                    -- upvalues: u66 (ref), u33 (ref), u30 (copy), u28 (copy), LocalPlayer (ref), NotificationController (ref), GreenbeanCheck (ref), GreenbeanAvatarController (ref), v (copy), u127 (copy), handleGiftButton (ref), DevProductController (ref)
                    if workspace:GetAttribute("InTutorial") then
                        return;
                    end;

                    if u66 then
                        return;
                    end;

                    if not u33 then
                        return;
                    end;

                    local Name = u33.Name;
                    local v128 = u30[Name];

                    if v128 and v128.isEquippable then
                        local v129 = u28.ownsEquippableGear and u28.ownsEquippableGear(Name);

                        if v129 then
                            return;
                        end;
                    end;

                    local u130 = u30[Name];
                    local v131;

                    if u130 and u130.requiredGroupId then
                        local success, result = pcall(function() -- Line: 700
                            -- upvalues: LocalPlayer (ref), u130 (copy)
                            return LocalPlayer:IsInGroup(u130.requiredGroupId);
                        end);

                        if success and result then
                            v131 = true;
                        else
                            NotificationController:CreateNotification("Join Group + Like👍");
                            v131 = false;
                        end;
                    else
                        v131 = true;
                    end;

                    if not v131 then
                        return;
                    end;

                    local v132;

                    if GreenbeanCheck.SeedRequiresGreenbean(Name) and not GreenbeanCheck.IsCharacterGreenbean(LocalPlayer.Character) then
                        NotificationController:CreateNotification("Equip the Green Bean avatar to buy this seed!");
                        GreenbeanAvatarController:Prompt();
                        v132 = false;
                    else
                        v132 = true;
                    end;

                    if not v132 then
                        return;
                    end;

                    local u133 = `{u28.devProductPrefix}:{Name}:{v}`;
                    u66 = true;
                    local success, result = pcall(function() -- Line: 870
                        -- upvalues: u127 (ref), handleGiftButton (ref), u133 (copy), DevProductController (ref), NotificationController (ref)
                        if u127 then
                            handleGiftButton(u133);

                            return;
                        end;

                        local v134, v135 = DevProductController:PromptPurchase(u133);

                        if v134 == false then
                            warn((`[RestockStoreController] Robux purchase unavailable ({u133}): {v135}`));
                            NotificationController:CreateNotification("Robux purchase unavailable for this item!");
                        end;
                    end);

                    if not success then
                        warn((`[RestockStoreController] Robux purchase flow failed ({u133}): {result}`));
                    end;

                    task.wait();
                    u66 = false;
                end);

                if not u127 then
                    u126.MouseEnter:Connect(function() -- Line: 893
                        -- upvalues: u33 (ref), DevProductController (ref), u28 (copy), v (copy), u126 (copy), NumberUtils (ref)
                        if not u33 then
                            return;
                        end;

                        local v136 = DevProductController:WaitForPreloadedProductInfo((`{u28.devProductPrefix}:{u33.Name}:{v}`));

                        if not v136 then
                            return;
                        end;

                        u126.TextDisplay.TextLabel.Text = `{NumberUtils.FormatWithCommas(v136.PriceInRobux)}`;
                        u126.TextDisplay.TextLabel.TextLabel.Text = u126.TextDisplay.TextLabel.Text;
                    end);
                    u126.MouseLeave:Connect(function() -- Line: 901
                        -- upvalues: i (copy), u33 (ref), u30 (copy), u126 (copy), v (copy)
                        if i == "1Button" and u33 then
                            local v137 = u30[u33.Name];

                            if v137 and v137.isEquippable then
                                return;
                            end;
                        end;

                        u126.TextDisplay.TextLabel.Text = `x{v}`;
                        u126.TextDisplay.TextLabel.TextLabel.Text = u126.TextDisplay.TextLabel.Text;
                    end);
                end;
            end;
        end;

        if u28.gearEquipStateEvent then
            u28.gearEquipStateEvent.OnClientEvent:Connect(function(u138, p139) -- Line: 916
                -- upvalues: u28 (copy), Robux_Shelf (copy), Sheckles_Shelf (copy), u64 (copy), RefreshStock (copy), u33 (ref), u30 (copy), UpdateShelf (copy)
                if u28.onGearEquipStateChanged then
                    u28.onGearEquipStateChanged(u138, p139);
                end;

                if p139 and Robux_Shelf.Visible then
                    Sheckles_Shelf.Visible = true;
                    Robux_Shelf.Visible = false;
                end;

                if not u64[u138] then
                    u64[u138] = true;
                    task.defer(function() -- Line: 380
                        -- upvalues: u64 (ref), u138 (copy), RefreshStock (ref)
                        u64[u138] = nil;
                        RefreshStock(u138);
                    end);
                end;

                local v140 = u33 and (u33.Name == u138 and u30[u138]);

                if v140 then
                    UpdateShelf(v140.mainFrame);
                end;
            end);
        end;

        if #u32 > 0 then
            local u141 = 0;
            RunService.Heartbeat:Connect(function() -- Line: 936
                -- upvalues: u141 (ref), u32 (copy), FormatCountdown (ref)
                local v142 = workspace:GetServerTimeNow();

                if v142 < u141 then
                    return;
                end;

                u141 = v142 + 1;

                for i = #u32, 1, -1 do
                    local v143 = u32[i];
                    local v144 = v143.getEndTime();
                    local Limited = v143.mainFrame:FindFirstChild("Limited");

                    if v144 then
                        local v145 = v144 - v142;

                        if v145 <= 0 then
                            v143.frame.Visible = false;

                            if Limited then
                                Limited.Visible = false;
                            end;

                            for _, v in v143.fxHandles do
                                v:Destroy();
                            end;

                            table.remove(u32, i);
                        elseif Limited then
                            local Timer = Limited:FindFirstChild("Timer");

                            if Timer then
                                local v146 = FormatCountdown(v145);
                                Timer.Text = v146;
                                local TextLabel = Timer:FindFirstChild("TextLabel");

                                if TextLabel then
                                    if v143.timerFx then
                                        v143.timerFx:SetText(v146);
                                    else
                                        TextLabel.Text = v146;
                                    end;
                                end;
                            end;
                        end;
                    else
                        if Limited then
                            Limited.Visible = false;
                        end;

                        for _, v in v143.fxHandles do
                            v:Destroy();
                        end;

                        table.remove(u32, i);
                    end;
                end;
            end);
        end;
    end
};