-- Decompiled with Potassium's decompiler.

local function SafeUnit(p1) -- Line: 2
    return p1.Magnitude == 0 and Vector3.new(0, 0, 0) or p1.Unit;
end;

local function solve(p2, p3, p4, p5) -- Line: 10
    local v6 = (p5 - p2):Dot(p3);
    local v7 = math.clamp(v6, -p4, p4);

    return p2 + p3 * v7, v7;
end;

local function ProjectOnPlane(p8, p9, p10) -- Line: 17
    return p10 - (p10 - p8):Dot(p9) * p9;
end;

local function ClosestPointFunc(p11, p12, p13) -- Line: 25
    local u14 = (p12.Y < p12.Z and p12.Y or p12.Z) * 0.5;
    local v15 = p12.X * 0.5;
    local Position = p11.Position;
    local RightVector = p11.RightVector;
    local v16 = (p13 - Position):Dot(RightVector);
    local v17 = math.clamp(v16, -v15, v15);
    local v18 = Position + RightVector * v17;
    local v19 = p11.Position + -p11.RightVector * v15;
    local v20 = p11.Position + p11.RightVector * v15;
    local v21 = -p11.RightVector;
    local RightVector2 = p11.RightVector;
    local v22 = p13 - (p13 - v19):Dot(v21) * v21;
    local v23 = p13 - (p13 - v20):Dot(RightVector2) * RightVector2;

    local function GetFinalProj(p24, p25) -- Line: 39
        -- upvalues: u14 (copy)
        local v26 = p24 - p25;
        local Magnitude = (p24 - p25).Magnitude;

        return p25 + (v26.Magnitude == 0 and Vector3.new(0, 0, 0) or v26.Unit) * (Magnitude < u14 and Magnitude and Magnitude or u14);
    end;

    local v27 = v22 - v19;
    local Magnitude = (v22 - v19).Magnitude;
    local v28;

    if Magnitude < u14 then
        v28 = Magnitude or u14;
    else
        v28 = u14;
    end;

    local v29 = v19 + (v27.Magnitude == 0 and Vector3.new(0, 0, 0) or v27.Unit) * v28;
    local v30 = v23 - v20;
    local Magnitude2 = (v23 - v20).Magnitude;
    local v31;

    if Magnitude2 < u14 then
        v31 = Magnitude2 or u14;
    else
        v31 = u14;
    end;

    local v32 = v20 + (v30.Magnitude == 0 and Vector3.new(0, 0, 0) or v30.Unit) * v31;
    local v33 = p13 - v18;
    local v34 = v33.Magnitude == 0 and Vector3.new(0, 0, 0) or v33.Unit;
    local v35 = (v18 - p13).Magnitude <= u14;
    local v36 = v18 + v34 * u14;
    local Magnitude3 = (v32 - p13).Magnitude;
    local Magnitude4 = (v29 - p13).Magnitude;
    local v37 = math.min(Magnitude3, Magnitude4, (v36 - p13).Magnitude);

    if v17 == v15 or v37 == Magnitude3 then
        local v38 = p13 - v32;

        return (v38.Magnitude == 0 and Vector3.new(0, 0, 0) or v38.Unit):Dot(RightVector2) < 0, v32, RightVector2;
    end;

    if v17 ~= -v15 and v37 ~= Magnitude4 then
        return v35, v36, v34;
    end;

    local v39 = p13 - v29;

    return (v39.Magnitude == 0 and Vector3.new(0, 0, 0) or v39.Unit):Dot(v21) < 0, v29, v21;
end;

return function(p40, p41, p42, p43) -- Line: 70
    -- upvalues: ClosestPointFunc (copy)
    local v44, v45, v46 = ClosestPointFunc(p40, p41, p42);

    if v44 then
        return v44, v45, v46;
    end;

    return (v45 - p42).Magnitude < p43, v45, v46;
end;