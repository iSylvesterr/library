-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local DropTable = require(ReplicatedStorage.Library.DropTable);
local CurrencyItem = require(ReplicatedStorage.Library.Items.CurrencyItem);
local Currency = require(ReplicatedStorage.Library.Types.Currency);
local Items = require(ReplicatedStorage.Library.Items);
local AllCurrencyTypes = Currency.AllCurrencyTypes;

return {
    DisplayName = "Spinny Wheel!",
    ItemCooldown = 57600,
    RequiredItem = CurrencyItem(AllCurrencyTypes.SpinnyWheelTickets),
    Weights = { 50, 34, 8.5, 5, 1.5, 1 },
    DropTable = {
        DropTable.new({
            {
                Weight = 50,
                Value = Items.Currency(AllCurrencyTypes.Money):SetAmount(250000)
            }
        }),
        DropTable.new({
            {
                Weight = 50,
                Value = Items.Currency(AllCurrencyTypes.Money):SetAmount(1000000)
            }
        }),
        DropTable.new({
            {
                Weight = 50,
                Value = Items.Currency(AllCurrencyTypes.Money):SetAmount(5000000)
            }
        }),
        DropTable.new({
            {
                Weight = 50,
                Value = Items.Currency(AllCurrencyTypes.Money):SetAmount(5000000)
            }
        }),
        DropTable.new({
            {
                Weight = 50,
                Value = Items.Currency(AllCurrencyTypes.Money):SetAmount(5000000)
            }
        }),
        DropTable.new({
            {
                Weight = 50,
                Value = Items.Currency(AllCurrencyTypes.Money):SetAmount(5000000)
            }
        })
    }
};