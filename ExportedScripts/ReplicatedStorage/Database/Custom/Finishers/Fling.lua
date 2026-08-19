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

local function ModifyFinisherData(p2, p3) -- Line: 31
    for i, v in pairs(p3) do
        p2[i] = v;
    end;

    return p2;
end;

return {
    Replication = "All",

    Finisher = function(p4, p5) -- Line: 43, Name: Finisher
        -- upvalues: Ragdoll (copy), LocalPlayer (copy), Finishers (copy)
        local new = Ragdoll.new;
        local v6 = {
            DirectionMultiplier = math.random(25, 40)
        };

        for i, v in pairs(v6) do
            p5[i] = v;
        end;

        local u7 = new(p4, p5);

        if p5.Victim == tostring(LocalPlayer.UserId) then
            Finishers:play({
                Name = "Fling",
                Parent = LocalPlayer.PlayerGui
            });
        end;

        return {
            OnDestroy = u7.OnDestroy,

            Destroy = function() -- Line: 55, Name: Destroy
                -- upvalues: u7 (copy)
                u7:Destroy();
            end
        };
    end
};