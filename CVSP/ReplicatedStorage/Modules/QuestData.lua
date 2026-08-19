-- Decompiled with Potassium's decompiler.

local Modules = game:GetService("ReplicatedStorage"):WaitForChild("Modules");
local u1 = {
    DAILY_COUNT = 3,
    Daily = {
        {
            Id = "DailyDefeat75",
            Label = "Plants Defeated",
            Stat = "PlantsDefeated",
            Target = 75,
            Reward = {
                Type = "Money",
                Amount = 2500
            }
        },
        {
            Id = "DailyDefeat150",
            Label = "Plants Defeated",
            Stat = "PlantsDefeated",
            Target = 150,
            Reward = {
                Type = "Money",
                Amount = 6000
            }
        },
        {
            Id = "DailyHatch10",
            Label = "Eggs Hatched",
            Stat = "EggsHatched",
            Target = 10,
            Reward = {
                Type = "Money",
                Amount = 2500
            }
        },
        {
            Id = "DailyHatch15",
            Label = "Eggs Hatched",
            Stat = "EggsHatched",
            Target = 15,
            Reward = {
                Type = "Money",
                Amount = 4000
            }
        },
        {
            Id = "DailyRare20",
            Label = "Rare Plants Defeated",
            Stat = "PlantsDefeated_Rare",
            Target = 20,
            Reward = {
                Type = "Money",
                Amount = 5000
            }
        },
        {
            Id = "DailyRare40",
            Label = "Rare Plants Defeated",
            Stat = "PlantsDefeated_Rare",
            Target = 40,
            Reward = {
                Type = "Money",
                Amount = 10000
            }
        },
        {
            Id = "DailyLegendary5",
            Label = "Legendary Plants Defeated",
            Stat = "PlantsDefeated_Legendary",
            Target = 5,
            Reward = {
                Type = "Money",
                Amount = 7500
            }
        },
        {
            Id = "DailyLegendary10",
            Label = "Legendary Plants Defeated",
            Stat = "PlantsDefeated_Legendary",
            Target = 10,
            Reward = {
                Type = "Money",
                Amount = 20000
            }
        },
        {
            Id = "DailyBounty2",
            Label = "Bounties Completed",
            Stat = "BountiesCompleted",
            Target = 2,
            Reward = {
                Type = "Money",
                Amount = 10000
            }
        },
        {
            Id = "DailyBounty4",
            Label = "Bounties Completed",
            Stat = "BountiesCompleted",
            Target = 4,
            Reward = {
                Type = "Money",
                Amount = 25000
            }
        }
    },
    DailyBonusRewards = { {
            Type = "Totem",
            ItemName = "Totem Of Stars",
            Description = "Doubles weather mutation chance!",
            Amount = 1
        }, {
            Type = "Totem",
            ItemName = "Totem Of Status",
            Description = "Doubles chance for variants for plants and eggs!",
            Amount = 1
        }, {
            Type = "Totem",
            ItemName = "Totem Of Might",
            Description = "Increases capybara damage by 25%!",
            Amount = 1
        }, {
            Type = "Egg",
            ItemName = "Golem Capybara Egg",
            Description = "Divine capybara egg! (1.5K DPS)",
            Amount = 1
        } },
    MAX_LIFETIME_LEVEL = 11,
    Lifetime = {}
};

local function addLevel(p2, p3, p4) -- Line: 71
    -- upvalues: u1 (copy)
    for _, v in p3 do
        v.Id = "L" .. p2 .. v.Id;
    end;

    u1.Lifetime[p2] = {
        Level = p2,
        Quests = p3,
        CompletionReward = p4
    };
end;

