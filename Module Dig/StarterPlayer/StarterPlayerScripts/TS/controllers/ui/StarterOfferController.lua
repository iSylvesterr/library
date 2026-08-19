-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local CollectionService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").CollectionService;
local FrameComponent = RuntimeLib.import(script, script.Parent.Parent.Parent, "components", "ui", "FrameComponent").FrameComponent;
local PlayerGui = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "player", "playerConstants").PlayerGui;
local MiscEvents = RuntimeLib.import(script, script.Parent.Parent.Parent, "network", "MiscNetwork").MiscEvents;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "monetization", "StarterPack");
local STARTER_OFFER_DELAY_SECONDS = v1.STARTER_OFFER_DELAY_SECONDS;
local STARTER_PACK_CLEAN_SKIPS = v1.STARTER_PACK_CLEAN_SKIPS;
local STARTER_PACK_GOLD = v1.STARTER_PACK_GOLD;
local STARTER_PACK_LUCK = v1.STARTER_PACK_LUCK;
local STARTER_PACK_LUCK_SECONDS = v1.STARTER_PACK_LUCK_SECONDS;
local STARTER_PACK_PRODUCT = v1.STARTER_PACK_PRODUCT;
local AbbreviateInteger = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "formatting", "AbbreviateNumber").AbbreviateInteger;
local formatShortDuration = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "formatting", "formatSeconds").formatShortDuration;
local WFChain = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "instances", "WFChain").WFChain;
local u2 = setmetatable({}, {
    __tostring = function() -- Line: 24, Name: __tostring
        return "StarterOfferController";
    end
});
u2.__index = u2;

function u2.new(...) -- Line: 29
    -- upvalues: u2 (ref)
    local v3 = setmetatable({}, u2);

    return v3:constructor(...) or v3;
end;

function u2.constructor(p4, p5, p6, p7, p8) -- Line: 33
    p4.data = p5;
    p4.dig = p6;
    p4.workbench = p7;
    p4.tutorial = p8;
    p4.phase = "waiting";
    p4.elapsed = 0;
    p4.settleUntil = 0;
    p4.ready = false;
end;

function u2.onStart(p9) -- Line: 43
    -- upvalues: WFChain (copy), PlayerGui (copy)
    p9.popup = WFChain(PlayerGui, "Main", "Starter Offer");
    p9.shopEntry = WFChain(PlayerGui, "Main", "Shop", "ScrollingFrame", "Starter Offer");
    p9:render(p9.popup);
    p9:render(p9.shopEntry);
    local v10 = p9.data:getData();

    if v10.StarterOfferShown then
        p9.phase = "done";
    end;

    p9:applyOwned(v10.StarterPackOwned);
    p9.ready = true;
end;

function u2.onDataChanged(p11, p12, p13) -- Line: 55
    if not p11.ready or table.find(p12, "StarterPackOwned") == nil then
        return nil;
    end;

    p11:applyOwned(p13.StarterPackOwned);
end;

function u2.onTick(p14, p15) -- Line: 61
    -- upvalues: STARTER_OFFER_DELAY_SECONDS (copy), MiscEvents (copy), FrameComponent (copy)
    if not p14.ready or p14.phase == "done" then
        return nil;
    end;

    if p14.data:getData().StarterPackOwned then
        p14:applyOwned(true);

        return nil;
    end;

    if p14.phase == "waiting" then
        if p14:tutorialUnfinished() then
            return nil;
        end;

        p14.elapsed = p14.elapsed + p15;

        if p14.elapsed < STARTER_OFFER_DELAY_SECONDS then
            return nil;
        end;

        if not p14:canOpen() then
            return nil;
        end;

        p14:open();
        MiscEvents.MarkStarterOfferShown:fire();

        return nil;
    end;

    if p14.phase == "visible" then
        if p14.popup.Visible then
            if p14:isBusy() then
                FrameComponent:toggleFrame("Starter Offer", false);
                p14.phase = "deferred";
            end;
        else
            p14.phase = "done";
        end;

        return nil;
    end;

    if p14:canOpen() then
        p14:open();
    end;
end;

function u2.open(p16) -- Line: 97
    -- upvalues: FrameComponent (copy)
    FrameComponent:toggleFrame("Starter Offer", true);
    p16.phase = "visible";
end;

function u2.canOpen(p17) -- Line: 101
    -- upvalues: FrameComponent (copy)
    if not p17:isBusy() and (not p17:tutorialUnfinished() and FrameComponent.activeFrame == nil) then
        return os.clock() >= p17.settleUntil;
    end;

    p17.settleUntil = os.clock() + 1;

    return false;
end;

function u2.isBusy(p18) -- Line: 108
    return p18.dig:isBusyDigging() or p18.workbench:isCleaning();
end;

function u2.tutorialUnfinished(p19) -- Line: 111
    return p19.tutorial:getStep() == nil and true or p19.tutorial:isActive();
end;

function u2.applyOwned(p20, p21) -- Line: 114
    -- upvalues: FrameComponent (copy)
    p20.shopEntry.Visible = not p21;

    if not p21 then
        return nil;
    end;

    if p20.popup.Visible then
        FrameComponent:toggleFrame("Starter Offer", false);
    end;

    p20.phase = "done";
end;

function u2.render(p22, p23) -- Line: 124
    -- upvalues: WFChain (copy), AbbreviateInteger (copy), STARTER_PACK_GOLD (copy), STARTER_PACK_LUCK (copy), formatShortDuration (copy), STARTER_PACK_LUCK_SECONDS (copy), STARTER_PACK_CLEAN_SKIPS (copy), STARTER_PACK_PRODUCT (copy), CollectionService (copy)
    local v24 = WFChain(p23, "Benefits");
    WFChain(v24, "Gold", "Description").Text = `+{AbbreviateInteger(STARTER_PACK_GOLD)} GOLD`;
    WFChain(v24, "Luck", "Description").Text = `{STARTER_PACK_LUCK}X LUCK ({formatShortDuration(STARTER_PACK_LUCK_SECONDS)})`;
    WFChain(v24, "CleanSkips", "Description").Text = `+{STARTER_PACK_CLEAN_SKIPS} CLEAN SKIPS`;
    local v25 = WFChain(p23, "RobuxBuy");
    local v26 = WFChain(v25, "Price");
    v25:SetAttribute("name", STARTER_PACK_PRODUCT);
    v26:SetAttribute("name", STARTER_PACK_PRODUCT);
    CollectionService:AddTag(v25, "ShopButton");
    CollectionService:AddTag(v26, "ShopPrice");
end;

Reflect.defineMetadata(u2, "identifier", "client/controllers/ui/StarterOfferController@StarterOfferController");
Reflect.defineMetadata(u2, "flamework:parameters", { "client/controllers/data/DataController@DataController", "client/controllers/world/DigController@DigController", "client/controllers/world/WorkbenchController@WorkbenchController", "client/controllers/tutorial/TutorialController@TutorialController" });
Reflect.defineMetadata(u2, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnTick", "client/controllers/data/DataController@OnDataChanged" });
Reflect.decorate(u2, "$:flamework@Controller", Controller, { {} });

return {
    StarterOfferController = u2
};