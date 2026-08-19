-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local FrameComponent = RuntimeLib.import(script, script.Parent.Parent.Parent, "components", "ui", "FrameComponent").FrameComponent;
local v1 = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "player", "playerConstants");
local Player = v1.Player;
local PlayerGui = v1.PlayerGui;
local MiscEvents = RuntimeLib.import(script, script.Parent.Parent.Parent, "network", "MiscNetwork").MiscEvents;
local WFChain = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "instances", "WFChain").WFChain;
local u2 = setmetatable({}, {
    __tostring = function() -- Line: 15, Name: __tostring
        return "TopButtonsController";
    end
});
u2.__index = u2;

function u2.new(...) -- Line: 20
    -- upvalues: u2 (ref)
    local v3 = setmetatable({}, u2);

    return v3:constructor(...) or v3;
end;

function u2.constructor(p4, p5, p6) -- Line: 24
    p4.data = p5;
    p4.islands = p6;
    p4.tutorialHidden = false;
end;

function u2.onStart(u7) -- Line: 29
    -- upvalues: FrameComponent (copy), WFChain (copy), PlayerGui (copy), MiscEvents (copy)
    FrameComponent.onOpened.Event:Connect(function() -- Line: 30
        -- upvalues: u7 (copy)
        return u7:updateVisibility();
    end);
    FrameComponent.onClosed.Event:Connect(function() -- Line: 33
        -- upvalues: u7 (copy)
        return u7:updateVisibility();
    end);
    local v8 = WFChain(PlayerGui, "HUD", "TopButtons");
    local Home = v8:WaitForChild("Home");
    local Hub = v8:WaitForChild("Hub");
    Home.Activated:Connect(function() -- Line: 39
        -- upvalues: MiscEvents (ref)
        return MiscEvents.RequestTeleportHome:fire();
    end);
    Hub.Activated:Connect(function() -- Line: 42
        -- upvalues: u7 (copy)
        return u7:teleportToHub();
    end);
    u7.frame = v8;
    u7:updateVisibility();
end;

function u2.setTutorialHidden(p9, p10) -- Line: 48
    p9.tutorialHidden = p10;
    p9:updateVisibility();
end;

function u2.updateVisibility(p11) -- Line: 52
    -- upvalues: FrameComponent (copy)
    if not p11.frame then
        return nil;
    end;

    p11.frame.Visible = not p11.tutorialHidden and FrameComponent.activeFrame == nil;
end;

function u2.teleportToHub(p12) -- Line: 58
    -- upvalues: Player (copy)
    local v13 = p12.data:getDataIfLoaded();

    if v13 ~= nil then
        v13 = v13.CurrentIsland;
    end;

    if v13 == nil then
        return nil;
    end;

    local v14 = p12.islands:getIsland(v13);

    if v14 ~= nil then
        v14 = v14.hub;
    end;

    if v14 then
        local Character = Player.Character;

        if Character ~= nil then
            Character:PivotTo(v14 + Vector3.new(0, 4, 0));
        end;
    end;
end;

Reflect.defineMetadata(u2, "identifier", "client/controllers/ui/TopButtonsController@TopButtonsController");
Reflect.defineMetadata(u2, "flamework:parameters", { "client/controllers/data/DataController@DataController", "client/controllers/world/IslandController@IslandController" });
Reflect.defineMetadata(u2, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u2, "$:flamework@Controller", Controller, { {} });

return {
    TopButtonsController = u2
};