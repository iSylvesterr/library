-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(ReplicatedStorage.Classes.Ragdoll.Types);
local LocalPlayer = Players.LocalPlayer;
local Sound = require(ReplicatedStorage.Classes.Sound);
local Ragdoll = require(ReplicatedStorage.Classes.Ragdoll);
local Finishers = Sound.new("Finishers");

local function IsLocalPlayer(p1) -- Line: 25
    -- upvalues: LocalPlayer (copy)
    return p1 == tostring(LocalPlayer.UserId);
end;

local function Activate(u2, p3) -- Line: 31
    -- upvalues: LocalPlayer (copy), Finishers (copy)
    local v4 = u2.Janitor:Add(script.FinisherGui:Clone(), "Destroy", "FinisherGui");
    v4.Parent = LocalPlayer.PlayerGui;
    local v5 = Finishers:play({
        Name = "LeSunshine",
        Parent = v4
    });

    if not v5 then
        return;
    end;

    u2.Janitor:Add(v5.Ended:Once(function() -- Line: 44
        -- upvalues: u2 (copy)
        u2.Janitor:Remove("FinisherGui");
    end));
end;

return {
    Replication = "All",

    Finisher = function(p6, p7) -- Line: 55, Name: Finisher
        -- upvalues: Ragdoll (copy), LocalPlayer (copy), Activate (copy)
        local u8 = Ragdoll.new(p6, p7);

        if p7.Victim == tostring(LocalPlayer.UserId) then
            Activate(u8, p7);
        end;

        return {
            OnDestroy = u8.OnDestroy,

            Destroy = function() -- Line: 65, Name: Destroy
                -- upvalues: u8 (copy)
                u8:Destroy();
            end
        };
    end
};