-- Decompiled with Potassium's decompiler.

local function clamp(p1, p2, p3) -- Line: 5
    if p1 < p2 then
        return p2;
    end;

    if p3 < p1 then
        return p3;
    end;

    return p1;
end;

local function lerp(p4, p5, p6) -- Line: 6
    return p4 + (p5 - p4) * p6;
end;

local u11 = {
    GenerateSeed = function(p7) -- Line: 11, Name: GenerateSeed
        local v8 = {};

        if not p7 or typeof(p7) ~= "NumberSequence" then
            return v8;
        end;

        local Keypoints = p7.Keypoints;
        local v9 = math.random();
        local v10 = math.random() >= 0.5;

        for i = 1, #Keypoints do
            if Keypoints[i].Envelope > 0 then
                if v10 then
                    v8[i] = v9 * Keypoints[i].Envelope;
                else
                    v8[i] = -v9 * Keypoints[i].Envelope;
                end;
            end;
        end;

        return v8;
    end
};

function u11.GenerateSeeds(p12, p13) -- Line: 30
    -- upvalues: u11 (copy)
    local v14 = {};

    for i = 1, p13 do
        v14[i] = u11.GenerateSeed(p12);
    end;

    return v14;
end;

function u11.QueryPointsWithTime(p15, p16, p17) -- Line: 39
    local v18 = math.clamp(p15, 0, 1);
    local Keypoints = p16.Keypoints;
    local v19 = #Keypoints;

    if v19 == 1 then
        return Keypoints[1].Value + (p17[1] or 0);
    end;

    local v20 = 1;

    while v20 < v19 - 1 do
        local v21 = (v20 + v19) // 2;

        if Keypoints[v21].Time <= v18 then
            v20 = v21;
            v21 = v19;
        end;

        v19 = v21;
    end;

    local v22 = Keypoints[v20];
    local v23 = Keypoints[v20 + 1];
    local v24 = v23.Time - v22.Time;
    local v25 = v22.Value + (p17[v20] or 0);

    return v25 + (v23.Value + (p17[v20 + 1] or 0) - v25) * (v24 > 0 and ((v18 - v22.Time) / v24 or 0) or 0);
end;

function u11.QueryColorPointWithTime(p26, p27) -- Line: 61
    local v28 = math.clamp(p26, 0, 1);
    local Keypoints = p27.Keypoints;
    local v29 = #Keypoints;

    if v29 == 0 then
        return Color3.new(1, 1, 1);
    end;

    if v29 == 1 then
        return Keypoints[1].Value;
    end;

    if v28 <= Keypoints[1].Time then
        return Keypoints[1].Value;
    end;

    local v30 = 1;

    while v30 < v29 - 1 do
        local v31 = (v30 + v29) // 2;

        if Keypoints[v31].Time <= v28 then
            v30 = v31;
            v31 = v29;
        end;

        v29 = v31;
    end;

    local v32 = Keypoints[v30];
    local v33 = Keypoints[v30 + 1];
    local v34 = v33.Time - v32.Time;

    return v32.Value:Lerp(v33.Value, v34 > 0 and ((v28 - v32.Time) / v34 or 0) or 0);
end;

function u11.IntegrateUpTo(p35, p36, p37) -- Line: 82
    local v38 = math.clamp(p35, 0, 1);
    local Keypoints = p36.Keypoints;
    local v39 = #Keypoints;

    if v39 == 0 then
        return 0;
    end;

    if v39 == 1 then
        return (Keypoints[1].Value + (p37[1] or 0)) * v38;
    end;

    local v40 = 0;

    for i = 1, v39 - 1 do
        local v41 = Keypoints[i];
        local v42 = Keypoints[i + 1];

        if v38 <= v41.Time then
            break;
        end;

        local v43 = v41.Value + (p37[i] or 0);
        local v44 = v42.Value + (p37[i + 1] or 0);
        local v45 = math.min(v38, v42.Time);
        local v46 = v42.Time - v41.Time;
        v40 = v40 + (v43 + (v43 + (v44 - v43) * (v46 > 0 and (v45 - v41.Time) / v46 or 0))) / 2 * (v45 - v41.Time);

        if v38 <= v42.Time then
            break;
        end;
    end;

    return v40;
