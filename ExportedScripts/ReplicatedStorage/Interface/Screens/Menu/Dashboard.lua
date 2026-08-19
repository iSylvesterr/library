-- Decompiled with Potassium's decompiler.

local MarketplaceService = game:GetService("MarketplaceService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local PolicyService = game:GetService("PolicyService");
local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
local HttpService = game:GetService("HttpService");
require(ReplicatedStorage.Database.Custom.Types);
local ConfigKeys = require(ReplicatedStorage.Database.Custom.ConfigKeys);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local ConfigController = require(ReplicatedStorage.Controllers.ConfigController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Profiler = require(ReplicatedStorage.Shared.Profiler);
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local DevProducts = require(ReplicatedStorage.Database.Custom.GameStats.Monetization.DevProducts);
local MissionStars = require(ReplicatedStorage.Database.Custom.GameStats.MissionStars);
local Missions = require(ReplicatedStorage.Database.Custom.GameStats.Missions);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local Store = require(ReplicatedStorage.Interface.Screens.Menu.Store);
local Top = require(ReplicatedStorage.Interface.Screens.Menu.Top);
local UpdateLogs = require(ReplicatedStorage.Database.Custom.UpdateLogs);
local LocalPlayer = Players.LocalPlayer;
local u1 = {};
local u2 = {};

for _, v in { "News", "Featured", "Verify" } do
    u1[v] = true;
end;

local v3 = { "MedalEvent" };
table.insert(v3, "Missions");
table.insert(v3, "MissionStars");
local u4 = {};
local u5 = {
    ["Featured Bundle"] = "Purchase Featured Bundle",
    StarterPack = "Credits Starter Pack"
};

for _, v in v3 do
    u4[v] = true;
end;

local u6 = nil;
local u7 = tick();
local u8 = false;
local u9 = 1;
local u10 = {};
local EditMobile = require(script:WaitForChild("EditMobile"));
local MedalEvent = require(script:WaitForChild("MedalEvent"));
local u11 = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 236, 160)), ColorSequenceKeypoint.new(1, Color3.fromRGB(235, 216, 141)) });
local u12 = Color3.fromRGB(255, 255, 255);
local u13 = Color3.fromRGB(201, 201, 201);
local u14 = Color3.fromRGB(50, 46, 46);
local u15 = Color3.fromRGB(50, 46, 46);
local u16 = Color3.fromRGB(255, 255, 255);
local u17 = Color3.fromRGB(207, 207, 207);
local u18 = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(160, 255, 157)), ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 225, 95)) });
local u19 = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(125, 125, 125)), ColorSequenceKeypoint.new(1, Color3.fromRGB(65, 65, 65)) });
local u20 = nil;

local function SetMissionUIVisible(p21) -- Line: 115
    -- upvalues: u20 (ref)
    if not u20 then
        return;
    end;

    local Holder = u20:FindFirstChild("Holder");

    if not Holder then
        return;
    end;

    local Missions2 = Holder:FindFirstChild("Missions");

    if Missions2 and Missions2:IsA("Frame") then
        Missions2.Visible = p21;
    end;

    local MissionStars2 = Holder:FindFirstChild("MissionStars");

    if MissionStars2 and MissionStars2:IsA("Frame") then
        MissionStars2.Visible = p21;
    end;
end;

local function CommaNumber(p22) -- Line: 136
    return tostring(p22):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
end;

local function EncodeForDebug(u23) -- Line: 142
    -- upvalues: HttpService (copy)
    local success, result = pcall(function() -- Line: 143
        -- upvalues: HttpService (ref), u23 (copy)
        return HttpService:JSONEncode(u23);
    end);

    return success and result and result or "<json-encode-failed>";
end;

local function IsMissionStarRewardClaimed(p24, p25) -- Line: 152
    if typeof(p24) ~= "table" then
        return false;
    end;

    local v26 = p24[tostring(p25)];

    if v26 == nil then
        v26 = p24[p25];
    end;

    if typeof(v26) == "string" then
        return string.lower(v26) == "true";
    end;

    return v26 == true;
end;

local function DebugMissionStarsState(p27) -- Line: 171
end;

local function GetMissionStarsProgressScale(p28) -- Line: 210
    -- upvalues: u20 (ref), MissionStars (copy)
    local Stars = u20.Right.Missions.Holder.Stars;
    local Bar = Stars.Frame.Bar;
    local Container = Stars.Frame.Container;
    local v29 = #MissionStars;
    local X = Bar.AbsoluteSize.X;
    local X2 = Bar.AbsolutePosition.X;

    if p28 <= 0 then
        return 0;
    end;

    if X <= 0 then
        local v30 = p28 / math.max(v29, 1);

        return math.clamp(v30, 0, 1);
    end;

    local function getMarkerCenterX(p31) -- Line: 226
        -- upvalues: Container (copy)
        local v32 = Container:FindFirstChild((tostring(p31)));

        if not (v32 and v32:IsA("GuiButton")) then
            return nil;
        end;

        local Star = v32:FindFirstChild("Star");

        if Star then
            if not Star:IsA("GuiObject") then
                Star = v32;
            end;
        else
            Star = v32;
        end;

        return Star.AbsolutePosition.X + Star.AbsoluteSize.X * 0.5;
    end;

    local v33 = math.clamp(p28, 0, v29);
    local v34 = getMarkerCenterX(v33);

    if not v34 then
        local v35 = v33 / math.max(v29, 1);

        return math.clamp(v35, 0, 1);
    end;

    local v36 = getMarkerCenterX(v33 + 1);

    if v36 then
        v34 = v36;
    elseif v29 <= v33 then
        v34 = X2 + X;
    end;

    return math.clamp((v34 - X2) / X, 0, 1);
end;

local function UpdateMissionStarsProgressBar(p37, p38) -- Line: 260
    -- upvalues: u20 (ref), GetMissionStarsProgressScale (copy), u16 (copy), u17 (copy), TweenService (copy)
    local Bar = u20.Right.Missions.Holder.Stars.Frame.Bar;
    local Progress = Bar.Progress;
    local v39 = UDim2.fromScale(GetMissionStarsProgressScale(p37), 1);
    Bar.BackgroundColor3 = u16;

    if Bar:IsA("ImageLabel") or Bar:IsA("ImageButton") then
        Bar.ImageColor3 = u16;
    end;

    Progress.BackgroundColor3 = u17;

    if p38 and u20.Visible then
        TweenService:Create(Progress, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = v39
        }):Play();

        return;
    end;

    Progress.Size = v39;
end;

local function GetTimerFormat(p40) -- Line: 284
    return string.format("%i:%02i:%02i:%02i", math.floor(p40 / 86400), math.floor(p40 % 86400 / 3600), math.floor(p40 % 3600 / 60), p40 % 60);
end;

local function GetTimerFormatHMS(p41) -- Line: 296
    return string.format("%02i:%02i:%02i", math.floor(p41 / 3600), math.floor(p41 % 3600 / 60), p41 % 60);
end;

local function GetTimerColor(p42) -- Line: 307
    return p42 > 600 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(255, 85, 85);
end;

local function UpdateNewsPage() -- Line: 313
    -- upvalues: Profiler (copy), u20 (ref), u10 (copy), u9 (ref), u12 (copy), u15 (copy), u13 (copy), u14 (copy)
    Profiler.mark("UI.Dashboard.UpdateNewsPage");
    local Bottom = u20.Left.News.Frame.Bottom;
    local v43 = #u10;
    Bottom.Right.ImageColor3 = v43 > 1 and (u9 < v43 and u12) or u15;
    Bottom.Left.ImageColor3 = u9 > 1 and u12 or u15;

    for i, v in u10 do
        v.Visible = i == u9;
    end;

    for _, child in Bottom:GetChildren() do
        if child:IsA("Frame") and (child.Name ~= "Left" and child.Name ~= "Right") then
            child.BackgroundColor3 = child.Name == u10[u9].Name and u13 or u14;
        end;
    end;
