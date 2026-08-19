-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local CollectionService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").CollectionService;
local PlayerGui = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "player", "playerConstants").PlayerGui;
local v1 = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "ui", "ServerLuckStyles");
local SERVER_LUCK_GRADIENT_ROTATION = v1.SERVER_LUCK_GRADIENT_ROTATION;
local SERVER_LUCK_STYLES = v1.SERVER_LUCK_STYLES;
local SERVER_LUCK_TITLE_SEQUENCE = v1.SERVER_LUCK_TITLE_SEQUENCE;
local TextGradient = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "gradient", "TextGradient").TextGradient;
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "luck", "ServerLuckTiers");
local MAX_SERVER_LUCK_TIER = v2.MAX_SERVER_LUCK_TIER;
local SERVER_LUCK_DURATION_MINUTES = v2.SERVER_LUCK_DURATION_MINUTES;
local SERVER_LUCK_PRODUCTS = v2.SERVER_LUCK_PRODUCTS;
local nextServerLuckTier = v2.nextServerLuckTier;
local WFChain = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "instances", "WFChain").WFChain;
local RichTextUtil = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "ui", "RichTextUtil").RichTextUtil;
local u3 = setmetatable({}, {
    __tostring = function() -- Line: 27, Name: __tostring
        return "ServerLuckShopController";
    end
});
u3.__index = u3;

function u3.new(...) -- Line: 32
    -- upvalues: u3 (ref)
    local v4 = setmetatable({}, u3);

    return v4:constructor(...) or v4;
end;

function u3.constructor(p5, p6) -- Line: 36
    p5.luck = p6;
    p5.ready = false;
    p5.renderedLuck = 0;
    p5.sinceRefresh = 0;
end;

function u3.onStart(p7) -- Line: 42
    -- upvalues: WFChain (copy), PlayerGui (copy), TextGradient (copy), SERVER_LUCK_TITLE_SEQUENCE (copy), SERVER_LUCK_GRADIENT_ROTATION (copy), SERVER_LUCK_DURATION_MINUTES (copy)
    local v8 = WFChain(PlayerGui, "Main", "Shop", "ScrollingFrame", "ServerLuck");
    p7.transition = WFChain(v8, "Transition");
    p7.robuxBuy = WFChain(v8, "RobuxBuy");
    p7.price = WFChain(p7.robuxBuy, "Price");
    local v9 = {
        {
            text = "DOUBLE",
            gradient = SERVER_LUCK_TITLE_SEQUENCE,
            rotation = SERVER_LUCK_GRADIENT_ROTATION
        },
        {
            text = " Server Luck"
        }
    };
    TextGradient.applySegments(WFChain(v8, "Title"), v9);
    WFChain(v8, "Duration").Text = `(lasts {SERVER_LUCK_DURATION_MINUTES} minutes)`;
    p7:render(p7.luck:getServerLuck());
    p7.ready = true;
end;

function u3.onTick(p10, p11) -- Line: 58
    if not p10.ready then
        return nil;
    end;

    p10.sinceRefresh = p10.sinceRefresh + p11;

    if p10.sinceRefresh < 1 then
        return nil;
    end;

    p10.sinceRefresh = 0;
    local v12 = p10.luck:getServerLuck();

    if v12 ~= p10.renderedLuck then
        p10:render(v12);
    end;
end;

function u3.render(p13, p14) -- Line: 72
    -- upvalues: nextServerLuckTier (copy), SERVER_LUCK_STYLES (copy), MAX_SERVER_LUCK_TIER (copy), TextGradient (copy), RichTextUtil (copy)
    p13.renderedLuck = p14;
    local v15 = nextServerLuckTier(p14);
    local v16 = SERVER_LUCK_STYLES[v15 or MAX_SERVER_LUCK_TIER];
    TextGradient.applySegments(p13.transition, {
        {
            text = RichTextUtil.escape((`{p14}x     >     `))
        },
        {
            text = v15 == nil and "MAX" or `{v15}x`,
            gradient = v16.sequence,
            animationTag = v16.tag
        }
    });
    p13.robuxBuy.Visible = v15 ~= nil;

    if v15 ~= nil then
        p13:setProduct(v15);
    end;
end;

function u3.setProduct(p17, p18) -- Line: 88
    -- upvalues: SERVER_LUCK_PRODUCTS (copy), CollectionService (copy)
    local v19 = SERVER_LUCK_PRODUCTS[p18];
    p17.robuxBuy:SetAttribute("name", v19);
    p17.price:SetAttribute("name", v19);
    CollectionService:AddTag(p17.robuxBuy, "ShopButton");
    CollectionService:AddTag(p17.price, "ShopPrice");
end;

Reflect.defineMetadata(u3, "identifier", "client/controllers/ui/ServerLuckShopController@ServerLuckShopController");
Reflect.defineMetadata(u3, "flamework:parameters", { "client/controllers/ui/LuckController@LuckController" });
Reflect.defineMetadata(u3, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnTick" });
Reflect.decorate(u3, "$:flamework@Controller", Controller, { {} });

return {
    ServerLuckShopController = u3
};