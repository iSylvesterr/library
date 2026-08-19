-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local t = require(ReplicatedStorage.Library.Modules.Packages.t);
local v1 = {
    SlapControllerProfile = t.interface({
        Duration = t.number,
        Force = t.number,
        BrainrotDamage = t.number,
        MaxBrainrotTargets = t.optional(t.number)
    })
};
v1.SlapControllerData = t.interface({
    Player = v1.SlapControllerProfile,
    Brainrot = v1.SlapControllerProfile,
    PlayerCooldown = t.optional(t.number),
    MobCooldown = t.optional(t.number)
});

return v1;