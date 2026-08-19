-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ButtonFX = require(ReplicatedStorage.Library.Client.GUIFX.ButtonFX);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
require(ReplicatedStorage.Library.Modules.DefaultStats.Types.Interface);
local Simple = require(ReplicatedStorage.Library.Modules.FormatNumber.Simple);
local GetPrice = require(ReplicatedStorage.Library.Functions.GetPrice);
local GUI = require(ReplicatedStorage.Library.Client.GUI);
require(ReplicatedStorage.Library.Types.GUI);
local Products = require(ReplicatedStorage.Directory.Products);
local Save = require(ReplicatedStorage.Library.Client.Save);
local TabController = require(ReplicatedStorage.Library.Client.TabController);
local Client = require(script.Parent.Parent.TreadmillUpgrade.Client);
local Treadmills = require(ReplicatedStorage.Directory.Treadmills);
local u1 = Color3.new(0.760784, 0, 0);
local ScrollingFrame = GUI.TreadmillSpeedShop().Frame.Main.ScrollingFrame;
local Button = GUI.SideButtonTools().TreadmillSpeedShop.Button;
local UpgradeTreadmill = ScrollingFrame.UpgradeTreadmill;
local Pack = UpgradeTreadmill.Pack;
local v2 = nil;

for _, child in ipairs(Pack:GetChildren()) do
    if child.Name == "Frame" and child:IsA("Frame") then
        assert(v2 == nil, "Treadmill speed shop Pack must contain one button Frame");
        v2 = child;
    end;
end;

assert(v2 ~= nil, "Treadmill speed shop Pack.Frame button container is required");
local RobuxUpgrade = v2.RobuxUpgrade;
local Upgrade = v2.Upgrade;
local BackgroundColor3 = Upgrade.BackgroundColor3;
local u3 = Upgrade:FindFirstChildOfClass("UIGradient");
local u4;

if u3 == nil then
    u4 = false;
else
    u4 = u3.Enabled;
end;

local u5 = 0;

local function getLoadedData() -- Line: 57
    -- upvalues: Save (copy)
    local v6 = Save.Get();
    assert(v6 ~= nil, "Treadmill speed shop requires loaded player data");

    return v6;
end;

local function updateRobuxUpgradePrice(u7, u8) -- Line: 63
    -- upvalues: RobuxUpgrade (copy), Constants (copy), GetPrice (copy), u5 (ref), Simple (copy)
    RobuxUpgrade.Cost.Text = Constants.ROBUX_ICON_STR;
    task.spawn(function() -- Line: 65
        -- upvalues: GetPrice (ref), u7 (copy), u8 (copy), u5 (ref), RobuxUpgrade (ref), Constants (ref), Simple (ref)
        local v9, v10 = GetPrice(u7, true);

        if u8 ~= u5 then
            return;
        end;

        RobuxUpgrade.Cost.Text = `{Constants.ROBUX_ICON_STR} {not v10 and "???" or Simple.FormatCompact(v9, ".#")}`;
    end);
end;

local function refreshUpgrade(p11, u12) -- Line: 76
    -- upvalues: Treadmills (copy), Pack (copy), Client (copy), UpgradeTreadmill (copy), Upgrade (copy), Simple (copy), BackgroundColor3 (copy), u1 (copy), u3 (copy), u4 (copy), RobuxUpgrade (copy), Products (copy), Constants (copy), GetPrice (copy), u5 (ref)
    local v13 = Treadmills.GetByUpgradeLevel(p11.TreadmillUpgradeLevel);
    local v14 = `Invalid current treadmill level {p11.TreadmillUpgradeLevel}`;
    assert(v13 ~= nil, v14);
    Pack.TreadmillIconCurrent.Image = v13.Icon;
    local _, v15 = Client.GetNextConfig(p11);

    if v15 == nil then
        UpgradeTreadmill.Visible = false;

        return;
    end;

    UpgradeTreadmill.Visible = true;
    Pack.TreadmillIconNext.Image = v15.Icon;
    Upgrade.Cost.Text = "$" .. Simple.FormatCompact(v15.Price, ".#");
    local v16 = Client.CanAffordNext(p11);
    local v17;

    if v16 then
        v17 = BackgroundColor3;
    else
        v17 = u1;
    end;

    Upgrade.BackgroundColor3 = v17;

    if u3 ~= nil then
        if v16 then
            v16 = u4;
        end;

        u3.Enabled = v16;
    end;

    local ProductId = v15.ProductId;
    local v18;

    if ProductId == nil then
        v18 = false;
    else
        v18 = Products.DataByProductId[ProductId] ~= nil;
    end;

    RobuxUpgrade.Visible = v18;

    if ProductId ~= nil and RobuxUpgrade.Visible then
        RobuxUpgrade.Cost.Text = Constants.ROBUX_ICON_STR;
        task.spawn(function() -- Line: 65
            -- upvalues: GetPrice (ref), ProductId (copy), u12 (copy), u5 (ref), RobuxUpgrade (ref), Constants (ref), Simple (ref)
            local v19, v20 = GetPrice(ProductId, true);

            if u12 ~= u5 then
                return;
            end;

            RobuxUpgrade.Cost.Text = `{Constants.ROBUX_ICON_STR} {not v20 and "???" or Simple.FormatCompact(v19, ".#")}`;
        end);
    end;
end;

local function refreshShop() -- Line: 105
    -- upvalues: u5 (ref), Save (copy), refreshUpgrade (copy)
    u5 = u5 + 1;
    local v21 = Save.Get();
    assert(v21 ~= nil, "Treadmill speed shop requires loaded player data");
    refreshUpgrade(v21, u5);
end;

if not Save.IsLocalDataLoaded() then
    Save.LoadedStats:Wait();
end;

ButtonFX(Button, nil, function() -- Line: 120
    -- upvalues: TabController (copy)
    TabController.ToggleTab("TreadmillSpeedShop");
end);
ButtonFX(Upgrade, nil, Client.RequestCashUpgrade);
ButtonFX(RobuxUpgrade, nil, Client.PromptRobuxUpgrade);
TabController.Opened:Connect(function(p22) -- Line: 128
    -- upvalues: u5 (ref), Save (copy), refreshUpgrade (copy)
    if p22 == "TreadmillSpeedShop" then
        u5 = u5 + 1;
        local v23 = Save.Get();
        assert(v23 ~= nil, "Treadmill speed shop requires loaded player data");
        refreshUpgrade(v23, u5);
    end;
end);
Save.GetStatChangedSignal("TreadmillUpgradeLevel"):Connect(function() -- Line: 134
    -- upvalues: TabController (copy), u5 (ref), Save (copy), refreshUpgrade (copy)
    if TabController.IsOpen("TreadmillSpeedShop") then
        u5 = u5 + 1;
        local v24 = Save.Get();
        assert(v24 ~= nil, "Treadmill speed shop requires loaded player data");
        refreshUpgrade(v24, u5);
    end;
end);
Save.GetStatChangedSignal("Money"):Connect(function() -- Line: 140
    -- upvalues: TabController (copy), u5 (ref), Save (copy), refreshUpgrade (copy)
    if TabController.IsOpen("TreadmillSpeedShop") then
        u5 = u5 + 1;
        local v25 = Save.Get();
        assert(v25 ~= nil, "Treadmill speed shop requires loaded player data");
        refreshUpgrade(v25, u5);
    end;
end);
u5 = u5 + 1;
local v26 = Save.Get();
assert(v26 ~= nil, "Treadmill speed shop requires loaded player data");
refreshUpgrade(v26, u5);