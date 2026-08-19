-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local t = require(ReplicatedStorage.Library.Modules.Packages.t);
local Currency = require(ReplicatedStorage.Library.Types.Currency);
local v1 = {
    DespawnTime = 300,
    Types = {
        Orb = 1
    },
    OrbTypesInverse = { Currency.AllCurrencyTypes.Money },
    OrbTypes = {},
    SchemaValidation = {
        OrbSpec = t.interface({
            Type = t.optional(t.number),
            Index = t.optional(t.number),
            PickupDelay = t.optional(t.number)
        }),
        AllOrbTypes = t.union(t.literal(Currency.AllCurrencyTypes.Money))
    }
};

for i, v in v1.OrbTypesInverse do
    v1.OrbTypes[v] = i;
end;

return v1;