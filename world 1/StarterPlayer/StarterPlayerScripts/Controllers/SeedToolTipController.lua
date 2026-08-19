-- Decompiled with Potassium's decompiler.

local v1 = {};
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local LocalPlayer = Players.LocalPlayer;
local u2 = LocalPlayer:GetMouse();
local Tooltip = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Tooltip"):WaitForChild("Tooltip");
local u3 = nil;
local u4 = false;
local SeedData = require(game.ReplicatedStorage.SharedModules.SeedData);
local PlantImages = game.ReplicatedStorage.SharedModules.SeedData.PlantImages;
local SellValueData = require(game.ReplicatedStorage.SharedModules.SellValueData);
local SellFlags = require(game.ReplicatedStorage.SharedModules.Flags.SellFlags);
local NumberUtils = require(game.ReplicatedStorage.SharedModules.NumberUtils);
local Worlds = require(game.ReplicatedStorage.SharedModules.Worlds);
local WeatherData = require(game.ReplicatedStorage.SharedModules.WeatherData);
local u5 = nil;
local HoverSFX = game.SoundService.SFX.HoverSFX;

local function isElementVisible(p6) -- Line: 28
    while p6 do
        if p6:IsA("GuiObject") and not p6.Visible then
            return false;
        end;

        if p6:IsA("ScreenGui") and not p6.Enabled then
            return false;
        end;

        p6 = p6.Parent;
    end;

    return true;
end;

function Update(p7)
    -- upvalues: u5 (ref), HoverSFX (copy), Tooltip (copy), SeedData (copy), PlantImages (copy), SellFlags (copy), SellValueData (copy), NumberUtils (copy), Worlds (copy)
    if u5 == p7 then
        return;
    end;

    HoverSFX.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
    HoverSFX.TimePosition = 0;
    HoverSFX.Playing = true;
    u5 = p7;
    Tooltip.AnchorPoint = Vector2.new(0, 0);

    for _, v in pairs(SeedData) do
        if v.SeedName == p7 then
            SeedSpec = v;
            break;
        end;
    end;

    if SeedSpec then
        local v8 = SeedSpec.FruitImage and SeedSpec.FruitImage.Value or "";

        if SeedSpec.IsSingleHarvest then
            local v9 = PlantImages:FindFirstChild(p7);

            if v9 and v9.Value ~= "" then
                v8 = v9.Value;
            end;
        end;

        Tooltip.ItemImage.Vector.Image = v8;
        Tooltip.Rarity.Text = SeedSpec.Rarity;
        Tooltip.Rarity.TextColor3 = Color3.new(1, 1, 1);
        Tooltip.ItemName.TextColor3 = Color3.new(1, 1, 1);
        Tooltip.Price.RichText = false;

        for _, child in pairs(Tooltip.Rarity:GetChildren()) do
            if child:IsA("UIGradient") then
                child:Destroy();
                break;
            end;
        end;

        local v10 = game.ReplicatedStorage.SharedModules.RarityData.Gradients:FindFirstChild(SeedSpec.Rarity):Clone();

        if v10 then
            v10.Parent = Tooltip.Rarity;
        else
            v10:Destroy();
        end;

        local v11 = SellFlags.Apply(p7, SellValueData[p7] or 0);
        Tooltip.Price.Text = "Base: " .. NumberUtils.Abbreviate((math.floor(v11))) .. Worlds.Current.CurrencySuffix;
        Tooltip.ItemName.Text = p7;
    end;
end;

function UpdateWeather(p12)
    -- upvalues: u5 (ref), HoverSFX (copy), Tooltip (copy), WeatherData (copy)
    if u5 ~= p12 then
        HoverSFX.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
        HoverSFX.TimePosition = 0;
        HoverSFX.Playing = true;
        u5 = p12;
        Tooltip.AnchorPoint = Vector2.new(1, 0);
    end;

    local Time = p12:FindFirstChild("Time");
    local Weather = p12:FindFirstChild("Weather");
    local Vector = p12:FindFirstChild("Vector");

    if Time and Time:IsA("TextLabel") then
        Tooltip.Rarity.Text = Time.Text;
        Tooltip.Rarity.TextColor3 = Time.TextColor3;
    end;

    for _, child in Tooltip.Rarity:GetChildren() do
        if child:IsA("UIGradient") then
            child:Destroy();
            break;
        end;
    end;

    if Weather and Weather:IsA("TextLabel") then
        Tooltip.ItemName.Text = Weather.Text;
        Tooltip.ItemName.TextColor3 = Weather.TextColor3;
    end;

    if Vector and Vector:IsA("ImageLabel") then
        Tooltip.ItemImage.Vector.Image = Vector.Image;
    end;

    local v13 = Weather and Weather.Text or "";
    local v14 = "";

    for _, v in WeatherData.Data do
        if v.Name == v13 then
            v14 = v.Description;
            break;
        end;
    end;

    if v14 == "" then
        local v15 = p12:GetAttribute("ToolTipDescription");
        v14 = typeof(v15) ~= "string" and "" or v15;
    end;

    Tooltip.Price.RichText = true;
    Tooltip.Price.Text = v14;
    Tooltip.Price.TextColor3 = Color3.new(1, 1, 1);
end;

