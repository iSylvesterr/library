-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
require(ReplicatedStorage.Library.Modules.DefaultStats.Types.Interface);
local Currency = require(ReplicatedStorage.Library.Types.Currency);
local t = require(ReplicatedStorage.Library.Modules.Packages.t);
local u1 = {};
local v2 = {
    Easy = {
        Icon = "rbxassetid://74160368106752",
        Rolls = 1,
        Scale = 0.83,
        Gradient = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(251, 131, 131)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 49, 49)) })
    },
    Medium = {
        Icon = "rbxassetid://130331699933836",
        Rolls = 2,
        Scale = 0.94,
        Gradient = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 246, 112)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 169, 64)) })
    },
    Hard = {
        Icon = "rbxassetid://139767177148368",
        Rolls = 3,
        Scale = 0.94,
        Gradient = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(251, 134, 245)), ColorSequenceKeypoint.new(1, Color3.fromRGB(221, 52, 255)) })
    },
    Impossible = {
        Icon = "rbxassetid://126777374447687",
        Rolls = 3,
        Gradient = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(251, 134, 245)), ColorSequenceKeypoint.new(1, Color3.fromRGB(221, 52, 255)) })
    }
};
u1.REFRESH_INTERVAL = 86400;
u1.RESET_UTC_HOUR = 23;
u1.TypeData = v2;

function u1.GetResetPeriodIndex(p3) -- Line: 77
    -- upvalues: Asserts (copy)
    Asserts.number(p3);
    local v4 = (math.max(p3, 0) - 82800) / 86400;

    return math.floor(v4);
end;

function u1.GetNextResetAt(p5) -- Line: 82
    -- upvalues: Asserts (copy), u1 (copy)
    Asserts.number(p5);

    return (u1.GetResetPeriodIndex(p5) + 1) * 86400 + 82800;
end;

function u1.GetTimeLeftUntilReset(p6) -- Line: 87
    -- upvalues: Asserts (copy), u1 (copy)
    Asserts.number(p6);
    local v7 = u1.GetNextResetAt(p6) - p6;

    return math.max(0, v7);
end;

for i, v in pairs(u1.TypeData) do
    v.Name = i;
end;

local v8 = {};
u1.SchemaValidation = v8;
v8.TypeData = t.interface({
    Icon = t.string,
    Gradient = t.ColorSequence,
    Rolls = t.number,
    Scale = t.optional(t.number),
    Name = t.optional(t.string)
});
v8.AllDifficulties = t.union(t.literal("Easy"), t.literal("Medium"), t.literal("Hard"), t.literal("Impossible"));
v8.LuckyBlockReward = t.interface({
    Id = t.string,
    TemplateId = t.literal("LuckyBlock"),
    Category = t.string
});
v8.RandomCurrentSpeedPowerOrCurrentStepMoneyReward = t.interface({
    Id = t.string,
    TemplateId = t.literal("RandomCurrentSpeedPowerOrCurrentStepMoney"),
    SpeedPowerPercent = t.number,
    MoneySeconds = t.number,
    CurrencyId = Currency.SchemaValidation.AllCurrencyTypes
});
v8.RewardConfig = t.union(v8.LuckyBlockReward, v8.RandomCurrentSpeedPowerOrCurrentStepMoneyReward);
v8.RedeemPresentation = t.interface({
    RewardId = t.string,
    MoneyNotificationAmount = t.optional(t.number),
    SpeedPowerNotificationAmount = t.optional(t.number)
});
v8.RedeemPayload = t.interface({
    GiftId = t.number,
    Rewards = t.array(v8.RedeemPresentation)
});

return u1;