end;

local function GetNewsTabNews(p44) -- Line: 336
    if p44.Name == "NewsTab1" then
        return "Featured Bundle";
    end;

    if p44.Name == "NewsTab2" then
        return "StarterPack";
    end;

    local v45 = p44:GetAttribute("News");

    if typeof(v45) == "string" then
        return v45;
    end;

    return nil;
end;

local function OpenNewsStoreDestination(p46) -- Line: 350
    -- upvalues: Top (copy), MenuState (copy), Store (copy)
    local Button = p46:FindFirstChild("Button");

    if not (Button and Button:IsA("GuiButton")) then
        return;
    end;

    if Button:GetAttribute("Page") ~= "Store" then
        return;
    end;

    local v47 = Button:GetAttribute("Tab");
    Top.openFrame("Store");

    if MenuState.GetCurrentScreen() ~= "Store" then
        return;
    end;

    if v47 ~= "Bundle" then
        local v48;

        if p46.Name == "NewsTab1" then
            v48 = "Featured Bundle";
        elseif p46.Name == "NewsTab2" then
            v48 = "StarterPack";
        else
            v48 = p46:GetAttribute("News");

            if typeof(v48) ~= "string" then
                v48 = nil;
            end;
        end;

        if v48 ~= "Featured Bundle" then
            if v47 == "Cases" or (v47 == "Credits" or v47 == "Featured") then
                Store.OpenTab(v47);
            end;

            return;
        end;
    end;

    Store.OpenBundleSection();
end;

local function GetNewsPurchaseProductName(p49) -- Line: 379
    -- upvalues: u5 (copy)
    local v50 = p49:GetAttribute("ProductName") or (p49:GetAttribute("Product") or p49:GetAttribute("DevProduct"));

    if typeof(v50) == "string" and v50 ~= "" then
        return v50;
    end;

    local v51;

    if p49.Name == "NewsTab1" then
        v51 = "Featured Bundle";
    elseif p49.Name == "NewsTab2" then
        v51 = "StarterPack";
    else
        v51 = p49:GetAttribute("News");

        if typeof(v51) ~= "string" then
            v51 = nil;
        end;
    end;

    if v51 then
        return u5[v51];
    end;

    return nil;
end;

local function PromptNewsPurchase(p52) -- Line: 398
    -- upvalues: MenuState (copy), Router (copy), DataController (copy), LocalPlayer (copy), Store (copy), GetNewsPurchaseProductName (copy), DevProducts (copy), MarketplaceService (copy)
    if not MenuState.IsStoreEnabled() then
        Router.broadcastRouter("RunInterfaceSound", "UI Store Click");

        return;
    end;

    local v53;

    if p52.Name == "NewsTab1" then
        v53 = "Featured Bundle";
    elseif p52.Name == "NewsTab2" then
        v53 = "StarterPack";
    else
        v53 = p52:GetAttribute("News");

        if typeof(v53) ~= "string" then
            v53 = nil;
        end;
    end;

    if v53 == "StarterPack" then
        if not DataController.IsDataLoaded(LocalPlayer) then
            return;
        end;

        if not Store.IsStarterPackAvailable() then
            p52:Destroy();

            return;
        end;
    end;

    local v54 = GetNewsPurchaseProductName(p52);

    if v54 then
        v54 = DevProducts[v54];
    end;

    if v54 then
        MarketplaceService:PromptProductPurchase(LocalPlayer, v54.DevProductId);

        return;
    end;

    warn((`[Dashboard] Missing dev product for news tab {p52.Name}`));
end;

local function FillNewsPurchasePrice(p55, p56) -- Line: 426
    -- upvalues: GetNewsPurchaseProductName (copy), DevProducts (copy), MarketplaceService (copy)
    local u57 = GetNewsPurchaseProductName(p55);

    if u57 then
        u57 = DevProducts[u57];
    end;

    if not u57 then
        return;
    end;

    local Redeem = p56:FindFirstChild("Redeem");
    local u58 = Redeem and Redeem:FindFirstChild("Container") and Redeem.Container:FindFirstChild("Title");

    if not u58 then
        return;
    end;

    task.spawn(function() -- Line: 439
        -- upvalues: MarketplaceService (ref), u57 (copy), u58 (copy)
        local success, result = pcall(function() -- Line: 440
            -- upvalues: MarketplaceService (ref), u57 (ref)
            return MarketplaceService:GetProductInfoAsync(u57.DevProductId, Enum.InfoType.Product);
        end);

        if not (success and (result and result.PriceInRobux)) then
            return;
        end;

        local v59 = utf8.char(57346);

        if u58 then
            u58.Text = `{v59}{tostring(result.PriceInRobux):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")}`;
        end;
    end);
end;

local function SetupNewsTab(u60) -- Line: 456
    -- upvalues: FillNewsPurchasePrice (copy), ActivateButton (copy), Router (copy), PromptNewsPurchase (copy), OpenNewsStoreDestination (copy)
    local Bottom = u60:FindFirstChild("Bottom");

    if Bottom then
        Bottom = Bottom:FindFirstChild("Container");
    end;

    if Bottom then
        Bottom = Bottom:FindFirstChild("Information");
    end;

    if Bottom then
        Bottom = Bottom:FindFirstChild("Buttons");
    end;

    if Bottom then
        FillNewsPurchasePrice(u60, Bottom);
    end;

    local v61;

    if u60.Name == "NewsTab1" then
        v61 = "Featured Bundle";
    elseif u60.Name == "NewsTab2" then
        v61 = "StarterPack";
    else
        v61 = u60:GetAttribute("News");

        if typeof(v61) ~= "string" then
            v61 = nil;
        end;
    end;

    if v61 ~= "StarterPack" then
        if not Bottom then
            for _, v in ipairs({ "Button", "Inspect" }) do
                local v62 = u60:FindFirstChild(v);

                if v62 and v62:IsA("GuiButton") then
                    ActivateButton(v62);
                    v62.MouseButton1Click:Connect(function() -- Line: 495
                        -- upvalues: Router (ref), OpenNewsStoreDestination (ref), u60 (copy)
                        Router.broadcastRouter("RunInterfaceSound", "UI Click");
                        OpenNewsStoreDestination(u60);
                    end);
                end;
            end;

            return;
        end;

        ActivateButton(Bottom.Redeem);
        Bottom.Redeem.MouseButton1Click:Connect(function() -- Line: 486
            -- upvalues: Router (ref), PromptNewsPurchase (ref), u60 (copy)
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
            PromptNewsPurchase(u60);
        end);

        return;
    end;

    if Bottom then
        ActivateButton(Bottom.Redeem);
        Bottom.Redeem.MouseButton1Click:Connect(function() -- Line: 470
            -- upvalues: Router (ref), PromptNewsPurchase (ref), u60 (copy)
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
            PromptNewsPurchase(u60);
        end);
    end;

    local Inspect = u60:FindFirstChild("Inspect");

    if not (Inspect and Inspect:IsA("GuiButton")) then
        return;
    end;

    ActivateButton(Inspect);
    Inspect.MouseButton1Click:Connect(function() -- Line: 479
        -- upvalues: Router (ref), OpenNewsStoreDestination (ref), u60 (copy)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        OpenNewsStoreDestination(u60);
    end);
end;

local function ScaleUdim2(p63, p64) -- Line: 507
    return UDim2.new(p63.X.Scale * p64, p63.X.Offset * p64, p63.Y.Scale * p64, p63.Y.Offset * p64);
end;

