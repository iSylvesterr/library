-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local WFChain = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "instances", "WFChain").WFChain;
local getIslandsFolder = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "world", "getStarterIsland").getIslandsFolder;
local u1 = setmetatable({}, {
    __tostring = function() -- Line: 16, Name: __tostring
        return "GearNpcController";
    end
});
u1.__index = u1;

function u1.new(...) -- Line: 21
    -- upvalues: u1 (ref)
    local v2 = setmetatable({}, u1);

    return v2:constructor(...) or v2;
end;

function u1.constructor(p3, p4, p5) -- Line: 25
    p3.dialogue = p4;
    p3.islands = p5;
end;

function u1.onStart(u6) -- Line: 29
    -- upvalues: getIslandsFolder (copy), WFChain (copy)
    task.spawn(function() -- Line: 30
        -- upvalues: getIslandsFolder (ref), u6 (copy), WFChain (ref)
        local v7 = getIslandsFolder();

        for _, v in u6.islands:getIslands() do
            if v.hasGearNpc then
                local u8 = v.id == "island2";
                u6.dialogue:registerNpc({
                    actionText = "Hello!",
                    model = WFChain(v7, v.name, "NPCs", "Gear", "GearNPC"),
                    name = u8 and "Scurvy Sam" or "Digger Dave",
                    islandId = v.id,

                    buildRootOptions = function(p9) -- Line: 42, Name: buildRootOptions
                        -- upvalues: u8 (copy), u6 (ref)
                        if u8 then
                            return u6:buildCoveOptions(p9);
                        end;

                        return u6:buildRootOptions(p9);
                    end
                });
            end;
        end;
    end);
end;

function u1.buildRootOptions(u10, u11) -- Line: 49
    return {
        {
            label = "How do I get more gear?",

            select = function() -- Line: 52, Name: select
                -- upvalues: u10 (copy), u11 (copy)
                return u10:explainMoreGear(u11);
            end
        },
        {
            label = "Bye",

            select = function() -- Line: 57, Name: select
                -- upvalues: u11 (copy)
                return u11.close();
            end
        }
    };
end;

u1.explainMoreGear = RuntimeLib.async(function(p12, p13) -- Line: 62
    -- upvalues: RuntimeLib (copy)
    RuntimeLib.await(p13.say("You need to sail to the next island!"));
    p13.showOptions(p12:buildRootOptions(p13));
end);

function u1.buildCoveOptions(u14, u15) -- Line: 66
    return {
        {
            label = "Where is the next island?",

            select = function() -- Line: 69, Name: select
                -- upvalues: u14 (copy), u15 (copy)
                return u14:explainNextIsland(u15);
            end
        }
    };
end;

u1.explainNextIsland = RuntimeLib.async(function(p16, p17) -- Line: 74
    -- upvalues: RuntimeLib (copy)
    RuntimeLib.await(p17.say("Ain\'t charted yet! Check back soon or I\'ll feed ye to the crabs."));
    p17.showOptions(p16:buildCoveOptions(p17));
end);
Reflect.defineMetadata(u1, "identifier", "client/controllers/npc/GearNpcController@GearNpcController");
Reflect.defineMetadata(u1, "flamework:parameters", { "client/controllers/npc/DialogueController@DialogueController", "client/controllers/world/IslandController@IslandController" });
Reflect.defineMetadata(u1, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u1, "$:flamework@Controller", Controller, { {} });

return {
    GearNpcController = u1
};