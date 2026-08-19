-- Decompiled with Potassium's decompiler.

require(script.Parent.Types);

local function SampleCurve(p1, p2, p3, p4) -- Line: 20
    return ((p1 * p4 + p2) * p4 + p3) * p4;
end;

local function SampleDerivative(p5, p6, p7, p8) -- Line: 24
    return (p5 * 3 * p8 + p6 * 2) * p8 + p7;
end;

local function SolveCubicBezier(p9, p10, p11, p12, p13) -- Line: 28
    if p13 <= 0 then
        return 0;
    end;

    if p13 >= 1 then
        return 1;
    end;

    if p9 == p10 and p11 == p12 then
        return p13;
    end;

    local v14 = p9 * 3;
    local v15 = (p11 - p9) * 3 - v14;
    local v16 = 1 - v14 - v15;
    local v17 = p10 * 3;
    local v18 = (p12 - p10) * 3 - v17;
    local v19 = 1 - v17 - v18;
    local v20 = p13;

    for _ = 1, 8 do
        local v21 = ((v16 * p13 + v15) * p13 + v14) * p13 - v20;

        if math.abs(v21) < 1e-7 then
            return ((v19 * p13 + v18) * p13 + v17) * p13;
        end;

        local v22 = (v16 * 3 * p13 + v15 * 2) * p13 + v14;

        if math.abs(v22) < 1e-7 then
            break;
        end;

        p13 = p13 - v21 / v22;
    end;

    local v23 = v20;
    local v24 = 0;
    local v25 = 1;

    for _ = 1, 16 do
        local v26 = ((v16 * v20 + v15) * v20 + v14) * v20 - v23;

        if math.abs(v26) < 1e-7 then
            break;
        end;

        if v26 > 0 then
            v25 = v20;
            v20 = v24;
        end;

        v24 = v20;
        v20 = (v20 + v25) * 0.5;
    end;

    return ((v19 * v20 + v18) * v20 + v17) * v20;
end;

local function NormalizeHandle(p27, p28) -- Line: 70
    return type(p27) ~= "number" and (p27[p28 or 1] or 0) or p27;
end;

local function LerpScalar(p29, p30, p31) -- Line: 78
    return p29 + (p30 - p29) * p31;
end;

