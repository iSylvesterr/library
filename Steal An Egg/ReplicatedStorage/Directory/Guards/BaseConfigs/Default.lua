-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
require(script.Parent.Parent.Types.Interface);
local DefaultAnimationConfigLooped = require(script.Parent.DefaultAnimationConfigLooped);

return {
    FlatRadius = 20,
    WalkSpeed = 18,
    HomeImpulseBoostDistanceXZ = 70,
    Rarity = Rarity.Rarities.Common,
    IdleAnimation = Pipeline:GetAndSerializeAnimation("rbxassetid://71674550993364", DefaultAnimationConfigLooped),
    WalkAnimation = Pipeline:GetAndSerializeAnimation("rbxassetid://80429517663629", DefaultAnimationConfigLooped),
    SleepAnimation = Pipeline:GetAndSerializeAnimation("rbxassetid://79297169387271", DefaultAnimationConfigLooped),
    AttackAnimation = Pipeline:GetAndSerializeAnimation("rbxassetid://81558105939037"),
    SleepSound = {
        SoundId = "rbxassetid://129416806869914",
        Volume = 0.800000011920929,
        MaxDistance = 40,
        PlaybackSpeed = 1,
        Looped = false
    },
    WakeSound = {
        SoundId = "rbxassetid://96595477884583",
        Volume = 0.30000001192092896,
        MaxDistance = 250.48046875,
        PlaybackSpeed = 1.0700000524520874,
        Looped = false
    },
    AttackSound = {
        SoundId = "rbxassetid://76766635785020",
        Volume = 2,
        MaxDistance = 150,
        PlaybackSpeed = 1.0700000524520874,
        Looped = false
    },
    FootstepSound = {
        SoundId = "rbxassetid://89709728610870",
        Volume = 1.5,
        MaxDistance = 74.38033294677734,
        PlaybackSpeed = 1.0700000524520874,
        Looped = false
    }
};