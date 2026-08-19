-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local Player = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "player", "playerConstants").Player;
local TravelFunctions = RuntimeLib.import(script, script.Parent.Parent.Parent, "network", "TravelNetwork").TravelFunctions;
local Islands = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "world", "Islands").Islands;
local formatAbbrevMoney = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "formatting", "formatAbbrevMoney").formatAbbrevMoney;
local WFChain = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "instances", "WFChain").WFChain;
local getIslandsFolder = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "world", "getStarterIsland").getIslandsFolder;
local teleportStreamed = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "world", "teleportStreamed").teleportStreamed;
local u1 = { "All aboard! Hold tight, matey!", "Anchors up! Away we go!", "Aboard with ye! The tide waits for no one!", "Har! Off we sail, matey!", "Hold fast, sailor! Away we go!" };
local u2 = setmetatable({}, {
    __tostring = function() -- Line: 23, Name: __tostring
        return "TravelNpcController";
    end
});
u2.__index = u2;

function u2.new(...) -- Line: 28
    -- upvalues: u2 (ref)
    local v3 = setmetatable({}, u2);

    return v3:constructor(...) or v3;
end;

function u2.constructor(p4, p5, p6, p7, p8, p9) -- Line: 32
    p4.dialogue = p5;
    p4.data = p6;
    p4.islands = p7;
    p4.transition = p8;
    p4.newArea = p9;
end;

function u2.onStart(u10) -- Line: 39
    -- upvalues: getIslandsFolder (copy), WFChain (copy)
    task.spawn(function() -- Line: 40
        -- upvalues: getIslandsFolder (ref), u10 (copy), WFChain (ref)
        local v11 = getIslandsFolder();

        for _, v in u10.islands:getIslands() do
            if v.hasTravelNpc then
                local v12 = WFChain(v11, v.name, "NPCs", "Travel", "Pirate");
                u10.dialogue:registerNpc({
                    name = "Pirate",
                    actionText = "Hello!",
                    model = v12,
                    islandId = v.id,

                    buildRootOptions = function(p13) -- Line: 52, Name: buildRootOptions
                        -- upvalues: u10 (ref)
                        return u10:buildRootOptions(p13);
                    end
                });
            end;
        end;
    end);
end;

function u2.buildRootOptions(u14, u15) -- Line: 59
    return {
        {
            label = "I want to travel",

            select = function() -- Line: 62, Name: select
                -- upvalues: u14 (copy), u15 (copy)
                return u14:askDestination(u15, "Where to?");
            end
        },
        {
            label = "Where does this take me?",

            select = function() -- Line: 67, Name: select
                -- upvalues: u14 (copy), u15 (copy)
                return u14:askDestination(u15, "Wherever ye can afford, matey! Take yer pick!");
            end
        },
        {
            label = "What is at other islands?",

            select = function() -- Line: 72, Name: select
                -- upvalues: u14 (copy), u15 (copy)
                return u14:explainIslands(u15);
            end
        },
        {
            label = "Bye",

            select = function() -- Line: 77, Name: select
                -- upvalues: u15 (copy)
                return u15.close();
            end
        }
    };
end;

u2.explainIslands = RuntimeLib.async(function(p16, p17) -- Line: 82
    -- upvalues: RuntimeLib (copy)
    RuntimeLib.await(p17.say("Each isle be luckier than the last, matey... finer gear too!"));
    p17.showOptions(p16:buildRootOptions(p17));
end);
u2.askDestination = RuntimeLib.async(function(p18, p19, p20) -- Line: 86
    -- upvalues: RuntimeLib (copy)
    RuntimeLib.await(p19.say(p20));
    p19.showOptions(p18:buildDestinationOptions(p19));
end);

function u2.buildDestinationOptions(u21, u22) -- Line: 90
    local v23 = u21.islands:getCurrentIslandId();
    local v24 = {};

    for _, v in u21.islands:getIslands() do
        if v.id ~= v23 then
            local v25 = {
                label = u21:destinationLabel(v),

                select = function() -- Line: 99, Name: select
                    -- upvalues: u21 (copy), u22 (copy), v (copy)
                    return u21:travelTo(u22, v);
                end
            };
            table.insert(v24, v25);
        end;
    end;

    table.insert(v24, {
        label = "Bye",

        select = function() -- Line: 107, Name: select
            -- upvalues: u22 (copy)
            return u22.close();
        end
    });

    return v24;
end;

function u2.destinationLabel(p26, p27) -- Line: 113
    -- upvalues: formatAbbrevMoney (copy), Islands (copy)
    return not p26.islands:isUnlocked(p27.id) and {
        {
            text = `{p27.name} (`
        },
        {
            gold = true,
            text = formatAbbrevMoney(Islands[p27.id].cost)
        },
        {
            text = ")"
        }
    } or p27.name;
end;

function u2.poorLine(p28, p29) -- Line: 126
    -- upvalues: formatAbbrevMoney (copy), Islands (copy)
    return {
        {
            text = "Ye need "
        },
        {
            gold = true,
            text = formatAbbrevMoney(Islands[p29.id].cost)
        },
        {
            text = " to travel there!"
        }
    };
end;

u2.travelTo = RuntimeLib.async(function(p30, p31, u32) -- Line: 136
    -- upvalues: Islands (copy), RuntimeLib (copy), TravelFunctions (copy), u1 (copy), teleportStreamed (copy), Player (copy)
    if not p30.islands:isUnlocked(u32.id) and p30.data:getData().Gold < Islands[u32.id].cost then
        RuntimeLib.await(p31.say(p30:poorLine(u32)));
        p31.close();

        return nil;
    end;

    local v33 = RuntimeLib.await(TravelFunctions.travel:invoke(u32.id):catch(function() -- Line: 142
        return nil;
    end));

    if v33 == nil then
        p31.close();

        return nil;
    end;

    if v33 == "poor" then
        RuntimeLib.await(p31.say(p30:poorLine(u32)));
        p31.close();

        return nil;
    end;

    RuntimeLib.await(p31.say(u1[math.random(0, #u1 - 1) + 1], 0.15));
    p31.close();
    RuntimeLib.await(p30.transition:play(function() -- Line: 156
        -- upvalues: teleportStreamed (ref), Player (ref), u32 (copy)
        return teleportStreamed(Player, u32.spawn + Vector3.new(0, 4, 0));
    end));
    p30.newArea:play(u32.name, Islands[u32.id].luck);
end);
Reflect.defineMetadata(u2, "identifier", "client/controllers/npc/TravelNpcController@TravelNpcController");
Reflect.defineMetadata(u2, "flamework:parameters", { "client/controllers/npc/DialogueController@DialogueController", "client/controllers/data/DataController@DataController", "client/controllers/world/IslandController@IslandController", "client/controllers/world/TransitionController@TransitionController", "client/controllers/world/NewAreaController@NewAreaController" });
Reflect.defineMetadata(u2, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u2, "$:flamework@Controller", Controller, { {} });

return {
    TravelNpcController = u2
};