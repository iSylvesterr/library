-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services");
local Players = v1.Players;
local ReplicatedStorage = v1.ReplicatedStorage;
local v2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "network", "ShovelNetwork");
local ShovelEvents = v2.ShovelEvents;
local ShovelFunctions = v2.ShovelFunctions;
local RarityBeams = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "effects", "RarityBeams").RarityBeams;
local SurfaceScenes = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "effects", "SurfaceScene").SurfaceScenes;
local ItemLabelStyles = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "itemLabels", "ItemLabelStyles").ItemLabelStyles;
local ServerNotification = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "ServerNotification").ServerNotification;
local Items = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "items", "Items").Items;
local TutorialStep = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "tutorial", "TutorialConfig").TutorialStep;
local ItemModel = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "items", "ItemModel").ItemModel;
local WFChain = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "instances", "WFChain").WFChain;
local playSound = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "sound", "SoundUtil").playSound;
local u3 = setmetatable({}, {
    __tostring = function() -- Line: 25, Name: __tostring
        return "SurfacedItemController";
    end
});
u3.__index = u3;

function u3.new(...) -- Line: 30
    -- upvalues: u3 (ref)
    local v4 = setmetatable({}, u3);

    return v4:constructor(...) or v4;
end;

function u3.constructor(p5, p6) -- Line: 34
    p5.tutorial = p6;
    p5.scenes = {};
    p5.pending = {};
end;

function u3.onDataChanged(p7, p8, p9) -- Line: 39
    if table.find(p8, "CurrentIsland") == nil or p9.CurrentIsland == p7.islandId then
        return nil;
    end;

    p7.islandId = p9.CurrentIsland;
    p7:clearScenes();
    p7:loadSurfaced();
end;

function u3.clearScenes(p10) -- Line: 47
    -- upvalues: SurfaceScenes (copy)
    table.clear(p10.pending);

    for _, v in p10.scenes do
        SurfaceScenes.destroy(v);
    end;

    table.clear(p10.scenes);
end;

function u3.onStart(u11) -- Line: 54
    -- upvalues: ShovelEvents (copy), TutorialStep (copy)
    ShovelEvents.SurfacedItemSpawned:connect(function(p12) -- Line: 55
        -- upvalues: u11 (copy)
        u11:notifySpawn(p12);
        u11:addItem(p12);
    end);
    ShovelEvents.SurfacedItemClaimed:connect(function(p13, p14) -- Line: 59
        -- upvalues: u11 (copy)
        return u11:onClaimed(p13, p14);
    end);
    ShovelEvents.SurfacedItemReleased:connect(function(p15) -- Line: 62
        -- upvalues: u11 (copy)
        u11:onRemoved(p15.id);
        u11:addItem(p15);
    end);
    ShovelEvents.SurfacedItemRemoved:connect(function(p16) -- Line: 66
        -- upvalues: u11 (copy)
        return u11:onRemoved(p16);
    end);
    u11.tutorial:onStepChanged(function(p17) -- Line: 69
        -- upvalues: TutorialStep (ref), u11 (copy)
        if TutorialStep.Done <= p17 then
            u11:loadSurfaced();
        end;
    end);
end;

function u3.loadSurfaced(u18) -- Line: 75
    -- upvalues: RuntimeLib (copy), ShovelFunctions (copy)
    local islandId = u18.islandId;
    task.spawn(RuntimeLib.async(function() -- Line: 77
        -- upvalues: RuntimeLib (ref), ShovelFunctions (ref), u18 (copy), islandId (copy)
        local v19 = RuntimeLib.await(ShovelFunctions.GetSurfacedItems:invoke():catch(function() -- Line: 78
            return nil;
        end));

        if not v19 or u18.islandId ~= islandId then
            return nil;
        end;

        for _, v in v19 do
            u18:addItem(v);
        end;
    end));
end;

function u3.onRender(p20) -- Line: 89
    -- upvalues: SurfaceScenes (copy)
    for _, v in p20.scenes do
        SurfaceScenes.update(v);
    end;
