-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local t = require(ReplicatedStorage.Library.Modules.Packages.t);

return {
    SprinklerItemData = t.strictInterface({
        Position = t.Vector3,
        Remaining = t.number,
        Category = t.string
    }),
    SerializedSprinklerItemData = t.strictInterface({
        Position = t.array(t.number),
        Remaining = t.number,
        Category = t.string
    })
};