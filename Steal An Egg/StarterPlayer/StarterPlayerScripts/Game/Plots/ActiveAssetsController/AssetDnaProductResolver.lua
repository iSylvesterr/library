-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Assets = require(ReplicatedStorage.Directory.Assets);
local AssetItem = require(ReplicatedStorage.Library.Types.AssetItem);
local Products = require(ReplicatedStorage.Directory.Products);

return {
    GetProductId = function(p1) -- Line: 18, Name: GetProductId
        -- upvalues: AssetItem (copy), Assets (copy), Products (copy)
        assert(AssetItem.AssetItemData(p1));
        local _id = Assets.Directory[p1.Category].Rarity._id;

        for _, v in pairs(Products.Directory) do
            if v.StealRarity == _id then
                return v.ProductId;
            end;
        end;

        return nil;
    end
};