function UpdateItem(p16)
    -- upvalues: u5 (ref), HoverSFX (copy), Tooltip (copy)
    if u5 == p16 then
        return;
    end;

    HoverSFX.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
    HoverSFX.TimePosition = 0;
    HoverSFX.Playing = true;
    u5 = p16;
    Tooltip.AnchorPoint = Vector2.new(0, 0);
    local v17 = p16:GetAttribute("ItemToolTip");
    local v18 = p16:GetAttribute("ItemToolTipImage");
    local v19 = p16:GetAttribute("ItemToolTipRarity");
    local v20 = p16:GetAttribute("ItemToolTipSubtitle");
    Tooltip.ItemImage.Vector.Image = typeof(v18) ~= "string" and "" or v18;
    Tooltip.ItemName.Text = typeof(v17) ~= "string" and "" or v17;
    Tooltip.ItemName.TextColor3 = Color3.new(1, 1, 1);

    for _, child in Tooltip.Rarity:GetChildren() do
        if child:IsA("UIGradient") then
            child:Destroy();
            break;
        end;
    end;

    Tooltip.Rarity.TextColor3 = Color3.new(1, 1, 1);

    if typeof(v19) == "string" and v19 ~= "" then
        Tooltip.Rarity.Text = v19;
        local v21 = game.ReplicatedStorage.SharedModules.RarityData.Gradients:FindFirstChild(v19);

        if v21 then
            v21:Clone().Parent = Tooltip.Rarity;
        end;
    else
        Tooltip.Rarity.Text = "";
    end;

    local v22 = typeof(v20) ~= "string" and "" or v20;
    Tooltip.Price.RichText = string.find(v22, "<%a") ~= nil;
    Tooltip.Price.TextColor3 = Color3.new(1, 1, 1);
    Tooltip.Price.Text = v22;
end;

function v1.TrackUI(p23, u24) -- Line: 201
    -- upvalues: u3 (ref), u4 (ref), u5 (ref)
    u24.MouseEnter:Connect(function() -- Line: 202
        -- upvalues: u3 (ref), u24 (copy), u4 (ref)
        u3 = u24;
        u4 = true;
    end);
    u24.MouseLeave:Connect(function() -- Line: 206
        -- upvalues: u3 (ref), u24 (copy), u4 (ref), u5 (ref)
        if u3 == u24 then
            u4 = false;
            u3 = nil;
            u5 = nil;
        end;
    end);

    local function onAttributeCleared() -- Line: 214
        -- upvalues: u24 (copy), u3 (ref), u4 (ref)
        if not u24:GetAttribute("SeedToolTip") and (not u24:GetAttribute("WeatherToolTip") and (not u24:GetAttribute("ItemToolTip") and u3 == u24)) then
            u4 = false;
            u3 = nil;
        end;
    end;

    u24:GetAttributeChangedSignal("SeedToolTip"):Connect(onAttributeCleared);
    u24:GetAttributeChangedSignal("WeatherToolTip"):Connect(onAttributeCleared);
    u24:GetAttributeChangedSignal("ItemToolTip"):Connect(onAttributeCleared);
    u24.Destroying:Connect(function() -- Line: 228
        -- upvalues: u3 (ref), u24 (copy), u4 (ref)
        if u3 == u24 then
            u4 = false;
            u3 = nil;
        end;
    end);
end;

function v1.Start(u25) -- Line: 236
    -- upvalues: LocalPlayer (copy), Tooltip (copy), RunService (copy), u4 (ref), u3 (ref), isElementVisible (copy), u5 (ref), u2 (copy)
    local PlayerGui = LocalPlayer.PlayerGui;

    local function shouldTrack(p26) -- Line: 239
        local v27 = p26:IsA("GuiObject") and (p26:GetAttribute("SeedToolTip") or (p26:GetAttribute("WeatherToolTip") or p26:GetAttribute("ItemToolTip")));

        return v27;
    end;

    for _, descendant in PlayerGui:GetDescendants() do
        local v28 = descendant:IsA("GuiObject") and (descendant:GetAttribute("SeedToolTip") or (descendant:GetAttribute("WeatherToolTip") or descendant:GetAttribute("ItemToolTip")));

        if v28 then
            u25:TrackUI(descendant);
        end;
    end;

    PlayerGui.DescendantAdded:Connect(function(p29) -- Line: 251
        -- upvalues: u25 (copy)
        local v30 = p29:IsA("GuiObject") and (p29:GetAttribute("SeedToolTip") or (p29:GetAttribute("WeatherToolTip") or p29:GetAttribute("ItemToolTip")));

        if v30 then
            u25:TrackUI(p29);
        end;
    end);
    Tooltip.Visible = false;
    RunService.Heartbeat:Connect(function() -- Line: 258
        -- upvalues: u4 (ref), u3 (ref), isElementVisible (ref), Tooltip (ref), u5 (ref), u2 (ref)
        if not (u4 and u3) then
            Tooltip.Visible = false;

            return;
        end;

        if isElementVisible(u3) then
            if u3:GetAttribute("WeatherToolTip") then
                UpdateWeather(u3);
            elseif u3:GetAttribute("ItemToolTip") == nil then
                local v31 = u3:GetAttribute("SeedToolTip") or "";
                Update(v31);
            else
                UpdateItem(u3);
            end;

            Tooltip.Position = UDim2.new(0, u2.X, 0, u2.Y - Tooltip.AbsoluteSize.Y - 8);
            Tooltip.Visible = true;

            return;
        end;

        Tooltip.Visible = false;
        u4 = false;
        u3 = nil;
        u5 = nil;
    end);
end;

function v1.Init(p32) -- Line: 285
end;

return v1;