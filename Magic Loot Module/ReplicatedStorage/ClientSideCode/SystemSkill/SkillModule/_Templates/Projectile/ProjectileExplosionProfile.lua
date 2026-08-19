-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local FXUtil = UtilsSystem.FXUtil;
local SoundModule = UtilsSystem.SoundModule;

local function resolvePath(p1, p2) -- Line: 18
    if not (p1 and p2) then
        return nil;
    end;

    for _, v in ipairs(p2) do
        p1 = p1:FindFirstChild(v);

        if not p1 then
            return nil;
        end;
    end;

    return p1;
end;

return {
    create = function(p3) -- Line: 40, Name: create
        -- upvalues: SoundModule (copy), FXUtil (copy)
        local u4 = p3.projectileResName or "普攻魔法弹";
        local u5 = p3.explosionResName or "普攻爆炸";
        local u6 = p3.explosionLightResName or "普攻爆炸灯";
        local onProjectileExplodeVisual = p3.onProjectileExplodeVisual;
        local _ = p3.resolveExplosionLight;
        local stopProjectileFX = p3.stopProjectileFX;
        local playExplosionFX = p3.playExplosionFX;
        local _ = p3.explosionLightPath;
        local _ = p3.explosionLightOffset or Vector3.new(0, 2, 0);
        local expSound = p3.expSound;

        return {
            EXPLOSION_HITBOX_SIZE = Vector3.new(10, 10, 10),
            EXPLOSION_TWEEN_TIME = 0.1,

            playExplosion = function(p7, p8) -- Line: 52, Name: playExplosion
                -- upvalues: u4 (copy), u5 (copy), u6 (copy), onProjectileExplodeVisual (copy), SoundModule (ref), expSound (copy), playExplosionFX (copy), FXUtil (ref), stopProjectileFX (copy)
                local skillRunData = p7.skillRunData;
                local v9 = skillRunData.material and skillRunData.material[u4];
                local v10 = skillRunData.material and skillRunData.material[u5];
                local v11 = skillRunData.material and skillRunData.material[u6];

                if type(onProjectileExplodeVisual) == "function" then
                    if p8 then
                        p8 = p8.Position;
                    end;

                    onProjectileExplodeVisual(p7, v9, p8);

                    return;
                end;

                if not (v9 and (v10 and v11)) then
                    warn("[ProjectileExplosionProfile] 爆炸素材缺失（需 projectile / explosion / explosionLight 资源名对应 material）");

                    return;
                end;

                v10.Parent = workspace.Debris;
                SoundModule:PlaySoundLocal({
                    Is2D = false,
                    SoundName = expSound,
                    PlayPosition = p8.Position
                });
                v10:PivotTo(p8);

                if type(playExplosionFX) == "function" then
                    playExplosionFX(v10);
                else
                    FXUtil.Emit_Particles_GetDescendants(v10, true);
                end;

                if type(stopProjectileFX) == "function" then
                    stopProjectileFX(v9);

                    return;
                end;

                FXUtil.Stop_All_Emit(v9);

                for _, descendant in pairs(v9:GetDescendants()) do
                    if descendant:IsA("ParticleEmitter") then
                        descendant.Enabled = false;
                    end;
                end;
            end
        };
    end
};