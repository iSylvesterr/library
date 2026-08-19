-- Decompiled with Potassium's decompiler.

local u1 = {};

function Get(p2, p3, p4)
    -- upvalues: u1 (copy)
    local v5 = p3 == nil and "Sine" or (typeof(p3) == "string" and p3 and p3 or p3.Name);
    local v6 = p4 == nil and "Sine" or (typeof(p4) == "string" and p4 and p4 or p4.Name);

    if type(v5) ~= "string" then
        local v7 = tostring(v5);
        v5 = string.sub(v7, 18);
    end;

    if type(v6) ~= "string" then
        local v8 = tostring(v6);
        v6 = string.sub(v8, 22);
    end;

    local v9 = v5 == "Circular" and "Circ" or (v5 == "Exponential" and "Expo" or v5);

    if v9 == "Linear" then
        return p2;
    end;

    local v10 = u1[v9 .. v6];

    if v10 then
        return v10(p2);
    end;

    error("Tween function \'" .. v9 .. "." .. v6 .. "\' doesn\'t exist.");
end;

function u1.QuadIn(p11) -- Line: 28
    return p11 * p11;
end;

function u1.QuadOut(p12) -- Line: 32
    return p12 * (2 - p12);
end;

function u1.QuadInOut(p13) -- Line: 36
    local v14 = p13 * 2;

    if v14 < 1 then
        return v14 * v14 * 0.5;
    end;

    return ((v14 - 1) * (v14 - 3) - 1) * -0.5;
end;

function u1.QuadOutIn(p15) -- Line: 44
    -- upvalues: u1 (copy)
    if p15 < 0.5 then
        return u1.QuadOut(p15 * 2);
    end;

    return u1.QuadIn(p15 * 2 - 1);
end;

function u1.CubicIn(p16) -- Line: 50
    return p16 * p16 * p16;
end;

function u1.CubicOut(p17) -- Line: 54
    local v18 = p17 - 1;

    return v18 * v18 * v18 + 1;
end;

function u1.CubicInOut(p19) -- Line: 59
    local v20 = p19 * 2;

    if v20 < 1 then
        return v20 * v20 * v20 * 0.5;
    end;

    local v21 = v20 - 2;

    return (v21 * v21 * v21 + 2) * 0.5;
end;

function u1.CubicOutIn(p22) -- Line: 68
    -- upvalues: u1 (copy)
    if p22 < 0.5 then
        return u1.CubicOut(p22 * 2);
    end;

    return u1.CubicIn(p22 * 2 - 1);
end;

function u1.QuartIn(p23) -- Line: 74
    return p23 * p23 * p23 * p23;
end;

function u1.QuartOut(p24) -- Line: 78
    local v25 = p24 - 1;

    return 1 - v25 * v25 * v25 * v25;
end;

function u1.QuartInOut(p26) -- Line: 83
    local v27 = p26 * 2;

    if v27 < 1 then
        return v27 * v27 * v27 * v27 * 0.5;
    end;

    local v28 = v27 - 2;

    return (2 - v28 * v28 * v28 * v28) * 0.5;
end;

function u1.QuartOutIn(p29) -- Line: 92
    -- upvalues: u1 (copy)
    if p29 < 0.5 then
        return u1.QuartOut(p29 * 2);
    end;

    return u1.QuartIn(p29 * 2 - 1);
end;

function u1.QuintIn(p30) -- Line: 98
    return p30 * p30 * p30 * p30 * p30;
end;

function u1.QuintOut(p31) -- Line: 102
    local v32 = p31 - 1;

    return v32 * v32 * v32 * v32 * v32 + 1;
end;

function u1.QuintInOut(p33) -- Line: 107
    local v34 = p33 * 2;

    if v34 < 1 then
        return v34 * v34 * v34 * v34 * v34 * 0.5;
    end;

    local v35 = v34 - 2;

    return (v35 * v35 * v35 * v35 * v35 + 2) * 0.5;
end;

function u1.QuintOutIn(p36) -- Line: 116
    -- upvalues: u1 (copy)
    if p36 < 0.5 then
        return u1.QuintOut(p36 * 2);
    end;

    return u1.QuintIn(p36 * 2 - 1);
end;

function u1.SineIn(p37) -- Line: 122
    return 1 - math.cos(p37 * 1.5707963267948966);
end;

function u1.SineOut(p38) -- Line: 126
    return math.sin(p38 * 1.5707963267948966);
end;

function u1.SineInOut(p39) -- Line: 130
    return (1 - math.cos(3.141592653589793 * p39)) * 0.5;
end;

function u1.SineOutIn(p40) -- Line: 134
    -- upvalues: u1 (copy)
    if p40 < 0.5 then
        return u1.SineOut(p40 * 2);
    end;

    return u1.SineIn(p40 * 2);
end;

function u1.ExpoIn(p41) -- Line: 140
    return p41 == 0 and 0 or math.pow(2, (p41 - 1) * 10) - 0.001;
end;

function u1.ExpoOut(p42) -- Line: 147
    return p42 == 1 and 1 or (1 - math.pow(2, p42 * -10)) * 1.001;
end;

