-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local PlayerGui = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "player", "playerConstants").PlayerGui;
local ShopFunctions = RuntimeLib.import(script, script.Parent.Parent.Parent, "network", "ShopNetwork").ShopFunctions;
local GearBenefits = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "GearBenefits").GearBenefits;
local GearViewport = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "GearViewport").GearViewport;
local ModelViewport = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "ModelViewport").ModelViewport;
local restoreStrokeThickness = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "StrokeThickness").restoreStrokeThickness;
local SprayBottles = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "cleaning", "SprayBottles").SprayBottles;
local Detectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "digging", "Detectors").Detectors;
local Shovels = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "digging", "Shovels").Shovels;
local WFChain = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "instances", "WFChain").WFChain;
local u1 = Color3.new(1, 1, 1);
local u2 = Color3.new(0, 0, 0);
local u3 = setmetatable({}, {
    __tostring = function() -- Line: 24, Name: __tostring
        return "InventoryController";
    end
});
u3.__index = u3;

function u3.new(...) -- Line: 29
    -- upvalues: u3 (ref)
    local v4 = setmetatable({}, u3);

    return v4:constructor(...) or v4;
end;

function u3.constructor(p5, p6) -- Line: 33
    p5.data = p6;
    p5.lists = {};
    p5.equipping = false;
end;

function u3.onStart(u7) -- Line: 38
    -- upvalues: GearViewport (copy), WFChain (copy), PlayerGui (copy), restoreStrokeThickness (copy)
    GearViewport.prepare();
    local v8 = WFChain(PlayerGui, "Main", "Inventory");
    local v9 = WFChain(v8, "TabList");
    local v10 = WFChain(v9, "Shovels");
    local v11 = WFChain(v9, "Sprays");
    local v12 = WFChain(v9, "Detectors");
    local v13 = WFChain(v8, "ScrollingFrame");
    WFChain(v13, "ItemFrame");
    WFChain(v13, "Spacer");
    local v14 = v13:Clone();
    v14.Name = "SpraysScrollingFrame";
    restoreStrokeThickness(v14);
    v14.Parent = v8;
    local v15 = v13:Clone();
    v15.Name = "DetectorsScrollingFrame";
    restoreStrokeThickness(v15);
    v15.Parent = v8;
    local lists = u7.lists;
    local v16 = u7:createList("shovel", v13, WFChain(v10, "UIStroke"), "OwnedShovels", "EquippedShovel");
    local v17 = u7:createList("spray", v14, WFChain(v11, "UIStroke"), "OwnedSprays", "EquippedSpray");
    local v18 = u7:createList("detector", v15, WFChain(v12, "UIStroke"), "OwnedDetectors", "EquippedDetector");
    table.insert(lists, v16);
    table.insert(lists, v17);
    table.insert(lists, v18);
    v10.Activated:Connect(function() -- Line: 65
        -- upvalues: u7 (copy)
        return u7:selectTab("shovel");
    end);
    v11.Activated:Connect(function() -- Line: 68
        -- upvalues: u7 (copy)
        return u7:selectTab("spray");
    end);
    v12.Activated:Connect(function() -- Line: 71
        -- upvalues: u7 (copy)
        return u7:selectTab("detector");
    end);
    u7:selectTab("shovel");
    u7:syncTabTextSize(v9, { v10, v11, v12 });
    local v19 = u7.data:getData();

    for _, v in u7.lists do
        u7:rebuild(v, v19);
    end;
end;

