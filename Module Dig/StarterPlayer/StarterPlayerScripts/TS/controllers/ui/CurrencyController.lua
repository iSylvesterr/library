-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local RunService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").RunService;
local PlayerGui = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "player", "playerConstants").PlayerGui;
local restoreStrokeThickness = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "StrokeThickness").restoreStrokeThickness;
local tweenAndDestroy = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "tween", "playAndDestroy").tweenAndDestroy;
local formatAbbrevMoney = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "formatting", "formatAbbrevMoney").formatAbbrevMoney;
local WFChain = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "instances", "WFChain").WFChain;
local u1 = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u2 = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out);
local u3 = TweenInfo.new(0.1);
local u4 = TweenInfo.new(0.24, Enum.EasingStyle.Back, Enum.EasingDirection.Out);
local u5 = TweenInfo.new(0.42, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
local u6 = TweenInfo.new(0.95, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u7 = Random.new();
local u8 = setmetatable({}, {
    __tostring = function() -- Line: 37, Name: __tostring
        return "CurrencyController";
    end
});
u8.__index = u8;

function u8.new(...) -- Line: 42
    -- upvalues: u8 (ref)
    local v9 = setmetatable({}, u8);

    return v9:constructor(...) or v9;
end;

function u8.constructor(p10, p11) -- Line: 46
    p10.dataController = p11;
    p10.pendingGain = 0;
    p10.initialized = false;
    p10.displayed = 0;
    p10.tickFrom = 0;
    p10.tickTarget = 0;
    p10.tickStart = 0;
end;

function u8.onStart(p12) -- Line: 55
    -- upvalues: WFChain (copy), PlayerGui (copy)
    p12.hud = WFChain(PlayerGui, "HUD");
    local v13 = WFChain(PlayerGui, "HUD", "Currency", "Gold");
    p12.goldLabel = v13;
    p12.popupTemplate = p12:buildPopupTemplate(v13);
    p12.goldFlash = p12:buildFlashOverlay(v13);
    p12.goldScale = Instance.new("UIScale");
    p12.goldScale.Parent = v13;
    p12:snapTo(p12.dataController:getData().Gold);
end;

function u8.onDataChanged(p14, p15, p16) -- Line: 65
    local Gold = p16.Gold;

    if not p14.initialized or Gold <= p14.displayed then
        p14:snapTo(Gold);

        return nil;
    end;

    local v17;

    if p14.tickConnection then
        v17 = p14.tickTarget;
    else
        v17 = p14.displayed;
    end;

    p14:queueGainPopup(Gold - v17);
    p14:punchGoldLabel();
    p14:startTick(Gold);
end;

function u8.buildPopupTemplate(p18, p19) -- Line: 76
    local v20 = p19:Clone();
    v20.Name = "GoldGain";
    v20.TextScaled = false;
    v20.TextWrapped = false;
    v20.TextXAlignment = Enum.TextXAlignment.Center;
    v20.TextYAlignment = Enum.TextYAlignment.Center;
    v20.AutomaticSize = Enum.AutomaticSize.XY;
    v20.Size = UDim2.new();
    v20.AnchorPoint = Vector2.new(0.5, 0.5);
    v20.TextTransparency = 1;
    v20.ZIndex = 50;
    local v21 = v20:FindFirstChildOfClass("UIStroke");

    if v21 then
        v21.Transparency = 1;
    end;

    return v20;
end;

function u8.buildFlashOverlay(p22, p23) -- Line: 94
    local v24 = p23:Clone();
    v24:ClearAllChildren();
    v24.Name = "GoldFlash";
    v24.Position = UDim2.fromScale(0, 0);
    v24.Size = UDim2.fromScale(1, 1);
    v24.TextColor3 = Color3.new(1, 1, 1);
    v24.TextTransparency = 1;
    v24.Parent = p23;

    return v24;
end;

function u8.punchGoldLabel(p25) -- Line: 105
    -- upvalues: tweenAndDestroy (copy), u1 (copy), u2 (copy)
    local goldScale = p25.goldScale;
    local goldFlash = p25.goldFlash;

    if not (goldScale and goldFlash) then
        return nil;
    end;

    tweenAndDestroy(goldScale, u1, {
        Scale = 1.08
    });
    tweenAndDestroy(goldFlash, u1, {
        TextTransparency = 0.2
    });
    task.delay(u1.Time, function() -- Line: 117
        -- upvalues: tweenAndDestroy (ref), goldScale (copy), u2 (ref), goldFlash (copy)
        tweenAndDestroy(goldScale, u2, {
            Scale = 1
        });
        tweenAndDestroy(goldFlash, u2, {
            TextTransparency = 1
        });
    end);
end;

function u8.queueGainPopup(u26, p27) -- Line: 126
    u26.pendingGain = u26.pendingGain + p27;

    if u26.pendingPopup then
        return nil;
    end;

    u26.pendingPopup = task.delay(0.12, function() -- Line: 131
        -- upvalues: u26 (copy)
        u26.pendingPopup = nil;
        local pendingGain = u26.pendingGain;
        u26.pendingGain = 0;
        u26:spawnGainPopup(pendingGain);
    end);
end;

function u8.spawnGainPopup(p28, p29) -- Line: 138
    -- upvalues: u7 (copy), formatAbbrevMoney (copy), restoreStrokeThickness (copy), tweenAndDestroy (copy), u3 (copy), u6 (copy), u4 (copy), u5 (copy)
    local goldLabel = p28.goldLabel;
    local hud = p28.hud;

    if not (goldLabel and (hud and p28.popupTemplate)) then
        return nil;
    end;

    local TextBounds = goldLabel.TextBounds;
    local v30 = goldLabel.AbsolutePosition - hud.AbsolutePosition;
    local v31 = u7:NextNumber(-0.22, 0.22);
    local v32 = UDim2.fromOffset(v30.X + TextBounds.X * (0.5 + v31), v30.Y + goldLabel.AbsoluteSize.Y - TextBounds.Y / 2);
    local v33 = u7:NextNumber(-52, 52);
    local v34 = u7:NextNumber(42, 74);
    local v35 = u7:NextNumber(6, 16) * math.sign(v33);
    local u36 = p28.popupTemplate:Clone();
    u36.Text = `+{formatAbbrevMoney((math.floor(p29)))}`;
    u36.TextSize = TextBounds.Y * 0.6;
    u36.Position = v32;
    u36.Rotation = -v35 * 0.7;
    local UIScale = Instance.new("UIScale");
    UIScale.Scale = 0.45;
    UIScale.Parent = u36;
    restoreStrokeThickness(u36);
    u36.Parent = hud;
    local u37 = u36:FindFirstChildOfClass("UIStroke");
    tweenAndDestroy(u36, u3, {
        TextTransparency = 0
    });
    tweenAndDestroy(u36, u6, {
        Position = v32 + UDim2.fromOffset(v33, -v34),
        Rotation = v35
    });
    tweenAndDestroy(UIScale, u4, {
        Scale = 1
    });

    if u37 then
        tweenAndDestroy(u37, u3, {
            Transparency = 0
        });
    end;

    task.delay(0.5, function() -- Line: 181
        -- upvalues: tweenAndDestroy (ref), u36 (copy), u5 (ref), UIScale (copy), u37 (copy)
        tweenAndDestroy(u36, u5, {
            TextTransparency = 1
        });
        tweenAndDestroy(UIScale, u5, {
            Scale = 1.15
        });

        if u37 then
            tweenAndDestroy(u37, u5, {
                Transparency = 1
            });
        end;
    end);
    task.delay(u6.Time, function() -- Line: 194
        -- upvalues: u36 (copy)
        return u36:Destroy();
    end);
end;

function u8.snapTo(p38, p39) -- Line: 198
    p38:stopTick();
    p38.initialized = true;
    p38.displayed = p39;
    p38:setText(p39);
end;

function u8.startTick(u40, p41) -- Line: 204
    -- upvalues: RunService (copy)
    u40.tickFrom = u40.displayed;
    u40.tickTarget = p41;
    u40.tickStart = os.clock();

    if not u40.tickConnection then
        u40.tickConnection = RunService.Heartbeat:Connect(function() -- Line: 209
            -- upvalues: u40 (copy)
            return u40:step();
        end);
    end;
end;

function u8.step(p42) -- Line: 214
    local v43 = (os.clock() - p42.tickStart) / 0.45;
    local v44 = math.clamp(v43, 0, 1);
    p42.displayed = p42.tickFrom + (p42.tickTarget - p42.tickFrom) * (1 - (1 - v44) ^ 3);

    if v44 >= 1 then
        p42.displayed = p42.tickTarget;
        p42:stopTick();
    end;

    p42:setText(p42.displayed);
end;

function u8.stopTick(p45) -- Line: 224
    local tickConnection = p45.tickConnection;

    if tickConnection ~= nil then
        tickConnection:Disconnect();
    end;

    p45.tickConnection = nil;
end;

function u8.setText(p46, p47) -- Line: 231
    -- upvalues: formatAbbrevMoney (copy)
    local v48 = formatAbbrevMoney((math.floor(p47)));

    if p46.goldLabel then
        p46.goldLabel.Text = v48;
    end;

    if p46.goldFlash then
        p46.goldFlash.Text = v48;
    end;
end;

Reflect.defineMetadata(u8, "identifier", "client/controllers/ui/CurrencyController@CurrencyController");
Reflect.defineMetadata(u8, "flamework:parameters", { "client/controllers/data/DataController@DataController" });
Reflect.defineMetadata(u8, "flamework:implements", { "$:flamework@OnStart", "client/controllers/data/DataController@OnDataChanged" });
Reflect.decorate(u8, "$:flamework@Controller", Controller, { {} });

return {
    CurrencyController = u8
};