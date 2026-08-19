-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local PolicyService = game:GetService("PolicyService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local ButtonFX = require(ReplicatedStorage.Library.Client.GUIFX.ButtonFX);
local GetPrice = require(ReplicatedStorage.Library.Functions.GetPrice);
local GUI = require(ReplicatedStorage.Library.Client.GUI);
local HoverInfoSession = require(script.HoverInfoSession);
local LimitedEgg = require(ReplicatedStorage.Directory.LimitedEgg);
local Lock = require(ReplicatedStorage.Library.Functions.Lock);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Products = require(ReplicatedStorage.Directory.Products);
local PromptPurchase = require(ReplicatedStorage.Library.Shared.Functions.PromptPurchase);
local TabController = require(ReplicatedStorage.Library.Client.TabController);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
require(script.Types.Interface);
local ViewportSession = require(script.ViewportSession);
local wcall = require(ReplicatedStorage.Library.Functions.wcall);
local u1 = Log.new();
local u2 = Lock();
local u3 = nil;
local LocalPlayer = Players.LocalPlayer;
local LimitedEgg2 = GUI.Shop().Frame.Main.ScrollingFrame.LimitedEgg;
local v4 = LimitedEgg2:IsA("GuiObject");
assert(v4, "Shop LimitedEgg must be a GuiObject");
local Main = LimitedEgg2.Main;
local v5 = Main:IsA("GuiObject");
assert(v5, "Shop LimitedEgg.Main must be a GuiObject");
local InfoButton = Main.InfoButton;
local v6 = InfoButton:IsA("GuiObject");
assert(v6, "Shop LimitedEgg.Main.InfoButton must be a GuiObject");
local Info = InfoButton.Info;
local v7 = Info:IsA("CanvasGroup");
assert(v7, "Shop LimitedEgg.Main.InfoButton.Info must be a CanvasGroup");
local AssetViewports = Main.AssetViewports;
local Buttons = Main.Buttons;
local v8 = Buttons:IsA("GuiObject");
assert(v8, "Shop LimitedEgg.Main.Buttons must be a GuiObject");
local v9 = Buttons["1"];
local Price = v9.Price;
local v10 = Buttons["3"];
local Price2 = v10.Price;
local v11 = Buttons["10"];
local Price3 = v11.Price;
local v12 = Buttons["50"];
local Price4 = v12.Price;
local v13 = v9:IsA("GuiObject");
assert(v13, "LimitedEgg Buttons.1 must be a GuiObject");
local v14 = Price:IsA("TextLabel");
assert(v14, "LimitedEgg Buttons.1.Price must be a TextLabel");
local v15 = v10:IsA("GuiObject");
assert(v15, "LimitedEgg Buttons.3 must be a GuiObject");
local v16 = Price2:IsA("TextLabel");
assert(v16, "LimitedEgg Buttons.3.Price must be a TextLabel");
local v17 = v11:IsA("GuiObject");
assert(v17, "LimitedEgg Buttons.10 must be a GuiObject");
local v18 = Price3:IsA("TextLabel");
assert(v18, "LimitedEgg Buttons.10.Price must be a TextLabel");
local v19 = v12:IsA("GuiObject");
assert(v19, "LimitedEgg Buttons.50 must be a GuiObject");
local v20 = Price4:IsA("TextLabel");
assert(v20, "LimitedEgg Buttons.50.Price must be a TextLabel");
local v21 = AssetViewports["1"];
local Chance = v21.Chance;
local v22 = AssetViewports["2"];
local Chance2 = v22.Chance;
local v23 = AssetViewports["3"];
local Chance3 = v23.Chance;
local v24 = AssetViewports["4"];
local Chance4 = v24.Chance;
local v25 = AssetViewports["5"];
local Chance5 = v25.Chance;
local v26 = AssetViewports["6"];
local Chance6 = v26.Chance;
local v27 = v21:IsA("GuiObject");
assert(v27, "LimitedEgg AssetViewports.1 must be a GuiObject");
local v28 = Chance:IsA("TextLabel");
assert(v28, "LimitedEgg AssetViewports.1.Chance must be a TextLabel");
local v29 = v22:IsA("GuiObject");
assert(v29, "LimitedEgg AssetViewports.2 must be a GuiObject");
local v30 = Chance2:IsA("TextLabel");
assert(v30, "LimitedEgg AssetViewports.2.Chance must be a TextLabel");
local v31 = v23:IsA("GuiObject");
assert(v31, "LimitedEgg AssetViewports.3 must be a GuiObject");
local v32 = Chance3:IsA("TextLabel");
assert(v32, "LimitedEgg AssetViewports.3.Chance must be a TextLabel");
local v33 = v24:IsA("GuiObject");
assert(v33, "LimitedEgg AssetViewports.4 must be a GuiObject");
local v34 = Chance4:IsA("TextLabel");
assert(v34, "LimitedEgg AssetViewports.4.Chance must be a TextLabel");
local v35 = v25:IsA("GuiObject");
assert(v35, "LimitedEgg AssetViewports.5 must be a GuiObject");
local v36 = Chance5:IsA("TextLabel");
assert(v36, "LimitedEgg AssetViewports.5.Chance must be a TextLabel");
local v37 = v26:IsA("GuiObject");
assert(v37, "LimitedEgg AssetViewports.6 must be a GuiObject");
local v38 = Chance6:IsA("TextLabel");
assert(v38, "LimitedEgg AssetViewports.6.Chance must be a TextLabel");
local u39 = {
    {
        Frame = v21,
        Chance = Chance
    },
    {
        Frame = v22,
        Chance = Chance2
    },
    {
        Frame = v23,
        Chance = Chance3
    },
    {
        Frame = v24,
        Chance = Chance4
    },
    {
        Frame = v25,
        Chance = Chance5
    },
    {
        Frame = v26,
        Chance = Chance6
    }
};
local u40 = {
    [1] = {
        Button = v9,
        Price = Price
    },
    [3] = {
        Button = v10,
        Price = Price2
    },
    [10] = {
        Button = v11,
        Price = Price3
    },
    [50] = {
        Button = v12,
        Price = Price4
    }
};

local function closeSession() -- Line: 147
    -- upvalues: u3 (ref), u1 (copy)
    local v41 = u3;

    if v41 == nil then
        return;
    end;

    u3 = nil;
    v41:Destroy();
    u1:AtTrace():Log("Limited egg shop session closed");
end;

local function bindOffer(u42, u43) -- Line: 158
    -- upvalues: ButtonFX (copy), u2 (copy), PromptPurchase (copy), GetPrice (copy), u3 (ref)
    u42:Add(ButtonFX(u43.Button, nil, function() -- Line: 159
        -- upvalues: u2 (ref), PromptPurchase (ref), u43 (copy)
        u2(function() -- Line: 160
            -- upvalues: PromptPurchase (ref), u43 (ref)
            PromptPurchase.Prompt(u43.ProductId, true);
        end);
    end));
    u42:Add((task.spawn(function() -- Line: 165
        -- upvalues: GetPrice (ref), u43 (copy), u3 (ref), u42 (copy)
        local v44, v45 = GetPrice(u43.ProductId, true);

        if u3 ~= u42 then
            return;
        end;

        if v45 then
            u43.Price.Text = "" .. tostring(v44);

            return;
        end;

        u43.Price.Text = "Loading...";
    end)));
end;

local function openSession() -- Line: 179
    -- upvalues: u3 (ref), u1 (copy), Trove (copy), wcall (copy), ViewportSession (copy), Main (copy), u39 (copy), LimitedEgg (copy), HoverInfoSession (copy), InfoButton (copy), Info (copy), u40 (copy), Products (copy), Asserts (copy), bindOffer (copy)
    local v46 = u3;

    if v46 ~= nil then
        u3 = nil;
        v46:Destroy();
        u1:AtTrace():Log("Limited egg shop session closed");
    end;

    local u47 = Trove.new();
    u3 = u47;
    local v51, v52 = wcall(function() -- Line: 184
        -- upvalues: ViewportSession (ref), u47 (copy), Main (ref), u39 (ref), LimitedEgg (ref), HoverInfoSession (ref), InfoButton (ref), Info (ref), u40 (ref), Products (ref), Asserts (ref), bindOffer (ref)
        ViewportSession.Start(u47, Main, u39, LimitedEgg.Entries);
        HoverInfoSession.Start(u47, InfoButton, Info, u39, LimitedEgg.Entries);

        for _, v in ipairs(LimitedEgg.Offers) do
            local v48 = u40[v.Amount];
            local v49 = `LimitedEgg Buttons.{v.Amount} must contain Price and TextButton`;
            assert(v48 ~= nil, v49);
            local v50 = Products.Directory[v.ProductName];
            Asserts.number(v50.ProductId);
            bindOffer(u47, {
                Button = v48.Button,
                Price = v48.Price,
                ProductId = v50.ProductId
            });
        end;
    end);

    if not v51 then
        local v53 = u3;

        if v53 ~= nil then
            u3 = nil;
            v53:Destroy();
            u1:AtTrace():Log("Limited egg shop session closed");
        end;

        error(v52);
    end;

    u1:AtTrace():Log("Limited egg shop session opened");
end;

task.spawn(function() -- Line: 132, Name: applyPaidRandomItemPolicy
    -- upvalues: LimitedEgg2 (copy), wcall (copy), PolicyService (copy), LocalPlayer (copy), Asserts (copy)
    LimitedEgg2.Visible = false;
    local v54, u55 = wcall(function() -- Line: 135
        -- upvalues: PolicyService (ref), LocalPlayer (ref)
        return PolicyService:GetPolicyInfoForPlayerAsync(LocalPlayer).ArePaidRandomItemsRestricted;
    end);

    if v54 then
        wcall(function() -- Line: 140
            -- upvalues: Asserts (ref), u55 (copy), LimitedEgg2 (ref)
            Asserts.boolean(u55);
            LimitedEgg2.Visible = not u55;
        end);
    end;
end);
TabController.Opened:Connect(function(p56) -- Line: 214
    -- upvalues: openSession (copy)
    if p56 == "Shop" then
        openSession();
    end;
end);
TabController.Closed:Connect(function(p57) -- Line: 220
    -- upvalues: u3 (ref), u1 (copy)
    if p57 == "Shop" then
        local v58 = u3;

        if v58 == nil then
            return;
        end;

        u3 = nil;
        v58:Destroy();
        u1:AtTrace():Log("Limited egg shop session closed");
    end;
end);

if TabController.Get() == "Shop" then
    openSession();
end;