-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local BuildConfig = require(script.Parent.Parent.BuildConfig);
local Rarities = require(ReplicatedStorage.Directory.Rarity).Rarities;
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local DefaultAnimationConfigLooped = require(script.Parent.Parent.BaseConfigs.DefaultAnimationConfigLooped);

return BuildConfig({
    WalkSpeed = 130,
    HitDistance = 5,
    EggPickupDistance = 18,
    AnimationBaseWalkSpeed = 17,
    HomeImpulseBoostDistanceXZ = 250,
    Rarity = Rarities.Cosmic,
    SleepAnimation = Pipeline:GetAndSerializeAnimation("rbxassetid://79122874973512", DefaultAnimationConfigLooped),
    IdleAnimation = Pipeline:GetAndSerializeAnimation("rbxassetid://102403705437382", DefaultAnimationConfigLooped),
    WalkAnimation = Pipeline:GetAndSerializeAnimation("rbxassetid://128961185865478", DefaultAnimationConfigLooped),
    AttackAnimation = Pipeline:GetAndSerializeAnimation("rbxassetid://138307614547337"),
    AfterWakeSound = { {
            SoundId = "rbxassetid://109513647043767",
            Volume = 5,
            MaxDistance = 250.48046875,
            PlaybackSpeed = 1,
            Looped = false
        }, {
            SoundId = "rbxassetid://112789890097920",
            Volume = 5,
            MaxDistance = 250.48046875,
            PlaybackSpeed = 1,
            Looped = false
        } },
    AttackSound = {
        SoundId = "rbxassetid://100308696101952",
        Volume = 2,
        MaxDistance = 150,
        PlaybackSpeed = 1.0700000524520874,
        Looped = false
    }
});