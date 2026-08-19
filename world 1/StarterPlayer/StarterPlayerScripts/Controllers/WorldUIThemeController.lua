-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 51
};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Worlds = require(ReplicatedStorage.SharedModules.Worlds);
local LocalPlayer = Players.LocalPlayer;
local u2 = {
    PilgrimQuests = true,
    MagicMailUI = true
};
local u3 = {
    Gacha = true
};
local u4 = { {
        X = 0.9653,
        Y = 0.7849,
        Width = 0.0604,
        Height = 0.7593,
        Rotation = 10
    }, {
        X = 0.8476,
        Y = 0.1914,
        Width = 0.0669,
        Height = 0.9871,
        Rotation = -25
    }, {
        X = -0.0262,
        Y = 0.8098,
        Width = 0.0669,
        Height = 0.9871,
        Rotation = -20
    }, {
        X = 0.052,
        Y = 0.1846,
        Width = 0.054,
        Height = 0.6222,
        Rotation = 7
    }, {
        X = 0.6144,
        Y = 0.7233,
        Width = 0.0794,
        Height = 0.8143,
        Rotation = 30
    } };
local u5 = { {
        X = 0.9784,
        Y = 0.84,
        Width = 0.048,
        Height = 0.62,
        Rotation = 14
    }, {
        X = 0.656,
        Y = 0.15,
        Width = 0.052,
        Height = 0.74,
        Rotation = -25
    }, {
        X = -0.022,
        Y = 0.79,
        Width = 0.056,
        Height = 0.82,
        Rotation = -20
    }, {
        X = 0.04,
        Y = 0.17,
        Width = 0.044,
        Height = 0.52,
        Rotation = 7
    }, {
        X = 0.426,
        Y = 0.83,
        Width = 0.062,
        Height = 0.68,
        Rotation = 30
    } };
local Theme = Worlds.Theme;

local function isThemableHeader(p6) -- Line: 108
    if p6.Name ~= "Header" or not p6:IsA("GuiObject") then
        return false;
    end;

    if not p6:FindFirstChildOfClass("UIGradient") then
        return false;
    end;

    local TextLabel = p6:FindFirstChild("TextLabel");
    local v7;

    if TextLabel == nil then
        v7 = false;
    else
        v7 = TextLabel:FindFirstChild("TextLabel") ~= nil;
    end;

    return v7;
end;

local function isSkipped(p8) -- Line: 119
    -- upvalues: u3 (copy), u2 (copy)
    local Parent = p8.Parent;

    if Parent and u3[Parent.Name] then
        return true;
    end;

    local v9 = p8:FindFirstAncestorWhichIsA("ScreenGui");
    local v10;

    if v9 == nil then
        v10 = false;
    else
        v10 = u2[v9.Name] == true;
    end;

    return v10;
end;

local function paintLabel(p11, p12, p13) -- Line: 132
    p11.TextColor3 = p12;

    for _, descendant in p11:GetDescendants() do
        if descendant:IsA("UIStroke") then
            descendant.Color = p12;
        end;
    end;

    local TextLabel = p11:FindFirstChild("TextLabel");

    if not (TextLabel and TextLabel:IsA("TextLabel")) then
        return;
    end;

    local v14 = TextLabel:FindFirstChildOfClass("UIGradient");

    if v14 then
        v14.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(0.418, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(1, p13) });
    end;
end;

local function paintButton(p15, p16) -- Line: 166
    -- upvalues: paintLabel (copy)
    if p15:IsA("GuiObject") and p15.BackgroundTransparency < 1 then
        p15.BackgroundColor3 = Color3.fromRGB(238, 228, 218);
    end;

    local v17 = p15:FindFirstChildOfClass("UIGradient");

    if v17 then
        v17.Color = p16.AccentRamp;
        v17.Rotation = -90;
    end;

    local v18 = p15:FindFirstChildOfClass("UIStroke");

    if v18 then
        v18.Color = p16.AccentDark;
    end;

    local TextLabel = p15:FindFirstChild("TextLabel");

    if TextLabel and TextLabel:IsA("TextLabel") then
        paintLabel(TextLabel, p16.AccentDark, p16.TitleHighlight);
    end;
