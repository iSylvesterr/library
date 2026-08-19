-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out");
local BaseComponent = v1.BaseComponent;
local Component = v1.Component;
local Janitor = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "janitor", "src").Janitor;
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services");
local CollectionService = v2.CollectionService;
local ReplicatedStorage = v2.ReplicatedStorage;
local RunService = v2.RunService;
local Workspace = v2.Workspace;
local Player = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "player", "playerConstants").Player;
local v3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "network", "PolisherNetwork");
local PolisherEvents = v3.PolisherEvents;
local PolisherFunctions = v3.PolisherFunctions;
local promptMonetizedItem = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "monetization", "promptMonetizedItem").promptMonetizedItem;
local Notification = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "Notification").Notification;
local v4 = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "itemLabels", "ItemLabelStyles");
local CONDITION_COLORS = v4.CONDITION_COLORS;
local ItemLabelStyles = v4.ItemLabelStyles;
local Conditions = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "items", "Conditions").Conditions;
local Items = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "items", "Items").Items;
local skipPolishProduct = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "monetization", "SkipPolishTiers").skipPolishProduct;
local v5 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "plot", "Polishing");
local POLISH_ENDS_ATTRIBUTE = v5.POLISH_ENDS_ATTRIBUTE;
local POLISH_FROM_ATTRIBUTE = v5.POLISH_FROM_ATTRIBUTE;
local POLISH_ITEM_ID_ATTRIBUTE = v5.POLISH_ITEM_ID_ATTRIBUTE;
local POLISH_ITEM_UID_ATTRIBUTE = v5.POLISH_ITEM_UID_ATTRIBUTE;
local POLISH_KG_ATTRIBUTE = v5.POLISH_KG_ATTRIBUTE;
local POLISH_STARTED_ATTRIBUTE = v5.POLISH_STARTED_ATTRIBUTE;
local POLISH_TO_ATTRIBUTE = v5.POLISH_TO_ATTRIBUTE;
local POLISHER_LEVEL_ATTRIBUTE = v5.POLISHER_LEVEL_ATTRIBUTE;
local POLISHER_MAX_LEVEL = v5.POLISHER_MAX_LEVEL;
local POLISHER_MIN_LEVEL = v5.POLISHER_MIN_LEVEL;
local POLISHER_UNLOCKED_ATTRIBUTE = v5.POLISHER_UNLOCKED_ATTRIBUTE;
local polisherSpeedFor = v5.polisherSpeedFor;
local polisherUpgradeCostFor = v5.polisherUpgradeCostFor;
local SECTION_UNLOCKED_ATTRIBUTE = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "plot", "PlotSections").SECTION_UNLOCKED_ATTRIBUTE;
local robuxIcon = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "symbols", "stringSymbols").robuxIcon;
local v6 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "ui", "TextEffectTags");
local RAINBOW_SEQUENCE = v6.RAINBOW_SEQUENCE;
local RAINBOW_TAG = v6.RAINBOW_TAG;
local formatAbbrevMoney = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "formatting", "formatAbbrevMoney").formatAbbrevMoney;
local formatPolishTimer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "formatting", "formatSeconds").formatPolishTimer;
local WFChain = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "instances", "WFChain").WFChain;
local ItemModel = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "items", "ItemModel").ItemModel;
local getMonetizedItemPrice = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "monetization", "getMonetizedItemPrice").getMonetizedItemPrice;
local u7 = Color3.new(1, 1, 1);

local function bottomFractionOf(p8) -- Line: 101
    return p8.Position.Y.Scale + p8.Size.Y.Scale * (1 - p8.AnchorPoint.Y);
end;

local u9 = setmetatable({}, {
    __tostring = function() -- Line: 108, Name: __tostring
        return "PolisherComponent";
    end,

    __index = BaseComponent
});
u9.__index = u9;

function u9.new(...) -- Line: 114
    -- upvalues: u9 (ref)
    local v10 = setmetatable({}, u9);

    return v10:constructor(...) or v10;
end;

function u9.constructor(p11, p12) -- Line: 118
    -- upvalues: BaseComponent (copy), Janitor (copy)
    BaseComponent.constructor(p11);
    p11.surfaceButtons = p12;
    p11.janitor = Janitor.new();
    p11.titleRefreshQueued = false;
    p11.outward = Vector3.new(0, 0, 1);
    p11.lateral = Vector3.new(1, 0, 0);
    p11.destroyed = false;
end;

