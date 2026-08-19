-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local Network = require(ReplicatedStorage.Library.Client.Network);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local ParseNumberSmart = require(ReplicatedStorage.Library.Functions.ParseNumberSmart);
local Assets = require(ReplicatedStorage.Directory.Assets);
local Personalities = require(ReplicatedStorage.Directory.Assets.Personalities);
local Save = require(ReplicatedStorage.Library.Client.Save);
local Directory = Assets.Directory;
require(ReplicatedStorage.Library.Types.AssetItem);
local Mutations = require(ReplicatedStorage.Library.Modules.Mutations);
local AssetGenerationUtil = require(ReplicatedStorage.Library.Util.AssetGenerationUtil);
local Simple = require(ReplicatedStorage.Library.Modules.FormatNumber.Simple);
local TreadmillUtil = require(ReplicatedStorage.Library.Util.TreadmillUtil);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local AdminPanel = Constants.NETWORK_MAP.AdminPanel;
local u1 = UDim2.fromOffset(900, 600);
local u2 = Log.new();
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
local u3 = nil;
local u4 = {};
local u5 = "Assets";
local u6 = false;

local function clearGradients(p7) -- Line: 86
    for _, child in ipairs(p7:GetChildren()) do
        if child:IsA("UIGradient") then
            child:Destroy();
        end;
    end;
end;

local function roundToStep(p8, p9) -- Line: 94
    return math.round(p8 / p9) * p9;
end;

local function formatWalkSpeedDisplay(p10) -- Line: 98
    local v11 = math.round(p10 / 0.1) * 0.1;
    local v12 = string.format("%.1f", v11);

    if string.sub(v12, -2) == ".0" then
        return string.sub(v12, 1, #v12 - 2);
    end;

    return v12;
end;

local function formatSpeedPowerDisplay(p13) -- Line: 108
    return string.format("%.0f", (math.round(p13)));
end;

local function parseNumericInput(p14) -- Line: 112
    -- upvalues: ParseNumberSmart (copy)
    local v15 = ParseNumberSmart(p14);

    if typeof(v15) == "number" then
        return v15;
    end;

    return tonumber(p14);
end;

local function trimText(p16) -- Line: 121
    return string.match(p16, "^%s*(.-)%s*$") or "";
end;

local function parseOptionalNumberInput(p17) -- Line: 125
    -- upvalues: ParseNumberSmart (copy)
    local v18 = string.match(p17, "^%s*(.-)%s*$") or "";

    if v18 == "" then
        return nil, true;
    end;

    local v19 = ParseNumberSmart(v18);

    if typeof(v19) ~= "number" then
        v19 = tonumber(v18);
    end;

    return v19, v19 ~= nil;
end;

local function updateSliderVisual(p20, p21) -- Line: 135
    local Step = p20.Step;
    local v22 = math.round(p21 / Step) * Step;
    local v23 = math.clamp(v22, p20.MinValue, p20.MaxValue);
    local v24 = math.max(p20.MaxValue - p20.MinValue, 0.0001);
    local v25 = math.clamp((v23 - p20.MinValue) / v24, 0, 1);
    p20.CurrentValue = v23;
    p20.Fill.Size = UDim2.fromScale(v25, 1);
    p20.Knob.Position = UDim2.fromScale(v25, 0.5);
    p20.ValueLabel.Text = p20.FormatDisplay(v23);
    p20.Input.Text = p20.FormatInput(v23);
end;

local function createSliderControl(p26, p27, p28, p29, p30, p31, p32, p33, p34) -- Line: 147
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = `{p27}Label`;
    TextLabel.Size = UDim2.fromOffset(190, 18);
    TextLabel.Position = UDim2.fromOffset(690, p29);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Text = p28;
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255);
    TextLabel.TextSize = 15;
    TextLabel.Font = Enum.Font.GothamBold;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.Parent = p26;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = `{p27}Value`;
    TextLabel2.Size = UDim2.fromOffset(190, 16);
    TextLabel2.Position = UDim2.fromOffset(690, p29 + 18);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.Text = "0";
    TextLabel2.TextColor3 = Color3.fromRGB(145, 232, 181);
    TextLabel2.TextSize = 13;
    TextLabel2.Font = Enum.Font.Gotham;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel2.Parent = p26;
    local TextButton = Instance.new("TextButton");
    TextButton.Name = `{p27}Track`;
    TextButton.Size = UDim2.fromOffset(124, 16);
    TextButton.Position = UDim2.fromOffset(690, p29 + 40);
    TextButton.BackgroundColor3 = Color3.fromRGB(31, 45, 71);
    TextButton.BorderSizePixel = 0;
    TextButton.Text = "";
    TextButton.AutoButtonColor = false;
    TextButton.Parent = p26;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(1, 0);
    UICorner.Parent = TextButton;
    local Frame = Instance.new("Frame");
    Frame.Name = "Fill";
    Frame.Size = UDim2.fromScale(0, 1);
    Frame.BackgroundColor3 = Color3.fromRGB(36, 114, 84);
    Frame.BorderSizePixel = 0;
    Frame.Parent = TextButton;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.CornerRadius = UDim.new(1, 0);
    UICorner2.Parent = Frame;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Knob";
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame2.Size = UDim2.fromOffset(14, 14);
    Frame2.Position = UDim2.fromScale(0, 0.5);
    Frame2.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    Frame2.BorderSizePixel = 0;
    Frame2.Parent = TextButton;
    local UICorner3 = Instance.new("UICorner");
    UICorner3.CornerRadius = UDim.new(1, 0);
    UICorner3.Parent = Frame2;
    local TextBox = Instance.new("TextBox");
    TextBox.Name = `{p27}Input`;
    TextBox.Size = UDim2.fromOffset(58, 28);
    TextBox.Position = UDim2.fromOffset(822, p29 + 34);
    TextBox.BackgroundColor3 = Color3.fromRGB(31, 45, 71);
    TextBox.BorderSizePixel = 0;
    TextBox.Text = "0";
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255);
    TextBox.TextSize = 15;
    TextBox.Font = Enum.Font.Gotham;
    TextBox.ClearTextOnFocus = false;
    TextBox.Parent = p26;
    local UICorner4 = Instance.new("UICorner");
    UICorner4.CornerRadius = UDim.new(0, 6);
    UICorner4.Parent = TextBox;

    return {
        Label = TextLabel,
        TrackButton = TextButton,
        Fill = Frame,
        Knob = Frame2,
        Input = TextBox,
        ValueLabel = TextLabel2,
        MinValue = p30,
        MaxValue = p31,
        Step = p32,
        CurrentValue = p30,
        FormatDisplay = p33,
        FormatInput = p34
    };
