-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local MutationConfig = require(script.Parent.MutationConfig);
local u1 = {
    HARVEST_COUNT = 5,
    FRUIT_SPAWN_COUNT = 4,
    Seeds = {
        Oak = {
            displayName = "Oak Tree",
            baseWoodValue = 1,
            sellPrice = 5,
            fruitName = "Acorn",
            baseFruitValue = 1,
            generationTime = 10,
            rarity = "COMMON",
            plantCost = 0,
            requiredFarmLevel = 1
        },
        Pine = {
            displayName = "Pine Tree",
            baseWoodValue = 1,
            sellPrice = 25,
            fruitName = "Pinecone",
            baseFruitValue = 2,
            generationTime = 12,
            rarity = "COMMON",
            plantCost = 25,
            requiredFarmLevel = 1
        },
        Apple = {
            displayName = "Apple Tree",
            baseWoodValue = 1,
            sellPrice = 200,
            fruitName = "Apple",
            baseFruitValue = 5,
            generationTime = 30,
            rarity = "RARE",
            plantCost = 200,
            requiredFarmLevel = 2
        },
        Peach = {
            displayName = "Peach Tree",
            baseWoodValue = 1,
            sellPrice = 350,
            fruitName = "Peach",
            baseFruitValue = 8,
            generationTime = 40,
            rarity = "RARE",
            plantCost = 350,
            requiredFarmLevel = 2
        },
        Fig = {
            displayName = "Fig Tree",
            baseWoodValue = 1,
            sellPrice = 500,
            fruitName = "Fig",
            baseFruitValue = 15,
            generationTime = 50,
            rarity = "RARE",
            plantCost = 500,
            requiredFarmLevel = 2
        },
        Orange = {
            displayName = "Orange Tree",
            baseWoodValue = 1,
            sellPrice = 15000,
            fruitName = "Orange",
            baseFruitValue = 30,
            generationTime = 60,
            rarity = "EPIC",
            plantCost = 15000,
            requiredFarmLevel = 3
        },
        Lemon = {
            displayName = "Lemon Tree",
            baseWoodValue = 1,
            sellPrice = 35000,
            fruitName = "Lemon",
            baseFruitValue = 50,
            generationTime = 75,
            rarity = "EPIC",
            plantCost = 35000,
            requiredFarmLevel = 3
        },
        Avocado = {
            displayName = "Avocado Tree",
            baseWoodValue = 1,
            sellPrice = 50000,
            fruitName = "Avocado",
            baseFruitValue = 75,
            generationTime = 90,
            rarity = "EPIC",
            plantCost = 50000,
            requiredFarmLevel = 3
        },
        Cherry = {
            displayName = "Cherry Tree",
            baseWoodValue = 1,
            sellPrice = 5000000,
            fruitName = "Cherry",
            baseFruitValue = 120,
            generationTime = 110,
            rarity = "LEGENDARY",
            plantCost = 5000000,
            requiredFarmLevel = 4
        },
        Mango = {
            displayName = "Mango Tree",
            baseWoodValue = 1,
            sellPrice = 12500000,
            fruitName = "Mango",
            baseFruitValue = 200,
            generationTime = 130,
            rarity = "LEGENDARY",
            plantCost = 12500000,
            requiredFarmLevel = 4
        },
        Coconut = {
            displayName = "Coconut Tree",
            baseWoodValue = 1,
            sellPrice = 20000000,
            fruitName = "Coconut",
            baseFruitValue = 280,
            generationTime = 150,
            rarity = "LEGENDARY",
            plantCost = 20000000,
            requiredFarmLevel = 4
        },
        Banana = {
            displayName = "Banana Tree",
            baseWoodValue = 1,
            sellPrice = 3000000000,
            fruitName = "Banana",
            baseFruitValue = 500,
            generationTime = 180,
            rarity = "MYTHIC",
            plantCost = 3000000000,
            requiredFarmLevel = 5
        },
        Starfruit = {
            displayName = "Starfruit Tree",
            baseWoodValue = 1,
            sellPrice = 4500000000,
            fruitName = "Starfruit",
            baseFruitValue = 700,
            generationTime = 210,
            rarity = "MYTHIC",
            plantCost = 4500000000,
            requiredFarmLevel = 5
        },
        DragonFruit = {
            displayName = "Dragon Fruit Cactus",
            baseWoodValue = 1,
            sellPrice = 7000000000,
            fruitName = "Dragon Fruit",
            baseFruitValue = 1000,
            generationTime = 240,
            rarity = "MYTHIC",
            plantCost = 7000000000,
            requiredFarmLevel = 5
        },
        Glowing = {
            displayName = "Glowing Tree",
            baseWoodValue = 1,
            sellPrice = 500000000000,
            fruitName = "Glowing Fruit",
            baseFruitValue = 2000,
            generationTime = 300,
            rarity = "CELESTIAL",
            plantCost = 500000000000,
            requiredFarmLevel = 6
        },
        Blooming = {
            displayName = "Blooming Tree",
            baseWoodValue = 1,
            sellPrice = 750000000000,
            fruitName = "Blooming Fruit",
            baseFruitValue = 2800,
            generationTime = 330,
            rarity = "CELESTIAL",
            plantCost = 750000000000,
            requiredFarmLevel = 6
        },
        Magic = {
            displayName = "Magic Tree",
            baseWoodValue = 1,
            sellPrice = 500000000000000,
            fruitName = "Magic Fruit",
            baseFruitValue = 5000,
            generationTime = 360,
            rarity = "SECRET",
            plantCost = 500000000000000,
            requiredFarmLevel = 6
        },
        Pizza = {
            displayName = "Pizza Tree",
            baseWoodValue = 1,
            sellPrice = 850000000000000,
            fruitName = "Pizza",
            baseFruitValue = 8000,
            generationTime = 400,
            rarity = "SECRET",
            plantCost = 850000000000000,
            requiredFarmLevel = 6
        },
        Diamond = {
            displayName = "Diamond Tree",
            baseWoodValue = 1,
            sellPrice = 1e18,
            fruitName = "Diamond Fruit",
            baseFruitValue = 15000,
            generationTime = 450,
            rarity = "DIVINE",
            plantCost = 1e18,
            requiredFarmLevel = 6
        },
        Void = {
            displayName = "Void Tree",
            baseWoodValue = 1,
            sellPrice = 1.75e18,
            fruitName = "Void Fruit",
            baseFruitValue = 25000,
            generationTime = 520,
            rarity = "DIVINE",
            plantCost = 1.75e18,
            requiredFarmLevel = 6
        },
        Mushroom = {
            displayName = "Mushroom Tree",
            baseWoodValue = 1,
            sellPrice = 7e21,
            fruitName = "Mushroom",
            baseFruitValue = 40000,
            generationTime = 580,
            rarity = "TRANSCENDENT",
            plantCost = 7e21,
            requiredFarmLevel = 6
        },
        Money = {
            displayName = "Money Tree",
            baseWoodValue = 1,
            sellPrice = 1.4e22,
            fruitName = "Money Fruit",
            baseFruitValue = 60000,
            generationTime = 640,
            rarity = "TRANSCENDENT",
            plantCost = 1.4e22,
            requiredFarmLevel = 6
        },
        Glowshroom = {
            displayName = "Glowshroom Tree",
            baseWoodValue = 1,
            sellPrice = 3.5e27,
            fruitName = "Glowshroom",
            baseFruitValue = 90000,
            generationTime = 700,
            rarity = "ANCIENT",
            plantCost = 3.5e27,
            requiredFarmLevel = 6
        },
        Elder = {
            displayName = "Elder Tree",
            baseWoodValue = 1,
            sellPrice = 5e27,
            fruitName = "Elder Fruit",
            baseFruitValue = 130000,
            generationTime = 780,
            rarity = "ANCIENT",
            plantCost = 5e27,
            requiredFarmLevel = 6
        }
    },
    FARM_LEVELS = {
        [2] = {
            wood = 10,
            money = 100,
            shredSeed = "Oak",
            shredSize = 5,
            shredCount = 1,
            unlocksSeed = "Apple"
        },
        [3] = {
            wood = 50,
            money = 500,
            shredSeed = "Apple",
            shredSize = 5,
            shredCount = 3,
            unlocksSeed = "Orange"
        },
        [4] = {
            wood = 250,
            money = 2500,
            shredSeed = "Orange",
            shredSize = 10,
            shredCount = 3,
            unlocksSeed = "Cherry"
        },
        [5] = {
            wood = 1000,
            money = 10000,
            shredSeed = "Cherry",
            shredSize = 25,
            shredCount = 5,
            unlocksSeed = "Banana"
        },
        [6] = {
            wood = 5000,
            money = 50000,
            shredSeed = "Banana",
            shredSize = 50,
            shredCount = 5,
            unlocksSeed = "Magic"
        }
    },
    MAX_FARM_LEVEL = 6,
    STAGE_CONFIG = { {
            name = "Stage1",
            minMult = 1,
            maxMult = 1.5,
            naturalHeight = 1
        }, {
            name = "Stage2",
            minMult = 1.5,
            maxMult = 3,
            naturalHeight = 6
        }, {
            name = "Stage3",
            minMult = 3,
            maxMult = 7.5,
            naturalHeight = 19.39
        }, {
            name = "Stage4",
            minMult = 7.5,
            maxMult = (1 / 0),
            naturalHeight = 36.18
        } },
    BASE_HEIGHT = 2,
    MAX_PLACED_VISUAL_MULT = 250,
    RARITY_WEIGHTS = {
        COMMON = 42.95,
        RARE = 32.5,
        EPIC = 20,
        LEGENDARY = 2.5,
        MYTHIC = 1,
        CELESTIAL = 0.4,
        SECRET = 0.25,
        DIVINE = 0.175,
        TRANSCENDENT = 0.125,
        ANCIENT = 0.1
    }
};

