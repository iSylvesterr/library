-- Decompiled with Potassium's decompiler.

local GearImages = script.Parent.GearImages;
local Worlds = require(script.Parent.Worlds);

local function getGearImage(p1) -- Line: 4
    -- upvalues: GearImages (copy)
    local v2 = GearImages:FindFirstChild(p1);

    return v2 and v2.Value or "";
end;

local u3 = {};
local v4 = {};
local v5 = {
    ItemName = "Common Watering Can",
    ItemType = "Watering Can",
    RestockChance = 90,
    Cost = 2000,
    Rarity = "Common",
    RestockValues = NumberRange.new(2, 5)
};
local v6 = GearImages:FindFirstChild("Common Watering Can");
v5.IMG = v6 and v6.Value or "";
v5.Worlds = { "Main" };
local v7 = {
    ItemName = "Common Sprinkler",
    ItemType = "Common Sprinkler",
    RestockChance = 50,
    Cost = 3000,
    Rarity = "Common",
    RestockValues = NumberRange.new(1, 2)
};
local v8 = GearImages:FindFirstChild("Common Sprinkler");
v7.IMG = v8 and v8.Value or "";
v7.Worlds = { "Main" };
local v9 = {
    ItemName = "Sign",
    ItemType = "Sign",
    Cost = 4000,
    PriceInRobux = 49,
    EquippableGear = true,
    Rarity = "Common"
};
local Sign = GearImages:FindFirstChild("Sign");
v9.IMG = Sign and Sign.Value or "";
local v10 = {
    ItemName = "Megaphone",
    ItemType = "Megaphone",
    Cost = 8000,
    PriceInRobux = 49,
    EquippableGear = true,
    Rarity = "Rare"
};
local Megaphone = GearImages:FindFirstChild("Megaphone");
v10.IMG = Megaphone and Megaphone.Value or "";
local v11 = {
    ItemName = "Harp",
    ItemType = "Harp",
    RestockChance = 8,
    Cost = 250000,
    Rarity = "Rare",
    RestockValues = NumberRange.new(1, 2)
};
local Harp = GearImages:FindFirstChild("Harp");
v11.IMG = Harp and Harp.Value or "";
v11.Worlds = { "FallHarvest" };
local v12 = {
    ItemName = "Uncommon Sprinkler",
    ItemType = "Uncommon Sprinkler",
    RestockChance = 35,
    Cost = 10000,
    Rarity = "Uncommon",
    RestockValues = NumberRange.new(1, 2)
};
local v13 = GearImages:FindFirstChild("Uncommon Sprinkler");
v12.IMG = v13 and v13.Value or "";
v12.Worlds = { "Main" };
local v14 = {
    ItemName = "Rare Sprinkler",
    ItemType = "Rare Sprinkler",
    RestockChance = 25,
    Cost = 80000,
    Rarity = "Rare",
    RestockValues = NumberRange.new(1, 2)
};
local v15 = GearImages:FindFirstChild("Rare Sprinkler");
v14.IMG = v15 and v15.Value or "";
v14.Worlds = { "Main" };
local v16 = {
    ItemName = "Legendary Sprinkler",
    ItemType = "Legendary Sprinkler",
    RestockChance = 4,
    Cost = 1200000,
    Rarity = "Legendary",
    RestockValues = NumberRange.new(1, 2)
};
local v17 = GearImages:FindFirstChild("Legendary Sprinkler");
v16.IMG = v17 and v17.Value or "";
v16.Worlds = { "Main" };
local v18 = {
    ItemName = "Wind Staff",
    ItemType = "WindStaff",
    Cost = 2000000,
    EquippableGear = true,
    Rarity = "Epic"
};
local v19 = GearImages:FindFirstChild("Wind Staff");
v18.IMG = v19 and v19.Value or "";
v18.Worlds = { "FallHarvest" };
local v20 = {
    ItemName = "Super Sprinkler",
    ItemType = "Super Sprinkler",
    RestockChance = 1.2,
    Cost = 300000,
    Rarity = "Super",
    RestockValues = NumberRange.new(1, 2)
};
local v21 = GearImages:FindFirstChild("Super Sprinkler");
v20.IMG = v21 and v21.Value or "";
v20.Worlds = { "Main" };
local v22 = {
    ItemName = "Trowel",
    ItemType = "Trowel",
    RestockChance = 28,
    Cost = 1000,
    Rarity = "Rare",
    RestockValues = NumberRange.new(2, 3)
};
local Trowel = GearImages:FindFirstChild("Trowel");
v22.IMG = Trowel and Trowel.Value or "";
local v23 = {
    ItemName = "Speed Mushroom",
    ItemType = "Mushroom",
    RestockChance = 22,
    Cost = 1500,
    Rarity = "Rare",
    RestockValues = NumberRange.new(1, 5)
};
local v24 = GearImages:FindFirstChild("Speed Mushroom");
v23.IMG = v24 and v24.Value or "";
v23.Worlds = { "Main" };
local v25 = {
    ItemName = "Jump Mushroom",
    ItemType = "Mushroom",
    RestockChance = 24,
    Cost = 1800,
    Rarity = "Rare",
    RestockValues = NumberRange.new(1, 4)
};
local v26 = GearImages:FindFirstChild("Jump Mushroom");
v25.IMG = v26 and v26.Value or "";
v25.Worlds = { "Main" };
local v27 = {
    ItemName = "Gnome",
    ItemType = "Gnome",
    RestockChance = 8,
    Cost = 100000,
    Rarity = "Epic",
    RestockValues = NumberRange.new(2, 5)
};
local Gnome = GearImages:FindFirstChild("Gnome");
v27.IMG = Gnome and Gnome.Value or "";
v27.Worlds = { "Main" };
v4[1], v4[2], v4[3], v4[4], v4[5], v4[6], v4[7], v4[8], v4[9], v4[10], v4[11], v4[12], v4[13], v4[14], v4[15], v4[16] = v5, v7, v9, v10, v11, {
    ItemName = "Wheelbarrow",
    ItemType = "Wheelbarrow",
    Cost = 500000,
    PriceInRobux = 129,
    EquippableGear = true,
    Rarity = "Legendary",
    IMG = "rbxassetid://125296794878681"
}, v12, v14, v16, v18, {
    ItemName = "Strawberry Sniper",
    ItemType = "StrawberrySniper",
    Cost = 13000000,
    PriceInRobux = 1349,
    EquippableGear = true,
    Rarity = "Mythic",
    IMG = "rbxassetid://75926403967341",
    Worlds = { "Main" }
}, v20, v22, v23, v25, v27;
local v28 = {
    ItemName = "Shrink Mushroom",
    ItemType = "Mushroom",
    RestockChance = 10,
    Cost = 10000,
    Rarity = "Epic",
    RestockValues = NumberRange.new(1, 3)
};
local v29 = GearImages:FindFirstChild("Shrink Mushroom");
v28.IMG = v29 and v29.Value or "";
v28.Worlds = { "Main" };
local v30 = {
    ItemName = "Supersize Mushroom",
    ItemType = "Mushroom",
    RestockChance = 10,
    Cost = 20000,
    Rarity = "Epic",
    RestockValues = NumberRange.new(1, 3)
};
local v31 = GearImages:FindFirstChild("Supersize Mushroom");
v30.IMG = v31 and v31.Value or "";
v30.Worlds = { "Main" };
local v32 = {
    ItemName = "Invisibility Mushroom",
    ItemType = "Mushroom",
    RestockChance = 4,
    Cost = 30000,
    Rarity = "Legendary",
    RestockValues = NumberRange.new(1, 2)
};
local v33 = GearImages:FindFirstChild("Invisibility Mushroom");
v32.IMG = v33 and v33.Value or "";
v32.Worlds = { "Main" };
local v34 = {
    ItemName = "Teleporter",
    ItemType = "Teleporter",
    RestockChance = 3,
    Cost = 60000,
    Rarity = "Legendary",
    HideFromShop = true,
    RestockValues = NumberRange.new(1, 3)
};
local Teleporter = GearImages:FindFirstChild("Teleporter");
v34.IMG = Teleporter and Teleporter.Value or "";
local v35 = {
    ItemName = "Legendary Pet Teleporter",
    ItemType = "PetTeleporter",
    Rarity = "Legendary",
    HideFromShop = true
};
local v36 = GearImages:FindFirstChild("Legendary Pet Teleporter");
v35.IMG = v36 and v36.Value or "";
local v37 = {
    ItemName = "Mythic Pet Teleporter",
    ItemType = "PetTeleporter",
    Rarity = "Mythic",
    HideFromShop = true
};
local v38 = GearImages:FindFirstChild("Mythic Pet Teleporter");
v37.IMG = v38 and v38.Value or "";
local v39 = {
    ItemName = "Super Pet Teleporter",
    ItemType = "PetTeleporter",
    Rarity = "Super",
    HideFromShop = true
};
local v40 = GearImages:FindFirstChild("Super Pet Teleporter");
v39.IMG = v40 and v40.Value or "";
local v41 = {
    ItemName = "Super Watering Can",
    ItemType = "Watering Can",
    RestockChance = 2,
    Cost = 1000000,
    Rarity = "Super",
    RestockValues = NumberRange.new(1, 2)
};
local v42 = GearImages:FindFirstChild("Super Watering Can");
v41.IMG = v42 and v42.Value or "";
v41.Worlds = { "Main" };
local v43 = {
    ItemName = "Basic Pot",
    ItemType = "EmptyPot",
    RestockChance = 7,
    Cost = 300000,
    Rarity = "Epic",
    RestockValues = NumberRange.new(1, 3)
};
local v44 = GearImages:FindFirstChild("Basic Pot");
v43.IMG = v44 and v44.Value or "";
v43.Worlds = { "Main" };
local v45 = {
    ItemName = "Flashbang",
    ItemType = "Flashbang",
    RestockChance = 7,
    Cost = 20000,
    Rarity = "Epic",
    IMG = "rbxassetid://137760243645491",
    RestockValues = NumberRange.new(4, 7),
    Worlds = { "Main" }
};
local v46 = {
    ItemName = "Bull Horn",
    ItemType = "BullHorn",
    Cost = 800000,
    EquippableGear = true,
    Rarity = "Rare"
};
local v47 = GearImages:FindFirstChild("Bull Horn");
v46.IMG = v47 and v47.Value or "";
v46.Worlds = { "FallHarvest" };
local v48 = {
    ItemName = "Player Magnet",
    ItemType = "Player Magnet",
    Cost = 7000000,
    EquippableGear = true,
    Rarity = "Mythic"
};
local v49 = GearImages:FindFirstChild("Player Magnet");
v48.IMG = v49 and v49.Value or "";
v48.Worlds = { "Main" };
local v50 = {
    ItemName = "Rare Magic Mail",
    ItemType = "MagicMail",
    RestockChance = 7,
    Cost = 500000,
    Rarity = "Rare",
    RestockValues = NumberRange.new(1, 2)
};
local v51 = GearImages:FindFirstChild("Rare Magic Mail");
v50.IMG = v51 and v51.Value or "";
v50.Worlds = { "FallHarvest" };
local v52 = {
    ItemName = "Legendary Magic Mail",
    ItemType = "MagicMail",
    RestockChance = 1,
    Cost = 5000000,
    Rarity = "Legendary",
    RestockValues = NumberRange.new(1, 1)
};
local v53 = GearImages:FindFirstChild("Legendary Magic Mail");
v52.IMG = v53 and v53.Value or "";
v52.Worlds = { "FallHarvest" };
local v54 = {
    ItemName = "Super Magic Mail",
    ItemType = "MagicMail",
    RestockChance = 0.015,
    Cost = 100000000,
    Rarity = "Super",
    RestockValues = NumberRange.new(1, 1)
};
local v55 = GearImages:FindFirstChild("Super Magic Mail");
v54.IMG = v55 and v55.Value or "";
v54.Worlds = { "FallHarvest" };
local v56 = {
    ItemName = "Syrup Sprinkler",
    ItemType = "Common Sprinkler",
    RestockChance = 50,
    Cost = 3000,
    Rarity = "Common",
    RestockValues = NumberRange.new(1, 2)
};
local v57 = GearImages:FindFirstChild("Syrup Sprinkler");
v56.IMG = v57 and v57.Value or "";
v56.Worlds = { "FallHarvest" };
v4[17], v4[18], v4[19], v4[20], v4[21], v4[22], v4[23], v4[24], v4[25], v4[26], v4[27], v4[28], v4[29], v4[30], v4[31], v4[32] = v28, v30, v32, v34, v35, v37, v39, v41, v43, v45, v46, v48, v50, v52, v54, v56;
local v58 = {
    ItemName = "Super Syrup Sprinkler",
    ItemType = "Super Sprinkler",
    RestockChance = 1.2,
    Cost = 300000,
    Rarity = "Super",
    RestockValues = NumberRange.new(1, 2)
};
local v59 = GearImages:FindFirstChild("Super Syrup Sprinkler");
v58.IMG = v59 and v59.Value or "";
v58.Worlds = { "FallHarvest" };
local v60 = {
    ItemName = "Syrup Watering Can",
    ItemType = "Watering Can",
    RestockChance = 90,
    Cost = 2000,
    Rarity = "Common",
    RestockValues = NumberRange.new(2, 5)
};
local v61 = GearImages:FindFirstChild("Syrup Watering Can");
v60.IMG = v61 and v61.Value or "";
v60.Worlds = { "FallHarvest" };
local v62 = {
    ItemName = "Super Syrup Watering Can",
    ItemType = "Watering Can",
    RestockChance = 2,
    Cost = 1000000,
    Rarity = "Super",
    RestockValues = NumberRange.new(1, 2)
};
local v63 = GearImages:FindFirstChild("Super Syrup Watering Can");
v62.IMG = v63 and v63.Value or "";
v62.Worlds = { "FallHarvest" };
v4[33], v4[34], v4[35] = v58, v60, v62;
u3.Data = v4;

function u3.LocalizeGearName(p64) -- Line: 496
    -- upvalues: u3 (copy), Worlds (copy)
    local v65 = nil;

    for _, v in u3.Data do
        if v.ItemName == p64 then
            v65 = v;
            break;
        end;
    end;

    if v65 == nil then
        return nil;
    end;

    if Worlds.EntryAvailableHere(v65) then
        return p64;
    end;

    for _, v in u3.Data do
        if v.ItemType == v65.ItemType and (v.Rarity == v65.Rarity and Worlds.EntryAvailableHere(v)) then
            return v.ItemName;
        end;
    end;

    return nil;
end;

return u3;