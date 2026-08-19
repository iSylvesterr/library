-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out");
local BaseComponent = v1.BaseComponent;
local Component = v1.Component;
local Janitor = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "janitor", "src").Janitor;
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services");
local ReplicatedStorage = v2.ReplicatedStorage;
local RunService = v2.RunService;
local Player = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "player", "playerConstants").Player;
local PedestalFunctions = RuntimeLib.import(script, script.Parent.Parent.Parent, "network", "PedestalNetwork").PedestalFunctions;
local Notification = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "Notification").Notification;
local applyGoldGradient = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "gradient", "GoldGradient").applyGoldGradient;
local ItemLabelStyles = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "itemLabels", "ItemLabelStyles").ItemLabelStyles;
local Conditions = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "items", "Conditions").Conditions;
local v3 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "items", "Items");
local effectiveOneIn = v3.effectiveOneIn;
local Items = v3.Items;
local itemValueFor = v3.itemValueFor;
local ItemModel = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "items", "ItemModel").ItemModel;
local WFChain = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "instances", "WFChain").WFChain;
local formatAbbrevMoney = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "formatting", "formatAbbrevMoney").formatAbbrevMoney;
local u4 = setmetatable({}, {
    __tostring = function() -- Line: 47, Name: __tostring
        return "PedestalComponent";
    end,

    __index = BaseComponent
});
u4.__index = u4;

function u4.new(...) -- Line: 53
    -- upvalues: u4 (ref)
    local v5 = setmetatable({}, u4);

    return v5:constructor(...) or v5;
end;

function u4.constructor(p6, p7) -- Line: 57
    -- upvalues: BaseComponent (copy), Janitor (copy)
    BaseComponent.constructor(p6);
    p6.tutorial = p7;
    p6.janitor = Janitor.new();
    p6.destroyed = false;
end;

function u4.onStart(u8) -- Line: 63
    -- upvalues: u4 (ref)
    local v9 = u8:getTopPart();

    if not v9 then
        return nil;
    end;

    u8.topPart = v9;
    u8.plot = u8:findPlot();
    local Part = Instance.new("Part");
    Part.Name = "PedestalPrompt";
    Part.Size = Vector3.new(0.2, 0.2, 0.2);
    Part.Transparency = 1;
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.Massless = true;
    Part.Position = v9.Position + Vector3.new(0, v9.Size.Y / 2 + 3, 0);
    Part.Parent = u8.instance;
    u8.janitor:Add(Part, "Destroy");
    local ProximityPrompt = Instance.new("ProximityPrompt");
    ProximityPrompt.RequiresLineOfSight = false;
    ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom;
    ProximityPrompt.MaxActivationDistance = 12;
    ProximityPrompt.HoldDuration = 0.5;
    ProximityPrompt.Enabled = false;
    ProximityPrompt.Parent = Part;
    u8.prompt = ProximityPrompt;
    u8.janitor:Add(ProximityPrompt, "Destroy");
    u8.janitor:Add(ProximityPrompt.Triggered:Connect(function() -- Line: 92
        -- upvalues: u8 (copy)
        return u8:onTriggered();
    end), "Disconnect");
    u8.janitor:Add(u8.instance:GetAttributeChangedSignal("ItemUid"):Connect(function() -- Line: 95
        -- upvalues: u8 (copy)
        return u8:onItemChanged();
    end), "Disconnect");

    if u8.plot then
        u8.janitor:Add(u8.plot:GetAttributeChangedSignal("OwnerUserId"):Connect(function() -- Line: 99
            -- upvalues: u8 (copy)
            return u8:refreshPrompt();
        end), "Disconnect");
    end;

    u4.instances[u8] = true;
    u4:bindCharacter();
    u8:rebuildDisplay();
    u8:refreshPrompt();
end;

function u4.ensureSharedLoop(p10) -- Line: 110
    -- upvalues: u4 (ref), RunService (copy)
    if u4.loopStarted then
        return nil;
    end;

    u4.loopStarted = true;
    RunService.RenderStepped:Connect(function() -- Line: 115
        -- upvalues: u4 (ref)
        local v11 = os.clock();
        local v12 = math.sin(v11 * 2) * 0.6;
        local v13 = Vector3.new(0, v12, 0);
        local v14 = CFrame.Angles(0, v11 * 1, 0);

        for i in u4.animating do
            local display = i.display;

            if display then
                display.item:PivotTo(CFrame.new(display.basePosition + v13) * v14);
            end;
        end;
    end);
end;

