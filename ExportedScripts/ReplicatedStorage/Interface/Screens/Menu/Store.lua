-- Decompiled with Potassium's decompiler.

local u1 = {};
local MarketplaceService = game:GetService("MarketplaceService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CollectionService = game:GetService("CollectionService");
local PolicyService = game:GetService("PolicyService");
local TweenService = game:GetService("TweenService");
local HttpService = game:GetService("HttpService");
local Players = game:GetService("Players");
require(ReplicatedStorage.Database.Custom.Types);
local Constants = require(ReplicatedStorage.Database.Custom.Constants);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local CaseSceneController = require(ReplicatedStorage.Controllers.CaseSceneController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton);
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform);
local GetSkinDisplayName = require(ReplicatedStorage.Components.Common.GetSkinDisplayName);
local Bundles = require(ReplicatedStorage.Database.Components.Libraries.Bundles);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local Cases = require(ReplicatedStorage.Database.Components.Libraries.Cases);
local TradeTokens = require(ReplicatedStorage.Database.Custom.GameStats.Monetization.TradeTokens);
local CloseButtonRegistry = require(ReplicatedStorage.Shared.CloseButtonRegistry);
local Profiler = require(ReplicatedStorage.Shared.Profiler);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local Observers = require(ReplicatedStorage.Packages.Observers);
local Spring = require(ReplicatedStorage.Shared.Spring);
local DevProducts = require(ReplicatedStorage.Database.Custom.GameStats.Monetization.DevProducts);
local Gamepasses = require(ReplicatedStorage.Database.Custom.GameStats.Monetization.Gamepasses);
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities);
local Cases2 = require(ReplicatedStorage.Database.Custom.GameStats.Monetization.Cases);
local u2 = Spring.new(1, 8, 0);
local LocalPlayer = Players.LocalPlayer;
local u3 = true;
local u4 = 0;
local u5 = 0;
local u6 = 1;
local u7 = nil;
local u8 = nil;
local u9 = {};
local u10 = { {
        productName = "M4A4 | Freedom",
        weaponName = "M4A4",
        skinName = "Freedom",
        frameNames = { "Tier1" }
    }, {
        productName = "AWP | Freedom",
        weaponName = "AWP",
        skinName = "Freedom",
        frameNames = { "Tier2" }
    }, {
        productName = "Desert Eagle | Freedom",
        weaponName = "Desert Eagle",
        skinName = "Freedom",
        frameNames = { "Tier3" }
    } };
local u11 = {
    apex_case = "rbxassetid://110520095994318",
    chrysalis = "rbxassetid://127888213250008"
};
local u12 = {
    Blue = 1,
    Purple = 2,
    Pink = 3,
    Red = 4,
    Special = 5
};
local u13 = nil;
local u14 = nil;
local u15 = nil;
local u16 = nil;
local u17 = nil;
local u18 = false;
local u19 = 0;
local u20 = false;
local u21 = false;
local u22 = nil;
local u23 = {};
local u24 = {
    isOpening = false,
    isPendingOpenRequest = false,
    isQuickUnlock = false,
    currentTween = nil,
    currentZoomTween = nil,
    renderConnection = nil,
    viewportConnection = nil,
    currentInventoryItem = nil,
    currentCaseIdentifier = nil,
    pendingOpenRequestId = nil,
    progressRightTween = nil,
    progressRightProxy = nil
};
local u25 = 0;
local u26 = {};
local u27 = {};
local u28 = {
    Special = "Drop Gold",
    Red = "Drop Red",
    Pink = "Drop Pink",
    Purple = "Drop Purple",
    Blue = "Drop Blue"
};
local u29 = {
    inventoryItems = nil,
    bulkIdentifier = nil,
    caseId = nil,
    isBulkOpening = false,
    currentIndex = 0,
    skipped = false,
    total = 0
};

local function CommaNumber(p30) -- Line: 205
    return tostring(p30):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
end;

local function LoadProductInfo(u31, p32) -- Line: 209
    -- upvalues: u23 (copy), MarketplaceService (copy)
    if u23[u31] then
        table.insert(u23[u31], p32);

        return;
    end;

    u23[u31] = { p32 };
    task.spawn(function() -- Line: 216
        -- upvalues: MarketplaceService (ref), u31 (copy), u23 (ref)
        local success, result = pcall(function() -- Line: 217
            -- upvalues: MarketplaceService (ref), u31 (ref)
            return MarketplaceService:GetProductInfoAsync(u31, Enum.InfoType.Product);
        end);
        local v33 = u23[u31];
        u23[u31] = nil;

        for _, v in v33 do
            task.defer(v, success and result and result or nil);
        end;
    end);
end;

local function LoadProductPrice(u34, u35) -- Line: 228
    -- upvalues: LoadProductInfo (copy)
    if u34.Price and u35 then
        u35(u34.Price);
    end;

    LoadProductInfo(u34.DevProductId, function(p36) -- Line: 232
        -- upvalues: u34 (copy), u35 (copy)
        if not (p36 and p36.PriceInRobux) then
            return;
        end;

        u34.Price = p36.PriceInRobux;

        if u35 then
            u35(u34.Price);
        end;
    end);
end;

local function DoCreditPurchase(u37, u38, u39) -- Line: 243
    -- upvalues: u13 (ref), DataController (copy), LocalPlayer (copy), TradeTokens (copy), ActivateButton (copy), MarketplaceService (copy), Remotes (copy), u8 (ref)
    if u13:FindFirstChild("CurrentConfirm") then
        return;
    end;

    local v40 = DataController.Get(LocalPlayer, "TradeTokens");
    local u41 = u13.Purchase:Clone();
    u41.Name = "CurrentConfirm";
    u41.Main.Header.Title.Text = u37;
    u41.Main.Info.Frame.Credits.TextLabel.Text = tostring(v40):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
    u41.Main.Info.Robux.Credits.Amount.Text = tostring(u38.Price or 0):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
    local Amount = u41.Main.Info.TradeTokens.Credits.Amount;
    local v42;

    if u39 then
        local v43 = math.floor(u38.Price * 1.15);
        v42 = tostring(v43):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "") or u41.Main.Info.Robux.Credits.Amount.Text;
    else
        v42 = u41.Main.Info.Robux.Credits.Amount.Text;
    end;

    Amount.Text = v42;
    u41.Visible = true;
    u41.Parent = u13;

    if TradeTokens[u37] and TradeTokens[u37].Price then
        u41.Main.Info.TradeTokens.Credits.Amount.Text = tostring(TradeTokens[u37].Price):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
    end;

    ActivateButton(u41.Main.Action.Frame.Close);
    u41.Main.Action.Frame.Close.MouseButton1Click:Connect(function() -- Line: 263
        -- upvalues: u41 (copy)
        u41:Destroy();
    end);
    ActivateButton(u41.Main.Info.Robux);
    u41.Main.Info.Robux.MouseButton1Click:Connect(function() -- Line: 268
        -- upvalues: MarketplaceService (ref), LocalPlayer (ref), u38 (copy), u41 (copy)
        MarketplaceService:PromptProductPurchase(LocalPlayer, u38.DevProductId);
        u41:Destroy();
    end);
    ActivateButton(u41.Main.Info.TradeTokens);
    u41.Main.Info.TradeTokens.MouseButton1Click:Connect(function() -- Line: 274
        -- upvalues: u39 (copy), Remotes (ref), u37 (copy), u8 (ref), u41 (copy)
        if u39 then
            Remotes.Store.PurchaseTradeTokensCase.Send({
                ProductName = u8.name,
                Quantity = u39
            });
        else
            Remotes.Store.PurchaseTradeTokensProduct.Send({
                ProductName = u37
            });
        end;

        u41:Destroy();
    end);
end;

local function MultiplyUdim2(p44, p45) -- Line: 286
    return UDim2.fromScale(p44.X.Scale * p45, p44.Y.Scale * p45);
end;

local function ClearFrame(p46, p47) -- Line: 292
    for _, child in ipairs(p46:GetChildren()) do
        if not table.find(p47, child.Name) then
            child:Destroy();
        end;
    end;
end;

local function FindDescendant(p48, p49) -- Line: 302
    for _, v in ipairs(p49) do
        if not p48 then
            return nil;
        end;

        p48 = p48:FindFirstChild(v);
    end;

    return p48;
end;

local function AsGuiButton(p50) -- Line: 315
    if p50 and p50:IsA("GuiButton") then
        return p50;
    end;

    return nil;
end;

local function UpdateCreatorCodeResponse(p51, p52) -- Line: 324
    -- upvalues: HttpService (copy), u13 (ref)
    local u53 = HttpService:GenerateGUID(false);
    local Response = u13.CreatorCode.Container.Body.Response;
    local v54 = p51 == "Success" and Color3.fromRGB(86, 228, 21);

    if not v54 then
        if p51 == "Error" then
            v54 = Color3.fromRGB(232, 59, 82);
        else
            v54 = false;
        end;
    end;

    Response.TextColor3 = v54;
    u13.CreatorCode.Container.Action.Confirm.Title.Text = "CONFIRM";
    u13.CreatorCode:SetAttribute("ResponseId", u53);
    u13.CreatorCode.Container.Body.Response.Text = p52;
    task.delay(5, function() -- Line: 334
        -- upvalues: u13 (ref), u53 (copy)
        if u13.CreatorCode:GetAttribute("ResponseId") ~= u53 then
            return;
        end;

        u13.CreatorCode.Container.Body.CreatorName.TextBox.Text = "";
        u13.CreatorCode.Container.Body.Response.Text = "";
    end);
end;

local function GetFeaturedBundleItemFrame(p55, p56) -- Line: 346
    if not p55 then
        return nil;
    end;

    for _, v in ipairs(p56) do
        local v57 = p55:FindFirstChild(v);

        if v57 then
            return v57;
        end;
    end;

    return nil;
end;

local function ScrollToBottom(u58) -- Line: 363
    -- upvalues: Profiler (copy)
    Profiler.defer("UI.Store.ScrollToBottomDeferred", function() -- Line: 364
        -- upvalues: u58 (copy)
        local v59 = math.max(0, u58.AbsoluteCanvasSize.Y - u58.AbsoluteWindowSize.Y);
        u58.CanvasPosition = Vector2.new(u58.CanvasPosition.X, v59);
    end);
end;

local function ScrollToFeaturedSection(p60) -- Line: 372
    -- upvalues: u13 (ref), TweenService (copy)
    local Scroll = u13.Tabs.Container.Featured.Scroll;
    local v61 = Scroll:FindFirstChild(p60, true);

    if not v61 then
        return false;
    end;

    local v62 = math.max(0, Scroll.CanvasPosition.Y + (v61.AbsolutePosition.Y - Scroll.AbsolutePosition.Y));
    local v63 = TweenService:Create(Scroll, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        CanvasPosition = Vector2.new(0, v62)
    });
    v63:Play();
    v63.Completed:Wait();
    v63:Destroy();

    return true;
end;

local function NotifyCaseOpenSequenceFinished() -- Line: 397
    -- upvalues: u24 (copy), Remotes (copy)
    local currentCaseIdentifier = u24.currentCaseIdentifier;

    if not currentCaseIdentifier then
        return;
    end;

    Remotes.Store.CaseOpenSequenceFinished.Send({
        CaseIdentifier = currentCaseIdentifier
    });
    u24.currentCaseIdentifier = nil;
end;

local function ClearPendingOpenRequest() -- Line: 409
    -- upvalues: u24 (copy)
    u24.isPendingOpenRequest = false;
    u24.pendingOpenRequestId = nil;
    u24.isQuickUnlock = false;
end;

local function CreateOpenCaseRequestId() -- Line: 417
    -- upvalues: u25 (ref)
    u25 = u25 + 1;

    return tostring(u25);
end;

local function CompleteOpenCaseRequest(p64) -- Line: 424
    -- upvalues: u26 (copy), u24 (copy)
    if not p64 then
        return nil;
    end;

    local v65 = u26[p64];

    if not v65 then
        return nil;
    end;

    if p64 and u24.pendingOpenRequestId == p64 then
        u24.isPendingOpenRequest = false;
        u24.pendingOpenRequestId = nil;
        u24.isQuickUnlock = false;
    end;

    u26[p64] = nil;

    return v65;
end;

local function FailOpenCaseRequest(p66) -- Line: 444
    -- upvalues: u24 (copy), u26 (copy)
    if not p66 then
        return;
    end;

    if u24.pendingOpenRequestId == p66 then
        u24.isPendingOpenRequest = false;
        u24.pendingOpenRequestId = nil;
        u24.isQuickUnlock = false;
    end;

    u26[p66] = nil;
end;

local function BeginOpenCaseRequest(p67) -- Line: 458
    -- upvalues: u25 (ref), u26 (copy), u24 (copy)
    u25 = u25 + 1;
    local v68 = tostring(u25);
    u26[v68] = {
        IsQuickUnlock = p67
    };
    u24.isPendingOpenRequest = true;
    u24.pendingOpenRequestId = v68;
    u24.isQuickUnlock = p67;

    return v68;
end;

local function IsResolvedCaseOpenBusy() -- Line: 471
    -- upvalues: u24 (copy), u29 (copy), MenuState (copy)
    return u24.isOpening or (u29.isBulkOpening or MenuState.IsInspectActive());
end;

local function StartResolvedCaseOpenJob(p69) -- Line: 477
    -- upvalues: u1 (copy)
    if #p69.InventoryItems > 1 then
        u1.StartBulkOpening(p69.CaseId, p69.InventoryItems, p69.CaseIdentifier);

        return;
    end;

    u1.OpenCase(p69.CaseId, p69.InventoryItems[1], p69.CaseIdentifier, p69.IsQuickUnlock, p69.RequestId);
end;

local function TryProcessResolvedCaseOpenQueue() -- Line: 488
    -- upvalues: Profiler (copy), u24 (copy), u29 (copy), MenuState (copy), u27 (copy), u1 (copy)
    Profiler.mark("UI.Store.TryProcessResolvedCaseOpenQueue");

    if u24.isOpening or (u29.isBulkOpening or MenuState.IsInspectActive()) then
        return false;
    end;

    local v70 = false;

    while true do
        local v71 = not (u24.isOpening or (u29.isBulkOpening or MenuState.IsInspectActive())) and table.remove(u27, 1);

        if not v71 then
            break;
        end;

        v70 = true;

        if #v71.InventoryItems > 1 then
            u1.StartBulkOpening(v71.CaseId, v71.InventoryItems, v71.CaseIdentifier);
        else
            u1.OpenCase(v71.CaseId, v71.InventoryItems[1], v71.CaseIdentifier, v71.IsQuickUnlock, v71.RequestId);
        end;
    end;

    return v70;
end;

local function CleanupCaseOpeningTweens() -- Line: 510
    -- upvalues: u24 (copy)
    if u24.currentTween then
        u24.currentTween:Cancel();
        u24.currentTween = nil;
    end;

    if u24.currentZoomTween then
        u24.currentZoomTween:Cancel();
        u24.currentZoomTween = nil;
    end;

    if u24.renderConnection then
        u24.renderConnection:Disconnect();
        u24.renderConnection = nil;
    end;

    if u24.viewportConnection then
        u24.viewportConnection:Disconnect();
        u24.viewportConnection = nil;
    end;
end;

local function GetDeveloperProductNameForAmount(p72) -- Line: 531
    return p72 <= 400 and "+ 400 Credits" or (p72 <= 950 and "+ 950 Credits" or (p72 <= 3100 and "+ 3,100 Credits" or (p72 <= 6500 and "+ 6,500 Credits" or (p72 <= 13250 and "+ 13,250 Credits" or "+ 27,000 Credits"))));
end;

local function NormalizeUnixTimestamp(p73) -- Line: 549
    if p73 > 10000000000 then
        return math.floor(p73 / 1000);
    end;

    return math.floor(p73);
end;

local function ParseDateTimerTimestamp(u74) -- Line: 559
    -- upvalues: u9 (copy)
    local v75 = `{typeof(u74)}:{u74}`;
    local v76 = u9[v75];

    if v76 ~= nil then
        if v76 == false then
            return nil;
        end;

        return v76;
    end;

    local v77 = nil;

    if typeof(u74) == "number" then
        v77 = u74;
    else
        local v78 = tonumber(u74);

        if v78 then
            v77 = v78;
        else
            local success, result = pcall(function() -- Line: 575
                -- upvalues: u74 (copy)
                return DateTime.fromIsoDate(u74);
            end);

            if success and result then
                v77 = result.UnixTimestamp;
            end;
        end;
    end;

    if not v77 then
        u9[v75] = false;

        return nil;
    end;

    local v79;

    if v77 > 10000000000 then
        v79 = math.floor(v77 / 1000);
    else
        v79 = math.floor(v77);
    end;

    u9[v75] = v79;

    return v79;
