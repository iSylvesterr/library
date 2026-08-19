-- Decompiled with Potassium's decompiler.

local u1 = {
    CELLS_PER_ROW = 4,
    REFRESH_INTERVAL = 43200,
    BOARD_VERSION = 4
};
local v2 = { "COMMON", "RARE" };
local v3 = { "RARE", "EPIC" };
local v4 = { "LEGENDARY", "MYTHIC", "CELESTIAL", "SECRET", "DIVINE", "TRANSCENDENT", "ANCIENT" };
u1.TOP_TIER_BONUS = 100;
u1.TOP_TIER_RARITIES = {
    TRANSCENDENT = true,
    ANCIENT = true
};
u1.Rows = {
    {
        kind = "regular",
        difficulty = "easy",
        reward = 25,
        tiers = v2
    },
    {
        kind = "regular",
        difficulty = "medium",
        reward = 50,
        tiers = { "EPIC", "LEGENDARY" }
    },
    {
        kind = "regular",
        difficulty = "hard",
        reward = 75,
        topTierBonusOverride = 75,
        tiers = { "MYTHIC", "CELESTIAL", "SECRET", "DIVINE", "TRANSCENDENT", "ANCIENT" }
    },
    {
        kind = "mutated",
        difficulty = "easy",
        reward = 35,
        tiers = v2,
        mutations = { "Dewy", "Shocked", "Radioactive" }
    },
    {
        kind = "mutated",
        difficulty = "medium",
        reward = 65,
        tiers = v3,
        mutations = { "Dewy", "Shocked", "Radioactive", "Golden" }
    },
    {
        kind = "mutated",
        difficulty = "hard",
        reward = 100,
        tiers = v4,
        mutations = { "Dewy", "Shocked", "Radioactive", "Golden", "Cosmic", "Charged", "Infested", "Slimy", "Scaled" }
    },
    {
        kind = "huge",
        difficulty = "easy",
        sizeMin = 12,
        sizeMax = 18,
        reward = 35,
        tiers = v2
    },
    {
        kind = "huge",
        difficulty = "medium",
        sizeMin = 22,
        sizeMax = 28,
        reward = 65,
        tiers = v3
    },
    {
        kind = "huge",
        difficulty = "hard",
        sizeMin = 35,
        sizeMax = 50,
        reward = 100,
        tiers = v4
    }
};

function u1.ApplyOverrides(p5) -- Line: 39
    -- upvalues: u1 (copy)
    if type(p5) ~= "table" then
        return;
    end;

    for i, v in p5 do
        local v6 = tonumber(v);

        if v6 and v6 > 0 then
            local v7, v8 = i:match("^Row(%d+)(%a+)$");

            if v7 then
                v7 = u1.Rows[tonumber(v7)];
            end;

            if i == "RefreshInterval" then
                u1.REFRESH_INTERVAL = v6;
            elseif v7 then
                if v8 == "Reward" then
                    v7.reward = v6;
                elseif v8 == "SizeMin" and v7.sizeMin then
                    v7.sizeMin = v6;
                elseif v8 == "SizeMax" and v7.sizeMax then
                    v7.sizeMax = v6;
                end;
            end;
        end;
    end;
end;

return u1;