end;

function u11.IsStatic(p47) -- Line: 110
    if not p47 then
        return true;
    end;

    local Keypoints = p47.Keypoints;

    if #Keypoints == 1 then
        return Keypoints[1].Envelope == 0;
    end;

    local Value = Keypoints[1].Value;

    if Keypoints[1].Envelope ~= 0 then
        return false;
    end;

    for i = 2, #Keypoints do
        if Keypoints[i].Value ~= Value or Keypoints[i].Envelope ~= 0 then
            return false;
        end;
    end;

    return true;
end;

function u11.GetStaticValue(p48, p49) -- Line: 123
    if p48 and #p48.Keypoints ~= 0 then
        return p48.Keypoints[1].Value;
    end;

    return p49;
end;

local function _mergeSequenceTimes(p50, p51) -- Line: 131
    local v52 = {};
    local v53 = {};

    for _, v in ipairs({ p50, p51 }) do
        for _, v2 in ipairs(v.Keypoints) do
            if not v52[v2.Time] then
                v52[v2.Time] = true;
                table.insert(v53, v2.Time);
            end;
        end;
    end;

    table.sort(v53);

    return v53;
end;

function u11.BlendGraphWithTime(p54, p55, p56, p57) -- Line: 146
    -- upvalues: _mergeSequenceTimes (copy), u11 (copy)
    local v58 = p57 or 1;
    local v59 = _mergeSequenceTimes(p54, p55);
    local v60 = u11.QueryPointsWithTime(v58 < 0 and 0 or (v58 > 1 and 1 or v58), p56, {});
    local v61 = {};

    for _, v in ipairs(v59) do
        local v62 = u11.QueryPointsWithTime(v, p54, {});
        local v63 = u11.QueryPointsWithTime(v, p55, {});
        table.insert(v61, NumberSequenceKeypoint.new(v, v62 + (v63 - v62) * v60));
    end;

    return NumberSequence.new(v61);
end;

function u11.BlendColorGraphWithTime(p64, p65, p66, p67) -- Line: 160
    -- upvalues: _mergeSequenceTimes (copy), u11 (copy)
    local v68 = p67 or 1;
    local v69 = _mergeSequenceTimes(p64, p65);
    local v70 = u11.QueryPointsWithTime(v68 < 0 and 0 or (v68 > 1 and 1 or v68), p66, {});
    local v71 = {};

    for _, v in ipairs(v69) do
        local v72 = u11.QueryColorPointWithTime(v, p64);
        local v73 = u11.QueryColorPointWithTime(v, p65);
        table.insert(v71, ColorSequenceKeypoint.new(v, v72:Lerp(v73, v70)));
    end;

    return ColorSequence.new(v71);
end;

function u11.LerpGraph(p74, p75, p76) -- Line: 175
    -- upvalues: _mergeSequenceTimes (copy), u11 (copy)
    local v77 = p76 or 0;
    local v78 = v77 < 0 and 0 or (v77 > 1 and 1 or v77);
    local v79 = _mergeSequenceTimes(p74, p75);
    local v80 = {};

    for _, v in ipairs(v79) do
        local v81 = u11.QueryPointsWithTime(v, p74, {});
        local v82 = u11.QueryPointsWithTime(v, p75, {});
        table.insert(v80, NumberSequenceKeypoint.new(v, v81 + (v82 - v81) * v78));
    end;

    return NumberSequence.new(v80);
end;

function u11.LerpColorGraph(p83, p84, p85) -- Line: 187
    -- upvalues: _mergeSequenceTimes (copy), u11 (copy)
    local v86 = p85 or 0;
    local v87 = v86 < 0 and 0 or (v86 > 1 and 1 or v86);
    local v88 = _mergeSequenceTimes(p83, p84);
    local v89 = {};

    for _, v in ipairs(v88) do
        local v90 = u11.QueryColorPointWithTime(v, p83);
        local v91 = u11.QueryColorPointWithTime(v, p84);
        table.insert(v89, ColorSequenceKeypoint.new(v, v90:Lerp(v91, v87)));
    end;

    return ColorSequence.new(v89);
