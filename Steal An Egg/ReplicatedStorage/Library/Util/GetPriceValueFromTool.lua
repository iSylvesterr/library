-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local GetPriceValueForItem = require(script.Parent.GetPriceValueForItem);
local Asserts = require(ReplicatedStorage.Library.Asserts);

return function(p1) -- Line: 11
    -- upvalues: Asserts (copy), GetPriceValueForItem (copy)
    Asserts.Tool(p1);
    local v2 = p1:GetAttribute("Category");
    local v3 = p1:GetAttribute("Mutations");
    local v4 = p1:GetAttribute("Scale");
    local v5 = p1:GetAttribute("IsFavorite");

    if v2 == nil or (v3 == nil or v4 == nil) then
        return 0;
    end;

    local v6 = {};

    for i in string.gmatch(v3, "[^,]+") do
        local v7 = string.gsub(i, "^%s*(.-)%s*$", "%1");
        table.insert(v6, v7);
    end;

    return GetPriceValueForItem({
        Category = v2,
        Mutations = v6,
        Scale = v4,
        IsFavorite = v5 == true
    });
end;