end;

local function FormatDateTimer(p80) -- Line: 596
    return p80 <= 0 and "00:00:00:00" or string.format("%02d:%02d:%02d:%02d", math.floor(p80 / 86400), math.floor(p80 % 86400 / 3600), math.floor(p80 % 3600 / 60), (math.floor(p80 % 60)));
end;

local function ConvertDateToTimer(p81, p82) -- Line: 612
    -- upvalues: ParseDateTimerTimestamp (copy), FormatDateTimer (copy)
    local v83 = ParseDateTimerTimestamp(p81);

    if not v83 then
        return "00:00:00:00";
    end;

    if not p82 then
        local v84 = workspace:GetServerTimeNow();
        p82 = math.floor(v84);
    end;

    return FormatDateTimer(v83 - math.floor(p82));
end;

local function ResolveStarterPackUI() -- Line: 624
    -- upvalues: u15 (ref), u16 (ref), u17 (ref), u13 (ref), u21 (ref)
    if u15 and (u16 and u17) then
        return true;
    end;

    local Featured = u13.Tabs.Container.Featured.Scroll.Featured;
    local Timer = Featured.Pack.Container.Top.Title.Top.Timer;
    local Purchase = Featured.Pack.Container.Bottom.Purchase;

    if not (Featured and (Timer and Purchase)) then
        if not u21 then
            u21 = true;
            warn("[Store] Missing StarterPack UI under Store.Tabs.Container.Credits.Container");
        end;

        return false;
    end;

    u15 = Featured;
    u16 = Timer;
    u17 = Purchase;

    return true;
end;

local function NormalizeOpenShopTime(p85) -- Line: 650
    local v86 = nil;

    if typeof(p85) == "number" then
        v86 = p85;
    elseif typeof(p85) == "string" then
        v86 = tonumber(p85);
    end;

    if v86 == nil then
        return nil;
    end;

    if v86 > 10000000000 then
        return math.floor(v86 / 1000);
    end;

    return math.floor(v86);
end;

local function GetStarterPackRemainingSeconds(p87, p88) -- Line: 673
    local v89 = nil;

    if typeof(p87) == "number" then
        v89 = p87;
    elseif typeof(p87) == "string" then
        v89 = tonumber(p87);
    end;

    local v90;

    if v89 == nil then
        v90 = nil;
    elseif v89 > 10000000000 then
        v90 = math.floor(v89 / 1000);
    else
        v90 = math.floor(v89);
    end;

    if v90 == nil then
        return 0;
    end;

    local v91 = p88 or workspace:GetServerTimeNow();
    local v92 = 86400 - math.max(0, v91 - v90);
    local v93 = math.floor(v92);

    return math.max(0, v93);
end;

local function FormatStarterPackTimer(p94) -- Line: 687
    local v95 = math.floor(p94);
    local v96 = math.max(0, v95);
    local v97 = math.floor(v96 / 3600);
    local v98 = math.floor(v96 % 3600 / 60);
    local v99 = math.floor(v96 % 60);

    return string.format("%02d:%02d:%02d", v97, v98, v99);
end;

local function PlayerOwnsStarterPack() -- Line: 697
    -- upvalues: DataController (copy), LocalPlayer (copy)
    if not DataController.IsDataLoaded(LocalPlayer) then
        return false;
    end;

    local v100 = DataController.Get(LocalPlayer, "Gamepasses");
    local v101;

    if typeof(v100) == "table" then
        v101 = table.find(v100, "Credits StarterPack") ~= nil;
    else
        v101 = false;
    end;

    return v101;
end;

local function GetStarterPackState(p102) -- Line: 714
    -- upvalues: DataController (copy), LocalPlayer (copy)
    if not DataController.IsDataLoaded(LocalPlayer) then
        return {
            IsDataLoaded = false,
            OpenShopTime = nil,
            OwnsStarterPack = false,
            RemainingSeconds = 0
        };
    end;

    local v103 = DataController.Get(LocalPlayer, "Statistics.OpenShopTime");
    local v104 = nil;

    if typeof(v103) == "number" then
        v104 = v103;
    elseif typeof(v103) == "string" then
        v104 = tonumber(v103);
    end;

    local v105;

    if v104 == nil then
        v105 = nil;
    elseif v104 > 10000000000 then
        v105 = math.floor(v104 / 1000);
    else
        v105 = math.floor(v104);
    end;

    local v106 = {
        IsDataLoaded = true,
        OpenShopTime = v105
    };
    local v107;

    if DataController.IsDataLoaded(LocalPlayer) then
        local v108 = DataController.Get(LocalPlayer, "Gamepasses");

        if typeof(v108) == "table" then
            v107 = table.find(v108, "Credits StarterPack") ~= nil;
        else
            v107 = false;
        end;
    else
        v107 = false;
    end;

    v106.OwnsStarterPack = v107;
    local v109 = nil;

    if typeof(v105) == "number" then
        v109 = v105;
    elseif typeof(v105) == "string" then
        v109 = tonumber(v105);
    end;

    local v110;

    if v109 == nil then
        v110 = nil;
    elseif v109 > 10000000000 then
        v110 = math.floor(v109 / 1000);
    else
        v110 = math.floor(v109);
    end;

    local v111;

    if v110 == nil then
        v111 = 0;
    else
        local v112 = p102 or workspace:GetServerTimeNow();
        local v113 = 86400 - math.max(0, v112 - v110);
        local v114 = math.floor(v113);
        v111 = math.max(0, v114);
    end;

    v106.RemainingSeconds = v111;

    return v106;
end;

local function RefreshStarterPackState(p115) -- Line: 735
    -- upvalues: Profiler (copy), GetStarterPackState (copy), u22 (ref), Bundles (copy), ParseDateTimerTimestamp (copy), ResolveStarterPackUI (copy), u15 (ref), u16 (ref)
    Profiler.mark("UI.Store.RefreshStarterPackState");
    local v116 = GetStarterPackState(p115);
    local v117;

    if v116.RemainingSeconds > 0 then
        v117 = not v116.OwnsStarterPack;
    else
        v117 = false;
    end;

    if u22 then
        if v117 then
            local v118 = math.floor(v116.RemainingSeconds);
            local v119 = math.max(0, v118);
            local v120 = math.floor(v119 / 3600);
            local v121 = math.floor(v119 % 3600 / 60);
            local v122 = math.floor(v119 % 60);
            u22.Text = string.format("%02d:%02d:%02d", v120, v121, v122);
        else
            local v123 = Bundles.GetActiveBundle();
            local v124;

            if v123 and v123.discontinueDate then
                local v125 = ParseDateTimerTimestamp(v123.discontinueDate);

                if v125 then
                    if not p115 then
                        local v126 = workspace:GetServerTimeNow();
                        p115 = math.floor(v126);
                    end;

                    local v127 = v125 - math.floor(p115);
                    v124 = v127 <= 0 and "00:00:00:00" or string.format("%02d:%02d:%02d:%02d", math.floor(v127 / 86400), math.floor(v127 % 86400 / 3600), math.floor(v127 % 3600 / 60), (math.floor(v127 % 60)));
                else
                    v124 = "00:00:00:00";
                end;
            else
                v124 = "NEW!";
            end;

            u22.Text = v124;
        end;
    end;

    if not ResolveStarterPackUI() then
        return;
    end;

    if v116.OwnsStarterPack then
        u15.Visible = false;

        return;
    end;

    u15.Visible = v117;
    local v128;

    if v117 then
        local v129 = math.floor(v116.RemainingSeconds);
        local v130 = math.max(0, v129);
        local v131 = math.floor(v130 / 3600);
        local v132 = math.floor(v130 % 3600 / 60);
        local v133 = math.floor(v130 % 60);
        v128 = string.format("%02d:%02d:%02d", v131, v132, v133) or "00:00:00";
    else
        v128 = "00:00:00";
    end;

    u16.Text = v128;
end;

function u1.IsStarterPackAvailable() -- Line: 767
    -- upvalues: GetStarterPackState (copy)
    local v134 = GetStarterPackState();

    if v134.IsDataLoaded and not v134.OwnsStarterPack then
        return v134.OpenShopTime == nil and true or v134.RemainingSeconds > 0;
    end;

    return false;
end;

function u1.GetStarterPackRemainingSeconds() -- Line: 778
    -- upvalues: GetStarterPackState (copy)
    return GetStarterPackState().RemainingSeconds;
end;

function u1.GetStarterPackWindowSeconds() -- Line: 782
    return 86400;
end;

local function HandleStoreOpened() -- Line: 788
    -- upvalues: Profiler (copy), GetStarterPackState (copy), RefreshStarterPackState (copy), u18 (ref), u19 (ref), Remotes (copy)
    Profiler.mark("UI.Store.HandleStoreOpened");
    local v135 = GetStarterPackState();

    if not v135.IsDataLoaded then
        RefreshStarterPackState();

        return;
    end;

    if v135.OpenShopTime ~= nil then
        u18 = true;
        RefreshStarterPackState();

        return;
    end;

    local v136 = tick();

    if not u18 or v136 - u19 >= 5 then
        u18 = true;
        u19 = v136;
        Remotes.Store.OpenedShop.Send({});
    end;

    RefreshStarterPackState();
end;

