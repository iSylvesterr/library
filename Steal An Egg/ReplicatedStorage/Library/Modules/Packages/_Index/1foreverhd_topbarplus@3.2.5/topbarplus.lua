-- Decompiled with Potassium's decompiler.

local UserInputService = game:GetService("UserInputService");
local StarterGui = game:GetService("StarterGui");
local Players = game:GetService("Players");
require(script.Types);
local u1 = script;
local Reference = require(u1.Reference);
local v2 = Reference.getObject();
local v3;

if v2 then
    v3 = v2.Value;
else
    v3 = v2;
end;

if v3 and v3 ~= u1 then
    return require(v3);
end;

if not v2 then
    Reference.addToReplicatedStorage();
end;

local GoodSignal = require(u1.Packages.GoodSignal);
local Janitor = require(u1.Packages.Janitor);
local Utility = require(u1.Utility);
local Themes = require(u1.Features.Themes);
local Gamepad = require(u1.Features.Gamepad);
local Overflow = require(u1.Features.Overflow);
local u4 = {};
u4.__index = u4;
local LocalPlayer = Players.LocalPlayer;
local Themes2 = u1.Features.Themes;
local u5 = {};
local u6 = GoodSignal.new();
local Elements = u1.Elements;
local u7 = 0;
u4.baseDisplayOrderChanged = GoodSignal.new();
u4.baseDisplayOrder = 10;
u4.baseTheme = require(Themes2.Default);
u4.isOldTopbar = false;
u4.iconsDictionary = u5;
u4.insetHeightChanged = GoodSignal.new();
u4.container = require(Elements.Container)(u4);
u4.topbarEnabled = true;
u4.iconAdded = GoodSignal.new();
u4.iconRemoved = GoodSignal.new();
u4.iconChanged = GoodSignal.new();

function u4.getIcons() -- Line: 90
    -- upvalues: u4 (copy)
    return u4.iconsDictionary;
end;

function u4.getIconByUID(p8) -- Line: 94
    -- upvalues: u4 (copy)
    return u4.iconsDictionary[p8] or nil;
end;

function u4.getIcon(p9) -- Line: 102
    -- upvalues: u4 (copy), u5 (copy)
    local v10 = u4.getIconByUID(p9);

    if v10 then
        return v10;
    end;

    for _, v in pairs(u5) do
        if v.name == p9 then
            return v;
        end;
    end;

    return nil;
end;

function u4.setTopbarEnabled(p11, p12) -- Line: 115
    -- upvalues: u4 (copy)
    if typeof(p11) ~= "boolean" then
        p11 = u4.topbarEnabled;
    end;

    if not p12 then
        u4.topbarEnabled = p11;
    end;

    for _, v in pairs(u4.container) do
        v.Enabled = p11;
    end;
end;

function u4.modifyBaseTheme(p13) -- Line: 127
    -- upvalues: Themes (copy), u4 (copy), u5 (copy)
    local v14 = Themes.getModifications(p13);

    for _, v in pairs(v14) do
        for _, v4 in pairs(u4.baseTheme) do
            Themes.merge(v4, v);
        end;
    end;

    for _, v in pairs(u5) do
        v:setTheme(u4.baseTheme);
    end;
end;

function u4.setDisplayOrder(p15) -- Line: 139
    -- upvalues: u4 (copy)
    u4.baseDisplayOrder = p15;
    u4.baseDisplayOrderChanged:Fire(p15);
end;

task.defer(Gamepad.start, u4);
task.defer(Overflow.start, u4);
task.defer(function() -- Line: 147
    -- upvalues: LocalPlayer (copy), u4 (copy), u1 (copy)
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");

    for _, v in pairs(u4.container) do
        v.Parent = PlayerGui;
    end;

    require(u1.Attribute);
end);

