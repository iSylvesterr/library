-- Decompiled with Potassium's decompiler.

local u3 = {
    SKIP_COOLDOWN_PRODUCT_ID = 3610595306,
    SUMMON_DELAY = 3,
    BOSS_SPEED_MULTIPLIER = 0.8,
    SlOWED_BOSS_SPEED_MULT = 0.75,
    BOSS_LANE = 4,
    ATTACKING_LANES = { 3, 4, 5 },
    Bosses = { {
            Name = "Scarlet Carrot",
            UnlockLevel = 0,
            Cooldown = 30,
            MoneyReward = 250,
            DropChance = 1
        }, {
            Name = "Red Potato",
            UnlockLevel = 1,
            Cooldown = 60,
            MoneyReward = 1000,
            DropChance = 1
        }, {
            Name = "Dark Tomato",
            UnlockLevel = 2,
            Cooldown = 210,
            MoneyReward = 25000,
            DropChance = 1
        }, {
            Name = "Skull Flower",
            UnlockLevel = 3,
            Cooldown = 300,
            MoneyReward = 100000,
            DropChance = 1
        }, {
            Name = "Holy Grailic",
            UnlockLevel = 4,
            Cooldown = 600,
            MoneyReward = 1000000,
            DropChance = 1
        }, {
            Name = "Carnivorous Jester",
            UnlockLevel = 6,
            Cooldown = 1800,
            MoneyReward = 10000000,
            DropChance = 1
        }, {
            Name = "Pumpkin Tyrant",
            UnlockLevel = 8,
            Cooldown = 3600,
            MoneyReward = 75000000,
            DropChance = 1
        }, {
            Name = "Golem King",
            UnlockLevel = 10,
            Cooldown = 7200,
            MoneyReward = 250000000,
            DropChance = 1
        }, {
            Name = "Conqueror Carrot",
            UnlockLevel = 11,
            Cooldown = 14400,
            MoneyReward = 1000000000,
            DropChance = 1
        } },
    BossList = { "Scarlet Carrot", "Red Potato", "Dark Tomato", "Skull Flower", "Holy Grailic", "Carnivorous Jester", "Pumpkin Tyrant", "Golem King", "Conqueror Carrot" },

    getImage = function(p1) -- Line: 102, Name: getImage
        local v2 = require(script.Parent.PlantData).getData(p1);

        if v2 then
            v2 = v2:FindFirstChild("Image");
        end;

        return v2 and v2.Value or "";
    end
};

function u3.getData(p4) -- Line: 108
    -- upvalues: u3 (copy)
    for i, v in ipairs(u3.Bosses) do
        if v.Name == p4 then
            return v, i;
        end;
    end;

    return nil;
end;

function u3.getPreviousBoss(p5) -- Line: 117
    -- upvalues: u3 (copy)
    local _, v6 = u3.getData(p5);

    if v6 and v6 ~= 1 then
        return u3.Bosses[v6 - 1];
    end;

    return nil;
end;

function u3.getRequiredBossForGrowth(p7) -- Line: 125
    -- upvalues: u3 (copy)
    local v8 = nil;

    for _, v in ipairs(u3.Bosses) do
        if v.UnlockLevel > p7 then
            break;
        end;

        v8 = v;
    end;

    return v8;
end;

function u3.meetsRequirements(p9, p10, p11) -- Line: 138
    -- upvalues: u3 (copy)
    local v12, _ = u3.getData(p9);

    if not v12 then
        return false;
    end;

    local v13 = v12.UnlockLevel <= p10;
    local v14 = u3.getPreviousBoss(p9);

    if v14 == nil then
        p11 = true;
    elseif p11 then
        p11 = p11[v14.Name] == true;
    end;

    return v13 and p11, v13, p11, v14;
end;

local u15 = { "", "k", "M", "B", "T" };

function u3.formatMoney(p16) -- Line: 150
    -- upvalues: u15 (copy)
    local v17 = 1;

    while p16 >= 1000 and v17 < #u15 do
        p16 = p16 / 1000;
        v17 = v17 + 1;
    end;

    local v18 = math.floor(p16 * 10 + 0.5) / 10;

    return "$" .. tostring(v18) .. u15[v17];
end;

function u3.formatCooldown(p19) -- Line: 160
    local v20 = math.floor(p19);
    local v21 = math.max(0, v20);
    local v22 = math.floor(v21 / 60);

    if v22 >= 60 then
        return math.floor(v22 / 60) .. "h " .. v22 % 60 .. "m";
    end;

    return v22 .. "m " .. v21 % 60 .. "s";
end;

return u3;