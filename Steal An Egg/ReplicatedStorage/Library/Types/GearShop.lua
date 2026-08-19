-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Gears = require(ReplicatedStorage.Directory.Gears);

return {
    Catalog = (function(p1) -- Line: 25, Name: buildCatalog
        local v2 = {};

        for i, v in pairs(p1) do
            if v.DisplayInShop ~= false and v.EventShopType == nil then
                v2[i] = true;
            end;
        end;

        return table.freeze(v2);
    end)(Gears.Directory),
    CatalogEntries = (function(p3) -- Line: 36, Name: buildCatalogEntries
        local v4 = {};

        for i, v in pairs(p3) do
            if v.DisplayInShop ~= false and v.EventShopType == nil then
                v4[#v4 + 1] = table.freeze({
                    Name = i,
                    Cost = v.MoneyCost or 0,
                    Config = v
                });
            end;
        end;

        table.sort(v4, function(p5, p6) -- Line: 49
            if p5.Cost == p6.Cost then
                return p5.Name < p6.Name;
            end;

            return p5.Cost < p6.Cost;
        end);

        return table.freeze(v4);
    end)(Gears.Directory)
};