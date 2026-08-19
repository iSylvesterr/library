-- Decompiled with Potassium's decompiler.

local UserInputService = game:GetService("UserInputService");
local ContentProvider = game:GetService("ContentProvider");
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
local u8 = {
    mobile = Enum.PreferredInput.Touch,
    desktop = Enum.PreferredInput.KeyboardAndMouse,
    console = Enum.PreferredInput.Gamepad
};
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

function u4.getIcons() -- Line: 110
    -- upvalues: u4 (copy)
    return u4.iconsDictionary;
end;

function u4.getIconByUID(p9) -- Line: 114
    -- upvalues: u4 (copy)
    return u4.iconsDictionary[p9] or nil;
end;

function u4.getIcon(p10) -- Line: 122
    -- upvalues: u4 (copy), u5 (copy)
    local v11 = u4.getIconByUID(p10);

    if v11 then
        return v11;
    end;

    for _, v in pairs(u5) do
        if v.name == p10 then
            return v;
        end;
    end;

    return nil;
end;

function u4.setTopbarEnabled(p12, p13) -- Line: 135
    -- upvalues: u4 (copy)
    if typeof(p12) ~= "boolean" then
        p12 = u4.topbarEnabled;
    end;

    if not p13 then
        u4.topbarEnabled = p12;
    end;

    for _, v in pairs(u4.container) do
        v.Enabled = p12;
    end;
end;

function u4.modifyBaseTheme(p14) -- Line: 147
    -- upvalues: Themes (copy), u4 (copy), u5 (copy)
    local v15 = Themes.getModifications(p14);

    for _, v in pairs(v15) do
        for _, v4 in pairs(u4.baseTheme) do
            Themes.merge(v4, v);
        end;
    end;

    for _, v in pairs(u5) do
        v:setTheme(u4.baseTheme);
    end;
end;

function u4.setDisplayOrder(p16) -- Line: 159
    -- upvalues: u4 (copy)
    u4.baseDisplayOrder = p16;
    u4.baseDisplayOrderChanged:Fire(p16);
end;

task.defer(Gamepad.start, u4);
task.defer(Overflow.start, u4);
task.defer(function() -- Line: 169
    -- upvalues: LocalPlayer (copy), u4 (copy), u1 (copy)
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");

    for _, v in pairs(u4.container) do
        v.Parent = PlayerGui;
    end;

    require(u1.Attribute);
end);

