-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local AssetItemUtil = require(ReplicatedStorage.Library.Util.AssetItemUtil);
local Simple = require(ReplicatedStorage.Library.Modules.FormatNumber.Simple);
require(script.Parent.Types.Interface);

return {
    Render = function(p1, p2, p3, p4) -- Line: 19, Name: Render
        -- upvalues: Asserts (copy), Simple (copy), AssetItemUtil (copy)
        Asserts.boolean(p3);
        Asserts.boolean(p4);
        local ClaimButton = p1.ClaimButton;
        p1.Rewards.MoneyReward.ClaimedIcon.Visible = p3;
        p1.Rewards.SpeedReward.ClaimedIcon.Visible = p3;

        if p2 == nil then
            ClaimButton.TextLabelFrame.TextLabel.Text = "CLAIM!";
            ClaimButton.TextButton.UIGradient.Enabled = false;
            ClaimButton.TextButton.GreyGradient.Enabled = true;
            ClaimButton.NotificationBadge.Visible = false;

            return;
        end;

        p1.Rewards.SpeedReward.TextLabelFrame.TextLabel.Text = "+" .. Simple.FormatCompact(AssetItemUtil.GetIndexSpeedRewardAmount(p2.Category), ".#");
        p1.Rewards.MoneyReward.TextLabelFrame.TextLabel.Text = "$" .. Simple.FormatCompact(AssetItemUtil.GetIndexMoneyRewardAmount(p2.Category), ".#");
        ClaimButton.TextLabelFrame.TextLabel.Text = p3 and "CLAIMED!" or "CLAIM!";
        ClaimButton.TextButton.UIGradient.Enabled = p4;
        ClaimButton.TextButton.GreyGradient.Enabled = not p4;
        ClaimButton.NotificationBadge.Visible = p4;
    end
};