addLevel(
    1,
    { {
            Id = "Tutorial",
            Label = "Tutorial Completed",
            Stat = "TutorialCompleted",
            Target = 1,
            Reward = {
                Type = "Money",
                Amount = 2500
            }
        }, {
            Id = "Defeat",
            Label = "Plants Defeated",
            Stat = "PlantsDefeated",
            Target = 25,
            Reward = {
                Type = "Money",
                Amount = 2500
            }
        }, {
            Id = "Hatch",
            Label = "Eggs Hatched",
            Stat = "EggsHatched",
            Target = 5,
            Reward = {
                Type = "Money",
                Amount = 2500
            }
        } },
    {
        Type = "Egg",
        ItemName = "Magic Capybara Egg",
        Amount = 1
    }
);
addLevel(
    2,
    { {
            Id = "Defeat",
            Label = "Plants Defeated",
            Stat = "PlantsDefeated",
            Target = 75,
            Reward = {
                Type = "Money",
                Amount = 3000
            }
        }, {
            Id = "Rare",
            Label = "Rare Plants Defeated",
            Stat = "PlantsDefeated_Rare",
            Target = 12,
            Reward = {
                Type = "Money",
                Amount = 4000
            }
        }, {
            Id = "Bounty",
            Label = "Bounties Completed",
            Stat = "BountiesCompleted",
            Target = 1,
            Reward = {
                Type = "Money",
                Amount = 5000
            }
        } },
    {
        Type = "Totem",
        ItemName = "Totem Of Might",
        Amount = 1
    }
);
addLevel(
    3,
    { {
            Id = "Defeat",
            Label = "Plants Defeated",
            Stat = "PlantsDefeated",
            Target = 200,
            Reward = {
                Type = "Money",
                Amount = 10000
            }
        }, {
            Id = "Legend",
            Label = "Legendary Plants Defeated",
            Stat = "PlantsDefeated_Legendary",
            Target = 6,
            Reward = {
                Type = "Money",
                Amount = 12500
            }
        }, {
            Id = "Bounty",
            Label = "Bounties Completed",
            Stat = "BountiesCompleted",
            Target = 3,
            Reward = {
                Type = "Money",
                Amount = 15000
            }
        } },
    {
        Type = "Egg",
        ItemName = "Ghost Capybara Egg",
        Amount = 1
    }
);
addLevel(
    4,
    { {
            Id = "Defeat",
            Label = "Plants Defeated",
            Stat = "PlantsDefeated",
            Target = 400,
            Reward = {
                Type = "Money",
                Amount = 20000
            }
        }, {
            Id = "Legend",
            Label = "Legendary Plants Defeated",
            Stat = "PlantsDefeated_Legendary",
            Target = 15,
            Reward = {
                Type = "Money",
                Amount = 30000
            }
        }, {
            Id = "Bounty",
            Label = "Bounties Completed",
            Stat = "BountiesCompleted",
            Target = 6,
            Reward = {
                Type = "Money",
                Amount = 50000
            }
        } },
    {
        Type = "Gear",
        ItemName = "Chilly Scroll",
        Amount = 2
    }
);
addLevel(
    5,
    { {
            Id = "Defeat",
            Label = "Plants Defeated",
            Stat = "PlantsDefeated",
            Target = 750,
            Reward = {
                Type = "Money",
                Amount = 50000
            }
        }, {
            Id = "Legend",
            Label = "Legendary Plants Defeated",
            Stat = "PlantsDefeated_Legendary",
            Target = 30,
            Reward = {
                Type = "Money",
                Amount = 60000
            }
        }, {
            Id = "Mythic",
            Label = "Mythic Plants Defeated",
            Stat = "PlantsDefeated_Mythic",
            Target = 8,
            Reward = {
                Type = "Money",
                Amount = 75000
            }
        } },
    {
        Type = "Gear",
        ItemName = "Gold Scroll",
        Amount = 1
    }
);
addLevel(
    6,
    { {
            Id = "Defeat",
            Label = "Plants Defeated",
            Stat = "PlantsDefeated",
            Target = 1500,
            Reward = {
                Type = "Money",
                Amount = 120000
            }
        }, {
            Id = "Mythic",
            Label = "Mythic Plants Defeated",
            Stat = "PlantsDefeated_Mythic",
            Target = 17,
            Reward = {
                Type = "Money",
                Amount = 150000
            }
        }, {
            Id = "Bounty",
            Label = "Bounties Completed",
            Stat = "BountiesCompleted",
            Target = 12,
            Reward = {
                Type = "Money",
                Amount = 180000
            }
        } },
    {
        Type = "Egg",
        ItemName = "Robot Capybara Egg",
        Amount = 1
    }
);
addLevel(
    7,
    { {
            Id = "Defeat",
            Label = "Plants Defeated",
            Stat = "PlantsDefeated",
            Target = 3000,
            Reward = {
                Type = "Money",
                Amount = 300000
            }
        }, {
            Id = "Mythic",
            Label = "Mythic Plants Defeated",
            Stat = "PlantsDefeated_Mythic",
            Target = 36,
            Reward = {
                Type = "Money",
                Amount = 350000
            }
        }, {
            Id = "Divine",
            Label = "Divine Plants Defeated",
            Stat = "PlantsDefeated_Divine",
            Target = 6,
            Reward = {
                Type = "Money",
                Amount = 400000
            }
        } },
    {
        Type = "Egg",
        ItemName = "Disco Capybara Egg",
        Amount = 1
    }
);
addLevel(
    8,
    { {
            Id = "Defeat",
            Label = "Plants Defeated",
            Stat = "PlantsDefeated",
            Target = 6000,
            Reward = {
                Type = "Money",
                Amount = 600000
            }
        }, {
            Id = "Mythic",
            Label = "Mythic Plants Defeated",
            Stat = "PlantsDefeated_Mythic",
            Target = 75,
            Reward = {
                Type = "Money",
                Amount = 700000
            }
        }, {
            Id = "Bounty",
            Label = "Bounties Completed",
            Stat = "BountiesCompleted",
            Target = 25,
            Reward = {
                Type = "Money",
                Amount = 800000
            }
        } },
    {
        Type = "Gear",
        ItemName = "Rainbow Scroll",
        Amount = 1
    }
);
addLevel(
    9,
    { {
            Id = "Defeat",
            Label = "Plants Defeated",
            Stat = "PlantsDefeated",
            Target = 12000,
            Reward = {
                Type = "Money",
                Amount = 1200000
            }
        }, {
            Id = "Mythic",
            Label = "Mythic Plants Defeated",
            Stat = "PlantsDefeated_Mythic",
            Target = 156,
            Reward = {
                Type = "Money",
                Amount = 1400000
            }
        }, {
            Id = "Divine",
            Label = "Divine Plants Defeated",
            Stat = "PlantsDefeated_Divine",
            Target = 29,
            Reward = {
                Type = "Money",
                Amount = 1600000
            }
        } },
    {
        Type = "Gear",
        ItemName = "Gilded Hatch Hammer",
        Amount = 10
    }
);
addLevel(
    10,
    { {
            Id = "Defeat",
            Label = "Plants Defeated",
            Stat = "PlantsDefeated",
            Target = 25000,
            Reward = {
                Type = "Money",
                Amount = 2500000
            }
        }, {
            Id = "Divine",
            Label = "Divine Plants Defeated",
            Stat = "PlantsDefeated_Divine",
            Target = 64,
            Reward = {
                Type = "Money",
                Amount = 3000000
            }
        }, {
            Id = "Bounty",
            Label = "Bounties Completed",
            Stat = "BountiesCompleted",
            Target = 50,
            Reward = {
                Type = "Money",
                Amount = 3500000
            }
        } },
    {
        Type = "Totem",
        ItemName = "Totem Of Stars",
        Amount = 2
    }
);
addLevel(
    11,
    { {
            Id = "Defeat",
            Label = "Plants Defeated",
            Stat = "PlantsDefeated",
            Target = 50000,
            Reward = {
                Type = "Money",
                Amount = 5000000
            }
        }, {
            Id = "Divine",
            Label = "Divine Plants Defeated",
            Stat = "PlantsDefeated_Divine",
            Target = 135,
            Reward = {
                Type = "Money",
                Amount = 6000000
            }
        }, {
            Id = "Bounty",
            Label = "Bounties Completed",
            Stat = "BountiesCompleted",
            Target = 100,
            Reward = {
                Type = "Money",
                Amount = 7000000
            }
        } },
    {
        Type = "Gear",
        ItemName = "Glitched Scroll",
        Amount = 2
    }
);
u1.DAILY_MONEY_LEVEL_BONUS = 0.25;
u1.DAILY_TARGET_SCALING = {
    MoneyEarned = 0.75,
    Default = 0.1
};