end;

function u3.notifySpawn(p21, p22) -- Line: 94
    -- upvalues: Items (copy), ServerNotification (copy), ItemLabelStyles (copy), RarityBeams (copy), playSound (copy)
    if p21.tutorial:isActive() then
        return nil;
    end;

    local rarity = Items[p22.itemId].rarity;
    ServerNotification.new({
        {
            text = "a "
        },
        ItemLabelStyles.unknownRaritySegment(rarity),
        {
            text = " item spawned!"
        }
    }, 5, "None");
    local v23 = RarityBeams.beamSound(rarity);
    playSound(v23.key, {
        volume = 0.05,
        playbackSpeed = v23.playbackSpeed
    });
end;

function u3.addItem(u24, u25) -- Line: 110
    -- upvalues: Items (copy), WFChain (copy), ReplicatedStorage (copy), ItemModel (copy)
    if u24.tutorial:isActive() or u24.scenes[u25.id] ~= nil or (u24.pending[u25.id] ~= nil or Items[u25.itemId] == nil) then
        return nil;
    end;

    u24.pending[u25.id] = true;
    task.spawn(function() -- Line: 131
        -- upvalues: WFChain (ref), ReplicatedStorage (ref), Items (ref), u25 (copy), ItemModel (ref), u24 (copy)
        local v26 = WFChain(ReplicatedStorage, "Assets", "Items", Items[u25.itemId].displayName);
        v26:WaitForChild("Handle", 5);
        local v27 = ItemModel.build(v26, u25.itemId, u25.kg);
        local pending = u24.pending;
        local id = u25.id;
        local v28 = pending[id] ~= nil;
        pending[id] = nil;

        if not (v28 and v27) then
            if v27 ~= nil then
                v27:Destroy();
            end;

            return nil;
        end;

        local _, v29 = v27:GetBoundingBox();
        v27:Destroy();
        u24:createScene(u25, v29);
    end);
end;

function u3.onClaimed(p30, p31, p32) -- Line: 154
    -- upvalues: Players (copy), SurfaceScenes (copy)
    p30.pending[p31] = nil;

    if p32 == Players.LocalPlayer.UserId then
        return nil;
    end;

    local v33 = p30.scenes[p31];

    if v33 then
        SurfaceScenes.clearMound(v33);
    end;
end;

function u3.hasDigSpotNear(p34, p35) -- Line: 168
    -- upvalues: SurfaceScenes (copy)
    for _, v in p34.scenes do
        if SurfaceScenes.isInReach(v, p35) then
            return true;
        end;
    end;

    return false;
end;

function u3.takeMound(p36, p37) -- Line: 176
    -- upvalues: SurfaceScenes (copy)
    local v38 = p36.scenes[p37];

    if v38 then
        return SurfaceScenes.takeMound(v38);
    end;

    return nil;
end;

function u3.onRemoved(p39, p40) -- Line: 182
    -- upvalues: SurfaceScenes (copy)
    p39.pending[p40] = nil;
    local v41 = p39.scenes[p40];

    if not v41 then
        return nil;
    end;

    p39.scenes[p40] = nil;
    SurfaceScenes.destroy(v41);
end;

function u3.createScene(p42, p43, p44) -- Line: 197
    -- upvalues: Items (copy), SurfaceScenes (copy)
    p42.scenes[p43.id] = SurfaceScenes.create(p43.position, Items[p43.itemId].rarity, p44);
end;

Reflect.defineMetadata(u3, "identifier", "client/controllers/world/SurfacedItemController@SurfacedItemController");
Reflect.defineMetadata(u3, "flamework:parameters", { "client/controllers/tutorial/TutorialController@TutorialController" });
Reflect.defineMetadata(u3, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnRender", "client/controllers/data/DataController@OnDataChanged" });
Reflect.decorate(u3, "$:flamework@Controller", Controller, { {} });

return {
    SurfacedItemController = u3
};