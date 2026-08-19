-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local Player = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "player", "playerConstants").Player;
local TravelFunctions = RuntimeLib.import(script, script.Parent.Parent.Parent, "network", "TravelNetwork").TravelFunctions;
local isIslandUnlocked = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "world", "Islands").isIslandUnlocked;
local u1 = setmetatable({}, {
    __tostring = function() -- Line: 12, Name: __tostring
        return "IslandController";
    end
});
u1.__index = u1;

function u1.new(...) -- Line: 17
    -- upvalues: u1 (ref)
    local v2 = setmetatable({}, u1);

    return v2:constructor(...) or v2;
end;

function u1.constructor(p3, p4) -- Line: 21
    p3.data = p4;
    p3.islands = {};
end;

function u1.onStart(u5) -- Line: 25
    task.spawn(function() -- Line: 26
        -- upvalues: u5 (copy)
        return u5:fetch();
    end);
end;

u1.fetch = RuntimeLib.async(function(p6) -- Line: 30
    -- upvalues: RuntimeLib (copy), TravelFunctions (copy)
    while #p6.islands == 0 do
        local v7 = RuntimeLib.await(TravelFunctions.getIslands:invoke():catch(function() -- Line: 32
            return nil;
        end));

        if v7 == nil or #v7 <= 0 then
            RuntimeLib.await(RuntimeLib.Promise.delay(1));
        else
            p6.islands = v7;
        end;
    end;
end);

function u1.getIslands(p8) -- Line: 42
    while #p8.islands == 0 do
        task.wait();
    end;

    return p8.islands;
end;

function u1.isUnlocked(p9, p10) -- Line: 48
    -- upvalues: isIslandUnlocked (copy)
    return isIslandUnlocked(p10, p9.data:getData().UnlockedIslands);
end;

function u1.getCurrentIslandId(p11) -- Line: 51
    -- upvalues: Player (copy)
    local Character = Player.Character;

    if Character ~= nil then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    local v12;

    if Character == nil then
        v12 = Character;
    else
        v12 = Character:IsA("BasePart");
    end;

    if not v12 then
        return nil;
    end;

    local Position = Character.Position;
    local v13 = (1 / 0);
    local v14 = nil;

    for _, v in p11.islands do
        local v15 = v.spawn.Position - Position;
        local v16 = v15.X * v15.X + v15.Z * v15.Z;

        if v13 > v16 then
            v14 = v.id;
            v13 = v16;
        end;
    end;

    return v14;
end;

function u1.getIsland(p17, u18) -- Line: 78
    local function _(p19) -- Line: 81
        -- upvalues: u18 (copy)
        return p19.id == u18;
    end;

    for i, v in p17.islands do
        local _ = i - 1;

        if v.id == u18 == true then
            return v;
        end;
    end;

    return nil;
end;

Reflect.defineMetadata(u1, "identifier", "client/controllers/world/IslandController@IslandController");
Reflect.defineMetadata(u1, "flamework:parameters", { "client/controllers/data/DataController@DataController" });
Reflect.defineMetadata(u1, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u1, "$:flamework@Controller", Controller, { {} });

return {
    IslandController = u1
};