function u4.new() -- Line: 156
    -- upvalues: u4 (copy), Janitor (copy), Utility (copy), u5 (copy), GoodSignal (copy), u1 (copy), Elements (copy), u7 (ref), UserInputService (copy), u6 (copy), StarterGui (copy)
    local u16 = {};
    setmetatable(u16, u4);
    local v17 = Janitor.new();
    u16.janitor = v17;
    u16.themesJanitor = v17:add(Janitor.new());
    u16.singleClickJanitor = v17:add(Janitor.new());
    u16.captionJanitor = v17:add(Janitor.new());
    u16.joinJanitor = v17:add(Janitor.new());
    u16.menuJanitor = v17:add(Janitor.new());
    u16.dropdownJanitor = v17:add(Janitor.new());
    local u18 = Utility.generateUID();
    u5[u18] = u16;
    v17:add(function() -- Line: 173
        -- upvalues: u5 (ref), u18 (copy)
        u5[u18] = nil;
    end);
    u16.selected = v17:add(GoodSignal.new());
    u16.deselected = v17:add(GoodSignal.new());
    u16.toggled = v17:add(GoodSignal.new());
    u16.viewingStarted = v17:add(GoodSignal.new());
    u16.viewingEnded = v17:add(GoodSignal.new());
    u16.stateChanged = v17:add(GoodSignal.new());
    u16.notified = v17:add(GoodSignal.new());
    u16.noticeStarted = v17:add(GoodSignal.new());
    u16.noticeChanged = v17:add(GoodSignal.new());
    u16.endNotices = v17:add(GoodSignal.new());
    u16.toggleKeyAdded = v17:add(GoodSignal.new());
    u16.fakeToggleKeyChanged = v17:add(GoodSignal.new());
    u16.alignmentChanged = v17:add(GoodSignal.new());
    u16.updateSize = v17:add(GoodSignal.new());
    u16.resizingComplete = v17:add(GoodSignal.new());
    u16.joinedParent = v17:add(GoodSignal.new());
    u16.menuSet = v17:add(GoodSignal.new());
    u16.dropdownSet = v17:add(GoodSignal.new());
    u16.updateMenu = v17:add(GoodSignal.new());
    u16.startMenuUpdate = v17:add(GoodSignal.new());
    u16.childThemeModified = v17:add(GoodSignal.new());
    u16.indicatorSet = v17:add(GoodSignal.new());
    u16.dropdownChildAdded = v17:add(GoodSignal.new());
    u16.menuChildAdded = v17:add(GoodSignal.new());
    u16.iconModule = u1;
    u16.UID = u18;
    u16.isEnabled = true;
    u16.enabled = u16.isEnabled;
    u16.isSelected = false;
    u16.isViewing = false;
    u16.joinedFrame = false;
    u16.parentIconUID = false;
    u16.deselectWhenOtherIconSelected = true;
    u16.totalNotices = 0;
    u16.activeState = "Deselected";
    u16.alignment = "";
    u16.originalAlignment = "";
    u16.appliedTheme = {};
    u16.appearance = {};
    u16.cachedInstances = {};
    u16.cachedNamesToInstances = {};
    u16.cachedCollectives = {};
    u16.bindedToggleKeys = {};
    u16.customBehaviours = {};
    u16.toggleItems = {};
    u16.bindedEvents = {};
    u16.notices = {};
    u16.menuIcons = {};
    u16.dropdownIcons = {};
    u16.childIconsDict = {};
    u16.creationTime = os.clock();
    u16.widget = v17:add(require(Elements.Widget)(u16, u4));
    u16:setAlignment();
    u7 = u7 + 1;
    local v19 = u7 * 0.01 + 1;
    u16:setOrder(v19, "deselected");
    u16:setOrder(v19, "selected");
    u16:setTheme(u4.baseTheme);
    local v20 = u16:getInstance("ClickRegion");

    local function handleToggle() -- Line: 249
        -- upvalues: u16 (copy)
        if u16.locked then
            return;
        end;

        if u16.isSelected then
            u16:deselect("User", u16);

            return;
        end;

        u16:select("User", u16);
    end;

    local u21 = false;
    local u22 = false;
    v20.MouseButton1Click:Connect(function() -- Line: 261
        -- upvalues: u21 (ref), u22 (ref), u16 (copy)
        if u21 then
            return;
        end;

        u22 = true;
        task.delay(0.01, function() -- Line: 266
            -- upvalues: u22 (ref)
            u22 = false;
        end);

        if u16.locked then
            return;
        end;

        if u16.isSelected then
            u16:deselect("User", u16);

            return;
        end;

        u16:select("User", u16);
    end);
    v20.TouchTap:Connect(function() -- Line: 271
        -- upvalues: u22 (ref), u21 (ref), u16 (copy)
        if u22 then
            return;
        end;

        u21 = true;
        task.delay(0.01, function() -- Line: 278
            -- upvalues: u21 (ref)
            u21 = false;
        end);

        if u16.locked then
            return;
        end;

        if u16.isSelected then
            u16:deselect("User", u16);

            return;
        end;

        u16:select("User", u16);
    end);
    v17:add(UserInputService.InputBegan:Connect(function(p23, p24) -- Line: 285
        -- upvalues: u16 (copy)
        if u16.locked then
            return;
        end;

        if u16.bindedToggleKeys[p23.KeyCode] and not p24 then
            if u16.locked then
                return;
            end;

            if u16.isSelected then
                u16:deselect("User", u16);

                return;
            end;

            u16:select("User", u16);
        end;
    end));

    local function viewingEnded() -- Line: 307
        -- upvalues: u16 (copy)
        if u16.locked then
            return;
        end;

        u16.isViewing = false;
        u16.viewingEnded:Fire(true);
        u16:setState(nil, "User", u16);
    end;

    u16.joinedParent:Connect(function() -- Line: 315
        -- upvalues: u16 (copy)
        if u16.isViewing then
            if u16.locked then
                return;
            end;

            u16.isViewing = false;
            u16.viewingEnded:Fire(true);
            u16:setState(nil, "User", u16);
        end;
    end);
    v20.MouseEnter:Connect(function() -- Line: 320
        -- upvalues: UserInputService (ref), u16 (copy)
        local v25 = not UserInputService.KeyboardEnabled;

        if u16.locked then
            return;
        end;

        u16.isViewing = true;
        u16.viewingStarted:Fire(true);

        if not v25 then
            u16:setState("Viewing", "User", u16);
        end;
    end);
    local u26 = 0;
    v17:add(UserInputService.TouchEnded:Connect(viewingEnded));
    v20.MouseLeave:Connect(viewingEnded);
    v20.SelectionGained:Connect(function(p27) -- Line: 297, Name: viewingStarted
        -- upvalues: u16 (copy)
        if u16.locked then
            return;
        end;

        u16.isViewing = true;
        u16.viewingStarted:Fire(true);

        if not p27 then
            u16:setState("Viewing", "User", u16);
        end;
    end);
    v20.SelectionLost:Connect(viewingEnded);
    v20.MouseButton1Down:Connect(function() -- Line: 329
        -- upvalues: u16 (copy), UserInputService (ref), u26 (ref)
        if not u16.locked and UserInputService.TouchEnabled then
            u26 = u26 + 1;
            local u28 = u26;
            task.delay(0.2, function() -- Line: 333
                -- upvalues: u28 (copy), u26 (ref), u16 (ref)
                if u28 == u26 then
                    if u16.locked then
                        return;
                    end;

                    u16.isViewing = true;
                    u16.viewingStarted:Fire(true);
                    u16:setState("Viewing", "User", u16);
                end;
            end);
        end;
    end);
    v20.MouseButton1Up:Connect(function() -- Line: 340
        -- upvalues: u26 (ref)
        u26 = u26 + 1;
    end);
    local u29 = u16:getInstance("IconOverlay");
    u16.viewingStarted:Connect(function() -- Line: 346
        -- upvalues: u29 (copy), u16 (copy)
        u29.Visible = not u16.overlayDisabled;
    end);
    u16.viewingEnded:Connect(function() -- Line: 349
        -- upvalues: u29 (copy)
        u29.Visible = false;
    end);
    v17:add(u6:Connect(function(p30) -- Line: 354
        -- upvalues: u16 (copy)
        if p30 ~= u16 and (u16.deselectWhenOtherIconSelected and p30.deselectWhenOtherIconSelected) then
            u16:deselect("AutoDeselect", p30);
        end;
    end));
    local v31 = debug.info(2, "s");
    local v32 = string.split(v31, ".");
    local v33 = game;
    local v34 = nil;

    for _, v in pairs(v32) do
        v33 = v33:FindFirstChild(v);

        if not v33 then
            break;
        end;

        if v33:IsA("ScreenGui") then
            v34 = v33;
        end;
    end;

    if v33 and (v34 and v34.ResetOnSpawn == true) then
        Utility.localPlayerRespawned(function() -- Line: 383
            -- upvalues: u16 (copy)
            u16:destroy();
        end);
    end;

    u16.toggled:Connect(function(p35) -- Line: 389
        -- upvalues: u16 (copy), u4 (ref)
        u16.noticeChanged:Fire(u16.totalNotices);

        for i, _ in pairs(u16.childIconsDict) do
            local v36 = u4.getIconByUID(i);
            v36.noticeChanged:Fire(v36.totalNotices);

            if not p35 and v36.isSelected then
                for _, _ in pairs(v36.childIconsDict) do
                    v36:deselect("HideParentFeature", u16);
                end;
            end;
        end;
    end);
    u16.selected:Connect(function() -- Line: 412
        -- upvalues: u16 (copy), StarterGui (ref)
        if #u16.dropdownIcons > 0 then
            if StarterGui:GetCore("ChatActive") and u16.alignment ~= "Right" then
                u16.chatWasPreviouslyActive = true;
                StarterGui:SetCore("ChatActive", false);
            end;

            if StarterGui:GetCoreGuiEnabled("PlayerList") and u16.alignment ~= "Left" then
                u16.playerlistWasPreviouslyActive = true;
                StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false);
            end;
        end;
    end);
    u16.deselected:Connect(function() -- Line: 425
        -- upvalues: u16 (copy), StarterGui (ref)
        if u16.chatWasPreviouslyActive then
            u16.chatWasPreviouslyActive = nil;
            StarterGui:SetCore("ChatActive", true);
        end;

        if u16.playerlistWasPreviouslyActive then
            u16.playerlistWasPreviouslyActive = nil;
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true);
        end;
    end);
    task.delay(0.1, function() -- Line: 439
        -- upvalues: u16 (copy)
        if u16.activeState == "Deselected" then
            u16.stateChanged:Fire("Deselected");
            u16:refresh();
        end;
    end);
    u4.iconAdded:Fire(u16);

    return u16;
