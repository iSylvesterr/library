-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 5
};
local MenuOpenClose = game.SoundService.SFX.MenuOpenClose;
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local Debris = game:GetService("Debris");
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local u2 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u3 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local Networking = require(game.ReplicatedStorage.SharedModules.Networking);
local DevProductController = require(game.Players.LocalPlayer.PlayerScripts.Controllers.DevProductController);
local GrowRateData = require(game.ReplicatedStorage.SharedModules.GrowRateData);
require(game.ReplicatedStorage.SharedModules.GrowthBoostSources);
local Notification = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("GrowingList"):WaitForChild("Exit"):WaitForChild("ExitButton"):WaitForChild("Notification");

local function profileBegin(p4) -- Line: 32
    debug.profilebegin("Controllers/GrowingListController/" .. p4);
end;

local function profileEnd() -- Line: 36
    debug.profileend();
end;

local u5 = UDim2.new(1, -5, 0.475, 0);
local u6 = UDim2.new(-0.03, 0, 0.475, 0);
local u7 = UDim2.new(1.265, 0, 0.475, 0);
local u8 = UDim2.new(1, 0, 0.475, 0);
local u9 = nil;
local u10 = nil;
local Plants = ReplicatedStorage:WaitForChild("PlantGenerationModules"):WaitForChild("Plants");
local u11 = {};

local function GetModuleGrowRate(p12) -- Line: 55
    -- upvalues: u11 (copy), Plants (copy)
    if p12 == nil then
        return nil;
    end;

    local v13 = u11[p12];

    if v13 ~= nil then
        return v13;
    end;

    local v14 = Plants:FindFirstChild(p12);

    if not v14 then
        return nil;
    end;

    local success, result = pcall(require, v14);

    if not success or type(result) ~= "table" then
        return nil;
    end;

    local GrowData = result.GrowData;

    if type(GrowData) ~= "table" then
        return nil;
    end;

    local GrowRate = GrowData.GrowRate;

    if type(GrowRate) ~= "number" then
        return nil;
    end;

    u11[p12] = GrowRate;

    return GrowRate;
end;

local u15 = nil;
local u16 = nil;
local u17 = nil;
local u18 = nil;
local u19 = {};
local u20 = {};
local u21 = {};
local u22 = 0;
local u23 = false;
local u24 = false;
local GuiController = require(script.Parent.GuiController);

local function FormatTimeRemaining(p25) -- Line: 118
    local v26 = math.floor(p25);
    local v27 = math.max(0, v26);
    local v28 = v27 // 604800;
    local v29 = v27 % 604800 // 86400;
    local v30 = v27 % 86400 // 3600;
    local v31 = v27 % 3600 // 60;
    local v32 = v27 % 60;
    local v33 = {};

    if v28 > 0 then
        table.insert(v33, v28 .. "w");
    end;

    if v29 > 0 then
        table.insert(v33, v29 .. "d");
    end;

    if v30 > 0 then
        table.insert(v33, v30 .. "h");
    end;

    if v31 > 0 then
        table.insert(v33, v31 .. "m");
    end;

    if v32 > 0 then
        table.insert(v33, v32 .. "s");
    end;

    return #v33 == 0 and "0s" or table.concat(v33, " ");
end;

local function IsBoostActive(p34) -- Line: 142
    return (p34.BoostExpiresClock or 0) > os.clock();
end;

local function GetEffectiveRate(p35) -- Line: 150
    if (p35.BoostExpiresClock or 0) > os.clock() then
        return p35.StableGrowthAmount;
    end;

    return p35.PostBoostRate or p35.StableGrowthAmount;
end;

local function CalculateTimeRemaining(p36) -- Line: 162
    local v37 = p36.MaxAge - p36.CurrentAge;

    if v37 <= 0 then
        return 0;
    end;

    local StableGrowthAmount = p36.StableGrowthAmount;
    local v38 = p36.PostBoostRate or StableGrowthAmount;

    if (p36.BoostExpiresClock or 0) <= os.clock() or StableGrowthAmount <= 0 then
        return v38 <= 0 and 999999 or v37 / v38;
    end;

    local v39 = p36.BoostExpiresClock - os.clock();
    local v40 = v39 * StableGrowthAmount;

    if v37 <= v40 then
        return v37 / StableGrowthAmount;
    end;

    return v38 <= 0 and 999999 or v39 + (v37 - v40) / v38;