local function SetupTradingHover(p65) -- Line: 513
    -- upvalues: ActivateButton (copy), Router (copy), Remotes (copy)
    local Button = p65:FindFirstChild("Button", true);

    if not (Button and Button:IsA("GuiButton")) then
        return;
    end;

    ActivateButton(Button);
    Button.Activated:Connect(function() -- Line: 520
        -- upvalues: Router (ref), Remotes (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        Remotes.Modes.SelectGamemode.Send("Trading");
    end);
end;

local function SetupNewsGunHover(p66, p67) -- Line: 528
    -- upvalues: TweenService (copy)
    local Gun = p66:FindFirstChild("Gun");

    if not (Gun and Gun:IsA("GuiObject")) then
        return;
    end;

    local Size = Gun.Size;
    local u68 = false;
    local u69 = nil;

    local function tweenScale(p70, p71) -- Line: 538
        -- upvalues: u69 (ref), TweenService (ref), Gun (copy), Size (copy)
        if u69 then
            u69:Cancel();
        end;

        local v72 = TweenInfo.new(p71 or 0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        local v73 = {};
        local v74 = Size;
        v73.Size = UDim2.new(v74.X.Scale * p70, v74.X.Offset * p70, v74.Y.Scale * p70, v74.Y.Offset * p70);
        local v75 = TweenService:Create(Gun, v72, v73);
        u69 = v75;
        v75:Play();
    end;

    p67.MouseEnter:Connect(function() -- Line: 552
        -- upvalues: u68 (ref), tweenScale (copy)
        u68 = true;
        tweenScale(1.04);
    end);
    p67.MouseLeave:Connect(function() -- Line: 557
        -- upvalues: u68 (ref), tweenScale (copy)
        u68 = false;
        tweenScale(1);
    end);
    p67.InputBegan:Connect(function(p76) -- Line: 562
        -- upvalues: tweenScale (copy)
        if p76.UserInputType == Enum.UserInputType.MouseButton1 or p76.UserInputType == Enum.UserInputType.Touch then
            tweenScale(1.02, 0.08);
        end;
    end);
    p67.InputEnded:Connect(function(p77) -- Line: 571
        -- upvalues: tweenScale (copy), u68 (ref)
        if p77.UserInputType == Enum.UserInputType.MouseButton1 or p77.UserInputType == Enum.UserInputType.Touch then
            tweenScale(u68 and 1.04 or 1, 0.12);
        end;
    end);
end;

local function GetMissionFromId(p78) -- Line: 583
    -- upvalues: DataController (copy), LocalPlayer (copy)
    local v79 = DataController.Get(LocalPlayer, "Missions");

    if v79 then
        for _, v in ipairs(v79) do
            if v.MissionId == p78 then
                return v;
            end;
        end;

        return nil;
    end;
end;

local function ClearFrame(p80, p81) -- Line: 600
    local v82 = p80:GetChildren();

    for _, v in ipairs(v82) do
        if v:IsA("Frame") and not (table.find(p81, v.Name) or table.find(p81, v.ClassName)) then
            v:Destroy();
        end;
    end;
end;

local function GetEarliestExpirationTime(p83) -- Line: 616
    -- upvalues: DataController (copy), LocalPlayer (copy), Missions (copy)
    if not p83 then
        return nil;
    end;

    local v84 = DataController.Get(LocalPlayer, "Missions");

    if not v84 then
        return nil;
    end;

    local v85 = os.time() * 1000;
    local v86 = nil;

    for _, v in ipairs(v84) do
        local v87 = Missions.GetMissionDefinition(v.MissionId);

        if v87 and (v87.Type == p83 and (v.ExpiresAt > 0 and (v85 < v.ExpiresAt and (not v86 or v.ExpiresAt < v86)))) then
            v86 = v.ExpiresAt;
        end;
    end;

    return v86;
end;

local function GetMissionCreditRewardAmount(p88) -- Line: 647
    -- upvalues: ConfigKeys (copy), ConfigController (copy)
    local v89 = p88.Rewards[1];

    if v89.type ~= "Credits" or typeof(v89.amount) ~= "number" then
        return 0;
    end;

    local v90 = ConfigKeys.Shared.MissionCreditRewardMultipliers[p88.Type];
    local v91 = not v90 and 1 or ConfigController.GetRewardMultiplier(v90);

    return math.round(v89.amount * v91);
end;

local function IsExternalLinkAllowed(p92, p93) -- Line: 660
    return table.find(p92, p93) ~= nil;
end;

local function SetupFeaturedSection(p94) -- Line: 666
    -- upvalues: UpdateLogs (copy), ActivateButton (copy), u20 (ref)
    local Container = p94.Featured.Container;
    local Information = Container.Bottom.Container.Information;
    local v95 = UpdateLogs[1];
    Container.ImageContent.Image.Image = v95.Banner;
    Information.Label.Text = v95.Title;
    Information.Description.Text = v95.Date;
    local Button = Information.Buttons.Button;
    ActivateButton(Button);
    Button.Container.Title.Text = "View Updates";
    Button.MouseButton1Click:Connect(function() -- Line: 678
        -- upvalues: u20 (ref)
        u20.Parent.Updates.Visible = true;
    end);
end;

local function CompareNewsTabs(p96, p97) -- Line: 686
    local v98;

    if p96.Name == "NewsTab1" then
        v98 = "Featured Bundle";
    elseif p96.Name == "NewsTab2" then
        v98 = "StarterPack";
    else
        v98 = p96:GetAttribute("News");

        if typeof(v98) ~= "string" then
            v98 = nil;
        end;
    end;

    if v98 == "StarterPack" then
        return true;
    end;

    local v99;

    if p97.Name == "NewsTab1" then
        v99 = "Featured Bundle";
    elseif p97.Name == "NewsTab2" then
        v99 = "StarterPack";
    else
        v99 = p97:GetAttribute("News");

        if typeof(v99) ~= "string" then
            v99 = nil;
        end;
    end;

    if v99 == "StarterPack" then
        return false;
    end;

    return (tonumber(string.gsub(p96.Name, "NewsTab", "")) or 0) < (tonumber(string.gsub(p97.Name, "NewsTab", "")) or 0);
end;

local function SetupNewsTabsDeferred(u100) -- Line: 700
    -- upvalues: DataController (copy), LocalPlayer (copy), Store (copy), u10 (copy), SetupNewsTab (copy), CompareNewsTabs (copy), ReplicatedStorage (copy), u14 (copy), UpdateNewsPage (copy)
    task.spawn(function() -- Line: 701
        -- upvalues: DataController (ref), LocalPlayer (ref), u100 (copy), Store (ref), u10 (ref), SetupNewsTab (ref), CompareNewsTabs (ref), ReplicatedStorage (ref), u14 (ref), UpdateNewsPage (ref)
        DataController.WaitForDataLoaded(LocalPlayer);
        local Frame = u100.News.Frame;

        for _, child in Frame:GetChildren() do
            if child:IsA("Frame") and string.find(child.Name, "NewsTab") then
                local v101;

                if child.Name == "NewsTab1" then
                    v101 = "Featured Bundle";
                elseif child.Name == "NewsTab2" then
                    v101 = "StarterPack";
                else
                    v101 = child:GetAttribute("News");

                    if typeof(v101) ~= "string" then
                        v101 = nil;
                    end;
                end;

                if v101 == "StarterPack" and not Store.IsStarterPackAvailable() then
                    child:Destroy();
                else
                    table.insert(u10, child);
                    SetupNewsTab(child);
                end;
            end;
        end;

        table.sort(u10, CompareNewsTabs);
        local Bottom = Frame.Bottom;
        Bottom.Right.LayoutOrder = 999;
        Bottom.Left.LayoutOrder = 0;

        for i, v in ipairs(u10) do
            local v102 = ReplicatedStorage.Assets.UI.News.TabFrame:Clone();
            v102.BackgroundColor3 = u14;
            v102.Name = v.Name;
            v102.Parent = Bottom;
            v102.LayoutOrder = i;
        end;

        UpdateNewsPage();
    end);
end;

local function ShiftNewsPage(p103) -- Line: 739
    -- upvalues: u10 (copy), Router (copy), u7 (ref), u9 (ref), UpdateNewsPage (copy)
    if #u10 == 0 then
        return;
    end;

    Router.broadcastRouter("RunInterfaceSound", "UI Click");
    u7 = tick();

    if p103 < 0 then
        u9 = (u9 - 2) % #u10 + 1;
    else
        u9 = u9 % #u10 + 1;
    end;

    UpdateNewsPage();
end;

local function SetupNewsPagination(p104) -- Line: 758
    -- upvalues: u10 (copy), Router (copy), u7 (ref), u9 (ref), UpdateNewsPage (copy)
    local Bottom = p104.News.Frame.Bottom;
    Bottom.Left.MouseButton1Click:Connect(function() -- Line: 760
        -- upvalues: u10 (ref), Router (ref), u7 (ref), u9 (ref), UpdateNewsPage (ref)
        if #u10 == 0 then
            return;
        end;

        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        u7 = tick();
        u9 = (u9 - 2) % #u10 + 1;
        UpdateNewsPage();
    end);
    Bottom.Right.MouseButton1Click:Connect(function() -- Line: 763
        -- upvalues: u10 (ref), Router (ref), u7 (ref), u9 (ref), UpdateNewsPage (ref)
        if #u10 == 0 then
            return;
        end;

        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        u7 = tick();
        u9 = u9 % #u10 + 1;
        UpdateNewsPage();
    end);
end;

local function SetupRedeemCode(p105) -- Line: 770
    -- upvalues: ActivateButton (copy), DataController (copy), LocalPlayer (copy), Router (copy), Remotes (copy)
    local Frame = p105.RedeemCode.Frame;
    ActivateButton(Frame.Redeem);
    Frame.Redeem.MouseButton1Click:Connect(function() -- Line: 773
        -- upvalues: DataController (ref), LocalPlayer (ref), Router (ref), Frame (copy), Remotes (ref)
        local v106 = DataController.Get(LocalPlayer, "Level");
        Router.broadcastRouter("RunInterfaceSound", "UI Click");

        if v106.Level < 5 then
            Router.broadcastRouter("CreateMenuNotification", "Error", "You need to be atleast level 5 to redeem codes.");

            return;
        end;

        local Text = Frame.Holder.TextBox.Text;

        if tostring(Text) == "" then
            Router.broadcastRouter("CreateMenuNotification", "Error", "Invalid code. Please try again.");

            return;
        end;

        Frame.Holder.TextBox.Text = "";
        Remotes.Dashboard.RedeemCode.Send(Text);
    end);
end;

local function SetupRedeemCodeInfo() -- Line: 799
    -- upvalues: u20 (ref), ActivateButton (copy), Router (copy)
    local More = u20.Left.RedeemCode.Header.Container.More;
    ActivateButton(More);
    More.MouseButton1Click:Connect(function() -- Line: 802
        -- upvalues: u20 (ref), Router (ref)
        u20.RedeemCodeInfo.Visible = not u20.RedeemCodeInfo.Visible;
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
    end);
    local Close = u20.RedeemCodeInfo.Container.Action.Close;
    ActivateButton(Close);
    Close.MouseButton1Click:Connect(function() -- Line: 809
        -- upvalues: Router (ref), u20 (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        u20.RedeemCodeInfo.Visible = false;
    end);
end;

local function SetupAdvertisementVisibility(u107, u108) -- Line: 817
    -- upvalues: u20 (ref)
    u107.Visible = u108;
    u107:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 820
        -- upvalues: u107 (copy), u108 (copy), u20 (ref)
        if not u107.Visible then
            u107.Visible = u108 and u20.Visible;
        end;
    end);
    u20:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 826
        -- upvalues: u108 (copy), u20 (ref), u107 (copy)
        local v109 = u108 and u20.Visible;

        if u107.Visible ~= v109 then
            u107.Visible = v109;
        end;
    end);
end;

local function SetupPlayerPolicies(p110, p111) -- Line: 836
    -- upvalues: PolicyService (copy), LocalPlayer (copy), Profiler (copy), SetupTradingHover (copy), SetupAdvertisementVisibility (copy), SetupRedeemCodeInfo (copy), u20 (ref)
    local success, result = pcall(PolicyService.GetPolicyInfoForPlayerAsync, PolicyService, LocalPlayer);
    Profiler.mark("UI.Dashboard.Initialize.PolicyLoaded");
    local Trading = p110.Trading;

    if success and (result and result.IsPaidItemTradingAllowed == true) then
        SetupTradingHover(Trading);
    else
        Trading:Destroy();
    end;

    local v112;

    if success and result then
        v112 = result.AllowedExternalLinkReferences;
    else
        v112 = nil;
    end;

    if not v112 then
        p110.RedeemCode.Header.Container.More.Visible = false;
        p111.Advertisement.Visible = false;
        u20.RedeemCodeInfo.Visible = false;

        return;
    end;

    local v113 = table.find(v112, "Discord") ~= nil;
    SetupAdvertisementVisibility(p111.Advertisement, v113);
    p110.RedeemCode.Frame.Bottom.Visible = true;

    if p110.RedeemCode.Header.Container.More.Visible then
        SetupRedeemCodeInfo();
    end;
end;

local function SetupToggleCollapse(u114, p115, p116) -- Line: 866
    -- upvalues: TweenService (copy), ActivateButton (copy)
    local u117 = p115:FindFirstChildOfClass("TextLabel");
    local u118 = false;
    local Scale = u114.Size.X.Scale;
    local Position = u114.Position;
    local BackgroundTransparency = u114.BackgroundTransparency;
    local v119;

    if p116 then
        v119 = Position.X.Scale - Scale - 0.04;
    else
        v119 = Position.X.Scale + Scale + 0.04;
    end;

    local u120 = UDim2.new(v119, Position.X.Offset, Position.Y.Scale, Position.Y.Offset);
    local u121 = p116 and "<" or ">";
    local u122 = p116 and ">" or "<";

    local function SetVisibleState(p123) -- Line: 887
        -- upvalues: u114 (copy), BackgroundTransparency (copy)
        for _, child in u114:GetChildren() do
            if child:IsA("GuiObject") then
                child.Visible = p123;
            elseif child:IsA("UIStroke") or (child:IsA("UIGradient") or child:IsA("UIShadow")) then
                child.Enabled = p123;
            end;
        end;

        u114.BackgroundTransparency = not p123 and 1 or BackgroundTransparency;
    end;

    local function UpdateCollapseState() -- Line: 899
        -- upvalues: u117 (copy), u118 (ref), u122 (copy), u121 (copy), TweenService (ref), u114 (copy), u120 (copy), Position (copy), SetVisibleState (copy)
        if u117 then
            local v124;

            if u118 then
                v124 = u122;
            else
                v124 = u121;
            end;

            u117.Text = v124;
        end;

        local v125 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        local v126 = {};
        local v127;

        if u118 then
            v127 = u120;
        else
            v127 = Position;
        end;

        v126.Position = v127;
        local v128 = TweenService:Create(u114, v125, v126);

        if u118 then
            v128.Completed:Once(function() -- Line: 909
                -- upvalues: SetVisibleState (ref)
                SetVisibleState(false);
            end);
        else
            SetVisibleState(true);
        end;

        v128:Play();
    end;

    UpdateCollapseState();
    ActivateButton(p115);
    p115.Activated:Connect(function() -- Line: 921
        -- upvalues: u118 (ref), UpdateCollapseState (copy)
        u118 = not u118;
        UpdateCollapseState();
    end);
end;

local function SetupToggleCollapses(p129, p130) -- Line: 929
    -- upvalues: SetupToggleCollapse (copy)
    for _, v in p129:QueryDescendants("#ToggleCollapsed") do
        if v:IsA("GuiButton") then
            local v131 = v:FindFirstAncestorWhichIsA("GuiObject");

            if v131 then
                SetupToggleCollapse(v131, v, p130);
            end;
        end;
    end;
end;

local function UpdateLeftFrameVisibility(p132) -- Line: 944
    -- upvalues: u1 (copy)
    for _, child in p132:GetChildren() do
        if child:IsA("Frame") then
            child.Visible = u1[child.Name] == true;
        end;
    end;
end;

local function UpdateRightFrameVisibility(p133) -- Line: 952
    -- upvalues: u4 (copy), MedalEvent (copy)
    for _, child in p133:GetChildren() do
        if child:IsA("Frame") then
            child.Visible = u4[child.Name] == true and (child.Name ~= "MedalEvent" and true or MedalEvent.IsAvailable());
        end;
    end;
end;

local function SetupLeftDashboard(u134) -- Line: 964
    -- upvalues: ClearFrame (copy), SetupFeaturedSection (copy), DataController (copy), LocalPlayer (copy), Store (copy), u10 (copy), SetupNewsTab (copy), CompareNewsTabs (copy), ReplicatedStorage (copy), u14 (copy), UpdateNewsPage (copy), SetupNewsPagination (copy), ActivateButton (copy), Router (copy), Remotes (copy), UpdateLeftFrameVisibility (copy), SetupToggleCollapses (copy)
    ClearFrame(u134.News.Frame.Bottom, { "UIListLayout", "Left", "Right" });
    SetupFeaturedSection(u134);
    task.spawn(function() -- Line: 701
        -- upvalues: DataController (ref), LocalPlayer (ref), u134 (copy), Store (ref), u10 (ref), SetupNewsTab (ref), CompareNewsTabs (ref), ReplicatedStorage (ref), u14 (ref), UpdateNewsPage (ref)
        DataController.WaitForDataLoaded(LocalPlayer);
        local Frame = u134.News.Frame;

        for _, child in Frame:GetChildren() do
            if child:IsA("Frame") and string.find(child.Name, "NewsTab") then
                local v135;

                if child.Name == "NewsTab1" then
                    v135 = "Featured Bundle";
                elseif child.Name == "NewsTab2" then
                    v135 = "StarterPack";
                else
                    v135 = child:GetAttribute("News");

                    if typeof(v135) ~= "string" then
                        v135 = nil;
                    end;
                end;

                if v135 == "StarterPack" and not Store.IsStarterPackAvailable() then
                    child:Destroy();
                else
                    table.insert(u10, child);
                    SetupNewsTab(child);
                end;
            end;
        end;

        table.sort(u10, CompareNewsTabs);
        local Bottom = Frame.Bottom;
        Bottom.Right.LayoutOrder = 999;
        Bottom.Left.LayoutOrder = 0;

        for i, v in ipairs(u10) do
            local v136 = ReplicatedStorage.Assets.UI.News.TabFrame:Clone();
            v136.BackgroundColor3 = u14;
            v136.Name = v.Name;
            v136.Parent = Bottom;
            v136.LayoutOrder = i;
        end;

        UpdateNewsPage();
    end);
    SetupNewsPagination(u134);
    local Frame = u134.RedeemCode.Frame;
    ActivateButton(Frame.Redeem);
    Frame.Redeem.MouseButton1Click:Connect(function() -- Line: 773
        -- upvalues: DataController (ref), LocalPlayer (ref), Router (ref), Frame (copy), Remotes (ref)
        local v137 = DataController.Get(LocalPlayer, "Level");
        Router.broadcastRouter("RunInterfaceSound", "UI Click");

        if v137.Level < 5 then
            Router.broadcastRouter("CreateMenuNotification", "Error", "You need to be atleast level 5 to redeem codes.");

            return;
        end;

        local Text = Frame.Holder.TextBox.Text;

        if tostring(Text) == "" then
            Router.broadcastRouter("CreateMenuNotification", "Error", "Invalid code. Please try again.");

            return;
        end;

        Frame.Holder.TextBox.Text = "";
        Remotes.Dashboard.RedeemCode.Send(Text);
    end);
    UpdateLeftFrameVisibility(u134);
    SetupToggleCollapses(u134, true);
end;

local function SetupRightDashboard(p138, p139) -- Line: 976
    -- upvalues: UpdateRightFrameVisibility (copy), SetupToggleCollapses (copy)
    p139.Advertisement.Visible = false;
    UpdateRightFrameVisibility(p139);
    SetupToggleCollapses(p139, false);
end;

local function RefreshMissionStarsProgressBar(p140) -- Line: 984
    -- upvalues: DataController (copy), LocalPlayer (copy), u20 (ref), MissionStars (copy), u16 (copy), u17 (copy), UpdateMissionStarsProgressBar (copy)
    local v141 = DataController.Get(LocalPlayer, "MissionStars");

    if v141 then
        UpdateMissionStarsProgressBar(v141.CurrentStreak, p140);

        return;
    end;

    local Bar = u20.Right.Missions.Holder.Stars.Frame.Bar;
    local Progress = Bar.Progress;
    local Stars = u20.Right.Missions.Holder.Stars;
    local Bar2 = Stars.Frame.Bar;
    local _ = Stars.Frame.Container;
    local _ = #MissionStars;
    local _ = Bar2.AbsoluteSize.X;
    local _ = Bar2.AbsolutePosition.X;
    local v142 = UDim2.fromScale(0, 1);
    Bar.BackgroundColor3 = u16;

    if Bar:IsA("ImageLabel") or Bar:IsA("ImageButton") then
        Bar.ImageColor3 = u16;
    end;

    Progress.BackgroundColor3 = u17;
    Progress.Size = v142;
end;

local function BindLayoutRefresh(p143, p144) -- Line: 996
    p143:GetPropertyChangedSignal("AbsolutePosition"):Connect(p144);
    p143:GetPropertyChangedSignal("AbsoluteSize"):Connect(p144);
end;

local function SetupMissionStars(p145) -- Line: 1003
    -- upvalues: MissionStars (copy), ReplicatedStorage (copy), u2 (copy), DataController (copy), LocalPlayer (copy), u20 (ref), u16 (copy), u17 (copy), GetMissionStarsProgressScale (copy), Profiler (copy), RefreshMissionStarsProgressBar (copy)
    local Container = p145.Missions.Holder.Stars.Frame.Container;
    local Bar = Container.Parent.Bar;

    for _, child in Container:GetChildren() do
        if child:IsA("ImageButton") then
            child:Destroy();
        end;
    end;

    for i, v in ipairs(MissionStars) do
        local v146 = ReplicatedStorage.Assets.UI.MissionStars:FindFirstChild((`Template{tostring(i)}`));

        if v146 then
            local v147 = v146:Clone();
            v147.Parent = Container;
            v147.ItemTemplate.Amount.Text = "x" .. tostring(v):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
            v147.Title.Text = tostring(i);
            v147.Name = tostring(i);
            v147.LayoutOrder = i;
            v147.MouseButton1Click:Connect(function() -- Line: 1026
                -- upvalues: u2 (ref), i (copy)
                u2.AttemptMissionStarClaim(i);
            end);

            local function v151() -- Line: 1030
                -- upvalues: DataController (ref), LocalPlayer (ref), u20 (ref), MissionStars (ref), u16 (ref), u17 (ref), GetMissionStarsProgressScale (ref)
                local v148 = DataController.Get(LocalPlayer, "MissionStars");

                if v148 then
                    local Bar2 = u20.Right.Missions.Holder.Stars.Frame.Bar;
                    local Progress = Bar2.Progress;
                    local v149 = UDim2.fromScale(GetMissionStarsProgressScale(v148.CurrentStreak), 1);
                    Bar2.BackgroundColor3 = u16;

                    if Bar2:IsA("ImageLabel") or Bar2:IsA("ImageButton") then
                        Bar2.ImageColor3 = u16;
                    end;

                    Progress.BackgroundColor3 = u17;
                    Progress.Size = v149;

                    return;
                end;

                local Bar2 = u20.Right.Missions.Holder.Stars.Frame.Bar;
                local Progress = Bar2.Progress;
                local Stars = u20.Right.Missions.Holder.Stars;
                local Bar3 = Stars.Frame.Bar;
                local _ = Stars.Frame.Container;
                local _ = #MissionStars;
                local _ = Bar3.AbsoluteSize.X;
                local _ = Bar3.AbsolutePosition.X;
                local v150 = UDim2.fromScale(0, 1);
                Bar2.BackgroundColor3 = u16;

                if Bar2:IsA("ImageLabel") or Bar2:IsA("ImageButton") then
                    Bar2.ImageColor3 = u16;
                end;

                Progress.BackgroundColor3 = u17;
                Progress.Size = v150;
            end;

            v147:GetPropertyChangedSignal("AbsolutePosition"):Connect(v151);
            v147:GetPropertyChangedSignal("AbsoluteSize"):Connect(v151);
        end;
    end;

    Bar.BackgroundColor3 = u16;

    if Bar:IsA("ImageLabel") or Bar:IsA("ImageButton") then
        Bar.ImageColor3 = u16;
    end;

    Bar.Progress.BackgroundColor3 = u17;

    local function v155() -- Line: 1042
        -- upvalues: DataController (ref), LocalPlayer (ref), u20 (ref), MissionStars (ref), u16 (ref), u17 (ref), GetMissionStarsProgressScale (ref)
        local v152 = DataController.Get(LocalPlayer, "MissionStars");

        if v152 then
            local Bar2 = u20.Right.Missions.Holder.Stars.Frame.Bar;
            local Progress = Bar2.Progress;
            local v153 = UDim2.fromScale(GetMissionStarsProgressScale(v152.CurrentStreak), 1);
            Bar2.BackgroundColor3 = u16;

            if Bar2:IsA("ImageLabel") or Bar2:IsA("ImageButton") then
                Bar2.ImageColor3 = u16;
            end;

            Progress.BackgroundColor3 = u17;
            Progress.Size = v153;

            return;
        end;

        local Bar2 = u20.Right.Missions.Holder.Stars.Frame.Bar;
        local Progress = Bar2.Progress;
        local Stars = u20.Right.Missions.Holder.Stars;
        local Bar3 = Stars.Frame.Bar;
        local _ = Stars.Frame.Container;
        local _ = #MissionStars;
        local _ = Bar3.AbsoluteSize.X;
        local _ = Bar3.AbsolutePosition.X;
        local v154 = UDim2.fromScale(0, 1);
        Bar2.BackgroundColor3 = u16;

        if Bar2:IsA("ImageLabel") or Bar2:IsA("ImageButton") then
            Bar2.ImageColor3 = u16;
        end;

        Progress.BackgroundColor3 = u17;
        Progress.Size = v154;
    end;

    Bar:GetPropertyChangedSignal("AbsolutePosition"):Connect(v155);
    Bar:GetPropertyChangedSignal("AbsoluteSize"):Connect(v155);
    Container:GetPropertyChangedSignal("AbsolutePosition"):Connect(v155);
    Container:GetPropertyChangedSignal("AbsoluteSize"):Connect(v155);
    Profiler.defer("UI.Dashboard.MissionStarsDeferred", RefreshMissionStarsProgressBar, false);
end;

local function SetupMissionTypeButtons(p156) -- Line: 1052
    -- upvalues: ActivateButton (copy), u2 (copy)
    for _, child in p156.Missions.Holder.Missions.Frame.ChangeMissionTimes:GetChildren() do
        if child:IsA("GuiButton") then
            ActivateButton(child);
            child.MouseButton1Click:Connect(function() -- Line: 1060
                -- upvalues: u2 (ref), child (copy)
                u2.OpenMissionFrame(child.Name);
            end);
        end;
    end;
end;

local function SetupMissionsRefreshButton(p157) -- Line: 1068
    -- upvalues: Router (copy), TweenService (copy), ActivateButton (copy), MarketplaceService (copy), LocalPlayer (copy), DevProducts (copy)
    local RefreshButton = p157.Missions.Holder.Missions.Header.Container.RefreshButton;
    RefreshButton.MouseEnter:Connect(function() -- Line: 1071
        -- upvalues: Router (ref), TweenService (ref), RefreshButton (copy)
        Router.broadcastRouter("RunInterfaceSound", "UI Highlight");
        TweenService:Create(RefreshButton, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Rotation = math.random(-15, 15)
        }):Play();
    end);
    RefreshButton.MouseLeave:Connect(function() -- Line: 1080
        -- upvalues: TweenService (ref), RefreshButton (copy)
        TweenService:Create(RefreshButton, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Rotation = 0
        }):Play();
    end);
    ActivateButton(RefreshButton);
    RefreshButton.MouseButton1Click:Connect(function() -- Line: 1089
        -- upvalues: MarketplaceService (ref), LocalPlayer (ref), DevProducts (ref), Router (ref)
        MarketplaceService:PromptProductPurchase(LocalPlayer, DevProducts["Refresh Missions"].DevProductId);
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
    end);
