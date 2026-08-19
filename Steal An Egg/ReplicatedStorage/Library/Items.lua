-- Decompiled with Potassium's decompiler.

local AbstractItem = require(script.AbstractItem);
local Container = require(script.Container);
local Types = require(script.Types);
local v1 = {
    Root = AbstractItem,
    All = AbstractItem,
    Types = {
        Currency = require(script.CurrencyItem),
        Gear = require(script.GearItem),
        Brainrot = require(script.BrainrotItem),
        SpeedPower = require(script.SpeedPowerItem)
    },
    Container = Container,
    TypeUnchecked = Types.TypeUnchecked,
    Type = Types.Type,
    FromModule = Types.FromModule,
    From = Types.From,
    AssertModule = AbstractItem.AssertModule,
    AssertUID = AbstractItem.AssertUID,
    AssertOptionalUID = AbstractItem.AssertOptionalUID,
    AssertUIDFast = AbstractItem.AssertUIDFast,
    AssertOptionalUIDFast = AbstractItem.AssertOptionalUIDFast,
    GenerateUID = AbstractItem.GenerateUID,
    AssertOrGenerateUID = AbstractItem.AssertOrGenerateUID,
    AssertUniqueItems = AbstractItem.AssertUniqueItems,
    Nil = AbstractItem.Nil
};
setmetatable(v1, {
    __index = v1.Types
});

return v1;