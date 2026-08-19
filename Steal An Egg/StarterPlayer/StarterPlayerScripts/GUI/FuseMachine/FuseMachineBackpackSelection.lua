-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local AssetIconShape = require(ReplicatedStorage.Library.Client.UI.AssetIconShape);
local AutoGridLayout = require(ReplicatedStorage.Library.Client.AutoGridLayout);
local AssetGenerationUtil = require(ReplicatedStorage.Library.Util.AssetGenerationUtil);
local AssetItemSerialization = require(ReplicatedStorage.Library.Util.AssetItemSerialization);
require(ReplicatedStorage.Library.Types.AssetItem);
local AssetItemUtil = require(ReplicatedStorage.Library.Util.AssetItemUtil);
local Directory = require(ReplicatedStorage.Directory.Assets).Directory;
local ButtonFX = require(ReplicatedStorage.Library.Client.GUIFX.ButtonFX);
local FuseKernelUtil = require(ReplicatedStorage.Library.Util.FuseKernelUtil);
require(ReplicatedStorage.Library.Types.FuseMachine);
local ItemDisplay = require(ReplicatedStorage.Library.Modules.ItemDisplay);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Mutations = require(ReplicatedStorage.Library.Modules.Mutations);
require(ReplicatedStorage.Library.Client.Save);
local ScreenResolution = require(ReplicatedStorage.Library.Client.ScreenResolution);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local u1 = Log.new();
local u2 = {};
u2.__index = u2;
u2.__class = "FuseMachineBackpackSelection";
local v3 = UserInputService.TouchEnabled and ScreenResolution.GetViewportSize().X < 1024;
local u4 = {
    {
        ResolutionThreshold = (1 / 0),
        ScalePaddingOffset = true,
        PerRow = v3 and 4 or 5,
        Padding = UDim2.fromScale(0.02, 0.04)
    }
};
local GUI = Players.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("GUI");
local v5 = GUI:IsA("Folder");
assert(v5, "PlayerScripts.GUI must be a Folder");
local Main = GUI.BackpackController.Main;
local v6 = Main:IsA("ModuleScript");
assert(v6, "BackpackController.Main must be a ModuleScript");
local InventoryTemplate = Main.InventoryTemplate;
local v7 = InventoryTemplate:IsA("GuiButton");
assert(v7, "BackpackController.Main.InventoryTemplate must be a GuiButton");

function u2.new(p8) -- Line: 68
    -- upvalues: u2 (copy), Trove (copy), AutoGridLayout (copy), u4 (copy)
    local v9 = setmetatable({}, u2);
    v9._active = false;
    v9._rows = Trove.new();
    v9._scrollingFrame = p8;
    v9._trove = Trove.new();
    v9._updateGridLayout = AutoGridLayout.Register(p8, u4);
    p8.AutomaticCanvasSize = Enum.AutomaticSize.None;
    v9._trove:Add(v9._rows);

    return v9;
end;

local function getConfig(p10) -- Line: 84
    -- upvalues: Directory (copy)
    local v11 = Directory[p10.Category];
    local v12 = `Missing asset config {p10.Category}`;
    assert(v11 ~= nil, v12);

    return v11;
end;

local function getOddsDenominator(p13) -- Line: 90
    -- upvalues: Directory (copy), Mutations (copy)
    local v14 = Directory[p13.Category];
    local v15 = `Missing asset config {p13.Category}`;
    assert(v14 ~= nil, v15);

    return 1 / v14.DropWeight * Mutations.GetVisualOddsMultiplier(p13.Mutations, p13.BaseMutation);
end;

local function clearDirectGradients(p16) -- Line: 95
    for _, child in ipairs(p16:GetChildren()) do
        if child:IsA("UIGradient") then
            child:Destroy();
        end;
    end;
end;

local function sortLikeBackpack(p17, p18, p19, p20) -- Line: 103
    -- upvalues: Directory (copy), AssetGenerationUtil (copy), Mutations (copy), AssetItemUtil (copy)
    local v21 = Directory[p17.Category];
    local v22 = `Missing asset config {p17.Category}`;
    assert(v21 ~= nil, v22);
    local v23 = Directory[p19.Category];
    local v24 = `Missing asset config {p19.Category}`;
    assert(v23 ~= nil, v24);
    local RarityNumber = v21.Rarity.RarityNumber;
    local RarityNumber2 = v23.Rarity.RarityNumber;

    if RarityNumber ~= RarityNumber2 then
        return RarityNumber2 < RarityNumber;
    end;

    local v25 = AssetGenerationUtil.GetBaseRateMutationOnly(p17);
    local v26 = AssetGenerationUtil.GetBaseRateMutationOnly(p19);

    if v25 ~= v26 then
        return v26 < v25;
    end;

    local v27 = Directory[p17.Category];
    local v28 = `Missing asset config {p17.Category}`;
    assert(v27 ~= nil, v28);
    local v29 = 1 / v27.DropWeight * Mutations.GetVisualOddsMultiplier(p17.Mutations, p17.BaseMutation);
    local v30 = Directory[p19.Category];
    local v31 = `Missing asset config {p19.Category}`;
    assert(v30 ~= nil, v31);
    local v32 = 1 / v30.DropWeight * Mutations.GetVisualOddsMultiplier(p19.Mutations, p19.BaseMutation);

    if v29 ~= v32 then
        return v32 < v29;
    end;

    if v21.DropWeight ~= v23.DropWeight then
        return v21.DropWeight < v23.DropWeight;
    end;

    local v33 = AssetItemUtil.GetVisualWeightKg(p17);
    local v34 = AssetItemUtil.GetVisualWeightKg(p19);

    if v33 == v34 then
        return p18 < p20;
    end;

    return v34 < v33;
