-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local BuildConfig = require(script.Parent.Parent.BuildConfig);
local Rarities = require(ReplicatedStorage.Directory.Rarity).Rarities;
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local DefaultAnimationConfigLooped = require(script.Parent.Parent.BaseConfigs.DefaultAnimationConfigLooped);

return BuildConfig({
    WalkSpeed = 82,
    HitDistance = 3,
    AnimationBaseWalkSpeed = 14,
    HomeImpulseBoostDistanceXZ = 160,
    Rarity = Rarities.Epic,
    SleepAnimation = Pipeline:GetAndSerializeAnimation("rbxassetid://80254440617270", DefaultAnimationConfigLooped),
    IdleAnimation = Pipeline:GetAndSerializeAnimation("rbxassetid://129822945034773", DefaultAnimationConfigLooped),
    WalkAnimation = Pipeline:GetAndSerializeAnimation("rbxassetid://102697421744284", DefaultAnimationConfigLooped),
    AttackAnimation = Pipeline:GetAndSerializeAnimation("rbxassetid://137152617410120"),
    AfterWakeSound = { {
            SoundId = "rbxassetid://110971572672011",
            Volume = 5,
            MaxDistance = 250.48046875,
            PlaybackSpeed = 1,
            Looped = false
        }, {
            SoundId = "rbxassetid://71105135143267",
            Volume = 5,
            MaxDistance = 250.48046875,
            PlaybackSpeed = 1,
            Looped = false
        } },
    AttackSound = {
        SoundId = "rbxassetid://127853591688222",
        Volume = 2,
        MaxDistance = 150,
        PlaybackSpeed = 1.0700000524520874,
        Looped = false
    },
    FootstepSound = {
        SoundId = "rbxassetid://95492669493151",
        Volume = 1.5,
        MaxDistance = 60,
        PlaybackSpeed = 1,
        Looped = true
    }
});