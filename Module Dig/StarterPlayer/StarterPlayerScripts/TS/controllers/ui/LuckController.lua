-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local Workspace = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Workspace;
local v1 = RuntimeLib.import(script, script.Parent.Parent.Parent, "network", "LuckNetwork");
local LuckEvents = v1.LuckEvents;
local LuckFunctions = v1.LuckFunctions;
local DEFAULT_LUCK = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "luck", "LuckConfig").DEFAULT_LUCK;
local u2 = setmetatable({}, {
    __tostring = function() -- Line: 13, Name: __tostring
        return "LuckController";
    end
});
u2.__index = u2;

function u2.new(...) -- Line: 18
    -- upvalues: u2 (ref)
    local v3 = setmetatable({}, u2);

    return v3:constructor(...) or v3;
end;

function u2.constructor(p4) -- Line: 22
    p4.receivedServerLuck = false;
end;

function u2.onStart(u5) -- Line: 25
    -- upvalues: LuckEvents (copy), RuntimeLib (copy), LuckFunctions (copy)
    LuckEvents.ServerLuckChanged:connect(function(p6) -- Line: 26
        -- upvalues: u5 (copy)
        return u5:setServerBoost(p6);
    end);
    task.spawn(RuntimeLib.async(function() -- Line: 29
        -- upvalues: RuntimeLib (ref), LuckFunctions (ref), u5 (copy)
        local v7 = RuntimeLib.await(LuckFunctions.getServerLuck:invoke());

        if u5.receivedServerLuck then
            return nil;
        end;

        u5:setServerBoost(v7);
    end));
end;

function u2.getServerLuck(p8) -- Line: 37
    -- upvalues: DEFAULT_LUCK (copy)
    local v9 = p8:getServerBoost();

    if v9 ~= nil then
        v9 = v9.multiplier;
    end;

    if v9 == nil then
        v9 = DEFAULT_LUCK;
    end;

    return v9;
end;

function u2.getServerBoost(p10) -- Line: 48
    -- upvalues: Workspace (copy)
    local serverBoost = p10.serverBoost;

    if serverBoost == nil or serverBoost.expiresAt <= Workspace:GetServerTimeNow() then
        return nil;
    end;

    return serverBoost;
end;

function u2.setServerBoost(p11, p12) -- Line: 52
    p11.receivedServerLuck = true;
    p11.serverBoost = p12;
end;

Reflect.defineMetadata(u2, "identifier", "client/controllers/ui/LuckController@LuckController");
Reflect.defineMetadata(u2, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u2, "$:flamework@Controller", Controller, { {} });

return {
    LuckController = u2
};