local function ActivateCategoryButton(u137) -- Line: 814
    -- upvalues: TweenService (copy), Router (copy)
    local Size = u137.Size;
    u137.MouseEnter:Connect(function() -- Line: 817
        -- upvalues: TweenService (ref), u137 (copy), Size (copy), Router (ref)
        local v138 = TweenInfo.new(0.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut);
        local v139 = {};
        local v140 = Size;
        v139.Size = UDim2.fromScale(v140.X.Scale * 0.9, v140.Y.Scale * 0.9);
        TweenService:Create(u137, v138, v139):Play();
        Router.broadcastRouter("RunInterfaceSound", "UI Highlight");
    end);
    u137.MouseLeave:Connect(function() -- Line: 826
        -- upvalues: TweenService (ref), u137 (copy), Size (copy)
        TweenService:Create(u137, TweenInfo.new(0.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
            Size = Size
        }):Play();
    end);
    u137.MouseButton1Click:Connect(function() -- Line: 834
        -- upvalues: Router (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
    end);
end;

local function GetRandomCaseItem(p141) -- Line: 841
    local v142 = 0;

    for _, v in ipairs(p141.contents) do
        v142 = v142 + v.weight;
    end;

    local v143 = math.random() * v142;
    local v144 = 0;

    for _, v in ipairs(p141.contents) do
        v144 = v144 + v.weight;

        if v143 <= v144 then
            return v, v.isSpecial or false;
        end;
    end;

    local v145 = p141.contents[1];

    return v145, v145.isSpecial or false;
end;

local function GenerateScrollItemList(p146, p147, p148, p149) -- Line: 860
    -- upvalues: GetRandomCaseItem (copy)
    local v150 = {};

    for i = 1, 75 do
        if i == p148 then
            table.insert(v150, {
                item = p147,
                isGold = p149
            });
        else
            local v151, v152 = GetRandomCaseItem(p146);
            table.insert(v150, {
                item = v151,
                isGold = v152
            });
        end;
    end;

    return v150;
end;

local function CreateScrollItem(p153, p154, p155, p156) -- Line: 880
    -- upvalues: ReplicatedStorage (copy), Rarities (copy), Skins (copy), u11 (copy)
    local CaseScroll = ReplicatedStorage.Assets.UI.Store.CaseScroll;
    local v157;

    if p154.isGold then
        v157 = CaseScroll:FindFirstChild("GoldTemplate");
    else
        v157 = CaseScroll:FindFirstChild("ItemTemplate");
    end;

    if not v157 then
        warn("[Store] Missing case scroll template");

        return;
    end;

    local v158 = v157:Clone();
    v158.Name = tostring(p155);
    v158.LayoutOrder = p155;
    v158.Size = p156;
    v158.SizeConstraint = Enum.SizeConstraint.RelativeXY;
    v158.AutomaticSize = Enum.AutomaticSize.None;
    v158.Parent = p153;

    if p154.isGold then
        local v159 = string.lower(p154.item.skin.skinName);
        v158.Frame.Icon.Image = "rbxassetid://132217734282843";

        if u11[v159] then
            v158.Frame.Icon.Image = u11[v159];
        end;
    else
        local v160 = Rarities[p154.item.rarity];
        local v161 = Skins.GetSkinInformation(p154.item.skin.weaponName, p154.item.skin.skinName);
        local Frame = v158:FindFirstChild("Frame");

        if v160 and (v161 and Frame) then
            local RarityFrame = Frame:FindFirstChild("RarityFrame");
            local v162 = RarityFrame and RarityFrame:FindFirstChild("UIGradient");

            if v162 then
                v162.Color = v160.ColorSequence;
            end;

            local Icon = Frame:FindFirstChild("Icon");

            if Icon then
                local v163 = "";

                if v161.wearImages and #v161.wearImages > 0 then
                    v163 = v161.wearImages[1].assetId;
                elseif v161.charmImages and #v161.charmImages > 0 then
                    v163 = v161.charmImages[1].assetId;
                elseif v161.imageAssetId then
                    v163 = v161.imageAssetId;
                end;

                Icon.Image = v163;
            end;

            local Rarity = Frame:FindFirstChild("Rarity");

            if Rarity then
                Rarity.ImageColor3 = v160.Color;
            end;
        end;
    end;
end;

local function PopulateScrollContainer(p164, p165, p166, p167) -- Line: 943
    -- upvalues: CreateScrollItem (copy)
    for _, child in ipairs(p164:GetChildren()) do
        if child:IsA("Frame") or (child:IsA("ImageLabel") or child:IsA("ImageButton")) then
            child:Destroy();
        end;
    end;

    local v168 = p164:FindFirstChildOfClass("UIListLayout");

    if v168 then
        v168.FillDirection = Enum.FillDirection.Horizontal;
        v168.HorizontalAlignment = Enum.HorizontalAlignment.Left;
        v168.VerticalAlignment = Enum.VerticalAlignment.Center;
        v168.Padding = UDim.new(0, p167);
    end;

    for i, v in ipairs(p165) do
        CreateScrollItem(p164, v, i, p166);
    end;
end;

local function ConfigureScrollContainer(p169, p170) -- Line: 968
    local v171 = math.max(p169.AbsoluteSize.X, 1);
    local v172 = math.max(p170 / v171, 1);
    p169.CanvasSize = UDim2.fromScale(v172, 0);
    p169:SetAttribute("ScrollMaxOffset", (math.max(0, p170 - v171)));
    p169:SetAttribute("ScrollViewportWidth", v171);
end;

local function CalculateTargetOffset(p173, p174, p175, p176, p177) -- Line: 978
    local v178 = math.max(p173.AbsoluteSize.X, 1);
    local v179 = math.max(0, p174 - v178);

    return v179 <= 0 and 0 or math.clamp((p175 - 0.5) * p176 - v178 * 0.5 + p177, 0, v179);
end;

local function AnimateScroll(u180, u181, u182, u183, u184, u185) -- Line: 996
    -- upvalues: TweenService (copy), u24 (copy), RunServiceController (copy)
    local v186 = TweenInfo.new(7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
    local u187 = TweenService:Create(u180, v186, {
        CanvasPosition = Vector2.new(u182, 0)
    });
    local u188 = TweenService:Create(u181, v186, {
        CanvasPosition = Vector2.new(u183, 0)
    });
    u24.currentTween = u187;
    u24.currentZoomTween = u188;
    local u189 = 0;
    local u190 = nil;
    u190 = RunServiceController.BindToRenderStep("UI.Store.CaseOpeningSounds", function() -- Line: 1018
        -- upvalues: u24 (ref), u190 (ref), u180 (copy), u184 (copy), u189 (ref), u185 (copy), u187 (copy)
        if not u24.isOpening then
            if u190 then
                u190:Disconnect();
                u190 = nil;
                u24.renderConnection = nil;
            end;

            return;
        end;

        local v191 = math.floor(u184 <= 0 and 0 or u180.CanvasPosition.X / u184) + 1;

        if u189 < v191 and v191 <= 75 then
            u185(v191);
            u189 = v191;
        end;

        if u187.PlaybackState == Enum.PlaybackState.Completed and u190 then
            u190:Disconnect();
            u190 = nil;
            u24.renderConnection = nil;
        end;
    end);
    u24.renderConnection = u190;
    u187.Completed:Connect(function() -- Line: 1047
        -- upvalues: u187 (copy), u24 (ref), u190 (ref)
        if u187 ~= u24.currentTween then
            return;
        end;

        if u190 then
            u190:Disconnect();
            u190 = nil;
            u24.renderConnection = nil;
        end;
    end);
    task.delay(6.02, function() -- Line: 1059
        -- upvalues: u187 (copy), u24 (ref), u180 (copy), u181 (copy), u190 (ref), u188 (copy), u182 (copy), u183 (copy)
        if u187 ~= u24.currentTween then
            return;
        end;

        if u187.PlaybackState == Enum.PlaybackState.Completed then
            return;
        end;

        if u180.Parent == nil or u181.Parent == nil then
            if u190 then
                u190:Disconnect();
                u190 = nil;
                u24.renderConnection = nil;
            end;

            return;
        end;

        u187:Cancel();
        u188:Cancel();
        u180.CanvasPosition = Vector2.new(u182, 0);
        u181.CanvasPosition = Vector2.new(u183, 0);

        if u190 then
            u190:Disconnect();
            u190 = nil;
            u24.renderConnection = nil;
        end;
    end);
    u187:Play();
    u188:Play();

    return u187;
end;

local function UpdateCaseTemplateAlert(p192, p193, p194) -- Line: 1093
    -- upvalues: ParseDateTimerTimestamp (copy)
    local Alert = p192:FindFirstChild("Alert");

    if not (Alert and Alert:IsA("GuiObject")) then
        return;
    end;

    if not p193.discontinueDate then
        Alert.Visible = p193.status == "featured";

        return;
    end;

    Alert.Visible = true;
    local TextLabel = Alert:FindFirstChild("TextLabel");

    if TextLabel and TextLabel:IsA("TextLabel") then
        local v195 = ParseDateTimerTimestamp(p193.discontinueDate);
        local v196;

        if v195 then
            if not p194 then
                local v197 = workspace:GetServerTimeNow();
                p194 = math.floor(v197);
            end;

            local v198 = v195 - math.floor(p194);
            v196 = v198 <= 0 and "00:00:00:00" or string.format("%02d:%02d:%02d:%02d", math.floor(v198 / 86400), math.floor(v198 % 86400 / 3600), math.floor(v198 % 3600 / 60), (math.floor(v198 % 60)));
        else
            v196 = "00:00:00:00";
        end;

        TextLabel.Text = v196;
    end;
end;

local function UpdateCaseDiscontinueTimers(u199) -- Line: 1114
    -- upvalues: Cases (copy), UpdateCaseTemplateAlert (copy), u13 (ref)
    (function(p200) -- Line: 1115, Name: UpdateContainer
        -- upvalues: Cases (ref), UpdateCaseTemplateAlert (ref), u199 (copy)
        for _, child in ipairs(p200:GetChildren()) do
            if child:IsA("Frame") then
                local v201 = Cases.GetCase(child.Name);

                if v201 then
                    UpdateCaseTemplateAlert(child, v201, u199);
                end;
            end;
        end;
    end)(u13.Tabs.Container.Featured.Scroll.Cases.Container.Cases);
end;

local function CountMatchingCases(p202) -- Line: 1132
    -- upvalues: DataController (copy), LocalPlayer (copy)
    local v203 = DataController.Get(LocalPlayer, "Inventory");

    if not v203 then
        return 0;
    end;

    local v204 = 0;

    for _, v in ipairs(v203) do
        if (v.Type == "Case" or v.Type == "Package") and v.Skin == p202 then
            v204 = v204 + 1;
        end;
    end;

    return v204;
end;

local function CollectCaseIdentifiers(p205, p206) -- Line: 1152
    -- upvalues: DataController (copy), LocalPlayer (copy)
    local v207 = DataController.Get(LocalPlayer, "Inventory");
    local v208 = {};

    if v207 then
        for _, v in ipairs(v207) do
            if p206 <= #v208 then
                break;
            end;

            if (v.Type == "Case" or v.Type == "Package") and v.Skin == p205 then
                table.insert(v208, v._id);
            end;
        end;
    end;

    return v208;
end;

local function FilterAmountButtons(p209, p210) -- Line: 1173
    local v211 = p209:GetChildren();

    for _, v in ipairs(v211) do
        if v:IsA("TextButton") then
            v.Visible = (tonumber(v.Name) or 0) <= p210;
        end;
    end;
end;

local function ShowAllAmountButtons(p212) -- Line: 1186
    local v213 = p212:GetChildren();

    for _, v in ipairs(v213) do
        if v:IsA("TextButton") then
            v.Visible = true;
        end;
    end;
end;

local function ResetBulkOpeningState() -- Line: 1199
    -- upvalues: u29 (copy)
    u29.isBulkOpening = false;
    u29.inventoryItems = nil;
    u29.bulkIdentifier = nil;
    u29.currentIndex = 0;
    u29.skipped = false;
    u29.caseId = nil;
    u29.total = 0;
end;

local function GetUnboxedItemRarity(p214, p215) -- Line: 1211
    if p214.Type == "Melee" or p214.Type == "Glove" then
        return "Special";
    end;

    for _, v in ipairs(p215.contents) do
        if v.skin.skinName == p214.Skin and v.skin.weaponName == p214.Name then
            return v.rarity or "Blue";
        end;
    end;

    return "Blue";
end;

local function FindWinningItem(p216, p217) -- Line: 1227
    for _, v in ipairs(p216.contents) do
        if v.skin.skinName == p217.Skin and v.skin.weaponName == p217.Name then
            return v, v.isSpecial or false;
        end;
    end;

    if p217.Type == "Melee" or p217.Type == "Glove" then
        return {
            isSpecial = true,
            rarity = "Special",
            skinId = "",
            weight = 0,
            skin = {
                weaponName = p217.Name,
                skinName = p217.Skin,
                type = p217.Type
            }
        }, true;
    end;

    local v218 = p216.contents[1];

    return v218, v218.isSpecial or false;
end;

local function ResetProgressBar() -- Line: 1255
    -- upvalues: u24 (copy), u14 (ref)
    if u24.progressRightTween then
        u24.progressRightTween:Cancel();
        u24.progressRightTween = nil;
    end;

    if u24.progressRightProxy then
        u24.progressRightProxy:Destroy();
        u24.progressRightProxy = nil;
    end;

    if not u14 then
        return;
    end;

    local ProgressBar = u14.Menu.OpenCase.Contents:FindFirstChild("ProgressBar");

    if not ProgressBar then
        return;
    end;

    local RightGradient = ProgressBar:FindFirstChild("RightGradient");
    local LeftGradient = ProgressBar:FindFirstChild("LeftGradient");
    local v219 = RightGradient and RightGradient:FindFirstChild("ProgressBarImage") and RightGradient.ProgressBarImage:FindFirstChild("UIGradient");
    local v220 = LeftGradient and LeftGradient:FindFirstChild("ProgressBarImage") and LeftGradient.ProgressBarImage:FindFirstChild("UIGradient");

    if v219 then
        v219.Transparency = NumberSequence.new(1);
        v219.Rotation = 90;
    end;

    if v220 then
        v220.Transparency = NumberSequence.new(1);
        v220.Rotation = 90;
    end;
end;

local function MakeFillTransparency(p221) -- Line: 1293
    if p221 <= 0.001 then
        return NumberSequence.new(1);
    end;

    if p221 >= 0.999 then
        return NumberSequence.new(0);
    end;

    local v222 = math.clamp(p221 - 0.05, 0, 0.999);
    local v223 = math.clamp(p221, v222 + 0.001, 1);

    return NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(v222, 0),
        NumberSequenceKeypoint.new(v223, 1),
        NumberSequenceKeypoint.new(1, 1)
    });
end;

local function MakeEraseTransparency(p224) -- Line: 1310
    if p224 <= 0.001 then
        return NumberSequence.new(0);
    end;

    if p224 >= 0.999 then
        return NumberSequence.new(1);
    end;

    local v225 = math.clamp(p224 - 0.05, 0, 0.999);
    local v226 = math.clamp(p224, v225 + 0.001, 1);

    return NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(v225, 1),
        NumberSequenceKeypoint.new(v226, 0),
        NumberSequenceKeypoint.new(1, 0)
    });
end;

local function AnimateProgressBar(p227) -- Line: 1329
    -- upvalues: ResetProgressBar (copy), u14 (ref), u4 (ref), u24 (copy), TweenService (copy), Profiler (copy), MakeFillTransparency (copy), MakeEraseTransparency (copy)
    ResetProgressBar();

    if not u14 then
        return;
    end;

    local ProgressBar = u14.Menu.OpenCase.Contents:FindFirstChild("ProgressBar");

    if not ProgressBar then
        return;
    end;

    local LeftGradient = ProgressBar:FindFirstChild("LeftGradient");
    local RightGradient = ProgressBar:FindFirstChild("RightGradient");

    if not (LeftGradient and RightGradient) then
        return;
    end;

    local ProgressBarImage = LeftGradient:FindFirstChild("ProgressBarImage");
    local ProgressBarImage2 = RightGradient:FindFirstChild("ProgressBarImage");

    if not (ProgressBarImage and ProgressBarImage2) then
        return;
    end;

    local UIGradient = ProgressBarImage:FindFirstChild("UIGradient");
    local UIGradient2 = ProgressBarImage2:FindFirstChild("UIGradient");

    if not (UIGradient and UIGradient2) then
        return;
    end;

    LeftGradient.ClipsDescendants = true;
    RightGradient.ClipsDescendants = true;
    UIGradient.Rotation = 90;
    UIGradient2.Rotation = -90;
    UIGradient.Transparency = NumberSequence.new(1);
    UIGradient2.Transparency = NumberSequence.new(1);
    ProgressBar.Visible = true;
    u4 = u4 + 1;
    local u228 = u4;
    local u229 = p227 / 4 / 4;

    local function runPhase(u230, u231, p232) -- Line: 1369
        -- upvalues: u24 (ref), u228 (copy), u4 (ref), TweenService (ref)
        if not u24.isOpening or u228 ~= u4 then
            return false;
        end;

        local NumberValue = Instance.new("NumberValue");
        NumberValue.Value = 0;
        local v234 = NumberValue.Changed:Connect(function(p233) -- Line: 1380
            -- upvalues: u230 (copy), u231 (copy)
            u230.Transparency = u231(p233);
        end);
        u24.progressRightProxy = NumberValue;
        local v235 = TweenService:Create(NumberValue, TweenInfo.new(p232, Enum.EasingStyle.Linear), {
            Value = 1
        });
        u24.progressRightTween = v235;
        v235:Play();
        v235.Completed:Wait();
        v234:Disconnect();
        NumberValue:Destroy();
        u24.progressRightProxy = nil;
        u24.progressRightTween = nil;

        return u24.isOpening and u228 == u4;
    end;

    Profiler.spawn("UI.Store.ProgressBarThread", function() -- Line: 1400
        -- upvalues: runPhase (copy), UIGradient (copy), MakeFillTransparency (ref), u229 (copy), UIGradient2 (copy), MakeEraseTransparency (ref)
        for _ = 1, 4 do
            if not runPhase(UIGradient, MakeFillTransparency, u229) then
                return;
            end;

            if not runPhase(UIGradient2, MakeFillTransparency, u229) then
                return;
            end;

            if not runPhase(UIGradient, MakeEraseTransparency, u229) then
                return;
            end;

            if not runPhase(UIGradient2, MakeEraseTransparency, u229) then
                return;
            end;
        end;
    end);
end;

