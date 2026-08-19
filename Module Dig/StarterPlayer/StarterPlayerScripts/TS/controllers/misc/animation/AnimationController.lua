-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local MiscEvents = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "network", "MiscNetwork").MiscEvents;
local CharacterUtils = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "world", "CharacterUtils").CharacterUtils;
local u1 = setmetatable({}, {
    __tostring = function() -- Line: 10, Name: __tostring
        return "AnimationController";
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
    -- upvalues: MiscEvents (copy), CharacterUtils (copy)
    MiscEvents.StopAnimation:connect(function() -- Line: 22
        -- upvalues: CharacterUtils (ref)
        local v5 = CharacterUtils.getHumanoid();

        if not v5 then
            return nil;
        end;

        local v6 = v5:FindFirstChildOfClass("Animator");

        if not v6 then
            return nil;
        end;

        for _, v in v6:GetPlayingAnimationTracks() do
            v:Stop(0.1);
        end;
    end);
end;

Reflect.defineMetadata(u1, "identifier", "client/controllers/misc/animation/AnimationController@AnimationController");
Reflect.defineMetadata(u1, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u1, "$:flamework@Controller", Controller, { {} });

return {
    AnimationController = u1
};