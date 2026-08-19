-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services");
local CollectionService = v1.CollectionService;
local ProximityPromptService = v1.ProximityPromptService;
local ReplicatedStorage = v1.ReplicatedStorage;
local TweenService = v1.TweenService;
local FrameComponent = RuntimeLib.import(script, script.Parent.Parent.Parent, "components", "ui", "FrameComponent").FrameComponent;
local PlayerGui = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "player", "playerConstants").PlayerGui;
local v2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "network", "ShopNetwork");
local ShopEvents = v2.ShopEvents;
local ShopFunctions = v2.ShopFunctions;
local CustomPrompt = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "CustomPrompt").CustomPrompt;
local GearBenefits = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "GearBenefits").GearBenefits;
local GearViewport = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "GearViewport").GearViewport;
local ModelViewport = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "ModelViewport").ModelViewport;
local Notification = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "Notification").Notification;
local getOrCreatePromptTrigger = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "PromptTrigger").getOrCreatePromptTrigger;
local SprayBottles = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "cleaning", "SprayBottles").SprayBottles;
local Detectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "digging", "Detectors").Detectors;
local Shovels = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "digging", "Shovels").Shovels;
local gearRobuxProduct = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "monetization", "GearRobuxTiers").gearRobuxProduct;
local formatAbbrevMoney = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "formatting", "formatAbbrevMoney").formatAbbrevMoney;
local WFChain = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "instances", "WFChain").WFChain;
local playSound = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "sound", "SoundUtil").playSound;
local getIslandsFolder = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "world", "getStarterIsland").getIslandsFolder;
local u3 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u4 = setmetatable({}, {
    __tostring = function() -- Line: 44, Name: __tostring
        return "GearShopController";
    end
});
u4.__index = u4;

function u4.new(...) -- Line: 49
    -- upvalues: u4 (ref)
    local v5 = setmetatable({}, u4);

    return v5:constructor(...) or v5;
end;

function u4.constructor(p6, p7, p8, p9) -- Line: 53
    p6.data = p7;
    p6.tutorial = p8;
    p6.islands = p9;
    p6.highlightsByPrompt = {};
    p6.entriesByPrompt = {};
    p6.prompts = {};
    p6.registeredModels = {};
    p6.buying = false;
    p6.robuxPending = false;
end;

function u4.onStart(u10) -- Line: 64
    -- upvalues: ProximityPromptService (copy), FrameComponent (copy), getIslandsFolder (copy), WFChain (copy)
    u10:setupFrame();
    ProximityPromptService.PromptShown:Connect(function(p11) -- Line: 66
        -- upvalues: u10 (copy)
        return u10:setHighlightSolid(p11, true);
    end);
    ProximityPromptService.PromptHidden:Connect(function(p12) -- Line: 69
        -- upvalues: u10 (copy)
        return u10:setHighlightSolid(p12, false);
    end);
    FrameComponent.onClosed.Event:Connect(function(p13) -- Line: 72
        -- upvalues: u10 (copy)
        if p13 ~= "BuyFrame" then
            return nil;
        end;

        u10.activeItem = nil;
        u10.robuxPending = false;
        u10:setPromptsEnabled(true);
    end);
    task.spawn(function() -- Line: 80
        -- upvalues: getIslandsFolder (ref), u10 (copy), WFChain (ref)
        local v14 = getIslandsFolder();

        for _, v in u10.islands:getIslands() do
            if v.hasGearNpc then
                local v15 = WFChain(v14, v.name, "NPCs", "Gear");
                u10:watchContainer(WFChain(v15, "BuyShovels"), "shovel");
                u10:watchContainer(WFChain(v15, "Sprays"), "spray");
                u10:watchContainer(WFChain(v15, "BuyDetectors"), "detector");
            end;
        end;
    end);
end;