function u1.getScaledDailyReward(p5, p6) -- Line: 165
    -- upvalues: u1 (copy)
    local Reward = p5.Reward;

    if Reward.Type ~= "Money" then
        return Reward;
    end;

    local v7 = table.clone(Reward);
    local v8 = Reward.Amount * (1 + math.max(0, p6 or 0) * u1.DAILY_MONEY_LEVEL_BONUS);
    v7.Amount = math.floor(v8);

    return v7;
end;

function u1.getScaledDailyTarget(p9, p10) -- Line: 175
    -- upvalues: u1 (copy)
    if not u1.DAILY_TARGET_SCALING[p9.Stat] then
        local _ = u1.DAILY_TARGET_SCALING.Default;
    end;

    return p9.Target;
end;

function u1.getById(p11) -- Line: 181
    -- upvalues: u1 (copy)
    for _, v in u1.Daily do
        if v.Id == p11 then
            return v;
        end;
    end;

    return nil;
end;

function u1.getLifetimeById(p12) -- Line: 188
    -- upvalues: u1 (copy)
    for i, v in u1.Lifetime do
        for _, v2 in v.Quests do
            if v2.Id == p12 then
                return v2, i;
            end;
        end;
    end;

    return nil;
end;

function u1.getDailyBonus(p13, p14) -- Line: 198
    -- upvalues: u1 (copy)
    local v15 = Random.new(p13 * 1000003 + p14);

    return u1.DailyBonusRewards[v15:NextInteger(1, #u1.DailyBonusRewards)];
end;

local u16 = { "", "k", "M", "B", "T", "Q" };

function u1.abbreviate(p17) -- Line: 206
    -- upvalues: u16 (copy)
    local v18 = tonumber(p17) or 0;
    local v19 = math.abs(v18);
    local v20 = math.max(1, v19);
    local v21 = math.log(v20, 1000);
    local v22 = math.floor(v21);
    local v23 = u16[v22 + 1] or "e+" .. v22;
    local v24 = math.floor(v18 * (10 / 1000 ^ v22)) / 10;

    if v24 % 1 == 0 then
        return ("%d%s"):format(v24, v23);
    end;

    return ("%.1f%s"):format(v24, v23);
end;

function u1.describeReward(p25, p26) -- Line: 217
    -- upvalues: u1 (copy)
    if p26 and p26 == true then
        return p25.Description;
    end;

    if p25.Type == "Money" then
        return "$" .. u1.abbreviate(p25.Amount);
    end;

    local v27 = p25.Amount or 1;

    return (v27 > 1 and v27 .. "x " or "") .. tostring(p25.ItemName);
end;

function u1.getRewardImage(p28) -- Line: 232
    -- upvalues: Modules (copy)
    if p28.Type == "Money" or not p28.ItemName then
        return nil;
    end;

    for _, v in { Modules:FindFirstChild("TotemData"), Modules:FindFirstChild("GearData"), Modules:FindFirstChild("EggData") } do
        if v then
            local v = v:FindFirstChild(p28.ItemName);
        end;

        if v then
            local v29 = v:FindFirstChild("Image") or v:FindFirstChild("ImageID");

            if v29 then
                return v29.Value;
            end;
        end;
    end;

    return nil;
end;

return u1;