function u9.onStart(u13) -- Line: 127
    -- upvalues: robuxIcon (copy), POLISH_ITEM_UID_ATTRIBUTE (copy), POLISHER_LEVEL_ATTRIBUTE (copy), POLISHER_UNLOCKED_ATTRIBUTE (copy), POLISH_STARTED_ATTRIBUTE (copy), POLISH_ENDS_ATTRIBUTE (copy), SECTION_UNLOCKED_ATTRIBUTE (copy), u9 (ref), WFChain (copy)
    local TableTop = u13.instance:FindFirstChild("TableTop");
    local Decor = u13.instance:FindFirstChild("Decor");

    if Decor ~= nil then
        Decor = Decor:FindFirstChild("Sponge");
    end;

    local v14;

    if TableTop == nil then
        v14 = TableTop;
    else
        v14 = TableTop:IsA("BasePart");
    end;

    local v15 = not v14;

    if not v15 then
        local v16;

        if Decor == nil then
            v16 = Decor;
        else
            v16 = Decor:IsA("BasePart");
        end;

        v15 = not v16;
    end;

    if v15 then
        return nil;
    end;

    u13.tableTop = TableTop;
    u13.spongeTemplate = Decor;
    u13.plot = u13:findAncestor(function(p17) -- Line: 151
        return string.match(p17.Name, "^Plot_%d+$") ~= nil;
    end);
    u13.section = u13:findAncestor(function(p18) -- Line: 154
        return p18.Name == "Polishing";
    end);
    u13.outward = u13:resolveOutward();
    u13.lateral = u13.outward:Cross(Vector3.new(0, 1, 0)).Unit;
    local ProximityPrompt = Instance.new("ProximityPrompt");
    ProximityPrompt.RequiresLineOfSight = false;
    ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom;
    ProximityPrompt.MaxActivationDistance = 12;
    ProximityPrompt.HoldDuration = 0.5;
    ProximityPrompt.Enabled = false;
    ProximityPrompt.Parent = TableTop;
    u13.prompt = ProximityPrompt;
    u13.janitor:Add(ProximityPrompt, "Destroy");
    u13.janitor:Add(ProximityPrompt.Triggered:Connect(function() -- Line: 168
        -- upvalues: u13 (copy)
        return u13:onTriggered();
    end), "Disconnect");
    local ProximityPrompt2 = Instance.new("ProximityPrompt");
    ProximityPrompt2.RequiresLineOfSight = false;
    ProximityPrompt2.Style = Enum.ProximityPromptStyle.Custom;
    ProximityPrompt2.MaxActivationDistance = 12;
    ProximityPrompt2.HoldDuration = 0.05;
    ProximityPrompt2.ObjectText = "Skip Polish";
    ProximityPrompt2.ActionText = robuxIcon;
    ProximityPrompt2:SetAttribute("Theme", "Robux");
    ProximityPrompt2.Enabled = false;
    ProximityPrompt2.Parent = TableTop;
    u13.skipPrompt = ProximityPrompt2;
    u13.janitor:Add(ProximityPrompt2, "Destroy");
    u13.janitor:Add(ProximityPrompt2.Triggered:Connect(function() -- Line: 183
        -- upvalues: u13 (copy)
        return u13:onSkipTriggered();
    end), "Disconnect");
    u13:bindUpgradeUi();
    u13.janitor:Add(u13.instance:GetAttributeChangedSignal(POLISH_ITEM_UID_ATTRIBUTE):Connect(function() -- Line: 187
        -- upvalues: u13 (copy)
        return u13:onItemChanged();
    end), "Disconnect");
    u13.janitor:Add(u13.instance:GetAttributeChangedSignal(POLISHER_LEVEL_ATTRIBUTE):Connect(function() -- Line: 190
        -- upvalues: u13 (copy)
        return u13:refreshUpgradeUi();
    end), "Disconnect");
    u13.janitor:Add(u13.instance:GetAttributeChangedSignal(POLISHER_UNLOCKED_ATTRIBUTE):Connect(function() -- Line: 193
        -- upvalues: u13 (copy)
        return u13:onAvailabilityChanged();
    end), "Disconnect");

    for _, v in { POLISH_STARTED_ATTRIBUTE, POLISH_ENDS_ATTRIBUTE } do
        u13.janitor:Add(u13.instance:GetAttributeChangedSignal(v):Connect(function() -- Line: 197
            -- upvalues: u13 (copy)
            return u13:onScheduleChanged();
        end), "Disconnect");
    end;

    if u13.plot then
        u13.janitor:Add(u13.plot:GetAttributeChangedSignal("OwnerUserId"):Connect(function() -- Line: 202
            -- upvalues: u13 (copy)
            return u13:onAvailabilityChanged();
        end), "Disconnect");
    end;

    if u13.section then
        u13.janitor:Add(u13.section:GetAttributeChangedSignal(SECTION_UNLOCKED_ATTRIBUTE):Connect(function() -- Line: 207
            -- upvalues: u13 (copy)
            return u13:onAvailabilityChanged();
        end), "Disconnect");
    end;

    u9.instances[u13] = true;
    u9:bindCharacter();
    u13.title = WFChain(u13.instance, "Title", "BillboardGui");
    u13:refreshUpgradeUi();
    u13:rebuildDisplay();
    u13:refreshPrompt();
    u13:refreshTitle();