function u1.GetSeed(p2) -- Line: 359
    -- upvalues: u1 (copy)
    return u1.Seeds[p2];
end;

function u1.GetSeedsByRarity(p3) -- Line: 363
    -- upvalues: u1 (copy)
    local v4 = {};

    for i, v in u1.Seeds do
        if v.rarity == p3 then
            table.insert(v4, i);
        end;
    end;

    return v4;
end;

function u1.CalcWoodValue(p5, p6) -- Line: 373
    -- upvalues: u1 (copy)
    local v7 = u1.Seeds[p5];

    return not v7 and 0 or math.floor(v7.sellPrice * p6);
end;

function u1.CalcFruitValue(p8, p9) -- Line: 379
    -- upvalues: u1 (copy)
    local v10 = u1.Seeds[p8];

    return not v10 and 0 or math.floor(v10.baseFruitValue * p9);
end;

function u1.GetStageIndex(p11) -- Line: 385
    -- upvalues: u1 (copy)
    for i, v in ipairs(u1.STAGE_CONFIG) do
        if p11 < v.maxMult then
            return i;
        end;
    end;

    return #u1.STAGE_CONFIG;
end;

u1.FRUIT_GROWTH_BASE_SECONDS = 150;
u1.FRUIT_GROWTH_SECONDS_PER_SIZE = 5;