end;

local function UpdateNewsAutoAdvance() -- Line: 1097
    -- upvalues: u7 (ref), u10 (copy), u9 (ref), UpdateNewsPage (copy)
    local v158 = tick() - u7 >= 30;

    if #u10 > 1 and v158 then
        u9 = u9 % #u10 + 1;
        u7 = tick();
        UpdateNewsPage();
    end;
end;

local function UpdateStarterPackTimer(p159) -- Line: 1108
    -- upvalues: DataController (copy), LocalPlayer (copy), Store (copy)
    local NewsTab2 = p159.News.Frame:FindFirstChild("NewsTab2");

    if not NewsTab2 then
        return;
    end;

    if not DataController.IsDataLoaded(LocalPlayer) then
        return;
    end;

    if not Store.IsStarterPackAvailable() then
        NewsTab2:Destroy();

        return;
    end;

    local Timer = NewsTab2:FindFirstChild("Timer");

    if Timer and NewsTab2.Visible then
        local v160 = math.max(0, Store.GetStarterPackRemainingSeconds());

        if v160 <= 0 then
            v160 = Store.GetStarterPackWindowSeconds();
        end;

        Timer.Text = string.format("%02i:%02i:%02i", math.floor(v160 / 3600), math.floor(v160 % 3600 / 60), v160 % 60);
    end;