end;

function u9.destroy(p19) -- Line: 221
    -- upvalues: u9 (ref), BaseComponent (copy)
    p19.destroyed = true;
    u9.instances[p19] = nil;
    u9.animating[p19] = nil;
    local display = p19.display;

    if display ~= nil then
        display.janitor:Destroy();
    end;

    p19.janitor:Destroy();
    BaseComponent.destroy(p19);
end;

function u9.ensureSharedLoop(p20) -- Line: 236
    -- upvalues: u9 (ref), RunService (copy), Workspace (copy)
    if u9.loopStarted then
        return nil;
    end;

    u9.loopStarted = true;
    RunService.RenderStepped:Connect(function(p21) -- Line: 241
        -- upvalues: Workspace (ref), u9 (ref)
        local v22 = os.clock();
        local v23 = Workspace:GetServerTimeNow();
        local v24 = math.sin(v22 * 2) * 0.45;
        local v25 = CFrame.Angles(0, v22 * 0.9, 0);
        local v26 = Vector3.new(0, v24, 0);

        for i in u9.animating do
            i:step(v22, v23, p21, v26, v25);
        end;
    end);
end;

function u9.bindCharacter(p27) -- Line: 252
    -- upvalues: u9 (ref), Player (copy)
    if u9.characterBound then
        return nil;
    end;

    u9.characterBound = true;

    local function v31(p28) -- Line: 257
        -- upvalues: u9 (ref)
        u9.characterJanitor:Add(p28.ChildAdded:Connect(function(p29) -- Line: 258
            -- upvalues: u9 (ref)
            if p29:IsA("Tool") then
                u9:queueRefresh();
            end;
        end), "Disconnect", "childAdded");
        u9.characterJanitor:Add(p28.ChildRemoved:Connect(function(p30) -- Line: 263
            -- upvalues: u9 (ref)
            if p30:IsA("Tool") then
                u9:queueRefresh();
            end;
        end), "Disconnect", "childRemoved");
        u9:queueRefresh();
    end;

    if Player.Character then
        v31(Player.Character);
    end;

    Player.CharacterAdded:Connect(v31);
end;

function u9.queueRefresh(p32) -- Line: 275
    -- upvalues: u9 (ref)
    if u9.refreshQueued then
        return nil;
    end;

    u9.refreshQueued = true;
    task.defer(function() -- Line: 280
        -- upvalues: u9 (ref)
        u9.refreshQueued = false;
        local v33 = u9:findHeldTool();

        for i in u9.instances do
            i:refreshPrompt(v33);
        end;
    end);
end;

function u9.findHeldTool(p34) -- Line: 288
    -- upvalues: Player (copy)
    local Character = Player.Character;

    if not Character then
        return nil;
    end;

    for _, child in Character:GetChildren() do
        if child:IsA("Tool") and child:GetAttribute("itemId") ~= nil then
            return child;
        end;
    end;

    return nil;
end;

function u9.findAncestor(p35, p36) -- Line: 300
    local Parent = p35.instance.Parent;

    while Parent do
        if Parent:IsA("Model") and p36(Parent) then
            return Parent;
        end;

        Parent = Parent.Parent;
    end;

    return nil;
end;

function u9.resolveOutward(p37) -- Line: 310
    local plot = p37.plot;

    if not plot then
        return Vector3.new(0, 0, 1);
    end;

    local v38 = (p37.tableTop.Position - plot:GetPivot().Position) * Vector3.new(1, 0, 1);

    return v38.Magnitude <= 0.05 and Vector3.new(0, 0, 1) or v38.Unit;
end;

function u9.isOwner(p39) -- Line: 321
    -- upvalues: Player (copy)
    local plot = p39.plot;

    if plot ~= nil then
        plot = plot:GetAttribute("OwnerUserId");
    end;

    return plot == Player.UserId;
end;

function u9.isAvailable(p40) -- Line: 328
    -- upvalues: SECTION_UNLOCKED_ATTRIBUTE (copy), POLISHER_UNLOCKED_ATTRIBUTE (copy)
    local v41 = p40:isOwner();

    if v41 then
        local section = p40.section;

        if section ~= nil then
            section = section:GetAttribute(SECTION_UNLOCKED_ATTRIBUTE);
        end;

        v41 = section == true and p40.instance:GetAttribute(POLISHER_UNLOCKED_ATTRIBUTE) == true;
    end;

    return v41;
