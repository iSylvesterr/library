-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Assets = require(ReplicatedStorage.Directory.Assets);

return table.freeze({
    FromAssetCategory = function(p1) -- Line: 18, Name: FromAssetCategory
        -- upvalues: Asserts (copy), Assets (copy)
        Asserts.string(p1);
        local v2 = Assets.Directory[p1];
        local v3 = `Missing asset config {p1}`;
        assert(v2 ~= nil, v3);

        return v2.Rarity.RarityNumber;
    end
});