function u4.setupFrame(u16) -- Line: 93
    -- upvalues: WFChain (copy), PlayerGui (copy), ModelViewport (copy), FrameComponent (copy)
    u16.frame = WFChain(PlayerGui, "Main", "BuyFrame");
    u16.title = WFChain(u16.frame, "Title");
    local v17 = WFChain(u16.frame, "ItemFrame");
    u16.itemName = WFChain(v17, "ItemName");
    u16.goldCost = WFChain(v17, "GoldCost");
    u16.itemViewport = ModelViewport.replace(WFChain(v17, "ImageLabel"));
    u16.benefitsFrame = WFChain(u16.frame, "Benefits");
    u16.benefitsTemplate = WFChain(u16.benefitsFrame, "Template");
    u16.benefitsTemplate.Visible = false;
    u16.robuxBuy = WFChain(u16.frame, "RobuxBuy");
    u16.robuxPrice = WFChain(u16.robuxBuy, "Price");
    local v18 = WFChain(u16.frame, "Yes");
    local v19 = WFChain(u16.frame, "No");
    v18.Activated:Connect(function() -- Line: 107
        -- upvalues: u16 (copy)
        return u16:confirmPurchase();
    end);
    v19.Activated:Connect(function() -- Line: 110
        -- upvalues: FrameComponent (ref)
        return FrameComponent:toggleFrame("BuyFrame", false);
    end);
    u16.robuxBuy.Activated:Connect(function() -- Line: 113
        -- upvalues: u16 (copy)
        return u16:confirmRobuxPurchase();
    end);
end;

function u4.buildItems(p20, p21) -- Line: 117
    -- upvalues: Shovels (copy), SprayBottles (copy), Detectors (copy), GearBenefits (copy)
    local v22;

    if p21 == "shovel" then
        v22 = Shovels;
    elseif p21 == "spray" then
        v22 = SprayBottles;
    else
        v22 = Detectors;
    end;

    local v23 = {};

    for i, v in pairs(v22) do
        if v.cost ~= 0 then
            local v24 = {
                category = p21,
                id = i,
                displayName = v.displayName,
                cost = v.cost,
                benefits = GearBenefits.get(p21, i)
            };
            table.insert(v23, v24);
        end;
    end;

    return v23;
end;

function u4.watchContainer(u25, p26, p27) -- Line: 135
    local u28 = {};

    for _, v in u25:buildItems(p27) do
        u28[v.displayName] = v;
    end;

    local function v31(p29) -- Line: 141
        -- upvalues: u28 (copy), u25 (copy)
        if not p29:IsA("Model") then
            return nil;
        end;

        local v30 = u28[p29.Name];

        if v30 then
            u25:registerItemModel(p29, v30);
        end;
    end;

    for _, descendant in p26:GetDescendants() do
        if descendant:IsA("Model") then
            local v32 = u28[descendant.Name];

            if v32 then
                u25:registerItemModel(descendant, v32);
            end;
        end;
    end;

    p26.DescendantAdded:Connect(v31);
end;

function u4.registerItemModel(u33, u34, u35) -- Line: 156
    if u33.registeredModels[u34] ~= nil then
        return nil;
    end;

    u33.registeredModels[u34] = true;
    task.spawn(function() -- Line: 165
        -- upvalues: u33 (copy), u34 (copy), u35 (copy)
        u33:waitForAnyPart(u34);
        u33:setupItemModel(u34, u35);
    end);
end;

function u4.waitForAnyPart(p36, p37) -- Line: 170
    -- upvalues: RuntimeLib (copy)
    if p37:FindFirstChildWhichIsA("BasePart", true) then
        return nil;
    end;

    RuntimeLib.Promise.fromEvent(p37.DescendantAdded, function(p38) -- Line: 174
        return p38:IsA("BasePart");
    end):expect();
end;

