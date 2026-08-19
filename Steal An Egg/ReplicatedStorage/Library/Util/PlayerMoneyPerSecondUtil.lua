-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local AssetGenerationUtil = require(ReplicatedStorage.Library.Util.AssetGenerationUtil);
local AssetItemSerialization = require(ReplicatedStorage.Library.Util.AssetItemSerialization);

return {
    GetTotalForProfile = function(p1, p2) -- Line: 17, Name: GetTotalForProfile
        -- upvalues: AssetItemSerialization (copy), AssetGenerationUtil (copy)
        local Inventory = p2.Inventory;
        local EquippedAssets = p2.EquippedAssets;

        if typeof(Inventory) ~= "table" or typeof(EquippedAssets) ~= "table" then
            return 0;
        end;

        local v3 = typeof(p2.Rebirth) ~= "number" and 0 or p2.Rebirth;
        local v4;

        if typeof(p2.Gamepasses) == "table" then
            v4 = p2.Gamepasses;
        else
            v4 = nil;
        end;

        local v5;

        if typeof(p2.Products) == "table" then
            v5 = p2.Products;
        else
            v5 = nil;
        end;

        local v6 = 0;

        for _, v in ipairs(EquippedAssets) do
            local v7 = Inventory[v];

            if typeof(v7) == "table" then
                local v8 = AssetItemSerialization.Deserialize(v7);
                local v9 = AssetGenerationUtil.GetRate(v8, v3, v4, v5);
                v6 = v6 + math.max(v9, 0);
            end;
        end;

        return v6;
    end
};