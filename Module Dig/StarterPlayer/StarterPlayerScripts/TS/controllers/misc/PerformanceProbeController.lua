-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local MiscEvents = RuntimeLib.import(script, script.Parent.Parent.Parent, "network", "MiscNetwork").MiscEvents;
local DirtBudget = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "world", "DirtBudget").DirtBudget;
local u1 = setmetatable({}, {
    __tostring = function() -- Line: 12, Name: __tostring
        return "PerformanceProbeController";
    end
});
u1.__index = u1;

function u1.new(...) -- Line: 17
    -- upvalues: u1 (ref)
    local v2 = setmetatable({}, u1);

    return v2:constructor(...) or v2;
end;

function u1.constructor(p3) -- Line: 21
    p3.lastReport = 0;
end;

function u1.onTick(p4, p5) -- Line: 24
    -- upvalues: MiscEvents (copy), DirtBudget (copy)
    if p5 < 0.25 then
        return nil;
    end;

    local v6 = os.clock();

    if v6 - p4.lastReport < 10 then
        return nil;
    end;

    p4.lastReport = v6;
    MiscEvents.ReportLongFrame:fire(math.floor(p5 * 1000), DirtBudget.isDraining() and "dirt" or "other");
end;

Reflect.defineMetadata(u1, "identifier", "client/controllers/misc/PerformanceProbeController@PerformanceProbeController");
Reflect.defineMetadata(u1, "flamework:implements", { "$:flamework@OnTick" });
Reflect.decorate(u1, "$:flamework@Controller", Controller, { {} });

return {
    PerformanceProbeController = u1
};