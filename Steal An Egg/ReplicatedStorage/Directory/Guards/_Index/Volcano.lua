-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local BuildConfig = require(script.Parent.Parent.BuildConfig);
local Rarities = require(ReplicatedStorage.Directory.Rarity).Rarities;
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local DefaultAnimationConfigLooped = require(script.Parent.Parent.BaseConfigs.DefaultAnimationConfigLooped);

return BuildConfig({
    WalkSpeed = 113,
    HitDistance = 5,
    EggPickupDistance = 18,
    AnimationBaseWalkSpeed = 35,
    HomeImpulseBoostDistanceXZ = 220,
    Rarity = Rarities.Mythic,
    IdleAnimation = Pipeline:GetAndSerializeAnimation("rbxassetid://128670391346328", DefaultAnimationConfigLooped),
    SleepAnimation = Pipeline:GetAndSerializeAnimation("rbxassetid://106118773587652", DefaultAnimationConfigLooped),
    WalkAnimation = Pipeline:GetAndSerializeAnimation("rbxassetid://102298982391360", DefaultAnimationConfigLooped),
    AttackAnimation = Pipeline:GetAndSerializeAnimation("rbxassetid://86276843966778"),
    AfterWakeSound = { {
            SoundId = "rbxassetid://76753017038067",
            Volume = 5,
            MaxDistance = 250.48046875,
            PlaybackSpeed = 1,
            Looped = false
        }, {
            SoundId = "rbxassetid://122381958459272",
            Volume = 5,
            MaxDistance = 250.48046875,
            PlaybackSpeed = 1,
            Looped = false
        } },
    AttackSound = {
        SoundId = "rbxassetid://70850087419426",
        Volume = 2,
        MaxDistance = 150,
        PlaybackSpeed = 1.0700000524520874,
        Looped = false
    },
    FootstepSound = {
        SoundId = "rbxassetid://103736662890224",
        Volume = 1.5,
        MaxDistance = 60,
        PlaybackSpeed = 1,
        Looped = true
    }
});