end;

function u4.setName(p37, p38) -- Line: 453
    p37.widget.Name = p38;
    p37.name = p38;

    return p37;
end;

function u4.setState(p39, p40, p41, p42) -- Line: 459
    -- upvalues: Utility (copy), u6 (copy)
    local v43 = Utility.formatStateName(p40 or (p39.isSelected and "Selected" or "Deselected"));

    if p39.activeState == v43 then
        return;
    end;

    local isSelected = p39.isSelected;
    p39.activeState = v43;

    if v43 == "Deselected" then
        p39.isSelected = false;

        if isSelected then
            p39.toggled:Fire(false, p41, p42);
            p39.deselected:Fire(p41, p42);
        end;

        p39:_setToggleItemsVisible(false, p41, p42);
    elseif v43 == "Selected" then
        p39.isSelected = true;

        if not isSelected then
            p39.toggled:Fire(true, p41, p42);
            p39.selected:Fire(p41, p42);
            u6:Fire(p39, p41, p42);
        end;

        p39:_setToggleItemsVisible(true, p41, p42);
    end;

    p39.stateChanged:Fire(v43, p41, p42);
end;

function u4.getInstance(u44, u45) -- Line: 492
    -- upvalues: Themes (copy)
    local v46 = u44.cachedNamesToInstances[u45];

    if v46 then
        return v46;
    end;

    local function cacheInstance(u47, u48) -- Line: 500
        -- upvalues: u44 (copy)
        if not u44.cachedInstances[u48] then
            local v49 = u48:GetAttribute("Collective");

            if v49 then
                v49 = u44.cachedCollectives[v49];
            end;

            if v49 then
                table.insert(v49, u48);
            end;

            u44.cachedNamesToInstances[u47] = u48;
            u44.cachedInstances[u48] = true;
            u48.Destroying:Once(function() -- Line: 510
                -- upvalues: u44 (ref), u47 (copy), u48 (copy)
                u44.cachedNamesToInstances[u47] = nil;
                u44.cachedInstances[u48] = nil;
            end);
        end;
    end;

    local widget = u44.widget;
    cacheInstance("Widget", widget);

    if u45 == "Widget" then
        return widget;
    end;

    local u50 = nil;

    local function scanChildren(p51) -- Line: 523
        -- upvalues: u44 (copy), Themes (ref), scanChildren (copy), cacheInstance (copy), u45 (copy), u50 (ref)
        for _, child in pairs(p51:GetChildren()) do
            local v52 = child:GetAttribute("WidgetUID");

            if not v52 or v52 == u44.UID then
                local v53 = Themes.getRealInstance(child) or child;
                scanChildren(v53);

                if v53:IsA("GuiBase") or (v53:IsA("UIBase") or v53:IsA("ValueBase")) then
                    local Name = v53.Name;
                    cacheInstance(Name, v53);

                    if Name == u45 then
                        u50 = v53;
                    end;
                end;
            end;
        end;
    end;

    scanChildren(widget);

    return u50;
