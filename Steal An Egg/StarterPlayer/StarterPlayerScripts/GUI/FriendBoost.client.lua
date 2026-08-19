-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local GUI = require(ReplicatedStorage.Library.Client.GUI);
local GetFriendCountInServer = require(ReplicatedStorage.Library.Functions.GetFriendCountInServer);
local FriendBoosts = require(ReplicatedStorage.Library.Shared.Variables.FriendBoosts);
local Confetti = require(ReplicatedStorage.Library.Client.GUIFX.Confetti);
local UpdateTextAndShadow = require(ReplicatedStorage.Library.Functions.UpdateTextAndShadow);
local Network = require(game.ReplicatedStorage.Library.Client.Network);
local LocalPlayer = Players.LocalPlayer;
local FriendBoost = GUI.Money().Bottom.Frame.FriendBoost;
local CurrentBoost = FriendBoost.CurrentBoost;
FriendBoost.Visible = false;

local function onFriendsInGame() -- Line: 24
    -- upvalues: FriendBoost (copy)
    FriendBoost.Visible = true;
end;

local function onNoFriends() -- Line: 28
    -- upvalues: FriendBoost (copy)
    FriendBoost.Visible = false;
end;

local function updateBoostsDisplay() -- Line: 32
    -- upvalues: GetFriendCountInServer (copy), LocalPlayer (copy), FriendBoost (copy), FriendBoosts (copy), UpdateTextAndShadow (copy), CurrentBoost (copy)
    local v1 = GetFriendCountInServer.GetCountByPlayer(LocalPlayer);

    if not v1 or v1 <= 0 then
        FriendBoost.Visible = false;

        return;
    end;

    local v2 = FriendBoosts.BaseBoostPercent * math.clamp(v1, 0, FriendBoosts.MaxPlayers);
    local v3 = math.floor(v2);

    if v3 <= 0 then
        FriendBoost.Visible = false;

        return;
    end;

    FriendBoost.Visible = true;
    UpdateTextAndShadow(CurrentBoost, string.format("Friend Boost: +%d%%", v3));
end;

GetFriendCountInServer.CacheUpdated:Connect(function(p4) -- Line: 49
    -- upvalues: LocalPlayer (copy), updateBoostsDisplay (copy)
    if p4 == LocalPlayer then
        updateBoostsDisplay();
    end;
end);
updateBoostsDisplay();
Players.PlayerAdded:Connect(updateBoostsDisplay);
Players.PlayerRemoving:Connect(updateBoostsDisplay);
Network.Fired(Network.NET_MAP.InviteFriends.ON_INVITE_SUCCESS):Connect(function() -- Line: 59
    -- upvalues: Confetti (copy)
    Confetti.Play();
end);

return {};