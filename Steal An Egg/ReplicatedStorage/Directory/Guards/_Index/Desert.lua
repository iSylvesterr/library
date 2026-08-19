-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local BuildConfig = require(script.Parent.Parent.BuildConfig);
local Rarities = require(ReplicatedStorage.Directory.Rarity).Rarities;
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local DefaultAnimationConfigLooped = require(script.Parent.Parent.BaseConfigs.DefaultAnimationConfigLooped);

return BuildConfig({
    WalkSpeed = 62,
    HitDistance = 4,
    HomeImpulseBoostDistanceXZ = 130,
    Rarity = Rarities.Rare,
    SleepAnimation = Pipeline:GetAndSerializeAnimation("rbxassetid://91477377508559", DefaultAnimationConfigLooped),
    IdleAnimation = Pipeline:GetAndSerializeAnimation("rbxassetid://85777917853482", DefaultAnimationConfigLooped),
    WalkAnimation = Pipeline:GetAndSerializeAnimation("rbxassetid://73290619201848", DefaultAnimationConfigLooped),
    AttackAnimation = Pipeline:GetAndSerializeAnimation("rbxassetid://132047161476745"),
    FootstepSound = {
        SoundId = "rbxassetid://137682861871003",
        Volume = 1.5,
        MaxDistance = 60,
        PlaybackSpeed = 1,
        Looped = true
    }
});