end;

function u9.isOccupied(p42) -- Line: 342
    -- upvalues: POLISH_ITEM_UID_ATTRIBUTE (copy)
    local v43 = p42.instance:GetAttribute(POLISH_ITEM_UID_ATTRIBUTE);

    return (v43 == nil and "" or v43) ~= "";
end;

function u9.level(p44) -- Line: 349
    -- upvalues: POLISHER_LEVEL_ATTRIBUTE (copy), POLISHER_MIN_LEVEL (copy), POLISHER_MAX_LEVEL (copy)
    local v45 = p44.instance:GetAttribute(POLISHER_LEVEL_ATTRIBUTE);

    if type(v45) == "number" then
        return math.clamp(v45, POLISHER_MIN_LEVEL, POLISHER_MAX_LEVEL);
    end;

    return POLISHER_MIN_LEVEL;
end;

function u9.onAvailabilityChanged(p46) -- Line: 353
    p46:refreshPrompt();
    p46:refreshUpgradeUi();
    p46:refreshTitle();
end;

function u9.onScheduleChanged(p47) -- Line: 358
    -- upvalues: POLISH_STARTED_ATTRIBUTE (copy), POLISH_ENDS_ATTRIBUTE (copy)
    local display = p47.display;

    if not display or display.completed then
        return nil;
    end;

    local v48 = p47.instance:GetAttribute(POLISH_STARTED_ATTRIBUTE);
    local v49 = p47.instance:GetAttribute(POLISH_ENDS_ATTRIBUTE);

    if type(v48) ~= "number" or (type(v49) ~= "number" or v49 <= v48) then
        return nil;
    end;

    display.startedAt = v48;
    display.endsAt = v49;
    display.shownSecond = -1;
end;

function u9.refreshTitle(u50) -- Line: 372
    if u50.titleRefreshQueued then
        return nil;
    end;

    u50.titleRefreshQueued = true;
    task.defer(function() -- Line: 377
        -- upvalues: u50 (copy)
        u50.titleRefreshQueued = false;

        if u50.destroyed or not u50.title then
            return nil;
        end;

        local title = u50.title;
        local v51 = u50:isAvailable() and not u50:isOccupied();
        title.Enabled = v51;
    end);
end;

function u9.refreshPrompt(p52, p53) -- Line: 385
    -- upvalues: u9 (ref)
    if p53 == nil then
        p53 = u9:findHeldTool();
    end;

    if not p52.prompt then
        return nil;
    end;

    p52:refreshSkipPrompt();

    if not p52:isAvailable() then
        p52.prompt.Enabled = false;

        return nil;
    end;

    if p52:isOccupied() then
        p52.prompt.ActionText = "Pick Up";
        local display = p52.display;

        if display ~= nil then
            display = display.completed;
        end;

        p52.prompt.Enabled = display == true;

        return nil;
    end;

    if p53 then
        p52.prompt.ActionText = "Polish Item";
        p52.prompt.Enabled = true;

        return nil;
    end;

    p52.prompt.Enabled = false;
end;

function u9.refreshSkipPrompt(p54) -- Line: 413
    if not p54.skipPrompt then
        return nil;
    end;

    local v55 = p54:isAvailable() and p54:isOccupied();

    if v55 then
        local display = p54.display;

        if display ~= nil then
            display = display.completed;
        end;

        v55 = display == false;
    end;

    p54.skipPrompt.Enabled = v55;
end;

function u9.refreshSkipPrice(u56, p57) -- Line: 427
    -- upvalues: skipPolishProduct (copy), robuxIcon (copy), RuntimeLib (copy), getMonetizedItemPrice (copy)
    local u58 = skipPolishProduct(p57);

    if u56.skipProduct == u58 then
        return nil;
    end;

    u56.skipProduct = u58;
    u56.skipPrompt.ActionText = robuxIcon;
    task.spawn(RuntimeLib.async(function() -- Line: 434
        -- upvalues: RuntimeLib (ref), getMonetizedItemPrice (ref), u58 (copy), u56 (copy), robuxIcon (ref)
        local v59 = RuntimeLib.await(getMonetizedItemPrice(u58));

        if u56.destroyed or u56.skipProduct ~= u58 then
            return nil;
        end;

        u56.skipPrompt.ActionText = `{robuxIcon}{v59}`;
    end));
end;

function u9.onSkipTriggered(p60) -- Line: 442
    -- upvalues: PolisherEvents (copy), promptMonetizedItem (copy)
    if not (p60:isAvailable() and p60:isOccupied()) then
        return nil;
    end;

    local display = p60.display;

    if display ~= nil then
        display = display.completed;
    end;

    if display ~= false then
        return nil;
    end;

    local skipProduct = p60.skipProduct;

    if skipProduct == nil then
        return nil;
    end;

    PolisherEvents.setSkipPolishIntent:fire(p60.attributes.Slot);
    promptMonetizedItem(skipProduct);