local function LerpArray(p32, p33, p34) -- Line: 82
    local v35 = table.create(#p32);

    for i = 1, #p32 do
        v35[i] = p32[i] + ((p33[i] or p32[i]) - p32[i]) * p34;
    end;

    return v35;
end;

local function LerpBezierShape(p36, p37, p38) -- Line: 90
    local v39 = table.create(#p36.v);
    local v40 = table.create(#p36.i);
    local v41 = table.create(#p36.o);

    for i = 1, #p36.v do
        local v42 = p36.v[i];
        local v43 = p37.v[i];
        local v44 = p36.i[i];
        local v45 = p37.i[i];
        local v46 = p36.o[i];
        local v47 = p37.o[i];
        v39[i] = { v42[1] + (v43[1] - v42[1]) * p38, v42[2] + (v43[2] - v42[2]) * p38 };
        v40[i] = { v44[1] + (v45[1] - v44[1]) * p38, v44[2] + (v45[2] - v44[2]) * p38 };
        v41[i] = { v46[1] + (v47[1] - v46[1]) * p38, v46[2] + (v47[2] - v46[2]) * p38 };
    end;

    return {
        v = v39,
        i = v40,
        o = v41,
        c = p36.c
    };
end;

local function FindKeyframes(p48, p49) -- Line: 107
    local v50 = #p48;

    if v50 == 0 then
        return nil, nil, 0;
    end;

    if v50 == 1 then
        return p48[1], nil, 0;
    end;

    local v51 = p48[1];

    if p49 <= v51.t then
        return v51, nil, 0;
    end;

    for i = 2, v50 do
        local v52 = p48[i];

        if p49 < v52.t then
            return p48[i - 1], v52, i - 1;
        end;
    end;

    return p48[v50], nil, v50;
end;

local function ExtractValue(p53) -- Line: 127
    if p53 == nil then
        return nil;
    end;

    if #p53 == 0 then
        return nil;
    end;

    if type(p53[1]) == "table" then
        return p53[1];
    end;

    return p53;
end;

local function Evaluate(p54, p55) -- Line: 139
    -- upvalues: FindKeyframes (copy), SolveCubicBezier (copy), LerpArray (copy), LerpBezierShape (copy)
    local a = p54.a;
    local k = p54.k;

    if a == nil or a == 0 then
        if type(k) == "number" then
            return k;
        end;

        if type(k) ~= "table" then
            return nil;
        end;

        if #k > 0 and type(k[1]) == "table" then
            return k[1];
        end;

        return k;
    end;

    local v56, v57, _ = FindKeyframes(k, p55);

    if v56 == nil then
        return nil;
    end;

    if v57 == nil then
        local s = v56.s;

        if s == nil or #s == 0 then
            s = nil;
        elseif type(s[1]) == "table" then
            s = s[1];
        end;

        if s ~= nil then
            return s;
        end;

        local e = v56.e;

        if e == nil then
            return nil;
        end;

        if #e == 0 then
            return nil;
        end;

        if type(e[1]) == "table" then
            return e[1];
        end;

        return e;
    end;

    if v56.h == 1 then
        local s = v56.s;

        if s == nil then
            return nil;
        end;

        if #s == 0 then
            return nil;
        end;

        if type(s[1]) == "table" then
            return s[1];
        end;

        return s;
    end;

    local t = v56.t;
    local v58 = v57.t - t;

    if v58 <= 0 then
        local s = v56.s;

        if s == nil then
            return nil;
        end;

        if #s == 0 then
            return nil;
        end;

        if type(s[1]) == "table" then
            return s[1];
        end;

        return s;
    end;

    local v59 = math.clamp((p55 - t) / v58, 0, 1);
    local s = v56.s;

    if s == nil or #s == 0 then
        s = nil;
    elseif type(s[1]) == "table" then
        s = s[1];
    end;

    local s2 = v57.s;

    if s2 == nil or #s2 == 0 then
        s2 = nil;
    elseif type(s2[1]) == "table" then
        s2 = s2[1];
    end;

    if not s2 then
        s2 = v56.e;

        if s2 == nil or #s2 == 0 then
            s2 = nil;
        elseif type(s2[1]) == "table" then
            s2 = s2[1];
        end;
    end;

    if s == nil or s2 == nil then
        return s or s2;
    end;

    local o = v56.o;
    local i = v56.i;

    if o and i then
        local x = o.x;
        local v60 = type(x) ~= "number" and (x[1] or 0) or x;
        local y = o.y;
        local v61 = type(y) ~= "number" and (y[1] or 0) or y;
        local x2 = i.x;
        local v62 = type(x2) ~= "number" and (x2[1] or 0) or x2;
        local y2 = i.y;
        v59 = SolveCubicBezier(v60, v61, v62, type(y2) ~= "number" and (y2[1] or 0) or y2, v59);
    end;

    if type(s) == "number" then
        return s + (s2 - s) * v59;
    end;

    if type(s) ~= "table" then
        return s;
    end;

    if #s > 0 and type(s[1]) == "number" then
        return LerpArray(s, s2, v59);
    end;

    return LerpBezierShape(s, s2, v59);
end;

return table.freeze({
    SolveCubicBezier = SolveCubicBezier,
    Evaluate = Evaluate,

    EvaluateScalar = function(p63, p64) -- Line: 212, Name: EvaluateScalar
        -- upvalues: Evaluate (copy)
        if p63 == nil then
            return p64;
        end;

        local v65 = Evaluate(p63, 0);

        if v65 == nil then
            return p64;
        end;

        if type(v65) == "number" then
            return v65;
        end;

        if type(v65) == "table" then
            return v65[1] or p64;
        end;

        return p64;
    end,

    EvaluateScalarAtFrame = function(p66, p67, p68) -- Line: 221, Name: EvaluateScalarAtFrame
        -- upvalues: Evaluate (copy)
        if p66 == nil then
            return p68;
        end;

        local v69 = Evaluate(p66, p67);

        if v69 == nil then
            return p68;
        end;

        if type(v69) == "number" then
            return v69;
        end;

        if type(v69) == "table" then
            return v69[1] or p68;
        end;

        return p68;
    end,

    EvaluateVector = function(p70, p71, p72) -- Line: 230, Name: EvaluateVector
        -- upvalues: Evaluate (copy)
        if p70 == nil then
            return p72;
        end;

        local v73 = Evaluate(p70, p71);

        if v73 == nil then
            return p72;
        end;

        if type(v73) == "table" then
            return v73;
        end;

        return type(v73) == "number" and { v73 } or p72;
    end,

    EvaluateColor = function(p74, p75) -- Line: 239, Name: EvaluateColor
        -- upvalues: Evaluate (copy)
        if p74 == nil then
            return Color3.new(1, 1, 1);
        end;

        local v76 = Evaluate(p74, p75);

        if v76 == nil then
            return Color3.new(1, 1, 1);
        end;

        if type(v76) == "table" then
            return Color3.new(v76[1] or 1, v76[2] or 1, v76[3] or 1);
        end;

        return Color3.new(1, 1, 1);
    end,

    EvaluateBezierShape = function(p77, p78) -- Line: 250, Name: EvaluateBezierShape
        -- upvalues: Evaluate (copy)
        if p77 == nil then
            return nil;
        end;

        local v79 = Evaluate(p77, p78);

        if v79 == nil then
            return nil;
        end;

        if type(v79) == "table" and (#v79 > 0 and type(v79[1]) ~= "number") then
            return v79;
        end;

        return nil;
    end,

    LerpArray = LerpArray
});