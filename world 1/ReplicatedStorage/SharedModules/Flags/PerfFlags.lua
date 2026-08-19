-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local v1 = FastFlags.Replicated("Game.Perf.Client.AgeUpdateMaxHz", Asserts.FinitePositive, 60);
local v2 = FastFlags.Replicated("Game.Perf.Client.MutationVFXDisabled", Asserts.Boolean, false);
local v3 = FastFlags.Replicated("Game.Perf.Client.DroppedItemAnimationsDisabled", Asserts.Boolean, false);
local v4 = FastFlags.Replicated("Game.Perf.Client.AnimatedGradientsDisabled", Asserts.Boolean, false);
local v5 = FastFlags.Replicated("Game.Perf.Client.PlantVisualizerBudget", Asserts.FinitePositive, 75);
local v6 = FastFlags.Replicated("Game.Perf.Client.MutationColorPopulationBaseHz", Asserts.FinitePositive, 60);
local v7 = FastFlags.Replicated("Game.Perf.Client.MutationColorPopulationFloorHz", Asserts.FinitePositive, 2);
local v8 = FastFlags.Replicated("Game.Perf.Client.MutationColorNearDistance", Asserts.FinitePositive, 100);
local v9 = FastFlags.Replicated("Game.Perf.Client.MutationColorFarDistance", Asserts.FinitePositive, 300);
local v10 = FastFlags.Replicated("Game.Perf.Client.MutationColorMidIntervalMultiplier", Asserts.FinitePositive, 4);
local v11 = FastFlags.Replicated("Game.Perf.Client.MutationColorOffscreenCulling", Asserts.Boolean, true);
local v12 = FastFlags.Replicated("Game.Perf.Client.PlantCulling.ManualRangeDisabled", Asserts.Boolean, true);
local v13 = FastFlags.Replicated("Game.Perf.Client.AutoQuality.Enabled", Asserts.Boolean, true);
local v14 = FastFlags.Replicated("Game.Perf.Client.AutoQuality.WindowSeconds", Asserts.FinitePositive, 10);
local v15 = FastFlags.Replicated("Game.Perf.Client.AutoQuality.DemoteWindows", Asserts.FinitePositive, 2);
local v16 = FastFlags.Replicated("Game.Perf.Client.AutoQuality.PromoteWindows", Asserts.FinitePositive, 30);
local v17 = FastFlags.Replicated("Game.Perf.Client.AutoQuality.BadFpsFraction", Asserts.FinitePositive, 0.6);
local v18 = FastFlags.Replicated("Game.Perf.Client.AutoQuality.GoodFpsFraction", Asserts.FinitePositive, 0.85);
local v19 = FastFlags.Replicated("Game.Perf.Client.AutoQuality.MinDwellSeconds", Asserts.FinitePositive, 120);

return table.freeze({
    AgeUpdateMaxHz = v1,
    MutationVFXDisabled = v2,
    DroppedItemAnimationsDisabled = v3,
    AnimatedGradientsDisabled = v4,
    PlantCullingManualRangeDisabled = v12,
    PlantVisualizerBudget = v5,
    MutationColorPopulationBaseHz = v6,
    MutationColorPopulationFloorHz = v7,
    MutationColorNearDistance = v8,
    MutationColorFarDistance = v9,
    MutationColorMidIntervalMultiplier = v10,
    MutationColorOffscreenCulling = v11,
    AutoQualityEnabled = v13,
    AutoQualityWindowSeconds = v14,
    AutoQualityDemoteWindows = v15,
    AutoQualityPromoteWindows = v16,
    AutoQualityBadFpsFraction = v17,
    AutoQualityGoodFpsFraction = v18,
    AutoQualityMinDwellSeconds = v19
});