end;

function u9.onTriggered(p61) -- Line: 460
    -- upvalues: PolisherFunctions (copy), u9 (ref), Notification (copy), RuntimeLib (copy)
    if not p61:isAvailable() then
        return nil;
    end;

    local Slot = p61.attributes.Slot;

    if p61:isOccupied() then
        local display = p61.display;

        if display ~= nil then
            display = display.completed;
        end;

        if display ~= true then
            return nil;
        end;

        PolisherFunctions.collectPolish:invoke(Slot):catch(function() -- Line: 473
            return nil;
        end);

        return nil;
    end;

    local v62 = u9:findHeldTool();

    if not v62 then
        return nil;
    end;

    if v62:GetAttribute("dirty") ~= false then
        Notification.new("You need to clean this item!", 3, "Error", "Light Red");

        return nil;
    end;

    local u63 = v62:GetAttribute("inventoryId");

    if type(u63) ~= "string" then
        return nil;
    end;

    task.spawn(RuntimeLib.async(function() -- Line: 490
        -- upvalues: RuntimeLib (ref), PolisherFunctions (ref), Slot (copy), u63 (copy), Notification (ref)
        local v64 = RuntimeLib.await(PolisherFunctions.startPolish:invoke(Slot, u63):catch(function() -- Line: 491
            return nil;
        end));

        if v64 == "maxed" then
            Notification.new("This item is already MAX condition!", 3, "Error", "Light Red");

            return;
        end;

        if v64 == "busy" then
            Notification.new("This polisher is already in use!", 3, "Error", "Light Red");
        end;
    end));
end;

function u9.onItemChanged(p65) -- Line: 501
    p65:rebuildDisplay();
    p65:refreshPrompt();
    p65:refreshTitle();
end;

function u9.bindUpgradeUi(u66) -- Line: 506
    -- upvalues: WFChain (copy)
    local v67 = WFChain(u66.instance, "Upgrade", "Info", "SurfaceGui", "Frame");
    local v68 = WFChain(v67, "Upgrade");

    local function _(p69) -- Line: 511
        return p69:IsA("TextLabel");
    end;

    local v70 = nil;

    for i, child in v68:GetChildren() do
        local _ = i - 1;

        if child:IsA("TextLabel") == true then
            v70 = child;
            break;
        end;
    end;

    if not v70 then
        return nil;
    end;

    u66.upgrade = {
        button = v68,
        price = v70,
        level = WFChain(v67, "Level"),
        speed = WFChain(v67, "PolishSpeed"),
        maxed = WFChain(v67, "Maxed")
    };
    u66.janitor:Add(u66.surfaceButtons:connect(v68, function() -- Line: 533
        -- upvalues: u66 (copy)
        return u66:requestUpgrade();
    end));
end;

function u9.refreshUpgradeUi(p71) -- Line: 537
    -- upvalues: polisherUpgradeCostFor (copy), polisherSpeedFor (copy), formatAbbrevMoney (copy)
    local upgrade = p71.upgrade;

    if not upgrade then
        return nil;
    end;

    local v72 = p71:level();
    local v73 = polisherUpgradeCostFor(v72);
    upgrade.level.Text = `Level {v72}`;
    upgrade.speed.Text = `Polish Speed: {string.format("%.2f", polisherSpeedFor(v72))}x`;
    upgrade.button.Visible = v73 ~= nil;
    upgrade.maxed.Visible = v73 == nil;

    if v73 ~= nil then
        upgrade.price.Text = formatAbbrevMoney(v73);
    end;
end;

function u9.requestUpgrade(u74) -- Line: 552
    -- upvalues: RuntimeLib (copy), PolisherFunctions (copy), Notification (copy)
    if not u74:isAvailable() then
        return nil;
    end;

    task.spawn(RuntimeLib.async(function() -- Line: 556
        -- upvalues: RuntimeLib (ref), PolisherFunctions (ref), u74 (copy), Notification (ref)
        local v75 = RuntimeLib.await(PolisherFunctions.upgradePolisher:invoke(u74.attributes.Slot):catch(function() -- Line: 557
            return nil;
        end));

        if v75 == "ok" then
            Notification.new("Polisher upgraded!", 3, "Notification", "Light Green");

            return;
        end;

        if v75 == "poor" then
            Notification.new("You can\'t afford this upgrade!", 3, "Error", "Light Red");
        end;
    end));
end;

