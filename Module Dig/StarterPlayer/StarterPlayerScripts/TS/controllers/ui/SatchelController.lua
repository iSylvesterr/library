-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local PlayerGui = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "player", "playerConstants").PlayerGui;
local weightStyleFor = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "ui", "WeightStyles").weightStyleFor;
local TextGradient = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "gradient", "TextGradient").TextGradient;
local ItemLabelStyles = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "itemLabels", "ItemLabelStyles").ItemLabelStyles;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "items", "Items");
local formatKg = v1.formatKg;
local Items = v1.Items;
local UNKNOWN_ITEM_NAME = v1.UNKNOWN_ITEM_NAME;
local unknownRarityFrom = v1.unknownRarityFrom;
local u2 = Color3.new(1, 1, 1);
local u3 = Color3.new(0, 0, 0);
local u4 = {};

for i, v in pairs(Items) do
    u4[v.displayName] = i;
end;

local u5 = setmetatable({}, {
    __tostring = function() -- Line: 28, Name: __tostring
        return "SatchelController";
    end
});
u5.__index = u5;

function u5.new(...) -- Line: 33
    -- upvalues: u5 (ref)
    local v6 = setmetatable({}, u5);

    return v6:constructor(...) or v6;
end;

function u5.constructor(p7) -- Line: 37
    p7.slots = {};
end;

function u5.onStart(u8) -- Line: 40
    -- upvalues: PlayerGui (copy)
    task.spawn(function() -- Line: 41
        -- upvalues: PlayerGui (ref), u8 (copy)
        local BackpackGui = PlayerGui:WaitForChild("BackpackGui", 30);

        if not BackpackGui then
            return nil;
        end;

        BackpackGui.DescendantAdded:Connect(function(p9) -- Line: 46
            -- upvalues: u8 (ref)
            return u8:tryAttach(p9);
        end);

        for _, descendant in BackpackGui:GetDescendants() do
            u8:tryAttach(descendant);
        end;
    end);
end;

function u5.tryAttach(u10, u11) -- Line: 54
    -- upvalues: u3 (copy)
    if not u11:IsA("TextLabel") then
        return nil;
    end;

    local Parent = u11.Parent;

    if not (Parent and Parent:IsA("TextButton")) then
        return nil;
    end;

    if u11.Name == "Number" then
        u11.TextTransparency = 1;
        u11.TextStrokeTransparency = 1;

        return nil;
    end;

    if u11.Name ~= "ToolName" or u10.slots[u11] ~= nil then
        return nil;
    end;

    Parent.BackgroundColor3 = u3;
    Parent.BackgroundTransparency = 0.25;
    Parent:GetPropertyChangedSignal("BackgroundTransparency"):Connect(function() -- Line: 78
        -- upvalues: Parent (copy)
        if Parent.BackgroundTransparency ~= 0.25 then
            Parent.BackgroundTransparency = 0.25;
        end;
    end);
    local u12 = {
        native = u11,
        nativeStrokeTransparency = u11.TextStrokeTransparency,
        displayName = u10:createLabel(Parent, u11, "NameLabel", UDim2.fromScale(0.5, 0.43), Vector2.new(0.5, 0.5), UDim2.fromScale(0.92, 0.55), false, 16),
        weight = u10:createLabel(Parent, u11, "WeightLabel", UDim2.fromScale(0.5, 0.97), Vector2.new(0.5, 1), UDim2.fromScale(0.94, 0.22), true)
    };
    u10.slots[u11] = u12;
    u11:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 92
        -- upvalues: u10 (copy), u12 (copy)
        return u10:render(u12);
    end);
    u11:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 95
        -- upvalues: u10 (copy), u12 (copy)
        return u10:render(u12);
    end);
    u11.Destroying:Connect(function() -- Line: 98
        -- upvalues: u10 (copy), u11 (copy)
        local slots = u10.slots;
        local v13 = u11;
        local v14 = slots[v13] ~= nil;
        slots[v13] = nil;

        return v14;
    end);
    u10:render(u12);
end;

function u5.createLabel(p15, p16, p17, p18, p19, p20, p21, p22, p23) -- Line: 109
    -- upvalues: u2 (copy)
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = p18;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Position = p19;
    TextLabel.AnchorPoint = p20;
    TextLabel.Size = p21;
    local v24;

    if p22 then
        v24 = Enum.FontStyle.Italic;
    else
        v24 = Enum.FontStyle.Normal;
    end;

    TextLabel.FontFace = Font.new(p17.FontFace.Family, Enum.FontWeight.Bold, v24);
    TextLabel.TextColor3 = u2;
    TextLabel.TextStrokeColor3 = p17.TextStrokeColor3;
    TextLabel.TextStrokeTransparency = p17.TextStrokeTransparency;
    TextLabel.TextWrapped = true;

    if p23 == nil then
        TextLabel.TextScaled = true;
    else
        TextLabel.TextScaled = false;
        TextLabel.TextSize = p23;
    end;

    TextLabel.Text = "";
    TextLabel.Visible = false;
    TextLabel.ZIndex = 2;
    TextLabel.Parent = p16;

    return TextLabel;
end;

function u5.render(p25, p26) -- Line: 133
    local native = p26.native;
    local v27, v28 = string.match(native.Text, "^(.+) %(([%d%.]+) KG%)$");
    local v29 = tonumber(v28);

    if not native.Visible or (v27 == nil or v29 == nil) then
        native.TextTransparency = 0;
        native.TextStrokeTransparency = p26.nativeStrokeTransparency;
        p26.displayName.Visible = false;
        p26.weight.Visible = false;

        return nil;
    end;

    native.TextTransparency = 1;
    native.TextStrokeTransparency = 1;
    p25:renderName(p26.displayName, (tostring(v27)));
    p25:renderWeight(p26.weight, v29);
    p26.displayName.Visible = true;
    p26.weight.Visible = true;
end;

function u5.renderName(p30, p31, p32) -- Line: 152
    -- upvalues: unknownRarityFrom (copy), ItemLabelStyles (copy), UNKNOWN_ITEM_NAME (copy), u4 (copy), TextGradient (copy), u2 (copy), Items (copy)
    local v33 = unknownRarityFrom(p32);

    if v33 ~= nil then
        ItemLabelStyles.applyName(p31, UNKNOWN_ITEM_NAME, v33);

        return nil;
    end;

    local v34 = u4[p32];

    if v34 == nil then
        TextGradient.clear(p31);
        p31.RichText = false;
        p31.Text = p32;
        p31.TextColor3 = u2;

        return nil;
    end;

    ItemLabelStyles.applyName(p31, p32, Items[v34].rarity);
end;

function u5.renderWeight(p35, p36, p37) -- Line: 169
    -- upvalues: weightStyleFor (copy), formatKg (copy), u2 (copy), TextGradient (copy)
    local v38 = weightStyleFor(p37);
    p36.Text = `[{formatKg(p37)}KG]`;

    if v38.gradient then
        p36.TextColor3 = u2;
        TextGradient.apply(p36, v38.gradient, 0, v38.animationTag);

        return;
    end;

    TextGradient.clear(p36);
    p36.TextColor3 = v38.color;
end;

Reflect.defineMetadata(u5, "identifier", "client/controllers/ui/SatchelController@SatchelController");
Reflect.defineMetadata(u5, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u5, "$:flamework@Controller", Controller, { {} });

return {
    SatchelController = u5
};