function u4.new() -- Line: 180
    -- upvalues: u4 (copy), Janitor (copy), Utility (copy), u5 (copy), GoodSignal (copy), u1 (copy), Elements (copy), u7 (ref), UserInputService (copy), u8 (copy), u6 (copy), StarterGui (copy)
    local u17 = {};
    setmetatable(u17, u4);
    local v18 = Janitor.new();
    u17.janitor = v18;
    u17.themesJanitor = v18:add(Janitor.new());
    u17.singleClickJanitor = v18:add(Janitor.new());
    u17.captionJanitor = v18:add(Janitor.new());
    u17.joinJanitor = v18:add(Janitor.new());
    u17.menuJanitor = v18:add(Janitor.new());
    u17.dropdownJanitor = v18:add(Janitor.new());
    local u19 = Utility.generateUID();
    u5[u19] = u17;
    v18:add(function() -- Line: 197
        -- upvalues: u5 (ref), u19 (copy)
        u5[u19] = nil;
    end);
    u17.selected = v18:add(GoodSignal.new());
    u17.deselected = v18:add(GoodSignal.new());
    u17.toggled = v18:add(GoodSignal.new());
    u17.viewingStarted = v18:add(GoodSignal.new());
    u17.viewingEnded = v18:add(GoodSignal.new());
    u17.stateChanged = v18:add(GoodSignal.new());
    u17.notified = v18:add(GoodSignal.new());
    u17.noticeStarted = v18:add(GoodSignal.new());
    u17.noticeChanged = v18:add(GoodSignal.new());
    u17.endNotices = v18:add(GoodSignal.new());
    u17.toggleKeyAdded = v18:add(GoodSignal.new());
    u17.fakeToggleKeyChanged = v18:add(GoodSignal.new());
    u17.alignmentChanged = v18:add(GoodSignal.new());
    u17.updateSize = v18:add(GoodSignal.new());
    u17.resizingComplete = v18:add(GoodSignal.new());
    u17.joinedParent = v18:add(GoodSignal.new());
    u17.menuSet = v18:add(GoodSignal.new());
    u17.dropdownSet = v18:add(GoodSignal.new());
    u17.updateMenu = v18:add(GoodSignal.new());
    u17.startMenuUpdate = v18:add(GoodSignal.new());
    u17.childThemeModified = v18:add(GoodSignal.new());
    u17.indicatorSet = v18:add(GoodSignal.new());
    u17.dropdownChildAdded = v18:add(GoodSignal.new());
    u17.menuChildAdded = v18:add(GoodSignal.new());
    u17.iconModule = u1;
    u17.UID = u19;
    u17.isEnabled = true;
    u17.enabled = u17.isEnabled;
    u17.isSelected = false;
    u17.isViewing = false;
    u17.joinedFrame = false;
    u17.parentIconUID = false;
    u17.deselectWhenOtherIconSelected = true;
    u17.totalNotices = 0;
    u17.activeState = "Deselected";
    u17.alignment = "";
    u17.originalAlignment = "";
    u17.appliedTheme = {};
    u17.appearance = {};
    u17.cachedInstances = {};
    u17.cachedNamesToInstances = {};
    u17.cachedCollectives = {};
    u17.bindedToggleKeys = {};
    u17.customBehaviours = {};
    u17.toggleItems = {};
    u17.bindedEvents = {};
    u17.notices = {};
    u17.menuIcons = {};
    u17.dropdownIcons = {};
    u17.childIconsDict = {};
    u17.creationTime = os.clock();
    u17.widget = v18:add(require(Elements.Widget)(u17, u4));
    u17:setAlignment();
    u7 = u7 + 1;
    local v20 = u7 * 0.01 + 1;
    u17:setOrder(v20, "deselected");
    u17:setOrder(v20, "selected");
    u17:setTheme(u4.baseTheme);
    local v21 = u17:getInstance("ClickRegion");
    local u22 = false;
    local u23 = 0;

    local function handleToggle() -- Line: 277
        -- upvalues: u17 (copy), u23 (ref)
        if u17.locked then
            return;
        end;

        local v24 = tick();

        if v24 - u23 < 0.1 then
            return;
        end;

        u23 = v24;

        if u17.isSelected then
            u17:deselect("User", u17);

            return;
        end;

        u17:select("User", u17);
    end;

    v21.MouseButton1Click:Connect(function() -- Line: 296
        -- upvalues: u22 (ref), u17 (copy), u23 (ref)
        u22 = true;

        if u17.locked then
            return;
        end;

        local v25 = tick();

        if v25 - u23 < 0.1 then
            return;
        end;

        u23 = v25;

        if u17.isSelected then
            u17:deselect("User", u17);

            return;
        end;

        u17:select("User", u17);
    end);
    v21.TouchTap:Connect(function() -- Line: 301
        -- upvalues: u22 (ref), u17 (copy), u23 (ref)
        if not u22 then
            if u17.locked then
                return;
            end;

            local v26 = tick();

            if v26 - u23 < 0.1 then
                return;
            end;

            u23 = v26;

            if u17.isSelected then
                u17:deselect("User", u17);

                return;
            end;

            u17:select("User", u17);
        end;
    end);
    v18:add(UserInputService.InputBegan:Connect(function(p27, p28) -- Line: 314
        -- upvalues: u17 (copy), u23 (ref)
        if u17.locked then
            return;
        end;

        if u17.bindedToggleKeys[p27.KeyCode] and not p28 then
            if u17.locked then
                return;
            end;

            local v29 = tick();

            if v29 - u23 < 0.1 then
                return;
            end;

            u23 = v29;

            if u17.isSelected then
                u17:deselect("User", u17);

                return;
            end;

            u17:select("User", u17);
        end;
    end));

    local function viewingEnded() -- Line: 336
        -- upvalues: u17 (copy)
        if u17.locked then
            return;
        end;

        u17.isViewing = false;
        u17.viewingEnded:Fire(true);
        u17:setState(nil, "User", u17);
    end;

    u17.joinedParent:Connect(function() -- Line: 344
        -- upvalues: u17 (copy)
        if u17.isViewing then
            if u17.locked then
                return;
            end;

            u17.isViewing = false;
            u17.viewingEnded:Fire(true);
            u17:setState(nil, "User", u17);
        end;
    end);
    v21.MouseEnter:Connect(function() -- Line: 349
        -- upvalues: UserInputService (ref), u8 (ref), u17 (copy)
        local v30 = UserInputService.PreferredInput ~= u8.desktop;

        if u17.locked then
            return;
        end;

        u17.isViewing = true;
        u17.viewingStarted:Fire(true);

        if not v30 then
            u17:setState("Viewing", "User", u17);
        end;
    end);
    local u31 = 0;
    v18:add(UserInputService.TouchEnded:Connect(viewingEnded));
    v21.MouseLeave:Connect(viewingEnded);
    v21.SelectionGained:Connect(function(p32) -- Line: 326, Name: viewingStarted
        -- upvalues: u17 (copy)
        if u17.locked then
            return;
        end;

        u17.isViewing = true;
        u17.viewingStarted:Fire(true);

        if not p32 then
            u17:setState("Viewing", "User", u17);
        end;
    end);
    v21.SelectionLost:Connect(viewingEnded);
    v21.MouseButton1Down:Connect(function() -- Line: 358
        -- upvalues: u17 (copy), UserInputService (ref), u8 (ref), u31 (ref)
        if not u17.locked and UserInputService.PreferredInput == u8.mobile then
            u31 = u31 + 1;
            local u33 = u31;
            task.delay(0.2, function() -- Line: 362
                -- upvalues: u33 (copy), u31 (ref), u17 (ref)
                if u33 == u31 then
                    if u17.locked then
                        return;
                    end;

                    u17.isViewing = true;
                    u17.viewingStarted:Fire(true);
                    u17:setState("Viewing", "User", u17);
                end;
            end);
        end;
    end);
    v21.MouseButton1Up:Connect(function() -- Line: 369
        -- upvalues: u31 (ref)
        u31 = u31 + 1;
    end);
    local u34 = u17:getInstance("IconOverlay");
    u17.viewingStarted:Connect(function() -- Line: 375
        -- upvalues: u34 (copy), u17 (copy)
        u34.Visible = not u17.overlayDisabled;
    end);
    u17.viewingEnded:Connect(function() -- Line: 378
        -- upvalues: u34 (copy)
        u34.Visible = false;
    end);
    v18:add(u6:Connect(function(p35) -- Line: 383
        -- upvalues: u17 (copy)
        if p35 ~= u17 and (u17.deselectWhenOtherIconSelected and p35.deselectWhenOtherIconSelected) then
            u17:deselect("AutoDeselect", p35);
        end;
    end));
    local v36 = debug.info(2, "s");
    local v37 = string.split(v36, ".");
    local v38 = game;
    local v39 = nil;

    for _, v in pairs(v37) do
        v38 = v38:FindFirstChild(v);

        if not v38 then
            break;
        end;

        if v38:IsA("ScreenGui") then
            v39 = v38;
        end;
    end;

    if v38 and (v39 and v39.ResetOnSpawn == true) then
        u17.originsScreenGui = v39;
        Utility.localPlayerRespawned(function() -- Line: 409
            -- upvalues: u17 (copy)
            u17:destroy();
        end);
    end;

    u17.toggled:Connect(function(p40) -- Line: 415
        -- upvalues: u17 (copy), u4 (ref)
        u17.noticeChanged:Fire(u17.totalNotices);

        for i, _ in pairs(u17.childIconsDict) do
            local v41 = u4.getIconByUID(i);
            v41.noticeChanged:Fire(v41.totalNotices);

            if not p40 and v41.isSelected then
                for _, _ in pairs(v41.childIconsDict) do
                    v41:deselect("HideParentFeature", u17);
                end;
            end;
        end;
    end);
    u17.selected:Connect(function() -- Line: 438
        -- upvalues: u17 (copy), StarterGui (ref)
        if #u17.dropdownIcons > 0 then
            if StarterGui:GetCore("ChatActive") and u17.alignment ~= "Right" then
                u17.chatWasPreviouslyActive = true;
                StarterGui:SetCore("ChatActive", false);
            end;

            if StarterGui:GetCoreGuiEnabled("PlayerList") and u17.alignment ~= "Left" then
                u17.playerlistWasPreviouslyActive = true;
                StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false);
            end;
        end;
    end);
    u17.deselected:Connect(function() -- Line: 451
        -- upvalues: u17 (copy), StarterGui (ref)
        if u17.chatWasPreviouslyActive then
            u17.chatWasPreviouslyActive = nil;
            StarterGui:SetCore("ChatActive", true);
        end;

        if u17.playerlistWasPreviouslyActive then
            u17.playerlistWasPreviouslyActive = nil;
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true);
        end;
    end);
    task.delay(0.1, function() -- Line: 465
        -- upvalues: u17 (copy)
        if u17.activeState == "Deselected" then
            u17.stateChanged:Fire("Deselected");
            u17:refresh();
        end;
    end);
    u4.iconAdded:Fire(u17);

    return u17;
