-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local t = require(ReplicatedStorage.Library.Modules.Packages.t);
local Types = require(ReplicatedStorage.Directory.Animations.Pipeline.Private.Types);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local v2 = {
    GuardNameExists = function(p1) -- Line: 14
        error("unimplemented");
    end,

    SoundConfig = t.interface({
        SoundId = t.string,
        SoundIds = t.optional(t.array(t.string)),
        Volume = t.number,
        MaxDistance = t.number,
        PlaybackSpeed = t.optional(t.number),
        Looped = t.optional(t.boolean)
    })
};
v2.AfterWakeSoundConfig = t.union(v2.SoundConfig, t.array(v2.SoundConfig));
v2.DefaultConfig = t.interface({
    _id = t.string,
    Rarity = Rarity.Types.DefaultConfig,
    FlatRadius = t.number,
    WalkSpeed = t.number,
    HitDistance = t.optional(t.numberPositive),
    EggPickupDistance = t.optional(t.numberPositive),
    AnimationBaseWalkSpeed = t.optional(t.number),
    HomeImpulseBoostDistanceXZ = t.numberPositive,
    IdleAnimation = Types.SerializedAnimation,
    SleepAnimation = Types.SerializedAnimation,
    WalkAnimation = Types.SerializedAnimation,
    AttackAnimation = Types.SerializedAnimation,
    SleepSound = v2.SoundConfig,
    WakeSound = v2.SoundConfig,
    AfterWakeSound = t.optional(v2.AfterWakeSoundConfig),
    AttackSound = v2.SoundConfig,
    FootstepSound = t.optional(v2.SoundConfig)
});

return v2;