end;

local u41 = { {
        Name = "RainIcon",
        Emoji = "🌧️"
    }, {
        Name = "WateringIcon",
        Emoji = "💦"
    }, {
        Name = "SprinklerIcon",
        Emoji = "🚿"
    }, {
        Name = "DeerIcon",
        Emoji = "🦌"
    }, {
        Name = "ButterflyIcon",
        Image = "rbxassetid://139600117588287"
    } };

local function CreateBoostIndicator(p42) -- Line: 206
    -- upvalues: u41 (copy)
    local Frame = Instance.new("Frame");
    Frame.Name = "WateringBoostIndicator";
    Frame.AnchorPoint = Vector2.new(1, 0);
    Frame.AutomaticSize = Enum.AutomaticSize.X;
    Frame.BackgroundTransparency = 1;
    Frame.BorderSizePixel = 0;
    Frame.Position = UDim2.new(1, -4, 0, 2);
    Frame.Size = UDim2.fromOffset(0, 20);
    Frame.Visible = false;
    Frame.ZIndex = 50;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.Padding = UDim.new(0, 2);
    UIListLayout.Parent = Frame;

    for i, v in u41 do
        local v43;

        if v.Image then
            v43 = Instance.new("ImageLabel");
            v43.Image = v.Image;
            v43.ScaleType = Enum.ScaleType.Fit;
        else
            v43 = Instance.new("TextLabel");
            v43.Font = Enum.Font.GothamBold;
            v43.Text = v.Emoji;
            v43.TextScaled = true;
        end;

        v43.Name = v.Name;
        v43.BackgroundTransparency = 1;
        v43.BorderSizePixel = 0;
        v43.LayoutOrder = i;
        v43.Size = UDim2.fromOffset(20, 20);
        v43.Visible = false;
        v43.ZIndex = 50;
        v43.Parent = Frame;
    end;

    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "FastForward";
    TextLabel.BackgroundTransparency = 1;
    TextLabel.BorderSizePixel = 0;
    TextLabel.Font = Enum.Font.GothamBold;
    TextLabel.LayoutOrder = #u41 + 1;
    TextLabel.Size = UDim2.fromOffset(20, 20);
    TextLabel.Text = "⏩";
    TextLabel.TextColor3 = Color3.fromRGB(60, 220, 80);
    TextLabel.TextScaled = true;
    TextLabel.ZIndex = 50;
    TextLabel.Parent = Frame;
    Frame.Parent = p42;

    return Frame;
end;

local function PlayCompletionEffect(u44) -- Line: 270
    -- upvalues: u19 (copy), u21 (copy), u23 (ref), u20 (copy), u15 (ref), TweenService (copy), u3 (copy), Debris (copy)
    local u45 = u19[u44];

    if not u45 or u21[u44] then
        return;
    end;

    if not u23 then
        if u45 and u45.Parent then
            u45:Destroy();
        end;

        u19[u44] = nil;
        u20[u44] = nil;

        return;
    end;

    u21[u44] = true;
    u45.Main_Frame.ProgressBar.TextLabel.Text = "Done!";
    local Frame = u45.Main_Frame.ProgressBar.Frame;
    Frame.Size = UDim2.new(1, 0, Frame.Size.Y.Scale, Frame.Size.Y.Offset);
    local Main_Frame = u45.Main_Frame;
    local AbsolutePosition = Main_Frame.AbsolutePosition;
    local AbsoluteSize = Main_Frame.AbsoluteSize;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "CompletionFlash";
    Frame2.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame2.BackgroundTransparency = 0;
    Frame2.BorderSizePixel = 0;
    Frame2.ZIndex = Main_Frame.ZIndex + 10;
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame2.Position = UDim2.fromOffset(AbsolutePosition.X + AbsoluteSize.X / 2, AbsolutePosition.Y + AbsoluteSize.Y / 2);
    Frame2.Size = UDim2.fromOffset(AbsoluteSize.X, AbsoluteSize.Y);
    Frame2.Parent = u15;
    local v46 = TweenService:Create(Frame2, u3, {
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(AbsoluteSize.X * 1.5, AbsoluteSize.Y)
    });
    v46:Play();
    Debris:AddItem(v46, u3.Time);
    task.delay(0.2, function() -- Line: 322
        -- upvalues: Frame2 (copy)
        if Frame2 and Frame2.Parent then
            Frame2:Destroy();
        end;
    end);
    task.delay(2, function() -- Line: 329
        -- upvalues: u45 (copy), u19 (ref), u44 (copy), u20 (ref), u21 (ref)
        if u45 and u45.Parent then
            u45:Destroy();
        end;

        u19[u44] = nil;
        u20[u44] = nil;
        u21[u44] = nil;
    end);