end;

function u4.setName(p42, p43) -- Line: 481
    p42.widget.Name = p43;
    p42.name = p43;

    return p42;
end;

function u4.setState(p44, p45, p46, p47) -- Line: 487
    -- upvalues: Utility (copy), u6 (copy)
    local v48 = Utility.formatStateName(p45 or (p44.isSelected and "Selected" or "Deselected"));

    if p44.activeState == v48 then
        return;
    end;

    local isSelected = p44.isSelected;
    p44.activeState = v48;

    if v48 == "Deselected" then
        p44.isSelected = false;

        if isSelected then
            p44.toggled:Fire(false, p46, p47);
            p44.deselected:Fire(p46, p47);
        end;

        p44:_setToggleItemsVisible(false, p46, p47);
    elseif v48 == "Selected" then
        p44.isSelected = true;

        if not isSelected then
            p44.toggled:Fire(true, p46, p47);
            p44.selected:Fire(p46, p47);
            u6:Fire(p44, p46, p47);
        end;

        p44:_setToggleItemsVisible(true, p46, p47);
    end;

    p44.stateChanged:Fire(v48, p46, p47);
end;

function u4.getInstance(u49, u50) -- Line: 520
    -- upvalues: Themes (copy)
    local v51 = u49.cachedNamesToInstances[u50];

    if v51 then
        return v51;
    end;

    local function cacheInstance(u52, u53) -- Line: 528
        -- upvalues: u49 (copy)
        if not u49.cachedInstances[u53] then
            local v54 = u53:GetAttribute("Collective");

            if v54 then
                v54 = u49.cachedCollectives[v54];
            end;

            if v54 then
                table.insert(v54, u53);
            end;

            u49.cachedNamesToInstances[u52] = u53;
            u49.cachedInstances[u53] = true;
            u53.Destroying:Once(function() -- Line: 538
                -- upvalues: u49 (ref), u52 (copy), u53 (copy)
                u49.cachedNamesToInstances[u52] = nil;
                u49.cachedInstances[u53] = nil;
            end);
        end;
    end;

    local widget = u49.widget;
    cacheInstance("Widget", widget);

    if u50 == "Widget" then
        return widget;
    end;

    local u55 = nil;

    local function scanChildren(p56) -- Line: 551
        -- upvalues: u49 (copy), Themes (ref), scanChildren (copy), cacheInstance (copy), u50 (copy), u55 (ref)
        for _, child in pairs(p56:GetChildren()) do
            local v57 = child:GetAttribute("WidgetUID");

            if not v57 or v57 == u49.UID then
                local v58 = Themes.getRealInstance(child) or child;
                scanChildren(v58);

                if v58:IsA("GuiBase") or (v58:IsA("UIBase") or v58:IsA("ValueBase")) then
                    local Name = v58.Name;
                    cacheInstance(Name, v58);

                    if Name == u50 then
                        u55 = v58;
                    end;
                end;
            end;
        end;
    end;

    scanChildren(widget);

    return u55;