function u4.setupItemModel(u39, p40, u41) -- Line: 178
    -- upvalues: getOrCreatePromptTrigger (copy), WFChain (copy), ReplicatedStorage (copy), formatAbbrevMoney (copy), CustomPrompt (copy)
    local v42 = getOrCreatePromptTrigger(p40);
    local Attachment = Instance.new("Attachment");
    Attachment.Parent = v42;
    Attachment.WorldPosition = u39:highestVisiblePartTop(p40);
    local v43 = WFChain(ReplicatedStorage, "Assets", "WorldUI", "GoldAmount"):Clone();
    local v44 = WFChain(v43, "Gold");
    local v45 = WFChain(v43, "Checkmark");
    v44.Text = formatAbbrevMoney(u41.cost);
    v43.StudsOffset = Vector3.new(0, 0.75, 0);
    v43.Adornee = Attachment;
    v43.Parent = v42;
    local Highlight = Instance.new("Highlight");
    Highlight.FillColor = Color3.new(1, 1, 1);
    Highlight.OutlineColor = Color3.new(1, 1, 1);
    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded;
    Highlight.FillTransparency = 1;
    Highlight.OutlineTransparency = 1;
    Highlight.Adornee = p40;
    Highlight.Parent = p40;
    local v46 = CustomPrompt.new({
        holdDuration = 0.3,
        actionText = formatAbbrevMoney(u41.cost),
        objectText = u41.displayName
    });
    local v47 = {
        item = u41,
        goldLabel = v44,
        checkmark = v45
    };
    u39:applyOwnershipState(v46.Prompt, v47, u39:isOwned(u41, u39.data:getData()));
    v46.Prompt.Parent = v42;
    v46:onTriggered(function() -- Line: 211
        -- upvalues: u39 (copy), u41 (copy)
        return u39:onPromptTriggered(u41);
    end);
    u39.highlightsByPrompt[v46.Prompt] = Highlight;
    u39.entriesByPrompt[v46.Prompt] = v47;
    table.insert(u39.prompts, v46.Prompt);
end;

function u4.highestVisiblePartTop(p48, p49) -- Line: 224
    local Position = p49:GetPivot().Position;
    local v50 = (-1 / 0);

    for _, descendant in p49:GetDescendants() do
        if descendant:IsA("BasePart") and descendant.Transparency < 1 then
            local CFrame = descendant.CFrame;
            local Size = descendant.Size;
            local Position2 = descendant.Position;
            local v51 = (math.abs(Size.X * CFrame.RightVector.Y) + math.abs(Size.Y * CFrame.UpVector.Y) + math.abs(Size.Z * CFrame.LookVector.Y)) / 2;
            local v52 = Position2.Y + v51;

            if v52 > v50 then
                Position = Vector3.new(Position2.X, v52, Position2.Z);
                v50 = v52;
            end;
        end;
    end;

    return Position;
end;

function u4.applyOwnershipState(p53, p54, p55, p56) -- Line: 245
    -- upvalues: formatAbbrevMoney (copy)
    p54:SetAttribute("Theme", p56 and "Owned" or "BuyItem");
    p54.ActionText = p56 and "Owned" or formatAbbrevMoney(p55.item.cost);
    p55.goldLabel.Visible = not p56;
    p55.checkmark.Visible = p56;
end;

function u4.isOwned(p57, p58, p59) -- Line: 251
    if p58.category == "shovel" then
        return table.find(p59.OwnedShovels, p58.id) ~= nil;
    end;

    local v60;

    if p58.category == "spray" then
        v60 = table.find(p59.OwnedSprays, p58.id) ~= nil;
    else
        v60 = table.find(p59.OwnedDetectors, p58.id) ~= nil;
    end;

    return v60;
end;

function u4.onPromptTriggered(p61, p62) -- Line: 272
    -- upvalues: Notification (copy)
    if not p61.tutorial:canBuyGear(p62.category, p62.id) then
        p61.tutorial:notifyFollowTutorial();

        return nil;
    end;

    if p61:isOwned(p62, p61.data:getData()) then
        Notification.new("Already owned!", 3, "Error", "Red");

        return nil;
    end;

    p61:openBuyFrame(p62);
end;

function u4.onDataChanged(u63, p64, p65) -- Line: 283
    -- upvalues: FrameComponent (copy), playSound (copy)
    if u63.robuxPending and (u63.activeItem and u63:isOwned(u63.activeItem, p65)) then
        FrameComponent:toggleFrame("BuyFrame", false);
        playSound("Purchase Success");
    end;

    for i, v in u63.entriesByPrompt do
        local v66 = u63:isOwned(v.item, p65);

        if (v66 and "Owned" or "BuyItem") ~= i:GetAttribute("Theme") then
            u63:applyOwnershipState(i, v, v66);

            if i.Enabled then
                i.Enabled = false;
                task.defer(function() -- Line: 297
                    -- upvalues: u63 (copy), i (copy)
                    if not u63.activeItem then
                        i.Enabled = true;
                    end;
                end);
            end;
        end;
    end;
