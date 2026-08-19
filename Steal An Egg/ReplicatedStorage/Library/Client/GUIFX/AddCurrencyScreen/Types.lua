-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local t = require(ReplicatedStorage.Library.Modules.Packages.t);

return {
    AvailableCurrencyWidgetsTypes = t.union(t.literal("Money"), t.literal("Speed"))
};