function u9.rebuildDisplay(u76) -- Line: 567
    -- upvalues: u9 (ref), POLISH_ITEM_UID_ATTRIBUTE (copy)
    u9.animating[u76] = nil;
    local display = u76.display;

    if display ~= nil then
        display.janitor:Destroy();
    end;

    u76.display = nil;
    local u77 = u76.instance:GetAttribute(POLISH_ITEM_UID_ATTRIBUTE);

    if type(u77) ~= "string" or u77 == "" then
        return nil;
    end;

    task.defer(function() -- Line: 580
        -- upvalues: u76 (copy), u77 (copy)
        return u76:buildDisplay(u77);
    end);
end;

function u9.isStale(p78, p79) -- Line: 584
    -- upvalues: POLISH_ITEM_UID_ATTRIBUTE (copy)
    return p78.destroyed or p78.instance:GetAttribute(POLISH_ITEM_UID_ATTRIBUTE) ~= p79;
end;

function u9.buildDisplay(p80, p81) -- Line: 587
    -- upvalues: POLISH_ITEM_ID_ATTRIBUTE (copy), Items (copy), POLISH_FROM_ATTRIBUTE (copy), POLISH_TO_ATTRIBUTE (copy), Conditions (copy), POLISH_STARTED_ATTRIBUTE (copy), POLISH_ENDS_ATTRIBUTE (copy), POLISH_KG_ATTRIBUTE (copy), WFChain (copy), ReplicatedStorage (copy), ItemModel (copy), Janitor (copy), Workspace (copy), u9 (ref)
    if p80:isStale(p81) then
        return nil;
    end;

    local v82 = p80.instance:GetAttribute(POLISH_ITEM_ID_ATTRIBUTE);

    if v82 == nil or Items[v82] == nil then
        return nil;
    end;

    local v83 = p80.instance:GetAttribute(POLISH_FROM_ATTRIBUTE);
    local v84 = p80.instance:GetAttribute(POLISH_TO_ATTRIBUTE);

    if Conditions[v83] == nil or Conditions[v84] == nil then
        return nil;
    end;

    local v85 = p80.instance:GetAttribute(POLISH_STARTED_ATTRIBUTE);
    local v86 = p80.instance:GetAttribute(POLISH_ENDS_ATTRIBUTE);

    if type(v85) ~= "number" or (type(v86) ~= "number" or v86 <= v85) then
        return nil;
    end;

    local v87 = p80.instance:GetAttribute(POLISH_KG_ATTRIBUTE);

    if type(v87) ~= "number" or v87 <= 0 then
        v87 = Items[v82].averageKg;
    end;

    local v88 = WFChain(ReplicatedStorage, "Assets", "Items", Items[v82].displayName);

    if p80:isStale(p81) then
        return nil;
    end;

    local v89 = ItemModel.build(v88, v82, v87);

    if not v89 then
        return nil;
    end;

    ItemModel.applyDisplayRotation(v89, v82);

    for _, descendant in v89:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true;
            descendant.CanCollide = false;
            descendant.CanTouch = false;
            descendant.CanQuery = true;
        end;
    end;

    local _, v90 = v89:GetBoundingBox();
    local Position = p80.tableTop.Position;
    local v91 = Vector3.new(Position.X, Position.Y + p80.tableTop.Size.Y / 2 + 1.5 + v90.Y / 2, Position.Z);
    v89:PivotTo(CFrame.new(v91));
    v89.Parent = p80.instance;
    local v92 = p80.spongeTemplate:Clone();
    v92.Name = "PolishSponge";
    v92.Anchored = true;
    v92.CanCollide = false;
    v92.CanQuery = false;
    v92.CanTouch = false;
    v92.Massless = true;
    v92.Parent = p80.instance;
    local Attachment = Instance.new("Attachment");
    Attachment.Position = Vector3.new(0, -v92.Size.Y / 2, 0);
    Attachment.Parent = v92;
    local v93 = WFChain(ReplicatedStorage, "Assets", "Particles", "Bubbles"):Clone();
    v93.Parent = Attachment;
    local v94 = RaycastParams.new();
    v94.FilterType = Enum.RaycastFilterType.Include;
    v94.FilterDescendantsInstances = { v89 };
    v94.IgnoreWater = true;
    local v95 = math.sqrt(v90.X * v90.X + v90.Z * v90.Z) / 2 + 2;
    v92.CFrame = CFrame.fromMatrix(v91 + p80.outward * v95, p80.lateral, p80.outward);
    local v96 = p80:buildUi(v83, v84, v90.Y);
    local v97 = Janitor.new();
    v97:Add(v89, "Destroy");
    v97:Add(v92, "Destroy");
    v97:Add(v96.attachment, "Destroy");

    if p80:isStale(p81) then
        v97:Destroy();

        return nil;
    end;

    local v98 = {
        surfaceRadius = -1,
        shownSecond = -1,
        completed = false,
        janitor = v97,
        item = v89,
        sponge = v92,
        bubbles = v93,
        rayParams = v94,
        reach = v95,
        lift = v92.Size.Y / 2 - 0.2
    };
    local v99 = math.min(v90.X, v90.Y, v90.Z) * 0.3;
    v98.buffRadius = math.min(0.55, v99);
    v98.sweepHeight = v90.Y * 0.34;
    v98.spongeNormal = p80.outward;
    v98.basePosition = v91;
    v98.ui = v96;
    v98.uid = p81;
    v98.itemName = Items[v82].displayName;
    v98.finishedBeforeSeen = v86 <= Workspace:GetServerTimeNow();
    v98.to = v84;
    v98.startedAt = v85;
    v98.endsAt = v86;
    p80.display = v98;
    u9.animating[p80] = true;
    u9:ensureSharedLoop();
    p80:refreshPrompt();