end;

local function UpdateMissionHeaderTimer(p161) -- Line: 1136
    -- upvalues: u6 (ref), GetEarliestExpirationTime (copy)
    local Timer = p161.Alert:FindFirstChild("Timer");

    if not Timer then
        return;
    end;

    if not u6 then
        Timer.TextColor3 = Color3.fromRGB(255, 255, 255);
        Timer.Text = string.format("%i:%02i:%02i:%02i", 0, 0, 0, 0);
        p161.Title.Text = "MISSIONS";

        return;
    end;

    local v162 = GetEarliestExpirationTime(u6);
    p161.Title.Text = `{string.upper(u6)} MISSIONS`;

    if not v162 then
        Timer.TextColor3 = Color3.fromRGB(255, 85, 85);
        Timer.Text = string.format("%i:%02i:%02i:%02i", 0, 0, 0, 0);

        return;
    end;

    local v163 = v162 - os.time() * 1000;
    local v164 = math.max(0, v163) / 1000;
    local v165 = math.floor(v164);
    Timer.TextColor3 = v165 > 600 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(255, 85, 85);
    Timer.Text = string.format("%i:%02i:%02i:%02i", math.floor(v165 / 86400), math.floor(v165 % 86400 / 3600), math.floor(v165 % 3600 / 60), v165 % 60);
