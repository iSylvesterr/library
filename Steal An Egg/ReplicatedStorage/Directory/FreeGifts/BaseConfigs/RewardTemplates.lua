-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Library.Types.FreeGifts);
local v1 = {};
local u2 = {
    Id = "",
    TemplateId = "LuckyBlock",
    Category = "Limited Block"
};
local u3 = {
    Id = "",
    TemplateId = "RandomCurrentSpeedPowerOrCurrentStepMoney",
    SpeedPowerPercent = 0.03,
    MoneySeconds = 60,
    CurrencyId = "Money"
};
local u4 = {
    Id = "",
    TemplateId = "RandomCurrentSpeedPowerOrCurrentStepMoney",
    SpeedPowerPercent = 0.04,
    MoneySeconds = 75,
    CurrencyId = "Money"
};
local u5 = {
    Id = "",
    TemplateId = "RandomCurrentSpeedPowerOrCurrentStepMoney",
    SpeedPowerPercent = 0.05,
    MoneySeconds = 90,
    CurrencyId = "Money"
};

local function cloneAssetRewardWithId(p6, p7) -- Line: 45
    local v8 = table.clone(p6);
    v8.Id = p7;

    return v8;
end;

local function cloneRandomRewardWithId(p9, p10) -- Line: 51
    local v11 = table.clone(p9);
    v11.Id = p10;

    return v11;
end;

function v1.CloneCurrentSpeedPowerOrCurrentStepMoneyReward(p12) -- Line: 60
    -- upvalues: u3 (copy)
    local v13 = table.clone(u3);
    v13.Id = p12;

    return v13;
end;

function v1.CloneEpicCurrentSpeedPowerOrCurrentStepMoneyReward(p14) -- Line: 66
    -- upvalues: u4 (copy)
    local v15 = table.clone(u4);
    v15.Id = p14;

    return v15;
end;

function v1.CloneLegendaryCurrentSpeedPowerOrCurrentStepMoneyReward(p16) -- Line: 72
    -- upvalues: u5 (copy)
    local v17 = table.clone(u5);
    v17.Id = p16;

    return v17;
end;

function v1.CloneLimitedBlock(p18) -- Line: 78
    -- upvalues: u2 (copy)
    local v19 = table.clone(u2);
    v19.Id = p18;

    return v19;
end;

return v1;