end;

local function createLabelInput(p35, p36, p37, p38) -- Line: 249
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = `{p36}Label`;
    TextLabel.Size = UDim2.fromOffset(190, 18);
    TextLabel.Position = UDim2.fromOffset(690, p38);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Text = p37;
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255);
    TextLabel.TextSize = 14;
    TextLabel.Font = Enum.Font.GothamBold;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.Parent = p35;
    local TextBox = Instance.new("TextBox");
    TextBox.Name = `{p36}Input`;
    TextBox.Size = UDim2.fromOffset(190, 32);
    TextBox.Position = UDim2.fromOffset(690, p38 + 20);
    TextBox.BackgroundColor3 = Color3.fromRGB(31, 45, 71);
    TextBox.BorderSizePixel = 0;
    TextBox.Text = "";
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255);
    TextBox.PlaceholderColor3 = Color3.fromRGB(156, 168, 188);
    TextBox.TextSize = 15;
    TextBox.Font = Enum.Font.Gotham;
    TextBox.ClearTextOnFocus = false;
    TextBox.Parent = p35;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(0, 6);
    UICorner.Parent = TextBox;

    return TextLabel, TextBox;
end;

local function buildRarityChancePercentById() -- Line: 287
    return {};
end;

local function buildAssetRows() -- Line: 300
    -- upvalues: Directory (copy), Personalities (copy), AssetGenerationUtil (copy)
    local v39 = {};
    local v40 = {};
    local v41 = {};

    for i, v in pairs(Directory) do
        local v42 = v.DropWeight or 0;
        local Rarity = v.Rarity;

        if Rarity then
            local v43 = Rarity.DisplayName or (Rarity._id or "Unknown");
            local v44 = Rarity._id or v43;
            local v45 = Personalities.CreateNewItemData({
                Scale = 1,
                Personality = "Normal",
                HasBeenFirstPlaced = false,
                Category = i,
                Mutations = {}
            });
            local v46 = AssetGenerationUtil.GetRateWithoutRebirth(v45);
            v40[v44] = (v40[v44] or 0) + v42;
            table.insert(v39, {
                InRarityDropChancePercent = 0,
                Id = i,
                DisplayName = v.DisplayName or i,
                Icon = v.Icon or "",
                RarityId = v44,
                RarityName = v43,
                RarityNumber = Rarity.RarityNumber or 0,
                RarityGradient = Rarity.Gradient,
                MoneyPerSecond = v46,
                DropWeight = v42
            });
        end;
    end;

    for _, v in ipairs(v39) do
        local v47 = v40[v.RarityId] or 0;

        if v47 > 0 then
            v.InRarityDropChancePercent = v.DropWeight / v47 * 100;
        end;
    end;

    table.sort(v39, function(p48, p49) -- Line: 341
        if p48.RarityNumber ~= p49.RarityNumber then
            return p48.RarityNumber > p49.RarityNumber;
        end;

        if p48.MoneyPerSecond == p49.MoneyPerSecond then
            return p48.DisplayName < p49.DisplayName;
        end;

        return p48.MoneyPerSecond > p49.MoneyPerSecond;
    end);

    return v39, v41;
end;

local function buildMutationNames() -- Line: 354
    -- upvalues: Mutations (copy)
    local v50 = Mutations.GetMutations();
    local v51 = {};

    for i, v in pairs(v50) do
        if v.DropWeight > 0 then
            table.insert(v51, i);
        end;
    end;

    table.sort(v51);

    return v51;
end;