end;

local function UpdateCanvasSize() -- Line: 341
    -- upvalues: u16 (ref)
    u16.CanvasSize = UDim2.new(0, 0, 0, u16.UIListLayout.AbsoluteContentSize.Y);
end;

u15 = PlayerGui:WaitForChild("GrowingList");
local Frame = u15:WaitForChild("Frame");
u16 = Frame:WaitForChild("Notepad"):WaitForChild("ScrollingFrame");
local u47 = #u16:GetChildren();

function UpdateScrollingFrame()
    -- upvalues: u16 (ref), u47 (copy), u23 (ref), Notification (copy)
    local v48 = #u16:GetChildren() - u47;

    if v48 <= 0 or u23 ~= false then
        Notification.Visible = false;

        return;
    end;

    Notification.Visible = true;
    Notification.InletTexture.TextLabel.TextLabel.Text = tostring(v48);
    Notification.InletTexture.TextLabel.Text = tostring(v48);
end;

u16.ChildAdded:Connect(function() -- Line: 361
    UpdateScrollingFrame();
end);
u16.ChildRemoved:Connect(function() -- Line: 365
    UpdateScrollingFrame();
end);

local function CreatePlantTemplate(u49, p50) -- Line: 370
    -- upvalues: u19 (copy), u22 (ref), u17 (ref), u10 (ref), GrowRateData (copy), u20 (copy), CalculateTimeRemaining (copy), FormatTimeRemaining (copy), u16 (ref), Networking (copy), DevProductController (copy)
    if (p50.Age or 0) >= (p50.MaxAge or 1) then
        return;
    end;

    if u19[u49] then
        return;
    end;

    u22 = u22 + 1;
    local v51 = u17:Clone();
    v51.Name = u49;
    v51.Visible = true;
    v51.LayoutOrder = u22;
    local PlantName = p50.PlantName;
    local v52 = u10:FindFirstChild(PlantName);

    if v52 then
        v51.Main_Frame.PlantImage.Image = v52.Value;
    end;

    local v53 = p50.Age or 0;
    local v54 = p50.MaxAge or 1;
    local v55 = GrowRateData[PlantName] and (GrowRateData[PlantName].GrowRate or 0.2) or 0.2;
    u20[u49] = {
        BoostExpiresClock = 0,
        BoostSources = 0,
        LastDisplayedPercent = 0,
        CurrentAge = v53,
        MaxAge = v54,
        StableGrowthAmount = v55,
        PostBoostRate = v55,
        PlantedAt = p50.PlantedAt or os.time(),
        PlantName = PlantName
    };
    local v56 = math.clamp(v53 / v54, 0, 1);
    local Frame2 = v51.Main_Frame.ProgressBar.Frame;
    Frame2.Size = UDim2.new(v56, 0, Frame2.Size.Y.Scale, Frame2.Size.Y.Offset);
    u20[u49].LastDisplayedPercent = v56;
    local v57 = CalculateTimeRemaining(u20[u49]);
    v51.Main_Frame.ProgressBar.TextLabel.Text = FormatTimeRemaining(v57);
    v51.LayoutOrder = v57;
    v51.Parent = u16;
    u19[u49] = v51;
    v51.Main_Frame.BevelEffect.GrowButton.MouseButton1Click:Connect(function() -- Line: 441
        -- upvalues: Networking (ref), u49 (copy), DevProductController (ref)
        Networking.GrowPlant:Fire(u49);
        DevProductController:PromptPurchase("Standalone:Grow Plant:1");
    end);
    u16.CanvasSize = UDim2.new(0, 0, 0, u16.UIListLayout.AbsoluteContentSize.Y);
