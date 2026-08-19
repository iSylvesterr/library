-- Decompiled with Potassium's decompiler.

local u1 = {
    Scale = "rbxassetid://101135911625338",
    Mutations = "rbxassetid://134360845365275",
    Luck = "rbxassetid://95919886597863",
    Strength = "rbxassetid://126374550699444"
};
local u2 = {
    Scale = Color3.fromRGB(255, 0, 0),
    Mutations = Color3.fromRGB(0, 255, 255),
    Luck = Color3.fromRGB(0, 255, 0),
    Strength = Color3.fromRGB(255, 255, 0)
};
local u3 = {
    Scale = "Size Luck",
    Mutations = "Mutations Luck",
    Luck = "Poop Luck",
    Strength = "Push Strength"
};

return function(p4, p5, p6, p7) -- Line: 23
    -- upvalues: u1 (copy), u2 (copy), u3 (copy)
    local v8 = u1[p6];
    local v9 = "Invalid statsType: " .. tostring(p6);
    local v10 = assert(v8, v9);
    local v11 = u2[p6];
    local v12 = "Invalid statsType: " .. tostring(p6);
    local v13 = assert(v11, v12);
    local v14 = type(p7) == "number" and p7 < 0 and "" or "+";
    local v15 = u3[p6] or p6;
    p4.boost.TextColor3 = v13;
    p4.boost.Text = type(p7) == "string" and p7 and p7 or string.format(`{v14}%d%% %s`, p7, v15);
    p4.icon.Image = v10;
end;