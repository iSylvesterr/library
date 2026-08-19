-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local MarketplaceService = game:GetService("MarketplaceService");
local Knit = require(ReplicatedStorage.Packages.Knit);
local WeatherConfig = require(ReplicatedStorage.Shared.Info.WeatherConfig);
local MutationConfig = require(ReplicatedStorage.Shared.Info.MutationConfig);
local Products = require(ReplicatedStorage.Shared.Info.Products);
local CustomEnum = require(ReplicatedStorage.Shared.Info.CustomEnum);
local Images = require(ReplicatedStorage.Shared.Info.Images);
local v1 = Knit.CreateController({
    Name = "ShopController"
});
local u2 = Color3.fromRGB(200, 200, 200);

local function rgbTag(p3) -- Line: 17
    return string.format("rgb(%d,%d,%d)", math.round(p3.R * 255), math.round(p3.G * 255), (math.round(p3.B * 255)));
end;

local u4 = {};

local function getProductPrice(u5) -- Line: 22
    -- upvalues: u4 (copy), MarketplaceService (copy)
    if u4[u5] then
        return u4[u5];
    end;

    local success, result = pcall(function() -- Line: 24
        -- upvalues: MarketplaceService (ref), u5 (copy)
        return MarketplaceService:GetProductInfo(u5, Enum.InfoType.Product);
    end);

    if not (success and (result and result.PriceInRobux)) then
        return nil;
    end;

    u4[u5] = result.PriceInRobux;

    return result.PriceInRobux;
end;