end;

function u4.getCollective(p54, p55) -- Line: 552
    local v56 = p54.cachedCollectives[p55];

    if v56 then
        return v56;
    end;

    local v57 = {};

    for i, _ in pairs(p54.cachedInstances) do
        if i:GetAttribute("Collective") == p55 then
            table.insert(v57, i);
        end;
    end;

    p54.cachedCollectives[p55] = v57;

    return v57;
end;

function u4.getInstanceOrCollective(p58, p59) -- Line: 573
    local v60 = {};
    local v61 = p58:getInstance(p59);

    if v61 then
        table.insert(v60, v61);
    end;

    if #v60 == 0 then
        v60 = p58:getCollective(p59);
    end;

    return v60;
end;

function u4.getStateGroup(p62, p63) -- Line: 587
    local v64 = p63 or p62.activeState;
    local v65 = p62.appearance[v64];

    if not v65 then
        v65 = {};
        p62.appearance[v64] = v65;
    end;

    return v65;
end;

function u4.refreshAppearance(p66, p67, p68) -- Line: 597
    -- upvalues: Themes (copy)
    Themes.refresh(p66, p67, p68);

    return p66;
end;

function u4.refresh(p69) -- Line: 602
    p69:refreshAppearance(p69.widget);
    p69.updateSize:Fire();

    return p69;
end;

function u4.updateParent(p70) -- Line: 608
    -- upvalues: u4 (copy)
    local v71 = u4.getIconByUID(p70.parentIconUID);

    if v71 then
        v71.updateSize:Fire();
    end;
