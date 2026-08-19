-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;

function u1.new(p2, p3) -- Line: 75
    -- upvalues: u1 (copy)
    local v4 = p2 or 0;
    local v5 = p3 or os.clock;
    local v6 = {
        _damper = 1,
        _speed = 1,
        _clock = v5,
        _time0 = v5(),
        _position0 = v4,
        _velocity0 = 0 * v4,
        _target = v4
    };

    return setmetatable(v6, u1);
end;

function u1.Impulse(p7, p8) -- Line: 100
    p7.Velocity = p7.Velocity + p8;
end;

function u1.TimeSkip(p9, p10) -- Line: 109
    local v11 = p9._clock();
    local v12, v13 = p9:_positionVelocity(v11 + p10);
    p9._position0 = v12;
    p9._velocity0 = v13;
    p9._time0 = v11;
end;

function u1.SetTarget(p14, p15, p16) -- Line: 123
    if not p16 then
        p14.Target = p15;

        return;
    end;

    local v17 = p14._clock();
    p14._position0 = p15;
    p14._velocity0 = 0 * p15;
    p14._target = p15;
    p14._time0 = v17;
end;

function u1.__index(p18, p19) -- Line: 216
    -- upvalues: u1 (copy)
    if u1[p19] then
        return u1[p19];
    end;

    if p19 == "Value" or (p19 == "Position" or p19 == "p") then
        local v20, _ = p18:_positionVelocity(p18._clock());

        return v20;
    end;

    if p19 == "Velocity" or p19 == "v" then
        local _, v21 = p18:_positionVelocity(p18._clock());

        return v21;
    end;

    if p19 == "Target" or p19 == "t" then
        return p18._target;
    end;

    if p19 == "Damper" or p19 == "d" then
        return p18._damper;
    end;

    if p19 == "Speed" or p19 == "s" then
        return p18._speed;
    end;

    if p19 == "Clock" then
        return p18._clock;
    end;

    error(string.format("%q is not a valid member of Spring", (tostring(p19))), 2);
end;

function u1.__newindex(p22, p23, p24) -- Line: 238
    local v25 = p22._clock();

    if p23 == "Value" or (p23 == "Position" or p23 == "p") then
        local _, v26 = p22:_positionVelocity(v25);
        p22._position0 = p24;
        p22._velocity0 = v26;
        p22._time0 = v25;

        return;
    end;

    if p23 == "Velocity" or p23 == "v" then
        local v27, _ = p22:_positionVelocity(v25);
        p22._position0 = v27;
        p22._velocity0 = p24;
        p22._time0 = v25;

        return;
    end;

    if p23 == "Target" or p23 == "t" then
        local v28, v29 = p22:_positionVelocity(v25);
        p22._position0 = v28;
        p22._velocity0 = v29;
        p22._target = p24;
        p22._time0 = v25;

        return;
    end;

    if p23 == "Damper" or p23 == "d" then
        local v30, v31 = p22:_positionVelocity(v25);
        p22._position0 = v30;
        p22._velocity0 = v31;
        p22._damper = p24;
        p22._time0 = v25;

        return;
    end;

    if p23 == "Speed" or p23 == "s" then
        local v32, v33 = p22:_positionVelocity(v25);
        p22._position0 = v32;
        p22._velocity0 = v33;
        p22._speed = p24 < 0 and 0 or p24;
        p22._time0 = v25;

        return;
    end;

    if p23 ~= "Clock" then
        error(string.format("%q is not a valid member of Spring", (tostring(p23))), 2);

        return;
    end;

    local v34, v35 = p22:_positionVelocity(v25);
    p22._position0 = v34;
    p22._velocity0 = v35;
    p22._clock = p24;
    p22._time0 = p24();
end;

function u1._positionVelocity(p36, p37) -- Line: 280
    local _position0 = p36._position0;
    local _velocity0 = p36._velocity0;
    local _target = p36._target;
    local _damper = p36._damper;
    local _speed = p36._speed;
    local v38 = _speed * (p37 - p36._time0);
    local v39 = _damper * _damper;
    local v40, v41, v42;

    if v39 < 1 then
        v40 = math.sqrt(1 - v39);
        local v43 = math.exp(-_damper * v38) / v40;
        v41 = v43 * math.cos(v40 * v38);
        v42 = v43 * math.sin(v40 * v38);
    elseif v39 == 1 then
        v40 = 1;
        v41 = math.exp(-_damper * v38) / v40;
        v42 = v41 * v38;
    else
        v40 = math.sqrt(v39 - 1);
        local v44 = math.exp((-_damper + v40) * v38) / (2 * v40);
        local v45 = math.exp((-_damper - v40) * v38) / (2 * v40);
        v41 = v44 + v45;
        v42 = v44 - v45;
    end;

    return (v40 * v41 + _damper * v42) * _position0 + (1 - (v40 * v41 + _damper * v42)) * _target + v42 / _speed * _velocity0, -_speed * v42 * _position0 + _speed * v42 * _target + (v40 * v41 - _damper * v42) * _velocity0;
end;

return u1;