-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out");
local BaseComponent = v1.BaseComponent;
local Component = v1.Component;
local Janitor = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "janitor", "src").Janitor;
local ownsPass = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "monetization", "Passes").ownsPass;
local TutorialStep = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "tutorial", "TutorialConfig").TutorialStep;
local u2 = setmetatable({}, {
    __tostring = function() -- Line: 16, Name: __tostring
        return "GamepassSignComponent";
    end,

    __index = BaseComponent
});
u2.__index = u2;

function u2.new(...) -- Line: 22
    -- upvalues: u2 (ref)
    local v3 = setmetatable({}, u2);

    return v3:constructor(...) or v3;
end;

function u2.constructor(p4, p5, p6, p7) -- Line: 26
    -- upvalues: BaseComponent (copy), Janitor (copy)
    BaseComponent.constructor(p4);
    p4.dataController = p5;
    p4.plot = p6;
    p4.tutorial = p7;
    p4.janitor = Janitor.new();
    p4.otherPlayersPlot = false;
    p4.owned = false;
    p4.tutorialDone = false;
end;

function u2.onStart(u8) -- Line: 36
    -- upvalues: TutorialStep (copy), ownsPass (copy)
    u8:setVisible(false);
    u8.otherPlayersPlot = u8:isOnOtherPlayersPlot();

    if u8.otherPlayersPlot then
        return nil;
    end;

    u8.janitor:Add(u8.tutorial:onStepChanged(function(p9) -- Line: 42
        -- upvalues: u8 (copy), TutorialStep (ref)
        u8.tutorialDone = TutorialStep.Done <= p9;
        u8:refresh();
    end));
    u8.owned = ownsPass(u8.dataController:getData(), u8.attributes.name);
    u8:refresh();
end;

function u2.onDataChanged(p10, p11, p12) -- Line: 49
    -- upvalues: ownsPass (copy)
    if table.find(p11, "Gamepasses") == nil then
        return nil;
    end;

    p10.owned = ownsPass(p12, p10.attributes.name);
    p10:refresh();
end;

function u2.destroy(p13) -- Line: 56
    p13.janitor:Destroy();
end;

function u2.refresh(p14) -- Line: 59
    p14:setVisible(not p14.otherPlayersPlot and p14.tutorialDone and not p14.owned);
end;

function u2.isOnOtherPlayersPlot(p15) -- Line: 62
    local v16 = p15:findPlotIndex();

    if v16 == nil then
        return false;
    end;

    local v17, v18 = p15.plot:awaitPlotNumber():await();

    if v17 then
        v17 = v18 ~= v16;
    end;

    return v17;
end;

function u2.findPlotIndex(p19) -- Line: 70
    local Parent = p19.instance.Parent;

    while Parent do
        local v20 = string.match(Parent.Name, "^Plot_(%d+)$");
        local v21 = tonumber(v20);

        if v21 ~= nil then
            return v21;
        end;

        Parent = Parent.Parent;
    end;

    return nil;
end;

function u2.setVisible(p22, p23) -- Line: 81
    for _, descendant in p22.instance:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.LocalTransparencyModifier = p23 and 0 or 1;
            descendant.CanCollide = p23;
        elseif descendant:IsA("SurfaceGui") then
            descendant.Enabled = p23;
        end;
    end;
end;

Reflect.defineMetadata(u2, "identifier", "client/components/monetization/GamepassSignComponent@GamepassSignComponent");
Reflect.defineMetadata(u2, "flamework:parameters", { "client/controllers/data/DataController@DataController", "client/controllers/plot/PlotController@PlotController", "client/controllers/tutorial/TutorialController@TutorialController" });
Reflect.defineMetadata(u2, "flamework:implements", { "$:flamework@OnStart", "client/controllers/data/DataController@OnDataChanged" });
Reflect.decorate(u2, "$c:components@Component", Component, {
    {
        tag = "GamepassSign",
        attributes = {
            name = t.string
        },
        instanceGuard = t.instanceIsA("Model")
    }
});

return {
    GamepassSignComponent = u2
};