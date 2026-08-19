-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out");
local Component = v1.Component;
local BaseComponent = v1.BaseComponent;
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services");
local TweenService = v2.TweenService;
local UserInputService = v2.UserInputService;
local Janitor = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "janitor", "src").Janitor;
local playSound = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "sound", "SoundUtil").playSound;
local u3 = setmetatable({}, {
    __tostring = function() -- Line: 17, Name: __tostring
        return "ButtonComponent";
    end,

    __index = BaseComponent
});
u3.__index = u3;

function u3.new(...) -- Line: 23
    -- upvalues: u3 (ref)
    local v4 = setmetatable({}, u3);

    return v4:constructor(...) or v4;
end;

function u3.constructor(p5, p6) -- Line: 27
    -- upvalues: BaseComponent (copy), UserInputService (copy), Janitor (copy)
    BaseComponent.constructor(p5);
    p5.components = p6;
    p5.uiScale = p5.instance:FindFirstChild("UIScale") or Instance.new("UIScale");
    p5.isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled;
    p5.buttonJanitor = Janitor.new();
    p5.hovering = false;
    p5.pressed = false;
end;

function u3.onStart(u7) -- Line: 36
    -- upvalues: playSound (copy)
    if u7.instance:IsA("GuiButton") then
        u7.clickableButton = u7.instance;
    else
        local ImageButton = u7.instance:WaitForChild("ImageButton", 10);

        if not ImageButton then
            return nil;
        end;

        u7.clickableButton = ImageButton;
    end;

    u7.uiScale.Parent = u7.instance;
    u7.buttonJanitor:Add(u7.instance.MouseEnter:Connect(function() -- Line: 47
        -- upvalues: u7 (copy), playSound (ref)
        u7.hovering = true;

        if u7.pressed then
            return nil;
        end;

        u7:scaleUp();

        if not u7.isMobile then
            playSound("Hover", {
                volume = 0.05
            });
        end;
    end), "Disconnect");
    u7.buttonJanitor:Add(u7.instance.MouseLeave:Connect(function() -- Line: 59
        -- upvalues: u7 (copy)
        u7.hovering = false;

        if u7.pressed then
            return nil;
        end;

        u7:scaleDown();
    end), "Disconnect");
    u7.buttonJanitor:Add(u7.clickableButton.MouseButton1Down:Connect(function() -- Line: 66
        -- upvalues: u7 (copy)
        u7:press();
    end), "Disconnect");
    u7.buttonJanitor:Add(function() -- Line: 69
        -- upvalues: u7 (copy)
        local releaseConnection = u7.releaseConnection;

        if releaseConnection ~= nil then
            releaseConnection = releaseConnection:Disconnect();
        end;

        return releaseConnection;
    end);
end;

function u3.destroy(p8) -- Line: 77
    p8.buttonJanitor:Destroy();
end;

function u3.press(u9) -- Line: 80
    -- upvalues: playSound (copy), UserInputService (copy)
    u9.pressed = true;
    playSound("Pop", {
        volume = 0.03
    });
    u9:click();
    local releaseConnection = u9.releaseConnection;

    if releaseConnection ~= nil then
        releaseConnection:Disconnect();
    end;

    u9.releaseConnection = UserInputService.InputEnded:Connect(function(p10) -- Line: 90
        -- upvalues: u9 (copy)
        if p10.UserInputType == Enum.UserInputType.MouseButton1 or p10.UserInputType == Enum.UserInputType.Touch then
            u9:release();
        end;
    end);
end;

function u3.release(p11) -- Line: 96
    local releaseConnection = p11.releaseConnection;

    if releaseConnection ~= nil then
        releaseConnection:Disconnect();
    end;

    p11.releaseConnection = nil;
    p11.pressed = false;

    if p11.hovering then
        p11:scaleUp();

        return;
    end;

    p11:scaleDown();
end;

function u3.scaleUp(p12) -- Line: 109
    p12:tweenSize(1.02);
end;

function u3.scaleDown(p13) -- Line: 112
    p13:tweenSize(1);
end;

function u3.click(p14) -- Line: 115
    p14:tweenSize(0.98);

    if p14.instance:HasTag("FrameButton") then
        local Frame = p14.instance:WaitForChild("Frame", 10);

        if not Frame then
            return nil;
        end;

        local Value = Frame.Value;
        local v15 = p14.components:getComponent(Value, "client/components/ui/FrameComponent@FrameComponent");

        if v15 then
            v15:toggle(not Value.Visible);
        end;
    end;
end;

function u3.tweenSize(p16, p17, u18) -- Line: 129
    -- upvalues: TweenService (copy)
    local v19 = TweenInfo.new(0.05, Enum.EasingStyle.Quad);
    local v20 = TweenService:Create(p16.uiScale, v19, {
        Scale = p17
    });
    v20:Play();

    if u18 then
        v20.Completed:Once(function() -- Line: 136
            -- upvalues: u18 (copy)
            return u18();
        end);
    end;
end;

Reflect.defineMetadata(u3, "identifier", "client/components/ui/ButtonComponent@ButtonComponent");
Reflect.defineMetadata(u3, "flamework:parameters", { "$c:components@Components" });
Reflect.defineMetadata(u3, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u3, "$c:components@Component", Component, {
    {
        tag = "Button",
        attributes = {},
        instanceGuard = t.union(t.instanceIsA("Frame"), t.instanceIsA("GuiButton"))
    }
});

return {
    ButtonComponent = u3
};