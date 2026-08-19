-- Decompiled with Potassium's decompiler.

local GearImages = script.Parent.GearImages;

local function getGearImage(p1) -- Line: 3
    -- upvalues: GearImages (copy)
    local v2 = GearImages:FindFirstChild(p1);

    return v2 and v2.Value or "";
end;

local v3 = {};
local v4 = {
    Name = "Common Watering Can",
    GrowthSpeedMultiplier = 3,
    EffectTime = 10,
    SplashRadius = 5
};
local v5 = GearImages:FindFirstChild("Common Watering Can");
v4.Image = v5 and v5.Value or "";
local v6 = {
    Name = "Super Watering Can",
    GrowthSpeedMultiplier = 300,
    EffectTime = 15,
    SplashRadius = 8,
    SuperTier = true
};
local v7 = GearImages:FindFirstChild("Super Watering Can");
v6.Image = v7 and v7.Value or "";
local v8 = {
    Name = "Syrup Watering Can",
    GrowthSpeedMultiplier = 3,
    EffectTime = 10,
    SplashRadius = 5
};
local v9 = GearImages:FindFirstChild("Syrup Watering Can");
v8.Image = v9 and v9.Value or "";
local v10 = {
    Name = "Super Syrup Watering Can",
    GrowthSpeedMultiplier = 300,
    EffectTime = 15,
    SplashRadius = 8,
    SuperTier = true
};
local v11 = GearImages:FindFirstChild("Super Syrup Watering Can");
v10.Image = v11 and v11.Value or "";
v3[1], v3[2], v3[3], v3[4] = v4, v6, v8, v10;

return v3;