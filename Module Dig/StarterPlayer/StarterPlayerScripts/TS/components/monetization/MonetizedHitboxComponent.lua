-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out");
local Component = v1.Component;
local BaseComponent = v1.BaseComponent;
local Janitor = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "janitor", "src").Janitor;
local CharacterUtils = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "world", "CharacterUtils").CharacterUtils;
local promptMonetizedItem = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "monetization", "promptMonetizedItem").promptMonetizedItem;
local u2 = setmetatable({}, {
    __tostring = function() -- Line: 15, Name: __tostring
        return "MonetizedHitbox";
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
end;

function u2.onStart(u5) -- Line: 29
    -- upvalues: CharacterUtils (copy), promptMonetizedItem (copy)
    u5.janitor:Add(u5.instance.Touched:Connect(function(p6) -- Line: 30
        -- upvalues: CharacterUtils (ref), promptMonetizedItem (ref), u5 (copy)
        local v7 = CharacterUtils.waitForCharacter();
        local Parent = p6.Parent;

        if Parent ~= nil then
            Parent = Parent:IsDescendantOf(v7);
        end;

        if not Parent then
            return nil;
        end;

        promptMonetizedItem(u5.attributes.name);
    end));
end;

function u2.destroy(p8) -- Line: 42
    p8.janitor:Destroy();
end;

Reflect.defineMetadata(u2, "identifier", "client/components/monetization/MonetizedHitboxComponent@MonetizedHitbox");
Reflect.defineMetadata(u2, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u2, "$c:components@Component", Component, {
    {
        tag = "MonetizedHitbox",
        attributes = {
            name = t.string
        },
        instanceGuard = t.instanceIsA("BasePart")
    }
});

return {
    MonetizedHitbox = u2
};