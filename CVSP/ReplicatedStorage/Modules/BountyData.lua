-- Decompiled with Potassium's decompiler.

local u1 = {};
local u2 = {
    ROTATION_SECONDS = 900,
    EASY_TOKENS = 3,
    HARD_TOKENS = 5,
    SKIP_BOTH_PRODUCT_ID = 3610427176,
    EASY_MUTATIONS = { "Moonlit", "Chilly", "Toasty" },
    HARD_MUTATIONS = { "Tranquil", "Shocked" }
};

for _, child in game:GetService("ReplicatedStorage").Modules:WaitForChild("PlantData"):GetChildren() do
    local Rarity = child:FindFirstChild("Rarity");

    if Rarity then
        local Value = Rarity.Value;
        u1[Value] = u1[Value] or {};
        table.insert(u1[Value], child.Name);
    end;
end;

for _, v in u1 do
    table.sort(v);
end;

local function pickFrom(p3, p4) -- Line: 59
    return p3[p4:NextInteger(1, #p3)];
end;

local u14 = { function(p5) -- Line: 70
        -- upvalues: u1 (copy), u2 (copy)
        local v6 = {};
        local Common = u1.Common;
        v6.PlantName = Common[p5:NextInteger(1, #Common)];
        v6.MinSize = p5:NextInteger(1, 1.8);
        local v7 = {};
        local EASY_MUTATIONS = u2.EASY_MUTATIONS;
        v7[1] = EASY_MUTATIONS[p5:NextInteger(1, #EASY_MUTATIONS)];
        v6.Mutations = v7;

        return v6;
    end, function(p8) -- Line: 78
        -- upvalues: u1 (copy), u2 (copy)
        local v9 = {};
        local Rare = u1.Rare;
        v9.PlantName = Rare[p8:NextInteger(1, #Rare)];
        v9.MinSize = p8:NextInteger(1, 1.5);
        local v10 = {};
        local EASY_MUTATIONS = u2.EASY_MUTATIONS;
        v10[1] = EASY_MUTATIONS[p8:NextInteger(1, #EASY_MUTATIONS)];
        v9.Mutations = v10;

        return v9;
    end, function(p11) -- Line: 86
        -- upvalues: u2 (copy)
        local v12 = {
            Rarity = "Legendary",
            MinSize = 1
        };
        local v13 = {};
        local EASY_MUTATIONS = u2.EASY_MUTATIONS;
        v13[1] = EASY_MUTATIONS[p11:NextInteger(1, #EASY_MUTATIONS)];
        v12.Mutations = v13;

        return v12;
    end };
local u21 = { function(p15) -- Line: 97
        -- upvalues: u1 (copy), u2 (copy)
        local v16 = {};
        local Mythic = u1.Mythic;
        v16.PlantName = Mythic[p15:NextInteger(1, #Mythic)];
        v16.MinSize = p15:NextInteger(1, 1.8);
        local v17 = {};
        local HARD_MUTATIONS = u2.HARD_MUTATIONS;
        v17[1] = HARD_MUTATIONS[p15:NextInteger(1, #HARD_MUTATIONS)];
        v16.Mutations = v17;

        return v16;
    end, function(p18) -- Line: 105
        -- upvalues: u2 (copy)
        local v19 = {
            Rarity = "Divine",
            MinSize = 1
        };
        local v20 = {};
        local HARD_MUTATIONS = u2.HARD_MUTATIONS;
        v20[1] = HARD_MUTATIONS[p18:NextInteger(1, #HARD_MUTATIONS)];
        v19.Mutations = v20;

        return v19;
    end };

local function now() -- Line: 122
    return workspace:GetServerTimeNow();
end;

function u2.getWindowNumber() -- Line: 126
    -- upvalues: u2 (copy)
    local v22 = workspace:GetServerTimeNow() / u2.ROTATION_SECONDS;

    return math.floor(v22);
end;

function u2.getSecondsRemaining() -- Line: 130
    -- upvalues: u2 (copy)
    local v23 = u2.ROTATION_SECONDS - workspace:GetServerTimeNow() % u2.ROTATION_SECONDS;

    return math.ceil(v23);
end;

function u2.generate(p24) -- Line: 135
    -- upvalues: u2 (copy), u14 (copy), u21 (copy)
    local v25 = p24 or u2.getWindowNumber();
    local v26 = Random.new(v25);
    local v27 = u14[v26:NextInteger(1, #u14)](v26);
    v27.Tokens = u2.EASY_TOKENS;
    v27.Kind = "Easy";
    local v28 = Random.new(v25 + 999983);
    local v29 = u21[v28:NextInteger(1, #u21)](v28);
    v29.Tokens = u2.HARD_TOKENS;
    v29.Kind = "Hard";

    return v27, v29;
end;

function u2.describe(p30) -- Line: 155
    local v31 = {};

    if p30.MinSize and p30.MinSize > 1 then
        table.insert(v31, p30.MinSize .. "x+");
    end;

    local v32 = p30.PlantName or tostring(p30.Rarity) .. " plant";
    table.insert(v31, v32);
    local v33 = "Deliver a " .. table.concat(v31, " ");

    if p30.Mutations and #p30.Mutations > 0 then
        v33 = v33 .. " with " .. table.concat(p30.Mutations, " + ");
    end;

    return v33;
end;

function u2.matches(p34, p35, p36, p37, p38) -- Line: 169
    if p34.PlantName and p35 ~= p34.PlantName then
        return false, "wrong plant";
    end;

    if p34.Rarity and p36 ~= p34.Rarity then
        return false, "wrong rarity";
    end;

    if (p37 or 1) < (p34.MinSize or 1) then
        return false, "too small";
    end;

    for _, v in p34.Mutations or {} do
        if not table.find(p38, v) then
            return false, "missing mutation " .. v;
        end;
    end;

    return true;
end;

u2.EASY_BONUS_REWARDS = { {
        Weight = 49.75,
        Type = "Money",
        Amount = { 2500, 10000 }
    }, {
        Weight = 30,
        Type = "Gear",
        ItemName = "Hatch Hammer",
        Amount = 5
    }, {
        Weight = 20,
        Type = "Gear",
        ItemName = "Bizarre Stopwatch",
        Amount = 1
    }, {
        Weight = 15,
        Type = "Gear",
        ItemName = "Raygun",
        Amount = 1
    }, {
        Weight = 5,
        Type = "Totem",
        ItemName = "Totem Of Marrow",
        Amount = 1
    }, {
        Weight = 0.25,
        Type = "Egg",
        ItemName = "Bounty Hunter Capybara Egg",
        Amount = 1
    } };
u2.HARD_BONUS_REWARDS = { {
        Weight = 40,
        Type = "Money",
        Amount = { 100000, 750000 }
    }, {
        Weight = 20,
        Type = "Gear",
        ItemName = "Raygun",
        Amount = 2
    }, {
        Weight = 15,
        Type = "Gear",
        ItemName = "Gilded Hatch Hammer",
        Amount = 1
    }, {
        Weight = 10,
        Type = "Totem",
        ItemName = "Totem Of Fortune",
        Amount = 1
    }, {
        Weight = 9,
        Type = "Totem",
        ItemName = "Totem Of Wealth",
        Amount = 1
    }, {
        Weight = 3,
        Type = "Gear",
        ItemName = "Gold Scroll",
        Amount = 1
    }, {
        Weight = 1,
        Type = "Egg",
        ItemName = "Bounty Hunter Capybara Egg",
        Amount = 1
    } };
local u39 = Random.new();

function u2.rollBonusReward(p40) -- Line: 219
    -- upvalues: u2 (copy), u39 (copy)
    local v41 = p40 == "Hard" and u2.HARD_BONUS_REWARDS or u2.EASY_BONUS_REWARDS;
    local v42 = 0;

    for _, v in v41 do
        v42 = v42 + (v.Weight or 1);
    end;

    local v43 = u39:NextNumber() * v42;
    local v44 = v41[#v41];

    for _, v in v41 do
        v43 = v43 - (v.Weight or 1);

        if v43 <= 0 then
            v44 = v;
            break;
        end;
    end;

    local v45 = table.clone(v44);

    if typeof(v45.Amount) == "table" then
        v45.Amount = u39:NextInteger(v45.Amount[1], v45.Amount[2]);
    end;

    return v45;
end;

function u2.describeReward(p46) -- Line: 246
    if p46.Type == "Money" then
        return "$" .. tostring(p46.Amount);
    end;

    local v47 = p46.Amount or 1;

    return (v47 > 1 and v47 .. "x " or "") .. tostring(p46.ItemName);
end;

return u2;