-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local PetSizes = require(ReplicatedStorage.SharedData.PetSizes);
local PetTypes = require(ReplicatedStorage.SharedData.PetTypes);
local PetFlags = require(ReplicatedStorage.SharedModules.Flags.PetFlags);
local GearImages = ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("GearImages");

local function getGearImage(p1) -- Line: 9
    -- upvalues: GearImages (copy)
    local v2 = GearImages:FindFirstChild(p1);

    return not (v2 and v2:IsA("StringValue")) and "" or v2.Value;
end;

local function formatNumber(p3) -- Line: 19
    local v4 = string.format("%.2f", p3);

    return string.gsub(v4, "%.?0+$", "");
end;

local function variantBoost(p5, p6) -- Line: 27
    -- upvalues: PetTypes (copy), PetSizes (copy)
    return PetTypes.GetBoostMultiplier(p6) * PetSizes.GetBoostMultiplier(p5);
end;

local function chanceClause(p7, p8) -- Line: 34
    if p7 == 2 then
        return `<b>doubles</b> the chance for plants and fruit to turn {p8}`;
    end;

    local v9 = string.format("%.2f", p7);

    return `<b>multiplies</b> the chance for plants and fruit to turn {p8} by <b>x{string.gsub(v9, "%.?0+$", "")}</b>`;
end;

local u10 = {};
local v11 = {
    DisplayName = "Raccoon",
    Rarity = "Super",
    SpawnChance = 0.24,
    BasePrice = 5000000,
    Offset = Vector3.new(0, 2.5, 0)
};
local Raccoon = GearImages:FindFirstChild("Raccoon");
v11.Image = not (Raccoon and Raccoon:IsA("StringValue")) and "" or Raccoon.Value;
v11.Worlds = { "Main" };

function v11.Description(p12, p13) -- Line: 53
    -- upvalues: PetSizes (copy), PetTypes (copy)
    local v14 = PetSizes.Normalize(p12);
    local v15 = v14 == "Huge" and 100 or (v14 == "Big" and 50 or 25);

    if p13 == PetTypes.Rainbow then
        v15 = v15 + 10;
    end;

    return `Sneaks out at <b>night</b> to <font color="#ff0000">steal</font> fruit from empty gardens and <font color="#55ff55">raises your steal limit by +{v15}</font>`;
end;

v11.NeededWeather = {};
v11.NeededTimeCycle = {};
u10.Raccoon = v11;
local v16 = {
    DisplayName = "Fox",
    Rarity = "Mythic",
    SpawnChance = 0.1,
    BasePrice = 10000000,
    Offset = Vector3.new(0, 2.5, 0)
};
local Fox = GearImages:FindFirstChild("Fox");
v16.Image = not (Fox and Fox:IsA("StringValue")) and "" or Fox.Value;
v16.Worlds = { "FallHarvest" };

function v16.Description(p17, p18) -- Line: 78
    return "Sneaks out at <b>night</b> to <font color=\"#ff0000\">steal</font> a seed from other players and brings it back to you";
end;

v16.NeededWeather = {};
v16.NeededTimeCycle = {};
u10.Fox = v16;
local v19 = {
    DisplayName = "Monkey",
    Rarity = "Mythic",
    SpawnChance = 0.2,
    BasePrice = 1000000,
    Offset = Vector3.new(0, 2.5, 0)
};
local Monkey = GearImages:FindFirstChild("Monkey");
v19.Image = not (Monkey and Monkey:IsA("StringValue")) and "" or Monkey.Value;
v19.Worlds = { "Main" };

function v19.Description(p20, p21) -- Line: 102
    -- upvalues: PetTypes (copy), PetSizes (copy)
    local v22 = PetTypes.GetBoostMultiplier(p21) * PetSizes.GetBoostMultiplier(p20);

    if v22 <= 1 then
        return "Swings around your <b>garden</b> and occasionally <font color=\"#55ff55\">picks ripe fruit</font> and brings it straight to you";
    end;

    local v23 = string.format("%.2f", v22);

    return `Swings around your <b>garden</b> and <font color="#55ff55">picks ripe fruit <b>x{string.gsub(v23, "%.?0+$", "")}</b> as often</font> and brings it straight to you`;
end;

