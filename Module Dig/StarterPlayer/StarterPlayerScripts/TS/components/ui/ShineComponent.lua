-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out");
local Component = v1.Component;
local BaseComponent = v1.BaseComponent;
local Janitor = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "janitor", "src").Janitor;
local TweenService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").TweenService;
local u2 = setmetatable({}, {
    __tostring = function() -- Line: 16, Name: __tostring
        return "ShineComponent";
    end,

    __index = BaseComponent
});
u2.__index = u2;

function u2.new(...) -- Line: 22
    -- upvalues: u2 (ref)
    local v3 = setmetatable({}, u2);

    return v3:constructor(...) or v3;
end;

function u2.constructor(p4, ...) -- Line: 26
    -- upvalues: BaseComponent (copy), Janitor (copy)
    BaseComponent.constructor(p4, ...);
    p4.janitor = Janitor.new();
    p4.running = true;
end;

function u2.onStart(u5) -- Line: 31
    -- upvalues: TweenService (copy)
    local shineInterval = u5.attributes.shineInterval;
    local u6 = shineInterval == nil and 5 or shineInterval;
    local shineDuration = u5.attributes.shineDuration;
    local u7 = shineDuration == nil and 3 or shineDuration;
    u5.instance.ClipsDescendants = true;
    local Frame = Instance.new("Frame");
    Frame.Name = "ShineEffect";
    Frame.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame.BorderSizePixel = 0;
    Frame.Size = UDim2.new(1, 0, 1, 0);
    Frame.BackgroundTransparency = 0;
    local v8 = u5.instance:FindFirstChildOfClass("UICorner");

    if v8 then
        v8:Clone().Parent = Frame;
    end;

    local UIGradient = Instance.new("UIGradient");
    UIGradient.Rotation = 45;
    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.35, 1),
        NumberSequenceKeypoint.new(0.48, 0.55),
        NumberSequenceKeypoint.new(0.5, 0.4),
        NumberSequenceKeypoint.new(0.52, 0.55),
        NumberSequenceKeypoint.new(0.65, 1),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient.Offset = Vector2.new(-1, -1);
    UIGradient.Parent = Frame;
    Frame.Parent = u5.instance;
    u5.janitor:Add(Frame, "Destroy");
    task.spawn(function() -- Line: 60
        -- upvalues: u5 (copy), u6 (copy), UIGradient (copy), TweenService (ref), u7 (copy)
        local shineDelay = u5.attributes.shineDelay;
        local v9 = shineDelay == nil and 0 or shineDelay;

        while u5.running do
            local v10 = os.clock();
            local v11 = math.floor(v10 / u6) * u6 + v9;

            if v11 <= v10 then
                v11 = v11 + u6;
            end;

            task.wait(v11 - os.clock());
            UIGradient.Offset = Vector2.new(-1, -1);
            local v12 = TweenService:Create(UIGradient, TweenInfo.new(u7, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                Offset = Vector2.new(1, 1)
            });
            v12:Play();
            v12.Completed:Wait();
            v12:Destroy();
        end;
    end);
end;

function u2.destroy(p13) -- Line: 86
    p13.running = false;
    p13.janitor:Destroy();
end;

Reflect.defineMetadata(u2, "identifier", "client/components/ui/ShineComponent@ShineComponent");
Reflect.defineMetadata(u2, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u2, "$c:components@Component", Component, {
    {
        tag = "UIShine",
        attributes = {
            shineInterval = t.optional(t.number),
            shineDuration = t.optional(t.number),
            shineDelay = t.optional(t.number)
        },
        instanceGuard = t.instanceIsA("GuiObject")
    }
});

return {
    ShineComponent = u2
};