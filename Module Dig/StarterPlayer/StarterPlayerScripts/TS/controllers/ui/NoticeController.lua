-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local FrameComponent = RuntimeLib.import(script, script.Parent.Parent.Parent, "components", "ui", "FrameComponent").FrameComponent;
local PlayerGui = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "player", "playerConstants").PlayerGui;
local MiscFunctions = RuntimeLib.import(script, script.Parent.Parent.Parent, "network", "MiscNetwork").MiscFunctions;
local NoticeEvents = RuntimeLib.import(script, script.Parent.Parent.Parent, "network", "NoticeNetwork").NoticeEvents;
local TOURISTS_LEAVING_NOTICE = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "ui", "Notices").TOURISTS_LEAVING_NOTICE;
local WFChain = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "instances", "WFChain").WFChain;
local u1 = setmetatable({}, {
    __tostring = function() -- Line: 15, Name: __tostring
        return "NoticeController";
    end
});
u1.__index = u1;

function u1.new(...) -- Line: 20
    -- upvalues: u1 (ref)
    local v2 = setmetatable({}, u1);

    return v2:constructor(...) or v2;
end;

function u1.constructor(p3) -- Line: 24
end;

function u1.onStart(u4) -- Line: 26
    -- upvalues: WFChain (copy), PlayerGui (copy), NoticeEvents (copy), RuntimeLib (copy), MiscFunctions (copy), TOURISTS_LEAVING_NOTICE (copy)
    u4.label = WFChain(PlayerGui, "Main", "Notice", "Notice");
    NoticeEvents.ShowNotice:connect(function(p5) -- Line: 28
        -- upvalues: u4 (copy)
        return u4:show(p5);
    end);
    task.spawn(RuntimeLib.async(function() -- Line: 31
        -- upvalues: RuntimeLib (ref), MiscFunctions (ref), u4 (copy), TOURISTS_LEAVING_NOTICE (ref)
        if RuntimeLib.await(MiscFunctions.RequestAfkReturn:invoke()) then
            u4:show(TOURISTS_LEAVING_NOTICE);
        end;
    end));
end;

function u1.show(p6, p7) -- Line: 37
    -- upvalues: FrameComponent (copy)
    p6.label.Text = p7;
    FrameComponent:toggleFrame("Notice", true);
end;

Reflect.defineMetadata(u1, "identifier", "client/controllers/ui/NoticeController@NoticeController");
Reflect.defineMetadata(u1, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u1, "$:flamework@Controller", Controller, { {} });

return {
    NoticeController = u1
};