v19.NeededWeather = {};
v19.NeededTimeCycle = {};
u10.Monkey = v19;
local v24 = {
    DisplayName = "Jandel Monkey",
    Rarity = "Mythic",
    SpawnChance = 0.2,
    BasePrice = 1000000,
    Offset = Vector3.new(0, 2.5, 0)
};
local v25 = GearImages:FindFirstChild("Jandel Monkey");
v24.Image = not (v25 and v25:IsA("StringValue")) and "" or v25.Value;
v24.Worlds = { "Main" };

function v24.Description(p26, p27) -- Line: 124
    -- upvalues: PetFlags (copy), PetSizes (copy)
    local v28 = PetFlags.JandelMonkeyIntervalSecondsBySize:Get();
    local v29 = v28[PetSizes.Normalize(p26) or "Normal"] or v28.Normal or 600;
    local v30 = string.format("%.2f", v29 / 60);

    return `Swings around your <b>garden</b> and every <b>{string.gsub(v30, "%.?0+$", "")} minutes</b> <font color="#55ff55">summons a random weather</font> for everyone on the server`;
end;

v24.NeededWeather = {};
v24.NeededTimeCycle = {};
u10.JandelMonkey = v24;
local v31 = {
    DisplayName = "Squirrel",
    Rarity = "Legendary",
    SpawnChance = 0.6,
    BasePrice = 1200000,
    Offset = Vector3.new(0, 2.5, 0)
};
local Squirrel = GearImages:FindFirstChild("Squirrel");
v31.Image = not (Squirrel and Squirrel:IsA("StringValue")) and "" or Squirrel.Value;
v31.Worlds = { "FallHarvest" };

function v31.Description(p32, p33) -- Line: 141
    -- upvalues: PetTypes (copy), PetSizes (copy)
    local v34 = PetTypes.GetBoostMultiplier(p33) * PetSizes.GetBoostMultiplier(p32);

    if v34 <= 1 then
        return "Scurries around your <b>garden</b> and rapidly <font color=\"#55ff55\">picks ripe fruit</font> and brings it straight to you";
    end;

    local v35 = string.format("%.2f", v34);

    return `Scurries around your <b>garden</b> and <font color="#55ff55">picks ripe fruit <b>x{string.gsub(v35, "%.?0+$", "")}</b> as often</font> and brings it straight to you`;
end;

v31.NeededWeather = {};
v31.NeededTimeCycle = {};
u10.Squirrel = v31;
local v36 = {
    DisplayName = "Robin",
    Rarity = "Legendary",
    SpawnChance = 2.86,
    BasePrice = 75000,
    Offset = Vector3.new(0, 5, 0)
};
local Robin = GearImages:FindFirstChild("Robin");
v36.Image = not (Robin and Robin:IsA("StringValue")) and "" or Robin.Value;
v36.Worlds = { "Main" };

function v36.Description(p37, p38) -- Line: 163
    -- upvalues: PetTypes (copy), PetSizes (copy)
    local v39 = PetTypes.GetBoostMultiplier(p38) * PetSizes.GetBoostMultiplier(p37);

    if v39 <= 1 then
        return "Flies around your <b>garden</b> eating ripe fruit and sometimes <font color=\"#55ff55\">drops seeds</font>";
    end;

    local v40 = string.format("%.2f", v39);

    return `Flies around your <b>garden</b> eating ripe fruit and <font color="#55ff55">drops seeds <b>x{string.gsub(v40, "%.?0+$", "")}</b> as often</font>`;
end;

v36.NeededWeather = {};
v36.NeededTimeCycle = {};
u10.Robin = v36;
local v41 = {
    DisplayName = "Frog",
    Rarity = "Common",
    SpawnChance = 11.9,
    BasePrice = 10000,
    Offset = Vector3.new(0, 2, 0)
};
local Frog = GearImages:FindFirstChild("Frog");
v41.Image = not (Frog and Frog:IsA("StringValue")) and "" or Frog.Value;
v41.Worlds = { "Main" };

function v41.Description(p42, p43) -- Line: 182
    -- upvalues: PetTypes (copy), PetSizes (copy)
    local v44 = PetTypes.GetBoostMultiplier(p43) * PetSizes.GetBoostMultiplier(p42) * 5;
    local v45 = string.format("%.2f", v44);

    return `Hops around your <b>garden</b> and <font color="#55ff55">boosts your jump height by +{string.gsub(v45, "%.?0+$", "")}</font>`;
