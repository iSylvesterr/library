-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local t = require(ReplicatedStorage.Library.Modules.Packages.t);
local DropTable = require(ReplicatedStorage.Library.DropTable);
local CurrencyItem = require(ReplicatedStorage.Library.Items.CurrencyItem);

return {
    AllWheelNames = t.union(t.literal("BasicWheel")),
    DefaultConfig = t.interface({
        DisplayName = t.string,
        RequiredItem = CurrencyItem:WrapForTCheck(),
        ItemCooldown = t.number,
        Weights = t.array(t.number),
        DropTable = t.array(DropTable.IsDropTable)
    })
};