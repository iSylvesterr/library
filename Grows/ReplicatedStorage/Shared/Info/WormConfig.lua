-- Decompiled with Potassium's decompiler.

local u1 = {
    Worms = {
        Worm = {
            id = "Worm",
            displayName = "Worm",
            mutation = nil,
            weight = 40,
            icon = "rbxassetid://71790372306940"
        },
        DewyWorm = {
            id = "DewyWorm",
            displayName = "Dewy Worm",
            mutation = "Dewy",
            weight = 20,
            icon = "rbxassetid://126600164985589"
        },
        ShockedWorm = {
            id = "ShockedWorm",
            displayName = "Shocked Worm",
            mutation = "Shocked",
            weight = 12,
            icon = "rbxassetid://106467437157699"
        },
        DustyWorm = {
            id = "DustyWorm",
            displayName = "Dusty Worm",
            mutation = "Dusty",
            weight = 8,
            icon = "rbxassetid://79048770144644"
        },
        FrostedWorm = {
            id = "FrostedWorm",
            displayName = "Frosted Worm",
            mutation = "Frosted",
            weight = 6,
            icon = "rbxassetid://107652365339721"
        },
        InfestedWorm = {
            id = "InfestedWorm",
            displayName = "Infested Worm",
            mutation = "Infested",
            weight = 4.5,
            icon = "rbxassetid://138162033994486"
        },
        RadioactiveWorm = {
            id = "RadioactiveWorm",
            displayName = "Radioactive Worm",
            mutation = "Radioactive",
            weight = 3,
            icon = "rbxassetid://111100419368089"
        },
        ChargedWorm = {
            id = "ChargedWorm",
            displayName = "Charged Worm",
            mutation = "Charged",
            weight = 2.5,
            icon = "rbxassetid://89477967197703"
        },
        SlimyWorm = {
            id = "SlimyWorm",
            displayName = "Slimy Worm",
            mutation = "Slimy",
            weight = 1.8,
            icon = "rbxassetid://115292328837641"
        },
        GoldenWorm = {
            id = "GoldenWorm",
            displayName = "Golden Worm",
            mutation = "Golden",
            weight = 1,
            icon = "rbxassetid://126872213283505"
        },
        ScaledWorm = {
            id = "ScaledWorm",
            displayName = "Scaled Worm",
            mutation = "Scaled",
            weight = 0.7,
            icon = "rbxassetid://89317292623119"
        },
        CosmicWorm = {
            id = "CosmicWorm",
            displayName = "Cosmic Worm",
            mutation = "Cosmic",
            weight = 0.5,
            icon = "rbxassetid://105224231783642"
        }
    },
    AdjustedWormTable = {}
};

for i, v in u1.Worms do
    u1.AdjustedWormTable[i] = {
        id = i,
        weight = v.weight * 10
    };
end;

u1.Order = { "Worm", "DewyWorm", "ShockedWorm", "DustyWorm", "FrostedWorm", "InfestedWorm", "RadioactiveWorm", "ChargedWorm", "SlimyWorm", "GoldenWorm", "ScaledWorm", "CosmicWorm" };
u1.LuckyChance = 0.25;
u1.LuckyMultBands = { {
        min = 5,
        max = 7,
        chance = 0.832
    }, {
        min = 7,
        max = 9,
        chance = 0.125
    }, {
        min = 9,
        max = 11,
        chance = 0.031
    }, {
        min = 11,
        max = 13,
        chance = 0.01
    }, {
        min = 13,
        max = 15,
        chance = 0.002
    } };
u1.MutatedBaseMult = 2.75;

function u1.Get(p2) -- Line: 47
    -- upvalues: u1 (copy)
    return u1.Worms[p2];
end;

function u1.GetMutation(p3) -- Line: 52
    -- upvalues: u1 (copy)
    local v4 = u1.Worms[p3];

    if v4 and v4.mutation then
        return require(game.ReplicatedStorage.Shared.Info.MutationConfig).Mutations[v4.mutation] and v4.mutation or nil;
    end;

    return nil;
end;

function u1.RollLuckyMult(p5) -- Line: 60
    -- upvalues: u1 (copy)
    local LuckyMultBands = u1.LuckyMultBands;
    local v6 = 0;

    for _, v in LuckyMultBands do
        v6 = v6 + v.chance;
    end;

    local v7 = (p5 and p5:NextNumber() or math.random()) * v6;
    local v8 = LuckyMultBands[#LuckyMultBands];

    for _, v in LuckyMultBands do
        v7 = v7 - v.chance;

        if v7 <= 0 then
            v8 = v;
            break;
        end;
    end;

    local v9 = (v8.max - v8.min) * 10 + (v8 == LuckyMultBands[#LuckyMultBands] and 1 or 0);
    local v10 = p5 and p5:NextInteger(0, v9 - 1) or math.random(0, v9 - 1);

    return v8.min + v10 / 10;
end;

function u1.RollWormType(p11) -- Line: 76
    -- upvalues: u1 (copy)
    local v12 = 0;

    for _, v in u1.Worms do
        v12 = v12 + v.weight;
    end;

    local v13 = (p11 and p11:NextNumber() or math.random()) * v12;

    for _, v in u1.Order do
        v13 = v13 - u1.Worms[v].weight;

        if v13 <= 0 then
            return v;
        end;
    end;

    return "Worm";
end;

function u1.RollLucky(p14, p15) -- Line: 88
    -- upvalues: u1 (copy)
    return (u1.GetMutation(p14) == nil and true or (p15 and p15:NextNumber() or math.random()) < u1.LuckyChance) and u1.RollLuckyMult(p15) or nil;
end;

function u1.Roll(p16) -- Line: 94
    -- upvalues: u1 (copy)
    local v17 = u1.RollWormType(p16);

    return v17, u1.RollLucky(v17, p16);
end;

u1.SuperLuckyMinMult = 10;

function u1.DisplayName(p18) -- Line: 102
    -- upvalues: u1 (copy)
    local v19;

    if p18 then
        v19 = u1.Worms[p18.wormType];
    else
        v19 = p18;
    end;

    if not v19 then
        return "Worm";
    end;

    local mult = p18.mult;

    return (mult and (u1.SuperLuckyMinMult <= mult and "Super Lucky " or "Lucky ") or "") .. v19.displayName;
end;

function u1.GetMult(p20) -- Line: 114
    -- upvalues: u1 (copy)
    return not p20 and 1 or (not p20.mult and (u1.GetMutation(p20.wormType) and u1.MutatedBaseMult or 1) or p20.mult);
end;

function u1.StrongerMutation(p21, p22) -- Line: 121
    if not p21 then
        return p22;
    end;

    if not p22 then
        return p21;
    end;

    local MutationConfig = require(game.ReplicatedStorage.Shared.Info.MutationConfig);

    if MutationConfig.GetMult(p22) > MutationConfig.GetMult(p21) then
        p21 = p22 or p21;
    end;

    return p21;
end;

return u1;