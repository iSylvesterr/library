-- Decompiled with Potassium's decompiler.

local GearImages = script.Parent.GearImages;

local function getGearImage(p1) -- Line: 3
    -- upvalues: GearImages (copy)
    local v2 = GearImages:FindFirstChild(p1);

    return v2 and v2.Value or "";
end;

local v3 = {};
local v4 = {};
local v5 = {
    Name = "Player Magnet",
    Description = "Suck nearby players toward you for 10 seconds!",
    Range = 30
};
local Magnet = GearImages:FindFirstChild("Magnet");
v5.IMG = Magnet and Magnet.Value or "";
local v6 = {
    Name = "Fruit Magnet",
    Description = "Show off the magnetic pulse effect for 10 seconds!",
    Range = 30
};
local v7 = GearImages:FindFirstChild("Fruit Magnet");
v6.IMG = v7 and v7.Value or "";
v4[1], v4[2] = v5, v6;
v3.Data = v4;

return v3;