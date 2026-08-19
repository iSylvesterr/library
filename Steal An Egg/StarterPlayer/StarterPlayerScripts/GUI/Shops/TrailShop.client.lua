-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ButtonFX = require(ReplicatedStorage.Library.Client.GUIFX.ButtonFX);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local Simple = require(ReplicatedStorage.Library.Modules.FormatNumber.Simple);
local GUI = require(ReplicatedStorage.Library.Client.GUI);
local Network = require(ReplicatedStorage.Library.Client.Network);
local Message = require(ReplicatedStorage.Library.Client.NotificationCmds.Message);
local MonetizationGamepassUtil = require(ReplicatedStorage.Library.Util.MonetizationGamepassUtil);
local Products = require(ReplicatedStorage.Directory.Products);
local PromptPurchase = require(ReplicatedStorage.Library.Shared.Functions.PromptPurchase);
local Save = require(ReplicatedStorage.Library.Client.Save);
local Trails = require(ReplicatedStorage.Directory.Trails);
local TreadmillUtil = require(ReplicatedStorage.Library.Util.TreadmillUtil);
local GradientSwap = require(ReplicatedStorage.Library.Functions.GradientSwap);
local Trails2 = Constants.NETWORK_MAP.Trails;
local u1 = Color3.fromRGB(9, 255, 0);
local ScrollingFrame = GUI.TrailShop().Main.ShopContent.List.ScrollingFrame;
local Template = ScrollingFrame.Template;
local u2 = {};
local u3 = {};
local v4 = {};

local function refreshEntry(p5, p6) -- Line: 55
    -- upvalues: Save (copy), Simple (copy), Trails (copy), Products (copy)
    local v7 = Save.Get();
    assert(v7 ~= nil, "Expected local save data");
    local Label = p5.Buttons.CashBuy.Label;

    if v7.TrailInventory[p6] then
        Label.Text = v7.EquippedTrail == p6 and "Unequip" or "Equip";
    else
        Label.Text = `${Simple.FormatCompact(Trails.Directory[p6].Price, ".#")}`;
    end;

    local ProductId = Trails.Directory[p6].ProductId;
    local v8;

    if ProductId == nil or Products.DataByProductId[ProductId] == nil then
        v8 = false;
    else
        v8 = not v7.TrailInventory[p6];
    end;

    p5.Buttons.RobuxBuy.Visible = v8;
end;

local function showFailure(p9) -- Line: 72
    -- upvalues: Message (copy)
    Message.Bottom({
        Time = 3,
        Message = p9,
        Color = Color3.fromRGB(255, 64, 64)
    });
end;

local function bindShopEntry(u10, p11) -- Line: 80
    -- upvalues: Trails (copy), Template (copy), ScrollingFrame (copy), GradientSwap (copy), u1 (copy), TreadmillUtil (copy), u2 (copy), ButtonFX (copy), Save (copy), Network (copy), Trails2 (copy), Message (copy), refreshEntry (copy), Products (copy), PromptPurchase (copy), Constants (copy), u3 (copy), MonetizationGamepassUtil (copy), Simple (copy)
    local u12 = Trails.Directory[u10];
    local u13 = Template:Clone();
    u13.Name = u10;
    u13.LayoutOrder = p11;
    u13.Visible = true;
    u13.Parent = ScrollingFrame;
    u13.Title.Text = u12.DisplayName;
    u13.Rarity.Text = u12.Rarity.DisplayName;
    u12.Rarity.Gradient:Clone().Parent = u13.Rarity;
    GradientSwap(u13.Background, u12.Rarity.Gradient);
    u13.Icon.Image = u12.Icon;
    u13.Data.Boosts.RichText = true;
    u13.Data.Boosts.Text = `<font color="#{u1:ToHex()}">{TreadmillUtil.FormatSpeedMultiplierValue(u12.SpeedMultiplier)}</font> Speed`;
    local CashBuy = u13.Buttons.CashBuy;
    local RobuxBuy = u13.Buttons.RobuxBuy;
    u2[u10] = {
        RobuxPrice = nil,
        Frame = u13
    };
    ButtonFX(CashBuy, 1.05, function() -- Line: 102
        -- upvalues: Save (ref), u10 (copy), Network (ref), Trails2 (ref), Message (ref), refreshEntry (ref), u13 (copy)
        local v14 = Save.Get();
        assert(v14 ~= nil, "Expected local save data");
        local v15, v16;

        if v14.TrailInventory[u10] then
            if v14.EquippedTrail == u10 then
                v15, v16 = Network.Invoke(Trails2.REQUEST_UNEQUIP);
            else
                v15, v16 = Network.Invoke(Trails2.REQUEST_SELECT, u10);
            end;
        else
            v15, v16 = Network.Invoke(Trails2.REQUEST_PURCHASE, u10);
        end;

        if not v15 then
            Message.Bottom({
                Time = 3,
                Message = v16 or "Trail request failed",
                Color = Color3.fromRGB(255, 64, 64)
            });
        end;

        refreshEntry(u13, u10);
    end);
    ButtonFX(RobuxBuy, 1.05, function() -- Line: 121
        -- upvalues: u12 (copy), Products (ref), Message (ref), PromptPurchase (ref)
        local ProductId = u12.ProductId;

        if ProductId == nil or Products.DataByProductId[ProductId] == nil then
            Message.Bottom({
                Message = "This trail Robux product is not configured yet",
                Time = 3,
                Color = Color3.fromRGB(255, 64, 64)
            });

            return;
        end;

        PromptPurchase.Prompt(ProductId, true);
    end);

    if u12.ProductId ~= nil and Products.DataByProductId[u12.ProductId] ~= nil then
        RobuxBuy.Label.Text = Constants.ROBUX_ICON_STR;

        if not u3[u12.ProductId] then
            u3[u12.ProductId] = true;
            task.spawn(function() -- Line: 133
                -- upvalues: MonetizationGamepassUtil (ref), u12 (copy), u2 (ref), u10 (copy), RobuxBuy (copy), Constants (ref), Simple (ref)
                local v17 = MonetizationGamepassUtil.GetProductPriceInRobux(u12.ProductId);
                local v18 = u2[u10];

                if v18 ~= nil and v17 > 0 then
                    v18.RobuxPrice = v17;
                    RobuxBuy.Label.Text = `{Constants.ROBUX_ICON_STR} {Simple.FormatCompact(v17, ".#")}`;
                end;
            end);
        end;
    end;

    refreshEntry(u13, u10);
end;

Template.Visible = false;
Template.Parent = script;

if not Save.IsLocalDataLoaded() then
    Save.LoadedStats:Wait();
end;

local u19 = {};

for i, v in pairs(Trails.Directory) do
    if v.DisplayInShop then
        u19[#u19 + 1] = i;
    end;
end;

table.sort(u19, function(p20, p21) -- Line: 162
    -- upvalues: Trails (copy)
    return Trails.Directory[p20].Price < Trails.Directory[p21].Price;
end);

for i, v in ipairs(u19) do
    bindShopEntry(v, i);
end;

Save.ConnectForDataChanged({ "TrailInventory", "EquippedTrail" }, function() -- Line: 169
    -- upvalues: u19 (copy), ScrollingFrame (copy), refreshEntry (copy)
    for _, v in ipairs(u19) do
        local v22 = ScrollingFrame:FindFirstChild(v);
        local v23;

        if v22 == nil then
            v23 = false;
        else
            v23 = v22:IsA("Frame");
        end;

        local v24 = `Missing trail shop entry "{v}"`;
        assert(v23, v24);
        refreshEntry(v22, v);
    end;
end);

return v4;