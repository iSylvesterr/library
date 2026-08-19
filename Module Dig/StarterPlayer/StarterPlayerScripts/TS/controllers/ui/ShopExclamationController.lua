-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local FrameComponent = RuntimeLib.import(script, script.Parent.Parent.Parent, "components", "ui", "FrameComponent").FrameComponent;
local PlayerGui = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "player", "playerConstants").PlayerGui;
local MiscEvents = RuntimeLib.import(script, script.Parent.Parent.Parent, "network", "MiscNetwork").MiscEvents;
local SHOP_EXCLAMATION_POINT_KEY = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "config", "Config").SHOP_EXCLAMATION_POINT_KEY;
local WFChain = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "instances", "WFChain").WFChain;
local u1 = setmetatable({}, {
    __tostring = function() -- Line: 14, Name: __tostring
        return "ShopExclamationController";
    end
});
u1.__index = u1;

function u1.new(...) -- Line: 19
    -- upvalues: u1 (ref)
    local v2 = setmetatable({}, u1);

    return v2:constructor(...) or v2;
end;

function u1.constructor(p3, p4, p5) -- Line: 23
    p3.data = p4;
    p3.config = p5;
    p3.shopOpened = false;
    p3.ready = false;
end;

function u1.onStart(u6) -- Line: 29
    -- upvalues: WFChain (copy), PlayerGui (copy), FrameComponent (copy), MiscEvents (copy)
    u6.exclamation = WFChain(PlayerGui, "HUD", "LeftButtons", "Shop", "ExclamationPoint");
    u6.exclamation.Visible = false;
    u6.shopOpened = u6.data:getData().ShopOpened;
    u6.ready = true;
    u6.config:observe(function() -- Line: 34
        -- upvalues: u6 (copy)
        return u6:refresh();
    end);
    FrameComponent.onOpened.Event:Connect(function(p7) -- Line: 37
        -- upvalues: u6 (copy), MiscEvents (ref)
        if p7 ~= "Shop" or u6.shopOpened then
            return nil;
        end;

        u6.shopOpened = true;
        MiscEvents.MarkShopOpened:fire();
        u6:refresh();
    end);
end;

function u1.onDataChanged(p8, p9, p10) -- Line: 46
    if table.find(p9, "ShopOpened") == nil then
        return nil;
    end;

    p8.shopOpened = p10.ShopOpened;
    p8:refresh();
end;

function u1.refresh(p11) -- Line: 53
    -- upvalues: SHOP_EXCLAMATION_POINT_KEY (copy)
    if not p11.ready then
        return nil;
    end;

    local v12 = p11.config:getConfigValue(SHOP_EXCLAMATION_POINT_KEY) == true;

    if v12 then
        v12 = not p11.shopOpened;
    end;

    p11.exclamation.Visible = v12;
end;

Reflect.defineMetadata(u1, "identifier", "client/controllers/ui/ShopExclamationController@ShopExclamationController");
Reflect.defineMetadata(u1, "flamework:parameters", { "client/controllers/data/DataController@DataController", "client/controllers/config/ConfigController@ConfigController" });
Reflect.defineMetadata(u1, "flamework:implements", { "$:flamework@OnStart", "client/controllers/data/DataController@OnDataChanged" });
Reflect.decorate(u1, "$:flamework@Controller", Controller, { {} });

return {
    ShopExclamationController = u1
};