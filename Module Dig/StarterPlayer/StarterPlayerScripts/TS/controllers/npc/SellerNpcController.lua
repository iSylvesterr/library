-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local Player = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "player", "playerConstants").Player;
local SellFunctions = RuntimeLib.import(script, script.Parent.Parent.Parent, "network", "SellNetwork").SellFunctions;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "items", "Items");
local dirtyItemValueFor = v1.dirtyItemValueFor;
local itemValueFor = v1.itemValueFor;
local STARTER_ISLAND_ID = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "world", "Islands").STARTER_ISLAND_ID;
local formatAbbrevMoney = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "formatting", "formatAbbrevMoney").formatAbbrevMoney;
local WFChain = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "instances", "WFChain").WFChain;
local playWorldSound = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "sound", "SoundUtil").playWorldSound;
local getStarterIsland = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "world", "getStarterIsland").getStarterIsland;
local u2 = setmetatable({}, {
    __tostring = function() -- Line: 24, Name: __tostring
        return "SellerNpcController";
    end
});
u2.__index = u2;

function u2.new(...) -- Line: 29
    -- upvalues: u2 (ref)
    local v3 = setmetatable({}, u2);

    return v3:constructor(...) or v3;
end;

function u2.constructor(p4, p5, p6) -- Line: 33
    p4.dialogue = p5;
    p4.data = p6;
end;

function u2.onStart(u7) -- Line: 37
    -- upvalues: WFChain (copy), getStarterIsland (copy), STARTER_ISLAND_ID (copy)
    task.spawn(function() -- Line: 38
        -- upvalues: WFChain (ref), getStarterIsland (ref), u7 (copy), STARTER_ISLAND_ID (ref)
        local v8 = WFChain(getStarterIsland(), "NPCs", "Sell", "SellerNPC");
        u7.npcRoot = WFChain(v8, "HumanoidRootPart");
        u7.dialogue:registerNpc({
            name = "Buyer Bob",
            actionText = "Hello!",
            model = v8,
            islandId = STARTER_ISLAND_ID,

            buildRootOptions = function(p9) -- Line: 46, Name: buildRootOptions
                -- upvalues: u7 (ref)
                return u7:buildRootOptions(p9);
            end
        });
    end);
end;

function u2.buildRootOptions(u10, u11) -- Line: 52
    return {
        {
            label = "I want to sell this",

            select = function() -- Line: 55, Name: select
                -- upvalues: u10 (copy), u11 (copy)
                return u10:sellHeld(u11);
            end
        },
        {
            label = "I want to sell my entire inventory",

            select = function() -- Line: 60, Name: select
                -- upvalues: u10 (copy), u11 (copy)
                return u10:confirmSellInventory(u11);
            end
        },
        {
            label = "How much is my inventory worth?",

            select = function() -- Line: 65, Name: select
                -- upvalues: u10 (copy), u11 (copy)
                return u10:showInventoryWorth(u11);
            end
        },
        {
            label = "Bye",

            select = function() -- Line: 70, Name: select
                -- upvalues: u11 (copy)
                return u11.close();
            end
        }
    };
end;

u2.showInventoryWorth = RuntimeLib.async(function(p12, p13) -- Line: 75
    -- upvalues: RuntimeLib (copy)
    local v14 = p12:getInventoryQuote();
    RuntimeLib.await(p13.say(p12:goldLine("Your inventory is worth ", v14, "")));
    p13.showOptions(p12:buildRootOptions(p13));
end);

function u2.goldLine(p15, p16, p17, p18) -- Line: 80
    -- upvalues: formatAbbrevMoney (copy)
    return {
        {
            text = p16
        },
        {
            gold = true,
            text = formatAbbrevMoney(p17)
        },
        {
            text = p18
        }
    };
end;

