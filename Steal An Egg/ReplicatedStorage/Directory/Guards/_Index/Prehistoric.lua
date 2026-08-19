-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local BuildConfig = require(script.Parent.Parent.BuildConfig);
local Rarities = require(ReplicatedStorage.Directory.Rarity).Rarities;
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local DefaultAnimationConfigLooped = require(script.Parent.Parent.BaseConfigs.DefaultAnimationConfigLooped);

return BuildConfig({
    WalkSpeed = 152,
    HitDistance = 5,
    EggPickupDistance = 18,
    AnimationBaseWalkSpeed = 30,
    HomeImpulseBoostDistanceXZ = 275,
    Rarity = Rarities.Secret,
    SleepAnimation = Pipeline:GetAndSerializeAnimation("rbxassetid://133422374459463", DefaultAnimationConfigLooped),
    IdleAnimation = Pipeline:GetAndSerializeAnimation("rbxassetid://85804925095766", DefaultAnimationConfigLooped),
    WalkAnimation = Pipeline:GetAndSerializeAnimation("rbxassetid://117274313338090", DefaultAnimationConfigLooped),
    AttackAnimation = Pipeline:GetAndSerializeAnimation("rbxassetid://72819921043071"),
    SleepSound = {
        SoundId = "rbxassetid://129416806869914",
        Volume = 0,
        MaxDistance = 107.4382553100586,
        PlaybackSpeed = 1,
        Looped = false
    },
    AfterWakeSound = {
        SoundId = "rbxassetid://75664314250862",
        Volume = 5,
        MaxDistance = 250.48046875,
        PlaybackSpeed = 1,
        Looped = false
    },
    AttackSound = {
        SoundId = "rbxassetid://95116072506206",
        Volume = 4,
        MaxDistance = 300,
        PlaybackSpeed = 1,
        Looped = false
    },
    FootstepSound = {
        SoundId = "rbxassetid://86392397661742",
        Volume = 1.5,
        MaxDistance = 60,
        PlaybackSpeed = 1,
        Looped = true
    }
});