end;

local function paintProgressPill(p19, p20) -- Line: 199
    if p19:IsA("GuiObject") and p19.BackgroundTransparency < 1 then
        p19.BackgroundColor3 = p20.AccentDark;
    end;

    local v21 = p19:FindFirstChildOfClass("UIGradient");

    if not v21 then
        return;
    end;

    local v22 = table.create(#v21.Color.Keypoints);

    for i, v in v21.Color.Keypoints do
        local v23;

        if v.Value.R > 0.95 and v.Value.G > 0.95 then
            v23 = v.Value.B > 0.95;
        else
            v23 = false;
        end;

        local v24;

        if v23 then
            v24 = v.Value;
        else
            v24 = p20.Accent;
        end;

        v22[i] = ColorSequenceKeypoint.new(v.Time, v24);
    end;

    v21.Color = ColorSequence.new(v22);
end;

local function addDecor(p25, p26) -- Line: 218
    -- upvalues: u5 (copy), u4 (copy)
    if p26.Decor == "" or p25:FindFirstChild("WorldThemeDecor") then
        return;
    end;

    p25.ClipsDescendants = true;
    local v27;

    if p25:FindFirstChild("RestockButton") ~= nil and true or p25:FindFirstChild("RefreshIn") ~= nil then
        v27 = u5;
    else
        v27 = u4;
    end;

    local Frame = Instance.new("Frame");
    Frame.Name = "WorldThemeDecor";
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.Position = UDim2.fromScale(0.5, 0.5);
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.BackgroundTransparency = 1;
    Frame.BorderSizePixel = 0;
    Frame.ZIndex = 0;

    for _, v in v27 do
        local ImageLabel = Instance.new("ImageLabel");
        ImageLabel.Name = "Leaf";
        ImageLabel.Image = p26.Decor;
        ImageLabel.AnchorPoint = Vector2.new(0, 0.5);
        ImageLabel.Position = UDim2.fromScale(v.X, v.Y);
        ImageLabel.Size = UDim2.fromScale(v.Width, v.Height);
        ImageLabel.Rotation = v.Rotation;
        ImageLabel.ScaleType = Enum.ScaleType.Fit;
        ImageLabel.BackgroundTransparency = 1;
        ImageLabel.BorderSizePixel = 0;
        ImageLabel.ZIndex = 0;
        ImageLabel.Parent = Frame;
    end;

    Frame.Parent = p25;
end;

local function applyStarterPackTheme(p28, p29) -- Line: 265
    -- upvalues: paintLabel (copy)
    if p28:GetAttribute("WorldThemeApplied") then
        return;
    end;

    p28:SetAttribute("WorldThemeApplied", true);
    local v30 = p28:FindFirstChildOfClass("UIGradient");

    if v30 then
        local v31 = table.create(#p29.AccentRamp.Keypoints);

        for i, v in p29.AccentRamp.Keypoints do
            v31[#p29.AccentRamp.Keypoints + 1 - i] = ColorSequenceKeypoint.new(1 - v.Time, v.Value);
        end;

        v30.Color = ColorSequence.new(v31);
        p28.BackgroundColor3 = Color3.new(1, 1, 1);
    end;

    local v32 = p28:FindFirstChildOfClass("UIStroke");

    if v32 then
        v32.Color = p29.HeaderStroke;
    end;

    local Frame = p28:FindFirstChild("Frame");

    if Frame and Frame:IsA("GuiObject") then
        Frame.BackgroundColor3 = p29.AccentDark;
    end;

    local Title = p28:FindFirstChild("Title");

    if Title and Title:IsA("TextLabel") then
        paintLabel(Title, p29.Title, p29.TitleHighlight);
    end;

    local LimitedTime = p28:FindFirstChild("LimitedTime");
    local v33 = LimitedTime and LimitedTime:IsA("TextLabel") and LimitedTime:FindFirstChildOfClass("UIStroke");

    if v33 then
        v33.Color = p29.AccentDark;
    end;

    if p29.Decor ~= "" then
        for _, descendant in p28:GetDescendants() do
            if descendant:IsA("ImageLabel") and descendant.Name == "Sparkle" then
                descendant.Image = p29.Decor;
                descendant.ImageTransparency = math.min(descendant.ImageTransparency, 0.35);
                descendant.Size = UDim2.fromScale(descendant.Size.Y.Scale * 0.75, descendant.Size.Y.Scale);
                descendant.ZIndex = 0;
            end;
        end;
    end;
end;

local function applyTheme(p34, p35) -- Line: 336
    -- upvalues: paintLabel (copy), paintButton (copy), paintProgressPill (copy), addDecor (copy)
    if p34:GetAttribute("WorldThemeApplied") then
        return;
    end;

    p34:SetAttribute("WorldThemeApplied", true);
    local v36 = p34:FindFirstChildOfClass("UIGradient");

    if v36 then
        v36.Color = p35.Header;
        v36.Rotation = 0;
        p34.BackgroundColor3 = Color3.new(1, 1, 1);
    end;

    local v37 = p34:FindFirstChildOfClass("UIStroke");

    if v37 then
        v37.Color = p35.HeaderStroke;
    end;

    local Glow = p34:FindFirstChild("Glow");

    if Glow and Glow:IsA("ImageLabel") then
        Glow.ImageColor3 = p35.Glow;
    end;

    local TextLabel = p34:FindFirstChild("TextLabel");

    if TextLabel and TextLabel:IsA("TextLabel") then
        paintLabel(TextLabel, p35.Title, p35.TitleHighlight);
    end;

    for _, v in { "RestockButton", "DefaultButton", "ExclusiveButton" } do
        local v38 = p34:FindFirstChild(v);

        if v38 then
            paintButton(v38, p35);
        end;
    end;

    local RefreshIn = p34:FindFirstChild("RefreshIn");

    if RefreshIn then
        paintProgressPill(RefreshIn, p35);
    end;

    addDecor(p34, p35);
end;

local function tryApply(p39) -- Line: 384
    -- upvalues: Theme (copy), applyStarterPackTheme (copy), isThemableHeader (copy), u3 (copy), u2 (copy), applyTheme (copy)
    if not Theme then
        return;
    end;

    if p39.Name == "StarterPack" and p39:IsA("GuiObject") then
        applyStarterPackTheme(p39, Theme);

        return;
    end;

    if isThemableHeader(p39) then
        local Parent = p39.Parent;
        local v40;

        if Parent and u3[Parent.Name] then
            v40 = true;
        else
            local v41 = p39:FindFirstAncestorWhichIsA("ScreenGui");

            if v41 == nil then
                v40 = false;
            else
                v40 = u2[v41.Name] == true;
            end;
        end;

        if not v40 then
            applyTheme(p39, Theme);
        end;
    end;
end;

local function onDescendantAdded(p42) -- Line: 403
    -- upvalues: tryApply (copy)
    tryApply(p42);
    local v43 = (p42:IsA("UIGradient") or p42.Name == "TextLabel") and p42.Parent;

    if v43 then
        tryApply(v43);
        local Parent = v43.Parent;

        if Parent then
            tryApply(Parent);
        end;
    end;
end;

function v1.Start(p44) -- Line: 420
    -- upvalues: Theme (copy), LocalPlayer (copy), tryApply (copy), onDescendantAdded (copy)
    if not Theme then
        return;
    end;

    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");

    for _, descendant in PlayerGui:GetDescendants() do
        tryApply(descendant);
    end;

    PlayerGui.DescendantAdded:Connect(onDescendantAdded);
end;

return v1;