function u4.bindCharacter(p15) -- Line: 130
    -- upvalues: u4 (ref), Player (copy)
    if u4.characterBound then
        return nil;
    end;

    u4.characterBound = true;

    local function v19(p16) -- Line: 135
        -- upvalues: u4 (ref)
        u4.characterJanitor:Add(p16.ChildAdded:Connect(function(p17) -- Line: 136
            -- upvalues: u4 (ref)
            if p17:IsA("Tool") then
                u4:queueRefresh();
            end;
        end), "Disconnect", "childAdded");
        u4.characterJanitor:Add(p16.ChildRemoved:Connect(function(p18) -- Line: 141
            -- upvalues: u4 (ref)
            if p18:IsA("Tool") then
                u4:queueRefresh();
            end;
        end), "Disconnect", "childRemoved");
        u4:queueRefresh();
    end;

    if Player.Character then
        v19(Player.Character);
    end;

    Player.CharacterAdded:Connect(v19);
end;

function u4.queueRefresh(p20) -- Line: 153
    -- upvalues: u4 (ref)
    if u4.refreshQueued then
        return nil;
    end;

    u4.refreshQueued = true;
    task.defer(function() -- Line: 158
        -- upvalues: u4 (ref)
        u4.refreshQueued = false;
        local v21 = u4:findHeldTool();

        for i in u4.instances do
            i:refreshPrompt(v21);
        end;
    end);
end;

function u4.findHeldTool(p22) -- Line: 166
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

function u4.destroy(p23) -- Line: 178
    -- upvalues: u4 (ref), BaseComponent (copy)
    p23.destroyed = true;
    u4.instances[p23] = nil;
    u4.animating[p23] = nil;
    local display = p23.display;

    if display ~= nil then
        display.janitor:Destroy();
    end;

    p23.janitor:Destroy();
    BaseComponent.destroy(p23);
end;

function u4.getTopPart(p24) -- Line: 193
    local v25 = nil;

    for _, child in p24.instance:GetChildren() do
        if child:IsA("BasePart") and (not v25 or child.Position.Y > v25.Position.Y) then
            v25 = child;
        end;
    end;

    return v25;
end;

function u4.findPlot(p26) -- Line: 205
    local Parent = p26.instance.Parent;

    while Parent do
        local v27 = Parent:IsA("Model") and string.match(Parent.Name, "^Plot_%d+$");

        if v27 ~= 0 and (v27 == v27 and (v27 ~= "" and v27)) then
            return Parent;
        end;

        Parent = Parent.Parent;
    end;

    return nil;
end;

function u4.isOwner(p28) -- Line: 216
    -- upvalues: Player (copy)
    local plot = p28.plot;

    if plot ~= nil then
        plot = plot:GetAttribute("OwnerUserId");
    end;

    return plot == Player.UserId;
end;

function u4.isOccupied(p29) -- Line: 223
    local v30 = p29.instance:GetAttribute("ItemUid");

    return (v30 == nil and "" or v30) ~= "";
end;

function u4.refreshPrompt(p31, p32) -- Line: 230
    -- upvalues: u4 (ref)
    if p32 == nil then
        p32 = u4:findHeldTool();
    end;

    if not p31.prompt then
        return nil;
    end;

    if not p31:isOwner() then
        p31.prompt.Enabled = false;

        return nil;
    end;

    local v33 = p31:isOccupied();

    if p32 then
        p31.prompt.ActionText = v33 and "Swap Item" or "Place Item";
        p31.prompt.Enabled = true;

        return nil;
    end;

    if v33 then
        p31.prompt.ActionText = "Pick Up";
        p31.prompt.Enabled = true;

        return nil;
    end;

    p31.prompt.Enabled = false;
end;

function u4.onTriggered(p34) -- Line: 254
    -- upvalues: u4 (ref), Notification (copy), PedestalFunctions (copy)
    if not p34:isOwner() then
        return nil;
    end;

    local Slot = p34.attributes.Slot;
    local v35 = u4:findHeldTool();

    if not p34.tutorial:canUsePedestal(Slot, v35 ~= nil) then
        p34.tutorial:notifyFollowTutorial();

        return nil;
    end;

    if v35 then
        if v35:GetAttribute("dirty") ~= false then
            Notification.new("You need to clean this item!", 3, "Error", "Light Red");

            return nil;
        end;

        local v36 = v35:GetAttribute("inventoryId");

        if type(v36) ~= "string" then
            return nil;
        end;

        PedestalFunctions.placeItem:invoke(Slot, v36):catch(function() -- Line: 273
            return nil;
        end);

        return nil;
    end;

    if p34:isOccupied() then
        PedestalFunctions.pickupItem:invoke(Slot):catch(function() -- Line: 279
            return nil;
        end);
    end;
end;

function u4.onItemChanged(p37) -- Line: 284
    p37:rebuildDisplay();
    p37:refreshPrompt();
end;

