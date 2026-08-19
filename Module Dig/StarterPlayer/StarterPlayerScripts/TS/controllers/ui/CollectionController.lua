-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local u1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "object-utils");
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services");
local CollectionService = v2.CollectionService;
local TweenService = v2.TweenService;
local FrameComponent = RuntimeLib.import(script, script.Parent.Parent.Parent, "components", "ui", "FrameComponent").FrameComponent;
local PlayerGui = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "player", "playerConstants").PlayerGui;
local rarityStyleFor = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "ui", "RarityStyles").rarityStyleFor;
local weightStyleFor = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "ui", "WeightStyles").weightStyleFor;
local ItemViewport = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "ItemViewport").ItemViewport;
local ModelViewport = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "ModelViewport").ModelViewport;
local restoreStrokeThickness = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "StrokeThickness").restoreStrokeThickness;
local TextGradient = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "gradient", "TextGradient").TextGradient;
local ItemLabelStyles = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "itemLabels", "ItemLabelStyles").ItemLabelStyles;
local v3 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "items", "Items");
local formatKg = v3.formatKg;
local Items = v3.Items;
local UNDISCOVERABLE_ITEM_IDS = v3.UNDISCOVERABLE_ITEM_IDS;
local formatWithCommas = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "formatting", "formatWithCommas").formatWithCommas;
local WFChain = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "instances", "WFChain").WFChain;
local u4 = Color3.new(1, 1, 1);
local u5 = Color3.new(0, 0, 0);
local u6 = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
local v7 = #u1.keys(Items);
local v8 = 0;

for _ in UNDISCOVERABLE_ITEM_IDS do
    v8 = v8 + 1;
end;

local u9 = v7 - v8;
local u10 = setmetatable({}, {
    __tostring = function() -- Line: 41, Name: __tostring
        return "CollectionController";
    end
});
u10.__index = u10;

function u10.new(...) -- Line: 46
    -- upvalues: u10 (ref)
    local v11 = setmetatable({}, u10);

    return v11:constructor(...) or v11;
end;

function u10.constructor(p12, p13) -- Line: 50
    p12.data = p13;
    p12.cells = {};
    p12.orderedIds = {};
    p12.infoOpen = false;
end;

function u10.onStart(u14) -- Line: 56
    -- upvalues: WFChain (copy), PlayerGui (copy), ModelViewport (copy), FrameComponent (copy)
    local v15 = WFChain(PlayerGui, "Main", "Collection");
    u14.scroll = WFChain(v15, "ScrollingFrame");
    local v16 = WFChain(u14.scroll, "UIGridLayout");
    local v17 = WFChain(u14.scroll, "UIPadding");
    u14.template = WFChain(u14.scroll, "Template");
    u14.completion = WFChain(v15, "CompletionAmount");
    u14.info = WFChain(WFChain(v15, "InformationClipper"), "Information");
    u14.infoName = WFChain(u14.info, "Name");
    u14.infoViewport = ModelViewport.replace(WFChain(u14.info, "ImageLabel"));
    u14.infoQuestionMark = WFChain(u14.infoViewport, "QuestionMark");
    u14.infoRarity = WFChain(u14.info, "Rarity");
    u14.infoHeaviest = WFChain(u14.info, "Heaviest");
    u14.infoBestCondition = WFChain(u14.info, "BestCondition");
    u14.infoTimesFound = WFChain(u14.info, "TimesFound");
    u14.metrics = {
        cellWidthScale = v16.CellSize.X.Scale,
        gapScale = Vector2.new(v16.CellPadding.X.Scale, v16.CellPadding.Y.Scale),
        padLeftScale = v17.PaddingLeft.Scale,
        padRightScale = v17.PaddingRight.Scale,
        padTopScale = v17.PaddingTop.Scale,
        padBottomScale = v17.PaddingBottom.Scale,
        anchor = u14.template.AnchorPoint
    };
    v16:Destroy();
    v17:Destroy();
    u14.scroll.ScrollingDirection = Enum.ScrollingDirection.Y;
    u14.scroll.AutomaticCanvasSize = Enum.AutomaticSize.None;
    u14.template.Visible = false;
    local Position = u14.info.Position;
    u14.infoVisiblePosition = Position;
    u14.infoHiddenPosition = UDim2.new(-(u14.info.Size.X.Scale / 2 + 0.1), 0, Position.Y.Scale, Position.Y.Offset);
    u14:hideInfo();
    u14.scroll:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- Line: 90
        -- upvalues: u14 (copy)
        return u14:relayout();
    end);
    FrameComponent.onFullyClosed.Event:Connect(function(p18) -- Line: 93
        -- upvalues: u14 (copy)
        if p18 == "Collection" then
            u14:hideInfo();
        end;
    end);
    FrameComponent.onOpened.Event:Connect(function(p19) -- Line: 98
        -- upvalues: u14 (copy)
        if p19 == "Collection" and u14.infoOpen then
            u14:hideInfo();
        end;
    end);
    u14:buildCells();
    u14:refresh(u14.data:getData());