function u2.getHeldEntry(p19) -- Line: 90
    -- upvalues: Player (copy)
    local Character = Player.Character;

    if Character ~= nil then
        Character = Character:FindFirstChildOfClass("Tool");
    end;

    if Character ~= nil then
        Character = Character:GetAttribute("inventoryId");
    end;

    if type(Character) ~= "string" then
        return nil;
    end;

    local function _(p20) -- Line: 107
        -- upvalues: Character (copy)
        return p20.uid == Character;
    end;

    for i, v in p19.data:getData().Inventory do
        local _ = i - 1;

        if v.uid == Character == true then
            return v;
        end;
    end;

    return nil;
end;

u2.sellHeld = RuntimeLib.async(function(p21, p22) -- Line: 120
    -- upvalues: RuntimeLib (copy), SellFunctions (copy), playWorldSound (copy)
    if not p21:getHeldEntry() then
        RuntimeLib.await(p22.say("You aren\'t holding anything I can buy!"));
        p22.showOptions(p21:buildRootOptions(p22));

        return nil;
    end;

    local v23 = RuntimeLib.await(SellFunctions.sellHeldItem:invoke():catch(function() -- Line: 127
        return nil;
    end));

    if v23 == nil then
        RuntimeLib.await(p22.say("You aren\'t holding anything I can buy!"));
        p22.showOptions(p21:buildRootOptions(p22));

        return nil;
    end;

    playWorldSound("Money Collect", {
        volume = 0.7,
        parent = p21.npcRoot
    });
    RuntimeLib.await(p22.say(p21:goldLine("Here is ", v23, "!")));
    p22.close();
end);
u2.confirmSellInventory = RuntimeLib.async(function(u24, u25) -- Line: 142
    -- upvalues: RuntimeLib (copy)
    local v26 = u24:getInventoryQuote();

    if v26 == 0 then
        RuntimeLib.await(u25.say("You don\'t have anything I can buy!"));
        u25.showOptions(u24:buildRootOptions(u25));

        return nil;
    end;

    RuntimeLib.await(u25.say(u24:goldLine("Are you sure you want to sell your inventory for ", v26, "?")));
    u25.showOptions({
        {
            label = "Yes",

            select = function() -- Line: 152, Name: select
                -- upvalues: u24 (copy), u25 (copy)
                return u24:sellInventory(u25);
            end
        },
        {
            label = "No",

            select = function() -- Line: 157, Name: select
                -- upvalues: u25 (copy)
                return u25.close();
            end
        }
    });
end);

function u2.getInventoryQuote(p27) -- Line: 162
    -- upvalues: dirtyItemValueFor (copy), itemValueFor (copy)
    local v28 = 0;

    for _, v in p27.data:getData().Inventory do
        if v.pedestalSlot == nil and v.polisherSlot == nil then
            local v29;

            if v.dirty or v.condition == nil then
                v29 = dirtyItemValueFor(v.id, v.kg);
            else
                v29 = itemValueFor(v.id, v.condition, v.kg);
            end;

            v28 = v28 + v29;
        end;
    end;

    return v28;
end;

u2.sellInventory = RuntimeLib.async(function(p30, p31) -- Line: 172
    -- upvalues: RuntimeLib (copy), SellFunctions (copy), playWorldSound (copy)
    local v32 = RuntimeLib.await(SellFunctions.sellInventory:invoke():catch(function() -- Line: 173
        return nil;
    end));

    if v32 == nil then
        RuntimeLib.await(p31.say("You don\'t have anything I can buy!"));
        p31.showOptions(p30:buildRootOptions(p31));

        return nil;
    end;

    playWorldSound("Money Collect", {
        volume = 0.7,
        parent = p30.npcRoot
    });
    RuntimeLib.await(p31.say(p30:goldLine("Here is ", v32, "!")));
    p31.close();
end);
Reflect.defineMetadata(u2, "identifier", "client/controllers/npc/SellerNpcController@SellerNpcController");
Reflect.defineMetadata(u2, "flamework:parameters", { "client/controllers/npc/DialogueController@DialogueController", "client/controllers/data/DataController@DataController" });
Reflect.defineMetadata(u2, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u2, "$:flamework@Controller", Controller, { {} });

return {
    SellerNpcController = u2
};