end;

local function RemovePlantTemplate(p58) -- Line: 457
    -- upvalues: u19 (copy), u21 (copy), u20 (copy), u16 (ref)
    local v59 = u19[p58];

    if v59 and not u21[p58] then
        local v60 = u20[p58];

        if v60 and v60.ProgressTween then
            v60.ProgressTween:Cancel();
            v60.ProgressTween:Destroy();
            v60.ProgressTween = nil;
        end;

        v59:Destroy();
        u19[p58] = nil;
        u20[p58] = nil;
    end;

    u16.CanvasSize = UDim2.new(0, 0, 0, u16.UIListLayout.AbsoluteContentSize.Y);
end;

local function UpdatePlantTemplate(p61) -- Line: 479
    -- upvalues: u19 (copy), u20 (copy), u21 (copy), PlayCompletionEffect (copy), TweenService (copy), u2 (copy), CalculateTimeRemaining (copy), FormatTimeRemaining (copy)
    local v62 = u19[p61];
    local u63 = u20[p61];

    if not (v62 and u63) then
        return;
    end;

    if u21[p61] then
        return;
    end;

    local v64 = math.clamp(u63.CurrentAge / u63.MaxAge, 0, 1);

    if v64 >= 1 then
        PlayCompletionEffect(p61);

        return;
    end;

    if math.abs(v64 - (u63.LastDisplayedPercent or 0)) > 0.001 then
        local Frame2 = v62.Main_Frame.ProgressBar.Frame;
        local v65 = UDim2.new(v64, 0, Frame2.Size.Y.Scale, Frame2.Size.Y.Offset);

        if (u63.LastDisplayedPercent or 0) < v64 then
            local ProgressTween = u63.ProgressTween;

            if ProgressTween then
                ProgressTween:Cancel();
                ProgressTween:Destroy();
            end;

            local u66 = TweenService:Create(Frame2, u2, {
                Size = v65
            });
            u63.ProgressTween = u66;
            u66.Completed:Once(function() -- Line: 515
                -- upvalues: u63 (copy), u66 (copy)
                if u63.ProgressTween == u66 then
                    u63.ProgressTween = nil;
                end;

                u66:Destroy();
            end);
            u66:Play();
        else
            local ProgressTween = u63.ProgressTween;

            if ProgressTween then
                ProgressTween:Cancel();
                ProgressTween:Destroy();
                u63.ProgressTween = nil;
            end;

            Frame2.Size = v65;
        end;

        u63.LastDisplayedPercent = v64;
    end;

    local v67 = CalculateTimeRemaining(u63);
    v62.Main_Frame.ProgressBar.TextLabel.Text = FormatTimeRemaining(v67);
    v62.LayoutOrder = v67;
end;

local function UpdateGrowthRate(p68, p69, p70, p71, p72, p73) -- Line: 563
    -- upvalues: u20 (copy), u21 (copy)
    if u20[p68] and not u21[p68] then
        local v74 = u20[p68];

        if math.abs(p69 - v74.CurrentAge) > 0.5 or p70 <= 0 then
            v74.CurrentAge = p69;
        end;

        v74.StableGrowthAmount = p70;
        local v75 = p71 or 0;
        v74.BoostExpiresClock = v75 <= 0 and 0 or os.clock() + v75;
        v74.PostBoostRate = p72 or p70;
        v74.BoostSources = p73 or 0;
    end;
end;

local function UpdateList() -- Line: 586
    -- upvalues: u23 (ref), Frame (ref), u5 (copy), u18 (ref), u6 (copy), u7 (copy), u8 (copy)
    if u23 then
        Frame.Position = u7;
        u18.Position = u8;
        u18.TextLabel.Text = "<";
        u18.TextLabel.TextLabel.Text = "<";

        return;
    end;

    Frame.Position = u5;
    u18.Position = u6;
    u18.TextLabel.Text = ">";
    u18.TextLabel.TextLabel.Text = ">";
end;

