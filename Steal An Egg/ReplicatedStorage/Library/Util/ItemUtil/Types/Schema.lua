-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local t = require(ReplicatedStorage.Library.Modules.Packages.t);
local Currency = require(ReplicatedStorage.Library.Types.Currency);

return {
    AvailableCurrencies = Currency.SchemaValidation.AllCurrencyTypes,
    Item = t.interface({
        Currency = Currency.SchemaValidation.AllCurrencyTypes,
        Amount = t.optional(t.number)
    }),
    FullItem = t.interface({
        Currency = Currency.SchemaValidation.AllCurrencyTypes,
        Amount = t.number
    })
};