function u1.ExpoInOut(p43) -- Line: 154
    if p43 == 0 then
        return 0;
    end;

    if p43 == 1 then
        return 1;
    end;

    local v44 = p43 * 2;

    if v44 < 1 then
        return math.pow(2, (v44 - 1) * 10) * 0.5 - 0.0005;
    end;

    return (2 - math.pow(2, (v44 - 1) * -10)) * 0.50025;
end;

function u1.ExpoOutIn(p45) -- Line: 169
    -- upvalues: u1 (copy)
    if p45 < 0.5 then
        return u1.ExpoOut(p45 * 2);
    end;

    return u1.ExpoIn(p45 * 2 - 1);
end;

function u1.CircIn(p46) -- Line: 175
    return 1 - math.sqrt(1 - p46 * p46);
end;

function u1.CircOut(p47) -- Line: 179
    local v48 = p47 - 1;

    return math.sqrt(1 - v48 * v48);
end;

function u1.CircInOut(p49) -- Line: 184
    local v50 = p49 * 2;

    if v50 < 1 then
        return (1 - math.sqrt(1 - v50 * v50)) * 0.5;
    end;

    local v51 = v50 - 2;

    return (math.sqrt(1 - v51 * v51) + 1) * 0.5;
end;

function u1.CircOutIn(p52) -- Line: 193
    -- upvalues: u1 (copy)
    if p52 < 0.5 then
        return u1.CircOut(p52 * 2);
    end;

    return u1.CircIn(p52 * 2 - 1);
end;

function u1.ElasticIn(p53) -- Line: 199
    if p53 == 0 then
        return 0;
    end;

    if p53 == 1 then
        return 1;
    end;

    local v54 = p53 - 1;

    return -(math.pow(2, v54 * 10) * 1 * math.sin((v54 - 0.075) * 6.283185307179586 / 0.3));
end;

function u1.ElasticOut(p55) -- Line: 213
    return p55 == 0 and 0 or (p55 == 1 and 1 or math.pow(2, p55 * -10) * 1 * math.sin((p55 - 0.075) * 6.283185307179586 / 0.3) + 1);
end;

function u1.ElasticInOut(p56) -- Line: 225
    if p56 == 0 then
        return 0;
    end;

    local v57 = p56 * 2;

    if v57 == 2 then
        return 1;
    end;

    if v57 < 1 then
        local v58 = v57 - 1;

        return math.pow(2, v58 * 10) * 1 * math.sin((v58 - 0.1125) * 6.283185307179586 / 0.45) * -0.5;
    end;

    local v59 = v57 - 1;

    return math.pow(2, v59 * -10) * 1 * math.sin((v59 - 0.1125) * 6.283185307179586 / 0.45) * 0.5 + 1;
end;

function u1.ElasticOutIn(p60) -- Line: 244
    -- upvalues: u1 (copy)
    if p60 < 0.5 then
        return u1.ElasticOut(p60 * 2);
    end;

    return u1.ElasticIn(p60 * 2 - 1);
end;

function u1.BackIn(p61) -- Line: 250
    return p61 * p61 * (p61 * 2.70158 - 1.70158);
end;

function u1.BackOut(p62) -- Line: 254
    local v63 = p62 - 1;

    return v63 * v63 * (v63 * 2.70158 + 1.70158) + 1;
end;

function u1.BackInOut(p64) -- Line: 259
    local v65 = p64 * 2;

    if v65 < 1 then
        return v65 * v65 * (3.5949095 * v65 - 2.5949095) * 0.5;
    end;

    local v66 = v65 - 2;

    return (v66 * v66 * (3.5949095 * v66 + 2.5949095) + 2) * 0.5;
end;

function u1.BackOutIn(p67) -- Line: 269
    -- upvalues: u1 (copy)
    if p67 < 0.5 then
        return u1.BackOut(p67 * 2);
    end;

    return u1.BackIn(p67 * 2 - 1);
end;

function u1.BounceOut(p68) -- Line: 275
    if p68 < 0.36363636363636365 then
        return p68 * 7.5625 * p68;
    end;

    if p68 < 0.7272727272727273 then
        local v69 = p68 - 0.5454545454545454;

        return v69 * 7.5625 * v69 + 0.75;
    end;

    if p68 < 0.9090909090909091 then
        local v70 = p68 - 0.8181818181818182;

        return v70 * 7.5625 * v70 + 0.9375;
    end;

    local v71 = p68 - 0.9545454545454546;

    return v71 * 7.5625 * v71 + 0.984375;
end;

function u1.BounceIn(p72) -- Line: 291
    -- upvalues: u1 (copy)
    return 1 - u1.BounceOut(1 - p72);
end;

function u1.BounceInOut(p73) -- Line: 295
    -- upvalues: u1 (copy)
    if p73 < 0.5 then
        return u1.BounceIn(p73 * 2) * 0.5;
    end;

    return u1.BounceOut(p73 * 2 - 1) * 0.5 + 0.5;
end;

function u1.BounceOutIn(p74) -- Line: 302
    -- upvalues: u1 (copy)
    if p74 < 0.5 then
        return u1.BounceOut(p74 * 2);
    end;

    return u1.BounceIn(p74 * 2 - 1);
end;

return Get;