local function ToggleList() -- Line: 601
    -- upvalues: u23 (ref), Frame (ref), u5 (copy), u18 (ref), u6 (copy), u7 (copy), u8 (copy), u20 (copy), UpdatePlantTemplate (copy)
    if u23 then
        Frame.Position = u7;
        u18.Position = u8;
        u18.TextLabel.Text = "<";
        u18.TextLabel.TextLabel.Text = "<";
    else
        Frame.Position = u5;
        u18.Position = u6;
        u18.TextLabel.Text = ">";
        u18.TextLabel.TextLabel.Text = ">";
    end;

    u23 = not u23;

    if u23 then
        for i in u20 do
            UpdatePlantTemplate(i);
        end;
    end;

    UpdateScrollingFrame();
end;

local function LoadExistingPlants() -- Line: 618
    -- upvalues: u9 (ref), LocalPlayer (copy), CreatePlantTemplate (copy)
    local v76 = {};

    for i, v in u9:GetGarden(LocalPlayer.UserId) do
        if (v.Age or 0) < (v.MaxAge or 1) then
            table.insert(v76, {
                Id = i,
                Data = v
            });
        end;
    end;

    table.sort(v76, function(p77, p78) -- Line: 631
        return (p77.Data.PlantedAt or 0) < (p78.Data.PlantedAt or 0);
    end);

    for _, v in v76 do
        CreatePlantTemplate(v.Id, v.Data);
    end;
end;

function v1.Init(p79) -- Line: 640
    -- upvalues: u9 (ref), LocalPlayer (copy), u10 (ref), ReplicatedStorage (copy), u15 (ref), PlayerGui (copy), Frame (ref), u16 (ref), u17 (ref), u18 (ref), u23 (ref), u7 (copy), u8 (copy)
    u9 = require(LocalPlayer.PlayerScripts:WaitForChild("Controllers"):WaitForChild("GardenSyncController"));
    u10 = ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("SeedData"):WaitForChild("FruitImages");
    u15 = PlayerGui:WaitForChild("GrowingList");
    Frame = u15:WaitForChild("Frame");
    u16 = Frame:WaitForChild("Notepad"):WaitForChild("ScrollingFrame");
    u17 = u16:WaitForChild("Template");
    u18 = u15:WaitForChild("Exit"):WaitForChild("ExitButton");
    u17.Visible = false;
    u16.CanvasSize = UDim2.new(0, 0, 0, u16.UIListLayout.AbsoluteContentSize.Y);
    u23 = false;
    Frame.Position = u7;
    u18.Position = u8;
    u18.TextLabel.Text = "<";
    u18.TextLabel.TextLabel.Text = "<";
    UpdateScrollingFrame();
end;