local function RunScrollAnimation(p236, p237) -- Line: 1420
    -- upvalues: u24 (copy), u14 (ref), FindWinningItem (copy), GenerateScrollItemList (copy), PopulateScrollContainer (copy), ConfigureScrollContainer (copy), AnimateScroll (copy), Router (copy), AnimateProgressBar (copy), TweenService (copy)
    if not u24.isOpening then
        return nil;
    end;

    local OpenCase = u14.Menu.OpenCase;
    local CanvasGroup = OpenCase:FindFirstChild("CanvasGroup");
    local Zoom = OpenCase:FindFirstChild("Zoom");

    if not (CanvasGroup and Zoom) then
        warn("[Store] Missing CanvasGroup or Zoom group in OpenCase UI");

        return nil;
    end;

    local Container = CanvasGroup:FindFirstChild("Container");
    local Container2 = Zoom:FindFirstChild("Container");

    if not (Container and Container2) then
        warn("[Store] Missing scroll containers for case opening");

        return nil;
    end;

    local v238, v239 = FindWinningItem(p236, p237);
    local v240 = GenerateScrollItemList(p236, v238, 55, v239);
    local v241 = u14 and u14.AbsoluteSize or Vector2.new(1075, 1000);
    local v242 = math.max(v241.X / 5, 1);
    local v243 = math.max(v242 * 0.65, 1);
    local v244 = UDim2.fromOffset(v242, v243);
    local v245 = UDim2.fromOffset(v242, v243 * 1.125);
    local Line = OpenCase:FindFirstChild("Line");

    if Line and Line:IsA("GuiObject") then
        Line.Size = UDim2.new(0.003, 0, 0, v243 * 1.125);
    end;

    PopulateScrollContainer(Container, v240, v244, 8);
    PopulateScrollContainer(Container2, v240, v245, 8);
    Container.CanvasPosition = Vector2.new(0, 0);
    Container2.CanvasPosition = Vector2.new(0, 0);
    local u246 = v242 + 8;
    local u247 = u246 * 75;
    task.wait();
    ConfigureScrollContainer(Container, u247);
    ConfigureScrollContainer(Container2, u247);
    local X = v241.X;
    local u248 = math.random(-math.floor(X / 11), (math.floor(X / 22)));
    local v249 = math.max(Container.AbsoluteSize.X, 1);
    local v250 = math.max(0, u247 - v249);
    local v251 = v250 <= 0 and 0 or math.clamp(u246 * 54.5 - v249 * 0.5 + u248, 0, v250);
    local v252 = math.max(Container2.AbsoluteSize.X, 1);
    local v253 = math.max(0, u247 - v252);
    local v254 = v253 <= 0 and 0 or math.clamp(u246 * 54.5 - v252 * 0.5 + u248, 0, v253);
    Container:SetAttribute("_scrollTarget", v251);
    Container2:SetAttribute("_scrollTarget", v254);
    local u255 = tick();
    local v256 = AnimateScroll(Container, Container2, v251, v254, u246, function() -- Line: 1479
        -- upvalues: Router (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
    end);
    AnimateProgressBar(7);
    u24.viewportConnection = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- Line: 1487
        -- upvalues: u24 (ref), Container (copy), u247 (copy), u246 (copy), u248 (copy), Container2 (copy), u255 (copy), TweenService (ref)
        if not u24.isOpening then
            return;
        end;

        local v257 = math.max(Container.AbsoluteSize.X, 1);
        local v258 = math.max(0, u247 - v257);
        local v259 = v258 <= 0 and 0 or math.clamp(u246 * 54.5 - v257 * 0.5 + u248, 0, v258);
        local v260 = math.max(Container2.AbsoluteSize.X, 1);
        local v261 = math.max(0, u247 - v260);
        local v262 = v261 <= 0 and 0 or math.clamp(u246 * 54.5 - v260 * 0.5 + u248, 0, v261);

        if u24.currentTween then
            u24.currentTween:Cancel();
        end;

        if u24.currentZoomTween then
            u24.currentZoomTween:Cancel();
        end;

        local v263 = 7 - (tick() - u255);
        local v264 = math.max(0.1, v263);
        local v265 = TweenInfo.new(v264, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
        local v266 = TweenService:Create(Container, v265, {
            CanvasPosition = Vector2.new(v259, 0)
        });
        local v267 = TweenService:Create(Container2, v265, {
            CanvasPosition = Vector2.new(v262, 0)
        });
        u24.currentTween = v266;
        u24.currentZoomTween = v267;
        v266:Play();
        v267:Play();
    end);

    if v256 then
        while u24.isOpening do
            local currentTween = u24.currentTween;

            if not currentTween then
                break;
            end;

            currentTween.Completed:Wait();

            if u24.currentTween == currentTween then
                break;
            end;
        end;
    end;

    if u24.viewportConnection then
        u24.viewportConnection:Disconnect();
        u24.viewportConnection = nil;
    end;

    u24.currentTween = nil;
    u24.currentZoomTween = nil;

    return v238;
end;

function u1.PurchaseCase(p268, p269) -- Line: 1540
    -- upvalues: DataController (copy), LocalPlayer (copy), Remotes (copy), u3 (ref), MarketplaceService (copy), DevProducts (copy), u1 (copy)
    local v270 = DataController.Get(LocalPlayer, "Credits");
    local v271 = p268.price * p269;

    if v271 <= v270 then
        Remotes.Store.PurchaseCase.Send({
            CaseId = p268.caseId,
            Amount = p269
        });

        return;
    end;

    if not u3 then
        return;
    end;

    local v272 = v271 - v270;
    MarketplaceService:PromptProductPurchase(LocalPlayer, DevProducts[v272 <= 400 and "+ 400 Credits" or (v272 <= 950 and "+ 950 Credits" or (v272 <= 3100 and "+ 3,100 Credits" or (v272 <= 6500 and "+ 6,500 Credits" or (v272 <= 13250 and "+ 13,250 Credits" or "+ 27,000 Credits"))))].DevProductId);
    u1.CloseCaseContent("Store");
    u1.OpenTab("Credits");
end;

function u1.CreateCaseTemplate(u273, p274) -- Line: 1558
    -- upvalues: Profiler (copy), Rarities (copy), ReplicatedStorage (copy), Cases2 (copy), UpdateCaseTemplateAlert (copy), ActivateButton (copy), Router (copy), u1 (copy)
    if u273.caseType == "Console" then
        return;
    end;

    if p274:FindFirstChild(u273.caseId) then
        return;
    end;

    Profiler.mark("UI.Store.CreateCaseTemplate");
    local v275 = Rarities[u273.caseRarity];

    if v275 then
        local v276 = ReplicatedStorage.Assets.UI.Store.CaseTemplate:Clone();
        local v277;

        if Cases2[u273.name] then
            v277 = Cases2[u273.name].Amounts[1] or nil;
        else
            v277 = nil;
        end;

        if v277 and (v277.BasePrice and v277.Price < v277.BasePrice) then
            local v278 = math.floor(v277.BasePrice / v277.Price) * 10;
            v276.Discount.Discount.Title.Text = `-{v278}%`;
        else
            v276.Discount.Visible = false;
        end;

        v276.Contents.Glow.ImageColor3 = v275.Color;
        v276.Contents.Pattern.ImageColor3 = v275.Color;
        v276.Contents.Rarity.BackgroundColor3 = v275.Color;
        UpdateCaseTemplateAlert(v276, u273);
        v276.Contents.Icon.Image = u273.imageAssetId;
        v276.Footer.CaseName.Text = u273.name;
        v276.Parent = p274;
        v276.Name = u273.caseId;
        ActivateButton(v276.Purchase);
        v276.Purchase.MouseButton1Click:Connect(function() -- Line: 1588
            -- upvalues: Router (ref), u1 (ref), u273 (copy)
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
            u1.OpenCaseContent(u273.caseId, "Inspect");
        end);
        ActivateButton(v276.Gift);
        v276.Gift.MouseButton1Click:Connect(function() -- Line: 1595
            -- upvalues: u1 (ref), u273 (copy)
            u1.OpenGift(u273.caseId, "Case");
        end);
    end;
end;

function u1.ActivateGiftTemplate(u279, u280) -- Line: 1604
    -- upvalues: Router (copy), TweenService (copy), LocalPlayer (copy), u13 (ref), DataController (copy), Cases (copy), Remotes (copy), MarketplaceService (copy), Gamepasses (copy), DevProducts (copy), DoCreditPurchase (copy)
    u279.Button.MouseEnter:Connect(function() -- Line: 1606
        -- upvalues: Router (ref), TweenService (ref), u279 (copy)
        Router.broadcastRouter("RunInterfaceSound", "UI Highlight");
        TweenService:Create(u279.Player.Username, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextColor3 = Color3.fromRGB(255, 200, 0)
        }):Play();
    end);
    u279.Button.MouseLeave:Connect(function() -- Line: 1619
        -- upvalues: TweenService (ref), u279 (copy)
        TweenService:Create(u279.Player.Username, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextColor3 = Color3.fromRGB(190, 190, 190)
        }):Play();
    end);
    u279.Button.MouseButton1Click:Connect(function() -- Line: 1631
        -- upvalues: u280 (copy), LocalPlayer (ref), u13 (ref), Router (ref), DataController (ref), Cases (ref), Remotes (ref), MarketplaceService (ref), Gamepasses (ref), DevProducts (ref), DoCreditPurchase (ref)
        if u280 == LocalPlayer.UserId then
            return;
        end;

        local v281 = u13:GetAttribute("GiftProductName");
        local v282 = u13:GetAttribute("GiftProductType");
        Router.broadcastRouter("RunInterfaceSound", "UI Click");

        if v282 == "Case" then
            local v283 = DataController.Get(LocalPlayer, "Credits");
            local v284 = Cases.GetCase(v281);
            local v285 = tonumber(u13.Gift.Amount.Header.TextLabel.Text) or 1;

            if v283 >= v284.price * v285 then
                u13.Gift.Visible = false;

                return Remotes.Store.GiftCase.Send({
                    RecipientUserId = tostring(u280),
                    CaseId = v281,
                    Amount = v285
                });
            end;

            return;
        end;

        Remotes.Store.CreateGift.Send({
            RecipientUserId = tostring(u280),
            ProductName = v281,
            ProductType = v282
        });

        if v282 == "Gamepass" then
            MarketplaceService:PromptGamePassPurchase(LocalPlayer, Gamepasses[v281].GamepassId);

            return;
        end;

        if v282 ~= "DevProduct" then
            return nil;
        end;

        local v286 = DataController.Get(LocalPlayer, "TradeTokens");

        if string.find(v281, "Trade Tokens", 1, true) ~= nil or (not DevProducts[v281].Price or DevProducts[v281].Price > v286) then
            MarketplaceService:PromptProductPurchase(LocalPlayer, DevProducts[v281].DevProductId);

            return;
        end;

        DoCreditPurchase(v281, DevProducts[v281]);
    end);
end;

function u1.SetupCurrencyFrame(u287, u288) -- Line: 1692
    -- upvalues: DevProducts (copy), Router (copy), TweenService (copy), LoadProductInfo (copy), ActivateButton (copy), u3 (ref), DataController (copy), LocalPlayer (copy), DoCreditPurchase (copy), MarketplaceService (copy), u1 (copy)
    local Rewards = u287:FindFirstChild("Rewards");
    local Size = u287.Size;
    local u289 = DevProducts[u287.Name];
    u287.MouseEnter:Connect(function() -- Line: 1698
        -- upvalues: Router (ref), TweenService (ref), u287 (copy), Size (copy)
        Router.broadcastRouter("RunInterfaceSound", "UI Highlight");
        local v290 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        local v291 = {};
        local v292 = Size;
        v291.Size = UDim2.fromScale(v292.X.Scale * 0.975, v292.Y.Scale * 0.975);
        TweenService:Create(u287, v290, v291):Play();
    end);
    u287.MouseLeave:Connect(function() -- Line: 1707
        -- upvalues: TweenService (ref), u287 (copy), Size (copy)
        TweenService:Create(u287, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = Size
        }):Play();
    end);
    local Purchase_Button = u287:FindFirstChild("Purchase_Button", true);

    if Purchase_Button then
        local function u294(p293) -- Line: 1717
            -- upvalues: u288 (copy), Purchase_Button (copy)
            if u288 then
                Purchase_Button.Credit.Amount.Text = tostring(p293):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");

                return;
            end;

            Purchase_Button.Container.Title.Text = `{utf8.char(57346)} {tostring(p293):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")}`;
        end;

        if u289.Price and u294 then
            local Price = u289.Price;

            if u288 then
                Purchase_Button.Credit.Amount.Text = tostring(Price):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
            else
                Purchase_Button.Container.Title.Text = `{utf8.char(57346)} {tostring(Price):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")}`;
            end;
        end;

        LoadProductInfo(u289.DevProductId, function(p295) -- Line: 232
            -- upvalues: u289 (copy), u294 (copy)
            if not (p295 and p295.PriceInRobux) then
                return;
            end;

            u289.Price = p295.PriceInRobux;

            if u294 then
                u294(u289.Price);
            end;
        end);
        ActivateButton(Purchase_Button);
        Purchase_Button.MouseButton1Click:Connect(function() -- Line: 1726
            -- upvalues: u3 (ref), DataController (ref), LocalPlayer (ref), u288 (copy), u289 (copy), DoCreditPurchase (ref), u287 (copy), MarketplaceService (ref), Router (ref)
            if not u3 then
                return;
            end;

            local v296 = DataController.Get(LocalPlayer, "TradeTokens");

            if u288 or (not u289.Price or u289.Price > v296) then
                MarketplaceService:PromptProductPurchase(LocalPlayer, u289.DevProductId);
            else
                DoCreditPurchase(u287.Name, u289);
            end;

            Router.broadcastRouter("RunInterfaceSound", "UI Click");
        end);
    end;

    local Gift_Button = u287:FindFirstChild("Gift_Button", true);

    if Gift_Button then
        ActivateButton(Gift_Button);
        Gift_Button.MouseButton1Click:Connect(function() -- Line: 1745
            -- upvalues: u1 (ref), u287 (copy), Router (ref)
            u1.OpenGift("Gift " .. u287.Name, "DevProduct");
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
        end);
    end;

    if Rewards then
        local v297 = Rewards:FindFirstChild("Rewards") or Rewards;

        for _, child in ipairs(v297:GetChildren()) do
            if child:IsA("Frame") then
                child.Icon.Button.MouseButton1Click:Connect(function() -- Line: 1756
                    -- upvalues: Router (ref), child (copy)
                    Router.broadcastRouter("WeaponInspect", child.Icon.Button:GetAttribute("WeaponName"), child.Icon.Button:GetAttribute("SkinName"), 0, nil, nil, nil, nil, nil, 1, nil, 1, nil);
                    Router.broadcastRouter("RunInterfaceSound", "UI Click");
                end);
            end;
        end;
    end;
end;

local u298 = false;
local u299 = nil;

function u1.SetupStarterPackFrame() -- Line: 1786
    -- upvalues: ResolveStarterPackUI (copy), u20 (ref), u15 (ref), ActivateButton (copy), u17 (ref), DevProducts (copy), LoadProductInfo (copy), u298 (ref), u1 (copy), RefreshStarterPackState (copy), u3 (ref), u299 (ref), DataController (copy), LocalPlayer (copy), DoCreditPurchase (copy), MarketplaceService (copy), Router (copy)
    if not ResolveStarterPackUI() or u20 then
        return;
    end;

    u20 = true;
    u15.Visible = false;
    local v300 = u15:FindFirstChild("Pack") and u15.Pack:FindFirstChild("Button");

    if v300 and v300:IsA("GuiButton") then
        v300.Visible = false;
    end;

    ActivateButton(u17);
    local u301 = DevProducts["Credits Starter Pack"];

    if u301 then
        local function u303(p302) -- Line: 1807
            -- upvalues: u17 (ref)
            if not u17.Parent then
                return;
            end;

            local Container = u17:FindFirstChild("Container");

            if Container then
                Container = Container:FindFirstChild("Title");
            end;

            if Container and Container:IsA("TextLabel") then
                Container.Text = `{utf8.char(57346)} {tostring(p302):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")}`;
            end;
        end;

        if u301.Price and u303 then
            u303(u301.Price);
        end;

        LoadProductInfo(u301.DevProductId, function(p304) -- Line: 232
            -- upvalues: u301 (copy), u303 (copy)
            if not (p304 and p304.PriceInRobux) then
                return;
            end;

            u301.Price = p304.PriceInRobux;

            if u303 then
                u303(u301.Price);
            end;
        end);
    end;

    u17.MouseButton1Click:Connect(function() -- Line: 1822
        -- upvalues: u298 (ref), u1 (ref), RefreshStarterPackState (ref), u3 (ref), DevProducts (ref), u299 (ref), DataController (ref), LocalPlayer (ref), DoCreditPurchase (ref), MarketplaceService (ref), Router (ref)
        if u298 or not u1.IsStarterPackAvailable() then
            RefreshStarterPackState();

            return;
        end;

        if u3 then
            local v305 = DevProducts["Credits Starter Pack"];

            if not v305 then
                warn("[Store] Missing dev product configuration for Credits Starter Pack");

                return;
            end;

            u298 = true;
            u299 = v305.DevProductId;
            local v306 = DataController.Get(LocalPlayer, "TradeTokens");

            if v305.Price and v305.Price <= v306 then
                DoCreditPurchase("Credits Starter Pack", v305);
                u298 = false;
            else
                MarketplaceService:PromptProductPurchase(LocalPlayer, v305.DevProductId);
                task.delay(1, function() -- Line: 1844
                    -- upvalues: u298 (ref)
                    u298 = false;
                end);
            end;

            Router.broadcastRouter("RunInterfaceSound", "UI Click");
        end;
    end);
    MarketplaceService.PromptProductPurchaseFinished:Connect(function(p307, p308) -- Line: 1852
        -- upvalues: u299 (ref), LocalPlayer (ref), u298 (ref)
        if p308 == u299 and p307 == LocalPlayer.UserId then
            u298 = false;
        end;
    end);
end;

function u1.UpdateCases() -- Line: 1861
    -- upvalues: Profiler (copy), Cases (copy), ClearFrame (copy), u13 (ref), u1 (copy)
    Profiler.mark("UI.Store.UpdateCases");
    local v309 = Cases.GetFeaturedCases(6);
    ClearFrame(u13.Tabs.Container.Featured.Scroll.Cases.Container.Cases, { "UIListLayout", "UIGridLayout" });
    local v310 = Cases.GetCases();
    ClearFrame(u13.Tabs.Container.Featured.Scroll.Cases.Container.Cases, { "UIListLayout", "UIGridLayout" });

    for _, v in ipairs(v309) do
        if v.caseType ~= "Package" then
            u1.CreateCaseTemplate(v, u13.Tabs.Container.Featured.Scroll.Cases.Container.Cases);
        end;
    end;

    for _, v in ipairs(v310) do
        if v.caseType ~= "Package" then
            u1.CreateCaseTemplate(v, u13.Tabs.Container.Featured.Scroll.Cases.Container.Cases);
        end;
    end;
end;

local function GetRarityChance(p311, p312) -- Line: 1884
    for _, v in p312 do
        if v.rarity == p311 then
            return v.chance;
        end;
    end;

    return 0;
end;

local function RoundToNearestThousandsth(p313) -- Line: 1894
    return string.format("%.4f", math.floor(p313 * 10000) / 10000);
end;

local function GetBaseSkinName(p314) -- Line: 1899
    if p314:find("_PATTERN_") then
        return p314:split("_PATTERN_")[1];
    end;

    return p314;
end;

local function RenderGroupedOdds(p315, p316, p317) -- Line: 1909
    -- upvalues: GetSkinDisplayName (copy), Rarities (copy), ReplicatedStorage (copy)
    local v318 = {};
    local v319 = {};

    for _, v in ipairs(p315) do
        local skinName = v.skin.skinName;

        if skinName:find("_PATTERN_") then
            skinName = skinName:split("_PATTERN_")[1];
        end;

        local v320 = `{v.skin.weaponName}|{skinName}`;

        if not v318[v320] then
            local v321 = {
                weaponName = v.skin.weaponName,
                baseSkinName = skinName,
                rarity = v.rarity
            };
            v318[v320] = v321;
            table.insert(v319, v321);
        end;
    end;

    for _, v in ipairs(v319) do
        local v322 = p316(v, v319);
        local v323 = GetSkinDisplayName(v.baseSkinName, false);
        local Color = Rarities[v.rarity].Color;
        local v324 = ReplicatedStorage.Assets.UI.Store.OddTemplate:Clone();
        v324.Left.Label.Text = `{v.weaponName} - <font color="#{Color:ToHex()}">{v323}</font>`;
        v324.Left.Frame.BackgroundColor3 = Color;
        v324.Right.Label.Text = `{string.format("%.4f", math.floor(v322 * 10000) / 10000)}%`;
        v324.LayoutOrder = 100 - v322;
        v324.Parent = p317;
    end;
