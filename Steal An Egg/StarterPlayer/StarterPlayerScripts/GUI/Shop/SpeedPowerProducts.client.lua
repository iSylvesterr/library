-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ButtonFX = require(ReplicatedStorage.Library.Client.GUIFX.ButtonFX);
local GUI = require(ReplicatedStorage.Library.Client.GUI);
require(ReplicatedStorage.Library.Types.GUI);
local GetPrice = require(ReplicatedStorage.Library.Functions.GetPrice);
local Products = require(ReplicatedStorage.Directory.Products);
require(ReplicatedStorage.Directory.Products.Types.Interface);
local PromptPurchase = require(ReplicatedStorage.Library.Shared.Functions.PromptPurchase);
local Save = require(ReplicatedStorage.Library.Client.Save);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local Simple = require(ReplicatedStorage.Library.Modules.FormatNumber.Simple);
local TreadmillUtil = require(ReplicatedStorage.Library.Util.TreadmillUtil);
local v1 = {
    Products.Directory.SpeedPower_150000,
    Products.Directory.SpeedPower_1000000,
    Products.Directory.SpeedPower_10000000,
    Products.Directory.SpeedPower_50000000,
    Products.Directory.SpeedPower_500000000,
    Products.Directory.SpeedPower_1000000000
};
local v2 = { Products.Directory.TemporarySpeedBoost_10Minutes, Products.Directory.TemporarySpeedBoost_30Minutes, Products.Directory.TemporarySpeedBoost_1Hour };
local v3 = GUI.Shop();
local v4 = GUI.TreadmillSpeedShop();
local ScrollingFrame = v3.Frame.Main.ScrollingFrame;
local ScrollingFrame2 = v4.Frame.Main.ScrollingFrame;
local v5 = {
    {
        ScrollingFrame.SpeedTop["1"],
        ScrollingFrame.SpeedTop["2"],
        ScrollingFrame.SpeedTop["3"],
        ScrollingFrame.SpeedBottom["1"],
        ScrollingFrame.SpeedBottom["2"],
        ScrollingFrame.SpeedBottom["3"]
    },
    {
        ScrollingFrame2.SpeedTop["1"],
        ScrollingFrame2.SpeedTop["2"],
        ScrollingFrame2.SpeedTop["3"],
        ScrollingFrame2.SpeedBottom["1"],
        ScrollingFrame2.SpeedBottom["2"],
        ScrollingFrame2.SpeedBottom["3"]
    }
};
local v6 = { ScrollingFrame.TemporarySpeedBoosts["1"], ScrollingFrame.TemporarySpeedBoosts["2"], ScrollingFrame.TemporarySpeedBoosts["3"] };

local function updateProductPrice(u7, p8) -- Line: 70
    -- upvalues: GetPrice (copy), Constants (copy)
    if p8 == nil then
        u7.Text = "???";

        return;
    end;

    local ProductId = p8.ProductId;

    if ProductId <= 0 then
        u7.Text = "???";

        return;
    end;

    task.spawn(function() -- Line: 82
        -- upvalues: GetPrice (ref), ProductId (copy), u7 (copy), Constants (ref)
        local v9, v10 = GetPrice(ProductId, true);
        u7.Text = `{Constants.ROBUX_ICON_STR}{not v10 and "???" or tostring(v9)}`;
    end);
end;

local function bindSpeedPowerProductFrame(p11, u12, p13) -- Line: 88
    -- upvalues: GetPrice (copy), Constants (copy), Simple (copy), ButtonFX (copy), PromptPurchase (copy)
    local Price = p11.Buy.Price;

    if u12 == nil then
        Price.Text = "???";
    else
        local ProductId = u12.ProductId;

        if ProductId <= 0 then
            Price.Text = "???";
        else
            task.spawn(function() -- Line: 82
                -- upvalues: GetPrice (ref), ProductId (copy), Price (copy), Constants (ref)
                local v14, v15 = GetPrice(ProductId, true);
                Price.Text = `{Constants.ROBUX_ICON_STR}{not v15 and "???" or tostring(v14)}`;
            end);
        end;
    end;

    p11.Title.Text = `<font color="#{p13:ToHex()}">+{Simple.FormatCompact(u12.SpeedPowerReward, ".#")}</font> SPEED`;
    ButtonFX(p11.Buy, nil, function() -- Line: 98
        -- upvalues: PromptPurchase (ref), u12 (copy)
        PromptPurchase.Prompt(u12.ProductId, true);
    end);
end;

local function bindTemporarySpeedBoostProductFrame(p16, u17) -- Line: 103
    -- upvalues: GetPrice (copy), Constants (copy), TreadmillUtil (copy), ButtonFX (copy), PromptPurchase (copy)
    local Price = p16.Buy.Price;

    if u17 == nil then
        Price.Text = "???";
    else
        local ProductId = u17.ProductId;

        if ProductId <= 0 then
            Price.Text = "???";
        else
            task.spawn(function() -- Line: 82
                -- upvalues: GetPrice (ref), ProductId (copy), Price (copy), Constants (ref)
                local v18, v19 = GetPrice(ProductId, true);
                Price.Text = `{Constants.ROBUX_ICON_STR}{not v19 and "???" or tostring(v18)}`;
            end);
        end;
    end;

    p16.Title.Text = TreadmillUtil.FormatTemporarySpeedBoostProductDuration(u17.TemporarySpeedBoostDurationSeconds);
    ButtonFX(p16.Buy, nil, function() -- Line: 111
        -- upvalues: PromptPurchase (ref), u17 (copy)
        PromptPurchase.Prompt(u17.ProductId, true);
    end);
end;

if not Save.IsLocalDataLoaded() then
    Save.LoadedStats:Wait();
end;

for _, v in ipairs(v5) do
    for i, v7 in ipairs(v) do
        bindSpeedPowerProductFrame(v7, v1[i], i <= 3 and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 200, 0));
    end;
end;

for i, v in ipairs(v6) do
    bindTemporarySpeedBoostProductFrame(v, v2[i]);
end;