end;

v41.NeededWeather = {};
v41.NeededTimeCycle = {};
u10.Frog = v41;
local v46 = {
    DisplayName = "Bunny",
    Rarity = "Common",
    SpawnChance = 11.9,
    BasePrice = 20000,
    Offset = Vector3.new(0, 2, 0)
};
local Bunny = GearImages:FindFirstChild("Bunny");
v46.Image = not (Bunny and Bunny:IsA("StringValue")) and "" or Bunny.Value;
v46.Worlds = { "Main" };

function v46.Description(p47, p48) -- Line: 198
    -- upvalues: PetTypes (copy), PetSizes (copy)
    local v49 = PetTypes.GetBoostMultiplier(p48) * PetSizes.GetBoostMultiplier(p47) * 5;
    local v50 = string.format("%.2f", v49);

    return `Hops around your <b>garden</b> and <font color="#55ff55">boosts your walk speed by +{string.gsub(v50, "%.?0+$", "")}</font>`;
end;

v46.NeededWeather = {};
v46.NeededTimeCycle = {};
u10.Bunny = v46;
local v51 = {
    DisplayName = "Deer",
    Rarity = "Rare",
    SpawnChance = 4.29,
    BasePrice = 50000,
    Offset = Vector3.new(0, 3, 0)
};
local Deer = GearImages:FindFirstChild("Deer");
v51.Image = not (Deer and Deer:IsA("StringValue")) and "" or Deer.Value;
v51.Worlds = { "Main" };

function v51.Description(p52, p53) -- Line: 214
    -- upvalues: PetTypes (copy), PetSizes (copy)
    local v54 = PetTypes.GetBoostMultiplier(p53) * PetSizes.GetBoostMultiplier(p52) * 10;
    local v55 = string.format("%.2f", v54);

    return `Trots around your <b>garden</b> and helps plants <font color="#55ff55">grow {string.gsub(v55, "%.?0+$", "")}% faster</font>`;
end;

v51.NeededWeather = {};
v51.NeededTimeCycle = {};
u10.Deer = v51;
local v56 = {
    DisplayName = "Butterfly",
    Rarity = "Legendary",
    SpawnChance = 2.38,
    BasePrice = 1000000,
    Offset = Vector3.new(0, 3, 0)
};
local Butterfly = GearImages:FindFirstChild("Butterfly");
v56.Image = not (Butterfly and Butterfly:IsA("StringValue")) and "" or Butterfly.Value;
v56.Worlds = { "Main" };

function v56.Description(p57, p58) -- Line: 230
    -- upvalues: PetFlags (copy), PetTypes (copy), PetSizes (copy)
    local v59 = PetFlags.ButterflyGrowthBoostPerEquipped:Get() * 100 * (PetTypes.GetBoostMultiplier(p58) * PetSizes.GetBoostMultiplier(p57));
    local v60 = string.format("%.2f", v59);

    return `Flutters around and helps <b>everyone's</b> plants <font color="#55ff55">grow {string.gsub(v60, "%.?0+$", "")}% faster</font>`;
end;

v56.NeededWeather = {};
v56.NeededTimeCycle = {};
u10.Butterfly = v56;
local v61 = {
    DisplayName = "Firefly",
    Rarity = "Mythic",
    SpawnChance = 0.6,
    BasePrice = 3000000,
    Offset = Vector3.new(0, 3, 0)
};
local Firefly = GearImages:FindFirstChild("Firefly");
v61.Image = not (Firefly and Firefly:IsA("StringValue")) and "" or Firefly.Value;
v61.Worlds = { "Main" };

function v61.Description(p62, p63) -- Line: 252
    -- upvalues: PetFlags (copy), PetTypes (copy), PetSizes (copy)
    local v64 = PetFlags.FireflyPlantSizeBonusPerEquipped:Get() * 100 * (PetTypes.GetBoostMultiplier(p63) * PetSizes.GetBoostMultiplier(p62));
    local v65 = string.format("%.2f", v64);

    return `Flies around and makes <b>everyone's</b> newly planted crops <font color="#55ff55">{string.gsub(v65, "%.?0+$", "")}% bigger</font>`;
end;

