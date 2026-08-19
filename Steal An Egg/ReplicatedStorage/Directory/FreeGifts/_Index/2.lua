-- Decompiled with Potassium's decompiler.

local Default = require(script.Parent.Parent.BaseConfigs.Default);
local RewardTemplates = require(script.Parent.Parent.BaseConfigs.RewardTemplates);
require(script.Parent.Parent.Types.Interface);
local v1 = {
    Id = 2,
    Type = "Easy",
    WaitTime = 600,
    Rewards = { RewardTemplates.CloneCurrentSpeedPowerOrCurrentStepMoneyReward(script.Name) }
};

return setmetatable(v1, {
    __index = Default
});