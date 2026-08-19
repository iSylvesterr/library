-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local BaseUpgradeClient = require(ReplicatedStorage.Library.Client.BaseUpgradeClient);
local ButtonFX = require(ReplicatedStorage.Library.Client.GUIFX.ButtonFX);
local Simple = require(ReplicatedStorage.Library.Modules.FormatNumber.Simple);
local GetOrCreateUIScale = require(ReplicatedStorage.Library.Functions.GetOrCreateUIScale);
require(ReplicatedStorage.Library.Types.GUI);
local LocalPlotUpgradeVisibility = require(ReplicatedStorage.Library.Client.LocalPlotUpgradeVisibility);
local PlotCmds = require(ReplicatedStorage.Library.Client.PlotCmds);
local Products = require(ReplicatedStorage.Directory.Products);
require(ReplicatedStorage.Directory.Products.Types.Interface);
local PromptPurchase = require(ReplicatedStorage.Library.Shared.Functions.PromptPurchase);
local Save = require(ReplicatedStorage.Library.Client.Save);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local u1 = Color3.new(0.760784, 0, 0);
local u2 = TweenInfo.new(0.65, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true);
local PlotUpgrade = ReplicatedStorage.Assets.UI.PlotUpgrade;
local FirstUpgradeInfo = PlotUpgrade.FirstUpgradeInfo;
local v3 = FirstUpgradeInfo:IsA("Frame");
assert(v3, "PlotUpgrade.FirstUpgradeInfo template must be a Frame");
local FirstUpgrade = PlotUpgrade.FirstUpgrade;
local v4 = FirstUpgrade:IsA("ImageButton");
assert(v4, "PlotUpgrade.FirstUpgrade template must be an ImageButton");
local u5 = nil;
local u6 = nil;
local u7 = nil;

local function getProductForLevel(p8) -- Line: 43
    -- upvalues: Products (copy)
    local v9 = `BaseUpgradeTier{p8}`;

    if Products.Types.ProductNameExists(v9) then
        return Products.Directory[v9];
    end;

    return nil;
end;

local function refreshPlotUpgradeVisibility() -- Line: 49
    -- upvalues: LocalPlotUpgradeVisibility (copy)
    LocalPlotUpgradeVisibility.Refresh("PlotUpgrade");
end;

