-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local t = require(ReplicatedStorage.Library.Modules.Packages.t);
local v1 = {};
local v2 = {};
v1.SchemaValidation = v2;
v2.AllCurrencyTypes = t.union(t.literal("Money"), t.literal("SpinnyWheelTickets"));
v1.AllCurrencyTypes = {
    Money = "Money",
    SpinnyWheelTickets = "SpinnyWheelTickets"
};
v1.AllCurrencyTypesArray = { "Money", "SpinnyWheelTickets" };

return v1;