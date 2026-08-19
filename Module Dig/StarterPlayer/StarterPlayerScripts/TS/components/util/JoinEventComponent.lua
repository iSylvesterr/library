-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out");
local Component = v1.Component;
local BaseComponent = v1.BaseComponent;
local Janitor = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "janitor", "src").Janitor;
local u2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "EventUtils");
local PromptEvent = u2.PromptEvent;
local EVENT_ID_KEY = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "config", "Config").EVENT_ID_KEY;
local u3 = setmetatable({}, {
    __tostring = function() -- Line: 17, Name: __tostring
        return "JoinEventComponent";
    end,

    __index = BaseComponent
});
u3.__index = u3;

function u3.new(...) -- Line: 23
    -- upvalues: u3 (ref)
    local v4 = setmetatable({}, u3);

    return v4:constructor(...) or v4;
end;

function u3.constructor(p5, p6, p7) -- Line: 27
    -- upvalues: BaseComponent (copy), Janitor (copy)
    BaseComponent.constructor(p5);
    p5.dataController = p6;
    p5.configController = p7;
    p5.janitor = Janitor.new();
end;

function u3.getEventId(p8) -- Line: 33
    -- upvalues: EVENT_ID_KEY (copy)
    local v9 = p8.configController:getConfigValue(EVENT_ID_KEY);

    if type(v9) == "string" and #v9 > 0 then
        return v9;
    end;

    return nil;
end;

function u3.onStart(u10) -- Line: 37
    -- upvalues: u2 (copy), PromptEvent (copy)
    local Board = u10.instance:WaitForChild("Board", 15);

    if not Board then
        return nil;
    end;

    local ProximityPrompt = Instance.new("ProximityPrompt");
    ProximityPrompt.ActionText = "Join Update";
    ProximityPrompt.ObjectText = "";
    ProximityPrompt.HoldDuration = 0.5;
    ProximityPrompt.RequiresLineOfSight = false;
    ProximityPrompt.MaxActivationDistance = 7;
    ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom;
    ProximityPrompt.Parent = Board;
    u10.janitor:Add(ProximityPrompt, "Destroy");
    task.spawn(function() -- Line: 51
        -- upvalues: u10 (copy), ProximityPrompt (copy), u2 (ref)
        local v11 = u10:getEventId();

        if v11 == nil then
            ProximityPrompt.Enabled = false;

            return nil;
        end;

        if u2.IsSubscribed(v11) then
            ProximityPrompt.Enabled = false;

            return nil;
        end;
    end);
    u10.janitor:Add(ProximityPrompt.Triggered:Connect(function() -- Line: 62
        -- upvalues: u10 (copy), PromptEvent (ref)
        if not u10.dataController:getData() then
            return nil;
        end;

        local v12 = u10:getEventId();

        if v12 == nil then
            return nil;
        end;

        PromptEvent(v12);
    end), "Disconnect");
end;

function u3.destroy(p13) -- Line: 74
    p13.janitor:Destroy();
end;

Reflect.defineMetadata(u3, "identifier", "client/components/util/JoinEventComponent@JoinEventComponent");
Reflect.defineMetadata(u3, "flamework:parameters", { "client/controllers/data/DataController@DataController", "client/controllers/config/ConfigController@ConfigController" });
Reflect.defineMetadata(u3, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u3, "$c:components@Component", Component, {
    {
        tag = "JoinEvent",
        attributes = {},
        instanceGuard = t.instanceIsA("Model")
    }
});

return {
    JoinEventComponent = u3
};