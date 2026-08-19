-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local t = require(ReplicatedStorage.Library.Modules.Packages.t);

return {
    SchemaValidation = t.interface({
        Magnitude = t.number,
        Roughness = t.number,
        FadeInTime = t.optional(t.number),
        FadeOutTime = t.optional(t.number),
        PosInfluence = t.optional(t.Vector3),
        RotInfluence = t.optional(t.Vector3)
    })
};