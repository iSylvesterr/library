-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Assets = ReplicatedStorage:WaitForChild("Assets");
local RunService = game:GetService("RunService");
local FuncWrapper = require(ReplicatedStorage.Library.Modules.FuncWrapper);
local AbstractItem = require(ReplicatedStorage.Library.Items.AbstractItem);
local ItemUI = require(ReplicatedStorage.Library.Client.UI.ItemUI);
local ItemContainerUI = require(ReplicatedStorage.Library.Client.UI.ItemContainerUI);
local Types = require(ReplicatedStorage.Library.Items.Types).Types;
local TradingCmds = require(ReplicatedStorage.Library.Client.TradingCmds);
local CurrencyCmds = require(ReplicatedStorage.Library.Client.CurrencyCmds);
local GUI = require(ReplicatedStorage.Library.Client.GUI);
local Functions = require(ReplicatedStorage.Library.Functions);
local Message = require(ReplicatedStorage.Library.Client.Message);
local Audio = require(ReplicatedStorage.Library.Audio);
local Variables = require(ReplicatedStorage.Library.Variables);
local ButtonFX = require(ReplicatedStorage.Library.Client.GUIFX.ButtonFX);
local FlashText = require(ReplicatedStorage.Library.Client.GUIFX.FlashText);
local Tooltip = require(ReplicatedStorage.Library.Client.GUIFX.Tooltip);
local InfoOverlay = require(ReplicatedStorage.Library.Client.InfoOverlay);
local TabController = require(ReplicatedStorage.Library.Client.TabController);
local ScreenResolution = require(ReplicatedStorage.Library.Client.ScreenResolution);
local Trading = require(ReplicatedStorage.Library.Types.Trading);
local Notifications = require(script.Notifications);
local u1 = require(ReplicatedStorage.Library.Modules.Packages.Log).new();
require(script.PlayerList);
local LocalPlayer = game.Players.LocalPlayer;
local u2 = GUI.TradeWindow();
local Frame = u2:WaitForChild("Frame");
local Buttons = Frame.Buttons;
local ChatOverlay = Frame.ChatOverlay;
local ClientDiamonds = Frame.ClientDiamonds;
local Input = ClientDiamonds.Diamonds.Input;
local ClientItems = Frame.ClientItems;
local TextLabel = Frame.PlayerDiamonds.TextLabel;
local PlayerItems = Frame.PlayerItems;
local Tabs = Frame.Tabs;
local u3 = Frame:WaitForChild("shadow-toolbar");
local PlayerRAPHolder = Frame.PlayerRAPHolder;
local ClientRAPHolder = Frame.ClientRAPHolder;
local Filters = ClientItems.Filters;
local Confirmed = Filters.Confirmed;
local Confirmed2 = PlayerItems.Confirmed;
local Status = ClientItems.Status;
local Status2 = PlayerItems.Status;
local ChatButton = Frame.ChatButton;
local Cancel = Buttons.CancelHolder.Cancel;
local Ready = Buttons.ReadyHolder.Ready;
local Footer = ChatOverlay.Footer;
local Input2 = Footer.Message.Input;
local Send = Footer.Send;
local Notification = ChatButton.Notification;
local ClientBar = ClientItems.ClientBar;
local GridMode = ClientBar.Container.GridMode;
local Input3 = ClientBar.Search.Input;
local ClientTitle = Frame.ClientTitle;
local ClientIcon = Frame.ClientIcon;
local PlayerTitle = Frame.PlayerTitle;
local PlayerIcon = Frame.PlayerIcon;
local Notice = Frame.Notice;
local GreenGradient = Assets.UI.Gradients.GreenGradient;
local RedGradient = Assets.UI.Gradients.RedGradient;
local GreyGradient = Assets.UI.Gradients.GreyGradient;
local BlueGradient = Assets.UI.Gradients.BlueGradient;
local u4 = Color3.new(0, 0, 0);
local u5 = Color3.new(1, 1, 1);
local u6 = Color3.fromRGB(64, 252, 59);
local u7 = table.clone(Trading.InventoryItemTypes);
local u8 = assert(u7[1], "Missing default category in trading categories");
local u9 = {};
u9.__index = u9;
u9.__class = "Trading";

local function getTradeItemKey(p10) -- Line: 137
    if p10:IsA("Brainrot") then
        return p10:GetUID();
    end;

    return p10:GetId();
end;

function u9._build() -- Line: 149
    -- upvalues: u9 (copy), FuncWrapper (copy), u8 (copy)
    local v11 = setmetatable({}, u9);
    v11._funcWrapper = FuncWrapper.CreateWrapper(v11);
    v11._isGridView = false;
    v11._userState = nil;
    v11._isModificationLocked = false;
    v11._lastDiamondValue = 0;
    v11._categoryGroup = u8;
    v11._currentRenderSelectedItems = {};
    v11._currentItems = {};
    v11._clientItemContainer = nil;
    v11._playerItemContainer = nil;
    v11._lastMessageTime = nil;
    v11._confirmTimestamp = nil;
    v11._closeTradeListeners = {};
    v11:_init();

    return v11;
end;

function u9.RemoveTradeNotif(p12) -- Line: 178
    -- upvalues: Notifications (copy)
    Notifications:Remove();
end;

function u9.HasTradeNotif(p13) -- Line: 182
    -- upvalues: Notifications (copy)
    return Notifications:HasTradeNotif();
end;

