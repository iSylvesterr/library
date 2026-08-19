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
    Name = "Invisibility Mushroom",
    LastTime = 30,
    Description = "Go Invisible"
};
local v6 = GearImages:FindFirstChild("Invisibility Mushroom");
v5.IMG = v6 and v6.Value or "";
v5.Color = Color3.new(0.666667, 0.666667, 0.666667);
local v7 = {
    Name = "Jump Mushroom",
    LastTime = 60,
    Description = "+5 Jump Power"
};
local v8 = GearImages:FindFirstChild("Jump Mushroom");
v7.IMG = v8 and v8.Value or "";
v7.Color = Color3.new(0, 0.666667, 1);
local v9 = {
    Name = "Shrink Mushroom",
    LastTime = 45,
    Description = "X0.75 Size"
};
local v10 = GearImages:FindFirstChild("Shrink Mushroom");
v9.IMG = v10 and v10.Value or "";
v9.Color = Color3.new(1, 0.4, 0.8);
local v11 = {
    Name = "Speed Mushroom",
    LastTime = 60,
    Description = "+5 Speed"
};
local v12 = GearImages:FindFirstChild("Speed Mushroom");
v11.IMG = v12 and v12.Value or "";
v11.Color = Color3.new(0.811765, 0.12549, 0.14902);
local v13 = {
    Name = "Supersize Mushroom",
    LastTime = 45,
    Description = "X1.25 Size"
};
local v14 = GearImages:FindFirstChild("Supersize Mushroom");
v13.IMG = v14 and v14.Value or "";
v13.Color = Color3.new(0.419608, 0.196078, 0.486275);
v4[1], v4[2], v4[3], v4[4], v4[5] = v5, v7, v9, v11, v13;
v3.Data = v4;

return v3;