v61.NeededWeather = {};
v61.NeededTimeCycle = {};
u10.Firefly = v61;
local v66 = {
    DisplayName = "Turtle",
    Rarity = "Rare",
    SpawnChance = 3.75,
    BasePrice = 70000,
    Offset = Vector3.new(0, 3, 0)
};
local Turtle = GearImages:FindFirstChild("Turtle");
v66.Image = not (Turtle and Turtle:IsA("StringValue")) and "" or Turtle.Value;
v66.Worlds = { "Main" };

function v66.Description(p67, p68) -- Line: 276
    -- upvalues: PetSizes (copy), PetTypes (copy)
    local v69 = PetSizes.Normalize(p67);
    local v70 = v69 == "Huge" and 100 or (v69 == "Big" and 50 or 10);

    if p68 == PetTypes.Rainbow then
        v70 = v70 + 20;
    end;

    return `Lugs a heavy shell that <font color="#55ff55">adds +{v70} backpack space</font> but <font color="#ff5555">slows your walk speed by 2</font>`;
end;

v66.NeededWeather = {};
v66.NeededTimeCycle = {};
u10.Turtle = v66;
local v71 = {
    DisplayName = "Bear",
    Rarity = "Mythic",
    Description = "Defends your <b>garden</b> by <font color=\"#ff8800\">tackling intruders</font>, pinning them down, then <font color=\"#ff8800\">throwing them</font> away",
    SpawnChance = 0.225,
    BasePrice = 5000000,
    Offset = Vector3.new(0, 3, 0)
};
local Bear = GearImages:FindFirstChild("Bear");
v71.Image = not (Bear and Bear:IsA("StringValue")) and "" or Bear.Value;
v71.Worlds = { "Main" };
v71.NeededWeather = {};
v71.NeededTimeCycle = {};
u10.Bear = v71;
local v72 = {
    DisplayName = "Hedgehog",
    Rarity = "Rare",
    Description = "Defends your <b>garden</b> by <font color=\"#ff8800\">rolling after intruders</font>, <font color=\"#ff8800\">tackling and knocking them back</font> so they drop what they stole",
    SpawnChance = 1,
    BasePrice = 140000,
    Offset = Vector3.new(0, 3, 0)
};
local Hedgehog = GearImages:FindFirstChild("Hedgehog");
v72.Image = not (Hedgehog and Hedgehog:IsA("StringValue")) and "" or Hedgehog.Value;
v72.Worlds = { "FallHarvest" };
v72.NeededWeather = {};
v72.NeededTimeCycle = {};
u10.Hedgehog = v72;
local v73 = {
    DisplayName = "Dog",
    Rarity = "Uncommon",
    Description = "Guards your <b>garden</b> and <font color=\"#ff8800\">chases down thieves</font>, <font color=\"#ff8800\">biting and stunning them</font> so they drop what they stole",
    SpawnChance = 0.75,
    BasePrice = 50000,
    Offset = Vector3.new(0, 3, 0)
};
local Dog = GearImages:FindFirstChild("Dog");
v73.Image = not (Dog and Dog:IsA("StringValue")) and "" or Dog.Value;
v73.Worlds = { "FallHarvest" };
v73.NeededWeather = {};
v73.NeededTimeCycle = {};
u10.Dog = v73;
local v74 = {
    DisplayName = "Owl",
    Rarity = "Uncommon",
    SpawnChance = 7.14,
    BasePrice = 25000,
    Offset = Vector3.new(0, 5, 0)
};
local Owl = GearImages:FindFirstChild("Owl");
v74.Image = not (Owl and Owl:IsA("StringValue")) and "" or Owl.Value;
v74.Worlds = { "Main" };

function v74.Description(p75, p76) -- Line: 353
    -- upvalues: PetTypes (copy), PetSizes (copy)
    local v77 = PetTypes.GetBoostMultiplier(p76) * PetSizes.GetBoostMultiplier(p75) * 12.5;
    local v78 = string.format("%.2f", v77);

    return `<font color="#55ff55">Extends your view distance by {string.gsub(v78, "%.?0+$", "")}%</font> at night and <font color="#ffaa00">hoots loudly</font> when a rare pet spawns`;
end;

