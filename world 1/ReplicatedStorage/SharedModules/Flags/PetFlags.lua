-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local v1 = FastFlags.Replicated("Game.Pets.HugeSizeDisplayLabel", Asserts.String, "Mega");
local v2 = FastFlags.Replicated("Game.Pets.BasePriceOverrides", Asserts.Map(Asserts.String, Asserts.FiniteNonNegative), {});
local v3 = FastFlags.Replicated("Game.Pets.SellPriceMultiplier", Asserts.FiniteNonNegative, 0.5);
local v4 = FastFlags.Replicated("Game.Pets.SellPriceMultiplierOverrides", Asserts.Map(Asserts.String, Asserts.FiniteNonNegative), {});
local v5 = FastFlags.Replicated("Game.Pets.Bear.AttackSpeed", Asserts.FinitePositive, 18);
local v6 = FastFlags.Replicated("Game.Pets.Bear.HoldDuration", Asserts.FinitePositive, 2);
local v7 = FastFlags.Replicated("Game.Pets.Dog.AttackSpeed", Asserts.FinitePositive, 20.7);
local v8 = FastFlags.Replicated("Game.Pets.Dog.StunDuration", Asserts.FinitePositive, 2);
local v9 = FastFlags.Replicated("Game.Pets.Hedgehog.AttackSpeed", Asserts.FinitePositive, 18);
local v10 = FastFlags.Replicated("Game.Pets.Hedgehog.StunDuration", Asserts.FinitePositive, 2);
local v11 = FastFlags.Replicated("Game.Pets.Hedgehog.KnockbackDistanceMultipliers", Asserts.Map(Asserts.String, Asserts.FiniteNonNegative), {
    Normal = 1,
    Big = 1.3,
    Huge = 1.7
});
local v12 = FastFlags.Replicated("Game.Pets.Butterfly.GrowthBoostPerEquipped", Asserts.FiniteNonNegative, 0.03);
local v13 = FastFlags.Replicated("Game.Pets.BaldEagle.Cooldown", Asserts.FiniteNonNegative, 10);
local v14 = FastFlags.Replicated("Game.Pets.Firefly.PlantSizeBonusPerEquipped", Asserts.FiniteNonNegative, 0.01);
local v15 = FastFlags.Replicated("Game.Pets.Firefly.MaxPlantSizeBonus", Asserts.FiniteNonNegative, 0.5);
local v16 = FastFlags.Replicated("Game.Pets.Squirrel.HarvestSpeedMultiplier", Asserts.FinitePositive, 2);
local v17 = FastFlags.Replicated("Game.Pets.JandelMonkey.IntervalSecondsBySize", Asserts.Map(Asserts.String, Asserts.FinitePositive), {
    Normal = 900,
    Big = 720,
    Huge = 540
});
local v18 = FastFlags.Replicated("Game.Pets.JandelMonkey.ServerCooldownSeconds", Asserts.FiniteNonNegative, 600);
local v19 = FastFlags.Replicated("Game.Pets.ShadowDragon.VeilChance", Asserts.Range(0, 1), 0.05);
local v20 = FastFlags.Replicated("Game.Pets.Swan.SpitChancePerSecond", Asserts.FiniteNonNegative, 0.01);
local v21 = FastFlags.Replicated("Game.Pets.Swan.SpitCooldownSeconds", Asserts.FiniteNonNegative, 5);
local v22 = FastFlags.Replicated("Game.Pets.Swan.SpitSpotDistanceBySize", Asserts.Map(Asserts.String, Asserts.FinitePositive), {
    Normal = 5,
    Big = 9,
    Huge = 15
});
local v23 = FastFlags.Replicated("Game.Pets.Swan.SplashRadiusBySize", Asserts.Map(Asserts.String, Asserts.FinitePositive), {
    Normal = 5,
    Big = 7.5,
    Huge = 10
});
local v24 = FastFlags.Replicated("Game.Pets.Swan.EffectivenessMultiplierBySize", Asserts.Map(Asserts.String, Asserts.FiniteNonNegative), {
    Normal = 0.5,
    Big = 1,
    Huge = 1.5
});
local v25 = FastFlags.Replicated("Game.Pets.Swan.StandingDurationSeconds", Asserts.FiniteNonNegative, 3);
local v26 = FastFlags.Replicated("Game.Pets.Swan.ParticleOnDelaySeconds", Asserts.FiniteNonNegative, 0.6);
local v27 = FastFlags.Replicated("Game.Pets.Swan.ParticleDurationSeconds", Asserts.FiniteNonNegative, 1.5);

return table.freeze({
    HugeSizeDisplayLabel = v1,
    BasePriceOverrides = v2,
    SellPriceMultiplier = v3,
    SellPriceMultiplierOverrides = v4,
    BearAttackSpeed = v5,
    BearHoldDuration = v6,
    DogAttackSpeed = v7,
    DogStunDuration = v8,
    HedgehogAttackSpeed = v9,
    HedgehogStunDuration = v10,
    HedgehogKnockbackDistanceByType = v11,
    ButterflyGrowthBoostPerEquipped = v12,
    BaldEagleCooldown = v13,
    FireflyPlantSizeBonusPerEquipped = v14,
    FireflyMaxPlantSizeBonus = v15,
    SquirrelHarvestSpeedMultiplier = v16,
    JandelMonkeyIntervalSecondsBySize = v17,
    JandelMonkeyServerCooldownSeconds = v18,
    ShadowDragonVeilChance = v19,
    SwanSpitChancePerSecond = v20,
    SwanSpitCooldownSeconds = v21,
    SwanSpitSpotDistanceBySize = v22,
    SwanSplashRadiusBySize = v23,
    SwanEffectivenessMultiplierBySize = v24,
    SwanStandingDurationSeconds = v25,
    SwanParticleOnDelaySeconds = v26,
    SwanParticleDurationSeconds = v27
});