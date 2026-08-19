-- Decompiled with Potassium's decompiler.

local GearImages = script.Parent.GearImages;

local function getGearImage(p1) -- Line: 3
    -- upvalues: GearImages (copy)
    local v2 = GearImages:FindFirstChild(p1);

    return v2 and v2.Value or "";
end;

local v3 = {};
local v4 = {
    RakeName = "Rake",
    Lifetime = 600,
    Cooldown = 3,
    Radius = 7,
    FlingMultiplier = 1,
    Scale = 1
};
local Rake = GearImages:FindFirstChild("Rake");
v4.Image = Rake and Rake.Value or "";
local v5 = {
    RakeName = "Big Rake",
    Lifetime = 600,
    Cooldown = 3,
    Radius = 10.5,
    FlingMultiplier = 2,
    Scale = 1.5
};
local v6 = GearImages:FindFirstChild("Big Rake");
v5.Image = v6 and v6.Value or "";
local v7 = {
    RakeName = "Mega Rake",
    Lifetime = 600,
    Cooldown = 3,
    Radius = 21,
    FlingMultiplier = 3,
    Scale = 3
};
local v8 = GearImages:FindFirstChild("Mega Rake");
v7.Image = v8 and v8.Value or "";
v3[1], v3[2], v3[3] = v4, v5, v7;

return v3;