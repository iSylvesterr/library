-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out");
local Component = v1.Component;
local BaseComponent = v1.BaseComponent;
local Janitor = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "janitor", "src").Janitor;
local robuxIcon = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "symbols", "stringSymbols").robuxIcon;
local getMonetizedItemPrice = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "monetization", "getMonetizedItemPrice").getMonetizedItemPrice;
local u2 = setmetatable({}, {
    __tostring = function() -- Line: 15, Name: __tostring
        return "ShopPriceComponent";
    end,

    __index = BaseComponent
});
u2.__index = u2;

function u2.new(...) -- Line: 21
    -- upvalues: u2 (ref)
    local v3 = setmetatable({}, u2);

    return v3:constructor(...) or v3;
end;

function u2.constructor(p4, ...) -- Line: 25
    -- upvalues: BaseComponent (copy), Janitor (copy)
    BaseComponent.constructor(p4, ...);
    p4.janitor = Janitor.new();
    p4.currentToken = 0;
end;

function u2.onStart(u5) -- Line: 30
    u5:refresh();
    u5.janitor:Add(u5.instance:GetAttributeChangedSignal("name"):Connect(function() -- Line: 32
        -- upvalues: u5 (copy)
        u5:refresh();
    end), "Disconnect");
    u5.janitor:Add(u5.instance:GetAttributeChangedSignal("overrideText"):Connect(function() -- Line: 35
        -- upvalues: u5 (copy)
        u5:refresh();
    end), "Disconnect");
end;

function u2.destroy(p6) -- Line: 39
    p6.janitor:Destroy();
end;

u2.refresh = RuntimeLib.async(function(p7) -- Line: 42
    -- upvalues: robuxIcon (copy), RuntimeLib (copy), getMonetizedItemPrice (copy)
    local overrideText = p7.attributes.overrideText;

    if overrideText ~= nil and overrideText ~= "" then
        p7.currentToken = p7.currentToken + 1;
        p7.instance.Text = overrideText;

        return nil;
    end;

    local name = p7.attributes.name;

    if name == nil then
        p7.instance.Text = `{robuxIcon}0`;

        return nil;
    end;

    p7.currentToken = p7.currentToken + 1;
    local currentToken = p7.currentToken;
    local v8 = RuntimeLib.await(getMonetizedItemPrice(name));

    if currentToken ~= p7.currentToken then
        return nil;
    end;

    if not p7.instance.Parent then
        return nil;
    end;

    p7.instance.Text = `{robuxIcon}{v8}`;
end);
Reflect.defineMetadata(u2, "identifier", "client/components/monetization/ShopPriceComponent@ShopPriceComponent");
Reflect.defineMetadata(u2, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u2, "$c:components@Component", Component, {
    {
        tag = "ShopPrice",
        attributes = {
            name = t.string,
            overrideText = t.optional(t.string)
        },
        instanceGuard = t.union(t.instanceIsA("TextButton"), t.instanceIsA("TextLabel"))
    }
});

return {
    ShopPriceComponent = u2
};