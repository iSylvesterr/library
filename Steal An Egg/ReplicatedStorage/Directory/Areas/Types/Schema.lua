-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local t = require(ReplicatedStorage.Library.Modules.Packages.t);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v2 = {
    AreaNameExists = function(p1) -- Line: 13
        error("unimplemented");
    end,

    AssetDropTableEntry = t.array(t.union(t.string, t.number))
};
v2.AreaConfig = t.interface({
    _id = t.string,
    DisplayName = t.string,
    Emoji = t.string,
    Icon = t.string,
    DropTable = t.array(v2.AssetDropTableEntry),
    GuardId = t.string,
    IndexBatGearId = t.string,
    Rarity = Rarity.Types.DefaultConfig
});

return v2;