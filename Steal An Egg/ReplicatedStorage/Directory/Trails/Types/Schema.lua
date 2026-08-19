-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local t = require(ReplicatedStorage.Library.Modules.Packages.t);
local Rarity = require(ReplicatedStorage.Directory.Rarity);

return {
    TrailNameExists = function(p1) -- Line: 13
        error("unimplemented");
    end,

    DefaultConfig = t.interface({
        _id = t.string,
        Price = t.number,
        ProductId = t.optional(t.number),
        Icon = t.string,
        Rarity = Rarity.Types.DefaultConfig,
        SpeedMultiplier = t.number,
        DisplayInShop = t.optional(t.boolean),
        DisplayName = t.string
    })
};