end;

function u9.buildUi(p100, p101, p102, p103) -- Line: 695
    -- upvalues: WFChain (copy), ReplicatedStorage (copy), ItemLabelStyles (copy)
    local v104 = WFChain(ReplicatedStorage, "Assets", "WorldUI", "Polishing"):Clone();
    v104.Name = "Polishing";
    local v105 = WFChain(v104, "PolishUI");
    local v106 = WFChain(v105, "ProgressBar");
    local v107 = WFChain(v105, "Transition");
    local v108 = math.max(v107.Position.Y.Scale + v107.Size.Y.Scale * (1 - v107.AnchorPoint.Y), v106.Position.Y.Scale + v106.Size.Y.Scale * (1 - v106.AnchorPoint.Y));
    v105.StudsOffsetWorldSpace = Vector3.new(0, -v105.Size.Y.Scale * (0.5 - v108), 0);
    v104.Position = Vector3.new(0, p100.tableTop.Size.Y / 2 + 1.5 + p103 + 0.45 + 0.6, 0);
    v104.Parent = p100.tableTop;
    local v109 = {
        attachment = v104,
        inner = WFChain(v106, "Inner"),
        timer = WFChain(v106, "Timer"),
        transition = v107
    };
    v109.inner.Size = UDim2.fromScale(0, 1);
    p100:applyBarCondition(v109.inner, p101);
    ItemLabelStyles.applyConditionTransition(v109.transition, p101, p102);

    return v109;
end;

function u9.applyBarCondition(p110, p111, p112) -- Line: 719
    -- upvalues: u7 (copy), CollectionService (copy), RAINBOW_TAG (copy), RAINBOW_SEQUENCE (copy), CONDITION_COLORS (copy)
    p111.BackgroundColor3 = u7;
    CollectionService:RemoveTag(p111, RAINBOW_TAG);
    local v113 = p111:FindFirstChildWhichIsA("UIGradient");

    if v113 ~= nil then
        v113:Destroy();
    end;

    local UIGradient = Instance.new("UIGradient");
    local v114;

    if p112 == "mint" then
        v114 = RAINBOW_SEQUENCE;
    else
        v114 = ColorSequence.new(CONDITION_COLORS[p112]);
    end;

    UIGradient.Color = v114;
    UIGradient.Parent = p111;

    if p112 == "mint" then
        CollectionService:AddTag(p111, RAINBOW_TAG);
    end;
end;

function u9.step(p115, p116, p117, p118, p119, p120) -- Line: 733
    local display = p115.display;

    if not display then
        return nil;
    end;

    local v121 = display.basePosition + p119;
    display.item:PivotTo(CFrame.new(v121) * p120);

    if display.completed then
        return nil;
    end;

    p115:stepUi(display, p117);

    if display.completed then
        return nil;
    end;

    p115:stepSponge(display, p116, p118, v121);
end;

