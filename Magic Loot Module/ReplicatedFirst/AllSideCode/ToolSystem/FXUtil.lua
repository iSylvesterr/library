-- Decompiled with Potassium's decompiler.

local v1 = {};

for _, v in {
    script.ModelFade,
    script.NumberSequence,
    script.ParticleScale,
    script.VfxCache,
    script.ParticleEmit,
    script.ParticleControl,
    script.ModelScale,
    script.ModelTransform,
    script.ColorCorrection,
    script.TweenUtil,
    script.ObjectPool,
    script.EffectDestruction,
    script.Resource,
    script.PlayEffectPrep,
    script.SkillBuffDotVfx,
    script.PlayEffect,
    script.SkillSettle,
    script.GroundAlign,
    script.LayeredFade
} do
    require(v)(v1);
end;

v1.BezierCurve = require(script.BezierCurve);
v1.BurstStone = require(script.BurstStone);
v1.GhostShadow = require(script.GhostShadow);
v1.Lightning = require(script.Lightning);
v1.PartIcles = require(script.PartIcles);

return v1;