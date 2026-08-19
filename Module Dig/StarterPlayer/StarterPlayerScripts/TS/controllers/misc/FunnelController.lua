-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local MiscEvents = RuntimeLib.import(script, script.Parent.Parent.Parent, "network", "MiscNetwork").MiscEvents;
local u1 = setmetatable({}, {
    __tostring = function() -- Line: 9, Name: __tostring
        return "FunnelController";
    end
});
u1.__index = u1;

function u1.new(...) -- Line: 14
    -- upvalues: u1 (ref)
    local v2 = setmetatable({}, u1);

    return v2:constructor(...) or v2;
end;

function u1.constructor(p3) -- Line: 18
end;

function u1.logFunnel(p4, p5) -- Line: 20
    -- upvalues: MiscEvents (copy)
    if #p5 > 0 and #p5 <= 50 then
        MiscEvents.LogFunnel:fire(p5);
    end;
end;

Reflect.defineMetadata(u1, "identifier", "client/controllers/misc/FunnelController@FunnelController");
Reflect.decorate(u1, "$:flamework@Controller", Controller, { {} });

return {
    FunnelController = u1
};