end;

local function SetupDashboardHeartbeat(u166, u167) -- Line: 1167
    -- upvalues: RunServiceController (copy), u20 (ref), Profiler (copy), u7 (ref), u10 (copy), u9 (ref), UpdateNewsPage (copy), UpdateStarterPackTimer (copy), UpdateMissionHeaderTimer (copy)
    RunServiceController.BindToHeartbeat("UI.Dashboard.NewsAndTimers", function() -- Line: 1168
        -- upvalues: u20 (ref), Profiler (ref), u7 (ref), u10 (ref), u9 (ref), UpdateNewsPage (ref), UpdateStarterPackTimer (ref), u166 (copy), UpdateMissionHeaderTimer (ref), u167 (copy)
        if not u20.Visible then
            return;
        end;

        Profiler.mark("UI.Dashboard.Heartbeat");
        local v168 = tick() - u7 >= 30;

        if #u10 > 1 and v168 then
            u9 = u9 % #u10 + 1;
            u7 = tick();
            UpdateNewsPage();
        end;

        UpdateStarterPackTimer(u166);
        UpdateMissionHeaderTimer(u167.Missions.Holder.Missions.Header.Container);
    end);
end;

local function UpdateMissionStarTemplate(p169, p170, p171) -- Line: 1185
    -- upvalues: u11 (copy), u18 (copy), u19 (copy)
    local v172 = tostring(p171);
    local Rewards = p170.Rewards;
    local v173;

    if typeof(Rewards) == "table" then
        local v174 = Rewards[tostring(p171)];

        if v174 == nil then
            v174 = Rewards[p171];
        end;

        if typeof(v174) == "string" then
            v173 = string.lower(v174) == "true";
        else
            v173 = v174 == true;
        end;
    else
        v173 = false;
    end;

    local v175 = p171 <= p170.CurrentStreak;

    if v173 then
        p169.Star.Glow.Visible = true;
        p169.Star.Glow.UIGradient.Color = u11;
        p169.Star.Icon.UIGradient.Color = u11;
        p169.Title.UIGradient.Color = u11;
        p169.Star.Glow.UIGradient.Rotation = 90;
        p169.Title.Text = "CLAIMED";

        return;
    end;

    if not v175 then
        p169.Star.Glow.UIGradient.Color = u19;
        p169.Star.Icon.UIGradient.Color = u19;
        p169.Title.UIGradient.Color = u19;
        p169.Title.Text = v172;
        p169.Star.Glow.Visible = false;

        return;
    end;

    p169.Star.Glow.Visible = true;
    p169.Star.Glow.UIGradient.Color = u18;
    p169.Star.Icon.UIGradient.Color = u18;
    p169.Title.UIGradient.Color = u18;
    p169.Star.Glow.UIGradient.Rotation = 45;
    p169.Title.Text = "CLAIM";