end;

local function UpdateCasePurchaseButtons(p325) -- Line: 1941
    -- upvalues: u13 (ref), Cases2 (copy), Cases (copy), u3 (ref)
    local SubButtons = u13.CaseContent.Main.Bottom.SubButtons;
    local v326 = Cases2[p325.name];
    local v327 = Cases.IsCaseForSale(p325.caseId);
    local v328 = false;

    for _, child in ipairs(SubButtons.CenterButtons:GetChildren()) do
        if child:IsA("GuiButton") then
            child.Visible = false;
        end;
    end;

    if v326 and (u3 and v327) then
        for i, v in v326.Amounts do
            local v329 = SubButtons.CenterButtons:FindFirstChild((tostring(i)));

            if v329 and v329:IsA("GuiButton") then
                v329.Visible = v.Offsale == false;
                v328 = v328 or v329.Visible;
                v329.Container.Title.Text = `BUY x{i} <font color="#ffda0f">({tostring(v.Price):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")})</font>`;
            end;
        end;
    end;

    SubButtons.Visible = v328;
end;

local function StartBackgroundProductLoading() -- Line: 1968
    -- upvalues: DevProducts (copy), LoadProductInfo (copy), u1 (copy), u8 (ref), u13 (ref), UpdateCasePurchaseButtons (copy), Cases2 (copy)
    for _, v in DevProducts do
        local _ = v.Price;
        local u330 = nil;
        LoadProductInfo(v.DevProductId, function(p331) -- Line: 232
            -- upvalues: v (copy), u330 (copy)
            if not (p331 and p331.PriceInRobux) then
                return;
            end;

            v.Price = p331.PriceInRobux;

            if u330 then
                u330(v.Price);
            end;
        end);
    end;

    local u332 = 0;

    local function CompleteRequest() -- Line: 1974
        -- upvalues: u332 (ref), u1 (ref), u8 (ref), u13 (ref), UpdateCasePurchaseButtons (ref)
        u332 = u332 - 1;

        if u332 == 0 then
            u1.UpdateCases();

            if u8 and u13.CaseContent.Visible then
                UpdateCasePurchaseButtons(u8);
            end;
        end;
    end;

    for _, v in Cases2 do
        for _, v2 in v.Amounts do
            u332 = u332 + 1;
            LoadProductInfo(v2.ID, function(p333) -- Line: 1987
                -- upvalues: v2 (copy), u332 (ref), u1 (ref), u8 (ref), u13 (ref), UpdateCasePurchaseButtons (ref)
                if p333 then
                    v2.Offsale = not p333.IsForSale;

                    if p333.IsForSale and p333.PriceInRobux then
                        v2.BasePrice = p333.UserBasePriceInRobux or v2.BasePrice;
                        v2.Price = p333.PriceInRobux;
                    end;
                end;

                u332 = u332 - 1;

                if u332 == 0 then
                    u1.UpdateCases();

                    if u8 and u13.CaseContent.Visible then
                        UpdateCasePurchaseButtons(u8);
                    end;
                end;
            end);
        end;
    end;
end;

function u1.OpenCaseContent(p334, p335, p336) -- Line: 2001
    -- upvalues: Profiler (copy), Cases (copy), u7 (ref), u8 (ref), UpdateCasePurchaseButtons (copy), u13 (ref), MenuState (copy), u14 (ref), CountMatchingCases (copy), FilterAmountButtons (copy), ShowAllAmountButtons (copy), RenderGroupedOdds (copy), u12 (copy), CaseSceneController (copy), ClearFrame (copy), Skins (copy), Rarities (copy), GetSkinDisplayName (copy), ReplicatedStorage (copy), ActivateButton (copy), Router (copy), GetUserPlatform (copy), u11 (copy)
    Profiler.mark((`UI.Store.OpenCaseContent.{p335}`));
    local u337 = Cases.GetCase(p334);
    u7 = p336;
    u8 = u337;

    if u337 then
        UpdateCasePurchaseButtons(u337);

        if u13.Visible or MenuState.GetCurrentScreen() == "Store" then
            MenuState.SetScreen("Store");
            u13.CaseContent:SetAttribute("WasVisibleBeforeInspect", true);
        else
            u13.CaseContent:SetAttribute("WasVisibleBeforeInspect", false);
        end;

        u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Position = p335 == "Open" and UDim2.new(0.687, 0, 0.465, 0) or UDim2.new(0.575, 0, 0.465, 0);
        u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Buy.Container.Title.Text = `BUY <font color="#ffda0f">({tostring(u337.price):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")})</font>`;
        u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Visible = true;
        u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Header.TextLabel.Text = "1";
        u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Buy.Visible = p335 == "Inspect";
        u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Open.Visible = p335 == "Open";
        u13.CaseContent:SetAttribute("State", p335);
        u13.Tabs.Container.Visible = false;
        u13.CaseContent.Visible = true;
        u14.Menu.Top.Visible = false;
        u13.Top.Visible = false;
        u13.Visible = true;

        if p335 == "Open" then
            local v338 = CountMatchingCases(u337.name);
            FilterAmountButtons(u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Container.Scroll, v338);
        else
            ShowAllAmountButtons(u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Container.Scroll);
        end;

        for _, child in ipairs(u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Container.Scroll:GetChildren()) do
            if child:IsA("TextButton") then
                child.Frame.BackgroundTransparency = child.Name == "1" and 0 or 1;
                child:SetAttribute("Selected", child.Name == "1");
            end;
        end;

        for _, child in ipairs(u13.CaseContent.Odds.Frame.Container.ScrollingComponent.Scroll:GetChildren()) do
            if child.Name ~= "INVIS" then
                if child:IsA("Frame") and child.Name ~= "Special" then
                    child:Destroy();
                elseif child:IsA("Frame") and child.Name == "Special" then
                    child.Visible = false;
                end;
            end;
        end;

        local v339 = {};
        local v340 = {};

        for _, v in u337.contents do
            if not v339[v.rarity] then
                v339[v.rarity] = 0;
            end;

            local rarity = v.rarity;
            v339[rarity] = v339[rarity] + 1;
        end;

        local u341 = {};
        local v342 = false;

        for i in pairs(v339) do
            local v343 = 0;

            for _, v in u337.rarityChances do
                if v.rarity == i then
                    v343 = v.chance;
                    break;
                end;
            end;

            local v344 = v343 or 0;
            u341[i] = v344;

            if v344 > 0 then
                v342 = true;
            end;
        end;

        if not v342 then
            local v345 = 0;
            local v346 = {};

            for _, v in ipairs(u337.contents) do
                local v347 = v.weight or 0;
                v345 = v345 + v347;
                v346[v.rarity] = (v346[v.rarity] or 0) + v347;
            end;

            local v348 = #u337.contents;

            for i, v in pairs(v339) do
                if v345 > 0 then
                    u341[i] = (v346[i] or 0) / v345 * 100;
                else
                    u341[i] = v / math.max(v348, 1) * 100;
                end;
            end;
        end;

        local function GetDisplayRarityChance(p349) -- Line: 2102
            -- upvalues: u341 (copy)
            return u341[p349] or 0;
        end;

        local Scroll = u13.CaseContent.Odds.Frame.Container.ScrollingComponent.Scroll;

        local function getContentGroupOdds(p350, p351) -- Line: 2109
            -- upvalues: u341 (copy)
            local v352 = 0;

            for _, v in ipairs(p351) do
                if v.rarity == p350.rarity then
                    v352 = v352 + 1;
                end;
            end;

            return (u341[p350.rarity] or 0) / math.max(v352, 1);
        end;

        local function getSpecialGroupOdds(p353, p354) -- Line: 2119
            -- upvalues: u337 (copy)
            return u337.specialChance / math.max(#p354, 1);
        end;

        for _, v in ipairs(u337.contents) do
            v340[`{v.skin.weaponName}_{v.skin.skinName}`] = (u341[v.rarity] or 0) / v339[v.rarity];
        end;

        RenderGroupedOdds(u337.contents, getContentGroupOdds, Scroll);
        RenderGroupedOdds(u337.specialContents, getSpecialGroupOdds, Scroll);
        local v355 = {};

        for _, v in ipairs(u337.contents) do
            if v.rarity then
                v355[v.rarity] = true;
            end;
        end;

        local function SetChanceRowText(p356, p357) -- Line: 2148
            local Right = p356:FindFirstChild("Right");

            if Right then
                Right = Right:FindFirstChild("Label");
            end;

            if Right then
                Right.Text = p357;
            end;
        end;

        for i in pairs(u12) do
            if i ~= "Special" then
                local v358 = u13.CaseContent.Main.CaseChances:FindFirstChild(i);

                if v358 then
                    v358.Visible = v355[i] == true;
                    local v359 = `{math.round((u341[i] or 0) * 100) / 100}%`;
                    local Right = v358:FindFirstChild("Right");

                    if Right then
                        Right = Right:FindFirstChild("Label");
                    end;

                    if Right then
                        Right.Text = v359;
                    end;
                end;
            end;
        end;

        local v360;

        if u337.specialContents == nil then
            v360 = false;
        else
            v360 = #u337.specialContents > 0;
        end;

        local Special = u13.CaseContent.Main.CaseChances:FindFirstChild("Special");

        if Special then
            Special.Visible = v360;
            local v361 = `{u337.specialChance or 0}%`;
            local Right = Special:FindFirstChild("Right");

            if Right then
                Right = Right:FindFirstChild("Label");
            end;

            if Right then
                Right.Text = v361;
            end;
        end;

        if u14 and u14.Menu then
            u14.Menu.Visible = true;
        end;

        CaseSceneController.ShowCaseScene(u337.caseType, u337.name);
        Profiler.defer("UI.Store.CaseContentVisibilityDeferred", function() -- Line: 2178
            -- upvalues: u13 (ref)
            u13.Visible = true;
            u13.CaseContent.Visible = true;
        end);
        ClearFrame(u13.CaseContent.Main.CaseContent.Container, { "UIGridLayout", "UIPadding" });
        local v362 = table.clone(u337.contents);
        table.sort(v362, function(p363, p364) -- Line: 2186
            -- upvalues: u12 (ref)
            return (u12[p363.rarity] or 0) < (u12[p364.rarity] or 0);
        end);

        for _, v in ipairs(v362) do
            local v365 = Skins.GetSkinInformation(v.skin.weaponName, v.skin.skinName);
            local v366 = Rarities[v.rarity];
            local v367;

            if v365.wearImages and v365.wearImages[1] then
                v367 = v365.wearImages[1].assetId;
            elseif v365.charmImages and v365.charmImages[1] then
                v367 = v365.charmImages[1].assetId;
            else
                v367 = v365.imageAssetId or "";
            end;

            local v368 = GetSkinDisplayName(v.skin.skinName, true);
            local v369 = ReplicatedStorage.Assets.UI.Store.ItemTemplate:Clone();
            local Odds = v369.ItemContent.Content.Odds;
            local v370 = v340[`{v.skin.weaponName}_{v.skin.skinName}`] or 0;
            Odds.Text = `{string.format("%.4f", math.floor(v370 * 10000) / 10000)}%`;
            v369.Bottom.Footer.WeaponName.Text = v.skin.weaponName:find("Zeus") and "Taser" or v.skin.weaponName;
            v369.ItemContent.Rarity.BackgroundColor3 = v366.Color;
            v369.ItemContent.Content.Rarity.ImageColor3 = v366.Color;
            v369.Bottom.Footer.SkinName.Text = v368;
            v369.Parent = u13.CaseContent.Main.CaseContent.Container;
            v369.ItemContent.Content.Icon.Image = v367;
            local Charm = v369.ItemContent:FindFirstChild("Charm");

            if Charm and Charm:IsA("ImageLabel") then
                Charm.Visible = false;
            end;

            local Inspect = v369.ItemContent:FindFirstChild("Inspect");

            if Inspect then
                Inspect.Visible = true;
                ActivateButton(Inspect);

                local function runInspect() -- Line: 2225
                    -- upvalues: Router (ref), v (copy)
                    Router.broadcastRouter("RunInterfaceSound", "UI Click");
                    Router.broadcastRouter("WeaponInspect", v.skin.weaponName, v.skin.skinName, 0, nil, nil, nil, nil, v.skin.type == "Charm" and "Charm" or nil, 1, nil, 1, nil);
                end;

                Inspect.MouseButton1Click:Connect(runInspect);
                local v371 = GetUserPlatform();
                local v372;

                if table.find(v371, "Mobile") == nil then
                    v372 = false;
                else
                    v372 = #v371 <= 1;
                end;

                local MobileInspect = v369.ItemContent:FindFirstChild("MobileInspect");

                if MobileInspect then
                    if v372 then
                        ActivateButton(MobileInspect);
                        MobileInspect.Activated:Connect(runInspect);
                    else
                        MobileInspect.Visible = false;
                    end;
                end;
            end;
        end;

        if u337.caseType == "Case" then
            local v373 = ReplicatedStorage.Assets.UI.Store.GoldTemplate:Clone();
            v373.Content.Content.Odds.Text = "0.26%";
            v373.Content.Icon.Image = u11[u337.caseId] or "rbxassetid://132217734282843";
            v373.Parent = u13.CaseContent.Main.CaseContent.Container;
        end;
    end;
end;

function u1.OpenGift(p374, p375) -- Line: 2276
    -- upvalues: u13 (ref)
    u13:SetAttribute("GiftProductName", p374);
    u13:SetAttribute("GiftProductType", p375);
    local Amount = u13.Gift.Amount;
    Amount.Header.TextLabel.Text = "1";
    Amount.Visible = p375 == "Case";
    Amount.Container.Visible = false;

    for _, child in ipairs(Amount.Container:GetChildren()) do
        if child:IsA("TextButton") then
            child.Frame.BackgroundTransparency = child.Name == "1" and 0 or 1;
            child:SetAttribute("Selected", child.Name == "1");
        end;
    end;

    u13.Gift.Visible = true;
end;

function u1.SearchPlayerGift(p376) -- Line: 2297
    -- upvalues: u13 (ref), Players (copy), ReplicatedStorage (copy), u1 (copy)
    local SearchResult = u13.Gift.Container:FindFirstChild("SearchResult");

    if SearchResult then
        SearchResult:Destroy();
    end;

    local u377 = tonumber(p376);

    if p376 == "" or not u377 then
        return;
    end;

    for _, child in ipairs(u13.Gift.Container:GetChildren()) do
        if child:IsA("Frame") then
            child.Visible = false;
        end;
    end;

    local success, result = pcall(function() -- Line: 2318
        -- upvalues: Players (ref), u377 (copy)
        return Players:GetNameFromUserIdAsync(u377);
    end);

    if not success then
        return;
    end;

    local v378 = ReplicatedStorage.Assets.UI.Store.PlayerTemplate:Clone();
    v378.Player.Avatar.Image = `rbxthumb://type=AvatarHeadShot&id={u377}&w=420&h=420`;
    v378.Player.Username.Text = `@{result}`;
    v378.Parent = u13.Gift.Container;
    v378.Name = "SearchResult";
    u1.ActivateGiftTemplate(v378, u377);
end;

function u1.OpenTab(p379) -- Line: 2337
    -- upvalues: Profiler (copy), u3 (ref), Router (copy), ScrollToFeaturedSection (copy)
    Profiler.mark((`UI.Store.OpenTab.{p379}`));

    if (p379 == "Credits" or p379 == "TradeTokens") and not u3 then
        Router.broadcastRouter("CreateMenuNotification", "Error", "Paid random items are not allowed in your region.");

        return;
    end;

    ScrollToFeaturedSection(p379);
end;

function u1.OpenBundleSection() -- Line: 2350
    -- upvalues: Profiler (copy), ScrollToFeaturedSection (copy)
    Profiler.mark("UI.Store.OpenBundleSection");
    ScrollToFeaturedSection("Bundle");
end;

function u1.OpenCase(p380, u381, p382, p383, p384) -- Line: 2357
    -- upvalues: Profiler (copy), u24 (copy), CleanupCaseOpeningTweens (copy), Cases (copy), Remotes (copy), CaseSceneController (copy), u13 (ref), u14 (ref), MenuState (copy), u28 (copy), GetUnboxedItemRarity (copy), Router (copy), TryProcessResolvedCaseOpenQueue (copy), RunScrollAnimation (copy)
    Profiler.mark("UI.Store.OpenCase");

    if p383 == nil then
        p383 = u24.isQuickUnlock;
    end;

    u24.currentCaseIdentifier = p382;
    CleanupCaseOpeningTweens();
    local u385 = Cases.GetCase(p380);

    if not u385 then
        return;
    end;

    if not p383 then
        u24.isOpening = true;
        u24.currentInventoryItem = u381;
        u13.CaseContent.Visible = false;
        local v386 = u385.caseType == "Package";

        local function startRollAnimation() -- Line: 2409
            -- upvalues: u24 (ref), u14 (ref), u385 (copy), u13 (ref), RunScrollAnimation (ref), u381 (copy), Router (ref), Remotes (ref), CaseSceneController (ref), MenuState (ref), u28 (ref)
            if not u24.isOpening then
                return;
            end;

            u14.Menu.OpenCase.CaseName.Text = `Unlock {u385.name}`;
            u14.Menu.OpenCase.Visible = true;
            u13.Visible = false;
            u14.Menu.OpenCase.Contents.Close.TextLabel.Text = "CLOSE";
            local v387 = RunScrollAnimation(u385, u381);

            if not u24.isOpening then
                return;
            end;

            Router.broadcastRouter("RunInterfaceSound", "UI Notification");
            task.wait(0.5);

            if not u24.isOpening then
                return;
            end;

            u24.isOpening = false;
            u24.currentInventoryItem = nil;
            local currentCaseIdentifier = u24.currentCaseIdentifier;

            if currentCaseIdentifier then
                Remotes.Store.CaseOpenSequenceFinished.Send({
                    CaseIdentifier = currentCaseIdentifier
                });
                u24.currentCaseIdentifier = nil;
            end;

            u14.Menu.OpenCase.Visible = false;
            CaseSceneController.HideCaseScene();
            u13.Tabs.Container.Visible = true;
            u13.CaseContent.Visible = false;
            u14.Menu.Top.Visible = true;
            u13.Top.Visible = true;
            u13.Visible = false;
            MenuState.SetScreen("Inventory");
            Router.broadcastRouter("RunStoreSound", u28[v387 and v387.rarity or "Blue"] or "Drop Blue");
            Router.broadcastRouter("RunStoreSound", "Case Close");
            Router.broadcastRouter("WeaponInspect", u381.Name, u381.Skin, u381.Float, u381.StatTrack, u381.NameTag, u381.Charm, u381.Stickers, u381.Type, u381.Pattern, u381._id, u381.Serial, u381.IsTradeable);
        end;

        if u385.caseType == "Charm Capsule" then
            CaseSceneController.TransitionToUnboxing(startRollAnimation);

            return;
        end;

        if v386 then
            CaseSceneController.TransitionToUnboxing();
            CaseSceneController.WaitForOpeningAnimation();

            if u24.isOpening then
                u24.isOpening = false;
                u24.currentInventoryItem = nil;
                local currentCaseIdentifier = u24.currentCaseIdentifier;

                if currentCaseIdentifier then
                    Remotes.Store.CaseOpenSequenceFinished.Send({
                        CaseIdentifier = currentCaseIdentifier
                    });
                    u24.currentCaseIdentifier = nil;
                end;

                CaseSceneController.HideCaseScene();
                u13.Tabs.Container.Visible = true;
                u13.CaseContent.Visible = false;
                u14.Menu.Top.Visible = true;
                u13.Top.Visible = true;
                u13.Visible = false;
                MenuState.SetScreen("Inventory");
                local v388 = u28[GetUnboxedItemRarity(u381, u385)] or "Drop Blue";
                Router.broadcastRouter("RunStoreSound", v388);
                Router.broadcastRouter("RunStoreSound", "Case Close");
                Router.broadcastRouter("WeaponInspect", u381.Name, u381.Skin, u381.Float, u381.StatTrack, u381.NameTag, u381.Charm, u381.Stickers, u381.Type, u381.Pattern, u381._id, u381.Serial, u381.IsTradeable);

                return;
            end;
        else
            CaseSceneController.TransitionToUnboxing();
            task.wait(0.8);
            startRollAnimation();
        end;

        return;
    end;

    if p382 then
        Remotes.Store.CaseOpenSequenceFinished.Send({
            CaseIdentifier = p382
        });
    end;

    CaseSceneController.HideCaseScene();
    u13.Tabs.Container.Visible = true;
    u13.CaseContent.Visible = false;
    u14.Menu.Top.Visible = true;
    u13.Top.Visible = true;
    u13.Visible = false;
    MenuState.SetScreen("Inventory");
    local v389 = u28[GetUnboxedItemRarity(u381, u385)] or "Drop Blue";
    Router.broadcastRouter("RunStoreSound", v389);
    Router.broadcastRouter("RunStoreSound", "Case Close");
    Router.broadcastRouter("QuickOpenResolved", p384);
    Router.broadcastRouter("ShowNewItemNotification", u381);
    Profiler.defer("UI.Store.ResolvedQueueDeferred", TryProcessResolvedCaseOpenQueue);
end;

function u1.StopCaseOpening() -- Line: 2518
    -- upvalues: u24 (copy), Router (copy), CleanupCaseOpeningTweens (copy), u29 (copy), ResetProgressBar (copy), CaseSceneController (copy)
    if u24.isOpening then
        Router.broadcastRouter("RunStoreSound", "Case Close");
    end;

    CleanupCaseOpeningTweens();
    u29.isBulkOpening = false;
    u29.inventoryItems = nil;
    u29.bulkIdentifier = nil;
    u29.currentIndex = 0;
    u29.skipped = false;
    u29.caseId = nil;
    u29.total = 0;
    ResetProgressBar();
    local currentInventoryItem = u24.currentInventoryItem;
    u24.isOpening = false;
    u24.currentInventoryItem = nil;
    CaseSceneController.HideCaseScene();

    return currentInventoryItem;
end;

function u1.FinishBulkOpening() -- Line: 2538
    -- upvalues: u29 (copy), CleanupCaseOpeningTweens (copy), ResetProgressBar (copy), u24 (copy), CaseSceneController (copy), u14 (ref), u13 (ref), Router (copy), Remotes (copy), MenuState (copy), Profiler (copy), TryProcessResolvedCaseOpenQueue (copy)
    local v390 = u29.inventoryItems or {};
    local bulkIdentifier = u29.bulkIdentifier;
    CleanupCaseOpeningTweens();
    ResetProgressBar();
    u24.isOpening = false;
    u24.currentInventoryItem = nil;
    CaseSceneController.HideCaseScene();
    u14.Menu.OpenCase.Visible = false;
    u13.Tabs.Container.Visible = true;
    u13.CaseContent.Visible = false;
    u14.Menu.Top.Visible = true;
    u13.Top.Visible = true;
    u13.Visible = false;
    u14.Menu.OpenCase.Contents.Close.TextLabel.Text = "CLOSE";
    Router.broadcastRouter("RunStoreSound", "Case Close");

    if bulkIdentifier then
        Remotes.Store.CaseOpenSequenceFinished.Send({
            CaseIdentifier = bulkIdentifier
        });
    end;

    MenuState.SetScreen("Inventory");

    for _, v in ipairs(v390) do
        Router.broadcastRouter("ShowNewItemNotification", v);
    end;

    if #v390 > 0 then
        Router.broadcastRouter("ShowNewItemNotificationAtIndex", 1);
    end;

    u29.isBulkOpening = false;
    u29.inventoryItems = nil;
    u29.bulkIdentifier = nil;
    u29.currentIndex = 0;
    u29.skipped = false;
    u29.caseId = nil;
    u29.total = 0;
    Profiler.defer("UI.Store.ResolvedQueueDeferred", TryProcessResolvedCaseOpenQueue);
end;

function u1.SkipBulkOpening() -- Line: 2579
    -- upvalues: u29 (copy), CleanupCaseOpeningTweens (copy), u1 (copy)
    u29.skipped = true;
    CleanupCaseOpeningTweens();
    u1.FinishBulkOpening();
end;

function u1.StartBulkOpening(p391, p392, p393) -- Line: 2588
    -- upvalues: Profiler (copy), Cases (copy), u29 (copy), CleanupCaseOpeningTweens (copy), u24 (copy), u13 (ref), CaseSceneController (copy), u14 (ref), RunScrollAnimation (copy), Router (copy), u28 (copy), u1 (copy)
    Profiler.mark("UI.Store.StartBulkOpening");
    local v394 = Cases.GetCase(p391);

    if not v394 then
        return;
    end;

    u29.isBulkOpening = true;
    u29.inventoryItems = p392;
    u29.bulkIdentifier = p393;
    u29.caseId = p391;
    u29.total = #p392;
    u29.currentIndex = 0;
    u29.skipped = false;
    CleanupCaseOpeningTweens();
    u24.isOpening = true;
    u24.currentInventoryItem = nil;
    u13.CaseContent.Visible = false;
    CaseSceneController.TransitionToUnboxing();
    task.wait(0.8);

    if not u24.isOpening or u29.skipped then
        return;
    end;

    u14.Menu.OpenCase.CaseName.Text = `Unlock {v394.name}`;
    u14.Menu.OpenCase.Visible = true;
    u13.Visible = false;

    for i = 1, #p392 do
        if not u24.isOpening or u29.skipped then
            break;
        end;

        u29.currentIndex = i;
        local v395 = p392[i];
        u14.Menu.OpenCase.Contents.Close.TextLabel.Text = "CLOSE";
        local v396 = RunScrollAnimation(v394, v395);

        if not u24.isOpening or u29.skipped then
            break;
        end;

        Router.broadcastRouter("RunInterfaceSound", "UI Notification");
        Router.broadcastRouter("RunStoreSound", u28[v396 and v396.rarity or "Blue"] or "Drop Blue");

        if i == #p392 then
            task.wait(0.5);
        else
            local v397 = tick();

            while tick() - v397 < 1.5 and (not u29.skipped and u24.isOpening) do
                task.wait(0.1);
            end;
        end;
    end;

    if u24.isOpening and not u29.skipped then
        u1.FinishBulkOpening();
    end;
end;

function u1.SetQuickUnlock(p398) -- Line: 2667
    -- upvalues: u24 (copy)
    u24.isQuickUnlock = p398;
end;

function u1.BeginOpenCaseRequest(p399) -- Line: 2673
    -- upvalues: u25 (ref), u26 (copy), u24 (copy)
    u25 = u25 + 1;
    local v400 = tostring(u25);
    u26[v400] = {
        IsQuickUnlock = p399
    };
    u24.isPendingOpenRequest = true;
    u24.pendingOpenRequestId = v400;
    u24.isQuickUnlock = p399;

    return v400;
end;

function u1.ClearPendingOpenCaseRequest(p401) -- Line: 2679
    -- upvalues: u24 (copy)
    if u24.pendingOpenRequestId ~= p401 then
        return false;
    end;

    u24.isPendingOpenRequest = false;
    u24.pendingOpenRequestId = nil;
    u24.isQuickUnlock = false;

    return true;
end;

function u1.OpenCreatorCode() -- Line: 2690
    -- upvalues: u13 (ref), DataController (copy), LocalPlayer (copy), TweenService (copy)
    u13.CreatorCode:SetAttribute("ResponseId", nil);
    u13.CreatorCode.Container.Body.Response.Text = "";
    u13.CreatorCode.Container.Action.Confirm.Title.Text = "CONFIRM";
    u13.CreatorCode.Container.Body.CreatorName.TextBox.Text = DataController.Get(LocalPlayer, "CreatorCode") or "";
    u13.CreatorCode.Position = UDim2.fromScale(0.5, -1);
    u13.CreatorCode.Visible = true;
    u13.Tabs.Visible = false;
    TweenService:Create(u13.CreatorCode, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.fromScale(0.5, 0.5)
    }):Play();