end;

function u4.setBehaviour(p72, p73, p74, p75, p76) -- Line: 615
    p72.customBehaviours[p73 .. "-" .. p74] = p75;

    if p76 then
        local v77 = p72:getInstanceOrCollective(p73);

        for _, v in pairs(v77) do
            p72:refreshAppearance(v, p74);
        end;
    end;
end;

function u4.modifyTheme(p78, p79, p80) -- Line: 628
    -- upvalues: Themes (copy)
    return p78, Themes.modify(p78, p79, p80);
end;

function u4.modifyChildTheme(p81, p82, p83) -- Line: 633
    -- upvalues: u4 (copy)
    p81.childModifications = p82;
    p81.childModificationsUID = p83;

    for i, _ in pairs(p81.childIconsDict) do
        u4.getIconByUID(i):modifyTheme(p82, p83);
    end;

    p81.childThemeModified:Fire();

    return p81;
end;

function u4.removeModification(p84, p85) -- Line: 646
    -- upvalues: Themes (copy)
    Themes.remove(p84, p85);

    return p84;
end;

function u4.removeModificationWith(p86, p87, p88, p89) -- Line: 651
    -- upvalues: Themes (copy)
    Themes.removeWith(p86, p87, p88, p89);

    return p86;
end;

function u4.setTheme(p90, p91) -- Line: 656
    -- upvalues: Themes (copy)
    Themes.set(p90, p91);

    return p90;
end;

function u4.setEnabled(p92, p93) -- Line: 661
    p92.isEnabled = p93;
    p92.enabled = p92.isEnabled;
    p92.widget.Visible = p93;
    p92:updateParent();

    return p92;
end;

function u4.select(p94, p95, p96) -- Line: 669
    p94:setState("Selected", p95, p96);

    return p94;
end;

function u4.deselect(p97, p98, p99) -- Line: 674
    p97:setState("Deselected", p98, p99);

    return p97;
end;

function u4.notify(p100, p101, p102) -- Line: 679
    -- upvalues: Elements (copy), u4 (copy)
    if not p100.notice then
        p100.notice = require(Elements.Notice)(p100, u4);
    end;

    p100.noticeStarted:Fire(p101, p102);

    return p100;
end;

function u4.clearNotices(p103) -- Line: 693
    p103.endNotices:Fire();

    return p103;
end;

function u4.disableOverlay(p104, p105) -- Line: 698
    p104.overlayDisabled = p105;

    return p104;
end;

u4.disableStateOverlay = u4.disableOverlay;

function u4.setImage(p106, p107, p108) -- Line: 704
    p106:modifyTheme({
        "IconImage",
        "Image",
        p107,
        p108
    });

    return p106;
end;

function u4.setLabel(p109, p110, p111) -- Line: 709
    p109:modifyTheme({
        "IconLabel",
        "Text",
        p110,
        p111
    });

    return p109;
end;

function u4.setOrder(p112, p113, p114) -- Line: 714
    local v115 = p113 * 100;
    p112:modifyTheme({
        "IconSpot",
        "LayoutOrder",
        v115,
        p114
    });
    p112:modifyTheme({
        "Widget",
        "LayoutOrder",
        v115,
        p114
    });

    return p112;
end;

function u4.setCornerRadius(p116, p117, p118) -- Line: 723
    p116:modifyTheme({
        "IconCorners",
        "CornerRadius",
        p117,
        p118
    });

    return p116;
end;

function u4.align(p119, p120, p121) -- Line: 728
    -- upvalues: u4 (copy)
    local v122 = tostring(p120):lower();
    local v123 = (v122 == "mid" or v122 == "centre") and "center" or v122;
    local v124 = v123 ~= "left" and (v123 ~= "center" and v123 ~= "right") and "left" or v123;
    local v125 = v124 == "center" and u4.container.TopbarCentered or u4.container.TopbarStandard;
    local Holders = v125.Holders;
    local v126 = string.upper((string.sub(v124, 1, 1))) .. string.sub(v124, 2);

    if not p121 then
        p119.originalAlignment = v126;
    end;

    local joinedFrame = p119.joinedFrame;
    local v127 = Holders[v126];
    p119.screenGui = v125;
    p119.alignmentHolder = v127;

    if not p119.isDestroyed then
        p119.widget.Parent = joinedFrame or v127;
    end;

    p119.alignment = v126;
    p119.alignmentChanged:Fire(v126);
    u4.iconChanged:Fire(p119);

    return p119;
end;

u4.setAlignment = u4.align;

function u4.setLeft(p128) -- Line: 757
    p128:setAlignment("Left");

    return p128;
end;

function u4.setMid(p129) -- Line: 762
    p129:setAlignment("Center");

    return p129;
end;

