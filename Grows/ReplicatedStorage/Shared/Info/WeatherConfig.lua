-- Decompiled with Potassium's decompiler.

local u1 = {
    Order = { "Misty", "Sandstorm", "Blizzard", "AcidRain", "Rainbow", "MeteorShower" },
    TintTargets = { { "Grass", "LeftSide", "Expansion1" }, { "Grass", "LeftSide", "Expansion2" }, { "Grass", "LeftSide", "MainField" }, { "Grass", "RightSide", "Expansion1" }, { "Grass", "RightSide", "Expansion2" }, { "Grass", "RightSide", "MainField" }, { "TreeIsland", "Ground" } },
    Weathers = {
        Misty = {
            mutationKey = "Dewy",
            chance = 0.5,
            weight = 0.1875,
            displayName = "Misty",
            icon = "rbxassetid://123609523459495",
            notifText = "It\'s getting misty..."
        },
        Sandstorm = {
            mutationKey = "Dusty",
            chance = 0.35,
            weight = 0.1875,
            displayName = "Sandstorm",
            icon = "rbxassetid://110138168066454",
            notifText = "A sandstorm has begun!",
            tintColor = Color3.fromRGB(255, 172, 88)
        },
        Blizzard = {
            mutationKey = "Frosted",
            chance = 0.35,
            weight = 0.1875,
            displayName = "Blizzard",
            icon = "rbxassetid://102277271049735",
            notifText = "A blizzard has begun!",
            tintColor = Color3.fromRGB(212, 255, 254)
        },
        AcidRain = {
            mutationKey = "Radioactive",
            chance = 0.2,
            weight = 0.1875,
            displayName = "Acid Rain",
            icon = "rbxassetid://79431564062913",
            notifText = "It\'s raining acid!"
        },
        Rainbow = {
            mutationKey = "Golden",
            chance = 0.075,
            weight = 0.15,
            displayName = "Rainbow",
            icon = "rbxassetid://106921997424772",
            notifText = "A rainbow has appeared!"
        },
        MeteorShower = {
            mutationKey = "Cosmic",
            chance = 0.025,
            weight = 0.1,
            displayName = "Meteor Shower",
            icon = "rbxassetid://110166873733608",
            notifText = "A meteor shower has begun!"
        }
    },
    EVENT_DURATION = 270,
    MIN_GAP = 300,
    MAX_GAP = 600
};

function u1.Normalize(p2) -- Line: 43
    -- upvalues: u1 (copy)
    if type(p2) ~= "string" then
        return nil;
    end;

    local v3 = p2:gsub("[%s_]", ""):lower();

    if v3 == "" or v3 == "none" then
        return nil;
    end;

    for i in u1.Weathers do
        if i:lower() == v3 then
            return i;
        end;
    end;

    return nil;
end;

function u1.IsValid(p4) -- Line: 55
    -- upvalues: u1 (copy)
    return u1.Normalize(p4) ~= nil;
end;

function u1.Get(p5) -- Line: 59
    -- upvalues: u1 (copy)
    local v6 = u1.Normalize(p5);

    return v6 and u1.Weathers[v6] or nil;
end;

function u1.MutationKeyFor(p7) -- Line: 64
    -- upvalues: u1 (copy)
    local v8 = u1.Get(p7);

    return v8 and v8.mutationKey or nil;
end;

function u1.ChanceFor(p9) -- Line: 69
    -- upvalues: u1 (copy)
    local v10 = u1.Get(p9);

    return v10 and v10.chance or 0;
end;

function u1.PickNext(p11) -- Line: 75
    -- upvalues: u1 (copy)
    local v12 = 0;

    for _, v in u1.Order do
        if v ~= p11 then
            v12 = v12 + u1.Weathers[v].weight;
        end;
    end;

    local v13 = math.random() * v12;
    local v14 = 0;
    local v15 = nil;

    for _, v in u1.Order do
        if v ~= p11 then
            v14 = v14 + u1.Weathers[v].weight;

            if v13 <= v14 then
                return v;
            end;

            v15 = v;
        end;
    end;

    return v15;
end;

return u1;