function u4.rebuildDisplay(u38) -- Line: 288
    -- upvalues: u4 (ref)
    u4.animating[u38] = nil;
    local display = u38.display;

    if display ~= nil then
        display.janitor:Destroy();
    end;

    u38.display = nil;
    local u39 = u38.instance:GetAttribute("ItemUid");

    if type(u39) ~= "string" or u39 == "" then
        return nil;
    end;

    task.defer(function() -- Line: 301
        -- upvalues: u38 (copy), u39 (copy)
        return u38:buildDisplay(u39);
    end);
end;

function u4.isStale(p40, p41) -- Line: 305
    return p40.destroyed or p40.instance:GetAttribute("ItemUid") ~= p41;
end;

function u4.buildDisplay(p42, p43) -- Line: 308
    -- upvalues: Items (copy), WFChain (copy), ReplicatedStorage (copy), ItemModel (copy), Janitor (copy), u4 (ref)
    if p42:isStale(p43) then
        return nil;
    end;

    local v44 = p42.instance:GetAttribute("ItemId");

    if v44 == nil or Items[v44] == nil then
        return nil;
    end;

    local v45 = p42.instance:GetAttribute("Kg");

    if type(v45) ~= "number" then
        v45 = Items[v44].averageKg;
    end;

    local v46 = p42.instance:GetAttribute("Condition");
    local v47 = WFChain(ReplicatedStorage, "Assets", "Items", Items[v44].displayName);

    if p42:isStale(p43) then
        return nil;
    end;

    local v48 = ItemModel.build(v47, v44, v45);

    if not v48 then
        return nil;
    end;

    ItemModel.applyDisplayRotation(v48, v44);

    for _, descendant in v48:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true;
            descendant.CanCollide = false;
            descendant.CanQuery = false;
        end;
    end;

    local _, v49 = v48:GetBoundingBox();
    local Position = p42.topPart.Position;
    local v50 = Vector3.new(Position.X, Position.Y + p42.topPart.Size.Y / 2 + 1.5 + v49.Y / 2, Position.Z);
    v48:PivotTo(CFrame.new(v50));
    v48.Parent = p42.instance;
    local Part = Instance.new("Part");
    Part.Name = "PedestalOverhead";
    Part.Size = Vector3.new(0.2, 0.2, 0.2);
    Part.Transparency = 1;
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.Massless = true;
    Part.Position = v50;
    Part.Parent = p42.instance;
    local v51 = WFChain(ReplicatedStorage, "Assets", "WorldUI", "ItemOverhead"):Clone();
    v51.Name = "ItemOverhead";
    v51.Adornee = Part;
    v51.Parent = Part;
    p42:fillOverhead(v51, v44, v45, v46);
    local v52 = Janitor.new();
    v52:Add(v48, "Destroy");
    v52:Add(Part, "Destroy");

    if p42:isStale(p43) then
        v52:Destroy();

        return nil;
    end;

    p42.display = {
        janitor = v52,
        item = v48,
        basePosition = v50
    };
    u4.animating[p42] = true;
    u4:ensureSharedLoop();
end;

function u4.fillOverhead(p53, p54, p55, p56, p57) -- Line: 373
    -- upvalues: WFChain (copy), ItemLabelStyles (copy), Items (copy), Conditions (copy), effectiveOneIn (copy), applyGoldGradient (copy), formatAbbrevMoney (copy), itemValueFor (copy)
    local v58 = WFChain(p54, "Frame");
    local v59 = WFChain(v58, "Name");
    local v60 = WFChain(v58, "Condition");
    local v61 = WFChain(v58, "Rarity");
    local v62 = WFChain(v58, "Money");
    ItemLabelStyles.applyItemName(v59, Items[p55].displayName, p56, Items[p55].rarity);

    if Conditions[p57] ~= nil then
        ItemLabelStyles.applyCondition(v60, p57);
        ItemLabelStyles.applyRarity(v61, effectiveOneIn(p55, p57, p56), Items[p55].rarity);
        v62.RichText = false;
        applyGoldGradient(v62);
        v62.Text = formatAbbrevMoney(itemValueFor(p55, p57, p56));
    end;
end;

u4.animating = {};
u4.loopStarted = false;
u4.instances = {};
u4.characterJanitor = Janitor.new();
u4.characterBound = false;
u4.refreshQueued = false;
Reflect.defineMetadata(u4, "identifier", "client/components/world/PedestalComponent@PedestalComponent");
Reflect.defineMetadata(u4, "flamework:parameters", { "client/controllers/tutorial/TutorialController@TutorialController" });
Reflect.defineMetadata(u4, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u4, "$c:components@Component", Component, {
    {
        tag = "Pedestal",
        attributes = {
            Slot = t.number,
            ItemUid = t.string,
            ItemId = t.string,
            Kg = t.number,
            Condition = t.string
        },
        instanceGuard = t.instanceIsA("Model")
    }
});

return {
    PedestalComponent = u4
};