function u4.setRight(p130) -- Line: 767
    p130:setAlignment("Right");

    return p130;
end;

function u4.setWidth(p131, p132, p133) -- Line: 772
    p131:modifyTheme({
        "Widget",
        "DesiredWidth",
        p132,
        p133
    });

    return p131;
end;

function u4.setImageScale(p134, p135, p136) -- Line: 780
    p134:modifyTheme({
        "IconImageScale",
        "Value",
        p135,
        p136
    });

    return p134;
end;

function u4.setImageRatio(p137, p138, p139) -- Line: 785
    p137:modifyTheme({
        "IconImageRatio",
        "AspectRatio",
        p138,
        p139
    });

    return p137;
end;

function u4.setTextSize(p140, p141, p142) -- Line: 790
    p140:modifyTheme({
        "IconLabel",
        "TextSize",
        p141,
        p142
    });

    return p140;
end;

function u4.setTextFont(p143, p144, p145, p146, p147) -- Line: 795
    local v148 = p145 or Enum.FontWeight.Regular;
    local v149 = p146 or Enum.FontStyle.Normal;
    local v150 = nil;
    local v151 = typeof(p144);

    if v151 == "number" then
        v150 = Font.fromId(p144, v148, v149);
    elseif v151 == "EnumItem" then
        v150 = Font.fromEnum(p144);
    elseif v151 == "string" and not p144:match("rbxasset") then
        v150 = Font.fromName(p144, v148, v149);
    end;

    p143:modifyTheme({
        "IconLabel",
        "FontFace",
        v150 or Font.new(p144, v148, v149),
        p147
    });

    return p143;
end;

function u4.bindToggleItem(p152, p153) -- Line: 816
    if not (p153:IsA("GuiObject") or p153:IsA("LayerCollector")) then
        error("Toggle item must be a GuiObject or LayerCollector!");
    end;

    p152.toggleItems[p153] = true;
    p152:_updateSelectionInstances();

    return p152;
end;

function u4.unbindToggleItem(p154, p155) -- Line: 825
    p154.toggleItems[p155] = nil;
    p154:_updateSelectionInstances();

    return p154;
end;

function u4._updateSelectionInstances(p156) -- Line: 831
    for i, _ in pairs(p156.toggleItems) do
        local v157 = {};

        for _, descendant in pairs(i:GetDescendants()) do
            if (descendant:IsA("TextButton") or descendant:IsA("ImageButton")) and descendant.Active then
                table.insert(v157, descendant);
            end;
        end;

        p156.toggleItems[i] = v157;
    end;
end;

function u4._setToggleItemsVisible(p158, p159, p160, p161) -- Line: 845
    for i, _ in pairs(p158.toggleItems) do
        if not p161 or (p161 == p158 or p161.toggleItems[i] == nil) then
            i[i:IsA("LayerCollector") and "Enabled" or "Visible"] = p159;
        end;
    end;
end;

function u4.bindEvent(u162, p163, u164) -- Line: 857
    local v165 = u162[p163];
    local v166;

    if v165 then
        if typeof(v165) == "table" then
            v166 = v165.Connect;
        else
            v166 = false;
        end;
    else
        v166 = v165;
    end;

    assert(v166, "argument[1] must be a valid topbarplus icon event name!");
    local v167 = typeof(u164) == "function";
    assert(v167, "argument[2] must be a function!");
    u162.bindedEvents[p163] = v165:Connect(function(...) -- Line: 864
        -- upvalues: u164 (copy), u162 (copy)
        u164(u162, ...);
    end);

    return u162;
end;

function u4.unbindEvent(p168, p169) -- Line: 870
    local v170 = p168.bindedEvents[p169];

    if v170 then
        v170:Disconnect();
        p168.bindedEvents[p169] = nil;
    end;

    return p168;
end;

function u4.bindToggleKey(p171, p172) -- Line: 879
    local v173 = typeof(p172) == "EnumItem";
    assert(v173, "argument[1] must be a KeyCode EnumItem!");
    p171.bindedToggleKeys[p172] = true;
    p171.toggleKeyAdded:Fire(p172);
    p171:setCaption("_hotkey_");

    return p171;
end;

function u4.unbindToggleKey(p174, p175) -- Line: 887
    local v176 = typeof(p175) == "EnumItem";
    assert(v176, "argument[1] must be a KeyCode EnumItem!");
    p174.bindedToggleKeys[p175] = nil;

    return p174;
end;

function u4.call(u177, u178, ...) -- Line: 893
    local u179 = table.pack(...);
    task.spawn(function() -- Line: 895
        -- upvalues: u178 (copy), u177 (copy), u179 (copy)
        u178(u177, table.unpack(u179));
    end);

    return u177;
end;

function u4.addToJanitor(p180, p181, p182, p183) -- Line: 901
    p180.janitor:add(p181, p182, p183);

    return p180;