end;

function u4.setHighlightSolid(p67, p68, p69) -- Line: 305
    -- upvalues: TweenService (copy), u3 (copy)
    local v70 = p67.highlightsByPrompt[p68];

    if not v70 then
        return nil;
    end;

    TweenService:Create(v70, u3, {
        OutlineTransparency = p69 and 0 or 1
    }):Play();
end;

function u4.setPromptsEnabled(p71, p72) -- Line: 316
    for _, v in p71.prompts do
        v.Enabled = p72;
    end;
end;

function u4.gearNoun(p73, p74) -- Line: 321
    local v75 = string.match(p74.displayName, "^%S+%s+(.+)$");

    if type(v75) == "string" then
        return v75;
    end;

    return p74.displayName;
end;

function u4.openBuyFrame(p76, p77) -- Line: 325
    -- upvalues: formatAbbrevMoney (copy), GearViewport (copy), GearBenefits (copy), FrameComponent (copy)
    if p76.activeItem then
        return nil;
    end;

    p76.activeItem = p77;
    p76.title.Text = `Buy {p76:gearNoun(p77)}`;
    p76.itemName.Text = p77.displayName;
    p76.goldCost.Text = formatAbbrevMoney(p77.cost);
    GearViewport.setGear(p76.itemViewport, p77.category, p77.id);
    GearBenefits.render(p76.benefitsFrame, p76.benefitsTemplate, p77.benefits);
    p76:setRobuxProduct(p77.cost);
    p76:setPromptsEnabled(false);
    FrameComponent:toggleFrame("BuyFrame", true);
end;

function u4.setRobuxProduct(p78, p79) -- Line: 339
    -- upvalues: gearRobuxProduct (copy), CollectionService (copy)
    local v80 = gearRobuxProduct(p79);
    p78.robuxBuy:SetAttribute("name", v80);
    p78.robuxPrice:SetAttribute("name", v80);
    CollectionService:AddTag(p78.robuxBuy, "ShopButton");
    CollectionService:AddTag(p78.robuxPrice, "ShopPrice");
end;

function u4.confirmPurchase(u81) -- Line: 346
    -- upvalues: ShopFunctions (copy), FrameComponent (copy), playSound (copy), Notification (copy)
    local activeItem = u81.activeItem;

    if not activeItem or u81.buying then
        return nil;
    end;

    u81.buying = true;
    ShopFunctions.buyGear:invoke(activeItem.category, activeItem.id):catch(function() -- Line: 352
        return false;
    end):andThen(function(p82) -- Line: 354
        -- upvalues: u81 (copy), FrameComponent (ref), playSound (ref), Notification (ref)
        u81.buying = false;
        FrameComponent:toggleFrame("BuyFrame", false);

        if p82 then
            playSound("Purchase Success");

            return;
        end;

        Notification.new("You can\'t afford this!", 3, "Error", "Light Red");
    end);
end;

function u4.confirmRobuxPurchase(p83) -- Line: 364
    -- upvalues: ShopEvents (copy)
    local activeItem = p83.activeItem;

    if not activeItem then
        return nil;
    end;

    p83.robuxPending = true;
    ShopEvents.setGearPurchaseIntent:fire(activeItem.category, activeItem.id);
end;

Reflect.defineMetadata(u4, "identifier", "client/controllers/npc/GearShopController@GearShopController");
Reflect.defineMetadata(u4, "flamework:parameters", { "client/controllers/data/DataController@DataController", "client/controllers/tutorial/TutorialController@TutorialController", "client/controllers/world/IslandController@IslandController" });
Reflect.defineMetadata(u4, "flamework:implements", { "$:flamework@OnStart", "client/controllers/data/DataController@OnDataChanged" });
Reflect.decorate(u4, "$:flamework@Controller", Controller, { {} });

return {
    GearShopController = u4
};