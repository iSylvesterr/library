-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local CollectionService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").CollectionService;
local PlayerGui = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "player", "playerConstants").PlayerGui;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "monetization", "Vip");
local VIP_GAMEPASS_NAME = v1.VIP_GAMEPASS_NAME;
local hasVip = v1.hasVip;
local WFChain = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "instances", "WFChain").WFChain;
local u2 = setmetatable({}, {
    __tostring = function() -- Line: 14, Name: __tostring
        return "VipShopController";
    end
});
u2.__index = u2;

function u2.new(...) -- Line: 19
    -- upvalues: u2 (ref)
    local v3 = setmetatable({}, u2);

    return v3:constructor(...) or v3;
end;

function u2.constructor(p4, p5) -- Line: 23
    p4.dataController = p5;
end;

function u2.onStart(p6) -- Line: 26
    -- upvalues: WFChain (copy), PlayerGui (copy), VIP_GAMEPASS_NAME (copy), CollectionService (copy), hasVip (copy)
    local v7 = WFChain(PlayerGui, "Main", "VIP");
    local v8 = WFChain(v7, "RobuxBuy");
    local v9 = WFChain(v8, "Price");
    v8:SetAttribute("name", VIP_GAMEPASS_NAME);
    v9:SetAttribute("name", VIP_GAMEPASS_NAME);
    CollectionService:AddTag(v8, "ShopButton");
    CollectionService:AddTag(v9, "ShopPrice");
    p6.buy = v8;
    p6.owned = WFChain(v7, "Owned");
    p6:applyOwned(hasVip(p6.dataController:getData()));
end;

function u2.onDataChanged(p10, p11, p12) -- Line: 38
    -- upvalues: hasVip (copy)
    if table.find(p11, "Gamepasses") == nil then
        return nil;
    end;

    p10:applyOwned(hasVip(p12));
end;

function u2.applyOwned(p13, p14) -- Line: 44
    if not (p13.buy and p13.owned) then
        return nil;
    end;

    p13.buy.Visible = not p14;
    p13.owned.Visible = p14;
end;

Reflect.defineMetadata(u2, "identifier", "client/controllers/ui/VipShopController@VipShopController");
Reflect.defineMetadata(u2, "flamework:parameters", { "client/controllers/data/DataController@DataController" });
Reflect.defineMetadata(u2, "flamework:implements", { "$:flamework@OnStart", "client/controllers/data/DataController@OnDataChanged" });
Reflect.decorate(u2, "$:flamework@Controller", Controller, { {} });

return {
    VipShopController = u2
};