-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local PlayerGui = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "player", "playerConstants").PlayerGui;
local DIG_PROGRESS_START = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "digging", "DiggingConfig").DIG_PROGRESS_START;
local WFChain = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "instances", "WFChain").WFChain;
local u1 = setmetatable({}, {
    __tostring = function() -- Line: 15, Name: __tostring
        return "DigBarController";
    end
});
u1.__index = u1;

function u1.new(...) -- Line: 20
    -- upvalues: u1 (ref)
    local v2 = setmetatable({}, u1);

    return v2:constructor(...) or v2;
end;

function u1.constructor(p3) -- Line: 24
    -- upvalues: DIG_PROGRESS_START (copy)
    p3.innerY = UDim.new(1, 0);
    p3.shovelY = UDim.new();
    p3.shovelScaleOffset = 0;
    p3.shovelPixelOffset = 0;
    p3.target = DIG_PROGRESS_START;
    p3.displayed = DIG_PROGRESS_START;
    p3.shake = 0;
    p3.initialized = false;
    p3.pendingVisible = false;
end;

function u1.onStart(p4) -- Line: 35
    -- upvalues: WFChain (copy), PlayerGui (copy), DIG_PROGRESS_START (copy)
    p4.screen = WFChain(PlayerGui, "DigGui");
    p4.bar = WFChain(p4.screen, "DigBar");
    p4.inner = WFChain(p4.bar, "Inner");
    p4.shovel = WFChain(p4.bar, "Shovel");
    p4.percentage = WFChain(p4.bar, "Percentage");
    p4.bar.Active = true;
    p4.innerY = p4.inner.Size.Y;
    p4.shovelY = p4.shovel.Position.Y;
    p4.shovelScaleOffset = p4.shovel.Position.X.Scale - p4.inner.Size.X.Scale;
    p4.shovelPixelOffset = p4.shovel.Position.X.Offset;
    p4:apply(DIG_PROGRESS_START);
    p4.bar.Visible = false;
    p4.screen.Enabled = false;
    p4.initialized = true;

    if p4.pendingVisible then
        p4:show();
    end;
end;

function u1.onRender(p5, p6) -- Line: 54
    if not (p5.initialized and p5.screen.Enabled) then
        return nil;
    end;

    p5.displayed = p5.displayed + (p5.target - p5.displayed) * (1 - math.exp(-22 * p6));
    p5.shake = p5.shake * math.exp(-10 * p6);
    p5:apply(p5.displayed);
    local shovel = p5.shovel;
    local v7 = os.clock() * 54;
    shovel.Rotation = math.sin(v7) * 7 * p5.shake;
end;

function u1.show(p8) -- Line: 63
    -- upvalues: DIG_PROGRESS_START (copy)
    p8.pendingVisible = true;

    if not p8.initialized then
        return nil;
    end;

    p8.target = DIG_PROGRESS_START;
    p8.displayed = DIG_PROGRESS_START;
    p8.shake = 0;
    p8:apply(DIG_PROGRESS_START);
    p8.bar.Visible = true;
    p8.screen.Enabled = true;
end;

function u1.hide(p9) -- Line: 75
    p9.pendingVisible = false;

    if not p9.initialized then
        return nil;
    end;

    p9.bar.Visible = false;
    p9.screen.Enabled = false;
    p9.shovel.Rotation = 0;
end;

function u1.setProgress(p10, p11) -- Line: 84
    p10.target = math.clamp(p11, 0, 1);
end;

function u1.kick(p12) -- Line: 87
    p12.shake = 1;
end;

function u1.apply(p13, p14) -- Line: 90
    p13.inner.Size = UDim2.new(p14, 0, p13.innerY.Scale, p13.innerY.Offset);
    p13.shovel.Position = UDim2.new(p14 + p13.shovelScaleOffset, p13.shovelPixelOffset, p13.shovelY.Scale, p13.shovelY.Offset);
    p13.percentage.Text = `{math.floor(p14 * 100)}%`;
end;

Reflect.defineMetadata(u1, "identifier", "client/controllers/world/DigBarController@DigBarController");
Reflect.defineMetadata(u1, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnRender" });
Reflect.decorate(u1, "$:flamework@Controller", Controller, { {} });

return {
    DigBarController = u1
};