end;

function u4.getCollective(p59, p60) -- Line: 580
    local v61 = p59.cachedCollectives[p60];

    if v61 then
        return v61;
    end;

    local v62 = {};

    for i, _ in pairs(p59.cachedInstances) do
        if i:GetAttribute("Collective") == p60 then
            table.insert(v62, i);
        end;
    end;

    p59.cachedCollectives[p60] = v62;

    return v62;
end;

function u4.getInstanceOrCollective(p63, p64) -- Line: 601
    local v65 = {};
    local v66 = p63:getInstance(p64);

    if v66 then
        table.insert(v65, v66);
    end;

    if #v65 == 0 then
        v65 = p63:getCollective(p64);
    end;

    return v65;
end;

function u4.getStateGroup(p67, p68) -- Line: 615
    local v69 = p68 or p67.activeState;
    local v70 = p67.appearance[v69];

    if not v70 then
        v70 = {};
        p67.appearance[v69] = v70;
    end;

    return v70;
end;

function u4.refreshAppearance(p71, p72, p73) -- Line: 625
    -- upvalues: Themes (copy)
    Themes.refresh(p71, p72, p73);

    return p71;
end;

function u4.refresh(p74) -- Line: 630
    p74:refreshAppearance(p74.widget);
    p74.updateSize:Fire();

    return p74;
end;

function u4.updateParent(p75) -- Line: 636
    -- upvalues: u4 (copy)
    local v76 = u4.getIconByUID(p75.parentIconUID);

    if v76 then
        v76.updateSize:Fire();
    end;
end;

function u4.setBehaviour(p77, p78, p79, p80, p81) -- Line: 643
    p77.customBehaviours[p78 .. "-" .. p79] = p80;

    if p81 then
        local v82 = p77:getInstanceOrCollective(p78);

        for _, v in pairs(v82) do
            p77:refreshAppearance(v, p79);
        end;
    end;
end;

function u4.modifyTheme(p83, p84, p85) -- Line: 656
    -- upvalues: Themes (copy)
    return p83, Themes.modify(p83, p84, p85);
end;

function u4.modifyChildTheme(p86, p87, p88) -- Line: 661
    -- upvalues: u4 (copy)
    p86.childModifications = p87;
    p86.childModificationsUID = p88;

    for i, _ in pairs(p86.childIconsDict) do
        u4.getIconByUID(i):modifyTheme(p87, p88);
    end;

    p86.childThemeModified:Fire();

    return p86;
end;

function u4.removeModification(p89, p90) -- Line: 674
    -- upvalues: Themes (copy)
    Themes.remove(p89, p90);

    return p89;
end;

function u4.removeModificationWith(p91, p92, p93, p94) -- Line: 679
    -- upvalues: Themes (copy)
    Themes.removeWith(p91, p92, p93, p94);

    return p91;