end;

function u10.buildCells(u20) -- Line: 106
    -- upvalues: u1 (copy), Items (copy), UNDISCOVERABLE_ITEM_IDS (copy), restoreStrokeThickness (copy), ModelViewport (copy), rarityStyleFor (copy), CollectionService (copy), ItemLabelStyles (copy), ItemViewport (copy)
    local function _(p21) -- Line: 110
        -- upvalues: UNDISCOVERABLE_ITEM_IDS (ref)
        return UNDISCOVERABLE_ITEM_IDS[p21] == nil;
    end;

    local v22 = 0;
    local v23 = {};

    for i, v in u1.keys(Items) do
        local _ = i - 1;

        if UNDISCOVERABLE_ITEM_IDS[v] == nil == true then
            v22 = v22 + 1;
            v23[v22] = v;
        end;
    end;

    table.sort(v23, function(p24, p25) -- Line: 122
        -- upvalues: Items (ref)
        return Items[p24].displayOneIn < Items[p25].displayOneIn;
    end);
    u20.orderedIds = v23;

    for _, v in u20.orderedIds do
        local v26 = u20.template:Clone();
        v26.Name = v;
        restoreStrokeThickness(v26);
        v26.Parent = u20.scroll;
        local v27 = ModelViewport.replace(v26:FindFirstChild("ImageLabel"));
        local QuestionMark = v27:FindFirstChild("QuestionMark");
        local Rarity = v26:FindFirstChild("Rarity");
        local UIGradient = v26:FindFirstChild("UIGradient");
        local v28 = rarityStyleFor(Items[v].rarity);
        UIGradient.Color = v28.gradient or ColorSequence.new(v28.color);

        if v28.rotation ~= nil then
            UIGradient.Rotation = v28.rotation;
        end;

        if v28.animationTag ~= nil then
            CollectionService:AddTag(v26, v28.animationTag);
        end;

        ItemLabelStyles.applyRarity(Rarity, Items[v].displayOneIn, Items[v].rarity);
        ItemViewport.setItem(v27, v);
        v26.Activated:Connect(function() -- Line: 145
            -- upvalues: u20 (copy), v (copy)
            return u20:showInfo(v);
        end);
        v26.Visible = true;
        u20.cells[v] = {
            itemId = v,
            button = v26,
            viewport = v27,
            questionMark = QuestionMark
        };
    end;
end;

function u10.refresh(p29, p30) -- Line: 159
    -- upvalues: UNDISCOVERABLE_ITEM_IDS (copy), u9 (copy)
    for i, v in p29.cells do
        p29:updateCell(v, table.find(p30.Discovered, i) ~= nil);
    end;

    p29:relayout();

    local function _(p31) -- Line: 167
        -- upvalues: UNDISCOVERABLE_ITEM_IDS (ref)
        return UNDISCOVERABLE_ITEM_IDS[p31] == nil;
    end;

    local v32 = 0;
    local v33 = {};

    for i, v in p30.Discovered do
        local _ = i - 1;

        if UNDISCOVERABLE_ITEM_IDS[v] == nil == true then
            v32 = v32 + 1;
            v33[v32] = v;
        end;
    end;

    p29.completion.Text = `{#v33}/{u9} Items Found`;

    if p29.infoOpen and p29.currentItemId ~= nil then
        p29:updateInfo(p29.currentItemId, p30);
    end;
end;

function u10.updateCell(p34, p35, p36) -- Line: 184
    -- upvalues: u4 (copy), u5 (copy)
    local v37;

    if p36 then
        v37 = u4;
    else
        v37 = u5;
    end;

    p35.viewport.ImageColor3 = v37;
    p35.questionMark.Visible = not p36;
end;

