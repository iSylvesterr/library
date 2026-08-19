-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local GUI = require(ReplicatedStorage.Library.Client.GUI);
local InputIconsConfig = require(ReplicatedStorage.Library.InputIconsConfig);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Signal = require(ReplicatedStorage.Library.Signal);
local Variables = require(ReplicatedStorage.Library.Variables);
local u1 = UDim2.fromScale(0.335, 0.965);
local u2 = Vector2.new(0, 1);
local u3 = UDim2.fromScale(0.085, 0.15);
local u4 = Color3.fromRGB(255, 255, 255);
local u5 = Color3.fromRGB(15, 15, 20);
local u6 = Log.new();
local u7 = GUI.PlayerGui();
local u8 = {};
local u9 = 0;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local v13 = {};

local function createHolder() -- Line: 54
    -- upvalues: u2 (copy), u1 (copy), u3 (copy), u7 (copy)
    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "ActionPrompts";
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.DisplayOrder = 5;
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
    local Frame = Instance.new("Frame");
    Frame.Name = "Holder";
    Frame.BackgroundTransparency = 1;
    Frame.AnchorPoint = u2;
    Frame.Position = u1;
    Frame.Size = UDim2.new(0, 0, u3.Y.Scale, 0);
    Frame.AutomaticSize = Enum.AutomaticSize.X;
    Frame.Visible = false;
    Frame.Parent = ScreenGui;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.FillDirection = Enum.FillDirection.Vertical;
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom;
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.Padding = UDim.new(0.06, 0);
    UIListLayout.Parent = Frame;
    ScreenGui.Parent = u7;

    return Frame;
end;

local function resolveHolder() -- Line: 83
    -- upvalues: u10 (ref), createHolder (copy)
    local v14 = u10;

    if v14 == nil then
        v14 = createHolder();
        u10 = v14;
    end;

    return v14;
end;

local function createRow(p15) -- Line: 92
    -- upvalues: u4 (copy), u5 (copy)
    local Frame = Instance.new("Frame");
    Frame.Name = "Prompt";
    Frame.BackgroundTransparency = 1;
    Frame.Size = UDim2.new(0, 0, 0.26, 0);
    Frame.AutomaticSize = Enum.AutomaticSize.X;
    Frame.LayoutOrder = p15;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.Padding = UDim.new(0, 5);
    UIListLayout.Parent = Frame;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Icon";
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.LayoutOrder = 1;
    ImageLabel.Parent = Frame;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Label";
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Size = UDim2.new(0, 0, 0.58, 0);
    TextLabel.AutomaticSize = Enum.AutomaticSize.X;
    TextLabel.LayoutOrder = 2;
    TextLabel.Font = Enum.Font.GothamBold;
    TextLabel.TextColor3 = u4;
    TextLabel.TextSize = 18;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.Parent = Frame;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Color = u5;
    UIStroke.Thickness = 2.5;
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
    UIStroke.Parent = TextLabel;

    return Frame, ImageLabel, TextLabel;
end;

local function projectPrompt(p16) -- Line: 138
    -- upvalues: InputIconsConfig (copy)
    local v17 = InputIconsConfig.Image(p16.KeyCode);
    p16.Icon.Image = v17 or "";
    p16.Icon.Visible = v17 ~= nil;
    p16.Label.Text = p16.Text;
end;

local function refresh() -- Line: 145
    -- upvalues: u10 (ref), createHolder (copy), u8 (copy), Variables (copy), InputIconsConfig (copy)
    local v18 = u10;

    if v18 == nil then
        v18 = createHolder();
        u10 = v18;
    end;

    local v19 = next(u8) ~= nil;
    v18.Visible = Variables.Console and v19;

    for _, v in u8 do
        local v20 = InputIconsConfig.Image(v.KeyCode);
        v.Icon.Image = v20 or "";
        v.Icon.Visible = v20 ~= nil;
        v.Label.Text = v.Text;
    end;
end;

