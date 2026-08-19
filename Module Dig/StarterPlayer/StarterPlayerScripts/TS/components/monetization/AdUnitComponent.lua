-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out");
local Component = v1.Component;
local BaseComponent = v1.BaseComponent;
local PolicyService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").PolicyService;
local Player = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "player", "playerConstants").Player;
local u2 = setmetatable({}, {
    __tostring = function() -- Line: 13, Name: __tostring
        return "AdUnitComponent";
    end,

    __index = BaseComponent
});
u2.__index = u2;

function u2.new(...) -- Line: 19
    -- upvalues: u2 (ref)
    local v3 = setmetatable({}, u2);

    return v3:constructor(...) or v3;
end;

function u2.constructor(p4, ...) -- Line: 23
    -- upvalues: BaseComponent (copy)
    BaseComponent.constructor(p4, ...);
end;

function u2.onStart(p5) -- Line: 26
    -- upvalues: PolicyService (copy), Player (copy)
    local success, result = pcall(function() -- Line: 27
        -- upvalues: PolicyService (ref), Player (ref)
        return PolicyService:GetPolicyInfoForPlayerAsync(Player);
    end);

    if success and (result and not result.AreAdsAllowed) then
        p5.instance:Destroy();
    end;
end;

Reflect.defineMetadata(u2, "identifier", "client/components/monetization/AdUnitComponent@AdUnitComponent");
Reflect.defineMetadata(u2, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u2, "$c:components@Component", Component, { {
        tag = "AdUnit",
        attributes = {}
    } });

return {
    AdUnitComponent = u2
};