end;

local function OnMissionStarsDataChanged(p176, p177) -- Line: 1219
    -- upvalues: u20 (ref), MissionStars (copy), u16 (copy), u17 (copy), UpdateMissionStarTemplate (copy), UpdateMissionStarsProgressBar (copy)
    local Stars = p176.Missions.Holder.Stars;
    local Streak = Stars.Header.Container.Streak.Streak;
    local Container = Stars.Frame.Container;

    if p177 then
        Streak.Text = p177.CurrentStreak;

        for _, child in Container:GetChildren() do
            if child:IsA("GuiButton") then
                local v178 = tonumber(child.Name);

                if v178 then
                    UpdateMissionStarTemplate(child, p177, v178);
                end;
            end;
        end;

        UpdateMissionStarsProgressBar(p177.CurrentStreak, true);

        return;
    end;

    Streak.Text = 0;
    local Bar = u20.Right.Missions.Holder.Stars.Frame.Bar;
    local Progress = Bar.Progress;
    local Stars2 = u20.Right.Missions.Holder.Stars;
    local Bar2 = Stars2.Frame.Bar;
    local _ = Stars2.Frame.Container;
    local _ = #MissionStars;
    local _ = Bar2.AbsoluteSize.X;
    local _ = Bar2.AbsolutePosition.X;
    local v179 = UDim2.fromScale(0, 1);
    Bar.BackgroundColor3 = u16;

    if Bar:IsA("ImageLabel") or Bar:IsA("ImageButton") then
        Bar.ImageColor3 = u16;
    end;

    Progress.BackgroundColor3 = u17;
    Progress.Size = v179;
end;

local function SetupMissionDataListeners(u180) -- Line: 1254
    -- upvalues: DataController (copy), LocalPlayer (copy), OnMissionStarsDataChanged (copy), u8 (ref), u2 (copy), ConfigKeys (copy), ConfigController (copy)
    DataController.CreateListener(LocalPlayer, "MissionStars", function(p181) -- Line: 1258
        -- upvalues: OnMissionStarsDataChanged (ref), u180 (copy)
        OnMissionStarsDataChanged(u180, p181);
    end);
    DataController.CreateListener(LocalPlayer, "Missions", function(p182) -- Line: 1263
        -- upvalues: u8 (ref), u2 (ref)
        if not p182 then
            return;
        end;

        if u8 then
            u2.UpdateCurrentMissions(p182);

            return;
        end;

        u2.OpenMissionFrame("hourly");
        u8 = true;
    end);

    for _, v in pairs(ConfigKeys.Shared.MissionCreditRewardMultipliers) do
        ConfigController.OnChanged(v, function() -- Line: 1278
            -- upvalues: DataController (ref), LocalPlayer (ref), u2 (ref)
            local v183 = DataController.Get(LocalPlayer, "Missions");

            if v183 then
                u2.UpdateCurrentMissions(v183);
            end;
        end);
    end;
end;

function u2.CreateMissionTemplate(p184, u185) -- Line: 1292
    -- upvalues: Profiler (copy), ReplicatedStorage (copy), u20 (ref), ConfigKeys (copy), ConfigController (copy), ActivateButton (copy), DataController (copy), LocalPlayer (copy), Router (copy), Remotes (copy)
    Profiler.mark("UI.Dashboard.CreateMissionTemplate");
    local v186 = ReplicatedStorage.Assets.UI.Missions.Template:Clone();
    v186.Bar.Progress.Size = UDim2.fromScale(math.min(u185.Progress / u185.Target, 1), 1);
    v186.Progress.Text = tostring(u185.Progress):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "") .. "/" .. tostring(u185.Target):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
    v186.Parent = u20.Right.Missions.Holder.Missions.Frame.MissionsTab;
    v186.Button.Title.Text = u185.IsClaimed and "CLAIMED" or "CLAIM";
    v186.Progress.Visible = u185.Progress < u185.Target;
    v186.Button.Visible = u185.Progress >= u185.Target;
    v186.Title.Text = p184.DisplayName or p184.MissionId;
    v186.Name = u185.MissionId;
    v186:SetAttribute("Progress", u185.Progress);
    v186:SetAttribute("Target", u185.Target);

    if p184.Rewards[1].type == "Credits" then
        local Amount = v186.ItemTemplate.Amount;
        local v187 = p184.Rewards[1];
        local v188;

        if v187.type == "Credits" and typeof(v187.amount) == "number" then
            local v189 = ConfigKeys.Shared.MissionCreditRewardMultipliers[p184.Type];
            local v190 = not v189 and 1 or ConfigController.GetRewardMultiplier(v189);
            v188 = math.round(v187.amount * v190);
        else
            v188 = 0;
        end;

        Amount.Text = "x" .. tostring(v188):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
        v186.ItemTemplate.Icon.Image = "rbxassetid://129921992230064";
    end;

    ActivateButton(v186.Button);
    v186.Button.MouseButton1Click:Connect(function() -- Line: 1320
        -- upvalues: u185 (copy), DataController (ref), LocalPlayer (ref), Router (ref), Remotes (ref)
        local MissionId = u185.MissionId;
        local v191 = DataController.Get(LocalPlayer, "Missions");

        if v191 then
            for _, v in ipairs(v191) do
                if v.MissionId == MissionId then
                    break;
                end;
            end;
        else
            local v = nil;
        end;

        Router.broadcastRouter("RunInterfaceSound", "UI Click");

        if not v or v.IsClaimed then
            return;
        end;

        Remotes.Dashboard.MissionCompleted.Send(v.MissionId);
    end);
