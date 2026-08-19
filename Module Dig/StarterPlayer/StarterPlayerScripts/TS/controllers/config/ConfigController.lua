-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local v1 = RuntimeLib.import(script, script.Parent.Parent.Parent, "network", "MiscNetwork");
local MiscEvents = v1.MiscEvents;
local MiscFunctions = v1.MiscFunctions;
local DEFAULT_CONFIG = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "config", "Config").DEFAULT_CONFIG;
local u2 = setmetatable({}, {
    __tostring = function() -- Line: 12, Name: __tostring
        return "ConfigController";
    end
});
u2.__index = u2;

function u2.new(...) -- Line: 17
    -- upvalues: u2 (ref)
    local v3 = setmetatable({}, u2);

    return v3:constructor(...) or v3;
end;

function u2.constructor(p4) -- Line: 21
    -- upvalues: DEFAULT_CONFIG (copy)
    local v5 = table.clone(DEFAULT_CONFIG);
    setmetatable(v5, nil);
    p4.config = v5;
    p4.listeners = {};
end;

function u2.onStart(u6) -- Line: 27
    -- upvalues: MiscEvents (copy), RuntimeLib (copy), MiscFunctions (copy)
    MiscEvents.SendPlayerConfig:connect(function(p7) -- Line: 28
        -- upvalues: u6 (copy)
        return u6:applyConfig(p7);
    end);
    task.spawn(RuntimeLib.async(function() -- Line: 31
        -- upvalues: RuntimeLib (ref), MiscFunctions (ref), u6 (copy)
        local v8 = RuntimeLib.await(MiscFunctions.GetPlayerConfig:invoke());

        if v8 ~= nil then
            u6:applyConfig(v8);
        end;
    end));
end;

function u2.getConfigValue(p9, p10) -- Line: 38
    return p9.config[p10];
end;

function u2.observe(u11, u12) -- Line: 41
    u11.listeners[u12] = true;
    u12(u11.config);

    return function() -- Line: 46
        -- upvalues: u11 (copy), u12 (copy)
        local listeners = u11.listeners;
        local v13 = u12;
        local v14 = listeners[v13] ~= nil;
        listeners[v13] = nil;

        return v14;
    end;
end;

function u2.applyConfig(p15, p16) -- Line: 56
    p15.config = p16;

    for i in p15.listeners do
        i(p16);
    end;
end;

Reflect.defineMetadata(u2, "identifier", "client/controllers/config/ConfigController@ConfigController");
Reflect.defineMetadata(u2, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u2, "$:flamework@Controller", Controller, { {} });

return {
    ConfigController = u2
};