function u3.syncTabTextSize(p20, u21, p22) -- Line: 81
    -- upvalues: WFChain (copy)
    local u23 = table.create(#p22);

    local function _(p24) -- Line: 84
        -- upvalues: WFChain (ref)
        return WFChain(p24, "TextLabel");
    end;

    for i, v in p22 do
        local _ = i - 1;
        u23[i] = WFChain(v, "TextLabel");
    end;

    local u25 = {};

    local function u29() -- Line: 93
        -- upvalues: u23 (copy), u25 (ref)
        local v26 = (1 / 0);

        for i = 0, #u23 - 1 do
            local AbsoluteSize = u23[i + 1].AbsoluteSize;

            if AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0 then
                return nil;
            end;

            v26 = math.min(v26, AbsoluteSize.Y * 0.9, AbsoluteSize.X * 0.9 / u25[i + 1]);
        end;

        local v27 = math.floor(v26);
        local v28 = math.clamp(v27, 8, 100);

        for _, v in u23 do
            v.TextSize = v28;
        end;
    end;

    task.defer(function() -- Line: 107
        -- upvalues: u23 (copy), u25 (ref), u29 (copy), u21 (copy)
        for _, v in u23 do
            v.TextScaled = false;
            v.TextWrapped = false;
            v.TextSize = 100;
        end;

        local v30 = table.create(#u23);

        local function _(p31) -- Line: 115
            return p31.TextBounds.X / 100;
        end;

        for i, v in u23 do
            local _ = i - 1;
            v30[i] = v.TextBounds.X / 100;
        end;

        u25 = v30;
        u29();
        u21:GetPropertyChangedSignal("AbsoluteSize"):Connect(u29);
    end);
end;

function u3.createList(p32, p33, p34, p35, p36, p37) -- Line: 127
    local ItemFrame = p34:FindFirstChild("ItemFrame");
    local Spacer = p34:FindFirstChild("Spacer");
    ItemFrame.Visible = false;
    Spacer.Visible = false;

    return {
        category = p33,
        scroll = p34,
        itemTemplate = ItemFrame,
        spacerTemplate = Spacer,
        stroke = p35,
        ownedKey = p36,
        equippedKey = p37
    };
end;

function u3.selectTab(p38, p39) -- Line: 142
    -- upvalues: u1 (copy), u2 (copy)
    for _, v in p38.lists do
        local v40 = v.category == p39;
        v.scroll.Visible = v40;
        local v41;

        if v40 then
            v41 = u1;
        else
            v41 = u2;
        end;

        v.stroke.Color = v41;
    end;
end;

function u3.buildEntries(p42, p43, p44, u45) -- Line: 149
    -- upvalues: Shovels (copy), SprayBottles (copy), Detectors (copy)
    local v46;

    if p43.category == "shovel" then
        local OwnedShovels = p44.OwnedShovels;
        v46 = table.create(#OwnedShovels);

        local function _(p47) -- Line: 155
            -- upvalues: Shovels (ref)
            return {
                id = p47,
                displayName = Shovels[p47].displayName,
                cost = Shovels[p47].cost
            };
        end;

        for i, v in OwnedShovels do
            local _ = i - 1;
            v46[i] = {
                id = v,
                displayName = Shovels[v].displayName,
                cost = Shovels[v].cost
            };
        end;
    elseif p43.category == "spray" then
        local OwnedSprays = p44.OwnedSprays;
        v46 = table.create(#OwnedSprays);

        local function _(p48) -- Line: 173
            -- upvalues: SprayBottles (ref)
            return {
                id = p48,
                displayName = SprayBottles[p48].displayName,
                cost = SprayBottles[p48].cost
            };
        end;

        for i, v in OwnedSprays do
            local _ = i - 1;
            v46[i] = {
                id = v,
                displayName = SprayBottles[v].displayName,
                cost = SprayBottles[v].cost
            };
        end;
    else
        local OwnedDetectors = p44.OwnedDetectors;
        v46 = table.create(#OwnedDetectors);

        local function _(p49) -- Line: 189
            -- upvalues: Detectors (ref)
            return {
                id = p49,
                displayName = Detectors[p49].displayName,
                cost = Detectors[p49].cost
            };
        end;

        for i, v in OwnedDetectors do
            local _ = i - 1;
            v46[i] = {
                id = v,
                displayName = Detectors[v].displayName,
                cost = Detectors[v].cost
            };
        end;
    end;

    table.sort(v46, function(p50, p51) -- Line: 205
        -- upvalues: u45 (copy)
        local v52 = p50.id == u45;

        if v52 == (p51.id == u45) then
            return p50.cost > p51.cost;
        end;

        return v52;
    end);

    return v46;
end;

function u3.getEquippedId(p53, p54, p55) -- Line: 215
    if p54.category == "shovel" then
        return p55.EquippedShovel;
    end;

    if p54.category == "spray" then
        return p55.EquippedSpray;
    end;

    return p55.EquippedDetector;
end;

function u3.rebuild(u56, u57, p58) -- Line: 224
    for _, child in u57.scroll:GetChildren() do
        if child ~= u57.itemTemplate and (child ~= u57.spacerTemplate and not child:IsA("UIListLayout")) then
            child:Destroy();
        end;
    end;

    local u59 = u56:getEquippedId(u57, p58);
    local v60 = u56:buildEntries(u57, p58, u59);

    local function _(p61, p62) -- Line: 237
        -- upvalues: u56 (copy), u57 (copy), u59 (copy)
        u56:addSpacer(u57, p62 * 2);
        u56:addItemFrame(u57, p61, p62 * 2 + 1, p61.id == u59);
    end;

    for i, v in v60 do
        local v63 = i - 1;
        u56:addSpacer(u57, v63 * 2);
        u56:addItemFrame(u57, v, v63 * 2 + 1, v.id == u59);
    end;

    u56:addSpacer(u57, #v60 * 2);
end;

function u3.addSpacer(p64, p65, p66) -- Line: 247
    local v67 = p65.spacerTemplate:Clone();
    v67.LayoutOrder = p66;
    v67.Visible = true;
    v67.Parent = p65.scroll;
end;

function u3.addItemFrame(u68, u69, u70, p71, p72) -- Line: 253
    -- upvalues: ModelViewport (copy), GearViewport (copy), GearBenefits (copy), u1 (copy), u2 (copy), restoreStrokeThickness (copy)
    local v73 = u69.itemTemplate:Clone();
    v73.Name = u70.id;
    v73.LayoutOrder = p71;
    v73:FindFirstChild("ItemName").Text = u70.displayName;
    local v74 = ModelViewport.replace(v73:FindFirstChild("ImageLabel"));
    GearViewport.setGear(v74, u69.category, u70.id);
    local Benefits = v73:FindFirstChild("Benefits");
    local Template = Benefits:FindFirstChild("Template");
    Template.Visible = false;
    GearBenefits.render(Benefits, Template, GearBenefits.get(u69.category, u70.id));
    local UIStroke = v73:FindFirstChild("UIStroke");
    local v75;

    if p72 then
        v75 = u1;
    else
        v75 = u2;
    end;

    UIStroke.Color = v75;
    v73.Activated:Connect(function() -- Line: 267
        -- upvalues: u68 (copy), u69 (copy), u70 (copy)
        return u68:equip(u69.category, u70.id);
    end);
    v73.Visible = true;
    restoreStrokeThickness(v73);
    v73.Parent = u69.scroll;
end;

function u3.equip(u76, p77, p78) -- Line: 274
    -- upvalues: ShopFunctions (copy)
    if u76.equipping then
        return nil;
    end;

    u76.equipping = true;
    ShopFunctions.equipGear:invoke(p77, p78):catch(function() -- Line: 279
        return false;
    end):andThen(function() -- Line: 281
        -- upvalues: u76 (copy)
        u76.equipping = false;
    end);
end;

function u3.onDataChanged(p79, p80, p81) -- Line: 285
    for _, v in p79.lists do
        if table.find(p80, v.ownedKey) ~= nil or table.find(p80, v.equippedKey) ~= nil then
            p79:rebuild(v, p81);
        end;
    end;
end;

Reflect.defineMetadata(u3, "identifier", "client/controllers/ui/InventoryController@InventoryController");
Reflect.defineMetadata(u3, "flamework:parameters", { "client/controllers/data/DataController@DataController" });
Reflect.defineMetadata(u3, "flamework:implements", { "$:flamework@OnStart", "client/controllers/data/DataController@OnDataChanged" });
Reflect.decorate(u3, "$:flamework@Controller", Controller, { {} });

return {
    InventoryController = u3
};