end;

function u2.AttemptMissionStarClaim(p192) -- Line: 1333
    -- upvalues: DataController (copy), LocalPlayer (copy), Router (copy), Remotes (copy)
    local v193 = DataController.Get(LocalPlayer, "MissionStars");
    Router.broadcastRouter("RunInterfaceSound", "UI Click");

    if not v193 then
        Router.broadcastRouter("CreateMenuNotification", "Error", "Mission stars data is still loading. Please try again.");

        return;
    end;

    local Rewards = v193.Rewards;
    local v194;

    if typeof(Rewards) == "table" then
        local v195 = Rewards[tostring(p192)];

        if v195 == nil then
            v195 = Rewards[p192];
        end;

        if typeof(v195) == "string" then
            v194 = string.lower(v195) == "true";
        else
            v194 = v195 == true;
        end;
    else
        v194 = false;
    end;

    if v194 then
        Router.broadcastRouter("CreateMenuNotification", "Error", "Star reward already claimed.");

        return;
    end;

    if p192 <= v193.CurrentStreak then
        Remotes.Dashboard.ClaimStarReward.Send(p192);

        return;
    end;

    Router.broadcastRouter("CreateMenuNotification", "Error", (`Star {p192} unlocks at streak day {p192}. Your current streak is {v193.CurrentStreak}/7.`));
end;

function u2.UpdateCurrentMissions(p196) -- Line: 1369
    -- upvalues: Profiler (copy), DataController (copy), LocalPlayer (copy), u6 (ref), Missions (copy), u20 (ref), ConfigKeys (copy), ConfigController (copy), TweenService (copy), u2 (copy)
    Profiler.mark("UI.Dashboard.UpdateCurrentMissions");
    local v197 = DataController.Get(LocalPlayer, "Missions");
    local v198 = {};

    if not (v197 and u6) then
        return;
    end;

    for _, v in ipairs(v197) do
        local v199 = Missions.GetMissionDefinition(v.MissionId);

        if v199 and v199.Type == u6 then
            local v200 = u20.Right.Missions.Holder.Missions.Frame.MissionsTab:FindFirstChild(v.MissionId);
            v198[v.MissionId] = true;

            if v200 and v200:IsA("Frame") then
                local v201 = v200:GetAttribute("Progress");
                v200.Progress.Text = tostring(v.Progress):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "") .. "/" .. tostring(v.Target):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
                v200.Button.Title.Text = v.IsClaimed and "CLAIMED" or "CLAIM";
                v200.Progress.Visible = v.Progress < v.Target;
                v200.Button.Visible = v.Progress >= v.Target;
                v200.Visible = true;

                if v199.Rewards[1].type == "Credits" then
                    local Amount = v200.ItemTemplate.Amount;
                    local v202 = v199.Rewards[1];
                    local v203;

                    if v202.type == "Credits" and typeof(v202.amount) == "number" then
                        local v204 = ConfigKeys.Shared.MissionCreditRewardMultipliers[v199.Type];
                        local v205 = not v204 and 1 or ConfigController.GetRewardMultiplier(v204);
                        v203 = math.round(v202.amount * v205);
                    else
                        v203 = 0;
                    end;

                    Amount.Text = "x" .. tostring(v203):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
                end;

                v200:SetAttribute("Progress", v.Progress);
                v200:SetAttribute("Target", v.Target);

                if u20.Visible and (v201 or 0) < v.Progress then
                    TweenService:Create(v200.Bar.Progress, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Size = UDim2.fromScale(math.min(v.Progress / v.Target, 1), 1)
                    }):Play();
                else
                    v200.Bar.Progress.Size = UDim2.fromScale(math.min(v.Progress / v.Target, 1), 1);
                end;
            else
                u2.CreateMissionTemplate(v199, v);
            end;
        end;
    end;

    for _, child in ipairs(u20.Right.Missions.Holder.Missions.Frame.MissionsTab:GetChildren()) do
        if child:IsA("Frame") and not (table.find({ "UIPadding", "UIListLayout", "Padding" }, child.Name) or v198[child.Name]) then
            child:Destroy();
        end;
    end;
end;

function u2.OpenMissionFrame(p206) -- Line: 1442
    -- upvalues: Profiler (copy), u20 (ref), DataController (copy), LocalPlayer (copy), u6 (ref), ClearFrame (copy), Missions (copy), u2 (copy)
    Profiler.mark((`UI.Dashboard.OpenMissionFrame.{p206}`));

    for _, child in u20.Right.Missions.Holder.Missions.Frame.ChangeMissionTimes:GetChildren() do
        if child:IsA("ImageButton") then
            local Enabled = child:FindFirstChild("Enabled");

            if Enabled then
                Enabled.Visible = p206 == child.Name;
            end;
        end;
    end;

    local v207 = DataController.Get(LocalPlayer, "Missions");

    if u6 == p206 then
        return;
    end;

    u6 = p206;

    if v207 then
        ClearFrame(u20.Right.Missions.Holder.Missions.Frame.MissionsTab, { "UIPadding", "UIListLayout", "Padding" });

        for _, v in ipairs(v207) do
            local v208 = Missions.GetMissionDefinition(v.MissionId);

            if v208 and v208.Type == p206 then
                u2.CreateMissionTemplate(v208, v);
            end;
        end;
    end;
end;

function u2.Initialize(p209, p210) -- Line: 1482
    -- upvalues: Profiler (copy), u20 (ref), EditMobile (copy), SetupLeftDashboard (copy), UpdateRightFrameVisibility (copy), SetupToggleCollapses (copy), SetupPlayerPolicies (copy)
    Profiler.mark("UI.Dashboard.Initialize");
    u20 = p210;
    EditMobile.Initialize(p209, u20);
    local Left = u20.Left;
    local Right = u20.Right;
    SetupLeftDashboard(Left);
    Right.Advertisement.Visible = false;
    UpdateRightFrameVisibility(Right);
    SetupToggleCollapses(Right, false);
    SetupPlayerPolicies(Left, Right);
end;

function u2.Start() -- Line: 1514
    -- upvalues: Profiler (copy), u20 (ref), SetupMissionStars (copy), SetupMissionTypeButtons (copy), SetupMissionsRefreshButton (copy), SetupMissionDataListeners (copy), RunServiceController (copy), u7 (ref), u10 (copy), u9 (ref), UpdateNewsPage (copy), UpdateStarterPackTimer (copy), UpdateMissionHeaderTimer (copy), MedalEvent (copy)
    debug.setmemorycategory("UI.Dashboard.Start");
    Profiler.mark("UI.Dashboard.Start");
    local Left = u20.Left;
    local Right = u20.Right;
    SetupMissionStars(Right);
    SetupMissionTypeButtons(Right);
    SetupMissionsRefreshButton(Right);
    SetupMissionDataListeners(Right);
    RunServiceController.BindToHeartbeat("UI.Dashboard.NewsAndTimers", function() -- Line: 1168
        -- upvalues: u20 (ref), Profiler (ref), u7 (ref), u10 (ref), u9 (ref), UpdateNewsPage (ref), UpdateStarterPackTimer (ref), Left (copy), UpdateMissionHeaderTimer (ref), Right (copy)
        if not u20.Visible then
            return;
        end;

        Profiler.mark("UI.Dashboard.Heartbeat");
        local v211 = tick() - u7 >= 30;

        if #u10 > 1 and v211 then
            u9 = u9 % #u10 + 1;
            u7 = tick();
            UpdateNewsPage();
        end;

        UpdateStarterPackTimer(Left);
        UpdateMissionHeaderTimer(Right.Missions.Holder.Missions.Header.Container);
    end);
    MedalEvent.Initialize(u20, Right);
end;

return u2;