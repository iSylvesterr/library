-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local BuildConfig = require(script.Parent.Parent.BuildConfig);
local Rarities = require(ReplicatedStorage.Directory.Rarity).Rarities;
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local DefaultAnimationConfigLooped = require(script.Parent.Parent.BaseConfigs.DefaultAnimationConfigLooped);

return BuildConfig({
    WalkSpeed = 35,
    HitDistance = 3,
    HomeImpulseBoostDistanceXZ = 100,
    Rarity = Rarities.Uncommon,
    SleepAnimation = Pipeline:GetAndSerializeAnimation("rbxassetid://119006758941979", DefaultAnimationConfigLooped),
    IdleAnimation = Pipeline:GetAndSerializeAnimation("rbxassetid://113947385873952", DefaultAnimationConfigLooped),
    WalkAnimation = Pipeline:GetAndSerializeAnimation("rbxassetid://136832792656489", DefaultAnimationConfigLooped),
    AttackAnimation = Pipeline:GetAndSerializeAnimation("rbxassetid://106848729969940"),
    FootstepSound = {
        SoundId = "rbxassetid://84639143672331",
        Volume = 1.5,
        MaxDistance = 60,
        PlaybackSpeed = 1,
        Looped = true
    }
});