function v1.Start(p80) -- Line: 668
    -- upvalues: ReplicatedStorage (copy), u24 (ref), u9 (ref), LocalPlayer (copy), CreatePlantTemplate (copy), RemovePlantTemplate (copy), UpdateGrowthRate (copy), u20 (copy), u21 (copy), RunService (copy), u23 (ref), UpdatePlantTemplate (copy), PlayCompletionEffect (copy), GuiController (copy), u18 (ref), MenuOpenClose (copy), Frame (ref), u5 (copy), u6 (copy), u7 (copy), u8 (copy), Players (copy), LoadExistingPlants (copy)
    task.spawn(function() -- Line: 672
        -- upvalues: ReplicatedStorage (ref), u24 (ref)
        local WeatherValues = ReplicatedStorage:WaitForChild("WeatherValues", 30);

        if not WeatherValues then
            return;
        end;

        local function RefreshRain() -- Line: 675
            -- upvalues: u24 (ref), WeatherValues (copy)
            u24 = WeatherValues:GetAttribute("Rain_Playing") == true;
        end;

        u24 = WeatherValues:GetAttribute("Rain_Playing") == true;
        WeatherValues:GetAttributeChangedSignal("Rain_Playing"):Connect(RefreshRain);
    end);
    u9:OnPlantAdded(function(p81, p82, p83) -- Line: 683
        -- upvalues: LocalPlayer (ref), CreatePlantTemplate (ref)
        if p81 == LocalPlayer.UserId then
            CreatePlantTemplate(p82, p83);
        end;
    end);
    u9:OnPlantRemoved(function(p84, p85) -- Line: 690
        -- upvalues: LocalPlayer (ref), RemovePlantTemplate (ref)
        if p84 == LocalPlayer.UserId then
            RemovePlantTemplate(p85);
        end;
    end);
    u9:OnPlantGrowthUpdated(function(p86, p87, p88, p89, p90, p91, p92) -- Line: 697
        -- upvalues: LocalPlayer (ref), UpdateGrowthRate (ref)
        if p86 == LocalPlayer.UserId then
            UpdateGrowthRate(p87, p88, p89, p90, p91, p92);
        end;
    end);
    u9:OnPlantAgeSync(function(p93, p94) -- Line: 704
        -- upvalues: LocalPlayer (ref), u20 (ref), u21 (ref)
        if p93 == LocalPlayer.UserId then
            for i, v in p94 do
                if u20[i] and (not u21[i] and u20[i].CurrentAge < v) then
                    u20[i].CurrentAge = v;
                end;
            end;
        end;
    end);
    local u95 = 0;
    RunService.Heartbeat:Connect(function(p96) -- Line: 720
        -- upvalues: u95 (ref), u20 (ref), u21 (ref)
        u95 = u95 + p96;

        if u95 < 0.25 then
            return;
        end;

        local v97 = u95;
        u95 = 0;
        debug.profilebegin("Controllers/GrowingListController/Heartbeat/simulatePlantGrowth");

        for i, v in u20 do
            if not u21[i] and v.CurrentAge < v.MaxAge then
                local v98;

                if (v.BoostExpiresClock or 0) > os.clock() then
                    v98 = v.StableGrowthAmount;
                else
                    v98 = v.PostBoostRate or v.StableGrowthAmount;
                end;

                v.CurrentAge = math.min(v.CurrentAge + v97 * v98, v.MaxAge);
            end;
        end;

        debug.profileend();
    end);
    task.spawn(function() -- Line: 741
        -- upvalues: u23 (ref), u20 (ref), UpdatePlantTemplate (ref), u21 (ref), PlayCompletionEffect (ref)
        while true do
            while true do
                task.wait(1);

                if not u23 then
                    break;
                end;

                debug.profilebegin("Controllers/GrowingListController/UI/UpdateAllPlantTemplates");

                for i in u20 do
                    UpdatePlantTemplate(i);
                end;

                debug.profileend();
            end;

            debug.profilebegin("Controllers/GrowingListController/UI/ClosedCompletionSweep");

            for i, v in u20 do
                if not u21[i] and v.CurrentAge >= v.MaxAge then
                    PlayCompletionEffect(i);
                end;
            end;

            debug.profileend();
        end;
    end);
    GuiController:Hook("Click", u18).Clicked:Connect(function() -- Line: 770
        -- upvalues: MenuOpenClose (ref), u23 (ref), Frame (ref), u5 (ref), u18 (ref), u6 (ref), u7 (ref), u8 (ref), u20 (ref), UpdatePlantTemplate (ref)
        MenuOpenClose.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
        MenuOpenClose.TimePosition = 0;
        MenuOpenClose.Playing = true;

        if u23 then
            Frame.Position = u7;
            u18.Position = u8;
            u18.TextLabel.Text = "<";
            u18.TextLabel.TextLabel.Text = "<";
        else
            Frame.Position = u5;
            u18.Position = u6;
            u18.TextLabel.Text = ">";
            u18.TextLabel.TextLabel.Text = ">";
        end;

        u23 = not u23;

        if u23 then
            for i in u20 do
                UpdatePlantTemplate(i);
            end;
        end;

        UpdateScrollingFrame();
    end);
    task.spawn(function() -- Line: 787
        -- upvalues: LocalPlayer (ref), Players (ref), LoadExistingPlants (ref)
        repeat
            task.wait();
        until LocalPlayer:HasTag("DataLoaded") or not LocalPlayer:IsDescendantOf(Players);

        if not LocalPlayer:IsDescendantOf(Players) then
            return;
        end;

        task.wait(0.5);
        LoadExistingPlants();
    end);
end;

return v1;