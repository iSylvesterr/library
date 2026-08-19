-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ToolSetup = require(ReplicatedStorage.Library.Util.ToolSetup);
local Network = require(ReplicatedStorage.Library.Client.Network);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local u1 = require(ReplicatedStorage.Library.Modules.Packages.Log).new();
local Magnet = require(ReplicatedStorage.Directory.Gears._Index.Other.Magnet);
local Magnet2 = Constants.NETWORK_MAP.Magnet;
local COOLDOWN = Magnet.COOLDOWN;
local LocalPlayer = Players.LocalPlayer;
local u2 = nil;

local function cleanupTargetVFX() -- Line: 26
    -- upvalues: u2 (ref)
    if u2 and u2.Parent then
        u2:Destroy();
    end;

    u2 = nil;
end;

local function playTargetVFX() -- Line: 34
    -- upvalues: u2 (ref), LocalPlayer (copy), u1 (copy), Magnet (copy)
    if u2 and u2.Parent then
        u2:Destroy();
    end;

    u2 = nil;
    local Character = LocalPlayer.Character;

    if not Character then
        u1:AtWarning():Log("[Magnet] Local character not found");

        return;
    end;

    local v3 = Character.PrimaryPart or Character:FindFirstChild("HumanoidRootPart");

    if not (v3 and v3:IsA("BasePart")) then
        u1:AtWarning():Log("[Magnet] Could not find local character root part");

        return;
    end;

    local MAGNET_EFFECT_PATH = Magnet.MAGNET_EFFECT_PATH;

    if not MAGNET_EFFECT_PATH then
        u1:AtWarning():Log("[Magnet] Could not find MagnetEffect template");

        return;
    end;

    local v4 = MAGNET_EFFECT_PATH:IsA("BasePart");
    assert(v4, "[Magnet] MagnetEffect template must be a Part");
    local v5 = MAGNET_EFFECT_PATH:Clone();
    v5.Name = "MagnetTargetVFX";
    v5.Parent = v3;
    u2 = v5;
end;

local function stopTargetVFX() -- Line: 64
    -- upvalues: u2 (ref)
    if u2 and u2.Parent then
        u2:Destroy();
    end;

    u2 = nil;
end;

local u7 = ToolSetup.Initialize(Magnet.DisplayName, {
    onActivated = function(p6) -- Line: 68, Name: onActivated
        -- upvalues: Network (copy), Magnet2 (copy)
        Network.Fire(Magnet2.REQUEST_PULL);
    end,

    onUnequipped = function() -- Line: 72, Name: onUnequipped
        -- upvalues: u2 (ref)
        if u2 and u2.Parent then
            u2:Destroy();
        end;

        u2 = nil;
    end
});
Network.Fired(Magnet2.PLAY_BEAM_VFX):Connect(function(p8, p9) -- Line: 82
    -- upvalues: LocalPlayer (copy), ToolSetup (copy), u7 (ref), COOLDOWN (copy)
    if p8 == LocalPlayer.Character then
        ToolSetup.StartCooldown(u7, COOLDOWN);
    end;
end);
Network.Fired(Magnet2.PLAY_TARGET_VFX):Connect(function() -- Line: 88
    -- upvalues: playTargetVFX (copy)
    playTargetVFX();
end);
Network.Fired(Magnet2.STOP_TARGET_VFX):Connect(function() -- Line: 92
    -- upvalues: u2 (ref)
    if u2 and u2.Parent then
        u2:Destroy();
    end;

    u2 = nil;
end);