function u10.relayout(u38) -- Line: 188
    local AbsoluteSize = u38.scroll.AbsoluteSize;

    if AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0 then
        return nil;
    end;

    local metrics = u38.metrics;
    local gapScale = metrics.gapScale;
    local anchor = metrics.anchor;
    local u39 = metrics.cellWidthScale * AbsoluteSize.X;
    local u40 = gapScale.X * AbsoluteSize.X;
    local u41 = gapScale.Y * AbsoluteSize.Y;
    local u42 = metrics.padLeftScale * AbsoluteSize.X;
    local u43 = metrics.padTopScale * AbsoluteSize.Y;
    local v44 = metrics.padBottomScale * AbsoluteSize.Y;
    local v45 = math.floor((AbsoluteSize.X - u42 - metrics.padRightScale * AbsoluteSize.X + u40) / (u39 + u40) + 0.001);
    local u46 = math.max(1, v45);
    local orderedIds = u38.orderedIds;

    local function v51(p47, p48) -- Line: 212
        -- upvalues: u38 (copy), u46 (copy), u42 (copy), u39 (copy), u40 (copy), anchor (copy), u43 (copy), u39 (copy), u41 (copy)
        local v49 = u38.cells[p47];
        local v50 = math.floor(p48 / u46);
        v49.button.Position = UDim2.fromOffset(u42 + p48 % u46 * (u39 + u40) + anchor.X * u39, u43 + v50 * (u39 + u41) + anchor.Y * u39);
        v49.button.Size = UDim2.fromOffset(u39, u39);
    end;

    for i, v in orderedIds do
        v51(v, i - 1, orderedIds);
    end;

    local v52 = math.ceil(#u38.orderedIds / u46);
    local v53 = u43 + v44 + v52 * u39 + math.max(0, v52 - 1) * u41;
    u38.scroll.CanvasSize = UDim2.fromOffset(0, v53);
end;

function u10.showInfo(u54, p55) -- Line: 229
    -- upvalues: ItemViewport (copy), TweenService (copy), u6 (copy)
    if u54.currentItemId ~= p55 then
        ItemViewport.setItem(u54.infoViewport, p55);
    end;

    u54.currentItemId = p55;
    u54:updateInfo(p55, u54.data:getData());

    if u54.infoOpen then
        return nil;
    end;

    u54.infoOpen = true;
    u54:cancelInfoTween();
    u54.info.Position = u54.infoHiddenPosition;
    u54.info.Visible = true;
    local u56 = TweenService:Create(u54.info, u6, {
        Position = u54.infoVisiblePosition
    });
    u54.infoTween = u56;
    u56:Play();
    u56.Completed:Once(function() -- Line: 247
        -- upvalues: u54 (copy), u56 (copy)
        if u54.infoTween == u56 then
            u56:Destroy();
            u54.infoTween = nil;
        end;
    end);
end;

function u10.hideInfo(p57) -- Line: 254
    p57:cancelInfoTween();
    p57.infoOpen = false;
    p57.currentItemId = nil;
    p57.info.Visible = false;
    p57.info.Position = p57.infoHiddenPosition;
end;

function u10.cancelInfoTween(p58) -- Line: 261
    if p58.infoTween then
        p58.infoTween:Cancel();
        p58.infoTween:Destroy();
        p58.infoTween = nil;
    end;
end;

function u10.updateInfo(p59, p60, p61) -- Line: 268
    -- upvalues: Items (copy), ItemLabelStyles (copy), u4 (copy), u5 (copy), formatWithCommas (copy), rarityStyleFor (copy), formatKg (copy), weightStyleFor (copy)
    local v62 = Items[p60];
    local v63 = table.find(p61.Discovered, p60) ~= nil;
    local v64 = p61.Collection[p60];

    if v63 then
        ItemLabelStyles.applyName(p59.infoName, v62.displayName, v62.rarity);
    else
        p59:setPlain(p59.infoName, "???");
    end;

    local v65;

    if v63 then
        v65 = u4;
    else
        v65 = u5;
    end;

    p59.infoViewport.ImageColor3 = v65;
    p59.infoQuestionMark.Visible = not v63;

    if v64 then
        ItemLabelStyles.applyStyledValue(p59.infoRarity, "Rarest Found: ", `1 in {formatWithCommas(v64.bestOneIn)}`, rarityStyleFor(v62.rarity));
        ItemLabelStyles.applyStyledValue(p59.infoHeaviest, "Heaviest: ", `{formatKg(v64.heaviestKg)} KG`, weightStyleFor(v64.heaviestKg));
        ItemLabelStyles.applyCondition(p59.infoBestCondition, v64.bestCondition, "Best Condition: ");
    else
        ItemLabelStyles.applyRarity(p59.infoRarity, v62.displayOneIn, v62.rarity);
        p59:setPlain(p59.infoHeaviest, "Heaviest: ??? KG");
        p59:setPlain(p59.infoBestCondition, "Best Condition: ???");
    end;

    p59.infoTimesFound.Text = `Times Found: {v64 == nil and 0 or v64.timesFound}`;
end;

function u10.setPlain(p66, p67, p68) -- Line: 292
    -- upvalues: TextGradient (copy), u4 (copy)
    TextGradient.clear(p67);
    p67.TextColor3 = u4;
    p67.Text = p68;
end;

function u10.onDataChanged(p69, p70, p71) -- Line: 297
    if next(p69.cells) == nil then
        return nil;
    end;

    if table.find(p70, "Discovered") == nil and table.find(p70, "Collection") == nil then
        return nil;
    end;

    p69:refresh(p71);
end;

Reflect.defineMetadata(u10, "identifier", "client/controllers/ui/CollectionController@CollectionController");
Reflect.defineMetadata(u10, "flamework:parameters", { "client/controllers/data/DataController@DataController" });
Reflect.defineMetadata(u10, "flamework:implements", { "$:flamework@OnStart", "client/controllers/data/DataController@OnDataChanged" });
Reflect.decorate(u10, "$:flamework@Controller", Controller, { {} });

return {
    CollectionController = u10
};