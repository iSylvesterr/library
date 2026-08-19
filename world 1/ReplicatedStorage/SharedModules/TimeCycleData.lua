-- Decompiled with Potassium's decompiler.

local Worlds = require(script.Parent.Worlds);
local v1 = {};
local v2 = {
    Main = {
        Moon = {
            Chance = 79,
            Image = "rbxassetid://91446334780160",
            Color = Color3.new(0.117647, 0.278431, 0.580392)
        },
        Bloodmoon = {
            Chance = 2,
            Image = "rbxassetid://140465339393451",
            Color = Color3.new(0.509804, 0, 0)
        },
        Goldmoon = {
            Chance = 13,
            Image = "rbxassetid://84902063004871",
            Color = Color3.new(1, 0.866667, 0)
        },
        ["Rainbow Moon"] = {
            Chance = 6,
            Image = "rbxassetid://93602895495056",
            Color = Color3.new(0.65098, 0.0941176, 1)
        },
        ["Mega Moon"] = {
            Chance = 2,
            Image = "rbxassetid://107925838920918",
            Color = Color3.new(0, 0, 1)
        }
    },
    FallHarvest = {
        Moon = {
            Chance = 79,
            Image = "rbxassetid://91446334780160",
            Color = Color3.new(0.117647, 0.278431, 0.580392)
        },
        Bloodmoon = {
            Chance = 2,
            Image = "rbxassetid://140465339393451",
            Color = Color3.new(0.509804, 0, 0)
        },
        Goldmoon = {
            Chance = 13,
            Image = "rbxassetid://84902063004871",
            Color = Color3.new(1, 0.866667, 0)
        },
        ["Rainbow Moon"] = {
            Chance = 6,
            Image = "rbxassetid://93602895495056",
            Color = Color3.new(0.65098, 0.0941176, 1)
        },
        ["Harvest Moon"] = {
            Chance = 4,
            Image = "rbxassetid://133267062078756",
            Color = Color3.fromRGB(214, 122, 38)
        }
    }
};
local v3 = v2[Worlds.Current.MoonTable or "Main"] or v2.Main;
v1.Data = {
    Day = {
        Lasts = 450,
        StartOrder = 1,
        Weathers = {
            Day = {
                Chance = 100,
                Image = "rbxassetid://100486757307207",
                Color = Color3.new(1, 0.882353, 0)
            }
        }
    },
    Sunset = {
        Lasts = 30,
        StartOrder = 2,
        Weathers = {
            Sunset = {
                Chance = 100,
                Image = "rbxassetid://86217612022586",
                Color = Color3.new(1, 0.894118, 0.352941)
            }
        }
    },
    Night = {
        Lasts = 120,
        StartOrder = 3,
        Weathers = v3
    }
};

return v1;