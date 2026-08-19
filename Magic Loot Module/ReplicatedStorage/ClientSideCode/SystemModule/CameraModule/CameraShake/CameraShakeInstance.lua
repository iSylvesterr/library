-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local new = Vector3.new;
local noise = math.noise;
u1.CameraShakeState = {
    FadingIn = 0,
    FadingOut = 1,
    Sustained = 2,
    Inactive = 3
};

function u1.new(p2, p3, p4, p5, p6) -- Line: 40
    -- upvalues: new (copy), u1 (copy)
    local v7 = p4 or 0;
    local v8 = p5 or 0;
    local v9 = type(p2) == "number";
    assert(v9, "Magnitude must be a number");
    local v10 = type(p3) == "number";
    assert(v10, "Roughness must be a number");
    local v11 = type(v7) == "number";
    assert(v11, "FadeInTime must be a number");
    local v12 = type(v8) == "number";
    assert(v12, "FadeOutTime must be a number");

    if p6 ~= nil then
        local v13 = type(p6) == "number";
        assert(v13, "TickSeed must be a number");
    end;

    if type(p6) ~= "number" then
        p6 = Random.new():NextNumber(-100, 100);
    end;

    local v14 = {
        roughMod = 1,
        magnMod = 1,
        DeleteOnInactive = true,
        _camShakeInstance = true,
        Magnitude = p2,
        Roughness = p3,
        PositionInfluence = new(),
        RotationInfluence = new(),
        fadeOutDuration = v8,
        fadeInDuration = v7,
        sustain = v7 > 0,
        currentFadeTime = v7 > 0 and 0 or 1,
        tick = p6
    };

    return setmetatable(v14, u1);
end;

function u1.UpdateShake(p15, p16) -- Line: 92
    -- upvalues: noise (copy), new (copy)
    local tick = p15.tick;
    local currentFadeTime = p15.currentFadeTime;
    local v17 = new(noise(tick, 0) * 0.5, noise(0, tick) * 0.5, noise(tick, tick) * 0.5);

    if p15.fadeInDuration > 0 and p15.sustain then
        if currentFadeTime < 1 then
            currentFadeTime = currentFadeTime + p16 / p15.fadeInDuration;
        elseif p15.fadeOutDuration > 0 then
            p15.sustain = false;
        end;
    end;

    if not p15.sustain then
        currentFadeTime = p15.fadeOutDuration <= 0 and 0 or currentFadeTime - p16 / p15.fadeOutDuration;
    end;

    if p15.sustain then
        p15.tick = tick + p16 * p15.Roughness * p15.roughMod;
    else
        p15.tick = tick + p16 * p15.Roughness * p15.roughMod * currentFadeTime;
    end;

    p15.currentFadeTime = currentFadeTime;

    return v17 * p15.Magnitude * p15.magnMod * currentFadeTime;
end;

function u1.StartFadeOut(p18, p19) -- Line: 140
    if p19 == 0 then
        p18.currentFadeTime = 0;
    end;

    p18.fadeOutDuration = p19;
    p18.fadeInDuration = 0;
    p18.sustain = false;
end;

function u1.StartFadeIn(p20, p21) -- Line: 154
    if p21 == 0 then
        p20.currentFadeTime = 1;
    end;

    p20.fadeInDuration = p21 or p20.fadeInDuration;
    p20.fadeOutDuration = 0;
    p20.sustain = true;
end;

function u1.GetScaleRoughness(p22) -- Line: 168
    return p22.roughMod;
end;

function u1.SetScaleRoughness(p23, p24) -- Line: 177
    p23.roughMod = p24;
end;

function u1.GetScaleMagnitude(p25) -- Line: 186
    return p25.magnMod;
end;

function u1.SetScaleMagnitude(p26, p27) -- Line: 195
    p26.magnMod = p27;
end;

function u1.GetNormalizedFadeTime(p28) -- Line: 204
    return p28.currentFadeTime;
end;

function u1.IsShaking(p29) -- Line: 213
    return p29.currentFadeTime > 0 and true or p29.sustain;
end;

function u1.IsFadingOut(p30) -- Line: 222
    return not p30.sustain and p30.currentFadeTime > 0;
end;

function u1.IsFadingIn(p31) -- Line: 231
    local v32;

    if p31.currentFadeTime < 1 then
        v32 = p31.sustain and p31.fadeInDuration > 0;
    else
        v32 = false;
    end;

    return v32;
end;

function u1.GetState(p33) -- Line: 240
    -- upvalues: u1 (copy)
    if p33:IsFadingIn() then
        return u1.CameraShakeState.FadingIn;
    end;

    if p33:IsFadingOut() then
        return u1.CameraShakeState.FadingOut;
    end;

    if p33:IsShaking() then
        return u1.CameraShakeState.Sustained;
    end;

    return u1.CameraShakeState.Inactive;
end;

return u1;