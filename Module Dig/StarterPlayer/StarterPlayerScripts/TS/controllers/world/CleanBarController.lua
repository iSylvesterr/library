-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local TweenService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").TweenService;
local PlayerGui = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "player", "playerConstants").PlayerGui;
local ItemsEvents = RuntimeLib.import(script, script.Parent.Parent.Parent, "network", "ItemsNetwork").ItemsEvents;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "monetization", "Passes");
local INSTANT_CLEAN_PASS_NAME = v1.INSTANT_CLEAN_PASS_NAME;
local ownsPass = v1.ownsPass;
local WFChain = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "instances", "WFChain").WFChain;
local u2 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u3 = setmetatable({}, {
    __tostring = function() -- Line: 16, Name: __tostring
        return "CleanBarController";
    end
});
u3.__index = u3;

function u3.new(...) -- Line: 21
    -- upvalues: u3 (ref)
    local v4 = setmetatable({}, u3);

    return v4:constructor(...) or v4;
end;

function u3.constructor(p5, p6) -- Line: 25
    p5.dataController = p6;
    p5.freeSkips = 0;
    p5.ownsInstantClean = false;
    p5.soapScaleOffset = 0;
    p5.soapPixelOffset = 0;
    p5.soapY = UDim.new(0, 0);
    p5.ratio = 0;
    p5.exitListeners = {};
end;

function u3.onStart(u7) -- Line: 35
    -- upvalues: WFChain (copy), PlayerGui (copy), INSTANT_CLEAN_PASS_NAME (copy), ItemsEvents (copy)
    u7.screen = WFChain(PlayerGui, "CleanUI");
    u7.bar = WFChain(u7.screen, "CleanBar");
    u7.inner = WFChain(u7.bar, "Inner");
    u7.soap = WFChain(u7.bar, "SoapBar");
    u7.percentage = WFChain(u7.bar, "Percentage");
    u7.exit = WFChain(u7.screen, "Exit");
    u7.skip = WFChain(u7.bar, "Skip");
    u7.skipPrice = WFChain(u7.skip, "Price");
    local Position = u7.soap.Position;
    u7.soapScaleOffset = Position.X.Scale - u7.inner.Size.X.Scale;
    u7.soapPixelOffset = Position.X.Offset;
    u7.soapY = Position.Y;
    u7.bar.Visible = false;
    u7.screen.Enabled = false;
    u7.exit.MouseButton1Click:Connect(function() -- Line: 50
        -- upvalues: u7 (copy)
        for i in u7.exitListeners do
            task.spawn(i);
        end;
    end);
    u7.skip:SetAttribute("name", INSTANT_CLEAN_PASS_NAME);
    u7.skipPrice:SetAttribute("name", INSTANT_CLEAN_PASS_NAME);
    u7.skip.MouseButton1Click:Connect(function() -- Line: 57
        -- upvalues: u7 (copy), ItemsEvents (ref)
        if not u7.ownsInstantClean and u7.freeSkips <= 0 then
            return nil;
        end;

        ItemsEvents.requestSkipClean:fire();
    end);
    u7:applySkipState(u7.dataController:getData());
end;

function u3.onDataChanged(p8, p9, p10) -- Line: 65
    if table.find(p9, "FreeSkips") == nil and table.find(p9, "Gamepasses") == nil then
        return nil;
    end;

    p8:applySkipState(p10);
end;

function u3.applySkipState(p11, p12) -- Line: 71
    -- upvalues: ownsPass (copy), INSTANT_CLEAN_PASS_NAME (copy)
    p11.ownsInstantClean = ownsPass(p12, INSTANT_CLEAN_PASS_NAME);
    p11.freeSkips = p12.FreeSkips;
    local v13 = not p11.ownsInstantClean and p11.freeSkips > 0;
    p11.skip:SetAttribute("suppressPrompt", p11.ownsInstantClean or v13);
    p11.skipPrice.Visible = not p11.ownsInstantClean;
    local skipPrice = p11.skipPrice;
    local v14;

    if v13 then
        v14 = `({p11.freeSkips} FREE)`;
    else
        v14 = nil;
    end;

    skipPrice:SetAttribute("overrideText", v14);
end;

function u3.onExit(p15, p16) -- Line: 79
    p15.exitListeners[p16] = true;
end;

function u3.setButtonsHidden(p17, p18) -- Line: 84
    p17.exit.Visible = not p18;
    p17.skip.Visible = not p18;
end;

function u3.show(p19) -- Line: 88
    local innerTween = p19.innerTween;

    if innerTween ~= nil then
        innerTween:Cancel();
    end;

    local soapTween = p19.soapTween;

    if soapTween ~= nil then
        soapTween:Cancel();
    end;

    p19.ratio = 0;
    p19.percentage.Text = "0% Clean";
    p19.inner.Size = UDim2.new(0, 0, 1, 0);
    p19.soap.Position = UDim2.new(p19.soapScaleOffset, p19.soapPixelOffset, p19.soapY.Scale, p19.soapY.Offset);
    p19.bar.Visible = true;
    p19.screen.Enabled = true;
end;

function u3.hide(p20) -- Line: 104
    p20.bar.Visible = false;
    p20.screen.Enabled = false;
end;

function u3.setProgress(p21, p22) -- Line: 108
    -- upvalues: TweenService (copy), u2 (copy)
    local v23 = math.clamp(p22, 0, 1);

    if math.abs(v23 - p21.ratio) < 0.001 then
        return nil;
    end;

    p21.ratio = v23;
    p21.percentage.Text = `{math.floor(v23 * 100)}% Clean`;
    local innerTween = p21.innerTween;

    if innerTween ~= nil then
        innerTween:Cancel();
    end;

    local soapTween = p21.soapTween;

    if soapTween ~= nil then
        soapTween:Cancel();
    end;

    p21.innerTween = TweenService:Create(p21.inner, u2, {
        Size = UDim2.new(v23, 0, 1, 0)
    });
    p21.soapTween = TweenService:Create(p21.soap, u2, {
        Position = UDim2.new(v23 + p21.soapScaleOffset, p21.soapPixelOffset, p21.soapY.Scale, p21.soapY.Offset)
    });
    p21.innerTween:Play();
    p21.soapTween:Play();
end;

Reflect.defineMetadata(u3, "identifier", "client/controllers/world/CleanBarController@CleanBarController");
Reflect.defineMetadata(u3, "flamework:parameters", { "client/controllers/data/DataController@DataController" });
Reflect.defineMetadata(u3, "flamework:implements", { "$:flamework@OnStart", "client/controllers/data/DataController@OnDataChanged" });
Reflect.decorate(u3, "$:flamework@Controller", Controller, { {} });

return {
    CleanBarController = u3
};