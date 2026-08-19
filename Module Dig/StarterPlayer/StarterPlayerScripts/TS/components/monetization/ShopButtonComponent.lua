-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out");
local Component = v1.Component;
local BaseComponent = v1.BaseComponent;
local Janitor = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "janitor", "src").Janitor;
local promptMonetizedItem = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "monetization", "promptMonetizedItem").promptMonetizedItem;
local u2 = setmetatable({}, {
    __tostring = function() -- Line: 14, Name: __tostring
        return "ShopButtonComponent";
    end,

    __index = BaseComponent
});
u2.__index = u2;

function u2.new(...) -- Line: 20
    -- upvalues: u2 (ref)
    local v3 = setmetatable({}, u2);

    return v3:constructor(...) or v3;
end;

function u2.constructor(p4, p5) -- Line: 24
    -- upvalues: BaseComponent (copy), Janitor (copy)
    BaseComponent.constructor(p4);
    p4.surfaceButtons = p5;
    p4.janitor = Janitor.new();
end;

function u2.onStart(u6) -- Line: 29
    -- upvalues: promptMonetizedItem (copy)
    u6.janitor:Add(u6.surfaceButtons:connect(u6.instance, function() -- Line: 30
        -- upvalues: u6 (copy), promptMonetizedItem (ref)
        if u6.attributes.suppressPrompt == true then
            return nil;
        end;

        local name = u6.attributes.name;

        if name == nil then
            return nil;
        end;

        promptMonetizedItem(name);
    end));
end;

function u2.destroy(p7) -- Line: 41
    p7.janitor:Destroy();
end;

Reflect.defineMetadata(u2, "identifier", "client/components/monetization/ShopButtonComponent@ShopButtonComponent");
Reflect.defineMetadata(u2, "flamework:parameters", { "client/controllers/ui/SurfaceButtonController@SurfaceButtonController" });
Reflect.defineMetadata(u2, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u2, "$c:components@Component", Component, {
    {
        tag = "ShopButton",
        attributes = {
            name = t.string,
            suppressPrompt = t.optional(t.boolean)
        },
        instanceGuard = t.instanceIsA("GuiButton")
    }
});

return {
    ShopButtonComponent = u2
};