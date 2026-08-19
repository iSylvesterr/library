-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local MiscEvents = RuntimeLib.import(script, script.Parent.Parent.Parent, "network", "MiscNetwork").MiscEvents;
local Notification = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "Notification").Notification;
local u1 = setmetatable({}, {
    __tostring = function() -- Line: 10, Name: __tostring
        return "NotificationController";
    end
});
u1.__index = u1;

function u1.new(...) -- Line: 15
    -- upvalues: u1 (ref)
    local v2 = setmetatable({}, u1);

    return v2:constructor(...) or v2;
end;

function u1.constructor(p3) -- Line: 19
end;

function u1.onStart(p4) -- Line: 21
    -- upvalues: MiscEvents (copy), Notification (copy)
    MiscEvents.NotifyPlayer:connect(function(p5, p6, p7, p8) -- Line: 22
        -- upvalues: Notification (ref)
        Notification.new(p5, p6, p7, p8);
    end);
end;

Reflect.defineMetadata(u1, "identifier", "client/controllers/misc/NotificationController@NotificationController");
Reflect.defineMetadata(u1, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u1, "$:flamework@Controller", Controller, { {} });

return {
    NotificationController = u1
};