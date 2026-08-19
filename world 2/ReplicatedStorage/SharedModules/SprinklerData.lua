-- Decompiled with Potassium's decompiler.

local GearImages = script.Parent.GearImages;

local function getGearImage(p1) -- Line: 2
    -- upvalues: GearImages (copy)
    local v2 = GearImages:FindFirstChild(p1);

    return v2 and v2.Value or "";
end;

local v3 = {};
local v4 = {
    SprinklerName = "Common Sprinkler",
    SizeLuckBonus = 7,
    GrowSpeedBonus = 1.5,
    Lifetime = 120,
    Radius = 20,
    ReviveRate = 0.01
};
local v5 = GearImages:FindFirstChild("Common Sprinkler");
v4.Image = v5 and v5.Value or "";
local v6 = {
    SprinklerName = "Uncommon Sprinkler",
    SizeLuckBonus = 21,
    GrowSpeedBonus = 2,
    Lifetime = 120,
    Radius = 25,
    ReviveRate = 0.014285714285714285
};
local v7 = GearImages:FindFirstChild("Uncommon Sprinkler");
v6.Image = v7 and v7.Value or "";
local v8 = {
    SprinklerName = "Rare Sprinkler",
    SizeLuckBonus = 40,
    GrowSpeedBonus = 3,
    Lifetime = 120,
    Radius = 30,
    ReviveRate = 0.025
};
local v9 = GearImages:FindFirstChild("Rare Sprinkler");
v8.Image = v9 and v9.Value or "";
local v10 = {
    SprinklerName = "Legendary Sprinkler",
    SizeLuckBonus = 65,
    GrowSpeedBonus = 4,
    Lifetime = 120,
    Radius = 40,
    ReviveRate = 0.05
};
local v11 = GearImages:FindFirstChild("Legendary Sprinkler");
v10.Image = v11 and v11.Value or "";
local v12 = {
    SprinklerName = "Super Sprinkler",
    SizeLuckBonus = 100,
    GrowSpeedBonus = 5,
    Lifetime = 120,
    Radius = 55,
    ReviveRate = 0.1
};
local v13 = GearImages:FindFirstChild("Super Sprinkler");
v12.Image = v13 and v13.Value or "";
local v14 = {
    SprinklerName = "Syrup Sprinkler",
    SizeLuckBonus = 7,
    GrowSpeedBonus = 1.5,
    Lifetime = 120,
    Radius = 20,
    ReviveRate = 0.01
};
local v15 = GearImages:FindFirstChild("Syrup Sprinkler");
v14.Image = v15 and v15.Value or "";
local v16 = {
    SprinklerName = "Super Syrup Sprinkler",
    SizeLuckBonus = 100,
    GrowSpeedBonus = 5,
    Lifetime = 120,
    Radius = 55,
    ReviveRate = 0.1
};
local v17 = GearImages:FindFirstChild("Super Syrup Sprinkler");
v16.Image = v17 and v17.Value or "";
v3[1], v3[2], v3[3], v3[4], v3[5], v3[6], v3[7] = v4, v6, v8, v10, v12, v14, v16;

return v3;