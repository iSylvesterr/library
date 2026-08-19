-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local t = require(ReplicatedStorage.Library.Modules.Packages.t);

return {
    UpdateModifiers = t.tuple(t.union(t.string, t.table), t.map(t.string, t.table))
};