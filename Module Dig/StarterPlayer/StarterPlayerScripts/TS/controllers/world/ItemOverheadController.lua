-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local Janitor = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "janitor", "src").Janitor;
local ReplicatedStorage = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").ReplicatedStorage;
local Player = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "player", "playerConstants").Player;
local rarityStyleFor = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "ui", "RarityStyles").rarityStyleFor;
local applyGoldGradient = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "gradient", "GoldGradient").applyGoldGradient;
local TextGradient = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "gradient", "TextGradient").TextGradient;
local ItemLabelStyles = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "itemLabels", "ItemLabelStyles").ItemLabelStyles;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "items", "Items");
local effectiveOneIn = v1.effectiveOneIn;
local Items = v1.Items;
local itemValueFor = v1.itemValueFor;
local ItemModel = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "items", "ItemModel").ItemModel;
local WFChain = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "instances", "WFChain").WFChain;
local formatAbbrevMoney = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "formatting", "formatAbbrevMoney").formatAbbrevMoney;
local u2 = Color3.new(1, 1, 1);
local u3 = setmetatable({}, {
    __tostring = function() -- Line: 30, Name: __tostring
        return "ItemOverheadController";
    end
});
u3.__index = u3;

function u3.new(...) -- Line: 35
    -- upvalues: u3 (ref)
    local v4 = setmetatable({}, u3);

    return v4:constructor(...) or v4;
end;

function u3.constructor(p5, p6) -- Line: 39
    -- upvalues: WFChain (copy), ReplicatedStorage (copy), Janitor (copy)
    p5.data = p6;
    p5.template = WFChain(ReplicatedStorage, "Assets", "WorldUI", "ItemOverhead");
    p5.overheads = {};
    p5.janitors = {};
    p5.containerJanitor = Janitor.new();
end;

function u3.onStart(u7) -- Line: 46
    -- upvalues: Player (copy)
    u7:bindContainer(Player.Character);
    Player.CharacterAdded:Connect(function(p8) -- Line: 48
        -- upvalues: u7 (copy)
        return u7:bindContainer(p8);
    end);
    local v9 = Player:FindFirstChildOfClass("Backpack");

    if v9 then
        u7:bindContainer(v9);
    end;

    Player.ChildAdded:Connect(function(p10) -- Line: 55
        -- upvalues: u7 (copy)
        if p10:IsA("Backpack") then
            u7:bindContainer(p10);
        end;
    end);
end;

function u3.onDataChanged(p11, p12, p13) -- Line: 61
    if table.find(p12, "Inventory") == nil and table.find(p12, "Discovered") == nil then
        return nil;
    end;

    for i, v in p11.overheads do
        p11:refresh(i, v, p13);
    end;
end;

function u3.bindContainer(u14, p15) -- Line: 69
    if not p15 then
        return nil;
    end;

    for _, child in p15:GetChildren() do
        u14:tryAttach(child);
    end;

    u14.containerJanitor:Add(p15.ChildAdded:Connect(function(p16) -- Line: 76
        -- upvalues: u14 (copy)
        return u14:tryAttach(p16);
    end), "Disconnect", p15:IsA("Backpack") and "backpack" or "character");
end;

function u3.tryAttach(u17, u18) -- Line: 80
    -- upvalues: Items (copy)
    if not u18:IsA("Tool") or u17.overheads[u18] ~= nil then
        return nil;
    end;

    local v19 = u18:GetAttribute("itemId");

    if v19 == nil or Items[v19] == nil then
        return nil;
    end;

    task.spawn(function() -- Line: 94
        -- upvalues: u17 (copy), u18 (copy)
        return u17:attach(u18);
    end);
end;

