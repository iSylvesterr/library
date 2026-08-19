-- Decompiled with Potassium's decompiler.

local LocalPlayer = game:GetService("Players").LocalPlayer;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Remotes = ReplicatedStorage:WaitForChild("Remotes");
local Sounds = ReplicatedStorage:WaitForChild("Sounds");
local UISoundController = require(Sounds.UISoundController);
local FriendBoost = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("MainGui"):WaitForChild("Root"):WaitForChild("FriendBoost");
Remotes.UpdateFriendBoost.OnClientEvent:Connect(function(p1) -- Line: 12
    -- upvalues: FriendBoost (copy)
    FriendBoost.Text = `Friend Boost: +{math.round(p1 * 100)}%`;
end);
FriendBoost.InviteButton.Button.Activated:Connect(function() -- Line: 17
    -- upvalues: UISoundController (copy), LocalPlayer (copy)
    UISoundController.Play("Click");
    game:GetService("SocialService"):PromptGameInvite(LocalPlayer);
end);