function u9._getResolution(p14) -- Line: 186
    return p14._isGridView and {
        {
            ResolutionThreshold = 0.65,
            PerRow = 6,
            Padding = UDim2.fromOffset(4, 8)
        },
        {
            ResolutionThreshold = 1.2,
            PerRow = 8,
            Padding = UDim2.fromOffset(5, 7.5)
        },
        {
            ResolutionThreshold = (1 / 0),
            PerRow = 8,
            Padding = UDim2.fromOffset(7.5, 10)
        }
    } or {
        {
            ResolutionThreshold = 0.65,
            PerRow = 4,
            Padding = UDim2.fromOffset(5, 10)
        },
        {
            ResolutionThreshold = 1.2,
            PerRow = 4,
            Padding = UDim2.fromOffset(10, 15)
        },
        {
            ResolutionThreshold = (1 / 0),
            PerRow = 4,
            Padding = UDim2.fromOffset(15, 20)
        }
    };
end;

function u9._diamondChangedSFX(p15, p16, p17, p18) -- Line: 224
    -- upvalues: Audio (copy), FlashText (copy)
    if tostring(p17) == tostring(p18) then
        return;
    end;

    Audio.Play("rbxassetid://123259573996522", script, nil, 1);
    FlashText(p16);
end;

function u9._setSelectionEnabled(p19, p20) -- Line: 234
    if not p19._userState then
        return;
    end;

    for _, v in pairs(p19._userState.containers) do
        v:SetSelectionEnabled(p20);
    end;
end;

function u9._populateCategoryItems(p21, p22) -- Line: 245
    -- upvalues: Types (copy)
    local v23 = Types[p22];
    local v24 = "ItemType not found for category: " .. tostring(p22);
    local v25 = assert(v23, v24);

    return table.clone(v25:All());
end;

function u9._refreshTabAvailability(p26) -- Line: 250
    -- upvalues: Tabs (copy)
    if not p26._userState then
        return;
    end;

    for _, child in ipairs(Tabs:GetChildren()) do
        if child:IsA("GuiButton") then
            local v27 = p26._userState.population[child.Name];

            if v27 then
                v27 = next(v27) ~= nil;
            end;

            child.Icon.ImageColor3 = v27 and Color3.new(1, 1, 1) or Color3.new(0, 0, 0);
            child.Icon.ImageTransparency = v27 and 0 or 0.8;
            child.Icon.Icon.Visible = false;
        end;
    end;
end;

function u9._refreshCategory(p28, p29) -- Line: 266
    if not p28._userState then
        return;
    end;

    local v30 = p28:_populateCategoryItems(p29);
    p28._userState.population[p29] = v30;
    local v31 = p28._userState.containers[p29];

    if v31 then
        v31:Populate(v30);
        p28:_syncCategorySelectionFromTradeState(p29);
    end;

    p28:_refreshTabAvailability();
end;

function u9._syncLocalSelectionFromTradeState(p32, p33, p34) -- Line: 283
    -- upvalues: TradingCmds (copy), LocalPlayer (copy)
    local v35 = TradingCmds.GetState();

    if not (v35 and p32._userState) then
        return;
    end;

    local v36 = v35:PlayerIndex(LocalPlayer);

    if not v36 then
        return;
    end;

    local v37 = p32._userState.containers[p33];

    if not v37 then
        return;
    end;

    local v38 = v35._items[v36][p33];

    if v38 then
        v38 = v38[p34];
    end;

    v37:SetSelectionAmount(p34, not v38 and 0 or v38:GetAmount());
end;

function u9._syncCategorySelectionFromTradeState(p39, p40) -- Line: 307
    -- upvalues: TradingCmds (copy), LocalPlayer (copy)
    if not p39._userState then
        return;
    end;

    local v41 = TradingCmds.GetState();

    if not v41 then
        return;
    end;

    local v42 = v41:PlayerIndex(LocalPlayer);

    if not v42 then
        return;
    end;

    local v43 = p39._userState.containers[p40];

    if not v43 then
        return;
    end;

    v43:ClearSelection();
    local v44 = v41._items[v42][p40];

    if not v44 then
        return;
    end;

    for i, v in pairs(v44) do
        if v then
            v43:SetSelectionAmount(i, v:GetAmount());
        end;
    end;
end;

function u9._getAllSelected(p45, p46) -- Line: 344
    local v47 = {};

    for _, v in pairs(p46) do
        for i, v2 in pairs(v) do
            if not v2:IsA("Currency") then
                v47[i] = v2;
            end;
        end;
    end;

    return v47;
end;

function u9._isChatting(p48) -- Line: 356
    -- upvalues: ChatOverlay (copy)
    return ChatOverlay.Visible;
end;

function u9._incrementChatNotification(p49) -- Line: 360
    -- upvalues: Notification (copy)
    if p49:_isChatting() then
        return;
    end;

    local v50 = tonumber(Notification.Count.Text) or 0;
    assert(v50, "Chat notification count must be a valid number");
    Notification.Count.Text = v50 + 1;
    Notification.Visible = true;
end;

function u9._getOtherDiamonds(p51) -- Line: 372
    -- upvalues: Functions (copy)
    local Currency = p51._currentItems.Currency;

    if not Currency then
        return 0;
    end;

    if Functions.DictionaryLength(Currency) == 0 then
        return 0;
    end;

    local _, v52 = next(Currency);

    return not v52 and 0 or v52:GetAmount();
end;