end;

function u4.setTheme(p95, p96) -- Line: 684
    -- upvalues: Themes (copy)
    Themes.set(p95, p96);

    return p95;
end;

function u4.setEnabled(p97, p98) -- Line: 689
    p97.isEnabled = p98;
    p97.enabled = p97.isEnabled;
    p97.widget.Visible = p98;
    p97:updateParent();

    return p97;
end;

function u4.select(p99, p100, p101) -- Line: 697
    p99:setState("Selected", p100, p101);

    return p99;
end;

function u4.deselect(p102, p103, p104) -- Line: 702
    p102:setState("Deselected", p103, p104);

    return p102;
end;

function u4.notify(p105, p106, p107) -- Line: 707
    -- upvalues: Elements (copy), u4 (copy)
    if not p105.notice then
        p105.notice = require(Elements.Notice)(p105, u4);
    end;

    p105.noticeStarted:Fire(p106, p107);

    return p105;
end;

function u4.clearNotices(p108) -- Line: 721
    p108.endNotices:Fire();

    return p108;
end;

function u4.disableOverlay(p109, p110) -- Line: 726
    p109.overlayDisabled = p110;

    return p109;
end;

u4.disableStateOverlay = u4.disableOverlay;

function u4.setImage(p111, u112, p113) -- Line: 732
    -- upvalues: ContentProvider (copy)
    p111:modifyTheme({
        "IconImage",
        "Image",
        u112,
        p113
    });
    task.spawn(function() -- Line: 736
        -- upvalues: u112 (copy), ContentProvider (ref)
        local v114;

        if tonumber(u112) then
            v114 = `rbxassetid://{u112}`;
        else
            v114 = u112;
        end;

        if ContentProvider:GetAssetFetchStatus(v114) ~= Enum.AssetFetchStatus.Success then
            pcall(ContentProvider.PreloadAsync, ContentProvider, { v114 });
        end;
    end);

    return p111;
end;

function u4.setLabel(p115, p116, p117) -- Line: 748
    p115:modifyTheme({
        "IconLabel",
        "Text",
        p116,
        p117
    });

    return p115;
end;

function u4.setOrder(p118, p119, p120) -- Line: 753
    local v121 = p119 * 100;
    p118:modifyTheme({
        "IconSpot",
        "LayoutOrder",
        v121,
        p120
    });
    p118:modifyTheme({
        "Widget",
        "LayoutOrder",
        v121,
        p120
    });

    return p118;
end;

function u4.setCornerRadius(p122, p123, p124) -- Line: 762
    p122:modifyTheme({
        "IconCorners",
        "CornerRadius",
        p123,
        p124
    });

    return p122;
end;

function u4.align(p125, p126, p127) -- Line: 767
    -- upvalues: u4 (copy)
    local v128 = tostring(p126):lower();
    local v129 = (v128 == "mid" or v128 == "centre") and "center" or v128;
    local v130 = v129 ~= "left" and (v129 ~= "center" and v129 ~= "right") and "left" or v129;
    local v131 = v130 == "center" and u4.container.TopbarCentered or u4.container.TopbarStandard;
    local Holders = v131.Holders;
    local v132 = string.upper((string.sub(v130, 1, 1))) .. string.sub(v130, 2);

    if not p127 then
        p125.originalAlignment = v132;
    end;

    local joinedFrame = p125.joinedFrame;
    local v133 = Holders[v132];
    p125.screenGui = v131;
    p125.alignmentHolder = v133;

    if not p125.isDestroyed then
        p125.widget.Parent = joinedFrame or v133;
    end;

    p125.alignment = v132;
    p125.alignmentChanged:Fire(v132);
    u4.iconChanged:Fire(p125);

    return p125;
end;

u4.setAlignment = u4.align;

function u4.setLeft(p134) -- Line: 796
    p134:setAlignment("Left");

    return p134;
end;

function u4.setMid(p135) -- Line: 801
    p135:setAlignment("Center");

    return p135;
end;

function u4.setRight(p136) -- Line: 806
    p136:setAlignment("Right");

    return p136;
end;

function u4.setWidth(p137, p138, p139) -- Line: 811
    p137:modifyTheme({
        "Widget",
        "DesiredWidth",
        p138,
        p139
    });

    return p137;
end;

function u4.setImageScale(p140, p141, p142) -- Line: 819
    p140:modifyTheme({
        "IconImageScale",
        "Value",
        p141,
        p142
    });

    return p140;
end;

function u4.setImageRatio(p143, p144, p145) -- Line: 824
    p143:modifyTheme({
        "IconImageRatio",
        "AspectRatio",
        p144,
        p145
    });

    return p143;
end;

function u4.setTextSize(p146, p147, p148) -- Line: 829
    p146:modifyTheme({
        "IconLabel",
        "TextSize",
        p147,
        p148
    });

    return p146;