v74.NeededWeather = {};
v74.NeededTimeCycle = {};
u10.Owl = v74;
local v79 = {
    DisplayName = "Bee",
    Rarity = "Legendary",
    Description = "Patrols your <b>garden</b> and <font color=\"#ff8800\">swarms intruders</font> to defend your fruit",
    SpawnChance = 2.38,
    BasePrice = 1000000,
    Offset = Vector3.new(0, 5, 0)
};
local Bee = GearImages:FindFirstChild("Bee");
v79.Image = not (Bee and Bee:IsA("StringValue")) and "" or Bee.Value;
v79.Worlds = { "Main" };
v79.NeededWeather = {};
v79.NeededTimeCycle = {};
u10.Bee = v79;
local v80 = {
    DisplayName = "Unicorn",
    Rarity = "Mythic",
    SpawnChance = 0.71,
    BasePrice = 4000000,
    Offset = Vector3.new(0, 3, 0)
};
local Unicorn = GearImages:FindFirstChild("Unicorn");
v80.Image = not (Unicorn and Unicorn:IsA("StringValue")) and "" or Unicorn.Value;
v80.Worlds = { "Main" };

function v80.Description(p81, p82) -- Line: 382
    -- upvalues: PetTypes (copy), PetSizes (copy)
    local v83 = PetTypes.GetBoostMultiplier(p82) * PetSizes.GetBoostMultiplier(p81) + 1;
    local v84;

    if v83 == 2 then
        v84 = "<b>doubles</b> the chance for plants and fruit to turn <font color=\"#ff66ff\">Rainbow</font>";
    else
        local v85 = string.format("%.2f", v83);
        v84 = `<b>multiplies</b> the chance for plants and fruit to turn <font color="#ff66ff">Rainbow</font> by <b>x{string.gsub(v85, "%.?0+$", "")}</b>`;
    end;

    return `Trots around your <b>garden</b> and {v84}`;
end;

v80.NeededWeather = {};
v80.NeededTimeCycle = {};
u10.Unicorn = v80;
local v86 = {
    DisplayName = "Wolf",
    Rarity = "Mythic",
    Description = "Prowls around your <b>garden</b> and summons a pack of <font color=\"#ffaa00\">wild animals</font> whenever a <b>moon</b> rises",
    SpawnChance = 0.2,
    BasePrice = 6500000,
    Offset = Vector3.new(0, 3, 0)
};
local Wolf = GearImages:FindFirstChild("Wolf");
v86.Image = not (Wolf and Wolf:IsA("StringValue")) and "" or Wolf.Value;
v86.Worlds = { "FallHarvest" };
v86.NeededWeather = {};
v86.NeededTimeCycle = {};
u10.Wolf = v86;
local v87 = {
    DisplayName = "Black Dragon",
    Rarity = "Super",
    SpawnChance = 0,
    BasePrice = 20000000,
    Offset = Vector3.new(0, 5, 0)
};
local v88 = GearImages:FindFirstChild("Black Dragon");
v87.Image = not (v88 and v88:IsA("StringValue")) and "" or v88.Value;
v87.Worlds = { "Main" };

function v87.Description(p89, p90) -- Line: 418
    -- upvalues: PetSizes (copy)
    local v91 = PetSizes.Normalize(p89);
    local v92 = 1;

    if v91 == "Huge" then
        v92 = v92 * 2;
    elseif v91 == "Big" then
        v92 = v92 * 1.25;
    end;

    if p90 == "Rainbow" then
        v92 = v92 * 1.15;
    end;

    if v92 <= 1 then
        return "Flies around <b>gardens</b> <font color=\"#55ff55\">eating ripe fruit</font> and <font color=\"#ffaa00\">laying eggs</font> that hatch into pets <b>based on the fruit it ate</b>";
    end;

    local v93 = string.format("%.2f", v92);

    return `Flies around <b>gardens</b> and <font color="#55ff55">eats ripe fruit <b>x{string.gsub(v93, "%.?0+$", "")}</b> as often</font>, <font color="#ffaa00">laying eggs</font> that hatch into pets that much faster, <b>based on the fruit it ate</b>`;
end;

