-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ButtonFX = require(ReplicatedStorage.Library.Client.GUIFX.ButtonFX);
local Simple = require(ReplicatedStorage.Library.Modules.FormatNumber.Simple);
require(ReplicatedStorage.Library.Types.GUI);
local MonetizationGamepassUtil = require(ReplicatedStorage.Library.Util.MonetizationGamepassUtil);
local PlotCmds = require(ReplicatedStorage.Library.Client.PlotCmds);
local Products = require(ReplicatedStorage.Directory.Products);
local Save = require(ReplicatedStorage.Library.Client.Save);
local Client = require(script.Client);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local u1 = Color3.new(0.760784, 0, 0);
local u2 = nil;
local u3 = 0;

local function bindLocalPlot() -- Line: 29
    -- upvalues: u3 (ref), u2 (ref), PlotCmds (copy), Trove (copy), Save (copy), Client (copy), u1 (copy), Simple (copy), Products (copy), MonetizationGamepassUtil (copy), ButtonFX (copy)
    u3 = u3 + 1;
    local u4 = u3;

    if u2 ~= nil then
        u2:Destroy();
        u2 = nil;
    end;

    local v5 = PlotCmds.GetPlotData();

    if v5 == nil then
        return;
    end;

    local PlotFolder = v5.PlotFolder;
    local v6 = PlotFolder:IsA("Model");
    assert(v6, "Local plot folder must be a Model");
    local TreadmillUpgrade = PlotFolder:WaitForChild("TreadmillUpgrade");
    local v7 = TreadmillUpgrade:IsA("Model");
    assert(v7, "TreadmillUpgrade must be a Model");
    local Sign = TreadmillUpgrade.Sign;
    local v8 = Sign:IsA("BasePart");
    assert(v8, "TreadmillUpgrade.Sign must be a BasePart");
    local CanUpgrade = Sign.CanUpgrade;
    local v9 = CanUpgrade:IsA("BillboardGui");
    assert(v9, "TreadmillUpgrade.Sign.CanUpgrade must be a BillboardGui");
    local SurfaceGui = Sign.SurfaceGui;
    local v10 = SurfaceGui:IsA("SurfaceGui");
    assert(v10, "TreadmillUpgrade.Sign.SurfaceGui must be a SurfaceGui");
    local Level = SurfaceGui.Level;
    local v11 = Level:IsA("TextLabel");
    assert(v11, "TreadmillUpgrade.Sign.SurfaceGui.Level must be a TextLabel");
    local Frame = SurfaceGui.Frame;
    local v12 = Frame:IsA("GuiObject");
    assert(v12, "TreadmillUpgrade.Sign.SurfaceGui.Frame must be a GuiObject");
    local Upgrade = Frame.Upgrade;
    local v13 = Upgrade:IsA("GuiButton");
    assert(v13, "Treadmill Upgrade must be a GuiButton");
    local RobuxUpgrade = Frame.RobuxUpgrade;
    local v14 = RobuxUpgrade:IsA("GuiButton");
    assert(v14, "Treadmill RobuxUpgrade must be a GuiButton");
    local Cost = Upgrade.Cost;
    local v15 = Cost:IsA("TextLabel");
    assert(v15, "Treadmill Upgrade.Cost must be a TextLabel");
    local Cost2 = RobuxUpgrade.Cost;
    local v16 = Cost2:IsA("TextLabel");
    assert(v16, "Treadmill RobuxUpgrade.Cost must be a TextLabel");
    local BackgroundColor3 = Upgrade.BackgroundColor3;
    local u17 = Upgrade:FindFirstChildOfClass("UIGradient");
    local u18;

    if u17 == nil then
        u18 = false;
    else
        u18 = u17.Enabled;
    end;

    local u19 = Trove.new();
    u2 = u19;
    u19:Add(function() -- Line: 69
        -- upvalues: Upgrade (copy), BackgroundColor3 (copy), u17 (copy), u18 (copy)
        Upgrade.BackgroundColor3 = BackgroundColor3;

        if u17 ~= nil then
            u17.Enabled = u18;
        end;
    end);

    local function refresh() -- Line: 75
        -- upvalues: Save (ref), Client (ref), CanUpgrade (copy), Upgrade (copy), BackgroundColor3 (copy), u1 (ref), u17 (copy), u18 (copy), Level (copy), Cost (copy), RobuxUpgrade (copy), Simple (ref), Products (ref), Cost2 (copy), MonetizationGamepassUtil (ref), u4 (copy), u3 (ref), u2 (ref), u19 (copy)
        local v20 = Save.Get();
        assert(v20 ~= nil, "Treadmill upgrade UI requires loaded data");
        local v21, v22 = Client.GetNextConfig(v20);
        local v23 = Client.CanAffordNext(v20);
        local v24;

        if v20.BaseUpgradeLevel > 0 then
            v24 = v23;
        else
            v24 = false;
        end;

        CanUpgrade.Enabled = v24;
        local v25;

        if v23 then
            v25 = BackgroundColor3;
        else
            v25 = u1;
        end;

        Upgrade.BackgroundColor3 = v25;

        if u17 ~= nil then
            if v23 then
                v23 = u18;
            end;

            u17.Enabled = v23;
        end;

        if v22 == nil then
            Level.Text = "Level MAX";
            Cost.Text = "MAX";
            RobuxUpgrade.Visible = false;

            return;
        end;

        Level.Text = `Level {v20.TreadmillUpgradeLevel} > Level {v21}`;
        Cost.Text = "$" .. Simple.FormatCompact(v22.Price, ".#");
        local ProductId = v22.ProductId;
        local v26;

        if ProductId == nil then
            v26 = false;
        else
            v26 = Products.DataByProductId[ProductId] ~= nil;
        end;

        RobuxUpgrade.Visible = v26;
        Cost2.Text = "";

        if ProductId ~= nil and RobuxUpgrade.Visible then
            task.spawn(function() -- Line: 100
                -- upvalues: MonetizationGamepassUtil (ref), ProductId (copy), u4 (ref), u3 (ref), u2 (ref), u19 (ref), Cost2 (ref), Simple (ref)
                local v27 = MonetizationGamepassUtil.GetProductPriceInRobux(ProductId);

                if u4 == u3 and (u2 == u19 and v27 > 0) then
                    Cost2.Text = ` {Simple.FormatCompact(v27, ".#")}`;
                end;
            end);
        end;
    end;

    u19:Add(ButtonFX(Upgrade, 1.05, Client.RequestCashUpgrade));
    u19:Add(ButtonFX(RobuxUpgrade, 1.05, Client.PromptRobuxUpgrade));
    u19:Add(Save.GetStatChangedSignal("TreadmillUpgradeLevel"):Connect(refresh));
    u19:Add(Save.GetStatChangedSignal("BaseUpgradeLevel"):Connect(refresh));
    u19:Add(Save.GetStatChangedSignal("Money"):Connect(refresh));
    refresh();
end;

if not Save.IsLocalDataLoaded() then
    Save.LoadedStats:Wait();
end;

bindLocalPlot();
PlotCmds.OnLocalPlotUpdated:Connect(bindLocalPlot);