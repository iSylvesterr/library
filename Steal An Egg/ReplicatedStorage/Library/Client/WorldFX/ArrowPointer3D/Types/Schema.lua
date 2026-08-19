-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local t = require(ReplicatedStorage.Library.Modules.Packages.t);
local v1 = {};
local v2 = {
    Amplitude = t.optional(t.number),
    Radius = t.optional(t.number),
    Blink = t.optional(t.boolean),
    Highlight = t.optional(t.boolean),
    RotationSpeed = t.optional(t.number),
    CleanupOnPartDestroyed = t.optional(t.boolean),
    OscillationSpeed = t.optional(t.number),
    BlinkFrequency = t.optional(t.number),
    ProximityThreshold = t.optional(t.number),
    OriginOffset = t.optional(t.Vector3),
    TargetOffset = t.optional(t.Vector3),
    Color = t.optional(t.Color3)
};
v1.Config = t.interface(v2);
v1.OptionalConfig = t.optional(t.interface(v2));

return v1;