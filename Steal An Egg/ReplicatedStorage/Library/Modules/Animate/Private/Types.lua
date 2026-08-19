-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local t = require(ReplicatedStorage.Library.Modules.Packages.t);

return {
    configureAnimationSetParameters = t.tuple(t.table, t.union(t.string, t.table)),
    playAnimationConfig = t.tuple(t.string, t.optional(t.number), t.optional(t.number), t.optional(t.number), t.optional(t.union(t.table, t.string)))
};