-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local BuildConfig = require(script.Parent.Parent.BuildConfig);
local Rarities = require(ReplicatedStorage.Directory.Rarity).Rarities;
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local TableUtil = require(ReplicatedStorage.Library.Modules.Packages.TableUtil);
local DefaultAnimationConfigLooped = require(script.Parent.Parent.BaseConfigs.DefaultAnimationConfigLooped);
TableUtil.Copy(DefaultAnimationConfigLooped, true).Play = { 0.6 };

return BuildConfig({
    WalkSpeed = 16,
    HitDistance = 2.5,
    AnimationBaseWalkSpeed = 4,
    HomeImpulseBoostDistanceXZ = 70,
    Rarity = Rarities.Common,
    SleepAnimation = Pipeline:GetAndSerializeAnimation("rbxassetid://130139384582356", DefaultAnimationConfigLooped),
    IdleAnimation = Pipeline:GetAndSerializeAnimation("rbxassetid://139122582247217", DefaultAnimationConfigLooped),
    WalkAnimation = Pipeline:GetAndSerializeAnimation("rbxassetid://139560613766322", DefaultAnimationConfigLooped),
    AttackAnimation = Pipeline:GetAndSerializeAnimation("rbxassetid://108528350206370"),
    AfterWakeSound = {
        SoundId = "rbxassetid://129675339394681",
        Volume = 5,
        MaxDistance = 250.48046875,
        PlaybackSpeed = 1,
        Looped = false
    },
    AttackSound = {
        SoundId = "rbxassetid://119910675891317",
        Volume = 2,
        MaxDistance = 150,
        PlaybackSpeed = 1.0700000524520874,
        Looped = false
    },
    FootstepSound = {
        SoundId = "rbxassetid://77569052979374",
        Volume = 1.5,
        MaxDistance = 60,
        PlaybackSpeed = 1,
        Looped = true
    }
});