function u9._setDiamondAmount(u53) -- Line: 388
    -- upvalues: Functions (copy), Input (copy), CurrencyCmds (copy), TradingCmds (copy), Audio (copy)
    local v54 = Functions.ParseNumberSmart(Input.Text);

    if not CurrencyCmds.GetItem("Coins") then
        u53:_diamondChangedSFX(Input, "0", u53._lastDiamondValue);
        Input.Text = "0";
        u53._lastDiamondValue = 0;
        TradingCmds.SetCurrency("Coins", 0);

        return;
    end;

    local function reset() -- Line: 397
        -- upvalues: u53 (copy), Input (ref), TradingCmds (ref)
        u53:_diamondChangedSFX(Input, "0", u53._lastDiamondValue);
        Input.Text = "0";
        u53._lastDiamondValue = 0;
        TradingCmds.SetCurrency("Coins", 0);
    end;

    if not v54 then
        u53:_diamondChangedSFX(Input, "0", u53._lastDiamondValue);
        Input.Text = "0";
        u53._lastDiamondValue = 0;
        TradingCmds.SetCurrency("Coins", 0);

        return;
    end;

    local v55 = math.round(v54);

    if v55 <= 0 then
        u53:_diamondChangedSFX(Input, "0", u53._lastDiamondValue);
        Input.Text = "0";
        u53._lastDiamondValue = 0;
        TradingCmds.SetCurrency("Coins", 0);

        return;
    end;

    if not CurrencyCmds.CanAfford("Coins", v55) then
        v55 = CurrencyCmds.Get("Coins");
    end;

    Audio.Play("rbxassetid://123259573996522", script, nil, 1);
    Input.Text = Functions.Commas(v55);
    u53:_diamondChangedSFX(Input, v55, u53._lastDiamondValue);
    u53._lastDiamondValue = v55;
    TradingCmds.SetCurrency("Coins", v55);
end;

function u9._sendChatMessage(p56) -- Line: 429
    -- upvalues: TradingCmds (copy), Input2 (copy), Functions (copy), Send (copy), GreyGradient (copy), Trading (copy), BlueGradient (copy), Message (copy)
    local v57 = TradingCmds.GetState();
    local Text = Input2.Text;

    if not v57 or (not p56._userState or Text == "") then
        return;
    end;

    Input2.Text = "";
    p56._lastMessageTime = workspace:GetServerTimeNow();
    Functions.GradientSwap(Send, GreyGradient);
    task.delay(Trading.ClientMessageDebounce, function() -- Line: 438
        -- upvalues: Functions (ref), Send (ref), BlueGradient (ref)
        Functions.GradientSwap(Send, BlueGradient);
    end);
    local v58, v59 = TradingCmds.Message(Text);

    if not v58 and v59 then
        Message.New(v59, {
            err = true,
            tradeAllowed = true
        });
    end;
end;

function u9._updateMessageScroll(p60) -- Line: 453
    -- upvalues: ChatOverlay (copy)
    local Messages = ChatOverlay.Messages;
    local v61 = Messages:FindFirstChildOfClass("UIListLayout");
    Messages.CanvasSize = UDim2.fromOffset(v61.AbsoluteContentSize.X, v61.AbsoluteContentSize.Y + 50);
end;

function u9._receivedMessage(p62, u63, p64) -- Line: 461
    -- upvalues: LocalPlayer (copy), Assets (copy), ChatOverlay (copy), Functions (copy), Audio (copy)
    local v65 = u63 == LocalPlayer;
    local v66 = v65 and Assets.UI.Trading.Chat.ClientLine:Clone() or Assets.UI.Trading.Chat.PlayerLine:Clone();
    local ImageLabel = v66:FindFirstChild("ImageLabel");
    task.defer(function() -- Line: 466
        -- upvalues: ChatOverlay (ref)
        ChatOverlay.Messages.CanvasPosition = ChatOverlay.Messages.AbsoluteCanvasSize;
    end);

    if not v65 then
        if ImageLabel then
            ImageLabel.Image = "";
            task.spawn(function() -- Line: 473
                -- upvalues: ImageLabel (copy), Functions (ref), u63 (copy)
                ImageLabel.Image = Functions.GetThumbnailFromUserIdAsync(u63.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size180x180) or "";
            end);
        end;

        if not p62:_isChatting() then
            p62:_incrementChatNotification();
        end;
    end;

    v66:FindFirstChildOfClass("Frame"):FindFirstChild("Label").Text = p64;
    v66.Parent = ChatOverlay.Messages;
    Audio.Play(v65 and "rbxassetid://130425178156489" or "rbxassetid://93792051643626", script, 1, 1);
    p62:_updateMessageScroll();
end;

function u9._getReadyStatus(p67) -- Line: 498
    -- upvalues: TradingCmds (copy), LocalPlayer (copy)
    local v68 = TradingCmds.GetState();

    if not v68 then
        return;
    end;

    local v69 = v68:PlayerIndex(LocalPlayer);

    if v69 then
        return v68._ready[v69], v68._ready[v68:Index2(v69)];
    end;
end;