function u3.attach(u20, u21) -- Line: 98
    -- upvalues: Items (copy), ItemModel (copy), WFChain (copy), Janitor (copy)
    local Handle = u21:WaitForChild("Handle", 5);

    if not (Handle and Handle:IsA("BasePart")) or (u20.overheads[u21] ~= nil or not u21.Parent) then
        return nil;
    end;

    local v22 = u21:GetAttribute("itemId");

    if v22 == nil or Items[v22] == nil then
        return nil;
    end;

    local v23 = u20.template:Clone();
    v23.Name = "ItemOverhead";
    local overheadOffset = Items[v22].overheadOffset;
    local v24 = u21:GetAttribute("kg");
    local v25 = type(v24) ~= "number" and 1 or ItemModel.scaleFor(v22, v24);

    if overheadOffset then
        v23.StudsOffset = Vector3.new(overheadOffset[1], overheadOffset[2], overheadOffset[3]) * v25;
    end;

    v23.Adornee = Handle;
    local v26 = WFChain(v23, "Frame");
    local u27 = {
        name = WFChain(v26, "Name"),
        condition = WFChain(v26, "Condition"),
        rarity = WFChain(v26, "Rarity"),
        money = WFChain(v26, "Money")
    };
    v23.Parent = Handle;
    local v28 = Janitor.new();
    v28:Add(v23, "Destroy");
    v28:Add(u21.Destroying:Connect(function() -- Line: 135
        -- upvalues: u20 (copy), u21 (copy)
        return u20:detach(u21);
    end), "Disconnect");
    v28:Add(u21:GetAttributeChangedSignal("dirty"):Connect(function() -- Line: 138
        -- upvalues: u20 (copy), u21 (copy), u27 (copy)
        return u20:refresh(u21, u27, u20.data:getDataIfLoaded());
    end), "Disconnect");
    u20.overheads[u21] = u27;
    u20.janitors[u21] = v28;
    u20:refresh(u21, u27, u20.data:getDataIfLoaded());

    if not u20.data:getDataIfLoaded() then
        local v29 = u20.data:getData();

        if u20.overheads[u21] == u27 then
            u20:refresh(u21, u27, v29);
        end;
    end;
end;

function u3.detach(p30, p31) -- Line: 157
    p30.overheads[p31] = nil;
    local v32 = p30.janitors[p31];

    if v32 then
        v32:Destroy();
        p30.janitors[p31] = nil;
    end;
end;

function u3.refresh(p33, p34, p35, p36) -- Line: 171
    -- upvalues: Items (copy), ItemLabelStyles (copy), effectiveOneIn (copy), applyGoldGradient (copy), formatAbbrevMoney (copy), itemValueFor (copy)
    local u37 = p34:GetAttribute("itemId");

    if u37 == nil or Items[u37] == nil then
        return nil;
    end;

    local v38 = p34:GetAttribute("kg");

    if type(v38) ~= "number" then
        v38 = Items[u37].averageKg;
    end;

    local u39 = p34:GetAttribute("inventoryId");

    if p34:GetAttribute("dirty") ~= false then
        p33:showUnknown(p35, u37, v38);

        return nil;
    end;

    if p36 ~= nil then
        local function _(p40) -- Line: 187
            -- upvalues: u39 (copy), u37 (copy)
            local v41;

            if p40.uid == u39 and p40.id == u37 then
                v41 = not p40.dirty and p40.condition ~= nil;
            else
                v41 = false;
            end;

            return v41;
        end;

        p36 = nil;

        for i, v in p36.Inventory do
            local _ = i - 1;
            local v42;

            if v.uid == u39 and v.id == u37 then
                v42 = not v.dirty and v.condition ~= nil;
            else
                v42 = false;
            end;

            if v42 == true then
                p36 = v;
                break;
            end;
        end;
    end;

    if p36 ~= nil then
        p36 = p36.condition;
    end;

    if p36 == nil then
        p33:showUnknown(p35, u37, v38);

        return nil;
    end;

    ItemLabelStyles.applyItemName(p35.name, Items[u37].displayName, v38, Items[u37].rarity);
    ItemLabelStyles.applyCondition(p35.condition, p36);
    ItemLabelStyles.applyRarity(p35.rarity, effectiveOneIn(u37, p36, v38), Items[u37].rarity);
    p35.money.RichText = false;
    applyGoldGradient(p35.money);
    p35.money.Text = formatAbbrevMoney(itemValueFor(u37, p36, v38));
end;

function u3.showUnknown(p43, p44, p45, p46) -- Line: 217
    -- upvalues: TextGradient (copy), u2 (copy), ItemLabelStyles (copy), Items (copy), rarityStyleFor (copy), applyGoldGradient (copy)
    for _, v in {
        p44.name,
        p44.condition,
        p44.rarity,
        p44.money
    } do
        TextGradient.clear(v);
        v.RichText = false;
        v.TextColor3 = u2;
    end;

    ItemLabelStyles.applyItemName(p44.name, "???", p46, Items[p45].rarity);
    p44.condition.Text = "Condition: ???";
    ItemLabelStyles.applyStyledValue(p44.rarity, "1 in ", "???", rarityStyleFor(Items[p45].rarity));
    applyGoldGradient(p44.money);
    p44.money.Text = "?¢";
end;

Reflect.defineMetadata(u3, "identifier", "client/controllers/world/ItemOverheadController@ItemOverheadController");
Reflect.defineMetadata(u3, "flamework:parameters", { "client/controllers/data/DataController@DataController" });
Reflect.defineMetadata(u3, "flamework:implements", { "$:flamework@OnStart", "client/controllers/data/DataController@OnDataChanged" });
Reflect.decorate(u3, "$:flamework@Controller", Controller, { {} });

return {
    ItemOverheadController = u3
};