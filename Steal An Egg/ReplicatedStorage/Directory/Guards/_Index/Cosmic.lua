-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local BuildConfig = require(script.Parent.Parent.BuildConfig);
local Rarities = require(ReplicatedStorage.Directory.Rarity).Rarities;
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local DefaultAnimationConfigLooped = require(script.Parent.Parent.BaseConfigs.DefaultAnimationConfigLooped);

return BuildConfig({
    WalkSpeed = 200,
    HitDistance = 4,
    AnimationBaseWalkSpeed = 28,
    HomeImpulseBoostDistanceXZ = 300,
    Rarity = Rarities.Eternal,
    SleepAnimation = Pipeline:GetAndSerializeAnimation("rbxassetid://124788456180750", DefaultAnimationConfigLooped),
    IdleAnimation = Pipeline:GetAndSerializeAnimation("rbxassetid://120083284147768", DefaultAnimationConfigLooped),
    WalkAnimation = Pipeline:GetAndSerializeAnimation("rbxassetid://103226370812076", DefaultAnimationConfigLooped),
    AttackAnimation = Pipeline:GetAndSerializeAnimation("rbxassetid://73187024208060"),
    AfterWakeSound = { {
            SoundId = "rbxassetid://135419634519147",
            Volume = 5,
            MaxDistance = 250.48046875,
            PlaybackSpeed = 1,
            Looped = false
        }, {
            SoundId = "rbxassetid://136805444765117",
            Volume = 5,
            MaxDistance = 250.48046875,
            PlaybackSpeed = 1,
            Looped = false
        } },
    AttackSound = {
        SoundId = "rbxassetid://103435959847699",
        Volume = 2,
        MaxDistance = 150,
        PlaybackSpeed = 1.0700000524520874,
        Looped = false
    },
    FootstepSound = {
        SoundId = "rbxassetid://85892053481113",
        Volume = 1.5,
        MaxDistance = 60,
        PlaybackSpeed = 1,
        Looped = true
    }
});