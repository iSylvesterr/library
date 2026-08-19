-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local t = require(ReplicatedStorage.Library.Modules.Packages.t);

return {
    StartConfig = t.strictInterface({
        trackedPart = t.optional(t.instanceIsA("BasePart")),
        trackedPartResolver = t.optional(t.callback),
        targetPart = t.optional(t.instanceIsA("BasePart")),
        targetPartResolver = t.optional(t.callback),
        proximitySoundDistance = t.optional(t.number),
        chaseSoundDistance = t.optional(t.number),
        proximityMinDistance = t.optional(t.number),
        baseFieldOfView = t.optional(t.number)
    })
};