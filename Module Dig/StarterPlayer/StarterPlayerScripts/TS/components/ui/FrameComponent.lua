-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out");
local Component = v1.Component;
local BaseComponent = v1.BaseComponent;
local TweenService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").TweenService;
local u2 = TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out);
local u3 = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
local u4 = setmetatable({}, {
    __tostring = function() -- Line: 17, Name: __tostring
        return "FrameComponent";
    end,

    __index = BaseComponent
});
u4.__index = u4;

function u4.new(...) -- Line: 23
    -- upvalues: u4 (ref)
    local v5 = setmetatable({}, u4);

    return v5:constructor(...) or v5;
end;

function u4.constructor(p6) -- Line: 27
    -- upvalues: BaseComponent (copy), u4 (ref)
    BaseComponent.constructor(p6);
    p6.isAnimating = false;
    u4.activeFrames[p6.instance.Name] = p6;
end;

function u4.onStart(p7) -- Line: 35
    p7.originalPos = p7.instance.Position;
    p7.originalSize = p7.instance.Size;
end;

function u4.toggleFrame(p8, p9, p10, p11) -- Line: 39
    -- upvalues: u4 (ref)
    local v12 = u4.activeFrames[p9];

    if not v12 then
        return nil;
    end;

    if p10 == nil then
        p10 = not v12.instance.Visible;
    end;

    v12:toggle(p10, p11 == nil and true or p11);
end;

function u4.toggle(p13, p14, p15) -- Line: 52
    -- upvalues: u4 (ref)
    local v16 = p15 == nil and true or p15;

    if p14 == nil then
        p14 = not p13.instance.Visible;
    end;

    if p13.isAnimating and p13.instance.Visible == p14 then
        return nil;
    end;

    if p14 and (u4.activeFrame and u4.activeFrame ~= p13) then
        u4.activeFrame:toggle(false, v16);
    end;

    if p14 then
        u4.activeFrame = p13;

        if v16 then
            p13:animateOpen();
        else
            p13:showInstant();
        end;

        u4.onOpened:Fire(p13.instance.Name);

        return;
    end;

    if u4.activeFrame == p13 then
        u4.activeFrame = nil;
    end;

    if v16 then
        p13:animateClose();
    else
        p13:hideInstant();
    end;

    u4.onClosed:Fire(p13.instance.Name);
end;

function u4.showInstant(p17) -- Line: 83
    if p17.activeTween then
        p17.activeTween:Cancel();
    end;

    p17:ensureOriginals();
    p17.isAnimating = false;
    p17.instance.Position = p17.originalPos;
    p17.instance.Size = p17.originalSize;
    p17.instance.Visible = true;
end;

function u4.hideInstant(p18) -- Line: 93
    -- upvalues: u4 (ref)
    if p18.activeTween then
        p18.activeTween:Cancel();
    end;

    p18:ensureOriginals();
    p18.isAnimating = false;
    p18.instance.Visible = false;
    p18.instance.Position = p18.originalPos;
    p18.instance.Size = p18.originalSize;
    u4.onFullyClosed:Fire(p18.instance.Name);
end;

function u4.ensureOriginals(p19) -- Line: 104
    if not p19.originalPos then
        p19.originalPos = p19.instance.Position;
    end;

    if not p19.originalSize then
        p19.originalSize = p19.instance.Size;
    end;
end;

function u4.clearActiveTween(p20) -- Line: 112
    if p20.activeTween then
        p20.activeTween:Cancel();
        p20.activeTween:Destroy();
        p20.activeTween = nil;
    end;
end;

function u4.animateOpen(u21) -- Line: 119
    -- upvalues: TweenService (copy), u2 (copy)
    u21:clearActiveTween();
    u21:ensureOriginals();
    u21.isAnimating = true;
    local originalPos = u21.originalPos;
    local originalSize = u21.originalSize;
    u21.instance.Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset, originalPos.Y.Scale + 1, originalPos.Y.Offset);
    u21.instance.Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, originalSize.Y.Scale * 0.85, (math.floor(originalSize.Y.Offset * 0.85)));
    u21.instance.Visible = true;
    local u22 = TweenService:Create(u21.instance, u2, {
        Position = originalPos,
        Size = originalSize
    });
    u21.activeTween = u22;
    u22:Play();
    u22.Completed:Once(function() -- Line: 134
        -- upvalues: u21 (copy), u22 (copy)
        u21.isAnimating = false;

        if u21.activeTween == u22 then
            u21:clearActiveTween();
        end;
    end);
end;

function u4.animateClose(u23) -- Line: 142
    -- upvalues: TweenService (copy), u3 (copy), u4 (ref)
    u23:clearActiveTween();
    u23:ensureOriginals();
    u23.isAnimating = true;
    local originalPos = u23.originalPos;
    local v24 = UDim2.new(originalPos.X.Scale, originalPos.X.Offset, originalPos.Y.Scale + 1, originalPos.Y.Offset);
    local u25 = TweenService:Create(u23.instance, u3, {
        Position = v24
    });
    u23.activeTween = u25;
    u25:Play();
    u25.Completed:Once(function(p26) -- Line: 153
        -- upvalues: u23 (copy), originalPos (copy), u4 (ref), u25 (copy)
        u23.isAnimating = false;

        if p26 == Enum.PlaybackState.Completed then
            u23.instance.Visible = false;
            u23.instance.Position = originalPos;
            u23.instance.Size = u23.originalSize;
            u4.onFullyClosed:Fire(u23.instance.Name);
        end;

        if u23.activeTween == u25 then
            u23:clearActiveTween();
        end;
    end);
end;

function u4.destroy(p27) -- Line: 166
    -- upvalues: u4 (ref)
    p27:clearActiveTween();

    if u4.activeFrame == p27 then
        u4.activeFrame = nil;
    end;

    u4.activeFrames[p27.instance.Name] = nil;
end;

u4.activeFrames = {};
u4.onOpened = Instance.new("BindableEvent");
u4.onClosed = Instance.new("BindableEvent");
u4.onFullyClosed = Instance.new("BindableEvent");
Reflect.defineMetadata(u4, "identifier", "client/components/ui/FrameComponent@FrameComponent");
Reflect.defineMetadata(u4, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u4, "$c:components@Component", Component, {
    {
        tag = "Frame",
        attributes = {},
        instanceGuard = t.instanceIsA("Frame")
    }
});

return {
    FrameComponent = u4
};