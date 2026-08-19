-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local AreaEggs = require(ReplicatedStorage.Library.Types.AreaEggs);
local ButtonFX = require(ReplicatedStorage.Library.Client.GUIFX.ButtonFX);
local EggCmds = require(ReplicatedStorage.Library.Client.EggCmds);
local GUI = require(ReplicatedStorage.Library.Client.GUI);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local PlayerRequest = AreaEggs.DropReasons.PlayerRequest;
local u1 = Log.new();
local LocalPlayer = Players.LocalPlayer;
local u2 = GUI.DropHeldEgg();
u2.Enabled = false;
ButtonFX(u2.Button, nil, function() -- Line: 45
    -- upvalues: EggCmds (copy), PlayerRequest (copy), u1 (copy), LocalPlayer (copy)
    local v3, v4 = EggCmds.RequestDropHeldAreaEgg(PlayerRequest);

    if not v3 and v4 ~= nil then
        u1:AtDebug():Log((`Drop held area egg denied for {LocalPlayer.UserId}: {v4}`));
    end;
end);
EggCmds.AreaEggCarryStateChanged:Connect(function(p5) -- Line: 31, Name: setCarrying
    -- upvalues: u2 (copy)
    if p5.IsCarrying then
        u2.Enabled = true;

        return;
    end;

    u2.Enabled = false;
end);