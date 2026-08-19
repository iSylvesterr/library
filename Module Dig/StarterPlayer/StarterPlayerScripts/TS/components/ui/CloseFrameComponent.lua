-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out");
local Component = v1.Component;
local BaseComponent = v1.BaseComponent;
local FrameComponent = RuntimeLib.import(script, script.Parent, "FrameComponent").FrameComponent;
local CollectionService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").CollectionService;
local Janitor = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "janitor", "src").Janitor;
local u2 = setmetatable({}, {
    __tostring = function() -- Line: 15, Name: __tostring
        return "CloseFrameComponent";
    end,

    __index = BaseComponent
});
u2.__index = u2;

function u2.new(...) -- Line: 21
    -- upvalues: u2 (ref)
    local v3 = setmetatable({}, u2);

    return v3:constructor(...) or v3;
end;

function u2.constructor(p4, p5) -- Line: 25
    -- upvalues: BaseComponent (copy), Janitor (copy)
    BaseComponent.constructor(p4);
    p4.uiController = p5;
    p4.janitor = Janitor.new();
end;

function u2.onStart(u6) -- Line: 30
    -- upvalues: CollectionService (copy), FrameComponent (copy)
    u6.janitor:Add(u6.instance.MouseButton1Click:Connect(function() -- Line: 31
        -- upvalues: CollectionService (ref), u6 (copy), FrameComponent (ref)
        for _, v in CollectionService:GetTagged("Frame") do
            if u6.instance:IsDescendantOf(v) then
                FrameComponent:toggleFrame(v.Name);

                return;
            end;
        end;
    end), "Disconnect");
end;

function u2.destroy(p7) -- Line: 40
    p7.janitor:Destroy();
end;

Reflect.defineMetadata(u2, "identifier", "client/components/ui/CloseFrameComponent@CloseFrameComponent");
Reflect.defineMetadata(u2, "flamework:parameters", { "client/controllers/ui/UIController@UIController" });
Reflect.defineMetadata(u2, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u2, "$c:components@Component", Component, {
    {
        tag = "CloseFrame",
        attributes = {},
        instanceGuard = t.instanceIsA("GuiButton")
    }
});

return {
    CloseFrameComponent = u2
};