v87.NeededWeather = {};
v87.NeededTimeCycle = {};
u10.BlackDragon = v87;
local v94 = {
    DisplayName = "Shadow Dragon",
    Rarity = "Super",
    Description = "Flies around your <b>gardens</b> and has a chance to apply the <font color=\"#a05cff\">Veil</font> mutation when you plant a seed",
    SpawnChance = 0.00464,
    BasePrice = 30000000,
    Offset = Vector3.new(0, 5, 0)
};
local v95 = GearImages:FindFirstChild("Shadow Dragon");
v94.Image = not (v95 and v95:IsA("StringValue")) and "" or v95.Value;
v94.Worlds = { "FallHarvest" };
v94.NeededWeather = {};
v94.NeededTimeCycle = {};
u10.ShadowDragon = v94;
local v96 = {
    DisplayName = "Swan",
    Rarity = "Legendary",
    Description = "Wanders your <b>garden</b> and periodically <font color=\"#66ccff\">spits water</font> on nearby plants to speed their growth",
    SpawnChance = 0.4,
    BasePrice = 1600000,
    Offset = Vector3.new(0, 5, 0)
};
local Swan = GearImages:FindFirstChild("Swan");
v96.Image = not (Swan and Swan:IsA("StringValue")) and "" or Swan.Value;
v96.Worlds = { "FallHarvest" };
v96.NeededWeather = {};
v96.NeededTimeCycle = {};
u10.Swan = v96;
local v97 = {
    DisplayName = "Ice Serpent",
    Rarity = "Super",
    SpawnChance = 0,
    BasePrice = 20000000,
    Offset = Vector3.new(0, 5, 0)
};
local v98 = GearImages:FindFirstChild("Ice Serpent");
v97.Image = not (v98 and v98:IsA("StringValue")) and "" or v98.Value;
v97.Worlds = { "Main" };

function v97.Description(p99, p100) -- Line: 516
    -- upvalues: PetTypes (copy), PetSizes (copy)
    local v101 = PetTypes.GetBoostMultiplier(p100) * PetSizes.GetBoostMultiplier(p99);

    if v101 <= 1 then
        return "Flies around your <b>garden</b> and <font color=\"#66ccff\">breathes frost</font> on intruders, freezing them solid";
    end;

    local v102 = string.format("%.2f", v101);

    return `Flies around your <b>garden</b> and <font color="#66ccff">breathes frost</font> on intruders, <font color="#66ccff">freezing them <b>x{string.gsub(v102, "%.?0+$", "")}</b> as hard</font>`;
end;

v97.NeededWeather = {};
v97.NeededTimeCycle = {};
u10.IceSerpent = v97;
local v103 = {
    DisplayName = "Golden Dragonfly",
    Rarity = "Mythic",
    SpawnChance = 0.6,
    BasePrice = 3000000,
    Offset = Vector3.new(0, 5, 0)
};
local v104 = GearImages:FindFirstChild("Golden Dragonfly");
v103.Image = not (v104 and v104:IsA("StringValue")) and "" or v104.Value;
v103.Worlds = { "Main" };

function v103.Description(p105, p106) -- Line: 535
    -- upvalues: PetTypes (copy), PetSizes (copy)
    local v107 = PetTypes.GetBoostMultiplier(p106) * PetSizes.GetBoostMultiplier(p105) + 1;
    local v108;

    if v107 == 2 then
        v108 = "<b>doubles</b> the chance for plants and fruit to turn <font color=\"#ffd700\">Gold</font>";
    else
        local v109 = string.format("%.2f", v107);
        v108 = `<b>multiplies</b> the chance for plants and fruit to turn <font color="#ffd700">Gold</font> by <b>x{string.gsub(v109, "%.?0+$", "")}</b>`;
    end;

    return `Flies around your <b>garden</b> and {v108}`;
end;

v103.NeededWeather = {};
v103.NeededTimeCycle = {};
u10.GoldenDragonfly = v103;
local v110 = {
    DisplayName = "Bald Eagle",
    Rarity = "Mythic",
    SpawnChance = 0.225,
    BasePrice = 5000000,
    Offset = Vector3.new(0, 5, 0)
};
local v111 = GearImages:FindFirstChild("Bald Eagle");
v110.Image = not (v111 and v111:IsA("StringValue")) and "" or v111.Value;
v110.Worlds = { "Main" };

function v110.Description(p112, p113) -- Line: 553
    -- upvalues: PetSizes (copy)
    local v114 = PetSizes.Normalize(p112);

    if v114 ~= "Huge" then
        local _ = v114 == "Big";
    end;

    return "<font color=\"#ff8800\">Snatches intruders</font> and <font color=\"#ff8800\">flies them</font> out of your <b>garden</b>";