end;

function u1.CloseCreatorCode() -- Line: 2708
    -- upvalues: TweenService (copy), u13 (ref)
    TweenService:Create(u13.CreatorCode, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.fromScale(0.5, -1)
    }):Play();
    task.wait(0.35);

    if u13.CreatorCode.Visible then
        u13.CreatorCode.Visible = false;
        u13.Tabs.Visible = true;
    end;
end;

function u1.CloseCaseContent(p402) -- Line: 2724
    -- upvalues: CaseSceneController (copy), u8 (ref), u7 (ref), u13 (ref), MenuState (copy), u14 (ref)
    CaseSceneController.HideCaseScene();
    u8 = nil;
    u7 = nil;
    u13.CaseContent:SetAttribute("WasVisibleBeforeInspect", false);

    if p402 == "Inventory" then
        MenuState.SetScreen("Inventory");
    end;

    u13.Tabs.Container.Visible = true;
    u13.CaseContent.Visible = false;
    u14.Menu.Top.Visible = true;
    u13.Top.Visible = true;

    if p402 ~= "Inventory" then
        u13.Visible = true;

        return;
    end;

    u14.Menu.Inventory.Visible = true;
    u13.Visible = false;
end;

function u1.Initialize(p403, p404) -- Line: 2755
    -- upvalues: Profiler (copy), u14 (ref), u13 (ref), u22 (ref), ActivateButton (copy), Router (copy), u1 (copy), CloseButtonRegistry (copy), u29 (copy), u24 (copy), Remotes (copy), MenuState (copy), TryProcessResolvedCaseOpenQueue (copy), u8 (ref), u7 (ref), CollectCaseIdentifiers (copy), u25 (ref), u26 (copy), UpdateCreatorCodeResponse (copy), DataController (copy), LocalPlayer (copy), ClearFrame (copy), DevProducts (copy), LoadProductInfo (copy), Bundles (copy), DoCreditPurchase (copy), MarketplaceService (copy), Cases (copy), Cases2 (copy), StartBackgroundProductLoading (copy), RunServiceController (copy), CollectionService (copy), u10 (copy), GetFeaturedBundleItemFrame (copy), u6 (ref), RefreshStarterPackState (copy), u5 (ref), UpdateCaseTemplateAlert (copy), ParseDateTimerTimestamp (copy), u2 (copy)
    Profiler.mark("UI.Store.Initialize");
    u14 = p403;
    u13 = p404;
    u22 = u14.Menu.Top.Bottom.Buttons.Store.Timer.Timer;
    ActivateButton(u13.Tabs.Container.Featured.Scroll.CreatorCode.CreatorCodeButton);
    u13.Tabs.Container.Featured.Scroll.CreatorCode.CreatorCodeButton.MouseButton1Click:Connect(function() -- Line: 2765
        -- upvalues: Router (ref), u1 (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        u1.OpenCreatorCode();
    end);
    CloseButtonRegistry.Add(u14.Menu.OpenCase, u14.Menu.OpenCase.Contents.Close, function() -- Line: 2771
        -- upvalues: u29 (ref), u1 (ref), u14 (ref), u24 (ref), Remotes (ref), u13 (ref), MenuState (ref), Router (ref), Profiler (ref), TryProcessResolvedCaseOpenQueue (ref)
        if u29.isBulkOpening then
            u1.SkipBulkOpening();

            return;
        end;

        local v405 = u1.StopCaseOpening();
        u14.Menu.OpenCase.Visible = false;
        local currentCaseIdentifier = u24.currentCaseIdentifier;

        if currentCaseIdentifier then
            Remotes.Store.CaseOpenSequenceFinished.Send({
                CaseIdentifier = currentCaseIdentifier
            });
            u24.currentCaseIdentifier = nil;
        end;

        u13.Tabs.Container.Visible = true;
        u13.CaseContent.Visible = false;
        u14.Menu.Top.Visible = true;
        u13.Top.Visible = true;
        u13.Visible = false;
        MenuState.SetScreen("Inventory");

        if v405 then
            Router.broadcastRouter("WeaponInspect", v405.Name, v405.Skin, v405.Float, v405.StatTrack, v405.NameTag, v405.Charm, v405.Stickers, v405.Type, v405.Pattern, v405._id, v405.Serial, v405.IsTradeable);

            return;
        end;

        u14.Menu.Inventory.Visible = true;
        Profiler.defer("UI.Store.ResolvedQueueDeferred", TryProcessResolvedCaseOpenQueue);
    end);
    ActivateButton(u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Open);
    u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Open.MouseButton1Click:Connect(function() -- Line: 2815
        -- upvalues: u8 (ref), u24 (ref), u7 (ref), Router (ref), u13 (ref), CollectCaseIdentifiers (ref), u25 (ref), u26 (ref), Remotes (ref)
        if not u8 or (u24.isOpening or u24.isPendingOpenRequest) then
            return;
        end;

        if not u7 then
            Router.broadcastRouter("CreateMenuNotification", "Error", "Case identifier missing. Please reopen the case.");

            return;
        end;

        local v406 = tonumber(u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Header.TextLabel.Text) or 1;
        local v407;

        if v406 > 1 then
            v407 = CollectCaseIdentifiers(u8.name, v406);

            if #v407 < 2 then
                Router.broadcastRouter("CreateMenuNotification", "Error", "Not enough cases in your inventory.");

                return;
            end;
        else
            v407 = { u7 };
        end;

        local v408;

        if v406 == 1 then
            v408 = u24.isQuickUnlock;
        else
            v408 = false;
        end;

        u25 = u25 + 1;
        local u409 = tostring(u25);
        u26[u409] = {
            IsQuickUnlock = v408
        };
        u24.isPendingOpenRequest = true;
        u24.pendingOpenRequestId = u409;
        u24.isQuickUnlock = v408;
        Remotes.Store.OpenCase.Send({
            CaseIdentifiers = v407,
            OpenType = v406 > 1 and "Bulk" or (v408 and "Quick Open" or "Standard"),
            CaseId = u8.caseId,
            RequestId = u409
        });
        task.delay(12 * (v406 > 1 and 2 or 1), function() -- Line: 2856
            -- upvalues: u24 (ref), u409 (copy), Router (ref)
            if u24.isPendingOpenRequest and u24.pendingOpenRequestId == u409 then
                u24.isPendingOpenRequest = false;
                u24.pendingOpenRequestId = nil;
                u24.isQuickUnlock = false;
                Router.broadcastRouter("CreateMenuNotification", "Error", "Opening case timed out. Please try again.");
            end;
        end);
    end);
    ActivateButton(u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Buy);
    u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Buy.MouseButton1Click:Connect(function() -- Line: 2866
        -- upvalues: u8 (ref), u1 (ref), u13 (ref)
        if not u8 then
            return;
        end;

        u1.PurchaseCase(u8, (tonumber(u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Header.TextLabel.Text)));
    end);
    ActivateButton(u13.CaseContent.Main.Bottom.Buttons.Close);
    CloseButtonRegistry.Add(u13.CaseContent, u13.CaseContent.Main.Bottom.Buttons.Close, function() -- Line: 2878
        -- upvalues: u24 (ref), u1 (ref), u13 (ref)
        if not u24.isPendingOpenRequest then
            u1.CloseCaseContent(u13.CaseContent:GetAttribute("State") == "Inspect" and "Store" or "Inventory");
        end;
    end);
    ActivateButton(u13.CreatorCode.Container.Action.Close);
    CloseButtonRegistry.Add(u13.CreatorCode, u13.CreatorCode.Container.Action.Close, function() -- Line: 2890
        -- upvalues: u1 (ref)
        u1.CloseCreatorCode();
    end);
    ActivateButton(u13.CreatorCode.Container.Body.CreatorName.Clear);
    u13.CreatorCode.Container.Body.CreatorName.Clear.MouseButton1Click:Connect(function() -- Line: 2897
        -- upvalues: u13 (ref), Remotes (ref)
        u13.CreatorCode.Container.Body.CreatorName.TextBox.Text = "";
        Remotes.UI.EquipCreatorCode.Send({
            CreatorCode = ""
        });
    end);
    ActivateButton(u13.CreatorCode.Container.Action.Confirm);
    u13.CreatorCode.Container.Action.Confirm.MouseButton1Click:Connect(function() -- Line: 2904
        -- upvalues: u13 (ref), Router (ref), UpdateCreatorCodeResponse (ref), Remotes (ref)
        local Text = u13.CreatorCode.Container.Body.CreatorName.TextBox.Text;
        u13.CreatorCode.Container.Action.Confirm.Title.Text = "SEARCHING..";
        Router.broadcastRouter("RunInterfaceSound", "UI Click");

        if Text and Text ~= "" then
            Remotes.UI.EquipCreatorCode.Send({
                CreatorCode = Text
            });

            return;
        end;

        UpdateCreatorCodeResponse("Error", "Creator code cannot be empty.");
    end);
    local Code = u13.Tabs.Container.Featured.Scroll.Code;
    local TextBox = Code.Main.Container.Top.Main.Textbox.TextBox;
    local Redeem = Code.Main.Container.Bottom.FooterButtons.Redeem;
    ActivateButton(Redeem);
    Redeem.MouseButton1Click:Connect(function() -- Line: 2924
        -- upvalues: Router (ref), DataController (ref), LocalPlayer (ref), TextBox (copy), Remotes (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        local v410 = DataController.Get(LocalPlayer, "Level");

        if not v410 or v410.Level < 5 then
            Router.broadcastRouter("CreateMenuNotification", "Error", "You need to be atleast level 5 to redeem codes.");

            return;
        end;

        local Text = TextBox.Text;

        if tostring(Text) == "" then
            Router.broadcastRouter("CreateMenuNotification", "Error", "Invalid code. Please try again.");

            return;
        end;

        TextBox.Text = "";
        Remotes.Dashboard.RedeemCode.Send(Text);
    end);
    ClearFrame(u13.Gift.Container, { "UICorner", "UIListLayout" });
    CloseButtonRegistry.Add(u13.Gift, u13.Gift.Close, function() -- Line: 2945
        -- upvalues: Router (ref), u13 (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        u13.Gift.Visible = false;
    end);
    ActivateButton(u13.Top.Currency.Credits.Buy);
    u13.Top.Currency.Credits.Buy.MouseButton1Click:Connect(function() -- Line: 2952
        -- upvalues: u1 (ref)
        u1.OpenTab("Credits");
    end);
    local TradeTokens2 = u13.Top.Currency.TradeTokens;
    TradeTokens2.Visible = true;
    ActivateButton(TradeTokens2.Buy);
    TradeTokens2.Buy.MouseButton1Click:Connect(function() -- Line: 2960
        -- upvalues: u1 (ref)
        u1.OpenTab("TradeTokens");
    end);
    local Bundle = u13.Tabs.Container.Featured.Scroll.Bundle;
    local Gift = Bundle.Container.Container.Content.FullBundle.Content.Buy.Gift;
    local Purchase = Bundle.Container.Container.Content.FullBundle.Content.Buy.Purchase;

    if Gift then
        ActivateButton(Gift);
        Gift.MouseButton1Click:Connect(function() -- Line: 2971
            -- upvalues: u1 (ref)
            u1.OpenGift("Gift Featured Bundle", "DevProduct");
        end);
    end;

    if Purchase then
        local u411 = DevProducts["Purchase Featured Bundle"];

        local function u413(p412) -- Line: 2979
            -- upvalues: Purchase (copy)
            Purchase.Container.Title.Text = `{utf8.char(57346)}{tostring(p412):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")}`;
        end;

        if u411.Price and u413 then
            local Price = u411.Price;
            Purchase.Container.Title.Text = `{utf8.char(57346)}{tostring(Price):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")}`;
        end;

        LoadProductInfo(u411.DevProductId, function(p414) -- Line: 232
            -- upvalues: u411 (copy), u413 (copy)
            if not (p414 and p414.PriceInRobux) then
                return;
            end;

            u411.Price = p414.PriceInRobux;

            if u413 then
                u413(u411.Price);
            end;
        end);
        ActivateButton(Purchase);
        Purchase.MouseButton1Click:Connect(function() -- Line: 2984
            -- upvalues: Bundles (ref), DataController (ref), LocalPlayer (ref), DevProducts (ref), DoCreditPurchase (ref), MarketplaceService (ref)
            if Bundles.GetActiveBundle() then
                local v415 = DataController.Get(LocalPlayer, "TradeTokens");

                if DevProducts["Purchase Featured Bundle"].Price and DevProducts["Purchase Featured Bundle"].Price <= v415 then
                    DoCreditPurchase("Purchase Featured Bundle", DevProducts["Purchase Featured Bundle"]);

                    return;
                end;

                MarketplaceService:PromptProductPurchase(LocalPlayer, DevProducts["Purchase Featured Bundle"].DevProductId);
            end;
        end);
    end;

    for _, child in u13.CaseContent.Main.Bottom.SubButtons.CenterButtons:GetChildren() do
        if child:IsA("ImageButton") then
            ActivateButton(child);
            child.MouseButton1Click:Connect(function() -- Line: 3007
                -- upvalues: u8 (ref), Cases (ref), Cases2 (ref), child (copy), DataController (ref), LocalPlayer (ref), DoCreditPurchase (ref), MarketplaceService (ref)
                if not (u8 and Cases.IsCaseForSale(u8.caseId)) then
                    return;
                end;

                local v416 = Cases2[u8.name];

                if not v416 then
                    return;
                end;

                local v417 = v416.Amounts[tonumber(child.Name)];

                if not v417 or v417.Offsale ~= false then
                    return;
                end;

                local v418 = DataController.Get(LocalPlayer, "TradeTokens");
                local Price = v417.Price;

                if Price * 1.15 > v418 then
                    MarketplaceService:PromptProductPurchase(LocalPlayer, v417.ID);

                    return;
                end;

                v416.Price = Price;
                v416.DevProductId = v417.ID;
                DoCreditPurchase(u8.name, v416, (tonumber(child.Name)));
            end);
        end;
    end;

    for _, child in ipairs(u13.Tabs.Container.Featured.Scroll.Credits:GetChildren()) do
        if child:IsA("Frame") then
            u1.SetupCurrencyFrame(child, false);
        end;
    end;

    for _, child in ipairs(u13.Tabs.Container.Featured.Scroll.TradeTokens:GetChildren()) do
        if child:IsA("Frame") then
            u1.SetupCurrencyFrame(child, true);
        end;
    end;

    u1.SetupStarterPackFrame();
    u1.UpdateCases();
    StartBackgroundProductLoading();
    RunServiceController.BindToHeartbeat("UI.Store.TimersAndCredits", function(p419) -- Line: 3051
        -- upvalues: Profiler (ref), u14 (ref), u13 (ref), CollectionService (ref)
        Profiler.mark("UI.Store.RotaterHeartbeat");
        local NewsTab2 = u14.Menu.Dashboard.Left.News.Frame:FindFirstChild("NewsTab2");

        if not (u13.Visible or NewsTab2 and NewsTab2.Visible) then
            return;
        end;

        for _, v in ipairs(CollectionService:GetTagged("StoreRotaterFrame")) do
            v.Rotation = v.Rotation + p419 * 25;
        end;
    end);

    for _, v in ipairs(u10) do
        local v420 = GetFeaturedBundleItemFrame(Bundle.Container.Container.Content.Parts.Content, v.frameNames);

        if v420 then
            local Gift2 = v420.Footer.Action.Gift;
            local Purchase2 = v420.Footer.Action.Purchase;
            local Inspect = v420.Inspect;

            if Gift2 then
                ActivateButton(Gift2);
                Gift2.MouseButton1Click:Connect(function() -- Line: 3072
                    -- upvalues: u1 (ref), v (copy)
                    u1.OpenGift("Gift " .. v.productName, "DevProduct");
                end);
            end;

            if Purchase2 then
                local u421 = DevProducts[v.productName];

                local function u423(p422) -- Line: 3079
                    -- upvalues: Purchase2 (copy)
                    Purchase2.Container.Title.Text = `{utf8.char(57346)}{tostring(p422):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")}`;
                end;

                if u421.Price and u423 then
                    local Price = u421.Price;
                    Purchase2.Container.Title.Text = `{utf8.char(57346)}{tostring(Price):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")}`;
                end;

                LoadProductInfo(u421.DevProductId, function(p424) -- Line: 232
                    -- upvalues: u421 (copy), u423 (copy)
                    if not (p424 and p424.PriceInRobux) then
                        return;
                    end;

                    u421.Price = p424.PriceInRobux;

                    if u423 then
                        u423(u421.Price);
                    end;
                end);
                ActivateButton(Purchase2);
                Purchase2.MouseButton1Click:Connect(function() -- Line: 3084
                    -- upvalues: DataController (ref), LocalPlayer (ref), DevProducts (ref), v (copy), DoCreditPurchase (ref), MarketplaceService (ref)
                    local v425 = DataController.Get(LocalPlayer, "TradeTokens");

                    if DevProducts[v.productName].Price and DevProducts[v.productName].Price <= v425 then
                        DoCreditPurchase(v.productName, DevProducts[v.productName]);

                        return;
                    end;

                    MarketplaceService:PromptProductPurchase(LocalPlayer, DevProducts[v.productName].DevProductId);
                end);
            end;

            if Inspect then
                ActivateButton(Inspect);
                Inspect.MouseButton1Click:Connect(function() -- Line: 3102
                    -- upvalues: Router (ref), v (copy)
                    Router.broadcastRouter("RunInterfaceSound", "UI Click");
                    Router.broadcastRouter("WeaponInspect", v.weaponName, v.skinName, 0, nil, nil, nil, nil, nil, 1, nil, 1, nil);
                end);
            end;
        end;
    end;

    u13.Gift.Search.TextBox.Focused:Connect(function() -- Line: 3126
        -- upvalues: u13 (ref)
        local SearchResult = u13.Gift.Container:FindFirstChild("SearchResult");

        if SearchResult then
            SearchResult:Destroy();
        end;

        for _, child in ipairs(u13.Gift.Container:GetChildren()) do
            if child:IsA("Frame") then
                child.Visible = true;
            end;
        end;
    end);
    u13.Gift.Search.TextBox.FocusLost:Connect(function() -- Line: 3140
        -- upvalues: u1 (ref), u13 (ref)
        u1.SearchPlayerGift(u13.Gift.Search.TextBox.Text);
    end);
    RunServiceController.BindToHeartbeat("UI.Store.Rotaters", function(p426) -- Line: 3145
        -- upvalues: u13 (ref), u14 (ref), u6 (ref), RefreshStarterPackState (ref), u5 (ref), Cases (ref), UpdateCaseTemplateAlert (ref), Bundles (ref), ParseDateTimerTimestamp (ref), Profiler (ref), u2 (ref)
        local Visible = u13.Visible;

        if not (Visible or u14 and u14.Menu and u14.Menu.Visible) then
            u6 = 1;

            return;
        end;

        u6 = u6 + p426;

        if u6 >= 1 then
            u6 = u6 % 1;
            local v427 = workspace:GetServerTimeNow();
            local u428 = math.floor(v427);
            RefreshStarterPackState(u428);

            if Visible and u5 <= u428 then
                u5 = u428 + 1;
                (function(p429) -- Line: 1115, Name: UpdateContainer
                    -- upvalues: Cases (ref), UpdateCaseTemplateAlert (ref), u428 (copy)
                    for _, child in ipairs(p429:GetChildren()) do
                        if child:IsA("Frame") then
                            local v430 = Cases.GetCase(child.Name);

                            if v430 then
                                UpdateCaseTemplateAlert(child, v430, u428);
                            end;
                        end;
                    end;
                end)(u13.Tabs.Container.Featured.Scroll.Cases.Container.Cases);
                local v431 = Bundles.GetActiveBundle();

                if v431 and v431.discontinueDate then
                    local Timer = u13.Tabs.Container.Featured.Scroll.Bundle.Container.Container.Header.Timer;
                    local v432 = ParseDateTimerTimestamp(v431.discontinueDate);
                    local v433;

                    if v432 then
                        if not u428 then
                            local v434 = workspace:GetServerTimeNow();
                            u428 = math.floor(v434);
                        end;

                        local v435 = v432 - math.floor(u428);
                        v433 = v435 <= 0 and "00:00:00:00" or string.format("%02d:%02d:%02d:%02d", math.floor(v435 / 86400), math.floor(v435 % 86400 / 3600), math.floor(v435 % 3600 / 60), (math.floor(v435 % 60)));
                    else
                        v433 = "00:00:00:00";
                    end;

                    Timer.Text = v433;
                end;
            end;
        end;

        if not Visible then
            return;
        end;

        Profiler.mark("UI.Store.CreditsHeartbeat");
        local v436 = u2:getPosition();
        local TextLabel = u13.Top.Currency.Credits.TextLabel;
        local v437 = math.round(v436);
        TextLabel.Text = `{tostring(v437):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")}`;
        u2:update(p426);
    end);
end;

function u1.HidePaidCurrencyPurchaseEntryPoints() -- Line: 3197
    -- upvalues: u13 (ref)
    local function hide(p438, ...) -- Line: 3198
        for _, v in ipairs({ ... }) do
            if not p438 then
                return;
            end;

            p438 = p438:FindFirstChild(v);
        end;

        if p438 and p438:IsA("GuiObject") then
            p438.Visible = false;
        end;
    end;

    hide(u13, "Top", "Categories", "Credits");
    hide(u13, "Top", "Currency", "Credits", "Buy");
    hide(u13, "Top", "Categories", "TradeTokens");
    hide(u13, "Top", "Currency", "TradeTokens", "Buy");
    hide(u13, "Tabs", "Container", "Featured", "Scroll", "Credits");
    hide(u13, "Tabs", "Container", "Featured", "Scroll", "TradeTokens");
end;

function u1.Start() -- Line: 3224
    -- upvalues: Profiler (copy), DataController (copy), LocalPlayer (copy), u1 (copy), PolicyService (copy), u3 (ref), u13 (ref), ActivateCategoryButton (copy), ActivateButton (copy), u8 (ref), u18 (ref), RefreshStarterPackState (copy), MenuState (copy), HandleStoreOpened (copy), u2 (copy), Constants (copy), Cases (copy), UpdateCasePurchaseButtons (copy), Remotes (copy), UpdateCreatorCodeResponse (copy), u26 (copy), u24 (copy), u27 (copy), TryProcessResolvedCaseOpenQueue (copy), CaseSceneController (copy), u14 (ref), Observers (copy), ReplicatedStorage (copy)
    debug.setmemorycategory("UI.Store.Start");
    Profiler.mark("UI.Store.Start.Begin");
    DataController.WaitForDataLoaded(LocalPlayer);
    Profiler.mark("UI.Store.Start.DataLoaded");
    u1.OpenTab("Featured");
    local success, result = pcall(function() -- Line: 3231
        -- upvalues: PolicyService (ref), LocalPlayer (ref)
        return PolicyService:GetPolicyInfoForPlayerAsync(LocalPlayer);
    end);
    Profiler.mark("UI.Store.Start.PolicyLoaded");

    if success and result then
        u3 = not result.ArePaidRandomItemsRestricted;
    end;

    if not u3 then
        u1.HidePaidCurrencyPurchaseEntryPoints();
    end;

    for _, child in ipairs(u13.Top.Categories:GetChildren()) do
        if child:IsA("ImageButton") then
            ActivateCategoryButton(child);
            child.MouseButton1Click:Connect(function() -- Line: 3250
                -- upvalues: u1 (ref), child (copy)
                u1.OpenTab(child.Name);
            end);
        end;
    end;

    ActivateButton(u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount);
    u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.MouseButton1Click:Connect(function() -- Line: 3258
        -- upvalues: u13 (ref), Profiler (ref)
        local Container = u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Container;
        Container.Visible = not Container.Visible;

        if not Container.Visible then
            u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Header.ImageLabel.Rotation = 180;

            return;
        end;

        u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Header.ImageLabel.Rotation = 0;
        local Scroll = Container.Scroll;
        Profiler.defer("UI.Store.ScrollToBottomDeferred", function() -- Line: 364
            -- upvalues: Scroll (copy)
            local v439 = math.max(0, Scroll.AbsoluteCanvasSize.Y - Scroll.AbsoluteWindowSize.Y);
            Scroll.CanvasPosition = Vector2.new(Scroll.CanvasPosition.X, v439);
        end);
    end);
    ActivateButton(u13.CaseContent.Odds.Frame.Buttons.Close);
    ActivateButton(u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Odds);
    u13.CaseContent.Odds.Frame.Buttons.Close.MouseButton1Click:Connect(function() -- Line: 3277
        -- upvalues: u13 (ref)
        u13.CaseContent.Odds.Visible = false;
    end);
    u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Odds.MouseButton1Click:Connect(function() -- Line: 3281
        -- upvalues: u13 (ref)
        u13.CaseContent.Odds.Visible = true;
    end);

    for _, child in ipairs(u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Container.Scroll:GetChildren()) do
        if child:IsA("TextButton") then
            child.MouseEnter:Connect(function() -- Line: 3289
                -- upvalues: child (copy)
                if child:GetAttribute("Selected") then
                    return;
                end;

                child.Frame.BackgroundTransparency = 0.5;
            end);
            child.MouseLeave:Connect(function() -- Line: 3296
                -- upvalues: child (copy)
                if child:GetAttribute("Selected") then
                    return;
                end;

                child.Frame.BackgroundTransparency = 1;
            end);
            child.MouseButton1Click:Connect(function() -- Line: 3303
                -- upvalues: u8 (ref), child (copy), u13 (ref)
                local v440 = u8.price * tonumber(child.Name);
                u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Buy.Container.Title.Text = `BUY <font color="#ffda0f">({tostring(v440):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")})</font>`;
                u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Header.TextLabel.Text = tostring(child.Name);
                u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Container.Visible = false;

                for _, child2 in ipairs(u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Container.Scroll:GetChildren()) do
                    if child2:IsA("TextButton") then
                        child2.Frame.BackgroundTransparency = child2 == child and 0 or 1;
                        child2:SetAttribute("Selected", child2 == child);
                    end;
                end;
            end);
        end;
    end;

    u13.Gift.Amount.MouseButton1Click:Connect(function() -- Line: 3320
        -- upvalues: u13 (ref), Profiler (ref)
        local Container = u13.Gift.Amount.Container;
        Container.Visible = not Container.Visible;

        if not Container.Visible then
            u13.Gift.Amount.Header.ImageLabel.Rotation = 180;

            return;
        end;

        u13.Gift.Amount.Header.ImageLabel.Rotation = 0;
        Profiler.defer("UI.Store.ScrollToBottomDeferred", function() -- Line: 364
            -- upvalues: Container (copy)
            local v441 = math.max(0, Container.AbsoluteCanvasSize.Y - Container.AbsoluteWindowSize.Y);
            Container.CanvasPosition = Vector2.new(Container.CanvasPosition.X, v441);
        end);
    end);

    for _, child in ipairs(u13.Gift.Amount.Container:GetChildren()) do
        if child:IsA("TextButton") then
            child.MouseEnter:Connect(function() -- Line: 3339
                -- upvalues: child (copy)
                if not child:GetAttribute("Selected") then
                    child.Frame.BackgroundTransparency = 0.5;
                end;
            end);
            child.MouseLeave:Connect(function() -- Line: 3345
                -- upvalues: child (copy)
                if not child:GetAttribute("Selected") then
                    child.Frame.BackgroundTransparency = 1;
                end;
            end);
            child.MouseButton1Click:Connect(function() -- Line: 3351
                -- upvalues: u13 (ref), child (copy)
                u13.Gift.Amount.Header.TextLabel.Text = tostring(child.Name);
                u13.Gift.Amount.Container.Visible = false;

                for _, child2 in ipairs(u13.Gift.Amount.Container:GetChildren()) do
                    if child2:IsA("TextButton") then
                        child2.Frame.BackgroundTransparency = child2 == child and 0 or 1;
                        child2:SetAttribute("Selected", child2 == child);
                    end;
                end;
            end);
        end;
    end;

    DataController.CreateListener(LocalPlayer, "Statistics.OpenShopTime", function(p442) -- Line: 3365
        -- upvalues: u18 (ref), RefreshStarterPackState (ref)
        local v443 = nil;

        if typeof(p442) == "number" then
            v443 = p442;
        elseif typeof(p442) == "string" then
            v443 = tonumber(p442);
        end;

        local v444;

        if v443 == nil then
            v444 = nil;
        elseif v443 > 10000000000 then
            v444 = math.floor(v443 / 1000);
        else
            v444 = math.floor(v443);
        end;

        if v444 ~= nil then
            u18 = true;
        end;

        RefreshStarterPackState();
    end);
    DataController.CreateListener(LocalPlayer, "Gamepasses", function() -- Line: 3372
        -- upvalues: RefreshStarterPackState (ref)
        RefreshStarterPackState();
    end);
    MenuState.OnScreenChanged:Connect(function(p445, p446) -- Line: 3376
        -- upvalues: HandleStoreOpened (ref)
        if p446 == "Store" then
            HandleStoreOpened();
        end;
    end);

    if MenuState.GetCurrentScreen() == "Store" then
        HandleStoreOpened();
    else
        RefreshStarterPackState();
    end;

    DataController.CreateListener(LocalPlayer, "Credits", function(p447) -- Line: 3389
        -- upvalues: u2 (ref)
        u2:setGoal(p447);
    end);
    local TextLabel = u13.Top.Currency:FindFirstChild("TradeTokens"):FindFirstChild("TextLabel");
    DataController.CreateListener(LocalPlayer, "TradeTokens", function(p448) -- Line: 3397
        -- upvalues: TextLabel (copy)
        local v449 = tonumber(p448) or 0;
        local v450 = math.floor(v449);
        TextLabel.Text = tostring(v450):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
    end);
    task.defer(function() -- Line: 3403
        -- upvalues: u13 (ref), DataController (ref), LocalPlayer (ref), Constants (ref)
        local Credits = u13.Tabs.Container.Featured.Scroll:WaitForChild("Credits");
        local u451 = Credits:FindFirstChild("+ 67,500 Credits");

        if not u451 then
            return;
        end;

        local Size = Credits.Size;
        local u452 = UDim2.new(Size.X.Scale, Size.X.Offset, Size.Y.Scale * 0.738575, Size.Y.Offset * 0.738575);

        local function SetMintReserveVisible(p453) -- Line: 3418
            -- upvalues: Credits (copy), Size (copy), u452 (copy), u451 (copy)
            local v454;

            if p453 then
                v454 = Size;
            else
                v454 = u452;
            end;

            Credits.Size = v454;
            u451.Visible = p453;
        end;

        Credits.Size = u452;
        u451.Visible = false;
        DataController.CreateListener(LocalPlayer, "Statistics.RobuxSpent", function(p455) -- Line: 3424
            -- upvalues: Constants (ref), Credits (copy), Size (copy), u452 (copy), u451 (copy)
            local v456 = (tonumber(p455) or 0) >= Constants.MINIMUM_CREDITS_FOR_SPECIAL_CREDITS_OPTION;
            local v457;

            if v456 then
                v457 = Size;
            else
                v457 = u452;
            end;

            Credits.Size = v457;
            u451.Visible = v456;
        end);
    end);
    Cases.ObserveAvailableCases(function(p458) -- Line: 3431
        -- upvalues: u1 (ref), u8 (ref), u13 (ref), UpdateCasePurchaseButtons (ref)
        u1.UpdateCases();

        if u8 and u13.CaseContent.Visible then
            UpdateCasePurchaseButtons(u8);
        end;
    end);
    Remotes.UI.UpdateCreatorCode.Listen(function(p459) -- Line: 3440
        -- upvalues: u13 (ref), UpdateCreatorCodeResponse (ref), u1 (ref)
        u13.CreatorCode.Container.Action.Confirm.Title.Text = "CONFIRM";
        UpdateCreatorCodeResponse(p459.Type, p459.Text);

        if p459.Type == "Success" and u13.CreatorCode.Visible then
            task.delay(1, function() -- Line: 3445
                -- upvalues: u13 (ref), u1 (ref)
                if u13.CreatorCode.Visible then
                    u1.CloseCreatorCode();
                end;
            end);
        end;
    end);
    Remotes.Store.CaseOpened.Listen(function(p460) -- Line: 3454
        -- upvalues: Profiler (ref), DataController (ref), LocalPlayer (ref), u26 (ref), u24 (ref), u27 (ref), TryProcessResolvedCaseOpenQueue (ref)
        Profiler.mark("UI.Store.CaseOpenedRemote");

        if p460.InventoryItems and #p460.InventoryItems > 0 then
            DataController.ApplyInventoryDelta(LocalPlayer, p460.InventoryItems, p460.DeletedCaseIds);
        end;

        local v461;

        if typeof(p460.RequestId) == "string" then
            v461 = p460.RequestId;
        else
            v461 = nil;
        end;

        local v462;

        if v461 then
            v462 = u26[v461];

            if v462 then
                if v461 and u24.pendingOpenRequestId == v461 then
                    u24.isPendingOpenRequest = false;
                    u24.pendingOpenRequestId = nil;
                    u24.isQuickUnlock = false;
                end;

                u26[v461] = nil;
            else
                v462 = nil;
            end;
        else
            v462 = nil;
        end;

        if v461 and not v462 then
            return;
        end;

        table.insert(u27, {
            CaseId = p460.CaseId,
            InventoryItems = p460.InventoryItems,
            CaseIdentifier = p460.CaseIdentifier,
            IsQuickUnlock = v462 and v462.IsQuickUnlock or false,
            RequestId = v461
        });
        Profiler.defer("UI.Store.ResolvedQueueDeferred", TryProcessResolvedCaseOpenQueue);
    end);
    Remotes.Store.CaseOpenDenied.Listen(function(p463) -- Line: 3476
        -- upvalues: u24 (ref), u26 (ref)
        local v464;

        if p463 and typeof(p463.RequestId) == "string" then
            v464 = p463.RequestId;
        else
            v464 = nil;
        end;

        if not v464 then
            return;
        end;

        if u24.pendingOpenRequestId == v464 then
            u24.isPendingOpenRequest = false;
            u24.pendingOpenRequestId = nil;
            u24.isQuickUnlock = false;
        end;

        u26[v464] = nil;
    end);
    MenuState.OnInspectStateChanged:Connect(function(p465) -- Line: 3482
        -- upvalues: Profiler (ref), TryProcessResolvedCaseOpenQueue (ref), MenuState (ref), u13 (ref), CaseSceneController (ref), u8 (ref), u14 (ref)
        if not p465 then
            Profiler.defer("UI.Store.InspectClosedDeferred", function() -- Line: 3484
                -- upvalues: TryProcessResolvedCaseOpenQueue (ref), MenuState (ref), u13 (ref), CaseSceneController (ref), u8 (ref), u14 (ref)
                if TryProcessResolvedCaseOpenQueue() then
                    return;
                end;

                local v466 = MenuState.GetCurrentScreen();
                local v467 = u13.CaseContent:GetAttribute("WasVisibleBeforeInspect") == true;
                local v468 = CaseSceneController.IsActive();

                if u8 and (v466 == "Store" and (v467 and v468)) then
                    u13.Visible = true;
                    u13.Tabs.Container.Visible = false;
                    u13.CaseContent.Visible = true;
                    u14.Menu.Top.Visible = false;
                    u13.Top.Visible = false;
                    MenuState.SetBlurEnabled(false);
                    local v469 = MenuState.GetMenuFrame();

                    if v469 then
                        v469.BackgroundTransparency = 1;
                    end;
                elseif u13.CaseContent.Visible and v466 == "Inventory" then
                    u13.Visible = true;
                    u13.Tabs.Container.Visible = false;
                    u13.CaseContent.Visible = true;
                    u14.Menu.Top.Visible = false;
                    u13.Top.Visible = false;
                    local Inventory = u14.Menu:FindFirstChild("Inventory");

                    if Inventory then
                        Inventory.Visible = false;
                    end;

                    MenuState.SetBlurEnabled(false);
                    local v470 = MenuState.GetMenuFrame();

                    if v470 then
                        v470.BackgroundTransparency = 1;
                    end;

                    if not CaseSceneController.IsActive() and u8 then
                        CaseSceneController.ShowCaseScene(u8.caseId);
                    end;
                end;
            end);
        end;
    end);
    Observers.observePlayer(function(p471) -- Line: 3532
        -- upvalues: LocalPlayer (ref), ReplicatedStorage (ref), u13 (ref), u1 (ref)
        if LocalPlayer == p471 then
            return function() -- Line: 3534
            end;
        end;

        local u472 = ReplicatedStorage.Assets.UI.Store.PlayerTemplate:Clone();
        u472.Player.Avatar.Image = `rbxthumb://type=AvatarHeadShot&id={p471.UserId}&w=420&h=420`;
        u472.Player.Username.Text = `@{p471.Name}`;
        u472.Parent = u13.Gift.Container;
        u472.Name = tostring(p471.UserId);
        u1.ActivateGiftTemplate(u472, p471.UserId);

        return function() -- Line: 3544
            -- upvalues: u472 (copy)
            if u472 then
                u472:Destroy();
            end;
        end;
    end);
end;

return u1;