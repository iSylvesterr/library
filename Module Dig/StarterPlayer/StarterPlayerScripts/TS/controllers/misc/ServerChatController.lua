-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local MiscEvents = RuntimeLib.import(script, script.Parent.Parent.Parent, "network", "MiscNetwork").MiscEvents;
local TextChatService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").TextChatService;
local RichTextApply = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "string", "RichUtil").RichTextApply;
local u1 = setmetatable({}, {
    __tostring = function() -- Line: 11, Name: __tostring
        return "ServerChatController";
    end
});
u1.__index = u1;

function u1.new(...) -- Line: 16
    -- upvalues: u1 (ref)
    local v2 = setmetatable({}, u1);

    return v2:constructor(...) or v2;
end;

function u1.constructor(p3) -- Line: 20
end;

function u1.onStart(u4) -- Line: 22
    -- upvalues: MiscEvents (copy), RichTextApply (copy)
    task.spawn(function() -- Line: 23
        -- upvalues: u4 (copy)
        return u4:initializeChannel();
    end);
    MiscEvents.SendServerMessage:connect(function(p5, p6, p7, p8) -- Line: 26
        -- upvalues: u4 (copy), RichTextApply (ref)
        local channel = u4.channel;

        if not channel then
            return nil;
        end;

        local v9 = RichTextApply(p7 and "[GLOBAL]" or "[SERVER]", {
            Bold = true,
            FontWeight = "Heavy",
            Color = p6
        });

        if not p8 then
            p5 = RichTextApply(p5, {
                Bold = true,
                FontWeight = "Heavy",
                Color = p6:Lerp(Color3.new(0, 0, 0), 0.15)
            });
        end;

        channel:DisplaySystemMessage(RichTextApply(`{v9} {p5}`, {
            Stroke = {
                Joins = "Bevel",
                Thickness = 4,
                Transparency = 0,
                Color = p6
            }
        }));
    end);
end;

function u1.initializeChannel(p10) -- Line: 51
    -- upvalues: TextChatService (copy)
    local TextChannels = TextChatService:WaitForChild("TextChannels", 30);

    if not TextChannels then
        return nil;
    end;

    local RBXGeneral = TextChannels:WaitForChild("RBXGeneral", 30);

    if not (RBXGeneral and RBXGeneral:IsA("TextChannel")) then
        return nil;
    end;

    p10.channel = RBXGeneral;
end;

Reflect.defineMetadata(u1, "identifier", "client/controllers/misc/ServerChatController@ServerChatController");
Reflect.defineMetadata(u1, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u1, "$:flamework@Controller", Controller, { {} });

return {
    ServerChatController = u1
};