end;

function u4.lock(p184) -- Line: 906
    p184:getInstance("ClickRegion").Visible = false;
    p184.locked = true;

    return p184;
end;

function u4.unlock(p185) -- Line: 914
    p185:getInstance("ClickRegion").Visible = true;
    p185.locked = false;

    return p185;
end;

function u4.debounce(p186, p187) -- Line: 921
    p186:lock();
    task.wait(p187);
    p186:unlock();

    return p186;
end;

function u4.autoDeselect(p188, p189) -- Line: 928
    p188.deselectWhenOtherIconSelected = p189 == nil and true or p189;

    return p188;
end;

function u4.oneClick(u190, p191) -- Line: 938
    local singleClickJanitor = u190.singleClickJanitor;
    singleClickJanitor:clean();

    if p191 or p191 == nil then
        singleClickJanitor:add(u190.selected:Connect(function() -- Line: 944
            -- upvalues: u190 (copy)
            u190:deselect("OneClick", u190);
        end));
    end;

    u190.oneClickEnabled = true;

    return u190;
end;

function u4.setCaption(p192, p193) -- Line: 952
    -- upvalues: Elements (copy)
    if p193 == "_hotkey_" and p192.captionText then
        return p192;
    end;

    local captionJanitor = p192.captionJanitor;
    p192.captionJanitor:clean();

    if not p193 or p193 == "" then
        p192.caption = nil;
        p192.captionText = nil;

        return p192;
    end;

    local v194 = captionJanitor:add(require(Elements.Caption)(p192));
    v194:SetAttribute("CaptionText", p193);
    p192.caption = v194;
    p192.captionText = p193;

    return p192;
end;

function u4.setCaptionHint(p195, p196) -- Line: 970
    local v197 = typeof(p196) == "EnumItem";
    assert(v197, "argument[1] must be a KeyCode EnumItem!");
    p195.fakeToggleKey = p196;
    p195.fakeToggleKeyChanged:Fire(p196);
    p195:setCaption("_hotkey_");

    return p195;
end;

function u4.leave(p198) -- Line: 978
    p198.joinJanitor:clean();

    return p198;
end;

function u4.joinMenu(p199, p200) -- Line: 984
    -- upvalues: Utility (copy)
    Utility.joinFeature(p199, p200, p200.menuIcons, p200:getInstance("Menu"));
    p200.menuChildAdded:Fire(p199);

    return p199;
end;

function u4.setMenu(p201, p202) -- Line: 990
    p201.menuSet:Fire(p202);

    return p201;
end;

function u4.setFrozenMenu(p203, p204) -- Line: 995
    p203:freezeMenu(p204);
    p203:setMenu(p204);
end;

function u4.freezeMenu(u205) -- Line: 1000
    u205:select("FrozenMenu", u205);
    u205:bindEvent("deselected", function(p206) -- Line: 1004
        -- upvalues: u205 (copy)
        p206:select("FrozenMenu", u205);
    end);
    u205:modifyTheme({ "IconSpot", "Visible", false });
end;

function u4.joinDropdown(p207, p208) -- Line: 1010
    -- upvalues: Utility (copy)
    p208:getDropdown();
    Utility.joinFeature(p207, p208, p208.dropdownIcons, p208:getInstance("DropdownScroller"));
    p208.dropdownChildAdded:Fire(p207);

    return p207;
end;

function u4.getDropdown(p209) -- Line: 1017
    -- upvalues: Elements (copy)
    local dropdown = p209.dropdown;

    if not dropdown then
        dropdown = require(Elements.Dropdown)(p209);
        p209.dropdown = dropdown;
        p209:clipOutside(dropdown);
    end;

    return dropdown;
end;

function u4.setDropdown(p210, p211) -- Line: 1027
    p210:getDropdown();
    p210.dropdownSet:Fire(p211);

    return p210;
end;

function u4.clipOutside(p212, p213) -- Line: 1033
    -- upvalues: Utility (copy)
    local v214 = Utility.clipOutside(p212, p213);
    p212:refreshAppearance(p213);

    return p212, v214;
end;

function u4.setIndicator(p215, p216) -- Line: 1044
    -- upvalues: Elements (copy), u4 (copy)
    if not p215.indicator then
        p215.indicator = p215.janitor:add(require(Elements.Indicator)(p215, u4));
    end;

    p215.indicatorSet:Fire(p216);
end;