end;

function u2._createRow(p35, u36, p37, p38, u39) -- Line: 142
    -- upvalues: InventoryTemplate (copy), AssetIconShape (copy), Directory (copy), clearDirectGradients (copy), ItemDisplay (copy), AssetItemUtil (copy), ButtonFX (copy)
    local v40 = InventoryTemplate:Clone();
    v40.Name = `FuseSelection.{u36}`;
    v40.LayoutOrder = p38;
    v40:SetAttribute("IsInventorySlot", true);
    v40.Active = true;
    v40.AutoButtonColor = false;
    v40.BackgroundColor3 = Color3.new(0, 0, 0);
    v40.BackgroundTransparency = 0.5;
    local UIStroke = v40.UIStroke;
    local v41 = UIStroke:IsA("UIStroke");
    assert(v41, "Fuse inventory row requires UIStroke");
    UIStroke.Thickness = 0;
    v40.Visible = true;
    v40.Parent = p35._scrollingFrame;
    p35._rows:Add(v40);
    local BaseTemplate = v40.BaseTemplate;
    local Amount = BaseTemplate.Amount;
    local v42 = Amount:IsA("TextLabel");
    assert(v42, "Fuse inventory row Amount must be a TextLabel");
    Amount.Text = "";
    Amount.Visible = false;
    local Mutations2 = BaseTemplate.Mutations;
    local v43 = Mutations2:IsA("GuiObject");
    assert(v43, "Fuse inventory row Mutations must be a GuiObject");
    Mutations2.Visible = false;
    local Icon = v40.Icon;
    local v44 = Icon:IsA("ImageLabel");
    assert(v44, "Fuse inventory row Icon must be an ImageLabel");
    AssetIconShape.Apply(Icon, p37);
    Icon.ImageColor3 = Color3.new(1, 1, 1);
    local v45 = Directory[p37.Category];
    local v46 = `Missing asset config {p37.Category}`;
    assert(v45 ~= nil, v46);
    local ToolName = v40.ToolName;
    local v47 = ToolName:IsA("TextLabel");
    assert(v47, "Fuse inventory row ToolName must be a TextLabel");
    clearDirectGradients(ToolName);
    v45.Rarity.Gradient:Clone().Parent = ToolName;
    ToolName.Text = `{ItemDisplay.GetNameFromItemData(p37)} ({AssetItemUtil.GetVisualWeightKgDisplay(p37)})`;
    ToolName.Visible = true;
    local Shadow = v40.Shadow;
    local v48 = Shadow:IsA("ImageLabel");
    assert(v48, "Fuse inventory row Shadow must be an ImageLabel");
    clearDirectGradients(Shadow);
    v45.Rarity.Gradient:Clone().Parent = Shadow;
    Shadow.Visible = true;
    local FavIcon = v40.FavIcon;
    local v49 = FavIcon:IsA("GuiObject");
    assert(v49, "Fuse inventory row FavIcon must be a GuiObject");
    FavIcon.Visible = false;
    local Weight = v40.Weight;
    local v50 = Weight:IsA("GuiObject");
    assert(v50, "Fuse inventory row Weight must be a GuiObject");
    Weight.Visible = false;
    p35._rows:Add(v40.Activated:Connect(function() -- Line: 199
        -- upvalues: u39 (copy), u36 (copy)
        u39(u36);
    end));
    ButtonFX(v40);
end;

function u2.Open(p51, p52, p53, p54) -- Line: 209
    -- upvalues: FuseKernelUtil (copy), AssetItemSerialization (copy), sortLikeBackpack (copy)
    if p51._active then
        return 0;
    end;

    local v55 = {};
    local u56 = {};

    for i, v in pairs(p52.Inventory) do
        if FuseKernelUtil.CanSelectPet(i, v, p53, false) then
            table.insert(v55, i);
            u56[i] = AssetItemSerialization.Deserialize(v);
        end;
    end;

    table.sort(v55, function(p57, p58) -- Line: 228
        -- upvalues: sortLikeBackpack (ref), u56 (copy)
        local v59 = u56[p57];
        local v60 = `Missing Fuse selection item data for {p57}`;
        local v61 = assert(v59, v60);
        local v62 = u56[p58];
        local v63 = `Missing Fuse selection item data for {p58}`;

        return sortLikeBackpack(v61, p57, assert(v62, v63), p58);
    end);

    if #v55 == 0 then
        return 0;
    end;

    p51._active = true;
    p51._scrollingFrame.CanvasPosition = Vector2.zero;

    for i, v in ipairs(v55) do
        local v64 = u56[v];
        local v65 = `Missing Fuse selection item data for {v}`;
        p51:_createRow(v, assert(v64, v65), i, p54);
    end;

    return #v55;
end;

function u2.Close(p66) -- Line: 254
    if not p66._active then
        return;
    end;

    p66._rows:Clean();
    p66._scrollingFrame.CanvasPosition = Vector2.zero;
    p66._active = false;
end;

function u2.RefreshGridLayout(p67) -- Line: 264
    assert(p67._active, "FuseMachine backpack selection must be open before refreshing its grid");
    p67._updateGridLayout();
end;

function u2.IsOpen(p68) -- Line: 269
    return p68._active;
end;

function u2.Destroy(p69) -- Line: 273
    -- upvalues: u1 (copy)
    p69:Close();
    p69._trove:Destroy();
    u1:AtTrace():Log("Destroyed FuseMachine backpack selection");
end;

return u2;