-- Decompiled with Potassium's decompiler.

local u1 = {
    SUBSTEP = 0.016666666666666666,
    MAX_SUBSTEPS = 3
};

local function windAccel(p2, p3, p4, p5, p6) -- Line: 23
    local v7 = p2 * 3 - p4;
    local v8 = p2 * 8.1 - p4 * 1.6;
    local v9 = (math.noise(v7, p5) + 0.5 * math.noise(v8, p5 + 37.1)) * p3;
    local v10 = (math.noise(v7, p6) + 0.5 * math.noise(v8, p6 + 37.1)) * p3;

    return Vector3.new(v9, 0, v10);
end;

function u1.step(p11, p12, p13, p14, p15, p16) -- Line: 37
    -- upvalues: u1 (copy), windAccel (copy)
    local v17 = p14._lastH or p15;
    p14._lastH = p15;
    local v18 = 1 - (p14._damping or 0);

    if p15 ~= u1.SUBSTEP and (v18 < 1 and v18 > 0) then
        v18 = v18 ^ (p15 / u1.SUBSTEP);
    end;

    local v19 = v18 * (p15 / v17);
    local _gravity = p14._gravity;
    local v20 = p14._windAmp or 0;
    local v21 = p14._pinStart ~= false;
    local _pinEnd = p14._pinEnd;

    for i = v21 and 2 or 1, _pinEnd and p13 and p13 or p13 + 1 do
        local v22 = p11[i];
        local v23;

        if v20 == 0 then
            v23 = _gravity;
        else
            v23 = _gravity + windAccel((i - 1) / p13, v20, p16, p14._windSeedA, p14._windSeedB);
        end;

        p11[i] = v22 + (v22 - p12[i]) * v19 + v23 * (p15 * p15);
        p12[i] = v22;
    end;

    local v24 = p14._restLenEff or p14._restLen;
    local v25 = p14._bendStiffness or 0;

    for _ = 1, p14._stiffness or 4 do
        for i = 1, p13 do
            local v26 = p11[i];
            local v27 = p11[i + 1];
            local v28 = v27 - v26;
            local Magnitude = v28.Magnitude;

            if Magnitude > 1e-6 then
                local v29 = v28 * ((Magnitude - v24) / Magnitude);
                local v30;

                if v21 then
                    v30 = i == 1;
                else
                    v30 = v21;
                end;

                local v31;

                if _pinEnd then
                    v31 = i + 1 == p13 + 1;
                else
                    v31 = _pinEnd;
                end;

                if v30 then
                    if not v31 then
                        p11[i + 1] = v27 - v29;
                    end;
                elseif v31 then
                    p11[i] = v26 + v29;
                else
                    local v32 = v29 * 0.5;
                    p11[i] = v26 + v32;
                    p11[i + 1] = v27 - v32;
                end;
            end;
        end;

        if v25 > 0 then
            local v33 = v25 * 0.5;

            for i = 2, p13 do
                p11[i] = p11[i] + ((p11[i - 1] + p11[i + 1]) * 0.5 - p11[i]) * v33;
            end;
        end;
    end;
end;

function u1.translate(p34, p35, p36, p37) -- Line: 109
    for i = 1, p36 + 1 do
        p34[i] = p34[i] + p37;
        p35[i] = p35[i] + p37;
    end;
end;

function u1.calm(p38, p39, p40) -- Line: 117
    for i = 1, p40 + 1 do
        p39[i] = p38[i];
    end;
end;

return u1;