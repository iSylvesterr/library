-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services");
local UserInputService = v1.UserInputService;
local TeleportService = v1.TeleportService;
local Players = v1.Players;
local RunService = v1.RunService;
local Player = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "player", "playerConstants").Player;
local MiscEvents = RuntimeLib.import(script, script.Parent.Parent.Parent, "network", "MiscNetwork").MiscEvents;
local afkTeleportData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "afk", "AfkTeleport").afkTeleportData;
local u2 = setmetatable({}, {
    __tostring = function() -- Line: 16, Name: __tostring
        return "AFKController";
    end
});
u2.__index = u2;

function u2.new(...) -- Line: 21
    -- upvalues: u2 (ref)
    local v3 = setmetatable({}, u2);

    return v3:constructor(...) or v3;
end;

function u2.constructor(p4) -- Line: 25
    p4.afkTime = 1140;
    p4.lastInput = os.time();
    p4.afkEnabled = false;
end;

function u2.onStart(u5) -- Line: 30
    -- upvalues: UserInputService (copy), RunService (copy), Players (copy), TeleportService (copy), Player (copy), afkTeleportData (copy), MiscEvents (copy)
    UserInputService.InputBegan:Connect(function(p6) -- Line: 31
        -- upvalues: u5 (copy)
        u5.lastInput = os.time();
    end);
    local u7 = RunService.Heartbeat:Connect(function() -- Line: 34
        -- upvalues: u5 (copy), Players (ref), TeleportService (ref), Player (ref), afkTeleportData (ref), MiscEvents (ref)
        if os.time() - u5.lastInput <= u5.afkTime then
            return nil;
        end;

        u5.lastInput = os.time();

        if #Players:GetPlayers() > 1 then
            TeleportService:Teleport(game.PlaceId, Player, afkTeleportData());

            return;
        end;

        MiscEvents.AntiAFK:fire();
    end);
    TeleportService.TeleportInitFailed:Connect(function() -- Line: 46
        -- upvalues: u7 (copy)
        return u7:Disconnect();
    end);
end;

Reflect.defineMetadata(u2, "identifier", "client/controllers/misc/AFKController@AFKController");
Reflect.defineMetadata(u2, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u2, "$:flamework@Controller", Controller, { {} });

return {
    AFKController = u2
};