function u4.convertLabelToNumberSpinner(u217, u218) -- Line: 1056
    local u219 = u217:getInstance("IconLabel");
    u219.Transparency = 1;
    u218.Parent = u219.Parent;
    u218.Size = UDim2.fromScale(1, 1);
    u218.AnchorPoint = Vector2.new(0.5, 0.5);
    u218.Position = UDim2.new(0.5, 0, 0.5, 0);
    u218.TextXAlignment = Enum.TextXAlignment.Center;
    u218.ClipsDescendants = false;

    for _, v in ipairs({ "FontFace", "BorderSizePixel", "BorderColor3", "Rotation", "TextStrokeTransparency", "TextStrokeColor3", "TextStrokeTransparency", "TextColor3" }) do
        u218[v] = u219[v];
        u217:addToJanitor(u219:GetPropertyChangedSignal(v):Connect(function() -- Line: 1078
            -- upvalues: u218 (copy), v (copy), u219 (copy)
            u218[v] = u219[v];
        end));
    end;

    local function getSpinnerSizeAndDigitCount() -- Line: 1085
        -- upvalues: u218 (copy)
        local v220 = 0;
        local v221 = 0;

        for _, child in u218.Frame:GetChildren() do
            local v222 = string.lower(child.Name);

            if v222 == "digit" then
                v220 = v220 + child.AbsoluteSize.X;
                v221 = v221 + 1;
            elseif (v222 == "prefix" or (v222 == "suffix" or v222 == "comma")) and child.Text ~= "" then
                v220 = v220 + child.AbsoluteSize.X;
                v221 = v221 + 1;
            end;
        end;

        return v220, v221;
    end;

    local function getLabelParentContainerXSize() -- Line: 1103
        -- upvalues: u219 (copy), u218 (copy)
        local Parent = u219.Parent.Parent;

        if Parent == nil then
            return 0;
        end;

        if Parent.IconImage.Visible == true then
            return u218.Frame.AbsoluteSize.X + u219.Parent.Parent.IconImage.AbsoluteSize.X;
        end;

        return Parent.AbsoluteSize.X;
    end;

    local function getNumberSpinnerXSize() -- Line: 1114
        -- upvalues: u218 (copy)
        return u218.Frame.AbsoluteSize.X;
    end;

    local function adjustSize() -- Line: 1118
        -- upvalues: getSpinnerSizeAndDigitCount (copy), u217 (copy), u218 (copy), u219 (copy)
        local v223, v224 = getSpinnerSizeAndDigitCount();

        if v224 < 18 then
            u217:setLabel(u218.Value);
        end;

        local X = u218.Frame.AbsoluteSize.X;

        while v223 < X and u217.isDestroyed ~= true do
            task.wait(0.05);

            if v224 > 0 and v224 < 8 then
                u218.TextSize = u219.TextSize;
                break;
            end;

            local v225 = u218;
            v225.TextSize = v225.TextSize + 1;
            X = u218.Frame.AbsoluteSize.X;
            v223, v224 = getSpinnerSizeAndDigitCount();
        end;

        local Parent = u219.Parent.Parent;
        local v226;

        if Parent == nil then
            v226 = 0;
        elseif Parent.IconImage.Visible == true then
            v226 = u218.Frame.AbsoluteSize.X + u219.Parent.Parent.IconImage.AbsoluteSize.X;
        else
            v226 = Parent.AbsoluteSize.X;
        end;

        while v226 < v223 and u217.isDestroyed ~= true do
            task.wait(0.05);

            if v224 < 8 and v224 > 0 then
                u218.TextSize = u219.TextSize;

                return;
            end;

            local v227 = u218;
            v227.TextSize = v227.TextSize - 1;
            local Parent2 = u219.Parent.Parent;

            if Parent2 == nil then
                v226 = 0;
            elseif Parent2.IconImage.Visible == true then
                v226 = u218.Frame.AbsoluteSize.X + u219.Parent.Parent.IconImage.AbsoluteSize.X;
            else
                v226 = Parent2.AbsoluteSize.X;
            end;

            v223, v224 = getSpinnerSizeAndDigitCount();
        end;
    end;

    u217:addToJanitor(u218.Frame.ChildAdded:Connect(adjustSize));
    u217:addToJanitor(u218.Frame.ChildRemoved:Connect(adjustSize));
    u217:addToJanitor(u217.iconAdded:Connect(function() -- Line: 1156
        -- upvalues: adjustSize (copy)
        task.wait(1);
        adjustSize();
    end));
    u217:updateParent();
    u218.Name = "LabelSpinner";
    u218.Prefix = "$";
    u218.Commas = true;
    u218.Decimals = 0;
    u218.Duration = 0.25;
    u218.Value = 10;
    task.wait(0.2);

    return u217;
end;

function u4.destroy(p228) -- Line: 1176
    -- upvalues: u4 (copy)
    if p228.isDestroyed then
        return;
    end;

    p228:clearNotices();

    if p228.parentIconUID then
        p228:leave();
    end;

    p228.isDestroyed = true;
    p228.janitor:clean();
    u4.iconRemoved:Fire(p228);
end;

u4.Destroy = u4.destroy;

return u4;