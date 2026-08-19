-- Decompiled with Potassium's decompiler.

local Modules = game:GetService("ReplicatedStorage").Modules;
local GameRules = require(Modules.GameRules);
local u1 = {
    Gold = 1,
    Rainbow = 2,
    Radiant = 3,
    Moonlit = 0.3,
    Chilly = 0.4,
    Toasty = 0.4,
    Tranquil = 0.45,
    Shocked = 0.6,
    Celestial = 0.7,
    Permafrost = 0.8,
    Scorched = 0.9,
    Glitched = 1,
    Flipped = 1,
    Taco = 1
};

function u1.getMultiplier(p2) -- Line: 23
    -- upvalues: u1 (copy)
    return u1[p2] or 0;
end;

function u1.calculateMoneyPerSecond(p3, p4, p5, p6) -- Line: 27
    -- upvalues: GameRules (copy), u1 (copy)
    if not (p3 and (p4 and (p5 and p6))) then
        return 1;
    end;

    local v7 = p3 * GameRules.sizeScalingMultiplier(p6);
    local v8 = {};
    table.insert(v8, p4);

    for i in string.gmatch(p5, "([^,]+)") do
        table.insert(v8, i:match("^%s*(.-)%s*$"));
    end;

    local v9 = 1;

    for _, v in ipairs(v8) do
        v9 = v9 + u1.getMultiplier(v);
    end;

    return math.round(v7 * v9);
end;

function u1.calculateDamage(p10, p11, p12, p13) -- Line: 53
    -- upvalues: GameRules (copy), u1 (copy)
    if not (p10 and (p11 and (p12 and p13))) then
        return 1;
    end;

    local v14 = p10 * GameRules.sizeScalingMultiplier(p13);
    local v15 = {};
    table.insert(v15, p11);

    for i in string.gmatch(p12, "([^,]+)") do
        table.insert(v15, i:match("^%s*(.-)%s*$"));
    end;

    local v16 = 1;

    for _, v in ipairs(v15) do
        v16 = v16 + u1.getMultiplier(v);
    end;

    return math.round(v14 * v16);
end;

function u1.calculateHealth(p17, p18, p19, p20) -- Line: 77
    -- upvalues: GameRules (copy), u1 (copy)
    if not (p17 and (p18 and (p19 and p20))) then
        return p17 or 1;
    end;

    local v21 = p17 * (1 + (GameRules.sizeScalingMultiplier(p20) - 1) * 0.55);
    local v22 = {};
    table.insert(v22, p18);

    for i in string.gmatch(p19, "([^,]+)") do
        table.insert(v22, i:match("^%s*(.-)%s*$"));
    end;

    local v23 = 1;

    for _, v in ipairs(v22) do
        v23 = v23 + u1.getMultiplier(v);
    end;

    local v24 = math.round(v21 * v23);
    local v25 = math.round(p17);

    return math.max(v24, v25);
end;

return u1;