end;

v110.NeededWeather = {};
v110.NeededTimeCycle = {};
u10.BaldEagle = v110;
local v115 = {
    DisplayName = "Turkey",
    Rarity = "Rare",
    Description = "Struts around your <b>garden</b> and <font color=\"#55ff55\">pecks the ground</font> to dig up a random <font color=\"#55ff55\">seed</font>",
    SpawnChance = 1,
    BasePrice = 100000,
    Offset = Vector3.new(0, 3, 0)
};
local Turkey = GearImages:FindFirstChild("Turkey");
v115.Image = not (Turkey and Turkey:IsA("StringValue")) and "" or Turkey.Value;
v115.Worlds = { "FallHarvest" };
v115.NeededWeather = {};
v115.NeededTimeCycle = {};
u10.Turkey = v115;

function u10.GetImage(p116, p117) -- Line: 596
    -- upvalues: u10 (copy), PetSizes (copy), GearImages (copy)
    local v118 = u10[p116];

    if type(v118) ~= "table" then
        return "";
    end;

    local v119 = PetSizes.Normalize(p117);

    if v119 then
        local v120 = GearImages:FindFirstChild((`{v119} {u10.GetSpeciesDisplayName(p116)}`));
        local v121 = not (v120 and v120:IsA("StringValue")) and "" or v120.Value;

        if v121 ~= "" then
            return v121;
        end;
    end;

    local Image = v118.Image;

    return type(Image) ~= "string" and "" or Image;
end;

local function humanizeSpecies(p122) -- Line: 617
    return string.gsub(p122, "(%l)(%u)", "%1 %2");
end;

function u10.GetSpeciesDisplayName(p123) -- Line: 625
    -- upvalues: u10 (copy)
    local v124 = u10[p123];

    if type(v124) == "table" and type(v124.DisplayName) == "string" then
        return v124.DisplayName;
    end;

    return string.gsub(p123, "(%l)(%u)", "%1 %2");
end;

function u10.GetDisplayName(p125, p126) -- Line: 636
    -- upvalues: PetSizes (copy), u10 (copy)
    return PetSizes.DisplayName(u10.GetSpeciesDisplayName(p125), p126);
end;

function u10.GetVariantDisplayName(p127, p128, p129) -- Line: 644
    -- upvalues: u10 (copy), PetTypes (copy), PetSizes (copy)
    local v130 = u10.GetSpeciesDisplayName(p127);

    if p129 == PetTypes.Rainbow then
        v130 = `Rainbow {v130}`;
    end;

    local v131 = PetSizes.DisplaySize(p128);

    if v131 then
        v130 = `{v131} {v130}`;
    end;

    return v130;
end;

function u10.GetVariantBoost(p132, p133) -- Line: 658
    -- upvalues: PetTypes (copy), PetSizes (copy)
    return PetTypes.GetBoostMultiplier(p133) * PetSizes.GetBoostMultiplier(p132);
end;

function u10.GetDescription(p134, p135, p136) -- Line: 664
    -- upvalues: u10 (copy)
    local v137 = u10[p134];

    if type(v137) ~= "table" then
        return "";
    end;

    local Description = v137.Description;

    if type(Description) == "function" then
        return Description(p135, p136);
    end;

    return type(Description) ~= "string" and "" or Description;
end;

function u10.GetBasePrice(p138) -- Line: 677
    -- upvalues: u10 (copy), PetFlags (copy)
    local v139 = u10[p138];

    if type(v139) ~= "table" then
        return 0;
    end;

    local v140 = PetFlags.BasePriceOverrides:Get()[p138];

    if type(v140) == "number" then
        return v140;
    end;

    local BasePrice = v139.BasePrice;

    return type(BasePrice) ~= "number" and 0 or BasePrice;
end;

function u10.GetSellValue(p141) -- Line: 691
    -- upvalues: PetFlags (copy), u10 (copy)
    local v142 = PetFlags.SellPriceMultiplierOverrides:Get()[p141];

    if type(v142) ~= "number" then
        v142 = PetFlags.SellPriceMultiplier:Get();
    end;

    local v143 = u10.GetBasePrice(p141) * v142;

    return math.floor(v143);
end;

return u10;