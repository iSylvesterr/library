-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local GUI = require(ReplicatedStorage.Library.Client.GUI);
local ButtonFX = require(ReplicatedStorage.Library.Client.GUIFX.ButtonFX);
local TabController = require(ReplicatedStorage.Library.Client.TabController);
local PromptPurchase = require(ReplicatedStorage.Library.Shared.Functions.PromptPurchase);
local Products = require(ReplicatedStorage.Directory.Products);
local Gamepasses = require(ReplicatedStorage.Directory.Gamepasses);
local GetPrice = require(ReplicatedStorage.Library.Functions.GetPrice);
local Lock = require(ReplicatedStorage.Library.Functions.Lock);
local Products2 = require(ReplicatedStorage.Library.Client.Products);
local Gamepasses2 = require(ReplicatedStorage.Library.Client.Gamepasses);
local Message = require(ReplicatedStorage.Library.Client.Message);
local Save = require(ReplicatedStorage.Library.Client.Save);
local Network = require(ReplicatedStorage.Library.Client.Network);
local Asserts = require(ReplicatedStorage.Library.Asserts);
local LocalPlayer = Players.LocalPlayer;
local ScrollingFrame = GUI.Shop().Frame.Main.ScrollingFrame;
local MoneyTop = ScrollingFrame.MoneyTop;
local MoneyBottom = ScrollingFrame.MoneyBottom;
local GamePasses = ScrollingFrame.GamePasses;
local Button = GUI.SideButtonTools().Shop.Button;
local u1 = Lock();

local function mapProductEntry(p2, p3) -- Line: 58
    -- upvalues: Asserts (copy)
    Asserts.table(p3);
    Asserts.number(p3.ProductId);
    local Buy = p2.Buy;
    local Price = Buy.Price;
    local v4;

    if Buy then
        v4 = Buy:IsA("GuiButton");
    else
        v4 = Buy;
    end;

    assert(v4, "Expected Buy to be a GuiButton");
    local v5;

    if Price then
        v5 = Price:IsA("TextLabel");
    else
        v5 = Price;
    end;

    assert(v5, "Expected Price to be a TextLabel");

    return {
        frame = p2,
        button = Buy,
        priceLabel = Price,
        productId = p3.ProductId
    };
end;

local u6 = {
    mapProductEntry(MoneyTop["1"], Products.Directory.Money_24000),
    mapProductEntry(MoneyTop["2"], Products.Directory.Money_200000),
    mapProductEntry(MoneyTop["3"], Products.Directory.Money_800000),
    mapProductEntry(MoneyBottom["1"], Products.Directory.Money_4000000),
    (mapProductEntry(MoneyBottom["2"], Products.Directory.Money_8000000))
};

local function mapGamepassEntry(p7, p8) -- Line: 83
    -- upvalues: Asserts (copy)
    local Main = p7.Main;
    local Price = Main.Price;
    local PriceText = Price.PriceText;
    local v9;

    if Main then
        v9 = Main:IsA("GuiButton");
    else
        v9 = Main;
    end;

    assert(v9, "Expected Main to be a GuiButton");

    if Price then
        Price = Price:IsA("Frame");
    end;

    assert(Price, "Expected Price to be a Frame");
    local v10;

    if PriceText then
        v10 = PriceText:IsA("TextLabel");
    else
        v10 = PriceText;
    end;

    assert(v10, "Expected PriceText to be a TextLabel");
    Asserts.table(p8);
    Asserts.string(p8._id);
    Asserts.number(p8.ProductId);

    return {
        button = Main,
        priceLabel = PriceText,
        gamepassId = p8._id,
        productId = p8.ProductId
    };
end;

local u11 = { mapGamepassEntry(GamePasses.x2Money, Gamepasses.Directory.X2Money), (mapGamepassEntry(GamePasses.x2Growth, Gamepasses.Directory.X2Growth)) };

local function updateGamepassPrice(p12) -- Line: 107
    -- upvalues: GetPrice (copy), Gamepasses2 (copy)
    local v13, v14 = GetPrice(p12.productId, false);

    if v14 then
        p12.priceLabel.Text = Gamepasses2.Owns(p12.gamepassId) and "OWNED" or "" .. tostring(v13);

        return;
    end;

    p12.priceLabel.Text = "Loading...";
end;

local function bindGamepassButton(u15) -- Line: 118
    -- upvalues: ButtonFX (copy), u1 (copy), Gamepasses2 (copy), Message (copy), PromptPurchase (copy)
    ButtonFX(u15.button, 1.08, function() -- Line: 119
        -- upvalues: u1 (ref), Gamepasses2 (ref), u15 (copy), Message (ref), PromptPurchase (ref)
        u1(function() -- Line: 120
            -- upvalues: Gamepasses2 (ref), u15 (ref), Message (ref), PromptPurchase (ref)
            if Gamepasses2.Owns(u15.gamepassId) then
                Message.New("You already own this!");

                return;
            end;

            PromptPurchase.Prompt(u15.productId, false);
        end);
    end);
end;

