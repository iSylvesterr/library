-- Decompiled with Potassium's decompiler.

local FenceImages = script.Parent.FenceImages;

local function getFenceImage(p1) -- Line: 3
    -- upvalues: FenceImages (copy)
    local v2 = FenceImages:FindFirstChild(p1);

    return v2 and v2.Value or "";
end;

local v3 = {};
local v4 = {};
local v5 = {
    PropName = "Default"
};
local Default = FenceImages:FindFirstChild("Default");
v5.IMG = Default and Default.Value or "";
local v6 = {
    PropName = "Rainbow"
};
local Rainbow = FenceImages:FindFirstChild("Rainbow");
v6.IMG = Rainbow and Rainbow.Value or "";
local v7 = {
    PropName = "Cupid"
};
local Cupid = FenceImages:FindFirstChild("Cupid");
v7.IMG = Cupid and Cupid.Value or "";
local v8 = {
    PropName = "Wood"
};
local Wood = FenceImages:FindFirstChild("Wood");
v8.IMG = Wood and Wood.Value or "";
local v9 = {
    PropName = "Bamboo"
};
local Bamboo = FenceImages:FindFirstChild("Bamboo");
v9.IMG = Bamboo and Bamboo.Value or "";
local v10 = {
    PropName = "Lantern"
};
local Lantern = FenceImages:FindFirstChild("Lantern");
v10.IMG = Lantern and Lantern.Value or "";
local v11 = {
    PropName = "Stone"
};
local Stone = FenceImages:FindFirstChild("Stone");
v11.IMG = Stone and Stone.Value or "";
local v12 = {
    PropName = "Light"
};
local Light = FenceImages:FindFirstChild("Light");
v12.IMG = Light and Light.Value or "";
local v13 = {
    PropName = "Futuristic"
};
local Futuristic = FenceImages:FindFirstChild("Futuristic");
v13.IMG = Futuristic and Futuristic.Value or "";
local v14 = {
    PropName = "Spike"
};
local Spike = FenceImages:FindFirstChild("Spike");
v14.IMG = Spike and Spike.Value or "";
local v15 = {
    PropName = "Flower"
};
local Flower = FenceImages:FindFirstChild("Flower");
v15.IMG = Flower and Flower.Value or "";
local v16 = {
    PropName = "Star"
};
local Star = FenceImages:FindFirstChild("Star");
v16.IMG = Star and Star.Value or "";
local v17 = {
    PropName = "White"
};
local White = FenceImages:FindFirstChild("White");
v17.IMG = White and White.Value or "";
local v18 = {
    PropName = "Stick"
};
local Stick = FenceImages:FindFirstChild("Stick");
v18.IMG = Stick and Stick.Value or "";
local v19 = {
    PropName = "Pole"
};
local Pole = FenceImages:FindFirstChild("Pole");
v19.IMG = Pole and Pole.Value or "";
v4[1], v4[2], v4[3], v4[4], v4[5], v4[6], v4[7], v4[8], v4[9], v4[10], v4[11], v4[12], v4[13], v4[14], v4[15] = v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19;
v3.Data = v4;

return v3;