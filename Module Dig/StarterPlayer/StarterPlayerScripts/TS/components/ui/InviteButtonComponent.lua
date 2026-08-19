-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out");
local Component = v1.Component;
local BaseComponent = v1.BaseComponent;
local Janitor = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "janitor", "src").Janitor;
local SocialService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").SocialService;
local Player = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "player", "playerConstants").Player;
local Notification = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "Notification").Notification;
local u2 = setmetatable({}, {
    __tostring = function() -- Line: 16, Name: __tostring
        return "InviteButtonComponent";
    end,

    __index = BaseComponent
});
u2.__index = u2;

function u2.new(...) -- Line: 22
    -- upvalues: u2 (ref)
    local v3 = setmetatable({}, u2);

    return v3:constructor(...) or v3;
end;

function u2.constructor(p4, p5) -- Line: 26
    -- upvalues: BaseComponent (copy), Janitor (copy)
    BaseComponent.constructor(p4);
    p4.dataController = p5;
    p4.janitor = Janitor.new();
end;

function u2.onStart(u6) -- Line: 31
    -- upvalues: SocialService (copy), Player (copy), Notification (copy)
    u6.janitor:Add(u6.instance.Activated:Connect(function() -- Line: 32
        -- upvalues: u6 (copy), SocialService (ref), Player (ref), Notification (ref)
        local v7 = u6.dataController:getData();

        if not v7 then
            return nil;
        end;

        if v7.Info.CanSendInvite then
            SocialService:PromptGameInvite(Player);

            return;
        end;

        Notification.new("You can\'t send invites yet!", 2, "None", "Light Red");
    end));
end;

function u2.destroy(p8) -- Line: 44
    p8.janitor:Destroy();
end;

Reflect.defineMetadata(u2, "identifier", "client/components/ui/InviteButtonComponent@InviteButtonComponent");
Reflect.defineMetadata(u2, "flamework:parameters", { "client/controllers/data/DataController@DataController" });
Reflect.defineMetadata(u2, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u2, "$c:components@Component", Component, {
    {
        tag = "InviteButton",
        attributes = {},
        instanceGuard = t.instanceIsA("GuiButton")
    }
});

return {
    InviteButtonComponent = u2
};