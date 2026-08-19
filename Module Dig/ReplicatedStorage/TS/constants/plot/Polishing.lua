-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local CONDITION_ORDER = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "items", "Conditions").CONDITION_ORDER;
local Items = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "items", "Items").Items;
local TEST_CHEAP_POLISHING = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "plot", "PlotSections").TEST_CHEAP_POLISHING;
local u1 = {
    poor = 120,
    ok = 420,
    good = 1200,
    great = 3600,
    perfect = 10800,
    mint = 0
};
local u2 = {
    common = 1,
    uncommon = 1.25,
    rare = 1.55,
    epic = 1.9,
    legendary = 2.3,
    mythic = 2.75,
    divine = 3.25,
    eternal = 3.75,
    transcendent = 4
};
local u3 = { {
        speed = 1,
        upgradeCost = 3000000
    }, {
        speed = 1.25,
        upgradeCost = 6000000
    }, {
        speed = 1.55,
        upgradeCost = 12000000
    }, {
        speed = 1.9,
        upgradeCost = 20000000
    }, {
        speed = 2.3,
        upgradeCost = 35000000
    }, {
        speed = 2.8,
        upgradeCost = 60000000
    }, {
        speed = 3.35,
        upgradeCost = 100000000
    }, {
        speed = 4,
        upgradeCost = 0
    } };
local u4 = #u3;
local u5 = { 20000000 };
local u6 = #u5 + 1;

return {
    POLISHER_SLOT_ATTRIBUTE = "Slot",
    POLISHER_LEVEL_ATTRIBUTE = "Level",
    POLISHER_UNLOCKED_ATTRIBUTE = "Unlocked",
    POLISH_ITEM_UID_ATTRIBUTE = "ItemUid",
    POLISH_ITEM_ID_ATTRIBUTE = "ItemId",
    POLISH_KG_ATTRIBUTE = "Kg",
    POLISH_FROM_ATTRIBUTE = "FromCondition",
    POLISH_TO_ATTRIBUTE = "ToCondition",
    POLISH_STARTED_ATTRIBUTE = "StartedAt",
    POLISH_ENDS_ATTRIBUTE = "EndsAt",
    POLISH_MAX_SECONDS = 43200,
    POLISHER_MIN_LEVEL = 1,

    polisherModelName = function(p7) -- Line: 84, Name: polisherModelName
        return p7 <= 1 and "Polisher" or `Polisher{p7}`;
    end,

    polisherSignName = function(p8) -- Line: 87, Name: polisherSignName
        return `BuyPolisher{p8}`;
    end,

    polisherSlotFromModelName = function(p9) -- Line: 90, Name: polisherSlotFromModelName
        -- upvalues: u6 (copy)
        if p9 == "Polisher" then
            return 1;
        end;

        local v10 = string.match(p9, "^Polisher(%d+)$");
        local v11;

        if type(v10) == "string" then
            v11 = tonumber(v10);
        else
            v11 = nil;
        end;

        if v11 == nil or (v11 < 1 or v11 > u6) then
            return nil;
        end;

        return v11;
    end,

    polisherUnlockCostFor = function(p12) -- Line: 98, Name: polisherUnlockCostFor
        -- upvalues: u6 (copy), TEST_CHEAP_POLISHING (copy), u5 (copy)
        if p12 < 2 or u6 < p12 then
            return nil;
        end;

        return TEST_CHEAP_POLISHING and 1 or u5[p12 - 1];
    end,

    ownedPolisherCount = function(p13) -- Line: 104, Name: ownedPolisherCount
        -- upvalues: u6 (copy)
        return math.clamp(p13, 1, u6);
    end,

    polisherLevelFor = function(p14, p15) -- Line: 107, Name: polisherLevelFor
        -- upvalues: u4 (copy)
        local v16 = p14[tostring(p15)];

        return type(v16) ~= "number" and 1 or math.clamp(v16, 1, u4);
    end,

    polisherSpeedFor = function(p17) -- Line: 111, Name: polisherSpeedFor
        -- upvalues: u3 (copy), u4 (copy)
        return u3[math.clamp(p17, 1, u4)].speed;
    end,

    polisherUpgradeCostFor = function(p18) -- Line: 114, Name: polisherUpgradeCostFor
        -- upvalues: u4 (copy), TEST_CHEAP_POLISHING (copy), u3 (copy)
        if u4 <= p18 then
            return nil;
        end;

        return TEST_CHEAP_POLISHING and 1 or u3[math.clamp(p18, 1, u4)].upgradeCost;
    end,

    nextConditionFor = function(p19) -- Line: 123, Name: nextConditionFor
        -- upvalues: CONDITION_ORDER (copy)
        local v20 = (table.find(CONDITION_ORDER, p19) or 0) - 1;

        if v20 == -1 then
            return nil;
        end;

        return CONDITION_ORDER[v20 + 2];
    end,

    polishSecondsFor = function(p21, p22, p23) -- Line: 128, Name: polishSecondsFor
        -- upvalues: u1 (copy), u2 (copy), Items (copy), u3 (copy), u4 (copy)
        local v24 = math.min(u1[p22] * u2[Items[p21].rarity], 43200) / u3[math.clamp(p23, 1, u4)].speed;

        return math.round(v24);
    end,

    POLISHER_LEVELS = u3,
    POLISHER_MAX_LEVEL = u4,
    POLISHER_UNLOCK_COSTS = u5,
    POLISHER_SLOT_COUNT = u6
};