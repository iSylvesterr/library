-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services");
local Players = v1.Players;
local TextChatService = v1.TextChatService;
local VIP_ATTRIBUTE = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "monetization", "Vip").VIP_ATTRIBUTE;
local RichTextUtil = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "ui", "RichTextUtil").RichTextUtil;
local VIP_TAG_COLOR = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "ui", "VipTag").VIP_TAG_COLOR;
local u2 = RichTextUtil.color("[VIP]", VIP_TAG_COLOR);
local u3 = setmetatable({}, {
    __tostring = function() -- Line: 15, Name: __tostring
        return "VipChatController";
    end
});
u3.__index = u3;

function u3.new(...) -- Line: 20
    -- upvalues: u3 (ref)
    local v4 = setmetatable({}, u3);

    return v4:constructor(...) or v4;
end;

function u3.constructor(p5) -- Line: 24
end;

function u3.onStart(p6) -- Line: 26
    -- upvalues: TextChatService (copy), Players (copy), VIP_ATTRIBUTE (copy), u2 (copy)
    function TextChatService.OnIncomingMessage(p7) -- Line: 27
        -- upvalues: Players (ref), VIP_ATTRIBUTE (ref), u2 (ref)
        local TextSource = p7.TextSource;

        if TextSource ~= nil then
            TextSource = TextSource.UserId;
        end;

        if TextSource == nil then
            return nil;
        end;

        local v8 = Players:GetPlayerByUserId(TextSource);

        if v8 ~= nil then
            v8 = v8:GetAttribute(VIP_ATTRIBUTE);
        end;

        if v8 ~= true then
            return nil;
        end;

        local TextChatMessageProperties = Instance.new("TextChatMessageProperties");
        TextChatMessageProperties.PrefixText = `{u2} {p7.PrefixText}`;

        return TextChatMessageProperties;
    end;
end;

Reflect.defineMetadata(u3, "identifier", "client/controllers/misc/VipChatController@VipChatController");
Reflect.defineMetadata(u3, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u3, "$:flamework@Controller", Controller, { {} });

return {
    VipChatController = u3
};