end;

function u4.setTextFont(p149, p150, p151, p152, p153) -- Line: 834
    local v154 = p151 or Enum.FontWeight.Regular;
    local v155 = p152 or Enum.FontStyle.Normal;
    local v156 = nil;
    local v157 = typeof(p150);

    if v157 == "number" then
        v156 = Font.fromId(p150, v154, v155);
    elseif v157 == "EnumItem" then
        v156 = Font.fromEnum(p150);
    elseif v157 == "string" and not p150:match("rbxasset") then
        v156 = Font.fromName(p150, v154, v155);
    end;

    p149:modifyTheme({
        "IconLabel",
        "FontFace",
        v156 or Font.new(p150, v154, v155),
        p153
    });

    return p149;
end;

function u4.setTextColor(p158, p159, p160) -- Line: 855
    if p159 == nil or (p159 == "" or (type(p159) ~= "userdata" or typeof(p159) ~= "Color3")) then
        if p159 ~= nil then
            local _ = p159 == "";
        end;

        p159 = Color3.fromRGB(255, 255, 255);
    end;

    p158:modifyTheme({
        "IconLabel",
        "TextColor3",
        p159,
        p160
    });

    return p158;
end;

function u4.bindToggleItem(p161, p162) -- Line: 866
    if not (p162:IsA("GuiObject") or p162:IsA("LayerCollector")) then
        error("Toggle item must be a GuiObject or LayerCollector!");
    end;

    p161.toggleItems[p162] = true;
    p161:_updateSelectionInstances();

    return p161;
end;

function u4.unbindToggleItem(p163, p164) -- Line: 875
    p163.toggleItems[p164] = nil;
    p163:_updateSelectionInstances();

    return p163;
end;

function u4._updateSelectionInstances(p165) -- Line: 881
    for i, _ in pairs(p165.toggleItems) do
        local v166 = {};

        for _, descendant in pairs(i:GetDescendants()) do
            if (descendant:IsA("TextButton") or descendant:IsA("ImageButton")) and descendant.Active then
                table.insert(v166, descendant);
            end;
        end;

        p165.toggleItems[i] = v166;
    end;
end;

function u4._setToggleItemsVisible(p167, p168, p169, p170) -- Line: 895
    for i, _ in pairs(p167.toggleItems) do
        if not p170 or (p170 == p167 or p170.toggleItems[i] == nil) then
            i[i:IsA("LayerCollector") and "Enabled" or "Visible"] = p168;
        end;
    end;
end;

function u4.bindEvent(u171, p172, u173) -- Line: 907
    local v174 = u171[p172];
    local v175;

    if v174 then
        if typeof(v174) == "table" then
            v175 = v174.Connect;
        else
            v175 = false;
        end;
    else
        v175 = v174;
    end;

    assert(v175, "argument[1] must be a valid topbarplus icon event name!");
    local v176 = typeof(u173) == "function";
    assert(v176, "argument[2] must be a function!");
    u171.bindedEvents[p172] = v174:Connect(function(...) -- Line: 911
        -- upvalues: u173 (copy), u171 (copy)
        u173(u171, ...);
    end);

    return u171;
end;

function u4.unbindEvent(p177, p178) -- Line: 917
    local v179 = p177.bindedEvents[p178];

    if v179 then
        v179:Disconnect();
        p177.bindedEvents[p178] = nil;
    end;

    return p177;
end;

function u4.bindToggleKey(p180, p181) -- Line: 926
    local v182 = typeof(p181) == "EnumItem";
    assert(v182, "argument[1] must be a KeyCode EnumItem!");
    p180.bindedToggleKeys[p181] = true;
    p180.toggleKeyAdded:Fire(p181);
    p180:setCaption("_hotkey_");

    return p180;
end;

function u4.unbindToggleKey(p183, p184) -- Line: 934
    local v185 = typeof(p184) == "EnumItem";
    assert(v185, "argument[1] must be a KeyCode EnumItem!");
    p183.bindedToggleKeys[p184] = nil;

    return p183;
end;

function u4.call(u186, u187, ...) -- Line: 940
    local u188 = table.pack(...);
    task.spawn(function() -- Line: 942
        -- upvalues: u187 (copy), u186 (copy), u188 (copy)
        u187(u186, table.unpack(u188));
    end);

    return u186;
end;

function u4.addToJanitor(p189, p190, p191, p192) -- Line: 948
    p189.janitor:add(p190, p191, p192);

    return p189;
end;

function u4.lock(p193) -- Line: 953
    p193:getInstance("ClickRegion").Visible = false;
    p193.locked = true;

    return p193;
end;

function u4.unlock(p194) -- Line: 961
    p194:getInstance("ClickRegion").Visible = true;
    p194.locked = false;

    return p194;
end;

