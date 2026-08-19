-- Decompiled with Potassium's decompiler.

local u1 = {
    poor = {
        displayName = "Poor",
        weight = 0,
        rarityMultiplier = 1
    },
    ok = {
        displayName = "OK",
        weight = 38,
        rarityMultiplier = 1
    },
    good = {
        displayName = "Good",
        weight = 28,
        rarityMultiplier = 1.3
    },
    great = {
        displayName = "Great",
        weight = 20,
        rarityMultiplier = 2.2
    },
    perfect = {
        displayName = "Perfect",
        weight = 10,
        rarityMultiplier = 4.4
    },
    mint = {
        displayName = "MINT",
        weight = 4,
        rarityMultiplier = 9.5
    }
};
local u2 = { "ok", "good", "great", "perfect", "mint" };

local function _(p3, p4) -- Line: 38
    -- upvalues: u1 (copy)
    return p3 + u1[p4].weight;
end;

local u5 = 0;
local v6 = { "poor", "ok", "good", "great", "perfect", "mint" };

for i = 1, #u2 do
    local _ = i - 1;
    u5 = u5 + u1[u2[i]].weight;
end;

return {
    rollCondition = function() -- Line: 46, Name: rollCondition
        -- upvalues: u5 (copy), u2 (copy), u1 (copy)
        local v7 = math.random() * u5;

        for _, v in u2 do
            v7 = v7 - u1[v].weight;

            if v7 <= 0 then
                return v;
            end;
        end;

        return "ok";
    end,

    Conditions = u1,
    CONDITION_ORDER = v6
};