local function createAdminPanel() -- Line: 366
    -- upvalues: PlayerGui (copy), u1 (copy), createLabelInput (copy), createSliderControl (copy), formatWalkSpeedDisplay (copy), TreadmillUtil (copy), formatSpeedPowerDisplay (copy)
    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "AdminPanel";
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.IgnoreGuiInset = true;
    ScreenGui.Parent = PlayerGui;
    local TextButton = Instance.new("TextButton");
    TextButton.Name = "Toggle";
    TextButton.Size = UDim2.fromOffset(150, 40);
    TextButton.AnchorPoint = Vector2.new(0, 0.5);
    TextButton.Position = UDim2.new(0, 12, 0.75, 0);
    TextButton.BackgroundColor3 = Color3.fromRGB(31, 45, 71);
    TextButton.BorderSizePixel = 0;
    TextButton.Text = "Admin";
    TextButton.TextColor3 = Color3.fromRGB(255, 255, 255);
    TextButton.TextSize = 20;
    TextButton.Font = Enum.Font.GothamBold;
    TextButton.Parent = ScreenGui;
    local Frame = Instance.new("Frame");
    Frame.Name = "Panel";
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.Size = u1;
    Frame.Position = UDim2.fromScale(0.5, 0.5);
    Frame.BackgroundColor3 = Color3.fromRGB(18, 24, 35);
    Frame.BorderSizePixel = 0;
    Frame.Visible = false;
    Frame.Parent = ScreenGui;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(0, 10);
    UICorner.Parent = Frame;
    Instance.new("UIDragDetector").Parent = Frame;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Title";
    TextLabel.Size = UDim2.new(1, -60, 0, 42);
    TextLabel.Position = UDim2.fromOffset(18, 8);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Text = "Admin Asset Grant";
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255);
    TextLabel.TextSize = 25;
    TextLabel.Font = Enum.Font.GothamBold;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.Parent = Frame;
    local TextButton2 = Instance.new("TextButton");
    TextButton2.Name = "CloseButton";
    TextButton2.Size = UDim2.fromOffset(34, 34);
    TextButton2.Position = UDim2.new(1, -42, 0, 8);
    TextButton2.BackgroundColor3 = Color3.fromRGB(117, 38, 46);
    TextButton2.BorderSizePixel = 0;
    TextButton2.Text = "X";
    TextButton2.TextColor3 = Color3.fromRGB(255, 255, 255);
    TextButton2.TextSize = 22;
    TextButton2.Font = Enum.Font.GothamBold;
    TextButton2.Parent = Frame;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.CornerRadius = UDim.new(0, 6);
    UICorner2.Parent = TextButton2;
    local TextButton3 = Instance.new("TextButton");
    TextButton3.Name = "AssetTabButton";
    TextButton3.Size = UDim2.fromOffset(94, 32);
    TextButton3.Position = UDim2.fromOffset(456, 18);
    TextButton3.BackgroundColor3 = Color3.fromRGB(36, 114, 84);
    TextButton3.BorderSizePixel = 0;
    TextButton3.Text = "Assets";
    TextButton3.TextColor3 = Color3.fromRGB(255, 255, 255);
    TextButton3.TextSize = 14;
    TextButton3.Font = Enum.Font.GothamBold;
    TextButton3.Parent = Frame;
    local UICorner3 = Instance.new("UICorner");
    UICorner3.CornerRadius = UDim.new(0, 7);
    UICorner3.Parent = TextButton3;
    local TextButton4 = Instance.new("TextButton");
    TextButton4.Name = "EggTabButton";
    TextButton4.Size = UDim2.fromOffset(94, 32);
    TextButton4.Position = UDim2.fromOffset(558, 18);
    TextButton4.BackgroundColor3 = Color3.fromRGB(37, 47, 66);
    TextButton4.BorderSizePixel = 0;
    TextButton4.Text = "Eggs";
    TextButton4.TextColor3 = Color3.fromRGB(255, 255, 255);
    TextButton4.TextSize = 14;
    TextButton4.Font = Enum.Font.GothamBold;
    TextButton4.Parent = Frame;
    local UICorner4 = Instance.new("UICorner");
    UICorner4.CornerRadius = UDim.new(0, 7);
    UICorner4.Parent = TextButton4;
    local ScrollingFrame = Instance.new("ScrollingFrame");
    ScrollingFrame.Name = "AssetList";
    ScrollingFrame.Size = UDim2.fromOffset(430, 520);
    ScrollingFrame.Position = UDim2.fromOffset(16, 60);
    ScrollingFrame.BackgroundColor3 = Color3.fromRGB(25, 33, 47);
    ScrollingFrame.BorderSizePixel = 0;
    ScrollingFrame.ScrollBarThickness = 7;
    ScrollingFrame.CanvasSize = UDim2.fromOffset(0, 0);
    ScrollingFrame.Parent = Frame;
    local UICorner5 = Instance.new("UICorner");
    UICorner5.CornerRadius = UDim.new(0, 8);
    UICorner5.Parent = ScrollingFrame;
    local ScrollingFrame2 = Instance.new("ScrollingFrame");
    ScrollingFrame2.Name = "MutationList";
    ScrollingFrame2.Size = UDim2.fromOffset(220, 300);
    ScrollingFrame2.Position = UDim2.fromOffset(456, 60);
    ScrollingFrame2.BackgroundColor3 = Color3.fromRGB(25, 33, 47);
    ScrollingFrame2.BorderSizePixel = 0;
    ScrollingFrame2.ScrollBarThickness = 7;
    ScrollingFrame2.CanvasSize = UDim2.fromOffset(0, 0);
    ScrollingFrame2.Parent = Frame;
    local UICorner6 = Instance.new("UICorner");
    UICorner6.CornerRadius = UDim.new(0, 8);
    UICorner6.Parent = ScrollingFrame2;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "SelectedLabel";
    TextLabel2.Size = UDim2.fromOffset(220, 50);
    TextLabel2.Position = UDim2.fromOffset(456, 368);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.Text = "Selected: None";
    TextLabel2.TextColor3 = Color3.fromRGB(226, 230, 236);
    TextLabel2.TextSize = 16;
    TextLabel2.Font = Enum.Font.Gotham;
    TextLabel2.TextWrapped = true;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel2.TextYAlignment = Enum.TextYAlignment.Top;
    TextLabel2.Parent = Frame;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "MutationSelectionLabel";
    TextLabel3.Size = UDim2.fromOffset(220, 50);
    TextLabel3.Position = UDim2.fromOffset(456, 420);
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.Text = "Mutations: None";
    TextLabel3.TextColor3 = Color3.fromRGB(226, 230, 236);
    TextLabel3.TextSize = 16;
    TextLabel3.Font = Enum.Font.Gotham;
    TextLabel3.TextWrapped = true;
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel3.TextYAlignment = Enum.TextYAlignment.Top;
    TextLabel3.Parent = Frame;
    local TextLabel4 = Instance.new("TextLabel");
    TextLabel4.Name = "ScaleLabel";
    TextLabel4.Size = UDim2.fromOffset(190, 20);
    TextLabel4.Position = UDim2.fromOffset(690, 142);
    TextLabel4.BackgroundTransparency = 1;
    TextLabel4.Text = "Size Scale";
    TextLabel4.TextColor3 = Color3.fromRGB(255, 255, 255);
    TextLabel4.TextSize = 15;
    TextLabel4.Font = Enum.Font.GothamBold;
    TextLabel4.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel4.Parent = Frame;
    local TextBox = Instance.new("TextBox");
    TextBox.Name = "ScaleInput";
    TextBox.Size = UDim2.fromOffset(190, 34);
    TextBox.Position = UDim2.fromOffset(690, 166);
    TextBox.BackgroundColor3 = Color3.fromRGB(31, 45, 71);
    TextBox.BorderSizePixel = 0;
    TextBox.Text = "1";
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255);
    TextBox.PlaceholderColor3 = Color3.fromRGB(156, 168, 188);
    TextBox.TextSize = 17;
    TextBox.Font = Enum.Font.Gotham;
    TextBox.ClearTextOnFocus = false;
    TextBox.Parent = Frame;
    local UICorner7 = Instance.new("UICorner");
    UICorner7.CornerRadius = UDim.new(0, 6);
    UICorner7.Parent = TextBox;
    local v52, v53 = createLabelInput(Frame, "ColorIndex", "Color Index Override", 218);
    v53.PlaceholderText = "blank = roll";
    local v54, v55 = createLabelInput(Frame, "ColorSeed", "Color Seed Override", 274);
    v55.PlaceholderText = "blank = roll";
    local v56, v57 = createLabelInput(Frame, "EyeColor", "Eye Hex Override", 330);
    v57.PlaceholderText = "blank = roll";
    local v58, v59 = createLabelInput(Frame, "Personality", "Personality Override", 386);
    v59.PlaceholderText = "blank = roll";
    local v60 = createSliderControl(Frame, "WalkSpeed", "Walk Speed", 220, 0, 1000, 0.1, formatWalkSpeedDisplay, formatWalkSpeedDisplay);
    local v61 = createSliderControl(Frame, "SpeedPower", "Speed Value", 288, 0, 1e18, 1, TreadmillUtil.FormatSpeedPower, formatSpeedPowerDisplay);
    local TextButton5 = Instance.new("TextButton");
    TextButton5.Name = "GiveButton";
    TextButton5.Size = UDim2.fromOffset(190, 46);
    TextButton5.Position = UDim2.fromOffset(690, 446);
    TextButton5.BackgroundColor3 = Color3.fromRGB(36, 114, 84);
    TextButton5.BorderSizePixel = 0;
    TextButton5.Text = "Give Selected Asset";
    TextButton5.TextColor3 = Color3.fromRGB(255, 255, 255);
    TextButton5.TextSize = 17;
    TextButton5.Font = Enum.Font.GothamBold;
    TextButton5.Parent = Frame;
    local UICorner8 = Instance.new("UICorner");
    UICorner8.CornerRadius = UDim.new(0, 8);
    UICorner8.Parent = TextButton5;
    local TextLabel5 = Instance.new("TextLabel");
    TextLabel5.Name = "StatusLabel";
    TextLabel5.Size = UDim2.fromOffset(190, 42);
    TextLabel5.Position = UDim2.fromOffset(690, 498);
    TextLabel5.BackgroundTransparency = 1;
    TextLabel5.Text = "Ready.";
    TextLabel5.TextWrapped = true;
    TextLabel5.TextColor3 = Color3.fromRGB(226, 230, 236);
    TextLabel5.TextSize = 15;
    TextLabel5.Font = Enum.Font.Gotham;
    TextLabel5.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel5.TextYAlignment = Enum.TextYAlignment.Top;
    TextLabel5.Parent = Frame;
    local TextButton6 = Instance.new("TextButton");
    TextButton6.Name = "ResetDataButton";
    TextButton6.Size = UDim2.fromOffset(190, 44);
    TextButton6.Position = UDim2.fromOffset(690, 546);
    TextButton6.BackgroundColor3 = Color3.fromRGB(134, 46, 46);
    TextButton6.BorderSizePixel = 0;
    TextButton6.Text = "Reset Data";
    TextButton6.TextColor3 = Color3.fromRGB(255, 255, 255);
    TextButton6.TextSize = 17;
    TextButton6.Font = Enum.Font.GothamBold;
    TextButton6.Parent = Frame;
    local UICorner9 = Instance.new("UICorner");
    UICorner9.CornerRadius = UDim.new(0, 8);
    UICorner9.Parent = TextButton6;

    return {
        screenGui = ScreenGui,
        panel = Frame,
        title = TextLabel,
        toggleButton = TextButton,
        closeButton = TextButton2,
        assetTabButton = TextButton3,
        eggTabButton = TextButton4,
        assetList = ScrollingFrame,
        mutationList = ScrollingFrame2,
        selectedLabel = TextLabel2,
        mutationSelectionLabel = TextLabel3,
        scaleLabel = TextLabel4,
        scaleInput = TextBox,
        colorIndexLabel = v52,
        colorIndexInput = v53,
        colorSeedLabel = v54,
        colorSeedInput = v55,
        eyeColorLabel = v56,
        eyeColorInput = v57,
        personalityLabel = v58,
        personalityInput = v59,
        walkSpeedControl = v60,
        speedPowerControl = v61,
        giveButton = TextButton5,
        resetButton = TextButton6,
        statusLabel = TextLabel5
    };