function u9._renderGroup(p70, p71) -- Line: 512
    -- upvalues: Filters (copy), Input3 (copy), ItemContainerUI (copy), ItemUI (copy), Trading (copy), AbstractItem (copy), Message (copy), TradingCmds (copy)
    if not p70._userState then
        return;
    end;

    if p70:_getReadyStatus() then
        return;
    end;

    local v72 = Filters:FindFirstChild(p71);
    local v73 = "Filter group not found for category: " .. tostring(p71);
    assert(v72, v73);
    Input3.Text = "";

    for _, child in ipairs(Filters:GetChildren()) do
        if child:IsA("GuiObject") then
            child.Visible = child.Name == p71;
        end;
    end;

    if p70._userState.containers[p71] then
        return;
    end;

    for _, child in pairs(v72:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy();
        end;
    end;

    local u80 = ItemContainerUI.new(v72, {
        LoadSpeed = 40,

        Permitted = function(p74) -- Line: 535, Name: Permitted
            return p74:IsTradable();
        end,

        Creator = function(p75) -- Line: 538, Name: Creator
            -- upvalues: ItemUI (ref)
            return ItemUI.Create(p75, {
                NoActionMenu = true,
                HideQuantity = p75:GetAmount() == 1
            });
        end,

        SelectionPermitted = function(p76) -- Line: 545, Name: SelectionPermitted
            return p76:IsTradable();
        end,

        Comparator = function(p77, p78) -- Line: 548, Name: Comparator
            -- upvalues: ItemContainerUI (ref)
            local v79 = p77:IsTradable();

            if v79 == p78:IsTradable() then
                return ItemContainerUI.Comparators.Default(p77, p78);
            end;

            return v79;
        end,

        ResolutionSettings = p70:_getResolution(),
        SelectionMode = ItemContainerUI.SelectionMode.UNLIMITED,
        QuantityMode = ItemContainerUI.QuantityMode.NORMAL,
        EventMode = ItemContainerUI.EventMode.ON_RELEASE,
        MaxSelectedStacks = Trading.ItemLimit,
        SearchBar = Input3
    });
    local v81 = "Failed to create item container for category: " .. tostring(p71);
    assert(u80, v81);

    if p70._userState.population[p71] then
        u80:Populate(p70._userState.population[p71]);
        p70:_syncCategorySelectionFromTradeState(p71);
        u80:AddItemListener(function(p82, p83, p84) -- Line: 568
            -- upvalues: AbstractItem (ref), Message (ref), TradingCmds (ref), u80 (copy)
            local v85 = AbstractItem:Get(p82);

            if not v85 then
                Message.New("Failed to add item to trade!", {
                    tradeAllowed = true
                });

                return;
            end;

            local SetItem = TradingCmds.SetItem;
            local Name = v85.Class.Name;
            local v86;

            if v85:IsA("Brainrot") then
                v86 = v85:GetUID();
            else
                v86 = v85:GetId();
            end;

            local v87, u88 = SetItem(Name, v86, p83);

            if not v87 then
                u80:SetSelectionAmount(p82, p84);
                task.spawn(function() -- Line: 580
                    -- upvalues: Message (ref), u88 (copy)
                    Message.New(u88 or "Failed to add item to trade!", {
                        tradeAllowed = true
                    });
                end);
            end;
        end);
    end;

    p70._userState.containers[p71] = u80;
    p70._categoryGroup = p71;
end;

function u9._unRenderSelectedItems(p89) -- Line: 598
    -- upvalues: Filters (copy)
    if p89._clientItemContainer then
        p89._clientItemContainer:Destroy();
        p89._clientItemContainer = nil;
    end;

    Filters.Items.Visible = false;
end;

function u9._renderSelectedItems(p90, p91) -- Line: 607
    -- upvalues: Filters (copy), PlayerItems (copy), ItemContainerUI (copy), ItemUI (copy)
    local v92 = p91 and p90._currentRenderSelectedItems or p90._currentItems;
    local v93 = p91 and Filters.Items or PlayerItems.Items;

    if p91 then
        v93.Visible = true;
    end;

    local v96 = {
        LoadSpeed = 40,
        Comparator = ItemContainerUI.Comparators.Default,

        Permitted = function(p94) -- Line: 615, Name: Permitted
            return p94:IsTradable();
        end,

        Creator = function(p95) -- Line: 618, Name: Creator
            -- upvalues: ItemUI (ref)
            return ItemUI.Create(p95, {
                NoActionMenu = true,
                NoButtonFX = true,
                HideQuantity = p95:GetAmount() == 1
            });
        end,

        ResolutionSettings = p90:_getResolution(),
        SelectionMode = ItemContainerUI.SelectionMode.DISABLED
    };

    if p91 then
        if not p90._clientItemContainer then
            p90._clientItemContainer = ItemContainerUI.new(v93, v96);
        end;

        assert(p90._clientItemContainer, "Client item container could not be created");
        p90._clientItemContainer:Populate(p90:_getAllSelected(v92));

        return;
    end;

    if not p90._playerItemContainer then
        p90._playerItemContainer = ItemContainerUI.new(v93, v96);
    end;

    assert(p90._playerItemContainer, "Player item container could not be created");
    p90._playerItemContainer:Populate(p90:_getAllSelected(v92));
end;

function u9._unRenderContainers(p97) -- Line: 646
    -- upvalues: Filters (copy)
    for _, child in ipairs(Filters:GetChildren()) do
        if child:IsA("GuiObject") and child.Name ~= "Items" then
            child.Visible = false;
        end;
    end;
end;

function u9._clientReady(p98) -- Line: 655
    p98:_unRenderContainers();
    p98:_renderSelectedItems(true);
end;

function u9._clientUnready(p99) -- Line: 661
    -- upvalues: u8 (copy)
    p99:_unRenderSelectedItems();
    p99:_renderGroup(p99._categoryGroup or u8);
end;

function u9._clearTabNotifications(p100) -- Line: 667
    -- upvalues: Tabs (copy)
    for _, child in ipairs(Tabs:GetChildren()) do
        if child:IsA("GuiObject") then
            local TopRight = child:FindFirstChild("TopRight");

            if TopRight then
                TopRight.Visible = false;
            end;
        end;
    end;
end;

function u9._setupMaxSelections(p101) -- Line: 679
    -- upvalues: Trading (copy)
    if p101._userState then
        local ItemLimit = Trading.ItemLimit;
        local v102 = 0;

        for _, v in pairs(p101._userState.containers) do
            v102 = v102 + v:GetStackCount();
        end;

        for _, v in pairs(p101._userState.containers) do
            v:SetMaximumSelectedStacks(ItemLimit - v102 + v:GetStackCount());
        end;
    end;
end;

function u9._renderTabNotifications(p103) -- Line: 693
    -- upvalues: Tabs (copy)
    if p103._userState then
        for _, child in ipairs(Tabs:GetChildren()) do
            if child:IsA("GuiObject") then
                local v104 = p103._userState.containers[child.Name];

                if v104 then
                    local TopRight = child:FindFirstChild("TopRight");

                    if TopRight then
                        local Amount = TopRight:FindFirstChild("Frame"):FindFirstChild("Amount");
                        local v105 = v104:GetSelectionCount();

                        if v105 <= 0 then
                            TopRight.Visible = false;
                        else
                            TopRight.Visible = true;
                            Amount.Text = tostring(v105);
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

function u9._getConfirmedStatus(p106) -- Line: 717
    -- upvalues: TradingCmds (copy), LocalPlayer (copy)
    local v107 = TradingCmds.GetState();

    if not v107 then
        return;
    end;

    local v108 = v107:PlayerIndex(LocalPlayer);

    if v108 then
        return v107._confirmed[v108], v107._confirmed[v107:Index2(v108)];
    end;
end;

function u9._update(p109) -- Line: 731
    -- upvalues: TradingCmds (copy), Status (copy), Status2 (copy), ClientItems (copy), u6 (copy), u4 (copy), PlayerItems (copy), ClientTitle (copy), u5 (copy), PlayerTitle (copy), Input (copy), Confirmed (copy), Confirmed2 (copy), ClientIcon (copy), PlayerIcon (copy), Tabs (copy), u3 (copy), GridMode (copy), TextLabel (copy), Functions (copy), Input3 (copy), ClientBar (copy), Notice (copy), Audio (copy), Trading (copy), Ready (copy), GreyGradient (copy), RedGradient (copy), GreenGradient (copy)
    local v110 = TradingCmds.GetState();

    if not v110 then
        return;
    end;

    local v111, v112 = p109:_getReadyStatus();
    local v113 = v111 and v112;
    local v114, v115 = p109:_getConfirmedStatus();
    local v116;

    if v111 then
        v116 = not v113 or v114;
    else
        v116 = v114;
    end;

    local v117;

    if v112 then
        v117 = not v113 or v115;
    else
        v117 = v115;
    end;

    Status.Visible = v116;
    Status2.Visible = v117;
    Status.Text = v114 and "Confirmed!" or "Ready!";
    Status2.Text = v115 and "Confirmed!" or "Ready!";
    ClientItems.UIStroke.Color = v116 and u6 or u4;
    PlayerItems.UIStroke.Color = v117 and u6 or u4;
    ClientTitle.TextColor3 = v116 and u6 or u5;
    PlayerTitle.TextColor3 = v117 and u6 or u5;
    Input.Parent.Parent.BackgroundColor3 = v116 and u6 or u4;
    Input.Parent.Parent.UIStroke.Color = v116 and u6 or u4;
    local v118 = not p109:_isChatting() and not v111;
    Input.TextEditable = v118;
    local v119 = not p109:_isChatting() and not v111;
    Input.ClearTextOnFocus = v119;
    Confirmed.Visible = v114;
    Confirmed2.Visible = v115;
    ClientIcon.Visible = not p109:_isChatting();
    PlayerIcon.Visible = not p109:_isChatting();
    ClientTitle.Visible = not p109:_isChatting();
    PlayerTitle.Visible = not p109:_isChatting();
    local v120 = not v111 and not p109:_isChatting();
    Tabs.Visible = v120;
    local v121 = not v111 and not p109:_isChatting();
    u3.Visible = v121;
    GridMode.ImageColor3 = p109._isGridView and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(42, 43, 49);
    local v122 = p109:_getOtherDiamonds();
    p109:_diamondChangedSFX(TextLabel, Functions.Commas(v122), TextLabel.Text);
    TextLabel.Text = Functions.Commas(v122);
    Input3.TextEditable = not p109:_isChatting();
    ClientBar.Visible = not v111;

    if v110._readyTimer then
        if v110._confirmedTimer then
            local v123 = v110._confirmedTimer - workspace:GetServerTimeNow();
            local v124 = (math.floor(v123 * 10) / 10 + 0.1) * 10 + 0.5;
            local v125 = math.floor(v124) / 10;

            if v123 <= 0 then
                p109._confirmTimestamp = nil;
                Notice.Text = "⌛ Trade confirming...";
            else
                if p109._confirmTimestamp and p109._confirmTimestamp ~= math.floor(v125) then
                    Audio.Play("rbxassetid://132281384049192", script, nil, 1);
                end;

                p109._confirmTimestamp = math.floor(v125);
                Notice.Text = "⌛ " .. v125 .. " seconds left...";
            end;
        else
            Notice.Text = "Countdown starts when both players are Confirmed!";
        end;
    else
        Notice.Text = "";
    end;

    local v126 = Trading.ModificationReadyDuration - (workspace:GetServerTimeNow() - v110._lastModified);

    if v126 > 0 then
        p109._isModificationLocked = true;
        local TextLabel2 = Ready.TextLabel;
        local v127 = (math.floor(v126 * 10) / 10 + 0.1) * 10 + 0.5;
        TextLabel2.Text = "(" .. math.floor(v127) / 10 .. ")";
        Functions.GradientSwap(Ready, GreyGradient);
    else
        p109._isModificationLocked = false;
        Ready.TextLabel.Text = v111 and (v111 and not v113 and "Unready!" or (v113 and not v114 and "Confirm!" or (v113 and v114 and "Unconfirm!" or "Ready!"))) or "Ready!";
        Functions.GradientSwap(Ready, v116 and RedGradient or GreenGradient);
    end;

    p109:_setupMaxSelections();
    p109:_renderTabNotifications();
end;

function u9._closeTrade(p128) -- Line: 823
    -- upvalues: TabController (copy), Variables (copy)
    if not p128._userState then
        return;
    end;

    TabController.SetLockedTab(nil);

    for _, v in ipairs(p128._closeTradeListeners) do
        task.spawn(v);
    end;

    for _, v in pairs(p128._userState.containers) do
        v:Destroy();
    end;

    if p128._clientItemContainer then
        p128._clientItemContainer:Destroy();
        p128._clientItemContainer = nil;
    end;

    if p128._playerItemContainer then
        p128._playerItemContainer:Destroy();
        p128._playerItemContainer = nil;
    end;

    p128._currentRenderSelectedItems = {};
    p128._currentItems = {};
    p128._userState = nil;
    Variables.Trading = false;
end;

function u9._setupTrade(u129, u130) -- Line: 850
    -- upvalues: Variables (copy), TabController (copy), u7 (copy), Tabs (copy), ButtonFX (copy), InfoOverlay (copy), Input (copy), TextLabel (copy), ClientRAPHolder (copy), PlayerRAPHolder (copy), Notification (copy), Input2 (copy), ChatOverlay (copy), Notice (copy), PlayerTitle (copy), PlayerIcon (copy), ClientIcon (copy), Functions (copy), LocalPlayer (copy), u8 (copy), AbstractItem (copy)
    Variables.Trading = true;
    TabController.SetLockedTab("TradeWindow");

    local function populateItems() -- Line: 853
        -- upvalues: u7 (ref), u129 (copy)
        local v131 = {};

        for _, v in ipairs(u7) do
            v131[v] = u129:_populateCategoryItems(v);
        end;

        return v131;
    end;

    u129._userState = {
        populator = populateItems,
        population = populateItems(),
        containers = {}
    };
    assert(u129._userState, "User state could not be properly initialized");

    for _, child in ipairs(Tabs:GetChildren()) do
        if child:IsA("GuiButton") then
            local Name = child.Name;

            if u129._userState.population[Name] and next(u129._userState.population[Name]) then
                local u132 = child.Activated:Connect(function() -- Line: 871, Name: onTabActivated
                    -- upvalues: u129 (copy), child (copy)
                    if u129:_isChatting() then
                        return;
                    end;

                    u129:_renderGroup(child.Name);
                end);
                table.insert(u129._closeTradeListeners, ButtonFX(child));
                table.insert(u129._closeTradeListeners, InfoOverlay.Hook(child, {
                    { "Title", child.Name }
                }));
                table.insert(u129._closeTradeListeners, function() -- Line: 883
                    -- upvalues: u132 (ref)
                    u132:Disconnect();
                end);
            end;

            child.Icon.Icon.Visible = false;
        end;
    end;

    Input.Text = "0";
    TextLabel.Text = "0";
    ClientRAPHolder.Amount.Text = "0";
    PlayerRAPHolder.Amount.Text = "0";
    Notification.Count.Text = "0";
    Notification.Visible = false;
    Input2.Text = "";
    ChatOverlay.Visible = false;
    u129:_setSelectionEnabled(true);

    for _, child in pairs(ChatOverlay.Messages:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy();
        end;
    end;

    u129:_updateMessageScroll();
    Notice.Text = "Countdown starts when both players are Ready!";
    PlayerTitle.Text = u130:GetAttribute("Partner") and u130.Name .. " (🔥 Partner)" or u130.Name;
    PlayerIcon.Image = "";
    ClientIcon.Image = "";
    PlayerIcon.Loading.Visible = true;
    ClientIcon.Loading.Visible = true;
    task.spawn(function() -- Line: 916
        -- upvalues: PlayerIcon (ref), Functions (ref), u130 (copy)
        PlayerIcon.Image = Functions.GetThumbnailFromUserIdAsync(u130.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size180x180) or "";
        PlayerIcon.Loading.Visible = false;
    end);
    task.spawn(function() -- Line: 926
        -- upvalues: ClientIcon (ref), Functions (ref), LocalPlayer (ref)
        ClientIcon.Image = Functions.GetThumbnailFromUserIdAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size180x180) or "";
        ClientIcon.Loading.Visible = false;
    end);
    u129:_clearTabNotifications();
    u129:_refreshTabAvailability();
    u129:_renderGroup(u8);

    local function connectInventoryRefresh(p133) -- Line: 939
        -- upvalues: LocalPlayer (ref), u129 (copy), u7 (ref)
        local u136 = p133:Connect(function(p134, p135) -- Line: 940
            -- upvalues: LocalPlayer (ref), u129 (ref), u7 (ref)
            if p135 ~= LocalPlayer or not u129._userState then
                return;
            end;

            local Name = p134.Class.Name;

            if table.find(u7, Name) == nil then
                return;
            end;

            u129:_refreshCategory(Name);
        end);
        table.insert(u129._closeTradeListeners, function() -- Line: 952
            -- upvalues: u136 (copy)
            u136:Disconnect();
        end);
    end;

    local u139 = AbstractItem.Added:Connect(function(p137, p138) -- Line: 940
        -- upvalues: LocalPlayer (ref), u129 (copy), u7 (ref)
        if p138 ~= LocalPlayer or not u129._userState then
            return;
        end;

        local Name = p137.Class.Name;

        if table.find(u7, Name) == nil then
            return;
        end;

        u129:_refreshCategory(Name);
    end);
    table.insert(u129._closeTradeListeners, function() -- Line: 952
        -- upvalues: u139 (copy)
        u139:Disconnect();
    end);
    local u142 = AbstractItem.Removed:Connect(function(p140, p141) -- Line: 940
        -- upvalues: LocalPlayer (ref), u129 (copy), u7 (ref)
        if p141 ~= LocalPlayer or not u129._userState then
            return;
        end;

        local Name = p140.Class.Name;

        if table.find(u7, Name) == nil then
            return;
        end;

        u129:_refreshCategory(Name);
    end);
    table.insert(u129._closeTradeListeners, function() -- Line: 952
        -- upvalues: u142 (copy)
        u142:Disconnect();
    end);
    local u145 = AbstractItem.Tracked:Connect(function(p143, p144) -- Line: 940
        -- upvalues: LocalPlayer (ref), u129 (copy), u7 (ref)
        if p144 ~= LocalPlayer or not u129._userState then
            return;
        end;

        local Name = p143.Class.Name;

        if table.find(u7, Name) == nil then
            return;
        end;

        u129:_refreshCategory(Name);
    end);
    table.insert(u129._closeTradeListeners, function() -- Line: 952
        -- upvalues: u145 (copy)
        u145:Disconnect();
    end);
    u129._lastDiamondValue = 0;
    u129._confirmTimestamp = nil;
end;

function u9._calculateRAPValues(p146) -- Line: 966
    local v147 = 0;
    local v148 = 0;

    for _, v in pairs(p146._currentRenderSelectedItems) do
        for _, v2 in pairs(v) do
            if v2:IsA("Currency") then
                v147 = v147 + v2:GetAmount();
            elseif v2:IsRAPVisible() then
                v147 = v147 + (v2:GetDevRAP() or 0) * v2:GetAmount();
            end;
        end;
    end;

    for _, v in pairs(p146._currentItems) do
        for _, v2 in pairs(v) do
            if v2:IsA("Currency") then
                v148 = v148 + v2:GetAmount();
            elseif v2:IsRAPVisible() then
                v148 = v148 + (v2:GetDevRAP() or 0) * v2:GetAmount();
            end;
        end;
    end;

    return v147, v148;
end;

function u9._updateRAPValues(p149) -- Line: 990
    -- upvalues: PlayerRAPHolder (copy), Functions (copy), ClientRAPHolder (copy)
    local v150, v151 = p149:_calculateRAPValues();
    PlayerRAPHolder.Amount.Text = Functions.NumberShorten(v151, false);
    ClientRAPHolder.Amount.Text = Functions.NumberShorten(v150, false);
end;

function u9._updateItems(p152, p153, p154) -- Line: 997
    p152._currentRenderSelectedItems = p153;
    p152._currentItems = p154;
    p152:_renderSelectedItems(false);
    p152:_updateRAPValues();
end;

function u9._updateItemsById(p155, p156) -- Line: 1005
    -- upvalues: TradingCmds (copy), LocalPlayer (copy)
    local v157 = TradingCmds.GetState(p156);
    local v158 = "Trade state not found for tradeId: " .. tostring(p156);
    local v159 = assert(v157, v158);
    local v160 = v159:PlayerIndex(LocalPlayer);
    local v161 = assert(v160, "Player index not found for localPlayer in UpdateItemsById");
    p155:_updateItems(v159._items[v161], v159._items[v159:Index2(v161)]);
    p155:_update();
end;

function u9._onTradeCreated(p162, p163, p164, p165) -- Line: 1015
    -- upvalues: LocalPlayer (copy), TabController (copy)
    if p164 == LocalPlayer then
        p164 = p165 or p164;
    end;

    p162:_setupTrade(p164);
    p162:_update();
    TabController.OpenTab("TradeWindow");
end;

function u9._onTradeSetReady(p166, p167, p168, p169) -- Line: 1022
    -- upvalues: TradingCmds (copy), LocalPlayer (copy), Audio (copy)
    local v170 = TradingCmds.GetState(p167);
    local v171 = "Trade state not found for tradeId: " .. tostring(p167);
    assert(v170, v171);
    local v172 = v170:PlayerIndex(LocalPlayer);
    assert(v172, "Player index not found for localPlayer in TradeSetReady");

    if p169 then
        Audio.Play("rbxassetid://129831368538797", script, nil, 1);
    end;

    if v172 == p168 then
        if p169 then
            p166:_clientReady();
        else
            p166:_clientUnready();
        end;
    end;

    p166:_update();
end;

function u9._onTradeSetItem(p173, p174, p175, p176, p177) -- Line: 1044
    -- upvalues: TradingCmds (copy), LocalPlayer (copy)
    local v178 = TradingCmds.GetState(p174);

    if v178 then
        local v179 = v178:PlayerIndex(LocalPlayer);

        if v179 and v179 == p175 then
            p173:_syncLocalSelectionFromTradeState(p176, p177);
        end;
    end;

    p173:_updateItemsById(p174);
end;

function u9._onTradeMessage(p180, p181, p182, p183) -- Line: 1062
    -- upvalues: TradingCmds (copy)
    local v184 = TradingCmds.GetState(p181);
    local v185 = "Trade state not found for tradeId: " .. tostring(p181);
    assert(v184, v185);
    p180:_receivedMessage(v184:Player1(p182), p183);
end;

function u9._onTradeDestroyed(p186, p187, p188) -- Line: 1070
    -- upvalues: TabController (copy), Audio (copy), Message (copy)
    TabController.SetLockedTab(nil);

    if TabController.Get() == "TradeWindow" then
        TabController.CloseTab();
    end;

    if p188 then
        local v189 = string.find(p188, "successfully") ~= nil;

        if v189 then
            Audio.Play("rbxassetid://85645660281534", script, nil, 1);
        end;

        Message.New(p188, {
            tradeAllowed = true,
            sound = v189 and "rbxassetid://74508332171664" or "rbxassetid://109670773332731"
        });
    end;

    p186:_closeTrade();
end;

function u9._onReadyButtonActivated(p190) -- Line: 1089
    -- upvalues: TradingCmds (copy), u1 (copy), Message (copy), Functions (copy)
    local v191 = TradingCmds.GetState();

    if not v191 then
        return;
    end;

    if p190:_isChatting() or (v191._executing or p190._isModificationLocked) then
        return;
    end;

    if v191._readyTimer == nil then
        local v192 = p190:_getReadyStatus();
        u1:AtTrace():Log((`ReadyButton activated, ready: {v192}`));

        if not v192 and (Functions.DictionaryLength(p190._currentItems) == 0 and not Message.New("Are you sure? You won\'t get anything from this trade.", true, {
            tradeAllowed = true
        })) then
            warn("no items");

            return;
        end;

        local v193, v194 = TradingCmds.SetReady(not v192);
        warn("set ready reqeust:", "ready?", v192, "success?", v193, "error?", v194);

        if not v193 and v194 then
            Message.New(v194, {
                tradeAllowed = true
            });
        end;
    else
        local v195 = p190:_getConfirmedStatus();
        u1:AtTrace():Log((`ReadyButton activated, confirmed: {v195}`));

        if not (v195 or Message.New("Are you sure? Make sure the trade is fair before continuing.", true, {
            tradeAllowed = true
        })) then
            return;
        end;

        local v196, v197 = TradingCmds.SetConfirmed(not v195);

        if not v196 and v197 then
            Message.New(v197, {
                tradeAllowed = true
            });
        end;
    end;
end;

function u9._onGridToggleActivated(p198) -- Line: 1140
    if p198:_isChatting() then
        return;
    end;

    p198._isGridView = not p198._isGridView;
    local v199 = p198:_getResolution();

    if p198._userState then
        for _, v in pairs(p198._userState.containers) do
            v:ChangeResolutionSettings(v199);
        end;
    end;

    if p198._clientItemContainer then
        p198._clientItemContainer:ChangeResolutionSettings(v199);
    end;

    if p198._playerItemContainer then
        p198._playerItemContainer:ChangeResolutionSettings(v199);
    end;

    p198:_update();
end;

function u9._onClientDiamondsInputBegan(p200, p201, p202) -- Line: 1165
    -- upvalues: TradingCmds (copy), Input (copy)
    if p202 then
        return;
    end;

    local v203 = TradingCmds.GetState();

    if not v203 then
        return;
    end;

    local v204 = v203._readyTimer ~= nil;
    local v205 = p200:_getReadyStatus();

    if not p200:_isChatting() and (not v205 and (not v204 and (p201.UserInputType == Enum.UserInputType.MouseButton1 or p201.UserInputType == Enum.UserInputType.Touch))) then
        Input:CaptureFocus();
    end;
end;

function u9._onChatButtonActivated(p206) -- Line: 1189
    -- upvalues: ChatOverlay (copy), Notification (copy), Input3 (copy)
    ChatOverlay.Visible = not ChatOverlay.Visible;
    p206:_setSelectionEnabled(not ChatOverlay.Visible);
    Notification.Count.Text = 0;
    Notification.Visible = false;

    if ChatOverlay.Visible then
        Input3:ReleaseFocus();
    end;
end;

function u9._onClientDiamondInputFocusLost(p207) -- Line: 1200
    -- upvalues: TradingCmds (copy)
    local v208 = TradingCmds.GetState();

    if not v208 then
        return;
    end;

    if v208._executing then
        return;
    end;

    if v208._readyTimer then
        return;
    end;

    p207:_setDiamondAmount();
end;

function u9._onSendButtonActivated(p209) -- Line: 1214
    -- upvalues: Trading (copy)
    if p209._lastMessageTime and workspace:GetServerTimeNow() - p209._lastMessageTime <= Trading.ClientMessageDebounce then
        return;
    end;

    p209:_sendChatMessage();
end;

function u9._onChatInputFocusLost(p210, p211) -- Line: 1226
    if not p211 then
        return;
    end;

    p210:_sendChatMessage();
end;

function u9._onScreenResolutionChanged(p212) -- Line: 1235
    -- upvalues: u2 (copy)
    if u2.Enabled then
        p212:_updateMessageScroll();
    end;
end;

function u9._onCancelButtonActivated(p213) -- Line: 1241
    -- upvalues: TradingCmds (copy)
    if not TradingCmds.GetState() then
        return;
    end;

    if p213:_isChatting() then
        return;
    end;

    TradingCmds.Decline();
end;

function u9._init(u214) -- Line: 1252
    -- upvalues: TradingCmds (copy), ScreenResolution (copy), GUI (copy), Cancel (copy), Ready (copy), ChatButton (copy), GridMode (copy), ClientDiamonds (copy), Send (copy), Input (copy), Input2 (copy), ButtonFX (copy), Tooltip (copy), Variables (copy), RunService (copy)
    TradingCmds.TradeCreated:Connect(u214._funcWrapper(u214._onTradeCreated));
    TradingCmds.TradeSetReady:Connect(u214._funcWrapper(u214._onTradeSetReady));
    TradingCmds.TradeSetItem:Connect(u214._funcWrapper(u214._onTradeSetItem));
    TradingCmds.TradeMessage:Connect(u214._funcWrapper(u214._onTradeMessage));
    TradingCmds.TradeDestroyed:Connect(u214._funcWrapper(u214._onTradeDestroyed));
    ScreenResolution.Changed:Connect(u214._funcWrapper(u214._onScreenResolutionChanged));
    GUI.ButtonActivated(Cancel, u214._funcWrapper(u214._onCancelButtonActivated));
    GUI.ButtonActivated(Ready, u214._funcWrapper(u214._onReadyButtonActivated));
    GUI.ButtonActivated(ChatButton, u214._funcWrapper(u214._onChatButtonActivated));
    GridMode.Activated:Connect(u214._funcWrapper(u214._onGridToggleActivated));
    ClientDiamonds.InputBegan:Connect(u214._funcWrapper(u214._onClientDiamondsInputBegan));
    Send.Activated:Connect(u214._funcWrapper(u214._onSendButtonActivated));
    Input.FocusLost:Connect(u214._funcWrapper(u214._onClientDiamondInputFocusLost));
    Input2.FocusLost:Connect(u214._funcWrapper(u214._onChatInputFocusLost));
    ButtonFX(Cancel);
    ButtonFX(Ready);
    ButtonFX(GridMode);
    ButtonFX(ChatButton);
    ButtonFX(Send);
    Tooltip(GridMode, "Toggle Grid View");
    task.spawn(function() -- Line: 1279
        -- upvalues: Variables (ref), RunService (ref), u214 (copy)
        while true do
            while Variables.Trading do
                u214:_update();
                RunService.Heartbeat:Wait();
            end;

            RunService.Heartbeat:Wait();
        end;
    end);
end;

return u9._build();