-- Decompiled with Potassium's decompiler.

return {
    getRewardedVideoAdAvailabilityNow = function() -- Line: 3, Name: getRewardedVideoAdAvailabilityNow
        local AdService = game:GetService("AdService");
        local success, result = pcall(function() -- Line: 5
            -- upvalues: AdService (copy)
            return AdService:GetAdAvailabilityNowAsync(Enum.AdFormat.RewardedVideo);
        end);

        if success then
            return type(result) == "table" and (result.AdAvailabilityResult ~= nil and result.AdAvailabilityResult == Enum.AdAvailabilityResult.IsAvailable);
        end;

        return false;
    end,

    showRewardedVideoAdForDevProduct = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).async(function(p1, p2) -- Line: 16
        local AdService = game:GetService("AdService");

        return AdService:ShowRewardedVideoAdAsync(p1, (AdService:CreateAdRewardFromDevProductId(p2)));
    end)
};