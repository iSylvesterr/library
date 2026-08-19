-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local AssetCmds = require(ReplicatedStorage.Library.Client.AssetCmds);
local HideImportantUI = require(ReplicatedStorage.Library.Client.HideImportantUI);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local Player = require(ReplicatedStorage.Library.Player);
local PlayerMoneyPerSecondUtil = require(ReplicatedStorage.Library.Util.PlayerMoneyPerSecondUtil);
local PlotCmds = require(ReplicatedStorage.Library.Client.PlotCmds);
local Save = require(ReplicatedStorage.Library.Client.Save);
local Simple = require(ReplicatedStorage.Library.Modules.FormatNumber.Simple);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local OFFLINE_ASSETS = Constants.OFFLINE_ASSETS;
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local v1 = PlayerGui:IsA("PlayerGui");
assert(v1, "Expected PlayerGui");
local OfflineMoneyInPlot = PlayerGui:WaitForChild("OfflineMoneyInPlot");
local v2 = OfflineMoneyInPlot:IsA("ScreenGui");
assert(v2, "OfflineMoneyInPlot must be a ScreenGui");
local TopBar = OfflineMoneyInPlot:WaitForChild("TopBar");
local v3 = TopBar:IsA("GuiObject");
assert(v3, "OfflineMoneyInPlot.TopBar must be a GuiObject");
local InPlot = TopBar:WaitForChild("InPlot");
local v4 = InPlot:IsA("GuiObject");
assert(v4, "OfflineMoneyInPlot.TopBar.InPlot must be a GuiObject");
local TextLabel = InPlot:WaitForChild("TextLabel");
local v5 = TextLabel:IsA("TextLabel");
assert(v5, "OfflineMoneyInPlot.TopBar.InPlot.TextLabel must be a TextLabel");
local v6 = Trove.new();
local u7 = 0;
local u8 = nil;

local function formatOfflineAmount(p9) -- Line: 47
    -- upvalues: Simple (copy)
    return Simple.FormatCompact((math.max(p9, 0)));
end;

local function getOfflinePreviewAmountFromTotalRate(p10) -- Line: 51
    -- upvalues: OFFLINE_ASSETS (copy)
    return math.max(p10, 0) * OFFLINE_ASSETS.MAX_DURATION_SECONDS * OFFLINE_ASSETS.MONEY_RATE_MULTIPLIER;
end;

local function updateText() -- Line: 57
    -- upvalues: TextLabel (copy), formatOfflineAmount (copy), u7 (ref), OFFLINE_ASSETS (copy)
    TextLabel.RichText = true;
    TextLabel.Text = string.format("You earn <font color = \"#00ff00\">$%s</font>/Day offline! 😈", formatOfflineAmount(math.max(u7, 0) * OFFLINE_ASSETS.MAX_DURATION_SECONDS * OFFLINE_ASSETS.MONEY_RATE_MULTIPLIER));
end;

local function isWorldPositionInsideScaledPetAreaXZ(p11) -- Line: 65
    -- upvalues: AssetCmds (copy), LocalPlayer (copy)
    local v12 = AssetCmds.ResolveAssetArea(LocalPlayer);

    if v12 == nil then
        return false;
    end;

    local v13 = v12.CFrame:PointToObjectSpace(p11);
    local v14 = v12.Size.X * 0.74 * 0.5;
    local v15 = v12.Size.Z * 0.74 * 0.5;
    local v16;

    if math.abs(v13.X) <= v14 then
        v16 = math.abs(v13.Z) <= v15;
    else
        v16 = false;
    end;

    return v16;
end;

local function refreshRateFromSave() -- Line: 78
    -- upvalues: Save (copy), u7 (ref), PlayerMoneyPerSecondUtil (copy), LocalPlayer (copy), TextLabel (copy), formatOfflineAmount (copy), OFFLINE_ASSETS (copy), u8 (ref)
    local v17 = Save.Get();
    u7 = v17 == nil and 0 or PlayerMoneyPerSecondUtil.GetTotalForProfile(LocalPlayer, v17);
    TextLabel.RichText = true;
    TextLabel.Text = string.format("You earn <font color = \"#00ff00\">$%s</font>/Day offline! 😈", formatOfflineAmount(math.max(u7, 0) * OFFLINE_ASSETS.MAX_DURATION_SECONDS * OFFLINE_ASSETS.MONEY_RATE_MULTIPLIER));
    u8();
end;

u8 = function() -- Line: 87, Name: updateVisibility
    -- upvalues: Player (copy), LocalPlayer (copy), HideImportantUI (copy), u7 (ref), isWorldPositionInsideScaledPetAreaXZ (copy), OfflineMoneyInPlot (copy)
    local v18 = Player.Optional.HumanoidRootPart(LocalPlayer);
    local v19 = not HideImportantUI:IsLocked();

    if v19 then
        if u7 > 1000 and v18 ~= nil then
            v19 = isWorldPositionInsideScaledPetAreaXZ(v18.Position);
        else
            v19 = false;
        end;
    end;

    OfflineMoneyInPlot.Enabled = v19;
end;

TextLabel.RichText = true;
OfflineMoneyInPlot.Enabled = false;
local v20 = Save.Get();

if v20 == nil then
    u7 = 0;
else
    u7 = PlayerMoneyPerSecondUtil.GetTotalForProfile(LocalPlayer, v20);
end;

TextLabel.RichText = true;
TextLabel.Text = string.format("You earn <font color = \"#00ff00\">$%s</font>/Day offline! 😈", formatOfflineAmount(math.max(u7, 0) * OFFLINE_ASSETS.MAX_DURATION_SECONDS * OFFLINE_ASSETS.MONEY_RATE_MULTIPLIER));
u8();
u8();
v6:Add(Save.ConnectForDataChanged({ "EquippedAssets", "Inventory", "Rebirth", "Gamepasses", "Products" }, refreshRateFromSave));
v6:Add(Save.LoadedStats:Connect(function(p21) -- Line: 112
    -- upvalues: LocalPlayer (copy), Save (copy), u7 (ref), PlayerMoneyPerSecondUtil (copy), TextLabel (copy), formatOfflineAmount (copy), OFFLINE_ASSETS (copy), u8 (ref)
    if p21 == LocalPlayer then
        local v22 = Save.Get();
        u7 = v22 == nil and 0 or PlayerMoneyPerSecondUtil.GetTotalForProfile(LocalPlayer, v22);
        TextLabel.RichText = true;
        TextLabel.Text = string.format("You earn <font color = \"#00ff00\">$%s</font>/Day offline! 😈", formatOfflineAmount(math.max(u7, 0) * OFFLINE_ASSETS.MAX_DURATION_SECONDS * OFFLINE_ASSETS.MONEY_RATE_MULTIPLIER));
        u8();
    end;
end));
v6:Add(PlotCmds.OnLocalPlotUpdated:Connect(u8));
v6:Connect(RunService.Heartbeat, u8);