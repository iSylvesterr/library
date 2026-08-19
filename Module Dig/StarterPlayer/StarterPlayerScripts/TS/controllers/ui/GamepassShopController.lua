-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local CollectionService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").CollectionService;
local PlayerGui = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "player", "playerConstants").PlayerGui;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "monetization", "Passes");
local DIG_POWER_PASS_NAME = v1.DIG_POWER_PASS_NAME;
local GOLD_PASS_NAME = v1.GOLD_PASS_NAME;
local INSTANT_CLEAN_PASS_NAME = v1.INSTANT_CLEAN_PASS_NAME;
local LUCK_PASS_NAME = v1.LUCK_PASS_NAME;
local WALK_SPEED_PASS_NAME = v1.WALK_SPEED_PASS_NAME;
local ownsPass = v1.ownsPass;
local WFChain = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "instances", "WFChain").WFChain;
local u2 = {
    GOLD_PASS_NAME,
    DIG_POWER_PASS_NAME,
    WALK_SPEED_PASS_NAME,
    LUCK_PASS_NAME,
    INSTANT_CLEAN_PASS_NAME
};
local u3 = setmetatable({}, {
    __tostring = function() -- Line: 19, Name: __tostring
        return "GamepassShopController";
    end
});
u3.__index = u3;

function u3.new(...) -- Line: 24
    -- upvalues: u3 (ref)
    local v4 = setmetatable({}, u3);

    return v4:constructor(...) or v4;
end;

function u3.constructor(p5, p6) -- Line: 28
    p5.dataController = p6;
    p5.cards = {};
end;

function u3.onStart(p7) -- Line: 32
    -- upvalues: WFChain (copy), PlayerGui (copy), u2 (copy), CollectionService (copy)
    local v8 = WFChain(PlayerGui, "Main", "Shop", "ScrollingFrame", "Passes");

    for _, v in u2 do
        local v9 = WFChain(v8, v);
        local v10 = WFChain(v9, "RobuxBuy");
        local v11 = WFChain(v10, "Price");
        v10:SetAttribute("name", v);
        v11:SetAttribute("name", v);
        CollectionService:AddTag(v10, "ShopButton");
        CollectionService:AddTag(v11, "ShopPrice");
        p7.cards[v] = {
            buy = v10,
            owned = WFChain(v9, "Owned")
        };
    end;

    p7:applyOwnership(p7.dataController:getData());
end;

function u3.onDataChanged(p12, p13, p14) -- Line: 51
    if table.find(p13, "Gamepasses") == nil then
        return nil;
    end;

    p12:applyOwnership(p14);
end;

function u3.applyOwnership(p15, p16) -- Line: 57
    -- upvalues: ownsPass (copy)
    for i, v in p15.cards do
        local v17 = ownsPass(p16, i);
        v.buy.Visible = not v17;
        v.owned.Visible = v17;
    end;
end;

Reflect.defineMetadata(u3, "identifier", "client/controllers/ui/GamepassShopController@GamepassShopController");
Reflect.defineMetadata(u3, "flamework:parameters", { "client/controllers/data/DataController@DataController" });
Reflect.defineMetadata(u3, "flamework:implements", { "$:flamework@OnStart", "client/controllers/data/DataController@OnDataChanged" });
Reflect.decorate(u3, "$:flamework@Controller", Controller, { {} });

return {
    GamepassShopController = u3
};