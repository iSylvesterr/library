-- Decompiled with Potassium's decompiler.

local v1 = { "Box", "Currency", "Pet", "Egg", "Lootbox", "Charm", "Ultimate", "Enchant", "XPPotion", "Potion", "Misc", "Hoverboard", "Booth", "Fruit", "Seed", "Page" };
local v2 = {};

for i, v in ipairs(v1) do
    v2[v] = i;
end;

return {
    Order = v2,
    OrderInv = v1
};