end;

local function setupAdminPanel() -- Line: 651
    -- upvalues: createAdminPanel (copy), u5 (ref), Save (copy), TreadmillUtil (copy), updateSliderVisual (copy), ParseNumberSmart (copy), u3 (ref), u4 (copy), buildAssetRows (copy), clearGradients (copy), Simple (copy), buildMutationNames (copy), Network (copy), AdminPanel (copy), UserInputService (copy)
    local u62 = createAdminPanel();
    local u63 = {};
    local u64 = {};
    local u65 = false;
    local u66 = nil;
    local u67 = nil;

    local function setSliderControlVisible(p68, p69) -- Line: 671
        p68.Label.Visible = p69;
        p68.ValueLabel.Visible = p69;
        p68.TrackButton.Visible = p69;
        p68.Input.Visible = p69;
    end;

    local function setEggOverrideControlsVisible(p70) -- Line: 678
        -- upvalues: u62 (copy)
        u62.colorIndexLabel.Visible = p70;
        u62.colorIndexInput.Visible = p70;
        u62.colorSeedLabel.Visible = p70;
        u62.colorSeedInput.Visible = p70;
        u62.eyeColorLabel.Visible = p70;
        u62.eyeColorInput.Visible = p70;
        u62.personalityLabel.Visible = not p70;
        u62.personalityInput.Visible = not p70;
    end;

    local function applyGrantTabState(p71) -- Line: 689
        -- upvalues: u5 (ref), u62 (copy)
        u5 = p71;
        local v72 = p71 == "Eggs";
        u62.title.Text = v72 and "Admin Egg Grant" or "Admin Asset Grant";
        local assetTabButton = u62.assetTabButton;
        local v73;

        if v72 then
            v73 = Color3.fromRGB(37, 47, 66);
        else
            v73 = Color3.fromRGB(36, 114, 84);
        end;

        assetTabButton.BackgroundColor3 = v73;
        local eggTabButton = u62.eggTabButton;
        local v74;

        if v72 then
            v74 = Color3.fromRGB(36, 114, 84);
        else
            v74 = Color3.fromRGB(37, 47, 66);
        end;

        eggTabButton.BackgroundColor3 = v74;
        u62.scaleLabel.Text = v72 and "Egg Scale Override" or "Size Scale";
        u62.scaleInput.PlaceholderText = v72 and "blank = roll" or "1 = roll";
        u62.giveButton.Text = v72 and "Give Selected Egg" or "Give Selected Asset";
        local walkSpeedControl = u62.walkSpeedControl;
        local v75 = not v72;
        walkSpeedControl.Label.Visible = v75;
        walkSpeedControl.ValueLabel.Visible = v75;
        walkSpeedControl.TrackButton.Visible = v75;
        walkSpeedControl.Input.Visible = v75;
        local speedPowerControl = u62.speedPowerControl;
        local v76 = not v72;
        speedPowerControl.Label.Visible = v76;
        speedPowerControl.ValueLabel.Visible = v76;
        speedPowerControl.TrackButton.Visible = v76;
        speedPowerControl.Input.Visible = v76;
        u62.colorIndexLabel.Visible = v72;
        u62.colorIndexInput.Visible = v72;
        u62.colorSeedLabel.Visible = v72;
        u62.colorSeedInput.Visible = v72;
        u62.eyeColorLabel.Visible = v72;
        u62.eyeColorInput.Visible = v72;
        u62.personalityLabel.Visible = not v72;
        u62.personalityInput.Visible = not v72;

        if v72 and u62.scaleInput.Text == "1" then
            u62.scaleInput.Text = "";

            return;
        end;

        if not v72 and (string.match(u62.scaleInput.Text, "^%s*(.-)%s*$") or "") == "" then
            u62.scaleInput.Text = "1";
        end;
    end;

    local function syncSpeedControlsFromSave(p77) -- Line: 711
        -- upvalues: Save (ref), TreadmillUtil (ref), updateSliderVisual (ref), u62 (copy)
        local v78 = Save.Get();

        if not v78 then
            return;
        end;

        local v79 = TreadmillUtil.NormalizeSpeedPower(v78.SpeedPower);
        updateSliderVisual(u62.speedPowerControl, v79);

        if p77 then
            local v80 = TreadmillUtil.SpeedPowerToWalkSpeed(v79);
            updateSliderVisual(u62.walkSpeedControl, v80);
        end;
    end;

    local function setSliderValueFromTrack(p81, p82) -- Line: 725
        -- upvalues: updateSliderVisual (ref)
        local v83 = (p82 - p81.TrackButton.AbsolutePosition.X) / math.max(p81.TrackButton.AbsoluteSize.X, 1);
        local v84 = math.clamp(v83, 0, 1);
        updateSliderVisual(p81, p81.MinValue + (p81.MaxValue - p81.MinValue) * v84);
    end;

    local function attachSliderBehavior(u85, u86) -- Line: 732
        -- upvalues: u66 (ref), u67 (ref), updateSliderVisual (ref), ParseNumberSmart (ref), u62 (copy)
        u85.TrackButton.MouseButton1Down:Connect(function(p87) -- Line: 733
            -- upvalues: u66 (ref), u85 (copy), u67 (ref), u86 (copy), updateSliderVisual (ref)
            u66 = u85;
            u67 = u86;
            local v88 = u85;
            local v89 = (p87 - v88.TrackButton.AbsolutePosition.X) / math.max(v88.TrackButton.AbsoluteSize.X, 1);
            local v90 = math.clamp(v89, 0, 1);
            updateSliderVisual(v88, v88.MinValue + (v88.MaxValue - v88.MinValue) * v90);
        end);
        u85.Input.FocusLost:Connect(function(p91) -- Line: 739
            -- upvalues: u85 (copy), ParseNumberSmart (ref), updateSliderVisual (ref), u62 (ref), u86 (copy)
            if not p91 and u85.Input.Text == u85.FormatInput(u85.CurrentValue) then
                return;
            end;

            local Text = u85.Input.Text;
            local v92 = ParseNumberSmart(Text);

            if typeof(v92) ~= "number" then
                v92 = tonumber(Text);
            end;

            if v92 ~= nil then
                updateSliderVisual(u85, v92);
                u86(u85.CurrentValue);

                return;
            end;

            updateSliderVisual(u85, u85.CurrentValue);
            u62.statusLabel.Text = "Enter a valid number.";
            u62.statusLabel.TextColor3 = Color3.fromRGB(255, 146, 146);
        end);
    end;

    local function updateSelectedAssetState() -- Line: 756
        -- upvalues: u63 (copy), u3 (ref), u62 (copy), u5 (ref)
        for i, v in pairs(u63) do
            local v93;

            if u3 == i then
                v93 = Color3.fromRGB(36, 114, 84);
            else
                v93 = Color3.fromRGB(37, 47, 66);
            end;

            v.BackgroundColor3 = v93;
        end;

        if not u3 then
            u62.selectedLabel.Text = "Selected: None";

            return;
        end;

        local selectedLabel = u62.selectedLabel;
        local v94;

        if u5 == "Eggs" then
            v94 = `Selected egg: {u3}`;
        else
            v94 = `Selected asset: {u3}`;
        end;

        selectedLabel.Text = v94;
    end;

    local function updateMutationState() -- Line: 772
        -- upvalues: u4 (ref), u64 (copy), u62 (copy)
        local v95 = {};

        for i, v in pairs(u4) do
            if v then
                table.insert(v95, i);
            end;
        end;

        table.sort(v95);

        for i, v in pairs(u64) do
            local v96;

            if u4[i] then
                v96 = Color3.fromRGB(126, 73, 153);
            else
                v96 = Color3.fromRGB(37, 47, 66);
            end;

            v.BackgroundColor3 = v96;
        end;

        if #v95 == 0 then
            u62.mutationSelectionLabel.Text = "Mutations: None";

            return;
        end;

        u62.mutationSelectionLabel.Text = `Mutations: {table.concat(v95, ", ")}`;
    end;

    local v97, v98 = buildAssetRows();
    local v99 = nil;
    local v100 = 8;
    local u101 = nil;

    local function setStatus(p102, p103) -- Line: 660
        -- upvalues: u62 (copy)
        u62.statusLabel.Text = p102;

        if p103 == nil then
            u62.statusLabel.TextColor3 = Color3.fromRGB(226, 230, 236);

            return;
        end;

        if p103 then
            u62.statusLabel.TextColor3 = Color3.fromRGB(145, 232, 181);

            return;
        end;

        u62.statusLabel.TextColor3 = Color3.fromRGB(255, 146, 146);
    end;

    for _, v in ipairs(v97) do
        if v99 ~= v.RarityName then
            local TextLabel = Instance.new("TextLabel");
            TextLabel.Name = `Rarity_{v.RarityName}`;
            TextLabel.Size = UDim2.new(1, -14, 0, 22);
            TextLabel.Position = UDim2.fromOffset(7, v100);
            TextLabel.BackgroundTransparency = 1;
            TextLabel.Text = `{v.RarityName} ({string.format("%.2f%%", v98[v.RarityId] or 0)})`;
            TextLabel.TextColor3 = Color3.fromRGB(193, 203, 219);
            TextLabel.TextSize = 14;
            TextLabel.Font = Enum.Font.GothamBold;
            TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
            TextLabel.Parent = u62.assetList;
            v100 = v100 + 24;
            v99 = v.RarityName;
        end;

        local TextButton = Instance.new("TextButton");
        TextButton.Name = v.Id;
        TextButton.Size = UDim2.new(1, -14, 0, 44);
        TextButton.Position = UDim2.fromOffset(7, v100);
        TextButton.BackgroundColor3 = Color3.fromRGB(37, 47, 66);
        TextButton.BorderSizePixel = 0;
        TextButton.Text = "";
        TextButton.Parent = u62.assetList;
        local UICorner = Instance.new("UICorner");
        UICorner.CornerRadius = UDim.new(0, 7);
        UICorner.Parent = TextButton;
        local ImageLabel = Instance.new("ImageLabel");
        ImageLabel.Name = "Icon";
        ImageLabel.Size = UDim2.fromOffset(34, 34);
        ImageLabel.ScaleType = Enum.ScaleType.Fit;
        ImageLabel.Position = UDim2.fromOffset(5, 5);
        ImageLabel.BackgroundTransparency = 1;
        ImageLabel.Image = v.Icon;
        ImageLabel.Parent = TextButton;
        local TextLabel = Instance.new("TextLabel");
        TextLabel.Name = "Name";
        TextLabel.Size = UDim2.new(1, -220, 1, 0);
        TextLabel.Position = UDim2.fromOffset(44, 0);
        TextLabel.BackgroundTransparency = 1;
        TextLabel.Text = v.DisplayName;
        TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255);
        TextLabel.TextSize = 14;
        TextLabel.Font = Enum.Font.GothamBold;
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
        TextLabel.Parent = TextButton;
        clearGradients(TextLabel);

        if v.RarityGradient then
            v.RarityGradient:Clone().Parent = TextLabel;
        end;

        local TextLabel2 = Instance.new("TextLabel");
        TextLabel2.Name = "MoneyPerSecond";
        TextLabel2.Size = UDim2.fromOffset(170, 44);
        TextLabel2.AnchorPoint = Vector2.new(1, 0);
        TextLabel2.Position = UDim2.new(1, -6, 0, 0);
        TextLabel2.BackgroundTransparency = 1;
        TextLabel2.Text = `{Simple.FormatCompact(v.MoneyPerSecond, ".##")}/s | {string.format("%.2f%%", v.InRarityDropChancePercent)}`;
        TextLabel2.TextColor3 = Color3.fromRGB(145, 232, 181);
        TextLabel2.TextSize = 13;
        TextLabel2.Font = Enum.Font.Gotham;
        TextLabel2.TextXAlignment = Enum.TextXAlignment.Right;
        TextLabel2.Parent = TextButton;
        TextButton.MouseButton1Click:Connect(function() -- Line: 869
            -- upvalues: u3 (ref), v (copy), updateSelectedAssetState (copy)
            u3 = v.Id;
            updateSelectedAssetState();
        end);
        u63[v.Id] = TextButton;
        v100 = v100 + 48;
    end;

    u62.assetList.CanvasSize = UDim2.fromOffset(0, v100 + 4);
    local v104 = buildMutationNames();
    local v105 = 8;

    for _, v in ipairs(v104) do
        local TextButton = Instance.new("TextButton");
        TextButton.Name = v;
        TextButton.Size = UDim2.new(1, -14, 0, 32);
        TextButton.Position = UDim2.fromOffset(7, v105);
        TextButton.BackgroundColor3 = Color3.fromRGB(37, 47, 66);
        TextButton.BorderSizePixel = 0;
        TextButton.Text = v;
        TextButton.TextColor3 = Color3.fromRGB(255, 255, 255);
        TextButton.TextSize = 14;
        TextButton.Font = Enum.Font.Gotham;
        TextButton.Parent = u62.mutationList;
        local UICorner = Instance.new("UICorner");
        UICorner.CornerRadius = UDim.new(0, 7);
        UICorner.Parent = TextButton;
        TextButton.MouseButton1Click:Connect(function() -- Line: 897
            -- upvalues: u4 (ref), v (copy), updateMutationState (copy)
            u4[v] = not u4[v];
            updateMutationState();
        end);
        u64[v] = TextButton;
        v105 = v105 + 36;
    end;

    u62.mutationList.CanvasSize = UDim2.fromOffset(0, v105 + 4);
    u62.assetTabButton.MouseButton1Click:Connect(function() -- Line: 907
        -- upvalues: applyGrantTabState (copy), updateSelectedAssetState (copy)
        applyGrantTabState("Assets");
        updateSelectedAssetState();
    end);
    u62.eggTabButton.MouseButton1Click:Connect(function() -- Line: 912
        -- upvalues: applyGrantTabState (copy), updateSelectedAssetState (copy)
        applyGrantTabState("Eggs");
        updateSelectedAssetState();
    end);
    u62.giveButton.MouseButton1Click:Connect(function() -- Line: 917
        -- upvalues: u3 (ref), u62 (copy), u4 (ref), u5 (ref), ParseNumberSmart (ref), Network (ref), AdminPanel (ref)
        if not u3 then
            u62.statusLabel.Text = "Select an asset first.";
            u62.statusLabel.TextColor3 = Color3.fromRGB(255, 146, 146);

            return;
        end;

        local v106 = {};

        for i, v in pairs(u4) do
            if v then
                table.insert(v106, i);
            end;
        end;

        table.sort(v106);

        if u5 ~= "Eggs" then
            local v107 = tonumber(u62.scaleInput.Text) or 1;
            u62.statusLabel.Text = "Granting asset...";
            u62.statusLabel.TextColor3 = Color3.fromRGB(226, 230, 236);
            local v108 = {
                assetId = u3,
                scale = v107,
                mutations = v106
            };
            local v109 = string.match(u62.personalityInput.Text, "^%s*(.-)%s*$") or "";

            if v109 ~= "" then
                v108.personality = v109;
            end;

            Network.Fire(AdminPanel.GIVE_ASSET_TO_SELF, v108);

            return;
        end;

        local v110 = string.match(u62.scaleInput.Text, "^%s*(.-)%s*$") or "";
        local v111, v112;

        if v110 == "" then
            v111 = true;
            v112 = nil;
        else
            v112 = ParseNumberSmart(v110);

            if typeof(v112) ~= "number" then
                v112 = tonumber(v110);
            end;

            if v112 == nil then
                v111 = false;
            else
                v111 = true;
            end;
        end;

        if not v111 then
            u62.statusLabel.Text = "Enter a valid scale override.";
            u62.statusLabel.TextColor3 = Color3.fromRGB(255, 146, 146);

            return;
        end;

        local v113 = string.match(u62.colorSeedInput.Text, "^%s*(.-)%s*$") or "";
        local v114, v115;

        if v113 == "" then
            v114 = true;
            v115 = nil;
        else
            v115 = ParseNumberSmart(v113);

            if typeof(v115) ~= "number" then
                v115 = tonumber(v113);
            end;

            if v115 == nil then
                v114 = false;
            else
                v114 = true;
            end;
        end;

        if not v114 then
            u62.statusLabel.Text = "Enter a valid color seed override.";
            u62.statusLabel.TextColor3 = Color3.fromRGB(255, 146, 146);

            return;
        end;

        local v116 = string.match(u62.colorIndexInput.Text, "^%s*(.-)%s*$") or "";
        local v117, v118;

        if v116 == "" then
            v117 = true;
            v118 = nil;
        else
            v118 = ParseNumberSmart(v116);

            if typeof(v118) ~= "number" then
                v118 = tonumber(v116);
            end;

            if v118 == nil then
                v117 = false;
            else
                v117 = true;
            end;
        end;

        if not v117 then
            u62.statusLabel.Text = "Enter a valid color index override.";
            u62.statusLabel.TextColor3 = Color3.fromRGB(255, 146, 146);

            return;
        end;

        local v119 = {
            assetId = u3
        };

        if v112 ~= nil then
            v119.scale = v112;
        end;

        if v115 ~= nil then
            v119.colorSeed = v115;
        end;

        if v118 ~= nil then
            v119.colorIndex = v118;
        end;

        local v120 = string.match(u62.eyeColorInput.Text, "^%s*(.-)%s*$") or "";

        if v120 ~= "" then
            v119.eyeColor = v120;
        end;

        if #v106 > 0 then
            v119.mutations = v106;
        end;

        u62.statusLabel.Text = "Granting egg...";
        u62.statusLabel.TextColor3 = Color3.fromRGB(226, 230, 236);
        Network.Fire(AdminPanel.GIVE_EGG_TO_SELF, v119);
    end);
    attachSliderBehavior(u62.walkSpeedControl, function(p121) -- Line: 990
        -- upvalues: u101 (ref), u62 (copy), Network (ref), AdminPanel (ref)
        u101 = "WalkSpeed";
        local v122 = math.round(p121 / 0.1) * 0.1;
        local v123 = string.format("%.1f", v122);

        if string.sub(v123, -2) == ".0" then
            v123 = string.sub(v123, 1, #v123 - 2);
        end;

        local v124 = `Setting walk speed to {v123}...`;
        u62.statusLabel.Text = v124;
        u62.statusLabel.TextColor3 = Color3.fromRGB(226, 230, 236);
        Network.Fire(AdminPanel.SET_WALK_SPEED, p121);
    end);
    attachSliderBehavior(u62.speedPowerControl, function(p125) -- Line: 996
        -- upvalues: u101 (ref), u62 (copy), Network (ref), AdminPanel (ref)
        u101 = "SpeedPower";
        local v126 = `Setting speed value to {string.format("%.0f", (math.round(p125)))}...`;
        u62.statusLabel.Text = v126;
        u62.statusLabel.TextColor3 = Color3.fromRGB(226, 230, 236);
        Network.Fire(AdminPanel.SET_SPEED_POWER, p125);
    end);
    u62.resetButton.MouseButton1Click:Connect(function() -- Line: 1002
        -- upvalues: u62 (copy), Network (ref), AdminPanel (ref)
        u62.statusLabel.Text = "Resetting your data...";
        u62.statusLabel.TextColor3 = Color3.fromRGB(226, 230, 236);
        Network.Fire(AdminPanel.RESET_SELF_DATA);
    end);
    Network.Fired(AdminPanel.GIVE_RESULT):Connect(function(p127, p128, p129) -- Line: 1007
        -- upvalues: setStatus (copy)
        if p129 and p129 ~= "" then
            p128 = `{p128} UID: {p129}`;
        end;

        setStatus(p128, p127);
    end);
    Network.Fired(AdminPanel.RESET_RESULT):Connect(function(p130, p131) -- Line: 1012
        -- upvalues: setStatus (copy)
        setStatus(p131, p130);
    end);
    Network.Fired(AdminPanel.SET_SPEED_RESULT):Connect(function(p132, p133) -- Line: 1016
        -- upvalues: setStatus (copy), u101 (ref), Save (ref), TreadmillUtil (ref), updateSliderVisual (ref), u62 (copy)
        setStatus(p133, p132);

        if u101 == "SpeedPower" then
            local v134 = Save.Get();

            if v134 then
                local v135 = TreadmillUtil.NormalizeSpeedPower(v134.SpeedPower);
                updateSliderVisual(u62.speedPowerControl, v135);
                local v136 = TreadmillUtil.SpeedPowerToWalkSpeed(v135);
                updateSliderVisual(u62.walkSpeedControl, v136);
            end;
        else
            local v137 = u101 == "WalkSpeed" and Save.Get();

            if v137 then
                local v138 = TreadmillUtil.NormalizeSpeedPower(v137.SpeedPower);
                updateSliderVisual(u62.speedPowerControl, v138);
            end;
        end;

        u101 = nil;
    end);

    local function togglePanel() -- Line: 1026
        -- upvalues: u65 (ref), u62 (copy)
        u65 = not u65;
        u62.panel.Visible = u65;
    end;

    u62.toggleButton.MouseButton1Click:Connect(togglePanel);
    u62.closeButton.MouseButton1Click:Connect(togglePanel);
    UserInputService.InputBegan:Connect(function(p139, p140) -- Line: 1034
        -- upvalues: u65 (ref), u62 (copy)
        if p140 then
            return;
        end;

        if p139.KeyCode == Enum.KeyCode.F9 then
            u65 = not u65;
            u62.panel.Visible = u65;
        end;
    end);
    UserInputService.InputChanged:Connect(function(p141, p142) -- Line: 1043
        -- upvalues: u66 (ref), updateSliderVisual (ref)
        if u66 == nil then
            return;
        end;

        if p141.UserInputType ~= Enum.UserInputType.MouseMovement and p141.UserInputType ~= Enum.UserInputType.Touch then
            return;
        end;

        local v143 = u66;
        local v144 = (p141.Position.X - v143.TrackButton.AbsolutePosition.X) / math.max(v143.TrackButton.AbsoluteSize.X, 1);
        local v145 = math.clamp(v144, 0, 1);
        updateSliderVisual(v143, v143.MinValue + (v143.MaxValue - v143.MinValue) * v145);
    end);
    UserInputService.InputEnded:Connect(function(p146, p147) -- Line: 1058
        -- upvalues: u66 (ref), u67 (ref)
        if u66 == nil or u67 == nil then
            return;
        end;

        if p146.UserInputType ~= Enum.UserInputType.MouseButton1 and p146.UserInputType ~= Enum.UserInputType.Touch then
            return;
        end;

        local v148 = u66;
        local v149 = u67;
        u66 = nil;
        u67 = nil;
        v149(v148.CurrentValue);
    end);
    local v150 = Save.Get();

    if v150 then
        local v151 = TreadmillUtil.NormalizeSpeedPower(v150.SpeedPower);
        updateSliderVisual(u62.speedPowerControl, v151);
        local v152 = TreadmillUtil.SpeedPowerToWalkSpeed(v151);
        updateSliderVisual(u62.walkSpeedControl, v152);
    end;

    Save.ConnectForDataChanged("SpeedPower", function() -- Line: 1078
        -- upvalues: Save (ref), TreadmillUtil (ref), updateSliderVisual (ref), u62 (copy)
        local v153 = Save.Get();

        if not v153 then
            return;
        end;

        local v154 = TreadmillUtil.NormalizeSpeedPower(v153.SpeedPower);
        updateSliderVisual(u62.speedPowerControl, v154);
    end);
    applyGrantTabState("Assets");
    updateSelectedAssetState();
    updateMutationState();
end;

Network.Fired(AdminPanel.ADMIN_STATUS_RESPONSE):Connect(function(p155) -- Line: 1088
    -- upvalues: u2 (copy), u6 (ref), setupAdminPanel (copy)
    if not p155 then
        u2:AtInfo():Log("Admin panel unavailable for this user");

        return;
    end;

    if u6 then
        return;
    end;

    u6 = true;
    u2:AtInfo():Log("Admin status confirmed, initializing admin panel");
    setupAdminPanel();
end);

if not Save.Get() then
    Save.LoadedStats:Wait();
end;

local v156 = os.clock();

while not u6 and os.clock() - v156 < 13 do
    Network.Fire(AdminPanel.CHECK_ADMIN_STATUS);
    task.wait(2);
end;