-- Decompiled with Potassium's decompiler.

local u1 = {};

function u1.new(p2) -- Line: 42
    -- upvalues: u1 (copy)
    local v3 = setmetatable({}, u1);
    local v4 = p2 or 0;
    rawset(v3, "_time0", tick());
    rawset(v3, "_position0", v4);
    rawset(v3, "_velocity0", 0 * v4);
    rawset(v3, "_target", v4);
    rawset(v3, "_damper", 1);
    rawset(v3, "_speed", 1);

    return v3;
end;

function u1.Impulse(p5, p6) -- Line: 58
    p5.Velocity = p5.Velocity + p6;
end;

function u1.Update(p7, p8) -- Line: 64
    local v9 = tick();
    local v10, v11 = p7:_positionVelocity(v9 + p8);
    rawset(p7, "_position0", v10);
    rawset(p7, "_velocity0", v11);
    rawset(p7, "_time0", v9);
end;

function u1.__index(p12, p13) -- Line: 72
    -- upvalues: u1 (copy)
    if u1[p13] then
        return u1[p13];
    end;

    if p13 == "Value" or (p13 == "Position" or p13 == "p") then
        local v14, _ = p12:_positionVelocity(tick());

        return v14;
    end;

    if p13 == "Velocity" or p13 == "v" then
        local _, v15 = p12:_positionVelocity(tick());

        return v15;
    end;

    if p13 == "Target" or p13 == "t" then
        return rawget(p12, "_target");
    end;

    if p13 == "Damper" or p13 == "d" then
        return rawget(p12, "_damper");
    end;

    if p13 == "Speed" or p13 == "s" then
        return rawget(p12, "_speed");
    end;

    error(("%q is not a valid member of Spring"):format((tostring(p13))), 2);
end;

function u1.__newindex(p16, p17, p18) -- Line: 92
    local v19 = tick();

    if p17 == "Value" or (p17 == "Position" or p17 == "p") then
        local _, v20 = p16:_positionVelocity(v19);
        rawset(p16, "_position0", p18);
        rawset(p16, "_velocity0", v20);
    elseif p17 == "Velocity" or p17 == "v" then
        local v21, _ = p16:_positionVelocity(v19);
        rawset(p16, "_position0", v21);
        rawset(p16, "_velocity0", p18);
    elseif p17 == "Target" or p17 == "t" then
        local v22, v23 = p16:_positionVelocity(v19);
        rawset(p16, "_position0", v22);
        rawset(p16, "_velocity0", v23);
        rawset(p16, "_target", p18);
    elseif p17 == "Damper" or p17 == "d" then
        local v24, v25 = p16:_positionVelocity(v19);
        rawset(p16, "_position0", v24);
        rawset(p16, "_velocity0", v25);
        local v26 = math.clamp(p18, 0, 1);
        rawset(p16, "_damper", v26);
    elseif p17 == "Speed" or p17 == "s" then
        local v27, v28 = p16:_positionVelocity(v19);
        rawset(p16, "_position0", v27);
        rawset(p16, "_velocity0", v28);
        rawset(p16, "_speed", p18 < 0 and 0 or p18);
    else
        error(("%q is not a valid member of Spring"):format((tostring(p17))), 2);
    end;

    rawset(p16, "_time0", v19);
end;

function u1._positionVelocity(p29, p30) -- Line: 125
    local v31 = p30 - rawget(p29, "_time0");
    local v32 = rawget(p29, "_position0");
    local v33 = rawget(p29, "_velocity0");
    local v34 = rawget(p29, "_target");
    local v35 = rawget(p29, "_damper");
    local v36 = rawget(p29, "_speed");
    local v37 = v32 - v34;

    if v36 == 0 then
        return v32, 0;
    end;

    if v35 >= 1 then
        local v38 = v33 / v36 + v37;
        local v39 = 2.718281828459045 ^ (v36 * v31);

        return v34 + (v37 + v38 * v36 * v31) / v39, v36 * (v38 - v37 - v38 * v36 * v31) / v39;
    end;

    local v40 = (1 - v35 * v35) ^ 0.5;
    local v41 = (v33 / v36 + v35 * v37) / v40;
    local v42 = math.cos(v40 * v36 * v31);
    local v43 = math.sin(v40 * v36 * v31);
    local v44 = 2.718281828459045 ^ (v35 * v36 * v31);

    return v34 + (v37 * v42 + v41 * v43) / v44, v36 * ((v40 * v41 - v35 * v37) * v42 - (v40 * v37 + v35 * v41) * v43) / v44;
end;

return u1;