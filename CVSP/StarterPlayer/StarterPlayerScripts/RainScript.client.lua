-- Decompiled with Potassium's decompiler.

local Rain = require(script.Rain);
Rain:SetColor(Color3.fromRGB(script.Color.Value.x, script.Color.Value.y, script.Color.Value.z));
Rain:SetDirection(script.Direction.Value);
Rain:SetTransparency(script.Transparency.Value);
Rain:SetSpeedRatio(script.SpeedRatio.Value);
Rain:SetIntensityRatio(script.IntensityRatio.Value);
Rain:SetLightInfluence(script.LightInfluence.Value);
Rain:SetLightEmission(script.LightEmission.Value);
Rain:SetVolume(script.Volume.Value);
Rain:SetSoundId(script.SoundId.Value);
Rain:SetStraightTexture(script.StraightTexture.Value);
Rain:SetTopDownTexture(script.TopDownTexture.Value);
Rain:SetSplashTexture(script.SplashTexture.Value);
local Value = script.TransparencyThreshold.Value;

if script.TransparencyConstraint.Value and script.CanCollideConstraint.Value then
    Rain:SetCollisionMode(Rain.CollisionMode.Function, function(p1) -- Line: 24
        -- upvalues: Value (copy)
        local v2;

        if p1.Transparency <= Value then
            v2 = p1.CanCollide;
        else
            v2 = false;
        end;

        return v2;
    end);
elseif script.TransparencyConstraint.Value then
    Rain:SetCollisionMode(Rain.CollisionMode.Function, function(p3) -- Line: 31
        -- upvalues: Value (copy)
        return p3.Transparency <= Value;
    end);
elseif script.CanCollideConstraint.Value then
    Rain:SetCollisionMode(Rain.CollisionMode.Function, function(p4) -- Line: 38
        return p4.CanCollide;
    end);
end;

Rain:Disable();