function u4.debounce(p195, p196) -- Line: 968
    p195:lock();
    task.wait(p196);
    p195:unlock();

    return p195;
end;

function u4.autoDeselect(p197, p198) -- Line: 975
    p197.deselectWhenOtherIconSelected = p198 == nil and true or p198;

    return p197;
end;

function u4.oneClick(u199, p200) -- Line: 985
    local singleClickJanitor = u199.singleClickJanitor;
    singleClickJanitor:clean();

    if p200 or p200 == nil then
        singleClickJanitor:add(u199.selected:Connect(function() -- Line: 991
            -- upvalues: u199 (copy)
            u199:deselect("OneClick", u199);
        end));
    end;

    u199.oneClickEnabled = true;

    return u199;
end;

function u4.setCaption(p201, p202) -- Line: 999
    -- upvalues: Elements (copy)
    if p202 == "_hotkey_" and p201.captionText then
        return p201;
    end;

    local captionJanitor = p201.captionJanitor;
    p201.captionJanitor:clean();

    if not p202 or p202 == "" then
        p201.caption = nil;
        p201.captionText = nil;

        return p201;
    end;

    local v203 = captionJanitor:add(require(Elements.Caption)(p201));
    v203:SetAttribute("CaptionText", p202);
    p201.caption = v203;
    p201.captionText = p202;

    return p201;
end;

function u4.setCaptionHint(p204, p205) -- Line: 1017
    local v206 = typeof(p205) == "EnumItem";
    assert(v206, "argument[1] must be a KeyCode EnumItem!");
    p204.fakeToggleKey = p205;
    p204.fakeToggleKeyChanged:Fire(p205);
    p204:setCaption("_hotkey_");

    return p204;
end;

function u4.leave(p207) -- Line: 1025
    p207.joinJanitor:clean();

    return p207;
end;

function u4.joinMenu(p208, p209) -- Line: 1031
    -- upvalues: Utility (copy)
    Utility.joinFeature(p208, p209, p209.menuIcons, p209:getInstance("Menu"));
    p209.menuChildAdded:Fire(p208);

    return p208;
end;

function u4.setMenu(p210, p211) -- Line: 1037
    p210.menuSet:Fire(p211);

    return p210;
end;

function u4.setFixedMenu(p212, p213) -- Line: 1042
    p212:freezeMenu(p213);
    p212:setMenu(p213);
end;

u4.setFrozenMenu = u4.setFixedMenu;

function u4.freezeMenu(u214) -- Line: 1048
    u214:select("FrozenMenu", u214);
    u214:bindEvent("deselected", function(p215) -- Line: 1052
        -- upvalues: u214 (copy)
        p215:select("FrozenMenu", u214);
    end);
    u214:modifyTheme({ "IconSpot", "Visible", false });
end;

function u4.joinDropdown(p216, p217) -- Line: 1058
    -- upvalues: Utility (copy)
    p217:getDropdown();
    Utility.joinFeature(p216, p217, p217.dropdownIcons, p217:getInstance("DropdownScroller"));
    p217.dropdownChildAdded:Fire(p216);

    return p216;
end;

function u4.getDropdown(p218) -- Line: 1065
    -- upvalues: Elements (copy)
    local dropdown = p218.dropdown;

    if not dropdown then
        dropdown = require(Elements.Dropdown)(p218);
        p218.dropdown = dropdown;
        p218:clipOutside(dropdown);
    end;

    return dropdown;
end;

function u4.setDropdown(p219, p220) -- Line: 1075
    p219:getDropdown();
    p219.dropdownSet:Fire(p220);

    return p219;
end;

function u4.clipOutside(p221, p222) -- Line: 1081
    -- upvalues: Utility (copy)
    local v223 = Utility.clipOutside(p221, p222);
    p221:refreshAppearance(p222);

    return p221, v223;
end;

function u4.setIndicator(p224, p225) -- Line: 1092
    -- upvalues: Elements (copy), u4 (copy)
    if not p224.indicator then
        p224.indicator = p224.janitor:add(require(Elements.Indicator)(p224, u4));
    end;

    p224.indicatorSet:Fire(p225);
end;

