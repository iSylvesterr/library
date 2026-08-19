-- Decompiled with Potassium's decompiler.

local TeleportService = game:GetService("TeleportService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local Network = require(ReplicatedStorage.Library.Client.Network);
local Analytics = Constants.NETWORK_MAP.Analytics;
local u1 = Analytics.REQUEST_AFK_TELEPORT_FLUSH or Analytics.REPORT_AFK_TELEPORT;
local LocalPlayer = Players.LocalPlayer;
local u2 = false;

local function reportAfkState(p3) -- Line: 27
    -- upvalues: u2 (ref), Network (copy), Analytics (copy)
    if u2 == p3 then
        return;
    end;

    u2 = p3;
    Network.Fire(Analytics.REPORT_AFK_STATE, p3);
end;

local function reportActiveFromInput() -- Line: 36
    -- upvalues: u2 (ref), Network (copy), Analytics (copy)
    if not u2 then
        return;
    end;

    if u2 == false then
        return;
    end;

    u2 = false;
    Network.Fire(Analytics.REPORT_AFK_STATE, false);
end;

LocalPlayer.Idled:Connect(function(p4) -- Line: 48
    -- upvalues: u2 (ref), Network (copy), Analytics (copy), Constants (copy), u1 (copy), TeleportService (copy), LocalPlayer (copy)
    if p4 >= 60 and u2 ~= true then
        u2 = true;
        Network.Fire(Analytics.REPORT_AFK_STATE, true);
    end;

    if p4 > 1080 and not Constants.IS_STUDIO then
        pcall(function() -- Line: 54
            -- upvalues: Network (ref), u1 (ref)
            Network.Invoke(u1);
        end);
        TeleportService:Teleport(game.PlaceId, LocalPlayer);
    end;
end);
UserInputService.InputBegan:Connect(function() -- Line: 61
    -- upvalues: u2 (ref), Network (copy), Analytics (copy)
    if not u2 then
        return;
    end;

    if u2 == false then
        return;
    end;

    u2 = false;
    Network.Fire(Analytics.REPORT_AFK_STATE, false);
end);
UserInputService.InputChanged:Connect(function(p5) -- Line: 64
    -- upvalues: u2 (ref), Network (copy), Analytics (copy)
    if p5.UserInputType == Enum.UserInputType.MouseMovement then
        if not u2 then
            return;
        end;

        if u2 == false then
            return;
        end;

        u2 = false;
        Network.Fire(Analytics.REPORT_AFK_STATE, false);

        return;
    end;

    if p5.UserInputType ~= Enum.UserInputType.Touch then
        if string.find(p5.UserInputType.Name, "Gamepad") ~= nil then
            if not u2 then
                return;
            end;

            if u2 == false then
                return;
            end;

            u2 = false;
            Network.Fire(Analytics.REPORT_AFK_STATE, false);
        end;

        return;
    end;

    if not u2 then
        return;
    end;

    if u2 == false then
        return;
    end;

    u2 = false;
    Network.Fire(Analytics.REPORT_AFK_STATE, false);
end);