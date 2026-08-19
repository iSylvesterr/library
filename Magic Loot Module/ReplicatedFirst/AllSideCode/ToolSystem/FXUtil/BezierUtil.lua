-- Decompiled with Potassium's decompiler.

local u58 = {
    Lerp = function(p1, p2, p3) -- Line: 23, Name: Lerp
        if typeof(p1) ~= "Vector3" then
            p1 = p1.Position;
        end;

        if typeof(p2) ~= "Vector3" then
            p2 = p2.Position;
        end;

        return p1 + (p2 - p1) * p3;
    end,

    GetFrameByDistance = function(p4, p5, p6) -- Line: 43, Name: GetFrameByDistance
        if typeof(p4) ~= "Vector3" then
            p4 = p4.Position;
        end;

        if typeof(p5) ~= "Vector3" then
            p5 = p5.Position;
        end;

        return math.round((p4 - p5).Magnitude * 2 / (p6 and 1 + p6 or 1));
    end,

    GetMotionTime = function(p7, p8) -- Line: 67, Name: GetMotionTime
        return 0 + task.wait(1 / p8) * p7;
    end,

    GetMiddlePosition = function(p9, p10, p11, p12) -- Line: 82, Name: GetMiddlePosition
        if typeof(p9) ~= "Vector3" then
            p9 = p9.Position;
        end;

        if typeof(p10) ~= "Vector3" then
            p10 = p10.Position;
        end;

        local v13 = (p9 - p10) * 0.5;
        local v14 = p9 - v13;

        return v14 + (CFrame.new(v14, p10) * CFrame.Angles(0, 0, (math.rad(p11 or 0)))).UpVector * (v13.Magnitude * (p12 or 1));
    end,

    GetMiddlePosition_OLD = function(p15, p16, p17, p18, p19) -- Line: 123, Name: GetMiddlePosition_OLD
        if typeof(p15) ~= "Vector3" then
            p15 = p15.Position;
        end;

        if typeof(p16) ~= "Vector3" then
            p16 = p16.Position;
        end;

        local v20 = p15 - (p15 - p16) * (p19 or 0.5);

        return v20 + (CFrame.new(v20, p16) * CFrame.Angles(0, 0, (math.rad(p17 or 0)))).UpVector * (p18 or 1);
    end,

    Get2MiddlePosition = function(p21, p22, p23, p24, p25, p26, p27, p28) -- Line: 159, Name: Get2MiddlePosition
        if typeof(p21) ~= "Vector3" then
            p21 = p21.Position;
        end;

        if typeof(p22) ~= "Vector3" then
            p22 = p22.Position;
        end;

        local function GetResultPosition(p29, p30, p31, p32, p33) -- Line: 176
            local v34 = p29 - (p29 - p30) * p33;

            return v34 + (CFrame.new(v34, p30) * CFrame.Angles(0, 0, (math.rad(p31)))).UpVector * p32;
        end;

        local v35 = p21 - (p21 - p22) * (p25 or 0.5);
        local v36 = v35 + (CFrame.new(v35, p22) * CFrame.Angles(0, 0, (math.rad(p23 or 0)))).UpVector * (p24 or 1);
        local v37 = p21 - (p21 - p22) * (p28 or 0.5);

        return v36, v37 + (CFrame.new(v37, p22) * CFrame.Angles(0, 0, (math.rad(p26 or 0)))).UpVector * (p27 or 1);
    end,

    Get2SquarePosition = function(p38, p39, p40, p41, p42, p43) -- Line: 204, Name: Get2SquarePosition
        if typeof(p38) ~= "Vector3" then
            p38 = p38.Position;
        end;

        if typeof(p39) ~= "Vector3" then
            p39 = p39.Position;
        end;

        local function _(p44, p45, p46, p47, p48) -- Line: 219
            local v49 = (p44 - p45) * p48;
            local v50 = p44 - v49;

            return v50 + (CFrame.new(v50, p45) * CFrame.Angles(0, 0, (math.rad(p46)))).UpVector * (v49.Magnitude * p47);
        end;

        local v51 = (p38 - p39) * 0.2;
        local v52 = p38 - v51;
        local v53 = v52 + (CFrame.new(v52, p39) * CFrame.Angles(0, 0, (math.rad(p40 or 0)))).UpVector * (v51.Magnitude * (p41 and 1 + p41 or 1));
        local v54 = (p38 - p39) * 0.8;
        local v55 = p38 - v54;

        return v53, v55 + (CFrame.new(v55, p39) * CFrame.Angles(0, 0, (math.rad(p42 or 0)))).UpVector * (v54.Magnitude * (p43 and 1 + p43 or 1));
    end,

    ApproxArcLength = function(p56) -- Line: 241, Name: ApproxArcLength
        local v57 = 0;

        for i = 1, #p56 - 1 do
            v57 = v57 + (p56[i + 1] - p56[i]).Magnitude;
        end;

        return v57;
    end
};

function u58.EstimateFlightTime(p59, p60, p61) -- Line: 257
    -- upvalues: u58 (copy)
    local v62 = math.max(p60, 0.001);
    local v63 = u58.ApproxArcLength(p59) / v62;

    return math.min(v63, p61);
end;

return u58;