end;

function u11.PrecomputeMergedTimes(p92, p93) -- Line: 200
    -- upvalues: _mergeSequenceTimes (copy)
    return _mergeSequenceTimes(p92, p93);
end;

function u11.PrecomputeMergedColorTimes(p94, p95) -- Line: 204
    -- upvalues: _mergeSequenceTimes (copy)
    return _mergeSequenceTimes(p94, p95);
end;

function u11.LerpGraphFast(p96, p97, p98, p99) -- Line: 209
    -- upvalues: u11 (copy)
    local v100 = p98 or 0;
    local v101 = v100 < 0 and 0 or (v100 > 1 and 1 or v100);

    if v101 == 0 then
        return p96;
    end;

    if v101 == 1 then
        return p97;
    end;

    local v102 = {};

    for _, v in ipairs(p99) do
        local v103 = u11.QueryPointsWithTime(v, p96, {});
        local v104 = u11.QueryPointsWithTime(v, p97, {});
        table.insert(v102, NumberSequenceKeypoint.new(v, v103 + (v104 - v103) * v101));
    end;

    return NumberSequence.new(v102);
end;

function u11.LerpColorGraphFast(p105, p106, p107, p108) -- Line: 222
    -- upvalues: u11 (copy)
    local v109 = p107 or 0;
    local v110 = v109 < 0 and 0 or (v109 > 1 and 1 or v109);

    if v110 == 0 then
        return p105;
    end;

    if v110 == 1 then
        return p106;
    end;

    local v111 = {};

    for _, v in ipairs(p108) do
        local v112 = u11.QueryColorPointWithTime(v, p105);
        local v113 = u11.QueryColorPointWithTime(v, p106);
        table.insert(v111, ColorSequenceKeypoint.new(v, v112:Lerp(v113, v110)));
    end;

    return ColorSequence.new(v111);
end;

function u11.CollectGraphStates(p114) -- Line: 236
    local v115 = {};
    local v116 = {};

    if not p114 then
        return v115, v116;
    end;

    for _, child in pairs(p114:GetChildren()) do
        if child:IsA("Configuration") then
            local v117 = child:GetAttribute("Time");

            if v117 == nil then
                local v118 = tonumber(string.match(child.Name, "%d+"));
                v117 = v118 and v118 - 1 or 0;
            end;

            local v119 = child:GetAttribute("Transparency");

            if v119 and typeof(v119) == "NumberSequence" then
                table.insert(v115, {
                    Time = v117,
                    Graph = v119
                });
            end;

            local v120 = child:GetAttribute("Color");

            if v120 and typeof(v120) == "ColorSequence" then
                table.insert(v116, {
                    Time = v117,
                    Graph = v120
                });
            end;
        end;
    end;

    table.sort(v115, function(p121, p122) -- Line: 257
        return p121.Time < p122.Time;
    end);
    table.sort(v116, function(p123, p124) -- Line: 258
        return p123.Time < p124.Time;
    end);

    for _, v in ipairs({ v115, v116 }) do
        if #v > 1 and v[#v].Time > 1 then
            local Time = v[#v].Time;

            if Time > 0 then
                for _, v2 in ipairs(v) do
                    v2.Time = v2.Time / Time;
                end;
            end;
        end;
    end;

    return v115, v116;
end;

function u11.InitialEffectiveElapsed(p125, p126, p127) -- Line: 272
    -- upvalues: u11 (copy)
    return p125 and typeof(p125) == "NumberSequence" and (u11.QueryPointsWithTime(0, p125, p126 or {}) < 0 and p127 and p127 or 0) or 0;
end;

function u11.ScaleSequence(p128, p129) -- Line: 280
    if not p128 or typeof(p128) ~= "NumberSequence" then
        return p128;
    end;

    local Keypoints = p128.Keypoints;
    local v130 = math.abs(p129);
    local v131 = {};

    for _, v in ipairs(Keypoints) do
        table.insert(v131, NumberSequenceKeypoint.new(v.Time, v.Value * p129, v.Envelope * v130));
    end;

    return NumberSequence.new(v131);
end;

return u11;