function u9.stepSponge(p122, p123, p124, p125, p126) -- Line: 754
    -- upvalues: polisherSpeedFor (copy), Workspace (copy)
    local v127 = polisherSpeedFor(p122:level());
    local v128 = -p124 * 1.25 * math.sqrt(v127);
    local v129 = p124 * 5 * v127;
    local outward = p122.outward;
    local v130 = math.cos(v128);
    local lateral = p122.lateral;
    local v131 = math.sin(v128);
    local v132 = outward * v130 + lateral * v131;
    local v133 = v132:Cross(Vector3.new(0, 1, 0));
    local v134 = math.cos(v129) * p123.buffRadius;
    local v135 = math.sin(v128 * 0.37) * p123.sweepHeight + math.sin(v129) * p123.buffRadius * 0.7;
    local v136 = v132 * p123.reach;
    local v137 = Vector3.new(0, v135, 0);
    local v138 = p126 + v136 + v133 * v134 + v137;
    local v139 = p126 - v138;
    local Magnitude = v139.Magnitude;

    if Magnitude < 0.05 then
        return nil;
    end;

    local v140 = Workspace:Raycast(v138, v139, p123.rayParams);
    local v141 = v139.Unit * -1;
    local v142;

    if v140 then
        v142 = Magnitude - v140.Distance;
    else
        v142 = p123.surfaceRadius;
    end;

    if v142 < 0 then
        return nil;
    end;

    if p123.surfaceRadius < 0 then
        p123.surfaceRadius = v142;
    end;

    p123.surfaceRadius = p123.surfaceRadius + (v142 - p123.surfaceRadius) * (1 - math.exp(-(p123.surfaceRadius < v142 and 24 or 14) * p125));

    if v140 ~= nil then
        v140 = v140.Normal;
    end;

    if v140 == nil then
        v140 = v141;
    end;

    local v143 = p123.spongeNormal:Lerp(v140, 1 - math.exp(-6 * p125));
    local v144;

    if v143.Magnitude > 0.05 then
        v144 = v143.Unit;
    else
        v144 = v141;
    end;

    p123.spongeNormal = v144;
    local spongeNormal = p123.spongeNormal;
    local v145 = v133 - spongeNormal * v133:Dot(spongeNormal);

    if v145.Magnitude < 0.05 then
        v145 = v132 - spongeNormal * v132:Dot(spongeNormal);
    end;

    if v145.Magnitude < 0.05 then
        return nil;
    end;

    local v146 = CFrame.Angles(math.cos(v129) * 0.12217304763960307, 0, math.sin(v129) * 0.12217304763960307);
    p123.sponge.CFrame = CFrame.fromMatrix(p126 + v141 * (p123.surfaceRadius + p123.lift), v145.Unit, spongeNormal) * v146;
end;

function u9.stepUi(p147, p148, p149) -- Line: 832
    -- upvalues: ItemLabelStyles (copy), formatPolishTimer (copy)
    local v150 = p148.endsAt - p149;

    if v150 <= 0 then
        p148.completed = true;
        p148.ui.inner.Size = UDim2.fromScale(1, 1);
        p147:applyBarCondition(p148.ui.inner, p148.to);
        p148.ui.timer.Text = "READY";
        p148.sponge.Transparency = 1;
        p148.bubbles.Enabled = false;
        ItemLabelStyles.applyNewCondition(p148.ui.transition, p148.to);
        p147:refreshPrompt();
        p147:notifyFinished(p148);

        return nil;
    end;

    p148.ui.inner.Size = UDim2.fromScale(math.clamp((p149 - p148.startedAt) / (p148.endsAt - p148.startedAt), 0, 1), 1);
    local v151 = math.ceil(v150);

    if p148.shownSecond == v151 then
        return nil;
    end;

    p148.shownSecond = v151;
    p148.ui.timer.Text = formatPolishTimer(v151);
    p147:refreshSkipPrice(v150);
end;

function u9.notifyFinished(p152, u153) -- Line: 855
    -- upvalues: u9 (ref), Notification (copy)
    if not p152:isOwner() then
        return nil;
    end;

    local v154 = `{u153.uid}:{u153.endsAt}`;

    if u9.notifiedFinishes[v154] ~= nil then
        return nil;
    end;

    u9.notifiedFinishes[v154] = true;

    local function v155() -- Line: 864
        -- upvalues: Notification (ref), u153 (copy)
        return Notification.new(`{u153.itemName} has finished polishing!`, 3, "Notification", "Light Green");
    end;

    if u153.finishedBeforeSeen then
        task.delay(1, v155);

        return;
    end;

    Notification.new(`{u153.itemName} has finished polishing!`, 3, "Notification", "Light Green");
end;

u9.animating = {};
u9.loopStarted = false;
u9.instances = {};
u9.notifiedFinishes = {};
u9.characterJanitor = Janitor.new();
u9.characterBound = false;
u9.refreshQueued = false;
Reflect.defineMetadata(u9, "identifier", "client/components/world/PolisherComponent@PolisherComponent");
Reflect.defineMetadata(u9, "flamework:parameters", { "client/controllers/ui/SurfaceButtonController@SurfaceButtonController" });
Reflect.defineMetadata(u9, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u9, "$c:components@Component", Component, {
    {
        tag = "Polisher",
        attributes = {
            Slot = t.number,
            Unlocked = t.boolean
        },
        instanceGuard = t.instanceIsA("Model")
    }
});

return {
    PolisherComponent = u9
};