local function updatePrice(p16) -- Line: 130
    -- upvalues: GetPrice (copy), Products2 (copy)
    local v17, v18 = GetPrice(p16.productId, true);

    if v18 then
        p16.priceLabel.Text = Products2.Owns(p16.productId) and "OWNED" or "" .. tostring(v17);

        return;
    end;

    p16.priceLabel.Text = "Loading...";
end;

local function bindMoneyButton(u19) -- Line: 153
    -- upvalues: ButtonFX (copy), u1 (copy), Products2 (copy), Message (copy), PromptPurchase (copy)
    ButtonFX(u19.button, nil, function() -- Line: 154
        -- upvalues: u1 (ref), Products2 (ref), u19 (copy), Message (ref), PromptPurchase (ref)
        u1(function() -- Line: 155
            -- upvalues: Products2 (ref), u19 (ref), Message (ref), PromptPurchase (ref)
            if Products2.Owns(u19.productId) then
                Message.New("You already own this item!");

                return;
            end;

            PromptPurchase.Prompt(u19.productId, true);
        end);
    end);
end;

local function updateAllProducts() -- Line: 141
    -- upvalues: u6 (copy), updatePrice (copy)
    for _, v in u6 do
        task.spawn(updatePrice, v);
    end;
end;

local function updateAllGamepasses() -- Line: 147
    -- upvalues: u11 (copy), updateGamepassPrice (copy)
    for _, v in u11 do
        task.spawn(updateGamepassPrice, v);
    end;
end;

for _, v in u6 do
    task.spawn(function() -- Line: 166
        -- upvalues: v (copy), GetPrice (copy), Products2 (copy), ButtonFX (copy), u1 (copy), Message (copy), PromptPurchase (copy)
        local v20 = v;
        local v21, v22 = GetPrice(v20.productId, true);

        if v22 then
            v20.priceLabel.Text = Products2.Owns(v20.productId) and "OWNED" or "" .. tostring(v21);
        else
            v20.priceLabel.Text = "Loading...";
        end;

        local u23 = v;
        ButtonFX(u23.button, nil, function() -- Line: 154
            -- upvalues: u1 (ref), Products2 (ref), u23 (copy), Message (ref), PromptPurchase (ref)
            u1(function() -- Line: 155
                -- upvalues: Products2 (ref), u23 (ref), Message (ref), PromptPurchase (ref)
                if Products2.Owns(u23.productId) then
                    Message.New("You already own this item!");

                    return;
                end;

                PromptPurchase.Prompt(u23.productId, true);
            end);
        end);
    end);
end;

for _, v in u11 do
    task.spawn(function() -- Line: 173
        -- upvalues: v (copy), GetPrice (copy), Gamepasses2 (copy), ButtonFX (copy), u1 (copy), Message (copy), PromptPurchase (copy)
        local v24 = v;
        local v25, v26 = GetPrice(v24.productId, false);

        if v26 then
            v24.priceLabel.Text = Gamepasses2.Owns(v24.gamepassId) and "OWNED" or "" .. tostring(v25);
        else
            v24.priceLabel.Text = "Loading...";
        end;

        local u27 = v;
        ButtonFX(u27.button, 1.08, function() -- Line: 119
            -- upvalues: u1 (ref), Gamepasses2 (ref), u27 (copy), Message (ref), PromptPurchase (ref)
            u1(function() -- Line: 120
                -- upvalues: Gamepasses2 (ref), u27 (ref), Message (ref), PromptPurchase (ref)
                if Gamepasses2.Owns(u27.gamepassId) then
                    Message.New("You already own this!");

                    return;
                end;

                PromptPurchase.Prompt(u27.productId, false);
            end);
        end);
    end);
end;

ButtonFX(Button, nil, function() -- Line: 179
    -- upvalues: TabController (copy)
    TabController.ToggleTab("Shop");
end);
TabController.Opened:Connect(function(p28) -- Line: 183
    -- upvalues: u6 (copy), updatePrice (copy), u11 (copy), updateGamepassPrice (copy)
    if p28 == "Shop" then
        for _, v in u6 do
            task.spawn(updatePrice, v);
        end;

        for _, v in u11 do
            task.spawn(updateGamepassPrice, v);
        end;
    end;
end);

if Save.IsLocalDataLoaded() then
    task.spawn(function() -- Line: 191
        -- upvalues: u6 (copy), updatePrice (copy), u11 (copy), updateGamepassPrice (copy)
        for _, v in u6 do
            task.spawn(updatePrice, v);
        end;

        for _, v in u11 do
            task.spawn(updateGamepassPrice, v);
        end;
    end);
end;

Save.LoadedStats:Connect(function(p29) -- Line: 197
    -- upvalues: LocalPlayer (copy), u6 (copy), updatePrice (copy)
    if p29 ~= LocalPlayer then
        return;
    end;

    for _, v in u6 do
        task.spawn(updatePrice, v);
    end;
end);
Save.ConnectForDataChanged("Products", updateAllProducts);
Save.ConnectForDataChanged("Gamepasses", updateAllGamepasses);
Network.Fired(Network.NET_MAP.Gamepasses.GRANTED):Connect(updateAllGamepasses);