function u4.convertLabelToNumberSpinner(u226, u227, u228) -- Line: 1104
    task.defer(function() -- Line: 1105
        -- upvalues: u226 (copy), u227 (copy), u228 (copy)
        local u229 = u226:getInstance("IconLabel");
        u229.Transparency = 1;
        u227.Parent = u229.Parent;
        u227.Size = UDim2.fromScale(1, 1);
        u227.AnchorPoint = Vector2.new(0.5, 0.5);
        u227.Position = UDim2.new(0.5, 0, 0.5, 0);
        u227.TextXAlignment = Enum.TextXAlignment.Center;
        u227.ClipsDescendants = false;

        for _, v in ipairs({ "FontFace", "BorderSizePixel", "BorderColor3", "Rotation", "TextStrokeTransparency", "TextStrokeColor3", "TextStrokeTransparency", "TextColor3" }) do
            u227[v] = u229[v];
            u226:addToJanitor(u229:GetPropertyChangedSignal(v):Connect(function() -- Line: 1128
                -- upvalues: u227 (ref), v (copy), u229 (copy)
                u227[v] = u229[v];
            end));
        end;

        local function getSpinnerSizeAndDigitCount() -- Line: 1135
            -- upvalues: u227 (ref)
            local v230 = 0;
            local v231 = 0;

            for _, child in u227.Frame:GetChildren() do
                local v232 = string.lower(child.Name);

                if v232 == "digit" then
                    v230 = v230 + child.AbsoluteSize.X;
                    v231 = v231 + 1;
                elseif (v232 == "prefix" or (v232 == "suffix" or v232 == "comma")) and child.Text ~= "" then
                    v230 = v230 + child.AbsoluteSize.X;
                    v231 = v231 + 1;
                end;
            end;

            return v230, v231;
        end;

        local function getLabelParentContainerXSize() -- Line: 1153
            -- upvalues: u229 (copy), u227 (ref)
            local Parent = u229.Parent;

            if Parent then
                Parent = Parent.Parent;
            end;

            if Parent == nil then
                return 0;
            end;

            if Parent.IconImage.Visible == true then
                return u227.Frame.AbsoluteSize.X + u229.Parent.Parent.IconImage.AbsoluteSize.X;
            end;

            return Parent.AbsoluteSize.X;
        end;

        local function getNumberSpinnerXSize() -- Line: 1165
            -- upvalues: u227 (ref)
            return u227.Frame.AbsoluteSize.X;
        end;

        local function adjustSize() -- Line: 1169
            -- upvalues: getSpinnerSizeAndDigitCount (copy), u226 (ref), u227 (ref), u229 (copy)
            local v233, v234 = getSpinnerSizeAndDigitCount();

            if v234 < 18 then
                u226:setLabel(u227.Value);
            end;

            local X = u227.Frame.AbsoluteSize.X;

            while v233 < X and u226.isDestroyed ~= true do
                task.wait(0.05);

                if v234 > 0 and v234 < 8 then
                    u227.TextSize = u229.TextSize;
                    break;
                end;

                local v235 = u227;
                v235.TextSize = v235.TextSize + 1;
                X = u227.Frame.AbsoluteSize.X;
                v233, v234 = getSpinnerSizeAndDigitCount();
            end;

            local Parent = u229.Parent;

            if Parent then
                Parent = Parent.Parent;
            end;

            local v236;

            if Parent == nil then
                v236 = 0;
            elseif Parent.IconImage.Visible == true then
                v236 = u227.Frame.AbsoluteSize.X + u229.Parent.Parent.IconImage.AbsoluteSize.X;
            else
                v236 = Parent.AbsoluteSize.X;
            end;

            while v236 < v233 and u226.isDestroyed ~= true do
                task.wait(0.05);

                if v234 < 8 and v234 > 0 then
                    u227.TextSize = u229.TextSize;

                    return;
                end;

                local v237 = u227;
                v237.TextSize = v237.TextSize - 1;
                local Parent2 = u229.Parent;

                if Parent2 then
                    Parent2 = Parent2.Parent;
                end;

                if Parent2 == nil then
                    v236 = 0;
                elseif Parent2.IconImage.Visible == true then
                    v236 = u227.Frame.AbsoluteSize.X + u229.Parent.Parent.IconImage.AbsoluteSize.X;
                else
                    v236 = Parent2.AbsoluteSize.X;
                end;

                v233, v234 = getSpinnerSizeAndDigitCount();
            end;
        end;

        u226:addToJanitor(u227.Frame.ChildAdded:Connect(adjustSize));
        u226:addToJanitor(u227.Frame.ChildRemoved:Connect(adjustSize));
        u226:addToJanitor(u226.iconAdded:Connect(function() -- Line: 1207
            -- upvalues: adjustSize (copy)
            task.wait(1);
            adjustSize();
        end));
        u226:updateParent();
        u227.Name = "LabelSpinner";
        u227.Prefix = "$";
        u227.Commas = true;
        u227.Decimals = 0;
        u227.Duration = 0.25;
        u227.Value = 10;
        task.wait(0.2);

        if typeof(u228) == "function" then
            u228();
        end;
    end);

    return u226;
end;

function u4.destroy(p238) -- Line: 1234
    -- upvalues: u4 (copy)
    if p238.isDestroyed then
        return;
    end;

    p238:clearNotices();

    if p238.parentIconUID then
        p238:leave();
    end;

    p238.isDestroyed = true;
    p238.janitor:clean();
    u4.iconRemoved:Fire(p238);
end;

u4.Destroy = u4.destroy;

return u4;