-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out");
local Component = v1.Component;
local BaseComponent = v1.BaseComponent;
local Janitor = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "janitor", "src").Janitor;
local CharacterUtils = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "world", "CharacterUtils").CharacterUtils;
local u2 = setmetatable({}, {
    __tostring = function() -- Line: 14, Name: __tostring
        return "FramePartComponent";
    end,

    __index = BaseComponent
});
u2.__index = u2;

function u2.new(...) -- Line: 20
    -- upvalues: u2 (ref)
    local v3 = setmetatable({}, u2);

    return v3:constructor(...) or v3;
end;

function u2.constructor(p4, p5, p6) -- Line: 24
    -- upvalues: BaseComponent (copy), Janitor (copy)
    BaseComponent.constructor(p4);
    p4.components = p5;
    p4.uiController = p6;
    p4.janitor = Janitor.new();
end;

function u2.onStart(u7) -- Line: 30
    -- upvalues: CharacterUtils (copy)
    u7.janitor:Add(u7.instance.Touched:Connect(function(p8) -- Line: 31
        -- upvalues: CharacterUtils (ref), u7 (copy)
        local v9 = CharacterUtils.getCharacter();

        if not v9 then
            return nil;
        end;

        if not p8:IsDescendantOf(v9) then
            return nil;
        end;

        local function _(p10) -- Line: 41
            -- upvalues: u7 (ref)
            return p10.instance.Name == u7.attributes.name;
        end;

        local v11 = nil;

        for i, v in u7.components:getAllComponents("client/components/ui/FrameComponent@FrameComponent") do
            local _ = i - 1;

            if v.instance.Name == u7.attributes.name == true then
                v11 = v;
                break;
            end;
        end;

        if v11 and not v11.instance.Visible then
            v11:toggle(true);
        end;
    end));
end;

function u2.destroy(p12) -- Line: 58
    p12.janitor:Destroy();
end;

Reflect.defineMetadata(u2, "identifier", "client/components/ui/FramePartComponent@FramePartComponent");
Reflect.defineMetadata(u2, "flamework:parameters", { "$c:components@Components", "client/controllers/ui/UIController@UIController" });
Reflect.defineMetadata(u2, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u2, "$c:components@Component", Component, {
    {
        tag = "FramePart",
        attributes = {
            name = t.string
        },
        instanceGuard = t.instanceIsA("BasePart")
    }
});

return {
    FramePartComponent = u2
};