local function bindLocalPlot() -- Line: 53
    -- upvalues: u5 (ref), PlotCmds (copy), u6 (ref), u7 (ref), Trove (copy), FirstUpgradeInfo (copy), FirstUpgrade (copy), GetOrCreateUIScale (copy), TweenService (copy), u2 (copy), Save (copy), BaseUpgradeClient (copy), u1 (copy), Simple (copy), ButtonFX (copy), Products (copy), PromptPurchase (copy)
    if u5 ~= nil then
        u5:Destroy();
        u5 = nil;
    end;

    local v10 = PlotCmds.GetPlotData();

    if v10 == nil then
        return;
    end;

    local PlotFolder = v10.PlotFolder;
    local v11 = PlotFolder:IsA("Model");
    assert(v11, "Local plot folder must be a Model");
    local PlotUpgrade2 = PlotFolder:WaitForChild("PlotUpgrade");
    local v12 = PlotUpgrade2:IsA("Model");
    assert(v12, "PlotUpgrade must be a Model");
    local Sign = PlotUpgrade2.Sign;
    local v13 = Sign:IsA("BasePart");
    assert(v13, "PlotUpgrade.Sign must be a BasePart");
    local CanUpgrade = Sign.CanUpgrade;
    local v14 = CanUpgrade:IsA("BillboardGui");
    assert(v14, "PlotUpgrade.Sign.CanUpgrade must be a BillboardGui");
    local SurfaceGui = Sign.SurfaceGui;
    local v15 = SurfaceGui:IsA("SurfaceGui");
    assert(v15, "PlotUpgrade.Sign.SurfaceGui must be a SurfaceGui");
    local Info = SurfaceGui.Info;
    local v16 = Info:IsA("TextLabel");
    assert(v16, "PlotUpgrade.Sign.SurfaceGui.Info must be a TextLabel");
    local Level = SurfaceGui.Level;
    local v17 = Level:IsA("TextLabel");
    assert(v17, "PlotUpgrade.Sign.SurfaceGui.Level must be a TextLabel");
    local Frame = SurfaceGui.Frame;
    local v18 = Frame:IsA("GuiObject");
    assert(v18, "PlotUpgrade.Sign.SurfaceGui.Frame must be a GuiObject");
    local Upgrade = Frame.Upgrade;
    local v19 = Upgrade:IsA("GuiButton");
    assert(v19, "Plot Upgrade must be a GuiButton");
    local RobuxUpgrade = Frame.RobuxUpgrade;
    local v20 = RobuxUpgrade:IsA("GuiButton");
    assert(v20, "Plot RobuxUpgrade must be a GuiButton");
    local Cost = Upgrade.Cost;
    local v21 = Cost:IsA("TextLabel");
    assert(v21, "Plot Upgrade.Cost must be a TextLabel");
    local u22 = Upgrade:FindFirstChildOfClass("UIGradient");

    if u6 == nil then
        u6 = Upgrade.BackgroundColor3;
    end;

    if u22 ~= nil and u7 == nil then
        u7 = u22.Enabled;
    end;

    local u23 = assert(u6, "Plot Upgrade authored background color must be initialized");
    Upgrade.AutoButtonColor = false;
    local v24 = Trove.new();
    local u25 = FirstUpgradeInfo:Clone();
    local Icon = u25.Icon;
    local v26 = Icon:IsA("ImageLabel");
    assert(v26, "Plot FirstUpgradeInfo.Icon must be an ImageLabel");
    local u27 = FirstUpgrade:Clone();
    local Cost2 = u27.Cost;
    local v28 = Cost2:IsA("TextLabel");
    assert(v28, "Plot FirstUpgrade.Cost must be a TextLabel");
    local ProgressFill = u27.ProgressFill;
    local v29 = ProgressFill:IsA("Frame");
    assert(v29, "Plot FirstUpgrade.ProgressFill must be a Frame");
    local UIGradient = u27.UIGradient;
    local v30 = UIGradient:IsA("UIGradient");
    assert(v30, "Plot FirstUpgrade button gradient must be a UIGradient");
    local BackgroundColor3 = u27.BackgroundColor3;
    local Enabled = UIGradient.Enabled;
    local Size = ProgressFill.Size;
    u25.Visible = false;
    u25.Parent = SurfaceGui;
    v24:Add(u25);
    local v31 = GetOrCreateUIScale(Icon);
    v31.Scale = 0.8;
    local v32 = TweenService:Create(v31, u2, {
        Scale = 1.3
    });
    v24:Add(v32);
    v32:Play();
    u27.Visible = false;
    u27.AutoButtonColor = false;
    u27.Parent = Frame;
    v24:Add(u27);
    u5 = v24;

    local function refresh() -- Line: 128
        -- upvalues: Save (ref), Info (copy), Level (copy), u25 (copy), Upgrade (copy), u27 (copy), BaseUpgradeClient (ref), CanUpgrade (copy), u23 (copy), u1 (ref), u22 (copy), u7 (ref), BackgroundColor3 (copy), UIGradient (copy), Enabled (copy), Cost (copy), RobuxUpgrade (copy), Simple (ref), Cost2 (copy), ProgressFill (copy), Size (copy)
        local v33 = Save.Get();
        assert(v33 ~= nil, "Plot upgrade UI requires loaded data");
        local v34 = v33.BaseUpgradeLevel == 0;
        Info.Visible = not v34;
        Level.Visible = not v34;
        u25.Visible = v34;
        Upgrade.Visible = not v34;
        u27.Visible = v34;
        local v35, v36 = BaseUpgradeClient.GetNextConfig(v33);
        local v37 = BaseUpgradeClient.CanAffordNext(v33);
        CanUpgrade.Enabled = v37;
        local v38;

        if v37 then
            v38 = u23;
        else
            v38 = u1;
        end;

        Upgrade.BackgroundColor3 = v38;

        if u22 ~= nil then
            local v39;

            if v37 then
                v39 = u7 == true;
            else
                v39 = v37;
            end;

            u22.Enabled = v39;
        end;

        local v40;

        if v37 then
            v40 = BackgroundColor3;
        else
            v40 = u1;
        end;

        u27.BackgroundColor3 = v40;

        if v37 then
            v37 = Enabled;
        end;

        UIGradient.Enabled = v37;

        if v35 == nil or v36 == nil then
            Level.Text = "Level MAX";
            Cost.Text = "MAX";
            RobuxUpgrade.Visible = false;

            return;
        end;

        Level.Text = `Level {v33.BaseUpgradeLevel} > Level {v35}`;
        local v41 = "$" .. Simple.FormatCompact(v36.Cost, ".#");
        Cost.Text = v41;
        Cost2.Text = v41;
        assert(v36.Cost > 0, "Plot upgrade cost must be positive");
        local v42 = math.clamp(v33.Money / v36.Cost, 0, 1);
        ProgressFill.Size = UDim2.new(v42, Size.X.Offset, Size.Y.Scale, Size.Y.Offset);
        RobuxUpgrade.Visible = false;
    end;

    v24:Add(ButtonFX(Upgrade, 1.05, BaseUpgradeClient.RequestCashUpgrade));
    v24:Add(ButtonFX(u27, 1.05, BaseUpgradeClient.RequestCashUpgrade));
    v24:Add(ButtonFX(RobuxUpgrade, 1.05, function() -- Line: 186
        -- upvalues: Save (ref), BaseUpgradeClient (ref), Products (ref), PromptPurchase (ref)
        local v43 = Save.Get();
        assert(v43 ~= nil, "Plot Robux upgrade requires loaded data");
        local v44, v45 = BaseUpgradeClient.GetNextConfig(v43);

        if v44 == nil or v45 == nil then
            return;
        end;

        local v46 = `BaseUpgradeTier{v44}`;
        local v47;

        if Products.Types.ProductNameExists(v46) then
            v47 = Products.Directory[v46];
        else
            v47 = nil;
        end;

        if v47 ~= nil then
            PromptPurchase.Prompt(v47.ProductId, true);
        end;
    end));
    v24:Add(Save.GetStatChangedSignal("BaseUpgradeLevel"):Connect(refresh));
    v24:Add(Save.GetStatChangedSignal("Money"):Connect(refresh));
    refresh();
end;

if not Save.IsLocalDataLoaded() then
    Save.LoadedStats:Wait();
end;

bindLocalPlot();
LocalPlotUpgradeVisibility.Refresh("PlotUpgrade");
PlotCmds.OnLocalPlotUpdated:Connect(function() -- Line: 212
    -- upvalues: bindLocalPlot (copy), LocalPlotUpgradeVisibility (copy)
    bindLocalPlot();
    LocalPlotUpgradeVisibility.Refresh("PlotUpgrade");
end);
PlotCmds.OnAnyPlotUpdated:Connect(refreshPlotUpgradeVisibility);
PlotCmds.OnPlotsFolderUpdated:Connect(refreshPlotUpgradeVisibility);