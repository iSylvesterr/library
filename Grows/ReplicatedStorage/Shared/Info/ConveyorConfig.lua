-- Decompiled with Potassium's decompiler.

local u1 = {
    SPAWN_INTERVAL = 4,
    GUARANTEED_INTERVAL = 300,
    TIER1_INITIAL_DELAY = 170,
    TIER1_RARITY = "LEGENDARY",
    TIER2_RARITY = "MYTHIC",
    OAK_GUARANTEE_INTERVAL = 5,
    PINE_GUARANTEE_INTERVAL = 4,
    PINE_GUARANTEE_MIN_COINS = 25,
    PINE_GUARANTEE_MAX_COINS = 200,
    APPLE_GUARANTEE_INTERVAL = 4,
    APPLE_GUARANTEE_MIN_COINS = 200,
    APPLE_GUARANTEE_MAX_COINS = 350,
    SEED_MUTATION_CHANCES = {
        Dewy = 0.1,
        Dusty = 0.075,
        Frosted = 0.075,
        Radioactive = 0.05,
        Golden = 0.025,
        Cosmic = 0.005
    }
};
local u2 = {
    SpawnInterval = "SPAWN_INTERVAL",
    GuaranteedInterval = "GUARANTEED_INTERVAL",
    Tier1InitialDelay = "TIER1_INITIAL_DELAY",
    OakGuaranteeInterval = "OAK_GUARANTEE_INTERVAL",
    PineGuaranteeInterval = "PINE_GUARANTEE_INTERVAL",
    PineGuaranteeMinCoins = "PINE_GUARANTEE_MIN_COINS",
    PineGuaranteeMaxCoins = "PINE_GUARANTEE_MAX_COINS",
    AppleGuaranteeInterval = "APPLE_GUARANTEE_INTERVAL",
    AppleGuaranteeMinCoins = "APPLE_GUARANTEE_MIN_COINS",
    AppleGuaranteeMaxCoins = "APPLE_GUARANTEE_MAX_COINS"
};
local u3 = {
    Tier1Rarity = "TIER1_RARITY",
    Tier2Rarity = "TIER2_RARITY"
};

function u1.ApplyOverrides(p4) -- Line: 51
    -- upvalues: u2 (copy), u3 (copy), u1 (copy)
    if type(p4) ~= "table" then
        return;
    end;

    local SeedConfig = require(script.Parent.SeedConfig);

    for i, v in p4 do
        local v5 = u2[i];
        local v6 = u3[i];
        local v7;

        if type(i) == "string" then
            v7 = i:match("^SeedMutationChance(%w+)$");
        else
            v7 = false;
        end;

        if v5 then
            local v8 = tonumber(v);

            if v8 and v8 > 0 then
                u1[v5] = v8;
            end;
        elseif v7 and u1.SEED_MUTATION_CHANCES[v7] then
            local v9 = tonumber(v);

            if v9 and v9 >= 0 then
                u1.SEED_MUTATION_CHANCES[v7] = v9;
            end;
        elseif v6 and type(v) == "string" then
            local v10 = v:upper();

            if SeedConfig.RARITY_WEIGHTS[v10] then
                u1[v6] = v10;
            end;
        end;
    end;
end;

return u1;