function v1.KnitStart(u6) -- Line: 34
    -- upvalues: Players (copy), Knit (copy), WeatherConfig (copy), Products (copy), CustomEnum (copy), MutationConfig (copy), u2 (copy), u4 (copy), MarketplaceService (copy), Images (copy)
    local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
    local u7 = Knit.GetService("PurchaseManager");
    local u8 = Knit.GetService("FarmersMarketService");
    local u9 = Knit.GetController("GiftingUI");
    local UI_Manager = u6.UI_Manager;
    local Shop = PlayerGui:WaitForChild("WindowsLocalZ"):WaitForChild("Shop");
    Shop.Visible = false;
    local Exit = Shop.Top:WaitForChild("Exit");
    local SkipButton = Shop.Top:FindFirstChild("SkipButton");

    if SkipButton then
        SkipButton.Visible = false;
    end;

    local ItemHolder = Shop.Content:WaitForChild("ScrollingFrame"):WaitForChild("ItemHolder");
    local TicketsDivider = ItemHolder:FindFirstChild("TicketsDivider");

    if TicketsDivider then
        TicketsDivider = TicketsDivider:FindFirstChild("Title");
    end;

    if TicketsDivider then
        TicketsDivider = TicketsDivider:FindFirstChildWhichIsA("TextLabel");
    end;

    if TicketsDivider and TicketsDivider.Text == "Weather Events" then
        TicketsDivider.Text = "Tickets";
    end;

    local u10 = {};

    for i, v in WeatherConfig.Weathers do
        u10[v.displayName] = "Weather" .. i;
    end;

    local function productKeyFor(p11) -- Line: 62
        -- upvalues: u10 (copy), Products (ref)
        if u10[p11] then
            return u10[p11];
        end;

        local v12 = p11:match("^x(%d+) Tickets$");

        if v12 and Products["Tickets" .. v12] then
            return "Tickets" .. v12;
        end;

        return nil;
    end;

    local u13 = {};

    for _, child in ItemHolder:GetChildren() do
        if child.Name == "Row" then
            local FruitReq = child:FindFirstChild("FruitReq");

            if FruitReq then
                for i, child2 in FruitReq:GetChildren() do
                    if child2.Name == "Cell" then
                        local TextLabel = child2:FindFirstChild("TextLabel");

                        if TextLabel then
                            local Text = TextLabel.Text;

                            if u10[Text] then
                                TextLabel = u10[Text];
                            else
                                local v14 = Text:match("^x(%d+) Tickets$");

                                if v14 and Products["Tickets" .. v14] then
                                    TextLabel = "Tickets" .. v14;
                                else
                                    TextLabel = nil;
                                end;
                            end;
                        end;

                        local u15;

                        if TextLabel then
                            u15 = Products[TextLabel];
                        else
                            u15 = TextLabel;
                        end;

                        local RobuxButton = child2:FindFirstChild("RobuxButton");
                        local v16;

                        if RobuxButton then
                            v16 = RobuxButton:FindFirstChild("Button");
                        else
                            v16 = RobuxButton;
                        end;

                        if v16 then
                            if u15 then
                                local v17 = {
                                    productKey = TextLabel,
                                    priceLabel = v16:FindFirstChild("Price"),
                                    productId = u15.Id
                                };
                                table.insert(u13, v17);
                                UI_Manager:AddBounceButton(v16, 1.05, false);
                                local u18 = TextLabel:match("^Tickets%d+$") ~= nil;
                                v16.Activated:Connect(function() -- Line: 90
                                    -- upvalues: u18 (copy), u8 (copy), TextLabel (copy), u7 (copy)
                                    if u18 then
                                        u8.purchaseTickets:Fire(TextLabel, nil);

                                        return;
                                    end;

                                    u7.PromptProductPurchase:Fire(TextLabel);
                                end);
                                local Gift = child2:FindFirstChild("Gift");
                                local v19;

                                if Gift then
                                    v19 = Gift:FindFirstChild("Button");
                                else
                                    v19 = Gift;
                                end;

                                if v19 then
                                    if u18 then
                                        UI_Manager:AddBounceButton(v19, 1.05, false);
                                        v19.Activated:Connect(function() -- Line: 103
                                            -- upvalues: u9 (copy), CustomEnum (ref), u15 (copy), TextLabel (copy)
                                            u9:OpenGiftingUI(CustomEnum.GIFT_TYPES.TICKETS, {
                                                amt = u15.Amount,
                                                productName = TextLabel
                                            });
                                        end);
                                    else
                                        Gift.Visible = false;
                                    end;
                                end;

                                local ImageLabel = child2:FindFirstChild("ImageLabel");

                                if ImageLabel and u18 then
                                    UI_Manager:AddEmitterTemplate(ImageLabel, UDim2.new(0.5, 0, 0.5, 0), UI_Manager.PARTICLE_TEMPLATES.SPARKLE, {
                                        zIndex = 4,
                                        em_delay = 0.8 + i * 0.05
                                    });
                                end;
                            else
                                RobuxButton.Visible = false;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    for _, child in ItemHolder:WaitForChild("NewWeatherRow"):GetChildren() do
        if child.Name == "SubRow" then
            for _, child2 in child:GetChildren() do
                if child2.Name == "Cell" then
                    local TextLabel = child2:FindFirstChild("TextLabel");

                    if TextLabel then
                        local Text = TextLabel.Text;

                        if u10[Text] then
                            TextLabel = u10[Text];
                        else
                            local v20 = Text:match("^x(%d+) Tickets$");

                            if v20 and Products["Tickets" .. v20] then
                                TextLabel = "Tickets" .. v20;
                            else
                                TextLabel = nil;
                            end;
                        end;
                    end;

                    local v21;

                    if TextLabel then
                        v21 = Products[TextLabel];
                    else
                        v21 = TextLabel;
                    end;

                    local RobuxButton = child2:FindFirstChild("RobuxButton");
                    local v22;

                    if RobuxButton then
                        v22 = RobuxButton:FindFirstChild("Button");
                    else
                        v22 = RobuxButton;
                    end;

                    if v22 then
                        if v21 then
                            local v23 = {
                                productKey = TextLabel,
                                priceLabel = v22:FindFirstChild("Price"),
                                productId = v21.Id
                            };
                            table.insert(u13, v23);
                            UI_Manager:AddBounceButton(v22, 1.05, false);
                            v22.Activated:Connect(function() -- Line: 145
                                -- upvalues: u7 (copy), TextLabel (copy)
                                u7.PromptProductPurchase:Fire(TextLabel);
                            end);
                            local v24 = TextLabel:match("^Weather(.+)$");
                            local PreviewButton = child2:FindFirstChild("PreviewButton");
                            local Info = child2:FindFirstChild("Info");
                            local Shadow = child2:FindFirstChild("Shadow");

                            if v24 and (PreviewButton and (Info and Shadow)) then
                                local v25 = WeatherConfig.Weathers[v24];
                                local v26;

                                if v25 then
                                    v26 = MutationConfig.Mutations[v25.mutationKey];
                                else
                                    v26 = v25;
                                end;

                                if v26 then
                                    Info.RichText = true;
                                    local format = string.format;
                                    local v27 = string.format("%g", v25.chance * 100);
                                    local textColor = v26.textColor;
                                    local v28 = u2;
                                    Info.Text = format("Seeds and fruits have a %s%% chance to become <font color=\"%s\">%s</font>! <font color=\"%s\">(lasts %gmin)</font>", v27, string.format("rgb(%d,%d,%d)", math.round(textColor.R * 255), math.round(textColor.G * 255), (math.round(textColor.B * 255))), v26.displayName, string.format("rgb(%d,%d,%d)", math.round(v28.R * 255), math.round(v28.G * 255), (math.round(v28.B * 255))), WeatherConfig.EVENT_DURATION / 60);
                                end;

                                Info.Visible = false;
                                Shadow.Visible = false;
                                UI_Manager:AddBounceButton(PreviewButton, 1.1, false);
                                PreviewButton.Activated:Connect(function() -- Line: 168
                                    -- upvalues: Info (copy), Shadow (copy)
                                    local v29 = not Info.Visible;
                                    Info.Visible = v29;
                                    Shadow.Visible = v29;
                                end);
                            end;
                        else
                            RobuxButton.Visible = false;
                        end;
                    end;
                end;
            end;
        end;
    end;

    local VipSection = ItemHolder:WaitForChild("VipSection");
    local Button = VipSection:WaitForChild("RobuxButton"):WaitForChild("Button");
    local Price = Button:WaitForChild("Price");
    local Button2 = VipSection:WaitForChild("Gift"):WaitForChild("Button");
    local Owned = VipSection:WaitForChild("RobuxButton"):WaitForChild("Owned");
    local RainEffect = VipSection:WaitForChild("RainEffect");
    local ImageLabel = VipSection:WaitForChild("ImageLabel");
    UI_Manager:AddEmitterTemplate(ImageLabel, UDim2.new(0.5, 0, 0.5, 0), UI_Manager.PARTICLE_TEMPLATES.SPARKLE, {
        zIndex = 2
    });
    UI_Manager:AddShineV3(ImageLabel, 1.75, Color3.new(1, 1, 1), {
        noThinTwinkle = true,
        rotSpeed = 20
    });
    UI_Manager:AddBounceButton(Button, 1.05, false);
    Button.Activated:Connect(function() -- Line: 200
        -- upvalues: u6 (copy), CustomEnum (ref)
        u6.BundlesService.attemptBuyBundle:Fire(CustomEnum.BUNDLES.EMOTES, nil);
    end);
    UI_Manager:AddBounceButton(Button2, 1.05, false);
    Button2.Activated:Connect(function() -- Line: 205
        -- upvalues: u6 (copy), CustomEnum (ref)
        u6.GiftingUI:OpenGiftingUI(CustomEnum.GIFT_TYPES.BUNDLE, {
            bundleID = CustomEnum.BUNDLES.EMOTES
        });
    end);

    local function refreshPrices() -- Line: 210
        -- upvalues: u13 (copy), u4 (ref), MarketplaceService (ref), Products (ref), Price (copy)
        for _, v in u13 do
            local v30 = u4[v.productId];

            if v30 then
                if v.priceLabel then
                    v.priceLabel.Text = tostring(v30);
                end;
            else
                task.spawn(function() -- Line: 216
                    -- upvalues: v (copy), u4 (ref), MarketplaceService (ref)
                    local productId = v.productId;
                    local v31;

                    if u4[productId] then
                        v31 = u4[productId];
                    else
                        local success, result = pcall(function() -- Line: 24
                            -- upvalues: MarketplaceService (ref), productId (copy)
                            return MarketplaceService:GetProductInfo(productId, Enum.InfoType.Product);
                        end);

                        if success and (result and result.PriceInRobux) then
                            u4[productId] = result.PriceInRobux;
                            v31 = result.PriceInRobux;
                        else
                            v31 = nil;
                        end;
                    end;

                    if v31 and v.priceLabel then
                        v.priceLabel.Text = tostring(v31);
                    end;
                end);
            end;
        end;

        task.spawn(function() -- Line: 223
            -- upvalues: Products (ref), u4 (ref), MarketplaceService (ref), Price (ref)
            local Id = Products.EMOTE_VIP.Id;
            local v32;

            if u4[Id] then
                v32 = u4[Id];
            else
                local success, result = pcall(function() -- Line: 24
                    -- upvalues: MarketplaceService (ref), Id (copy)
                    return MarketplaceService:GetProductInfo(Id, Enum.InfoType.Product);
                end);

                if success and (result and result.PriceInRobux) then
                    u4[Id] = result.PriceInRobux;
                    v32 = result.PriceInRobux;
                else
                    v32 = nil;
                end;
            end;

            Price.Text = tostring(v32);
        end);
    end;

    refreshPrices();
    UI_Manager:AddBounceButton(Exit, 1.05, true);
    Exit.Activated:Connect(function() -- Line: 232
        -- upvalues: UI_Manager (copy), Shop (copy)
        UI_Manager:CloseWindow(Shop, true);
    end);
    Shop:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 234
        -- upvalues: Shop (copy), refreshPrices (copy), UI_Manager (copy), RainEffect (copy), Images (ref)
        if not Shop.Visible then
            UI_Manager:RemoveRainEffect(RainEffect);

            return;
        end;

        refreshPrices();
        UI_Manager:AddRainEffect(RainEffect, 15, {
            Images.TICKET_ONE,
            Images.TICKET_ONE,
            Images.TICKET_ONE,
            Images.TICKET_ONE,
            Images.TICKET_ONE,
            Images.TICKET_ONE,
            Images.TICKET_ONE,
            Images.EM_APPLAUSE,
            Images.EM_ANGRY,
            Images.EM_CONFUSED,
            Images.EM_SCREAM,
            Images.EM_LIGHTNING,
            Images.EM_EVIL_LAUGH
        }, UDim2.fromScale(1, 0.25), 2, {
            RotatableImages = { Images.TICKET_ONE }
        });
    end);
    local Button3 = PlayerGui:WaitForChild("HUD"):WaitForChild("SideMenus"):WaitForChild("Left"):WaitForChild("Buttons"):WaitForChild("Shop"):WaitForChild("Button");
    UI_Manager:AddBounceButton(Button3, 1.05, false);
    Button3.Activated:Connect(function() -- Line: 252
        -- upvalues: UI_Manager (copy), Shop (copy)
        UI_Manager:ToggleWindow(Shop, true);
    end);
    u6.DataClient.EV_UPDATE:Connect(function() -- Line: 256
        -- upvalues: u6 (copy), CustomEnum (ref), Owned (copy), Button (copy)
        if u6.DataClient.currentData.Gamepasses[CustomEnum.PASSES.EMOTE_VIP].Owned then
            Owned.Visible = true;
            Button.Visible = false;

            return;
        end;

        Owned.Visible = false;
        Button.Visible = true;
    end);
end;

function v1.KnitInit(p33) -- Line: 267
    -- upvalues: Knit (copy)
    p33.UI_Manager = Knit.GetController("UI_Manager");
    p33.BundlesService = Knit.GetService("BundlesService");
    p33.GiftingUI = Knit.GetController("GiftingUI");
    p33.DataClient = Knit.GetController("DataClient");
end;

return v1;