local function applyPlacement() -- Line: 155
    -- upvalues: u10 (ref), createHolder (copy), u11 (ref), u2 (copy), u1 (copy), u12 (ref)
    local v21 = u10;

    if v21 == nil then
        v21 = createHolder();
        u10 = v21;
    end;

    local v22 = u11;

    if v22 ~= nil then
        v21.AnchorPoint = u2;
        v21.Position = UDim2.fromScale(v22, u1.Y.Scale);

        return;
    end;

    local v23 = u12;

    if v23 == nil then
        v21.AnchorPoint = u2;
        v21.Position = u1;

        return;
    end;

    v21.AnchorPoint = Vector2.new(1, 1);
    v21.Position = UDim2.fromScale(v23, u1.Y.Scale);
end;

function v13.Show(p24, p25, p26) -- Line: 179
    -- upvalues: Asserts (copy), u8 (copy), u9 (ref), createRow (copy), u10 (ref), createHolder (copy), InputIconsConfig (copy), Variables (copy), u6 (copy)
    Asserts.string(p24);
    Asserts.string(p26);
    local v27 = typeof(p25) == "EnumItem";
    local v28 = `Action prompt "{p24}" requires a KeyCode`;
    assert(v27, v28);
    local v29 = u8[p24];

    if v29 ~= nil and (v29.KeyCode == p25 and v29.Text == p26) then
        return;
    end;

    if v29 == nil then
        u9 = u9 + 1;
        local v30, v31, v32 = createRow(u9);
        v29 = {
            KeyCode = p25,
            Text = p26,
            Row = v30,
            Icon = v31,
            Label = v32
        };
        u8[p24] = v29;
        local v33 = u10;

        if v33 == nil then
            v33 = createHolder();
            u10 = v33;
        end;

        v30.Parent = v33;
    else
        v29.KeyCode = p25;
        v29.Text = p26;
    end;

    local v34 = InputIconsConfig.Image(v29.KeyCode);
    v29.Icon.Image = v34 or "";
    v29.Icon.Visible = v34 ~= nil;
    v29.Label.Text = v29.Text;
    local v35 = u10;

    if v35 == nil then
        v35 = createHolder();
        u10 = v35;
    end;

    local v36 = next(u8) ~= nil;
    v35.Visible = Variables.Console and v36;

    for _, v in u8 do
        local v37 = InputIconsConfig.Image(v.KeyCode);
        v.Icon.Image = v37 or "";
        v.Icon.Visible = v37 ~= nil;
        v.Label.Text = v.Text;
    end;

    u6:AtDebug():Log((`Action prompt "{p24}" shown: key={p25.Name}, console={Variables.Console}, image="{v29.Icon.Image}"`));
end;

function v13.Hide(p38) -- Line: 213
    -- upvalues: Asserts (copy), u8 (copy), u10 (ref), createHolder (copy), Variables (copy), InputIconsConfig (copy)
    Asserts.string(p38);
    local v39 = u8[p38];

    if v39 == nil then
        return;
    end;

    u8[p38] = nil;
    v39.Row:Destroy();
    local v40 = u10;

    if v40 == nil then
        v40 = createHolder();
        u10 = v40;
    end;

    local v41 = next(u8) ~= nil;
    v40.Visible = Variables.Console and v41;

    for _, v in u8 do
        local v42 = InputIconsConfig.Image(v.KeyCode);
        v.Icon.Image = v42 or "";
        v.Icon.Visible = v42 ~= nil;
        v.Label.Text = v.Text;
    end;
end;

function v13.SetRightBoundary(p43) -- Line: 226
    -- upvalues: u12 (ref), applyPlacement (copy)
    u12 = p43;
    applyPlacement();
end;

function v13.SetLeftBoundary(p44) -- Line: 231
    -- upvalues: u11 (ref), applyPlacement (copy)
    u11 = p44;
    applyPlacement();
end;

function v13.IsShown(p45) -- Line: 236
    -- upvalues: Asserts (copy), u8 (copy)
    Asserts.string(p45);

    return u8[p45] ~= nil;
end;

Signal.Fired("Changed Platform"):Connect(refresh);
InputIconsConfig.Changed:Connect(refresh);
local v46 = u10;

if v46 == nil then
    v46 = createHolder();
    u10 = v46;
end;

local v47 = next(u8) ~= nil;
v46.Visible = Variables.Console and v47;

for _, v in u8 do
    local v48 = InputIconsConfig.Image(v.KeyCode);
    v.Icon.Image = v48 or "";
    v.Icon.Visible = v48 ~= nil;
    v.Label.Text = v.Text;
end;

return v13;