function u1.GetFruitGrowthTime(p12, p13) -- Line: 400
    -- upvalues: u1 (copy)
    local v14 = math.max(0, p12 - u1.STAGE_CONFIG[#u1.STAGE_CONFIG].minMult);

    return (u1.FRUIT_GROWTH_BASE_SECONDS + v14 * u1.FRUIT_GROWTH_SECONDS_PER_SIZE) * (p13 or 1);
end;

function u1.PlotGrowthMult(p15) -- Line: 408
    if not p15 then
        return 1;
    end;

    local v16 = p15:GetAttribute("FruitGrowthMult");

    return (typeof(v16) ~= "number" or (v16 <= 0 or not v16)) and 1 or v16;
end;

u1.FRUIT_SIZE_BONUS_ROLLS = { {
        chance = 0.03,
        mult = 3
    }, {
        chance = 0.02,
        mult = 4
    } };
u1.FRUIT_SIZE_RANGE_MIN = 0.7;
u1.FRUIT_SIZE_RANGE_MAX = 1.4;

function u1.RollFruitSizeMult() -- Line: 422
    -- upvalues: u1 (copy)
    local v17 = math.random();
    local v18 = 0;

    for _, v in u1.FRUIT_SIZE_BONUS_ROLLS do
        v18 = v18 + v.chance;

        if v17 < v18 then
            return v.mult;
        end;
    end;

    local v19 = (u1.FRUIT_SIZE_RANGE_MIN + math.random() * (u1.FRUIT_SIZE_RANGE_MAX - u1.FRUIT_SIZE_RANGE_MIN)) * 100;

    return math.floor(v19) / 100;
end;

function u1.FruitSize(p20, p21) -- Line: 435
    return math.floor(p20 * (p21 or 1) * 100) / 100;
end;

function u1.CalcDeadWoodValue(p22, p23, p24) -- Line: 440
    -- upvalues: MutationConfig (copy), u1 (copy)
    local v25 = MutationConfig.ProductMult(p24);
    local v26 = u1.CalcWoodValue(p22, p23) * v25 * 0.4;
    local v27 = math.floor(v26);

    return math.max(1, v27);
end;

function u1.CalcPlotFruitValue(p28, p29) -- Line: 446
    -- upvalues: u1 (copy)
    local v30 = u1.Seeds[p28];

    if v30 then
        local v31 = math.floor(v30.sellPrice * p29 / 10);

        return math.max(1, v31);
    end;

    local v32 = math.floor(p29);

    return math.max(1, v32);
end;

function u1.CalcTotalTreeValue(p33, p34, p35) -- Line: 453
    -- upvalues: u1 (copy), MutationConfig (copy)
    local v36 = u1.CalcWoodValue(p33, p34);

    if u1.GetStageIndex(p34) == 4 then
        v36 = v36 + u1.CalcPlotFruitValue(p33, p34) * u1.FRUIT_SPAWN_COUNT;
    end;

    local v37 = v36 * MutationConfig.ProductMult(p35);
    local v38 = math.floor(v37);

    return math.max(1, v38);
end;

function u1.CalcFruitIncomePerMinute(p39, p40, p41) -- Line: 463
    -- upvalues: u1 (copy), MutationConfig (copy)
    local v42 = u1.GetFruitGrowthTime(p40) / 60;

    if v42 <= 0 then
        return 0;
    end;

    local v43 = u1.CalcPlotFruitValue(p39, p40) * MutationConfig.ProductMult(p41);
    local v44 = math.floor(v43) * u1.FRUIT_SPAWN_COUNT / v42;

    return math.floor(v44);
end;

u1.FRUIT_MODEL_NAMES = {
    Oak = "Acorn",
    Pine = "Pinecone",
    Apple = "Apple",
    Peach = "Peach",
    Fig = "Fig",
    Orange = "Orange",
    Lemon = "Lemon",
    Avocado = "Avocado",
    Cherry = "Cherry",
    Mango = "Mango",
    Coconut = "Coconut",
    Banana = "Banana",
    Starfruit = "Starfruit",
    DragonFruit = "DragonFruit",
    Glowing = "GlowingFruit",
    Blooming = "Blooming",
    Magic = "MagicFruit",
    Pizza = "Pizza",
    Diamond = "Diamond",
    Void = "Void",
    Mushroom = "Mushroom",
    Money = "MoneyFruit",
    Glowshroom = "Glowshroom",
    Elder = "ElderFruit"
};
u1.SEED_MODEL_NAMES = {
    Oak = "OakSeed",
    Pine = "PineSeed",
    Apple = "AppleSeed",
    Peach = "PeachSeed",
    Fig = "FigSeed",
    Orange = "OrangeSeed",
    Lemon = "LemonSeed",
    Avocado = "AvacadoSeed",
    Cherry = "CherrySeed",
    Mango = "MangoSeed",
    Coconut = "CoconutSeed",
    Banana = "BananaSeed",
    Starfruit = "StarfruitSeed",
    DragonFruit = "DragonfruitSeed",
    Magic = "MagicSeed",
    Divine = "DivineSeed",
    Mushroom = "MushroomSeed",
    Money = "MoneySeed",
    Glowshroom = "GlowshroomSeed",
    Elder = "ElderSeed"
};
u1.FRUIT_HANG_FLIP = {
    Blooming = true,
    Magic = true,
    Money = true,
    Pizza = true
};
u1.FRUIT_UP_BLEND = 2.5;
u1.FRUIT_GROW_FROM_BOTTOM = {
    Mushroom = true,
    Glowshroom = true
};
u1.FRUIT_HANG_BY_BOUNDS = {
    Elder = true
};
u1.HIDE_HELD_FRUIT = {
    Mushroom = true,
    Glowshroom = true
};

function u1.FruitUprightCFrame(p45, p46, p47, p48) -- Line: 551
    -- upvalues: u1 (copy)
    local Unit = (p46.UpVector + Vector3.new(0, 1, 0) * u1.FRUIT_UP_BLEND).Unit;
    local v49 = math.sin(p47);
    local v50 = math.cos(p47);
    local v51 = Vector3.new(v49, 0, v50):Cross(Unit);

    if v51.Magnitude < 0.0001 then
        v51 = Unit:Cross(Vector3.new(1, 0, 0));
    end;

    local v52 = CFrame.fromMatrix(p45, v51.Unit, Unit);

    if u1.FRUIT_HANG_FLIP[p48] then
        v52 = v52 * CFrame.Angles(3.141592653589793, 0, 0);
    end;

    return v52;
end;

function u1.SeedDisplayName(p53) -- Line: 564
    -- upvalues: u1 (copy)
    local v54 = u1.GetSeed(p53);

    if v54 then
        p53 = v54.displayName or p53;
    end;

    return p53:gsub("%s+%S+$", "") .. " Seed";
end;

local function fruitBase(p55) -- Line: 571
    local PrimaryPart = p55.PrimaryPart;

    if not PrimaryPart or (PrimaryPart.Name ~= "Base" or not PrimaryPart) then
        PrimaryPart = nil;
    end;

    return PrimaryPart;
end;

local u56 = setmetatable({}, {
    __mode = "k"
});

local function isUnderFruitVisual(p57, p58) -- Line: 578
    while p57 and p57 ~= p58 do
        if p57.Name:match("^FruitVisual_") or p57.Name:match("^HeldFruit_") then
            return true;
        end;

        p57 = p57.Parent;
    end;

    return false;
end;

local function branchTipDir(p59) -- Line: 588
    -- upvalues: u56 (copy), isUnderFruitVisual (copy)
    local v60 = u56[p59];

    if v60 then
        return v60;
    end;

    local v61 = p59.Parent and p59.Parent.Parent;
    local v62;

    if v61 then
        v62 = v61.Parent;
    else
        v62 = v61;
    end;

    local v63 = Vector3.new(0, 0, 0);
    local v64 = 0;

    if v62 and v62:IsA("Model") then
        local _, v65 = v62:GetBoundingBox();
        local v66 = math.max(1, v65.Magnitude * 0.06);

        for _, descendant in v62:GetDescendants() do
            if descendant:IsA("BasePart") and (descendant ~= p59 and (descendant.Transparency < 1 and (not descendant:IsDescendantOf(v61) and (not isUnderFruitVisual(descendant, v62) and (descendant.Position - p59.Position).Magnitude < v66)))) then
                v63 = v63 + descendant.Position;
                v64 = v64 + 1;
            end;
        end;
    end;

    local v67 = v64 > 0 and p59.Position - v63 / v64 or p59.CFrame.UpVector;
    local v68 = v67.Magnitude > 0.0001 and v67.Unit or Vector3.new(0, 1, 0);
    u56[p59] = v68;

    return v68;
end;

function u1.AnchorFruitToBase(p69, p70, p71, p72) -- Line: 616
    -- upvalues: branchTipDir (copy)
    local v73 = branchTipDir(p70);
    local Unit = (math.abs(v73.Y) > 0.99 and Vector3.new(0, 0, 1) or Vector3.new(0, 1, 0)):Cross(v73).Unit;
    local v74 = CFrame.fromMatrix(p70.Position, Unit, v73) * CFrame.Angles(0, p71, 0);
    local PrimaryPart = p69.PrimaryPart;

    if not PrimaryPart or (PrimaryPart.Name ~= "Base" or not PrimaryPart) then
        PrimaryPart = nil;
    end;

    if not PrimaryPart then
        p69:PivotTo(v74);

        return;
    end;

    p69:PivotTo(v74);
    local v75 = PrimaryPart.CFrame.RightVector:Dot(v73);
    local v76 = math.abs(v75) * PrimaryPart.Size.X;
    local v77 = PrimaryPart.CFrame.UpVector:Dot(v73);
    local v78 = v76 + math.abs(v77) * PrimaryPart.Size.Y;
    local v79 = PrimaryPart.CFrame.LookVector:Dot(v73);
    local v80 = 0.5 * (v78 + math.abs(v79) * PrimaryPart.Size.Z);
    local v81 = PrimaryPart.Position - v73 * v80;
    p69:PivotTo(p69:GetPivot() + (p70.Position - v73 * (v80 * 0.5) - v81));
end;

function u1.AnchorFruitTop(p82, p83, p84, p85) -- Line: 644
    -- upvalues: u1 (copy)
    local v86 = u1.FRUIT_HANG_BY_BOUNDS[p85] == true;
    local Base = p83:FindFirstChild("Base");

    if Base and (Base:IsA("BasePart") and not v86) then
        u1.AnchorFruitToBase(p82, Base, p84, p85);

        return;
    end;

    local v87 = u1.FRUIT_GROW_FROM_BOTTOM[p85] == true;
    local CFrame2 = p83.CFrame;
    local Size = p83.Size;
    local v88 = 0.5 * (math.abs(CFrame2.RightVector.Y) * Size.X + math.abs(CFrame2.UpVector.Y) * Size.Y + math.abs(CFrame2.LookVector.Y) * Size.Z);

    if v87 then
        v88 = -v88 or v88;
    end;

    local v89 = p83.Position + Vector3.new(0, v88, 0);
    p82:PivotTo(u1.FruitUprightCFrame(v89, CFrame2, p84, p85));
    local Unit = (CFrame2.UpVector + Vector3.new(0, 1, 0) * u1.FRUIT_UP_BLEND).Unit;
    local v90 = v87 and Unit and Unit or -Unit;
    local v91;

    if v86 then
        v91 = nil;
    else
        local PrimaryPart = p82.PrimaryPart;

        if not PrimaryPart or (PrimaryPart.Name ~= "Base" or not PrimaryPart) then
            PrimaryPart = nil;
        end;

        v91 = PrimaryPart or nil;
    end;

    if v91 then
        local v92 = v91.CFrame.RightVector:Dot(v90);
        local v93 = math.abs(v92) * v91.Size.X;
        local v94 = v91.CFrame.UpVector:Dot(v90);
        local v95 = v93 + math.abs(v94) * v91.Size.Y;
        local v96 = v91.CFrame.LookVector:Dot(v90);
        local v97 = 0.5 * (v95 + math.abs(v96) * v91.Size.Z);
        local v98 = v91.Position - v90 * v97;
        p82:PivotTo(p82:GetPivot() + (v89 - v98));

        return;
    end;

    local v99, v100 = p82:GetBoundingBox();
    local v101 = v99.RightVector:Dot(Unit);
    local v102 = math.abs(v101) * v100.X;
    local v103 = v99.UpVector:Dot(Unit);
    local v104 = v102 + math.abs(v103) * v100.Y;
    local v105 = v99.LookVector:Dot(Unit);
    local v106 = 0.5 * (v104 + math.abs(v105) * v100.Z);
    local v107 = v99.Position - v90 * v106;
    p82:PivotTo(p82:GetPivot() + (v89 - v107));
end;

function u1.CalcModelScale(p108, p109) -- Line: 687
    -- upvalues: u1 (copy)
    return u1.BASE_HEIGHT * p109 / p108;
end;

local function fruitTreeWorldHeight(p110) -- Line: 692
    local v111 = (1 / 0);
    local v112 = (-1 / 0);

    for _, descendant in p110:GetDescendants() do
        if descendant:IsA("BasePart") then
            local CFrame2 = descendant.CFrame;
            local Size = descendant.Size;
            local v113 = math.abs(CFrame2.RightVector.Y) * Size.X / 2 + math.abs(CFrame2.UpVector.Y) * Size.Y / 2 + math.abs(CFrame2.LookVector.Y) * Size.Z / 2;
            v111 = math.min(v111, CFrame2.Position.Y - v113);
            v112 = math.max(v112, CFrame2.Position.Y + v113);
        end;
    end;

    return v111 == (1 / 0) and 1 or math.max(v112 - v111, 1);
end;

function u1.CalcFruitScale(p114, p115) -- Line: 709
    -- upvalues: u1 (copy), ReplicatedStorage (copy), fruitTreeWorldHeight (copy)
    local naturalHeight = u1.STAGE_CONFIG[4].naturalHeight;
    local Assets = ReplicatedStorage:FindFirstChild("Assets");

    if Assets then
        Assets = Assets:FindFirstChild("Greedy");
    end;

    if Assets then
        Assets = Assets:FindFirstChild("PlantStages");
    end;

    if Assets then
        Assets = Assets:FindFirstChild(p114);
    end;

    if Assets then
        Assets = Assets:FindFirstChild(p114 .. "4");
    end;

    if Assets then
        naturalHeight = fruitTreeWorldHeight(Assets);
    end;

    return u1.CalcModelScale(naturalHeight, p115 or 1);
end;

function u1.ApplyCostOverrides(p116) -- Line: 722
    -- upvalues: u1 (copy)
    if type(p116) ~= "table" then
        return;
    end;

    for i, v in p116 do
        local v117 = u1.Seeds[i];

        if v117 and type(v) == "table" then
            local v118 = tonumber(v.plantCost);

            if v118 and v118 >= 0 then
                v117.plantCost = v118;
            end;

            local v119 = tonumber(v.sellPrice);

            if v119 and v119 > 0 then
                v117.sellPrice = v119;
            end;

            local v120 = tonumber(v.baseFruitValue);

            if v120 and v120 >= 0 then
                v117.baseFruitValue = v120;
            end;

            local v121 = tonumber(v.generationTime);

            if v121 and v121 > 0 then
                v117.generationTime = v121;
            end;
        end;
    end;
end;

function u1.ApplyWeightOverrides(p122) -- Line: 741
    -- upvalues: u1 (copy)
    if type(p122) ~= "table" then
        return;
    end;

    for i, v in p122 do
        local v123 = tonumber(v);

        if u1.RARITY_WEIGHTS[i] ~= nil and (v123 and v123 > 0) then
            u1.RARITY_WEIGHTS[i] = v123;
        end;
    end;
end;

return u1;